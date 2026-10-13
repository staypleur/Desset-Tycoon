-- Check imported decoration safety and clear gameplay surfaces on the saved place.
local island=workspace.DessertJellyIsland
assert(island:GetAttribute("LandscapeVersion")==1)
assert(#island.Landscape.PocketGardens:GetChildren()==6)
assert(not workspace:FindFirstChild("AssetPreview"),"Remove inspection models before saving")
assert(#island.CentralHub.CentralDisplay:GetChildren()==0,"Keep future center model space reserved")
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]; local decor=plot.CafeGardenDecor
	assert(plot.PlotFloor.Size==Vector3.new(96,1,120))
	local counts={}
	for _,m in ipairs(decor:GetChildren()) do counts[m.Name]=(counts[m.Name] or 0)+1 end
	assert(counts.CafeTableAndChairs==2 and counts.WarmCafeLamp==2 and counts.PastryDisplay==1)
	assert(counts.GrassTuft==8 and counts.FlowerBorder==6)
	for _,m in ipairs(decor:GetChildren()) do
		if m:GetAttribute("DecorationOnly") then
			for _,p in ipairs(m:GetDescendants()) do
				assert(not p:IsA("LuaSourceContainer"))
				if p:IsA("BasePart") then assert(p.Anchored and not p.CanCollide and not p.CanTouch) end
			end
		end
	end
	-- Imported props must not cover a pet position, merge board or purchase pad.
	local targets=plot.PetSpawnPads:GetChildren()
	for _,p in ipairs(plot.PurchaseButtons:GetChildren()) do table.insert(targets,p) end
	table.insert(targets,plot.MergeBoard)
	for _,m in ipairs(decor:GetChildren()) do
		if m:GetAttribute("DecorationOnly") then
			for _,p in ipairs(targets) do
				for _,d in ipairs(m:GetDescendants()) do
					if d:IsA("BasePart") then
						local pos=d.CFrame:PointToObjectSpace(p.Position)
						assert(math.abs(pos.X)>d.Size.X/2+.5 or math.abs(pos.Z)>d.Size.Z/2+.5,"Decoration covers gameplay position: "..m.Name)
					end
				end
			end
		end
	end
end
for _,p in ipairs(game.ServerStorage.FreeEnvironmentAssets:GetDescendants()) do assert(not p:IsA("LuaSourceContainer"),"Code in imported templates") end
print("[LandscapeTest] PASS: furniture counts, anchored script-free props, clear gameplay positions and reserved center")
