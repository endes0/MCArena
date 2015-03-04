PlayerSelection = {}

function OnPluginsLoaded()
	PlayersInArena = {}
	cRoot:Get():ForEachPlayer(function(Player)
		PlayersInArena = {}
		Player:SetGameMode(gmCreative)
		Player:TeleportToCoords(Player:GetWorld():GetSpawnX(), Player:GetWorld():GetSpawnY(), Player:GetWorld():GetSpawnZ())
		Player:SetCurrentExperience(0)
		Player:Heal(1337)
	end
	)
end

function OnPlayerDestroyed(Player)
	PlayersInArena[Player:GetName()] = nil
end

function OnPlayerSpawned(Player)
	-- Confiscate any barrier blocks as they crash 1.7.10 clients
	for c = 0, 39, 1 do
		if Player:GetInventory():GetSlot(c).m_ItemType == E_BLOCK_BARRIER then
			Player:GetInventory():SetSlot(c, cItem())
		end
	end
	Player:SetGameMode(gmCreative)
	Player:TeleportToCoords(Player:GetWorld():GetSpawnX(), Player:GetWorld():GetSpawnY(), Player:GetWorld():GetSpawnZ())
	Player:SetCurrentExperience(0)
	Player:Heal(1337)
end

-- If Player is in survival, do not let him break blocks
function OnPlayerBreakBlock(Player)
	if Player:GetGameMode() == gmSurvival and
	IsPlayerInArena(Player) == true then
		return true
	else
		return false
	end
end

function OnWorldTick(World, TimeDelta)
	if World:IsWeatherSunny() == false then
		World:SetWeather(wSunny)
	end
	
	--PollNumberOfPlayersInArenas(World)
	--for c = 0, GetNumberOfArenas() do
	--	if GetNumberOfPlayersInArena(GetArenaNameFromID(c)) <= 0 then
	--		--Make Arena available		
	--	end
	--end

	for _, CurrentArena in pairs(Arenas) do
		CurrentArena:KeepPlayersInBounds()
	end
end

function OnPlayerMoving(Player, OldPos, NewPos)
end

-- If Player is in survival, do not let him place blocks
function OnPlayerPlaceBlock(Player)
	if Player:GetGameMode() == gmSurvival and
	IsPlayerInArena(Player) == true then
		return true
	else
		return false
	end
end

function OnPlayerLeftClick(Player, BlockX, BlockY, BlockZ, BlockFace, Action)
	if PlayerSelection[Player:GetName()] == nil then
		PlayerSelection[Player:GetName()] = {}
	end

	if Player:IsCrouched() == true and
	Player:GetInventory():GetEquippedItem().m_ItemType == E_ITEM_GOLD_PICKAXE then
		PlayerSelection[Player:GetName()]["spec"] = Vector3i(BlockX, BlockY, BlockZ)
		Player:SendMessageInfo("Selected spectator position: " .. BlockX .. ", " .. BlockY .. ", " .. BlockZ)
		return true
	elseif Player:GetInventory():GetEquippedItem().m_ItemType == E_ITEM_GOLD_PICKAXE then
		PlayerSelection[Player:GetName()]["select1"] = Vector3i(BlockX, BlockY, BlockZ)
		Player:SendMessageInfo("Selected first position: " .. BlockX .. ", " .. BlockY .. ", " .. BlockZ)
		return true
	end
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, Action)
	if BlockFace == BLOCK_FACE_NONE then
		return true	
	end

	if PlayerSelection[Player:GetName()] == nil then
		PlayerSelection[Player:GetName()] = {}
	end

	if Player:IsCrouched() == true and
	Player:GetInventory():GetEquippedItem().m_ItemType == E_ITEM_GOLD_PICKAXE then
		PlayerSelection[Player:GetName()]["spec"] = Vector3i(BlockX, BlockY, BlockZ)
		Player:SendMessageInfo("Selected spectator position: " .. BlockX .. ", " .. BlockY .. ", " .. BlockZ)
		return true
	elseif Player:GetInventory():GetEquippedItem().m_ItemType == E_ITEM_GOLD_PICKAXE then
		PlayerSelection[Player:GetName()]["select2"] = Vector3i(BlockX, BlockY, BlockZ)
		Player:SendMessageInfo("Selected second position: " .. BlockX .. ", " .. BlockY .. ", " .. BlockZ)
		return true
	end
end

function OnKilling(Victim, Killer)
	if Victim:IsPlayer() == true then
		PlayersInArena[Victim:GetName()] = nil
	end
end
