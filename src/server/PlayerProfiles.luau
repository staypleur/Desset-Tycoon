local DataStoreService=game:GetService("DataStoreService")
local HttpService=game:GetService("HttpService")
local RunService=game:GetService("RunService")
local Rules=require(game.ReplicatedStorage.DessertRules)
local Store=not RunService:IsStudio() and DataStoreService:GetDataStore("DessertTycoon_Profiles_v1") or nil
local session=game.JobId~="" and game.JobId or HttpService:GenerateGUID(false)
local Profiles={}
local function clone(data) return HttpService:JSONDecode(HttpService:JSONEncode(data)) end
function Profiles.Load(player)
	if RunService:IsStudio() then
		-- Studio tests never acquire/overwrite production profiles or grant paid receipts.
		return {Data=Rules.New(os.time()), Durable=false, Busy=false, Key=tostring(player.UserId)}
	end
	local profile={Key=tostring(player.UserId),Durable=true,Busy=false}
	local claimed=false
	local ok,result=pcall(function() return Store:UpdateAsync(profile.Key,function(old)
		claimed=false
		if old and old.Lock and old.Lock.Session~=session and old.Lock.Expires>os.time() then return nil end
		claimed=true
		return {Data=old and old.Data or Rules.New(os.time()),Lock={Session=session,Expires=os.time()+180}}
	end) end)
	if not ok or not claimed or not result then return nil,"Your save is unavailable. Please rejoin." end
	profile.Data=result.Data
	return profile
end
function Profiles.Save(profile,release,preserveSeen)
	if not profile.Durable then return true end
	if profile.Faulted then return false end
	if profile.Busy then return false end
	profile.Busy=true; local data=clone(profile.Data); if not preserveSeen then data.LastSeen=os.time() end; local saved=false
	local ok=pcall(function() Store:UpdateAsync(profile.Key,function(old)
		saved=false
		if not old or not old.Lock or old.Lock.Session~=session or old.Lock.Expires<os.time() then return nil end
		saved=true
		return {Data=data,Lock=not release and {Session=session,Expires=os.time()+180} or nil}
	end) end)
	profile.Busy=false
	if ok and saved then profile.Data.LastSeen=data.LastSeen end
	return ok and saved
end
-- Receipt and reward are written in the SAME atomic profile update before acknowledging Roblox.
function Profiles.Receipt(profile,id,grant)
	if not profile.Durable or profile.Busy or profile.Faulted then return false end
	if profile.Data.Receipts[id] then return true end
	profile.Busy=true; local snapshot=clone(profile.Data); local committed
	local ok,result=pcall(function() return Store:UpdateAsync(profile.Key,function(old)
		committed=false
		if not old or not old.Lock or old.Lock.Session~=session or old.Lock.Expires<os.time() then return nil end
		if old.Data.Receipts[id] then committed=true; return old end
		local trial=clone(snapshot); trial.LastSeen=os.time()
		grant(trial); trial.Receipts[id]=true
		committed=true
		return {Data=trial,Lock={Session=session,Expires=os.time()+180}}
	end) end)
	if ok and committed and result then profile.Data=result.Data end
	-- A timeout can occur AFTER the write committed. Never overwrite that unknown result
	-- with the old in-memory snapshot; the next session reloads the durable receipt ledger.
	if not ok then profile.Faulted=true end
	profile.Busy=false
	return ok and committed
end
-- Durable code rewards/toggles. Never acknowledge before the profile write succeeds.
function Profiles.Mutate(profile,mutate)
	if profile.Busy or profile.Faulted then return false,"Please wait." end
	profile.Busy=true
	local trial=clone(profile.Data)
	local accepted,message=mutate(trial)
	if not accepted then profile.Busy=false;return false,message end
	if not profile.Durable then profile.Data=trial;profile.Busy=false;return true,message end
	trial.LastSeen=os.time()
	local committed=false
	local ok,result=pcall(function() return Store:UpdateAsync(profile.Key,function(old)
		committed=false
		if not old or not old.Lock or old.Lock.Session~=session or old.Lock.Expires<os.time() then return nil end
		committed=true
		return {Data=trial,Lock={Session=session,Expires=os.time()+180}}
	end) end)
	if ok and committed and result then profile.Data=result.Data else profile.Faulted=true end
	profile.Busy=false
	if profile.Faulted then return false,"Save confirmation pending. Please rejoin." end
	return true,message
end
return Profiles
