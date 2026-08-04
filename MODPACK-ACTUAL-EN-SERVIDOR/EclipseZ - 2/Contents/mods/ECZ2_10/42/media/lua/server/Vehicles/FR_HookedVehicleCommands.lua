if isClient() then return end

local VehicleCommands = {}
local Commands = {}
--args.vehicleA and args.vehicleB work for this one
function Commands.attachTrailer(player, args)
	--DebugLog.log ("INTERCEPTED ATTACHTRAILER SUCCESSFULLY!")

	local opened
	local partString = "FRTrailerJack"
	local vehicleA = getVehicleById(args.vehicleA)
	local vehicleB = getVehicleById(args.vehicleB)
	local trailer
	if vehicleB and vehicleB:getPartById(partString) then
		trailer = vehicleB:getId()
		opened = true
		--DebugLog.log ("INTERCEPTED ATTACHTRAILER: " .. tostring(vehicleB:getScriptName()) .. ", " .. tostring(trailer) .. ", is a trailer with a jack.")
	elseif vehicleA and vehicleA:getPartById(partString) then
		trailer = vehicleA:getId()
		opened = true
		--DebugLog.log ("INTERCEPTED ATTACHTRAILER: " .. tostring(vehicleA:getScriptName()) .. ", " .. tostring(trailer) .. ", is a trailer with a jack.")
	else
		--DebugLog.log ("INTERCEPTED ATTACHTRAILER: No trailer part detected, exiting function")
	return end
	--DebugLog.log ("INTERCEPTED ATTACHTRAILER: Since opened is " .. tostring(opened) .. ", attempting to run FR_Functions.toggleTrailerJack.")
	if not isServer() and not isClient() then
		FR_Functions.toggleTrailerJack(player, trailer, partString, opened)
	return end
	local args = { username = player:getUsername(), vehicle = trailer, opened = opened, partID = partString }
	sendServerCommand('FR_UpdateParts', 'FR_toggleTrailerJack', args)
end
--Cannot get vehicleB with the server. This code needs to go in the client.
function Commands.detachTrailer(player, args)
	--DebugLog.log ("INTERCEPTED DETACHTRAILER SUCCESSFULLY!")
	local opened = false
	local partString = "FRTrailerJack"
	local vehicle = args.vehicle
	--DebugLog.log ("INTERCEPTED DETACHTRAILER: Since opened is " .. tostring(opened) .. ", attempting to run FR_Functions.toggleTrailerJack.")
	if not isServer() and not isClient() then
		FR_Functions.toggleTrailerJack(player, vehicle, partString, opened)
	return end
	local args = { username = player:getUsername(), vehicle = vehicle, opened = opened, partID = partString }
	sendServerCommand('FR_UpdateParts', 'FR_toggleTrailerJack', args)
end

function Commands.fixPart(player, args)
	local vehicle = getVehicleById(args.vehicle)
	local part = vehicle:getPartById(tostring(args.part))
	--DebugLog.log("FR_VehicleCommandsServer: Commands.fixPart is running. vehicle is " .. tostring(vehicle) .. " and part is " .. tostring(part) .. " and part ID is " .. tostring(part:getId()))
	VehicleUtils.FR_SetVisualDefault(vehicle, part)
end

Events.OnClientCommand.Add(function(module, command, player, args)
	--DebugLog.log ("INTERCEPTED CLIENT COMMAND")
	if module ~= 'vehicle' then return end;
	args = args or {}
	if command == 'attachTrailer' then -- hook the attachTrailer function
	--DebugLog.log ("TRYING TO RUN INTERCEPTED ATTACHTRAILER")
		Commands.attachTrailer(player, args)
	end
	-- add additional commands if needed
	if command == 'detachTrailer' then -- hook the detachTrailer function
	--DebugLog.log ("TRYING TO RUN INTERCEPTED DETACHTRAILER")
		Commands.detachTrailer(player, args)
	end
	
	if command == 'fixPart' then
	--DebugLog.log ("TRYING TO RUN INTERCEPTED FIXPART")
		Commands.fixPart(player, args)
	end
end)