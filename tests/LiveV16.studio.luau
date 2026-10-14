-- Temporary server Script for Studio Play only. Accelerates production, not saves.
assert(game:GetService('RunService'):IsStudio())
local player=game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()
local invoke=game.ServerScriptService.DessertGame:WaitForChild('StudioDessertAction',20)
repeat task.wait(.2) until player.Character and player:GetAttribute('PlotId') and invoke:Invoke(player,'State')
local plot=workspace.DessertJellyIsland.PlayerPlots['Plot'..player:GetAttribute('PlotId')]
local r=player.Character:WaitForChild('HumanoidRootPart'); r.Anchored=true; r.CFrame=CFrame.new(0,100,0)
local C=require(game.ReplicatedStorage.TycoonConfig); local interval=C.ProductionInterval; C.ProductionInterval=.05
local deadline=os.clock()+40
repeat task.wait(.3) until #plot.MovingDesserts:GetChildren()==100 or os.clock()>deadline
C.ProductionInterval=interval
assert(#plot.MovingDesserts:GetChildren()==100,'Drop cap must reach exactly 100')
local afkBefore=invoke:Invoke(player,"State").AFKStored
task.wait(4)
assert(invoke:Invoke(player,"State").AFKStored>afkBefore,"Full physical tray must store overflow in AFK basket")
assert(#plot.MovingDesserts:GetChildren()==100,'Full collector must pause production')
local function call(verb,arg) return invoke:Invoke(player,verb,arg) end
r.CFrame=CFrame.new(plot.Conveyors.Collector.Position+Vector3.new(0,2,0)); task.wait(1)
local s=call('State'); assert(s.Bag>0 and s.TotalMiniCollected==s.Bag)
r.CFrame=CFrame.new(0,100,0); task.wait(4)
assert(#plot.MovingDesserts:GetChildren()>0 and #plot.MovingDesserts:GetChildren()<100,'Pickup must resume production')
local deposit=workspace.DessertJellyIsland.CentralHub.DepositPads['Deposit'..player:GetAttribute('PlotId')]
r.CFrame=CFrame.new(deposit.Position+Vector3.new(0,4,0)); assert(call('Deposit'))
s=call('State'); local credit=s.CafeQueue; assert(credit>0 and s.Pending==0)
task.wait(1); assert(call('State').Pending==0)
task.wait(1.25); s=call('State'); assert(s.Pending==2 and s.CafeQueue==credit-2 and s.TotalCashEarned==2)
assert(not call('Collect'),'Bank distance validation')
r.CFrame=CFrame.new(plot.PersonalShopArea.CollectIncome.Position+Vector3.new(0,4,0)); assert(call('Collect'))
s=call('State'); assert(s.Pending==0 and s.Cash==2 and s.PlaySeconds>10)
local afk=call("State").AFKStored
r.CFrame=CFrame.new(plot.DessertBaskets.AFKAnchor.Position+Vector3.new(0,2,0)); task.wait(.4)
s=call("State"); assert(afk>0 and s.AFKStored==0 and s.Bag>=afk,"Owner proximity must collect AFK storage")
r.Anchored=false
print('[LiveV16] PASS: 100 physical object cap, counted AFK overflow/pickup/resume, counted collection statistics, delayed fixed throughput, conserved sale queue, owner bank distance and persistent session counters')
script:Destroy()
