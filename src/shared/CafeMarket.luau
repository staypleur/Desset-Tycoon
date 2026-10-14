-- Server-owned cafe sale rate. A rate is locked when the bag is deposited.
local Config=require(script.Parent.TycoonConfig)
local Market={}
function Market.New(now,rng)
 return {Tenths=rng:NextInteger(Config.CafeMarketMinTenths,Config.CafeMarketMaxTenths),NextChange=now+Config.CafeMarketInterval}
end
function Market.Update(state,now,rng)
 if now<state.NextChange then return false end
 -- Every change is different; all other tenth-step rates are equally likely.
 local value=rng:NextInteger(Config.CafeMarketMinTenths,Config.CafeMarketMaxTenths-1)
 if value>=state.Tenths then value+=1 end
 state.Tenths=value
 state.NextChange+= (math.floor((now-state.NextChange)/Config.CafeMarketInterval)+1)*Config.CafeMarketInterval
 return true
end
function Market.Multiplier(state) return state.Tenths/10 end
return Market
