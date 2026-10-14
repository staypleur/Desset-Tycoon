-- One decorative, anchored chef. No humanoid physics, economic actions or per-frame path searches.
local Tween=game:GetService("TweenService")
local Nav=require(game.ReplicatedStorage.CafeChefNavigation)
local island=workspace:WaitForChild("DessertJellyIsland")
local cafe=island:WaitForChild("CentralHub"):WaitForChild("CentralShop")
local chef=cafe:FindFirstChild("CafeChef")
if not chef then
 local template=game.ServerStorage:FindFirstChild("CafeChefTemplate")
 if not template then warn("[CafeChef] User model missing");return end
 chef=template:Clone();chef.Name="CafeChef";chef.Parent=cafe
end
local mesh=chef.PrimaryPart
assert(mesh and mesh:IsA("MeshPart"),"Chef mesh missing")
local graph=Nav.Build(cafe,chef)
if #graph.Points<2 then warn("[CafeChef] No clear walking area");return end
local current=graph.Points[1]
for _,n in ipairs(graph.Points) do if (n.Position-chef:GetPivot().Position).Magnitude<(current.Position-chef:GetPivot().Position).Magnitude then current=n end end
chef:PivotTo(CFrame.new(current.Position))
chef:SetAttribute("NavigationPoints",#graph.Points)
local controller=chef:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController",chef)
local animator=controller:FindFirstChildOfClass("Animator") or Instance.new("Animator",controller)
local animation=chef:FindFirstChild("Walking")
local track
if animation then
 local ok,result=pcall(animator.LoadAnimation,animator,animation)
 if ok then track=result;track.Looped=true;track.Priority=Enum.AnimationPriority.Movement else warn("[CafeChef] Walking clip failed",result) end
end
local rng=Random.new()
local speed=chef:GetAttribute("WalkSpeed") or 6
local function move(target)
 local foot=chef:GetPivot();local destination=target.Position
 local facing=CFrame.lookAt(foot.Position,destination)
 if foot.LookVector:Dot(facing.LookVector)<.995 then
  local turn=Tween:Create(mesh,TweenInfo.new(.12),{CFrame=facing*mesh.PivotOffset:Inverse()})
  turn:Play();turn.Completed:Wait()
 end
 local distance=(destination-foot.Position).Magnitude
 local tween=Tween:Create(mesh,TweenInfo.new(distance/speed,Enum.EasingStyle.Linear),{CFrame=(facing-facing.Position+destination)*mesh.PivotOffset:Inverse()})
 tween:Play();tween.Completed:Wait()
 current=target;chef:SetAttribute("StepsWalked",(chef:GetAttribute("StepsWalked") or 0)+1)
end
print("[CafeChef] Ready: one chef, "..#graph.Points.." safe navigation points")
while chef.Parent do
 local destination=graph.Points[rng:NextInteger(1,#graph.Points)]
 local route=Nav.Route(current,destination)
 if #route>0 then
  chef:SetAttribute("Walking",true)
  if track then track:Play(.2,1,chef:GetAttribute("WalkAnimationSpeed") or 1.15) end
  for _,node in ipairs(route) do if not chef.Parent then break end;move(node) end
  if track then track:Stop(.25) end
  chef:SetAttribute("Walking",false)
 end
 task.wait(rng:NextNumber(.6,1.5))
end
