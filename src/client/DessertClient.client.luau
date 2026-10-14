local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Tween=game:GetService("TweenService")
local Run=game:GetService("RunService")
local Input=game:GetService("UserInputService")
local SoundService=game:GetService("SoundService")
local Market=game:GetService("MarketplaceService")
local player=Players.LocalPlayer
local Config=require(RS:WaitForChild("TycoonConfig"))
local Catalog=require(RS:WaitForChild("DessertCatalog"))
local Rules=require(RS:WaitForChild("DessertRules"))
local Visuals=require(RS:WaitForChild("DessertVisuals"))
local Style=require(RS:WaitForChild("DessertUI"))
local Gauge=require(RS:WaitForChild("CircularGauge"))
local Art=require(RS:WaitForChild("PastelArt"))
local ShopUI=require(RS:WaitForChild("KawaiiShop"))
local remotes=RS:WaitForChild("DessertRemotes")
local action=remotes:WaitForChild("Action"); local event=remotes:WaitForChild("Event")
local colors={Cream=Color3.fromRGB(255,248,239),Pink=Color3.fromRGB(255,193,217),Lavender=Color3.fromRGB(215,199,249),Mint=Color3.fromRGB(184,233,212),Text=Color3.fromRGB(105,66,90)}
local screen=Instance.new("ScreenGui"); screen.Name="DessertHUD"; screen.ResetOnSpawn=false; screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; screen.Parent=player:WaitForChild("PlayerGui")
local gui=Instance.new("Frame"); gui.BackgroundTransparency=1; gui.Parent=screen
local uiScale=Instance.new("UIScale"); uiScale.Parent=gui
local function resize()
	local viewport=workspace.CurrentCamera.ViewportSize
	local scale=math.min(viewport.X/800,viewport.Y/650,1)
	uiScale.Scale=scale; gui.Size=UDim2.fromOffset(viewport.X/scale,math.max(1,viewport.Y-58)/scale)
	Style.ResizeWorld(workspace,viewport.X)
end
resize(); workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
local data,panelName,spinning=nil,nil,{}
local giftLabel
local statLabels={}
local indexGrid
local crateDetails={}
local voiceStatus="Voice Chat: checking availability..."
task.spawn(function()
	local ok,enabled=pcall(function() return game:GetService("VoiceChatService"):IsVoiceEnabledForUserIdAsync(player.UserId) end)
	voiceStatus=Run:IsStudio() and "Voice Chat: test in a published voice-enabled experience" or ok and enabled and "Voice Chat: use Roblox microphone controls" or "Voice Chat: unavailable for this account or experience"
	screen:SetAttribute("VoiceEligible",ok and enabled or false)
end)
local function giftText()
	local left=math.max(0,data.NextGift-data.ServerTime)
	return string.format("Next free gift: %02d:%02d:%02d | AFK: %ds / 5h\nPremium: normal + perk together every 5h",math.floor(left/3600),math.floor(left/60)%60,left%60,math.floor(data.AFKSeconds))
end
local function corner(object,radius) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,radius or 16); c.Parent=object end
local function text(parent,label,size,pos)
	local t=Instance.new("TextLabel"); t.Size=size; t.Position=pos; t.Text=label; t.Font=Enum.Font.FredokaOne
	t.TextColor3=colors.Text; t.TextSize=20; t.TextWrapped=true; t.BackgroundTransparency=1; t.ZIndex=parent.ZIndex+1; t.Parent=parent; return t
end
local click=Instance.new("Sound"); click.SoundId=Config.ClickSoundId; click.Volume=.3; click.Parent=SoundService
local revealSound=Instance.new("Sound"); revealSound.SoundId=Config.DiscoverySoundId; revealSound.Volume=.3; revealSound.Parent=SoundService
local music=Instance.new("Sound"); music.Name="DessertCafeMusic"; music.SoundId=Config.MusicId; music.Volume=.12; music.Looped=true; music.Parent=SoundService
local function button(parent,label,size,pos,callback,color,shortcut)
	local b=Instance.new("TextButton"); b.Size=size; b.Position=pos; b.Text=label; b.Font=Enum.Font.GothamBold; b.TextSize=16
	b.TextColor3=colors.Text; b.BackgroundColor3=color or colors.Pink; b.BorderSizePixel=0; b.ZIndex=parent.ZIndex+1; b.Parent=parent
	local icon=Style.Icons[label] and label or label:find("Open") and "Crates" or label:find("Equipped") and "Check" or label:find("Equip") and "Cake" or "Sparkles"
	if shortcut then Style.Button(b,icon) else Art.Apply(b,"Button"); b.Font=Enum.Font.FredokaOne; b.TextXAlignment=Enum.TextXAlignment.Center; b.TextWrapped=true end
	b.Activated:Connect(function() if not data or data.Settings.Effects then click:Play() end; callback() end)
	return b
end
local function box(label,size,pos,color,icon)
	local f=Instance.new("Frame"); f.Size=size; f.Position=pos; f.Parent=gui; Style.Card(f,color or colors.Cream,18)
	if size.Y.Offset<=60 then Style.Art(f,"Stats") end
	Style.Icon(f,icon or "Sparkles",32,UDim2.new(0,10,.5,-16))
	return text(f,label,UDim2.new(1,-56,1,-8),UDim2.fromOffset(48,4)),f
end
local function format(n)
	if n>=1e12 then return string.format("%.2e",n) end
	for _,v in ipairs({{1e9,"B"},{1e6,"M"},{1e3,"K"}}) do if n>=v[1] then return string.format("%.1f%s",n/v[1],v[2]) end end
	return math.abs(n-math.floor(n))>.00001 and string.format("%.1f",n) or tostring(math.floor(n))
end
local cash=box("$0",UDim2.fromOffset(180,60),UDim2.new(0,18,1,-80),colors.Mint,"Coins"); cash.Name="CashValue"; cash.TextSize=28
local plate=Instance.new("ImageLabel"); plate.Name="MiniDessertPlate"; plate.BackgroundTransparency=1
plate.Size=UDim2.fromOffset(112,112); plate.AnchorPoint=Vector2.new(.5,1); plate.Position=UDim2.new(.5,0,1,-12)
plate.Image=Config.PlateImageId or ""; plate.ScaleType=Enum.ScaleType.Fit; plate.Parent=gui
local bag=text(plate,"0",UDim2.fromScale(.68,.5),UDim2.fromScale(.16,.32)); bag.Name="BagValue"; bag.TextScaled=true
local numberLimit=Instance.new("UITextSizeConstraint"); numberLimit.MinTextSize=14; numberLimit.MaxTextSize=27; numberLimit.Parent=bag
local boost=box("×1",UDim2.fromOffset(150,48),UDim2.new(1,-168,1,-68),colors.Lavender)
local shinyChance=box("Shiny 1%",UDim2.fromOffset(150,48),UDim2.new(1,-168,1,-124),colors.Pink,"Sparkles")
shinyChance.Name="ShinyChanceValue"; shinyChance.TextSize=16; boost.TextSize=16
local function updateShinyChance()
 shinyChance.Text=string.format("Shiny %.0f%%",100*(data.ShinyChance or Rules.ShinyChance("Normal",data.Luck)))
end
local cafeRateLabel,cafeGauge,marketIsland
task.spawn(function()
	marketIsland=workspace:WaitForChild("DessertJellyIsland",30); if not marketIsland then return end
	local hub=marketIsland:WaitForChild("CentralHub"); local shop=hub:WaitForChild("CentralShop")
	local architecture=shop:WaitForChild("CafeArchitecture"); local anchor=architecture:WaitForChild("CafeMultiplierAnchor",30)
	if not anchor then return end
	local board=Instance.new("BillboardGui"); board.Name="CafeMarketSign"
	local function fitMarket() local scale=math.clamp(workspace.CurrentCamera.ViewportSize.X/1280,.65,1); board.Size=UDim2.fromOffset(150*scale,150*scale) end
	fitMarket(); workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitMarket)
	board.Adornee=anchor; board.MaxDistance=250; board.AlwaysOnTop=true; board.Parent=screen
	cafeGauge=Gauge.Create(board); cafeRateLabel=cafeGauge.Label
end)
local window=Instance.new("Frame"); window.Name="Panel"; window.Size=UDim2.fromScale(.78,.72); window.Position=UDim2.fromScale(.11,.15)
window.ZIndex=10; window.Visible=false; window.Parent=screen; Art.Apply(window,"Panel")
local title=text(window,"",UDim2.new(1,-140,0,54),UDim2.fromOffset(18,0)); title.TextXAlignment=Enum.TextXAlignment.Center; title.TextSize=24
button(window,"×",UDim2.fromOffset(38,38),UDim2.new(1,-65,0,22),function() window.Visible=false; panelName=nil end)
local scroll=Instance.new("ScrollingFrame"); scroll.Size=UDim2.new(1,-24,1,-70); scroll.Position=UDim2.fromOffset(12,60)
scroll.ZIndex=window.ZIndex+1; scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=6; scroll.ScrollBarImageColor3=colors.Text; scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.CanvasSize=UDim2.new(); scroll.Parent=window
local function request(verb,arg)
	local ok,result,message=pcall(action.InvokeServer,action,verb,arg)
	if not ok then warn("[DessertHUD] Action unavailable") end
	return ok and result
end
local function preview(parent,tier,shiny,size,pos)
	local view=Instance.new("ViewportFrame"); view.Size=size; view.Position=pos; view.BackgroundTransparency=1
	view.ZIndex=parent.ZIndex+1; view.Ambient=Color3.fromRGB(220,208,220); view.LightColor=Color3.fromRGB(255,247,233); view.Parent=parent
	local world=Instance.new("WorldModel"); world.Parent=view
	local model=Visuals.Build(tier,shiny); model.Parent=world
	local camera=Instance.new("Camera"); camera.FieldOfView=35; camera.CFrame=CFrame.lookAt(Vector3.new(0,2.6,-4.5),Vector3.new(0,1.2,0)); camera.Parent=view; view.CurrentCamera=camera
	table.insert(spinning,{Model=model,View=view})
	return view
end
local show,kawaiiShop
local function fitPanel()
 local v=workspace.CurrentCamera.ViewportSize
 local w=math.max(260,math.min(940,v.X-24)); local h=math.max(260,math.min(660,v.Y-90))
 window.AnchorPoint=Vector2.new(.5,.5); window.Position=UDim2.fromScale(.5,.5); window.Size=UDim2.fromOffset(w,h)
 if indexGrid then local cols=w>=800 and 4 or w>=600 and 3 or w>=400 and 2 or 1; indexGrid.FillDirectionMaxCells=cols; indexGrid.CellSize=UDim2.fromOffset(math.floor((w-42-(cols-1)*12)/cols),190) end
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitPanel)
local function productButton(key,spec,y,isPass)
	local b=button(scroll,(spec.Name or key).." | "..spec.Price.." R$",UDim2.new(1,-18,0,50),UDim2.fromOffset(6,y),function() request("Purchase",key) end,colors.Lavender)
	if spec.Id==0 or not data.Durable or ((spec.Crate or key=="Luck") and data.Restricted) then
		b.Text=(spec.Name or key).." | "..spec.Price.." R$ | Coming Soon"; b.AutoButtonColor=false; b.Active=false
	else task.spawn(function()
		local ok,info=pcall(Market.GetProductInfoAsync,Market,spec.Id,isPass and Enum.InfoType.GamePass or Enum.InfoType.Product)
		if ok and b.Parent then b.Text=(spec.Name or key).." | "..tostring(info.PriceInRobux).." R$" end
	end) end
end
show=function(name)
	if not data then return end
	if kawaiiShop then kawaiiShop.Destroy(); kawaiiShop=nil end
	panelName=name; window.Visible=name~="Shop"; title.Text=name; scroll:ClearAllChildren(); spinning={}; giftLabel=nil; statLabels={}; indexGrid=nil
	if name=="Shop" then
		kawaiiShop=ShopUI.Open(screen,data,{
			Click=function() if data.Settings.Effects then click:Play() end end,
			Close=function() panelName=nil; kawaiiShop=nil end,
			Purchase=function(key) request("Purchase",key) end,
			Preview=function(parent,tier,size,pos)
				local view=preview(parent,tier,false,size,pos)
				view.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(0,2.6,-4.5),Vector3.new(0,1.2,0)); view.CurrentCamera.FieldOfView=35
				return view
			end,
		})
		return
	end
	if name=="Index" then
		indexGrid=Instance.new("UIGridLayout"); indexGrid.CellPadding=UDim2.fromOffset(12,12); indexGrid.SortOrder=Enum.SortOrder.LayoutOrder; indexGrid.Parent=scroll
		for tier=1,30 do for variant=0,1 do
			local shiny=variant==1; local key=Rules.Key(tier,shiny); local owned=data.Index[key]
			local index=(tier-1)*2+variant; local row=math.floor(index/4); local column=index%4
			local card=Instance.new("Frame"); card.Size=UDim2.new(.25,-12,0,190); card.Position=UDim2.new(column*.25,6,0,row*200)
			card.LayoutOrder=index; card.ZIndex=scroll.ZIndex+1; card.Parent=scroll; Art.Apply(card,"Card")
			if owned then preview(card,tier,shiny,UDim2.new(1,0,0,112),UDim2.new()) else text(card,"?",UDim2.new(1,0,0,110),UDim2.new()) end
			text(card,owned and ((shiny and "Shiny " or "")..Catalog[tier].Name) or "Undiscovered",UDim2.new(1,-8,0,34),UDim2.fromOffset(4,112)).TextSize=14
			if owned then button(card,data.Equipped==key and "Equipped" or "Equip",UDim2.new(1,-16,0,32),UDim2.fromOffset(8,152),function() request("Equip",key) end,colors.Mint) end
		end end
	elseif name=="Settings" then
		for n,item in ipairs({{"Music","Background Music"},{"Effects","Sound Effects"},{"HideOthers","Hide Other Players' Pets"}}) do
			button(scroll,item[2]..": "..(data.Settings[item[1]] and "ON" or "OFF"),UDim2.new(1,-18,0,54),UDim2.fromOffset(6,(n-1)*66),function()
				local settings=table.clone(data.Settings); settings[item[1]]=not settings[item[1]]; request("Settings",settings); task.delay(.3,function() show("Settings") end)
			end,colors.Lavender)
		end
		text(scroll,voiceStatus,UDim2.new(1,-18,0,54),UDim2.fromOffset(6,210)).TextSize=15
	elseif name=="Stats" then
		for n,item in ipairs({{"TotalCashEarned","Total Cash Earned"},{"TotalMiniCollected","Mini Desserts Collected"},{"PlaySeconds","Total Play Time"}}) do
			local card=Instance.new("Frame"); card.Size=UDim2.new(1,-32,0,108); card.Position=UDim2.fromOffset(16,(n-1)*126); card.ZIndex=scroll.ZIndex+1; card.Parent=scroll; Art.Apply(card,"Card")
			text(card,item[2],UDim2.new(1,-24,0,38),UDim2.fromOffset(12,12)).TextSize=20
			statLabels[item[1]]=text(card,"",UDim2.new(1,-24,0,40),UDim2.fromOffset(12,54)); statLabels[item[1]].TextSize=27
		end
	elseif name=="Crates" then
		giftLabel=text(scroll,giftText(),UDim2.new(1,-18,0,72),UDim2.fromOffset(6,0))
		local y=80
		for _,kind in ipairs({"Normal","Perk"}) do
			local tokens=kind=="Normal" and data.NormalTokens or data.PerkTokens
			local paidTokens=kind=="Normal" and data.PaidNormalTokens or data.PaidPerkTokens
			local odds=Rules.Odds(data.Highest,kind); local entries={}; local shiny=100*Rules.ShinyChance(kind,data.Luck)
			for tier=1,30 do if odds[tier] then
				table.insert(entries,Catalog[tier].Name..": "..string.format("%.2f",odds[tier]*(1-shiny/100)).."% normal / "..string.format("%.2f",odds[tier]*shiny/100).."% shiny")
			end end
			text(scroll,kind.." Crates | Free: "..tokens.." | Purchased: "..(paidTokens or 0),UDim2.new(1,-18,0,40),UDim2.fromOffset(6,y)); y+=44
			button(scroll,"Details",UDim2.fromOffset(132,36),UDim2.fromOffset(6,y),function() crateDetails[kind]=not crateDetails[kind]; show("Crates") end,colors.Cream); y+=44
			if crateDetails[kind] then text(scroll,table.concat(entries,"\n"),UDim2.new(1,-18,0,130),UDim2.fromOffset(6,y)); y+=140 end
			for n,count in ipairs({1,10}) do
				button(scroll,"Open "..count.." credits",UDim2.new(.5,-12,0,40),UDim2.new((n-1)*.5,6,0,y),function() request("Crate",{Kind=kind,Count=count}); task.delay(.3,function() show("Crates") end) end,colors.Mint)
			end; y+=50
			for _,count in ipairs({1,10}) do productButton(kind..count,Config.Products[kind..count],y,false); y+=58 end
		end
	end
 fitPanel()
 for key,label in pairs(statLabels) do local value=data[key] or 0; label.Text=key=="PlaySeconds" and string.format("%dh %02dm %02ds",math.floor(value/3600),math.floor(value/60)%60,math.floor(value)%60) or (key=="TotalCashEarned" and "$" or "")..format(value) end
end
button(gui,"Index",UDim2.fromOffset(118,54),UDim2.new(0,18,.5,-70),function() show("Index") end,colors.Pink,true)
button(gui,"Shop",UDim2.fromOffset(118,48),UDim2.new(0,18,.5,-8),function() show("Shop") end,colors.Mint,true)
local topbar=Instance.new("ScreenGui"); topbar.Name="DessertTopbar"; topbar.IgnoreGuiInset=true; topbar.ResetOnSpawn=false; topbar.Parent=screen.Parent
local settings=Instance.new("ImageButton"); settings.Name="SettingsButton"; settings.Size=UDim2.fromOffset(56,56)
settings.Image=Style.Icons.Settings; settings.ImageColor3=Color3.fromRGB(255,240,245); settings.BackgroundColor3=Color3.fromRGB(35,36,40); settings.Parent=topbar; corner(settings,28)
local statsButton=Instance.new("ImageButton"); statsButton.Name="StatsButton"; statsButton.Size=UDim2.fromOffset(56,56); statsButton.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"; statsButton.BackgroundColor3=Color3.fromRGB(35,36,40); statsButton.Parent=topbar; corner(statsButton,28)
statsButton.Activated:Connect(function() show("Stats") end)
local function positionSettings()
	local inset=game:GetService("GuiService").TopbarInset
	settings.Position=UDim2.fromOffset(inset.Min.X+8,inset.Min.Y+math.max(8,(inset.Height-56)/2))
	statsButton.Position=settings.Position+UDim2.fromOffset(64,0)
end
positionSettings(); game:GetService("GuiService"):GetPropertyChangedSignal("TopbarInset"):Connect(positionSettings)
settings.Activated:Connect(function() if not data or data.Settings.Effects then click:Play() end; show("Settings") end)
local function applySettings()
	if not data then return end
	if data.Settings.Music then if not music.Playing then music:Play() end else music:Stop() end
	for _,model in ipairs(workspace:GetDescendants()) do
		local owner=model:IsA("Model") and model:GetAttribute("OwnerUserId")
		local pet=model.Parent and (model.Parent.Name=="ActiveDesserts" or model.Parent.Name=="MovingDesserts" or model.Name=="DessertCompanion")
		if pet and owner and owner~=0 and owner~=player.UserId then for _,p in ipairs(model:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier=data.Settings.HideOthers and 1 or 0
			elseif p:IsA("ParticleEmitter") then p.Enabled=not data.Settings.HideOthers end
		end end
	end
end
local revealQueue={}; local revealing=false
local function reveal(item)
	table.insert(revealQueue,item); if revealing then return end; revealing=true
	task.spawn(function()
		while #revealQueue>0 do
			local found=table.remove(revealQueue,1)
			local f=Instance.new("Frame"); f.Size=UDim2.fromScale(1,1); f.BackgroundColor3=colors.Lavender; f.BackgroundTransparency=.12; f.ZIndex=20; f.Parent=gui; Art.Apply(f,"Panel")
			text(f,found.Shiny and "SHINY DISCOVERED!" or "NEW DESSERT!",UDim2.new(1,0,0,60),UDim2.fromScale(0,.17)).TextSize=32
			preview(f,found.Tier,found.Shiny,UDim2.fromScale(.5,.46),UDim2.fromScale(.25,.25))
			text(f,Catalog[found.Tier].Name.." | Tier "..found.Tier,UDim2.new(1,0,0,60),UDim2.fromScale(0,.72)).TextSize=28
			if not data or data.Settings.Effects then revealSound:Play() end
			for n=1,28 do
				local star=text(f,n%2==0 and "✦" or "♥",UDim2.fromOffset(30,30),UDim2.fromScale(math.random(),-.05)); star.TextColor3=n%2==0 and colors.Pink or colors.Mint
				Tween:Create(star,TweenInfo.new(2.3),{Position=UDim2.fromScale(math.random(),1.05),Rotation=math.random(-180,180)}):Play()
			end
			task.wait(2.6); f:Destroy()
		end; revealing=false
	end)
end
local transfers={}
local function transfer(kind,start,finish)
	if data and not data.Settings.Effects then return end
	if #transfers>=30 then return end
	local model
	if kind=="CafeDelivery" then model=Visuals.Build(1,false); model:ScaleTo(.4)
	else
		model=Instance.new("Model"); local coin=Instance.new("Part"); coin.Shape=Enum.PartType.Ball; coin.Size=Vector3.new(1.8,1.8,1.8); coin.Color=Color3.fromRGB(255,215,112); coin.Material=Enum.Material.Neon; coin.Parent=model
	end
	for _,part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then part.Anchored=true; part.CanCollide=false; part.CanTouch=false; part.CanQuery=false end end
	model.Name="CafeTransferEffect"; model.Parent=workspace
	table.insert(transfers,{Model=model,Start=start+Vector3.new(0,2,0),Finish=finish+Vector3.new(0,2,0),Time=os.clock(),Duration=kind=="CafeCash" and 1.8 or .8})
end
event.OnClientEvent:Connect(function(kind,value,message)
	if kind=="State" then
		local previousEquipped=data and data.Equipped
		local previousHighest=data and data.Highest
		local previousNormal=data and data.NormalTokens
		local previousPerk=data and data.PerkTokens
		data=value; updateShinyChance(); for key,label in pairs(statLabels) do local value=data[key] or 0; label.Text=key=="PlaySeconds" and string.format("%dh %02dm %02ds",math.floor(value/3600),math.floor(value/60)%60,math.floor(value)%60) or (key=="TotalCashEarned" and "$" or "")..format(value) end; cash.Text="$"..format(data.Cash); bag.Text=format(data.Bag); boost.Text="×"..data.Multiplier
		applySettings()
		if giftLabel and giftLabel.Parent then giftLabel.Text=giftText() end
		if panelName=="Index" and previousEquipped~=data.Equipped then show("Index") end
		if panelName=="Crates" and (previousHighest~=data.Highest or previousNormal~=data.NormalTokens or previousPerk~=data.PerkTokens) then show("Crates") end
	elseif kind=="Panel" then show(value)
	elseif kind=="Discovery" then reveal(value)
	elseif kind=="Crates" then for _,found in ipairs(value) do reveal(found) end
	elseif kind=="CafeDelivery" or kind=="CafeCash" then transfer(kind,value,message)
	end
end)
local lastActivity=0
local actualLastInput=os.clock(); local lastCameraNudge=os.clock()
local function recordInput(input)
 actualLastInput=os.clock()
 if os.clock()-lastActivity>5 then lastActivity=os.clock(); task.spawn(request,"Activity") end
end
Input.InputBegan:Connect(recordInput)
Input.InputChanged:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then recordInput(input) end
end)
-- Experimental ordinary camera motion, NOT virtual input and NOT a proven idle bypass.
-- It never sends Activity pings itself or changes character/economy state.
Run:BindToRenderStep("DessertIdleCameraMotion",Enum.RenderPriority.Camera.Value+1,function()
 local now=os.clock(); local camera=workspace.CurrentCamera
 if Config.IdleCameraNudgeEnabled and camera and now-actualLastInput>=Config.IdleCameraStartSeconds
  and now-lastCameraNudge>=Config.IdleCameraInterval then
  lastCameraNudge=now
  camera.CFrame=camera.CFrame*CFrame.Angles(0,math.rad(.03),0)
  screen:SetAttribute("IdleCameraNudges",(screen:GetAttribute("IdleCameraNudges") or 0)+1)
 end
end)
local visibilityTimer=0
Run.RenderStepped:Connect(function(dt)
	if cafeRateLabel and marketIsland then
		local rate=marketIsland:GetAttribute("CafeSaleMultiplier") or 1
		local remaining=math.max(0,(marketIsland:GetAttribute("CafeNextSaleChange") or workspace:GetServerTimeNow()+30)-workspace:GetServerTimeNow())
		cafeRateLabel.Text=string.format("%.1fx",rate)
		Gauge.SetProgress(cafeGauge,1-remaining/30)
	end
	for n=#transfers,1,-1 do local v=transfers[n]; local alpha=math.clamp((os.clock()-v.Time)/v.Duration,0,1)
		v.Model:PivotTo(CFrame.new(v.Start:Lerp(v.Finish,alpha)+Vector3.new(0,math.sin(alpha*math.pi)*8,0)))
		if alpha>=1 then v.Model:Destroy(); table.remove(transfers,n) end
	end
	for n=#spinning,1,-1 do local v=spinning[n]; if not v.View.Parent then table.remove(spinning,n) else v.Model:PivotTo(CFrame.Angles(0,os.clock()*.5,0)) end end
	visibilityTimer+=dt; if visibilityTimer>2 then visibilityTimer=0; applySettings() end
end)
task.spawn(function()
	for _=1,30 do local state=request("State"); if type(state)=="table" then
		data=state; updateShinyChance(); cash.Text="$"..format(data.Cash); bag.Text=format(data.Bag); boost.Text="×"..data.Multiplier; applySettings(); break
	end; task.wait(1) end
end)
