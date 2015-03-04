function IsPlayerInArena(Player)
	-- If a player entry exists in PlayersInArena, then the given Player exists in game
	if PlayersInArena ~= nil and
	PlayersInArena[Player:GetName()] ~= nil then
		return true
	else
		-- Or else thats a lie
		return false
	end
end

function GetPlayerArenaName(Player)
	if PlayersInArena ~= nil and
	IsPlayerInArena(Player) == true then
		return PlayersInArena[Player:GetName()]["arena"]
	end
end

function GetNumberOfPlayersInArena(ArenaName)
	return 0--Arenas[GetArenaIDFromName(ArenaName)]["numplayers"]
end

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
