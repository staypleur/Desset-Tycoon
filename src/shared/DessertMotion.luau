-- Small cosmetic hop, synchronized to the server's production timestamp.
local Motion={}
function Motion.HopHeight(elapsed)
	if elapsed<0 or elapsed>=.4 then return 0 end
	return .35*math.sin(math.pi*elapsed/.4)
end
return Motion
