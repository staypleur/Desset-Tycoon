-- Edit-mode migration for the decorated place; not a runtime Script.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before editing")
local island = workspace.DessertJellyIsland
assert(not island:GetAttribute("ProductionLayoutVersion"), "Layout already applied")
local cream = Color3.fromRGB(255, 245, 224)
local cocoa = Color3.fromRGB(112, 76, 91)
local function part(parent, name, size, cf, color)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
	p.Anchored, p.CanTouch = true, false
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
local function sign(p, text, width)
	local gui = Instance.new("BillboardGui")
	gui.Name = "LayoutLabel"
	gui.Size = UDim2.new(width, 0, 1.5, 0)
	gui.StudsOffset = Vector3.new(0, 1.7, 0)
	gui.MaxDistance = 90
	gui.Parent = p
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text, label.TextColor3 = text, cocoa
	label.Font, label.TextScaled = Enum.Font.GothamBold, true
	label.Parent = gui
end
for i = 1, 6 do
	local plot = island.PlayerPlots["Plot" .. i]
	local cf, tint = plot:GetPivot(), plot.PastelBoundary.Color
	local function at(x, y, z) return cf * CFrame.new(x, y, z) end
	for _, name in ipairs({"ProductionBeds", "PurchaseButtons"}) do
		local previous = plot:FindFirstChild(name)
		if previous then previous:Destroy() end
	end
	for _, p in ipairs(plot.PetSpawnPads:GetChildren()) do p:Destroy() end
	local beds = Instance.new("Model")
	beds.Name, beds.Parent = "ProductionBeds", plot
	local aisle = part(beds, "CentralAisle", Vector3.new(10, .12, 48), at(0, .23, 5), cream)
	aisle.CanCollide = false
	local slot = 0
	for row = 1, 5 do
		local z = -12 + (row - 1) * 8
		for _, side in ipairs({-1, 1}) do
			local bed = Instance.new("Model")
			bed.Name = (side < 0 and "LeftRow" or "RightRow") .. row
			bed.Parent = beds
			bed:SetAttribute("Row", row)
			bed:SetAttribute("Capacity", 3)
			local x = side * 18
			part(bed, "TrayBase", Vector3.new(24, .4, 6), at(x, .4, z), tint)
			part(bed, "CreamBed", Vector3.new(23, .16, 5), at(x, .68, z), cream)
			for _, edge in ipairs({-1, 1}) do
				part(bed, "LongRim", Vector3.new(24, .5, .4), at(x, .75, z + edge * 2.8), tint)
				part(bed, "EndRim", Vector3.new(.4, .5, 5.6), at(x + edge * 11.8, .75, z), tint)
			end
			for col = 1, 3 do
				slot += 1
				local p = part(plot.PetSpawnPads, "PetPad" .. slot, Vector3.new(5, .1, 4), at(x + (col - 2) * 7, .82, z), Color3.fromRGB(255, 251, 246))
				p.CanCollide = false
				p:SetAttribute("SlotIndex", slot)
				p:SetAttribute("PlotId", i)
				p:SetAttribute("BedName", bed.Name)
			end
		end
	end
	local board = plot.MergeBoard
	if board:FindFirstChild("LayoutLabel") then board.LayoutLabel:Destroy() end
	board.Size, board.CFrame = Vector3.new(10, .4, 7), at(0, .55, -22)
	board.Color = Color3.fromRGB(206, 198, 237)
	if board:FindFirstChild("Label") then board.Label.Enabled = false end
	sign(board, "Merge 3 into 1", 9)
	board:SetAttribute("RequiredCount", 3)
	for n = 1, 3 do
		local p = plot:FindFirstChild("MergeSlot" .. n)
		if p then
			p.Size = Vector3.new(.12, 2.2, 2.2)
			p.CFrame = at((n - 2) * 3, .82, -22) * CFrame.Angles(0, 0, math.pi / 2)
		end
	end
	local buttons = Instance.new("Model")
	buttons.Name, buttons.Parent = "PurchaseButtons", plot
	for n, count in ipairs({1, 5, 25, 100}) do
		local x = ({-25, -15, 15, 25})[n]
		part(buttons, "ButtonTrim" .. count, Vector3.new(8, .3, 6), at(x, .35, -22), cream)
		local p = part(buttons, "Buy" .. count, Vector3.new(7.2, .35, 5.2), at(x, .65, -22), n == 1 and Color3.fromRGB(174, 229, 192) or tint)
		p:SetAttribute("PurchaseCount", count)
		p:SetAttribute("GameplayConnected", false)
		sign(p, "Buy " .. count, 7)
	end
	-- Move flowers away from the new beds, retaining the imported assets.
	local flowerCounts = { [true] = 0, [false] = 0 }
	for _, p in ipairs(plot.GardenDecor:GetChildren()) do
		if p.Name == "Planter" and p:IsA("BasePart") then
			local old = cf:PointToObjectSpace(p.Position)
			p.CFrame = at(old.X < 0 and -32 or 32, old.Y, 3)
			p.Size = Vector3.new(2, p.Size.Y, 38)
		elseif p.Name == "PastelFlowers" and p:IsA("Model") then
			local old = cf:PointToObjectSpace(p:GetPivot().Position)
			local left = old.X < 0
			flowerCounts[left] += 1
			p:PivotTo(at(left and -32 or 32, old.Y, -10 + (flowerCounts[left] - 1) * 8))
		end
	end
	plot:SetAttribute("ProductionBedCount", 10)
	plot:SetAttribute("PetCapacity", 30)
	plot:SetAttribute("LayoutStyle", "TwinProductionRows")
	assert(slot == 30, "Expected thirty slots")
	assert(#beds:GetChildren() == 11, "Expected ten beds and an aisle")
	for _, p in ipairs(plot.PetSpawnPads:GetChildren()) do
		local localPos = cf:PointToObjectSpace(p.Position)
		assert(math.abs(localPos.X) >= 10.99 and math.abs(localPos.X) <= 25.01, "Aisle must stay clear")
	end
end
island:SetAttribute("ProductionLayoutVersion", 1)
island:SetAttribute("MapVersion", "4.0.0")
game:GetService("Selection"):Set({})
local cf = island.PlayerPlots.Plot1:GetPivot()
workspace.CurrentCamera.CFrame = CFrame.lookAt((cf * CFrame.new(48, 62, -67)).Position, (cf * CFrame.new(0, 0, 0)).Position)
print("[ProductionLayout] PASS: six plots, ten mirrored beds each, thirty slots each, four purchase placeholders, front merge board")
