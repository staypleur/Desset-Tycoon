-- Server Command Bar in a fresh Studio Play session; uses temporary session cash only.
local player=game.Players:GetPlayers()[1]
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local invoke=game.ServerScriptService.DessertGame:WaitForChild("StudioDessertAction")
local UI=require(game.ReplicatedStorage.DessertUI)
local function state() return invoke:Invoke(player,"State") end
local function verify()
	local d=state()
	for _,count in ipairs({1,10,100,1000}) do
		local pad=plot.PurchaseButtons["Buy"..count]; local affordable=d.Cash>=count*5
		assert(pad:GetAttribute("Affordable")==affordable and pad.Color==(affordable and UI.Green or UI.Red),"Purchase color must reflect current wallet")
		assert(pad:GetAttribute("Cost")==count*5 and pad.ActionSign:FindFirstChild("BubbleCard"))
	end
	local pad=plot.PersonalShopArea.UpgradeConverter
	assert(pad:GetAttribute("Affordable")== (d.Cash>=d.CafeUpgradeCost and d.CafeLevel<18))
end
verify(); assert(state().Cash==25)
assert(plot.PurchaseButtons.Buy1.Color==UI.Green and plot.PurchaseButtons.Buy10.Color==UI.Red)
-- Standing on the upgrade pad spends all 25 cash and must immediately turn Buy1 red.
player.Character:PivotTo(CFrame.new(plot.PersonalShopArea.UpgradeConverter.Position+Vector3.new(0,4,0)))
task.wait(1); assert(state().Cash==0 and state().CafeLevel==1); verify()
for _,p in ipairs(workspace.DessertJellyIsland.PlayerPlots:GetChildren()) do
	for _,d in ipairs(p.PersonalShopArea:GetDescendants()) do assert(d.Name~="BuildingSign" and not d.Name:find("Alphabet_"),"Building signage must be removed") end
end
print("[DessertUITest] PASS: green/red price thresholds, immediate update after spending, upgrade cost, styled bubbles and removed signs")
