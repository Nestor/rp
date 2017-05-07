local LOCAL = 0
local RADIO = 1
local ADMIN = 2

function GM:PlayerCanHearPlayersVoice( listener, talker )
	if listener:GetPos():Distance(talker:GetPos()) <= 500 then
		return true, true
	end
end

function GM:PlayerSay( sender, text, isteam)

	if isteam && sender:IsPolice() then
		GAMEMODE.PlayerRealSay(nil, RADIO, Color(0,0,255), "[RADIO]".. sender:Nick()..":", Color(255, 255 , 255), string.sub(text, 1))
		return ""
	end
	if string.sub(text, 1, 6) == "/radio" && sender:IsPolice() then
		GAMEMODE.PlayerRealSay(nil, RADIO, Color(0,0,255), "[RADIO]".. sender:Nick()..":"..string.sub(text, 8))
		return ""
	end
	if string.sub(text, 1, 6) == "/radio" || isteam && not sender:IsPolice() then
		sender:Notify("You can't use the radio if you are not a government employee!")
		return ""
	end
	if string.sub( text, 1, 4) == "/ooc" then
		GAMEMODE.PlayerRealSay(nil, nil, Color(255, 255, 255),"[OOC]", JOB_DB[sender:Team()].Color, sender:Nick()..":", Color(255, 255, 255), string.sub(text, 5))
		return ""
	end
	if string.sub( text, 1, 2) == "//" then
		GAMEMODE.PlayerRealSay(nil, nil, Color(255, 255, 255),"[OOC]", JOB_DB[sender:Team()].Color, sender:Nick()..":", Color(255, 255, 255), string.sub(text, 3))
		return ""
	end
	if string.sub(text, 1, 5) == "/looc" then
		GAMEMODE.PlayerRealSay(sender, LOCAL, Color(255, 255, 255), "[LOOC]", JOB_DB[sender:Team()].Color, sender:Nick()..":", Color(255, 255, 255), string.sub(text, 6))
		return ""
	end
	if string.sub(text, 1, 6) == "/admin" && sender:Isadmin() then
		GAMEMODE.PlayerRealSay(sender, ADMIN, Color(255, 0, 0), "[ADMIN]"..sender:Nick()..":"..string.sub(text, 8))
		return ""
	end
	if string.sub(text, 1, 6) == "/admin" && not sender:Isadmin() then
		sender:Notify("You can't use the admin chat if you are not an admin!")
		return ""
	end
	GAMEMODE.PlayerRealSay(sender, LOCAL, JOB_DB[sender:Team()].Color, sender:Nick()..":", Color(255, 255, 100), " "..text)
	return ""

end



util.AddNetworkString("chat")
function GM.PlayerRealSay(...)
	arg = {...}
	net.Start("chat")
	net.WriteInt(#arg, 32)
		if type(arg[1]) == "Player" && arg[2] == nil then		
			for _, v in pairs(arg) do
				if type(v) == "string" then
					net.WriteString(v)
				elseif type(v) == "table" then
					net.WriteInt(v.r, 32)
					net.WriteInt(v.g, 32)
					net.WriteInt(v.b, 32)
				end
			end
		net.Send(arg[1])
		elseif type(arg[2]) == "number" then
			if arg[2] == LOCAL then
				local tosend = {}
				for _, v in pairs(arg) do
					if type(v) == "string" then
						net.WriteString(v)
					elseif type(v) == "table" then
						net.WriteInt(v.r, 32)
						net.WriteInt(v.g, 32)
						net.WriteInt(v.b, 32)
					end
				end
				for k,v in pairs(ents.FindInSphere(arg[1]:GetPos(), 500)) do
					if type(v) == "Player" then
						table.insert(tosend, v)
					end
				end
				net.Send(tosend)
			elseif arg[2] == RADIO then
				local tosend = {}
				for _, v in pairs(arg) do
					if type(v) == "string" then
						net.WriteString(v)
					elseif type(v) == "table" then
						net.WriteInt(v.r, 32)
						net.WriteInt(v.g, 32)
						net.WriteInt(v.b, 32)
					end
				end
				for k, v in pairs(player.GetAll()) do
					if v:Team() == 2 then
						table.insert(tosend, v)
					end
				end
				net.Send(tosend)
			elseif arg[2] == ADMIN then
				local tosend = {}
				for _, v in pairs(arg) do
					if type(v) == "string" then
						net.WriteString(v)
					elseif type(v) == "table" then
						net.WriteInt(v.r, 32)
						net.WriteInt(v.g, 32)
						net.WriteInt(v.b, 32)
					end
				end
				for k,v in pairs(player.GetAll()) do
					if v:Isadmin() then
						table.insert(tosend, v)
					end
				end
				net.Send(tosend)
			end
		else
			for _, v in pairs(arg) do
				if type(v) == "string" then
					net.WriteString(v)
				elseif type(v) == "table" then
					net.WriteInt(v.r, 32)
					net.WriteInt(v.g, 32)
					net.WriteInt(v.b, 32)
				end
			end
		net.Broadcast()
		end
end
