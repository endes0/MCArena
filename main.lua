PLUGIN = nil

local clock = os.clock

local Name = "MCArena Beta"

function Initialize(Plugin)
	Plugin:SetName(Name)
	Plugin:SetVersion(1)
	
	-- Load config
	
	-- Set up random number generator
	math.randomseed(os.time())
	
	-- Hooks here you scrub...
	
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlaceBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnPlayerLeftClick)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager:AddHook(cPluginManager.HOOK_KILLING, OnKilling)
	
	-- Command Binds
	
	cPluginManager.BindCommand("/joinarena", "mcarena.join", PlayerJoinArena, " - Get in there you maggot.")
	cPluginManager.BindCommand("/specarena", "mcarena.spectate", PlayerSpectateArena, " - Get in there you maggot.")
	cPluginManager.BindCommand("/listarenas", "mcarena.list", ListArenas, " - Gotta find a place to settle scores first.")
	cPluginManager.BindCommand("/createarena", "mcarena.createarena", CreateArena, " - Gotta have a place to settle your issues right?")
	cPluginManager.BindCommand("/tplobby", "arena.tplobby", TPLobby, " - So I heard you like coffee.")
	cPluginManager.BindCommand("/setlobby", "arena.setlobby", SetLobby, " - Don't forget the coffee maker.  :D")
	
	-- Continue

	LoadConfig()
	LoadArenas()

	LOG("Initialized " .. Plugin:GetName() .. " v0." .. Plugin:GetVersion())
	return true
end

-- Self-explanatory
function OnDisable()
	LOG("Disabled " .. Name .. "!")
end

function TPLobby(Split, Player)
	-- Refuse to let him tp to lobby if he is already in a fight
	if IsPlayerInArena(Player) == true then
		Player:SendMessageInfo("You can not do that during combat!")
		return true
	end
	-- Get Lobby coords and tp to that
	Player:TeleportToCoords(Lobby["x"], Lobby["y"], Lobby["z"])
	return true
end

-- Put Player in the arena and add him to an arena
function PlayerJoinArena(Split, Player)
	if IsPlayerInArena(Player) then
		Player:SendMessageInfo("You cannot do that during combat!")
		return true
	end
	
	if IsPlayerInQueue(Player) == true then
		Player:SendMessageInfo("You're already in the queue!")
		return true
	end

	-- No arena defined
	if Split[2] == nil then
		Player:SendMessageInfo("Please choose a kit!")
		return true
	end

	local NewPlayerData = {}
	NewPlayerData.Name = Player:GetName()
	NewPlayerData.Kit = Split[2]

	AddPlayerToQueue(NewPlayerData)

	Player:SendMessageSuccess(cChatColor.LightBlue .. "You have joined the queue!")

	return true
end

-- List arenas (FIX THIS)
function ListArenas(Split, Player)
	Player:SendMessage("Arenas: ")
	for _, k in pairs(Arenas) do		
		Player:SendMessage(k:GetName())
	end
	return true
end

-- Put Player in spectate
function PlayerSpectateArena(Split, Player)
	Player:SendMessageInfo("We don't have that yet, soz.  :(")
	return true
end

function GiveKit(Player)
	Player:GetInventory():AddItem(cItem(E_ITEM_DIAMOND_SWORD))
end
