-- Edit-mode migration for the entrance cafe place. Production script is installed separately.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play first")
local island = workspace.DessertJellyIsland
assert(island:GetAttribute("EntranceCafeLayoutVersion") == 1, "Entrance cafes required")
assert(not island:GetAttribute("ConveyorLayoutVersion"), "Conveyors already applied")
local function part(parent, name, size, cf, color, solid)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
	p.Anchored, p.CanCollide, p.CanTouch = true, solid ~= false, false
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
local cream, beltColor = Color3.fromRGB(255,245,224), Color3.fromRGB(175,159,188)
local mascots=Instance.new("Folder")
mascots.Name,mascots.Parent="DecorativeMascots",game.ServerStorage
for i=1,6 do
	local plot = island.PlayerPlots["Plot"..i]
	local cf, tint = plot:GetPivot(), plot.PastelBoundary.Color
	local function at(x,y,z) return cf*CFrame.new(x,y,z) end
	if plot:FindFirstChild("DisplayMascot") then plot.DisplayMascot.Parent=mascots end
	-- Raised production shelves make the belts genuinely lower than the pet floors.
	plot.ProductionBeds:Destroy()
	local beds = Instance.new("Model")
	beds.Name, beds.Parent = "ProductionBeds", plot
	local belts = Instance.new("Model")
	belts.Name, belts.Parent = "Conveyors", plot
	for row=1,5 do
		local z=1+(row-1)*7
		for _,side in ipairs({-1,1}) do
			local bed=Instance.new("Model")
			bed.Name=(side<0 and "LeftRow" or "RightRow")..row
			bed:SetAttribute("Row",row)
			bed:SetAttribute("Capacity",3)
			bed.Parent=beds
			part(bed,"TrayBase",Vector3.new(24,1.7,4),at(side*18,1.05,z-.75),tint)
			part(bed,"CreamBed",Vector3.new(23,.15,3.5),at(side*18,1.975,z-.75),cream)
			local channel=part(belts,bed.Name.."Belt",Vector3.new(26,.25,2.3),at(side*17,.4,z+2.5),beltColor)
			channel:SetAttribute("FlowDirection",side<0 and "Right" or "Left")
			channel:SetAttribute("Row",row)
			channel:SetAttribute("Side",side)
			for _,edge in ipairs({-1,1}) do
				part(belts,"ChannelRim",Vector3.new(26,.7,.2),at(side*17,.7,z+2.5+edge*1.25),tint)
			end
			for x=6,28,3 do
				part(belts,"RollerStripe",Vector3.new(.14,.04,2.1),at(side*x,.55,z+2.5),cream,false)
			end
		end
	end
	local main=part(belts,"MainBelt",Vector3.new(4,.25,34),at(0,.4,16),beltColor)
	main:SetAttribute("FlowDirection","TowardCafe")
	for _,x in ipairs({-2.15,2.15}) do
		part(belts,"MainRail",Vector3.new(.2,.6,34),at(x,.6,16),tint)
		part(belts,"SideWalk",Vector3.new(2.5,.2,34),at(x<0 and -3.6 or 3.6,.55,16),cream)
	end
	for z=0,32,2 do part(belts,"MainRollerStripe",Vector3.new(3.8,.04,.14),at(0,.55,z),cream,false) end
	for _,z in ipairs({0,14,28}) do
		part(belts,"WalkwayBridge",Vector3.new(10,.3,2),at(0,2.1,z),cream)
	end
	for _,p in ipairs(plot.PetSpawnPads:GetChildren()) do
		local row=math.ceil(p:GetAttribute("SlotIndex")/6)
		local old=cf:PointToObjectSpace(p.Position)
		p.CFrame=at(old.X,2.12,1+(row-1)*7-.75)
		p.Size=Vector3.new(5,.1,3)
		p:SetAttribute("Row",row)
		p:SetAttribute("DropLaneZ",1+(row-1)*7+2.5)
	end
	local collector=part(belts,"Collector",Vector3.new(4,.8,2),at(0,.6,-1),Color3.fromRGB(184,230,205))
	collector:SetAttribute("GameplayConnected",true)
	local gui=Instance.new("BillboardGui")
	gui.Name,gui.Size= "CollectorSign",UDim2.new(8,0,2,0)
	gui.StudsOffset,gui.MaxDistance=Vector3.new(0,2,0),80
	gui.Parent=collector
	local label=Instance.new("TextLabel")
	label.Name,label.Size="CollectionLabel",UDim2.fromScale(1,1)
	label.BackgroundTransparency,label.TextScaled=1,true
	label.TextColor3,label.Font=Color3.fromRGB(112,76,91),Enum.Font.GothamBold
	label.Text="Collect $0"
	label.Parent=gui
	plot:SetAttribute("ProductionBedCount",10)
	plot:SetAttribute("ConveyorSpeed",7)
end
local translations={
	["합성 · 3 → 1"]="Merge 3 into 1",
	["수익 받기"]="Collect Earnings",
	["디저트 상자"]="Dessert Crate - Coming Soon",
}
for _,item in ipairs(game:GetDescendants()) do
	if item:IsA("TextLabel") or item:IsA("TextButton") or item:IsA("TextBox") then
		local count=item.Text:match("^(%d+)개 구매$")
		item.Text=translations[item.Text] or (count and "Buy "..count.." ($"..tostring(tonumber(count)*5)..")") or item.Text
		if item.Name=="OwnerLabel" then item.Text="Available Cafe" end
		assert(not item.Text:match("[\234-\237][\128-\191][\128-\191]"),"Untranslated game text: "..item.Text)
	end
end
island:SetAttribute("ConveyorLayoutVersion",1)
island:SetAttribute("MapVersion","7.0.0")
print("[ConveyorLayout] PASS: 60 recessed feed lanes, six main conveyors, 180 elevated pet positions; game labels in English")
