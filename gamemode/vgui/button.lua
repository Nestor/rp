local PANEL = {}

function PANEL:Init()
	self.BColor = Color(155, 155, 155, 0)
	self:SetTextColor(Color(64, 64, 64, 255))
	self:SetMouseInputEnabled(true)
end
function PANEL:PerformLayout()

end

function PANEL:Paint()
	surface.SetDrawColor(self.BColor)
	surface.DrawRect(0, 0, self.x, self.y)
end

function PANEL:OnMousePressed(key)
	self:DoClick()
end

function PANEL:OnMouseReleased(key)

end

function PANEL:SetColor(color)
	self.BColor = color
end
function PANEL:Think()
	if self:IsHovered() then
		self.BColor = Color(64, 64, 64, 100)
	else
		self.BColor = Color(155, 155, 155, 0)
	end
end

vgui.Register("EButton", PANEL, "DLabel")