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
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)
	
	-- Command Binds

	cPluginManager.BindCommand("/mca", "mcarena.use", CommandManager, " - Main command for MCArena")

	-- Continue

	LoadArenas()
	LoadKits()

	LOG("Initialized " .. Plugin:GetName() .. " v0." .. Plugin:GetVersion())
	return true
end

-- Self-explanatory
function OnDisable()
	LOG("Disabled " .. Name .. "!")
end

function CommandManager(Split, Player)
	if Split[2] == "join" then PlayerJoinArena(Split, Player)
	elseif Split[2] == "spec" then PlayerSpectateArena(Split, Player)
	elseif Split[2] == "list" then ListArenas(Split, Player)
	elseif Split[2] == "create" then CreateArena(Split, Player)
	elseif Split[2] == "listkits" then ListKits(Split, Player)
	else Player:SendMessage(cChatColor.Gold .. "/mca - join, spec, list, listkits, create")	
	end
	return true
end

-- Put Player in the arena and add him to the queue
function PlayerJoinArena(Split, Player)
	if IsPlayerInQueue(Player) == true then
		Player:SendMessageInfo("You're already in the queue!")
		--return true
	end

	if Player:GetWorld():GetDimension() ~= dimOverworld then
		Player:SendMessageInfo("You must be in the overworld to join!")
		return true
	end

	-- No arena defined
	if Split[3] == nil then
		Player:SendMessageInfo("Please choose a kit!  Use '/mca listkits' for avaliable kits")
		return true
	end

	if DoesKitExist(Split[3]) == false then
		Player:SendMessageInfo("That kit does not exist!  Use /mca listkits to print a list of avaliable kits!")
		return true
	end

	local NewPlayerData = {}
	NewPlayerData.Name = Player:GetName()
	NewPlayerData.Kit = Split[3]

	AddPlayerToQueue(NewPlayerData)

	Player:SendMessageSuccess(cChatColor.LightBlue .. "You have joined the queue!")

	return true
end

-- List arenas
function ListArenas(Split, Player)
	Player:SendMessage(cChatColor.LightBlue .. "Arenas: ")
	for _, k in pairs(Arenas) do		
		Player:SendMessage(k:GetName())
	end
	return true
end

-- List kits
function ListKits(Split, Player)
	Player:SendMessage(cChatColor.Green .. "Kits: ")
	for _, k in pairs(Kits) do		
		Player:SendMessage(k:GetName())
	end
	return true
end

-- Put Player in spectate
function PlayerSpectateArena(Split, Player)
	Player:SendMessageInfo("We don't have that yet, soz.  :(")
	return true
end
