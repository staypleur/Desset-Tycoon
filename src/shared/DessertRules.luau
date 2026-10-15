-- Pure server rules. Quantities are logical counts; a Buy 1000 never builds 1000 models.
local Rules = {}
local Config=require(script.Parent.TycoonConfig)
local INTERVAL = Config.GiftInterval
-- Keep the original shiny key (1s) for existing saves; the second variant is 1s2.
function Rules.Key(tier, shiny, variant)
	return tostring(tier)..(shiny and (variant==2 and "s2" or "s") or "n")
end
function Rules.Decode(key)
	if type(key)~="string" then return nil end
	local tier,suffix=key:match("^(%d+)([ns]%d*)$")
	tier=tonumber(tier)
	if not tier or tier<1 or tier>30 or (suffix~="n" and suffix~="s" and suffix~="s2") then return nil end
	return tier,suffix~="n",suffix=="s2" and 2 or suffix=="s" and 1 or 0
end
function Rules.RollVariant(tier,shiny,rng)
	if not shiny then return 0 end
	return tier<=7 and (rng:NextNumber()<.5 and 1 or 2) or 1
end
function Rules.New(now)
	return {Version=2, Cash=0, Bag=0, Pending=0, CafeQueue=0, CafeLevel=0, Pets={["1n"]=1}, Index={["1n"]=true},
		TotalCashEarned=0,TotalMiniCollected=0,PlaySeconds=0,AFKStored=0,OfflineStored=0,LastSeen=now,
		NormalTokens=0, PerkTokens=0, PaidNormalTokens=0, PaidPerkTokens=0, NextGift=now+INTERVAL, AFKSeconds=0,
		Settings={Music=true, Effects=true, MusicVolume=.4, EffectsVolume=.5, HideOthers=false}, Receipts={}, HotUntil=0}
end
function Rules.NormalizeCafe(data)
	data.CafeQueue=math.max(0,data.CafeQueue or 0)
	data.CafeLevel=math.clamp(math.floor(data.CafeLevel or 0),0,Config.CafeMaxLevel)
	data.Version=2
	data.TotalCashEarned=math.max(0,data.TotalCashEarned or 0)
	data.TotalMiniCollected=math.max(0,data.TotalMiniCollected or 0)
	data.PlaySeconds=math.max(0,data.PlaySeconds or 0)
	data.AFKSeconds=math.max(0,data.AFKSeconds or 0)
	data.AFKStored=math.max(0,data.AFKStored or 0)
	data.OfflineStored=math.max(0,data.OfflineStored or 0)
	data.LastSeen=data.LastSeen or os.time()
	Rules.NormalizeSettings(data)
end
local function validVolume(value)
	return type(value)=="number" and value==value and value>-math.huge and value<math.huge
end
function Rules.NormalizeSettings(data)
	local settings=type(data.Settings)=="table" and data.Settings or {}
	for key,default in pairs({Music=.4,Effects=.5}) do
		local volume=settings[key.."Volume"]
		settings[key.."Volume"]=validVolume(volume) and math.clamp(volume,0,1) or (settings[key]==false and 0 or default)
		settings[key]=settings[key.."Volume"]>0
	end
	settings.HideOthers=settings.HideOthers==true
	data.Settings=settings
end
function Rules.UpdateSettings(data,changes)
	if type(changes)~="table" then return false end
	Rules.NormalizeSettings(data)
	for key,default in pairs({Music=.4,Effects=.5}) do
		local volume=changes[key.."Volume"]
		if validVolume(volume) then data.Settings[key.."Volume"]=math.clamp(volume,0,1)
		elseif volume==nil and type(changes[key])=="boolean" then
			data.Settings[key.."Volume"]=changes[key] and math.max(data.Settings[key.."Volume"],default) or 0
		end
		data.Settings[key]=data.Settings[key.."Volume"]>0
	end
	if type(changes.HideOthers)=="boolean" then data.Settings.HideOthers=changes.HideOthers end
	return true
end
-- Use exactly the same 60-slot ordering as the displayed producer models.
function Rules.ProductionPerSecond(data)
	local slots,value=0,0
	for tier=30,1,-1 do for variant=0,2 do
		local count=math.min(data.Pets[Rules.Key(tier,variant>0,variant)] or 0,Config.Capacity-slots)
		slots+=count; value+=count*3^(tier-1)
	end end
	return value/Config.ProductionInterval
end
function Rules.AccrueOffline(data,now,multiplier)
	local seconds=math.max(0,now-(data.LastSeen or now))
	local earned=Rules.ProductionPerSecond(data)*seconds*.5*(multiplier or 1)
	data.OfflineStored+=earned; data.LastSeen=math.max(data.LastSeen or now,now)
	return earned
end
-- Capacity is queued units per SECOND; no percentage of the remaining queue.
function Rules.CafeRate(data) return Config.CafeBaseRate*Config.CafeRateGrowth^data.CafeLevel end
function Rules.CafeUpgradeCost(data) return Config.CafeUpgradeBaseCost*Config.CafeUpgradeCostGrowth^data.CafeLevel end
-- Companion selection is independent of the producing desserts on the plot.
function Rules.ToggleEquip(data,key)
	if not Rules.Decode(key) or not data.Index[key] then return false end
	data.Equipped=data.Equipped~=key and key or nil
	return true
end
function Rules.BuyCost(count) return Config.BuyCosts[count] end
function Rules.Deposit(data,multiplier)
	local amount=math.max(0,data.Bag)
	local credited=amount*(multiplier or 1)
	data.Bag=0; data.CafeQueue+=credited
	return amount,credited
end
function Rules.ConvertCafe(data,now)
	local units=math.min(data.CafeQueue,Rules.CafeRate(data)*Config.CafeInterval)
	data.CafeQueue-=units
	local cash=units*(now<data.HotUntil and Config.HotTimeMultiplier or 1)
	data.Pending+=cash
	data.TotalCashEarned=(data.TotalCashEarned or 0)+cash
	return units,cash
end
function Rules.UpgradeCafe(data)
	if data.CafeLevel>=Config.CafeMaxLevel then return false,"Converter is fully upgraded" end
	local cost=Rules.CafeUpgradeCost(data)
	if data.Cash<cost then return false,"Not enough cash for converter upgrade" end
	data.Cash-=cost; data.CafeLevel+=1; return true
end
function Rules.Add(data,tier,shiny,count,discoveries,variant)
	variant=shiny and (variant==2 and 2 or 1) or 0
	local key=Rules.Key(tier,shiny,variant)
	data.Pets[key]=(data.Pets[key] or 0)+(count or 1)
	if not data.Index[key] then
		data.Index[key]=true
		if discoveries then table.insert(discoveries,{Tier=tier,Shiny=shiny,Variant=variant,Key=key}) end
	end
end
function Rules.Merge(data,discoveries)
	for tier=1,29 do for variant=0,2 do
		local shiny=variant>0; local key=Rules.Key(tier,shiny,variant)
		local count=data.Pets[key] or 0
		local nextCount=math.floor(count/3)
		data.Pets[key]=count%3
		if nextCount>0 then Rules.Add(data,tier+1,shiny,nextCount,discoveries,variant) end
	end end
end
function Rules.Count(data)
	local count=0; for _,n in pairs(data.Pets) do count+=n end; return count
end
function Rules.Highest(data)
	local highest=1
	for key,n in pairs(data.Pets) do if n>0 then local tier=Rules.Decode(key); highest=math.max(highest,tier) end end
	return highest
end
function Rules.ShinyChance(kind,luck,friendBonus)
 local multiplier=type(luck)=="number" and luck or (luck and 2 or 1)
 return math.clamp((kind=="Perk" and .1 or .01)*multiplier+(friendBonus or 0),0,1)
end
function Rules.FriendBonus(premium,friends)
	local bonus=0
	for _,friendPremium in ipairs(friends) do bonus=math.max(bonus,(premium or friendPremium) and .05 or .03) end
	return bonus
end
function Rules.NextPass(passes,group)
	local tiers=group=="Production" and Config.ProductionTiers or group=="Speed" and Config.SpeedTiers or Config.LuckTiers
	for _,key in ipairs(tiers) do if not passes[key] then return key end end
end
function Rules.PassMultiplier(passes,group)
	local value=1
	if group=="Production" or group=="Luck" or group=="Speed" then
		local tiers=group=="Production" and Config.ProductionTiers or group=="Speed" and Config.SpeedTiers or Config.LuckTiers
		for _,key in ipairs(tiers) do if not passes[key] then break end; value=Config.Passes[key].Multiplier end
	else for key,spec in pairs(Config.Passes) do if passes[key] and spec.Group==group then value=math.max(value,spec.Multiplier) end end end
	return value
end
function Rules.CanBuyPass(passes,key)
	local spec=Config.Passes[key]
	return spec~=nil and not passes[key] and ((spec.Group~="Production" and spec.Group~="Luck" and spec.Group~="Speed") or Rules.NextPass(passes,spec.Group)==key)
end
function Rules.Buy(data,count,rng,luck,autoMerge,friendBonus)
	if count~=1 and count~=10 and count~=100 and count~=1000 then return false,"Invalid quantity" end
	local cost=Rules.BuyCost(count)
	if data.Cash<cost then return false,"Not enough cash" end
	local trial={Pets=table.clone(data.Pets), Index=table.clone(data.Index)}
	local discoveries={}
	for _=1,count do
		local shiny=rng:NextNumber()<Rules.ShinyChance("Normal",luck,friendBonus)
		Rules.Add(trial,1,shiny,1,discoveries,Rules.RollVariant(1,shiny,rng))
	end
	if count>1 or autoMerge then Rules.Merge(trial,discoveries) end
	if Rules.Count(trial)>Config.Capacity then return false,"Plates are full. Merge desserts first." end
	data.Pets,data.Index=trial.Pets,trial.Index
	data.Cash-=cost
	return true,discoveries
end
function Rules.Odds(highest,kind)
	local offsets=kind=="Perk" and {3,2,1,0} or {4,3,2,1}
	local weights={40,30,20,10}
	local odds={}
	for i,offset in ipairs(offsets) do
		local cap=math.max(1,highest-offset)
		for tier=1,cap do odds[tier]=(odds[tier] or 0)+weights[i]/cap end
	end
	return odds
end
function Rules.Roll(data,kind,rng,luck,discoveries,friendBonus)
	local roll=rng:NextNumber()*100; local sum=0
	local highest=Rules.Highest(data); local lastTier=kind=="Perk" and highest or math.max(1,highest-1)
	local odds=Rules.Odds(highest,kind)
	for tier=1,lastTier do
		sum+=odds[tier] or 0
		if roll<sum or tier==lastTier then
			local shiny=rng:NextNumber()<Rules.ShinyChance(kind,luck,friendBonus)
			local variant=Rules.RollVariant(tier,shiny,rng)
			Rules.Add(data,tier,shiny,1,discoveries,variant)
			return {Tier=tier,Shiny=shiny,Variant=variant,Key=Rules.Key(tier,shiny,variant)}
		end
	end
end
-- A missed offline interval does not accumulate unlimited gifts. Start the next 5h cycle now.
-- Both Premium and normal rewards share ONE deadline and are delivered atomically.
function Rules.Gift(data,now,premium)
	if now<data.NextGift then return false end
	data.NormalTokens+=1
	if premium then data.PerkTokens+=1 end
	data.NextGift=now+INTERVAL
	return true
end
function Rules.AFK(data,seconds,premium)
	data.AFKSeconds+=seconds
	local earned=math.floor(data.AFKSeconds/Config.AFKInterval)
	data.AFKSeconds%=Config.AFKInterval
	data.NormalTokens+=earned
	if premium then data.PerkTokens+=earned end
	return earned
end
return Rules
