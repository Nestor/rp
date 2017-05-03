net.Receive( "notification", function()
	notification.AddLegacy(net.ReadString(), NOTIFY_GENERIC, 3)
end)