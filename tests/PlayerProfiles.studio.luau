-- Edit-mode deterministic DataStore mock. No real account profiles are read or written.
local realGame=game
local json=game:GetService("HttpService")
local saved,failAfterCommit=nil,false
local store={}
function store:UpdateAsync(_,callback)
	local result=callback(saved)
	if result then saved=json:JSONDecode(json:JSONEncode(result)) end
	if failAfterCommit then failAfterCommit=false; error("Simulated timeout after commit") end
	return saved
end
local rulesFolder=Instance.new('Folder'); rulesFolder.Parent=game.ReplicatedStorage
for _,name in ipairs({'DessertRules','TycoonConfig'}) do game.ReplicatedStorage[name]:Clone().Parent=rulesFolder end
local fakeGame={JobId="ProfileRegression",ReplicatedStorage=rulesFolder}
function fakeGame:GetService(name)
	if name=="DataStoreService" then return {GetDataStore=function() return store end} end
	if name=="RunService" then return {IsStudio=function() return false end} end
	return realGame:GetService(name)
end
local fn=assert(loadstring(game.ServerScriptService.PlayerProfiles.Source))
setfenv(fn,setmetatable({game=fakeGame},{__index=getfenv()}))
local Profiles=fn()
local profile=assert(Profiles.Load({UserId=999999999}))
profile.Data.AFKSeconds=1234; profile.Data.NextGift=987654
profile.Data.TotalCashEarned=456; profile.Data.TotalMiniCollected=789; profile.Data.PlaySeconds=2345
profile.Data.AFKStored=12.5; profile.Data.OfflineStored=24.25
assert(Profiles.Save(profile,false))
local grants=0
assert(Profiles.Receipt(profile,"first",function(d) grants+=1; d.PaidNormalTokens+=1 end))
profile.Data.Cash+=10
assert(Profiles.Receipt(profile,"first",function() error("Duplicate grant") end))
assert(grants==1 and profile.Data.Cash==10 and profile.Data.PaidNormalTokens==1)
assert(Profiles.Save(profile,true))
profile=assert(Profiles.Load({UserId=999999999}))
assert(profile.Data.NextGift==987654 and profile.Data.AFKSeconds==1234 and profile.Data.Receipts.first)
assert(profile.Data.TotalCashEarned==456 and profile.Data.TotalMiniCollected==789 and profile.Data.PlaySeconds==2345)
assert(profile.Data.AFKStored==12.5 and profile.Data.OfflineStored==24.25 and profile.Data.LastSeen>0)
failAfterCommit=true
assert(not Profiles.Receipt(profile,"uncertain",function(d) d.PaidPerkTokens+=1 end))
assert(profile.Faulted and saved.Data.PaidPerkTokens==1 and saved.Data.Receipts.uncertain)
assert(not Profiles.Save(profile,true),"An uncertain receipt must never be overwritten")
saved.Lock.Expires=0
local rejoined=assert(Profiles.Load({UserId=999999999}))
assert(rejoined.Data.PaidPerkTokens==1)
assert(Profiles.Receipt(rejoined,"uncertain",function() error("Retry must not grant twice") end))
rulesFolder:Destroy()
print("[PlayerProfilesTest] PASS: timers persisted, duplicate receipts preserve progress, uncertain committed writes protected, rejoin/retry exactly once")
