local source=game.ReplicatedStorage.ProductionPlot:Clone();source.Parent=game.ReplicatedStorage
local Layout=require(source)
for _,plot in ipairs(workspace.DessertJellyIsland.PlayerPlots:GetChildren()) do
 local original={};for _,pad in ipairs(plot.PetSpawnPads:GetChildren()) do original[pad]=pad.CFrame end
 Layout.ReorderSlots(plot);Layout.ReorderSlots(plot)
 for slot=1,60 do
  local pad=assert(plot.PetSpawnPads:FindFirstChild("PetPad"..slot))
  assert(pad:GetAttribute("Row")==math.floor((slot-1)/12)+1)
  assert(pad:GetAttribute("Column")==((slot-1)%6)+1)
  assert(pad:GetAttribute("Side")==((slot-1)%12<6 and "Left" or "Right"))
  assert(pad.CFrame:FuzzyEq(original[pad]),"Only fill order changes; lanes and plates stay in place")
 end
end
source:Destroy()
print("[AlternatingRows] PASS: all 360 plates alternate sides per row; idempotent, positions preserved")
