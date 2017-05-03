local PLUGIN = { }
PLUGIN.ID = 3
PLUGIN.Name = "Freeze"
PLUGIN.Func = function( ply )
	if IsValid(ply) && LocalPlayer():Isadmin() then
		net.Start("freeze_player")
			net.WriteEntity( ply )
		net.SendToServer()
	else
		GAMEMODE.Notify("Not an admin")
	end
end
GM.LoadAdminPlugin(PLUGIN)