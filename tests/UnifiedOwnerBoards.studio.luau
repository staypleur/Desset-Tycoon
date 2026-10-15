-- Run after applying CleanPresentation in edit mode; repeat Apply to check idempotency.
local island=workspace.DessertJellyIsland
local module=game.ReplicatedStorage.CleanPresentation:Clone();module.Parent=game.ReplicatedStorage
local P=require(module);P.Apply(island);P.Apply(island)
local counts={}
for i=1,6 do
 local plot=island.PlayerPlots["Plot"..i]
 local board=plot.PersonalShopArea.OwnerBoard
 assert(board:GetAttribute("BoardStyle")=="PinkPark")
 local parts=0
 for _,item in ipairs(board:GetDescendants()) do
  assert(not item:IsA("LuaSourceContainer") and not item:IsA("PackageLink"))
  if item:IsA("BasePart") then parts+=1;assert(item.Anchored and not item.CanCollide) end
 end
 counts[i]=parts;assert(parts==counts[1],"Same framed geometry in every plot")
 local front=board:FindFirstChild("FrontOwner",true);local back=board:FindFirstChild("BackOwner",true)
 assert(front and back and front.OwnerFace and front.OwnerName and back.OwnerFace and back.OwnerName)
 assert(front.OwnerName.Text==(plot:GetAttribute("OwnerName") or ""),"Owner binding preserved")
 local n=0;for _,child in ipairs(plot.PersonalShopArea:GetChildren()) do if child.Name=="OwnerBoard" then n+=1 end end
 assert(n==1,"Exactly one owner board per plot")
end
module:Destroy()
print("[UnifiedOwnerBoards] PASS: six identical pink frames, two-sided owner UI, no duplicate boards or foreign code")
