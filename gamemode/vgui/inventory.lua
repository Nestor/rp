local PANEL = {}

function PANEL:Init()
	--self:MakePopup()
	self.title = vgui.Create("DLabel", self)
	self.title:SetFont("Verdana40")
	self.title:SetText("Inventory")
	self.title:SetTextColor(Color(64, 64, 64, 255))

	self.exitbutton = vgui.Create("EButton", self)
	self.exitbutton:SetFont("Tahoma40")
	self.exitbutton:SetText("X")
	self.exitbutton.DoClick = function() 
		self:Remove()
	end
	local inv = {}
	for i=0,3 do
		inv[i] = {}
		for j=0,7 do
			local u = i*8+j+1
			local o = i*4
			--inv[i][j] = { ID = GAMEMODE.PlayerInventory[u].ID, Quantity = GAMEMODE.PlayerInventory[u].Quantity}
			local itembutton = vgui.Create("ItemButton", self)
			itembutton.ID = GAMEMODE.PlayerInventory[u].ID
			itembutton.Quantity = GAMEMODE.PlayerInventory[u].Quantity
			itembutton.U = u
			itembutton:SetSize(64, 64)
			itembutton:SetPos(j*72+115, i*72+300)
		end
	end
	self:Receiver("ItemButton", function(receiver, pnls, dropped, index, x, y) 
		print("OK")
		end)
end

function PANEL:PerformLayout()
	self:SetSize(800, 600)
	self:SetPos(ScrW()/2-400, ScrH()/2-300)

	self.exitbutton:SetSize(32, 32)
	self.exitbutton:SetPos(776, 0)

	self.title:SetSize(200, 32)
	self.title:SetPos(300, 0)
end

function PANEL:Paint()
	surface.SetDrawColor(Color(155, 155, 155, 200))
	surface.DrawRect(0, 0, 800, 600)
	surface.SetDrawColor(Color(90, 90, 90, 200))
	surface.DrawRect(0, 32, 800, 5)
end

function PANEL:Think()

end

vgui.Register("Inventory", PANEL)