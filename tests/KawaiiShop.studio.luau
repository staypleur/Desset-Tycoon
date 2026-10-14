-- Run in the Play client after opening Shop using the actual HUD/building prompt.
local player=game.Players.LocalPlayer
local shop=player.PlayerGui.DessertHUD:FindFirstChild('KawaiiShopWindow')
assert(shop,'Open the actual Shop first')
local cards=shop.ProductCards
local expected={Boost12=9,Boost15=49,Boost2=149,Boost5=499,AutoMerge=299,Magnet=99,Luck=399,HotTime=19}
local count=0
for key,price in pairs(expected) do
 local card=cards:FindFirstChild(key); assert(card and card:IsA('Frame'),key)
 assert(card.RobuxPrice.Text==price..' R$')
 assert(card.Purchase:GetAttribute('ProductId')==0 and not card.Purchase.Active)
 assert(card.Purchase.PurchaseLabel.Text=='COMING SOON')
 assert(card.ProductName.Text~='' and card.Description.Text~='')
 count+=1
end
assert(count==8)
for _,image in ipairs(shop:GetDescendants()) do if image:IsA('ImageLabel') and image.Name:find('Kawaii') then
 assert(image.Image=='rbxassetid://82678981874379')
end end
-- Offscreen scrolling cards may not request textures until they become visible.
for _,image in ipairs({shop.WindowCrop.KawaiiWindow,cards.Boost12.PictureCrop.KawaiiPicture,cards.Boost12.Purchase.ButtonCrop.KawaiiButton}) do
 for _=1,8 do if image.IsLoaded then break end; task.wait(.5) end
 assert(image.IsLoaded,'Visible free atlas did not render')
end
local w=workspace.CurrentCamera.ViewportSize.X-24
assert(shop:GetAttribute('Columns')==(w>=840 and 3 or w>=520 and 2 or 1))
assert(shop.AbsoluteSize.X<=workspace.CurrentCamera.ViewportSize.X)
assert(cards.AbsoluteCanvasSize.Y>cards.AbsoluteSize.Y,'All eight cards must be scrollable')
print('[KawaiiShopTest] PASS: eight English cards, correct prices, loaded free atlas, responsive columns and locked unconfigured purchases')
