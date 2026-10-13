-- Server-owned session prototype: spawn -> produce -> conveyor -> collect.
-- Cash and pets reset on a new server; persistence and random crates are separate work.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Catalog = require(game.ReplicatedStorage:WaitForChild("DessertCatalog"))
local island = workspace:WaitForChild("DessertJellyIsland",30)
assert(island, "Dessert island missing")
if not island:GetAttribute("ConveyorLayoutVersion") then
	warn("[DessertProduction] Use the saved conveyor place; basic generator has no belts")
	return
end
local states, drops = {}, {}
local function part(parent,name,size,cf,color,shape)
	local p=Instance.new("Part")
	p.Name,p.Size,p.CFrame,p.Color=name,size,cf,color
	p.Anchored,p.CanCollide,p.CanTouch,p.CanQuery=true,false,false,false
	p.Material=Enum.Material.SmoothPlastic
	if shape then p.Shape=shape end
	p.Parent=parent
	return p
end
local function disc(parent,name,diameter,height,cf,color)
	return part(parent,name,Vector3.new(height,diameter,diameter),cf*CFrame.Angles(0,0,math.pi/2),color,Enum.PartType.Cylinder)
end
local function notify(state,text)
	state.plot:SetAttribute("Status",text)
	state.status.Text=text
end
local function update(state)
	state.plot:SetAttribute("PendingCash",state.pending)
	state.plot:SetAttribute("ActiveDesserts",#state.pets)
	state.collection.Text="Collect $"..state.pending
	if state.owner then state.owner.leaderstats.Cash.Value=state.cash end
end
local function spawnPet(state,tier)
	local used={}
	for _,pet in ipairs(state.pets) do used[pet.slot]=true end
	local slot
	for n=1,30 do if not used[n] then slot=n; break end end
	if not slot then return false end
	local pad=state.plot.PetSpawnPads["PetPad"..slot]
	local cf=pad.CFrame
	local model=Instance.new("Model")
	model.Name="Dessert"..slot
	model:SetAttribute("Tier",tier)
	model:SetAttribute("SlotIndex",slot)
	model.Parent=state.models
	local tint= tier==1 and Color3.fromRGB(255,225,158) or Color3.fromHSV((tier*.09)%1,.25,1)
	disc(model,"Plate",3.6,.12,cf*CFrame.new(0,.15,0),Color3.fromRGB(255,248,234))
	disc(model,"Pudding",2.8,1.7,cf*CFrame.new(0,1.1,0),tint)
	disc(model,"Caramel",2.85,.15,cf*CFrame.new(0,2,0),Color3.fromRGB(218,164,131))
	part(model,"Cream",Vector3.new(1.1,.8,1.1),cf*CFrame.new(0,2.4,0),Color3.fromRGB(255,251,244),Enum.PartType.Ball)
	part(model,"Cherry",Vector3.new(.45,.45,.45),cf*CFrame.new(0,2.85,0),Color3.fromRGB(245,146,176),Enum.PartType.Ball)
	for _,x in ipairs({-.5,.5}) do
		part(model,"Eye",Vector3.new(.18,.26,.15),cf*CFrame.new(x,1.2,-1.35),Color3.fromRGB(101,70,82),Enum.PartType.Ball)
	end
	part(model,"Smile",Vector3.new(.22,.09,.13),cf*CFrame.new(0,.85,-1.38),Color3.fromRGB(101,70,82),Enum.PartType.Ball)
	local gui=Instance.new("BillboardGui")
	gui.Size,gui.StudsOffset,gui.MaxDistance=UDim2.new(6,0,1,0),Vector3.new(0,3.6,0),55
	gui.Adornee,gui.Parent=model.Pudding,model.Pudding
	local text=Instance.new("TextLabel")
	text.Size,text.BackgroundTransparency,text.TextScaled=UDim2.fromScale(1,1),1,true
	text.Font,text.TextColor3=Enum.Font.GothamBold,Color3.fromRGB(112,76,91)
	text.Text=Catalog[tier].Name.." - T"..tier
	text.Parent=gui
	table.insert(state.pets,{tier=tier,slot=slot,model=model,nextDrop=os.clock()+1+(slot%6)*.35})
	update(state)
	return true
end
local function reset(state)
	state.generation+=1
	for n=#drops,1,-1 do
		if drops[n].state==state then drops[n].part:Destroy(); table.remove(drops,n) end
	end
	state.models:ClearAllChildren()
	state.pets={}
	state.pending,state.cash=0,25
	state.owner=Players:GetPlayerByUserId(state.plot:GetAttribute("OwnerUserId") or 0)
	if state.owner then
		local stats=state.owner:FindFirstChild("leaderstats")
		if not stats then
			stats=Instance.new("Folder")
			stats.Name,stats.Parent="leaderstats",state.owner
		end
		local cash=stats:FindFirstChild("Cash") or Instance.new("IntValue")
		cash.Name,cash.Parent="Cash",stats
		spawnPet(state,1)
		notify(state,"Welcome! Your pudding produces every 5 seconds.")
	else notify(state,"Claimed automatically when you join") end
	update(state)
end
local function authorized(state,player,pad)
	if state.owner~=player or state.plot:GetAttribute("OwnerUserId")~=player.UserId then return false end
	local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	return root and humanoid and humanoid.Health>0 and (root.Position-pad.Position).Magnitude<=14
end
local function prompt(state,pad,action,callback)
	local p=Instance.new("ProximityPrompt")
	p.ActionText,p.ObjectText,p.MaxActivationDistance=action,"Dessert Cafe",10
	p.RequiresLineOfSight,p.HoldDuration=false,.2
	p.Parent=pad
	p.Triggered:Connect(function(player)
		if not authorized(state,player,pad) then return end
		local now=os.clock()
		if now-(state.lastAction or 0)<.35 then return end
		state.lastAction=now
		callback()
	end)
	pad:SetAttribute("GameplayConnected",true)
end
local function emit(state,pet,now)
	local pad=state.plot.PetSpawnPads["PetPad"..pet.slot]
	local cf=state.plot:GetPivot()
	local pos=cf:PointToObjectSpace(pad.Position)
	local laneZ=pad:GetAttribute("DropLaneZ")
	local points={Vector3.new(pos.X,3,laneZ-1.25),Vector3.new(pos.X,1,laneZ),Vector3.new(0,1,laneZ),Vector3.new(0,1,-1)}
	local durations={.55,math.abs(pos.X)/7,(laneZ+1)/7}
	local product=Instance.new("Model")
	product.Name,product.Parent="DessertDrop",state.products
	disc(product,"MiniPudding",.8,.6,CFrame.new(),pet.model.Pudding.Color)
	disc(product,"CaramelTop",.82,.08,CFrame.new(0,.34,0),Color3.fromRGB(218,164,131))
	part(product,"Cream",Vector3.new(.3,.25,.3),CFrame.new(0,.49,0),Color3.fromRGB(255,251,244),Enum.PartType.Ball)
	product.WorldPivot=CFrame.new()
	product:PivotTo(cf*CFrame.new(points[1]))
	product:SetAttribute("Value",2^(pet.tier-1))
	table.insert(drops,{part=product,state=state,generation=state.generation,owner=state.owner,points=points,durations=durations,start=now,cf=cf,value=2^(pet.tier-1)})
end
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]
	local models=Instance.new("Folder")
	models.Name,models.Parent="ActiveDesserts",plot
	local products=Instance.new("Folder")
	products.Name,products.Parent="MovingDesserts",plot
	local state={plot=plot,models=models,products=products,pets={},pending=0,cash=25,generation=0,collection=plot.Conveyors.Collector.CollectorSign.CollectionLabel}
	local gui=Instance.new("BillboardGui")
	gui.Name,gui.Size,gui.StudsOffset,gui.MaxDistance="ProductionStatus",UDim2.new(18,0,1,0),Vector3.new(0,5,0),35
	gui.Parent=plot.MergeBoard
	local text=Instance.new("TextLabel")
	text.Size,text.TextScaled,text.BackgroundTransparency=UDim2.fromScale(1,1),true,1
	text.Font,text.TextColor3=Enum.Font.GothamBold,Color3.fromRGB(112,76,91)
	text.Parent=gui
	state.status=text
	table.insert(states,state)
	for _,count in ipairs({1,5,25,100}) do
		prompt(state,plot.PurchaseButtons["Buy"..count],"Buy "..count.." ($"..tostring(count*5)..")",function()
			if #state.pets+count>30 then notify(state,"Not enough space. Merge desserts first."); return end
			if state.cash<count*5 then notify(state,"Not enough cash. Collect your earnings."); return end
			state.cash-=count*5
			for _=1,count do spawnPet(state,1) end
			notify(state,"Purchased "..count.." pudding(s)")
			update(state)
		end)
	end
	local function collect()
		local amount=state.pending
		state.cash+=amount
		state.pending=0
		notify(state,"Collected $"..amount)
		update(state)
	end
	prompt(state,plot.Conveyors.Collector,"Collect Earnings",collect)
	prompt(state,plot.PersonalShopArea.CollectIncome,"Collect Earnings",collect)
	prompt(state,plot.MergeBoard,"Merge 3 Matching Desserts",function()
		for tier=1,#Catalog-1 do
			local chosen={}
			for n,pet in ipairs(state.pets) do if pet.tier==tier then table.insert(chosen,n); if #chosen==3 then break end end end
			if #chosen==3 then
				for n=3,1,-1 do local pet=table.remove(state.pets,chosen[n]); pet.model:Destroy() end
				spawnPet(state,tier+1)
				notify(state,"Merged into "..Catalog[tier+1].Name)
				return
			end
		end
		notify(state,"You need 3 matching desserts below tier 30.")
	end)
	plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function() reset(state) end)
	reset(state)
end
local accumulated=0
RunService.Heartbeat:Connect(function(dt)
	accumulated+=dt
	if accumulated<.05 then return end
	accumulated=0
	local now=os.clock()
	for _,state in ipairs(states) do
		if state.owner and state.owner.Parent==Players then
			for _,pet in ipairs(state.pets) do
				if now>=pet.nextDrop then emit(state,pet,now); pet.nextDrop=now+5 end
			end
		end
	end
	for n=#drops,1,-1 do
		local drop=drops[n]
		local elapsed=now-drop.start
		local segment=1
		while segment<=3 and elapsed>=drop.durations[segment] do elapsed-=drop.durations[segment]; segment+=1 end
		if drop.generation~=drop.state.generation or drop.owner~=drop.state.owner then
			drop.part:Destroy(); table.remove(drops,n)
		elseif segment>3 then
			drop.state.pending+=drop.value
			update(drop.state)
			drop.part:Destroy(); table.remove(drops,n)
		else
			local pos=drop.points[segment]:Lerp(drop.points[segment+1],elapsed/drop.durations[segment])
			drop.part:PivotTo(drop.cf*CFrame.new(pos)*CFrame.Angles(now*4,0,now*3))
		end
	end
end)
print("[DessertProduction] Ready: owner-only buys, 3-to-1 merges, five-second production, conveyors and collection; session data")
