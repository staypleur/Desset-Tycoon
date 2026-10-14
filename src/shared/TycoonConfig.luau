-- Configure real IDs only after creating products in this experience's Creator Dashboard.
local Config = {
	GiftInterval = 5 * 60 * 60,
	AFKInterval = 5 * 60 * 60,
	ProductionInterval = 3,
	PuddingCost = 5,
	Capacity = 60,
	HotTimeSeconds = 15 * 60,
	HotTimeMultiplier = 2,
	MusicId = "rbxassetid://88115288095261",
	ClickSoundId = "rbxasset://sounds/volume_slider.ogg",
	DiscoverySoundId = "rbxassetid://158050602",
	Products = {
		Normal1 = {Id=0, Price=9, Count=1, Crate="Normal"},
		Normal10 = {Id=0, Price=79, Count=10, Crate="Normal"},
		Perk1 = {Id=0, Price=29, Count=1, Crate="Perk"},
		Perk10 = {Id=0, Price=229, Count=10, Crate="Perk"},
		HotTime = {Id=0, Price=19},
	},
	Passes = {
		Boost12 = {Id=0, Price=9, Multiplier=1.2, Name="1.2x Mini Desserts"},
		Boost15 = {Id=0, Price=49, Multiplier=1.5, Name="1.5x Mini Desserts"},
		Boost2 = {Id=0, Price=149, Multiplier=2, Name="2x Mini Desserts"},
		Boost5 = {Id=0, Price=499, Multiplier=5, Name="5x Mini Desserts"},
		AutoMerge = {Id=0, Price=299, Name="Auto Merge"},
		Magnet = {Id=0, Price=99, Name="Magnet"},
		Luck = {Id=0, Price=399, Name="2x Shiny Chance"},
	},
}
return Config
