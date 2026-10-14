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
local function polishCafe(island)
 local architecture=island.CentralHub.CentralShop.CafeArchitecture
 local machine=architecture:FindFirstChild('FreeCoffeeMachine'); if machine then machine:Destroy() end
 for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
  local bank=plot.PersonalShopArea.BankBuilding
  if not bank:GetAttribute('FacingIntoPlot') then
   local word=bank:FindFirstChild('RoofWord'); local wordCF=word and word:GetPivot()
   local cf=bank:GetPivot(); bank:PivotTo(cf*CFrame.Angles(0,math.pi,0))
   if word then word:PivotTo(wordCF) end
   bank:SetAttribute('FacingIntoPlot',true)
  end
 end
 if not island:GetAttribute('CafeCounterClosed') then
  local floor=architecture.CafeFloor; local center=Vector3.new(floor.Position.X,0,floor.Position.Z)
  for _,spec in ipairs({{'CircularCounter',24,2.7},{'CounterTop',24,4.65}}) do
   local ring=architecture[spec[1]]; local template=ring:FindFirstChildWhichIsA('BasePart')
   for n=31,33 do local angle=n*math.pi/32; local radial=Vector3.new(math.sin(angle),0,math.cos(angle))
    local segment=template:Clone(); segment.CFrame=CFrame.lookAt(center+radial*spec[2]+Vector3.new(0,spec[3],0),center+radial*(spec[2]+1)+Vector3.new(0,spec[3],0)); segment.Parent=ring
   end
  end
  island:SetAttribute('CafeCounterClosed',true)
 end
 if island:GetAttribute('CafePolishVersion')==3 then return end
 if island:GetAttribute('CafePolishVersion')==2 then
  for _,bench in ipairs(island.CentralHub.CafeSeating:GetChildren()) do if bench:IsA('Model') then
   local seats={}; for _,s in ipairs(bench:GetDescendants()) do if s:IsA('Seat') then seats[s]=s.CFrame end end
   bench:PivotTo(bench:GetPivot()*CFrame.Angles(0,math.pi,0)); for s,cf in pairs(seats) do s.CFrame=cf end
  end end
  island:SetAttribute('CafePolishVersion',3); return
 end
 if island:GetAttribute('CafePolishVersion')==1 then
  for _,bench in ipairs(island.CentralHub.CafeSeating:GetChildren()) do if bench:IsA('Model') then
   local seats={}; for _,s in ipairs(bench:GetDescendants()) do if s:IsA('Seat') then seats[s]=s.CFrame end end
   for s,cf in pairs(seats) do s.CFrame=cf+Vector3.new(0,.8,0) end
  end end
  island:SetAttribute('CafePolishVersion',3); return
 end
 local hub=island.CentralHub; local cafe=hub.CentralShop.CafeArchitecture
 for _,bench in ipairs(hub.CafeSeating:GetChildren()) do
  if bench:IsA('Model') then
   local seats={}
   for _,seat in ipairs(bench:GetDescendants()) do if seat:IsA('Seat') then
    seats[seat]=seat.CFrame*CFrame.new(0,.8,-.55)
   end end
   bench:PivotTo(bench:GetPivot()*CFrame.Angles(0,math.pi,0)); for seat,cf in pairs(seats) do seat.CFrame=cf end
  end
 end
 local floor=cafe.CafeFloor
 local barrier=Instance.new('Part'); barrier.Name='CafeInteriorBarrier'
 barrier.Shape=Enum.PartType.Cylinder; barrier.Size=Vector3.new(18,56,56)
 barrier.CFrame=CFrame.new(floor.Position.X,9.6,floor.Position.Z)*CFrame.Angles(0,0,math.pi/2)
 barrier.Anchored=true; barrier.Transparency=1; barrier.CanCollide=true; barrier.CanTouch=false; barrier.CastShadow=false; barrier.Parent=cafe
 for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
  local cf=plot:GetPivot(); local spawn=plot.PlotSpawn
  spawn.Size=Vector3.new(18,.1,12); spawn.CFrame=cf*CFrame.new(0,.2,-54)
  plot.Entrance.Transparency=1; plot.Entrance.CanCollide=false; plot.Entrance.CanTouch=false; plot.Entrance.CanQuery=false
  local trim=plot.FrontTrim; trim.Size=Vector3.new(54,trim.Size.Y,trim.Size.Z)
  trim.CFrame=cf*CFrame.new(-36,.27,-59.5)
  local right=trim:Clone(); right.Name='FrontTrimRight'; right.CFrame=cf*CFrame.new(36,.27,-59.5); right.Parent=plot
 end
 island:SetAttribute('CafePolishVersion',3)
end
local function levelFood(model)
 local reference,volume=nil,0
 for _,p in ipairs(model:GetDescendants()) do if p:IsA('BasePart') then
  local v=p.Size.X*p.Size.Y*p.Size.Z; if v>volume then reference=p; volume=v end
 end end
 if not reference then return end
 local up=reference.CFrame.UpVector
 for _,axis in ipairs({reference.CFrame.RightVector,reference.CFrame.LookVector}) do if math.abs(axis.Y)>math.abs(up.Y) then up=axis end end
 if up.Y<0 then up=-up end
 local axis=up:Cross(Vector3.yAxis)
 if axis.Magnitude>.00001 then
  local center=bounds(model)
  model:PivotTo(CFrame.new(center)*CFrame.fromAxisAngle(axis.Unit,math.acos(math.clamp(up.Y,-1,1)))*CFrame.new(-center)*model:GetPivot())
 end
 model:SetAttribute('UprightFood',true)
end
local function decorateCafe(island,sources)
 local source=sources:FindFirstChild('KawaiiDisplay'); if not source then return end
 local stand=sources:FindFirstChild('PinkCakeStand'); local version=stand and 7 or 3
 if island:GetAttribute('DenseCafeVersion')==version then return end
 local cafe=island.CentralHub.CentralShop.CafeArchitecture
 local floor=cafe.CafeFloor; local center=Vector3.new(floor.Position.X,0,floor.Position.Z)
 local old=cafe:FindFirstChild('ApprovedCafeDecor'); if old then old:Destroy() end
 local decor=Instance.new('Model'); decor.Name='ApprovedCafeDecor'; decor.Parent=cafe
 local function partCount(model)
  local count=0; for _,p in ipairs(model:GetDescendants()) do if p:IsA('BasePart') then count+=1 end end; return count
 end
 -- Keep the approved shelf frame and lightweight foods; avoid cloning 50-97-part pastries.
 local lite=source:Clone(); local foods={}
 for _,item in ipairs(source:GetChildren()) do if item:IsA('Model') then
  local count=partCount(item); if count>=3 and count<=14 then table.insert(foods,item) end
 end end
 table.sort(foods,function(a,b) local ac=a:GetBoundingBox().Position; local bc=b:GetBoundingBox().Position; return ac.Y==bc.Y and ac.Z<bc.Z or ac.Y<bc.Y end)
 assert(#foods>0,'Approved lightweight desserts missing')
 for n,item in ipairs(foods) do local clone=item:Clone(); levelFood(clone); clone:SetAttribute('SourceAssetId',13702399035); foods[n]=clone end
 local replacements=0
 for _,item in ipairs(lite:GetChildren()) do if item:IsA('Model') and partCount(item)>14 then
  local pos,size,lo=bounds(item); item:Destroy(); replacements+=1
  local simple=foods[(replacements-1)%#foods+1]
  prop(simple,lite,'LitePastry'..replacements,CFrame.new(pos.X,lo.Y,pos.Z),math.max(size.X,size.Z))
 elseif item:IsA('Model') then levelFood(item) end end
 for n=0,2 do local angle=n*math.pi*2/3; local radial=Vector3.new(math.sin(angle),0,math.cos(angle))
  local pos=center+radial*12+Vector3.new(0,.85,0)
  prop(lite,decor,'KawaiiDessertDisplay'..n,CFrame.lookAt(pos,pos+radial)*CFrame.Angles(0,-math.pi/2,0),8)
  prop(sources.PottedFlowers,decor,'CafeFlowers'..n,CFrame.new(center+radial*18+Vector3.new(0,.85,0)),5)
 end
 lite:Destroy()
 -- Dense counters all around the cafe, visible from every player's route.
 for n=0,11 do local angle=(n+.5)*math.pi/6; local radial=Vector3.new(math.sin(angle),0,math.cos(angle))
  local pos=center+radial*24+Vector3.new(0,4.95,0); local cf=CFrame.lookAt(pos,pos+radial)
  local height=0
  if stand then local tray=prop(stand,decor,'PinkCakeStand'..n,cf,4.2); local _,size=bounds(tray); height=size.Y end
  for k=0,2 do
   local item=foods[(n*3+k)%#foods+1]
   prop(item,decor,'CounterDessert'..n..'_'..k,cf*CFrame.new((k-1)*1.25,height,k==1 and .65 or -.25),k==1 and 1.05 or 1.2)
  end
 end
 for _,part in ipairs(decor:GetDescendants()) do if part:IsA('BasePart') then part.CastShadow=false; part.CanCollide=false; part.CanTouch=false; part.CanQuery=false end end
 for _,item in ipairs(foods) do item:Destroy() end
 decor:SetAttribute('DecorativePartCount',partCount(decor))
 island:SetAttribute('DenseCafeVersion',version)
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
  polishCafe(island)
  decorateCafe(island,sources)
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
 polishCafe(island)
 decorateCafe(island,sources)
 island:SetAttribute('PresentationVersion',2); island:SetAttribute('MapVersion','15.0.0')
end
return Presentation
