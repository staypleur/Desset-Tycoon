-- Native, script-free dessert models shared by world pets and ViewportFrame previews.
local Catalog=require(script.Parent.DessertCatalog)
local Visuals={}
local DISPLAY_SCALE=2
local function imported(name,tier,shiny,variant,nativeShiny)
	local folder=script.Parent:FindFirstChild("DessertModelTemplates")
	local template=folder and folder:FindFirstChild(name)
	if not template then return nil end
	local m=template:Clone(); m.Name=Catalog[tier].Name
	m:SetAttribute("Tier",tier); m:SetAttribute("Shiny",shiny)
	m:SetAttribute("Variant",shiny and (variant or 1) or 0)
	if shiny and not nativeShiny then
		for _,part in ipairs(m:GetDescendants()) do
			if part:IsA("BasePart") then part.Color=Color3.fromRGB(255,220,115) end
		end
		local sparkle=Instance.new("ParticleEmitter"); sparkle.Texture="rbxasset://textures/particles/sparkles_main.dds"
		sparkle.Rate=3; sparkle.Lifetime=NumberRange.new(.8,1.3); sparkle.Speed=NumberRange.new(.3,.8)
		sparkle.Color=ColorSequence.new(Color3.fromRGB(255,225,129)); sparkle.Size=NumberSequence.new(.18); sparkle.Parent=m.PrimaryPart
	end
	return m
end
function Visuals.Build(tier,shiny,variant)
	if tier<=8 then
		local name=tier==8 and (shiny and (variant==2 and "MangoBingsu" or "RedBeanBingsu") or "NormalBingsu") or tier==7 and (shiny and (variant==2 and "HoneybeeWaffle" or "UnicornWaffle") or "NormalWaffle") or tier==6 and (shiny and (variant==2 and "QuartzCroissant" or "GalaxyCroissant") or "NormalCroissant") or tier==5 and (shiny and (variant==2 and "DarkMacaron" or "CrystalMacaron") or "NormalMacaron") or tier==4 and (shiny and (variant==2 and "UnicornShortcake" or "GalaxyShortcake") or "NormalShortcake") or tier==3 and (shiny and (variant==2 and "RubyJelly" or "SherbetJelly") or "NormalJelly") or tier==2 and (shiny and (variant==2 and "DarkChocoCustard" or "RainbowCustard") or "NormalCustard") or shiny and (variant==2 and "GalaxyPudding" or "MilkPudding") or "NormalPudding"
		local m=imported(name,tier,shiny,variant,shiny)
		if m then m:ScaleTo(m:GetScale()*DISPLAY_SCALE); return m end
	end
	local m=Instance.new("Model"); m.Name=Catalog[tier].Name; m:SetAttribute("Tier",tier); m:SetAttribute("Shiny",shiny)
	m:SetAttribute("Variant",shiny and (variant or 1) or 0)
	local tint=shiny and Color3.fromRGB(255,220,115) or Color3.fromHSV((tier*.071+.07)%1,.24,1)
	if not shiny then
		if tier==2 then tint=Color3.fromRGB(255,239,198)
		elseif tier==3 then tint=Color3.fromRGB(255,170,197)
		elseif tier==23 then tint=Color3.fromRGB(255,249,235)
		elseif tier==27 then tint=Color3.fromRGB(224,184,154) end
	end
	local cream=Color3.fromRGB(255,247,231); local cocoa=Color3.fromRGB(133,82,72)
	local function p(name,size,pos,color,shape)
		local a=Instance.new("Part"); a.Name,a.Size,a.CFrame,a.Color=name,size,CFrame.new(pos),color
		a.Anchored,a.CanCollide,a.CanTouch,a.CanQuery=true,false,false,false
		a.Material=Enum.Material.SmoothPlastic; if shape then a.Shape=shape end; a.Parent=m; return a
	end
	local function disc(name,d,h,y,color)
		local a=p(name,Vector3.new(h,d,d),Vector3.new(0,y,0),color,Enum.PartType.Cylinder)
		a.CFrame*=CFrame.Angles(0,0,math.pi/2); return a
	end
	local body
	if tier==1 or tier==2 or tier==3 or tier==23 or tier==27 then
		body=disc("Body",2.7,1.7,1, tier==1 and not shiny and Color3.fromRGB(255,225,146) or tint)
		disc("Glaze",2.75,.18,1.9,tier==1 and cocoa or tint:Lerp(Color3.new(1,1,1),.4))
		p("Cream",Vector3.new(1,.65,1),Vector3.new(0,2.23,0),cream,Enum.PartType.Ball)
	elseif tier==6 then
		-- A ring assembled from curved-looking beads keeps a visible donut hole.
		for n=1,12 do local angle=n*math.pi/6
			local a=p("Donut",Vector3.new(.9,.7,.9),Vector3.new(math.cos(angle),.65,math.sin(angle)),tint,Enum.PartType.Ball)
			body=body or a
		end
	elseif tier==5 or tier==12 or tier==13 or tier==14 or tier==10 then
		body=disc("Body",2.9,.65,.6,shiny and tint or Color3.fromRGB(232,185,135))
		for n=1,6 do local a=n*math.pi/3; p("ChocolateChip",Vector3.new(.28,.15,.28),Vector3.new(math.cos(a)*.85,.98,math.sin(a)*.85),cocoa,Enum.PartType.Ball) end
	elseif tier==9 or tier==28 then
		local layers=tier==28 and 5 or 1
		for n=1,layers do
			disc("MacaronBottom",2.5-n*.13,.45,.4+(n-1)*.9,tint)
			disc("Filling",2.3-n*.13,.16,.69+(n-1)*.9,cream)
			body=disc("MacaronTop",2.5-n*.13,.45,.97+(n-1)*.9,tint)
		end
	elseif tier==26 then
		body=p("PotionBottle",Vector3.new(2,2,2),Vector3.new(0,1.2,0),tint,Enum.PartType.Ball)
		disc("BottleNeck",.8,.65,2.35,Color3.fromRGB(223,234,255))
		disc("Cork",.9,.3,2.8,Color3.fromRGB(220,176,140))
		p("Ribbon",Vector3.new(1.3,.3,.3),Vector3.new(0,2.3,-.5),cream)
	elseif tier==25 then
		body=disc("Candy",2.6,.65,1.2,tint)
		p("CandyWrapper",Vector3.new(3.4,.25,.65),Vector3.new(0,1.2,0),cream)
	elseif tier==16 or tier==19 then
		body=disc("Cup",2,1.7,1,Color3.fromRGB(206,227,248))
		for n=1,3 do p("Scoop",Vector3.new(1.5,1.3,1.5),Vector3.new((n-2)*.6,1.9+(n%2)*.45,0),tint,Enum.PartType.Ball) end
	elseif tier==29 then
		body=p("Castle",Vector3.new(2.2,2,1.7),Vector3.new(0,1.2,0),tint)
		for _,x in ipairs({-1.2,1.2}) do
			p("Tower",Vector3.new(.9,2.7,.9),Vector3.new(x,1.4,0),cream)
			p("SugarRoof",Vector3.new(1.2,1.2,1.2),Vector3.new(x,3,0),tint,Enum.PartType.Ball)
		end
	elseif tier==30 then
		body=p("Dragon",Vector3.new(2.4,2.3,2.2),Vector3.new(0,1.6,0),tint,Enum.PartType.Ball)
		for _,x in ipairs({-1,1}) do
			p("Wing",Vector3.new(1.8,.35,1.8),Vector3.new(x*1.6,1.6,.3),cream)
			p("Horn",Vector3.new(.45,1.1,.45),Vector3.new(x*.65,3,-.2),Color3.fromRGB(255,215,129))
		end
		p("Tail",Vector3.new(.8,.8,2),Vector3.new(0,.9,1.6),tint,Enum.PartType.Ball)
	else
		body=p("Body",Vector3.new(2.6,1.5,2),Vector3.new(0,1,0),(tier==4 or tier==21) and cocoa or tint)
		p("Filling",Vector3.new(2.65,.25,2.05),Vector3.new(0,1.25,0),cream)
		p("Icing",Vector3.new(2.7,.25,2.1),Vector3.new(0,1.88,0),tint)
		p("Berry",Vector3.new(.5,.5,.5),Vector3.new(.6,2.2,0),Color3.fromRGB(239,131,163),Enum.PartType.Ball)
	end
	for _,x in ipairs({-.48,.48}) do
		p("Eye",Vector3.new(.17,.24,.12),Vector3.new(x,1.1,-1.32),Color3.fromRGB(73,55,68),Enum.PartType.Ball)
		p("Blush",Vector3.new(.35,.16,.08),Vector3.new(x*1.55,.88,-1.32),Color3.fromRGB(255,167,186),Enum.PartType.Ball)
	end
	p("Smile",Vector3.new(.19,.09,.12),Vector3.new(0,.86,-1.34),cocoa)
	-- Cylinder parts are rotated locally; keep the MODEL pivot upright at the origin.
	body.PivotOffset=body.CFrame:Inverse(); m.PrimaryPart=body
	if shiny then
		local sparkle=Instance.new("ParticleEmitter"); sparkle.Texture="rbxasset://textures/particles/sparkles_main.dds"
		sparkle.Rate=3; sparkle.Lifetime=NumberRange.new(.8,1.3); sparkle.Speed=NumberRange.new(.3,.8)
		sparkle.Color=ColorSequence.new(Color3.fromRGB(255,225,129)); sparkle.Size=NumberSequence.new(.18); sparkle.Parent=body
	end
	m:ScaleTo(m:GetScale()*DISPLAY_SCALE)
	return m
end
function Visuals.BuildMini(tier,shiny,variant)
	if tier<=8 then
		local m=imported(tier==8 and "MiniBingsu" or tier==7 and "MiniWaffle" or tier==6 and "MiniCroissant" or tier==5 and "MiniMacaron" or tier==4 and "MiniShortcake" or tier==3 and "MiniJelly" or tier==2 and "MiniCustard" or "MiniPudding",tier,shiny,variant)
		if m then return m end
	end
	local m=Visuals.Build(tier,shiny,variant); m:ScaleTo(m:GetScale()*.25/DISPLAY_SCALE)
	return m
end
return Visuals
