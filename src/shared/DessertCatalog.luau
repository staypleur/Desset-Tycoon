-- English display names; the first three tiers follow the latest economy specification.
local names = {
	"Pudding", "Custard", "Strawberry Jelly", "Shortcake", "Macaron", "Croissant", "Waffle", "Patbingsu",
	"Tiramisu Cake", "Madeleine", "Eclair", "Panna Cotta", "Souffle Pancake", "Wagashi", "Cheesecake",
	"Financier", "Croffle", "Gelato", "Crepe", "Churro", "Chiffon Cake Slice", "Cookie", "Cream Puff Profiterole", "Creme Brulee", "Donut", "Egg Tart", "Scone", "Brownie", "Crepe", "Mont Blanc",
}
-- User labels: tier 19 = 크레이프; tier 29 = 크레페. Both translate to Crepe.
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
