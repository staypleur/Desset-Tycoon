local f=Instance.new("Folder"); f.Name="UserShopRulesRegression"; f.Parent=game.ReplicatedStorage
for _,n in ipairs({"TycoonConfig","DessertRules"}) do game.ReplicatedStorage[n]:Clone().Parent=f end
local C=require(f.TycoonConfig); local R=require(f.DessertRules)
local owned={}
for _,group in ipairs({"Production","Luck","Speed"}) do
 local tiers=group=="Production" and C.ProductionTiers or group=="Speed" and C.SpeedTiers or C.LuckTiers
 assert(R.PassMultiplier(owned,group)==1)
 assert(not R.CanBuyPass(owned,tiers[#tiers]),"Cannot skip progression")
 for _,key in ipairs(tiers) do
  assert(R.NextPass(owned,group)==key and R.CanBuyPass(owned,key))
  owned[key]=true; assert(not R.CanBuyPass(owned,key))
  assert(R.PassMultiplier(owned,group)==C.Passes[key].Multiplier)
 end
 assert(R.NextPass(owned,group)==nil)
end
assert(R.PassMultiplier({Boost5=true},"Production")==1)
assert(R.PassMultiplier({Speed12=true,Speed3=true},"Speed")==1.2 and R.PassMultiplier({Speed3=true},"Production")==1)
assert(math.abs(R.ShinyChance("Normal",2,.03)-.05)<1e-9)
assert(R.FriendBonus(false,{false,false})==.03 and R.FriendBonus(false,{true,true})==.05)
assert(R.FriendBonus(true,{false})==.05 and R.FriendBonus(false,{true})==.05 and R.FriendBonus(true,{})==0)
assert(math.abs(R.ShinyChance("Perk",3,.05)-.35)<1e-9 and R.ShinyChance("Perk",20,.05)==1)
for highest=1,30 do for _,kind in ipairs({"Normal","Perk"}) do
 local odds=R.Odds(highest,kind); local sum=0
 for tier,chance in pairs(odds) do assert(tier>=1 and tier<=highest and chance>0); sum+=chance end
 assert(math.abs(sum-100)<1e-9)
end end
local odds=R.Odds(10,"Normal")
assert(math.abs(odds[1]-(40/6+30/7+20/8+10/9))<1e-9 and odds[10]==nil and math.abs(odds[9]-10/9)<1e-9)
local d=R.New(0); d.Pets={['10n']=1}; local rng={NextNumber=function() return 0 end}; local discoveries={}
R.Roll(d,"Normal",rng,1,discoveries); R.Roll(d,"Normal",rng,1,discoveries)
assert(d.Pets['1s']==2 and #discoveries==1,"Shinies may repeat; discovery only happens once")
d=R.New(0); R.AFK(d,2*3600,false)
local json=game:GetService("HttpService"); d=json:JSONDecode(json:JSONEncode(d))
assert(R.AFK(d,3600,true)==1 and d.NormalTokens==1 and d.PerkTokens==1 and d.AFKSeconds==0)
assert(R.AFK(d,6*3600,false)==2 and d.NormalTokens==3 and d.PerkTokens==1)
assert(R.Gift(d,5*3600,true) and d.NormalTokens==4 and d.PerkTokens==2)
assert(not R.Gift(d,5*3600,true))
for _,spec in pairs(C.Passes) do assert(spec.Id>=0 and spec.Id%1==0) end
assert(C.Products.Normal10.Price==69 and C.Products.Perk10.Price==269)
f:Destroy()
print("[UserShopRules] PASS: sequential gates, isolated highest multipliers, all uniform-range odds, repeated shinies, luck plus friend bonus, stored 3h/Premium rewards, 5h gift deadline, locked IDs and prices")
