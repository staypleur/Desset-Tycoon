-- Edit mode; cloned modules and fake durable store, never production account data.
local f=Instance.new("Folder");f.Parent=game.ServerStorage
for _,name in ipairs({"DessertRules","TycoonConfig"}) do game.ReplicatedStorage[name]:Clone().Parent=f end
game.ServerScriptService.DessertCodes:Clone().Parent=f
local R=require(f.DessertRules);local C=require(f.DessertCodes)
local json=game:GetService("HttpService")
local function copy(d) return json:JSONDecode(json:JSONEncode(d)) end
local d=R.New(0);local base=R.ProductionPerSecond(d);local cafe=R.CafeRate(d)
for i,code in ipairs({"jungbin0629","jungbin0410","jungbin0514"}) do
	assert(C.Redeem(d,"  "..string.upper(code).."  "))
	d=copy(d);assert(not C.Redeem(d,code),"Redemption survives reload")
end
assert(R.Count(d)==1 and R.Highest(d)==1 and R.UnlockedTier(d)==1)
assert(R.ProductionPerSecond(d)==base and R.CafeRate(d)==cafe and d.Index["code:cookie-fish"]==nil)
assert(R.ToggleEquip(d,"code:cookie-fish") and d.Equipped=="code:cookie-fish")
assert(R.ToggleEquip(d,"code:cookie-fish") and not d.Equipped)
assert(not R.ToggleEquip(R.New(0),"code:cookie-fish"))
for _,invalid in ipairs({{},false,123,"","unknown",string.rep("x",65)}) do assert(not C.Redeem(d,invalid)) end
assert(C.Redeem(d,"woochan0207"));d=copy(d)
assert(R.ShinyChance("Normal",16,.05,d.CodeShiny50)==.5 and R.ShinyChance("Perk",16,.05,d.CodeShiny50)==.5)
assert(C.Redeem(d,"woochan0207") and not d.CodeShiny50)
assert(R.ShinyChance("Normal",1,0,d.CodeShiny50)==.01)
assert(C.Redeem(d,"YWC14") and d.Cash==1e30);d=copy(d)
assert(d.CodeCashActive and C.Redeem(d,"ywc14") and d.Cash==0)
-- Boundary checks across purchases, merging and both crate types, including auto merge trials.
for _,roll in ipairs({.499999,.5}) do
	local rng={NextNumber=function() return roll end};local shiny=roll<.5
	local p=R.New(0);p.CodeShiny50=true;p.Cash=1e30
	assert(R.Buy(p,1,rng,16,false,.05));assert((p.Pets[R.Key(1,shiny,shiny and 1 or 0)] or 0)==(shiny and 1 or 2))
	p=R.New(0);p.CodeShiny50=true;p.Pets={['1n']=3};R.Merge(p,{},rng,16,.05)
	assert(p.Pets[R.Key(2,shiny,shiny and 1 or 0)]==1)
	p=R.New(0);p.CodeShiny50=true;p.Cash=1e30;assert(R.Buy(p,10,rng,16,true,.05))
	assert((p.Pets[R.Key(3,shiny,shiny and 1 or 0)] or 0)==1,"Bulk trial preserves override")
	for _,kind in ipairs({"Normal","Perk"}) do
		p=R.New(0);p.CodeShiny50=true;assert(R.Roll(p,kind,rng,16,{},.05).Shiny==shiny)
	end
end
local realGame=game;local saved;local fail=false;local writes=0
local store={UpdateAsync=function(_,_,callback)
	writes+=1;local value=callback(saved);if value then saved=copy(value) end
	if fail then fail=false;error("Timeout AFTER commit") end
	return saved
end}
local fakeGame={JobId="CodeProfileTest",ReplicatedStorage=f}
function fakeGame:GetService(name)
	if name=="RunService" then return {IsStudio=function() return false end} end
	if name=="DataStoreService" then return {GetDataStore=function() return store end} end
	return realGame:GetService(name)
end
local fn=assert(loadstring(game.ServerScriptService.PlayerProfiles.Source));setfenv(fn,setmetatable({game=fakeGame},{__index=getfenv()}))
local P=fn();local p=assert(P.Load({UserId=999999999}))
assert(P.Mutate(p,function(t) return C.Redeem(t,"jungbin0629") end))
assert(saved.Data.CodePets["code:cookie-fish"] and saved.Data.RedeemedCodes.jungbin0629)
local count=writes;assert(not P.Mutate(p,function(t) return C.Redeem(t,"jungbin0629") end));assert(writes==count)
assert(P.Save(p,true));p=assert(P.Load({UserId=999999999}));assert(not C.Redeem(p.Data,"jungbin0629"))
fail=true;assert(not P.Mutate(p,function(t) return C.Redeem(t,"jungbin0410") end))
assert(p.Faulted and saved.Data.CodePets["code:chocolate-fish"] and not P.Save(p,true))
saved.Lock.Expires=0;p=assert(P.Load({UserId=999999999}));assert(not C.Redeem(p.Data,"jungbin0410"))
assert(P.Mutate(p,function(t) return C.Redeem(t,"woochan0207") end));assert(P.Save(p,true))
p=assert(P.Load({UserId=999999999}));assert(p.Data.CodeShiny50)
assert(P.Mutate(p,function(t) return C.Redeem(t,"woochan0207") end) and not p.Data.CodeShiny50)
f:Destroy();print("[DessertCodes] PASS: cosmetic isolation, once-only reload, exact 50% boundaries, cash toggle, durable atomic grant, timeout recovery")
