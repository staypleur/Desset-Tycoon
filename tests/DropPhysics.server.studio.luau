-- Temporary Play server regression. Remove the runner before saving the place.
local Physics=require(game.ServerScriptService.DessertDropPhysics)
local Visuals=require(game.ReplicatedStorage.DessertVisuals)
local arena=Instance.new("Folder");arena.Name="DropPhysicsRegression";arena.Parent=workspace
local drops={}
local connection
local ok,err=xpcall(function()
	local floor=Instance.new("Part");floor.Anchored=true;floor.Size=Vector3.new(280,1,60)
	floor.Position=Vector3.new(0,1000,0);floor.Parent=arena
	local function spawn(position,goal)
		local model=Visuals.BuildMini(1,false);model:PivotTo(CFrame.new(position))
		local d=Physics.New(model,{position,goal,goal,goal,goal},arena)
		table.insert(drops,d);return d
	end
	local a=spawn(Vector3.new(-100,1001,0),Vector3.new(-90,1001,0))
	local b=spawn(Vector3.new(-99.7,1001,0),Vector3.new(-90,1001,0))
	assert(a.Body:CanCollideWith(b.Body),"Drops collide with drops")
	assert(a.Body:GetNetworkOwner()==nil,"Server owns physics")
	local character=Instance.new("Model");character.Parent=arena
	local limb=Instance.new("Part");limb.Anchored=true;limb.Parent=character;Physics.Character(character)
	assert(not a.Body:CanCollideWith(limb),"Players cannot shove the economy bodies")
	local initial=a.Body.CFrame
	connection=game:GetService("RunService").Heartbeat:Connect(function() for _,d in ipairs(drops) do Physics.Step(d) end end)
	task.wait(2)
	assert((a.Body.Position-initial.Position).Magnitude>2,"Real translation")
	assert(a.Body.CFrame.UpVector:Dot(initial.UpVector)<.99,"Ground contact rolls the body")
	assert((a.Body.Position-b.Body.Position).Magnitude>=a.Body.Size.X*.85,"Contact separates bodies")
	print("[DropPhysics] PASS: server ownership, rolling, collision separation, character exclusion")
	a.Model:Destroy();b.Model:Destroy();table.clear(drops)
	for plot=1,6 do for i=1,100 do
		local position=Vector3.new(-105+(plot-1)*40+((i-1)%10)*1.1,1001,math.floor((i-1)/10)*1.1-5)
		spawn(position,position+Vector3.new(15,0,0))
	end end
	local samples,total,worst=0,0,0
	local timing=game:GetService("RunService").Heartbeat:Connect(function(dt) samples+=1;total+=dt;worst=math.max(worst,dt) end)
	task.wait(6);timing:Disconnect()
	assert(#drops==600 and samples>20)
	for _,d in ipairs(drops) do assert(d.Body.Position.Y>1000 and d.Body:GetNetworkOwner()==nil) end
	print("[DropPhysicsStress] PASS: 600 simple bodies, 6x100 cap; Heartbeat mean ms",total/samples*1000,"max ms",worst*1000,"samples",samples)
end,debug.traceback)
if connection then connection:Disconnect() end
arena:Destroy()
if not ok then error(err) end
