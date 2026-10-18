local Rules=require(game.ReplicatedStorage.DessertRules)
local Config=require(game.ReplicatedStorage.TycoonConfig)
assert(Config.GiftInterval==18000 and Config.AFKInterval==18000)
local d=Rules.New(100)
assert(not Rules.Gift(d,18099,true))
assert(d.NormalTokens==0 and d.PerkTokens==0)
assert(Rules.Gift(d,18100,true))
assert(d.NormalTokens==1 and d.PerkTokens==1 and d.NextGift==36100)
assert(not Rules.Gift(d,18100,true),"Duplicate gift")
assert(Rules.Gift(d,36100,false))
assert(d.NormalTokens==2 and d.PerkTokens==1)
assert(Rules.AFK(d,17999)==0)
assert(Rules.AFK(d,1)==1 and d.AFKSeconds==0 and d.NormalTokens==3)
assert(Rules.AFK(d,36001)==2 and d.AFKSeconds==1)
local normal=Rules.Odds(10,"Normal"); assert(normal[6]==40 and normal[7]==30 and normal[8]==20 and normal[9]==10)
local perk=Rules.Odds(10,"Perk"); assert(perk[7]==40 and perk[8]==30 and perk[9]==20 and perk[10]==10)
assert(Rules.Odds(1,"Normal")[1]==100 and Rules.Odds(1,"Perk")[1]==100)
local random={NextNumber=function() return .5 end}
local purchase=Rules.New(0); purchase.Cash=5000
local ok=Rules.Buy(purchase,1000,random,false)
assert(ok and purchase.Cash==0 and Rules.Count(purchase)<60)
assert(purchase.Pets["7n"]==1,"1001 pudding equivalents should carry to tier 7")
local equivalent=0; for key,count in pairs(purchase.Pets) do local tier=Rules.Decode(key); equivalent+=count*3^(tier-1) end
assert(equivalent==1001)
local before=purchase.Cash; assert(not Rules.Buy(purchase,1,random,false) and purchase.Cash==before)
local shiny=Rules.New(0); shiny.Cash=50
Rules.Buy(shiny,10,{NextNumber=function() return 0 end},false)
assert(shiny.Pets["3s"]==1 and shiny.Index["2s"] and shiny.Index["3s"])
for _,spec in pairs(Config.Products) do assert(spec.Id>=0 and spec.Id%1==0) end
for _,spec in pairs(Config.Passes) do assert(spec.Id>=0 and spec.Id%1==0) end
for tier=1,30 do for _,variant in ipairs({false,true}) do
	local model=require(game.ReplicatedStorage.DessertVisuals).Build(tier,variant)
	assert(model.PrimaryPart and #model:GetChildren()>0)
	assert(model:GetPivot():FuzzyEq(CFrame.new()),"Dessert model pivot must be upright")
	model:Destroy()
end end
print("[DessertRulesTest] PASS: 5h normal/Premium atomic gifts, 5h AFK, odds, 1000 auto merge, shiny, 60 models, purchase lock")
