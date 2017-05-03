local Player = FindMetaTable("Player")

function Player:LoadProfile()

	local q1 = "SELECT * FROM items WHERE steamid = '"..self:SteamID64().."'"
	local q2 = "SELECT * FROM players WHERE steamid = '"..self:SteamID64().."'"
	local q3 = "SELECT * FROM vehicles WHERE steamid = '"..self:SteamID64().."'"

	function SetData(str)
		if str[1] == nil then
			self:CreateProfile()
		else
			self:SetNWInt('money', str[1].money)
			self:SetPlaytime(CurTime(), str[1].playtime)
			self:SetNWString('name', str[1].name)
			self:SetRank(str[1].rank)
		end
	end
	GetDataQuery(q2, SetData)
	function SetInventory(str)
		for i=1,#str do
			if str[i].steamid ~= self:SteamID64() then print("Error with ID") return end 
			self:SetItem(i, str[i].itemid, str[1].quantity)
		end

	end
	GetDataQuery(q1, SetInventory)
	function SetVehicle(str)
		for i=1,#str do
			self:SetVehicle(str[i].vehicleid, string.ToColor(str[i].color))
		end
	end
	GetDataQuery(q3, SetVehicle)
end

function Player:CreateProfile()

	local nick, money = self:Nick(), self:GetNWInt('money')

	local q = "INSERT INTO players ( steamid, steamname, name, money, rank, playtime ) VALUES ( '"..self:SteamID64().."', '"..nick.."', 'Charles', '15000', '0', '0' )"	
	self:SetNWInt("money", 15000)
	self:SetRank(0)
	self:SetPlaytime(CurTime(), 0)
	Query(q)
	print('Profile created')

end

function Player:SaveProfile()

	local money = self:GetNWInt('money')
	local playtime = self:GetSessionTime() + self.Playtime
	local rank = self.Rank
	local inv = self.Inventory
	local savestring = ""

 
	local goodsave = string.sub(savestring, 2)

	local q = "UPDATE players SET money = '"..money.."', playtime = '"..playtime.."' WHERE steamid = '"..self:SteamID64().."'"
	Query(q)

end

util.AddNetworkString("notification")

function Player:Notify(msg)

	net.Start("notification")
		net.WriteString( msg )
	net.Send( self )

end



util.AddNetworkString( "giveothermoney" )
net.Receive("giveothermoney", function( len, pl )

	local ent = net.ReadEntity()
	local amount = net.ReadInt(32)

	pl:GiveOtherMoney(ent, amount)

end)

function Player:GiveOtherMoney( receiver, amount )

	if IsValid(receiver) && receiver:GetClass() == "player" && amount >= 0 then
		if self:RemoveMoney(amount) then
			receiver:AddMoney(amount)
			self:Notify("You gave "..amount.."$ to "..receiver:Nick())
			receiver:Notify("You received "..amount.."$ from "..self:Nick())
		end
	else
		self:Notify("WTF")
	end

end

function Player:GetSalary()
	return JOB_DB[self:Team()].Salary end


-----------------
----DEBUGGING----
-----------------
concommand.Add('rp_saveprofile', function(ply)
	ply:SaveProfile()
end)
concommand.Add('rp_createprofile', function(ply)
	ply:CreateProfile()
end)
concommand.Add('rp_getrank_sv', function(ply)
	print(ply.Rank)
end)

concommand.Add('rp_setrank', function(ply,cmd, args) 
	ply:SetRank(tonumber(args[1])) 
end)

concommand.Add("rp_loadprofile", function(ply) 
	ply:LoadProfile() 
end)

concommand.Add("rp_checkveh", function(ply) 
	PrintTable(ply.Vehicles)
end)