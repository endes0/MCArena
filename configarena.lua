ArenaIniFile = cIniFile()
KitIniFile = cIniFile()

Arenas = {}
Kits = {}
Lobby = {}
PlayerQueue = {}

QueueWaiting = false

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

function LoadKits()
	if KitIniFile:ReadFile("Plugins/MCArena/kits.ini") == false then
		LOG("Kit config file does not exist or is empty, generating a new one")
		-- If no kits exist, this function creates default kit
		KitIniFile:AddKeyName("default")
		KitIniFile:SetValueI("default", "item1", E_ITEM_DIAMOND_SWORD, true)
		KitIniFile:SetValueI("default", "amount1", 1, true)
		KitIniFile:WriteFile("Plugins/MCArena/kits.ini")
		-- End default kit
	end

	for c = 0, KitIniFile:GetNumKeys() - 1 do
		if DoesKitExist(KitIniFile:GetKeyName(c)) == false then
			local m_Kit = Kit:new()
			m_Kit:SetName(KitIniFile:GetKeyName(c))
			for i = 0, (KitIniFile:GetNumValues(c) - 1) / 2 do
				local itemID = KitIniFile:GetValueI(m_Kit:GetName(), "item" .. tostring(i+1))
				local itemAmount = KitIniFile:GetValueI(m_Kit:GetName(), "amount" .. tostring(i+1))
				
				for c = 1, itemAmount do
					m_Kit:AddItem(itemID)
				end
			end
			table.insert(Kits, m_Kit)
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

function AddPlayerToArena(ArenaName, PlayerData)
	for _, k in pairs(Arenas) do
		if k:GetName() == ArenaName then
			k:AddPlayer(PlayerData)
			return true
		end			
	end
end

function GetNumberOfArenas()	
	return #Arenas
end

-- Remove player from arena if is currently in one
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

-- Dump all waiting players into the same randomly chosen arena and empty queue line
function DumpQueueToArena()
	local ArenaSelection = math.random(1, GetNumberOfArenas())
	
	for _, k in pairs(PlayerQueue) do
		AddPlayerToArena(Arenas[ArenaSelection].Name, k)
	end
	PlayerQueue = {}
end
