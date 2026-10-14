-- SERVER Command Bar immediately after DessertUI test in the same Play session.
local player=game.Players:GetPlayers()[1]; local island=workspace.DessertJellyIsland
local plot=island.PlayerPlots['Plot'..player:GetAttribute('PlotId')]
local invoke=game.ServerScriptService.DessertGame.StudioDessertAction
local function state() return invoke:Invoke(player,'State') end
local function move(p) player.Character:PivotTo(CFrame.new(p.Position+Vector3.new(0,4,0))) end
assert(state().Cash==0 and state().CafeLevel==1)
local previousRate=island:GetAttribute('CafeSaleMultiplier'); local nextChange=island:GetAttribute('CafeNextSaleChange')
move(plot.Conveyors.Collector); task.wait(15)
local bag=state().Bag; assert(bag>10,'Nearby collection of raised-slope production failed')
local deposit=island.CentralHub.DepositPads['Deposit'..player:GetAttribute('PlotId')]
move(deposit)
local rate=island:GetAttribute('CafeSaleMultiplier')
assert(invoke:Invoke(player,'Deposit')); local d=state()
assert(math.abs(d.CafeQueue-bag*rate)<1e-7 and d.Bag==0 and d.Pending==0,'Current sale rate must apply to deposited units')
local total=d.CafeQueue
assert(d.CafeQueue>0); task.wait(1); assert(state().Pending==0,'No instant cash')
task.wait(5.4); d=state()
assert(d.Pending>0 and math.abs(d.CafeQueue+d.Pending-total)<1e-7,'Fractional queue must be conserved')
move(plot.PersonalShopArea.CollectIncome); task.wait(1)
local cash=state().Cash; assert(cash>=5 and state().Pending==0,'Bank touch must collect money')
move(plot.PurchaseButtons.Buy1); task.wait(1)
assert(math.abs(state().Cash-(cash-5))<1e-7,'Buy pad must spend once on touch')
task.wait(2); assert(math.abs(state().Cash-(cash-5))<1e-7,'Standing must not repeatedly purchase')
local current=island:GetAttribute('CafeSaleMultiplier'); assert(current>=.5 and current<=1.5)
if workspace:GetServerTimeNow()<nextChange then task.wait(nextChange-workspace:GetServerTimeNow()+.3) end
assert(island:GetAttribute('CafeNextSaleChange')>nextChange,'Live server market must advance every 30s')
print('[CafeLiveTest] PASS: raised production/pickup, rate-adjusted deposit, two-second fractional conversion, bank touch collection, single touch purchase and live market advance')
