-- Is Player currently inside of an existing arena?
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

-- Is Player waiting to be matched?
function IsPlayerInQueue(Player)
	for _, k in pairs(PlayerQueue) do
		if k.Name == Player:GetName() then
			return true
		end
	end
	return false
end

-- Sends message to everyone currently in queue
function BroadcastToQueue(String)
	for _, k in pairs(PlayerQueue) do
		cRoot:Get():FindAndDoWithPlayer(k.Name, function(Player)
			Player:SendMessage(String)
		end
		)
	end
end

-- Add player to waiting queue
function AddPlayerToQueue(PlayerDataTable)
	table.insert(PlayerQueue, PlayerDataTable)
end

-- Get number on players waiting in the queue
function GetNumberInQueue()
	return #PlayerQueue
end

function DoesArenaExist(ArenaName)
	for _, k in pairs(Arenas) do
		if k:GetName() == ArenaName then
			return true
		end
	end
	return false
end

function DoesKitExist(KitName)
	for _, k in pairs(Kits) do
		if k:GetName() == KitName then
			return true
		end
	end
	return false
end

-- Returns a reference to the requested arena object
function GetArenaByName(ArenaName)
	for _, k in pairs(Arenas) do
		if k:GetName() == ArenaName then
			return k
		end
	end
	return {}
end

-- Returns a reference of the requested kit object
function GetKitByName(KitName)
	for _, k in pairs(Kits) do
		if k:GetName() == KitName then
			for n, l in pairs(k.Items) do
			end			
			return k
		end
	end
	return {}
end

-- Give selected kit to player
function GiveKit(Player, KitName)	
	local a_Kit = GetKitByName(KitName)	
	Player:GetInventory():Clear()
	for _, k in pairs(Kits) do
		if k:GetName() == KitName then
			for n, l in pairs(a_Kit.Items) do
				Player:GetInventory():AddItem(cItem(l))
			end
		end
	end
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

-- Copy a table by values instead of by reference
function CopyTable(Table)
	local t = {}
	setmetatable(t, Table)
	self.__index = self
	return t
end

function DoesPlayerHavePermissionToEdit(Player)
	local permissions = Player:GetPermissions()
	for _, k in pairs(permissions) do
		if k == "mcarena.create" or
		k == "*" then
			return true
		end
	end
	return false
end
