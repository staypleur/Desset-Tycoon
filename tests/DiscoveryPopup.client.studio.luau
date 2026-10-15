-- Start in Play client, then trigger a discovery through the real server event.
local hud=game.Players.LocalPlayer.PlayerGui.DessertHUD
local deadline=os.clock()+60;local popup
repeat popup=hud:FindFirstChild("DessertDiscoveryPopup",true);task.wait() until popup or os.clock()>deadline
assert(popup,"Trigger a discovery within 60 seconds")
local view=assert(popup:FindFirstChildWhichIsA("ViewportFrame",true))
local world=view:FindFirstChildOfClass("WorldModel")
assert(world and #world:GetChildren()==1,"Exactly one 3D model in a discovery")
local model=world:GetChildren()[1];local original=model:GetPivot();local minY,maxY=original.Y,original.Y
local finish=os.clock()+1.4
repeat
 game:GetService("RunService").RenderStepped:Wait()
 local cf=model:GetPivot();minY=math.min(minY,cf.Y);maxY=math.max(maxY,cf.Y)
 assert(cf.LookVector:Dot(original.LookVector)>.99999 and cf.UpVector:Dot(original.UpVector)>.99999,"No spinning")
until os.clock()>finish
assert(maxY-minY>.08 and maxY-minY<.401,"Gentle floating")
local expires=os.clock()+5
repeat task.wait(.05) until not popup.Parent or os.clock()>expires
assert(not popup.Parent and not hud:FindFirstChildWhichIsA("ViewportFrame",true),"Destroy preview after closing")
print("[DiscoveryPopup] PASS: one 3D preview, fixed facing, floating, cleanup",maxY-minY)
