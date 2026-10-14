-- Put this single Script in ServerScriptService.
-- Requires one CentralShop Model and six existing Models named Plot1 ... Plot6.
-- Arrange models at startup, reserve a unique plot on join, release it on leave.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local CONFIG = {
	PlotCount = 6,
	Radius = 180, -- widened plots; the saved map's PlotRadius takes precedence
	StartAngleDegrees = 0,
	ModelWaitSeconds = 30,
	CharacterWaitSeconds = 10,
}

local function findUniqueModel(name)
	local found
	for _, item in ipairs(Workspace:GetDescendants()) do
		if item.Name == name and item:IsA("Model") then
			assert(not found, "[PlotAllocator] Duplicate Model named " .. name)
			found = item
		end
	end
	return found
end

-- Bounded startup wait accommodates maps built by another server script.
local deadline = os.clock() + CONFIG.ModelWaitSeconds
local shop, plots
repeat
	shop = findUniqueModel("CentralShop")
	plots = {}
	for i = 1, CONFIG.PlotCount do plots[i] = findUniqueModel("Plot" .. i) end
	local island = Workspace:FindFirstChild("DessertJellyIsland")
	local complete = shop ~= nil and (not island or island:GetAttribute("LayoutReady") ~= false)
	for i = 1, CONFIG.PlotCount do complete = complete and plots[i] ~= nil end
	if complete then break end
	assert(os.clock() < deadline, "[PlotAllocator] CentralShop or Plot1–Plot6 is missing")
	task.wait(0.1)
until false

local center = shop:GetPivot().Position
local island = Workspace:FindFirstChild("DessertJellyIsland")
CONFIG.Radius = island and island:GetAttribute("PlotRadius") or CONFIG.Radius
local plotOwners = {} -- [plotIndex] = Player; the authoritative server state
local assigned = {} -- [Player] = plotIndex
local connections = {} -- [Player] = CharacterAdded connection
local waiting = {} -- FIFO; extra players remain in the hub until a plot is free

local function updateOwnerLabel(index, player)
	local label = plots[index]:FindFirstChild("OwnerLabel", true)
	if label and label:IsA("TextLabel") then
		label.Text = player and (player.Name .. "'s Dessert Plot") or "Available Plot"
	end
end

for i, plot in ipairs(plots) do
	assert(plot:FindFirstChildWhichIsA("BasePart", true), "[PlotAllocator] Empty plot: " .. plot.Name)
	local angle = math.rad(CONFIG.StartAngleDegrees) + (i - 1) * math.pi * 2 / CONFIG.PlotCount
	-- Retain the artist's ground height. The shop pivot may be above its roof/floor.
	local y = plot:GetPivot().Position.Y
	local position = Vector3.new(center.X + math.sin(angle) * CONFIG.Radius, y, center.Z + math.cos(angle) * CONFIG.Radius)
	plot:PivotTo(CFrame.lookAt(position, Vector3.new(center.X, y, center.Z)))
	plot:SetAttribute("PlotId", i)
	plot:SetAttribute("OwnerUserId", 0)
	plot:SetAttribute("OwnerName", "")
	updateOwnerLabel(i, nil)
end

local function getSpawnPart(plot)
	local marker = plot:FindFirstChild("PlotSpawn", true)
	if marker and marker:IsA("BasePart") then return marker end
	local entrance = plot:FindFirstChild("Entrance", true)
	if entrance and entrance:IsA("BasePart") then return entrance end
	return plot.PrimaryPart or plot:FindFirstChildWhichIsA("BasePart", true)
end

local function moveCharacter(player, character)
	local index = assigned[player]
	if not index or player.Parent ~= Players then return end
	local root = character:WaitForChild("HumanoidRootPart", CONFIG.CharacterWaitSeconds)
	-- Waiting yields; recheck ownership, player and character before teleporting.
	if not root or assigned[player] ~= index or player.Parent ~= Players or player.Character ~= character then return end
	local marker = getSpawnPart(plots[index])
	if not marker then return end
	local pos = marker.Position + Vector3.new(0, marker.Size.Y / 2 + 4, 0)
	character:PivotTo(CFrame.lookAt(pos, Vector3.new(center.X, pos.Y, center.Z)))
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
end

local function assign(player)
	if assigned[player] then return true end
	if player.Parent ~= Players then return false end
	for i = 1, CONFIG.PlotCount do
		if not plotOwners[i] then
			-- No yields between checking and reserving: joins cannot share a plot.
			plotOwners[i], assigned[player] = player, i
			plots[i]:SetAttribute("OwnerUserId", player.UserId)
			plots[i]:SetAttribute("OwnerName", player.Name)
			player:SetAttribute("PlotId", i)
			player:SetAttribute("PlotName", plots[i].Name)
			player:SetAttribute("WaitingForPlot", false)
			updateOwnerLabel(i, player)
			if player.Character then task.defer(moveCharacter, player, player.Character) end
			print(string.format("[PlotAllocator] %s -> Plot%d", player.Name, i))
			return true
		end
	end
	return false
end

local function join(player)
	if connections[player] then return end
	connections[player] = player.CharacterAdded:Connect(function(character)
		task.defer(moveCharacter, player, character)
	end)
	if not assign(player) then
		player:SetAttribute("WaitingForPlot", true)
		table.insert(waiting, player)
	end
end

local function leave(player)
	if connections[player] then connections[player]:Disconnect(); connections[player] = nil end
	for i = #waiting, 1, -1 do
		if waiting[i] == player then table.remove(waiting, i) end
	end
	local index = assigned[player]
	assigned[player] = nil
	player:SetAttribute("PlotId", nil)
	player:SetAttribute("PlotName", nil)
	player:SetAttribute("WaitingForPlot", nil)
	if not index then return end
	plotOwners[index] = nil
	plots[index]:SetAttribute("OwnerUserId", 0)
	plots[index]:SetAttribute("OwnerName", "")
	updateOwnerLabel(index, nil)
	-- Drain disconnected queue entries, then give the oldest waiting player the slot.
	while #waiting > 0 do
		local nextPlayer = table.remove(waiting, 1)
		if nextPlayer.Parent == Players and assign(nextPlayer) then break end
	end
end

Players.PlayerAdded:Connect(join)
Players.PlayerRemoving:Connect(leave)
for _, player in ipairs(Players:GetPlayers()) do join(player) end
print("[PlotAllocator] Ready: six circular plots around CentralShop")
