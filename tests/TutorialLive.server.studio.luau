-- Temporary Studio-only fixture. Remove from edit place after the playtest.
assert(game:GetService("RunService"):IsStudio())
local Players=game:GetService("Players")
local p=Players:GetPlayers()[1] or Players.PlayerAdded:Wait()
local bridge=game.ServerScriptService.DessertGame:WaitForChild("StudioDessertAction",30)
local function state() return bridge:Invoke(p,"State") end
local deadline=os.clock()+45
repeat task.wait(.2) until state() or os.clock()>deadline
assert(state() and state().TutorialStep==1,"New player tutorial")
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..p:GetAttribute("PlotId")]
assert(not bridge:Invoke(p,"Buy",1000),"Bulk cannot bypass onboarding")
assert(not bridge:Invoke(p,"Merge"),"Early merge cannot skip onboarding")
local targets={plot.Conveyors.Collector,workspace.DessertJellyIsland.CentralHub.DepositPads["Deposit"..p:GetAttribute("PlotId")],plot.PersonalShopArea.CollectIncome,plot.PurchaseButtons.Buy1}
task.wait(8)
for step=1,9 do
	local d=state(); assert(d.TutorialStep==step,"Expected tutorial step "..step)
	local target=step==9 and plot.MergeBoard or targets[(step-1)%4+1]
	local char=p.Character or p.CharacterAdded:Wait();char:PivotTo(CFrame.new(target.Position+Vector3.new(0,4,0)))
	local finish=os.clock()+85
	repeat
		task.wait(.5)
		if state().TutorialStep==step and step~=1 and step~=5 then
			local verb=step==9 and "Merge" or ({"Pickup","Deposit","Collect","Buy"})[(step-1)%4+1]
			bridge:Invoke(p,verb,verb=="Buy" and 1 or nil)
		end
	until state().TutorialStep>step or os.clock()>finish
	assert(state().TutorialStep==step+1,"Tutorial stuck at "..step)
	print("TUTORIAL_LIVE_STEP",step,"->",state().TutorialStep)
end
assert(state().Index['2n'] or state().Index['2s'] or state().Index['2s2'],"Custard discovered")
print("TUTORIAL_LIVE_WAIT_EQUIP")
