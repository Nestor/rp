ADMIN_PLUGIN = {}

function GM.LoadAdminPlugin( plugin )
	ADMIN_PLUGIN[plugin.ID] = plugin
	print("Loaded "..plugin.Name) 
end
