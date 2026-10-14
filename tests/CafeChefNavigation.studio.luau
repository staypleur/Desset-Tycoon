-- Edit mode: validate routes against the actual non-colliding decorative parts.
local nav=game.ReplicatedStorage.CafeChefNavigation:Clone();nav.Parent=game.ReplicatedStorage
local N=require(nav)
local cafe=workspace.DessertJellyIsland.CentralHub.CentralShop
local graph=N.Build(cafe,cafe.CafeChef)
assert(#graph.Points>20)
for _,node in ipairs(graph.Points) do
 assert(graph.Clear(node.Position))
 for _,next in ipairs(node.Neighbors) do assert(graph.Segment(node.Position,next.Position)) end
end
local rng=Random.new(72)
for _=1,40 do
 local start=graph.Points[rng:NextInteger(1,#graph.Points)]
 local finish=graph.Points[rng:NextInteger(1,#graph.Points)]
 local path=N.Route(start,finish)
 assert(start==finish or #path>0,"Connected graph must reach destination")
 local previous=start
 for _,node in ipairs(path) do assert(graph.Segment(previous.Position,node.Position));previous=node end
 assert(previous==finish)
end
assert(not graph.Clear(graph.Center+Vector3.new(21,0,0)),"Cannot leave cafe")
nav:Destroy()
print("[CafeChefNavigation] PASS: all graph edges clear, 40 routes avoid actual props, cafe boundary respected")
