-- Original pastel components with free Laurel / Tabler MIT icons.
-- Attribution and MIT notice: docs/LAUREL-LICENSE.txt, docs/ASSETS.md.
local UI={}
local UserArt=require(script.Parent.UserArt)
UI.Icons={Coins="rbxassetid://74778137045475",Index="rbxassetid://82382233309285",
	Settings="rbxassetid://123802788977158",Shop="rbxassetid://136213874647182",
	Crates="rbxassetid://123119869662551",Cake="rbxassetid://127893549827766",
	Sparkles="rbxassetid://74659718515937",Bank="rbxassetid://110036223487911",
	Cafe="rbxassetid://84687926049338",Close="rbxassetid://119058583962559",
	Upgrade="rbxassetid://119889402592837",Check="rbxassetid://129170135048823",Lock="rbxassetid://128255973855104"}
-- Approved Hapy UI v1 free artwork; names below match the visible art, rather
-- than relying on inconsistent names in the source pack.
UI.Hapy={Stats="rbxassetid://17136126657",Index="rbxassetid://17136645041",
	Shop="rbxassetid://17136790643",Close="rbxassetid://17136872736",
	Window="rbxassetid://17136988296",Inventory="rbxassetid://17137717840"}
UI.Icons.Index=UI.Hapy.Index; UI.Icons.Shop=UI.Hapy.Shop; UI.Icons.Close=UI.Hapy.Close
UI.Green=Color3.fromRGB(156,235,81)
UI.Red=Color3.fromRGB(243,91,113)
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
	local custom={["Join Group"]="GroupJoin",Coins="CashIcon",Index="IndexIcon",Shop="ShopIcon",Crates="NormalCrate",Sparkles="ShinyIcon",Multiplier="MultiplierIcon"}
	if custom[key] then return UserArt.Create(parent,custom[key],UDim2.fromOffset(size,size),pos) end
	local image=Instance.new("ImageLabel"); image.Name="Icon"; image.BackgroundTransparency=1; image.Image=UI.Icons[key] or UI.Icons.Cake
	image.ImageColor3=UI.Hapy[key] and Color3.new(1,1,1) or UI.Ink; image.Size=UDim2.fromOffset(size,size); image.Position=pos; image.ZIndex=parent.ZIndex+1; image.Parent=parent; return image
end
function UI.Art(parent,key)
	local art=Instance.new("ImageLabel"); art.Name="HapyArtwork"; art.Image=assert(UI.Hapy[key]); art.BackgroundTransparency=1
	art.Size=UDim2.fromScale(1,1); art.ScaleType=Enum.ScaleType.Stretch; art.ZIndex=parent.ZIndex; art.Parent=parent
	parent.BackgroundTransparency=1
	local stroke=parent:FindFirstChild("CreamOutline"); if stroke then stroke.Enabled=false end
	return art
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
	if g:GetAttribute("DessertLabelVersion")==2 then return end
	local label=g:FindFirstChildOfClass("TextLabel"); if not label then return end
	for _,child in ipairs(g:GetChildren()) do if child~=label then child:Destroy() end end
	label:ClearAllChildren(); g:SetAttribute("DessertLabelVersion",2); g.MaxDistance=45; g.AlwaysOnTop=false
	g.Size=UDim2.fromOffset(label.Name=="OwnerLabel" and 170 or 138,label.Name=="OwnerLabel" and 28 or 48)
	g.StudsOffset=Vector3.new(0,2.5,0)
	label.Font=Enum.Font.GothamBold; label.TextColor3=Color3.fromRGB(255,253,246); label.TextScaled=true; label.BackgroundTransparency=1
	label.Position=UDim2.new(); label.Size=UDim2.fromScale(1,1); label.ZIndex=2
	local outline=Instance.new("UIStroke"); outline.Color=Color3.fromRGB(42,31,43); outline.Thickness=2; outline.Parent=label
	local limit=Instance.new("UITextSizeConstraint"); limit.MaxTextSize=18; limit.MinTextSize=10; limit.Parent=label
	local price=label:Clone(); price.Name="PriceLabel"; price.Text=""; price.Font=Enum.Font.GothamBlack; price.TextColor3=UI.Green; price.Parent=g
	local caption,detail=label.Text:match("([^\n]*)\n?(.*)"); UI.Label(g.Parent,caption,detail)
end
function UI.Label(pad,caption,detail,color)
	local g=pad:FindFirstChild("ActionSign"); if not g then return end
	local label=g:FindFirstChildOfClass("TextLabel"); local price=g:FindFirstChild("PriceLabel")
	if not label or not price then return end
	label.Text=caption; price.Text=detail or ""; price.TextColor3=color or UI.Green
	label.Size=UDim2.fromScale(1,price.Text~="" and .46 or 1)
	price.Position=UDim2.fromScale(0,.46); price.Size=UDim2.fromScale(1,.54)
end
function UI.Format(n)
	for _,unit in ipairs({{1e12,"T"},{1e9,"B"},{1e6,"M"},{1e3,"K"}}) do if n>=unit[1] then return string.format("%.1f%s",n/unit[1],unit[2]) end end
	return math.abs(n-math.floor(n))>.00001 and string.format("%.1f",n) or string.format("%.0f",n)
end
function UI.ResizeWorld(root,viewportWidth)
	local scale=math.clamp(viewportWidth/1280,.65,1)
	for _,g in ipairs(root:GetDescendants()) do if g:IsA("BillboardGui") and g:GetAttribute("DessertLabelVersion")==2 then
		local label=g:FindFirstChild("OwnerLabel"); g.Size=UDim2.fromOffset((label and 170 or 138)*scale,(label and 28 or 48)*scale)
	end end
end
function UI.Pad(pad,cash,cost,maxed)
	local affordable=cash~=nil and cash>=cost and not maxed
	pad:SetAttribute("Cost",cost); pad:SetAttribute("Affordable",affordable); pad:SetAttribute("Maxed",maxed==true)
	pad.Color=maxed and UI.Idle or cash==nil and UI.Idle or affordable and UI.Green or UI.Red
	local top=pad:FindFirstChild("ButtonTop")
	if top then for _,p in ipairs(top:GetDescendants()) do if p:IsA("BasePart") then p.Color=pad.Color; p.Material=Enum.Material.Neon end end end
	local g=pad:FindFirstChild("ActionSign"); local price=g and g:FindFirstChild("PriceLabel")
	if price then price.TextColor3=pad.Color end
end
function UI.ApplyWorld(island)
	for _,d in ipairs(island:GetDescendants()) do if d:IsA("BillboardGui") then UI.Billboard(d) end end
	for _,plot in ipairs(island.PlayerPlots:GetChildren()) do
		for _,pad in ipairs(plot.PurchaseButtons:GetChildren()) do local count=tonumber(pad.Name:match("Buy(%d+)")); if count then
			local cost=require(script.Parent.DessertRules).BuyCost(count); UI.Pad(pad,nil,cost); UI.Label(pad,"Buy "..count,"$"..UI.Format(cost),UI.Idle)
		end end
		UI.Pad(plot.PersonalShopArea.UpgradeConverter,nil,require(script.Parent.TycoonConfig).CafeUpgradeBaseCost)
		UI.Label(plot.PersonalShopArea.UpgradeConverter,"Upgrade","+2 / sec | $60",UI.Idle)
		UI.Label(plot.PersonalShopArea.CollectIncome,"Collect Cash","$0 | $1 / sec",UI.Green)
		UI.Label(plot.PersonalShopArea.RobuxShop,"Shop","Hold E",Color3.fromRGB(255,231,169))
		UI.Label(plot.MergeBoard,"Merge","")
	end
	island:SetAttribute("UIStyleVersion",2); island:SetAttribute("MapVersion","15.0.0")
end
return UI
