if isClient() then return end

local Commands = {};
Commands.FR_UpdateParts = {};
Commands.FR_VehicleAnimations = {};

function Commands.FR_UpdateParts.FR_setPart(player, args)
	local args = { vehicleID = args.vehicleID, doorOpen = args.doorOpen, partID = args.partID, username = player:getUsername() }
	local vehicleIDTest = args.vehicleID
	local doorOpenTest = args.doorOpen
	local partIDTest = args.partID
	local usernameTest = args.username
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: vehicleID type is " .. type(vehicleIDTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: vehicleID is " .. tostring(vehicleIDTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: doorOpen type is " .. type(doorOpenTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: doorOpen is " .. tostring(doorOpenTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: partID type is " .. type(partIDTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: partID is " .. tostring(partIDTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: username type is " .. type(usernameTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART: username is " .. tostring(usernameTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART SERVER ARGS RECEIVED, Vehicle is " .. vehicleIDTest .. ", door opened is " .. tostring(doorOpenTest) .. ", and the username is " .. tostring(usernameTest))
	--DebugLog.log ("FR_UPDATEPARTS.FR_SETPART SERVER ATTEPMTING TO SEND COMMAND TO CLIENT")
    sendServerCommand('FR_UpdateParts', 'FR_partStatus', args)
end

function Commands.FR_UpdateParts.FR_setPopupLights(player, args)
	--DebugLog.log ("POPUP LIGHTS COMMANDED BY CLIENT!!")
	local args = { vehicleID = args.vehicleID, doorOpen = args.doorOpen, partID = args.partID, username = player:getUsername() }
    sendServerCommand('FR_UpdateParts', 'FR_popupStatus', args)
end

function Commands.FR_UpdateParts.setFridge(playerObj, args)	
	local username = playerObj:getUsername()
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: username is " .. tostring(username))
	local vehicleID = args.vehicleID
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: vehicleID is " .. tostring(vehicleID))
	local vehicle = getVehicleById(vehicleID)
	
	if not vehicle then
		--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Player " .. tostring(username) .. " isn't in or near a vehicle.")
	return end
	
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Vehicle is " .. tostring(vehicle))
	local partFridge = vehicle:getPartById("FR_Fridge")
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: partFridge is " .. tostring(partFridge))
	local active = partFridge:getModData().FR_FridgeActive
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Before running, active is " .. tostring(active))
	
	partFridge:getModData().FR_FridgeActive = not active
		--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Toggling FR_FridgeActive in mod data.")
	active = partFridge:getModData().FR_FridgeActive
	if active then
		partFridge:getItemContainer():setCustomTemperature(0.2)
		--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Setting temperature to " .. tostring(0.2))
	else
		partFridge:getItemContainer():setCustomTemperature(1)
		--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Setting temperature to " .. tostring(1.0))
	end
	vehicle:transmitPartModData(partFridge)
	local currentTemp = partFridge:getItemContainer():getCustomTemperature()
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Temperature is now " .. tostring(currentTemp))
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: active is NOW " .. tostring(active))
	local args = { vehicleID = args.vehicleID, currentTemp = currentTemp }
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Attempting to send server command to client.")
    sendServerCommand('FR_UpdateParts', 'FR_fridgeStatus', args)
	--DebugLog.log ("FR_FUNCTIONS.SETFRIDGE: Attempted to send server command to client.")
end

function Commands.FR_UpdateParts.setOven(playerObj, args)	
	local username = playerObj:getUsername()
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: username is " .. tostring(username))
	local vehicleID = args.vehicleID
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: vehicleID is " .. tostring(vehicleID))
	local vehicle = getVehicleById(vehicleID)
	
	if not vehicle then
		--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Player " .. tostring(username) .. " isn't in or near a vehicle.")
	return end
	
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Vehicle is " .. tostring(vehicle))
	local partOven = vehicle:getPartById("FR_Oven")
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: partOven is " .. tostring(partOven))
	local active = partOven:getModData().FR_OvenActive
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Before running, active is " .. tostring(active))
	
	partOven:getModData().FR_OvenActive = not active
		--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Toggling FR_OvenActive in mod data.")
	active = partOven:getModData().FR_OvenActive
	if active then
		partOven:getItemContainer():setCustomTemperature(2)
		--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Setting temperature to " .. tostring(2))
	else
		partOven:getItemContainer():setCustomTemperature(1)
		--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Setting temperature to " .. tostring(1.0))
	end
	vehicle:transmitPartModData(partOven)
	local currentTemp = partOven:getItemContainer():getCustomTemperature()
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Temperature is now " .. tostring(currentTemp))
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: active is NOW " .. tostring(active))
	local args = { vehicleID = args.vehicleID, currentTemp = currentTemp }
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Attempting to send server command to client.")
    sendServerCommand('FR_UpdateParts', 'FR_ovenStatus', args)
	--DebugLog.log ("FR_FUNCTIONS.SETOVEN: Attempted to send server command to client.")
end

function Commands.FR_UpdateParts.testTime(playerObj, args)
	local vehicleID = args.vehicleID
		--DebugLog.log("testTime: VehicleID is: " .. tostring(vehicleID))
	local vehicle = getVehicleById(vehicleID)
		--DebugLog.log("testTime: Vehicle is: " .. tostring(vehicle))
	if (vehicle and string.find(vehicle:getScriptName(), "fr_")) then
		--DebugLog.log("testTime: Vehicle has fr_")
		local partID = args.partID
		--DebugLog.log("testTime: PartID is: " .. tostring(partID))
		local part = vehicle:getPartById(partID)
		--DebugLog.log("testTime: part is: " .. tostring(part))
		part:setAllModelsVisible(false)
	end
end

function Commands.FR_VehicleAnimations.FR_SendPlayerAnimation(playerObj, args)
	local args =  { seatAnim = args.seatAnim, onlineID = args.onlineID }
	--This is for detailed debug shit, remove when you figure it out
	--[[local seatAnim = args.seatAnim
	local onlineID = args.onlineID
	local debugSeatAnim
	if seatAnim then 
		debugSeatAnim = seatAnim
	else
		debugSeatAnim = "NONE"
	end
	
	local debugOnlineID
	local animatedPlayer
	if onlineID then
		debugOnlineID = onlineID
		animatedPlayer = getPlayerByOnlineID(onlineID)
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
	
	--DebugLog.log("FR_VehicleAnimations.FR_SendPlayerAnimation: SERVER: Attempting to set animation. Animation: " .. tostring(debugSeatAnim) .. ". Username: " .. tostring(debugAnimatedPlayerUsername) .. ". Online ID: " .. tostring(debugOnlineID))
	--]]
	--Debug stuff end
	sendServerCommand('FR_VehicleAnimations', 'FR_SetPlayerAnimation', args)
end

function Commands.FR_UpdateParts.FR_FuelTankAmount(playerObj, args)
	--local args = { partTankID = partTankID, sourceVehicleID = sourceVehicleID, tankAmount = self.tank:getContainerContentAmount() }
	--DebugLog.log("FR_UpdateParts.FR_FuelTankAmount: partTankID: " .. tostring(args.partTankID) .. ", sourceVehicleID: " .. tostring(args.sourceVehicleID) .. " tankAmount: " .. tostring(args.tankAmount))
	if (not args.sourceVehicleID) or (not args.partTankID) or (not args.tankAmount) then 
		--DebugLog.log ("FR_UpdateParts.FR_FuelTankAmount: args.sourceVehicleID: " .. tostring(args.sourceVehicleID) .. ", args.partTankID: " .. tostring(args.partTankID) .. ", args.partTankID: " .. tostring(args.partTankID))
	return end
	local sourceVehicle = getVehicleById(args.sourceVehicleID)
	local partTank = sourceVehicle:getPartById(args.partTankID)
	local amount = args.tankAmount
	--DebugLog.log("FR_UpdateParts.FR_FuelTankAmount: sourceVehicle: " .. tostring(sourceVehicle) .. ", fuelTank: " .. tostring(partTank) .. ", amount: " .. tostring(amount))
	partTank:setContainerContentAmount(amount)
	local args = { partTankID = args.partTankID, sourceVehicleID = args.sourceVehicleID, tankAmount =  args.tankAmount }
	sendServerCommand('FR_UpdateParts', 'FR_FuelTankAmountClient', args)
end

function Commands.FR_UpdateParts.FR_removeMountedPart(playerObj, args)
	local vehicle = getVehicleById(args.vehicleID)
	--DebugLog.log ("FR_UpdateParts.FR_removeMountedPart: vehicle is " .. tostring(vehicle))
	local part = vehicle:getPartById(args.partID)
	--DebugLog.log ("FR_UpdateParts.FR_removeMountedPart: part is " .. tostring(part))
	part:setInventoryItem(nil)
	part:getVehicle():transmitPartItem(part)
	local args = { vehicleID = args.vehicleID, partID = args.partID }
	sendServerCommand('FR_UpdateParts', 'FR_sendRemoveMountedPart', args)
end

function Commands.FR_UpdateParts.FR_addMountedPart(playerObj, args)
--check equipped for item name
	local item
	local equippedPrimary = playerObj:getPrimaryHandItem()
	local equippedSecondary = playerObj:getSecondaryHandItem()
	--DebugLog.log ("FR_UpdateParts.FR_addMountedPart: args.itemName is " .. tostring(args.itemName))
	if equippedPrimary and equippedPrimary:getType() == args.itemName then
		--DebugLog.log ("FR_UpdateParts.FR_addMountedPart: equippedPrimary is " .. tostring(equippedPrimary:getType()))
		item = equippedPrimary
	elseif equippedSecondary and equippedSecondary:getType() == args.itemName then
		--DebugLog.log ("FR_UpdateParts.FR_addMountedPart: equippedSecondary is " .. tostring(equippedSecondary:getType()))
		item = equippedSecondary
	else return end
	local vehicle = getVehicleById(args.vehicleID)
	local part = vehicle:getPartById(args.partID)
	part:setInventoryItem(item)
	vehicle:transmitPartItem(part)
	playerObj:removeFromHands(item)
	playerObj:getInventory():DoRemoveItem(item)
	VehicleUtils.FR_SetVisualDefault(part:getVehicle(), part)
	
	--local args = { playerIndex = playerIndex, itemName = args.itemName }
	--sendServerCommand('FR_UpdateParts', 'FR_sendAddMountedPart', args)
	
	--DebugLog.log ("FR_UpdateParts.FR_addMountedPart: item is " .. tostring(item))
	--DebugLog.log ("FR_UpdateParts.FR_addMountedPart: item:getType() is " .. tostring(item:getType()))
	--local itemName =  args.itemName
	--local vehicle = getVehicleById(args.vehicleID)
	--DebugLog.log("FR_UpdateParts.FR_addMountedPart: vehicle is " .. tostring(vehicle))
	--local part = vehicle:getPartById(args.partID)
	--DebugLog.log("FR_UpdateParts.FR_addMountedPart: part is " .. tostring(part))
	
	--local item = playerObj:getInventory():getItemById(itemID)
	--DebugLog.log("FR_UpdateParts.FR_addMountedPart: item is " .. tostring(item))
--[[
	part:setInventoryItem(nil)
	part:getVehicle():transmitPartItem(part)
--]]
	local args = { vehicleID = args.vehicleID, partID = args.partID, itemName = args.itemName }
	sendServerCommand('FR_UpdateParts', 'FR_sendAddMountedPart', args)
end

local onClientCommand = function(module, command, playerObj, args)
	args = args or {}
	--DebugLog.log("Received Client Command: " .. tostring(module) .. "." .. tostring(command))
	if module ~= 'FR_UpdateParts' and module ~= 'FR_VehicleAnimations' then return end;
	if Commands[module] and Commands[module][command] then
		Commands[module][command](playerObj, args)
	end
end

Events.OnClientCommand.Add(onClientCommand)