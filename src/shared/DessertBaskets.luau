-- User-approved free basket by Glowziing, asset 6132018569.
local Baskets={}
function Baskets.Refresh(plot,afk,offline)
 local group=plot:FindFirstChild('DessertBaskets'); if not group then return end
 local UI=require(script.Parent.DessertUI)
 for _,item in ipairs({{'AFK',afk,'AFK Desserts'},{'Offline',offline,'Offline Desserts'}}) do
  local anchor=group[item[1]..'Anchor']; local model=group[item[1]..'Basket']
  UI.Label(anchor,item[3],UI.Format(item[2]),Color3.fromRGB(249,172,202))
  local visible=item[2]>0
  for _,part in ipairs(model:GetDescendants()) do if part:IsA('BasePart') then
   if part:GetAttribute('BasketTransparency')==nil then part:SetAttribute('BasketTransparency',part.Transparency) end
   part.Transparency=visible and part:GetAttribute('BasketTransparency') or 1
   part.CanQuery=visible
  end end
  anchor.ActionSign.Enabled=visible
  local fill=model:FindFirstChild('DessertFill')
  if fill then fill:Destroy() end
 end
end
local function basket(source,parent,name,cf)
 local m=Instance.new('Model'); m.Name=name; source:Clone().Parent=m
 for _,d in ipairs(m:GetDescendants()) do
  assert(not d:IsA('LuaSourceContainer') and not d:IsA('PackageLink'),'Unclean imported basket')
  if d:IsA('BasePart') then
   d.Anchored=true; d.CanCollide=false; d.CanTouch=false; d.Color=Color3.fromRGB(249,172,202)
   if d:IsA('MeshPart') then d.TextureID='' end
   d.Material=Enum.Material.SmoothPlastic
  elseif d:IsA('SpecialMesh') then d.TextureId=''
  elseif d:IsA('SurfaceAppearance') or d:IsA('Decal') or d:IsA('Texture') then d:Destroy() end
 end
 local box,size=m:GetBoundingBox(); m:ScaleTo(m:GetScale()*5.8/math.max(size.X,size.Z)); box,size=m:GetBoundingBox()
 -- Lower the selected mesh vertically to keep the collection aisle open visually.
 local bottom=box.Position.Y-size.Y/2
 for _,p in ipairs(m:GetDescendants()) do if p:IsA('BasePart') then
  local s=p.Size
  if math.abs(p.CFrame.RightVector.Y)>.98 then p.Size=Vector3.new(s.X*.65,s.Y,s.Z)
  elseif math.abs(p.CFrame.LookVector.Y)>.98 then p.Size=Vector3.new(s.X,s.Y,s.Z*.65)
  else p.Size=Vector3.new(s.X,s.Y*.65,s.Z) end
  p.Position=Vector3.new(p.Position.X,bottom+(p.Position.Y-bottom)*.65,p.Position.Z)
 end end
 box,size=m:GetBoundingBox(); m:PivotTo(cf*CFrame.new(0,size.Y/2,0)*box:ToObjectSpace(m:GetPivot()))
 m:SetAttribute('SourceAssetId',6132018569); m:SetAttribute('DecorationOnly',true); m.Parent=parent
end
function Baskets.Apply(island)
 -- Plot pivots face the central hub. From the entrance looking INTO the field,
 -- screen-left is positive local X. Keep the user's illustrated order.
 for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
  local cf=plot:GetPivot()
  for n,count in ipairs({1,10,100,1000}) do
   local pad=plot.PurchaseButtons['Buy'..count]; local pos=cf:PointToObjectSpace(pad.Position)
   local x=({44,22,-22,-44})[n]; local delta=cf:VectorToWorldSpace(Vector3.new(x-pos.X,0,0))
   local base=pad:FindFirstChild('ButtonBase'); if base then base:PivotTo(base:GetPivot()+delta) end
   pad.CFrame=pad.CFrame+delta
  end
 end
 if island:GetAttribute('DessertBasketVersion')==2 then
  for _,plot in ipairs(island.PlayerPlots:GetChildren()) do Baskets.Refresh(plot,0,0) end
  return
 end
 if island:GetAttribute('DessertBasketVersion')==1 then
  for _,plot in ipairs(island.PlayerPlots:GetChildren()) do local cf=plot:GetPivot(); local group=plot.DessertBaskets
   for _,item in ipairs({{'AFK',10},{'Offline',-10}}) do
    local anchor=group[item[1]..'Anchor']; local pos=cf:PointToObjectSpace(anchor.Position)
    local delta=cf:VectorToWorldSpace(Vector3.new(item[2]-pos.X,0,0))
    group[item[1]..'Basket']:PivotTo(group[item[1]..'Basket']:GetPivot()+delta); anchor.CFrame=anchor.CFrame+delta
   end
  end
  island:SetAttribute('DessertBasketVersion',2)
  for _,plot in ipairs(island.PlayerPlots:GetChildren()) do Baskets.Refresh(plot,0,0) end
  return
 end
 local assets=game.ServerStorage:FindFirstChild('FreeDesignSources')
 local source=assets and assets:FindFirstChild('OverflowBasket'); assert(source,'Approved basket template missing')
 local UI=require(script.Parent.DessertUI)
 for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
  local cf=plot:GetPivot(); local group=Instance.new('Model'); group.Name='DessertBaskets'; group.Parent=plot
  for _,item in ipairs({{10,'AFK','AFK Desserts'},{-10,'Offline','Offline Desserts'}}) do
   basket(source,group,item[2]..'Basket',cf*CFrame.new(item[1],.2,-27))
   local anchor=Instance.new('Part'); anchor.Name=item[2]..'Anchor'; anchor.Size=Vector3.one
   anchor.CFrame=cf*CFrame.new(item[1],2,-27); anchor.Transparency=1; anchor.Anchored=true; anchor.CanCollide=false; anchor.CanTouch=false; anchor.CanQuery=false; anchor.Parent=group
   local gui=Instance.new('BillboardGui'); gui.Name='ActionSign'; gui.Size=UDim2.fromOffset(150,48); gui.StudsOffset=Vector3.new(0,2.8,0); gui.MaxDistance=45; gui.Parent=anchor
   local text=Instance.new('TextLabel'); text.Text=item[3]; text.Size=UDim2.fromScale(1,1); text.BackgroundTransparency=1; text.Parent=gui
   UI.Billboard(gui); UI.Label(anchor,item[3],'0',Color3.fromRGB(249,172,202))
  end
 end
 island:SetAttribute('DessertBasketVersion',2)
 for _,plot in ipairs(island.PlayerPlots:GetChildren()) do Baskets.Refresh(plot,0,0) end
end
return Baskets
