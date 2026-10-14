-- Run in a fresh Studio Play session, SERVER Command Bar.
local player=game.Players:GetPlayers()[1]
local plot=workspace.DessertJellyIsland.PlayerPlots['Plot'..player:GetAttribute('PlotId')]
local hub=workspace.DessertJellyIsland.CentralHub
local invoke=game.ServerScriptService.DessertGame:WaitForChild('StudioDessertAction')
local UI=require(game.ReplicatedStorage.DessertUI)
local function state() return invoke:Invoke(player,'State') end
local function verify()
 local d=state()
 for _,count in ipairs({1,10,100,1000}) do
  local pad=plot.PurchaseButtons['Buy'..count]; local affordable=d.Cash>=count*5
  assert(pad:GetAttribute('Affordable')==affordable and pad.Color==(affordable and UI.Green or UI.Red))
  assert(pad:GetAttribute('Cost')==count*5 and pad.ActionSign.PriceLabel and not pad.ActionSign:FindFirstChild('BubbleCard'))
  assert(not pad:FindFirstChildOfClass('ProximityPrompt'),'Purchase must activate by touch only')
  assert(pad.ButtonTop.Head.Color==pad.Color)
 end
end
verify(); assert(state().Cash==25)
for _,p in ipairs({plot.MergeBoard,plot.PersonalShopArea.CollectIncome,plot.PersonalShopArea.UpgradeConverter,hub.DepositPads['Deposit'..player:GetAttribute('PlotId')]}) do
 assert(not p:FindFirstChildOfClass('ProximityPrompt'))
end
player.Character:PivotTo(CFrame.new(plot.PersonalShopArea.UpgradeConverter.Position+Vector3.new(0,4,0)))
task.wait(1); assert(state().Cash==0 and state().CafeLevel==1); verify()
print('[DessertUITest] PASS: live green/red prices, free button top colors, touch-only purchase/merge/deposit/bank pads and cash upgrade')
