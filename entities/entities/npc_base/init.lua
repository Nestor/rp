AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
      
	self:SetMoveType( MOVETYPE_STEP )   
	self:SetSolid( SOLID_BBOX )   
 	self:SetUseType(SIMPLE_USE)

 	self:SetHullType( HULL_HUMAN )
 	self:SetHullSizeNormal()

 	self:SetSchedule( SCHED_IDLE_STAND )
 	self:DropToFloor()
end
 
function ENT:AcceptInput( name, activator, caller )
	if name == "Use" && caller:IsPlayer() then
		net.Start("npc_use")
			net.WriteString(self.Panel)
			net.WriteInt(self.ID, 32)
		net.Send(caller)
	end
end

function ENT:OnTakeDamage( dmg )
	return false end