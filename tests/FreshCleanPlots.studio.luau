-- Verify fresh, empty plots with an existing reusable cafe template.
assert(not game:GetService("RunService"):IsRunning(),"Stop Play first")
local fixture=workspace.DessertJellyIsland:Clone()
local storage=Instance.new("Folder")
local template=game.ServerStorage.CentralCafeTemplate:Clone(); template.Parent=storage
local ok,err=xpcall(function()
	fixture:SetAttribute("CleanPlotLayoutVersion",nil)
	fixture.PlayerPlots:ClearAllChildren()
	fixture.CentralHub.CentralShop:Destroy()
	local shop=template.CentralShop:Clone(); shop.Parent=fixture.CentralHub
	local pudding=template.GiantPudding:Clone(); pudding.Parent=fixture.CentralHub
	for i=1,6 do
		local plot=Instance.new("Model"); plot.Name,plot.Parent="Plot"..i,fixture.PlayerPlots
		plot.WorldPivot=CFrame.new(0,.85,0)
	end
	local run=assert(loadstring(game.ReplicatedStorage.TycoonPlotLayout.Source))
	local env=setmetatable({game={ServerStorage=storage}},{__index=getfenv()})
	setfenv(run,env)
	run().Apply(fixture)
	assert(fixture.CentralHub.CentralShop:FindFirstChild("CenterAnchor"))
	assert(not fixture.CentralHub:FindFirstChild("GiantPudding"))
	for _,plot in ipairs(fixture.PlayerPlots:GetChildren()) do
		assert(plot.PlotFloor.Size==Vector3.new(96,1,120))
		assert(plot.PersonalShopArea.DessertCafe.CafeBuilding)
		assert(#plot.PetSpawnPads:GetChildren()==60)
	end
end,debug.traceback)
fixture:Destroy(); storage:Destroy()
assert(ok,err)
print("[FreshCleanPlots] PASS: fresh empty plots, template reuse, six cafes and reserved center")
