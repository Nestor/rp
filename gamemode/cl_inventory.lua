GM.PlayerInventory = { }

function GM.CreateInventory()

	for i = 1, 32 do
		table.insert(GM.PlayerInventory, {Slot = 0, ID = 0, Quantity = 0, Ref = "" })
	end

end


net.Receive( "inventory", function()
	local id = net.ReadInt(32)
	local quant = net.ReadInt(32)
	local slot = net.ReadInt(32)
	GAMEMODE.SetItem(slot, id, quant)
end)

function GM.GiveItem(id, quantity)

	local inv = GAMEMODE.PlayerInventory

	for k, v in pairs(inv) do

		if v.ID == id then

			inv[k].Slot = k
			inv[k].Quantity = v.Quantity + quantity

			break
		end

		if v.ID == 0 then

			inv[k].ID = id
			inv[k].Slot = k
			inv[k].Quantity = quantity
			inv[k].Ref = ITEM_DB[id].Ref

			break
		end
	end
end

function GM.RemoveItem(id, quantity)
	local inv = GAMEMODE.PlayerInventory

	for k, v in pairs(inv) do

		if v.ID == id then

			local quant = v.Quantity

			if(quant - quantity) < 0 then

				break
			elseif (quant - quantity) >= 0 then

				inv[k].Quantity = v.Quantity - quantity

				break
			elseif (quant - quantity) <= 0 then

				GAMEMODE.ClearSlot(v.Slot)

				break	
			end
			break
		end
	end
end


function GM.ClearSlot(slot)
	local inv = GAMEMODE.PlayerInventory
	inv[slot] = {Slot = 0, ID = 0, Quantity = 0, Ref = ""}
end

function GM.SlotIsEmpty(slot)
	local inv = GAMEMODE.PlayerInventory

	if inv[slot].ID == 0 then
		return true
	else
		return false
	end
end

function GM.ChangeItemSlot(oldslot, newslot) --If there's an item in the newslot, switch it

		local inv = GAMEMODE.PlayerInventory

		if newslot > 32 && oldslot > 32 then

			print('Slot number is too high')
			return

		elseif oldslot == newslot then
			
			print("Can't have the same slot number!")
			return 
		end

		for k, v in pairs(inv) do 

			if GAMEMODE.SlotIsEmpty(newslot) then
				GAMEMODE.SetItem(newslot, inv[oldslot].ID, inv[oldslot].Quantity)
				GAMEMODE.ClearSlot(oldslot)
				net.Start("item_changeslot")
					net.WriteInt(oldslot, 16)
					net.WriteInt(newslot, 16)
				net.SendToServer()
				break
			end

			if not GAMEMODE.SlotIsEmpty(newslot) then
				if GAMEMODE.SlotIsEmpty(oldslot) then
					GAMEMODE.SetItem(oldslot, inv[newslot].ID, inv[newslot].Quantity)
					GAMEMODE.ClearSlot(newslot)
					net.Start("item_changeslot")
						net.WriteInt(oldslot, 16)
						net.WriteInt(newslot, 16)
					net.SendToServer()
					break
				else
				local oldid, oldquant = inv[newslot].ID, inv[newslot].Quantity
					GAMEMODE.SetItem(newslot, inv[oldslot].ID, inv[oldslot].Quantity)
					GAMEMODE.SetItem(oldslot, oldid, oldquant)
					net.Start("item_changeslot")
						net.WriteInt(oldslot, 16)
						net.WriteInt(newslot, 16)
					net.SendToServer()
					break
				end
				break
			end
		end	
end

function GM.SetItem(slot, id, quantity)

	local inv = GAMEMODE.PlayerInventory

	inv[slot].Slot     = slot
	inv[slot].ID       = id
	inv[slot].Quantity = quantity
	inv[slot].Ref 	   = ITEM_DB[id].Ref

end
function GM.DropItem(id)

	if id == 0 then return end
	net.Start("item_drop")
		net.WriteInt(id, 32)
	net.SendToServer()
	istime = false
end

function GM.UseItem(id)
	if id == 0 then return end
	net.Start("item_use")
		net.WriteInt(id, 32)
	net.SendToServer()
end
function GM.SlotToID(slot)
	return GAMEMODE.PlayerInventory[slot].ID 
end

function GM.IDToQuantity(id)
	for k, v in pairs(GAMEMODE.PlayerInventory) do
		if v.ID == id then
			return v.Quantity
		else
			print("WTF")
			return 0
		end	
	end
end


net.Receive("item_set", function()
	GAMEMODE.SetItem(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))
end)

net.Receive("item_give", function()
	GAMEMODE.GiveItem(net.ReadInt(32), net.ReadInt(32))
end)

net.Receive("remove_item", function()
	GAMEMODE.RemoveItem(net.ReadInt(32), net.ReadInt(32))
end)

net.Receive("item_clearslot", function() 
	GAMEMODE.ClearSlot(net.ReadInt(32))
end)

-----------------
----DEBUGGING----
-----------------

concommand.Add("rp_idtoquantity", function(ply, cmd, args)
	print(GAMEMODE.IDToQuantity(tonumber(args[1])))
end)
concommand.Add('rp_seeinventory_cl', function()
	for k, v in pairs(GAMEMODE.PlayerInventory) do
		if v.ID ~= 0 then
			PrintTable(v)
		end
	end
end)

concommand.Add('rp_changeitemslot_cl', function(ply, cmd, args)
	if args[1] && args[2] then
		GAMEMODE.ChangeItemSlot(tonumber(args[1]), tonumber(args[2]))
	else
		print('Wrong arg')
	end
end)

concommand.Add('rp_setitem_cl', function(ply, cmd, args)
	if args[1] && args[2] && args[3] then
		GAMEMODE.SetItem(args[1], args[2], args[3])
	else
		print('Wrong arg')
	end
end)
concommand.Add('rp_slotisempty_cl', function(ply, cmd, args)
	if args[1] then
		print(GAMEMODE.SlotIsEmpty(tonumber(args[1])))
	else
		print('Wrong arg')
	end
end)
concommand.Add('rp_removeitem_cl', function(ply, cmd, args)
	if args[1] && args[2] then
		GAMEMODE.RemoveItem(args[1], args[2])
	else
		print('Wrong arg')
	end
end)

concommand.Add('rp_giveitem_cl', function(ply, cmd, args)
	if args[1] && args[2] then
		GAMEMODE.GiveItem(tonumber(args[1]), tonumber(args[2]))
	else
		print('Wrong arg')
	end
end)

concommand.Add("rp_clearslot_cl", function(ply, cmd, args) 
	GAMEMODE.ClearSlot(tonumber(args[1]))

end)

concommand.Add("rp_seeitemtable_cl", function() 
	PrintTable(ITEM_DB)
end)