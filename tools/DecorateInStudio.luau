-- One-time EDIT MODE utility. Do not install as a running server Script.
-- Import Creator Store "Low poly Bench" (I4supraa) as Bench and
-- "Low Poly Flower" (Dashon907AK) as Flower before running this utility.
local island = workspace:WaitForChild("DessertJellyIsland")
assert(not island:FindFirstChild("GardenPolish"), "Decoration already applied")
local hub = island.CentralHub
local shop = hub:FindFirstChild("CentralShop") or hub.DessertShop
shop.Name = "CentralShop"
local center = shop:GetPivot().Position
local colors = { Color3.fromRGB(255,193,218), Color3.fromRGB(211,198,248), Color3.fromRGB(185,235,211),
	Color3.fromRGB(255,215,185), Color3.fromRGB(192,224,250), Color3.fromRGB(249,220,246) }
local cream, white = Color3.fromRGB(255,245,224), Color3.fromRGB(255,251,246)
local cocoa = Color3.fromRGB(110,76,91)
local function template(original, name, creator, title)
	local m = game.ServerStorage:FindFirstChild(name) or workspace:FindFirstChild(original)
	assert(m and m:IsA("Model"), original .. " import missing")
	for _, v in ipairs(m:GetDescendants()) do
		assert(not v:IsA("LuaSourceContainer"), "Unexpected script in imported " .. original)
		if v:IsA("BasePart") then v.Anchored = true; v.CanTouch = false; v.CanCollide = false end
	end
	m.Name = name
	m:SetAttribute("Creator", creator)
	m:SetAttribute("SourceTitle", title)
	m.Parent = game.ServerStorage
	return m
end
local bench = template("Bench", "FreeBenchTemplate", "I4supraa", "Low poly Bench")
local flower = template("Flower", "FreeFlowerTemplate", "Dashon907AK", "Low Poly Flower")
local polish = Instance.new("Model")
polish.Name = "GardenPolish"
polish.Parent = island
local function block(name, size, cf, color, parent)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
	p.Anchored = true
	p.Material = Enum.Material.SmoothPlastic
	p.CanCollide, p.CanTouch = false, false
	p.Parent = parent
	return p
end
local function place(templateModel, parent, cf, ground, length, color, kind)
	local m = templateModel:Clone()
	m.Name = kind
	m.Parent = parent
	local size = m:GetExtentsSize()
	m:ScaleTo(m:GetScale() * length / math.max(size.X, size.Y, size.Z))
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Material = Enum.Material.SmoothPlastic
			if kind == "PastelBench" then
				p.Color = p.Color.R > p.Color.G * 1.2 and color or white
			else
				p.Color = p.Color.G > p.Color.R and Color3.fromRGB(149,207,170) or color
			end
		end
	end
	m:PivotTo(cf)
	local box, bounds = m:GetBoundingBox()
	m:PivotTo(m:GetPivot() + Vector3.new(0, ground - (box.Position.Y - bounds.Y / 2), 0))
	return m
end

for i = 1, 6 do
	local plot = island.PlayerPlots:FindFirstChild("Plot" .. i) or island.PlayerPlots[string.format("Plot%02d", i)]
	plot.Name = "Plot" .. i
	plot.PrimaryPart = plot.PlotFloor
	local a = (i - 1) * math.pi / 3
	local pos = Vector3.new(center.X + math.sin(a) * 70, plot:GetPivot().Position.Y, center.Z + math.cos(a) * 70)
	plot:PivotTo(CFrame.lookAt(pos, Vector3.new(center.X, pos.Y, center.Z)))
	local cf = plot:GetPivot()
	plot.Entrance.Label.Enabled = false
	plot.MergeBoard.Label.Size = UDim2.fromOffset(135,26)
	plot.MergeBoard.Label.MaxDistance = 65
	local spawn = block("PlotSpawn", Vector3.new(7,0.2,4), cf * CFrame.new(0,0.35,-14.5), colors[i], plot)
	spawn.CanCollide = true
	local decor = Instance.new("Model")
	decor.Name = "GardenDecor"
	decor.Parent = plot
	-- Candy gate: leave the center open for walking.
	for _, x in ipairs({ -8, 8 }) do
		block("GatePost", Vector3.new(0.75,7,0.75), cf * CFrame.new(x,3.65,-17), colors[i], decor)
	end
	local top = block("GardenGate", Vector3.new(17.5,1.1,1.2), cf * CFrame.new(0,7,-17), colors[i], decor)
	local gui = Instance.new("BillboardGui")
	gui.Name = "OwnerSign"
	gui.Size = UDim2.new(14,0,2.4,0)
	gui.StudsOffset = Vector3.new(0,1.5,0)
	gui.MaxDistance = 100
	gui.Parent = top
	local text = Instance.new("TextLabel")
	text.Name = "OwnerLabel"
	text.Size = UDim2.fromScale(1,1)
	text.BackgroundColor3, text.BackgroundTransparency = cream, 0.1
	text.TextColor3, text.TextScaled = cocoa, true
	text.Font = Enum.Font.GothamBold
	text.Text = "Available Garden"
	text.Parent = gui
	local rounded = Instance.new("UICorner")
	rounded.CornerRadius = UDim.new(0,14)
	rounded.Parent = text
	-- Imported sculpted flowers in two raised beds on each garden's sides.
	for _, x in ipairs({ -18, 18 }) do
		block("Planter", Vector3.new(3.4,0.8,13), cf * CFrame.new(x,0.7,-3), cream, decor)
		for j = 1, 4 do
			place(flower, decor, cf * CFrame.new(x,0,-9+j*2.8), 2, 3.5, colors[i], "PastelFlowers")
		end
	end
	local mid = a + math.pi / 6
	local bpos = Vector3.new(math.sin(mid)*22,0,math.cos(mid)*22)
	place(bench, polish, CFrame.lookAt(bpos,Vector3.zero),0.78,7,colors[i],"PastelBench")
	-- Small flower pots flank the plaza seating.
	for _, offset in ipairs({ -5,5 }) do
		local fpos = (CFrame.lookAt(bpos,Vector3.zero)*CFrame.new(offset,0,0)).Position
		block("PlazaPlanter",Vector3.new(2.6,1,2.6),CFrame.new(fpos+Vector3.new(0,1.25,0)),colors[i],polish)
		place(flower,polish,CFrame.new(fpos),1.75,3,colors[i],"PastelFlowers")
	end
end
-- Align the existing radial pathways with the same shop center.
for _, p in ipairs(island.SugarPaths:GetChildren()) do
	if p:IsA("BasePart") then p.CFrame += Vector3.new(center.X,0,center.Z) end
end
game.ServerScriptService.DessertIsland.Disabled = true
workspace.CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(110,145,175),Vector3.zero)
print("[GardenPolish] Six gates, six benches and 60 flower clusters applied; generator disabled")
