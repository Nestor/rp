local PANEL = {}

function PANEL:Init()
	self.BColor = Color(64, 64, 64, 255)
	self.dmodel = vgui.Create("DModelPanel", self)
	self.dmodel:SetMouseInputEnabled(false)

	self.dlabel = vgui.Create("DLabel", self)
	self.dlabel:SetFont("Arial16")
	self.dlabel:SetTextColor(Color(225, 0, 0, 255))
	self.dlabel:SetText("")
	function self.dmodel:LayoutEntity(ent) return end

	self:Droppable("ItemButton")

end
function PANEL:PerformLayout()
	self.dmodel:SetSize(self:GetWide(), self:GetTall())
	if self.ID == 0 then self.dmodel:SetModel("")  return end

	self.dmodel:SetModel( ITEM_DB[self.ID].Model)
	self.dmodel:SetCamPos( ITEM_DB[self.ID].CamPos)
	self.dmodel:SetLookAt( ITEM_DB[self.ID].LookAt)
	self.dmodel:SetFOV( ITEM_DB[self.ID].FOV)

	self.dlabel:SetSize(16, 16)
	self.dlabel:SetPos(54,48)
	self.dlabel:SetText(""..self.Quantity)

end

function PANEL:Paint()
	--if self.ID == 0 then return end

	surface.SetDrawColor(self.BColor)
	surface.DrawRect(0, 0, 64, 64)
end
function PANEL:OnMousePressed(key)
	print(self.U)
	if self.ID == 0 then return end
end
function PANEL:OnMouseReleased(key)

	/*if GAMEMODE.Drag ~= self.Slot && key == MOUSE_LEFT && GAMEMODE.Drag ~= 0 then 
		GAMEMODE.ChangeItemSlot(self.Slot, GAMEMODE.Drag)
		self.ID = GAMEMODE.PlayerInventory[self.Slot].ID
		self.Quantity = GAMEMODE.PlayerInventory[self.Slot].Quantity
		self:InvalidateLayout(true)
		GAMEMODE.Drag = 0
		print(self.ID, self.Slot)
		return 
	end*/

	if self.ID == 0 then self:InvalidateLayout(true) return end

	if key == MOUSE_LEFT then
		if self.Quantity == 1  then
			GAMEMODE.UseItem(self.ID)
			self.ID = 0
			self.Quantity = 0
			self.dlabel:SetText("")
		else
			GAMEMODE.UseItem(self.ID)
			self.Quantity = self.Quantity - 1
		end
	end
	if key == MOUSE_RIGHT then
		if self.Quantity == 1 then
			GAMEMODE.DropItem(self.ID)
			self.ID = 0
			self.Quantity = 0
			self.dlabel:SetText("")
		else
			GAMEMODE.DropItem(self.ID)
			self.Quantity = self.Quantity - 1
		end
	end
	self:InvalidateLayout(true)
end

function PANEL:Think()
	if self:IsHovered() then
		self.BColor = Color(200, 200, 200, 255)
	else
		self.BColor = Color(64, 64, 64, 255)
	end
	if self.ID ~= 0 then
		if self:IsDragging() then
			print(true)
		end
	end
end

vgui.Register("ItemButton", PANEL)