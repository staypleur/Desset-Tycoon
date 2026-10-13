-- Edit-mode integration test. Unparented plot clones and mock players; no live player data.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play first")
local fixture=Instance.new("Model")
fixture.Name="DessertJellyIsland"
fixture:SetAttribute("ConveyorLayoutVersion",1)
local plots=Instance.new("Model")
plots.Name,plots.Parent="PlayerPlots",fixture
for i=1,6 do
	local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..i]:Clone()
	plot:SetAttribute("OwnerUserId",0)
	plot.Parent=plots
end
local function signal()
	local s={callbacks={}}
	function s:Connect(fn) table.insert(self.callbacks,fn); return {Disconnect=function() end} end
	function s:Fire(...) for _,fn in ipairs(self.callbacks) do fn(...) end end
	return s
end
local heartbeat=signal()
local now=0
local players={}
local function player(id)
	local stats=Instance.new("Folder")
	stats.Name="leaderstats"
	local cash=Instance.new("IntValue")
	cash.Name,cash.Parent="Cash",stats
	local character=Instance.new("Model")
	local root=Instance.new("Part")
	root.Name,root.Anchored,root.Parent="HumanoidRootPart",true,character
	local humanoid=Instance.new("Humanoid")
	humanoid.Parent=character
	local p={UserId=id,Name="Test"..id,Parent=players,Character=character,leaderstats=stats}
	function p:FindFirstChild(name) if name=="leaderstats" then return stats end end
	return p
end
local owner,other=player(1001),player(1002)
function players:GetPlayerByUserId(id) if id==owner.UserId then return owner elseif id==other.UserId then return other end end
local prompts={}
local fakeInstance={}
function fakeInstance.new(class)
	if class~="ProximityPrompt" then return Instance.new(class) end
	local p={Triggered=signal()}
	table.insert(prompts,p)
	return p
end
local services={Players=players,RunService={Heartbeat=heartbeat}}
local fakeGame={ReplicatedStorage=game.ReplicatedStorage}
function fakeGame:GetService(name) return assert(services[name],"Unexpected service "..name) end
local fakeWorkspace={}
function fakeWorkspace:WaitForChild(name) assert(name=="DessertJellyIsland"); return fixture end
local catalog=assert(loadstring(game.ReplicatedStorage.DessertCatalog.Source))()
local run=assert(loadstring(game.ServerScriptService.DessertProduction.Source))
setfenv(run,setmetatable({game=fakeGame,workspace=fakeWorkspace,Instance=fakeInstance,os={clock=function() return now end},require=function() return catalog end},{__index=getfenv()}))
local function execute()
	run()
	local plot=plots.Plot1
	plot:SetAttribute("OwnerUserId",owner.UserId)
	task.wait()
	assert(#plot.ActiveDesserts:GetChildren()==1 and owner.leaderstats.Cash.Value==25,"Starter state")
	local function trigger(pad,p,near)
		p.Character.HumanoidRootPart.CFrame=pad.CFrame*CFrame.new(near==false and 100 or 0,4,0)
		now+=1
		for _,prompt in ipairs(prompts) do if prompt.Parent==pad then prompt.Triggered:Fire(p); return end end
		error("Missing prompt for "..pad.Name)
	end
	trigger(plot.PurchaseButtons.Buy1,other)
	assert(#plot.ActiveDesserts:GetChildren()==1,"Another player purchased")
	trigger(plot.PurchaseButtons.Buy1,owner,false)
	assert(#plot.ActiveDesserts:GetChildren()==1,"Remote purchase accepted")
	trigger(plot.PurchaseButtons.Buy25,owner)
	assert(#plot.ActiveDesserts:GetChildren()==1 and owner.leaderstats.Cash.Value==25,"Insufficient cash must not spend")
	trigger(plot.PurchaseButtons.Buy1,owner)
	trigger(plot.PurchaseButtons.Buy1,owner)
	assert(#plot.ActiveDesserts:GetChildren()==3 and owner.leaderstats.Cash.Value==15,"Purchase cost/count")
	trigger(plot.MergeBoard,owner)
	assert(#plot.ActiveDesserts:GetChildren()==1 and plot.ActiveDesserts:GetChildren()[1]:GetAttribute("Tier")==2,"Three-to-one merge")
	for _=1,400 do now+=.1; heartbeat:Fire(.1) end
	local pending=plot:GetAttribute("PendingCash")
	assert(pending>=2 and pending%2==0,"Conveyor value must arrive once per tier-two drop")
	assert(#plot.MovingDesserts:GetChildren()>0,"No moving products")
	trigger(plot.Conveyors.Collector,other)
	assert(plot:GetAttribute("PendingCash")==pending,"Other player collected")
	trigger(plot.Conveyors.Collector,owner)
	assert(plot:GetAttribute("PendingCash")==0 and owner.leaderstats.Cash.Value==15+pending,"Collection credit")
	trigger(plot.Conveyors.Collector,owner)
	assert(owner.leaderstats.Cash.Value==15+pending,"Double collection")
	-- Insufficient capacity must preserve cash and pets.
	trigger(plot.PurchaseButtons.Buy100,owner)
	assert(#plot.ActiveDesserts:GetChildren()==1 and owner.leaderstats.Cash.Value==15+pending,"Capacity check")
	plot:SetAttribute("OwnerUserId",0)
	task.wait()
	assert(#plot.ActiveDesserts:GetChildren()==0 and #plot.MovingDesserts:GetChildren()==0,"Owner release cleanup")
	plot:SetAttribute("OwnerUserId",other.UserId)
	task.wait()
	assert(other.leaderstats.Cash.Value==25 and plot:GetAttribute("PendingCash")==0,"New owner received old earnings")
	print("[ProductionTest] PASS: starter, owner/distance guards, purchases, capacity/cash guards, merge, moving products, arrival/collection, duplicate collection, owner cleanup")
end
local ok,err=xpcall(execute,debug.traceback)
fixture:Destroy()
owner.Character:Destroy(); other.Character:Destroy()
owner.leaderstats:Destroy(); other.leaderstats:Destroy()
if not ok then error(err) end
