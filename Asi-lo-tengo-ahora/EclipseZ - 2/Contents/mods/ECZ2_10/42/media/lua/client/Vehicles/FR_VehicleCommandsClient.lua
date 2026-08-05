if not isClient() then return end

local Commands = {};
Commands.FR_UpdateParts = {};
Commands.FR_VehicleAnimations = {};

function Commands.FR_UpdateParts.FR_partStatus(args)
--args = { vehicleID = args.vehicleID, doorOpen = args.doorOpen, partID = args.partID, username = player:getUsername() }
	local vehicleID = args.vehicleID
	local vehicle = getVehicleById(vehicleID)
	local opened = args.doorOpen
	local part = args.partID
	local player = args.username
	--DebugLog.log ("FR_UPDATEPARTS.FR_PARTSTATUS COMMANDED BY SERVER!!")
	--DebugLog.log ("FR_UPDATEPARTS.FR_PARTSTATUS: VehicleID is: " .. tostring(vehicle))
	--DebugLog.log ("FR_UPDATEPARTS.FR_PARTSTATUS: Door is open? " .. tostring(opened))
	--DebugLog.log ("FR_UPDATEPARTS.FR_PARTSTATUS: PartID is: " .. tostring(part))
	--DebugLog.log ("FR_UPDATEPARTS.FR_PARTSTATUS: Username is: " .. tostring(player))
	--DebugLog.log ("FR_UPDATEPARTS.FR_PARTSTATUS CLIENT COMMANDS: " .. tostring(player) .. " in vehicle " .. tostring(vehicle) .. " has set " .. tostring(part) .. " to " .. tostring(opened))
	if vehicle then
		local part = vehicle:getPartById(part)
		if getPlayer():getUsername() ~= player then
			if opened then
				vehicle:playPartAnim(part, "Open")
				part:getDoor():setOpen(true)
				--DebugLog.log ("FR_UpdateParts.FR_partStatus: " ..tostring(vehicleID) .. "'s " .. tostring(part) .. " should be playing the opened animation.")
			else
				vehicle:playPartAnim(part, "Close")
				part:getDoor():setOpen(false)
				--DebugLog.log ("FR_UpdateParts.FR_partStatus: " ..tostring(vehicleID) .. "'s " .. tostring(part) .. " should be playing the closed animation.")
			end
		end
	end
end

function Commands.FR_UpdateParts.FR_popupStatus(args)
	local vehicleID = args.vehicleID
	local vehicle = getVehicleById(vehicleID)
	local opened = args.doorOpen
	local part = args.partID
	local player = args.username
	--DebugLog.log ("POPUP LIGHTS COMMANDED BY SERVER!!")
	--DebugLog.log ("POPUP LIGHTS CLIENT: VehicleID is: " .. tostring(vehicle))
	--DebugLog.log ("POPUP LIGHTS CLIENT: Door is open? " .. tostring(opened))
	--DebugLog.log ("POPUP LIGHTS CLIENT: PartID is: " .. tostring(part))
	--DebugLog.log ("POPUP LIGHTS CLIENT: Username is: " .. tostring(player))
	--DebugLog.log ("POPUP LIGHTS CLIENT COMMANDS: " .. tostring(player) .. " in vehicle " .. tostring(vehicle) .. " has set " .. tostring(part) .. " to " .. tostring(opened))
	if vehicle then
		local part = vehicle:getPartById(part)
		if getPlayer():getUsername() ~= player then
			if opened then
				vehicle:playPartAnim(part, "Closed")
				--DebugLog.log ("FR_UpdateParts.FR_popupStatus: " ..tostring(vehicleID) .. "'s lights should be playing the closed animation.")
			else
				vehicle:playPartAnim(part, "Opened")
				--DebugLog.log ("FR_UpdateParts.FR_popupStatus: " ..tostring(vehicleID) .. "'s lights should be playing the opened animation.")
			end
		end
	end
end

--Commands.FR_UpdateParts.FR_setVisible might be old and unused
function Commands.FR_UpdateParts.FR_setVisible(args)
	--{ vehicleID = vehicle:getId(), partID = part:getId(), partString = partName, username = player:getUsername }
	--[[local vehicleID = args.vehicleID
	local vehicle = getVehicleById(vehicleID)
	local part = args.partID
	local functionString = args.functionString--]]
	--DebugLog.log ("COMMANDS.FR_UPDATEPARTS.FR_SETVISIBLE: " .. tostring(functionString) .. " is transmitting data: part is " .. tostring(part) .. ", VehicleID is " .. tostring(vehicleID) .. ", Vehicle is: " .. tostring(vehicle))
	
	if not (args.vehicleID and args.partID) then
		--DebugLog.log("COMMANDS.FR_UPDATEPARTS.FR_SETVISIBLE: Didn't detect the right args, closing.")
	return end
	--DebugLog.log("COMMANDS.FR_UPDATEPARTS.FR_SETVISIBLE: Vehicle and Part IDs are " .. tostring(args.vehicleID) .. tostring(args.partID))
	local vehicleID = args.vehicleID
	--DebugLog.log("VehicleID is " .. tostring(vehicleID))
	local vehicle = getVehicleById(vehicleID)
	--DebugLog.log("Vehicle is " .. tostring(vehicle))
	local partID = args.partID
	--DebugLog.log("PartID is " .. tostring(partID))
	--DebugLog.log("COMMANDS.FR_UPDATEPARTS.FR_SETVISIBLE: vehicle " .. type(vehicle) .. " is " .. tostring(vehicle))
	local part = vehicle:getPartById(tostring(partID))
	--DebugLog.log("COMMANDS.FR_UPDATEPARTS.FR_SETVISIBLE is attempting to set the " .. tostring(partID) .. " model for " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(args.vehicleID))
	part:setAllModelsVisible(false)
	part:setModelVisible("ModernCarMuffler", false)
	if not part:getInventoryItem() then
		--DebugLog.log("No part installed, keeping models hidden. " .. tostring(part:getInventoryItem()))
	else
	--DebugLog.log("Maybe part here? Try it. " .. tostring(part:getInventoryItem()))
		local partType = part:getInventoryItem():getType()
		local partName = string.match(partType, "%D+")
		part:setModelVisible(tostring(partName), true)
		--DebugLog.log ("Attempting to set " .. tostring(partType) .. " to " .. tostring(partName))
	end
end

function Commands.FR_UpdateParts.FR_fridgeStatus(args)
	local vehicleID = args.vehicleID
	local vehicle = getVehicleById(vehicleID)
		
	if not vehicle then
		--DebugLog.log ("FR_FUNCTIONS.FRIDGESTATUS: Player isn't in or near a vehicle.")
	return end
	
	local partFridge = vehicle:getPartById("FR_Fridge")
	local currentTemp = args.currentTemp
	partFridge:getItemContainer():setCustomTemperature(currentTemp)
	--DebugLog.log ("FR_FUNCTIONS.OVENSTATUS: " .. tostring(vehicleID) .. "'s " .. tostring(partFridge) .. " current temp is " .. tostring(currentTemp) .. ", new temp is " .. tostring(partFridge:getItemContainer():getCustomTemperature()))
end

function Commands.FR_UpdateParts.FR_ovenStatus(args)
	local vehicleID = args.vehicleID
	local vehicle = getVehicleById(vehicleID)
		
	if not vehicle then
		--DebugLog.log ("FR_FUNCTIONS.OVENSTATUS: Player isn't in or near a vehicle.")
	return end
	
	local partOven = vehicle:getPartById("FR_Oven")
	local currentTemp = args.currentTemp
	partOven:getItemContainer():setCustomTemperature(currentTemp)
	--DebugLog.log ("FR_FUNCTIONS.OVENSTATUS: " .. tostring(vehicleID) .. "'s " .. tostring(partOven) .. " current temp is " .. tostring(currentTemp) .. ", new temp is " .. tostring(partOven:getItemContainer():getCustomTemperature()))
end

--put the function here. If it's the original player, then do the open animation, if not, do opened
function Commands.FR_UpdateParts.FR_toggleTrailerJack(args) --vehicle, partString, opened)
--(playerObj, vehicle, partString, opened)
-- username = player:getUsername(), vehicle = trailer, doorOpen = opened, partID = partString 
	local vehicleID = args.vehicle
	local vehicle = getVehicleById(vehicleID)
	local opened = args.opened
	local partString = args.partID
	local player = args.username
	local trailer
	--DebugLog.log ("FR_FUNCTIONS.FR_TOGGLETRAILERJACK " .. tostring(player) .. "'s " .. tostring(vehicleID) .. "'s " .. tostring(partString) .. " is opened: " .. tostring(opened))
	
	--the attachTrailer function should have made sure the vehicle is a trailer with a jack already
	if opened == true and vehicleID then
		trailer = vehicle
	--9/16/24, Just added "and vehicle" to try to eliminate any oopsies
	elseif opened == false and vehicleID and vehicle then
	--We need to get the closest vehicle to it and check if it's a trailer with part
		--DebugLog.log ("FR_FUNCTIONS.FR_TOGGLETRAILERJACK Vehicle is " .. tostring(vehicle:getScriptName()) .. ", ID " .. tostring(vehicleID))
		trailer = ISVehicleTrailerUtils.getTowableVehicleNear(vehicle:getSquare(), vehicle, "trailer", "trailer")
		--DebugLog.log ("FR_FUNCTIONS.FR_TOGGLETRAILERJACK Trailer is ".. tostring(trailer))
	end
	if not trailer then
		--DebugLog.log ("FR_FUNCTIONS.FR_TOGGLETRAILERJACK: No trailer, I guess.")
	return
	end
	--DebugLog.log ("FR_FUNCTIONS.FR_TOGGLETRAILERJACK Trailer is ".. tostring(trailer:getScriptName()))
	
	local part = trailer:getPartById(partString)
	--DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK: part = " .. tostring(part))
	if not part then return end
	part:getDoor():setOpen(opened)
	if getPlayer():getUsername() == player then
		if opened then
			trailer:playPartAnim(part, "Open")
		else
			trailer:playPartAnim(part, "Close")
		end
	else
		if opened then
			trailer:playPartAnim(part, "Opened")
		else
			trailer:playPartAnim(part, "Closed")
		end
	end
	
--[[	local args = { vehicleID = trailer:getId(), doorOpen = opened, partID = partString }
	sendClientCommand(getPlayer(), 'FR_UpdateParts', 'FR_setPart', args)
	--DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK: Attempting to send client command to server")--]]
end

function Commands.FR_VehicleAnimations.FR_SetPlayerAnimation(args)
	--local args =  { seatAnim = args.seatAnim, onlineID = args.onlineID }
	local seatAnim = args.seatAnim
	local onlineID = args.onlineID
	
	if not onlineID then
		--DebugLog.log("FR_VehicleAnimations.FR_SetPlayerAnimation: CLIENT: No onlineID! Ending Function.")
		return
	end
	
	local animatedPlayer = getPlayerByOnlineID(onlineID)
	
	if not animatedPlayer then
		--DebugLog.log("FR_VehicleAnimations.FR_SetPlayerAnimation: CLIENT: No animatedPlayer! Ending Function.")
		return
	end
	
	
	--This is for detailed debug shit, remove when you figure it out
	--[[local debugSeatAnim
	if seatAnim then 
		debugSeatAnim = seatAnim
	else
		debugSeatAnim = "NONE"
	end
	
	local debugOnlineID
	if onlineID then
		debugOnlineID = onlineID
	else
		debugOnlineID = "NONE"
	end
	
	local debugAnimatedPlayerUsername
	if animatedPlayer and animatedPlayer:getUsername() then
		debugAnimatedPlayerUsername = animatedPlayer:getUsername()
	elseif animatedPlayer then
		debugAnimatedPlayerUsername = "Cannot getUsername"
	else
		debugAnimatedPlayerUsername = "NONE"
	end
	
	--DebugLog.log("FR_VehicleAnimations.FR_SetPlayerAnimation: CLIENT: Attempting to set animation. Animation: " .. tostring(debugSeatAnim) .. ". Username: " .. tostring(debugAnimatedPlayerUsername) .. ". Online ID: " .. tostring(debugOnlineID))
	--]]
	--Debug stuff end
	
	--animatedPlayer:SetVariable("FR_Animation", seatAnim)
	if seatAnim == "" then
		animatedPlayer:SetVariable("FR_Vehicle", "False")
	else
		animatedPlayer:SetVariable("FR_Vehicle", "True")
	end
end



function Commands.FR_UpdateParts.FR_sendRemoveMountedPart(args)
	--DebugLog.log("FR_sendRemoveMountedPart: vehicleID is " .. tostring(args.vehicleID))
	--DebugLog.log("FR_sendRemoveMountedPart: partID is " .. tostring(args.partID))
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.partID)
	part:setInventoryItem(nil)
end

function Commands.FR_UpdateParts.FR_sendAddMountedPart(args)
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.partID)
	part:setInventoryItem(item)
end

function Commands.FR_UpdateParts.FR_UpdateTrunkCapacity(args)
	local vehicleID = args.vehicleID
	local vehicle = getVehicleById(vehicleID)
	local trunkPart = vehicle:getPartById("TruckBed")
	local trunkCapacity = args.capacity
	--DebugLog.log ("FR_UpdateParts.FR_UpdateTrunkCapacity: vehicleID: " .. tostring(vehicleID) .. ", vehicle: " .. tostring(vehicle) .. ", trunkPart: " .. tostring(trunkPart) .. ", trunkCapacity: " .. tostring(trunkCapacity))
	trunkPart:setContainerCapacity(trunkCapacity)
	--DebugLog.log ("FR_UpdateParts.FR_UpdateTrunkCapacity: getContainerCapacity: " .. tostring(trunkPart:getContainerCapacity()))
end

function Commands.FR_UpdateParts.FR_FuelTankAmountClient(args)
	if (not args.sourceVehicleID) or (not args.partTankID) or (not args.tankAmount) then 
		--DebugLog.log ("FR_UpdateParts.FR_FuelTankAmountClient: args.sourceVehicleID: " .. tostring(args.sourceVehicleID) .. ", args.partTankID: " .. tostring(args.partTankID) .. ", args.partTankID: " .. tostring(args.partTankID))
	return end
	local sourceVehicle = getVehicleById(args.sourceVehicleID)
	if not sourceVehicle then return end
	local partTank = sourceVehicle:getPartById(args.partTankID)
	local amount = args.tankAmount
	--DebugLog.log("FR_UpdateParts.FR_FuelTankAmountClient: sourceVehicle: " .. tostring(sourceVehicle) .. ", fuelTank: " .. tostring(partTank) .. ", amount: " .. tostring(amount))
	partTank:setContainerContentAmount(amount)
end

local onServerCommand = function(module, command, args)
	args = args or {}
	if module ~= 'FR_UpdateParts' and module ~= 'FR_VehicleAnimations' then return end;
	if Commands[module] and Commands[module][command] then
		Commands[module][command](args)
	end
end

Events.OnServerCommand.Add(onServerCommand)