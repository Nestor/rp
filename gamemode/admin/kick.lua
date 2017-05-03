local PLUGIN = { }
PLUGIN.ID = 1
PLUGIN.Name = "Kick"
PLUGIN.Reasons = { "Disrespecting the admin","RDM","Bye"}
PLUGIN.Func = function( ply, reason)
	if IsValid(ply) && LocalPlayer():Isadmin() then
		net.Start("kick_player")
			net.WriteEntity( ply )
			net.WriteString(reason)
		net.SendToServer()
	else
		GAMEMODE.Notify("Not an admin")
	end
end
GM.LoadAdminPlugin(PLUGIN)