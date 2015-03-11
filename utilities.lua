function IsPlayerInArena(Player)
	for _, k in pairs(Arenas) do
		for n, l in pairs(k.Players) do
			if Player:GetName() == l.Name then
				return true
			end
		end
	end
	return false
end

function IsPlayerInQueue(Player)
	for _, k in pairs(PlayerQueue) do
		if k.Name == Player:GetName() then
			return true
		end
	end
	return false
end

-- Not sure why I need this, but it seems to work...
function CopyVector(Vector)
	local t = {}
	t[1] = Vector.x
	t[2] = Vector.y
	t[3] = Vector.z
	local s = Vector3d(t[1], t[2], t[3])
	return s
end
