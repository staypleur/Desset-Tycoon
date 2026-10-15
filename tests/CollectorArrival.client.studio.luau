-- Fresh Play, wait at least 25 seconds without standing near the owner's collector.
local player=game.Players.LocalPlayer
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local tray=plot.Conveyors.Collector
local checked=0
for _,model in ipairs(plot.MovingDesserts:GetChildren()) do
	if workspace:GetServerTimeNow()-model:GetAttribute("DropStartTime")>15 then
		local p=tray.CFrame:PointToObjectSpace(model.PrimaryPart.Position)
		assert(math.abs(p.X)<tray.Size.X/2-.3 and math.abs(p.Z)<tray.Size.Z/2-.3,"Every older real production drop must be inside the white collector")
		assert(p.Y>0 and p.Y<3,"On the tray, not below or launched above it")
		checked+=1
	end
end
assert(checked>=3,"Observe several actual production cycles")
print("[CollectorArrival] PASS: all",checked,"older actual production drops inside white tray")
