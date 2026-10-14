-- Approved ToffeeCraft Pastel Dream FREE art; legacy module name retained.
-- Raw atlas stays local; shared rendering is in PastelArt.
local Shop={}
local Art=require(script.Parent.PastelArt)
local Market=game:GetService('MarketplaceService')
local Tween=game:GetService('TweenService')
local Config=require(script.Parent.TycoonConfig)
local Style=require(script.Parent.DessertUI)
local UserArt=require(script.Parent.UserArt)
local Rules=require(script.Parent.DessertRules)
local ink=Color3.fromRGB(105,62,88)
local cream=Color3.fromRGB(255,242,233)
local function productsFor(data)
 local owned=data.OwnedPasses or {}; local items={}
 for _,group in ipairs({'Production','Luck','Speed'}) do
  local key=Rules.NextPass(owned,group)
  if key then table.insert(items,{Key=key}) else
   local tiers=group=='Production' and Config.ProductionTiers or group=='Speed' and Config.SpeedTiers or Config.LuckTiers
   table.insert(items,{Key=tiers[#tiers]})
  end
 end
 for _,key in ipairs({'AutoMerge','DessertMagnet','MoneyMagnet'}) do table.insert(items,{Key=key}) end
 return items
end
local function label(parent,name,value,size,pos,fontSize)
 local t=Instance.new('TextLabel'); t.Name=name; t.BackgroundTransparency=1; t.Text=value; t.TextColor3=ink
 t.Font=Enum.Font.FredokaOne; t.TextSize=fontSize; t.TextWrapped=true; t.Size=size; t.Position=pos; t.ZIndex=parent.ZIndex+2; t.Parent=parent
 return t
end
local function sprite(parent,key,size,pos)
 local mapped=key=="Window" and "Panel" or key=="Picture" and "Card" or "Button"
 local art=Art.Image(parent,mapped,size,pos); art.ZIndex=parent.ZIndex+1
 art.Atlas.ZIndex=art.ZIndex
 return art.Atlas
end
function Shop.Open(parent,data,callbacks)
 local backdrop=Instance.new('Frame'); backdrop.Name='KawaiiShopBackdrop'; backdrop.Size=UDim2.fromScale(1,1)
 backdrop.BackgroundColor3=Color3.fromRGB(106,67,94); backdrop.BackgroundTransparency=.48; backdrop.BorderSizePixel=0; backdrop.ZIndex=9; backdrop.Parent=parent
 local root=Instance.new('Frame'); root.Name='KawaiiShopWindow'; root.AnchorPoint=Vector2.new(.5,.5); root.Position=UDim2.fromScale(.5,.5)
 root.BackgroundColor3=cream; root.BorderSizePixel=0; root.ZIndex=10; root.Parent=parent
 local rootRound=Instance.new('UICorner'); rootRound.CornerRadius=UDim.new(0,24); rootRound.Parent=root
 local outline=Instance.new('UIStroke'); outline.Color=Color3.fromRGB(244,187,212); outline.Thickness=3; outline.Parent=root
 sprite(root,'Window',UDim2.new(1,-16,1,-16),UDim2.fromOffset(8,8))
 sprite(root,'Button',UDim2.fromOffset(280,58),UDim2.new(.5,-140,0,-18))
 local title=label(root,'ShopTitle','SHOP',UDim2.fromOffset(280,58),UDim2.new(.5,-140,0,-18),26)
 local close=Instance.new('TextButton'); close.Name='CloseShop'; close.Text='×'; close.Font=Enum.Font.GothamBlack; close.TextSize=30; close.TextColor3=ink
 close.BackgroundColor3=Color3.fromRGB(255,196,223); close.Size=UDim2.fromOffset(38,38); close.AnchorPoint=Vector2.new(1,0); close.Position=UDim2.new(1,-20,0,20); close.ZIndex=18; close.Parent=root
 local round=Instance.new('UICorner'); round.CornerRadius=UDim.new(0,12); round.Parent=close
 local scrolling=Instance.new('ScrollingFrame'); scrolling.Name='ProductCards'; scrolling.BackgroundTransparency=1; scrolling.BorderSizePixel=0
 scrolling.Position=UDim2.fromOffset(24,82); scrolling.Size=UDim2.new(1,-48,1,-124); scrolling.ScrollBarThickness=5
 scrolling.ScrollBarImageColor3=Color3.fromRGB(225,140,182); scrolling.AutomaticCanvasSize=Enum.AutomaticSize.Y; scrolling.CanvasSize=UDim2.new(); scrolling.ZIndex=12; scrolling.Parent=root
 local grid=Instance.new('UIGridLayout'); grid.CellPadding=UDim2.fromOffset(12,12); grid.SortOrder=Enum.SortOrder.LayoutOrder; grid.Parent=scrolling
 local padding=Instance.new('UIPadding'); padding.PaddingRight=UDim.new(0,8); padding.PaddingBottom=UDim.new(0,10); padding.Parent=scrolling
 local foot=label(root,'BoostRule','∞ Permanent',UDim2.new(1,-52,0,26),UDim2.new(0,26,1,-34),13)
 local disposed=false; local resizeConnection
 local function destroy()
  if disposed then return end; disposed=true
  if resizeConnection then resizeConnection:Disconnect() end
  root:Destroy(); backdrop:Destroy()
 end
 close.Activated:Connect(function() callbacks.Click(); destroy(); callbacks.Close() end)
 for n,item in ipairs(productsFor(data)) do
  local spec=item.Product and Config.Products[item.Key] or Config.Passes[item.Key]
  local card=Instance.new('Frame'); card.Name=item.Key; card.LayoutOrder=n; card.BackgroundColor3=cream; card.BorderSizePixel=0; card.ZIndex=13; card.Parent=scrolling
  local curve=Instance.new('UICorner'); curve.CornerRadius=UDim.new(0,18); curve.Parent=card
  local border=Instance.new('UIStroke'); border.Color=Color3.fromRGB(246,192,208); border.Thickness=2; border.Parent=card
  UserArt.Create(card,item.Key,UDim2.new(1,-24,0,150),UDim2.fromOffset(12,10))
  label(card,'ProductName',spec.Name,UDim2.new(1,-24,0,34),UDim2.fromOffset(12,162),18)
  local badge=label(card,'Badge','∞',UDim2.fromOffset(30,24),UDim2.new(1,-40,0,12),20)
  local price=label(card,'RobuxPrice',spec.Price..' Robux',UDim2.new(.43,-12,0,38),UDim2.new(0,12,1,-46),19); price.TextXAlignment=Enum.TextXAlignment.Left
  local purchase=Instance.new('TextButton'); purchase.Name='Purchase'; purchase.Text=''; purchase.BackgroundTransparency=1
  purchase.Size=UDim2.new(.55,-12,0,38); purchase.Position=UDim2.new(.45,0,1,-46); purchase.ZIndex=16; purchase.Parent=card
  local art=sprite(purchase,'Button',UDim2.fromScale(1,1),UDim2.new()); art.ZIndex=16
  local buttonText=label(purchase,'PurchaseLabel','BUY',UDim2.fromScale(1,1),UDim2.new(),14); buttonText.ZIndex=17
  local owned=data.OwnedPasses or {}
  local available=spec.Id~=0 and data.Durable and Rules.CanBuyPass(owned,item.Key) and not (spec.Group=='Luck' and data.Restricted)
  purchase:SetAttribute('ProductId',spec.Id); purchase:SetAttribute('Purchasable',available==true); purchase.Active=available==true; purchase.AutoButtonColor=false
  if not available then buttonText.Text=owned[item.Key] and 'OWNED' or 'LOCKED'; art.ImageTransparency=.35 end
  purchase.Activated:Connect(function()
   if not available or disposed then return end
   callbacks.Click(); callbacks.Purchase(item.Key)
  end)
  if available then
   purchase.MouseEnter:Connect(function() Tween:Create(art,TweenInfo.new(.12),{ImageColor3=Color3.fromRGB(255,237,246)}):Play() end)
   purchase.MouseLeave:Connect(function() Tween:Create(art,TweenInfo.new(.12),{ImageColor3=Color3.new(1,1,1)}):Play() end)
   task.spawn(function()
    local ok,info=pcall(Market.GetProductInfoAsync,Market,spec.Id,item.Product and Enum.InfoType.Product or Enum.InfoType.GamePass)
    if ok and not disposed then price.Text=tostring(info.PriceInRobux)..' Robux' end
   end)
  end
 end
 local function layout()
  if disposed then return end
  local v=workspace.CurrentCamera.ViewportSize; local inset=game:GetService('GuiService'):GetGuiInset()
  local w=math.max(230,math.min(940,v.X-24)); local h=math.max(250,math.min(660,v.Y-inset.Y-24))
  root.Size=UDim2.fromOffset(w,h); local columns=w>=840 and 3 or w>=520 and 2 or 1
  local height=math.clamp(math.floor((h-148)/2),194,248)
  grid.FillDirectionMaxCells=columns; grid.CellSize=UDim2.fromOffset(math.floor((w-56-(columns-1)*12)/columns),height)
  for _,card in ipairs(scrolling:GetChildren()) do if card:IsA('Frame') then
   card['UserArt'..card.Name].Size=UDim2.new(1,-24,0,height-98)
   card.ProductName.Position=UDim2.fromOffset(12,height-84)
  end end
  title.TextSize=w<450 and 22 or 26; foot.TextSize=w<450 and 11 or 13
  root:SetAttribute('Columns',columns)
 end
 layout(); resizeConnection=workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(layout)
 return {Root=root,Destroy=destroy}
end
return Shop
