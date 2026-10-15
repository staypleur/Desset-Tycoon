-- One transparent atlas shared by the index, carousel and result summaries.
-- Add user-supplied images here as the remaining dessert models arrive.
local Rules=require(script.Parent.DessertRules)
local Catalog=require(script.Parent.DessertCatalog)
local UserArt=require(script.Parent.UserArt)
local Images={Atlas="rbxassetid://140655109036421",CustardAtlas="rbxassetid://117870878192537",JellyAtlas="rbxassetid://78200800148968",ShortcakeAtlas="rbxassetid://96411714992673",MacaronAtlas="rbxassetid://81932094548604",CroissantAtlas="rbxassetid://101676992338599",WaffleAtlas="rbxassetid://91766508733195",BingsuAtlas="rbxassetid://91644959397587",TiramisuAtlas="rbxassetid://110416862812071",MadeleineAtlas="rbxassetid://112960015006578",EclairAtlas="rbxassetid://91034076326961",PannaAtlas="rbxassetid://92406130456099",SouffleAtlas="rbxassetid://84736068710282",WagashiAtlas="rbxassetid://117055066619950",CheesecakeAtlas="rbxassetid://108637796798942",FinancierAtlas="rbxassetid://139647408954483"}
local rects={['1n']={0,0},['1s']={512,0},['1s2']={0,512},['2n']={512,512},['2s']={0,0,2},['2s2']={512,0,2},['3n']={0,0,3},['3s']={512,0,3},['3s2']={0,512,3},['4n']={0,0,4},['4s']={512,0,4},['4s2']={0,512,4},['5n']={0,0,5},['5s']={512,0,5},['5s2']={0,512,5},['6n']={0,0,6},['6s']={512,0,6},['6s2']={0,512,6},['7n']={0,0,7},['7s']={512,0,7},['7s2']={0,512,7},['8n']={0,0,8},['8s']={512,0,8},['8s2']={0,512,8},['9n']={0,0,9},['9s']={512,0,9},['9s2']={0,512,9},['10n']={0,0,10},['10s']={512,0,10},['10s2']={0,512,10},['11n']={0,0,11},['11s']={512,0,11},['11s2']={0,512,11},['12n']={0,0,12},['12s']={512,0,12},['12s2']={0,512,12},['13n']={0,0,13},['13s']={512,0,13},['13s2']={0,512,13},['14n']={0,0,14},['14s']={512,0,14},['14s2']={0,512,14},['15n']={0,0,15},['15s']={512,0,15},['15s2']={0,512,15},['16n']={0,0,16},['16s']={512,0,16},['16s2']={0,512,16}}
function Images.Name(tier,shiny,variant)
	if tier==1 and shiny then return variant==2 and "Galaxy Aurora Pudding" or "Milky Pudding" end
	if tier==2 and shiny then return variant==2 and "Dark Choco Custard" or "Rainbow Cotton Candy Custard" end
	if tier==3 and shiny then return variant==2 and "Strawberry Mint Ruby Crystal Jelly" or "Strawberry Mint Sherbet Jelly" end
	if tier==4 and shiny then return variant==2 and "Rainbow Unicorn Shortcake" or "Galaxy Aurora Shortcake" end
	if tier==5 and shiny then return variant==2 and "Pink Gold Dark Macaron" or "Crystal Gem Macaron" end
	if tier==6 and shiny then return variant==2 and "Pink Quartz Rose Gold Croissant" or "Galaxy Crescent Croissant" end
	if tier==7 and shiny then return variant==2 and "Pink Dark Choco Honey Waffle" or "Cotton Candy Unicorn Waffle" end
	if tier==8 and shiny then return variant==2 and "Mango Bingsu" or "Extra Red Bean Bingsu" end
	if tier==9 and shiny then return variant==2 and "Pink Quartz Rose Gold Tiramisu Cake" or "Prism Cube Tiramisu Cake" end
	if tier==10 and shiny then return variant==2 and "Mint Ocean Crystal Madeleine" or "Pearl Prism Madeleine" end
	if tier==11 and shiny then return variant==2 and "Galaxy Aurora Eclair" or "Pink Quartz Rose Gold Eclair" end
	if tier==12 and shiny then return variant==2 and "Mint Ocean Crystal Panna Cotta" or "Ruby Strawberry Panna Cotta" end
	if tier==13 and shiny then return variant==2 and "Black Hole Choco Souffle Pancake" or "Sakura Souffle Pancake" end
	if tier==14 and shiny then return variant==2 and "Dark Choco Gold Wagashi" or "Mint Emerald Crystal Wagashi" end
	if tier==15 and shiny then return variant==2 and "Mint Ocean Emerald Cheesecake" or "Ruby Blueberry Cheesecake" end
	if tier==16 and shiny then return variant==2 and "Pink Quartz Financier" or "Pure Gold Financier" end
	return (shiny and "Shiny " or "")..Catalog[tier].Name
end
function Images.Create(parent,tier,shiny,variant,size,pos)
	local key=Rules.Key(tier,shiny,variant); local rect=rects[key]
	local image
	if rect then
		image=Instance.new("ImageLabel"); image.BackgroundTransparency=1; image.Image=rect[3]==16 and Images.FinancierAtlas or rect[3]==15 and Images.CheesecakeAtlas or rect[3]==14 and Images.WagashiAtlas or rect[3]==13 and Images.SouffleAtlas or rect[3]==12 and Images.PannaAtlas or rect[3]==11 and Images.EclairAtlas or rect[3]==10 and Images.MadeleineAtlas or rect[3]==9 and Images.TiramisuAtlas or rect[3]==8 and Images.BingsuAtlas or rect[3]==7 and Images.WaffleAtlas or rect[3]==6 and Images.CroissantAtlas or rect[3]==5 and Images.MacaronAtlas or rect[3]==4 and Images.ShortcakeAtlas or rect[3]==3 and Images.JellyAtlas or rect[3]==2 and Images.CustardAtlas or Images.Atlas
		image.ImageRectOffset=Vector2.new(rect[1],rect[2]); image.ImageRectSize=Vector2.new(512,512)
		image.ScaleType=Enum.ScaleType.Fit; image.Size=size; image.Position=pos or UDim2.new()
		image.ZIndex=parent.ZIndex+1; image.Parent=parent
	else
		-- Reuse approved generic art until this tier's reference image is supplied.
		image=UserArt.Create(parent,"DessertMagnet",size,pos)
	end
	image.Name="DessertImage"; image:SetAttribute("DessertKey",key); return image
end
return Images
