local PLUGIN = { }
PLUGIN.ID = 2
PLUGIN.Name = "Ban"
PLUGIN.Reasons = { "Disrespecting the admin","RDM","Bye"}
PLUGIN.DefaultTime = { 10, 60, 1440, 10080, 43200, 0}
PLUGIN.Func = function( ply, reason, time)
	if IsValid(ply) && LocalPlayer():Isadmin() then
		net.Start("ban_player")
			net.WriteEntity( ply )
			net.WriteInt(time, 32)
			net.WriteString(reason)
		net.SendToServer()
	else
		GAMEMODE.Notify("Not an admin")
	end
end
GM.LoadAdminPlugin(PLUGIN)