-- Edit mode: deterministic market boundary and fractional queue tests.
local folder=Instance.new('Folder'); folder.Parent=game.ReplicatedStorage
for _,name in ipairs({'TycoonConfig','DessertRules','CafeMarket'}) do game.ReplicatedStorage[name]:Clone().Parent=folder end
local Rules=require(folder.DessertRules); local Market=require(folder.CafeMarket)
local rng=Random.new(123); local s=Market.New(0,rng)
assert(s.NextChange==30 and not Market.Update(s,29.999,rng))
for n=1,50 do local previous=s.Tenths
 assert(Market.Update(s,n*30,rng) and s.Tenths~=previous and s.Tenths>=5 and s.Tenths<=15 and s.NextChange==(n+1)*30)
end
local example=Rules.New(0);example.Bag=100
local deposited,queued=Rules.Deposit(example,1.3)
assert(deposited==100 and queued==130 and example.CafeQueue==130 and example.Bag==0)
for _,rate in ipairs({.5,.9,1,1.3,1.5}) do
 local d=Rules.New(0); d.Bag=101
 local amount,credited=Rules.Deposit(d,rate)
 assert(amount==101 and math.abs(credited-101*rate)<1e-8 and d.Bag==0 and d.Pending==0)
 local total=0; for _=1,1000 do local units=Rules.ConvertCafe(d,0); total+=units end
 assert(d.CafeQueue==0 and math.abs(total-credited)<1e-8 and math.abs(d.Pending-credited)<1e-8)
end
local d=Rules.New(0); d.Bag=1.2; Rules.Deposit(d,.5); assert(math.abs(d.CafeQueue-.6)<1e-8 and d.Bag==0)
folder:Destroy()
print('[CafeMarketTest] PASS: 100 x 1.3 = 130 queued, 30-second boundaries, tenth-step range/different rates, fractional conservation')
