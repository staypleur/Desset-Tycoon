-- Verified free Creator Store models; editor-only GetObjects import. No runtime downloads.
assert(not game:GetService("RunService"):IsRunning(),"Stop Play first")
local folder=game.ServerStorage:FindFirstChild("FreeEnvironmentAssets") or Instance.new("Folder")
assert(not folder:FindFirstChild("NaturePack"),"Environment assets already imported")
folder.Name,folder.Parent="FreeEnvironmentAssets",game.ServerStorage
local specs={{14299404156,"NaturePack","Low Poly Asset Pack [Grass Biome] V 1.0","Bolt_Confirmed"},{186713502,"CafeSeating","Cafe Table & Chairs","Elliott_RBLX"},{11146095708,"StreetLamp","Street Lamp","BryanROBLOXgamer10"},{5360143567,"DisplayCase","Display Case","QuetzalCoatlus8431"},{18723685255,"MeadowPack","Low Poly Asset Pack","Yoopyhoop"}}
local preview=Instance.new("Model"); preview.Name,preview.Parent="AssetPreview",workspace
for i,s in ipairs(specs) do
 local ok,result=pcall(function() return game:GetObjects("rbxassetid://"..s[1]) end)
 if ok then
  local template=Instance.new("Model"); template.Name=s[2]
  local removed,parts=0,0
  for _,obj in ipairs(result) do
   for _,d in ipairs(obj:GetDescendants()) do
    if d:IsA("LuaSourceContainer") or d:IsA("PackageLink") then d:Destroy(); removed+=1
    elseif d:IsA("BasePart") then d.Anchored=true; d.CanCollide=false; d.CanTouch=false; parts+=1 end
   end
   obj.Parent=template
  end
  template:SetAttribute("AssetId",s[1]); template:SetAttribute("SourceTitle",s[3]); template:SetAttribute("Creator",s[4]); template:SetAttribute("RemovedScriptsOrLinks",removed)
  template.Parent=folder
  local copy=template:Clone(); copy.Parent=preview
  local box,size=copy:GetBoundingBox(); local scale=20/math.max(size.X,size.Y,size.Z)
  copy:ScaleTo(copy:GetScale()*scale); box,size=copy:GetBoundingBox()
  copy:PivotTo(CFrame.new(-500+(i-1)*30,size.Y/2,0)*box:ToObjectSpace(copy:GetPivot()))
  print("[AssetImport]",s[2],parts,removed)
  for _,obj in ipairs(template:GetChildren()) do print("[AssetContents]",s[2],obj.Name,obj.ClassName) end
 else warn("[AssetImport] Failed",s[2],tostring(result)) end
end
workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(-455,55,100),Vector3.new(-455,5,0))
