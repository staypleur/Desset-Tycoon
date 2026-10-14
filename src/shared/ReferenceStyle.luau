-- v14: photo-inspired open cafe counter, horizontal purchase row and physical roof letters.
local Style={}
local cream=Color3.fromRGB(255,246,226)
local pink=Color3.fromRGB(246,178,200)
local mint=Color3.fromRGB(166,223,202)
local laneYellow=Color3.fromRGB(255,228,150)
local lavender=Color3.fromRGB(191,174,232)
local gold=Color3.fromRGB(226,188,125)
local dark=Color3.fromRGB(73,65,82)
local function model(parent,name) local m=Instance.new("Model"); m.Name=name; m.Parent=parent; return m end
local function part(parent,name,size,cf,color,shape)
	local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Color=color; p.Anchored=true
	p.Material=Enum.Material.SmoothPlastic; p.CanTouch=false; p.Shape=shape or Enum.PartType.Block
	p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth; p.Parent=parent; return p
end
local function ring(parent,name,center,radius,width,height,y,color,material,gap)
	local m=model(parent,name)
	for n=0,63 do local a=n*math.pi/32
		if not gap or math.abs(a-math.pi)>gap then
			local r=Vector3.new(math.sin(a),0,math.cos(a)); local p=part(m,"RingSegment",Vector3.new(radius*math.pi/32+.1,height,width),CFrame.lookAt(center+r*radius+Vector3.new(0,y,0),center+r*(radius+1)+Vector3.new(0,y,0)),color)
			p.Material=material or Enum.Material.SmoothPlastic
		end
	end; return m
end
local function rounded(parent,name,w,d,h,cf,color)
	local m=model(parent,name); local radius=1.3
	part(m,"Center",Vector3.new(w-2*radius,h,d),cf,color)
	part(m,"Cross",Vector3.new(w,h,d-2*radius),cf,color)
	for _,x in ipairs({-w/2+radius,w/2-radius}) do for _,z in ipairs({-d/2+radius,d/2-radius}) do
		part(m,"Corner",Vector3.new(h,radius*2,radius*2),cf*CFrame.new(x,0,z)*CFrame.Angles(0,0,math.pi/2),color,Enum.PartType.Cylinder)
	end end; return m
end
local function roofWord(parent,word,cf)
	local m=model(parent,"RoofWord"); m:SetAttribute("Text",word); m:SetAttribute("GeometryText",true)
	local sources=game.ServerStorage:FindFirstChild("FreeDesignSources")
	local source=sources and sources:FindFirstChild("Alphabet"); if not source then m:Destroy(); return end
	local total=#word*3.7
	local palette={pink,mint,cream,lavender}
	for n=1,#word do local original=source:FindFirstChild(word:sub(n,n),true)
		if original and original:IsA("BasePart") then
			local glyph=original:Clone(); glyph:ClearAllChildren()
			glyph.Size=original.Size.X<original.Size.Z and Vector3.new(.8,4,3.1) or Vector3.new(3.1,4,.8)
			glyph.CFrame=cf*CFrame.new(-total/2+(n-.5)*3.7,2,0)*original.CFrame.Rotation; glyph.Color=palette[n]; glyph.UsePartColor=true
			glyph.Anchored=true; glyph.CanCollide=false; glyph.CanTouch=false; glyph.Parent=m
		elseif word:sub(n,n)=="K" then
			local glyph=model(m,"K"); local kc=cf*CFrame.new(-total/2+(n-.5)*3.7,2,0)
			part(glyph,"Stem",Vector3.new(.65,4,.8),kc*CFrame.new(-1.2,0,0),palette[n]).CanCollide=false
			for _,sign in ipairs({-1,1}) do part(glyph,"Arm",Vector3.new(.65,2.6,.8),kc*CFrame.new(.1,sign*.85,0)*CFrame.Angles(0,0,-sign*math.pi/4),palette[n]).CanCollide=false end
		end
	end
	m:SetAttribute("SourceAssetId",4455779753)
	part(m,"LetterRail",Vector3.new(total+.8,.25,1.4),cf*CFrame.new(0,-.05,0),gold).CanCollide=false
	return m
end
local function prop(source,parent,name,cf,width)
	if not source then return end
	local m=model(parent,name); source:Clone().Parent=m; local b,s=m:GetBoundingBox()
	m:ScaleTo(m:GetScale()*width/math.max(s.X,s.Z)); b,s=m:GetBoundingBox()
	m:PivotTo(cf*CFrame.new(0,s.Y/2,0)*b:ToObjectSpace(m:GetPivot()))
	for _,d in ipairs(m:GetDescendants()) do assert(not d:IsA("LuaSourceContainer")); if d:IsA("BasePart") then d.Anchored=true; d.CanCollide=false; d.CanTouch=false end end
	m:SetAttribute("DecorationOnly",true); m:SetAttribute("SourceAssetId",source:GetAttribute("SourceAssetId")); return m
end
function Style.Apply(island)
	if island:GetAttribute("ReferenceStyleVersion")==1 then return end
	local anchor=island.CentralHub.CentralShop; local origin=anchor:GetPivot().Position; local center=Vector3.new(origin.X,0,origin.Z)
	local old=anchor:FindFirstChild("CafeArchitecture"); local cake=old and old:FindFirstChild("FacelessRoofCake")
	if cake then cake.Parent=anchor end; if old then old:Destroy() end
	local cafe=model(anchor,"CafeArchitecture"); cafe:SetAttribute("OpenCounter",true)
	part(cafe,"CafeFloor",Vector3.new(.4,58,58),CFrame.new(center+Vector3.new(0,.65,0))*CFrame.Angles(0,0,math.pi/2),cream,Enum.PartType.Cylinder)
	ring(cafe,"CircularCounter",center,24,5,3.5,2.7,cream,nil,math.rad(10))
	ring(cafe,"CounterTop",center,24,5.8,.45,4.65,Color3.fromRGB(237,234,228),Enum.Material.Marble,math.rad(10))
	ring(cafe,"CounterBaseLight",center,26.55,.14,.14,1.1,gold,Enum.Material.Neon,math.rad(10))
	ring(cafe,"SuspendedCanopy",center,24.5,4.5,2.6,13,pink,Enum.Material.Metal)
	ring(cafe,"CanopyRim",center,24.5,4.8,.3,11.6,gold,Enum.Material.Metal)
	ring(cafe,"CanopyLight",center,24.5,4.2,.1,11.4,Color3.fromRGB(255,225,167),Enum.Material.Neon)
	for n=1,6 do local a=n*math.pi/3+math.pi/6; local r=Vector3.new(math.sin(a),0,math.cos(a))
		part(cafe,"SlenderSupport",Vector3.new(.3,7,.3),CFrame.new(center+r*26+Vector3.new(0,8,0)),gold).Material=Enum.Material.Metal
	end
	for n=1,40 do local a=n*math.pi/20; local r=Vector3.new(math.sin(a),0,math.cos(a)); local length=1.4+(n%5)*.6; local pos=center+r*(n%2==0 and 23 or 25)+Vector3.new(0,11.35,0)
		part(cafe,"PendantCable",Vector3.new(.06,length,.06),CFrame.new(pos-Vector3.new(0,length/2,0)),gold).CanCollide=false
		local bulb=part(cafe,"WarmPendant",Vector3.new(.48,.48,.48),CFrame.new(pos-Vector3.new(0,length+.15,0)),Color3.fromRGB(255,229,181),Enum.PartType.Ball); bulb.Material=Enum.Material.Neon; bulb.CanCollide=false
		if n%10==0 then local light=Instance.new("PointLight"); light.Color=bulb.Color; light.Brightness=.6; light.Range=13; light.Parent=bulb end
	end
	local roofTop=14.3
	if cake then
		cake.Parent=cafe; cake:ScaleTo(cake:GetScale()*1.5)
		-- Translate the already upright cake; its cylindrical primary part gives
		-- GetBoundingBox a rotated frame that must not become the placement frame.
		local b=cake:GetBoundingBox(); local bottom=math.huge; local top=-math.huge
		for _,p in ipairs(cake:GetDescendants()) do if p:IsA("BasePart") then
			local half=math.abs(p.CFrame.RightVector.Y)*p.Size.X/2+math.abs(p.CFrame.UpVector.Y)*p.Size.Y/2+math.abs(p.CFrame.LookVector.Y)*p.Size.Z/2
			bottom=math.min(bottom,p.Position.Y-half)
			top=math.max(top,p.Position.Y+half)
		end end
		cake:PivotTo(cake:GetPivot()+Vector3.new(center.X-b.X,14.3-bottom,center.Z-b.Z))
		roofTop=top+14.3-bottom
	end
	local marketAnchor=part(cafe,"CafeMultiplierAnchor",Vector3.new(.2,.2,.2),CFrame.new(center+Vector3.new(0,roofTop+5,0)),cream)
	marketAnchor.Transparency=1; marketAnchor.CanCollide=false; marketAnchor.CanQuery=false
	local sources=game.ServerStorage:FindFirstChild("FreeDesignSources")
	-- All of CentralDisplay's existing children remain reserved for the user's later model.
	for i=1,6 do
		local plot=island.PlayerPlots["Plot"..i]; local cf=plot:GetPivot(); local function at(x,y,z) return cf*CFrame.new(x,y,z) end
		for n,count in ipairs({1,10,100,1000}) do local pad=plot.PurchaseButtons["Buy"..count]
			pad.CFrame=at(({-44,-22,22,44})[n],.45,-11); pad.Size=Vector3.new(13,.3,7.5)
		end
		local area=plot.PersonalShopArea
		for _,name in ipairs({"ShopBuilding","BankBuilding"}) do local building=area[name]
			for _,d in ipairs(building:GetDescendants()) do if d.Name=="RoofWord" then d:Destroy() end end
			if name=="ShopBuilding" then
				for index,d in ipairs(building:GetDescendants()) do if d:IsA("BasePart") then
					local lower=d.Name:lower()
					if lower:find("canopy") then d.Color=index%2==0 and mint or cream
					elseif lower:find("door") then d.Color=mint
					elseif lower:find("flower") then d.Color=gold
					elseif lower=="frame" then d.Color=cream
					else d.Color=pink end
				end end
			end
			local box,size=building:GetBoundingBox(); local localBox=cf:PointToObjectSpace(box.Position)
			roofWord(building,name=="ShopBuilding" and "SHOP" or "BANK",at(localBox.X,localBox.Y+size.Y/2+.25,localBox.Z+size.Z/2-1))
		end
		for _,pad in ipairs(plot.PurchaseButtons:GetChildren()) do Style.Button(pad) end
		for _,pad in ipairs({plot.MergeBoard,area.CollectIncome,area.UpgradeConverter}) do Style.Button(pad) end
		local shop=area.RobuxShop; shop.Size=Vector3.new(1,1,1); shop.CFrame=at(-40,3,-34); shop.Transparency=1; shop.CanCollide=false
		local sign=shop:FindFirstChild("ActionSign"); if sign then sign:Destroy() end
		Style.Field(plot,sources)
		Style.Fence(plot,sources)
		local crate=island.CentralHub.CratePads["Crate"..i]
		crate.CFrame=at(-19,2.5,-47); crate.Size=Vector3.new(1,1,1); crate.Transparency=1; crate.CanCollide=false
		prop(sources and sources:FindFirstChild("TreasureChest"),area,"NormalChest",at(-20,.2,-43),5)
		local perk=prop(sources and sources:FindFirstChild("TreasureChest"),area,"PerkChest",at(-20,.2,-51),5)
		if perk then for _,d in ipairs(perk:GetDescendants()) do if d:IsA("BasePart") then d.Color=lavender end end end
	end
	for _,pad in ipairs(island.CentralHub.DepositPads:GetChildren()) do Style.Button(pad) end
	local skySource=sources and sources:FindFirstChild("PinkSky")
	local sky=skySource and skySource:FindFirstChildWhichIsA("Sky",true)
	if sky then for _,d in ipairs(game.Lighting:GetChildren()) do if d:IsA("Sky") then d:Destroy() end end
		local copy=sky:Clone(); copy.Name="FreePinkSky"; copy:SetAttribute("SourceAssetId",107689530722174); copy.Parent=game.Lighting
	end
	island:SetAttribute("ReferenceStyleVersion",1); island:SetAttribute("MapVersion","14.0.0")
end
function Style.Button(pad)
	if pad:FindFirstChild("ButtonTop") then return end
	local base=rounded(pad,"ButtonBase",pad.Size.X+1.7,pad.Size.Z+1.3,.5,pad.CFrame*CFrame.new(0,-.32,0),dark)
	local sources=game.ServerStorage:FindFirstChild("FreeDesignSources")
	local source=sources and sources:FindFirstChild("TycoonButtons")
	local head=source and source:FindFirstChild("Head",true)
	local top
	if head then
		top=model(pad,"ButtonTop"); local p=head:Clone(); p:ClearAllChildren()
		p.Size=Vector3.new(pad.Size.X,.25,pad.Size.Z); p.CFrame=pad.CFrame; p.Color=pad.Color; p.UsePartColor=true; p.Material=Enum.Material.Neon; p.Parent=top
		top:SetAttribute("SourceAssetId",12528362526)
	else top=rounded(pad,"ButtonTop",pad.Size.X,pad.Size.Z,.25,pad.CFrame,pad.Color) end
	for _,p in ipairs(base:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
	for _,p in ipairs(top:GetDescendants()) do if p:IsA("BasePart") then
		p.CanCollide=false; p.CanTouch=false; p.Massless=true; p.Anchored=false
		local weld=Instance.new("WeldConstraint"); weld.Part0=pad; weld.Part1=p; weld.Parent=p
	end end
	pad.Transparency=1; pad:SetAttribute("RoundedButton",true)
end
function Style.Field(plot)
	local cf=plot:GetPivot(); local rise=5.5; local function at(x,y,z) return cf*CFrame.new(x,y,z) end
	local function delta(z) return math.clamp((z+7)/62,0,1)*rise end
	plot:SetAttribute("FieldRise",rise)
	for _,bed in ipairs(plot.ProductionBeds:GetChildren()) do local lp=cf:PointToObjectSpace(bed.Position)
		bed.CFrame=bed.CFrame+cf:VectorToWorldSpace(Vector3.new(0,delta(lp.Z),0)); bed.Color=mint
	end
	for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do local lp=cf:PointToObjectSpace(pad.Position)
		pad.CFrame=pad.CFrame+cf:VectorToWorldSpace(Vector3.new(0,delta(lp.Z),0)); pad:SetAttribute("ShelfHeight",2.25+delta(lp.Z))
	end
	local layout=require(script.Parent.ProductionPlot)
	for _,slope in ipairs(plot.Conveyors:GetChildren()) do
		if slope.Name=="FeedSlope" then
			local lp=cf:PointToObjectSpace(slope.Position); local side=lp.X<0 and -1 or 1
			local low=layout.ChannelHeight(lp.Z,rise); local high=2.25+delta(lp.Z+5.2)
			slope.Size=Vector3.new(3.4,high-low,52); slope.CFrame=at(side*30,(low+high)/2,lp.Z)*CFrame.Angles(0,side*math.pi/2,0); slope.Color=laneYellow
		elseif slope.Name=="MainBelt" then
			slope.Size=Vector3.new(8,.65+rise,62); slope.CFrame=at(0,.3+(.65+rise)/2,24); slope.Color=laneYellow
		end
	end
	-- The shelves rise together; narrow filler wedges sit only beneath the shelves,
	-- leaving the transverse feed lanes and central trough exposed.
	for _,side in ipairs({-1,1}) do
		local ground=Instance.new("WedgePart"); ground.Name="RaisedFieldGround"; ground.Size=Vector3.new(52,rise,62)
		ground.CFrame=at(side*30,.15+rise/2,24); ground.Color=mint; ground.Material=Enum.Material.Plastic; ground.Anchored=true; ground.CanTouch=false
		ground.TopSurface=Enum.SurfaceType.Studs; ground.Parent=plot.ProductionBeds
	end
end
function Style.Fence(plot,sources)
	local source=sources and sources:FindFirstChild("WhiteFence"); if not source then return end
	local group=model(plot,"WhitePicketFence"); local cf=plot:GetPivot()
	local function run(x,z,length,angle,y)
		local count=math.ceil(length/25); local segment=length/count
		for n=1,count do
			local p=prop(source,group,"FenceSegment",cf*CFrame.new(x,y or .2,z)*CFrame.Angles(0,angle,0)*CFrame.new(0,0,-length/2+(n-.5)*segment),segment)
			if p then for _,d in ipairs(p:GetDescendants()) do if d:IsA("BasePart") then d.CanCollide=true end end end
		end
	end
	run(-63,0,120,0); run(63,0,120,0); run(0,59,126,math.pi/2)
	run(-38,-59,50,math.pi/2); run(38,-59,50,math.pi/2)
	for _,old in ipairs(plot:GetChildren()) do if old.Name=="SideFence" or old.Name=="BackFence" then old:Destroy() end end
end
return Style
