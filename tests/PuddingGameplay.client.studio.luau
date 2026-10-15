-- Play client, fresh Studio profile with the free starting pudding.
local player=game.Players.LocalPlayer
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local templates=game.ReplicatedStorage.DessertModelTemplates
local action=game.ReplicatedStorage.DessertRemotes.Action
local producer=plot.ActiveDesserts:WaitForChild("Dessert1")
assert(producer.PrimaryPart.MeshId==templates.NormalPudding.PrimaryPart.MeshId)
assert(#plot.MovingDesserts:GetChildren()<=100)
local mini=plot.MovingDesserts:FindFirstChild("MiniDessert")
assert(mini and mini.PrimaryPart.MeshId==templates.MiniPudding.PrimaryPart.MeshId)
local _,size=mini:GetBoundingBox();assert(math.abs(size.Y-18/28)<.001)
assert(action:InvokeServer("Equip","1n"));task.wait(.5)
local companion=workspace:FindFirstChild("DessertCompanion")
assert(companion and companion.PrimaryPart.MeshId==templates.NormalPudding.PrimaryPart.MeshId)
local _,petSize=companion:GetBoundingBox();assert(math.abs(petSize.Y-1.625)<.001)
assert(action:InvokeServer("Equip","1n"));task.wait(.5)
assert(not workspace:FindFirstChild("DessertCompanion"),"Unequip toggle")
local before=action:InvokeServer("State")
local root=player.Character.HumanoidRootPart
root.CFrame=CFrame.new(mini:GetPivot().Position+Vector3.new(0,2,0))
task.wait(2)
local after=action:InvokeServer("State")
assert(after.TotalMiniCollected>before.TotalMiniCollected,"Owner pickup must still credit the server profile")
print("[PuddingGameplay] PASS: producer, face-free drops, 100 cap, equip/unequip, companion scale, server pickup credit")
