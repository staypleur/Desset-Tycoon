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
	return rng:NextNumber()<.5 and 1 or 2
end
function Rules.New(now)
	return {Version=2, TutorialStep=1, Cash=0, Bag=0, Pending=0, CafeQueue=0, CafeLevel=0, Pets={["1n"]=1}, Index={["1n"]=true},
		TotalCashEarned=0,TotalMiniCollected=0,PlaySeconds=0,AFKStored=0,OfflineStored=0,LastSeen=now,
		NormalTokens=0, PerkTokens=0, PaidNormalTokens=0, PaidPerkTokens=0, NextGift=now+INTERVAL, AFKSeconds=0,
		CodePets={},RedeemedCodes={},CodeShiny50=false,CodeCashActive=false,
		Settings={Music=true, Effects=true, MusicVolume=.4, EffectsVolume=.5, HideOthers=false}, Receipts={}, HotUntil=0}
end
function Rules.NormalizeCafe(data)
	data.CodePets=data.CodePets or {};data.RedeemedCodes=data.RedeemedCodes or {}
	data.CodeShiny50=data.CodeShiny50==true;data.CodeCashActive=data.CodeCashActive==true
	-- Missing marker means a pre-tutorial save, never replay onboarding for veterans.
	data.TutorialStep=type(data.TutorialStep)=="number" and math.clamp(math.floor(data.TutorialStep),1,11) or 11
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
function Rules.UnlockedTier(data)
	local tier=1
	for key,owned in pairs(data.Index) do if owned then tier=math.max(tier,Rules.Decode(key) or 1) end end
	return tier
end
function Rules.CafeRate(data) return Config.CafeBaseRate*3^(Rules.UnlockedTier(data)-1)*Config.CafeRateGrowth^data.CafeLevel end
function Rules.CafeUpgradeCost(data) return Config.CafeUpgradeBaseCost*3^(Rules.UnlockedTier(data)-1)*Config.CafeUpgradeCostGrowth^data.CafeLevel end
-- Companion selection is independent of the producing desserts on the plot.
function Rules.ToggleEquip(data,key)
	if type(key)~="string" then return false end
	if not (Rules.Decode(key) and data.Index[key]) and not (data.CodePets and data.CodePets[key]==true) then return false end
	data.Equipped=data.Equipped~=key and key or nil
	return true
end
function Rules.Equivalent(data)
	local total=0
	for key,count in pairs(data.Pets) do local tier=Rules.Decode(key); if tier then total+=count*3^(tier-1) end end
	return total
end
function Rules.BuyTier(data) return math.max(1,Rules.UnlockedTier(data)-6) end
function Rules.BuyQuantity(count,data) return count*3^(Rules.BuyTier(data)-1) end
function Rules.BuyCost(count,data)
	if not Config.BuyCosts[count] then return nil end
	if not data then return Config.BuyCosts[count] end -- Unowned pads show starter prices.
	local start=Rules.Equivalent(data); local remaining=Rules.BuyQuantity(count,data); local cost=0
	for tier=1,30 do
		local boundary=tier==30 and math.huge or 3^tier
		if start<boundary and remaining>0 then
			local units=math.min(remaining,boundary-start)
			local hours=(Config.ProgressionHours[math.min(30,tier+1)]-Config.ProgressionHours[math.min(29,tier)])
			local price=tier==1 and Config.PuddingCost or hours*3600/(Config.ProductionInterval*math.log(3)) * Config.ProgressionCostScale
			cost+=units*price; start+=units; remaining-=units
		end
	end
	return cost*Config.BuyDiscounts[count]
end
function Rules.TutorialEvent(data,event)
	local step=data.TutorialStep or 11
	local expected=({"Pickup","Deposit","Collect","Buy","Pickup","Deposit","Collect","Buy","Merge","Equip"})[step]
	if event~=expected then return false end
	if event=="Pickup" and data.Bag<10 then return false end
	if event=="Collect" and data.Cash<Rules.BuyCost(1,data) then return false end
	if event=="Merge" and not (data.Index["2n"] or data.Index["2s"] or data.Index["2s2"]) then return false end
	if event=="Equip" and data.Equipped~="1n" then return false end
	data.TutorialStep=step+1
	-- A player who already selected Pudding should never be guided to unequip it.
	if data.TutorialStep==10 and data.Equipped=="1n" then data.TutorialStep=11 end
	return true
end
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
function Rules.Merge(data,discoveries,rng,luck,friendBonus)
	rng=rng or Random.new()
	for tier=1,29 do
		local chance=Rules.ShinyChance("Normal",luck,friendBonus,data.CodeShiny50,tier+1)
		local total=0
		for variant=0,2 do total+=data.Pets[Rules.Key(tier,variant>0,variant)] or 0 end
		local nextCount=math.floor(total/3)
		-- Consume normals first, preserving rare leftovers when possible. Result odds
		-- are rolled independently; even three identical shinies confer no bonus.
		local consume=nextCount*3
		for variant=0,2 do
			local key=Rules.Key(tier,variant>0,variant)
			local used=math.min(data.Pets[key] or 0,consume)
			data.Pets[key]=(data.Pets[key] or 0)-used; consume-=used
		end
		for _=1,nextCount do
			local shiny=rng:NextNumber()<chance
			Rules.Add(data,tier+1,shiny,1,discoveries,Rules.RollVariant(tier+1,shiny,rng))
		end
	end
end
function Rules.Count(data)
	local count=0; for _,n in pairs(data.Pets) do count+=n end; return count
end
function Rules.Highest(data)
	local highest=1
	for key,n in pairs(data.Pets) do if n>0 then local tier=Rules.Decode(key); highest=math.max(highest,tier) end end
	return highest
end
function Rules.ShinyChance(kind,luck,friendBonus,forceHalf,tier)
 if forceHalf==true then return .5 end
 local multiplier=type(luck)=="number" and luck or (luck and 2 or 1)
 local band=math.ceil(math.clamp(tier or 1,1,30)/10)
 local base=kind=="Perk" and Config.CrateShinyRates.Perk or kind=="NormalCrate" and Config.CrateShinyRates.Normal or Config.ShinyBaseRates[band]
 return math.clamp((base+(friendBonus or 0))*multiplier,0,1)
end
function Rules.FriendBonus(premium,friends)
	return (premium and Config.ShinyPremiumBoost or 0)+(#friends>0 and Config.ShinyFriendBoost or 0)
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
	local cost=Rules.BuyCost(count,data)
	if data.Cash<cost then return false,"Not enough cash" end
	local trial={Pets=table.clone(data.Pets), Index=table.clone(data.Index),CodeShiny50=data.CodeShiny50}
	local discoveries={}
	local buyTier=Rules.BuyTier(data)
	for _=1,count do
		local shiny=rng:NextNumber()<Rules.ShinyChance("Normal",luck,friendBonus,data.CodeShiny50,buyTier)
		Rules.Add(trial,buyTier,shiny,1,discoveries,Rules.RollVariant(buyTier,shiny,rng))
	end
	if count>1 or autoMerge then Rules.Merge(trial,discoveries,rng,luck,friendBonus) end
	if Rules.Count(trial)>Config.Capacity then return false,"Plates are full. Merge desserts first." end
	data.Pets,data.Index=trial.Pets,trial.Index
	data.Cash-=cost
	return true,discoveries
end
function Rules.Odds(highest,kind)
	highest=math.clamp(math.floor(highest),1,30)
	local odds={}
	for tier=1,highest do odds[tier]=100/highest end
	return odds
end
-- Itemized final outcomes used by the pre-purchase details panel.
function Rules.CrateOutcomeOdds(highest,kind,luck,friendBonus,forceHalf)
	local entries={};local tiers=Rules.Odds(highest,kind)
	for tier=1,30 do if tiers[tier] then
		local shiny=Rules.ShinyChance(kind=="Normal" and "NormalCrate" or kind,luck,friendBonus,forceHalf,tier)
		for variant=0,2 do
			table.insert(entries,{Tier=tier,Shiny=variant>0,Variant=variant,Percent=tiers[tier]*(variant==0 and 1-shiny or shiny/2)})
		end
	end end
	return entries
end
function Rules.Roll(data,kind,rng,luck,discoveries,friendBonus)
	local roll=rng:NextNumber()*100; local sum=0
	local highest=Rules.Highest(data); local lastTier=highest
	local odds=Rules.Odds(highest,kind)
	for tier=1,lastTier do
		sum+=odds[tier] or 0
		if roll<sum or tier==lastTier then
			local shiny=rng:NextNumber()<Rules.ShinyChance(kind=="Normal" and "NormalCrate" or kind,luck,friendBonus,data.CodeShiny50,tier)
			local variant=Rules.RollVariant(tier,shiny,rng)
			Rules.Add(data,tier,shiny,1,discoveries,variant)
			return {Tier=tier,Shiny=shiny,Variant=variant,Key=Rules.Key(tier,shiny,variant)}
		end
	end
end
-- Used inside one durable profile transaction: credits and rewards commit together.
function Rules.OpenCrates(data,kind,count,rng,luck,friendBonus,restricted,autoMerge)
	if (data.TutorialStep or 11)<11 then return false,"Follow the arrows first" end
	if (kind~="Normal" and kind~="Perk") or (count~=1 and count~=10) then return false,"Invalid crate request" end
	local key=kind=="Perk" and "PerkTokens" or "NormalTokens"
	local paidKey="Paid"..key;local free=data[key] or 0;local paid=data[paidKey] or 0
	if free+(restricted and 0 or paid)<count then return false,"Not enough available crate credits" end
	local paidUsed=count-math.min(free,count)
	local batch={Results={},KnownBefore=table.clone(data.Index),Discoveries={},Highest=Rules.Highest(data),Kind=kind,PaidUsed=paidUsed}
	data[key]=free-(count-paidUsed);data[paidKey]=paid-paidUsed
	for _=1,count do table.insert(batch.Results,Rules.Roll(data,kind,rng,luck,batch.Discoveries,friendBonus)) end
	if autoMerge then Rules.Merge(data,batch.Discoveries,rng,luck,friendBonus) end
	return true,batch
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
