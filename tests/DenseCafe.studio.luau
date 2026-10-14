assert(not game:GetService('RunService'):IsRunning())
local island=workspace.DessertJellyIsland; local RS=game.ReplicatedStorage
local fresh=Instance.new('Folder'); fresh.Parent=RS
for _,name in ipairs({'CleanPresentation','DessertRules','TycoonConfig'}) do RS[name]:Clone().Parent=fresh end
local banks={}
for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
 local bank=plot.PersonalShopArea.BankBuilding; local word=bank.RoofWord
 banks[bank]={WordCF=word:GetPivot(),Parts={}}
 if not bank:GetAttribute('FacingIntoPlot') then
  local pivot=bank:GetPivot()
  for _,p in ipairs(bank:GetDescendants()) do if p:IsA('BasePart') and not p:IsDescendantOf(word) then
   banks[bank].Parts[p]=pivot*CFrame.Angles(0,math.pi,0)*pivot:ToObjectSpace(p.CFrame)
  end end
 end
end
local P=require(fresh.CleanPresentation); P.Apply(island)
local cafe=island.CentralHub.CentralShop.CafeArchitecture
assert(not cafe:FindFirstChild('FreeCoffeeMachine'))
local decor=cafe.ApprovedCafeDecor; P.Apply(island); assert(cafe.ApprovedCafeDecor==decor,'Duplicate decor regeneration')
local displays,desserts,count,stands=0,0,0,0
for _,p in ipairs(decor:GetChildren()) do
 if p.Name:match('^KawaiiDessertDisplay') then displays+=1 end
 if p.Name:match('^CounterDessert') then desserts+=1 end
 if p.Name:match('^PinkCakeStand') then stands+=1 end
 if p.Name:match('^CounterDessert') then
  local reference,volume=nil,0
  for _,part in ipairs(p:GetDescendants()) do if part:IsA('BasePart') then local v=part.Size.X*part.Size.Y*part.Size.Z; if v>volume then volume=v; reference=part end end end
  assert(reference and math.max(math.abs(reference.CFrame.UpVector.Y),math.abs(reference.CFrame.RightVector.Y),math.abs(reference.CFrame.LookVector.Y))>.999,'Tilted pastry remains')
 end
end
for _,p in ipairs(decor:GetDescendants()) do
 assert(not p:IsA('LuaSourceContainer') and not p:IsA('PackageLink'))
 if p:IsA('BasePart') then count+=1; assert(p.Anchored and not p.CanCollide and not p.CanTouch and not p.CanQuery and not p.CastShadow) end
end
assert(displays==3 and desserts==36 and count<=1800,'Dense decor exceeds measured part budget')
assert(stands==12,'Exactly twelve approved stands are required')
for bank,saved in pairs(banks) do
 assert(bank:GetAttribute('FacingIntoPlot'))
 assert((bank.RoofWord:GetPivot().Position-saved.WordCF.Position).Magnitude<.001)
 assert(bank.RoofWord:GetPivot().LookVector:Dot(saved.WordCF.LookVector)>.999)
 for p,expected in pairs(saved.Parts) do assert((p.Position-expected.Position).Magnitude<.001 and p.CFrame.LookVector:Dot(expected.LookVector)>.999) end
end
local R=require(fresh.DessertRules); local d=R.New(0)
assert(d.Cash==0 and d.Pets['1n']==1 and R.ProductionPerSecond(d)>0)
assert(not R.Buy(d,1,{NextNumber=function() return .5 end},false,false))
local saved={Cash=123}; R.NormalizeCafe(saved); assert(saved.Cash==123,'Existing balances must survive migration')
d.Bag=5; assert(R.Deposit(d,1)); for _=1,3 do R.ConvertCafe(d,0) end
assert(d.Pending==5 and d.CafeQueue==0,'Zero-cash starter can earn from pudding production')
fresh:Destroy()
print('[DenseCafe] PASS: removed machine, 3 lightweight shelves, 36 counter props, '..count..' decorative parts, banks rotated/roof words preserved, zero-cash viable starter and saved balances unchanged')
