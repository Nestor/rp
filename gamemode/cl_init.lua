ITEM_DB = {}
PROPERTY_DB = {}
VEHICLE_DB = {}
include( 'shared.lua' )

GM.Rank = 0
GM.Jointime = 0
GM.Playtime = 0

include("items/item_chair.lua")
include("items/item_desk.lua")
include("items/item_toilet.lua")
include("vehicles/impreza.lua")

include("sh_player.lua")
include("sh_entity.lua")
include('cl_inventory.lua')
include('cl_admin.lua')
include('cl_font.lua')
include('cl_vehicle.lua')

include('vgui/amountmenu.lua')
include('vgui/actionmenu.lua')
include('vgui/inventory.lua')
include('vgui/itembutton.lua')
include('vgui/campos.lua')
include('vgui/button.lua')
include('vgui/cardealer.lua')
include('vgui/carfile.lua')
include('vgui/camposcar.lua')
include('vgui/dialog.lua')

include('npcs/police.lua')
include('npcs/cardealer.lua')
include('npcs/paramedic.lua')

include('admin/ban.lua')
include('admin/kick.lua')
include('admin/freeze.lua')

include("properties/appshop1.lua")
include("properties/appshop1.lua")
include("properties/appstudio1.lua")
include("properties/appstudio2.lua")
function GM.Notify( string )
	notification.AddLegacy(string, NOTIFY_GENERIC, 3)
end

net.Receive("npc_use", function()
	local talk = vgui.Create(""..net.ReadString())
	talk:MakePopup()
end)

net.Receive( "notification", function()
	GAMEMODE.Notify(net.ReadString())
end)

GM.CreateInventory()

function camdoor()
	for k, v in pairs(ents.GetAll()) do
		if v:IsDoor() && LocalPlayer():GetPos():Distance(v:GetPos()) < 100 && not v:IsVehicle() then
			if v:GetNWEntity("owner") ~= NULL then
				local ang = v:GetAngles()
				local pos = v:GetPos()
				local offset = ang:Up() + ang:Forward() * -1.2 + ang:Right() * - 20
				local offset2 = ang:Up() + ang:Forward() * 1.2 + ang:Right() * - 20;

				ang:RotateAroundAxis(ang:Forward(), 90)
				ang:RotateAroundAxis(ang:Right(), 90)

				cam.Start3D2D(pos + offset, ang, 0.1)
					draw.SimpleText("Owned by "..v:GetNWEntity("owner"):Nick(), "Arial40", 0, 0, Color(122, 122, 0, 255), 1, 1)
				cam.End3D2D()

				ang:RotateAroundAxis(ang:Forward(), 0)
				ang:RotateAroundAxis(ang:Right(), 180)

				cam.Start3D2D(pos + offset2, ang, 0.1)
					draw.SimpleText("Owned by "..v:GetNWEntity("owner"):Nick(), "Arial40", 0, 0, Color(122, 122, 0, 255), 1, 1)
				cam.End3D2D()
			end
		end
	end
end
hook.Add("PostDrawOpaqueRenderables", "camdoor", camdoor)

hook.Add( "HUDShouldDraw", "hide hud", function( name )
	 if ( name == "CHudHealth" || name == "CHudBattery" || name == "CHudAmmo" || name == "CHudSecondaryAmmo" ) || name == "CHudCrosshair" then
		 return false
	 end
end )

function GM.ActionMenu(  )
	local eyetrace = LocalPlayer():GetEyeTrace()
	local actionmenu = vgui.Create("ActionMenu")
	local ent = eyetrace.Entity
	if IsValid(eyetrace.Entity) && eyetrace.StartPos:Distance(eyetrace.HitPos) < 250 then
		if eyetrace.Entity:GetClass() == "player" then 

			actionmenu:AddOption("Give Money", function() 
				local amenu = vgui.Create("CashMenu")
				amenu.Ent = ent
				end,"icon16/money_add.png")
			actionmenu:MakePopup()	
		end
	end
	
	if LocalPlayer():Isadmin() then
		local adminmenu = actionmenu:AddSubMenu("Admin")	

		for k, v in pairs(ADMIN_PLUGIN) do
			adminmenu:AddAdminPlugin( v )
		end
		actionmenu:MakePopup()
	end
end

concommand.Add("rp_actionmenu", GM.ActionMenu)

local money = Material("icon16/money.png")
local time = Material("icon16/time.png")

hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
	//draw.RoundedBox( 0, 0, ScrH()-150, 250, 150, Color(  150 + math.sin(RealTime() * 2) * 50, 0, 0, 255  ) )

	draw.RoundedBox(4, 13, ScrH()-92, 130, 80, Color(32,32,32,240))
	draw.SimpleText("Money:"..tostring(LocalPlayer():GetNWInt('money')).."$", "Arial16", 40, ScrH()-80, Color(0,150,0, 255))
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(money)
	surface.DrawTexturedRect(20, ScrH() - 80, 16, 16)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(time)
	surface.DrawTexturedRect(20, ScrH() - 60, 16, 16)

	draw.SimpleText(""..parseTime(LocalPlayer():GetSessionTime()), "Arial16", 40, ScrH()-60, Color(0,150,150,255))

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(time)
	surface.DrawTexturedRect(20, ScrH() - 40, 16, 16)

	draw.SimpleText(""..parseTime(LocalPlayer():GetPlayTime()), "Arial16", 40, ScrH()-40, Color(0,150,150,255))

end )

-----------------
----DEBUGGING----
-----------------

concommand.Add("rp_campos", function()
	local frame = vgui.Create("DFrame")
	frame:SetSize(800, 400)
	frame:SetPos(ScrW()/2-400, ScrH()/2-300)
	local campos = vgui.Create("CamPos", frame)
	campos:SetPos(0, 0)
	campos:SetSize(800, 400)
	campos.dbutton.DoClick = function() 
		campos:Remove()
		frame:Close()
	end
	frame:MakePopup()
end)
concommand.Add("rp_camposcar", function()
	local frame = vgui.Create("DFrame")
		frame:SetSize(800, 400)
		frame:SetPos(ScrW()/2-400, ScrH()/2-300)
	local campos = vgui.Create("CamPosCar", frame)
		campos:SetPos(0, 0)
		campos:SetSize(800, 400)
		campos.dbutton.DoClick = function() 
			campos:Remove()
			frame:Close()
		end
	frame:MakePopup()
end)
concommand.Add("parsetime", function(ply, cmd, args) 
	print(parseTime(tonumber(args[1])))
end)

concommand.Add("rp_getrank_cl", function() 
	print(CurTime(), GAMEMODE.Playtime,"sd".. GAMEMODE.Jointime)
	print(LocalPlayer():GetSessionTime())
	print(LocalPlayer():GetPlayTime())
end)

concommand.Add("rp_testdb", function()
	PrintTable(VEHICLE_DB)
end)
concommand.Add("rp_testvar", function()
	for k, v in pairs(player.GetAll()) do
		v:GetRank()
	end
end)

function ItemPanel()

	local panel = vgui.Create("DFrame")

		panel:SetSize(600,500)
		panel:SetPos(ScrW()/2-300, ScrH()/2-250)
		panel:SetTitle("Inventory")
		panel:SetVisible( true )
		panel:SetDraggable( false )
		panel:ShowCloseButton( true )
		panel:MakePopup()

	local dlist = vgui.Create("DListView", panel)

		dlist:SetSize(300, 400)
		dlist:SetPos(25, 50)
		dlist:AddColumn( "ID" )
		dlist:AddColumn( "Name" )
		dlist:AddColumn( "Ref name" )
		dlist:AddColumn( "Model")
		dlist:SetMultiSelect(false)
		dlist:GetSortable(false)
		for k,v in pairs(ITEM_DB) do
			dlist:AddLine(""..ITEM_DB[k].ID, ""..ITEM_DB[k].Name, ""..ITEM_DB[k].Ref, ""..ITEM_DB[k].Model)
		end

		dlist:SelectFirstItem()

	local Shape = vgui.Create( "DShape", panel )
		Shape:SetType( "Rect" ) -- This is the only type it can be
		Shape:SetPos( 375, 50 )
		Shape:SetColor( Color( 63, 63, 63, 255 ) )
		Shape:SetSize( 200, 200 )

	local dmodelview = vgui.Create("DModelPanel", panel)

		dmodelview:SetSize(200, 200)
		dmodelview:SetPos(375, 50)
		dmodelview:SetModel(ITEM_DB[dlist:GetSelectedLine()].Model)
		dmodelview:SetCamPos(Vector(20,0,0))
		dmodelview:SetLookAng(Angle(0, 30, 0))
		function dmodelview:LayoutEntity( ent )
			
		end

	local dbutton = vgui.Create("DButton", panel)

		dbutton:SetSize(200, 100)
		dbutton:SetPos(375,300)
		dbutton:SetText("Spawn Item")
		dbutton.DoClick = function()

			local int = dlist:GetSelectedLine()
			net.Start("spawn_item")
				net.WriteInt(int, 4)
			net.SendToServer()
		end


end

concommand.Add("rp_itempanel", ItemPanel)

concommand.Add("rp_inventory", function() 
	local inventory = vgui.Create("Inventory")
	inventory:MakePopup()
end)

concommand.Add("rp_getmodel", function(ply) 
	local eye = ply:GetEyeTrace()

	print(eye.Entity:GetModel())
end)

concommand.Add("rp_getpos", function(ply) 
	local eye = ply:GetEyeTrace()

	print(eye.Entity:GetPos())
end)
concommand.Add("rp_getname", function(ply) 
	local eye = ply:GetEyeTrace()

	print(eye.Entity)
end)
concommand.Add("rp_getangles", function(ply) 
	local eye = ply:GetEyeTrace()

	print(eye.Entity:GetAngles())
end)
concommand.Add("rp_getdoor", function(ply) 
	local eye = ply:GetEyeTrace().Entity
	print("{ Pos = Vector("..eye:GetPos().x..", "..eye:GetPos().y..", "..eye:GetPos().z.."), Model = \""..eye:GetModel().."\"}")
end)
concommand.Add("rp_getentpos", function(ply) 
	local eye = ply:GetEyeTrace().Entity
	print("Vector("..math.Round(eye:GetPos().x, 2)..", "..math.Round(eye:GetPos().y, 2)..", "..math.Round(eye:GetPos().z, 2)..")")
	print("Angle("..math.Round(eye:GetAngles().x, 2)..", "..math.Round(eye:GetAngles().y, 2)..", "..math.Round(eye:GetAngles().z, 2)..")")

end)
concommand.Add("rp_getowner", function(ply)
	local eye = ply:GetEyeTrace().Entity 
	print(eye:GetNWEntity("owner"))
end)

concommand.Add("rp_getselfpos", function(ply)
	local pos = ply:GetPos()
	print("Vector("..pos.x..", "..pos.y..", "..pos.z..")")
end)

concommand.Add("rp_getselfang", function(ply) 
	print(ply:GetAngles())
end)

concommand.Add("rp_cardealer", function() 
	local car = vgui.Create("CarDealer")
	car:MakePopup()
end)

concommand.Add("rp_dialog", function() 
	local dialog = vgui.Create("Dialog")
	dialog.ID = 2
	dialog:MakePopup()
end)
local isopen = isopen or false
local fw, ft = 200, 175
local cx, cy, cz
local isw = isw or false
local vehwe = vehwe or nil
local chair = chair or nil
local f = f or nil

concommand.Add("rp_getbench", function()
	if not isopen then
		isopen = true

		if not IsValid(vehwe) then
			vehwe = nil
			isw = false

			if IsValid(chair) then
				chair:Remove()
				chair = nil
			end
		end

		f = vgui.Create("DFrame")
		f:SetSize(fw, ft)
		f:SetPos(ScrW() - fw - 5, ScrH() / 2 - ft / 2)
		f:SetTitle("")

		f.OnClose = function()
			isopen = false
		end

		local won = vgui.Create("DButton", f)
		won:Dock(TOP)
		won:SetText(isw and "Finish working (and close)" or "Work on this vehicle")

		won.DoClick = function()
			if not isw then
				won:SetText("Finish working (and close)")
				vehwe = LocalPlayer():GetEyeTrace().Entity
				isw = true
				chair = ents.CreateClientProp()
				chair:SetModel("models/nova/airboat_seat.mdl")
				chair:SetPos(vehwe:GetPos())
				chair:SetAngles(vehwe:GetAngles())
				chair:SetParent(vehwe)
				chair:SetMaterial("models/debug/debugwhite")
				chair:SetColor(Color(0, 255, 0))
				chair:Spawn()
				cx = 0
				cy = 0
				cz = 0
				local pc = vgui.Create("DButton", f)
				pc:Dock(TOP)
				pc:SetText("Print to console")

				pc.DoClick = function()
					print("Vector(" .. chair:GetLocalPos().x .. ", " .. chair:GetLocalPos().y .. ", " .. chair:GetLocalPos().z .. ")")
				end
			else
				vehwe = nil
				isw = false
				chair:Remove()
				chair = nil
				f:Close()
			end
		end

		local sposx = vgui.Create("DNumSlider", f)
		sposx:SetText("X: ")
		sposx:SetMin(-200)
		sposx:SetMax(200)
		sposx:SetDecimals(2)
		sposx:Dock(TOP)
		sposx:SetValue(cx)

		sposx.OnValueChanged = function(val)
			cx = math.Round(val:GetValue(), 2)
			chair:SetLocalPos(Vector(cx, cy, cz))
		end

		local sposy = vgui.Create("DNumSlider", f)
		sposy:SetText("Y: ")
		sposy:SetMin(-200)
		sposy:SetMax(200)
		sposy:SetDecimals(2)
		sposy:Dock(TOP)
		sposy:SetValue(cy)

		sposy.OnValueChanged = function(val)
			cy = math.Round(val:GetValue(), 2)
			chair:SetLocalPos(Vector(cx, cy, cz))
		end

		local sposz = vgui.Create("DNumSlider", f)
		sposz:SetText("Z: ")
		sposz:SetMin(-200)
		sposz:SetMax(200)
		sposz:SetDecimals(2)
		sposz:Dock(TOP)
		sposz:SetValue(cz)

		sposz.OnValueChanged = function(val)
			cz = math.Round(val:GetValue(), 2)
			chair:SetLocalPos(Vector(cx, cy, cz))
		end

		if isw then
			local pc = vgui.Create("DButton", f)
			pc:Dock(TOP)
			pc:SetText("Print to console")

			pc.DoClick = function()
				print("Vector(" .. math.Round(chair:GetLocalPos().x, 2) .. ", " .. math.Round(chair:GetLocalPos().y, 2) .. ", " .. math.Round(chair:GetLocalPos().z, 2) .. ")")
			end
		end
	end
end)

hook.Add("Think", "chairpositioning-chair-remover", function()
	if not IsValid(vehwe) and IsValid(chair) then
		chair:Remove()
	end

	if not IsValid(vehwe) and IsValid(f) and isw then
		f:Close()
	end
end)

/*properties.Add('Give Money', {
	MenuLabel = 'Give Money',
	Order = 1,
	MenuIcon = 'icon16/money.png',
	Filter = function(self, ent, ply)
		return ent:IsPlayer()
	end,
	Action = function(self, ent)
		if not IsValid(ent) or not ent:IsPlayer() then return false end
		
		Derma_StringRequest('Give money','The amount of money that you want to give to '..ent:Nick()..":",'',function(amount)
			if not IsValid(ent) then return end

			if not isnumber(tonumber(amount)) then 
				GAMEMODE.Notify("Invalid number")
				return 
			end

			if LocalPlayer():GetNWInt("money") - amount < 0 then
				GAMEMODE.Notify("Not enough money")	
				return
			end
				
			net.Start( "giveothermoney" )
				net.WriteEntity(ent)
				net.WriteInt(tonumber(amount), 32)
			net.SendToServer()
		end, nil, "Accept", "Decline")

		return true
	end
})*/
