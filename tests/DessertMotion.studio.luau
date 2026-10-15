local clone=game.ReplicatedStorage.DessertMotion:Clone();clone.Parent=game.ReplicatedStorage
local M=require(clone)
assert(M.HopHeight(-1)==0 and M.HopHeight(0)==0 and M.HopHeight(.4)==0 and M.HopHeight(5)==0)
assert(math.abs(M.HopHeight(.2)-.35)<.0001,"Low production hop")
clone:Destroy()
print("[DessertMotion] PASS: production timestamp boundaries, 0.35-stud hop returns to base")
