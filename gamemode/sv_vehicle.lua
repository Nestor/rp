local Player = FindMetaTable("Player")

local BuyCarPos = { { Pos = Vector(4364.31, -5898.44, 55.78), Ang = Angle(0, 158.55, 0.18) }  }

function Player:SpawnVehicle(id, color, pos, ang)
	if self.SpawnedVehicle then self:Notify("Already a car spawned") return end
	local vehicle = ents.Create("prop_vehicle_jeep")
		vehicle:SetPos(pos)
		vehicle:SetAngles(ang)
		vehicle:SetModel(VEHICLE_DB[id].Model)
		vehicle:SetColor(color)
		vehicle:SetKeyValue("vehiclescript", "scripts/vehicles/"..VEHICLE_DB[id].Script..".txt")
		vehicle:Setowner(self)
		vehicle.SeatDB = { }
		vehicle.ExitPoint = VEHICLE_DB[id].ExitPoint
		vehicle:lock()
		for k,v in pairs(VEHICLE_DB[id].PassengerSeats) do
			local seats = ents.Create("prop_vehicle_prisoner_pod")
				seats:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
				seats:SetModel("models/nova/airboat_seat.mdl")
				seats:SetPos(vehicle:GetPos()+v)
				seats:SetParent(vehicle)
				seats:SetNoDraw(true)
			seats:Spawn()
			vehicle.SeatDB[k] = seats
		end
	vehicle:Spawn()
	self.SpawnedVehicle = vehicle
end
function GM.EnterVehicle(ply, veh)
	if not IsValid(ply) || not IsValid(veh) || not veh:IsVehicle() || not ply:IsPlayer() || veh.Locked then return end

	if veh:GetModel() == "models/nova/jeep_seat.mdl" then

	else
		if veh:GetDriver() ~= NULL then
			for k,v in pairs(veh.SeatDB) do
				if v:GetDriver() == NULL then
					ply:EnterVehicle(v)
					break
				end
			end
		end
	end
end
hook.Add("PlayerUse", "entervehicle", GM.EnterVehicle)

util.AddNetworkString("vehicles")

function Player:BuyVehicle(vehid, color)
	if not VEHICLE_DB[vehid] || self:GetNWInt("money") < VEHICLE_DB[vehid].Price then return end
	local colorstring = ""..color.r.." "..color.g.." "..color.b.." 255"
	self:RemoveMoney(VEHICLE_DB[vehid].Price)
	self.Vehicles[vehid] = {Color = color}
	Query("INSERT INTO vehicles (steamid, steamname, vehicleid, color) VALUES ('"..self:SteamID64().."', '"..self:Nick().."' ,'"..vehid.."', '"..colorstring.."') ")
	net.Start("vehicles")
		net.WriteInt(vehid, 32)
		net.WriteInt(color.r, 32)
		net.WriteInt(color.g, 32)
		net.WriteInt(color.b, 32)
	net.Send(self)
	if self.SpawnedVehicle then
		self.SpawnedVehicle:Remove()
		self.SpawnedVehicle = nil
	end
	print(BuyCarPos[1])
	self:SpawnVehicle(vehid, color, BuyCarPos[1].Pos, BuyCarPos[1].Ang)
end

function Player:RemoveCar()
	self.Vehicles = {}

	self.SpawnedVehicle:Remove()
end
function Player:HasVehicle(vehid)
	for k,v in pairs(self.Vehicles) do
		if k == vehid then 
			return true
		else
			return false
		end
	end
end

function Player:SetVehicle(vehid, color)
	self.Vehicles[vehid] = {Color = color}
	net.Start("vehicles")
		net.WriteInt(vehid, 32)
		net.WriteInt(color.r, 32)
		net.WriteInt(color.g, 32)
		net.WriteInt(color.b, 32)
	net.Send(self)
end

function Player:SendVehicles()
	for k,v in pairs(self.Vehicles) do
		net.Start("vehicles")
			net.WriteInt(v.ID, 32)
			net.WriteInt(v.color.r, 32)
			net.WriteInt(v.color.g, 32)
			net.WriteInt(v.color.b, 32)
		net.Send(self)
	end
end

function Player:ChangePaint(vehid, color)
	if not self.Vehicles[vehid] then return end
	local colorstring = ""..color.r.." "..color.g.." "..color.b" 255"
	self.Vehicles[vehid] = {Color = color}
	net.Start("vehicles")
		net.WriteInt(vehid, 32)
		net.WriteInt(color.r, 32)
		net.WriteInt(color.g, 32)
		net.WriteInt(color.b, 32)
	net.Send(self)
	Query("UPDATE vehicles SET color = '"..colorstring.."' WHERE steamid = '"..self:SteamID64().."'")
end
util.AddNetworkString("buy_car")

net.Receive("buy_car", function(len, ply) 
	local carid, color = net.ReadInt(32), Color(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))

	ply:BuyVehicle(carid, color)
end)
/*
function GM:PlayerEnteredVehicle(ply, veh)
	
end
function GM:CanPlayerEnterVehicle(ply, veh)

end*/

function GM:PlayerLeaveVehicle(ply, veh)
	if veh:GetParent() ~= NULL then
		print(veh:GetParent())
		ply:SetPos(veh:GetParent():GetRight() + veh:GetParent().ExitPoint)
		return
	end
	print(veh:EyeAngles())
	ply:SetPos(veh:GetPos()+veh.ExitPoint)
end

-----------------
----DEBUGGING----
-----------------

concommand.Add("rp_spawnvehicle", function(ply, cmd, args)
	ply:SpawnVehicle(tonumber(args[1]))
end)
concommand.Add("rp_getinseat", function(ply, cmd, args) 
	local eye = ply:GetEyeTrace().Entity
	ply:EnterVehicle(eye.SeatDB[tonumber(args[1])])
end)

concommand.Add("rp_sendvehicles", function(ply) 
	ply:SendVehicles()
end)

concommand.Add("rp_newcolor", function(ply, cmd, args) 
	ply:ChangePaint(tonumber(args[1]), tonumber(args[2]))
end)

concommand.Add("rp_getvehicles", function(ply) 
	for k,v in pairs(ply.Vehicles) do
		print(k, v.Color)
	end
end)

concommand.Add("rp_spawnpersonalvehicle", function(ply, cmd, args) 
	if not ply.Vehicles[tonumber(args[1])] then return end

	ply:SpawnVehicle(tonumber(args[1]), ply.Vehicles[tonumber(args[1])].Color, ply:GetPos(), ply:GetAngles())
end)

concommand.Add("rp_clearvehicles_sv", function(ply) 
	ply.Vehicles = {}
end)

concommand.Add("rp_printcartable", function() 
	PrintTable(BuyCarPos)
end)