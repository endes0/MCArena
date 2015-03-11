ArenaIniFile = cIniFile()
ConfigIniFile = cIniFile()

Arenas = {}
ArenaNames = {}
Lobby = {}
PlayerQueue = {}

function LoadConfig()
	if ConfigIniFile:ReadFile("Plugins/MCArena/config.ini") == false then
		LOG("Main config file does not exist or is empty, generating a new one")
		ConfigIniFile:WriteFile("Plugins/MCArena/config.ini")
	end
	
	ConfigIniFile:ReadFile("Plugins/MCArena/config.ini")
	
	Lobby["x"] = ConfigIniFile:GetValueF("lobby", "LobbyX")
	Lobby["y"] = ConfigIniFile:GetValueF("lobby", "LobbyY")
	Lobby["z"] = ConfigIniFile:GetValueF("lobby", "LobbyZ")
end

function LoadArenas()
	if ArenaIniFile:ReadFile("Plugins/MCArena/arenas.ini") == false then
		LOG("Arena config file does not exist or is empty, generating a new one")
		ArenaIniFile:WriteFile("Plugins/MCArena/arenas.ini")
	end

	for c = 0, ArenaIniFile:GetNumKeys() - 1 do
		if DoesArenaExist(ArenaIniFile:GetKeyName(c)) == false then
			local m_Arena = Arena:new()
			m_Arena:SetName(ArenaIniFile:GetKeyName(c))
			local Min = Vector3f()
				Min.x = ArenaIniFile:GetValueF(m_Arena.Name, "MinX")
				Min.y = ArenaIniFile:GetValueF(m_Arena.Name, "MinY")
				Min.z = ArenaIniFile:GetValueF(m_Arena.Name, "MinZ")
			local Max = Vector3f()
				Max.x = ArenaIniFile:GetValueF(m_Arena.Name, "MaxX")
				Max.y = ArenaIniFile:GetValueF(m_Arena.Name, "MaxY")
				Max.z = ArenaIniFile:GetValueF(m_Arena.Name, "MaxZ")
			local SpecWarp = Vector3f()
				SpecWarp.x = ArenaIniFile:GetValueF(m_Arena.Name, "SpecX")
				SpecWarp.x = ArenaIniFile:GetValueF(m_Arena.Name, "SpecX")
				SpecWarp.x = ArenaIniFile:GetValueF(m_Arena.Name, "SpecX")	
			m_Arena:SetBoundingBox(Min, Max)
			m_Arena:SetSpectatorWarp(SpecWarp)
			table.insert(Arenas, m_Arena)
		end
	end
end

function CreateArena(Split, Player)
	ArenaIniFile:Clear()
	ArenaIniFile:ReadFile("Plugins/MCArena/arenas.ini")
	
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: /createarena <name>")
		return true
	end

	ArenaIniFile:DeleteKey(Split[2])
	ArenaIniFile:AddKeyName(Split[2])
	
	local Min = PlayerSelection[Player:GetName()]["select1"]
	local Max = PlayerSelection[Player:GetName()]["select2"]
	local Spec = PlayerSelection[Player:GetName()]["spec"]

	if Min.x > Max.x then
		local s = Max.x
		Max.x = Min.x
		Min.x = s
	end
	if Min.y > Max.y then
		local t = Max.y
		Max.y = Min.y
		Min.y = t
	end
	if Min.z > Max.z then
		local u = Max.z
		Max.z = Min.z
		Min.z = u
	end

	ArenaIniFile:SetValue(Split[2], "MinX", Min.x)
	ArenaIniFile:SetValue(Split[2], "MinY", Min.y)
	ArenaIniFile:SetValue(Split[2], "MinZ", Min.z)
	ArenaIniFile:SetValue(Split[2], "MaxX", Max.x)
	ArenaIniFile:SetValue(Split[2], "MaxY", Max.y)
	ArenaIniFile:SetValue(Split[2], "MaxZ", Max.z)
	ArenaIniFile:SetValue(Split[2], "SpecX", Spec.x)
	ArenaIniFile:SetValue(Split[2], "SpecY", Spec.y)
	ArenaIniFile:SetValue(Split[2], "SpecZ", Spec.z)
	
	ArenaIniFile:WriteFile("Plugins/MCArena/arenas.ini")
	LoadArenas()
	
	Player:SendMessageSuccess("Arena successfully created/modified!")

	return true
end

function SetLobby(Split, Player)
	ConfigIniFile:ReadFile("Plugins/MCArena/config.ini")
	
	ConfigIniFile:DeleteKey("lobby")
	ConfigIniFile:AddKeyName("lobby")
	ConfigIniFile:SetValue("lobby", "LobbyX", Player:GetPosX())
	ConfigIniFile:SetValue("lobby", "LobbyY", Player:GetPosY())
	ConfigIniFile:SetValue("lobby", "LobbyZ", Player:GetPosZ())
	
	ConfigIniFile:WriteFile("Plugins/MCArena/config.ini")
	LoadConfig()
	
	Player:SendMessageSuccess("Set lobby position successfully!")
	return true
end

function AddPlayerToQueue(PlayerDataTable)
	table.insert(PlayerQueue, PlayerDataTable)
end

function DoesArenaExist(ArenaName)
	for _, k in pairs(Arenas) do
		if k:GetName() == ArenaName then
			return true
		end
	end
	return false
end

function AddPlayerToArena(ArenaName, Player)
	for _, k in pairs(Arenas) do
		if k:GetName() == ArenaName then
			k:AddPlayer(Player)
			return true
		end			
	end
end

function GetNumberOfArenas()	
	return #Arenas
end

function GetArenaByName(ArenaName)
	for _, k in pairs(Arenas) do
		if k:GetName() == ArenaName then
			return k
		end
	end
	return nil
end

function RemovePlayer(Player)
	for _, k in pairs(Arenas) do
		for n, l in pairs(k.Players) do
			if Player:GetName() == l.Name then
				table.remove(k.Players, n)
				l:RestoreInfo(Player)
				Player:SendMessage(cChatColor.Navy .. "You have been eliminated!")
			end
		end
	end
end

function GetNumberInQueue()
	return #PlayerQueue
end

function BroadcastToQueue(String)
	for _, k in pairs(PlayerQueue) do
		cRoot:Get():FindAndDoWithPlayer(k.Name, function(Player)
			Player:SendMessage(String)
		end
		)
	end
end

function DumpQueueToArena()
	local ArenaSelection = math.random(1, GetNumberOfArenas())
	
	for _, k in pairs(PlayerQueue) do
		cRoot:Get():FindAndDoWithPlayer(k.Name, function(Player)
			AddPlayerToArena(Arenas[ArenaSelection].Name, Player)
		end
		)
		PlayerQueue = {}
	end
end
