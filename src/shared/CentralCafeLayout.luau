-- Six wide dessert plots with axial paths to one hollow round cafe.
local Layout={Width=128,Depth=120,Radius=180,IslandDiameter=560}
local cream=Color3.fromRGB(255,246,231)
local pink=Color3.fromRGB(255,193,215)
local lavender=Color3.fromRGB(208,193,245)
local mint=Color3.fromRGB(181,234,210)
local cocoa=Color3.fromRGB(109,71,91)
local function group(parent,name)
	local m=Instance.new("Model"); m.Name,m.Parent=name,parent; return m
end
local function p(parent,name,size,cf,color,shape)
	local a=Instance.new("Part"); a.Name,a.Size,a.CFrame,a.Color=name,size,cf,color
	a.Anchored,a.CanTouch=true,false; a.Material=Enum.Material.Plastic
	for _,face in ipairs({"Top","Bottom","Left","Right","Front","Back"}) do a[face.."Surface"]=Enum.SurfaceType.Studs end
	if shape then a.Shape=shape end; a.Parent=parent; return a
end
local function disc(parent,name,d,h,cf,color)
	return p(parent,name,Vector3.new(h,d,d),cf*CFrame.Angles(0,0,math.pi/2),color,Enum.PartType.Cylinder)
end
local function sign(part,text,name,width)
	local g=Instance.new("BillboardGui"); g.Name="ActionSign"; g.Size=UDim2.fromOffset(width or 220,58)
	g.StudsOffset=Vector3.new(0,3,0); g.MaxDistance=85; g.Parent=part
	local t=Instance.new("TextLabel"); t.Name=name or "Label"; t.Size=UDim2.fromScale(1,1)
	t.Text=text; t.Font=Enum.Font.GothamBold; t.TextColor3=cocoa; t.BackgroundTransparency=1; t.TextScaled=true; t.Parent=g
end
local function remove(parent,names)
	for _,name in ipairs(names) do local old=parent:FindFirstChild(name); if old then old:Destroy() end end
end
local function decoration(source,parent,name,cf,width,tint)
	if not source then return nil end
	local m=group(parent,name); source:Clone().Parent=m
	local box,size=m:GetBoundingBox()
	m:ScaleTo(m:GetScale()*width/math.max(size.X,size.Z)); box,size=m:GetBoundingBox()
	m:PivotTo(cf*CFrame.new(0,size.Y/2,0)*box:ToObjectSpace(m:GetPivot()))
	for _,d in ipairs(m:GetDescendants()) do
		assert(not d:IsA("LuaSourceContainer"),"Building template contains code")
		if d:IsA("BasePart") then
			d.Anchored,d.CanCollide,d.CanTouch,d.CanQuery=true,false,false,false
			if tint then
				d.Color=d.Name:lower():find("glass") and Color3.fromRGB(199,229,243) or tint
			end
		end
	end
	m:SetAttribute("DecorationOnly",true); m:SetAttribute("SourceAssetId",source:GetAttribute("SourceAssetId"))
	return m
end
function Layout.Apply(island)
	if island:GetAttribute("CentralCafeVersion")==1 then return end
	local hub=island.CentralHub; local anchor=hub.CentralShop
	local origin=anchor:GetPivot().Position; local center=Vector3.new(origin.X,0,origin.Z)
	local ground=island.FloatingIsland.MintIcingGround; local factor=Layout.IslandDiameter/ground.Size.Y
	for _,a in ipairs(island.FloatingIsland:GetDescendants()) do if a:IsA("Part") then
		a.CFrame=a.CFrame+Vector3.new((a.Position.X-center.X)*(factor-1),0,(a.Position.Z-center.Z)*(factor-1))
		if a.Shape==Enum.PartType.Cylinder then a.Size=Vector3.new(a.Size.X,a.Size.Y*factor,a.Size.Z*factor)
		else a.Size=Vector3.new(a.Size.X*factor,a.Size.Y,a.Size.Z*factor) end
	end end
	for _,name in ipairs({"CandyGarden","SakuraGarden"}) do local g=island:FindFirstChild(name)
		if g then for _,m in ipairs(g:GetChildren()) do if m:IsA("PVInstance") then
			local pos=m:GetPivot().Position; local radial=Vector3.new(pos.X-center.X,0,pos.Z-center.Z)
			m:PivotTo(m:GetPivot()+radial*(factor-1))
		end end end
	end
	local landscape=island:FindFirstChild("Landscape")
	if landscape then
		for _,a in ipairs(landscape:GetChildren()) do if a.Name=="PathEdging" then a:Destroy() end end
		local gardens=landscape:FindFirstChild("PocketGardens")
		if gardens then for _,g in ipairs(gardens:GetChildren()) do
			local pos=g:GetPivot().Position; local radial=Vector3.new(pos.X-center.X,0,pos.Z-center.Z)
			if radial.Magnitude>0 then g:PivotTo(g:GetPivot()+radial.Unit*50) end
		end end
	end
	island.SugarPaths:ClearAllChildren()
	remove(hub,{"CafeArchitecture","DepositPads","CratePads","CafeSeating"})
	remove(anchor,{"CafeArchitecture"})
	local cafe=group(anchor,"CafeArchitecture")
	disc(cafe,"CafeFloor",58,.5,CFrame.new(center+Vector3.new(0,.6,0)),cream)
	-- Faceted circular walls leave six open bays for round door frames.
	for n=0,71 do
		local angle=n*math.pi/36; local nearest=math.abs((angle+math.pi/6)%(math.pi/3)-math.pi/6)
		if nearest>math.rad(12) then
			local radial=Vector3.new(math.sin(angle),0,math.cos(angle))
			p(cafe,"RoundWall",Vector3.new(2.5,12,1.2),CFrame.lookAt(center+radial*27+Vector3.new(0,6.8,0),center+radial*28+Vector3.new(0,6.8,0)),n%3==0 and mint or cream)
		end
	end
	for i=1,6 do
		local a=(i-1)*math.pi/3; local radial=Vector3.new(math.sin(a),0,math.cos(a))
		local cf=CFrame.lookAt(center+radial*27+Vector3.new(0,.8,0),center+radial*28+Vector3.new(0,.8,0))
		for n=0,19 do local angle=n*math.pi/10
			local frame=p(cafe,"CircularDoorFrame",Vector3.new(1.5,1.5,1.4),cf*CFrame.new(math.cos(angle)*5.5,5+math.sin(angle)*5.5,0)*CFrame.Angles(0,0,angle),pink)
			frame.CanCollide=false
		end
	end
	disc(cafe,"CafeRoof",65,1.4,CFrame.new(center+Vector3.new(0,13.8,0)),lavender)
	local cake=group(cafe,"FacelessRoofCake")
	for n,d in ipairs({40,31,22}) do
		disc(cake,"CakeLayer",d,3.2,CFrame.new(center+Vector3.new(0,15.8+(n-1)*3.4,0)),n%2==0 and pink or cream)
		disc(cake,"Frosting",d+.6,.35,CFrame.new(center+Vector3.new(0,17.45+(n-1)*3.4,0)),n%2==0 and cream or pink)
	end
	for n=1,12 do local a=n*math.pi/6
		p(cake,"CreamDollop",Vector3.new(2,2,2),CFrame.new(center+Vector3.new(math.sin(a)*8.8,25.2,math.cos(a)*8.8)),cream,Enum.PartType.Ball)
	end
	p(cake,"Strawberry",Vector3.new(3,3.6,3),CFrame.new(center+Vector3.new(0,25.7,0)),Color3.fromRGB(237,128,158),Enum.PartType.Ball)
	-- The existing CentralDisplay is deliberately left untouched for the user's interior model.
	hub.CentralDisplay:SetAttribute("Purpose","User-created cafe interior model")
	for _,name in ipairs({"VanillaPlaza","PlazaBorder"}) do local a=hub:FindFirstChild(name)
		if a then a.Size=Vector3.new(a.Size.X,156,156) end
	end
	if hub:FindFirstChild("CentralSpawn") then hub.CentralSpawn.Position=center+Vector3.new(0,1.1,-73) end
	local deposits=group(hub,"DepositPads"); local crates=group(hub,"CratePads"); local seating=group(hub,"CafeSeating")
	for i=1,6 do
		local plot=island.PlayerPlots["Plot"..i]; local a=(i-1)*math.pi/3
		local radial=Vector3.new(math.sin(a),0,math.cos(a)); local pos=center+radial*Layout.Radius
		local cf=CFrame.lookAt(Vector3.new(pos.X,plot:GetPivot().Y,pos.Z),Vector3.new(center.X,plot:GetPivot().Y,center.Z))
		plot:PivotTo(cf)
		local function at(x,y,z) return cf*CFrame.new(x,y,z) end
		plot.PlotFloor.Size=Vector3.new(128,1,120)
		for _,edge in ipairs(plot:GetChildren()) do
			if edge.Name=="SideFence" then local lp=cf:PointToObjectSpace(edge.Position); edge.CFrame=at(lp.X<0 and -63.5 or 63.5,lp.Y,0)
			elseif edge.Name=="BackFence" or edge.Name=="FrontTrim" then edge.Size=Vector3.new(126,edge.Size.Y,1) end
		end
		for _,s in ipairs(plot.ProductionBeds:GetChildren()) do local lp=cf:PointToObjectSpace(s.Position); s.Size=Vector3.new(52,s.Size.Y,s.Size.Z); s.CFrame=at(lp.X<0 and -30 or 30,lp.Y,lp.Z) end
		for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do
			local side=pad:GetAttribute("Side")=="Left" and -1 or 1; local row=pad:GetAttribute("Row"); local col=pad:GetAttribute("Column")
			pad.CFrame=at(side*(10+(col-1)*8.4),2.35,4+(row-1)*11.2)*CFrame.Angles(0,0,math.pi/2)
			pad.Size=Vector3.new(.16,5.6,5.6)
		end
		for _,s in ipairs(plot.Conveyors:GetChildren()) do if s.Name=="FeedSlope" then
			local lp=cf:PointToObjectSpace(s.Position); local side=lp.X<0 and -1 or 1
			s.Size=Vector3.new(3.4,s.Size.Y,52); s.CFrame=at(side*30,lp.Y,lp.Z)*CFrame.Angles(0,side*math.pi/2,0)
		end end
		plot:SetAttribute("SideLaneWidth",52)
		local area=plot.PersonalShopArea; remove(area,{"DessertCafe","SellDesserts","DessertCrate","CollectIncome","RobuxShop","UpgradeConverter","BankBuilding","ShopBuilding"})
		plot.PlotSpawn.CFrame=at(0,.2,-53); plot.Entrance.CFrame=at(0,.2,-58)
		for n,count in ipairs({1,10,100,1000}) do plot.PurchaseButtons["Buy"..count].CFrame=at(n<=2 and -36 or 36,.3,(n==1 or n==3) and -12 or -23) end
		local collect=p(area,"CollectIncome",Vector3.new(11,.3,7),at(33,.3,-34),mint); sign(collect,"R | COLLECT CASH")
		local upgrade=p(area,"UpgradeConverter",Vector3.new(11,.3,7),at(47,.3,-34),lavender); sign(upgrade,"UPGRADE CONVERTER\n10% -> 15% | $25")
		local shop=p(area,"RobuxShop",Vector3.new(10,.3,6),at(-40,.3,-34),mint); sign(shop,"SHOP | HOLD E")
		local bank=decoration(game.ServerStorage:FindFirstChild("FreeBankTemplate"),area,"BankBuilding",at(40,.2,-50),27,mint)
		local store=decoration(game.ServerStorage:FindFirstChild("FreeShopTemplate"),area,"ShopBuilding",at(-40,.2,-50)*CFrame.Angles(0,math.pi,0),27,lavender)
		if not bank then bank=group(area,"BankBuilding"); p(bank,"BankShell",Vector3.new(25,12,17),at(40,6.2,-50),mint) end
		if not store then store=group(area,"ShopBuilding"); p(store,"ShopShell",Vector3.new(25,12,17),at(-40,6.2,-50),lavender) end
		for _,v in ipairs({{40,"DESSERT BANK",mint},{-40,"SUGAR SHOP",lavender}}) do
			local signPart=p(area,"BuildingSign",Vector3.new(15,2.5,.25),at(v[1],10,-40),v[3]); signPart.CanCollide=false
			local g=Instance.new("SurfaceGui"); g.Face=Enum.NormalId.Back; g.PixelsPerStud=40; g.Parent=signPart
			local t=Instance.new("TextLabel"); t.Size=UDim2.fromScale(1,1); t.BackgroundTransparency=1; t.Text=v[2]; t.Font=Enum.Font.GothamBold; t.TextColor3=cocoa; t.TextScaled=true; t.Parent=g
		end
		local decor=plot:FindFirstChild("CafeGardenDecor")
		if decor then
			remove(decor,{"BakeryTerrace","TeaPatio","PatioBorder","PastryDisplay","DisplayCake","CafePlanter","SoftHedge","PlanterFlowers"})
			for _,m in ipairs(decor:GetChildren()) do if m:IsA("PVInstance") then
				local lp=cf:PointToObjectSpace(m:GetPivot().Position)
				if m.Name=="FlowerBorder" or m.Name=="GrassTuft" or m.Name=="WarmCafeLamp" then m:PivotTo(m:GetPivot()+cf:VectorToWorldSpace(Vector3.new((lp.X<0 and -60 or 60)-lp.X,0,0)))
				elseif m.Name=="CafeTableAndChairs" then m:PivotTo(m:GetPivot()+cf:VectorToWorldSpace(Vector3.new((lp.X<0 and -55 or 55)-lp.X,0,-9-lp.Z))) end
			end end
		end
		remove(plot.Entrance,{"ActionSign"}); sign(plot.Entrance,"Available Plot","OwnerLabel",280)
		local depositCF=CFrame.lookAt(center+radial*44+Vector3.new(0,.85,0),center+radial*45+Vector3.new(0,.85,0))
		local deposit=p(deposits,"Deposit"..i,Vector3.new(12,.3,7),depositCF,pink); deposit:SetAttribute("PlotId",i); sign(deposit,"PLOT "..i.." | DEPOSIT")
		local crate=p(crates,"Crate"..i,Vector3.new(7,.3,6),depositCF*CFrame.new(14,0,0),lavender); sign(crate,"DESSERT CRATES")
		local start=center+radial*44+Vector3.new(0,.45,0); local finish=at(0,-.4,-60).Position
		p(island.SugarPaths,"CreamPath",Vector3.new(18,.5,(finish-start).Magnitude),CFrame.lookAt((start+finish)/2,finish),cream)
		local ba=a+math.pi/6; local br=Vector3.new(math.sin(ba),0,math.cos(ba)); local benchCF=CFrame.lookAt(center+br*64+Vector3.new(0,.75,0),center+Vector3.new(0,.75,0))
		local bench=decoration(game.ServerStorage:FindFirstChild("FreeBenchTemplate"),seating,"SocialBench"..i,benchCF,11,cream)
		if bench then for _,x in ipairs({-2,2}) do
			local seat=Instance.new("Seat"); seat.Name="BenchSeat"; seat.Size=Vector3.new(2.5,.3,2.5); seat.CFrame=benchCF*CFrame.new(x,1.8,0); seat.Anchored=true; seat.Transparency=1; seat.Parent=bench
		end end
	end
	island:SetAttribute("PlotRadius",Layout.Radius); island:SetAttribute("CentralCafeVersion",1); island:SetAttribute("MapVersion","12.0.0")
	print("[CentralCafeLayout] Six wide plots, axial paths, hollow central cafe and roof cake")
end
return Layout
