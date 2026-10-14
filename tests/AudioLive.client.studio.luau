-- Client Command Bar in Studio Play. Restore the starting settings afterward.
local action=game.ReplicatedStorage.DessertRemotes.Action
local sounds=game:GetService("SoundService")
local original=action:InvokeServer("State").Settings
assert(action:InvokeServer("Settings",{MusicVolume=.2,EffectsVolume=.8}))
task.wait(.6)
assert(math.abs(sounds.DessertCafeMusic.Volume-.06)<1e-6)
assert(math.abs(sounds.DessertClick.Volume-.48)<1e-6 and sounds.DessertDiscovery.Volume==sounds.DessertClick.Volume)
assert(action:InvokeServer("Settings",{MusicVolume=0,EffectsVolume=0}))
task.wait(.6)
assert(sounds.DessertCafeMusic.Volume==0 and not sounds.DessertCafeMusic.Playing and sounds.DessertClick.Volume==0)
assert(action:InvokeServer("Settings",{MusicVolume=.4,EffectsVolume=.5}))
local deadline=os.clock()+20
repeat task.wait(.2) until sounds.DessertCafeMusic.IsLoaded or os.clock()>deadline
assert(sounds.DessertCafeMusic.IsLoaded and sounds.DessertCafeMusic.TimeLength>0,"Approved music must load")
assert(sounds.DessertCafeMusic.Playing and sounds.DessertCafeMusic.Looped)
assert(sounds.DessertCafeMusic.SoundId=="rbxassetid://73635875504187")
task.wait(.5); assert(action:InvokeServer("Settings",original))
print("[AudioLive] PASS: independent actual sound levels, mute/resume, music loaded/playing/looped, settings restored")
