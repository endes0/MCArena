PlayerSelection = {}

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

	for _, CurrentArena in pairs(Arenas) do
		CurrentArena:KeepPlayersInBounds()
	end

	if GetNumberInQueue() > 1 and QueueWaiting == false then
		QueueWaiting = true
		BroadcastToQueue(cChatColor.LightPurple .. "Other players have joined the queue, ")
		BroadcastToQueue(cChatColor.LightPurple .. "waiting for other potential players...")		
		World:ScheduleTask(300, function()
			BroadcastToQueue(cChatColor.LightPurple .. "You have been matched!")
			DumpQueueToArena()
			QueueWaiting = false
		end
		)
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
	if DoesPlayerHavePermissionToEdit(Player) == false then
		return false
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
		PlayerSelection[Player:GetName()]["select1"] = Vector3i(BlockX, BlockY, BlockZ)
		Player:SendMessageInfo("Selected first position: " .. BlockX .. ", " .. BlockY .. ", " .. BlockZ)
		return true
	end
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, Action)
	if DoesPlayerHavePermissionToEdit(Player) == false then
		return false
	end	

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

function OnTakeDamage(Entity, TDI)
	if Entity:IsPlayer() == true and TDI.Attacker:IsPlayer() == true then
		if TDI.Attacker:IsPlayer() == true then
			if IsPlayerInArena(Entity) == true and IsPlayerInArena(TDI.Attacker) == false then
				TDI.Attacker:SendMessageWarn("You cannot interfere with arena battles!")
				return true
			end
		end
	end
	return false
end

function OnKilling(Victim, Killer)
	if Victim:IsPlayer() == true then
		if IsPlayerInArena(Victim) == true then
			RemovePlayer(Victim)
		end
	end
end
