-- Play client with a temporary Studio-only 10-token fixture. No real purchases.
local RS=game.ReplicatedStorage
local action=RS.DessertRemotes.Action;local events=RS.DessertRemotes.Event
local hud=game.Players.LocalPlayer.PlayerGui.DessertHUD
local before=action:InvokeServer("State");assert(before.NormalTokens==10)
local batch
local connection=events.OnClientEvent:Connect(function(kind,value) if kind=="Crates" then batch=value end end)
assert(not action:InvokeServer("Crate",{Kind="Normal",Count=0}))
task.wait(.25)
assert(not action:InvokeServer("Crate",{Kind="Normal",Count=11}))
task.wait(.25)
assert(action:InvokeServer("Crate",{Kind="Normal",Count=10}))
task.wait(.55)
local after=action:InvokeServer("State")
assert(after.NormalTokens==0 and after.Active==before.Active+10,"Grant exactly 10 logical desserts")
assert(not action:InvokeServer("Crate",{Kind="Normal",Count=10}),"Cannot replay spent credits")
task.wait(.55)
assert(action:InvokeServer("State").Active==after.Active)
while not batch do task.wait() end;connection:Disconnect()
assert(#batch.Results==10 and batch.KnownBefore["1n"] and batch.Highest==before.Highest)
local roulette;local readyBy=os.clock()+5
repeat roulette=hud:FindFirstChild("CrateRoulette",true);task.wait() until roulette or os.clock()>readyBy
assert(roulette)
local observed=0;local deadline=os.clock()+30
repeat
 local train=roulette:FindFirstChild("DessertTrain",true)
 if train then
  assert(not train:FindFirstChildWhichIsA("ViewportFrame",true),"Carousel uses 2D only")
  local stopped=roulette:GetAttribute("StoppedResultKey")
  local winner=train:FindFirstChild("ServerResult")
  if stopped and winner and winner:FindFirstChild("Frame") then
   local arrow=roulette:FindFirstChild("ResultArrow",true)
   local center=winner.AbsolutePosition.X+winner.AbsoluteSize.X/2
   assert(math.abs(center-(arrow.AbsolutePosition.X+arrow.AbsoluteSize.X/2))<1.1,"Exact server outcome centered under arrow")
   assert(stopped==winner:GetAttribute("DessertKey"));observed+=1
  end
 end
 task.wait(.03)
until roulette:FindFirstChild("CrateResults",true) or os.clock()>deadline
assert(roulette:FindFirstChild("CrateResults",true),"All 10 outcomes presented")
assert(observed>0,"Observe actual stopped cards")
print("[CrateRoulette] PASS: 10 server grants once, spent-credit replay rejected, exact arrow alignment, image-only animation",observed)
