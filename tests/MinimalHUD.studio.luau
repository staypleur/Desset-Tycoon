-- Run in the actual Play client Command Bar.
local p=game.Players.LocalPlayer; local hud=p.PlayerGui.DessertHUD
local plate=hud:FindFirstChild('MiniDessertPlate',true)
assert(plate and plate.Image=='rbxassetid://73464157423623')
for _=1,10 do if plate.IsLoaded then break end; task.wait(1) end
assert(plate.IsLoaded,'Plate image did not render')
assert(plate.BagValue.Text:match('^[%d%.e%+KMB]+$'))
for _,t in ipairs(hud:GetDescendants()) do if t:IsA('TextLabel') or t:IsA('TextButton') then
 assert(t.Text~='Dessert Island' and t.Text~='Crates' and not t.Text:find('Cafe Queue') and not t.Text:find('CAFE SALE RATE') and not t.Text:find('Changes in'))
end end
assert(p.PlayerGui.DessertTopbar.SettingsButton:IsA('ImageButton'))
local gauge=hud:FindFirstChild('CircularSaleGauge',true); assert(gauge and gauge.Multiplier.Text:match('^[01]%.%dx$'))
local start=gauge:GetAttribute('Progress'); task.wait(1)
local finish=gauge:GetAttribute('Progress'); assert(finish~=start)
local plot=workspace.DessertJellyIsland.PlayerPlots[p:GetAttribute('PlotName')]
local front=plot.PersonalShopArea.OwnerBoard:FindFirstChild('FrontOwner',true)
assert(front.OwnerName.Text==p.Name)
print('[MinimalHUDTest] PASS: rendered plate, number only, removed labels, settings gear, moving ring and owner name')
