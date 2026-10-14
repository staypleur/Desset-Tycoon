-- Read-only checks for the enlarged clean layout; use in the edit-mode Command Bar.
local island=workspace.DessertJellyIsland
assert(island:GetAttribute("CleanPlotLayoutVersion")==1)
local center=island.CentralHub.CentralShop:GetPivot().Position
local plots={}
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]
	local cf=plot:GetPivot(); table.insert(plots,plot)
	assert(plot.PlotFloor.Size==Vector3.new(96,1,120))
	assert(plot.PlotFloor.TopSurface==Enum.SurfaceType.Studs and plot.PlotFloor.Material==Enum.Material.Plastic)
	assert(plot.ProductionBeds.LeftMeadow.TopSurface==Enum.SurfaceType.Studs and plot.ProductionBeds.RightMeadow.TopSurface==Enum.SurfaceType.Studs)
	assert(math.abs(Vector2.new(cf.X-center.X,cf.Z-center.Z).Magnitude-150)<.01)
	assert(#plot.ProductionBeds:GetChildren()==4,"Only two meadows and their broad steps expected")
	assert(#plot.MergeCells:GetChildren()==9 and plot.MergeBoard.Size==Vector3.new(18,.6,18))
	assert(cf:PointToObjectSpace(plot.MergeBoard.Position).X<-20,"Merge board belongs at the side")
	assert(#plot.PetSpawnPads:GetChildren()==60)
	assert(#plot.PetPadFrames:GetChildren()==60 and plot:GetAttribute("DessertCapacity")==60)
	for _,side in ipairs({"Left","Right"}) do
		local count,seen=0,{}
		for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do if pad:GetAttribute("Side")==side then
			local row,col=pad:GetAttribute("Row"),pad:GetAttribute("Column")
			assert(row>=1 and row<=6 and col>=1 and col<=5)
			local key=row..":"..col; assert(not seen[key]); seen[key]=true; count+=1
		end end
		assert(count==30,"Six by five grid per side")
	end
	for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do
		assert(pad.Transparency==0 and pad.CanCollide and pad.TopSurface==Enum.SurfaceType.Studs,"Visible classic pedestals expected")
		local pos=cf:PointToObjectSpace(pad.Position)
		assert(math.abs(pos.X)>=7.99 and math.abs(pos.X)<=39.21 and pos.Z>=3.99 and pos.Z<=50.01)
	end
	assert(#plot.Conveyors:GetChildren()==5,"Single belt, three bridges and collector only")
	assert(plot.Conveyors.MainBelt.Size.X==8)
	assert(math.abs(cf:PointToObjectSpace(plot.Conveyors.Collector.Position).Z+20)<.01)
	local cafe=plot.PersonalShopArea.DessertCafe
	assert(cf:PointToObjectSpace(cafe:GetPivot().Position).Z<-25)
	for _,part in ipairs(cafe:GetDescendants()) do
		if part:IsA("BasePart") then
			for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
				local corner=cf:PointToObjectSpace(part.CFrame:PointToWorldSpace(part.Size*Vector3.new(x,y,z)/2))
				assert(math.abs(corner.X)<48.01 and math.abs(corner.Z)<60.01,"Cafe outside enlarged floor")
			end end end
		end
	end
	-- Adjacent radial rectangles must remain separate even at their inner corners.
	for _,x in ipairs({-48,48}) do for _,z in ipairs({-60,60}) do
		local corner=cf:PointToWorldSpace(Vector3.new(x,0,z))
		assert(Vector2.new(corner.X,corner.Z).Magnitude<230,"Plot leaves floating island")
		for j=1,6 do if j~=i then
			local other=island.PlayerPlots["Plot"..j]:GetPivot():PointToObjectSpace(corner)
			assert(math.abs(other.X)>48 or math.abs(other.Z)>60,"Adjacent plots overlap")
		end end
	end end
end
for _,p in ipairs(island:GetDescendants()) do
	if p:IsA("TextLabel") then assert(not p.Text:match("[\234-\237][\128-\191][\128-\191]"),"Non-English game label") end
end
print("[CleanPlotTest] PASS: six spacious bases, isolated side boards, open meadows, visible sixty-slot grid, wide belt, cafe bounds and plot separation")
