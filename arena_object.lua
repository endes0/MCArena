Arena = {
Name = "",
BoundingBox = nil,
NumberOfPlayers = 0,
SpectatorWarp = 0,
Center = Vector3f(),
Players = {}
}

function Arena:new()
	local o = {}   -- create object if user does not provide one
	setmetatable(o, Arena)
	self.__index = self
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
	self.BoundingBox = cBoundingBox(Min.x, Min.y, Min.z, Max.x, Max.y, Max.z)
end

function Arena:SetSpectatorWarp(Warp)
	self.SpectatorWarp = Warp
end

function Arena:SetName(NewName)
	self.Name = NewName
end

function Arena:KeepPlayersInBounds()
	function ContainPlayer(Player)
		if self.BoundingBox:IsInside(Player:GetPosition()) == true then
			Player:SetSpeedX(Player:GetSpeedX() * -10)
			Player:SetSpeedZ(Player:GetSpeedZ() * -10)
			Player:SetSpeedY(1)
		end
	end	

	for _, name in pairs(self.Players) do
		cRoot:Get():FindAndDoWithPlayer(name, ContainPlayer)
	end
end

function Arena:AddPlayer(Player)
	for _, a_PlayerName in pairs(self.Players) do
		if Player:GetName() == a_PlayerName then
			--return true
		end
	end
	table.insert(self.Players, Player:GetName())
	Player:TeleportToCoords(self:GetCenter().x, self:GetCenter().y, self:GetCenter().z)
	for _, k in pairs(self.Players) do
		LOG(k)
	end
	LOG(Player:GetPosX())
LOG(Player:GetPosY())
LOG(Player:GetPosZ())
			
end

function Arena:GetCenter()
	return self.Center
end

function Arena:GetName()
	return self.Name
end
