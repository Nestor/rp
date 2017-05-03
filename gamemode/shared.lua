GM.Name = "rp"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

DeriveGamemode( "sandbox" )


function GM:Initialize()

end


JOB_DB = {}
NPC_DB = {}
doortable = {}

doortable = {["models/props_c17/door01_left.mdl"] = true,
["models/props_c17/door02_double.mdl"] = true,
["models/props_warehouse/door.mdl"] = true}
for i=0, 500 do
	doortable["*"..i] = true
end
function GM:LoadJob(tbl)
	JOB_DB[tbl.ID] = tbl
	print("Loaded "..tbl.Name.." job.")
	team.SetUp(tbl.ID, tbl.Name, tbl.Color)
end


function CheckInt( int )
	if isnumber(int) then
		if int >= 0 then
			return true
		else
			if CLIENT then
				GAMEMODE.Notify("Invalid number")
			end
			return false
		end
	else
		if CLIENT then
			GAMEMODE.Notify( "Not a number" )
		end
		return false
	end
end

function parseTime(time, int)
	local days = math.floor(time/86400)
	local hours = math.floor(time/3600 - (days * 24))
	local minutes = math.floor(time/60 - (days*1440) - (hours*60))
	local seconds = math.floor(time - days*86400 - hours*3600 - minutes*60)

	if time > 86399 then return ""..days.."d"..hours.."h"..minutes.."m"..seconds.."s"
	elseif time > 3599 then return "0d"..hours.."h"..minutes.."m"..seconds.."s"
	elseif time > 59 then return "0d0h"..minutes.."m"..seconds.."s"
	else return "0d0h0m"..seconds.."s"
	end
end

function parseAdminTime(time)
	local months = math.floor(time/40320)
	local weeks = math.floor(time/10080 - (months * 4))
	local days = math.floor(time/1440 - (weeks*7) - (months*4))
	local hours = math.floor(time/60 - (weeks*7) - (months*4) - (days*24))
	local minutes = math.floor(time - (weeks*7) - (months*4) - (days*24) - (hours*60))

	local realtime = math.floor(time)

	if realtime == 0 then return "Permanent" end
	if realtime == 60 then return "1 hour" end
	if realtime == 1440 then return "1 day" end
	if realtime == 10080 then return "1 week" end
	if realtime == 43200 then return "1 month" end

	if realtime > 43199 then return ""..months.." months, "..weeks.." weeks, "..days.." days, "..hours.." hours, "..minutes.." minutes"
	elseif realtime > 10079 then return ""..weeks.." week, "..days.." days, "..hours.." hours, "..minutes.." minutes"
	elseif realtime > 1439 then return ""..days.." days, "..hours.." hours, "..minutes.." minutes"
	elseif realtime > 59 then return ""..hours.." hours, "..minutes.." minutes"
	else return ""..minutes.." minutes"
	end

end
function IDToRef( id )
	return ITEM_DB[id].ref end

function IDToQuantity(int, ply)
	if SERVER then
		for k, v in pairs(ply.Inventory) do
			if v.ID == int then
				return v.Quantity
			else
				return 
			end
		end
	end
	if CLIENT then
		for k, v in pairs(GAMEMODE.PlayerInventory) do
			if v.ID == int then
				return v.Quantity
			else
				return 0
			end
		end
	end
end

function GM:LoadNPC( tbl )
	NPC_DB[tbl.ID] = tbl
	print("Loaded NPC "..tbl.Name)
end

function GM:LoadItem(tbl)
	ITEM_DB[tbl.ID] = tbl
	print("Loaded item "..tbl.Name)
end

function GM:LoadVehicle(tbl)
	VEHICLE_DB[tbl.ID] = tbl
	print("Loaded vehicle "..tbl.Name)
end

function GM:LoadProperty(tbl)
	PROPERTY_DB[tbl.ID] = tbl
	print("Loaded property "..tbl.Name)
end