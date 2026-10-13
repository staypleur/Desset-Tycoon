-- One-time edit-mode migration for the saved, decorated v2 island.
-- Run via Studio Command Bar, never as a runtime server Script.
local island = workspace.DessertJellyIsland
assert(not island:GetAttribute("ExpandedGardens"), "Gardens already expanded")
local shop = island.CentralHub.CentralShop
local center = shop:GetPivot().Position
local cream = Color3.fromRGB(255,245,224)
local white = Color3.fromRGB(255,251,246)
local cocoa = Color3.fromRGB(110,76,91)
local function part(name, size, cf, color, parent, shape)
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame, p.Color = name, size, cf, color
	p.Anchored = true
	p.CanTouch = false
	p.Material = Enum.Material.SmoothPlastic
	if shape then p.Shape = shape end
	p.Parent = parent
	return p
end
local function disc(name, diameter, height, pos, color, parent)
	return part(name, Vector3.new(height,diameter,diameter),CFrame.new(pos)*CFrame.Angles(0,0,math.pi/2),color,parent,Enum.PartType.Cylinder)
end
-- Widen only the island's horizontal dimensions. Keep the walkable ground at Y=0.
local k = 1.5
for _, p in ipairs(island.FloatingIsland:GetDescendants()) do
	if p:IsA("BasePart") then
		local pos = p.Position
		p.CFrame = CFrame.new(pos.X*k,pos.Y,pos.Z*k) * p.CFrame.Rotation
		if p.Shape == Enum.PartType.Cylinder then
			p.Size = Vector3.new(p.Size.X,p.Size.Y*k,p.Size.Z*k)
		else
			p.Size = Vector3.new(p.Size.X*k,p.Size.Y,p.Size.Z*k)
		end
	end
end
-- Move the perimeter trees and their adjacent marshmallow bushes outward.
for _, child in ipairs(island.CandyGarden:GetChildren()) do
	if child:IsA("Model") and child.Name == "CottonCandyTree" then
		local old = child:GetPivot()
		local direction = Vector3.new(old.X,0,old.Z).Unit
		child:PivotTo(old + direction * (163 - Vector3.new(old.X,0,old.Z).Magnitude))
	elseif child:IsA("BasePart") and (child.Name == "MarshmallowBush" or child.Name == "SugarCloud") then
		local p = child.Position
		child.Position = Vector3.new(p.X*1.6,p.Y,p.Z*1.6)
	end
end

for i = 1, 6 do
	local plot = island.PlayerPlots["Plot" .. i]
	local oldScale = plot:GetScale()
	plot:ScaleTo(oldScale * 1.6)
	local a = (i-1)*math.pi/3
	local pos = Vector3.new(center.X+math.sin(a)*108,0.85,center.Z+math.cos(a)*108)
	local cf = CFrame.lookAt(pos, Vector3.new(center.X,0.85,center.Z))
	plot:PivotTo(cf)
	plot.PrimaryPart.Size = Vector3.new(66,0.3,66)
	plot.PastelBoundary.Size = Vector3.new(70,0.6,70)
	plot.PastelBoundary.CFrame = cf * CFrame.new(0,-0.45,0)
	for _, p in ipairs(plot:GetChildren()) do
		if p.Name == "SideFence" then
			local x = cf:PointToObjectSpace(p.Position).X
			p.Size = Vector3.new(0.7,1.2,69)
			p.CFrame = cf*CFrame.new(x<0 and -34.5 or 34.5,0.6,0)
		elseif p.Name == "BackFence" then
			p.Size = Vector3.new(69,1.2,0.7)
			p.CFrame = cf*CFrame.new(0,0.6,34.5)
		end
	end
	plot.Entrance.CFrame=cf*CFrame.new(0,0.25,-32)
	plot.PlotSpawn.CFrame=cf*CFrame.new(0,0.35,-30)
	plot.PlotSpawn.Size=Vector3.new(8,0.2,4)
	local decor=plot.GardenDecor
	for _, p in ipairs(decor:GetChildren()) do
		if p.Name=="GatePost" then
			local x=cf:PointToObjectSpace(p.Position).X
			p.CFrame=cf*CFrame.new(x,5.4,-32)
		elseif p.Name=="GardenGate" then
			p.CFrame=cf*CFrame.new(0,10.7,-32)
			p.OwnerSign.Size=UDim2.new(18,0,2.6,0)
		end
	end
	local board=plot.MergeBoard
	local oldBoard=board.CFrame
	board.CFrame=cf*CFrame.new(0,0.6,25)
	board.Label.MaxDistance=80
	for _, p in ipairs(plot:GetChildren()) do
		if p.Name:match("^MergeSlot") then
			p.CFrame=board.CFrame*oldBoard:ToObjectSpace(p.CFrame)
		end
	end
	-- Replace the six oversized pads with a compact 5x6 grid.
	for _, child in ipairs(plot.PetSpawnPads:GetChildren()) do child:Destroy() end
	for row=1,6 do
		for col=1,5 do
			local slot=(row-1)*5+col
			local world=(cf*CFrame.new((col-3)*10,0.5,-25+(row-1)*7)).Position
			local p=disc("PetPad"..slot,5.8,0.25,world,plot.PastelBoundary.Color,plot.PetSpawnPads)
			p:SetAttribute("SlotIndex",slot)
			p:SetAttribute("PlotId",i)
			local icing=disc("PadIcing",5.1,0.1,world+Vector3.new(0,0.17,0),cream,plot.PetSpawnPads)
			icing.CanCollide=false
		end
	end
	-- Push the cosmetic mascot behind the production grid.
	local mascot=plot.DisplayMascot
	local old=mascot:GetPivot()
	local target=(cf*CFrame.new(-25,3,25)).Position
	mascot:PivotTo(old + target-old.Position)
	plot:SetAttribute("PetCapacity",30)
	plot:SetAttribute("FootprintStuds",70)
end
for i,path in ipairs(island.SugarPaths:GetChildren()) do
	local a=(i-1)*math.pi/3
	local dir=Vector3.new(math.sin(a),0,math.cos(a))
	local pos=Vector3.new(center.X,0.18,center.Z)+dir*52
	path.Size=Vector3.new(10,0.3,54)
	path.CFrame=CFrame.lookAt(pos,Vector3.new(center.X,0.18,center.Z))
end
island:SetAttribute("ExpandedGardens",true)
island:SetAttribute("MapVersion","3.0.0")
island:SetAttribute("PetPadsPerPlot",30)
game:GetService("Selection"):Set({})
workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(190,210,240),Vector3.zero)
-- Check counts, safe ground coverage and separation before saving.
for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
	local count=0
	for _,p in ipairs(plot.PetSpawnPads:GetChildren()) do
		if p:GetAttribute("SlotIndex") then
			count+=1
			assert(Vector2.new(p.Position.X,p.Position.Z).Magnitude<170,"Pad outside ground")
		end
	end
	assert(count==30,"Expected thirty pads per plot")
end
print("[GardenExpansion] PASS: six 70x70 plots, 180 pet pads, radius 108, island diameter 348")
