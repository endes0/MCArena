Arena = {
	Name = "",
	BoundingBox = nil,
	NumberOfPlayers = 0,
	SpectatorWarp = Vector3f(),
	Center = Vector3f(),
	World = "",
	Players = {}
}

APlayer = {
	PreviousPosition = Vector3d(),
	PreviousArmor = {},
	PreviousInventory = {},
	PreviousHotbar = {},
	PreviousHealth = 0,
	PreviousHunger = 0,
	PreviousXP = 0
}

function Arena:new()
	local o = {}
	setmetatable(o, Arena)
	self.__index = self
	o.Players = {}
	return o
end

function APlayer:new()
	local o = {}
	setmetatable(o, APlayer)
	self.__index = self
	o.PreviousArmor = {}
	o.PreviousInventory = {}
	o.PreviousInventory = {}
	return o
end

function Arena:SetBoundingBox(Min, Max)
	-- We want all of the values of the minimum point to be smaller so we don't run into any boundary problems	
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
	
	self.Center = Vector3f((Min.x + Max.x) / 2, (Min.y + Max.y) / 2, (Min.z + Max.z) / 2)
	self.BoundingBox = cBoundingBox(Min.x, Max.x, Min.y, Max.y, Min.z, Max.z)
end

function Arena:SetSpectatorWarp(Warp)
	self.SpectatorWarp = Warp
end

function Arena:SetName(NewName)
	self.Name = NewName
end

function Arena:KeepPlayersInBounds()
	function ContainPlayer(Player)
		if self.BoundingBox:IsInside(Player:GetPosition()) == false then
			Player:SetSpeed((Vector3d(self:GetCenter()) - Player:GetPosition()) * 2)
			Player:SendMessage("You cannot leave the arena while in battle!")
		end
	end

	for _, a_Player in pairs(self.Players) do
		cRoot:Get():FindAndDoWithPlayer(a_Player.Name, ContainPlayer)
	end

	if self:GetNumberOfPlayers() <= 1 then
		for _, k in pairs(self.Players) do
			cRoot:Get():FindAndDoWithPlayer(k.Name, function(Player)
				Player:SendMessageSuccess(cChatColor.Gold .. "You have claimed victory!")
				RemovePlayer(Player)
			end
			)
		end
		self.Players = {}
	end
end

function Arena:AddPlayer(Player)
	for _, a_PlayerName in pairs(self.Players) do
		if Player:GetName() == a_PlayerName.Name then
			return true
		end
	end
	local a_Player = APlayer:new()
	a_Player:CopyInfo(Player)	
	table.insert(self.Players, a_Player)

	-- Set gamemode and reset stats
	Player:SetGameMode(gmSurvival)
	Player:Heal(1337)
	Player:Feed(20, 1337)
	Player:SetCurrentExperience(0)
	Player:GetInventory():Clear()
	Player:TeleportToCoords(self:GetCenter().x, self:GetCenter().y, self:GetCenter().z)

	GiveKit(Player)
end

function Arena:GetCenter()
	return self.Center
end

function Arena:GetName()
	return self.Name
end

function APlayer:CopyInfo(Player)
	self.Name = Player:GetName()
	self.PreviousPosition = CopyVector(Player:GetPosition())
	self.PreviousHealth = Player:GetHealth()
	self.PreviousHunger = Player:GetFoodLevel()
	self.PreviousXP = Player:GetCurrentXp()
end

function APlayer:RestoreInfo(Player)
	Player:TeleportToCoords(self.PreviousPosition.x, self.PreviousPosition.y, self.PreviousPosition.z)
	Player:SetHealth(self.PreviousHealth)
	Player:SetFoodLevel(self.PreviousHunger)
	Player:SetCurrentExperience(self.PreviousXP)
	Player:StopBurning()
end

function Arena:GetNumberOfPlayers()
	return #self.Players
end
