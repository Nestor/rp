RP = {}
VEHICLE_DB = {}
ITEM_DB = {}
PROPERTY_DB = {}
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_inventory.lua" )
AddCSLuaFile( "sh_player.lua" )
AddCSLuaFile( "cl_admin.lua" )
AddCSLuaFile('cl_font.lua')
AddCSLuaFile( "sh_entity.lua" )
AddCSLuaFile( "cl_vehicle.lua")
AddCSLuaFile('admin/ban.lua')
AddCSLuaFile('admin/kick.lua')
AddCSLuaFile('admin/freeze.lua')

include( "sh_entity.lua" )
include( "sh_player.lua" )
include( "sv_player.lua" )
include( "sv_entity.lua" )
include( "sv_sql.lua" )
include( "shared.lua" )
include( "sv_chat.lua" )
include( "sv_inventory.lua" )
include( "sv_networking.lua" )
include( "sv_admin.lua" )
include( "sv_vehicle.lua" )
include( "sv_property.lua" )

for k, v in pairs(file.Find("gamemodes/rp/gamemode/vgui/*.lua", "GAME")) do
	--include("vgui/"..v)
	AddCSLuaFile("vgui/"..v)
end


for k, v in pairs(file.Find("gamemodes/rp/gamemode/npcs/*.lua", "GAME")) do
	include("npcs/"..v)
	AddCSLuaFile("npcs/"..v)
end

for k, v in pairs(file.Find("gamemodes/rp/gamemode/jobs/*.lua", "GAME")) do
	include("jobs/"..v)
	AddCSLuaFile("jobs/"..v)
end

for k, v in pairs(file.Find("gamemodes/rp/gamemode/items/*.lua", "GAME")) do
	include("items/"..v)
	AddCSLuaFile("items/"..v)
end

for k, v in pairs(file.Find("gamemodes/rp/gamemode/vehicles/*.lua", "GAME")) do
	include("vehicles/"..v)
	AddCSLuaFile("vehicles/"..v)
end

for k, v in pairs(file.Find("gamemodes/rp/gamemode/properties/*.lua", "GAME")) do
	include("properties/"..v)
	AddCSLuaFile("properties/"..v)
end

function GM:PlayerInitialSpawn(ply)
	ply.Inventory = ply:CreateInventory()
	ply.Vehicles = {}
	ply:SetTeam(1)
	ply:LoadProfile()

	--ply:SendInventory()
	--ply:SetRank(self.Rank)
end

function IDToRef( id )
	return ITEM_DB[id].ref end

function ChangeTeam(ply, cmd, args)
	ply:SetTeam(args[1])
	ply:Spawn()
end
concommand.Add('rp_changeteam', ChangeTeam)

GM.LoadoutTable = {"weapon_physgun", "weapon_physcannon", "gmod_tool", "gmod_camera", "weapon_keys"}

function GM:PlayerSpawn( ply )
	ply:SetModel(JOB_DB[ply:Team()].Model)
	ply:StripWeapons()
	for k, v in pairs(GAMEMODE.LoadoutTable) do
		ply:Give(v)
	end
	for k, v in pairs(JOB_DB[ply:Team()].Loadout) do
		ply:Give(v)
	end
end

function GM:PlayerDisconnected( ply )
	ply:SaveProfile()
end
timer.Create('payday',10, 0, function() 
	for k, v in pairs( player.GetAll() ) do
		v:AddMoney(v:GetSalary())
		--v:SaveProfile()
		v:Notify("Received "..v:GetSalary().."$ for salary!")
	end 
end)

function GM:InitPostEntity()
	for k, v in ipairs(NPC_DB) do
	
		local npc = ents.Create("npc_base")

			npc:SetID(v.ID)
			npc:SetPos(v.Location)
			npc:SetAngles(v.Angles)
			npc:SetModel(v.Model)
			npc.Panel = v.Panel
			npc:Spawn()
	end
	for k,v in pairs(ents.GetAll()) do
		if v:GetModel() == "models/sickness/genericsign_001.mdl" then
			v:Remove()
		end
	end
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
	local query = "SELECT * FROM bans WHERE steamid = '"..ply:SteamID64().."'"

	GetDataQuery(query, function(tbl) 
		if tbl[1] == nil then return end

		local bantime = tbl[1].bantime
		local banduration = tbl[1].banduration

		if banduration == 0 then
			ply:Kick("You are permanently banned.")
		end
		local minuteduration = (bantime+banduration-os.time())/60
		
		if os.time() < bantime+banduration then
			ply:Kick("Banned for "..parseAdminTime(minuteduration))
			return
		elseif os.time() > bantime+banduration then
			Query("DELETE FROM bans WHERE steamid = '"..ply:SteamID64().."'")
			return
		end
	end)
end

function GM:PhysgunPickup(ply, ent)
	if ent:IsDoor() || ent:IsVehicle() || ent:GetClass() == "npc_base" then return ply:Isadmin()
	else 
		return true
	end
end

function GM:CheckPassword(steamid64)
	local query = "SELECT * FROM bans WHERE steamid = '"..steamid64.."'"

	GetDataQuery(query, function(tbl)
		if tbl[1] == nil then return end
		local bantime = tbl[1].bantime
		local banduration = tbl[1].banduration

		local minuteduration = (bantime+banduration-os.time())/60
		print(minuteduration)
		if os.time() < bantime+banduration then
			return false, "Banned for "..parseAdminTime(minuteduration)
		elseif os.time() > bantime+banduration then
			Query("DELETE FROM bans WHERE steamid = '"..ply:SteamID64().."'")
			return true
		end
	end)
end


concommand.Add("rp_testdb2", function(ply)
	PrintTable(VEHICLE_DB)
end)