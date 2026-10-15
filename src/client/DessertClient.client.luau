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
local UserArt=require(RS:WaitForChild("UserArt"))
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
local voiceEligible=false
local refreshVoice
task.spawn(function()
	local ok,enabled=pcall(function() return game:GetService("VoiceChatService"):IsVoiceEnabledForUserIdAsync(player.UserId) end)
	voiceStatus=Run:IsStudio() and "Voice Chat: test in a published voice-enabled experience" or ok and enabled and "Voice Chat: use Roblox microphone controls" or "Voice Chat: unavailable for this account or experience"
	screen:SetAttribute("VoiceEligible",ok and enabled or false)
	voiceEligible=ok and enabled or false
	if refreshVoice then refreshVoice() end
end)
local function giftText()
	local left=math.max(0,data.NextGift-data.ServerTime)
	return string.format("Free gift  %02d:%02d:%02d\nPlay reward  %02d:%02d / 3h",math.floor(left/3600),math.floor(left/60)%60,left%60,math.floor(data.AFKSeconds/3600),math.floor(data.AFKSeconds/60)%60)
end
local function corner(object,radius) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,radius or 16); c.Parent=object end
local function text(parent,label,size,pos)
	local t=Instance.new("TextLabel"); t.Size=size; t.Position=pos; t.Text=label; t.Font=Enum.Font.FredokaOne
	t.TextColor3=colors.Text; t.TextSize=20; t.TextWrapped=true; t.BackgroundTransparency=1; t.ZIndex=parent.ZIndex+1; t.Parent=parent; return t
end
local click=Instance.new("Sound"); click.Name="DessertClick"; click.SoundId=Config.ClickSoundId; click.Volume=.3; click.Parent=SoundService
local revealSound=Instance.new("Sound"); revealSound.Name="DessertDiscovery"; revealSound.SoundId=Config.DiscoverySoundId; revealSound.Volume=.3; revealSound.Parent=SoundService
local music=Instance.new("Sound"); music.Name="DessertCafeMusic"; music.SoundId=Config.MusicId; music.Volume=.12; music.Looped=true; music.Parent=SoundService
local audioDraft,volumeControls={},{}
local draggingVolume
local function volumeValue(key)
	return audioDraft[key] or (data and data.Settings[key.."Volume"]) or (key=="Music" and .4 or .5)
end
local function applyAudio()
	music.Volume=.3*volumeValue("Music")
	click.Volume=.6*volumeValue("Effects"); revealSound.Volume=click.Volume
	if music.Volume>0 then
		if not music.Playing then if music.TimePosition>0 then music:Resume() else music:Play() end end
	elseif music.Playing then music:Pause() end
	for key,control in pairs(volumeControls) do
		local value=volumeValue(key)
		control.Fill.Size=UDim2.fromScale(value,1); control.Knob.Position=UDim2.fromScale(value,.5)
		control.Label.Text=string.format("%d%%",math.floor(value*100+.5))
	end
end
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
local boost=box("×1",UDim2.fromOffset(150,48),UDim2.new(1,-168,1,-68),colors.Lavender,"Multiplier")
local shinyChance=box("Shiny 1%",UDim2.fromOffset(150,48),UDim2.new(1,-168,1,-124),colors.Pink,"Sparkles")
shinyChance.Name="ShinyChanceValue"; shinyChance.TextSize=16; boost.TextSize=16
local function updateShinyChance()
 local percent=100*(data.ShinyChance or Rules.ShinyChance("Normal",data.Luck,data.FriendBonus))
 shinyChance.Text="Shiny "..string.format(percent%1<.00001 and "%.0f%%" or "%.1f%%",percent)
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
local pendingAudioSave,audioSaving={},false
local function setVolume(key,value,save)
	audioDraft[key]=math.floor(math.clamp(value,0,1)*100+.5)/100
	applyAudio()
	if save then
		pendingAudioSave[key]=audioDraft[key]
		if audioSaving then return end
		audioSaving=true
		task.spawn(function()
			while next(pendingAudioSave) do
				task.wait(.25) -- Coalesce +/- taps; never send a remote every drag frame.
				local sent=pendingAudioSave; pendingAudioSave={}; local changes={}
				for channel,value in pairs(sent) do changes[channel.."Volume"]=value end
				local ok=request("Settings",changes)
				if not ok then task.wait(.25); ok=request("Settings",changes) end
				for channel,value in pairs(sent) do
					if ok then data.Settings[channel.."Volume"]=value; data.Settings[channel]=value>0 end
					if audioDraft[channel]==value and not pendingAudioSave[channel] and (not draggingVolume or draggingVolume.Key~=channel) then audioDraft[channel]=nil end
				end
				applyAudio()
			end
			audioSaving=false
		end)
	end
end
local function volumeSlider(key,label,y)
	local card=Instance.new("Frame"); card.Name=key.."VolumeControl"; card.Size=UDim2.new(1,-18,0,118)
	card.Position=UDim2.fromOffset(6,y); card.ZIndex=scroll.ZIndex+1; card.Parent=scroll; Art.Apply(card,"Card")
	text(card,label,UDim2.new(1,-112,0,38),UDim2.fromOffset(16,10)).TextSize=20
	local percent=text(card,"",UDim2.fromOffset(64,38),UDim2.new(1,-80,0,10)); percent.TextSize=20
	local track=Instance.new("TextButton"); track.Name="VolumeTrack"; track.Text=""; track.AutoButtonColor=false
	track.BackgroundColor3=colors.Lavender; track.BorderSizePixel=0; track.Size=UDim2.new(1,-144,0,14)
	track.Position=UDim2.fromOffset(72,73); track.ZIndex=card.ZIndex+2; track.Parent=card; corner(track,7)
	local fill=Instance.new("Frame"); fill.Name="VolumeFill"; fill.BackgroundColor3=colors.Pink; fill.BorderSizePixel=0
	fill.ZIndex=track.ZIndex+1; fill.Parent=track; corner(fill,7)
	local knob=Instance.new("TextButton"); knob.Name="VolumeKnob"; knob.Text=""; knob.Size=UDim2.fromOffset(26,26)
	knob.AnchorPoint=Vector2.new(.5,.5); knob.BackgroundColor3=colors.Cream; knob.ZIndex=track.ZIndex+2; knob.Parent=track; corner(knob,13)
	local outline=Instance.new("UIStroke"); outline.Color=colors.Text; outline.Thickness=2; outline.Parent=knob
	volumeControls[key]={Fill=fill,Knob=knob,Label=percent}
	button(card,"−",UDim2.fromOffset(38,38),UDim2.fromOffset(18,61),function() setVolume(key,volumeValue(key)-.05,true) end)
	button(card,"+",UDim2.fromOffset(38,38),UDim2.new(1,-56,0,61),function() setVolume(key,volumeValue(key)+.05,true) end)
	local function start(input)
		if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
		draggingVolume={Key=key,Track=track,Input=input}; scroll.ScrollingEnabled=false
		setVolume(key,(input.Position.X-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),false)
	end
	track.InputBegan:Connect(start); knob.InputBegan:Connect(start)
	applyAudio()
end
Input.InputChanged:Connect(function(input)
	local drag=draggingVolume
	if drag and (input==drag.Input or (drag.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then
		setVolume(drag.Key,(input.Position.X-drag.Track.AbsolutePosition.X)/math.max(1,drag.Track.AbsoluteSize.X),false)
	end
end)
Input.InputEnded:Connect(function(input)
	local drag=draggingVolume
	if drag and (input==drag.Input or (drag.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)) then
		draggingVolume=nil; scroll.ScrollingEnabled=true; setVolume(drag.Key,volumeValue(drag.Key),true)
	end
end)
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
show=function(name)
	if not data then return end
	if draggingVolume then local key=draggingVolume.Key; draggingVolume=nil; setVolume(key,volumeValue(key),true) end
	volumeControls={}; scroll.ScrollingEnabled=true
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
			if owned then button(card,data.Equipped==key and "Unequip" or "Equip",UDim2.new(1,-16,0,32),UDim2.fromOffset(8,152),function() request("Equip",key) end,colors.Mint) end
		end end
	elseif name=="Settings" then
		volumeSlider("Music","Background Music",0)
		volumeSlider("Effects","Sound Effects",130)
		button(scroll,"Hide Other Players' Pets: "..(data.Settings.HideOthers and "ON" or "OFF"),UDim2.new(1,-18,0,54),UDim2.fromOffset(6,260),function()
			request("Settings",{HideOthers=not data.Settings.HideOthers}); task.delay(.3,function() if panelName=="Settings" then show("Settings") end end)
		end,colors.Lavender)
		text(scroll,voiceStatus,UDim2.new(1,-18,0,54),UDim2.fromOffset(6,326)).TextSize=15
	elseif name=="Stats" then
		for n,item in ipairs({{"TotalCashEarned","Total Cash Earned"},{"TotalMiniCollected","Mini Desserts Collected"},{"PlaySeconds","Total Play Time"}}) do
			local card=Instance.new("Frame"); card.Size=UDim2.new(1,-32,0,108); card.Position=UDim2.fromOffset(16,(n-1)*126); card.ZIndex=scroll.ZIndex+1; card.Parent=scroll; Art.Apply(card,"Card")
			text(card,item[2],UDim2.new(1,-24,0,38),UDim2.fromOffset(12,12)).TextSize=20
			statLabels[item[1]]=text(card,"",UDim2.new(1,-24,0,40),UDim2.fromOffset(12,54)); statLabels[item[1]].TextSize=27
		end
	elseif name=="Crates" then
		giftLabel=text(scroll,giftText(),UDim2.new(1,-18,0,72),UDim2.fromOffset(6,0))
		local choices=Instance.new("Frame"); choices.Name="CrateChoices"; choices.BackgroundTransparency=1
		choices.AnchorPoint=Vector2.new(.5,0); choices.Position=UDim2.new(.5,0,0,80)
		choices.Size=UDim2.new(1,-16,0,0); choices.AutomaticSize=Enum.AutomaticSize.Y; choices.ZIndex=scroll.ZIndex+1; choices.Parent=scroll
		local limit=Instance.new("UISizeConstraint"); limit.MaxSize=Vector2.new(680,10000); limit.Parent=choices
		for index,kind in ipairs({"Normal","Perk"}) do
			local card=Instance.new("Frame"); card.Name=kind.."CrateChoice"; card.Size=UDim2.new(.5,-8,0,338)
			card.Position=UDim2.new((index-1)*.5,index==1 and 0 or 8,0,0); card.ZIndex=choices.ZIndex+1; card.Parent=choices; Art.Apply(card,"Card")
			text(card,kind.." Crate",UDim2.new(1,-16,0,32),UDim2.fromOffset(8,8)).TextSize=20
			local picture=UserArt.Create(card,kind.."Crate",UDim2.new(1,-24,0,136),UDim2.fromOffset(12,42))
			local details=button(card,"Details",UDim2.new(.7,0,0,34),UDim2.new(.15,0,0,180),function()
				local open=not crateDetails[kind]; crateDetails={}; crateDetails[kind]=open; show("Crates")
			end,colors.Cream); details.Name="DetailsButton"
			local free=kind=="Normal" and data.NormalTokens or data.PerkTokens
			local paid=(kind=="Normal" and data.PaidNormalTokens or data.PaidPerkTokens) or 0
			local credits=free+(data.Restricted and 0 or paid)
			for column,count in ipairs({1,10}) do
				local key=kind..count; local spec=Config.Products[key]
				local hasCredits=credits>=count
				local purchasable=spec.Id>0 and data.Durable and not data.Restricted
				local x=(column-1)*.5
				local open=button(card,"Open "..count,UDim2.new(.5,-16,0,42),UDim2.new(x,8,0,224),function()
					if hasCredits then request("Crate",{Kind=kind,Count=count}) elseif purchasable then request("Purchase",key) end
				end,colors.Mint); open.Name="Open"..count; open.Active=hasCredits or purchasable; open.AutoButtonColor=false
				open:SetAttribute("Purchasable",purchasable==true); open:SetAttribute("Quantity",count)
				local price=text(card,hasCredits and (free>=count and "FREE" or "Credits") or spec.Price.." Robux",UDim2.new(.5,-16,0,28),UDim2.new(x,8,0,269)); price.TextSize=15
				if purchasable and not hasCredits then task.spawn(function()
					local ok,info=pcall(Market.GetProductInfoAsync,Market,spec.Id,Enum.InfoType.Product)
					if ok and price.Parent then price.Text=tostring(info.PriceInRobux).." Robux" end
				end) end
			end
			text(card,"Free "..free.."  |  Paid "..paid,UDim2.new(1,-12,0,28),UDim2.fromOffset(6,300)).TextSize=13
			if crateDetails[kind] then
				local odds=Rules.Odds(data.Highest,kind); local entries={}; local shiny=Rules.ShinyChance(kind,data.Luck,data.FriendBonus)
				for tier=1,30 do if odds[tier] then table.insert(entries,Catalog[tier].Name..": "..string.format("%.2f%% normal / %.2f%% shiny",odds[tier]*(1-shiny),odds[tier]*shiny)) end end
				local detail=text(choices,kind.." Details\n"..table.concat(entries,"\n"),UDim2.new(1,-12,0,0),UDim2.fromOffset(6,350))
				detail.TextSize=14; detail.AutomaticSize=Enum.AutomaticSize.Y
			end
		end
	end
 fitPanel()
 for key,label in pairs(statLabels) do local value=data[key] or 0; label.Text=key=="PlaySeconds" and string.format("%dh %02dm %02ds",math.floor(value/3600),math.floor(value/60)%60,math.floor(value)%60) or (key=="TotalCashEarned" and "$" or "")..format(value) end
end
button(gui,"Index",UDim2.fromOffset(118,54),UDim2.new(0,18,.5,-70),function() show("Index") end,colors.Pink,true)
button(gui,"Shop",UDim2.fromOffset(118,48),UDim2.new(0,18,.5,-8),function() show("Shop") end,colors.Mint,true)
local topbar=Instance.new("ScreenGui"); topbar.Name="DessertTopbar"; topbar.IgnoreGuiInset=true; topbar.ResetOnSpawn=false; topbar.Parent=screen.Parent
local microphone=Instance.new("ImageButton"); microphone.Name="MicrophoneButton"; microphone.Size=UDim2.fromOffset(56,56)
microphone.BackgroundColor3=Color3.fromRGB(35,36,40); microphone.Parent=topbar; corner(microphone,28)
microphone.Image="rbxasset://textures/ui/VoiceChat/MicLight/Muted.png"
local voiceHint=Instance.new("Frame"); voiceHint.Name="MicrophoneStatus"; voiceHint.Size=UDim2.fromOffset(290,60)
voiceHint.BackgroundColor3=colors.Cream; voiceHint.ZIndex=20; voiceHint.Visible=false; voiceHint.Parent=topbar; corner(voiceHint,14)
local voiceHintText=text(voiceHint,voiceStatus,UDim2.new(1,-20,1,-12),UDim2.fromOffset(10,6)); voiceHintText.TextSize=14
local voiceInput,voiceConnection
refreshVoice=function()
	local available=not Run:IsStudio() and voiceEligible and voiceInput and voiceInput.Parent and voiceInput.Player==player
	local muted=not available or voiceInput.Muted
	microphone.Image="rbxasset://textures/ui/VoiceChat/MicLight/"..(muted and "Muted.png" or "Unmuted0.png")
	microphone.ImageTransparency=available and 0 or .4
	microphone:SetAttribute("VoiceAvailable",available and true or false); microphone:SetAttribute("Muted",muted and true or false)
	voiceHintText.Text=available and (muted and "Microphone muted" or "Microphone on") or voiceStatus
end
local function bindVoiceInput()
	if voiceConnection then voiceConnection:Disconnect(); voiceConnection=nil end
	voiceInput=player:FindFirstChildWhichIsA("AudioDeviceInput",true)
	if voiceInput then voiceConnection=voiceInput:GetPropertyChangedSignal("Muted"):Connect(refreshVoice) end
	refreshVoice()
end
player.DescendantAdded:Connect(function(child) if child:IsA("AudioDeviceInput") then bindVoiceInput() end end)
player.DescendantRemoving:Connect(function(child)
	if child==voiceInput then voiceInput=nil; if voiceConnection then voiceConnection:Disconnect(); voiceConnection=nil end; refreshVoice() end
end)
microphone.Activated:Connect(function()
	if microphone:GetAttribute("VoiceAvailable") then
		local ok=pcall(function() voiceInput.Muted=not voiceInput.Muted end)
		if not ok then voiceStatus="Voice Chat: microphone unavailable" end
		refreshVoice()
	end
	voiceHint.Visible=true; task.delay(3,function() voiceHint.Visible=false end)
end)
microphone.MouseEnter:Connect(function() voiceHint.Visible=true end)
microphone.MouseLeave:Connect(function() voiceHint.Visible=false end)
bindVoiceInput()
local settings=Instance.new("ImageButton"); settings.Name="SettingsButton"; settings.Size=UDim2.fromOffset(56,56)
settings.Image=Style.Icons.Settings; settings.ImageColor3=Color3.fromRGB(255,240,245); settings.BackgroundColor3=Color3.fromRGB(35,36,40); settings.Parent=topbar; corner(settings,28)
local statsButton=Instance.new("ImageButton"); statsButton.Name="StatsButton"; statsButton.Size=UDim2.fromOffset(56,56); statsButton.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"; statsButton.BackgroundColor3=Color3.fromRGB(35,36,40); statsButton.Parent=topbar; corner(statsButton,28)
statsButton.Activated:Connect(function() show("Stats") end)
local function positionSettings()
	local inset=game:GetService("GuiService").TopbarInset
	local width=workspace.CurrentCamera.ViewportSize.X
	local size=math.clamp(math.floor((width-inset.Min.X-32)/3),24,56)
	for _,b in ipairs({microphone,settings,statsButton}) do b.Size=UDim2.fromOffset(size,size) end
	microphone.Position=UDim2.fromOffset(inset.Min.X+8,inset.Min.Y+math.max(8,(inset.Height-size)/2))
	settings.Position=microphone.Position+UDim2.fromOffset(size+8,0)
	statsButton.Position=settings.Position+UDim2.fromOffset(size+8,0)
	voiceHint.Position=UDim2.fromOffset(math.max(0,math.min(microphone.Position.X.Offset,width-298)),microphone.Position.Y.Offset+size+8)
end
positionSettings(); game:GetService("GuiService"):GetPropertyChangedSignal("TopbarInset"):Connect(positionSettings)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(positionSettings)
settings.Activated:Connect(function() if not data or data.Settings.Effects then click:Play() end; show("Settings") end)
local lastHideOthers
local function applySettings(forceVisibility)
	if not data then return end
	applyAudio()
	if not forceVisibility and lastHideOthers==data.Settings.HideOthers then return end
	lastHideOthers=data.Settings.HideOthers
	local models={}
	local island=workspace:FindFirstChild("DessertJellyIsland"); local plots=island and island:FindFirstChild("PlayerPlots")
	if plots then for _,plot in ipairs(plots:GetChildren()) do for _,name in ipairs({"ActiveDesserts","MovingDesserts"}) do
		local folder=plot:FindFirstChild(name); if folder then for _,model in ipairs(folder:GetChildren()) do table.insert(models,model) end end
	end end end
	for _,model in ipairs(workspace:GetChildren()) do if model.Name=="DessertCompanion" then table.insert(models,model) end end
	for _,model in ipairs(models) do
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
	if #transfers>=30 then return end
	local model
	if kind=="CafeDelivery" then model=Visuals.BuildMini(1,false)
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
		local previousPaidNormal=data and data.PaidNormalTokens
		local previousPaidPerk=data and data.PaidPerkTokens
		local previousChance=data and data.ShinyChance
		local previousPasses=data and data.OwnedPasses or {}
		data=value; updateShinyChance(); for key,label in pairs(statLabels) do local value=data[key] or 0; label.Text=key=="PlaySeconds" and string.format("%dh %02dm %02ds",math.floor(value/3600),math.floor(value/60)%60,math.floor(value)%60) or (key=="TotalCashEarned" and "$" or "")..format(value) end; cash.Text="$"..format(data.Cash); bag.Text=format(data.Bag); boost.Text="×"..data.Multiplier
		applySettings()
		if giftLabel and giftLabel.Parent then giftLabel.Text=giftText() end
		if panelName=="Index" and previousEquipped~=data.Equipped then show("Index") end
		if panelName=="Crates" and (previousHighest~=data.Highest or previousNormal~=data.NormalTokens or previousPerk~=data.PerkTokens or previousPaidNormal~=data.PaidNormalTokens or previousPaidPerk~=data.PaidPerkTokens or previousChance~=data.ShinyChance) then show("Crates") end
		if panelName=="Shop" then
			for key in pairs(Config.Passes) do if previousPasses[key]~=data.OwnedPasses[key] then show("Shop"); break end end
		end
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
	visibilityTimer+=dt; if visibilityTimer>2 then visibilityTimer=0; applySettings(true) end
end)
task.spawn(function()
	for _=1,30 do local state=request("State"); if type(state)=="table" then
		data=state; updateShinyChance(); cash.Text="$"..format(data.Cash); bag.Text=format(data.Bag); boost.Text="×"..data.Multiplier; applySettings(); break
	end; task.wait(1) end
end)
