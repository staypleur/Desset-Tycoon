-- One simple, server-owned rolling body per collectible. Visual meshes never collide.
local PhysicsService=game:GetService("PhysicsService")
local Drops={}
local DROP_GROUP="DessertDrops"
local CHARACTER_GROUP="DessertCharacters"
for _,name in ipairs({DROP_GROUP,CHARACTER_GROUP}) do
	if not PhysicsService:IsCollisionGroupRegistered(name) then PhysicsService:RegisterCollisionGroup(name) end
end
PhysicsService:CollisionGroupSetCollidable(DROP_GROUP,DROP_GROUP,true)
PhysicsService:CollisionGroupSetCollidable(DROP_GROUP,CHARACTER_GROUP,false)

function Drops.Character(character)
	local function configure(part)
		if part:IsA("BasePart") then part.CollisionGroup=CHARACTER_GROUP end
	end
	for _,part in ipairs(character:GetDescendants()) do configure(part) end
	character.DescendantAdded:Connect(configure)
end

function Drops.New(model,points,parent)
	local box,size=model:GetBoundingBox()
	local body=Instance.new("Part");body.Name="DropCollider";body.Shape=Enum.PartType.Ball
	local diameter=math.clamp(math.min(size.X,size.Y,size.Z),.35,.8)
	body.Size=Vector3.one*diameter;body.CFrame=box;body.Transparency=1;body.CastShadow=false
	body.CanCollide=true;body.CanTouch=false;body.CanQuery=false;body.RootPriority=127
	body.CollisionGroup=DROP_GROUP
	body.CustomPhysicalProperties=PhysicalProperties.new(.4,.4,.05,1,1)
	for _,part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then
		part.Anchored=false;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false;part.Massless=true
		local weld=Instance.new("WeldConstraint");weld.Part0=body;weld.Part1=part;weld.Parent=body
	end end
	body.Parent=model
	local attachment=Instance.new("Attachment");attachment.Parent=body
	local force=Instance.new("VectorForce");force.Name="LaneGuidance";force.Attachment0=attachment
	force.RelativeTo=Enum.ActuatorRelativeTo.World;force.ApplyAtCenterOfMass=true;force.Parent=body
	model:SetAttribute("DropVisualOffset",body.CFrame:ToObjectSpace(model:GetPivot()))
	model:SetAttribute("PhysicalDrop",true);model.PrimaryPart=body;model.Parent=parent
	body:SetNetworkOwner(nil)
	return {Model=model,Body=body,Force=force,Points=points,Waypoint=2,Settled=false,Started=os.clock()}
end

function Drops.Step(drop)
	local body=drop.Body
	if not body.Parent or drop.Settled then return end
	local position=body.Position
	local delta=drop.Points[drop.Waypoint]-position;delta=Vector3.new(delta.X,0,delta.Z)
	while delta.Magnitude<.8 and drop.Waypoint<#drop.Points do
		drop.Waypoint+=1
		delta=drop.Points[drop.Waypoint]-position;delta=Vector3.new(delta.X,0,delta.Z)
	end
	local velocity=body.AssemblyLinearVelocity;velocity=Vector3.new(velocity.X,0,velocity.Z)
	-- Stop guiding the arrival pile so resting bodies can sleep and keep natural contacts.
	if (drop.Waypoint==#drop.Points and delta.Magnitude<.8 and velocity.Magnitude<1)
		or os.clock()-drop.Started>20 then
		drop.Force.Enabled=false;drop.Settled=true;return
	end
	local speed=drop.Waypoint==#drop.Points and math.min(7,delta.Magnitude*2) or 7
	local desired=delta.Magnitude>.01 and delta.Unit*speed or Vector3.zero
	local acceleration=(desired-velocity)/.35
	if acceleration.Magnitude>30 then acceleration=acceleration.Unit*30 end
	drop.Force.Force=acceleration*body.AssemblyMass
end
return Drops
