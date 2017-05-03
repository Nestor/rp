local ITEM = {}

ITEM.ID = 3
ITEM.Ref = "item_toilet"
ITEM.Name = "Toilet"

ITEM.Description = "You sit on this."

ITEM.Model = "models/props_c17/FurnitureToilet001a.mdl"
ITEM.LookAt = Vector(-6, -4, -33)
ITEM.CamPos = Vector(59, 37, 19)
ITEM.FOV = 26
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
	