-- Read-only regression checks for the saved entrance-cafe layout, in edit mode.
local island = workspace.DessertJellyIsland
local central = island.CentralHub.CentralShop
assert(#central:GetDescendants() == 1 and central.CenterAnchor.Transparency == 1, "Center must remain empty")
assert(#island.CentralHub.CentralDisplay:GetChildren() == 0, "Reserved display must be empty")
local centralNames = 0
for _, p in ipairs(workspace:GetDescendants()) do
	if p:IsA("Model") and p.Name == "CentralShop" then centralNames += 1 end
end
assert(centralNames == 1, "Allocator center must be unique")
for i = 1, 6 do
	local plot = island.PlayerPlots["Plot" .. i]
	local cf, cafe = plot:GetPivot(), plot.PersonalShopArea.DessertCafe
	local front = cf:VectorToObjectSpace(cafe.CafeBuilding.BackWall.CFrame.ZVector)
	assert(front.Z > .99, "Cafe must face into the plot")
	assert(cf:PointToObjectSpace(cafe.CafeBuilding.ShopFloor.Position).Z < -15, "Cafe must be at entrance")
	assert(cafe:FindFirstChild("GiantPudding"), "Original pudding decoration required")
	assert(plot:FindFirstChild("OwnerLabel", true), "Owner display missing")
	assert(#plot.PetSpawnPads:GetChildren() == 30, "Thirty positions required")
	local pads = {plot.MergeBoard, plot.PlotSpawn, plot.PersonalShopArea.CollectIncome, plot.PersonalShopArea.DessertCrate, plot.GardenDecor.CakePedestal}
	for _, count in ipairs({1, 5, 25, 100}) do table.insert(pads, plot.PurchaseButtons["Buy" .. count]) end
	for a, p in ipairs(pads) do
		local pos = cf:PointToObjectSpace(p.Position)
		assert(math.abs(pos.X) + p.Size.X / 2 <= 34.01, "Pad outside plot")
		assert(pos.Z + p.Size.Z / 2 < 0 and pos.Z - p.Size.Z / 2 >= -34.01, "Service pads must stay near cafe")
		for b = a + 1, #pads do
			local other = pads[b]
			local q = cf:PointToObjectSpace(other.Position)
			assert(math.abs(pos.X - q.X) >= (p.Size.X + other.Size.X) / 2 - .01 or math.abs(pos.Z - q.Z) >= (p.Size.Z + other.Size.Z) / 2 - .01, "Overlapping pads: " .. p.Name .. "/" .. other.Name)
		end
	end
end
print("[EntranceCafeCheck] PASS: empty center, unique origin, six inward-facing pudding cafes, 180 slots, no overlapping service pads")
