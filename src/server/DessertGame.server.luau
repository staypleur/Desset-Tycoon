local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local Market=game:GetService("MarketplaceService")
local Policy=game:GetService("PolicyService")
local Tween=game:GetService("TweenService")
local Config=require(RS:WaitForChild("TycoonConfig"))
local Rules=require(RS:WaitForChild("DessertRules"))
local Visuals=require(RS:WaitForChild("DessertVisuals"))
local DropPhysics=require(script.Parent:WaitForChild("DessertDropPhysics"))
local Layout=require(RS:WaitForChild("ProductionPlot"))
local UI=require(RS:WaitForChild("DessertUI"))
local CafeMarket=require(RS:WaitForChild("CafeMarket"))
local Profiles=require(script.Parent:WaitForChild("PlayerProfiles"))
local island=workspace:WaitForChild("DessertJellyIsland",30)
assert(island,"Dessert island missing")
while island:GetAttribute("LayoutReady")==false do task.wait(.1) end
Layout.Apply(island)
require(RS:WaitForChild("CentralCafeLayout")).Apply(island)
require(RS:WaitForChild("ReferenceStyle")).Apply(island)
require(RS:WaitForChild("CleanPresentation")).Apply(island)
require(RS:WaitForChild("HubPromenade")).Apply(island)
require(RS:WaitForChild("DessertBaskets")).Apply(island)
UI.ApplyWorld(island)
for _,plot in ipairs(island.PlayerPlots:GetChildren()) do DropPhysics.SetupPlot(plot) end
local remotes=Instance.new("Folder"); remotes.Name="DessertRemotes"; remotes.Parent=RS
local action=Instance.new("RemoteFunction"); action.Name="Action"; action.Parent=remotes
local events=Instance.new("RemoteEvent"); events.Name="Event"; events.Parent=remotes
local profiles,states={},{}
local friendPairs={}
local function pairKey(a,b) return tostring(math.min(a.UserId,b.UserId))..":"..tostring(math.max(a.UserId,b.UserId)) end
local function friendBonus(player,p)
	local bonus=0
	for other,q in pairs(profiles) do
		if other~=player and not q.Closing and friendPairs[pairKey(player,other)] then
			bonus=math.max(bonus,Rules.FriendBonus(p.Premium,{q.Premium}))
		end
	end
	return bonus
end
local rng=Random.new()
local market=CafeMarket.New(workspace:GetServerTimeNow(),rng)
local function refreshMarket()
	CafeMarket.Update(market,workspace:GetServerTimeNow(),rng)
	island:SetAttribute("CafeSaleMultiplier",CafeMarket.Multiplier(market))
	island:SetAttribute("CafeNextSaleChange",market.NextChange)
end
refreshMarket()
local function root(player)
	local c=player.Character; local h=c and c:FindFirstChildOfClass("Humanoid")
	return h and h.Health>0 and c:FindFirstChild("HumanoidRootPart") or nil
end
local function multiplier(p)
	return Rules.PassMultiplier(p.Passes,"Production")
end
local function snapshot(player)
	local p=profiles[player]; if not p then return nil end; local d=p.Data
	return {Cash=d.Cash,Bag=d.Bag,Pending=d.Pending,CafeQueue=d.CafeQueue,CafeLevel=d.CafeLevel,
		AFKStored=d.AFKStored,OfflineStored=d.OfflineStored,TotalCashEarned=d.TotalCashEarned,TotalMiniCollected=d.TotalMiniCollected,PlaySeconds=d.PlaySeconds,
		CafeRate=Rules.CafeRate(d),CafeUpgradeCost=Rules.CafeUpgradeCost(d),Index=d.Index,Highest=Rules.Highest(d),
		NormalTokens=d.NormalTokens,PerkTokens=d.PerkTokens,PaidNormalTokens=d.PaidNormalTokens,PaidPerkTokens=d.PaidPerkTokens,NextGift=d.NextGift,AFKSeconds=d.AFKSeconds,
		Multiplier=multiplier(p),Luck=Rules.PassMultiplier(p.Passes,"Luck"),FriendBonus=friendBonus(player,p),ShinyChance=Rules.ShinyChance("Normal",Rules.PassMultiplier(p.Passes,"Luck"),friendBonus(player,p)),OwnedPasses=table.clone(p.Passes),Settings=d.Settings,Equipped=d.Equipped,
		Durable=p.Durable,Premium=p.Premium,Restricted=p.Restricted,HotUntil=d.HotUntil,
		Active=Rules.Count(d),PlotId=player:GetAttribute("PlotId"),ServerTime=os.time()}
end
local function update(player,message)
	local p=profiles[player]; if not p then return end
	local cash=player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Cash")
	if cash then cash.Value=p.Data.Cash end
	local s=states[player:GetAttribute("PlotId")]
	if s then
		for _,count in ipairs({1,10,100,1000}) do
			local pad=s.Plot.PurchaseButtons["Buy"..count]
			UI.Pad(pad,p.Data.Cash,Rules.BuyCost(count))
			UI.Label(pad,"Buy "..count,"$"..UI.Format(Rules.BuyCost(count)),pad.Color)
		end
		local baskets=s.Plot:FindFirstChild("DessertBaskets")
		if baskets then require(RS.DessertBaskets).Refresh(s.Plot,p.Data.AFKStored,p.Data.OfflineStored) end
		UI.Pad(s.Plot.PersonalShopArea.UpgradeConverter,p.Data.Cash,Rules.CafeUpgradeCost(p.Data),p.Data.CafeLevel>=Config.CafeMaxLevel)
		UI.Label(s.Plot.PersonalShopArea.CollectIncome,"Collect Cash","$"..UI.Format(p.Data.Pending).." | $"..UI.Format(Rules.CafeRate(p.Data)*(os.time()<p.Data.HotUntil and Config.HotTimeMultiplier or 1)).." / sec",UI.Green)
		UI.Label(s.Plot.PersonalShopArea.UpgradeConverter,"Upgrade",p.Data.CafeLevel>=Config.CafeMaxLevel and "MAX" or "+"..UI.Format(Rules.CafeRate(p.Data)*(Config.CafeRateGrowth-1)).." / sec | $"..UI.Format(Rules.CafeUpgradeCost(p.Data)),s.Plot.PersonalShopArea.UpgradeConverter.Color)
	end
	events:FireClient(player,"State",snapshot(player),message)
end
local function discoveries(player,items)
	for _,item in ipairs(items or {}) do events:FireClient(player,"Discovery",item) end
end
local function stateFor(player) return states[player:GetAttribute("PlotId")] end
local function render(player)
	local s=stateFor(player); local p=profiles[player]
	if not s or not p or s.Plot:GetAttribute("OwnerUserId")~=player.UserId then return end
	s.Models:ClearAllChildren(); s.Pets={}; s.Owner=player
	local slot=0; local cf=s.Plot:GetPivot()
	for tier=1,30 do for _,shiny in ipairs({false,true}) do
		for _=1,math.min(p.Data.Pets[Rules.Key(tier,shiny)] or 0,60-slot) do
			slot+=1; local pad=s.Plot.PetSpawnPads["PetPad"..slot]; local pos=cf:PointToObjectSpace(pad.Position)
			local model=Visuals.Build(tier,shiny); model.Name="Dessert"..slot
			local placement=cf*CFrame.new(pos+Vector3.new(0,.1,0))
			model:SetAttribute("OwnerUserId",player.UserId);model:SetAttribute("DisplayBasePivot",placement)
			model:PivotTo(placement);model.Parent=s.Models
			table.insert(s.Pets,{Tier=tier,Shiny=shiny,Slot=slot,Next=os.clock()+Config.ProductionInterval})
		end
	end end
end
local function near(player,pad) local r=root(player); return r and (r.Position-pad.Position).Magnitude<=14 end
local function emit(s,pet,now)
	local p=profiles[s.Owner]; if not p or p.Busy then return end
	local producedAt=workspace:GetServerTimeNow()
	local producer=s.Models:FindFirstChild("Dessert"..pet.Slot)
	if producer then producer:SetAttribute("LastProductionTime",producedAt) end
	local value=3^(pet.Tier-1)*multiplier(p)
	if p.Passes.DessertMagnet then p.Data.Bag+=value; p.Data.TotalMiniCollected+=value; return end
	local cf=s.Plot:GetPivot(); local pad=s.Plot.PetSpawnPads["PetPad"..pet.Slot]
	local points,collector=DropPhysics.Route(s.Plot,pad,rng)
	if #s.Drops>=Config.MaxDrops then p.Data.AFKStored+=value; return end
	local m=Visuals.BuildMini(pet.Tier,pet.Shiny); m.Name="MiniDessert"
	m:SetAttribute("OwnerUserId",s.Owner.UserId);m:SetAttribute("DropStartTime",producedAt)
	m:PivotTo(CFrame.new(points[1])*cf.Rotation)
	local drop=DropPhysics.New(m,points,s.Products,collector);drop.Value=value
	table.insert(s.Drops,drop)
end
local function perform(player,verb,arg)
	local p=profiles[player]; local s=stateFor(player)
	if not p or p.Busy or p.Closing or p.Faulted then return false,"Please wait" end
	local d=p.Data
	if verb=="State" then return snapshot(player) end
	if verb=="Settings" then
		if not Rules.UpdateSettings(d,arg) then return false end
		update(player); return true
	elseif verb=="Activity" then p.LastActivity=os.clock(); return true
	elseif verb=="Equip" then
		if not Rules.ToggleEquip(d,arg) then return false end
		if p.Companion then p.Companion:Destroy(); p.Companion=nil end
		if d.Equipped then
			local tier,shiny=Rules.Decode(d.Equipped); local m=Visuals.Build(tier,shiny); m:ScaleTo(m:GetScale()*.65)
			m.Name="DessertCompanion"; m:SetAttribute("OwnerUserId",player.UserId)
			local r=root(player); m:PivotTo(r and r.CFrame*CFrame.new(-3,3,2) or s.Plot:GetPivot())
			m.Parent=workspace; p.Companion=m
		end
		update(player); return true
	elseif verb=="Crate" then
		if type(arg)~="table" or (arg.Kind~="Normal" and arg.Kind~="Perk") or (arg.Count~=1 and arg.Count~=10) then return false end
		local key=arg.Kind=="Perk" and "PerkTokens" or "NormalTokens"
		local paidKey="Paid"..key; local paid=d[paidKey] or 0
		if d[key]+(p.Restricted and 0 or paid)<arg.Count then return false,"Not enough available crate credits" end
		local freeUsed=math.min(d[key],arg.Count); d[key]-=freeUsed; d[paidKey]=paid-(arg.Count-freeUsed)
		local found={}; local results={}
		for _=1,arg.Count do table.insert(results,Rules.Roll(d,arg.Kind,rng,Rules.PassMultiplier(p.Passes,"Luck"),found,friendBonus(player,p))) end
		if p.Passes.AutoMerge then Rules.Merge(d,found) end
		render(player); events:FireClient(player,"Crates",results); update(player); return true
	elseif verb=="Purchase" then
		if type(arg)~="string" then return false end
		local product=Config.Products[arg]; local spec=product or Config.Passes[arg]
		if not spec or spec.Id<=0 or not p.Durable then return false,"Coming soon: purchases are not configured" end
		if not product and not Rules.CanBuyPass(p.Passes,arg) then return false,"Unlock the previous upgrade first" end
		if (product and product.Crate or spec.Group=="Luck") and p.Restricted then return false,"Unavailable in your region" end
		if product then Market:PromptProductPurchase(player,spec.Id) else Market:PromptGamePassPurchase(player,spec.Id) end
		return true
	end
	if not s or s.Owner~=player or s.Plot:GetAttribute("OwnerUserId")~=player.UserId then return false end
	local area=s.Plot.PersonalShopArea
	if verb=="Buy" then
		if arg~=1 and arg~=10 and arg~=100 and arg~=1000 then return false end
		if not near(player,s.Plot.PurchaseButtons["Buy"..arg]) then return false end
		local ok,result=Rules.Buy(d,arg,rng,Rules.PassMultiplier(p.Passes,"Luck"),p.Passes.AutoMerge,friendBonus(player,p))
		if ok then render(player); discoveries(player,result); update(player,"Purchased "..arg.." puddings") else update(player,result) end; return ok
	elseif verb=="Merge" then
		if not near(player,s.Plot.MergeBoard) then return false end
		local found={}; Rules.Merge(d,found); render(player); discoveries(player,found); update(player,"Matching desserts merged")
	elseif verb=="Deposit" or verb=="Sell" then
		local pad=island.CentralHub.DepositPads["Deposit"..player:GetAttribute("PlotId")]
		if not near(player,pad) then return false end
		refreshMarket()
		local amount,credited=Rules.Deposit(d,CafeMarket.Multiplier(market))
		-- Each owner's queue begins its own full two-second cycle after a deposit.
		if amount>0 and not p.NextCafeTick then p.NextCafeTick=os.clock()+Config.CafeInterval end
		if amount>0 then events:FireAllClients("CafeDelivery",pad.Position,island.CentralHub.CentralShop:GetPivot().Position) end
		update(player,string.format("Deposited %s at %.1fx: %s queued",UI.Format(amount),CafeMarket.Multiplier(market),UI.Format(credited)))
	elseif verb=="Upgrade" then
		if not near(player,area.UpgradeConverter) then return false end
		local ok,message=Rules.UpgradeCafe(d); update(player,message or "Converter upgraded"); return ok
	elseif verb=="Collect" then
		if not near(player,area.CollectIncome) then return false end
		d.Cash+=d.Pending; d.Pending=0; update(player,"Cash collected")
	else return false end
	return true
end
action.OnServerInvoke=function(player,verb,arg)
	local p=profiles[player]; if not p or type(verb)~="string" then return false end
	-- Input pings and HUD reads must not consume the debounce for deliberate UI actions.
	if verb=="Activity" then
		if os.clock()-(p.LastInputSignal or 0)>=5 then p.LastInputSignal=os.clock(); p.LastActivity=os.clock() end
		return true
	elseif verb=="State" then
		if os.clock()-(p.LastStateRead or 0)<.5 then return false end
		p.LastStateRead=os.clock(); return snapshot(player)
	end
	if os.clock()-(p.LastAction or 0)<.2 then return false,"Please wait" end
	p.LastAction=os.clock(); return perform(player,verb,arg)
end
if Run:IsStudio() then
	local testAction=Instance.new("BindableFunction"); testAction.Name="StudioDessertAction"
	testAction.OnInvoke=perform; testAction.Parent=script
end
for i=1,6 do
	local plot=island.PlayerPlots["Plot"..i]
	for _,name in ipairs({"ActiveDesserts","MovingDesserts"}) do local old=plot:FindFirstChild(name); if old then old:Destroy() end end
	local models=Instance.new("Folder"); models.Name="ActiveDesserts"; models.Parent=plot
	local products=Instance.new("Folder"); products.Name="MovingDesserts"; products.Parent=plot
	local s={Plot=plot,Models=models,Products=products,Pets={},Drops={}}; states[i]=s
	local function button(pad,verb,arg,text,hold,public)
		pad.CanTouch=not hold
		for _,old in ipairs(pad:GetChildren()) do if old:IsA("ProximityPrompt") then old:Destroy() end end
		local prompt
		if hold then
			prompt=Instance.new("ProximityPrompt"); prompt.ActionText=text; prompt.KeyboardKeyCode=Enum.KeyCode.E; prompt.HoldDuration=hold; prompt.MaxActivationDistance=10; prompt.RequiresLineOfSight=false; prompt.Parent=pad
		end
		local pressed,latched={},{}
		local function activate(player,fromTouch)
			if (not public and player~=s.Owner) or not near(player,pad) or not profiles[player] then return end
			if fromTouch and latched[player] then return end
			if os.clock()-(pressed[player] or 0)<1 then return end; pressed[player]=os.clock()
			if fromTouch then
				latched[player]=true
				task.spawn(function()
					repeat task.wait(.25); local r=root(player)
						local pos=r and pad.CFrame:PointToObjectSpace(r.Position)
						if not pos or math.abs(pos.X)>pad.Size.X/2+2 or math.abs(pos.Z)>pad.Size.Z/2+2 then break end
					until player.Parent~=Players
					latched[player]=nil
				end)
			end
			Tween:Create(pad,TweenInfo.new(.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,true),{CFrame=pad.CFrame*CFrame.new(0,-.16,0)}):Play()
			if verb=="Panel" then events:FireClient(player,"Panel",arg) else perform(player,verb,arg) end
		end
		if prompt then prompt.Triggered:Connect(activate) end
		if not hold then pad.Touched:Connect(function(hit) local c=hit:FindFirstAncestorOfClass("Model"); local player=c and Players:GetPlayerFromCharacter(c); if player then activate(player,true) end end) end
	end
	for _,count in ipairs({1,10,100,1000}) do button(plot.PurchaseButtons["Buy"..count],"Buy",count,"Buy "..count) end
	button(plot.MergeBoard,"Merge",nil,"Merge matching desserts")
	button(island.CentralHub.DepositPads["Deposit"..i],"Deposit",nil,"Deposit mini desserts")
	button(plot.PersonalShopArea.CollectIncome,"Collect",nil,"Collect cash")
	button(plot.PersonalShopArea.UpgradeConverter,"Upgrade",nil,"Upgrade converter")
	button(plot.PersonalShopArea.RobuxShop,"Panel","Shop","Open shop",.8,true)
	button(island.CentralHub.CratePads["Crate"..i],"Panel","Crates","Open crates",.5,true)
	plot:GetAttributeChangedSignal("OwnerUserId"):Connect(function()
		s.Models:ClearAllChildren(); s.Products:ClearAllChildren(); s.Pets={}; s.Drops={}
		s.Owner=Players:GetPlayerByUserId(plot:GetAttribute("OwnerUserId") or 0)
		if s.Owner then render(s.Owner); update(s.Owner)
		else require(RS.DessertBaskets).Refresh(plot,0,0); for _,count in ipairs({1,10,100,1000}) do UI.Pad(plot.PurchaseButtons["Buy"..count],nil,Rules.BuyCost(count)) end; UI.Pad(plot.PersonalShopArea.UpgradeConverter,nil,Config.CafeUpgradeBaseCost) end
	end)
end
local function refreshPasses(player,p)
	for key,spec in pairs(Config.Passes) do if spec.Id>0 then
		local ok,owns=pcall(Market.UserOwnsGamePassAsync,Market,player.UserId,spec.Id); p.Passes[key]=ok and owns or false
	end end
	if p.Restricted then for _,key in ipairs(Config.LuckTiers) do p.Passes[key]=false end end
	local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.WalkSpeed=16*Rules.PassMultiplier(p.Passes,"Speed") end
end
local function join(player)
 local arrival=os.time()
 local p,message=Profiles.Load(player); if not p then player:Kick(message); return end
 if player.Parent~=Players then Profiles.Save(p,true,true); return end
 p.Passes={}; p.Restricted=true; p.Premium=player.MembershipType==Enum.MembershipType.Premium
 player.CharacterAdded:Connect(function(character)
  DropPhysics.Character(character)
  local humanoid=character:WaitForChild("Humanoid",10)
  if humanoid then humanoid.WalkSpeed=16*Rules.PassMultiplier(p.Passes,"Speed") end
 end)
 if player.Character then DropPhysics.Character(player.Character) end
 Rules.NormalizeCafe(p.Data)
 if not Run:IsStudio() then local ok,info=pcall(Policy.GetPolicyInfoForPlayerAsync,Policy,player); p.Restricted=not ok or info.ArePaidRandomItemsRestricted~=false end
 refreshPasses(player,p)
 Rules.AccrueOffline(p.Data,arrival,multiplier(p))
 if player.Parent~=Players then Profiles.Save(p,true,true); return end
 p.LastActivity=os.clock(); p.LastPlayCheck=os.clock(); profiles[player]=p
 -- Query each joining player's pairs once; cached relationships never yield in the game loop.
 task.spawn(function()
  for other,q in pairs(profiles) do if other~=player and not q.Closing then
   local ok,friends=pcall(player.IsFriendsWithAsync,player,other.UserId)
   friendPairs[pairKey(player,other)]=ok and friends==true
  end end
 end)
 if p.Data.CafeQueue>0 then p.NextCafeTick=os.clock()+Config.CafeInterval end
 local stats=Instance.new("Folder"); stats.Name="leaderstats"; stats.Parent=player
 local cash=Instance.new("NumberValue"); cash.Name="Cash"; cash.Parent=stats
 player:GetAttributeChangedSignal("PlotId"):Connect(function() render(player); update(player) end)
 Rules.Gift(p.Data,os.time(),p.Premium); render(player); update(player)
 print("[DessertGame] Profile ready: "..(p.Durable and "saved" or "Studio session").."; gifts every 5h")
end
Players.PlayerAdded:Connect(join); for _,player in ipairs(Players:GetPlayers()) do task.spawn(join,player) end
local function close(player)
	local p=profiles[player]; if not p or p.Closing then return end; p.Closing=true
	local deadline=os.clock()+15; while p.Busy and os.clock()<deadline do task.wait(.1) end
	local elapsed=math.max(0,os.clock()-(p.LastPlayCheck or os.clock()))
	p.Data.PlaySeconds+=elapsed; Rules.AFK(p.Data,elapsed,p.Premium); p.LastPlayCheck=os.clock()
	if not Profiles.Save(p,true) then warn("[DessertGame] Save failed on leave") end
	if p.Companion then p.Companion:Destroy() end; profiles[player]=nil
end
Players.PlayerRemoving:Connect(close)
game:BindToClose(function()
	local count=0; for player in pairs(profiles) do count+=1; task.spawn(function() close(player); count-=1 end) end
	local deadline=os.clock()+25; while count>0 and os.clock()<deadline do task.wait(.1) end
end)
Market.PromptGamePassPurchaseFinished:Connect(function(player) local p=profiles[player]; if p then refreshPasses(player,p); update(player) end end)
Market.ProcessReceipt=function(receipt)
	local player=Players:GetPlayerByUserId(receipt.PlayerId); local p=player and profiles[player]
	if not p or p.Closing then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local spec; for _,product in pairs(Config.Products) do if product.Id>0 and product.Id==receipt.ProductId then spec=product end end
	if not spec then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local granted=Profiles.Receipt(p,tostring(receipt.PurchaseId),function(d)
		if spec.Crate then local key=spec.Crate=="Perk" and "PaidPerkTokens" or "PaidNormalTokens"; d[key]=(d[key] or 0)+spec.Count
		else d.HotUntil=math.max(os.time(),d.HotUntil)+Config.HotTimeSeconds end
	end)
	if granted then update(player); return Enum.ProductPurchaseDecision.PurchaseGranted end
	if p.Faulted then player:Kick("Purchase confirmation is pending. Please rejoin shortly.") end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end
local frameTime,timer,saveTimer=0,0,0
Run.Heartbeat:Connect(function(dt)
	frameTime+=dt; timer+=dt; saveTimer+=dt; if frameTime<.1 then return end; frameTime=0
	local now=os.clock()
	if workspace:GetServerTimeNow()>=market.NextChange then refreshMarket() end
	for _,s in ipairs(states) do local p=s.Owner and profiles[s.Owner]
		if p and not p.Busy and not p.Closing and not p.Faulted then
			for _,pet in ipairs(s.Pets) do if now>=pet.Next then
				emit(s,pet,now)
				pet.Next=now+Config.ProductionInterval
			end end
			s.Plot:SetAttribute("UncollectedDrops",#s.Drops)
			local r=root(s.Owner); local picked=false
			if r or p.Passes.DessertMagnet then for _,item in ipairs({{"AFKAnchor","AFKStored"},{"OfflineAnchor","OfflineStored"}}) do
				local baskets=s.Plot:FindFirstChild("DessertBaskets"); local anchor=baskets and baskets:FindFirstChild(item[1])
				if anchor and p.Data[item[2]]>0 and (p.Passes.DessertMagnet or (r and (r.Position-anchor.Position).Magnitude<=6)) then
					local amount=p.Data[item[2]]; p.Data[item[2]]=0; p.Data.Bag+=amount; p.Data.TotalMiniCollected+=amount; picked=true
				end
			end end
			for n=#s.Drops,1,-1 do
				local drop=s.Drops[n]
				DropPhysics.Step(drop)
				local pos=drop.Body.Position
				if p.Passes.DessertMagnet or (r and (r.Position-pos).Magnitude<=6) then p.Data.Bag+=drop.Value; p.Data.TotalMiniCollected+=drop.Value; drop.Model:Destroy(); table.remove(s.Drops,n); picked=true
				elseif pos.Y<s.Plot:GetPivot().Position.Y-25 or (pos-s.Plot:GetPivot().Position).Magnitude>150 or (os.clock()-drop.Started>90 and not DropPhysics.InCollector(drop)) then
					-- Preserve value if a body is lost or its route remains blocked.
					p.Data.AFKStored+=drop.Value;drop.Model:Destroy();table.remove(s.Drops,n);picked=true
				end
			end
			if picked then update(s.Owner) end
		end
	end
	for player,p in pairs(profiles) do
		if p.Passes.MoneyMagnet and not p.Busy and not p.Closing and not p.Faulted and p.Data.Pending>0 then p.Data.Cash+=p.Data.Pending; p.Data.Pending=0; update(player) end
		-- Companions are cosmetic; each client follows the replicated character every render frame.
		if p.NextCafeTick and now>=p.NextCafeTick and not p.Busy and not p.Closing and not p.Faulted then
			local units,cash=Rules.ConvertCafe(p.Data,os.time())
			p.NextCafeTick=p.Data.CafeQueue>0 and now+Config.CafeInterval or nil
			local s=stateFor(player)
			if units>0 and s then events:FireAllClients("CafeCash",island.CentralHub.CentralShop:GetPivot().Position,s.Plot.PersonalShopArea.CollectIncome.Position,cash); update(player) end
		end
	end
	if timer>=1 then local seconds=timer; timer=0
		for player,p in pairs(profiles) do if not p.Busy and not p.Closing and not p.Faulted then
			local r=root(player); if r and p.LastPosition and (r.Position-p.LastPosition).Magnitude>.5 then p.LastActivity=now end
			p.LastPosition=r and r.Position; p.Premium=player.MembershipType==Enum.MembershipType.Premium
			Rules.Gift(p.Data,os.time(),p.Premium)
			-- Include idle time spent waiting for a save instead of losing busy-frame seconds.
			local connectedSeconds=math.max(0,now-(p.LastPlayCheck or now))
			p.Data.PlaySeconds+=connectedSeconds; Rules.AFK(p.Data,connectedSeconds,p.Premium); p.LastPlayCheck=now
			if p.Passes.AutoMerge then local found={}; local before=Rules.Count(p.Data); Rules.Merge(p.Data,found); if before~=Rules.Count(p.Data) then render(player); discoveries(player,found) end end
			update(player)
		end end
	end
	if saveTimer>=60 then saveTimer=0
		for player,p in pairs(profiles) do if not p.Closing and not p.Busy then task.spawn(function()
			if not Profiles.Save(p,false) and player.Parent==Players then player:Kick("Your save connection was lost. Please rejoin.") end
		end) end end
	end
end)
print("[DessertGame] Ready: central cafe, 2-second queued conversion, bank upgrades, hold-E shop, 5-hour gifts")
