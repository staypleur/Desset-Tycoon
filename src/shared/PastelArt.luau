-- Approved ToffeeCraft Pastel Dream FREE atlas. No imported executable code.
local Art={}
local Config=require(script.Parent.TycoonConfig)
local rects={Panel={111,8,59,83},Card={178,8,48,51},Button={182,223,53,16}}
function Art.Image(parent,key,size,pos)
 local r=assert(rects[key]); local clip=Instance.new('Frame')
 clip.Name='Pastel'..key; clip.BackgroundTransparency=1; clip.ClipsDescendants=true
 clip.Size=size or UDim2.fromScale(1,1); clip.Position=pos or UDim2.new(); clip.ZIndex=parent.ZIndex; clip.Parent=parent
 local image=Instance.new('ImageLabel'); image.Name='Atlas'; image.BackgroundTransparency=1
 image.Image=Config.PastelAtlasId; image.ResampleMode=Enum.ResamplerMode.Pixelated
 image.Size=UDim2.fromScale(256/r[3],300/r[4]); image.Position=UDim2.fromScale(-r[1]/r[3],-r[2]/r[4]); image.ZIndex=clip.ZIndex; image.Parent=clip
 return clip
end
function Art.Apply(parent,key)
 parent.BackgroundTransparency=1; parent.BorderSizePixel=0
 for _,child in ipairs(parent:GetChildren()) do
  if child.Name=='HapyArtwork' or child.Name=='PastelPanel' or child.Name=='PastelCard' or child.Name=='PastelButton' then child:Destroy() end
  if child:IsA('UIStroke') then child.Enabled=false end
 end
 local art=Art.Image(parent,key)
 if parent:IsA('TextButton') then
  parent.TextTransparency=1
  local label=Instance.new('TextLabel'); label.Name='PastelText'; label.BackgroundTransparency=1
  label.Size=UDim2.new(1,-16,1,-4); label.Position=UDim2.fromOffset(8,2); label.ZIndex=parent.ZIndex+2; label.Parent=parent
  local function sync()
   label.Text=parent.Text; label.Font=parent.Font; label.TextSize=parent.TextSize
   label.TextColor3=parent.TextColor3; label.TextWrapped=true
  end
  sync()
  for _,p in ipairs({'Text','Font','TextSize','TextColor3'}) do parent:GetPropertyChangedSignal(p):Connect(sync) end
 end
 return art
end
return Art
