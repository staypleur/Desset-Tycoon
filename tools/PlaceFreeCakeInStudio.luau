-- One-time edit-mode utility. Select imported Heart Cake (Taiyon) first.
local selection=game:GetService("Selection"):Get()
assert(#selection==1,"Select the imported Heart Cake")
local imported=selection[1]
assert(imported:IsA("Model") or imported:IsA("BasePart"),"Expected a cake model/mesh")
for _,v in ipairs(imported:GetDescendants()) do
	assert(not v:IsA("LuaSourceContainer"),"Unexpected script in cake")
end
local tree
if imported:IsA("Model") then tree=imported else
	tree=Instance.new("Model")
	imported.Parent=tree
end
tree.Name="FreeHeartCakeTemplate"
tree:SetAttribute("Creator","Taiyon")
tree:SetAttribute("SourceTitle","Heart Cake")
tree.Parent=game.ServerStorage
for _,p in ipairs(tree:GetDescendants()) do
	if p:IsA("BasePart") then p.Anchored=true; p.CanCollide=false; p.CanTouch=false end
end
local island=workspace.DessertJellyIsland
assert(not island:FindFirstChild("CakeDisplays"),"Cake displays already placed")
local displays=Instance.new("Model")
displays.Name="CakeDisplays"
displays.Parent=island
local function place(parent,pos,color)
	local pedestal=Instance.new("Part")
	pedestal.Name="CakePedestal"
	pedestal.Size=Vector3.new(5,2,5)
	pedestal.Position=pos+Vector3.new(0,1,0)
	pedestal.Color=color
	pedestal.Material=Enum.Material.SmoothPlastic
	pedestal.Anchored=true
	pedestal.CanCollide=false
	pedestal.CanTouch=false
	pedestal.Parent=parent
	local cake=tree:Clone()
	cake.Name="HeartCakeDisplay"
	cake.Parent=parent
	local s=cake:GetExtentsSize()
	cake:ScaleTo(cake:GetScale()*4/math.max(s.X,s.Y,s.Z))
	cake:PivotTo(CFrame.new(pos))
	local box,bounds=cake:GetBoundingBox()
	cake:PivotTo(cake:GetPivot()+Vector3.new(0,pos.Y+2-(box.Position.Y-bounds.Y/2),0))
end
for _,x in ipairs({-16,16}) do place(displays,Vector3.new(x,0.75,-8),Color3.fromRGB(255,193,218)) end
for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
	place(plot.GardenDecor,(plot:GetPivot()*CFrame.new(25,0.15,25)).Position,plot.PastelBoundary.Color)
end
game:GetService("Selection"):Set({})
workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(140,165,210),Vector3.zero)
print("[FreeCake] Eight decorative Heart Cake displays added; no embedded scripts")
