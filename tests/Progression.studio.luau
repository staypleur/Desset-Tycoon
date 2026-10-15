-- Run in Studio edit mode. Uses actual rules, virtual time, and a seeded server RNG.
local f=Instance.new("Folder"); f.Parent=game.ServerStorage
game.ReplicatedStorage.DessertRules:Clone().Parent=f
game.ReplicatedStorage.TycoonConfig:Clone().Parent=f
local R=require(f.DessertRules); local C=require(f.TycoonConfig)
local function mass(d) return R.Equivalent(d) end
local normal={NextNumber=function() return .9 end}
for tier=1,29 do
	for _,counts in ipairs({{3,0,0},{0,3,0},{0,0,3},{2,1,0},{1,1,1},{0,1,2},{2,2,2}}) do
		local d=R.New(0);d.Pets={}; local before=0
		for v=0,2 do R.Add(d,tier,v>0,counts[v+1],nil,v);before+=counts[v+1]*3^(tier-1) end
		R.Merge(d,{},normal)
		assert(mass(d)==before and d.Pets[R.Key(tier+1,false)]==math.floor((counts[1]+counts[2]+counts[3])/3),"Mixed merge independent of inputs")
	end
end
-- Same seed produces the same results for normal-only and shiny-only ingredients.
for v=0,2 do
	local d=R.New(0);d.Pets={};R.Add(d,1,v>0,3000,nil,v)
	R.Merge(d,{},Random.new(42));_G.MergeReference=_G.MergeReference or d.Pets
	for key,count in pairs(_G.MergeReference) do if tonumber(key:match("%d+"))>1 then assert(d.Pets[key]==count) end end
end
_G.MergeReference=nil
local d=R.New(0); assert(d.TutorialStep==1)
assert(not R.TutorialEvent(d,"Buy"));d.Bag=9;assert(not R.TutorialEvent(d,"Pickup"));d.Bag=10;assert(R.TutorialEvent(d,"Pickup"))
R.Deposit(d,.5);assert(R.TutorialEvent(d,"Deposit"));assert(not R.TutorialEvent(d,"Collect"))
for _=1,3 do R.ConvertCafe(d,0) end;d.Cash+=d.Pending;d.Pending=0;assert(R.TutorialEvent(d,"Collect"))
local shiny={NextNumber=function() return 0 end}
assert(R.Buy(d,1,shiny));assert(R.TutorialEvent(d,"Buy")); assert(d.TutorialStep==5)
d.Bag=10;assert(R.TutorialEvent(d,"Pickup"));R.Deposit(d,.5);assert(R.TutorialEvent(d,"Deposit"))
for _=1,3 do R.ConvertCafe(d,0) end;d.Cash+=d.Pending;d.Pending=0;assert(R.TutorialEvent(d,"Collect"))
assert(R.Buy(d,1,shiny));assert(R.TutorialEvent(d,"Buy"));R.Merge(d,{},normal);assert(R.TutorialEvent(d,"Merge"))
assert(d.Index["1s"] and R.ToggleEquip(d,"1n"));assert(R.TutorialEvent(d,"Equip") and d.TutorialStep==11)
local legacy=R.New(0);legacy.TutorialStep=nil;R.NormalizeCafe(legacy);assert(legacy.TutorialStep==11)
local resumed=R.New(0);resumed.TutorialStep=7;R.NormalizeCafe(resumed);assert(resumed.TutorialStep==7)
local equippedEarly=R.New(0);equippedEarly.TutorialStep=9;equippedEarly.Equipped="1n";equippedEarly.Index["2s"]=true
assert(R.TutorialEvent(equippedEarly,"Merge") and equippedEarly.TutorialStep==11)
local capped=R.New(0);capped.Pets={['30s']=3};R.Merge(capped,{},normal);assert(capped.Pets['30s']==3)
local function simulate(cycle)
	local p=R.New(0);p.TutorialStep=11; local rng=Random.new(734);local times={};local hours=0
	for tick=1,math.ceil(220*3600/cycle) do
		-- One full collection/sale/bank trip per cycle. Mean market 1x, no boosts,
		-- no offline rewards, crates or cafe upgrades; allow 1.5s render reset loss.
		local income=R.ProductionPerSecond(p)*(cycle-1.5)
		local converted=math.min(p.CafeQueue,R.CafeRate(p)*cycle)
		p.CafeQueue-=converted;p.Cash+=converted;p.Bag+=income;R.Deposit(p,1)
		for _=1,100 do
			local bought=false
			for _,count in ipairs({1000,100,10,1}) do
				if p.Cash>=R.BuyCost(count,p) then
					assert(R.Buy(p,count,rng,1,false,0));R.Merge(p,{},rng);bought=true;break
				end
			end
			if not bought then break end
		end
		hours=tick*cycle/3600
		for _,tier in ipairs({10,20,30}) do if R.Highest(p)>=tier and not times[tier] then times[tier]=hours end end
		if times[30] then break end
	end
	print("PROGRESSION_HOURS",cycle,times[10],times[20],times[30])
	if cycle==60 then for _,tier in ipairs({10,20,30}) do assert(times[tier] and math.abs(times[tier]/C.ProgressionHours[tier]-1)<.08,"Target time "..tier) end end
end
simulate(60); simulate(120)
f:Destroy();print("[Progression] PASS mixed merges, independent RNG, tutorial, migration, F2P targets")
