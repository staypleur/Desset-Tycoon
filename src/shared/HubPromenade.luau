-- Reuse the previously approved free white fence and BryanROBLOXgamer10 lamp.
local Hub={}
local function prop(source,parent,name,cf,height)
 assert(source,'Missing approved prop: '..name)
 local m=Instance.new('Model'); m.Name=name; source:Clone().Parent=m
 for _,d in ipairs(m:GetDescendants()) do
  assert(not d:IsA('LuaSourceContainer') and not d:IsA('PackageLink'),'Imported code found')
  if d:IsA('BasePart') then d.Anchored=true; d.CanTouch=false; d.CanCollide=name=='Fence'; d.CanQuery=name=='Fence'; d.CastShadow=name=='Fence' end
  if d:IsA('Beam') then d.Enabled=false end
  if d:IsA('Light') then d.Color=Color3.fromRGB(255,230,196); d.Brightness=.4; d.Range=12; d.Shadows=false end
 end
 local b,s=m:GetBoundingBox(); m:ScaleTo(m:GetScale()*height/s.Y); b,s=m:GetBoundingBox()
 m:PivotTo(cf*CFrame.new(0,s.Y/2,0)*b:ToObjectSpace(m:GetPivot()))
 m:SetAttribute('DecorationOnly',true); m.Parent=parent; return m
end
function Hub.Apply(island)
 if island:GetAttribute('PromenadeVersion')==2 then return end
 local assets=game.ServerStorage.FreeDesignSources
 local environment=game.ServerStorage.FreeEnvironmentAssets
 -- A single approved union replaces coplanar Center/Cross/corner base pieces.
 local head=assets.TycoonButtons:FindFirstChild('Head',true)
 assert(head and head:IsA('BasePart'))
 for _,pad in ipairs(island:GetDescendants()) do
  local base=pad:IsA('BasePart') and pad:FindFirstChild('ButtonBase')
  if base then
   local old=base:FindFirstChild('Cross')
   if old then
    local size,cf,color=old.Size,old.CFrame,old.Color
    local center=base:FindFirstChild('Center'); if center then size=Vector3.new(size.X,.5,center.Size.Z) end
    base:ClearAllChildren()
    local p=head:Clone(); p:ClearAllChildren(); p.Name='SingleBase'; p.Size=size; p.CFrame=cf; p.Color=color
    p.UsePartColor=true; p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.Material=Enum.Material.SmoothPlastic; p.Parent=base
    base:SetAttribute('NoCoplanarOverlap',true)
   end
  end
 end
 local landscape=island:FindFirstChild('Landscape')
 if landscape then for _,p in ipairs(landscape:GetChildren()) do if p.Name=='PathEdging' then p:Destroy() end end end
 -- Replace the earlier layout once; repeated startup must not add duplicates.
 for _,child in ipairs(island:GetChildren()) do if child.Name=='HubPromenade' then child:Destroy() end end
 local area=Instance.new('Model'); area.Name='HubPromenade'; area.Parent=island
 local cafe=island.CentralHub.CentralShop.CafeArchitecture.CafeFloor.Position
 local center=Vector3.new(cafe.X,0,cafe.Z)
 local function at(angle,radius,x,y)
  local radial=Vector3.new(math.sin(angle),0,math.cos(angle))
  return CFrame.lookAt(center+radial*radius+Vector3.new(0,y,0),center+radial*(radius+1)+Vector3.new(0,y,0))*CFrame.new(x,0,0)
 end
 for i=0,5 do
  local angle=i*math.pi/3
  for _,side in ipairs({-1,1}) do
   for _,r in ipairs({91,111}) do
    -- The approved source's lamp head extends along +X. Turn both sides inward.
    local lamp=prop(environment.StreetLamp,area,'StreetLamp',at(angle,r,side*15,.2)*CFrame.Angles(0,side==1 and math.pi or 0,0),11)
    lamp:SetAttribute('SourceAssetId',11146095708)
    lamp:SetAttribute('PathIndex',i+1); lamp:SetAttribute('PathSide',side)
   end
  end
  -- One 22-stud section per gap, rather than three at 7.5-stud spacing.
  prop(assets.WhiteFence,area,'Fence',at(angle+math.pi/6,78,0,.7)*CFrame.Angles(0,math.pi/2,0),2.7):SetAttribute('SourceAssetId',4539718362)
 end
 island:SetAttribute('PromenadeVersion',2); island:SetAttribute('MapVersion','16.1.0')
end
return Hub
