-- Edit-mode utility after importing "Sakura Tree" by plentune as Workspace.Tree.
local island=workspace.DessertJellyIsland
assert(not island:FindFirstChild("SakuraGarden"),"Sakura garden already placed")
local tree=workspace:FindFirstChild("Tree") or game.ServerStorage:FindFirstChild("FreeSakuraTemplate")
assert(tree and tree:IsA("Model"),"Import Sakura Tree first")
for _,v in ipairs(tree:GetDescendants()) do
	assert(not v:IsA("LuaSourceContainer"),"Unexpected script in Sakura Tree")
	if v:IsA("BasePart") then v.Anchored=true; v.CanCollide=false; v.CanTouch=false end
end
tree.Name="FreeSakuraTemplate"
tree:SetAttribute("Creator","plentune")
tree:SetAttribute("SourceTitle","Sakura Tree")
tree.Parent=game.ServerStorage
local garden=Instance.new("Model")
garden.Name="SakuraGarden"
garden.Parent=island
for i=1,12 do
	local a=(i-0.5)*math.pi/6
	local m=tree:Clone()
	m.Name="Sakura"..i
	m.Parent=garden
	local size=m:GetExtentsSize()
	m:ScaleTo(m:GetScale()*18/math.max(size.X,size.Y,size.Z))
	m:PivotTo(CFrame.new(math.sin(a)*157,0,math.cos(a)*157)*CFrame.Angles(0,a,0))
	local box,bounds=m:GetBoundingBox()
	m:PivotTo(m:GetPivot()+Vector3.new(0,0.05-(box.Position.Y-bounds.Y/2),0))
end
print("[FreeSakura] Twelve free blossom trees placed; no embedded scripts")
