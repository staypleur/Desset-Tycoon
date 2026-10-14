-- Edit-mode geometry checks for the approved v14 design.
local island=workspace.DessertJellyIsland
assert(island:GetAttribute('ReferenceStyleVersion')==1)
local cafe=island.CentralHub.CentralShop.CafeArchitecture
assert(cafe:GetAttribute('OpenCounter') and cafe.CircularCounter and cafe.SuspendedCanopy)
assert(cafe.FreeCoffeeMachine:GetAttribute('SourceAssetId')==12520208389)
local cakeBase=cafe.FacelessRoofCake:GetChildren()[1]
assert(cakeBase.Size.Y>=58 and math.abs(cakeBase.CFrame.RightVector.Y)>.99,'Roof cake must be wide and upright')
assert(cafe.CafeMultiplierAnchor.Position.Y>cakeBase.Position.Y+10)
local pendants=0
for _,d in ipairs(cafe:GetDescendants()) do if d.Name=='WarmPendant' then pendants+=1 end end
assert(pendants==40)
assert(game.Lighting.FreePinkSky:GetAttribute('SourceAssetId')==107689530722174)
local function ray(part,x,z)
 local cf=part.Parent.Parent:GetPivot(); local origin=(cf*CFrame.new(x,30,z)).Position
 local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Include; params.FilterDescendantsInstances={part}
 local hit=workspace:Raycast(origin,Vector3.new(0,-60,0),params); assert(hit,part.Name)
 return hit.Position.Y
end
for i=1,6 do
 local plot=island.PlayerPlots['Plot'..i]; local cf=plot:GetPivot()
 assert(#plot.PetSpawnPads:GetChildren()==60 and plot:GetAttribute('FieldRise')==5.5)
 assert(plot.PetSpawnPads.PetPad25.Position.Y>plot.PetSpawnPads.PetPad1.Position.Y+3.9)
 local belt=plot.Conveyors.MainBelt
 assert(belt.Color==Color3.fromRGB(255,228,150),'All slopes must be yellow')
 assert(ray(belt,0,53)>ray(belt,0,-5)+5,'Center channel must descend to tray')
 for _,slope in ipairs(plot.Conveyors:GetChildren()) do if slope.Name=='FeedSlope' then
  assert(slope.Color==belt.Color)
  local pos=cf:PointToObjectSpace(slope.Position); local side=pos.X<0 and -1 or 1
  assert(ray(slope,side*54,pos.Z)>ray(slope,side*6,pos.Z)+1,'Side lane must descend toward center')
 end end
 for n,count in ipairs({1,10,100,1000}) do
  local p=plot.PurchaseButtons['Buy'..count]; local pos=cf:PointToObjectSpace(p.Position)
  assert(math.abs(pos.Z+11)<.01 and math.abs(pos.X-({-44,-22,22,44})[n])<.01)
  assert(p.ButtonTop:GetAttribute('SourceAssetId')==12528362526 and p.ActionSign.PriceLabel)
 end
 local area=plot.PersonalShopArea
 assert(area.RobuxShop.Transparency==1 and not area.RobuxShop:FindFirstChild('ButtonTop'))
 assert(area.NormalChest:GetAttribute('SourceAssetId')==8600350858 and area.PerkChest)
 assert(#plot.WhitePicketFence:GetChildren()>=18)
 assert(area.ShopBuilding.RoofWord:GetAttribute('Text')=='SHOP' and area.BankBuilding.RoofWord:GetAttribute('Text')=='BANK')
end
for _,m in ipairs(game.ServerStorage.FreeDesignSources:GetChildren()) do
 for _,d in ipairs(m:GetDescendants()) do assert(not d:IsA('LuaSourceContainer'),'Free decoration must contain no code') end
end
print('[ReferenceStyleTest] PASS: open cafe, 40 lights, approved props/sky/fences, 360 raised plates, inward side slopes, downhill center, horizontal pads and roof words')
