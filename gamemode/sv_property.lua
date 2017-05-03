local Player = FindMetaTable("Player")

function Player:RentProperty(id)
	if not PROPERTY_DB[id] || not self:IsValid() then return end
	for _, v in pairs(PROPERTY_DB[id].Doors) do
		for _, u in pairs(ents.FindInSphere(v.Pos, 5)) do
			if v.Model == u:GetModel() && u.Owner == NULL then
				u:Setowner(self)
			end
		end
	end
end

function Player:VacantProperty(id)
	if not PROPERTY_DB[id] || not self:IsValid() then return end
	for _, v in pairs(PROPERTY_DB[id].Doors) do
		for _, u in pairs(ents.FindInSphere(v.Pos, 5)) do
			if v.Model == u:GetModel() then
				u:Setowner(NULL)
			end
		end
	end
end

-----------------
----DEBUGGING----
-----------------

concommand.Add("rp_rentproperty", function(ply, cmd, args) 
	ply:RentProperty(tonumber(args[1]))
end)

concommand.Add("rp_vacantproperty", function(ply, cmd, args) 
	ply:VacantProperty(tonumber(args[1]))
end)