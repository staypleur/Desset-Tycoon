-- Play client; ordinary real character contacts, no synthetic touch events.
local player=game.Players.LocalPlayer
local action=game.ReplicatedStorage.DessertRemotes.Action
local character=player.Character;local humanoid=character:FindFirstChildOfClass("Humanoid")
local root=character.HumanoidRootPart
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local pad=plot.PurchaseButtons.Buy1
local Rules=require(game.ReplicatedStorage.DessertRules)
local before=action:InvokeServer("State")
root.CFrame=pad.CFrame*CFrame.new(0,5,0)
task.wait(1.2)
local landed=action:InvokeServer("State")
assert(landed.Cash==before.Cash-Rules.BuyCost(1),"Initial landing purchases exactly one")
task.wait(.8)
local standing=action:InvokeServer("State")
assert(standing.Cash==landed.Cash,"Standing must not repeat purchases")
for n=1,3 do
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
root.CFrame=pad.CFrame*CFrame.new(0,5,-12)
print("[JumpPurchase] PASS: initial purchase, three real jumps/landings, exactly four purchases, no idle repeats")
