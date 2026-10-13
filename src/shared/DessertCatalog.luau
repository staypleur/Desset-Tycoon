-- Design catalog only. No prices, production, models or merge gameplay yet.
local names = {
	"푸딩", "젤리", "커스터드", "브라우니", "쿠키", "도넛", "에그타르트", "슈크림",
	"마카롱", "소금빵", "케이크", "휘낭시에", "까눌레", "마들렌", "수플레",
	"파르페", "롤케이크", "크레페", "빙수", "에클레어", "티라미수", "몽블랑",
	"판나코타", "밀푀유", "수제캔디", "파스텔포션", "로열 홍차 푸딩",
	"마카롱 타워", "달빛 슈가 성", "페르페 용",
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
