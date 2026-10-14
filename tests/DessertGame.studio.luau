-- Run from the SERVER Command Bar during Studio Play; no production debug endpoints.
assert(game:GetService("RunService"):IsStudio())
local player=game.Players:GetPlayers()[1]; assert(player and player.Character)
local invoke=game.ServerScriptService.DessertGame:WaitForChild("StudioDessertAction",10)
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local function call(verb,arg) return invoke:Invoke(player,verb,arg) end
local before=call("State"); assert(before and before.Cash==25 and before.NormalTokens==0)
local function move(part) player.Character:PivotTo(CFrame.new(part.Position+Vector3.new(0,4,0))); task.wait(.3) end
move(plot.PurchaseButtons.Buy1)
task.wait(2)
assert(call("State").Cash==20,"Holding a pressure pad must buy only once")
move(plot.PlotSpawn); move(plot.PurchaseButtons.Buy1); task.wait(2)
local state=call("State"); assert(state.Cash==15 and state.Index["2n"] or state.Index["1s"])
assert(not call("Buy",1000),"Insufficient cash must reject")
assert(not call("Purchase","Normal1"),"Missing ID must lock payments")
assert(not call("Crate",{Kind="Normal",Count=1}),"No early free crate")
assert(call("Equip","1n")); assert(workspace:FindFirstChild("DessertCompanion"))
task.wait(4)
assert(#plot.MovingDesserts:GetChildren()>0,"3-second production missing")
move(plot.Conveyors.Collector); task.wait(10)
local bag=call("State").Bag; assert(bag>0,"Nearby pickup failed")
local hub=workspace.DessertJellyIsland.CentralHub
local deposit=hub.DepositPads["Deposit"..player:GetAttribute("PlotId")]
move(plot.PlotSpawn); assert(not call("Deposit"),"Deposit from plot must reject distance")
-- Pivot above pad and invoke immediately, before the automatic pressure-pad touch.
player.Character:PivotTo(CFrame.new(deposit.Position+Vector3.new(0,4,0)))
assert(call("Deposit")); state=call("State")
assert(state.CafeQueue>0 and state.Pending==0 and state.Bag<1,"Cafe must queue, not instantly pay")
local initialQueue=state.CafeQueue
task.wait(1); assert(call("State").Pending==0,"Full two-second cycle is required")
task.wait(1.3); state=call("State"); assert(state.Pending>0 and state.CafeQueue<initialQueue)
assert(not call("Collect"),"Collect from cafe must fail distance validation")
move(plot.PersonalShopArea.CollectIncome); assert(call("Collect"))
state=call("State"); assert(state.Cash>15 and state.Pending==0)
assert(not call("Upgrade"),"Upgrade from collection pad must reject distance")
-- Production continues while we gather enough cash for the first upgrade.
move(plot.Conveyors.Collector); task.wait(35)
player.Character:PivotTo(CFrame.new(deposit.Position+Vector3.new(0,4,0))); call("Deposit")
task.wait(12); move(plot.PersonalShopArea.CollectIncome); call("Collect")
local beforeUpgrade=call("State"); assert(beforeUpgrade.Cash>=25)
move(plot.PersonalShopArea.UpgradeConverter); task.wait(.4)
local upgraded=call("State"); assert(upgraded.CafeLevel==1 and upgraded.Cash==beforeUpgrade.Cash-25)
assert(math.abs(upgraded.CafeRate-.15)<1e-8)
local prompt=plot.PersonalShopArea.RobuxShop:FindFirstChildOfClass("ProximityPrompt")
assert(prompt and math.abs(prompt.HoldDuration-.8)<1e-6 and prompt.KeyboardKeyCode==Enum.KeyCode.E and not prompt.Parent.CanTouch)
assert(call("Settings",{Music=false,Effects=true,HideOthers=true}))
assert(call("State").Settings.Music==false)
call("Settings",{Music=true,Effects=true,HideOthers=false})
print("[DessertGameTest] PASS: owner buys, merge/production/pickup, central deposit, delayed 2s conversion, bank collection, paid cash upgrade, hold-E shop, companion/settings, locked payments")
