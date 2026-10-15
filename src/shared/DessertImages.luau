-- One transparent atlas shared by the index, carousel and result summaries.
-- Add user-supplied images here as the remaining dessert models arrive.
local Rules=require(script.Parent.DessertRules)
local Catalog=require(script.Parent.DessertCatalog)
local UserArt=require(script.Parent.UserArt)
local Images={Atlas="rbxassetid://140655109036421",CustardAtlas="rbxassetid://117870878192537",JellyAtlas="rbxassetid://78200800148968",ShortcakeAtlas="rbxassetid://96411714992673",MacaronAtlas="rbxassetid://81932094548604",CroissantAtlas="rbxassetid://101676992338599",WaffleAtlas="rbxassetid://91766508733195",BingsuAtlas="rbxassetid://91644959397587",TiramisuAtlas="rbxassetid://110416862812071",MadeleineAtlas="rbxassetid://112960015006578"}
local rects={['1n']={0,0},['1s']={512,0},['1s2']={0,512},['2n']={512,512},['2s']={0,0,2},['2s2']={512,0,2},['3n']={0,0,3},['3s']={512,0,3},['3s2']={0,512,3},['4n']={0,0,4},['4s']={512,0,4},['4s2']={0,512,4},['5n']={0,0,5},['5s']={512,0,5},['5s2']={0,512,5},['6n']={0,0,6},['6s']={512,0,6},['6s2']={0,512,6},['7n']={0,0,7},['7s']={512,0,7},['7s2']={0,512,7},['8n']={0,0,8},['8s']={512,0,8},['8s2']={0,512,8},['9n']={0,0,9},['9s']={512,0,9},['9s2']={0,512,9},['10n']={0,0,10},['10s']={512,0,10},['10s2']={0,512,10}}
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
	return (shiny and "Shiny " or "")..Catalog[tier].Name
end
function Images.Create(parent,tier,shiny,variant,size,pos)
	local key=Rules.Key(tier,shiny,variant); local rect=rects[key]
	local image
	if rect then
		image=Instance.new("ImageLabel"); image.BackgroundTransparency=1; image.Image=rect[3]==10 and Images.MadeleineAtlas or rect[3]==9 and Images.TiramisuAtlas or rect[3]==8 and Images.BingsuAtlas or rect[3]==7 and Images.WaffleAtlas or rect[3]==6 and Images.CroissantAtlas or rect[3]==5 and Images.MacaronAtlas or rect[3]==4 and Images.ShortcakeAtlas or rect[3]==3 and Images.JellyAtlas or rect[3]==2 and Images.CustardAtlas or Images.Atlas
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
