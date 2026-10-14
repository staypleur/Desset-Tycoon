-- Presentation refinements applied after the approved v14 layout.
local Presentation={}
local boundPanels=setmetatable({},{__mode='k'})
local function bounds(m)
 local lo=Vector3.new(math.huge,math.huge,math.huge); local hi=-lo
 for _,p in ipairs(m:GetDescendants()) do if p:IsA('BasePart') then
  local c=p.CFrame; local s=p.Size/2
  local e=Vector3.new(math.abs(c.RightVector.X)*s.X+math.abs(c.UpVector.X)*s.Y+math.abs(c.LookVector.X)*s.Z,math.abs(c.RightVector.Y)*s.X+math.abs(c.UpVector.Y)*s.Y+math.abs(c.LookVector.Y)*s.Z,math.abs(c.RightVector.Z)*s.X+math.abs(c.UpVector.Z)*s.Y+math.abs(c.LookVector.Z)*s.Z)
  lo=lo:Min(p.Position-e); hi=hi:Max(p.Position+e)
 end end
 return (lo+hi)/2,hi-lo,lo
end
local function prop(source,parent,name,cf,width)
 assert(source,'Missing approved source: '..name)
 local m=Instance.new('Model'); m.Name=name; source:Clone().Parent=m
 for _,d in ipairs(m:GetDescendants()) do
  assert(not d:IsA('LuaSourceContainer') and not d:IsA('PackageLink'),'Unclean decorative source')
  if d:IsA('BasePart') then d.Anchored=true; d.CanTouch=false; d.CanCollide=false end
 end
 local _,s=bounds(m); m:ScaleTo(width/math.max(s.X,s.Z))
 local center,_,lo=bounds(m); local anchor=Vector3.new(center.X,lo.Y,center.Z)
 m:PivotTo(cf*CFrame.new(-anchor)*m:GetPivot())
 m:SetAttribute('SourceAssetId',source:GetAttribute('SourceAssetId')); m:SetAttribute('DecorationOnly',true); m.Parent=parent
 return m
end
local function bindOwner(panel,plot)
 if boundPanels[panel] then return end; boundPanels[panel]=true
 local function update()
  local id=plot:GetAttribute('OwnerUserId') or 0; local name=plot:GetAttribute('OwnerName') or ''
  for _,g in ipairs(panel:GetChildren()) do if g:IsA('SurfaceGui') then
   g.OwnerFace.Image=id>0 and ('rbxthumb://type=AvatarHeadShot&id='..id..'&w=420&h=420') or ''; g.OwnerName.Text=name
  end end
 end
 update(); plot:GetAttributeChangedSignal('OwnerUserId'):Connect(update); plot:GetAttributeChangedSignal('OwnerName'):Connect(update)
end
local function ownerBoard(source,area,plot,cf)
 local m=prop(source,area,'OwnerBoard',cf,9)
 -- Retain the selected free frame; replace its artwork with two readable owner faces.
 for _,d in ipairs(m:GetDescendants()) do if d:IsA('Decal') or d:IsA('SurfaceGui') then d:Destroy() end end
 local panel=m:FindFirstChild('Decal',true)
 if not panel or not panel:IsA('BasePart') then
  panel=Instance.new('Part'); panel.Name='OwnerPanel'; panel.Size=Vector3.new(6.8,5.4,.14); panel.CFrame=cf*CFrame.new(0,4.2,0)
  panel.Anchored=true; panel.CanCollide=false; panel.CanTouch=false; panel.Color=Color3.fromRGB(255,245,237); panel.Parent=m
 end
 for _,face in ipairs({Enum.NormalId.Front,Enum.NormalId.Back}) do
  local gui=Instance.new('SurfaceGui'); gui.Name=face.Name..'Owner'; gui.Face=face; gui.CanvasSize=Vector2.new(480,360); gui.LightInfluence=0; gui.Parent=panel
  local portrait=Instance.new('ImageLabel'); portrait.Name='OwnerFace'; portrait.Size=UDim2.fromOffset(235,235); portrait.Position=UDim2.fromOffset(122,12); portrait.BackgroundTransparency=1; portrait.Parent=gui
  local label=Instance.new('TextLabel'); label.Name='OwnerName'; label.Size=UDim2.new(1,-24,0,86); label.Position=UDim2.fromOffset(12,260); label.BackgroundTransparency=1; label.Font=Enum.Font.FredokaOne
  label.TextScaled=true; label.TextColor3=Color3.fromRGB(103,58,87); label.Text=''; label.Parent=gui
  local limit=Instance.new('UITextSizeConstraint'); limit.MaxTextSize=36; limit.MinTextSize=12; limit.Parent=label
 end
 bindOwner(panel,plot)
end
local palette={Color3.fromRGB(180,231,208),Color3.fromRGB(255,194,211),Color3.fromRGB(207,190,244),Color3.fromRGB(255,220,169),Color3.fromRGB(186,220,246),Color3.fromRGB(249,240,202)}
local function colorTree(tree,n)
 for _,p in ipairs(tree:GetDescendants()) do if p:IsA('BasePart') and (p.Name:lower():find('canopy') or p.Name:lower():find('leav')) then
  p.Color=palette[(n-1)%#palette+1]; if p:IsA('MeshPart') then p.TextureID='' end
  local appearance=p:FindFirstChildOfClass('SurfaceAppearance'); if appearance then appearance:Destroy() end
 end end
end
local function roofCake(island,sources)
 local architecture=island.CentralHub.CentralShop.CafeArchitecture; local c=architecture.CafeFloor.Position; local center=Vector3.new(c.X,0,c.Z)
 local old=architecture:FindFirstChild('FacelessRoofCake'); if old then old:Destroy() end
 local cake=prop(sources.BirthdayCake,architecture,'FacelessRoofCake',CFrame.new(center+Vector3.new(0,14.3,0)),60)
 cake:SetAttribute('SourceName','Happy Birthday Cake'); cake:SetAttribute('SourceCreator','Marko97_IT')
 local cakeCenter,cakeSize=bounds(cake); architecture.CafeMultiplierAnchor.CFrame=CFrame.new(center+Vector3.new(0,cakeCenter.Y+cakeSize.Y/2+5,0))
end
local function faceChestsIntoPlots(island)
 for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
  local chest=plot.PersonalShopArea:FindFirstChild('NormalChest')
  if chest and not chest:GetAttribute('FacingIntoPlot') then
   local center=chest:GetBoundingBox().Position
   chest:PivotTo(CFrame.new(center)*CFrame.Angles(0,math.pi,0)*CFrame.new(-center)*chest:GetPivot())
   chest:SetAttribute('FacingIntoPlot',true)
  end
 end
end
function Presentation.Apply(island)
 for _,g in ipairs(island:GetDescendants()) do if g:IsA('BillboardGui') then
  local t=g:FindFirstChildWhichIsA('TextLabel',true); if t and t.Text:lower():find('welcome') then g:Destroy() end
 end end
 local sources=game.ServerStorage:FindFirstChild('FreeDesignSources')
 if not sources or not sources:FindFirstChild('BirthdayCake') then
  warn('[CleanPresentation] Approved templates are included in DessertIsland.rbxlx; presentation upgrade skipped')
  return
 end
 if (island:GetAttribute('PresentationVersion') or 0)>=1 then
  if island:GetAttribute('PresentationVersion')==1 then
   roofCake(island,sources)
   for n=1,24 do colorTree(island.FreePastelGarden['PastelTree'..n],n) end
   island:SetAttribute('PresentationVersion',2)
  end
  for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
   local board=plot.PersonalShopArea:FindFirstChild('OwnerBoard'); local gui=board and board:FindFirstChildWhichIsA('SurfaceGui',true)
   if gui then bindOwner(gui.Parent,plot) end
  end
  faceChestsIntoPlots(island)
  return
 end
 local skySource=sources and sources:FindFirstChild('CottonCandySky')
 if skySource then local template=skySource:IsA('Sky') and skySource or skySource:FindFirstChildWhichIsA('Sky',true)
  if template then
   for _,sky in ipairs(game.Lighting:GetChildren()) do if sky:IsA('Sky') then sky:Destroy() end end
   local sky=template:Clone(); sky.Name='FreeCottonCandySky'; sky:SetAttribute('SourceAssetId',10800422601); sky.Parent=game.Lighting
  end
 end
 for i=1,6 do
  local plot=island.PlayerPlots['Plot'..i]; local cf=plot:GetPivot(); local area=plot.PersonalShopArea
  local trayLabel=plot.Conveyors.Collector:FindFirstChild('ActionSign'); if trayLabel then trayLabel:Destroy() end
  local ownerLabel=plot.Entrance:FindFirstChild('ActionSign'); if ownerLabel then ownerLabel:Destroy() end
  local perk=area:FindFirstChild('PerkChest'); if perk then perk:Destroy() end
  local chest=area:FindFirstChild('NormalChest')
  if chest then local b=chest:GetBoundingBox(); local pos=(cf*CFrame.new(-57,.2,-45)).Position
   chest:PivotTo(chest:GetPivot()+Vector3.new(pos.X-b.X,0,pos.Z-b.Z))
  end
  local anchor=island.CentralHub.CratePads['Crate'..i]
  anchor.CFrame=cf*CFrame.new(-57,2.5,-45)
  local label=anchor:FindFirstChild('ActionSign'); if label then label:Destroy() end
  for _,name in ipairs({'BankBuilding','ShopBuilding'}) do
   local building=area[name]
   for _,p in ipairs(building:GetDescendants()) do if p:IsA('BasePart') and not p:FindFirstAncestor('RoofWord') then p.CanCollide=true end end
  end
  ownerBoard(sources[i%2==1 and 'OwnerBoardA' or 'OwnerBoardB'],area,plot,cf*CFrame.new(18,.2,-48))
  prop(sources.FlowerPot,area,'FreeFlowerPot',cf*CFrame.new(22,.2,-35),3.2)
  prop(sources.PottedFlowers,area,'FreePottedFlowers',cf*CFrame.new(-25,.2,-55),3.2)
 end
 local native=island:FindFirstChild('CandyGarden'); if native then native:Destroy() end
 local hub=island.CentralHub; local center=hub.CentralShop:GetPivot().Position; center=Vector3.new(center.X,0,center.Z)
 roofCake(island,sources)
 local garden=Instance.new('Model'); garden.Name='FreePastelGarden'; garden.Parent=island
 local trees=sources.StylizedTrees.Models_Trees.Models:GetChildren(); table.sort(trees,function(a,b) return a.Name<b.Name end)
 for n=1,24 do
  local a=(n-.5)*math.pi/12; local source=trees[(n-1)%#trees+1]
  local tree=prop(source,garden,'PastelTree'..n,CFrame.new(center+Vector3.new(math.sin(a)*258,.2,math.cos(a)*258)),9+n%3*2)
  tree:SetAttribute('SourceAssetId',79689531752352)
  colorTree(tree,n)
 end
 for n=1,6 do local a=(n-.5)*math.pi/3
  prop(sources[n%2==1 and 'FlowerPot' or 'PottedFlowers'],garden,'CafeFlowerPot'..n,CFrame.new(center+Vector3.new(math.sin(a)*58,.7,math.cos(a)*58)),3.8)
 end
 faceChestsIntoPlots(island)
 island:SetAttribute('PresentationVersion',2); island:SetAttribute('MapVersion','15.0.0')
end
return Presentation
