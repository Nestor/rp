GM.PlayerVehicles = { }

net.Receive("vehicles", function() 
	local vehid = net.ReadInt(32)
	local vehcolor = Color(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))

	GAMEMODE.PlayerVehicles[vehid] = {Color = vehcolor}
	PrintTable(GAMEMODE.PlayerVehicles)
end)

function GM.PlayerHasVehicle(id)
	for k,v in pairs(GAMEMODE.PlayerVehicles) do
		if k == id then 
			return true
		else
			return false
		end
	end
end

function GM.PlayerBuyCar(vehid, color)
	PrintTable(color)
	net.Start("buy_car")
		net.WriteInt(vehid, 32)
		net.WriteInt(color.r, 32)
		net.WriteInt(color.g, 32)
		net.WriteInt(color.b, 32)
	net.SendToServer()
end

-----------------
----DEBUGGING----
-----------------

concommand.Add("rp_playerhasvehicle", function(ply, cmd, args)  
	print(GAMEMODE.PlayerHasVehicle(tonumber(args[1])))
end)

concommand.Add("rp_clearvehicles_cl", function(ply) 
	GAMEMODE.PlayerVehicles = {}
end)