-- Pure current rules: no purchases, production accounts or live DataStores.
local f=Instance.new('Folder');f.Parent=game.ServerStorage
for _,name in {'DessertRules','TycoonConfig'} do game.ReplicatedStorage[name]:Clone().Parent=f end
local R=require(f.DessertRules);local C=require(f.TycoonConfig)
local function close(a,b) assert(math.abs(a-b)<1e-10,tostring(a)..' != '..tostring(b)) end
close(R.FriendBonus(false,{}),0);close(R.FriendBonus(true,{}),.03)
close(R.FriendBonus(false,{true}),.01);close(R.FriendBonus(true,{false}),.04)
close(R.FriendBonus(false,{false,false,false}),.01);close(R.FriendBonus(true,{true,true}),.04)
close(R.ShinyChance('Normal',1,R.FriendBonus(true,{false,false}),false,1),.05)
close(R.ShinyChance('Normal',1,R.FriendBonus(false,{true,true,true}),false,10),.02)
close(R.ShinyChance('Normal',2,.04,false,30),.082)
close(R.ShinyChance('NormalCrate',2,.04,false,30),.14)
close(R.ShinyChance('Perk',2,.04,false,1),.28)
close(R.ShinyChance('Normal',1,0,false,10),.01);close(R.ShinyChance('Normal',1,0,false,11),.005)
close(R.ShinyChance('Normal',1,0,false,20),.005);close(R.ShinyChance('Normal',1,0,false,21),.001)
for tier=1,30 do
 local base=C.ShinyBaseRates[math.ceil(tier/10)]
 close(R.ShinyChance('Normal',1,0,false,tier),base)
 close(R.ShinyChance('NormalCrate',1,0,false,tier),.03)
 close(R.ShinyChance('Perk',1,0,false,tier),.10)
 for _,kind in {'Normal','NormalCrate','Perk'} do close(R.ShinyChance(kind,2,.04,true,tier),.5) end
 -- Buy uses the purchased tier, even when highest tier is six tiers ahead.
 local d=R.New(0);d.Index={[R.Key(math.min(30,tier+6),false)]=true};d.Cash=1e30;d.Pets={}
 local buyTier=R.BuyTier(d);local chance=R.ShinyChance('Normal',1,0,false,buyTier)
 local calls=0;local rng={NextNumber=function() calls+=1;return calls==1 and chance-.0000001 or .9 end}
 assert(R.Buy(d,1,rng,1,false,0));assert(d.Pets[R.Key(buyTier,true,2)]==1,'Buy output tier odds')
 if tier>1 then
  for _,isShiny in {false,true} do
   local p=R.New(0);p.Pets={[R.Key(tier-1,false)]=3};local n=0
   R.Merge(p,{}, {NextNumber=function() n+=1;return n==1 and (base+(isShiny and -.0000001 or 0)) or .9 end},1,0)
   assert(p.Pets[R.Key(tier,isShiny,isShiny and 2 or 0)]==1,'Merge destination boundary tier '..tier)
  end
 end
 for _,kind in {'Normal','Perk'} do
  local p=R.New(0);p.Pets={[R.Key(tier,false)]=1}
  local n=0;local target=tier
  local chance=R.ShinyChance(kind=='Normal' and 'NormalCrate' or kind,1,.04,false,target)
  local result=R.Roll(p,kind,{NextNumber=function() n+=1;return ({.99999999,chance-.0000001,.9})[n] end},1,{},.04)
  assert(result.Tier==target and result.Shiny and result.Variant==2,'Crate destination tier odds')
  local total=0
  for _,entry in R.CrateOutcomeOdds(tier,kind,2,.04,false) do
   local prob=R.ShinyChance(kind=='Normal' and 'NormalCrate' or kind,2,.04,false,entry.Tier)
   close(entry.Percent,R.Odds(tier,kind)[entry.Tier]*(entry.Variant==0 and 1-prob or prob/2))
   assert(entry.Percent>0);total+=entry.Percent
  end
  close(total,100)
  -- Even a max-tier owner can still roll a starter shiny, or the current max tier.
  local starterCalls=0;local low=R.Roll(p,kind,{NextNumber=function() starterCalls+=1;return 0 end},1,{},0)
  assert(low.Tier==1 and low.Shiny and low.Variant==1)
 end
end
-- Seeded statistical check of each normal base rate, including the 0.1% band.
local rng=Random.new(20261018);local sample=1000000
for band,base in C.ShinyBaseRates do
 local hits=0;for _=1,sample do if rng:NextNumber()<R.ShinyChance('Normal',1,0,false,band*10) then hits+=1 end end
 assert(math.abs(hits-sample*base)<6*math.sqrt(sample*base*(1-base)),'Statistical rate band '..band)
 print('SHINY_SAMPLED_PERCENT',band*10,hits/sample*100,'expected',base*100)
end
for _,kind in {'Normal','Perk'} do
 local d=R.New(0);d.Pets={['10n']=1};local hits=0;local tiers={}
 for _=1,100000 do local item=R.Roll(d,kind,rng,1,{},0);hits+=item.Shiny and 1 or 0;tiers[item.Tier]=(tiers[item.Tier] or 0)+1 end
 local rate=C.CrateShinyRates[kind];assert(math.abs(hits-100000*rate)<6*math.sqrt(100000*rate*(1-rate)))
 for t=1,10 do assert(math.abs(tiers[t]-10000)<600) end
 print('CRATE_SAMPLED_PERCENT',kind,hits/1000,'expected',rate*100,'all ten tiers')
end
f:Destroy();print('[ShinyBalance] PASS: 30 tiers, purchase/merge boundaries, full-range crates, fixed 3/10% crate rates, truthful joint odds, one friend bonus regardless of count, additive Premium then Luck, 50% override, 3 million base samples and 200000 actual crate rolls')
