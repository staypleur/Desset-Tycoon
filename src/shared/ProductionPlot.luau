-- Editable drawing-based production layout. Apply after the landscape/classic passes.
local Layout={}
local cream=Color3.fromRGB(255,248,239)
local pink=Color3.fromRGB(255,193,215)
local mint=Color3.fromRGB(190,235,218)
local function studs(p)
	if p:IsA("Part") or p:IsA("WedgePart") or p:IsA("SpawnLocation") then
		p.Material=Enum.Material.Plastic
		for _,face in ipairs({"Top","Bottom","Left","Right","Front","Back"}) do p[face.."Surface"]=Enum.SurfaceType.Studs end
	end
end
local function part(parent,name,size,cf,color,class)
	local p=Instance.new(class or "Part"); p.Name,p.Size,p.CFrame,p.Color=name,size,cf,color
	p.Anchored,p.CanTouch=true,false; p.Parent=parent; studs(p); return p
end
local function group(parent,name)
	local old=parent:FindFirstChild(name); if old then old:Destroy() end
	local m=Instance.new("Model"); m.Name,m.Parent=name,parent; return m
end
local function sign(p,text)
	local g=Instance.new("BillboardGui"); g.Name="ActionSign"; g.Size=UDim2.fromOffset(180,44)
	g.StudsOffset=Vector3.new(0,2.5,0); g.MaxDistance=70; g.Parent=p
	local t=Instance.new("TextLabel"); t.Size=UDim2.fromScale(1,1); t.BackgroundTransparency=1
	t.Text=text; t.TextColor3=Color3.fromRGB(101,64,89); t.Font=Enum.Font.GothamBold; t.TextScaled=true; t.Parent=g
end
function Layout.ChannelHeight(z,rise) return .3+math.clamp((z+7)/62,0,1)*(.65+(rise or 0)) end
-- Preserve the first side as seen from the entrance, then fill its opposite row
-- before moving backwards: right row 1, left row 1, right row 2, left row 2.
function Layout.ReorderSlots(plot)
	local pads=plot:FindFirstChild("PetSpawnPads"); if not pads then return end
	local ordered={}
	for _,pad in ipairs(pads:GetChildren()) do
		local row,column=pad:GetAttribute("Row"),pad:GetAttribute("Column")
		if row and column then
			local sideIndex=pad:GetAttribute("Side")=="Left" and 0 or 1
			local slot=(row-1)*12+sideIndex*6+column
			table.insert(ordered,{Pad=pad,Slot=slot})
		end
	end
	for _,item in ipairs(ordered) do item.Pad.Name="ReorderingPad"..item.Slot end
	for _,item in ipairs(ordered) do item.Pad.Name="PetPad"..item.Slot;item.Pad:SetAttribute("SlotIndex",item.Slot) end
end
function Layout.Apply(island)
	if island:GetAttribute("ProductionPlotVersion")==1 then
		for _,plot in ipairs(island.PlayerPlots:GetChildren()) do Layout.ReorderSlots(plot) end
		return
	end
	for i=1,6 do
		local plot=island.PlayerPlots["Plot"..i]; local cf=plot:GetPivot()
		local function at(x,y,z) return cf*CFrame.new(x,y,z) end
		local beds=group(plot,"ProductionBeds"); local pads=group(plot,"PetSpawnPads")
		local frames=group(plot,"PetPadFrames"); local belts=group(plot,"Conveyors")
		for sideIndex,side in ipairs({-1,1}) do for row=1,5 do
			local z=4+(row-1)*11.2; local laneZ=z-5.2
			part(beds,"DessertShelf",Vector3.new(40,2,7),at(side*24,1.25,z),mint)
			local low=Layout.ChannelHeight(laneZ); local height=2.25-low
			local slope=part(belts,"FeedSlope",Vector3.new(3.4,height,40),at(side*24,low+height/2,laneZ)*CFrame.Angles(0,side*math.pi/2,0),pink,"WedgePart")
			slope:SetAttribute("FlowDirection",side<0 and "Right" or "Left")
			for column=1,6 do
				local slot=(row-1)*12+(sideIndex-1)*6+column; local x=side*(10+(column-1)*6.2)
				local pad=part(pads,"PetPad"..slot,Vector3.new(.16,4.9,4.9),at(x,2.35,z)*CFrame.Angles(0,0,math.pi/2),cream)
				pad.Shape=Enum.PartType.Cylinder
				pad:SetAttribute("SlotIndex",slot); pad:SetAttribute("Row",row); pad:SetAttribute("Column",column)
				pad:SetAttribute("Side",side<0 and "Left" or "Right"); pad:SetAttribute("DropLaneZ",laneZ)
			end
		end end
		-- Lowest channel descends toward the protruding collection tray at the front.
		part(belts,"MainBelt",Vector3.new(8,.65,62),at(0,.625,24),Color3.fromRGB(198,184,236),"WedgePart")
		local tray=part(belts,"Collector",Vector3.new(12,.25,8),at(0,.25,-11),cream)
		for _,x in ipairs({-6,6}) do part(belts,"TrayLip",Vector3.new(.4,.7,8),at(x,.65,-11),pink) end
		part(belts,"TrayLip",Vector3.new(12,.7,.4),at(0,.65,-15),pink)
		for _,name in ipairs({"MergeBoard","MergeCells","PurchaseButtons"}) do local old=plot:FindFirstChild(name); if old then old:Destroy() end end
		local merge=part(plot,"MergeBoard",Vector3.new(10,.4,6),at(0,.35,-21),pink); sign(merge,"MERGE")
		local buttons=group(plot,"PurchaseButtons")
		for n,count in ipairs({1,10,100,1000}) do
			local x=n<=2 and -25 or 25; local z=(n==1 or n==3) and -12 or -22
			local button=part(buttons,"Buy"..count,Vector3.new(10,.3,6),at(x,.3,z),pink)
			sign(button,"Buy "..count.." | $"..count*5)
		end
		local area=plot.PersonalShopArea
		plot.PlotSpawn.CFrame=at(30,.2,-55)
		local decor=plot:FindFirstChild("CafeGardenDecor")
		if decor then for _,item in ipairs(decor:GetChildren()) do
			if item.Name=="CafeTableAndChairs" then
				local pos=cf:PointToObjectSpace(item:GetPivot().Position)
				if pos.Z>-15 then item:PivotTo(item:GetPivot()+cf:VectorToWorldSpace(Vector3.new(37-pos.X,0,-9-pos.Z))) end
			end
		end end
		for _,name in ipairs({"CollectIncome","DessertCrate","RobuxShop","SellDesserts"}) do local old=area:FindFirstChild(name); if old then old:Destroy() end end
		sign(part(area,"SellDesserts",Vector3.new(9,.3,4),at(0,.3,-28),mint),"SELL AT CAFE")
		sign(part(area,"CollectIncome",Vector3.new(10,.3,7),at(25,.3,-47),mint),"R | COLLECT CASH")
		sign(part(area,"RobuxShop",Vector3.new(10,.3,7),at(-25,.3,-47),mint),"SHOP")
		sign(part(area,"DessertCrate",Vector3.new(9,.3,6),at(25,.3,-33),pink),"DESSERT CRATES")
		plot:SetAttribute("CollectorZ",-11); plot:SetAttribute("DessertCapacity",60)
	end
	for _,p in ipairs(island:GetDescendants()) do if p:IsA("BasePart") then studs(p) end end
	island:SetAttribute("ProductionPlotVersion",1); island:SetAttribute("MapVersion","11.0.0")
end
return Layout
