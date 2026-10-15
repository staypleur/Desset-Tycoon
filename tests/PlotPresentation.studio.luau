local style=game.ReplicatedStorage.ReferenceStyle:Clone();style.Parent=game.ReplicatedStorage
local S=require(style);local island=workspace.DessertJellyIsland
S.RefinePlots(island);S.RefinePlots(island)
local function rect(model,cf)
 local lo,hi=Vector3.new(math.huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-math.huge)
 for _,p in ipairs(model:GetDescendants()) do if p:IsA("BasePart") then
  for _,x in ipairs({-1,1}) do for _,y in ipairs({-1,1}) do for _,z in ipairs({-1,1}) do
   local v=cf:PointToObjectSpace(p.CFrame:PointToWorldSpace(p.Size*Vector3.new(x,y,z)/2));lo=lo:Min(v);hi=hi:Max(v)
  end end end
 end end
 return lo,hi
end
local tables=0
for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
 local cf=plot:GetPivot()
 for _,ground in ipairs(plot.ProductionBeds:GetChildren()) do if ground.Name=="RaisedFieldGround" then assert(ground.Size.X==51.5,"Filler side inset from shelf") end end
 for _,seat in ipairs(plot.CafeGardenDecor:GetChildren()) do if seat.Name=="CafeTableAndChairs" then
  tables+=1;local lo,hi=rect(seat,cf)
  for _,p in ipairs(plot:GetDescendants()) do if p:IsA("BasePart") and (p:FindFirstChild("ButtonTop") or p.Name=="RobuxShop") then
   local pos=cf:PointToObjectSpace(p.Position)
   assert(hi.X+2<pos.X-p.Size.X/2 or lo.X-2>pos.X+p.Size.X/2 or hi.Z+2<pos.Z-p.Size.Z/2 or lo.Z-2>pos.Z+p.Size.Z/2,"Furniture blocks "..p:GetFullName())
  end end
 end end
end
assert(tables==12);style:Destroy()
print("[PlotPresentation] PASS: 12 furniture sets, six plots, 2-stud pad clearance, inset filler faces, idempotent")
