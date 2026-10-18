-- Edit-mode regression. All durable writes use an in-memory fake store.
local f=Instance.new("Folder");f.Parent=game.ReplicatedStorage
for _,name in {"DessertRules","TycoonConfig"} do game.ReplicatedStorage[name]:Clone().Parent=f end
local R=require(f.DessertRules);local C=require(f.TycoonConfig)
local function fresh(tier)
 local d=R.New(0);d.TutorialStep=11;d.Pets={[R.Key(tier,false)]=1};d.Index={[R.Key(tier,false)]=true};return d
end
for tier=1,30 do for _,kind in {"Normal","Perk"} do
 local odds=R.Odds(tier,kind);local total=0;local n=0
 for t,p in odds do
  assert(t>=math.max(1,tier-(kind=="Perk" and 3 or 4)) and t<=math.max(1,tier-(kind=="Perk" and 0 or 1)))
  total+=p;n+=1
 end
 assert(total==100 and n<=4)
 local disclosed=0
 for _,entry in R.CrateOutcomeOdds(tier,kind,2,.4,false) do disclosed+=entry.Percent end
 assert(math.abs(disclosed-100)<1e-8)
end end
local d=fresh(30);d.NormalTokens=4;d.PaidNormalTokens=6
local ok,b=R.OpenCrates(d,"Normal",10,Random.new(1),1,0,false,false)
assert(ok and #b.Results==10 and b.PaidUsed==6 and b.ShardsEarned==6 and d.CrateShards==6 and d.NormalTokens==0 and d.PaidNormalTokens==0)
d.PaidPerkTokens=10
assert(R.OpenCrates(d,"Perk",10,Random.new(2),1,0,false,false));assert(d.CrateShards==36)
d.NormalTokens=1;d.PaidNormalTokens=10
assert(R.OpenCrates(d,"Normal",1,Random.new(3),1,0,true,false));assert(d.CrateShards==36 and d.PaidNormalTokens==10)
assert(not R.OpenCrates(d,"Normal",1,Random.new(),1,0,true,false))
assert(not R.OpenCrates(d,"invalid",1,Random.new(),1,0,false,false))
assert(not R.OpenCrates(d,"Normal",2,Random.new(),1,0,false,false))
assert(R.ExchangeShards(d,30,0));assert(d.CrateShards==6)
assert(not R.ExchangeShards(d,30,0) and d.CrateShards==6)
d.CrateShards=300
for _,variant in {1,2} do assert(R.ExchangeShards(d,30,variant));assert(d.Index[R.Key(30,true,variant)]) end
assert(d.CrateShards==0)
d.CrateShards=150
for _,tier in {0,31,1.5,0/0,math.huge} do assert(not R.ExchangeShards(d,tier,1) and d.CrateShards==150) end
assert(not R.ExchangeShards(d,30,3))
assert(not R.ExchangeShards(fresh(1),2,1))
local old=fresh(1);old.CrateShards=nil;R.NormalizeCafe(old);assert(old.CrateShards==0)
for _,bad in {-1,0/0,math.huge} do old.CrateShards=bad;R.NormalizeCafe(old);assert(old.CrateShards==0) end
-- Exercise the real persistence wrapper, including a timeout after the store committed.
local realGame=game;local json=game:GetService("HttpService");local saved;local fail=false
local store={UpdateAsync=function(_,_,fn)
 local result=fn(saved);if result then saved=json:JSONDecode(json:JSONEncode(result)) end
 if fail then fail=false;error("Simulated post-commit timeout") end
 return saved
end}
local fake={JobId="ShardRegression",ReplicatedStorage=f}
function fake:GetService(name)
 if name=="DataStoreService" then return {GetDataStore=function() return store end} end
 if name=="RunService" then return {IsStudio=function() return false end} end
 return realGame:GetService(name)
end
local fn=assert(loadstring(game.ServerScriptService.PlayerProfiles.Source));setfenv(fn,setmetatable({game=fake},{__index=getfenv()}));local P=fn()
local player={UserId=999999999,Kick=function(self) self.Kicked=true end};local p=assert(P.Load(player))
p.Data=fresh(30);p.Data.PaidPerkTokens=10
local function open(trial) return R.OpenCrates(trial,"Perk",10,Random.new(9),1,0,false,false) end
assert(P.Mutate(p,open));assert(p.Data.CrateShards==30 and p.Data.PaidPerkTokens==0)
assert(not P.Mutate(p,open) and p.Data.CrateShards==30)
assert(P.Save(p,true));p=assert(P.Load(player));assert(p.Data.CrateShards==30)
assert(P.Mutate(p,function(t) return R.ExchangeShards(t,30,0) end));assert(p.Data.CrateShards==0)
p.Data.PaidPerkTokens=10;fail=true
assert(not P.Mutate(p,open) and p.Faulted)
assert(saved.Data.CrateShards==30 and saved.Data.PaidPerkTokens==0)
assert(not P.Save(p,true));saved.Lock.Expires=0;p=assert(P.Load(player))
assert(p.Data.CrateShards==30 and not P.Mutate(p,open))
f:Destroy();print("[CrateShards] PASS: 60 tier pools, exact disclosure, free/paid mixed openings, restricted regions, deterministic choices, input validation, migration, atomic saves, reload and uncertain-commit recovery")
