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
local Motion=require(RS:WaitForChild("DessertMotion"))
local Style=require(RS:WaitForChild("DessertUI"))
local Gauge=require(RS:WaitForChild("CircularGauge"))
local Art=require(RS:WaitForChild("PastelArt"))
local ShopUI=require(RS:WaitForChild("KawaiiShop"))
local UserArt=require(RS:WaitForChild("UserArt"))
local DessertImages=require(RS:WaitForChild("DessertImages"))
local CodePets=require(RS:WaitForChild("DessertCodePets"))
local Rewards=require(RS:WaitForChild("DessertRewards"))
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
local dropViews={}
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
local pickupSound=Instance.new("Sound"); pickupSound.Name="DessertPickup"; pickupSound.SoundId=Config.PickupSoundId; pickupSound.PlaybackSpeed=1.5; pickupSound.Volume=.2; pickupSound.Parent=SoundService
local lastPickup=-math.huge
local revealSound=Instance.new("Sound"); revealSound.Name="DessertDiscovery"; revealSound.SoundId=Config.DiscoverySoundId; revealSound.Volume=.3; revealSound.Parent=SoundService
local music=Instance.new("Sound"); music.Name="DessertCafeMusic"; music.SoundId=Config.MusicId; music.Volume=.12; music.Looped=true; music.Parent=SoundService
local audioDraft,volumeControls={},{}
local draggingVolume
local function volumeValue(key)
	return audioDraft[key] or (data and data.Settings[key.."Volume"]) or (key=="Music" and .4 or .5)
end
local function applyAudio()
	music.Volume=.3*volumeValue("Music")
	click.Volume=.6*volumeValue("Effects"); revealSound.Volume=click.Volume; pickupSound.Volume=.45*volumeValue("Effects")
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
	local icon=label=="Join Group" and label or Style.Icons[label] and label or label:find("Open") and "Crates" or label:find("Equipped") and "Check" or label:find("Equip") and "Cake" or "Sparkles"
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
local cash=box("$0",UDim2.fromOffset(180,60),UDim2.new(1,-198,.5,-86),colors.Mint,"Coins"); cash.Name="CashValue"; cash.TextSize=28
local plate=Instance.new("ImageLabel"); plate.Name="MiniDessertPlate"; plate.BackgroundTransparency=1
plate.Size=UDim2.fromOffset(112,112); plate.AnchorPoint=Vector2.new(.5,1); plate.Position=UDim2.new(.5,0,1,-12)
plate.Image=Config.PlateImageId or ""; plate.ScaleType=Enum.ScaleType.Fit; plate.Parent=gui
local bag=text(plate,"0",UDim2.fromScale(.68,.5),UDim2.fromScale(.16,.32)); bag.Name="BagValue"; bag.TextScaled=true
local numberLimit=Instance.new("UITextSizeConstraint"); numberLimit.MinTextSize=14; numberLimit.MaxTextSize=27; numberLimit.Parent=bag
local boost=box("×1",UDim2.fromOffset(180,48),UDim2.new(1,-198,.5,38),colors.Lavender,"Multiplier")
local shinyChance=box("Shiny 1%",UDim2.fromOffset(180,48),UDim2.new(1,-198,.5,-18),colors.Pink,"Sparkles")
shinyChance.Name="ShinyChanceValue"; shinyChance.TextSize=16; boost.TextSize=16
local function updateShinyChance()
 local tier=data.ShinyTier or Rules.BuyTier(data)
 local percent=100*(data.ShinyChance or Rules.ShinyChance("Normal",data.Luck,data.FriendBonus,data.CodeShiny50,tier))
 shinyChance.Text=string.format("Shiny T%d\n%.4g%%",tier,percent)
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
local title=text(window,"",UDim2.new(1,-100,0,54),UDim2.fromOffset(50,0)); title.TextXAlignment=Enum.TextXAlignment.Center; title.TextSize=24
-- The approved 59px panel crop includes transparent pixels on its right edge.
-- Align to the artwork's actual header center (x=139.5), not the crop rectangle.
title.AnchorPoint=Vector2.new(.5,.5); title.Position=UDim2.fromScale(28.5/59,6/83)
local closePanel=button(window,"×",UDim2.fromOffset(32,32),UDim2.fromScale(53/59,6/83),function() window.Visible=false; panelName=nil end)
closePanel.AnchorPoint=Vector2.new(.5,.5)
local scroll=Instance.new("ScrollingFrame"); scroll.Name="PanelContent"
scroll.Size=UDim2.new(47/59,-12,60/83,-12); scroll.Position=UDim2.new(5/59,6,14/83,6)
scroll.ClipsDescendants=true
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
local function preview(parent,tier,shiny,size,pos,variant)
	local view=Instance.new("ViewportFrame"); view.Size=size; view.Position=pos; view.BackgroundTransparency=1
	view.Visible=false; view.ZIndex=parent.ZIndex+1; view.Ambient=Color3.fromRGB(220,208,220); view.LightColor=Color3.fromRGB(255,247,233); view.Parent=parent
	local fallback=DessertImages.Create(parent,tier,shiny,variant,size,pos)
	local world=Instance.new("WorldModel"); world.Parent=view
	local model=Visuals.Build(tier,shiny,variant); model.Parent=world
	local box,bounds=model:GetBoundingBox()
	local camera=Instance.new("Camera"); camera.FieldOfView=35
	camera.Parent=view; view.CurrentCamera=camera
	local function fitCamera()
		local aspect=math.max(.1,view.AbsoluteSize.X/math.max(1,view.AbsoluteSize.Y))
		local distance=math.max((bounds.Y+.65)/2,bounds.X/(2*aspect))/math.tan(math.rad(35/2))+bounds.Z/2
		camera.CFrame=CFrame.lookAt(box.Position+Vector3.new(0,.15,-distance),box.Position)
	end
	fitCamera();view:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitCamera)
	task.spawn(function()
        local loaded=true
        local ok=pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(model:GetDescendants(),function(_,status)
                if status~=Enum.AssetFetchStatus.Success then loaded=false end
            end)
        end)
        if not ok or not loaded or not view.Parent then return end
        box,bounds=model:GetBoundingBox();fitCamera()
        Run.RenderStepped:Wait();Run.RenderStepped:Wait()
        if not view.Parent then return end
        view.Visible=true;view:SetAttribute("PreviewReady",true);fallback:Destroy()
    end)
    table.insert(spinning,{Model=model,View=view,Base=model:GetPivot()})
	return view
end
local show,kawaiiShop
local function fitPanel()
 local v=workspace.CurrentCamera.ViewportSize
 local w=math.max(260,math.min(940,v.X-24)); local h=math.max(260,math.min(660,v.Y-90))
 window.AnchorPoint=Vector2.new(.5,.5); window.Position=UDim2.fromScale(.5,.5); window.Size=UDim2.fromOffset(w,h)
 if indexGrid then
  local contentWidth=w*47/59-12
  local cols=contentWidth>=700 and 4 or contentWidth>=500 and 3 or contentWidth>=320 and 2 or 1
  indexGrid.FillDirectionMaxCells=cols; indexGrid.HorizontalAlignment=Enum.HorizontalAlignment.Center
  indexGrid.CellSize=UDim2.fromOffset(math.floor((contentWidth-8-(cols-1)*12)/cols),190)
 end
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitPanel)
show=function(name)
	if not data then return end
	if draggingVolume then local key=draggingVolume.Key; draggingVolume=nil; setVolume(key,volumeValue(key),true) end
	volumeControls={}; scroll.ScrollingEnabled=true
	if kawaiiShop then kawaiiShop.Destroy(); kawaiiShop=nil end
	if panelName~=name then scroll.CanvasPosition=Vector2.zero end
	panelName=name; window.Visible=name~="Shop"; title.Text=name; scroll:ClearAllChildren(); giftLabel=nil; statLabels={}; indexGrid=nil
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
		local index=0
		for tier=1,30 do for variant=0,2 do
			local shiny=variant>0; local key=Rules.Key(tier,shiny,variant); local owned=data.Index[key]
			local row=math.floor(index/4); local column=index%4
			local card=Instance.new("Frame"); card.Size=UDim2.new(.25,-12,0,190); card.Position=UDim2.new(column*.25,6,0,row*200)
			card.Name="IndexCard"..key; card.LayoutOrder=index; index+=1; card.ZIndex=scroll.ZIndex+1; card.Parent=scroll; Art.Apply(card,"Card")
			if owned then
				local artBounds=Instance.new("Frame"); artBounds.Name="DessertImageBounds"; artBounds.BackgroundTransparency=1
				artBounds.Position=UDim2.fromOffset(20,20); artBounds.Size=UDim2.new(1,-40,0,104)
				artBounds.ClipsDescendants=true; artBounds.ZIndex=card.ZIndex+1; artBounds.Parent=card
				DessertImages.Create(artBounds,tier,shiny,variant,UDim2.fromScale(1,1),UDim2.new())
			else
				local mystery=text(card,"?",UDim2.new(1,-40,0,64),UDim2.fromScale(.5,.5))
				mystery.AnchorPoint=Vector2.new(.5,.5); mystery.Name="MysteryMark"; mystery.TextSize=58
			end
			text(card,owned and DessertImages.Name(tier,shiny,variant) or "Undiscovered",UDim2.new(1,-8,0,26),UDim2.fromOffset(4,126)).TextSize=((tier==9 or tier==13 or tier==14 or tier==15 or tier>=17) and shiny) and 10 or (shiny and 12 or 14)
			if owned then local equipButton=button(card,data.Equipped==key and "Unequip" or "Equip",UDim2.new(1,-16,0,32),UDim2.fromOffset(8,152),function() request("Equip",key) end,colors.Mint); equipButton.Name="TutorialEquip"..key end
		end end
		for _,key in ipairs(CodePets.Order) do if (data.CodePets or {})[key] then
			local spec=CodePets.Items[key]
			local card=Instance.new("Frame");card.Name="IndexCard"..key;card.LayoutOrder=index;index+=1
			card.ZIndex=scroll.ZIndex+1;card.Parent=scroll;Art.Apply(card,"Card")
			CodePets.CreateImage(card,key,UDim2.new(1,-40,0,104),UDim2.fromOffset(20,20))
			text(card,spec.Name,UDim2.new(1,-8,0,26),UDim2.fromOffset(4,126)).TextSize=14
			button(card,data.Equipped==key and "Unequip" or "Equip",UDim2.new(1,-16,0,32),UDim2.fromOffset(8,152),function() request("Equip",key) end,colors.Mint).Name="EquipCodePet"
		end end
	elseif name=="Join Group" then
		local claimed=data.CommunityRewardClaimed
		text(scroll,"Join Cosmon Studio?",UDim2.new(1,-20,0,46),UDim2.fromOffset(10,8)).TextSize=25
		UserArt.Create(scroll,"GroupJoin",UDim2.fromOffset(112,100),UDim2.new(.5,-56,0,58))
		local status=text(scroll,claimed and "Your free Perk Crate has already been claimed." or "Join our community and receive 1 free Perk Crate!\nOne reward per account.",UDim2.new(1,-24,0,74),UDim2.fromOffset(12,164)); status.TextSize=17
		local busy=false
		local join=button(scroll,claimed and "Reward Claimed" or "Yes, Join Group",UDim2.new(.5,-16,0,46),UDim2.fromOffset(8,246),function()
			if busy or data.CommunityRewardClaimed then return end
			if Run:IsStudio() then status.Text="Group joining is available in the published game.";return end
			busy=true
			local ok,result=pcall(function() return game:GetService("GroupService"):PromptJoinAsync(Config.CommunityId) end)
			if not ok or (result~=Enum.GroupMembershipStatus.Joined and result~=Enum.GroupMembershipStatus.AlreadyMember) then
				if status.Parent then status.Text=ok and (result==Enum.GroupMembershipStatus.JoinRequestPending and "Your join request is pending. Claim after it is approved." or "Joining cancelled. You can try again anytime.") or "Could not open the group prompt. Please try again." end
				busy=false;return
			end
			local called,granted,message=pcall(action.InvokeServer,action,"CommunityReward")
			if status.Parent then status.Text=called and (message or "Checking membership...") or "Connection unavailable. Please try again." end
			-- Roblox can retain a negative server membership result for sixty seconds.
			if called and not granted and message and message:find("Membership not confirmed",1,true) then
				if status.Parent then status.Text="Confirming your membership... Your reward will be checked again shortly." end
				task.wait(65)
				if screen.Parent and not data.CommunityRewardClaimed then
					local retry,saved,note=pcall(action.InvokeServer,action,"CommunityReward")
					if status.Parent then status.Text=retry and (note or "Please try again.") or "Connection unavailable. Please try again." end
				end
			end
			busy=false
		end,colors.Pink)
		join.Name="ConfirmJoinGroup";join.Active=not claimed;join.AutoButtonColor=not claimed
		button(scroll,"Cancel",UDim2.new(.5,-16,0,46),UDim2.new(.5,8,0,246),function() window.Visible=false;panelName=nil end,colors.Mint)
	elseif name=="Settings" then
		volumeSlider("Music","Background Music",0)
		volumeSlider("Effects","Sound Effects",130)
		button(scroll,"Hide Other Players' Pets: "..(data.Settings.HideOthers and "ON" or "OFF"),UDim2.new(1,-18,0,54),UDim2.fromOffset(6,260),function()
			request("Settings",{HideOthers=not data.Settings.HideOthers}); task.delay(.3,function() if panelName=="Settings" then show("Settings") end end)
		end,colors.Lavender)
		text(scroll,voiceStatus,UDim2.new(1,-18,0,54),UDim2.fromOffset(6,326)).TextSize=15
		button(scroll,"Codes",UDim2.new(1,-18,0,54),UDim2.fromOffset(6,390),function() show("Codes") end,colors.Mint).Name="OpenCodes"
	elseif name=="Codes" then
		text(scroll,"Enter your code",UDim2.new(1,-20,0,42),UDim2.fromOffset(10,16)).TextSize=23
		local entry=Instance.new("TextBox");entry.Name="CodeInput";entry.Text="";entry.PlaceholderText="Enter code here"
		entry.ClearTextOnFocus=false;entry.MultiLine=false;entry.Font=Enum.Font.Gotham;entry.TextSize=20
		entry.TextColor3=colors.Text;entry.PlaceholderColor3=Color3.fromRGB(153,125,143);entry.BackgroundColor3=colors.Cream
		entry.Size=UDim2.new(1,-32,0,60);entry.Position=UDim2.fromOffset(16,76);entry.ZIndex=scroll.ZIndex+2;entry.Parent=scroll;corner(entry,14)
		local border=Instance.new("UIStroke");border.Color=colors.Lavender;border.Thickness=2;border.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;border.Parent=entry
		entry:GetPropertyChangedSignal("Text"):Connect(function() if #entry.Text>64 then entry.Text=entry.Text:sub(1,64) end end)
		local status=text(scroll,"",UDim2.new(1,-24,0,70),UDim2.fromOffset(12,214));status.Name="CodeStatus";status.TextSize=17
		local busy=false
		local redeem
		local function submit()
			if busy then return end
			busy=true;status.Text="Checking code...";redeem.Text="Checking..."
			local called,granted,message=pcall(action.InvokeServer,action,"RedeemCode",entry.Text)
			if status.Parent then
				status.Text=called and (message or "Please try again.") or "Connection unavailable. Please try again."
				status.TextColor3=called and granted and Color3.fromRGB(0,105,50) or colors.Text
				redeem.Text="Redeem";if called and granted then entry.Text="" end
			end
			busy=false
		end
		redeem=button(scroll,"Redeem",UDim2.new(1,-32,0,54),UDim2.fromOffset(16,150),submit,colors.Mint);redeem.Name="RedeemCode"
		entry.FocusLost:Connect(function(enterPressed) if enterPressed then submit() end end)
		button(scroll,"Back to Settings",UDim2.new(1,-32,0,46),UDim2.fromOffset(16,298),function() show("Settings") end,colors.Lavender)
	elseif name=="Stats" then
		for n,item in ipairs({{"TotalCashEarned","Total Cash Earned"},{"TotalMiniCollected","Mini Desserts Collected"},{"PlaySeconds","Total Play Time"}}) do
			local card=Instance.new("Frame"); card.Size=UDim2.new(1,-32,0,108); card.Position=UDim2.fromOffset(16,(n-1)*126); card.ZIndex=scroll.ZIndex+1; card.Parent=scroll; Art.Apply(card,"Card")
			text(card,item[2],UDim2.new(1,-24,0,38),UDim2.fromOffset(12,12)).TextSize=20
			statLabels[item[1]]=text(card,"",UDim2.new(1,-24,0,40),UDim2.fromOffset(12,54)); statLabels[item[1]].TextSize=27
		end
	elseif name=="Shiny Odds" then
		text(scroll,"Rates depend on the RESULT tier. Each purchase or merge result rolls separately. Two shiny variants share the shiny rate equally.",UDim2.new(1,-16,0,100),UDim2.fromOffset(8,0)).TextSize=16
		text(scroll,string.format("Luck x%.2g | Social boost +%.0f%% (relative)",data.Luck or 1,(data.FriendBonus or 0)*100),UDim2.new(1,-16,0,40),UDim2.fromOffset(8,104)).TextSize=16
		for band=1,6 do
			local tier=band*5
			local normal=Rules.ShinyChance("Normal",data.Luck,data.FriendBonus,data.CodeShiny50,tier)*100
			local perk=Rules.ShinyChance("Perk",data.Luck,data.FriendBonus,data.CodeShiny50,tier)*100
			text(scroll,string.format("Tiers %d-%d: %.4g%% buy / merge / Normal Crate | %.4g%% Perk",tier-4,tier,normal,perk),UDim2.new(1,-16,0,58),UDim2.fromOffset(8,150+(band-1)*62)).TextSize=16
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
					if hasCredits then
                        window.Visible=false;panelName=nil
                        local accepted=request("Crate",{Kind=kind,Count=count})
                        if not accepted then show("Crates") end
                    elseif purchasable then request("Purchase",key) end
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
				local entries={"Odds per result. Rounded values may not total 100%."}
				for _,outcome in ipairs(Rules.CrateOutcomeOdds(data.Highest,kind,data.Luck,data.FriendBonus,data.CodeShiny50)) do
					table.insert(entries,DessertImages.Name(outcome.Tier,outcome.Shiny,outcome.Variant)..": "..string.format("%.6g%%",outcome.Percent))
				end
				local detail=text(choices,kind.." Details\n"..table.concat(entries,"\n"),UDim2.new(1,-12,0,0),UDim2.fromOffset(6,350))
				detail.TextSize=14; detail.AutomaticSize=Enum.AutomaticSize.Y
			end
		end
	end
 fitPanel()
 for key,label in pairs(statLabels) do local value=data[key] or 0; label.Text=key=="PlaySeconds" and string.format("%dh %02dm %02ds",math.floor(value/3600),math.floor(value/60)%60,math.floor(value)%60) or (key=="TotalCashEarned" and "$" or "")..format(value) end
end
local communityButton=button(gui,"Join Group",UDim2.fromOffset(118,54),UDim2.new(0,18,.5,-132),function() show("Join Group") end,colors.Pink,true)
local shinyInfo=Instance.new("TextButton");shinyInfo.Name="ShinyOddsButton";shinyInfo.Text="";shinyInfo.BackgroundTransparency=1;shinyInfo.Size=UDim2.fromScale(1,1);shinyInfo.ZIndex=shinyChance.ZIndex+1;shinyInfo.Parent=shinyChance.Parent
shinyInfo.Activated:Connect(function() show("Shiny Odds") end)
communityButton.Name="JoinGroupButton"
local indexButton=button(gui,"Index",UDim2.fromOffset(118,54),UDim2.new(0,18,.5,-70),function() show("Index") end,colors.Pink,true)
button(gui,"Shop",UDim2.fromOffset(118,48),UDim2.new(0,18,.5,-8),function() show("Shop") end,colors.Mint,true)
local topbar=Instance.new("ScreenGui"); topbar.Name="DessertTopbar"; topbar.IgnoreGuiInset=true; topbar.ResetOnSpawn=false; topbar.Parent=screen.Parent
local settings=Instance.new("ImageButton"); settings.Name="SettingsButton"; settings.Size=UDim2.fromOffset(56,56)
settings.Image=Style.Icons.Settings; settings.ImageColor3=Color3.fromRGB(255,240,245); settings.BackgroundColor3=Color3.fromRGB(35,36,40); settings.Parent=topbar; corner(settings,28)
local statsButton=Instance.new("ImageButton"); statsButton.Name="StatsButton"; statsButton.Size=UDim2.fromOffset(56,56); statsButton.Image="rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"; statsButton.BackgroundColor3=Color3.fromRGB(35,36,40); statsButton.Parent=topbar; corner(statsButton,28)
statsButton.Activated:Connect(function() show("Stats") end)
local function positionSettings()
	local inset=game:GetService("GuiService").TopbarInset
	local width=workspace.CurrentCamera.ViewportSize.X
	local size=math.clamp(math.floor((width-inset.Min.X-24)/2),24,56)
	for _,b in ipairs({settings,statsButton}) do b.Size=UDim2.fromOffset(size,size) end
	settings.Position=UDim2.fromOffset(inset.Min.X+8,inset.Min.Y+math.max(8,(inset.Height-size)/2))
	statsButton.Position=settings.Position+UDim2.fromOffset(size+8,0)
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
		if model:GetAttribute("PhysicalDrop") then
			for _,p in ipairs(model:GetDescendants()) do
				if p:IsA("BasePart") then p.LocalTransparencyModifier=1 elseif p:IsA("ParticleEmitter") then p.Enabled=false end
			end
		elseif pet and owner and owner~=0 and owner~=player.UserId then for _,p in ipairs(model:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier=data.Settings.HideOthers and 1 or 0
			elseif p:IsA("ParticleEmitter") then p.Enabled=not data.Settings.HideOthers end
		end end
	end
	for model,state in pairs(dropViews) do
		local hidden=data.Settings.HideOthers and model:GetAttribute("OwnerUserId")~=player.UserId
		for _,p in ipairs(state.View:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier=hidden and 1 or 0 elseif p:IsA("ParticleEmitter") then p.Enabled=not hidden end
		end
	end
end
local rewards=Rewards.Open(gui,{
 Text=text,Button=button,Preview=preview,
 Sound=function() if not data or data.Settings.Effects then revealSound:Play() end end,
})
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
	if kind=="Pickup" then
		if os.clock()-lastPickup>=.12 and volumeValue("Effects")>0 then
			lastPickup=os.clock(); pickupSound.TimePosition=0; pickupSound:Play()
		end
	elseif kind=="State" then
		local previousIndex=data and data.Index or {}
		local previousCodePets=data and data.CodePets or {}
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
		if panelName=="Index" then
   local changed=previousEquipped~=data.Equipped
   for key in pairs(previousIndex) do if not data.Index[key] then changed=true;break end end
   for key in pairs(previousCodePets) do if not (data.CodePets or {})[key] then changed=true;break end end
   for key in pairs(data.Index) do if not previousIndex[key] then changed=true; break end end
   for key in pairs(data.CodePets or {}) do if not previousCodePets[key] then changed=true; break end end
   if changed then show("Index") end
  end
		if panelName=="Crates" and (previousHighest~=data.Highest or previousNormal~=data.NormalTokens or previousPerk~=data.PerkTokens or previousPaidNormal~=data.PaidNormalTokens or previousPaidPerk~=data.PaidPerkTokens or previousChance~=data.ShinyChance) then show("Crates") end
		if panelName=="Shiny Odds" and (previousHighest~=data.Highest or previousChance~=data.ShinyChance) then show("Shiny Odds") end
		if panelName=="Shop" then
			for key in pairs(Config.Passes) do if previousPasses[key]~=data.OwnedPasses[key] then show("Shop"); break end end
		end
	elseif kind=="Panel" then show(value)
	elseif kind=="Discovery" then rewards.Discovery(value)
	elseif kind=="Crates" then window.Visible=false;panelName=nil;rewards.Crates(value)
	elseif kind=="CafeDelivery" or kind=="CafeCash" then transfer(kind,value,message)
	end
end)
local lastActivity=0
local actualLastInput=os.clock(); local lastRejoinAttempt=-math.huge
local function recordInput(input)
 actualLastInput=os.clock()
 if os.clock()-lastActivity>5 then lastActivity=os.clock(); task.spawn(request,"Activity") end
end
Input.InputBegan:Connect(recordInput)
Input.InputChanged:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then recordInput(input) end
end)
-- Real reconnect; camera animation cannot reset Roblox's idle timer.
task.spawn(function()
 while screen.Parent do
  task.wait(5)
  local now=os.clock()
  if not Run:IsStudio() and now-actualLastInput>=Config.IdleRejoinSeconds and now-lastRejoinAttempt>=30 then
   lastRejoinAttempt=now;request("IdleRejoin")
  end
 end
end)
local visibilityTimer=0
local producers={}
local dropFolder=Instance.new("Folder");dropFolder.Name="ClientDropVisuals";dropFolder.Parent=workspace
local function trackDessert(model)
	if not model:IsA("Model") or not model.Parent then return end
	if model.Name=="MiniDessert" and model:GetAttribute("PhysicalDrop") then
		local body=model:WaitForChild("DropCollider",5);if not body or not model.Parent then return end
		local view=Visuals.BuildMini(model:GetAttribute("Tier") or 1,model:GetAttribute("Shiny")==true,model:GetAttribute("Variant"))
		view.Name="DropVisual";view:SetAttribute("SourceDrop",model:GetAttribute("DropStartTime"))
		local offset=model:GetAttribute("DropVisualOffset") or CFrame.new(0,-body.Size.Y/2,0)
		view:PivotTo(body.CFrame*offset);view.Parent=dropFolder
		dropViews[model]={View=view,Body=body,Offset=offset,Current=body.CFrame}
		for _,p in ipairs(model:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier=1 elseif p:IsA("ParticleEmitter") then p.Enabled=false end
		end
		local hidden=data and data.Settings.HideOthers and model:GetAttribute("OwnerUserId")~=player.UserId
		for _,p in ipairs(view:GetDescendants()) do
			if p:IsA("BasePart") then p.LocalTransparencyModifier=hidden and 1 or 0 elseif p:IsA("ParticleEmitter") then p.Enabled=not hidden end
		end
	elseif model.Parent.Name=="ActiveDesserts" then
		producers[model]={Base=model:GetAttribute("DisplayBasePivot") or model:GetPivot(),Height=0}
	end
end
for _,model in ipairs(workspace:GetDescendants()) do trackDessert(model) end
workspace.DescendantAdded:Connect(trackDessert)
workspace.DescendantRemoving:Connect(function(model)
	producers[model]=nil
	local view=dropViews[model];if view then view.View:Destroy();dropViews[model]=nil end
end)
local companions={}
local function trackCompanion(model)
	if model:IsA("Model") and model.Name=="DessertCompanion" then
		companions[model]={Owner=Players:GetPlayerByUserId(model:GetAttribute("OwnerUserId") or 0)}
	end
end
for _,model in ipairs(workspace:GetChildren()) do trackCompanion(model) end
workspace.ChildAdded:Connect(trackCompanion)
workspace.ChildRemoved:Connect(function(model) companions[model]=nil end)
Run.RenderStepped:Connect(function(dt)
	local serverNow=workspace:GetServerTimeNow()
	for _,state in pairs(dropViews) do
		local target=state.Body.CFrame
		if (target.Position-state.Current.Position).Magnitude>15 then state.Current=target
		else state.Current=state.Current:Lerp(target,1-math.exp(-18*math.min(dt,.1))) end
		state.View:PivotTo(state.Current*state.Offset)
	end
	for model,state in pairs(producers) do
		local producedAt=model:GetAttribute("LastProductionTime")
		local height=producedAt and Motion.HopHeight(serverNow-producedAt) or 0
		if height~=state.Height then model:PivotTo(state.Base+Vector3.new(0,height,0));state.Height=height end
	end
	for model,state in pairs(companions) do
		local owner=state.Owner
		if not owner then owner=Players:GetPlayerByUserId(model:GetAttribute("OwnerUserId") or 0);state.Owner=owner end
		local character=owner and owner.Character
		local root=character and character:FindFirstChild("HumanoidRootPart")
		if root then
			local target=root.CFrame*CFrame.new(-3,3+math.sin(workspace:GetServerTimeNow()*2)*.3,2)
			local current=state.Current
			if not current or (current.Position-target.Position).Magnitude>40 then current=target
			else current=current:Lerp(target,1-math.exp(-10*math.min(dt,.1))) end
			state.Current=current;model:PivotTo(current)
		end
	end
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
	for n=#spinning,1,-1 do
  local v=spinning[n]
  if not v.View:IsDescendantOf(screen) then table.remove(spinning,n)
  else
   local visible=true; local ancestor=v.View
   while ancestor and ancestor~=screen do
    if ancestor:IsA("GuiObject") and not ancestor.Visible then visible=false; break end
    ancestor=ancestor.Parent
   end
   if visible then v.Model:PivotTo(v.Base+Vector3.new(0,math.sin(serverNow*2)*.2,0)) end
  end
 end
	visibilityTimer+=dt; if visibilityTimer>2 then visibilityTimer=0; applySettings(true) end
end)
task.spawn(function()
	for _=1,30 do local state=request("State"); if type(state)=="table" then
		data=state; updateShinyChance(); cash.Text="$"..format(data.Cash); bag.Text=format(data.Bag); boost.Text="×"..data.Multiplier; applySettings(); break
	end; task.wait(1) end
end)

indexButton.Name="TutorialIndexButton"
require(RS:WaitForChild("DessertTutorial")).Start(screen,function() return data end)
