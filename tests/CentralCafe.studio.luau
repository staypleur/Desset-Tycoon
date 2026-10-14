-- Run in edit mode after v12 layout; cloned modules avoid the Command Bar require cache.
local sandbox=Instance.new("Folder"); sandbox.Parent=game.ReplicatedStorage
game.ReplicatedStorage.TycoonConfig:Clone().Parent=sandbox
local rc=game.ReplicatedStorage.DessertRules:Clone(); rc.Parent=sandbox
local R=require(rc); sandbox:Destroy()
local d=R.New(0); d.Bag=100
assert(R.Deposit(d)==100 and d.CafeQueue==100 and d.Pending==0 and d.Bag==0,"Deposit must not instantly pay")
local n,c=R.ConvertCafe(d,1); assert(n==10 and c==10 and d.CafeQueue==90 and d.Pending==10)
assert(R.UpgradeCafe(d)); assert(d.Cash==0 and d.CafeLevel==1 and math.abs(R.CafeRate(d)-.15)<1e-8)
assert(not R.UpgradeCafe(d),"Upgrade must charge cash")
local total=10; for _=1,100 do local units=R.ConvertCafe(d,1); total+=units end
assert(total==100 and d.CafeQueue==0 and d.Pending==100,"Conversion must conserve and fully drain units")
d.Bag=1; R.Deposit(d); d.HotUntil=10; local _,hot=R.ConvertCafe(d,2); assert(hot==2)
d.Cash=1e15; for _=1,30 do R.UpgradeCafe(d) end
assert(d.CafeLevel==18 and R.CafeRate(d)==1 and not R.UpgradeCafe(d))
local old={Cash=13,Bag=4,Pending=9}; R.NormalizeCafe(old); assert(old.CafeQueue==0 and old.CafeLevel==0 and old.Cash==13 and old.Pending==9)
local island=workspace.DessertJellyIsland; local hub=island.CentralHub
assert(island:GetAttribute("CentralCafeVersion")==1 and #hub.DepositPads:GetChildren()==6)
assert(hub.CentralShop.CafeArchitecture:FindFirstChild("FacelessRoofCake"))
assert(#hub.CafeSeating:GetChildren()==6 and #island.SugarPaths:GetChildren()==6)
local center=hub.CentralShop:GetPivot().Position
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]; assert(plot.PlotFloor.Size==Vector3.new(128,1,120))
	assert(#plot.PetSpawnPads:GetChildren()==60 and not plot.PersonalShopArea:FindFirstChild("DessertCafe"))
	assert(plot.PersonalShopArea.BankBuilding:GetAttribute("DecorationOnly") and plot.PersonalShopArea.ShopBuilding:GetAttribute("DecorationOnly"))
	local radial=Vector3.new(plot:GetPivot().X-center.X,0,plot:GetPivot().Z-center.Z).Unit
	local path=island.SugarPaths:GetChildren()[i]; assert(math.abs(path.CFrame.LookVector:Dot(radial))>.9999,"Path must align with plot axis")
	local entrance=plot:GetPivot():PointToObjectSpace(plot.Entrance.Position); assert(math.abs(entrance.X)<.01)
	local left=plot.PetSpawnPads.PetPad1; assert(left:GetAttribute("SlotIndex")==1)
end
for _,dsc in ipairs(hub.CentralShop.CafeArchitecture.FacelessRoofCake:GetDescendants()) do assert(not dsc.Name:lower():find("eye") and not dsc.Name:lower():find("mouth")) end
for _,template in ipairs({game.ServerStorage.FreeBankTemplate,game.ServerStorage.FreeShopTemplate}) do for _,dsc in ipairs(template:GetDescendants()) do assert(not dsc:IsA("LuaSourceContainer")) end end
print("[CentralCafeTest] PASS: delayed/conserved conversion, upgrades/cap, hot time, old profiles, six axial paths, 360 plates, faceless roof cake, script-free buildings")
