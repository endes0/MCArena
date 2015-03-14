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

-- Put Player in the arena and add him to the queue
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

	if DoesKitExist(Split[2]) == false then
		Player:SendMessageInfo("That kit does not exist!  Use /listkits to print a list of avaliable kits!")
		return true
	end

	local NewPlayerData = {}
	NewPlayerData.Name = Player:GetName()
	NewPlayerData.Kit = Split[2]

	AddPlayerToQueue(NewPlayerData)

	Player:SendMessageSuccess(cChatColor.LightBlue .. "You have joined the queue!")

	return true
end

-- List arenas
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

-- Give selected kit to player (FIX THIS)
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
