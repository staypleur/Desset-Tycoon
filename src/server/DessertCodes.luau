local Codes={CashAmount=1e30}
local rewards={
	jungbin0629={Key="code:cookie-fish",Name="Cookie Fish"},
	jungbin0410={Key="code:chocolate-fish",Name="Chocolate Fish"},
	jungbin0514={Key="code:rainbow-fish",Name="Rainbow Fish"},
}
function Codes.Normalize(value)
	if type(value)~="string" or #value>64 then return nil end
	return string.lower(value:match("^%s*(.-)%s*$"))
end
-- Pure mutation: the caller commits both reward and redemption ledger atomically.
function Codes.Redeem(data,input)
	local code=Codes.Normalize(input)
	if not code or code=="" then return false,"Enter a valid code." end
	if code=="woochan0207" then
		data.CodeShiny50=not data.CodeShiny50
		return true,data.CodeShiny50 and "Shiny chance: 50%." or "Normal shiny chance restored."
	elseif code=="ywc14" then
		data.CodeCashActive=not data.CodeCashActive
		data.Cash=data.CodeCashActive and Codes.CashAmount or 0
		return true,data.CodeCashActive and "Cash boost enabled." or "Cash reset to $0."
	end
	local reward=rewards[code]
	if not reward then return false,"Invalid code." end
	data.RedeemedCodes=data.RedeemedCodes or {};data.CodePets=data.CodePets or {}
	if data.RedeemedCodes[code] or data.CodePets[reward.Key] then return false,"This code has already been redeemed." end
	data.RedeemedCodes[code]=true;data.CodePets[reward.Key]=true
	return true,reward.Name.." unlocked! Equip it in Index."
end
return Codes
