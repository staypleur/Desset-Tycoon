-- Build a small static navigation graph from the actual cafe props, including non-queryable decor.
local Nav={Step=2,Radius=20}
local function key(x,z) return x..":"..z end
function Nav.Build(cafe,chef)
 local floor=cafe.CafeArchitecture.CafeFloor
 local center=Vector3.new(floor.Position.X,floor.Position.Y+floor.Size.X/2,floor.Position.Z)
 local size=chef.PrimaryPart.Size
 local clearance=math.max(size.X,size.Z)/2+.2
 local obstacles={}
 for _,p in ipairs(cafe:GetDescendants()) do
  if p:IsA("BasePart") and not p:IsDescendantOf(chef) and p~=floor and p.Name~="CafeInteriorBarrier" then
   local lo,hi=Vector3.new(math.huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-math.huge)
   for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
    local v=p.CFrame:PointToWorldSpace(p.Size*Vector3.new(x,y,z)/2)
    lo=Vector3.new(math.min(lo.X,v.X),math.min(lo.Y,v.Y),math.min(lo.Z,v.Z))
    hi=Vector3.new(math.max(hi.X,v.X),math.max(hi.Y,v.Y),math.max(hi.Z,v.Z))
   end end end
   if hi.Y>center.Y+.3 and lo.Y<center.Y+size.Y and lo.X<center.X+23 and hi.X>center.X-23 and lo.Z<center.Z+23 and hi.Z>center.Z-23 then
    table.insert(obstacles,{Min=lo,Max=hi})
   end
  end
 end
 local graph={Nodes={},Center=center,Obstacles=obstacles}
 function graph.Clear(pos)
  if Vector3.new(pos.X-center.X,0,pos.Z-center.Z).Magnitude>Nav.Radius then return false end
  for _,o in ipairs(obstacles) do
   if pos.X>o.Min.X-clearance and pos.X<o.Max.X+clearance and pos.Z>o.Min.Z-clearance and pos.Z<o.Max.Z+clearance then return false end
  end
  return true
 end
 function graph.Segment(a,b)
  local steps=math.max(1,math.ceil((b-a).Magnitude/.4))
  for i=0,steps do if not graph.Clear(a:Lerp(b,i/steps)) then return false end end
  return true
 end
 for x=-10,10 do for z=-10,10 do
  local pos=center+Vector3.new(x*Nav.Step,0,z*Nav.Step)
  if graph.Clear(pos) then graph.Nodes[key(x,z)]={X=x,Z=z,Position=pos,Neighbors={}} end
 end end
 for _,n in pairs(graph.Nodes) do
  for _,d in ipairs({{1,0},{-1,0},{0,1},{0,-1}}) do
   local other=graph.Nodes[key(n.X+d[1],n.Z+d[2])]
   if other and graph.Segment(n.Position,other.Position) then table.insert(n.Neighbors,other) end
  end
 end
 -- Keep one connected area so every chosen destination is reachable.
 local seen,largest={},{}
 for _,start in pairs(graph.Nodes) do if not seen[start] then
  local queue={start};seen[start]=true;local i=1
  while i<=#queue do for _,next in ipairs(queue[i].Neighbors) do if not seen[next] then seen[next]=true;table.insert(queue,next) end end;i+=1 end
  if #queue>#largest then largest=queue end
 end end
 graph.Points=largest
 return graph
end
function Nav.Route(start,finish)
 local queue={start};local parent={[start]=start};local i=1
 while i<=#queue and not parent[finish] do
  for _,n in ipairs(queue[i].Neighbors) do if not parent[n] then parent[n]=queue[i];table.insert(queue,n) end end
  i+=1
 end
 if not parent[finish] then return {} end
 local path={};local n=finish
 while n~=start do table.insert(path,1,n);n=parent[n] end
 return path
end
return Nav
