-- Client Command Bar during Play. Stand at the Sugar Shop first.
local player=game.Players.LocalPlayer
local plot=workspace.DessertJellyIsland.PlayerPlots["Plot"..player:GetAttribute("PlotId")]
local prompt=plot.PersonalShopArea.RobuxShop:FindFirstChildOfClass("ProximityPrompt")
prompt:InputHoldBegin(); task.wait(1); prompt:InputHoldEnd(); task.wait(.5)
assert(player.PlayerGui.DessertHUD:FindFirstChild("Panel",true).Visible,"Hold prompt must open store UI")
print("[ShopInteraction] PASS: native hold prompt opens Shop panel")
