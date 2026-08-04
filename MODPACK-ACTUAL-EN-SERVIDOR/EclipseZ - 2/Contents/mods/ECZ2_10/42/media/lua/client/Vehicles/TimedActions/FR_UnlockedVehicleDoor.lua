require "ISUnlockVehicleDoor"
local FR_tableStorage = require("FR_Tables")
local FR_roofTypes = FR_tableStorage.FR_roofTypes

local Old_ISUnlockVehicleDoor_start = ISUnlockVehicleDoor.start
function ISUnlockVehicleDoor.start(self)
	--DebugLog.log ("INTERCEPTING ISUNLOCKVEHICLEDOOR:START")
	if (self.vehicle and string.find(self.vehicle:getScriptName(), "fr_")) then
			--DebugLog.log ("ISUNLOCKVEHICLEDOOR: Player is tryign to use " .. tostring(self.vehicle))
		if not self.character:getVehicle() then
			self.character:faceThisObject(self.vehicle)
		end
		self.vehicle:toggleLockedDoor(self.part, self.character, false)
		if self.part:getDoor():isLocked() then
		
			local partRoof
			for i, v in ipairs(FR_roofTypes) do
				if self.vehicle:getPartById(v) then
				partRoof = self.vehicle:getPartById(v)
				--DebugLog.log ("ISUNLOCKVEHICLEDOOR: Roof type is " .. tostring(v))
				break
				end
			end

			if partRoof and partRoof:getId() == "FRConRoof" then
				--DebugLog.log ("ISUNLOCKVEHICLEDOOR: Roof is convertible and is open: " .. tostring(partRoof:getDoor():isOpen()))
				elseif partRoof then
				--DebugLog.log ("ISUNLOCKVEHICLEDOOR: Roof is " .. tostring(partRoof:getId()))
			end
			
			if self.vehicle:getPartById("FR_keyless") then
			--DebugLog.log ("ISUNLOCKVEHICLEDOOR: The keyless shit is working!")
			end
			
			if not self.vehicle:getPartById("FR_keyless") and not (partRoof and (not partRoof:getInventoryItem() or (partRoof:getId() == "FRConRoof" and partRoof:getDoor():isOpen()))) then
			--DebugLog.log ("ISUNLOCKVEHICLEDOOR: " .. tostring(self.vehicle:getScriptName()) .. "'s door is locked")
				if self.part:getDoor():isLockBroken() then
					self.character:Say(getText("IGUI_PlayerText_VehicleLockIsBroken"))
			--DebugLog.log ("ISUNLOCKVEHICLEDOOR Lock is broken")
				end
				self.vehicle:playPartSound(self.part, self.character, "IsLocked");
				self:forceStop();
				return;
			end
		end
		self.vehicle:playPartSound(self.part, self.character, "Unlock")
		--DebugLog.log ("ISUNLOCKVEHICLEDOOR The door is unlocked, I guess?")
		if isClient() then
			local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), locked = false }
			sendClientCommand(self.character, 'vehicle', 'setDoorLocked', args)
		end
		-- isValid() will return false since the door isn't locked now
		self.forceValid = true
		--DebugLog.log ("ISUNLOCKVEHICLEDOOR isValide is: " .. tostring(self.forceValid))
		self:forceComplete()
	else
	--DebugLog.log ("ISUNLOCKVEHICLEDOOR: Running VANILLA FUNCTION")
	Old_ISUnlockVehicleDoor_start(self)
	end
end