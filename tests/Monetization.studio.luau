-- Edit mode only. Execute the real receipt handler against a mock DataStore.
-- No purchase prompt, real payment or production save is used.
local realGame=game
local json=game:GetService("HttpService")
local saved,failAfterCommit=nil,false
local store={}
function store:UpdateAsync(_,callback)
	local result=callback(saved)
	if result then saved=json:JSONDecode(json:JSONEncode(result)) end
	if failAfterCommit then failAfterCommit=false;error("Simulated timeout after commit") end
	return saved
end
local folder=Instance.new("Folder");folder.Parent=game.ReplicatedStorage
for _,name in ipairs({"DessertRules","TycoonConfig"}) do game.ReplicatedStorage[name]:Clone().Parent=folder end
local Config=require(folder.TycoonConfig)
local Rules=require(folder.DessertRules)
local fakeGame={JobId="MonetizationRegression",ReplicatedStorage=folder}
function fakeGame:GetService(name)
	if name=="DataStoreService" then return {GetDataStore=function() return store end} end
	if name=="RunService" then return {IsStudio=function() return false end} end
	return realGame:GetService(name)
end
local profileFn=assert(loadstring(game.ServerScriptService.PlayerProfiles.Source))
setfenv(profileFn,setmetatable({game=fakeGame},{__index=getfenv()}))
local Profiles=profileFn()
local player={UserId=999999999,Kick=function(self) self.Kicked=true end}
local profile=assert(Profiles.Load(player))
local profiles={[player]=profile}
local Players={GetPlayerByUserId=function(_,id) if id==player.UserId then return player end end}
local Market={}
local source=game.ServerScriptService.DessertGame.Source
local first=assert(source:find("Market.ProcessReceipt=function(receipt)",1,true))
local last=assert(source:find("local frameTime,timer,saveTimer",first,true))
local handlerFn=assert(loadstring(source:sub(first,last-1)))
setfenv(handlerFn,setmetatable({Market=Market,Players=Players,profiles=profiles,Profiles=Profiles,Config=Config,update=function() end},{__index=getfenv()}))
handlerFn()
local granted,pending=Enum.ProductPurchaseDecision.PurchaseGranted,Enum.ProductPurchaseDecision.NotProcessedYet
local used={};local passCount,productCount=0,0
for _,spec in pairs(Config.Passes) do
	assert(spec.Id>0 and not used[spec.Id]);used[spec.Id]=true;passCount+=1
end
local function receipt(spec,id,userId)
	return Market.ProcessReceipt({PlayerId=userId or player.UserId,ProductId=spec.Id,PurchaseId=id})
end
for key,spec in pairs(Config.Products) do
	assert(spec.Id>0 and not used[spec.Id]);used[spec.Id]=true;productCount+=1
	assert(receipt(spec,key)==granted)
	local snapshot=json:JSONEncode(profile.Data)
	assert(receipt(spec,key)==granted and json:JSONEncode(profile.Data)==snapshot,"Duplicate receipt changed inventory")
end
assert(passCount==16 and productCount==5)
assert(profile.Data.PaidNormalTokens==11 and profile.Data.PaidPerkTokens==11)
assert(profile.Data.HotUntil>=os.time()+Config.HotTimeSeconds-2)
local hotUntil=profile.Data.HotUntil
assert(receipt(Config.Products.HotTime,"hot-extension")==granted)
assert(profile.Data.HotUntil==hotUntil+Config.HotTimeSeconds)
assert(receipt({Id=-123},"unknown")==pending)
assert(receipt(Config.Products.Normal1,"absent-player",-1)==pending)
profile.Closing=true;assert(receipt(Config.Products.Normal1,"closing")==pending);profile.Closing=false
assert(Profiles.Save(profile,true))
profile=assert(Profiles.Load(player));profiles[player]=profile
assert(receipt(Config.Products.Normal10,"Normal10")==granted and profile.Data.PaidNormalTokens==11,"Reload duplicated a paid grant")
failAfterCommit=true
assert(receipt(Config.Products.Normal1,"uncertain")==pending and profile.Faulted and player.Kicked)
assert(saved.Data.PaidNormalTokens==12 and saved.Data.Receipts.uncertain)
assert(not Profiles.Save(profile,true),"Unknown commit must not overwrite receipt")
saved.Lock.Expires=0
profile=assert(Profiles.Load(player));profiles[player]=profile
assert(receipt(Config.Products.Normal1,"uncertain")==granted and profile.Data.PaidNormalTokens==12)
local allPasses={};for key in pairs(Config.Passes) do allPasses[key]=true end
assert(Rules.PassMultiplier(allPasses,"Production")==5)
assert(Rules.PassMultiplier(allPasses,"Luck")==2)
assert(Rules.PassMultiplier(allPasses,"Speed")==3)
assert(Rules.PassMultiplier({Boost12=true,Boost5=true},"Production")==1.2,"Missing prerequisite must not unlock a tier")
folder:Destroy()
print("[MonetizationTest] PASS: 21 unique release IDs; all five real product mappings; exact grants; duplicate/rejoin/uncertain-commit recovery; hot-time extension; pending invalid receipts; highest pass multiplier")
