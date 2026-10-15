-- Open Index in Play before running. Index must never construct 3D previews.
local hud=game.Players.LocalPlayer.PlayerGui.DessertHUD
local panel=hud:FindFirstChild("Panel")
local title
for _,v in ipairs(panel:GetDescendants()) do
 if v:IsA("TextLabel") and v.Text=="Index" and v.Size.Y.Offset==54 then title=v end
 assert(not v:IsA("ViewportFrame") and not v:IsA("WorldModel"),"Index is entirely 2D")
end
assert(title and panel.Visible)
assert(math.abs(title.AbsolutePosition.X+title.AbsoluteSize.X/2-(panel.AbsolutePosition.X+panel.AbsoluteSize.X*28.5/59))<1,"Centered on the actual pink header artwork")
local content=panel:FindFirstChild("PanelContent")
assert(content and content.ClipsDescendants)
assert(content.AbsolutePosition.X>=panel.AbsolutePosition.X+panel.AbsoluteSize.X*5/59)
assert(content.AbsolutePosition.X+content.AbsoluteSize.X<=panel.AbsolutePosition.X+panel.AbsoluteSize.X*52/59)
for _,v in ipairs(content:GetDescendants()) do if v.Name=="MysteryMark" then assert(v.TextSize>=52); assert((v.AbsolutePosition+v.AbsoluteSize/2-(v.Parent.AbsolutePosition+v.Parent.AbsoluteSize/2)).Magnitude<1,"Mystery centered in card") end end
local images=0
for _,v in ipairs(panel:GetDescendants()) do
 if v.Name=="DessertImage" then assert(v:IsA("ImageLabel")); local bounds=v.Parent;assert(bounds.Name=="DessertImageBounds" and bounds.ClipsDescendants);assert(bounds.Position.X.Offset>=20 and bounds.Position.Y.Offset>=20);images+=1 end
end
assert(images>=1)
print("[IndexPreview] PASS: centered title, transparent 2D images, zero ViewportFrames/WorldModels",images)
