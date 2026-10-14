-- Approved ToffeeCraft Pastel Dream FREE art; legacy module name retained.
-- Raw atlas stays local; shared rendering is in PastelArt.
local Shop={}
local Art=require(script.Parent.PastelArt)
local Market=game:GetService('MarketplaceService')
local Tween=game:GetService('TweenService')
local Config=require(script.Parent.TycoonConfig)
local Style=require(script.Parent.DessertUI)
local ink=Color3.fromRGB(105,62,88)
local cream=Color3.fromRGB(255,242,233)
local products={
 {Key='Boost12',Name='1.2x Production',Description='Collect 20% more mini desserts.',Tier=1,Badge='1.2x'},
 {Key='Boost15',Name='1.5x Production',Description='Collect 50% more mini desserts.',Tier=2,Badge='1.5x'},
 {Key='Boost2',Name='2x Production',Description='Collect twice as many mini desserts.',Tier=3,Badge='2x'},
 {Key='Boost5',Name='5x Production',Description='Collect five times as many mini desserts.',Tier=5,Badge='5x'},
 {Key='AutoMerge',Name='Auto Merge',Description='Automatically merge matching desserts.',Icon='Cake',Badge='AUTO'},
 {Key='Magnet',Name='Magnet',Description='Collect mini desserts from farther away.',Icon='Sparkles',Badge='PICKUP'},
 {Key='Luck',Name='Shiny Luck',Description='Double your shiny dessert chance.',Icon='Sparkles',Badge='2x LUCK'},
 {Key='HotTime',Name='Cash Hot Time',Description='Double cash conversion for 15 minutes.',Icon='Coins',Badge='15 MIN',Product=true},
}
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
 local foot=label(root,'BoostRule','Production boosts use your highest multiplier.',UDim2.new(1,-52,0,26),UDim2.new(0,26,1,-34),13)
 local disposed=false; local resizeConnection
 local function destroy()
  if disposed then return end; disposed=true
  if resizeConnection then resizeConnection:Disconnect() end
  root:Destroy(); backdrop:Destroy()
 end
 close.Activated:Connect(function() callbacks.Click(); destroy(); callbacks.Close() end)
 for n,item in ipairs(products) do
  local spec=item.Product and Config.Products[item.Key] or Config.Passes[item.Key]
  local card=Instance.new('Frame'); card.Name=item.Key; card.LayoutOrder=n; card.BackgroundColor3=cream; card.BorderSizePixel=0; card.ZIndex=13; card.Parent=scrolling
  local curve=Instance.new('UICorner'); curve.CornerRadius=UDim.new(0,18); curve.Parent=card
  local border=Instance.new('UIStroke'); border.Color=Color3.fromRGB(246,192,208); border.Thickness=2; border.Parent=card
  local picture=sprite(card,'Picture',UDim2.new(1,-24,0,102),UDim2.fromOffset(12,10)); picture.ImageTransparency=.2
  if item.Tier then callbacks.Preview(card,item.Tier,UDim2.new(1,-24,0,105),UDim2.fromOffset(12,8))
  else local icon=Style.Icon(card,item.Icon,62,UDim2.new(.5,-31,0,28)); icon.ZIndex=16 end
  local badge=label(card,'Badge',item.Badge,UDim2.fromOffset(84,24),UDim2.new(1,-94,0,14),13); badge.TextColor3=Color3.fromRGB(137,67,112)
  label(card,'ProductName',item.Name,UDim2.new(1,-24,0,34),UDim2.fromOffset(12,118),20)
  label(card,'Description',item.Description,UDim2.new(1,-24,0,44),UDim2.fromOffset(12,151),14)
  local price=label(card,'RobuxPrice',spec.Price..' R$',UDim2.new(.43,-12,0,38),UDim2.new(0,12,1,-46),19); price.TextXAlignment=Enum.TextXAlignment.Left
  local purchase=Instance.new('TextButton'); purchase.Name='Purchase'; purchase.Text=''; purchase.BackgroundTransparency=1
  purchase.Size=UDim2.new(.55,-12,0,38); purchase.Position=UDim2.new(.45,0,1,-46); purchase.ZIndex=16; purchase.Parent=card
  local art=sprite(purchase,'Button',UDim2.fromScale(1,1),UDim2.new()); art.ZIndex=16
  local buttonText=label(purchase,'PurchaseLabel','BUY',UDim2.fromScale(1,1),UDim2.new(),14); buttonText.ZIndex=17
  local available=spec.Id~=0 and data.Durable and not (item.Key=='Luck' and data.Restricted)
  purchase:SetAttribute('ProductId',spec.Id); purchase:SetAttribute('Purchasable',available==true); purchase.Active=available==true; purchase.AutoButtonColor=false
  if not available then buttonText.Text='COMING SOON'; art.ImageTransparency=.35 end
  purchase.Activated:Connect(function()
   if not available or disposed then return end
   callbacks.Click(); callbacks.Purchase(item.Key)
  end)
  if available then
   purchase.MouseEnter:Connect(function() Tween:Create(art,TweenInfo.new(.12),{ImageColor3=Color3.fromRGB(255,237,246)}):Play() end)
   purchase.MouseLeave:Connect(function() Tween:Create(art,TweenInfo.new(.12),{ImageColor3=Color3.new(1,1,1)}):Play() end)
   task.spawn(function()
    local ok,info=pcall(Market.GetProductInfoAsync,Market,spec.Id,item.Product and Enum.InfoType.Product or Enum.InfoType.GamePass)
    if ok and not disposed then price.Text=tostring(info.PriceInRobux)..' R$' end
   end)
  end
 end
 local function layout()
  if disposed then return end
  local v=workspace.CurrentCamera.ViewportSize; local inset=game:GetService('GuiService'):GetGuiInset()
  local w=math.max(230,math.min(940,v.X-24)); local h=math.max(250,math.min(660,v.Y-inset.Y-24))
  root.Size=UDim2.fromOffset(w,h); local columns=w>=840 and 3 or w>=520 and 2 or 1
  grid.FillDirectionMaxCells=columns; grid.CellSize=UDim2.fromOffset(math.floor((w-56-(columns-1)*12)/columns),248)
  title.TextSize=w<450 and 22 or 26; foot.TextSize=w<450 and 11 or 13
  root:SetAttribute('Columns',columns)
 end
 layout(); resizeConnection=workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(layout)
 return {Root=root,Destroy=destroy}
end
return Shop
