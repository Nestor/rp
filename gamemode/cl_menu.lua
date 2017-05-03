include('shared.lua')




--[[function cashmenu( ent )
			local frame = vgui.Create('DFrame')
			local daccept = vgui.Create("DButton", frame)
			local ddecline = vgui.Create("DButton", frame)
			local dtext = vgui.Create("DTextEntry", frame)

			frame:SetSize(300, 200)
			frame:SetPos( ScrW()/2 - 150, ScrH() / 2 - 100 )
			frame:SetTitle( "Amount of money" )

			dtext:SetSize( 200, 75 )
			dtext:SetPos( 50, 50 )

			daccept:SetSize( 100, 50 )
			daccept:SetPos( 50, 130)
			daccept:SetText( "Accept" )

			ddecline:SetSize(100, 50)
			ddecline:SetPos( 150, 130 )
			ddecline:SetText( "Decline" )

			function daccept:DoClick()
				if isnumber(dtext:GetValue()) then
					local int = dtext:GetInt()
					local dosh = LocalPlayer():GetNWInt( "money" )
					print(int)

					if dosh - int >= 0 && CheckInt(int) then

						net.Start( "giveothermoney" )
							net.WriteEntity(ent)
							net.WriteInt(int, 16)
						net.SendToServer()

					elseif dosh - int < 0 then

						GAMEMODE.Notify("Not enough money")
				
					else

						frame:Close()
					
					end
					frame:Close()
				else

					GAMEMODE.Notify("Invalid number")
					frame:Close()
				end
				function ddecline:DoClick()
					frame:Close()
				end
			end
				frame:MakePopup()
end

concommand.Add('testsomeshit', testshit)]]--