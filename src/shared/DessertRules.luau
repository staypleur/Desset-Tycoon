-- Pure server rules. Quantities are logical counts; a Buy 1000 never builds 1000 models.
local Rules = {}
local Config=require(script.Parent.TycoonConfig)
local INTERVAL = Config.GiftInterval
function Rules.Key(tier, shiny) return tostring(tier)..(shiny and "s" or "n") end
function Rules.Decode(key) return tonumber(key:sub(1,-2)), key:sub(-1)=="s" end
function Rules.New(now)
	return {Version=2, Cash=0, Bag=0, Pending=0, CafeQueue=0, CafeLevel=0, Pets={["1n"]=1}, Index={["1n"]=true},
		TotalCashEarned=0,TotalMiniCollected=0,PlaySeconds=0,AFKStored=0,OfflineStored=0,LastSeen=now,
		NormalTokens=0, PerkTokens=0, PaidNormalTokens=0, PaidPerkTokens=0, NextGift=now+INTERVAL, AFKSeconds=0,
		Settings={Music=true, Effects=true, HideOthers=false}, Receipts={}, HotUntil=0}
end
function Rules.NormalizeCafe(data)
	data.CafeQueue=math.max(0,data.CafeQueue or 0)
	data.CafeLevel=math.clamp(math.floor(data.CafeLevel or 0),0,Config.CafeMaxLevel)
	data.Version=2
	data.TotalCashEarned=math.max(0,data.TotalCashEarned or 0)
	data.TotalMiniCollected=math.max(0,data.TotalMiniCollected or 0)
	data.PlaySeconds=math.max(0,data.PlaySeconds or 0)
	data.AFKStored=math.max(0,data.AFKStored or 0)
	data.OfflineStored=math.max(0,data.OfflineStored or 0)
	data.LastSeen=data.LastSeen or os.time()
end
-- Use exactly the same 60-slot ordering as the displayed producer models.
function Rules.ProductionPerSecond(data)
	local slots,value=0,0
	for tier=1,30 do for _,shiny in ipairs({false,true}) do
		local count=math.min(data.Pets[Rules.Key(tier,shiny)] or 0,Config.Capacity-slots)
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
	if type(key)~="string" or not data.Index[key] then return false end
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
function Rules.Add(data,tier,shiny,count,discoveries)
	local key=Rules.Key(tier,shiny)
	data.Pets[key]=(data.Pets[key] or 0)+(count or 1)
	if not data.Index[key] then
		data.Index[key]=true
		if discoveries then table.insert(discoveries,{Tier=tier,Shiny=shiny}) end
	end
end
function Rules.Merge(data,discoveries)
	for tier=1,29 do for _,shiny in ipairs({false,true}) do
		local key=Rules.Key(tier,shiny)
		local count=data.Pets[key] or 0
		local nextCount=math.floor(count/3)
		data.Pets[key]=count%3
		if nextCount>0 then Rules.Add(data,tier+1,shiny,nextCount,discoveries) end
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
function Rules.ShinyChance(kind,luck)
 return (kind=="Perk" and .1 or .01)*(luck and 2 or 1)
end
function Rules.Buy(data,count,rng,luck,autoMerge)
	if count~=1 and count~=10 and count~=100 and count~=1000 then return false,"Invalid quantity" end
	local cost=Rules.BuyCost(count)
	if data.Cash<cost then return false,"Not enough cash" end
	local trial={Pets=table.clone(data.Pets), Index=table.clone(data.Index)}
	local discoveries={}
	for _=1,count do Rules.Add(trial,1,rng:NextNumber()<Rules.ShinyChance("Normal",luck),1,discoveries) end
	if count>1 or autoMerge then Rules.Merge(trial,discoveries) end
	if Rules.Count(trial)>Config.Capacity then return false,"Plates are full. Merge desserts first." end
	data.Pets,data.Index=trial.Pets,trial.Index
	data.Cash-=cost
	return true,discoveries
end
function Rules.Odds(highest,kind)
	local offsets=kind=="Perk" and {3,2,1,0} or {4,3,2,1}
	local weights=kind=="Perk" and {40,30,20,10} or {70,20,9,1}
	local odds={}
	for i,offset in ipairs(offsets) do
		local tier=math.max(1,highest-offset); odds[tier]=(odds[tier] or 0)+weights[i]
	end
	return odds
end
function Rules.Roll(data,kind,rng,luck,discoveries)
	local roll=rng:NextNumber()*100; local sum=0
	local odds=Rules.Odds(Rules.Highest(data),kind)
	for tier=1,30 do
		sum+=odds[tier] or 0
		if roll<sum then
			local shiny=rng:NextNumber()<Rules.ShinyChance(kind,luck)
			Rules.Add(data,tier,shiny,1,discoveries)
			return {Tier=tier,Shiny=shiny}
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
function Rules.AFK(data,seconds)
	data.AFKSeconds+=seconds
	local earned=math.floor(data.AFKSeconds/Config.AFKInterval)
	data.AFKSeconds%=Config.AFKInterval
	data.NormalTokens+=earned
	return earned
end
return Rules
