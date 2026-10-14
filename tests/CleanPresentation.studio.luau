-- Run on the actual Play server, then inspect the client HUD separately.
local island=workspace.DessertJellyIsland
assert(island:GetAttribute('PresentationVersion')==2)
assert(not island:FindFirstChild('CandyGarden'))
assert(#island.FreePastelGarden:GetChildren()==30)
local cafe=island.CentralHub.CentralShop.CafeArchitecture
assert(cafe.FacelessRoofCake:GetAttribute('SourceAssetId')==76551418404097)
assert(game.Lighting.FreeCottonCandySky:GetAttribute('SourceAssetId')==10800422601)
for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
 local area=plot.PersonalShopArea
 assert(area.NormalChest and not area:FindFirstChild('PerkChest'))
 local localChest=plot:GetPivot():PointToObjectSpace(area.NormalChest:GetBoundingBox().Position)
 assert(math.abs(localChest.X+57)<.1 and math.abs(localChest.Z+45)<.1)
 assert(not plot.Conveyors.Collector:FindFirstChild('ActionSign'))
 assert(not plot.Entrance:FindFirstChild('ActionSign'))
 for _,name in ipairs({'ShopBuilding','BankBuilding'}) do
  for _,p in ipairs(area[name]:GetDescendants()) do if p:IsA('BasePart') and not p:FindFirstAncestor('RoofWord') then assert(p.CanCollide) end end
 end
 local owner=area.OwnerBoard; local front=owner:FindFirstChild('FrontOwner',true); local back=owner:FindFirstChild('BackOwner',true)
 assert(front and back and front.Face==Enum.NormalId.Front and back.Face==Enum.NormalId.Back)
 local oldId,oldName=plot:GetAttribute('OwnerUserId'),plot:GetAttribute('OwnerName')
 plot:SetAttribute('OwnerUserId',12345); plot:SetAttribute('OwnerName','Owner Test'); task.wait()
 assert(front.OwnerName.Text=='Owner Test' and back.OwnerFace.Image:find('12345'))
 plot:SetAttribute('OwnerUserId',0); plot:SetAttribute('OwnerName',''); task.wait()
 assert(front.OwnerName.Text=='' and back.OwnerFace.Image=='')
 plot:SetAttribute('OwnerUserId',oldId); plot:SetAttribute('OwnerName',oldName); task.wait()
 assert(front.OwnerName.Text==oldName and back.OwnerName.Text==oldName)
end
local mapped={}
for service,names in pairs({
 [game.ReplicatedStorage]={'DessertCatalog','TycoonPlotLayout','IslandLandscape','ClassicPlotStyle','TycoonConfig','DessertRules','DessertVisuals','ProductionPlot','CentralCafeLayout','DessertUI','ReferenceStyle','CafeMarket','CleanPresentation','CircularGauge','KawaiiShop'},
 [game.ServerScriptService]={'DessertIsland','PlotAllocator','DessertProduction','DessertGame','PlayerProfiles'},
 [game.StarterPlayer.StarterPlayerScripts]={'DessertClient'},
}) do
 for _,name in ipairs(names) do local s=service:FindFirstChild(name); assert(s and s:IsA('LuaSourceContainer')); mapped[s]=true end
end
local count=0
for _ in pairs(mapped) do count+=1 end
for _,root in ipairs({workspace,game.ServerStorage}) do for _,s in ipairs(root:GetDescendants()) do if s:IsA('LuaSourceContainer') then
 -- Roblox injects standard Health/Animate scripts into runtime characters.
 local nativeCharacter=false
 for _,p in ipairs(game.Players:GetPlayers()) do if p.Character and s:IsDescendantOf(p.Character) then nativeCharacter=true end end
 if not nativeCharacter then assert(mapped[s], 'Unexpected decorative code: '..s:GetFullName()) end
end end end
assert(count==21)
print('[CleanPresentationTest] PASS: one chest, collisions, owner lifecycle, free sources and 21 known game scripts')
