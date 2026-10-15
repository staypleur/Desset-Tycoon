-- Play client; ordinary real character contacts, no synthetic touch events.
local player=game.Players.LocalPlayer
local action=game.ReplicatedStorage.DessertRemotes.Action
local character=player.Character;local humanoid=character:FindFirstChildOfClass("Humanoid")
local root=character.HumanoidRootPart
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local pad=plot.PurchaseButtons.Buy1
local Rules=require(game.ReplicatedStorage.DessertRules)
local home=pad.CFrame
local before=action:InvokeServer("State")
root.CFrame=pad.CFrame*CFrame.new(0,5,0)
task.wait(1.2)
local landed=action:InvokeServer("State")
assert(landed.Cash==before.Cash-Rules.BuyCost(1),"Initial landing purchases exactly one")
task.wait(.8)
local standing=action:InvokeServer("State")
assert(standing.Cash==landed.Cash,"Standing must not repeat purchases")
-- Walk between interior points (including the edges) without ever leaving the pad.
for _,offset in ipairs({Vector3.new(4,0,0),Vector3.new(-4,0,0),Vector3.new(0,0,2),Vector3.new(0,0,-2),Vector3.zero}) do
 humanoid:MoveTo((home*CFrame.new(offset)).Position+Vector3.new(0,3.6,0))
 task.wait(.65)
 assert(action:InvokeServer("State").Cash==standing.Cash,"Walking on pad must not re-arm")
end
humanoid:Move(Vector3.zero)
for n=1,8 do
 humanoid.Jump=true
 local start=os.clock()
 repeat task.wait(.03) until humanoid.FloorMaterial==Enum.Material.Air or os.clock()-start>1
 assert(humanoid.FloorMaterial==Enum.Material.Air,"Actual jump")
 repeat task.wait(.03) until humanoid.FloorMaterial~=Enum.Material.Air or os.clock()-start>3
 task.wait(.3)
 local after=action:InvokeServer("State")
 assert(after.Cash==standing.Cash-Rules.BuyCost(1),"One additional purchase for landing "..n)
 standing=after
end
task.wait(.8)
assert(action:InvokeServer("State").Cash==standing.Cash,"No idle repeat after jumps")
assert(pad.CFrame:FuzzyEq(home,.0001),"Press animation restores the original position without drift")
local head=pad.ButtonTop:FindFirstChildWhichIsA("BasePart",true);assert((head.Position-pad.Position).Magnitude<.001,"Visible top remains attached")
root.CFrame=pad.CFrame*CFrame.new(0,5,-12)
print("[JumpPurchase] PASS: initial purchase, walking/edge movement without re-buy, eight actual landings, no idle repeat or pad drift")
