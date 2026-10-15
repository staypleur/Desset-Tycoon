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
local sherbet,ruby=0,0
for _=1,20000 do if R.RollVariant(3,true,random)==1 then sherbet+=1 else ruby+=1 end end
assert(math.abs(sherbet-ruby)<600,"Jelly shinies are equally likely")
local jelly=R.New(0);jelly.Pets={};jelly.Index={};local jellyFound={}
R.Add(jelly,2,true,3,jellyFound,1);R.Add(jelly,2,true,3,jellyFound,2);R.Merge(jelly,jellyFound)
assert(jelly.Pets["3s"]==1 and jelly.Pets["3s2"]==1 and jelly.Index["3s"] and jelly.Index["3s2"],"Custard merges retain jelly variant lineage")
assert(R.ToggleEquip(jelly,"3s2") and jelly.Equipped=="3s2")
local crateData=R.New(0);crateData.Index["3n"]=true;crateData.Pets["3n"]=1;local sample3={.999,0,.75};local sampleIndex=0
local jellyRoll=R.Roll(crateData,"Perk",{NextNumber=function() sampleIndex+=1;return sample3[sampleIndex] end},1,{})
assert(jellyRoll.Key=="3s2" and jellyRoll.Tier==3,"Tier-three crate winner retains ruby identity")
local aurora,unicorn=0,0
for _=1,20000 do if R.RollVariant(4,true,random)==1 then aurora+=1 else unicorn+=1 end end
assert(math.abs(aurora-unicorn)<600,"Shortcake shinies are equally likely")
local cake=R.New(0);cake.Pets={};cake.Index={};local cakeFound={}
R.Add(cake,3,true,3,cakeFound,1);R.Add(cake,3,true,3,cakeFound,2);R.Merge(cake,cakeFound)
assert(cake.Pets["4s"]==1 and cake.Pets["4s2"]==1 and cake.Index["4s"] and cake.Index["4s2"])
assert(R.ToggleEquip(cake,"4s2") and cake.Equipped=="4s2")
local cakeData=R.New(0);cakeData.Index["4n"]=true;cakeData.Pets["4n"]=1;local ci=0
local cakeRoll=R.Roll(cakeData,"Perk",{NextNumber=function() ci+=1;return ({.999,0,.75})[ci] end},1,{})
assert(cakeRoll.Key=="4s2" and cakeRoll.Tier==4,"Crate returns unicorn shortcake")
local crystal,dark=0,0
for _=1,20000 do if R.RollVariant(5,true,random)==1 then crystal+=1 else dark+=1 end end
assert(math.abs(crystal-dark)<600,"Macaron shinies are equally likely")
local macaron=R.New(0);macaron.Pets={};macaron.Index={};local macaronFound={}
R.Add(macaron,4,true,3,macaronFound,1);R.Add(macaron,4,true,3,macaronFound,2);R.Merge(macaron,macaronFound)
assert(macaron.Pets["5s"]==1 and macaron.Pets["5s2"]==1 and macaron.Index["5s"] and macaron.Index["5s2"])
assert(R.ToggleEquip(macaron,"5s2") and macaron.Equipped=="5s2")
local macaronData=R.New(0);macaronData.Index["5n"]=true;macaronData.Pets["5n"]=1;local mi=0
local macaronRoll=R.Roll(macaronData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(macaronRoll.Key=="5s2" and macaronRoll.Tier==5,"Crate returns pink gold dark macaron")
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
local expected={{1,false,0,"NormalPudding",5},{1,true,1,"MilkPudding",5},{1,true,2,"GalaxyPudding",5},{2,false,0,"NormalCustard",5},{2,true,1,"RainbowCustard",5},{2,true,2,"DarkChocoCustard",5},{3,false,0,"NormalJelly",5},{3,true,1,"SherbetJelly",5},{3,true,2,"RubyJelly",5},{4,false,0,"NormalShortcake",5},{4,true,1,"GalaxyShortcake",5},{4,true,2,"UnicornShortcake",5},{5,false,0,"NormalMacaron",5},{5,true,1,"CrystalMacaron",5},{5,true,2,"DarkMacaron",5}}
for _,spec in ipairs(expected) do
 local m=V.Build(spec[1],spec[2],spec[3]);local _,size=m:GetBoundingBox()
 assert(m.PrimaryPart.MeshId==f.DessertModelTemplates[spec[4]].PrimaryPart.MeshId)
 assert(math.abs(size.Y-spec[5])<.001 and m:GetPivot():FuzzyEq(CFrame.new()))
 assert(m:GetAttribute("Variant")==spec[3])
 for _,p in ipairs(m:GetDescendants()) do assert(not p:IsA("LuaSourceContainer") and not p:IsA("PackageLink")) end
 m:Destroy()
end
local mini=V.BuildMini(2,false);assert(mini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniCustard.PrimaryPart.MeshId)
assert(math.abs(select(2,mini:GetBoundingBox()).Y-18/28)<.001);mini:Destroy();local jellyMini=V.BuildMini(3,false);assert(jellyMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniJelly.PrimaryPart.MeshId);assert(math.abs(select(2,jellyMini:GetBoundingBox()).Y-18/28)<.001);jellyMini:Destroy();local cakeMini=V.BuildMini(4,false);assert(cakeMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniShortcake.PrimaryPart.MeshId);assert(math.abs(select(2,cakeMini:GetBoundingBox()).Y-18/28)<.001);cakeMini:Destroy();local macaronMini=V.BuildMini(5,false);assert(macaronMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniMacaron.PrimaryPart.MeshId);assert(math.abs(select(2,macaronMini:GetBoundingBox()).Y-18/28)<.001);macaronMini:Destroy();f:Destroy()
print("[DessertVariants] PASS: legacy save, 50:50",milk,galaxy,"separate merges/equip, offline production, crate identity, all imported models")

