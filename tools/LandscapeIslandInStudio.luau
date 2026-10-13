-- Install IslandLandscape and import the verified free models before running this in edit mode.
assert(not game:GetService("RunService"):IsRunning(),"Stop Play first")
require(game.ReplicatedStorage.IslandLandscape).Apply(workspace.DessertJellyIsland)
if workspace:FindFirstChild("AssetPreview") then workspace.AssetPreview:Destroy() end
