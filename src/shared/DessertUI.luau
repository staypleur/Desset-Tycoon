-- Original pastel components with free Laurel / Tabler MIT icons.
-- Attribution and MIT notice: docs/LAUREL-LICENSE.txt, docs/ASSETS.md.
local UI={}
UI.Icons={Coins="rbxassetid://74778137045475",Index="rbxassetid://82382233309285",
	Settings="rbxassetid://123802788977158",Shop="rbxassetid://136213874647182",
	Crates="rbxassetid://123119869662551",Cake="rbxassetid://127893549827766",
	Sparkles="rbxassetid://74659718515937",Bank="rbxassetid://110036223487911",
	Cafe="rbxassetid://84687926049338",Close="rbxassetid://119058583962559",
	Upgrade="rbxassetid://119889402592837",Check="rbxassetid://129170135048823",Lock="rbxassetid://128255973855104"}
UI.Green=Color3.fromRGB(108,218,147)
UI.Red=Color3.fromRGB(245,123,139)
UI.Idle=Color3.fromRGB(213,204,221)
UI.Ink=Color3.fromRGB(104,64,90)
local function corner(object,radius)
	local c=object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner"); c.CornerRadius=UDim.new(0,radius or 18); c.Parent=object
end
function UI.Card(object,color,radius)
	object.BackgroundColor3=color; object.BorderSizePixel=0; corner(object,radius)
	local stroke=Instance.new("UIStroke"); stroke.Name="CreamOutline"; stroke.Color=Color3.fromRGB(255,253,247); stroke.Thickness=2.5; stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; stroke.Parent=object
	local gradient=Instance.new("UIGradient"); gradient.Rotation=90; gradient.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(232,216,230)); gradient.Parent=object
	local shadow=Instance.new("Frame"); shadow.Name="SoftShadow"; shadow.AnchorPoint=Vector2.new(.5,.5); shadow.Position=UDim2.new(.5,0,.5,5); shadow.Size=UDim2.new(1,6,1,6)
	shadow.BackgroundColor3=UI.Ink; shadow.BackgroundTransparency=.86; shadow.BorderSizePixel=0; shadow.ZIndex=math.max(1,object.ZIndex-1); shadow.Parent=object; corner(shadow,radius)
	-- Behind the surface: sibling sharing the same placement, independent of card content.
	shadow.Parent=object.Parent; shadow.Position=object.Position+UDim2.fromOffset(-3,5); shadow.AnchorPoint=object.AnchorPoint; shadow.Size=object.Size+UDim2.fromOffset(6,6)
	object:GetPropertyChangedSignal("Visible"):Connect(function() shadow.Visible=object.Visible end); shadow.Visible=object.Visible
	object.Destroying:Connect(function() shadow:Destroy() end)
	object.ZIndex=shadow.ZIndex+1
end
function UI.Icon(parent,key,size,pos)
	local image=Instance.new("ImageLabel"); image.Name="Icon"; image.BackgroundTransparency=1; image.Image=UI.Icons[key] or UI.Icons.Cake
	image.ImageColor3=UI.Ink; image.Size=UDim2.fromOffset(size,size); image.Position=pos; image.ZIndex=parent.ZIndex+1; image.Parent=parent; return image
end
function UI.Button(b,key)
	UI.Card(b,b.BackgroundColor3,16); b.Font=Enum.Font.FredokaOne; b.TextWrapped=true; b.TextXAlignment=Enum.TextXAlignment.Left
	local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,40); pad.PaddingRight=UDim.new(0,8); pad.Parent=b
	-- UIPadding shifts child positions as well as text; offset the icon back into the left gutter.
	UI.Icon(b,key,26,UDim2.new(0,-32,.5,-13))
	local scale=Instance.new("UIScale"); scale.Parent=b
	local tween=game:GetService("TweenService")
	b.MouseEnter:Connect(function() tween:Create(scale,TweenInfo.new(.14),{Scale=1.025}):Play() end)
	b.MouseLeave:Connect(function() tween:Create(scale,TweenInfo.new(.14),{Scale=1}):Play() end)
	b.Activated:Connect(function() scale.Scale=.96; tween:Create(scale,TweenInfo.new(.22,Enum.EasingStyle.Back),{Scale=1}):Play() end)
end
function UI.Billboard(g)
	if g:GetAttribute("DessertStyled") then return end
	local label=g:FindFirstChildOfClass("TextLabel"); if not label then return end
	g:SetAttribute("DessertStyled",true); g.MaxDistance=65; g.AlwaysOnTop=false
	g.Size=UDim2.fromOffset(label.Name=="OwnerLabel" and 250 or 190,label.Name=="OwnerLabel" and 54 or 64)
	local card=Instance.new("Frame"); card.Name="BubbleCard"; card.Size=UDim2.new(1,-8,1,-8); card.Position=UDim2.fromOffset(4,0); card.Parent=g
	UI.Card(card,Color3.fromRGB(255,247,236),16)
	local key=label.Name=="OwnerLabel" and "Cake" or (g.Parent.Name:find("Buy") and "Coins" or g.Parent.Name=="UpgradeConverter" and "Upgrade" or g.Parent.Name=="CollectIncome" and "Bank" or g.Parent.Name=="RobuxShop" and "Shop" or g.Parent.Name:find("Crate") and "Crates" or "Cake")
	UI.Icon(card,key,28,UDim2.new(0,8,.5,-14))
	label.Font=Enum.Font.FredokaOne; label.TextColor3=UI.Ink; label.TextScaled=true; label.BackgroundTransparency=1
	label.Position=UDim2.fromOffset(44,4); label.Size=UDim2.new(1,-56,1,-16); label.ZIndex=5
	local limit=Instance.new("UITextSizeConstraint"); limit.MaxTextSize=21; limit.MinTextSize=11; limit.Parent=label
end
function UI.Pad(pad,cash,cost,maxed)
	local affordable=cash~=nil and cash>=cost and not maxed
	pad:SetAttribute("Cost",cost); pad:SetAttribute("Affordable",affordable); pad:SetAttribute("Maxed",maxed==true)
	pad.Color=maxed and UI.Idle or cash==nil and UI.Idle or affordable and UI.Green or UI.Red
	local g=pad:FindFirstChild("ActionSign"); local card=g and g:FindFirstChild("BubbleCard")
	if card then card.BackgroundColor3=pad.Color; local icon=card:FindFirstChild("Icon"); if icon then icon.Image=UI.Icons[affordable and "Check" or "Lock"] end end
end
function UI.ApplyWorld(island)
	for _,d in ipairs(island:GetDescendants()) do if d:IsA("BillboardGui") then UI.Billboard(d) end end
	for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
		for _,pad in ipairs(plot.PurchaseButtons:GetChildren()) do local count=tonumber(pad.Name:match("Buy(%d+)")); if count then UI.Pad(pad,nil,count*require(script.Parent.TycoonConfig).PuddingCost) end end
		UI.Pad(plot.PersonalShopArea.UpgradeConverter,nil,require(script.Parent.TycoonConfig).CafeUpgradeBaseCost)
	end
	island:SetAttribute("UIStyleVersion",1); island:SetAttribute("MapVersion","13.0.0")
end
return UI
