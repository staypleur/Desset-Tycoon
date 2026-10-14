local island=workspace.DessertJellyIsland
assert(island:GetAttribute("ProductionPlotVersion")==1)
assert(#island.CentralHub.CentralDisplay:GetChildren()==0)
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]; local cf=plot:GetPivot()
	assert(plot.PlotFloor.Size==Vector3.new(96,1,120))
	assert(#plot.PetSpawnPads:GetChildren()==60)
	local left,right=0,0
	for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do
		assert(pad.Shape==Enum.PartType.Cylinder)
		assert(pad:GetAttribute("Row")>=1 and pad:GetAttribute("Row")<=5)
		assert(pad:GetAttribute("Column")>=1 and pad:GetAttribute("Column")<=6)
		if pad:GetAttribute("Side")=="Left" then left+=1 else right+=1 end
	end
	assert(left==30 and right==30)
	local function ray(p,x,z)
		local rp=RaycastParams.new(); rp.FilterType=Enum.RaycastFilterType.Include; rp.FilterDescendantsInstances={p}
		return workspace:Raycast(cf:PointToWorldSpace(Vector3.new(x,20,z)),Vector3.new(0,-30,0),rp)
	end
	local slopes=0
	for _,s in ipairs(plot.Conveyors:GetChildren()) do if s.Name=="FeedSlope" then
		slopes+=1; local pos=cf:PointToObjectSpace(s.Position); local side=pos.X<0 and -1 or 1
		local outer,inner=ray(s,side*42,pos.Z),ray(s,side*6,pos.Z)
		assert(outer and inner and outer.Position.Y>inner.Position.Y+.8)
	end end
	assert(slopes==10)
	local front,back=ray(plot.Conveyors.MainBelt,0,-5),ray(plot.Conveyors.MainBelt,0,53)
	assert(front and back and back.Position.Y>front.Position.Y+.5,"Center must descend toward cafe")
	for _,count in ipairs({1,10,100,1000}) do assert(plot.PurchaseButtons["Buy"..count]) end
	for _,p in ipairs(plot:GetDescendants()) do
		if p:IsA("Part") or p:IsA("WedgePart") then
			for _,face in ipairs({"Top","Bottom","Left","Right","Front","Back"}) do assert(p[face.."Surface"]==Enum.SurfaceType.Studs,p.Name) end
		end
	end
end
print("[ProductionPlotTest] PASS: six 60-plate plots, inward side ramps, center descent, classic surfaces, buy pads and reserved center")
