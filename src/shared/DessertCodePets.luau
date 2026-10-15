-- Public presentation only. Redemption codes stay on the server.
local Pets={}
Pets.Order={"code:cookie-fish","code:chocolate-fish","code:rainbow-fish"}
Pets.Items={
	["code:cookie-fish"]={Name="Cookie Fish",Template="CookieFish",Offset=Vector2.new(0,0)},
	["code:chocolate-fish"]={Name="Chocolate Fish",Template="ChocolateFish",Offset=Vector2.new(512,0)},
	["code:rainbow-fish"]={Name="Rainbow Fish",Template="RainbowFish",Offset=Vector2.new(0,512)},
}
Pets.Atlas="rbxassetid://139938748808911"
function Pets.CreateImage(parent,key,size,pos)
	local spec=assert(Pets.Items[key])
	local image=Instance.new("ImageLabel");image.Name="CodePetImage";image.BackgroundTransparency=1
	image.Image=Pets.Atlas;image.ImageRectOffset=spec.Offset;image.ImageRectSize=Vector2.new(512,512)
	image.ScaleType=Enum.ScaleType.Fit;image.Size=size;image.Position=pos;image.ZIndex=parent.ZIndex+1;image.Parent=parent
	return image
end
return Pets
