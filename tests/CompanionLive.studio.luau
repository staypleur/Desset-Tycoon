-- Temporary server test, run only in Studio Play; does not save or grant purchases.
local Players=game:GetService("Players")
local p=Players:GetPlayers()[1] or Players.PlayerAdded:Wait()
local api=game.ServerScriptService.DessertGame:WaitForChild("StudioDessertAction",30)
local snapshot
repeat task.wait(.25); snapshot=api:Invoke(p,"State") until snapshot
assert(api:Invoke(p,"Equip","1n"))
assert(api:Invoke(p,"State").Equipped=="1n")
local count=0
for _,m in ipairs(workspace:GetChildren()) do if m.Name=="DessertCompanion" and m:GetAttribute("OwnerUserId")==p.UserId then count+=1 end end
assert(count==1,"Equip must create exactly one companion")
assert(api:Invoke(p,"Equip","1n"))
local after=api:Invoke(p,"State"); assert(after.Equipped==nil and after.Active==snapshot.Active)
for _,m in ipairs(workspace:GetChildren()) do assert(m.Name~="DessertCompanion" or m:GetAttribute("OwnerUserId")~=p.UserId,"Unequip must destroy the companion") end
assert(after.CafeUpgradeCost==20 and after.CafeRate==1)
print("[CompanionLive] PASS: real server equip, repeated-click unequip, model cleanup, producer preservation and new initial upgrade cost")
