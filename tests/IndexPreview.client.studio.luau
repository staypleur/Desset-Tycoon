-- Open Index before running. Verify actual layout and fixed-facing bob animation.
local hud=game.Players.LocalPlayer.PlayerGui.DessertHUD
local title,view
for _,v in ipairs(hud:GetDescendants()) do
	if v:IsA("TextLabel") and v.Text=="Index" and v.Parent:IsA("Frame") and v.Size.Y.Offset==54 then title=v end
	if v:IsA("ViewportFrame") then view=v end
end
assert(title and title.Visible and view)
assert(math.abs(title.AbsolutePosition.X+title.AbsoluteSize.X/2-(title.Parent.AbsolutePosition.X+title.Parent.AbsoluteSize.X/2))<1,"Centered title")
assert(view.Size.Y.Offset==126,"Larger model area")
local model=view:FindFirstChildOfClass("WorldModel"):FindFirstChildOfClass("Model")
local initial=model:GetPivot();local minY,maxY=initial.Y,initial.Y
for _=1,60 do
	game:GetService("RunService").RenderStepped:Wait()
	local cf=model:GetPivot();minY=math.min(minY,cf.Y);maxY=math.max(maxY,cf.Y)
	assert(cf.LookVector:Dot(initial.LookVector)>.9999 and cf.UpVector:Dot(initial.UpVector)>.9999,"Fixed facing")
end
assert(maxY-minY>.1 and maxY-minY<.401,"Gentle floating motion")
print("[IndexPreview] PASS: centered title, enlarged preview, fixed facing and floating",maxY-minY)
