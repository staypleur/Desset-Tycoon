-- Client-only, noninteractive guidance. Progress is saved and validated by the server.
local Tutorial={}
function Tutorial.Start(screen,getData)
	local player=game:GetService("Players").LocalPlayer
	local Run=game:GetService("RunService")
	local folder=Instance.new("Folder"); folder.Name="DessertTutorialArrows"; folder.Parent=workspace
	local arrows={}
	for i=1,12 do
		local model=Instance.new("Model"); model.Name="Arrow"..i; model.Parent=folder
		for side=-1,1,2 do
			local p=Instance.new("Part"); p.Name="Chevron"; p.Size=Vector3.new(.35,.1,1.7)
			p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.CanQuery=false
			p.Material=Enum.Material.Neon; p.Color=Color3.fromRGB(0,105,50); p.Transparency=1; p.Parent=model
			p:SetAttribute("Side",side)
		end
		arrows[i]=model
	end
	local marker=Instance.new("BillboardGui"); marker.Name="TutorialTarget"; marker.Size=UDim2.fromOffset(70,80)
	marker.AlwaysOnTop=true; marker.StudsOffset=Vector3.new(0,5,0); marker.Parent=screen
	local glyph=Instance.new("TextLabel"); glyph.Size=UDim2.fromScale(1,1); glyph.BackgroundTransparency=1
	glyph.Text="▼"; glyph.TextColor3=Color3.fromRGB(0,105,50); glyph.TextStrokeTransparency=.2; glyph.TextSize=62; glyph.Parent=marker
	local pointer=glyph:Clone(); pointer.Name="TutorialMenuArrow"; pointer.Size=UDim2.fromOffset(54,54); pointer.AnchorPoint=Vector2.new(.5,1); pointer.ZIndex=100; pointer.Visible=false; pointer.Parent=screen
	local lastEquip,elapsed=nil,0
	local connection
	local function hide()
		for _,m in ipairs(arrows) do for _,p in ipairs(m:GetChildren()) do p.Transparency=1 end end
		marker.Enabled=false; pointer.Visible=false
	end
	connection=Run.Heartbeat:Connect(function(dt)
		elapsed+=dt; if elapsed<.1 then return end; elapsed=0
		local d=getData(); if not d then hide(); return end
		local step=d.TutorialStep or 11
		screen:SetAttribute("TutorialStep",step)
		if step>=11 then hide(); folder:Destroy(); marker:Destroy(); pointer:Destroy(); connection:Disconnect(); return end
		hide()
		if step==10 then
			local equip=screen:FindFirstChild("TutorialEquip1n",true)
			local target=screen:FindFirstChild("TutorialIndexButton",true)
			if equip then
				local visible=true; local parent=equip.Parent
				while parent and parent~=screen do
					if parent:IsA("GuiObject") and not parent.Visible then visible=false end
					if parent:IsA("ScrollingFrame") and equip~=lastEquip then parent.CanvasPosition=Vector2.zero end
					parent=parent.Parent
				end
				if visible then target=equip; lastEquip=equip end
			end
			if target then pointer.Visible=true; pointer.Position=UDim2.fromOffset(target.AbsolutePosition.X+target.AbsoluteSize.X/2,target.AbsolutePosition.Y+math.sin(os.clock()*4)*5) end
			return
		end
		local island=workspace:FindFirstChild("DessertJellyIsland")
		local plot=island and island.PlayerPlots:FindFirstChild("Plot"..tostring(d.PlotId))
		local r=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not plot or not r then return end
		local target
		if step==1 or step==5 then
			target=plot.Conveyors:FindFirstChild("Collector")
			if d.AFKStored>0 then target=plot.DessertBaskets.AFKAnchor
			elseif d.OfflineStored>0 then target=plot.DessertBaskets.OfflineAnchor end
		elseif step==2 or step==6 then target=island.CentralHub.DepositPads:FindFirstChild("Deposit"..d.PlotId)
		elseif step==3 or step==7 then target=plot.PersonalShopArea.CollectIncome
		elseif step==4 or step==8 then target=plot.PurchaseButtons.Buy1
		elseif step==9 then target=plot.MergeBoard end
		if not target then return end
		marker.Adornee=target; marker.Enabled=true; marker.StudsOffset=Vector3.new(0,5+math.sin(os.clock()*4)*.4,0)
		-- Lead through the open central aisle and entrance when crossing the bridge.
		local cf=plot:GetPivot(); local localPos=cf:PointToObjectSpace(r.Position)
		local destination=target.Position
		if step==2 or step==6 then
			if localPos.Z>-54 then destination=cf:PointToWorldSpace(Vector3.new(0,0,-58)) end
		elseif localPos.Z< -62 then destination=cf:PointToWorldSpace(Vector3.new(0,0,-55)) end
		local direction=Vector3.new(destination.X-r.Position.X,0,destination.Z-r.Position.Z)
		if direction.Magnitude<1 then return end
		local distance=direction.Magnitude; direction=direction.Unit
		local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances={folder,player.Character}
		for i,m in ipairs(arrows) do
			local offset=2+(i-1)*3
			if offset<distance then
				local pos=r.Position+direction*offset
				local hit=workspace:Raycast(pos+Vector3.new(0,3,0),Vector3.new(0,-20,0),params)
				if hit then
					pos=Vector3.new(pos.X,hit.Position.Y+.12,pos.Z)
					local base=CFrame.lookAt(pos,pos+direction)
					for _,p in ipairs(m:GetChildren()) do
						local side=p:GetAttribute("Side")
						p.CFrame=base*CFrame.new(side*.5,0,.5)*CFrame.Angles(0,side*math.pi/4,0)
						p.Transparency=.1+.2*(.5+.5*math.sin(os.clock()*5-i))
					end
				end
			end
		end
	end)
	screen.Destroying:Once(function() connection:Disconnect(); folder:Destroy() end)
end
return Tutorial
