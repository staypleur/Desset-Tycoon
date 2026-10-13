-- Dessert & Jelly Island | place this Script in ServerScriptService (or Workspace).
-- Map foundation only: pads/boards are integration points, not economy mechanics.
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local PlotLayout = require(game.ReplicatedStorage:WaitForChild("TycoonPlotLayout"))

local CONFIG = { PlotCount = 6, PlotRadius = 150, IslandRadius = 174, Seed = 31415 }
local C = {
	pink = Color3.fromRGB(255, 193, 218), lavender = Color3.fromRGB(211, 198, 248),
	mint = Color3.fromRGB(185, 235, 211), cream = Color3.fromRGB(255, 245, 224),
	peach = Color3.fromRGB(255, 215, 185), blue = Color3.fromRGB(192, 224, 250),
	white = Color3.fromRGB(255, 251, 246), cocoa = Color3.fromRGB(110, 76, 91),
	caramel = Color3.fromRGB(222, 159, 120), berry = Color3.fromRGB(244, 134, 170),
}
local palette = { C.pink, C.lavender, C.mint, C.peach, C.blue, Color3.fromRGB(249, 220, 246) }
local names = { "Strawberry Garden", "Lavender Bakery", "Mint Meadow", "Peach Patisserie", "Cloud Cafe", "Sugar Blossom" }
local rng = Random.new(CONFIG.Seed)
-- Never clear unrelated Workspace objects. Own only this named generated model.
local previous = Workspace:FindFirstChild("DessertJellyIsland")
if previous then previous:Destroy() end
local map = Instance.new("Model")
map.Name = "DessertJellyIsland"
map:SetAttribute("LayoutReady", false)
map:SetAttribute("MapVersion", "1.0.0")
map:SetAttribute("PlotCount", CONFIG.PlotCount)
map:SetAttribute("RecommendedMaxPlayers", 6)
map.Parent = Workspace

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

local base = group("FloatingIsland")
disc("LavenderCakeLayer", 327, 10, Vector3.new(0, -14, 0), C.lavender, base)
disc("PinkCakeLayer", 348, 10, Vector3.new(0, -6, 0), C.pink, base)
disc("MintIcingGround", 348, 2, Vector3.new(0, -1, 0), C.mint, base)
ball("RoundedUnderside", Vector3.new(303, 34, 303), Vector3.new(0, -23, 0), C.lavender, base)
for i = 1, 48 do
	local a = i * math.pi * 2 / 48
	ball("ScallopedIcing", Vector3.new(18, 5, 18), Vector3.new(math.cos(a) * 165, -1.8, math.sin(a) * 165), C.mint, base)
	-- Invisible continuous fence protects players from the floating island's edge.
	local cf = CFrame.new(math.cos(a) * 171, 6, math.sin(a) * 171) * CFrame.Angles(0, -a, 0)
	local barrier = part("EdgeSafety", Vector3.new(3, 14, 24), cf, C.white, base)
	barrier.Transparency = 1
	barrier.CastShadow = false
end

local hub = group("CentralHub")
disc("PlazaBorder", 58, 0.5, Vector3.new(0, 0.25, 0), C.pink, hub)
disc("VanillaPlaza", 55, 0.3, Vector3.new(0, 0.6, 0), C.cream, hub)
local spawn = Instance.new("SpawnLocation")
spawn.Name = "CentralSpawn"
spawn.Size = Vector3.new(9, 0.3, 9)
spawn.CFrame = CFrame.new(0, 0.9, 17)
spawn.Color, spawn.Material = C.mint, Enum.Material.SmoothPlastic
spawn.Anchored, spawn.Neutral, spawn.Enabled = true, true, true
spawn.Duration = 0
spawn.Parent = hub
label(spawn, "Welcome to Sugar Island!", 280, 40, Vector3.new(0, 3, 0))

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

local paths = group("SugarPaths")
local plots = group("PlayerPlots")
for i = 1, CONFIG.PlotCount do
	local plot = group("Plot" .. i, plots)
	plot:SetAttribute("PlotId", i)
	plot:SetAttribute("OwnerUserId", 0)
	plot:SetAttribute("Theme", names[i])
	plot.WorldPivot = CFrame.new(0, .85, 0)
end

local garden = group("CandyGarden")
local function tree(pos, color)
	local t = group("CottonCandyTree", garden)
	part("BiscuitTrunk", Vector3.new(1.4, 7, 1.4), CFrame.new(pos + Vector3.new(0, 3.5, 0)), C.caramel, t)
	ball("CandyCrown", Vector3.new(9, 9, 9), pos + Vector3.new(0, 9, 0), color, t)
	ball("CandyPuff", Vector3.new(6, 6, 6), pos + Vector3.new(3, 8, 0), color, t)
	ball("CandyPuff", Vector3.new(6, 6, 6), pos + Vector3.new(-3, 8.5, 0), C.white:Lerp(color, 0.65), t)
end
for i = 1, 24 do
	local a = (i - 0.5) * math.pi * 2 / 24
	local pos = Vector3.new(math.sin(a) * 163, 0, math.cos(a) * 163)
	tree(pos, palette[(i - 1) % #palette + 1])
	for j = 1, 3 do
		ball("MarshmallowBush", Vector3.new(3.5, 2.5, 3.5), pos + Vector3.new(j * 2 - 4, 1.1, 5), C.white, garden)
	end
end
for i = 1, 12 do
	local a = (i - 0.5) * math.pi * 2 / 12
	local pos = Vector3.new(math.sin(a) * 34, 0, math.cos(a) * 34)
	disc("FlowerBed", 5, 0.25, pos + Vector3.new(0, 0.15, 0), C.mint, garden, false)
	for j = 1, 5 do
		local b = j * math.pi * 2 / 5
		ball("SugarPetal", Vector3.new(1.4, 0.5, 1.4), pos + Vector3.new(math.cos(b), 0.55, math.sin(b)), palette[(i - 1) % 6 + 1], garden)
	end
	ball("FlowerCenter", Vector3.new(1, 0.65, 1), pos + Vector3.new(0, 0.7, 0), C.cream, garden)
end
-- Distant cloud puffs have no collision and no external asset dependencies.
for i = 1, 10 do
	local a = i * math.pi * 2 / 10
	local pos = Vector3.new(math.sin(a) * 226, rng:NextNumber(-16, -5), math.cos(a) * 226)
	for j = -1, 1 do
		ball("SugarCloud", Vector3.new(18, 8, 12), pos + Vector3.new(j * 10, j == 0 and 2 or 0, 0), C.white, garden)
	end
end

local effects = group("WarmSparkles", hub)
for i = 1, 6 do
	local a = i * math.pi * 2 / 6
	local emitterPart = part("SparkleAnchor", Vector3.new(1, 1, 1), CFrame.new(math.cos(a) * 23, 4, math.sin(a) * 23), C.white, effects, nil, false)
	emitterPart.Transparency = 1
	local attachment = Instance.new("Attachment")
	attachment.Parent = emitterPart
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "WarmSparkles"
	emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Color = ColorSequence.new(C.cream, C.pink)
	emitter.LightEmission = 0.6
	emitter.Rate = 3
	emitter.Lifetime = NumberRange.new(3, 5)
	emitter.Speed = NumberRange.new(0.4, 1.1)
	emitter.SpreadAngle = Vector2.new(40, 40)
	emitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 0.5), NumberSequenceKeypoint.new(1, 0) })
	emitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0.2), NumberSequenceKeypoint.new(1, 1) })
	emitter.Parent = attachment
	-- Asset-free hearts complement the actual sparkle particles.
	local heart = label(emitterPart, "♥", 32, 32, Vector3.new(0, 3 + i % 3, 0))
	heart.Text.TextColor3 = C.berry
end

Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.Ambient = Color3.fromRGB(145, 130, 151)
Lighting.OutdoorAmbient = Color3.fromRGB(190, 174, 180)
Lighting.GlobalShadows = true
Lighting.ShadowSoftness = 0.5
Lighting.ExposureCompensation = -0.25
local function lightingEffect(class, name)
	local effect = Lighting:FindFirstChild(name)
	if effect and not effect:IsA(class) then effect:Destroy(); effect = nil end
	if not effect then effect = Instance.new(class); effect.Name = name; effect.Parent = Lighting end
	return effect
end
local blur = lightingEffect("BlurEffect", "DessertDreamBlur")
blur.Size = 1.5
local correction = lightingEffect("ColorCorrectionEffect", "DessertPastelColor")
correction.Brightness = -0.02
correction.Contrast = 0.02
correction.Saturation = 0.03
correction.TintColor = Color3.fromRGB(255, 244, 247)
local bloom = lightingEffect("BloomEffect", "DessertSoftBloom")
bloom.Intensity, bloom.Size, bloom.Threshold = 0.12, 20, 1.4

-- Build the same spacious bases as the saved place, without temporary grid parts.
PlotLayout.Apply(map)
map:SetAttribute("LayoutReady", true)
assert(#plots:GetChildren() == 6)
print("[DessertIsland] Built six clean tycoon plots; map v8.0.0")
