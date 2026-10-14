-- Large ground surfaces and pocket gardens; no new gameplay scripts in imported props.
local Landscape={}
local cream=Color3.fromRGB(249,239,221)
local pink=Color3.fromRGB(245,190,211)
local lavender=Color3.fromRGB(204,188,228)
local grass=Color3.fromRGB(180,238,191)
local function group(parent,name)
	local m=Instance.new("Model"); m.Name,m.Parent=name,parent; return m
end
local function part(parent,name,size,cf,color,material,shape,solid)
	local p=Instance.new("Part")
	p.Name,p.Size,p.CFrame,p.Color=name,size,cf,color
	p.Material=material or Enum.Material.SmoothPlastic
	p.Shape=shape or Enum.PartType.Block
	p.Anchored,p.CanCollide,p.CanTouch=true,solid==true,false
	p.TopSurface,p.BottomSurface=Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth
	p.Parent=parent; return p
end
local function place(source,parent,name,cf,maxSize,recolor)
	if not source then return end
	local m=group(nil,name)
	local copy=source:Clone(); copy.Parent=m
	local box,size=m:GetBoundingBox()
	m:ScaleTo(m:GetScale()*maxSize/math.max(size.X,size.Y,size.Z))
	box,size=m:GetBoundingBox()
	m:PivotTo(cf*CFrame.new(0,size.Y/2,0)*box:ToObjectSpace(m:GetPivot()))
	for _,p in ipairs(m:GetDescendants()) do
		assert(not p:IsA("LuaSourceContainer"),"Imported decoration contains code")
		if p:IsA("BasePart") then
			p.Anchored,p.CanCollide,p.CanTouch,p.CanQuery=true,false,false,false
			if recolor then recolor(p) end
		elseif p:IsA("Light") then p.Color=Color3.fromRGB(255,229,196); p.Brightness=.35; p.Range=8
		elseif p:IsA("Beam") then p.Enabled=false end
	end
	m:SetAttribute("DecorationOnly",true)
	m.Parent=parent; return m,size
end
local function solidTint(p,color)
	if p:IsA("MeshPart") then p.TextureID="" end
	for _,d in ipairs(p:GetChildren()) do
		if d:IsA("SpecialMesh") then d.TextureId=""
		elseif d:IsA("SurfaceAppearance") or d:IsA("Decal") or d:IsA("Texture") then d:Destroy() end
	end
	p.Color=color; p.Material=Enum.Material.SmoothPlastic
end
function Landscape.Apply(island)
	assert(not island:GetAttribute("LandscapeVersion"),"Landscape already applied")
	local storage=game.ServerStorage
	local assets=storage:FindFirstChild("FreeEnvironmentAssets")
	local function asset(name) return assets and assets:FindFirstChild(name) end
	local meadow=asset("MeadowPack")
	local grassMesh=meadow and meadow:FindFirstChild("Grass",true)
	local rockMesh=meadow and meadow:FindFirstChild("Rock",true)
	local terrainTop=meadow and meadow:FindFirstChild("Terrain Top",true)
	local nature=asset("NaturePack")
	local roundRock=nature and nature:FindFirstChild("Meshes/lowpolypack_Icosphere",true)
	local world=group(island,"Landscape")
	local ground=island.FloatingIsland.MintIcingGround
	ground.Color,ground.Material=grass,Enum.Material.Grass
	for _,p in ipairs(island.FloatingIsland:GetChildren()) do
		if p.Name=="ScallopedIcing" then p.Color=grass; p.Material=Enum.Material.Grass end
	end
	island.FloatingIsland.PinkCakeLayer.Material=Enum.Material.Sandstone
	island.FloatingIsland.PinkCakeLayer.Color=Color3.fromRGB(227,183,195)
	island.FloatingIsland.LavenderCakeLayer.Material=Enum.Material.Slate
	island.FloatingIsland.LavenderCakeLayer.Color=Color3.fromRGB(197,181,207)
	for _,path in ipairs(island.SugarPaths:GetChildren()) do
		path.Material,path.Color=Enum.Material.Limestone,cream
		for _,side in ipairs({-1,1}) do
			part(world,"PathEdging",Vector3.new(1,.2,path.Size.Z),path.CFrame*CFrame.new(side*(path.Size.X/2+.6),.12,0),Color3.fromRGB(219,207,195),Enum.Material.Slate)
		end
	end
	-- Sculpted ellipsoid hills sit only between plots; the central display remains empty.
	local center=island.CentralHub.CentralShop:GetPivot().Position
	local gardens=group(world,"PocketGardens")
	for i=1,6 do
		local angle=(i-.5)*math.pi/3
		local origin=Vector3.new(center.X+math.sin(angle)*160,0,center.Z+math.cos(angle)*160)
		local cf=CFrame.new(origin)*CFrame.Angles(0,angle,0)
		local garden=group(gardens,"Garden"..i)
		local hill=part(garden,"SoftGrassHill",Vector3.new(42,10,46),cf*CFrame.new(0,-3,0),grass,Enum.Material.Grass,Enum.PartType.Ball,true)
		hill:SetAttribute("LandscapeGround",true)
		part(garden,"SmallGrassHill",Vector3.new(26,6,25),cf*CFrame.new(5,-1.8,8),Color3.fromRGB(219,240,210),Enum.Material.Grass,Enum.PartType.Ball,true)
		place(storage:FindFirstChild("FreeSakuraTemplate"),garden,"BlossomTree",cf*CFrame.new(0,2,0),18)
		-- A low-poly ground mesh rounds out the small garden's shape.
		place(terrainTop,garden,"LowPolyGrassBank",cf*CFrame.new(-3,-1.2,-4),24,function(p) solidTint(p,grass) end)
		for n=1,5 do
			local a=n*math.pi*2/5
			local rock=place(n%2==0 and rockMesh or roundRock,garden,"PastelRock",cf*CFrame.new(math.sin(a)*18,0,math.cos(a)*17),3+n%3,function(p) solidTint(p,n%2==0 and lavender or cream) end)
			if rock then rock:SetAttribute("SourceAssetId",n%2==0 and 18723685255 or 14299404156) end
			place(storage:FindFirstChild("FreeFlowerTemplate"),garden,"FlowerCluster",cf*CFrame.new(math.sin(a)*14,1.1,math.cos(a)*13),4)
		end
		place(storage:FindFirstChild("FreeBenchTemplate"),garden,"GardenBench",cf*CFrame.new(0,0,-24),9,function(p) p.Material=Enum.Material.WoodPlanks; p.Color=cream end)
	end
	for i=1,6 do
		local plot=island.PlayerPlots["Plot"..i]; local cf=plot:GetPivot()
		local decor=group(plot,"CafeGardenDecor"); decor:SetAttribute("PlotId",i)
		local function at(x,y,z) return cf*CFrame.new(x,y,z) end
		plot.PlotFloor.Material,plot.PlotFloor.Color=Enum.Material.Limestone,cream
		for _,p in ipairs(plot.ProductionBeds:GetChildren()) do
			if p.Name:match("Meadow$") then p.Material,p.Color=Enum.Material.Grass,Color3.fromRGB(190,245,205) end
		end
		-- Broad material zones define the cafe, pedestrian forecourt and grassy field.
		part(decor,"BakeryTerrace",Vector3.new(32,.08,27),at(0,.19,-42),Color3.fromRGB(239,211,205),Enum.Material.WoodPlanks,nil,true)
		part(decor,"TeaPatio",Vector3.new(18,.08,17),at(34,.19,-4),Color3.fromRGB(240,216,224),Enum.Material.Limestone,nil,true)
		part(decor,"PatioBorder",Vector3.new(19,.05,18),at(34,.12,-4),lavender,Enum.Material.Slate)
		for _,pos in ipairs({Vector3.new(35,.24,-4),Vector3.new(-38,.24,-38)}) do
			place(asset("CafeSeating"),decor,"CafeTableAndChairs",cf*CFrame.new(pos),9,function(p)
				solidTint(p,p.Size.Y<.3 and cream or pink)
			end)
		end
		for _,x in ipairs({-43,43}) do
			place(asset("StreetLamp"),decor,"WarmCafeLamp",at(x,.15,-22),10,function(p) solidTint(p,lavender); p.Material=Enum.Material.Metal end)
			for _,z in ipairs({4,26,50}) do
				place(storage:FindFirstChild("FreeFlowerTemplate"),decor,"FlowerBorder",at(x<0 and -46 or 46,2.27,z),4)
			end
			for _,z in ipairs({10,20,35,45}) do
				place(grassMesh,decor,"GrassTuft",at(x<0 and -46 or 46,2.25,z),2.7,function(p) solidTint(p,Color3.fromRGB(139,185,149)) end)
			end
		end
		local display=place(asset("DisplayCase"),decor,"PastryDisplay",at(12,.15,-24),7,function(p)
			if p.Transparency<.2 then p.Color=cream; p.Material=Enum.Material.WoodPlanks
			else p.Color=Color3.fromRGB(205,234,240); p.Transparency=.65 end
		end)
		if display then
			place(storage:FindFirstChild("FreeHeartCakeTemplate"),decor,"DisplayCake",at(12,3.0,-24),2.5)
		end
		-- A tiny trimmed hedge near the cafe, not throughout the production field.
		for _,x in ipairs({-18,18}) do
			part(decor,"CafePlanter",Vector3.new(4,.8,4),at(x,.5,-54),lavender,Enum.Material.Slate)
			part(decor,"SoftHedge",Vector3.new(5,2.2,5),at(x,1.8,-54),Color3.fromRGB(146,187,154),Enum.Material.Grass,Enum.PartType.Ball)
			place(storage:FindFirstChild("FreeFlowerTemplate"),decor,"PlanterFlowers",at(x,2.2,-54),3)
		end
	end
	local Lighting=game:GetService("Lighting")
	Lighting.ExposureCompensation=-.25
	local atmosphere=Lighting:FindFirstChild("DessertAtmosphere") or Instance.new("Atmosphere")
	atmosphere.Name,atmosphere.Density,atmosphere.Offset="DessertAtmosphere",.2,.1
	atmosphere.Color,atmosphere.Decay=Color3.fromRGB(239,224,234),Color3.fromRGB(218,218,233)
	atmosphere.Haze,atmosphere.Glare,atmosphere.Parent=.6,.1,Lighting
	island:SetAttribute("LandscapeVersion",1)
	island:SetAttribute("MapVersion","9.0.0")
	print("[Landscape] PASS: six landscaped gardens, textured ground and cafe furniture; gameplay surfaces preserved")
end
return Landscape
