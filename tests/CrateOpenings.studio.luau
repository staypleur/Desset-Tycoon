-- Edit-mode regression. Durable writes use a fake store, never production saves.
local f=Instance.new("Folder");f.Parent=game.ReplicatedStorage
for _,name in {"DessertRules","TycoonConfig"} do game.ReplicatedStorage[name]:Clone().Parent=f end
local R=require(f.DessertRules)
local function fresh(tier)
 local d=R.New(0);d.TutorialStep=11;d.Pets={[R.Key(tier,false)]=1};d.Index={[R.Key(tier,false)]=true};return d
end
for tier=1,30 do for _,kind in {"Normal","Perk"} do
 local total=0;local n=0
 for t,p in R.Odds(tier,kind) do
  assert(t>=1 and t<=tier and math.abs(p-100/tier)<1e-8);total+=p;n+=1
 end
 assert(math.abs(total-100)<1e-8 and n==tier)
 local disclosed=0;for _,entry in R.CrateOutcomeOdds(tier,kind,2,.04,false) do disclosed+=entry.Percent end
 assert(math.abs(disclosed-100)<1e-8)
end end
local d=fresh(30);d.NormalTokens=4;d.PaidNormalTokens=6
local ok,b=R.OpenCrates(d,"Normal",10,Random.new(1),1,0,false,false)
assert(ok and #b.Results==10 and b.PaidUsed==6 and d.NormalTokens==0 and d.PaidNormalTokens==0)
assert(R.Count(d)==11)
d.PaidPerkTokens=10
assert(R.OpenCrates(d,"Perk",10,Random.new(2),1,0,false,false));assert(R.Count(d)==21)
d.NormalTokens=1;d.PaidNormalTokens=10
assert(R.OpenCrates(d,"Normal",1,Random.new(3),1,0,true,false));assert(d.PaidNormalTokens==10 and R.Count(d)==22)
assert(not R.OpenCrates(d,"Normal",1,Random.new(),1,0,true,false))
assert(not R.OpenCrates(d,"invalid",1,Random.new(),1,0,false,false))
assert(not R.OpenCrates(d,"Normal",2,Random.new(),1,0,false,false))
assert(R.ExchangeShards==nil and R.New(0).CrateShards==nil and b.ShardsEarned==nil)
local realGame=game;local json=game:GetService("HttpService");local saved;local fail=false
local store={UpdateAsync=function(_,_,fn)
 local result=fn(saved);if result then saved=json:JSONDecode(json:JSONEncode(result)) end
 if fail then fail=false;error("Simulated post-commit timeout") end
 return saved
end}
local fake={JobId="CrateOpeningRegression",ReplicatedStorage=f}
function fake:GetService(name)
 if name=="DataStoreService" then return {GetDataStore=function() return store end} end
 if name=="RunService" then return {IsStudio=function() return false end} end
 return realGame:GetService(name)
end
local fn=assert(loadstring(game.ServerScriptService.PlayerProfiles.Source));setfenv(fn,setmetatable({game=fake},{__index=getfenv()}));local P=fn()
local p=assert(P.Load({UserId=999999999}));p.Data=fresh(30);p.Data.PaidPerkTokens=10
local function open(trial) return R.OpenCrates(trial,"Perk",10,Random.new(9),1,0,false,false) end
assert(P.Mutate(p,open));assert(R.Count(p.Data)==11 and p.Data.PaidPerkTokens==0)
assert(not P.Mutate(p,open) and R.Count(p.Data)==11)
assert(P.Save(p,true));p=assert(P.Load({UserId=999999999}));assert(R.Count(p.Data)==11)
p.Data.PaidPerkTokens=10;fail=true
assert(not P.Mutate(p,open) and p.Faulted)
assert(R.Count(saved.Data)==21 and saved.Data.PaidPerkTokens==0)
assert(not P.Save(p,true));saved.Lock.Expires=0;p=assert(P.Load({UserId=999999999}))
assert(R.Count(p.Data)==21 and not P.Mutate(p,open))
f:Destroy();print("[CrateOpenings] PASS: 60 full tier pools, exact disclosure, mixed/free/paid grants, restricted regions, input validation, retired shard system, atomic saves, reload and uncertain-commit recovery")
