local Player = FindMetaTable("Player")

function Player:CreateInventory()

	local Inventory = {}

	for i=1,32 do 
		table.insert(Inventory, {Slot = 0, ID = 0, Quantity = 0, Ref = "" })
	end
	
	return Inventory

end

util.AddNetworkString("item_set")
function Player:SetItem(slot, id, quantity)

	self.Inventory[slot].Slot     = slot
	self.Inventory[slot].ID       = id
	self.Inventory[slot].Quantity = quantity
	self.Inventory[slot].Ref 	  = ITEM_DB[tonumber(id)].Ref

	net.Start("item_set")
		net.WriteInt(slot, 32)
		net.WriteInt(id, 32)
		net.WriteInt(quantity, 32)
	net.Send(self)

end

function Player:PrintInventory()
	local inv = self.Inventory

	for k, v in pairs(inv) do 
		if(v.ID) ~= 0 then
			PrintTable(v)
		end
	end
end

util.AddNetworkString("item_give")
function Player:GiveItem(id, quantity)
	local inv = self.Inventory

	if ITEM_DB[id] then
		for k, v in pairs(self.Inventory) do
			if v.ID == id then

				inv[k].Slot = k
				inv[k].Quantity = v.Quantity + quantity
				net.Start("item_give")
					net.WriteInt(id, 32)
					net.WriteInt(quantity, 32)
				net.Send(self)

				Query("UPDATE items SET quantity='"..v.Quantity.."' WHERE steamid = '"..self:SteamID64().."' AND itemid = '"..v.ID.."' ")
				break
			end

			if v.ID == 0 then

				inv[k] = {Slot = k, ID = id, Quantity = quantity, Ref = ITEM_DB[id].Ref}
				net.Start("item_give")
						net.WriteInt(id, 32)
						net.WriteInt(quantity, 32)
				net.Send(self)
				Query("INSERT INTO items (steamid, itemid, quantity) VALUES ('"..self:SteamID64().."', '"..id.."', '"..quantity.."')")
				break
			end
		end
	else
		print("Wrong ID")
		self:Notify("Wrong ID")
	end
end

util.AddNetworkString("remove_item")
function Player:RemoveItem(id, quantity)
	local inv = self.Inventory
	if not id or not quantity then print("Args missing") return end

	for k, v in pairs(inv) do
		if v.ID == id then

			local quant = v.Quantity
			if(quant - quantity) < 0 then
				break
			elseif (quant - quantity) > 0 then

				inv[k].Quantity = v.Quantity - quantity
				net.Start("remove_item")
					net.WriteInt(id, 32)
					net.WriteInt(quantity, 32)
				net.Send(self)
				Query("UPDATE items SET quantity = '"..v.Quantity.."' WHERE steamid = '"..self:SteamID64().."' AND itemid = '"..v.ID.."'")
				break
			elseif (quant - quantity) == 0 then
				self:ClearSlot(v.Slot)
				Query("DELETE FROM items WHERE steamid='"..self:SteamID64().."' AND itemid='"..v.ID.."' ")
				break	
			end
			break
		end
	end
end
util.AddNetworkString("item_changeslot")

net.Receive("item_changeslot", function(len, ply) 
	ply:ChangeItemSlot(net.ReadInt(16), net.ReadInt(16))
end)
function Player:ChangeItemSlot(oldslot, newslot) --If there's an item in the newslot, switch it

		local inv = self.Inventory

		if newslot > 32 && oldslot > 32 then

			print('Slot number is too high')
			return

		elseif oldslot == newslot then
			
			print("Can't have the same slot number!")
			return 
		end

		for k, v in pairs(inv) do 

			if self:SlotIsEmpty(newslot) then
				self:SetItem(newslot, inv[oldslot].ID, inv[oldslot].Quantity)
				self:ClearSlot(oldslot)
				/*net.Start("item_changeslot")
					net.WriteInt(oldslot, 32)
					net.WriteInt(newslot, 32)
				net.Send(self)*/
				break
			end

			if not self:SlotIsEmpty(newslot) then
				if self:SlotIsEmpty(oldslot) then
					self:SetItem(oldslot, inv[newslot].ID, inv[newslot].Quantity)
					self:ClearSlot(newslot)
					/*net.Start("item_changeslot")
						net.WriteInt(oldslot, 32)
						net.WriteInt(newslot, 32)
					net.Send(self)*/
					break
				else
				local oldid, oldquant = inv[newslot].ID, inv[newslot].Quantity
					self:SetItem(newslot, inv[oldslot].ID, inv[oldslot].Quantity)
					self:SetItem(oldslot, oldid, oldquant)
					/*net.Start("item_changeslot")
						net.WriteInt(newslot, 32)
						net.WriteInt(oldslot, 32)
					net.Send()*/
					break
				end
				break
			end
		end	
end

util.AddNetworkString("item_clearslot")
function Player:ClearSlot(slot)
	local inv = self.Inventory
	inv[slot] = {Slot = 0, ID = 0, Quantity = 0, Ref = ""}
	net.Start("item_clearslot")
		net.WriteInt(slot, 32)
	net.Send(self)
	/*for k,v in pairs(inv) do
		if v.Slot == slot then
			inv[k] = {Slot = 0, ID = 0, Quantity = 0, Ref = ""}
			break
		end
	end*/
end

util.AddNetworkString("inventory")
function Player:SendInventory()

	local inv = self.Inventory


		for k,v in pairs(inv) do

			if v.ID ~= 0 then
				net.Start("inventory")
					net.WriteInt( v.ID, 32 )
					net.WriteInt( v.Quantity, 32 )
					net.WriteInt( v.Slot, 32 )
				net.Send( self )
			end
		end
end

function Player:GetItemSlot(slot)
	return self.Inventory[slot] end

function Player:SlotIsEmpty(slot)
	local inv = self.Inventory

	if inv[slot].ID == 0 then
		return true
	else
		return false
	end
end

function Player:GetItemID(id)
	local inv = self.Inventory
	local id = tonumber(id)
	for k,v in pairs(inv) do

		if v.ID == id then
			return true
		else
			return false
		end
	end
end

function Player:GetInventory()
	return self.Inventory end

util.AddNetworkString("item_use")

net.Receive("item_use", function(len, ply) 
	ply:UseItem(net.ReadInt(32))
end)

util.AddNetworkString("item_drop")
net.Receive("item_drop", function(len, ply) 
	ply:DropItem(net.ReadInt(32))
end)
function Player:UseItem(id)
	local inv = self.Inventory 
	local id = tonumber(id)

	for k,v in pairs(self.Inventory) do
		
		if v.ID == id then
			if v.Quantity > 0 then
				self:RemoveItem(id, 1)
				ITEM_DB[id].Use(self)
			end
		end
		break
	end
end

function Player:DropItem(itemid)

	local trace = self:GetEyeTrace()

	for k, v in pairs(self.Inventory) do
		if v.ID == itemid && v.Quantity > 0 then

			local ent = ents.Create("ent_item")
				ent:SetModel(ITEM_DB[itemid].Model)
				ent:SetPos(self:EyePos() + self:GetAngles():Forward() * 64 + Vector(0, 0, 20))
				ent:SetID(itemid)
				ent:Spawn()
				self:RemoveItem(itemid, 1)
			break
		end	
	end
end

-----------------
----DEBUGGING----
-----------------

util.AddNetworkString("spawn_item")

net.Receive("spawn_item", function(len, pl) 
	local item = ents.Create("ent_item")
	item.ID = net.ReadInt(4)
	item:SetModel(ITEM_DB[item.ID].Model)
	item:SetPos(pl:EyePos() + pl:GetAngles():Forward() * 64 + Vector(0, 0, 20))
	item:Spawn()
end)

concommand.Add('rp_seeinventory', function(ply)
	ply:PrintInventory()
end)

concommand.Add('rp_changeitemslot', function(ply, cmd, args)
	if args[1] && args[2] then
		ply:ChangeItemSlot(tonumber(args[1]), tonumber(args[2]))
	else
		print('Wrong arg')
	end
end)


concommand.Add('rp_sendinventory', function(ply)
	ply:SendInventory()
end)


concommand.Add('rp_setitem', function(ply, cmd, args)
	if args[1] && args[2] && args[3] then
		ply:SetItem(args[1], args[2], args[3])
	else
		print('Wrong arg')
	end
end)
concommand.Add('rp_slotisempty', function(ply, cmd, args)
	if args[1] then
		print(ply:SlotIsEmpty(tonumber(args[1])))
	else
		print('Wrong arg')
	end
end)
concommand.Add('rp_removeitem', function(ply, cmd, args)
	if args[1] && args[2] then
		ply:RemoveItem(tonumber(args[1]), tonumber(args[2]))
	else
		print('Wrong arg')
	end
end)
concommand.Add('rp_clearslots', function(ply) 
	for k,v in pairs(ply.Inventory) do
		ply:ClearSlot(k)
	end
end)
concommand.Add('rp_useitem', function(ply, cmd, args)
	ply:UseItem(args[1])
end)

concommand.Add('rp_giveitem', function(ply, cmd, args)
	if args[1] && args[2] then
		ply:GiveItem(tonumber(args[1]), tonumber(args[2]))
	else
		print('Wrong arg')
	end
end)

concommand.Add("rp_clearslot", function(ply, cmd, args) 
	ply:ClearSlot(tonumber(args[1]))

end)

