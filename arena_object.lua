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
	setmetatable(o.Players, Arena.Players)
	self.Players__index = self.Players
	return o
end

function APlayer:new()
	local o = {}
	setmetatable(o, APlayer)
	self.__index = self
	o.PreviousArmor = {}
	setmetatable(o.PreviousArmor, APlayer.PreviousArmor)
	self.PreviousArmor.__index = self.PreviousArmor
	o.PreviousInventory = {}
	setmetatable(o.PreviousInventory, APlayer.PreviousInventory)
	self.PreviousInventory.__index = self.PreviousInventory
	o.PreviousInventory = {}
	setmetatable(o.PreviousHotbar, APlayer.PreviousHotbar)
	self.PreviousHotbar.__index = self.PreviousHotbar
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
		LOG(a_Player.PreviousPosition.x)
		LOG(a_Player.PreviousPosition.y)
		LOG(a_Player.PreviousPosition.z)
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
	Player:TeleportToCoords(self:GetCenter().x, self:GetCenter().y, self:GetCenter().z)
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
	for c = 0, 3 do
		self.PreviousArmor[c] = Player:GetInventory():GetArmorSlot(c)
	end
	for c = 0, 26 do
		self.PreviousInventory[c] = Player:GetInventory():GetInventorySlot(c)
	end
	for c = 0, 8 do
		self.PreviousHotbar[c] = Player:GetInventory():GetHotbarSlot(c)
	end
	self.PreviousHealth = Player:GetHealth()
	self.PreviousHunger = Player:GetFoodLevel()
	self.PreviousXP = Player:GetCurrentXp()
end

function APlayer:RestoreInfo(Player)
	Player:TeleportToCoords(self.PreviousPosition.x, self.PreviousPosition.y, self.PreviousPosition.z)
	for c = 0, 3 do
		Player:GetInventory():SetArmorSlot(c, self.PreviousArmor[c])
	end
	for c = 0, 26 do
		Player:GetInventory():SetInventorySlot(c, self.PreviousInventory[c])
	end
	for c = 0, 8 do
		Player:GetInventory():SetHotbarSlot(c, self.PreviousHotbar[c])
	end
	Player:SetHealth(self.PreviousHealth)
	Player:SetFoodLevel(self.PreviousHunger)
	Player:SetCurrentExperience(self.PreviousXP)
end
