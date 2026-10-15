-- Edit mode after importing the two approved templates.
local module=game.ReplicatedStorage.DessertVisuals:Clone(); module.Parent=game.ReplicatedStorage
local V=require(module)
for _,mini in ipairs({false,true}) do
 for _,shiny in ipairs({false,true}) do
  local m=mini and V.BuildMini(1,shiny) or V.Build(1,shiny)
  local expected=game.ReplicatedStorage.DessertModelTemplates[mini and "MiniPudding" or "NormalPudding"]
  assert(m.PrimaryPart:IsA("MeshPart") and m.PrimaryPart.MeshId==expected.PrimaryPart.MeshId)
  local box,size=m:GetBoundingBox()
  assert(math.abs(size.Y-(mini and 18/28 or 5))<.001,"Imported height")
  assert((box.Position-Vector3.new(0,size.Y/2,0)).Magnitude<.001,"Bottom-center origin")
  assert(m:GetAttribute("Shiny")==shiny)
  for _,part in ipairs(m:GetDescendants()) do
   assert(not part:IsA("LuaSourceContainer") and not part:IsA("PackageLink"))
   if part:IsA("BasePart") then assert(part.Anchored and not part.CanCollide and not part.CanTouch and not part.CanQuery) end
  end
  m:ScaleTo(m:GetScale()*.65);local _,scaled=m:GetBoundingBox()
  assert(math.abs(scaled.Y-size.Y*.65)<.001,"Companion relative scale")
  m:Destroy()
 end
end
for tier=2,30 do
 local normal=V.Build(tier,false);local mini=V.BuildMini(tier,false)
 local _,a=normal:GetBoundingBox();local _,b=mini:GetBoundingBox()
 -- Roblox clamps very small primitive dimensions to 0.05 studs.
 assert((a*.125-b).Magnitude<.06,"Other tier mini scale")
 normal:Destroy();mini:Destroy()
end
module:Destroy()
print("[PuddingModels] PASS: both imported meshes, heights, bottom pivots, shiny variants, companion scale, other 29 tiers")
