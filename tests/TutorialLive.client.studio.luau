assert(game:GetService("RunService"):IsStudio())
local player=game.Players.LocalPlayer
local screen=player.PlayerGui:WaitForChild("DessertHUD",40)
local event=game.ReplicatedStorage:WaitForChild("DessertRemotes").Event
local pickups=0;event.OnClientEvent:Connect(function(kind) if kind=="Pickup" then pickups+=1 end end)
local deadline=os.clock()+200
repeat task.wait(.2) until screen:GetAttribute("TutorialStep")==1 or os.clock()>deadline
assert(workspace:FindFirstChild("DessertTutorialArrows"),"Local floor arrows exist")
task.wait(2)
local target=screen:FindFirstChild("TutorialTarget");assert(target and target.Enabled and target.Adornee.Name=="Collector","First target collector")
local sound=game:GetService("SoundService"):WaitForChild("DessertPickup")
repeat task.wait(.3) until screen:GetAttribute("TutorialStep")==10 or os.clock()>deadline
assert(screen:GetAttribute("TutorialStep")==10 and pickups>0,"Full tutorial collected real minis")
assert(sound.IsLoaded and sound.Volume>0,"Pickup sound loaded and audible")
assert(screen.TutorialMenuArrow.Visible,"Index arrow visible")
print("TUTORIAL_CLIENT_WAIT_EQUIP",pickups,sound.SoundId,sound.Volume)
task.wait(15)
local action=game.ReplicatedStorage.DessertRemotes.Action
assert(action:InvokeServer("Equip","1n"))
task.wait(1)
assert(screen:GetAttribute("TutorialStep")==11 and not workspace:FindFirstChild("DessertTutorialArrows"),"Completed guidance cleaned up")
assert(action:InvokeServer("Settings",{EffectsVolume=0}));task.wait(.5);assert(sound.Volume==0,"Pickup respects mute")
assert(action:InvokeServer("Settings",{EffectsVolume=.5}));task.wait(.5);assert(math.abs(sound.Volume-.225)<1e-6,"Pickup respects restored effects volume")
print("[TutorialLive] PASS: real pickups/sound, arrows, cafe/bank, two purchases, merge, equip, cleanup, mute")
