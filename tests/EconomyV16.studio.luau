-- Edit-mode regression; no real saves, payments or accounts.
local folder=Instance.new('Folder'); folder.Parent=game.ReplicatedStorage
for _,n in ipairs({'TycoonConfig','DessertRules'}) do game.ReplicatedStorage[n]:Clone().Parent=folder end
local R=require(folder.DessertRules); local C=require(folder.TycoonConfig)
local rng={NextNumber=function() return .5 end}
local d=R.New(0); d.Cash=10000
assert(R.Buy(d,1,rng,false) and R.Buy(d,1,rng,false))
assert(d.Pets['1n']==3 and not d.Pets['2n'],'Buy 1 must not auto-merge')
R.Merge(d,{},rng); assert(d.Pets['2n']==1 and d.Pets['1n']==0)
for _,count in ipairs({10,100,1000}) do
 local p=R.New(0); p.Cash=1e12; local before=p.Cash;local cost=R.BuyCost(count,p)
 assert(R.Buy(p,count,rng,false)); assert(p.Cash==before-cost)
 local units=0; for key,n in pairs(p.Pets) do local tier=R.Decode(key); units+=n*3^(tier-1); assert(tier==30 or n<3) end
 assert(units==count+1,'Bulk merge must conserve all logical desserts')
end
local full=R.New(0); full.Cash=10000; full.Pets={['1n']=60}; local original=full.Cash
assert(not R.Buy(full,1,rng,false) and full.Cash==original,'Full plates must reject without charging')
d=R.New(0); d.Bag=100.5; d.Cash=20
local amount,credit=R.Deposit(d,1.5); assert(amount==100.5 and credit==150.75 and d.Pending==0)
local units,cash=R.ConvertCafe(d,0); assert(units==2 and cash==2 and d.CafeQueue==148.75)
assert(R.UpgradeCafe(d) and d.Cash==0 and R.CafeRate(d)==3 and R.CafeUpgradeCost(d)==80)
assert(not R.UpgradeCafe(d)); local total=2
for _=1,100 do local n=R.ConvertCafe(d,0); total+=n end
assert(total==150.75 and d.CafeQueue==0 and d.Pending==150.75 and d.TotalCashEarned==150.75)
d.Bag=.4; R.Deposit(d,.5); d.HotUntil=10
local _,hot=R.ConvertCafe(d,1); assert(math.abs(hot-.4)<1e-8)
local old={Cash=17,Pending=4,CafeLevel=2}; R.NormalizeCafe(old)
assert(old.Cash==17 and old.Pending==4 and old.TotalCashEarned==0 and old.PlaySeconds==0)
assert(C.MaxDrops==100 and C.Products.Normal1.Id>=0)
local offline=R.New(100); offline.Pets={['1n']=3,['2n']=2}
assert(R.ProductionPerSecond(offline)==3)
assert(R.AccrueOffline(offline,120,2)==60 and offline.OfflineStored==60)
assert(R.AccrueOffline(offline,120,2)==0,'Same timestamp must not duplicate offline credits')
assert(R.AccrueOffline(offline,110,2)==0,'Clock going backwards must not subtract credits')
local excess=R.New(0); excess.Pets={['1n']=60,['30n']=1}
assert(R.ProductionPerSecond(excess)==(3^29+59)/3,'Hidden inventory must not earn offline production')
local island=workspace.DessertJellyIsland
assert(island:GetAttribute('PromenadeVersion')>=2)
for _,pad in ipairs(island:GetDescendants()) do local base=pad:IsA('BasePart') and pad:FindFirstChild('ButtonBase')
 if base then assert(#base:GetChildren()==1 and base.SingleBase and base:GetAttribute('NoCoplanarOverlap')) end
end
for _,p in ipairs(island.HubPromenade:GetDescendants()) do assert(not p:IsA('LuaSourceContainer') and not p:IsA('PackageLink')) end
folder:Destroy()
print('[EconomyV16] PASS: single/manual merge, bulk conservation/discounts, capacity rollback, fixed per-second conversion, fractional market conservation, upgrades, statistics migration, clean promenade and single bases')
