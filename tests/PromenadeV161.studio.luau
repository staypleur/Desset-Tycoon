-- Run in the Studio edit Command Bar after installing current sources.
assert(not game:GetService('RunService'):IsRunning())
local RS=game.ReplicatedStorage
local folder=Instance.new('Folder'); folder.Parent=RS
for _,name in ipairs({'HubPromenade','TycoonConfig','DessertRules'}) do RS[name]:Clone().Parent=folder end
local island=workspace.DessertJellyIsland
local Hub=require(folder.HubPromenade); local R=require(folder.DessertRules)
Hub.Apply(island); local area=island.HubPromenade; Hub.Apply(island)
assert(island.HubPromenade==area,'Repeated application recreated props')
local lamps,fences={},{}
local center=island.CentralHub.CentralShop.CafeArchitecture.CafeFloor.Position
for _,m in ipairs(area:GetChildren()) do
 if m.Name=='StreetLamp' then
  table.insert(lamps,m)
  local pole=m:FindFirstChildWhichIsA('MeshPart',true); local head
  for _,p in ipairs(m:GetDescendants()) do
   assert(not p:IsA('LuaSourceContainer') and not p:IsA('PackageLink'))
   if p:IsA('Part') then head=p end
   if p:IsA('BasePart') then assert(not p.CanTouch and not p.CanCollide and not p.CastShadow) end
  end
  assert(head and pole)
  local angle=(m:GetAttribute('PathIndex')-1)*math.pi/3
  local side=m:GetAttribute('PathSide')
  local right=CFrame.lookAt(Vector3.zero,Vector3.new(math.sin(angle),0,math.cos(angle))).RightVector
  local facing=head.Position-pole.Position; facing=Vector3.new(facing.X,0,facing.Z).Unit
  assert(facing:Dot(right*(-side))>.98,'Lamp head does not face the path')
 elseif m.Name=='Fence' then
  table.insert(fences,m)
  local pos=m:GetBoundingBox().Position
  assert(math.abs(Vector3.new(pos.X-center.X,0,pos.Z-center.Z).Magnitude-78)<.05,'Path fence remains')
 end
end
assert(#lamps==24 and #fences==6 and #area:GetChildren()==30)
for i,a in ipairs(fences) do for j=i+1,#fences do
 local ac,as=a:GetBoundingBox(); local bc,bs=fences[j]:GetBoundingBox()
 assert((ac.Position-bc.Position).Magnitude>math.max(as.X,as.Z)/2+math.max(bs.X,bs.Z)/2,'Central fences overlap')
end end
assert(R.ShinyChance('Normal',false)==.01 and R.ShinyChance('Normal',true)==.02)
assert(R.ShinyChance('Perk',false)==.1 and R.ShinyChance('Perk',true)==.2)
for _,luck in ipairs({false,true}) do
 local d=R.New(0); local rng={NextNumber=function() return .015 end}
 assert(R.Buy(d,1,rng,luck,false))
 assert((d.Pets['1s'] or 0)==(luck and 1 or 0),'Displayed probability differs from purchase roll')
end
folder:Destroy()
print('[PromenadeV161] PASS: 24 lamps face paths, 6 nonoverlapping plaza fences, no path fences, idempotent props, matching shiny purchase/crate probabilities')
