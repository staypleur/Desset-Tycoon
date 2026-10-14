-- User-supplied UI, packed without design changes. Source mapping: assets/ui/manifest.json.
local Art={}
local Config=require(script.Parent.TycoonConfig)
local rects={
	MultiplierIcon={2,0,512},
	Boost12={1,0,0},
	Boost15={1,256,0},
	Boost2={1,512,0},
	Boost3={1,768,0},
	Boost4={1,0,256},
	Boost5={1,256,256},
	AutoMerge={1,512,256},
	MoneyMagnet={1,768,256},
	DessertMagnet={1,0,512},
	Luck12={1,256,512},
	Luck15={1,512,512},
	Luck2={1,768,512},
	Speed12={1,0,768},
	Speed15={1,256,768},
	Speed3={1,512,768},
	Speed2={1,768,768},
	NormalCrate={2,0,0},
	ShinyIcon={2,256,0},
	CashIcon={2,512,0},
	IndexIcon={2,0,256},
	ShopIcon={2,256,256},
	PerkCrate={2,512,256},
}
function Art.Create(parent,key,size,pos)
 local r=assert(rects[key],"Unknown user icon"); local image=Instance.new("ImageLabel")
 image.Name="UserArt"..key; image.BackgroundTransparency=1; image.Image=Config.UserAtlasIds[r[1]]
 image.ImageRectOffset=Vector2.new(r[2],r[3]); image.ImageRectSize=Vector2.new(256,256); image.ScaleType=Enum.ScaleType.Fit
 image.Size=size or UDim2.fromScale(1,1); image.Position=pos or UDim2.new(); image.ZIndex=parent.ZIndex+1; image.Parent=parent
 image:SetAttribute("UserIcon",key); return image
end
return Art
