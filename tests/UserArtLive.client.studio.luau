-- Run in a fresh Studio Play client. Test UI snapshots never grant real passes.
local RS=game.ReplicatedStorage
local C=require(RS.TycoonConfig); local A=require(RS.UserArt); local Shop=require(RS.KawaiiShop)
local screen=Instance.new("ScreenGui"); screen.Name="UserArtRegression"; screen.Parent=game.Players.LocalPlayer.PlayerGui
local holder=Instance.new("Frame"); holder.BackgroundTransparency=1; holder.Size=UDim2.fromOffset(770,210)
holder.Position=UDim2.new(.5,-385,0,70); holder.Parent=screen
local keys={"Boost12","Boost15","Boost2","Boost3","Boost4","Boost5","AutoMerge","MoneyMagnet","DessertMagnet","Luck12","Luck15","Luck2","Speed12","Speed15","Speed3","Speed2","NormalCrate","ShinyIcon","CashIcon","IndexIcon","ShopIcon","PerkCrate"}
local images={}
table.insert(keys,"MultiplierIcon")
for index,key in ipairs(keys) do
 local image=A.Create(holder,key,UDim2.fromOffset(64,64),UDim2.fromOffset(((index-1)%11)*70,math.floor((index-1)/11)*70))
 assert(image:GetAttribute("UserIcon")==key and image.ImageRectSize==Vector2.new(256,256))
 table.insert(images,image)
end
local deadline=os.clock()+20
repeat task.wait(.1); local loaded=true
 for _,image in ipairs(images) do if not image.IsLoaded then loaded=false; break end end
 if loaded then break end
until os.clock()>deadline
for _,image in ipairs(images) do assert(image.IsLoaded,"Rendered image failed to load: "..image.Name) end
local data={OwnedPasses={},Durable=false,Restricted=false}
local callbacks={Click=function() end,Close=function() end,Purchase=function() error("Tests must never purchase") end}
for stage=1,7 do
 local shop=Shop.Open(screen,data,callbacks); local cards=shop.Root.ProductCards
 local expected=C.ProductionTiers[math.min(stage,6)]
 assert(cards:FindFirstChild(expected) and cards.Luck12 and cards.DessertMagnet and cards.MoneyMagnet)
 local count=0
 for _,key in ipairs(C.ProductionTiers) do if cards:FindFirstChild(key) then count+=1 end end
 assert(count==1,"Only the next production tier is shown")
 for _,card in ipairs(cards:GetChildren()) do if card:IsA("Frame") then
  assert(card:FindFirstChild("UserArt"..card.Name) and card.Purchase:GetAttribute("Purchasable")==false)
  assert(card.RobuxPrice.Text:match(" Robux$"))
 end end
 shop.Destroy(); if stage<=6 then data.OwnedPasses[C.ProductionTiers[stage]]=true end
end
for stage=1,3 do
 local shop=Shop.Open(screen,data,callbacks); assert(shop.Root.ProductCards:FindFirstChild(C.LuckTiers[stage])); shop.Destroy()
 data.OwnedPasses[C.LuckTiers[stage]]=true
end
for stage=1,4 do
 local shop=Shop.Open(screen,data,callbacks); local cards=shop.Root.ProductCards
 assert(cards:FindFirstChild(C.SpeedTiers[stage]))
 local count=0; for _,key in ipairs(C.SpeedTiers) do if cards:FindFirstChild(key) then count+=1 end end
 assert(count==1,"Only next speed tier is shown"); shop.Destroy(); data.OwnedPasses[C.SpeedTiers[stage]]=true
end
screen:Destroy()
local state=RS.DessertRemotes.Action:InvokeServer("State")
assert(state.OwnedPasses and state.FriendBonus>=0 and math.abs(state.ShinyChance-require(game.ReplicatedStorage.DessertRules).ShinyChance("Normal",state.Luck,state.FriendBonus,state.CodeShiny50,state.ShinyTier))<1e-6)
local topbar=game.Players.LocalPlayer.PlayerGui.DessertTopbar
assert(not topbar:FindFirstChild("MicrophoneButton"))
assert(topbar.StatsButton.Position.X.Offset==topbar.SettingsButton.Position.X.Offset+topbar.SettingsButton.Size.X.Offset+8)
assert(game.Players.LocalPlayer.PlayerGui.DessertHUD:FindFirstChild("CashValue",true).Text=="$0")
assert(game.Players.LocalPlayer.PlayerGui.DessertHUD:FindFirstChild("UserArtMultiplierIcon",true))
print("[UserArtLive] PASS: all 23 source pictures loaded, exact crops, next-tier-only production/luck/speed, separate magnets, Robux labels, compact settings/profile buttons, prefix cash and zero-ID locks")
