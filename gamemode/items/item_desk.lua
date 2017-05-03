local ITEM = {}

ITEM.ID = 2
ITEM.Ref = "item_desk"
ITEM.Name = "Desk"

ITEM.Description = "To work on."

ITEM.Model = "models/props_combine/breendesk.mdl"
ITEM.LookAt = Vector(-3, 12, 7)
ITEM.CamPos = Vector(42, 55, 45)
ITEM.FOV = 66

if SERVER then
	ITEM.Use = function(ply)
		local prop = ents.Create("prop_physics")
		prop:SetModel(ITEM.Model)
		prop:SetPos(ply:EyePos() + ply:GetAngles():Forward() * 64 + Vector(0, 0, 20))
		prop:Spawn()
	end
	ITEM.OnUse = function(ply)
		ply:SpawnItem(ITEM.ID)
	end
	
end


GM:LoadItem(ITEM)
	