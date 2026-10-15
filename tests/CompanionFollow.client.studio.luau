-- Play client: verify actual companion render motion while the avatar walks.
local player=game.Players.LocalPlayer
local action=game.ReplicatedStorage.DessertRemotes.Action
local before=action:InvokeServer("State")
if before.Equipped then assert(action:InvokeServer("Equip",before.Equipped)) end
assert(action:InvokeServer("Equip","1n"));task.wait(.5)
local companion=workspace:WaitForChild("DessertCompanion")
local character=player.Character
local root=character.HumanoidRootPart
local humanoid=character:FindFirstChildOfClass("Humanoid")
local run=game:GetService("RunService")
local start=root.Position
local last=companion:GetPivot()
local moving,changed,maxStep=0,0,0
run:BindToRenderStep("CompanionFollowTestWalk",Enum.RenderPriority.Input.Value+1,function()
 humanoid:Move(Vector3.new(1,0,0),false)
end)
run:BindToRenderStep("CompanionFollowTestSample",Enum.RenderPriority.Last.Value,function()
 local current=companion:GetPivot();local step=(current.Position-last.Position).Magnitude
 if root.AssemblyLinearVelocity.Magnitude>5 then
  moving+=1;if step>.0001 then changed+=1 end
  maxStep=math.max(maxStep,step)
 end
 last=current
end)
task.wait(4)
run:UnbindFromRenderStep("CompanionFollowTestWalk")
run:UnbindFromRenderStep("CompanionFollowTestSample")
humanoid:Move(Vector3.zero,false)
assert((root.Position-start).Magnitude>10,"Avatar must actually walk")
assert(moving>25 and changed/moving>.95,"Companion must move every render frame, not 10 Hz")
assert(maxStep<2,"No large follow jumps")
task.wait(.7)
local relative=root.CFrame:PointToObjectSpace(companion:GetPivot().Position)
assert(math.abs(relative.X+3)<.3 and math.abs(relative.Z-2)<.3,"Same lateral offset, two studs behind")
assert(relative.Y>2.5 and relative.Y<3.5,"Same hover height")
local _,size=companion:GetBoundingBox();assert(math.abs(size.Y-3.25)<.001,"Double sized equipped pudding")
-- A teleport should catch up promptly rather than drift across the entire map.
root.CFrame+=Vector3.new(60,0,0);task.wait(.3)
assert((companion:GetPivot().Position-root.Position).Magnitude<8,"Teleport recovery")
assert(action:InvokeServer("Equip","1n"));task.wait(.3)
assert(not workspace:FindFirstChild("DessertCompanion"),"Unequip removes the tracked model")
if before.Equipped then assert(action:InvokeServer("Equip",before.Equipped)) end
print("[CompanionFollow] PASS: moving render frames",changed,"/",moving,"max step",maxStep,"double size, teleport, unequip")
