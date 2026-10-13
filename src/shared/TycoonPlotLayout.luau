-- Shared by the fresh map generator and the edit-mode layout migration.
-- Thirty invisible placement markers are gameplay data, not visible floor tiles.
local Layout = { Radius = 150, Width = 96, Depth = 120, IslandDiameter = 460 }
local pink = Color3.fromRGB(255,193,218)
local lavender = Color3.fromRGB(211,198,248)
local mint = Color3.fromRGB(185,235,211)
local cream = Color3.fromRGB(255,248,235)
local cocoa = Color3.fromRGB(112,76,91)
local function part(parent,name,size,cf,color,solid)
	local p=Instance.new("Part")
	p.Name,p.Size,p.CFrame,p.Color=name,size,cf,color
	p.Anchored,p.CanCollide,p.CanTouch=true,solid~=false,false
	p.Material=Enum.Material.SmoothPlastic
	p.TopSurface,p.BottomSurface=Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth
	p.Parent=parent
	return p
end
local function model(parent,name)
	local m=Instance.new("Model"); m.Name,m.Parent=name,parent; return m
end
local function label(p,name,text,width)
	local gui=Instance.new("BillboardGui")
	gui.Name,gui.Size,gui.StudsOffset,gui.MaxDistance=name,UDim2.new(width or 8,0,1.5,0),Vector3.new(0,2.5,0),55
	gui.Adornee,gui.Parent=p,p
	local t=Instance.new("TextLabel")
	t.Name,t.Size,t.BackgroundTransparency,t.TextScaled="CollectionLabel",UDim2.fromScale(1,1),1,true
	t.Text,t.Font,t.TextColor3=text,Enum.Font.GothamBold,cocoa; t.Parent=gui
	return gui
end
function Layout.Apply(island)
	assert(not island:GetAttribute("CleanPlotLayoutVersion"),"Clean layout already applied")
	local hub=island.CentralHub
	local center=hub.CentralShop:GetPivot().Position
	local template=game.ServerStorage:FindFirstChild("CentralCafeTemplate")
	if not hub.CentralShop:FindFirstChild("CenterAnchor") then
		if not template then
			template=model(game.ServerStorage,"CentralCafeTemplate")
			hub.CentralShop.Parent=template
			if hub:FindFirstChild("GiantPudding") then hub.GiantPudding.Parent=template end
		else
			hub.CentralShop:Destroy()
			if hub:FindFirstChild("GiantPudding") then hub.GiantPudding:Destroy() end
		end
		local anchorModel=model(hub,"CentralShop")
		local anchor=part(anchorModel,"CenterAnchor",Vector3.new(.2,.2,.2),CFrame.new(center),cream,false)
		anchor.Transparency,anchor.CanQuery=1,false; anchorModel.PrimaryPart=anchor
		if not hub:FindFirstChild("CentralDisplay") then model(hub,"CentralDisplay") end
	end
	-- Expand the circular island once, without scaling the cafes or tree meshes.
	local ground=island.FloatingIsland.MintIcingGround
	local factor=Layout.IslandDiameter/ground.Size.Y
	for _,p in ipairs(island.FloatingIsland:GetDescendants()) do
		if p:IsA("BasePart") then
			local pos=p.Position; p.CFrame=CFrame.new(pos.X*factor,pos.Y,pos.Z*factor)*p.CFrame.Rotation
			if p.Shape==Enum.PartType.Cylinder then p.Size=Vector3.new(p.Size.X,p.Size.Y*factor,p.Size.Z*factor)
			else p.Size=Vector3.new(p.Size.X*factor,p.Size.Y,p.Size.Z*factor) end
		end
	end
	for _,groupName in ipairs({"CandyGarden","SakuraGarden"}) do
		local garden=island:FindFirstChild(groupName)
		if garden then for _,item in ipairs(garden:GetChildren()) do
			if item:IsA("PVInstance") then
				local old=item:GetPivot(); local radial=Vector3.new(old.X,0,old.Z)
				if radial.Magnitude>100 then item:PivotTo(old+radial.Unit*(radial.Magnitude*(factor-1))) end
			end
		end end
	end
	if island:FindFirstChild("SugarPaths") then island.SugarPaths:ClearAllChildren() end
	local archive=Instance.new("Folder"); archive.Name,archive.Parent="PreviousPlotDecor",game.ServerStorage
	for i=1,6 do
		local plot=island.PlayerPlots["Plot"..i]
		local old=plot:GetPivot(); local angle=(i-1)*math.pi/3
		local position=Vector3.new(center.X+math.sin(angle)*Layout.Radius,old.Y,center.Z+math.cos(angle)*Layout.Radius)
		local cf=CFrame.lookAt(position,Vector3.new(center.X,old.Y,center.Z))
		plot:PivotTo(cf)
		local area=plot:FindFirstChild("PersonalShopArea") or model(plot,"PersonalShopArea")
		local cafe=area:FindFirstChild("DessertCafe")
		if not cafe then cafe=template:Clone(); cafe.Name,cafe.Parent="DessertCafe",area; cafe.CentralShop.Name="CafeBuilding" end
		local owner=cafe:FindFirstChild("OwnerSign",true)
		local box,size=cafe:GetBoundingBox()
		cafe:PivotTo(cf*CFrame.new(0,.15+size.Y/2,-42)*box:ToObjectSpace(cafe:GetPivot()))
		if not owner then owner=label(cafe.CafeBuilding.Roof,"OwnerSign","Available Cafe",18); owner.CollectionLabel.Name="OwnerLabel" end
		owner.StudsOffset=Vector3.new(0,15,0)
		for _,child in ipairs(plot:GetChildren()) do
			if child~=area then
				if child.Name=="GardenDecor" or child.Name:match("DisplayMascot") then child.Parent=archive
				else child:Destroy() end
			end
		end
		for _,child in ipairs(area:GetChildren()) do if child~=cafe then child:Destroy() end end
		local function at(x,y,z) return cf*CFrame.new(x,y,z) end
		local function p(parent,name,size,x,y,z,color,solid) return part(parent,name,size,at(x,y,z),color,solid) end
		-- One uninterrupted smooth base, four low edge trims, no stud/grid floor.
		local floor=p(plot,"PlotFloor",Vector3.new(96,1,120),0,-.35,0,cream)
		plot.PrimaryPart=floor
		-- Keep the pivot at the original gameplay origin rather than the floor's center.
		floor.PivotOffset=CFrame.new(0,.35,0)
		for _,x in ipairs({-47.5,47.5}) do p(plot,"SideFence",Vector3.new(1,.6,120),x,.35,0,i%2==0 and lavender or pink) end
		p(plot,"BackFence",Vector3.new(94,.6,1),0,.35,59.5,lavender)
		p(plot,"FrontTrim",Vector3.new(94,.25,1),0,.27,-59.5,pink)
		p(plot,"Entrance",Vector3.new(10,.1,5),30,.2,-57,mint)
		p(plot,"PlotSpawn",Vector3.new(8,.1,6),30,.2,-51,mint)
		local board=p(plot,"MergeBoard",Vector3.new(18,.6,18),-27,.45,-4,lavender)
		board:SetAttribute("RequiredCount",3); label(board,"MergeSign","Merge 3 into 1",10)
		local cells=model(plot,"MergeCells")
		for row=1,3 do for col=1,3 do
			p(cells,"Cell"..((row-1)*3+col),Vector3.new(4.8,.05,4.8),-27+(col-2)*5.3,.78,-4+(row-2)*5.3,cream,false)
		end end
		local buttons=model(plot,"PurchaseButtons")
		for n,count in ipairs({1,5,25,100}) do
			local x=n<=2 and -25 or 25; local z=(n==1 or n==3) and -32 or -22
			local pad=p(buttons,"Buy"..count,Vector3.new(9,.3,6),x,.3,z,lavender)
			label(pad,"BuySign","Buy "..count.." ($"..tostring(count*5)..")",9)
		end
		label(p(area,"CollectIncome",Vector3.new(9,.3,6),-25,.3,-47,mint),"IncomeSign","Collect Earnings",9)
		local crate=p(area,"DessertCrate",Vector3.new(9,.3,6),25,.3,-47,pink)
		crate:SetAttribute("GameplayConnected",false); label(crate,"CrateSign","Dessert Crate - Coming Soon",10)
		-- Two broad meadows, with no visible rows or individual pet pads.
		local beds=model(plot,"ProductionBeds")
		for _,side in ipairs({-1,1}) do
			p(beds,side<0 and "LeftMeadow" or "RightMeadow",Vector3.new(40,2,56),side*24,1.25,27,mint)
			p(beds,"MeadowStep",Vector3.new(40,1,3),side*24,.65,-2,cream)
		end
		local pads=model(plot,"PetSpawnPads")
		for slot=1,30 do
			local row=math.ceil(slot/6); local column=(slot-1)%6+1
			local x=({-36,-24,-12,12,24,36})[column]; local z=4+(row-1)*11
			local pad=p(pads,"PetPad"..slot,Vector3.new(1,.1,1),x,2.32,z,mint,false)
			pad.Transparency,pad.CanQuery=1,false
			pad:SetAttribute("SlotIndex",slot); pad:SetAttribute("PlotId",i); pad:SetAttribute("DropLaneZ",z)
		end
		local belts=model(plot,"Conveyors")
		local main=p(belts,"MainBelt",Vector3.new(8,.25,74),0,.4,18,Color3.fromRGB(175,159,188))
		main:SetAttribute("FlowDirection","TowardCafe")
		-- Wide bridges make both meadows accessible; rolling goods pass underneath.
		for _,z in ipairs({0,26,52}) do p(belts,"WalkwayBridge",Vector3.new(12,.3,4),0,2.1,z,cream) end
		local collector=p(belts,"Collector",Vector3.new(8,.8,3),0,.6,-20,mint)
		label(collector,"CollectorSign","Collect $0",9)
		plot:SetAttribute("LayoutStyle","CleanTycoonBase")
		plot:SetAttribute("CollectorZ",-20)
		plot:SetAttribute("ProductionBedCount",2)
		plot:SetAttribute("OwnerUserId",0)
		local pathCenter=(Vector3.new(center.X,position.Y,center.Z)+at(30,0,-60).Position)/2
		local endpoint=at(30,0,-60).Position
		part(island.SugarPaths,"CreamPath",Vector3.new(14,.3,(endpoint-Vector3.new(center.X,position.Y,center.Z)).Magnitude),CFrame.lookAt(pathCenter,endpoint)*CFrame.new(0,-.55,0),cream)
	end
	island:SetAttribute("CleanPlotLayoutVersion",1)
	island:SetAttribute("ConveyorLayoutVersion",2)
	island:SetAttribute("MapVersion","8.0.0")
	island:SetAttribute("PlotRadius",Layout.Radius)
	print("[CleanPlots] Built six 96x120 bases, side merge boards, open meadows and wide conveyors")
end
return Layout
