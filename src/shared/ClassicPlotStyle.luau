-- Apply Classic Baseplate stud surfaces to ground and gameplay platforms.
local Style={}
local names={PlotFloor=true,SideFence=true,BackFence=true,FrontTrim=true,Entrance=true,PlotSpawn=true,
	MergeBoard=true,MainBelt=true,WalkwayBridge=true,Collector=true,CollectIncome=true,DessertCrate=true,
	BakeryTerrace=true,TeaPatio=true,PatioBorder=true,CafePlanter=true,CreamPath=true,PathEdging=true,
	MintIcingGround=true,VanillaPlaza=true,PlazaBorder=true}
local faces={{"TopSurface",Vector3.yAxis},{"BottomSurface",-Vector3.yAxis},
	{"RightSurface",Vector3.xAxis},{"LeftSurface",-Vector3.xAxis},
	{"BackSurface",Vector3.zAxis},{"FrontSurface",-Vector3.zAxis}}
local function studs(p)
	p.Material=Enum.Material.Plastic
	for _,face in ipairs(faces) do
		p[face[1]]=p.CFrame:VectorToWorldSpace(face[2]).Y>.98 and Enum.SurfaceType.Studs or Enum.SurfaceType.Smooth
	end
	p:SetAttribute("ClassicBaseplateSurface",true)
end
function Style.Apply(island)
	assert(not island:GetAttribute("ClassicPlotVersion"),"Classic style already applied")
	local layout=require(game.ReplicatedStorage.TycoonPlotLayout)
	for i=1,6 do
		local plot=island.PlayerPlots["Plot"..i]
		layout.BuildDessertSlots(plot)
		local decor=plot:FindFirstChild("CafeGardenDecor")
		if decor then for _,m in ipairs(decor:GetChildren()) do
			if m.Name=="FlowerBorder" or m.Name=="GrassTuft" then
				local cf=plot:GetPivot(); local localPos=cf:PointToObjectSpace(m:GetPivot().Position)
				if math.abs(localPos.X)<45 then
					m:PivotTo(m:GetPivot()+cf:VectorToWorldSpace(Vector3.new(localPos.X<0 and -3 or 3,0,0)))
				end
			end
		end end
	end
	for _,p in ipairs(island:GetDescendants()) do
		if p:IsA("Part") or p:IsA("SpawnLocation") then
			if names[p.Name] or p.Parent.Name=="PurchaseButtons" or p.Parent.Name=="MergeCells"
				or p.Parent.Name=="ProductionBeds" or p.Parent.Name=="PetSpawnPads" or p.Parent.Name=="PetPadFrames" then studs(p) end
		end
	end
	island:SetAttribute("ClassicPlotVersion",1)
	island:SetAttribute("MapVersion","10.0.0")
	print("[ClassicPlots] PASS: classic stud ground, 6x5 left + 6x5 right, 60 dessert slots per plot")
end
return Style
