-- Edit mode only; modifies the saved 70x70 production-row layout.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before editing")
local island = workspace.DessertJellyIsland
assert(island:GetAttribute("ProductionLayoutVersion") == 1, "Production-row layout required")
assert(not island:GetAttribute("PersonalShopLayoutVersion"), "Personal shops already applied")
local template = island.CentralHub.CentralShop
local cream = Color3.fromRGB(255, 245, 224)
local cocoa = Color3.fromRGB(112, 76, 91)
local function pad(parent, name, position, color, text)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame = name, Vector3.new(7, .35, 5), position
	p.Anchored, p.CanTouch = true, false
	p.Material, p.Color = Enum.Material.SmoothPlastic, color
	p.Parent = parent
	p:SetAttribute("GameplayConnected", false)
	local gui = Instance.new("BillboardGui")
	gui.Name, gui.Size = "ServiceLabel", UDim2.new(7, 0, 2, 0)
	gui.StudsOffset, gui.MaxDistance = Vector3.new(0, 2, 0), 85
	gui.Parent = p
	local label = Instance.new("TextLabel")
	label.Size, label.BackgroundTransparency = UDim2.fromScale(1, 1), 1
	label.Font, label.TextScaled = Enum.Font.GothamBold, true
	label.TextColor3, label.Text = cocoa, text
	label.Parent = gui
	return p
end
for i = 1, 6 do
	local plot = island.PlayerPlots["Plot" .. i]
	local cf = plot:GetPivot()
	local function at(x, y, z) return cf * CFrame.new(x, y, z) end
	-- Compact the five rows slightly to reserve a shop courtyard at the rear.
	for _, bed in ipairs(plot.ProductionBeds:GetChildren()) do
		if bed:IsA("Model") then
			local row = bed:GetAttribute("Row")
			local desiredZ = -15 + (row - 1) * 7
			local currentZ = cf:PointToObjectSpace(bed.TrayBase.Position).Z
			bed:PivotTo(bed:GetPivot() + cf:VectorToWorldSpace(Vector3.new(0, 0, desiredZ - currentZ)))
		end
	end
	for _, p in ipairs(plot.PetSpawnPads:GetChildren()) do
		local bed = plot.ProductionBeds[p:GetAttribute("BedName")]
		local old = cf:PointToObjectSpace(p.Position)
		p.CFrame = at(old.X, old.Y, -15 + (bed:GetAttribute("Row") - 1) * 7)
	end
	local aisle = plot.ProductionBeds.CentralAisle
	aisle.Size, aisle.CFrame = Vector3.new(10, .12, 40), at(0, .23, 1)
	local previous = plot:FindFirstChild("PersonalShopArea")
	if previous then previous:Destroy() end
	local area = Instance.new("Model")
	area.Name, area.Parent = "PersonalShopArea", plot
	local shop = template:Clone()
	shop.Name, shop.Parent = "DessertShop", area
	shop:ScaleTo(shop:GetScale() * .7)
	local box, bounds = shop:GetBoundingBox()
	local target = at(0, .15 + bounds.Y / 2, 25) * CFrame.Angles(0, math.pi, 0)
	shop:PivotTo(target * box:ToObjectSpace(shop:GetPivot()))
	shop:SetAttribute("PlotId", i)
	shop:SetAttribute("Purpose", "Personal dessert shop; gameplay connection pending")
	for _, p in ipairs(shop:GetDescendants()) do
		assert(not p:IsA("LuaSourceContainer"), "Unexpected script in shop")
		if p:IsA("BasePart") then
			p.Anchored, p.CanTouch = true, false
			if p.Name == "Roof" or p.Name == "CandyPillar" then p.Color = plot.PastelBoundary.Color end
		elseif p:IsA("TextLabel") then
			p.Text = "DESSERT " .. string.format("%02d", i)
		end
	end
	pad(area, "CollectIncome", at(-15, .45, 25), Color3.fromRGB(181, 231, 201), "수익 받기")
	pad(area, "DessertCrate", at(15, .45, 25), Color3.fromRGB(239, 215, 168), "디저트 상자")
	local terrace = Instance.new("Part")
	terrace.Name, terrace.Size, terrace.CFrame = "ShopCourtyard", Vector3.new(24, .1, 4), at(0, .24, 18.5)
	terrace.Anchored, terrace.CanCollide, terrace.CanTouch = true, false, false
	terrace.Color, terrace.Material = cream, Enum.Material.SmoothPlastic
	terrace.Parent = area
	plot:SetAttribute("LayoutStyle", "PersonalShopAndProductionRows")
	assert(#plot.PetSpawnPads:GetChildren() == 30, "Thirty dessert slots required")
	local shopBox, shopSize = shop:GetBoundingBox()
	local shopLocal = cf:PointToObjectSpace(shopBox.Position)
	assert(math.abs(shopLocal.X) + shopSize.X / 2 < 34, "Shop outside plot")
	-- Use the unrotated local extents for all six rotations.
	local minZ, maxZ = math.huge, -math.huge
	for _, p in ipairs(shop:GetDescendants()) do
		if p:IsA("BasePart") then
			for _, x in ipairs({-1, 1}) do for _, y in ipairs({-1, 1}) do for _, z in ipairs({-1, 1}) do
				local corner = cf:PointToObjectSpace(p.CFrame:PointToWorldSpace(p.Size * Vector3.new(x, y, z) / 2))
				minZ, maxZ = math.min(minZ, corner.Z), math.max(maxZ, corner.Z)
				assert(math.abs(corner.X) < 34.01 and math.abs(corner.Z) < 34.01, "Shop corner outside plot")
			end end end
		end
	end
	assert(minZ > 16.01, "Shop overlaps production beds")
end
island:SetAttribute("PersonalShopLayoutVersion", 1)
island:SetAttribute("MapVersion", "5.0.0")
game:GetService("Selection"):Set({})
local cf = island.PlayerPlots.Plot1:GetPivot()
workspace.CurrentCamera.CFrame = CFrame.lookAt((cf * CFrame.new(35, 48, -53)).Position, (cf * CFrame.new(0, 0, 8)).Position)
print("[PersonalShops] PASS: six personal shops within plots, clear production beds, thirty slots per plot")
