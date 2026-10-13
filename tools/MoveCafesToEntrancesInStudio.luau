-- Restore only the cafe source if an interrupted edit removed it. Never rebuild the island.
local function recoverCafeTemplate()
local C = {
	pink = Color3.fromRGB(255, 193, 218), lavender = Color3.fromRGB(211, 198, 248),
	mint = Color3.fromRGB(185, 235, 211), cream = Color3.fromRGB(255, 245, 224),
	peach = Color3.fromRGB(255, 215, 185), blue = Color3.fromRGB(192, 224, 250),
	white = Color3.fromRGB(255, 251, 246), cocoa = Color3.fromRGB(110, 76, 91),
	caramel = Color3.fromRGB(222, 159, 120), berry = Color3.fromRGB(244, 134, 170),
}
local palette = { C.pink, C.lavender, C.mint, C.peach, C.blue, Color3.fromRGB(249, 220, 246) }

local map=Instance.new("Model"); map.Name="CentralCafeTemplate"; map.Parent=game.ServerStorage; local hub=map
local function group(name, parent)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent or map
	return model
end
local function part(name, size, cf, color, parent, shape, solid)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
	p.Anchored = true
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.CanCollide = solid ~= false
	p.CanTouch = false
	p.CastShadow = solid ~= false
	if shape then p.Shape = shape end
	p.Parent = parent or map
	return p
end
local function ball(name, size, pos, color, parent)
	return part(name, size, CFrame.new(pos), color, parent, Enum.PartType.Ball, false)
end
-- Roblox cylinders extend along local X, so rotate them to make horizontal discs.
local function disc(name, diameter, height, pos, color, parent, solid)
	return part(name, Vector3.new(height, diameter, diameter),
		CFrame.new(pos) * CFrame.Angles(0, 0, math.pi / 2), color, parent, Enum.PartType.Cylinder, solid)
end
local function label(adornee, text, width, height, offset)
	local gui = Instance.new("BillboardGui")
	gui.Name = "Label"
	gui.Size = UDim2.fromOffset(width or 220, height or 48)
	gui.StudsOffset = offset or Vector3.new(0, 3, 0)
	gui.MaxDistance = 135
	gui.AlwaysOnTop = false
	gui.Adornee, gui.Parent = adornee, adornee
	local t = Instance.new("TextLabel")
	t.Name = "Text"
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.Text, t.TextColor3 = text, C.cocoa
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextStrokeColor3 = C.white
	t.TextStrokeTransparency = 0.35
	t.Parent = gui
	return gui
end
local function face(parent, origin, scale)
	for _, x in ipairs({ -0.32, 0.32 }) do
		ball("ChocolateEye", Vector3.new(0.18, 0.26, 0.12) * scale,
			origin + Vector3.new(x, 0.05, -0.73) * scale, C.cocoa, parent)
		ball("Blush", Vector3.new(0.23, 0.11, 0.08) * scale,
			origin + Vector3.new(x * 1.65, -0.12, -0.66) * scale, C.berry, parent)
	end
	ball("Smile", Vector3.new(0.16, 0.09, 0.08) * scale,
		origin + Vector3.new(0, -0.16, -0.8) * scale, C.cocoa, parent)
end


local shop = group("CentralShop", hub)
part("ShopFloor", Vector3.new(24, 0.5, 18), CFrame.new(0, 1, -6), C.white, shop)
part("BackWall", Vector3.new(24, 10, 1), CFrame.new(0, 6, -14.5), C.peach, shop)
for _, x in ipairs({ -11.5, 11.5 }) do
	part("SideWall", Vector3.new(1, 10, 18), CFrame.new(x, 6, -6), C.cream, shop)
	part("CandyPillar", Vector3.new(1.2, 10, 1.2), CFrame.new(x, 6, 2.5), C.pink, shop)
end
part("Roof", Vector3.new(26, 1, 20), CFrame.new(0, 11.5, -6), C.pink, shop)
for i = 1, 12 do
	local x = -13 + (i - 0.5) * 26 / 12
	part("StripedAwning", Vector3.new(26 / 12, 0.6, 4), CFrame.new(x, 10.6, 4) * CFrame.Angles(math.rad(8), 0, 0),
		i % 2 == 0 and C.white or C.berry, shop, nil, false)
	ball("AwningScallop", Vector3.new(2.2, 1.3, 1), Vector3.new(x, 10.2, 6), i % 2 == 0 and C.white or C.berry, shop)
end
local sign = part("ShopSign", Vector3.new(15, 2.5, 0.4), CFrame.new(0, 8.7, 3.1), C.cream, shop, nil, false)
local surface = Instance.new("SurfaceGui")
surface.Face = Enum.NormalId.Back
surface.CanvasSize = Vector2.new(600, 100)
surface.Parent = sign
local signText = Instance.new("TextLabel")
signText.Size = UDim2.fromScale(1, 1)
signText.BackgroundTransparency = 1
signText.Font = Enum.Font.GothamBold
signText.TextScaled = true
signText.TextColor3 = C.cocoa
signText.Text = "SUGAR & JELLY"
signText.Parent = surface
part("DisplayCounter", Vector3.new(17, 2.8, 3), CFrame.new(0, 2.6, -2), C.lavender, shop)
part("CounterTop", Vector3.new(18, 0.4, 3.6), CFrame.new(0, 4.2, -2), C.white, shop)
for i = 1, 3 do
	local pos = Vector3.new((i - 2) * 5, 4.9, -2)
	disc("DessertPlate", 3.5, 0.2, pos - Vector3.new(0, 0.4, 0), C.cream, shop, false)
	ball("DisplayJelly", Vector3.new(2.4, 1.5, 2.4), pos, palette[i], shop)
end
local pudding = group("GiantPudding", hub)
disc("PuddingPlate", 19, 0.5, Vector3.new(0, 12.3, -6), C.white, pudding, false)
disc("PuddingBody", 15, 7, Vector3.new(0, 16, -6), C.cream, pudding, false)
ball("SoftPuddingTop", Vector3.new(15, 3.2, 15), Vector3.new(0, 19, -6), C.caramel, pudding)
ball("WhippedCream", Vector3.new(5, 3.5, 5), Vector3.new(0, 21, -6), C.white, pudding)
ball("Cherry", Vector3.new(2.6, 2.6, 2.6), Vector3.new(0, 23.4, -6), C.berry, pudding)
-- Face points toward the main spawn (positive Z).
local frontFace = group("PuddingFace", pudding)
face(frontFace, Vector3.new(0, 16, -6), 9)
frontFace:PivotTo(CFrame.new(0, 16, -6) * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, -16, 6) * frontFace:GetPivot())


return map
end
-- Edit-mode migration: the complete central pudding cafe becomes six entrance cafes.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play before editing")
local island = workspace.DessertJellyIsland
assert(island:GetAttribute("PersonalShopLayoutVersion") == 1, "Personal-shop layout required")
assert(not island:GetAttribute("EntranceCafeLayoutVersion"), "Entrance cafes already applied")
local hub = island.CentralHub
local originalShop = hub:FindFirstChild("CentralShop")
local center = originalShop and originalShop:GetPivot() or CFrame.new(0, 6.375, -4.75)
-- Keep the original cafe and giant pudding together as a reusable source model.
local template = game.ServerStorage:FindFirstChild("CentralCafeTemplate")
if not template then
if not originalShop then recoverCafeTemplate(); template = game.ServerStorage.CentralCafeTemplate else
template = Instance.new("Model")
template.Name = "CentralCafeTemplate"
hub.CentralShop.Parent = template
hub.GiantPudding.Parent = template
template:PivotTo(template:GetPivot())
template.Parent = game.ServerStorage
end
end
if not hub:FindFirstChild("CentralShop") then
local anchorModel = Instance.new("Model")
anchorModel.Name, anchorModel.Parent = "CentralShop", hub
local anchor = Instance.new("Part")
anchor.Name, anchor.Size, anchor.CFrame = "CenterAnchor", Vector3.new(.2, .2, .2), center
anchor.Anchored, anchor.Transparency = true, 1
anchor.CanCollide, anchor.CanTouch, anchor.CanQuery = false, false, false
anchor.Parent, anchorModel.PrimaryPart = anchorModel, anchor
anchorModel:SetAttribute("Purpose", "Invisible layout origin; future central model belongs in CentralDisplay")
local display = Instance.new("Model")
display.Name, display.Parent = "CentralDisplay", hub
display:SetAttribute("Purpose", "Reserved for the user's future central model")
-- Archive plaza furniture and cake displays to leave the central display space clear.
local archive = Instance.new("Folder")
archive.Name, archive.Parent = "ArchivedCentralDecor", game.ServerStorage
if island:FindFirstChild("GardenPolish") then island.GardenPolish.Parent = archive end
if island:FindFirstChild("CakeDisplays") then island.CakeDisplays.Parent = archive end
local centralLabel = hub.CentralSpawn:FindFirstChildWhichIsA("BillboardGui")
if centralLabel then centralLabel.Enabled = false end
end
for i = 1, 6 do
	local plot = island.PlayerPlots["Plot" .. i]
	local cf = plot:GetPivot()
	local function at(x, y, z) return cf * CFrame.new(x, y, z) end
	local area = plot.PersonalShopArea
	local existingCafe = area:FindFirstChild("DessertCafe")
	local ownerSign = existingCafe and existingCafe:FindFirstChild("OwnerSign", true)
	if ownerSign then ownerSign.Parent = plot.GardenDecor end
	if existingCafe then existingCafe:Destroy() end
	if area:FindFirstChild("DessertShop") then area.DessertShop:Destroy() end
	local cafe = template:Clone()
	cafe.Name, cafe.Parent = "DessertCafe", area
	cafe.CentralShop.Name = "CafeBuilding"
	local box, size = cafe:GetBoundingBox()
	-- Original facade faces +Z. Keep +Z facing outward into the player's production area.
	cafe:PivotTo(at(0, .15 + size.Y / 2, -22) * box:ToObjectSpace(cafe:GetPivot()))
	cafe:SetAttribute("PlotId", i)
	for _, p in ipairs(cafe:GetDescendants()) do
		assert(not p:IsA("LuaSourceContainer"), "Unexpected script in cafe")
		if p:IsA("BasePart") then p.Anchored, p.CanTouch = true, false end
	end
	-- Move the existing owner sign onto the cafe; the allocator still finds OwnerLabel.
	local gate = plot.GardenDecor:FindFirstChild("GardenGate")
	ownerSign = ownerSign or (gate and gate:FindFirstChild("OwnerSign"))
	if not ownerSign then
		ownerSign = Instance.new("BillboardGui")
		ownerSign.Name, ownerSign.Size = "OwnerSign", UDim2.new(18, 0, 2.6, 0)
		ownerSign.MaxDistance = 100
		local label = Instance.new("TextLabel")
		label.Name, label.Size = "OwnerLabel", UDim2.fromScale(1, 1)
		label.BackgroundColor3, label.TextColor3 = Color3.fromRGB(255, 245, 224), Color3.fromRGB(112, 76, 91)
		label.Font, label.TextScaled, label.Text = Enum.Font.GothamBold, true, "Available Garden"
		label.Parent = ownerSign
	end
	ownerSign.Parent, ownerSign.Adornee = cafe.CafeBuilding.Roof, cafe.CafeBuilding.Roof
	ownerSign.StudsOffset = Vector3.new(0, 15, 0)
	for _, p in ipairs(plot.GardenDecor:GetChildren()) do
		if p.Name == "GardenGate" or p.Name == "GatePost" then p:Destroy() end
	end
	-- Side entrance routes bypass the cafe's back wall.
	plot.Entrance.Size, plot.Entrance.CFrame = Vector3.new(6, .2, 3), at(30, .25, -32)
	plot.PlotSpawn.Size, plot.PlotSpawn.CFrame = Vector3.new(6, .2, 4), at(30, .35, -30)
	area.CollectIncome.CFrame = at(-19, .45, -29)
	area.DessertCrate.CFrame = at(19, .45, -29)
	area.ShopCourtyard.Size, area.ShopCourtyard.CFrame = Vector3.new(28, .1, 5), at(0, .24, -7.5)
	local board = plot.MergeBoard
	board.CFrame = at(0, .55, -6)
	for n = 1, 3 do
		plot["MergeSlot" .. n].CFrame = at((n - 2) * 3, .82, -6) * CFrame.Angles(0, 0, math.pi / 2)
	end
	for n, count in ipairs({1, 5, 25, 100}) do
		local x = n <= 2 and -22 or 22
		local z = (n == 1 or n == 3) and -19 or -10
		plot.PurchaseButtons["Buy" .. count].CFrame = at(x, .65, z)
		plot.PurchaseButtons["ButtonTrim" .. count].CFrame = at(x, .35, z)
	end
	for _, bed in ipairs(plot.ProductionBeds:GetChildren()) do
		if bed:IsA("Model") then
			local z = 1 + (bed:GetAttribute("Row") - 1) * 7
			local oldZ = cf:PointToObjectSpace(bed.TrayBase.Position).Z
			bed:PivotTo(bed:GetPivot() + cf:VectorToWorldSpace(Vector3.new(0, 0, z - oldZ)))
		end
	end
	for _, p in ipairs(plot.PetSpawnPads:GetChildren()) do
		local bed = plot.ProductionBeds[p:GetAttribute("BedName")]
		local old = cf:PointToObjectSpace(p.Position)
		p.CFrame = at(old.X, old.Y, 1 + (bed:GetAttribute("Row") - 1) * 7)
	end
	plot.ProductionBeds.CentralAisle.Size = Vector3.new(10, .12, 36)
	plot.ProductionBeds.CentralAisle.CFrame = at(0, .23, 15)
	-- Move corner decorations away from the last production row.
	local mascot = plot.DisplayMascot
	mascot:PivotTo(at(0, 3, 29) * cf.Rotation:Inverse() * mascot:GetPivot().Rotation)
	local cake = plot.GardenDecor.HeartCakeDisplay
	local oldCake = cake:GetPivot()
	local cakeBox, cakeSize = cake:GetBoundingBox()
	cake:PivotTo(oldCake + at(-31, 2.15 + cakeSize.Y / 2, -26).Position - cakeBox.Position)
	plot.GardenDecor.CakePedestal.CFrame = at(-31, 1.15, -26)
	plot:SetAttribute("LayoutStyle", "EntranceCafe")
	-- Geometry checks in plot-local coordinates avoid rotation-dependent bounds.
	for _, p in ipairs(cafe:GetDescendants()) do
		if p:IsA("BasePart") then
			for _, x in ipairs({-1, 1}) do for _, y in ipairs({-1, 1}) do for _, z in ipairs({-1, 1}) do
				local corner = cf:PointToObjectSpace(p.CFrame:PointToWorldSpace(p.Size * Vector3.new(x, y, z) / 2))
				assert(math.abs(corner.X) < 34.01 and math.abs(corner.Z) < 34.01, "Cafe outside plot: " .. p.Name .. " " .. tostring(corner))
				assert(corner.Z < -9.51, "Cafe overlaps front merge area")
			end end end
		end
	end
	assert(#plot.PetSpawnPads:GetChildren() == 30, "Expected thirty dessert positions")
end
island:SetAttribute("EntranceCafeLayoutVersion", 1)
island:SetAttribute("MapVersion", "6.0.0")
game:GetService("Selection"):Set({island.PlayerPlots.Plot1})
print("[EntranceCafes] PASS: six complete pudding cafes face into plots, service pads nearby, center reserved, 180 dessert positions")

