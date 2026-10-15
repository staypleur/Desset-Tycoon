-- Membership is checked on the server; the persistent receipt and free credit commit together.
local Config=require(game.ReplicatedStorage.TycoonConfig)
local Reward={}
function Reward.Claim(profile,checkMembership,commit)
	local id=Config.CommunityRewardReceipt
	if profile.Data.Receipts[id] then return false,"Reward already claimed" end
	if profile.CommunityChecking then return false,"Checking membership..." end
	profile.CommunityChecking=true
	local ok,member=pcall(checkMembership)
	if not ok or member~=true then
		profile.CommunityChecking=nil
		return false,ok and "Membership not confirmed yet. Please try again shortly." or "Could not check membership. Please try again."
	end
	local saved=commit(profile,id,function(data) data.PerkTokens+=1 end)
	profile.CommunityChecking=nil
	return saved,saved and "Joined! You received 1 free Perk Crate." or "Could not save the reward. Please rejoin and try again."
end
return Reward
