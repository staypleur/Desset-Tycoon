-- Run once in the edit-mode Command Bar after installing TycoonPlotLayout.
assert(not game:GetService("RunService"):IsRunning(), "Stop Play first")
require(game.ReplicatedStorage.TycoonPlotLayout).Apply(workspace.DessertJellyIsland)
