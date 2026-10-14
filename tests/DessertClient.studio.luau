-- Run from the CLIENT Command Bar during Play. Input/HUD requests must not block buttons.
local action=game.ReplicatedStorage:WaitForChild("DessertRemotes").Action
assert(action:InvokeServer("Activity"))
assert(action:InvokeServer("Settings",{Music=false,Effects=true,HideOthers=false}))
task.wait(.6)
local state=action:InvokeServer("State")
assert(state.Settings.Music==false)
task.wait(.3)
local other=require(game.ReplicatedStorage.DessertVisuals).Build(1,false)
other.Name="DessertCompanion"; other:SetAttribute("OwnerUserId",999999999); other.Parent=workspace
assert(action:InvokeServer("Settings",{Music=true,Effects=true,HideOthers=true}))
task.wait(2.5)
assert(other.PrimaryPart.LocalTransparencyModifier==1,"Other pet should hide")
assert(workspace.DessertJellyIsland.PlayerPlots.Plot2.PlotFloor.LocalTransparencyModifier==0,"Plot floors must remain visible")
assert(action:InvokeServer("Settings",{Music=true,Effects=true,HideOthers=false}))
task.wait(.6); assert(other.PrimaryPart.LocalTransparencyModifier==0); other:Destroy()
print("[DessertClientTest] PASS: activity/UI actions, other pet visibility toggle, plot floors preserved")
