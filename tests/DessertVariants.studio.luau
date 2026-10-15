-- Edit mode, use a fresh folder to avoid cached modules from earlier tests.
local f=Instance.new("Folder"); f.Name="VariantRegression"; f.Parent=game.ServerStorage
for _,name in ipairs({"DessertRules","TycoonConfig","DessertCatalog","DessertVisuals","DessertModelTemplates"}) do game.ReplicatedStorage[name]:Clone().Parent=f end
local R=require(f.DessertRules); local V=require(f.DessertVisuals)
local legacy=R.New(0);legacy.Pets["1s"]=2;legacy.Index["1s"]=true;legacy.Equipped="1s"
R.NormalizeCafe(legacy)
assert(legacy.Pets["1s"]==2 and legacy.Index["1s"] and legacy.Equipped=="1s","Preserve existing save")
assert(R.Key(1,true,1)=="1s" and R.Key(1,true,2)=="1s2")
local tier,shiny,variant=R.Decode("1s2");assert(tier==1 and shiny and variant==2)
assert(not R.Decode("31s") and not R.Decode("1s3") and not R.ToggleEquip(legacy,"1n2"))
local random=Random.new(42178);local milk,galaxy=0,0
for _=1,20000 do local n=R.RollVariant(1,true,random);if n==1 then milk+=1 else galaxy+=1 end end
assert(math.abs(milk-galaxy)<600,"Two shiny variants are equally likely")
local rainbow,choco=0,0
for _=1,20000 do if R.RollVariant(2,true,random)==1 then rainbow+=1 else choco+=1 end end
assert(math.abs(rainbow-choco)<600 and R.RollVariant(1,false,random)==0)
local priority=R.New(0);priority.Pets={["1n"]=100,["2n"]=4,["4n"]=2};assert(R.ProductionPerSecond(priority)==40,"Highest tiers occupy limited production slots first")
local d=R.New(0);local found={}
R.Add(d,1,true,2,found,1);R.Add(d,1,true,2,found,2);R.Merge(d,found)
assert(d.Pets["1s"]==2 and d.Pets["1s2"]==2 and (d.Pets["2s"] or 0)==0,"Do not merge across variants")
R.Add(d,1,true,1,found,2);R.Merge(d,found)
assert(d.Pets["1s"]==2 and d.Pets["1s2"]==0 and d.Pets["2s2"]==1)
assert(d.Index["1s"] and d.Index["1s2"] and d.Index["2s2"])
assert(R.ToggleEquip(d,"1s") and d.Equipped=="1s")
assert(R.ToggleEquip(d,"1s2") and d.Equipped=="1s2")
assert(R.ToggleEquip(d,"1s2") and d.Equipped==nil)
assert(math.abs(R.ProductionPerSecond(d)-6/require(f.TycoonConfig).ProductionInterval)<1e-6)
local sample={0,0,.75};local i=0
local roll=R.Roll(R.New(0),"Normal",{NextNumber=function() i+=1;return sample[i] end},1,{})
assert(roll.Key=="1s2" and roll.Variant==2,"Crates carry the exact shiny identity")
local expected={{1,false,0,"NormalPudding",5},{1,true,1,"MilkPudding",5},{1,true,2,"GalaxyPudding",5},{2,false,0,"NormalCustard",5},{2,true,1,"RainbowCustard",5},{2,true,2,"DarkChocoCustard",5}}
for _,spec in ipairs(expected) do
 local m=V.Build(spec[1],spec[2],spec[3]);local _,size=m:GetBoundingBox()
 assert(m.PrimaryPart.MeshId==f.DessertModelTemplates[spec[4]].PrimaryPart.MeshId)
 assert(math.abs(size.Y-spec[5])<.001 and m:GetPivot():FuzzyEq(CFrame.new()))
 assert(m:GetAttribute("Variant")==spec[3])
 for _,p in ipairs(m:GetDescendants()) do assert(not p:IsA("LuaSourceContainer") and not p:IsA("PackageLink")) end
 m:Destroy()
end
local mini=V.BuildMini(2,false);assert(mini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniCustard.PrimaryPart.MeshId)
assert(math.abs(select(2,mini:GetBoundingBox()).Y-18/28)<.001);mini:Destroy();f:Destroy()
print("[DessertVariants] PASS: legacy save, 50:50",milk,galaxy,"separate merges/equip, offline production, crate identity, all imported models")

