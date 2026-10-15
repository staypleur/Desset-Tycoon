-- Client presentation only. Rewards, odds and discovery ownership come from the server.
local Tween=game:GetService("TweenService")
local Art=require(script.Parent.PastelArt)
local Images=require(script.Parent.DessertImages)
local Rules=require(script.Parent.DessertRules)
local Rewards={}
function Rewards.Open(gui,ui)
	local queue,running={},false
	local function overlay(name)
		local f=Instance.new("TextButton"); f.Name=name; f.Text=""; f.AutoButtonColor=false; f.Modal=true
		f.Size=UDim2.fromScale(1,1); f.BackgroundColor3=Color3.fromRGB(37,22,42); f.BackgroundTransparency=.18
		f.ZIndex=40; f.Parent=gui
		return f
	end
	local function panel(f,size,pos)
		local p=Instance.new("Frame"); p.Size=size; p.Position=pos; p.ZIndex=f.ZIndex+1; p.Parent=f; Art.Apply(p,"Panel"); return p
	end
	local function sparkle(f)
		ui.Sound()
		-- Reuse the approved stars and hearts, bounded and destroyed with the popup.
		for n=1,28 do
			local star=ui.Text(f,n%2==0 and "✦" or "♥",UDim2.fromOffset(30,30),UDim2.fromScale(math.random(),-.05))
			star.TextColor3=n%2==0 and Color3.fromRGB(255,193,217) or Color3.fromRGB(184,233,212)
			Tween:Create(star,TweenInfo.new(2.3),{Position=UDim2.fromScale(math.random(),1.05),Rotation=math.random(-180,180)}):Play()
		end
	end
	local function discovery(item)
		local f=overlay("DessertDiscoveryPopup")
		local p=panel(f,UDim2.fromScale(.84,.88),UDim2.fromScale(.08,.06))
		ui.Text(p,item.Shiny and "SHINY DISCOVERED!" or "NEW DESSERT!",UDim2.fromScale(.9,.12),UDim2.fromScale(.05,.06)).TextSize=28
		ui.Preview(p,item.Tier,item.Shiny,UDim2.fromScale(.7,.53),UDim2.fromScale(.15,.20),item.Variant)
		ui.Text(p,Images.Name(item.Tier,item.Shiny,item.Variant).." | Tier "..item.Tier,UDim2.fromScale(.9,.13),UDim2.fromScale(.05,.72)).TextSize=24
		sparkle(p)
		local done=false
		ui.Button(p,"Continue",UDim2.fromScale(.4,.08),UDim2.fromScale(.3,.87),function() done=true end)
		local deadline=os.clock()+3.2
		repeat task.wait(.04) until done or os.clock()>=deadline or not f.Parent
		f:Destroy()
	end
	local function key(item) return item.Key or Rules.Key(item.Tier,item.Shiny,item.Variant) end
	local function card(parent,item,known,size,pos)
		local f=Instance.new("Frame"); f.Size=size; f.Position=pos; f.ZIndex=parent.ZIndex+1; f.Parent=parent; Art.Apply(f,"Card")
		f:SetAttribute("DessertKey",key(item)); f:SetAttribute("Known",known==true)
		if known then Images.Create(f,item.Tier,item.Shiny,item.Variant,UDim2.fromScale(.94,.72),UDim2.fromScale(.03,.03))
		else ui.Text(f,"?",UDim2.fromScale(1,.75),UDim2.new()).TextSize=42 end
		ui.Text(f,known and Images.Name(item.Tier,item.Shiny,item.Variant) or "Undiscovered",UDim2.fromScale(.9,.23),UDim2.fromScale(.05,.74)).TextSize=14
		return f
	end
	local function crates(batch)
		local f=overlay("CrateRoulette"); local known=table.clone(batch.KnownBefore)
		local p=panel(f,UDim2.fromScale(.94,.73),UDim2.fromScale(.03,.135))
		local heading=ui.Text(p,"",UDim2.fromScale(.9,.14),UDim2.fromScale(.05,.04)); heading.TextSize=26
		local mask=Instance.new("Frame"); mask.Name="CarouselMask"; mask.BackgroundTransparency=1; mask.ClipsDescendants=true
		mask.Size=UDim2.fromScale(.92,.54); mask.Position=UDim2.fromScale(.04,.22); mask.ZIndex=p.ZIndex+1; mask.Parent=p
		local arrow=ui.Text(p,"▼",UDim2.fromScale(.1,.11),UDim2.fromScale(.45,.13)); arrow.Name="ResultArrow"; arrow.TextSize=34; arrow.ZIndex=mask.ZIndex+5
		local skip=false; local activeTween
		local skipButton=ui.Button(p,"Skip animation",UDim2.fromScale(.42,.10),UDim2.fromScale(.29,.83),function()
			skip=true; if activeTween then activeTween:Cancel() end
		end)
		local candidates={}
		for tier,weight in pairs(Rules.Odds(batch.Highest,batch.Kind)) do
			if weight>0 then
				for variant=0,tier<=3 and 2 or 1 do table.insert(candidates,{Tier=tier,Shiny=variant>0,Variant=variant}) end
			end
		end
		local random=Random.new()
		for index,item in ipairs(batch.Results) do
			heading.Text=batch.Kind.." Crate  "..index.." / "..#batch.Results
			if skip then known[key(item)]=true; continue end
			local train=Instance.new("Frame"); train.Name="DessertTrain"; train.BackgroundTransparency=1
			train.Size=UDim2.fromScale(1,1); train.ZIndex=mask.ZIndex+1; train.Parent=mask
			local stop=25; local stride=.34; local width=.31
			local winner
			for n=1,stop+3 do
				local candidate=n==stop and item or candidates[random:NextInteger(1,#candidates)]
				local c=card(train,candidate,known[key(candidate)],UDim2.fromScale(width,.94),UDim2.fromScale((n-1)*stride,.03))
				if n==stop then winner=c; c.Name="ServerResult" end
			end
			local target=.5-((stop-1)*stride+width/2)
			activeTween=Tween:Create(train,TweenInfo.new(index==1 and 3.6 or 1.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.fromScale(target,0)})
			activeTween:Play(); activeTween.Completed:Wait(); activeTween=nil
			train.Position=UDim2.fromScale(target,0)
			f:SetAttribute("StoppedResultKey",key(item))
			winner:SetAttribute("Stopped",true)
			winner:ClearAllChildren()
			card(winner,item,true,UDim2.fromScale(1,1),UDim2.new())
			known[key(item)]=true
			if not skip then ui.Sound(); task.wait(.65) end
			train:Destroy()
		end
		mask:Destroy(); arrow:Destroy(); skipButton:Destroy()
		heading.Text="Crate Rewards"
		local results=Instance.new("ScrollingFrame"); results.Name="CrateResults"; results.BackgroundTransparency=1; results.BorderSizePixel=0
		results.Size=UDim2.fromScale(.9,.61); results.Position=UDim2.fromScale(.05,.19); results.ZIndex=p.ZIndex+1
		results.AutomaticCanvasSize=Enum.AutomaticSize.Y; results.CanvasSize=UDim2.new(); results.ScrollBarThickness=5; results.Parent=p
		local grid=Instance.new("UIGridLayout"); grid.CellSize=UDim2.new(.31,0,0,150); grid.CellPadding=UDim2.new(.02,0,0,10); grid.Parent=results
		for _,item in ipairs(batch.Results) do card(results,item,true,UDim2.new(),UDim2.new()) end
		local done=false
		ui.Button(p,"Continue",UDim2.fromScale(.42,.10),UDim2.fromScale(.29,.83),function() done=true end)
		repeat task.wait(.05) until done or not f.Parent
		f:Destroy()
		-- Only genuinely new discoveries receive the 3D celebration, including auto-merge discoveries.
		for _,item in ipairs(batch.Discoveries or {}) do discovery(item) end
	end
	local function enqueue(kind,value)
		table.insert(queue,{Kind=kind,Value=value})
		if running then return end; running=true
		task.spawn(function()
			while #queue>0 and gui.Parent do
				local item=table.remove(queue,1)
				if item.Kind=="Crates" then crates(item.Value) else discovery(item.Value) end
			end
			running=false
		end)
	end
	return {Discovery=function(item) enqueue("Discovery",item) end,Crates=function(batch) enqueue("Crates",batch) end}
end
return Rewards
