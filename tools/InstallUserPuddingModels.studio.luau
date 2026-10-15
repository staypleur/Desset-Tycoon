-- Run in Studio edit mode after importing the two FBX meshes without materials.
assert(not game:GetService("RunService"):IsRunning(),"Edit mode required")
local RS=game:GetService("ReplicatedStorage")
local folder=RS:FindFirstChild("DessertModelTemplates") or Instance.new("Folder")
folder.Name="DessertModelTemplates"; folder.Parent=RS
local specs={
 {Source="pudding-import",Name="NormalPudding",Height=2.5,Decal=112799935838007,Triangles=2914},
 {Source="mini-import",Name="MiniPudding",Height=18/28,Decal=128560628779702,Triangles=314},
}
for _,spec in ipairs(specs) do
 local source=workspace:FindFirstChild(spec.Source)
 assert(source,"Import "..spec.Source..".fbx first")
 local parts={}
 for _,part in ipairs(source:GetDescendants()) do
  assert(not part:IsA("LuaSourceContainer") and not part:IsA("PackageLink"),"Foreign code")
  if part:IsA("BasePart") then table.insert(parts,part) end
 end
 assert(#parts==1 and parts[1]:IsA("MeshPart"),"One static mesh required")
 local decal=game:GetObjects("rbxassetid://"..spec.Decal)[1]
 assert(decal and decal:IsA("Decal") and decal.Texture~="","Color map unavailable")
 local texture=decal.Texture; decal:Destroy()
 local m=Instance.new("Model"); m.Name=spec.Name
 local mesh=parts[1]:Clone();mesh.Name="PuddingMesh"
 mesh:ClearAllChildren();mesh.Size*=spec.Height/mesh.Size.Y
 mesh.CFrame=CFrame.new(0,mesh.Size.Y/2,0)
 mesh.PivotOffset=CFrame.new(0,-mesh.Size.Y/2,0)
 mesh.TextureID=texture;mesh.Color=Color3.new(1,1,1)
 mesh.Material=Enum.Material.SmoothPlastic
 mesh.Anchored=true;mesh.CanCollide=false;mesh.CanTouch=false;mesh.CanQuery=false;mesh.CastShadow=false
 mesh.RenderFidelity=Enum.RenderFidelity.Automatic;mesh.Parent=m;m.PrimaryPart=mesh
 m:SetAttribute("UserModel",spec.Name);m:SetAttribute("SourceTriangles",spec.Triangles)
 m:SetAttribute("HeightCm",spec.Height*28);m:SetAttribute("ColorDecalId",spec.Decal)
 local previous=folder:FindFirstChild(spec.Name)
 assert(not previous,"Template already exists; inspect before replacing")
 m.Parent=folder
 -- Archive the imported original for further editing without leaving a floating prop.
 local originals=game.ServerStorage:FindFirstChild("UserPuddingOriginals") or Instance.new("Folder")
 originals.Name="UserPuddingOriginals";originals.Parent=game.ServerStorage;source.Parent=originals
 print("[PuddingTemplate]",m.Name,mesh.MeshId,texture,mesh.Size,m:GetPivot())
end
