-- Play client, actual freshly produced drops and synchronized producer hops.
local player=game.Players.LocalPlayer
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local producer=plot.ActiveDesserts:WaitForChild("Dessert1")
local root=player.Character.HumanoidRootPart
-- Empty the settled pile through normal owner pickup so the drop cap cannot mask a spawn.
root.CFrame=plot:GetPivot()*CFrame.new(0,2,-11);task.wait(.6)
root.CFrame=plot:GetPivot()*CFrame.new(25,5,-15)
local before=producer:GetAttribute("LastProductionTime")
local deadline=os.clock()+5
repeat task.wait(.02) until producer:GetAttribute("LastProductionTime")~=before or os.clock()>deadline
assert(producer:GetAttribute("LastProductionTime")~=before,"A production cycle must occur")
task.wait(.03)
local drop
for _,m in ipairs(plot.MovingDesserts:GetChildren()) do
 if not drop or m:GetAttribute("DropStartTime")>drop:GetAttribute("DropStartTime") then drop=m end
end
assert(drop)
assert(drop:GetAttribute("DropStartTime")>=producer:GetAttribute("LastProductionTime")-.1,"Fresh drop required")
assert(drop:GetAttribute("PhysicalDrop"))
assert(drop.PrimaryPart.Name=="DropCollider" and drop.PrimaryPart.CanCollide and not drop.PrimaryPart.Anchored)
local base=producer:GetAttribute("DisplayBasePivot")
local samples,changed,maxHop=0,0,0
local visual
for _,v in ipairs(workspace.ClientDropVisuals:GetChildren()) do if v:GetAttribute("SourceDrop")==drop:GetAttribute("DropStartTime") then visual=v end end
assert(visual,"Client interpolation visual")
local last=visual:GetPivot().Position
local run=game:GetService("RunService")
local connection=run.RenderStepped:Connect(function()
 if not drop.Parent then return end
 local cf=visual:GetPivot()
 local moved=(cf.Position-last).Magnitude
 -- Initial replication can leave a new body still briefly; measure frames after motion begins.
 if moved>.0001 or changed>0 then samples+=1;if moved>.0001 then changed+=1 end end
 maxHop=math.max(maxHop,producer:GetPivot().Position.Y-base.Position.Y)
 last=cf.Position
end)
task.wait(.65);connection:Disconnect()
assert(samples>10 and changed/samples>.8,"Replicated physics must move smoothly")
assert(maxHop>.1 and maxHop<=.351,"Small production-synchronized hop")
assert((producer:GetPivot().Position-base.Position).Magnitude<.001,"Hop returns to its plate")
print("[ProductionMotion] PASS: physical drop moving frames",changed,"/",samples,"production hop",maxHop,"returns to plate")
