local Entity = FindMetaTable("Entity")



function Entity:IsDoor()
	if self:IsVehicle() then return true end
	if not doortable[self:GetModel()] then return false end
	return true
end

-----------------
----DEBUGGING----
-----------------


/*concommand.Add("rp_getowner", function(ply)
	local eye = ply:GetEyeTrace().Entity 
	print(eye.Owner, eye:GetNWEntity("owner"))
end)*/

concommand.Add("rp_isdoor", function(ply)
	local eye = ply:GetEyeTrace().Entity
	print(eye:IsDoor())
end)

