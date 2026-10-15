-- English display names; the first three tiers follow the latest economy specification.
local names = {
	"Pudding", "Custard", "Strawberry Jelly", "Shortcake", "Macaron", "Donut", "Egg Tart", "Cream Puff",
	"Macaron", "Salt Bread", "Cake", "Financier", "Canele", "Madeleine", "Souffle",
	"Parfait", "Roll Cake", "Crepe", "Shaved Ice", "Eclair", "Tiramisu", "Mont Blanc",
	"Panna Cotta", "Mille-Feuille", "Handmade Candy", "Pastel Potion", "Royal Tea Pudding",
	"Macaron Tower", "Moonlight Sugar Castle", "Parfait Dragon",
}
local tiers = {}
for tier, name in ipairs(names) do
	tiers[tier] = table.freeze({
		Tier = tier,
		Name = name,
		MergeCount = 3,
		NextTier = tier < #names and tier + 1 or nil,
		PuddingEquivalent = 3 ^ (tier - 1),
	})
end
return table.freeze(tiers)
