-- Run from the Studio Command Bar in Edit mode:
-- loadstring(<this source>)()
-- Tests use fake player signals and a temporary folder, never real player data.
local source = game.ServerScriptService.PlotAllocator.Source
local folder = Instance.new("Folder")
folder.Name = "AllocatorTestFixture"
local signals = {}
local function signal()
	-- BindableEvent serializes table arguments, so it would copy fake Players.
	-- These synchronous mock signals preserve identity just like real Players.
	local event = { callbacks = {} }
	event.Event = event
	function event:Connect(callback)
		local connection = { Connected = true }
		function connection:Disconnect() self.Connected = false end
		table.insert(self.callbacks, { callback, connection })
		return connection
	end
	function event:Fire(...)
		for _, entry in ipairs(self.callbacks) do
			if entry[2].Connected then entry[1](...) end
		end
	end
	function event:Destroy() table.clear(self.callbacks) end
	table.insert(signals, event)
	return event
end
local added, removing = signal(), signal()
local fakePlayers = { PlayerAdded = added.Event, PlayerRemoving = removing.Event }
local initial = {}
function fakePlayers:GetPlayers() return initial end
local function player(id)
	local char = signal()
	local p = { UserId = id, Name = "Test" .. id, DisplayName = "Test" .. id,
		Parent = fakePlayers, CharacterAdded = char.Event, attributes = {} }
	function p:SetAttribute(k, v) self.attributes[k] = v end
	return p
end
local function model(name, pos)
	local m = Instance.new("Model")
	m.Name = name
	local p = Instance.new("Part")
	p.Name = name == "CentralShop" and "ShopBase" or "PlotSpawn"
	p.Anchored = true
	p.Size = Vector3.new(8, 1, 8)
	p.Position = pos
	p.Parent = m
	m.PrimaryPart = p
	m.Parent = folder
	return m
end
model("CentralShop", Vector3.new(100, 30, -200))
for i = 1, 6 do model("Plot" .. i, Vector3.new(i, 5, 0)) end
for i = 1, 7 do initial[i] = player(i) end
local fakeGame = {}
function fakeGame:GetService(name)
	if name == "Players" then return fakePlayers end
	if name == "Workspace" then return folder end
	error("Unexpected service " .. name)
end
local ok, err = pcall(function()
	local run = assert(loadstring(source))
	local env = setmetatable({ game = fakeGame }, { __index = getfenv() })
	setfenv(run, env)
	run()
	for i = 1, 6 do
		assert(initial[i].attributes.PlotId == i, "Unique assignment failed")
		local pos = folder["Plot" .. i]:GetPivot().Position
		assert(math.abs(Vector2.new(pos.X - 100, pos.Z + 200).Magnitude - 70) < 0.01, "Shop-relative radius failed")
		assert(math.abs(pos.Y - 5) < 0.01, "Ground height was changed")
	end
	assert(initial[7].attributes.WaitingForPlot and not initial[7].attributes.PlotId, "Full server queue failed")
	removing:Fire(initial[3]); task.wait()
	assert(initial[7].attributes.PlotId == 3, "Released plot not reused by queue")
	assert(not initial[3].attributes.PlotId, "Departed player retains assignment")
	added:Fire(initial[1]); task.wait()
	assert(initial[1].attributes.PlotId == 1, "Duplicate join changed assignment")
	local character = Instance.new("Model")
	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Anchored = true
	root.Parent = character
	character.Parent = folder
	initial[1].Character = character
	-- Find this fake player's CharacterAdded signal.
	local charEvent = signals[3]
	charEvent:Fire(character); task.wait(); task.wait()
	local expected = folder.Plot1.PlotSpawn.Position + Vector3.new(0, 4.5, 0)
	assert((character:GetPivot().Position - expected).Magnitude < 0.01, "Character spawn failed")
	root.Position = Vector3.zero
	charEvent:Fire(character); task.wait(); task.wait()
	assert((character:GetPivot().Position - expected).Magnitude < 0.01, "Respawn failed")
	local eighth = player(8)
	added:Fire(eighth); task.wait()
	removing:Fire(eighth); eighth.Parent = nil; task.wait()
	removing:Fire(initial[2]); task.wait()
	assert(folder.Plot2:GetAttribute("OwnerUserId") == 0, "Disconnected queue entry was assigned")
	print("[PlotAllocatorTest] PASS: offset center, height, six unique owners, queue, release, duplicate join, spawn/respawn")
end)
for _, p in ipairs(initial) do removing:Fire(p) end
task.wait()
for _, event in ipairs(signals) do event:Destroy() end
folder:Destroy()
assert(ok, err)
