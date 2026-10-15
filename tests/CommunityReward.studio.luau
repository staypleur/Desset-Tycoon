-- Edit-mode unit regression: no real account joins, production profiles or Robux.
local reward=require(game.ServerScriptService.CommunityReward:Clone())
local config=require(game.ReplicatedStorage.TycoonConfig)
local function fresh() return {Data={Receipts={},PerkTokens=0},Durable=true} end
local commits=0
local function commit(p,id,grant)
	commits+=1
	if not p.Data.Receipts[id] then grant(p.Data);p.Data.Receipts[id]=true end
	return true
end
local p=fresh()
assert(not reward.Claim(p,function() return false end,commit) and commits==0 and p.Data.PerkTokens==0)
assert(not reward.Claim(p,function() error("network unavailable") end,commit) and commits==0)
assert(reward.Claim(p,function() return true end,commit))
assert(p.Data.PerkTokens==1 and p.Data.Receipts[config.CommunityRewardReceipt] and commits==1)
assert(not reward.Claim(p,function() error("must not query claimed accounts") end,commit))
assert(p.Data.PerkTokens==1 and commits==1)
local reloaded={Data=game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):JSONEncode(p.Data))}
assert(not reward.Claim(reloaded,function() return true end,commit) and reloaded.Data.PerkTokens==1)
local q=fresh()
assert(not reward.Claim(q,function() return true end,function() return false end))
assert(q.Data.PerkTokens==0 and not q.CommunityChecking)
local r=fresh(); local done=false
local gate=Instance.new("BindableEvent")
task.spawn(function() assert(reward.Claim(r,function() gate.Event:Wait();return true end,commit));done=true end)
task.wait()
assert(not reward.Claim(r,function() return true end,commit),"Concurrent request blocked")
gate:Fire();task.wait();assert(done and r.Data.PerkTokens==1);gate:Destroy()
print("[CommunityReward] PASS: membership required, one free credit, durable receipt, reload, retry and concurrent guard")
