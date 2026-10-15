-- Temporary Play server runner: all 60 slots plus a full 100-drop pile on an unowned plot.
task.wait(3)
local Physics=require(game.ServerScriptService.DessertDropPhysics)
local Visuals=require(game.ReplicatedStorage.DessertVisuals)
local plots=workspace.DessertJellyIsland.PlayerPlots
local folder=Instance.new("Folder");folder.Name="DropRouteRegression";folder.Parent=workspace
local drops={};local rng=Random.new(513);local surfaces={}
for plotIndex=1,6 do
	local plot=plots["Plot"..plotIndex]
	local query=RaycastParams.new();query.FilterType=Enum.RaycastFilterType.Include;query.FilterDescendantsInstances={plot.Conveyors};query.CollisionGroup="DessertDrops";surfaces[plot]=query
	for spawnIndex=1,(plotIndex==6 and 100 or 1) do
		local slot=plotIndex==6 and ((spawnIndex-1)%60+1) or 60
		local points,collector=Physics.Route(plot,plot.PetSpawnPads["PetPad"..slot],rng)
		local model=Visuals.BuildMini(1,false);model.Name="MiniDessert"
		model:SetAttribute("OwnerUserId",0);model:SetAttribute("DropStartTime",workspace:GetServerTimeNow())
		model:PivotTo(CFrame.new(points[1])*plot:GetPivot().Rotation)
		local d=Physics.New(model,points,folder,collector);d.Plot=plot;d.Slot=slot;table.insert(drops,d)
	end
end
local elapsed,timer=0,0;local escaped,belowSurface=0,0;local connection
connection=game:GetService("RunService").Heartbeat:Connect(function(dt)
	elapsed+=dt;timer+=dt
	if timer<.1 then return end;timer=0
	local arrived=0
	for _,d in ipairs(drops) do
		Physics.Step(d)
		local p=d.Plot:GetPivot():PointToObjectSpace(d.Body.Position)
		if d.Waypoint>2 and not Physics.InCollector(d) then
			local surface=workspace:Raycast(d.Body.Position+Vector3.new(0,20,0),Vector3.new(0,-50,0),surfaces[d.Plot])
			if surface and d.Body.Position.Y<surface.Position.Y-.15 then belowSurface+=1 end
			local onLane=math.abs(p.X)<=4.45 and p.Z>=-8.6 and p.Z<=55.5
			for _,slope in ipairs(d.Plot.Conveyors:GetChildren()) do if slope.Name=="FeedSlope" then
				local q=d.Plot:GetPivot():PointToObjectSpace(slope.Position)
				if math.abs(p.X-q.X)<=slope.Size.Z/2+.4 and math.abs(p.Z-q.Z)<=slope.Size.X/2+.4 then onLane=true end
			end end
			-- Collector edge overlaps its mouth; include the entire white tray footprint.
			local t=d.Collector.CFrame:PointToObjectSpace(d.Body.Position)
			if math.abs(t.X)<=d.Collector.Size.X/2+.2 and math.abs(t.Z)<=d.Collector.Size.Z/2+.2 then onLane=true end
			if not onLane then escaped+=1 end
		end
		if Physics.InCollector(d) and d.Settled then arrived+=1 end
	end
	if elapsed>=75 or arrived==#drops then
		connection:Disconnect()
		for _,d in ipairs(drops) do if not Physics.InCollector(d) then warn("[DropRouteStuck]",d.Plot.Name,d.Slot,d.Waypoint,d.Plot:GetPivot():PointToObjectSpace(d.Body.Position),d.Body.AssemblyLinearVelocity) end end
		print("[DropRoutes]",arrived==#drops and escaped==0 and belowSurface==0 and "PASS" or "FAIL","arrived",arrived,"/",#drops,"escaped samples",escaped,"below surface",belowSurface,"seconds",elapsed)
		folder:SetAttribute("Complete",true)
		task.delay(2,function() folder:Destroy() end)
	end
end)
