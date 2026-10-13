-- Read-only edit-mode geometry and English display regression checks.
local island=workspace.DessertJellyIsland
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]
	local cf=plot:GetPivot()
	local lanes=0
	for _,part in ipairs(plot.Conveyors:GetChildren()) do
		if part:GetAttribute("Row") then lanes+=1 end
	end
	assert(lanes==10,"Ten feed lanes required")
	assert(#plot.ProductionBeds:GetChildren()==10,"Ten raised shelves required")
	assert(#plot.PetSpawnPads:GetChildren()==30,"Thirty pet positions required")
	for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do
		local pos=cf:PointToObjectSpace(pad.Position)
		local lane=plot.Conveyors[pad:GetAttribute("BedName").."Belt"]
		local lanePos=cf:PointToObjectSpace(lane.Position)
		assert(pos.Y-lanePos.Y>1.5,"Feed lane must be recessed below pet floor")
		assert(math.abs(lanePos.Z-pad:GetAttribute("DropLaneZ"))<.01,"Drop lane target mismatch")
		assert(math.abs(pos.X)<=25.01 and pos.Z<30,"Pet position outside shelf")
	end
	assert(plot.Conveyors.MainBelt:GetAttribute("FlowDirection")=="TowardCafe","Main flow must reach cafe")
end
for _,p in ipairs(game:GetDescendants()) do
	if p:IsA("TextLabel") or p:IsA("TextButton") or p:IsA("TextBox") then
		assert(not p.Text:match("[\234-\237][\128-\191][\128-\191]"),"Non-English display text: "..p.Text)
	end
end
local catalog=assert(loadstring(game.ReplicatedStorage.DessertCatalog.Source))()
assert(#catalog==30 and catalog[1].Name=="Pudding" and catalog[30].Name=="Parfait Dragon","English thirty-tier catalog")
print("[ConveyorTest] PASS: 60 recessed feed lanes, six cafe-bound main belts, 180 pet positions, English game text/catalog")
