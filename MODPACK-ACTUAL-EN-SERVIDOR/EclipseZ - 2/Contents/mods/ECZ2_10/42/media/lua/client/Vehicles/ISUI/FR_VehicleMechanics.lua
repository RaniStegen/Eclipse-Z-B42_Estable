require "ISUI/ISVehicleMechanics"

--I THINK I'VE GOT IT!!!!
--HAVE THE INIT FUNCTIONS AND SHIT CHECK FOR THE PARTS DIRECTLY IN THE FUNCTION.
--No need to send it to the server. It should work!
--Then have the install/uninstall shit in here, that way it updates at the right time.
--I think this should work. I'm gonna play dragons dogma 2. Jesus Christ.

--I THINK THIS SHOULD FINALLY FUCKING WORK FOR MULTIPLAYER AND SINGLEPLAYER.
--Make sure you check multiplayer before you go on
--Also for the part creation, check out the event Events.VehiclePart_create.add(MyFunction)
--local old_OnMechanicActionDone = ISVehicleMechanics.OnMechanicActionDone
--IT LOOKS LIKE THE MODEL BEING VISIBLE IS SET BY THE SERVER, NOT THE CLIENT.

--I think this function was used to test sending stuff through the args table as a client command
--I don't remember enough to confidentally delete it, though, haha.
--Shit.
function FrFunctionTest(chr, success, vehicleId, partId, itemId, installing)
	--DebugLog.log("INTERCEPTED ISVehicleMechanics.OnMechanicActionDone, running VANILLA")
	--local temp_OnMechanicActionDone = old_OnMechanicActionDone(chr, success, vehicleId, partId, itemId, installing)
	--DebugLog.log("INTERCEPTED ISVehicleMechanics.OnMechanicActionDone VANILLA HAS RAN")
	--return temp_OnMechanicActionDone
	local vehicleID = vehicleId
		--DebugLog.log("FrFunctionTest: VehicleID is: " .. tostring(vehicleID))
	local vehicle = getVehicleById(vehicleID)
		--DebugLog.log("FrFunctionTest: Vehicle is: " .. tostring(vehicle))
	if (vehicle and string.find(vehicle:getScriptName(), "fr_")) then
		--DebugLog.log("FrFunctionTest: Vehicle has fr_")
		local partID = partId
		--[[DebugLog.log("FrFunctionTest: PartID is: " .. tostring(partID))
		local part = vehicle:getPartById(partID)
		--DebugLog.log("FrFunctionTest: part is: " .. tostring(part))
		part:setAllModelsVisible(false)--]]
		local args = { vehicleID = vehicleID, partID = partID }
		sendClientCommand(chr, 'FR_UpdateParts', 'testTime', args)
	end
end