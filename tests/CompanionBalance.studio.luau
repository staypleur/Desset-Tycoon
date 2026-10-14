-- Edit-mode test; clone modules so Studio's require cache cannot hide a change.
local folder=Instance.new("Folder"); folder.Name="CompanionBalanceRulesTest"; folder.Parent=game.ReplicatedStorage
for _,name in ipairs({"TycoonConfig","DessertRules"}) do game.ReplicatedStorage[name]:Clone().Parent=folder end
local R=require(folder.DessertRules); local C=require(folder.TycoonConfig)
local d=R.New(0); d.Index["2s"]=true
local pets=table.clone(d.Pets)
assert(R.ToggleEquip(d,"1n") and d.Equipped=="1n")
assert(R.ToggleEquip(d,"1n") and d.Equipped==nil)
assert(R.ToggleEquip(d,"1n") and R.ToggleEquip(d,"2s") and d.Equipped=="2s")
assert(not R.ToggleEquip(d,"30s") and d.Equipped=="2s")
assert(not R.ToggleEquip(d,{}) and d.Equipped=="2s")
assert(R.ToggleEquip(d,"2s") and d.Equipped==nil)
assert(d.Pets["1n"]==pets["1n"] and R.ProductionPerSecond(d)==1/3,"Unequip must not remove producers")
for level=0,C.CafeMaxLevel-1 do
 d.CafeLevel=level; local cost=R.CafeUpgradeCost(d); local rate=R.CafeRate(d)
 d.Cash=cost*.5; assert(not R.UpgradeCafe(d) and d.Cash==cost*.5 and d.CafeLevel==level)
 d.Cash=cost; assert(R.UpgradeCafe(d) and d.Cash==0 and d.CafeLevel==level+1)
 assert(R.CafeRate(d)==rate*3 and R.CafeUpgradeCost(d)==cost*4)
end
d.Cash=1e30; assert(not R.UpgradeCafe(d) and d.CafeLevel==C.CafeMaxLevel and d.Cash==1e30)
d.CafeLevel=0; assert(R.CafeUpgradeCost(d)==20 and 20/R.ProductionPerSecond(d)==60)
folder:Destroy()
print("[CompanionBalance] PASS: equip/unequip/switch, discovery gate, unchanged production, all upgrade levels, affordable first upgrade and growing cost-to-speed ratio")
