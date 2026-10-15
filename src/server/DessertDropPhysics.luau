-- One simple, server-owned rolling body per collectible. Visual meshes never collide.
local PhysicsService=game:GetService("PhysicsService")
local Drops={}
local DROP_GROUP="DessertDrops"
local CHARACTER_GROUP="DessertCharacters"
local ENTER_GROUP="DessertEntering"
local GUIDE_GROUP="DessertGuides"
local ENTRY_GUIDE_GROUP="DessertEntryGuides"
for _,name in ipairs({DROP_GROUP,CHARACTER_GROUP,ENTER_GROUP,GUIDE_GROUP,ENTRY_GUIDE_GROUP}) do
	if not PhysicsService:IsCollisionGroupRegistered(name) then PhysicsService:RegisterCollisionGroup(name) end
end
PhysicsService:CollisionGroupSetCollidable(DROP_GROUP,DROP_GROUP,true)
PhysicsService:CollisionGroupSetCollidable(DROP_GROUP,CHARACTER_GROUP,false)
PhysicsService:CollisionGroupSetCollidable(ENTER_GROUP,CHARACTER_GROUP,false)
PhysicsService:CollisionGroupSetCollidable(ENTER_GROUP,DROP_GROUP,true)
PhysicsService:CollisionGroupSetCollidable(GUIDE_GROUP,"Default",false)
PhysicsService:CollisionGroupSetCollidable(GUIDE_GROUP,CHARACTER_GROUP,false)
PhysicsService:CollisionGroupSetCollidable(GUIDE_GROUP,ENTER_GROUP,false)
PhysicsService:CollisionGroupSetCollidable(GUIDE_GROUP,DROP_GROUP,true)
PhysicsService:CollisionGroupSetCollidable(ENTRY_GUIDE_GROUP,"Default",false)
PhysicsService:CollisionGroupSetCollidable(ENTRY_GUIDE_GROUP,CHARACTER_GROUP,false)
PhysicsService:CollisionGroupSetCollidable(ENTRY_GUIDE_GROUP,ENTER_GROUP,true)
PhysicsService:CollisionGroupSetCollidable(ENTRY_GUIDE_GROUP,DROP_GROUP,true)

function Drops.SetupPlot(plot)
	local old=plot:FindFirstChild("DropLaneGuides");if old then old:Destroy() end
	local guides=Instance.new("Folder");guides.Name="DropLaneGuides";guides.Parent=plot
	local cf=plot:GetPivot()
	local function visibleGuard(size,placement)
		local p=Instance.new("Part");p.Name="MintLaneGuard";p.Size=size;p.CFrame=cf*placement
		p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
		p.Material=Enum.Material.Plastic;p.Color=Color3.fromRGB(166,223,202);p.Parent=guides
	end
	local function rollingFloor(name,size,placement)
		local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf*placement
		p.Anchored=true;p.Transparency=1;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
		p.CollisionGroup=ENTRY_GUIDE_GROUP;p.Parent=guides
	end
	local function rail(name,x,z,sx,sz,height,collisionGroup)
		local p=Instance.new("Part");p.Name=name;p.Size=Vector3.new(sx,height or 16,sz)
		p.CFrame=cf*CFrame.new(x,(height or 16)/2,z);p.Anchored=true;p.Transparency=1
		p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.CollisionGroup=collisionGroup or GUIDE_GROUP;p.Parent=guides
	end
	local lanes={}
	for _,slope in ipairs(plot.Conveyors:GetChildren()) do if slope.Name=="FeedSlope" then
		local localPos=cf:PointToObjectSpace(slope.Position)
		local side=localPos.X<0 and -1 or 1
		local length=slope.Size.Z;local width=slope.Size.X
		local inner=math.abs(localPos.X)-length/2+.2
		local outer=math.abs(localPos.X)+length/2+.2
		local angle=math.atan(slope.Size.Y/length)
		-- Solid thickness and overlapping ends avoid the zero-thickness wedge edge
		-- that small spheres can fall through at the center junction.
		rollingFloor("FeedRollingFloor",Vector3.new((length+2.4)/math.cos(angle),.4,width+.1),CFrame.new(localPos.X-side*.9,localPos.Y-.9*slope.Size.Y/length-.2/math.cos(angle)+.015,localPos.Z)*CFrame.Angles(0,0,side*angle))
		for _,sign in ipairs({-1,1}) do
			rail("FeedEdge",side*(inner+outer)/2,localPos.Z+sign*(width/2+.1),outer-inner,.2,nil,sign<0 and ENTRY_GUIDE_GROUP or GUIDE_GROUP)
			visibleGuard(Vector3.new(length/math.cos(angle),.65,.2),CFrame.new(localPos.X,localPos.Y+.325,localPos.Z+sign*(width/2+.1))*CFrame.Angles(0,0,side*angle))
		end
		rail("FeedEnd",side*outer,localPos.Z,.2,width+.4,nil,ENTRY_GUIDE_GROUP)
		lanes[localPos.Z]=width/2+.1
	end end
	local belt=plot.Conveyors.MainBelt;local center=cf:PointToObjectSpace(belt.Position)
	local mainAngle=math.atan(belt.Size.Y/belt.Size.Z)
	rollingFloor("MainRollingFloor",Vector3.new(belt.Size.X+.6,.4,(belt.Size.Z+.2)/math.cos(mainAngle)),CFrame.new(center.X,center.Y-.2/math.cos(mainAngle)+.015,center.Z)*CFrame.Angles(-mainAngle,0,0))
	local function mainEdge(side,start,finish)
		if finish<=start then return end
		local z=(start+finish)/2;local angle=math.atan(belt.Size.Y/belt.Size.Z)
		rail("MainEdge",side*(belt.Size.X/2+.1),z,.2,finish-start)
		local y=center.Y-belt.Size.Y/2+(z-(center.Z-belt.Size.Z/2))*belt.Size.Y/belt.Size.Z
		visibleGuard(Vector3.new(.2,.65,(finish-start)/math.cos(angle)),CFrame.new(side*(belt.Size.X/2+.1),y+.325,z)*CFrame.Angles(-angle,0,0))
	end
	local rows={};for z,half in pairs(lanes) do table.insert(rows,{Z=z,Half=half}) end
	table.sort(rows,function(a,b) return a.Z<b.Z end)
	for _,side in ipairs({-1,1}) do
		local start=center.Z-belt.Size.Z/2-1
		for _,row in ipairs(rows) do
			local finish=row.Z-row.Half
			mainEdge(side,start,finish)
			start=row.Z+row.Half
		end
		local finish=center.Z+belt.Size.Z/2
		mainEdge(side,start,finish)
	end
	local tray=plot.Conveyors.Collector;local t=cf:PointToObjectSpace(tray.Position)
	for _,side in ipairs({-1,1}) do rail("TrayEdge",t.X+side*tray.Size.X/2,t.Z,.2,tray.Size.Z,3) end
	rail("TrayFront",t.X,t.Z-tray.Size.Z/2,tray.Size.X,.2,3)
	-- Bridge the small raised lip where the wedge ends and the white tray starts.
	local endZ=center.Z-belt.Size.Z/2
	local startZ=endZ+3;local finishZ=endZ-1
	-- Start beneath the yellow wedge: overlapping slopes join without a box edge
	-- that a small rolling sphere can catch on.
	local startY=center.Y-belt.Size.Y/2+belt.Size.Y*3/belt.Size.Z-.15
	local finishY=t.Y+tray.Size.Y/2
	local angle=math.atan((startY-finishY)/(startZ-finishZ));local thickness=.08
	local bridge=Instance.new("Part");bridge.Name="TrayTransition";bridge.Anchored=true
	bridge.Size=Vector3.new(belt.Size.X,thickness,(startZ-finishZ)/math.cos(angle))
	bridge.CFrame=cf*CFrame.new(center.X,(startY+finishY)/2-thickness/(2*math.cos(angle)),(startZ+finishZ)/2)*CFrame.Angles(-angle,0,0)
	bridge.Transparency=1;bridge.CanTouch=false;bridge.CanQuery=false;bridge.CastShadow=false;bridge.CollisionGroup=GUIDE_GROUP;bridge.Parent=guides
end

function Drops.InCollector(drop)
	if not drop.Collector then return true end
	local p=drop.Collector.CFrame:PointToObjectSpace(drop.Body.Position)
	local margin=drop.Body.Size.X/2+.1
	return math.abs(p.X)<drop.Collector.Size.X/2-margin and math.abs(p.Z)<drop.Collector.Size.Z/2-margin
end

function Drops.Route(plot,pad,rng)
	local cf=plot:GetPivot();local pos=cf:PointToObjectSpace(pad.Position)
	local z=pad:GetAttribute("DropLaneZ")
	local lo=require(game.ReplicatedStorage.ProductionPlot).ChannelHeight(z,plot:GetAttribute("FieldRise"))
	local high=pad:GetAttribute("ShelfHeight") or 2.25
	local y=lo+(high-lo)*math.clamp((math.abs(pos.X)-4)/(plot:GetAttribute("SideLaneWidth") or 40),0,1)
	local collector=plot.Conveyors.Collector
	local points={cf:PointToWorldSpace(pos+Vector3.new(0,.65,0)),cf:PointToWorldSpace(Vector3.new(pos.X,y+.6,z)),
		cf:PointToWorldSpace(Vector3.new(0,lo+.6,z)),cf:PointToWorldSpace(Vector3.new(0,.8,-8)),
		collector.CFrame:PointToWorldSpace(Vector3.new(rng:NextNumber(-collector.Size.X/2+1.5,collector.Size.X/2-1.5),collector.Size.Y/2+.35,rng:NextNumber(-collector.Size.Z/2+1.5,collector.Size.Z/2-2.5)))}
	return points,collector
end

function Drops.Character(character)
	local function configure(part)
		if part:IsA("BasePart") then part.CollisionGroup=CHARACTER_GROUP end
	end
	for _,part in ipairs(character:GetDescendants()) do configure(part) end
	character.DescendantAdded:Connect(configure)
end

function Drops.New(model,points,parent,collector)
	local box,size=model:GetBoundingBox()
	local body=Instance.new("Part");body.Name="DropCollider";body.Shape=Enum.PartType.Ball
	local diameter=math.clamp(math.min(size.X,size.Y,size.Z),.35,.8)
	body.Size=Vector3.one*diameter;body.CFrame=box;body.Transparency=1;body.CastShadow=false
	body.CanCollide=true;body.CanTouch=false;body.CanQuery=false;body.RootPriority=127
	body.CollisionGroup=collector and ENTER_GROUP or DROP_GROUP
	body.CustomPhysicalProperties=PhysicalProperties.new(.4,.4,.05,1,1)
	for _,part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then
		part.Anchored=false;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false;part.Massless=true
		local weld=Instance.new("WeldConstraint");weld.Part0=body;weld.Part1=part;weld.Parent=body
	end end
	body.Parent=model
	local attachment=Instance.new("Attachment");attachment.Parent=body
	local force=Instance.new("LinearVelocity");force.Name="LaneGuidance";force.Attachment0=attachment
	force.RelativeTo=Enum.ActuatorRelativeTo.World;force.VelocityConstraintMode=Enum.VelocityConstraintMode.Plane
	force.PrimaryTangentAxis=Vector3.xAxis;force.SecondaryTangentAxis=Vector3.zAxis;force.PlaneVelocity=Vector2.zero
	force.ForceLimitsEnabled=true;force.ForceLimitMode=Enum.ForceLimitMode.Magnitude;force.MaxForce=0;force.Parent=body
	model:SetAttribute("DropVisualOffset",body.CFrame:ToObjectSpace(model:GetPivot()))
	model:SetAttribute("PhysicalDrop",true);model.PrimaryPart=body;model.Parent=parent
	body:SetNetworkOwner(nil)
	return {Model=model,Body=body,Force=force,Points=points,Waypoint=2,Settled=false,Started=os.clock(),Collector=collector}
end

function Drops.Step(drop)
	local body=drop.Body
	if not body.Parent then return end
	if drop.Settled then
		if Drops.InCollector(drop) then return end
		drop.Settled=false;drop.Force.Enabled=true;drop.Waypoint=#drop.Points
	end
	local position=body.Position
	local delta=drop.Points[drop.Waypoint]-position;delta=Vector3.new(delta.X,0,delta.Z)
	local function reached()
		if drop.Waypoint==2 and drop.Collector then
			return math.abs(drop.Collector.CFrame:VectorToObjectSpace(delta).Z)<.65
		end
		-- Once inside the center lane, turn downhill immediately. Requiring the exact
		-- upstream junction point makes gravity and opposing arrivals hold a pile there.
		if drop.Waypoint==3 and drop.Collector then
			return math.abs(drop.Collector.CFrame:VectorToObjectSpace(delta).X)<1.2
		end
		return delta.Magnitude<.8
	end
	while reached() and drop.Waypoint<#drop.Points do
		body.CollisionGroup=DROP_GROUP
		drop.Waypoint+=1
		delta=drop.Points[drop.Waypoint]-position;delta=Vector3.new(delta.X,0,delta.Z)
	end
	if drop.Collector and drop.Waypoint>=3 then
		local plot=drop.Collector.Parent.Parent;local cf=plot:GetPivot();local localPos=cf:PointToObjectSpace(position)
		local floorY
		if drop.Waypoint==3 then
			local a=cf:PointToObjectSpace(drop.Points[2]);local b=cf:PointToObjectSpace(drop.Points[3])
			local t=math.clamp((localPos.X-a.X)/(b.X-a.X),0,1);floorY=a.Y+(b.Y-a.Y)*t-.6
		elseif drop.Waypoint==4 then
			local belt=plot.Conveyors.MainBelt;local c=cf:PointToObjectSpace(belt.Position)
			floorY=c.Y-belt.Size.Y/2+math.clamp((localPos.Z-c.Z+belt.Size.Z/2)/belt.Size.Z,0,1)*belt.Size.Y
		else floorY=cf:PointToObjectSpace(drop.Collector.Position).Y+drop.Collector.Size.Y/2 end
		local x,z=localPos.X,localPos.Z
		if drop.Waypoint==3 then
			local laneZ=cf:PointToObjectSpace(drop.Points[3]).Z
			if math.abs(z-laneZ)>1.6 then z=laneZ+math.clamp(z-laneZ,-1.1,1.1) end
		elseif drop.Waypoint==4 and math.abs(x)>3.85 then x=math.clamp(x,-3.4,3.4) end
		if localPos.Y<floorY-.25 or x~=localPos.X or z~=localPos.Z then
			-- Rare physics tunneling must not leave a collectible beneath the lane.
			local corrected=cf:PointToWorldSpace(Vector3.new(x,math.max(localPos.Y,floorY+body.Size.Y/2+.03),z))
			body.CFrame=CFrame.new(corrected)*body.CFrame.Rotation;body.AssemblyLinearVelocity=Vector3.zero
			position=corrected;delta=drop.Points[drop.Waypoint]-position;delta=Vector3.new(delta.X,0,delta.Z)
		end
	end
	local velocity=body.AssemblyLinearVelocity;velocity=Vector3.new(velocity.X,0,velocity.Z)
	-- Stop guiding the arrival pile so resting bodies can sleep and keep natural contacts.
	local inside=drop.Collector and drop.Collector.CFrame:PointToObjectSpace(position)
	local clearMouth=not inside or inside.Z<drop.Collector.Size.Z/2-1.5
	if drop.Waypoint==#drop.Points and velocity.Magnitude<1 and Drops.InCollector(drop) and clearMouth then
		drop.Force.Enabled=false;drop.Settled=true;return
	end
	local speed=drop.Waypoint==#drop.Points and math.min(4.5,delta.Magnitude*2) or math.min(4.5,delta.Magnitude*2+1)
	local desired=delta.Magnitude>.01 and delta.Unit*speed or Vector3.zero
	-- The physics solver maintains horizontal transport continuously, including
	-- crowded junctions. Vertical gravity and inter-drop contacts remain free.
	drop.Force.MaxForce=body.AssemblyMass*250
	drop.Force.PlaneVelocity=Vector2.new(desired.X,desired.Z)
end
return Drops
