Player = FindMetaTable("Player")

function Player:GetSessionTime()
	if SERVER then
		return math.Round(CurTime() - self.Jointime)
	end
	if CLIENT then
		return math.Round(CurTime() - GAMEMODE.Jointime)
	end
end

function Player:GetPlayTime()
	if SERVER then
		return math.Round(CurTime() - self.Jointime + self.Playtime)
	end
	if CLIENT then
		return math.Round(CurTime() - GAMEMODE.Jointime + GAMEMODE.Playtime)
	end
end

function Player:SetMoney(amount)
	self:SetNWInt( 'money', amount) end

function Player:GetMoney()
	return self:GetNWInt( 'money' ) end

function Player:AddMoney(amount)
	if CheckInt(amount) then
		self:SetNWInt( 'money', self:GetMoney() + amount) 
	else
		return false
	end
end

function Player:RemoveMoney(amount)
	if self:GetNWInt('money') - amount >= 0 then
		self:SetNWInt( 'money', self:GetMoney() - amount) 
		return true
	else
		return false
	end
end

if SERVER then
	util.AddNetworkString("rank")

	function Player:SetRank(int)
		self.Rank = int
		net.Start("rank")
			net.WriteInt(self.Rank, 16)
		net.Send(self)
	end
	util.AddNetworkString("playtime")

	function Player:SetPlaytime(int, int2)
		self.Jointime = math.Round(int)
		self.Playtime = int2
		net.Start("playtime")
			net.WriteInt(self.Jointime, 32)
			net.WriteInt(self.Playtime, 32)
		net.Send(self)
	end
end
if CLIENT then
	net.Receive("rank", function()
		GAMEMODE.Rank = net.ReadInt(16)
	end)
	net.Receive("playtime", function()
		GAMEMODE.Jointime = net.ReadInt(32)
		GAMEMODE.Playtime = net.ReadInt(32)
	end)
end

function Player:Isadmin()
	if SERVER then
		return self.Rank >= 5 
	end
	if CLIENT then
		return GAMEMODE.Rank >= 5
	end
end


concommand.Add("rp_givemoney", function(ply, cmd, args)
	ply:AddMoney(tonumber(args[1]))
end)