-- Uses Roblox's built-in free RadialFill.png and official two-half gradient mask.
-- Source: https://create.roblox.com/docs/reference/engine/enums/ProximityPromptStyle
local Gauge={}
local texture='rbxasset://textures/ui/Controls/RadialFill.png'
local rainbow=ColorSequence.new({
 ColorSequenceKeypoint.new(0,Color3.fromRGB(255,137,186)),
 ColorSequenceKeypoint.new(.2,Color3.fromRGB(255,195,181)),
 ColorSequenceKeypoint.new(.4,Color3.fromRGB(255,225,177)),
 ColorSequenceKeypoint.new(.6,Color3.fromRGB(182,231,213)),
 ColorSequenceKeypoint.new(.8,Color3.fromRGB(197,177,241)),
 ColorSequenceKeypoint.new(1,Color3.fromRGB(255,137,186))})
local function image(parent)
 local p=Instance.new('ImageLabel'); p.BackgroundTransparency=1; p.Image=texture; p.Size=UDim2.fromScale(1,1); p.Parent=parent; return p
end
function Gauge.Create(parent)
 local root=Instance.new('Frame'); root.Name='CircularSaleGauge'; root.Size=UDim2.fromScale(1,1); root.BackgroundTransparency=1; root.Parent=parent
 local track=image(root); track.Name='Track'; track.ImageColor3=Color3.fromRGB(253,218,235); track.ImageTransparency=.55
 local halves,gradients={},{}
 for n=1,2 do
  local f=Instance.new('Frame'); f.Name=n==1 and 'LeftArc' or 'RightArc'; f.BackgroundTransparency=1; f.ClipsDescendants=true
  f.Size=UDim2.fromScale(.5,1); f.Position=UDim2.fromScale(n==1 and 0 or .5,0); f.Parent=root
  local p=image(f); p.Size=UDim2.fromScale(2,1); p.Position=UDim2.fromScale(n==1 and 0 or -1,0)
  local gradient=Instance.new('UIGradient'); gradient.Color=rainbow
  gradient.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.51,1),NumberSequenceKeypoint.new(1,1)})
  gradient.Parent=p; halves[n]=f; gradients[n]=gradient
 end
 local label=Instance.new('TextLabel'); label.Name='Multiplier'; label.BackgroundTransparency=1
 label.Size=UDim2.fromScale(.76,.48); label.Position=UDim2.fromScale(.12,.26); label.Font=Enum.Font.GothamBlack; label.TextScaled=true
 label.TextColor3=Color3.fromRGB(103,58,87); label.Text='1.0x'; label.Parent=root
 local outline=Instance.new('UIStroke'); outline.Color=Color3.fromRGB(255,250,246); outline.Thickness=2; outline.Parent=label
 local limit=Instance.new('UITextSizeConstraint'); limit.MaxTextSize=32; limit.MinTextSize=12; limit.Parent=label
 local function cap()
  local c=Instance.new('Frame'); c.Size=UDim2.fromScale(.075,.075); c.AnchorPoint=Vector2.new(.5,.5); c.BackgroundColor3=Color3.fromRGB(255,137,186); c.BorderSizePixel=0; c.ZIndex=2; c.Parent=root
  local corner=Instance.new('UICorner'); corner.CornerRadius=UDim.new(1,0); corner.Parent=c; return c
 end
 local result={Root=root,Label=label,Halves=halves,Gradients=gradients,Start=cap(),Finish=cap()}
 result.Start.Position=UDim2.fromScale(.5,.055); Gauge.SetProgress(result,0); return result
end
function Gauge.SetProgress(g,progress)
 progress=math.clamp(progress,0,1); local angle=progress*360
 g.Halves[1].Visible=progress>.5; g.Halves[2].Visible=progress>.001
 g.Gradients[1].Rotation=math.clamp(angle,180,360); g.Gradients[2].Rotation=math.clamp(angle,0,180)
 g.Start.Visible=progress>0; g.Finish.Visible=progress>0 and progress<1
 g.Finish.Position=UDim2.fromScale(.5+math.sin(progress*math.pi*2)*.445,.5-math.cos(progress*math.pi*2)*.445)
 g.Root:SetAttribute('Progress',progress)
end
return Gauge
