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

--function GetNumberOfPlayersInArena(ArenaName)
	--return 0--Arenas[GetArenaIDFromName(ArenaName)]["numplayers"]
--end

--function PollNumberOfPlayersInArenas(World)
	--for c = 0, GetNumberOfArenas() - 1 do
	--Arenas[c]["numplayers"] = 0
	--	World:ForEachPlayer(function(Player)
	--		if IsPlayerInArena(Player) == true then
	--			if Arenas[c]["name"] == GetPlayerArenaName(Player) then
	--				Arenas[c]["numplayers"] = Arenas[c]["numplayers"] + 1
	--			end
	--		end
	--	end
	--	)
	--end
--end

function protect(tbl)  
    return setmetatable({}, {  
        __index = tbl,  
        __newindex = function(t, key, value)  
            error("attempting to change constant " ..  
                   tostring(key) .. " to " .. tostring(value), 2)  
        end  
    })  
end  

-- Not sure why I need this, but it seems to work...
function CopyVector(Vector)
	t = {}
	setmetatable(t, {})
	t[1] = Vector.x
	t[2] = Vector.y
	t[3] = Vector.z
	s = Vector3d(t[1], t[2], t[3])
	return s
end
