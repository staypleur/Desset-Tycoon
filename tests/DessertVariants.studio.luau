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
local crescent,quartz=0,0
for _=1,20000 do if R.RollVariant(6,true,random)==1 then crescent+=1 else quartz+=1 end end
assert(math.abs(crescent-quartz)<600,"Croissant shinies are equally likely")
local croissant=R.New(0);croissant.Pets={};croissant.Index={};local croissantFound={}
R.Add(croissant,5,true,3,croissantFound,1);R.Add(croissant,5,true,3,croissantFound,2);R.Merge(croissant,croissantFound)
assert(croissant.Pets["6s"]==1 and croissant.Pets["6s2"]==1 and croissant.Index["6s"] and croissant.Index["6s2"])
assert(R.ToggleEquip(croissant,"6s2") and croissant.Equipped=="6s2")
local croissantData=R.New(0);croissantData.Index["6n"]=true;croissantData.Pets["6n"]=1;local mi=0
local croissantRoll=R.Roll(croissantData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(croissantRoll.Key=="6s2" and croissantRoll.Tier==6,"Crate returns pink quartz rose gold croissant")
local cotton,honey=0,0
for _=1,20000 do if R.RollVariant(7,true,random)==1 then cotton+=1 else honey+=1 end end
assert(math.abs(cotton-honey)<600,"Waffle shinies are equally likely")
local waffle=R.New(0);waffle.Pets={};waffle.Index={};local waffleFound={}
R.Add(waffle,6,true,3,waffleFound,1);R.Add(waffle,6,true,3,waffleFound,2);R.Merge(waffle,waffleFound)
assert(waffle.Pets["7s"]==1 and waffle.Pets["7s2"]==1 and waffle.Index["7s"] and waffle.Index["7s2"])
assert(R.ToggleEquip(waffle,"7s2") and waffle.Equipped=="7s2")
local waffleData=R.New(0);waffleData.Index["7n"]=true;waffleData.Pets["7n"]=1;local mi=0
local waffleRoll=R.Roll(waffleData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(waffleRoll.Key=="7s2" and waffleRoll.Tier==7,"Crate returns pink dark choco honey waffle")
local bean,mango=0,0
for _=1,20000 do if R.RollVariant(8,true,random)==1 then bean+=1 else mango+=1 end end
assert(math.abs(bean-mango)<600,"Bingsu shinies are equally likely")
local bingsu=R.New(0);bingsu.Pets={};bingsu.Index={};local bingsuFound={}
R.Add(bingsu,7,true,3,bingsuFound,1);R.Add(bingsu,7,true,3,bingsuFound,2);R.Merge(bingsu,bingsuFound)
assert(bingsu.Pets["8s"]==1 and bingsu.Pets["8s2"]==1 and bingsu.Index["8s"] and bingsu.Index["8s2"])
assert(R.ToggleEquip(bingsu,"8s2") and bingsu.Equipped=="8s2")
local bingsuData=R.New(0);bingsuData.Index["8n"]=true;bingsuData.Pets["8n"]=1;local mi=0
local bingsuRoll=R.Roll(bingsuData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(bingsuRoll.Key=="8s2" and bingsuRoll.Tier==8,"Crate returns mango bingsu")
local prism,quartz=0,0
for _=1,20000 do if R.RollVariant(9,true,random)==1 then prism+=1 else quartz+=1 end end
assert(math.abs(prism-quartz)<600,"Tiramisu shinies are equally likely")
local tiramisu=R.New(0);tiramisu.Pets={};tiramisu.Index={};local tiramisuFound={}
R.Add(tiramisu,8,true,3,tiramisuFound,1);R.Add(tiramisu,8,true,3,tiramisuFound,2);R.Merge(tiramisu,tiramisuFound)
assert(tiramisu.Pets["9s"]==1 and tiramisu.Pets["9s2"]==1 and tiramisu.Index["9s"] and tiramisu.Index["9s2"])
assert(R.ToggleEquip(tiramisu,"9s2") and tiramisu.Equipped=="9s2")
local tiramisuData=R.New(0);tiramisuData.Index["9n"]=true;tiramisuData.Pets["9n"]=1;local mi=0
local tiramisuRoll=R.Roll(tiramisuData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(tiramisuRoll.Key=="9s2" and tiramisuRoll.Tier==9,"Crate returns quartz tiramisu")
local pearl,mint=0,0
for _=1,20000 do if R.RollVariant(10,true,random)==1 then pearl+=1 else mint+=1 end end
assert(math.abs(pearl-mint)<600,"Madeleine shinies are equally likely")
local madeleine=R.New(0);madeleine.Pets={};madeleine.Index={};local madeleineFound={}
R.Add(madeleine,9,true,3,madeleineFound,1);R.Add(madeleine,9,true,3,madeleineFound,2);R.Merge(madeleine,madeleineFound)
assert(madeleine.Pets["10s"]==1 and madeleine.Pets["10s2"]==1 and madeleine.Index["10s"] and madeleine.Index["10s2"])
assert(R.ToggleEquip(madeleine,"10s2") and madeleine.Equipped=="10s2")
local madeleineData=R.New(0);madeleineData.Index["10n"]=true;madeleineData.Pets["10n"]=1;local mi=0
local madeleineRoll=R.Roll(madeleineData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(madeleineRoll.Key=="10s2" and madeleineRoll.Tier==10,"Crate returns mint madeleine")
local quartz,galaxy=0,0
for _=1,20000 do if R.RollVariant(11,true,random)==1 then quartz+=1 else galaxy+=1 end end
assert(math.abs(quartz-galaxy)<600,"Eclair shinies are equally likely")
local eclair=R.New(0);eclair.Pets={};eclair.Index={};local eclairFound={}
R.Add(eclair,10,true,3,eclairFound,1);R.Add(eclair,10,true,3,eclairFound,2);R.Merge(eclair,eclairFound)
assert(eclair.Pets["11s"]==1 and eclair.Pets["11s2"]==1 and eclair.Index["11s"] and eclair.Index["11s2"])
assert(R.ToggleEquip(eclair,"11s2") and eclair.Equipped=="11s2")
local eclairData=R.New(0);eclairData.Index["11n"]=true;eclairData.Pets["11n"]=1;local mi=0
local eclairRoll=R.Roll(eclairData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(eclairRoll.Key=="11s2" and eclairRoll.Tier==11,"Crate returns galaxy eclair")
local ruby,mint=0,0
for _=1,20000 do if R.RollVariant(12,true,random)==1 then ruby+=1 else mint+=1 end end
assert(math.abs(ruby-mint)<600,"Panna Cotta shinies are equally likely")
local panna=R.New(0);panna.Pets={};panna.Index={};local pannaFound={}
R.Add(panna,11,true,3,pannaFound,1);R.Add(panna,11,true,3,pannaFound,2);R.Merge(panna,pannaFound)
assert(panna.Pets["12s"]==1 and panna.Pets["12s2"]==1 and panna.Index["12s"] and panna.Index["12s2"])
assert(R.ToggleEquip(panna,"12s2") and panna.Equipped=="12s2")
local pannaData=R.New(0);pannaData.Index["12n"]=true;pannaData.Pets["12n"]=1;local mi=0
local pannaRoll=R.Roll(pannaData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(pannaRoll.Key=="12s2" and pannaRoll.Tier==12,"Crate returns mint panna")
local sakura,blackhole=0,0
for _=1,20000 do if R.RollVariant(13,true,random)==1 then sakura+=1 else blackhole+=1 end end
assert(math.abs(sakura-blackhole)<600,"Souffle Pancake shinies are equally likely")
local souffle=R.New(0);souffle.Pets={};souffle.Index={};local souffleFound={}
R.Add(souffle,12,true,3,souffleFound,1);R.Add(souffle,12,true,3,souffleFound,2);R.Merge(souffle,souffleFound)
assert(souffle.Pets["13s"]==1 and souffle.Pets["13s2"]==1 and souffle.Index["13s"] and souffle.Index["13s2"])
assert(R.ToggleEquip(souffle,"13s2") and souffle.Equipped=="13s2")
local souffleData=R.New(0);souffleData.Index["13n"]=true;souffleData.Pets["13n"]=1;local mi=0
local souffleRoll=R.Roll(souffleData,"Perk",{NextNumber=function() mi+=1;return ({.999,0,.75})[mi] end},1,{})
assert(souffleRoll.Key=="13s2" and souffleRoll.Tier==13,"Crate returns blackhole souffle")
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
local expected={{1,false,0,"NormalPudding",5},{1,true,1,"MilkPudding",5},{1,true,2,"GalaxyPudding",5},{2,false,0,"NormalCustard",5},{2,true,1,"RainbowCustard",5},{2,true,2,"DarkChocoCustard",5},{3,false,0,"NormalJelly",5},{3,true,1,"SherbetJelly",5},{3,true,2,"RubyJelly",5},{4,false,0,"NormalShortcake",5},{4,true,1,"GalaxyShortcake",5},{4,true,2,"UnicornShortcake",5},{5,false,0,"NormalMacaron",5},{5,true,1,"CrystalMacaron",5},{5,true,2,"DarkMacaron",5},{6,false,0,"NormalCroissant",5},{6,true,1,"GalaxyCroissant",5},{6,true,2,"QuartzCroissant",5},{7,false,0,"NormalWaffle",5},{7,true,1,"UnicornWaffle",5},{7,true,2,"HoneybeeWaffle",5},{8,false,0,"NormalBingsu",5},{8,true,1,"RedBeanBingsu",5},{8,true,2,"MangoBingsu",5},{9,false,0,"NormalTiramisu",5},{9,true,1,"PrismTiramisu",5},{9,true,2,"QuartzTiramisu",5},{10,false,0,"NormalMadeleine",5},{10,true,1,"PearlMadeleine",5},{10,true,2,"MintMadeleine",5},{11,false,0,"NormalEclair",5},{11,true,1,"QuartzEclair",5},{11,true,2,"GalaxyEclair",5},{12,false,0,"NormalPannaCotta",5},{12,true,1,"RubyPannaCotta",5},{12,true,2,"MintPannaCotta",5},{13,false,0,"NormalSouffle",5},{13,true,1,"SakuraSouffle",5},{13,true,2,"BlackholeSouffle",5}}
for _,spec in ipairs(expected) do
 local m=V.Build(spec[1],spec[2],spec[3]);local _,size=m:GetBoundingBox()
 assert(m.PrimaryPart.MeshId==f.DessertModelTemplates[spec[4]].PrimaryPart.MeshId)
 assert(math.abs(size.Y-spec[5])<.001 and m:GetPivot():FuzzyEq(CFrame.new()))
 assert(m:GetAttribute("Variant")==spec[3])
 for _,p in ipairs(m:GetDescendants()) do assert(not p:IsA("LuaSourceContainer") and not p:IsA("PackageLink")) end
 m:Destroy()
end
local mini=V.BuildMini(2,false);assert(mini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniCustard.PrimaryPart.MeshId)
assert(math.abs(select(2,mini:GetBoundingBox()).Y-18/28)<.001);mini:Destroy();local jellyMini=V.BuildMini(3,false);assert(jellyMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniJelly.PrimaryPart.MeshId);assert(math.abs(select(2,jellyMini:GetBoundingBox()).Y-18/28)<.001);jellyMini:Destroy();local cakeMini=V.BuildMini(4,false);assert(cakeMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniShortcake.PrimaryPart.MeshId);assert(math.abs(select(2,cakeMini:GetBoundingBox()).Y-18/28)<.001);cakeMini:Destroy();local macaronMini=V.BuildMini(5,false);assert(macaronMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniMacaron.PrimaryPart.MeshId);assert(math.abs(select(2,macaronMini:GetBoundingBox()).Y-18/28)<.001);macaronMini:Destroy();local croissantMini=V.BuildMini(6,false);assert(croissantMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniCroissant.PrimaryPart.MeshId);assert(math.abs(select(2,croissantMini:GetBoundingBox()).Y-18/28)<.001);croissantMini:Destroy();local waffleMini=V.BuildMini(7,false);assert(waffleMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniWaffle.PrimaryPart.MeshId);assert(math.abs(select(2,waffleMini:GetBoundingBox()).Y-18/28)<.001);waffleMini:Destroy();local bingsuMini=V.BuildMini(8,false);assert(bingsuMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniBingsu.PrimaryPart.MeshId);assert(math.abs(select(2,bingsuMini:GetBoundingBox()).Y-18/28)<.001);bingsuMini:Destroy();local tiramisuMini=V.BuildMini(9,false);assert(tiramisuMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniTiramisu.PrimaryPart.MeshId);assert(math.abs(select(2,tiramisuMini:GetBoundingBox()).Y-18/28)<.001);tiramisuMini:Destroy();local madeleineMini=V.BuildMini(10,false);assert(madeleineMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniMadeleine.PrimaryPart.MeshId);assert(math.abs(select(2,madeleineMini:GetBoundingBox()).Y-18/28)<.001);madeleineMini:Destroy();local eclairMini=V.BuildMini(11,false);assert(eclairMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniEclair.PrimaryPart.MeshId);assert(math.abs(select(2,eclairMini:GetBoundingBox()).Y-18/28)<.001);eclairMini:Destroy();local pannaMini=V.BuildMini(12,false);assert(pannaMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniPannaCotta.PrimaryPart.MeshId);assert(math.abs(select(2,pannaMini:GetBoundingBox()).Y-18/28)<.001);pannaMini:Destroy();local souffleMini=V.BuildMini(13,false);assert(souffleMini.PrimaryPart.MeshId==f.DessertModelTemplates.MiniSouffle.PrimaryPart.MeshId);assert(math.abs(select(2,souffleMini:GetBoundingBox()).Y-18/28)<.001);souffleMini:Destroy();f:Destroy()
print("[DessertVariants] PASS: legacy save, 50:50",milk,galaxy,"separate merges/equip, offline production, crate identity, all imported models")

