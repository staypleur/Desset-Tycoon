-- Play client: real imported animation must deform the rig, not only move the mesh.
local chef=workspace.DessertJellyIsland.CentralHub.CentralShop:WaitForChild("CafeChef")
local seen=false
local startSteps=chef:GetAttribute("StepsWalked") or 0
for _=1,60 do
 for _,bone in ipairs(chef:GetDescendants()) do
  if bone:IsA("Bone") and bone.Transform~=CFrame.identity then seen=true end
 end
 task.wait(.15)
end
assert((chef:GetAttribute("StepsWalked") or 0)>startSteps,"Chef must keep moving")
assert(seen,"Walking animation must deform imported bones")
local center=workspace.DessertJellyIsland.CentralHub.CentralShop.CafeArchitecture.CafeFloor.Position
local p=chef:GetPivot().Position
assert(Vector3.new(p.X-center.X,0,p.Z-center.Z).Magnitude<=20.01)
assert(math.abs(chef.PrimaryPart.Size.Y-5.8)<.001)
assert(chef.PrimaryPart.Anchored and not chef.PrimaryPart.CanCollide and not chef.PrimaryPart.CanTouch)
print("[CafeChefClient] PASS: walking bone deformation, continuing movement, cafe boundary, player-sized anchored mesh")
