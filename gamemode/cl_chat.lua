hook.Add("StartChat", "StartedChat", function(isteam) 

end)

hook.Add("ChatText", "RemoveJoin", function(index, name, text, typ) 
	if typ == "joinleave" || typ == "namechange" || typ == "servermsg" || typ == "teamchange" then
		return true
	end
	if LocalPlayer():Team() == 1 && string.find(text, "[RADIO]") then
		return true
	end
end)

function GM:OnPlayerChat(ply, text, isteam, isdead)

	chat.AddText(Color(255, 0, 0), text)
	return true
end

net.Receive("chat", function() 
	local argc = net.ReadInt(32)
	local args = {}

	for i = 1, argc/2, 1 do
		table.insert(args, Color(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32), 255))
		table.insert(args, net.ReadString())
	end

	chat.AddText( unpack(args) )
	chat.PlaySound()
end)