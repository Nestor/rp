local ITEM = {}

ITEM.ID = 1
ITEM.Ref = "item_metalchair"
ITEM.Name = "Metal Chair"

ITEM.Description = "You sit on this."

ITEM.Model = "models/props_c17/chair02a.mdl"
ITEM.CamPos = Vector(50, 50, 50)
ITEM.LookAt = Vector(5, -9, -2)
ITEM.FOV = 30

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
	