FR_Functions = {}
FR_Functions.changeModel = {}

function FR_Functions.itemMountRemove(part, playerObj)
    local item = part:getInventoryItem()
    part:setInventoryItem(nil)
    part:getVehicle():transmitPartItem(part)
    playerObj:getInventory():AddItem(item)

    if not playerObj:getPrimaryHandItem() and not playerObj:getSecondaryHandItem() then
        playerObj:setPrimaryHandItem(item)
    elseif not playerObj:getPrimaryHandItem() and not item:isRequiresEquippedBothHands() then
        playerObj:setPrimaryHandItem(item)
    elseif not playerObj:getSecondaryHandItem() and not item:isRequiresEquippedBothHands() then
        playerObj:setSecondaryHandItem(item)
    end
    -- DebugLog.log("FR_Functions.itemMountRemove: This will remove an item from the item mount!")
end

function FR_Functions.itemMountAdd(part, item, playerObj)
    -- DebugLog.log("FR_Functions.itemMountAdd: This will add an item to the item mount!")
    part:setInventoryItem(item)
    part:getVehicle():transmitPartItem(part)
    playerObj:removeFromHands(item)
    playerObj:getInventory():DoRemoveItem(item)
    VehicleUtils.FR_SetVisualDefault(part:getVehicle(), part)
end

function FR_Functions.itemMountRemove(part, playerObj, vehicle)
    local item = part:getInventoryItem()
    playerObj:getInventory():AddItem(item)
    -- DebugLog.log("FR_Functions.itemMountAdd: isClient: " .. tostring(isClient()) .. ", isServer: " .. tostring(isServer()))

    if not playerObj:getPrimaryHandItem() and not playerObj:getSecondaryHandItem() then
        playerObj:setPrimaryHandItem(item)
    elseif not playerObj:getPrimaryHandItem() and not item:isRequiresEquippedBothHands() then
        playerObj:setPrimaryHandItem(item)
    elseif not playerObj:getSecondaryHandItem() and not item:isRequiresEquippedBothHands() then
        playerObj:setSecondaryHandItem(item)
    end
    -- if not isServer then
    if isClient() then
        local vehicleID = vehicle:getId()
        local partString = part:getId()
        local args = {
            vehicleID = vehicleID,
            partID = partString
        }
        sendClientCommand(getPlayer(), 'FR_UpdateParts', 'FR_removeMountedPart', args)
    else
        part:setInventoryItem(nil)
        part:getVehicle():transmitPartItem(part)
    end
    -- DebugLog.log("FR_Functions.itemMountRemove: This will remove an item from the item mount!")
end

function FR_Functions.itemMountAdd(part, item, playerObj, vehicle)
    -- DebugLog.log("FR_Functions.itemMountAdd: This will add an item to the item mount!")

    if isClient() then
        local vehicleID = vehicle:getId()
        local partString = part:getId()
        local itemName = item:getType()
        -- local item = 
        local args = {
            vehicleID = vehicleID,
            partID = partString,
            itemName = itemName
        }
        sendClientCommand(getPlayer(), 'FR_UpdateParts', 'FR_addMountedPart', args)
    else
        part:setInventoryItem(item)
        part:getVehicle():transmitPartItem(part)
    end
    playerObj:removeFromHands(item)
    playerObj:getInventory():DoRemoveItem(item)
    VehicleUtils.FR_SetVisualDefault(part:getVehicle(), part)
end

function FR_Functions.togglePart(playerObj, partString)
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Function is running, partString is " ..tostring(partString))

    local inVehicle = playerObj:getVehicle();
    local nearVehicle = ISVehicleMenu.getVehicleToInteractWith(playerObj)

    -- if not inVehicle and not nearVehicle then
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Player isn't in or near a vehicle.")
    -- return end

    local vehicle
    if inVehicle then
        vehicle = inVehicle
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Player is in a vehicle.")
    elseif nearVehicle then
        vehicle = nearVehicle
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Player is near a vehicle.")
    else
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Player isn't in or near a vehicle.")
        return
    end

    local vehicleID = vehicle:getId()
    local part = vehicle:getPartById(partString)
    local opened = part:getDoor():isOpen()
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: " .. tostring(vehicle:getId()) .. "'s " .. tostring(part) .. " is opened: " .. tostring(opened))

    if opened then
        vehicle:playPartAnim(part, "Close")
        part:getDoor():setOpen(false)
        opened = false
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART " .. tostring(partString) .. " is closing!")
    else
        vehicle:playPartAnim(part, "Open")
        part:getDoor():setOpen(true)
        opened = true
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART " .. tostring(partString) .. " is opening!")
    end
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Is the part still opened? " .. tostring(opened))
    local args = {
        vehicleID = vehicleID,
        doorOpen = opened,
        partID = partString
    }
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Is the part in the args opened, too? " .. tostring(args.doorOpen))
    sendClientCommand(getPlayer(), 'FR_UpdateParts', 'FR_setPart', args)
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEPART: Attempting to send client command to server")
end
-- Need to send the data to here, just vehicle/vehicleA. After that, I can get the other vhicle and all that shit. Do main code here.
function FR_Functions.objectTogglePart(playerObj, vehicleID, partString, opened)
    -- DebugLog.log ("FR_FUNCTIONS.OBJECTTOGGLEPART: Attempting to run")
    local vehicle = vehicleID and getVehicleById(vehicleID)
    local part = vehicle:getPartById(partString)
    part:getDoor():setOpen(opened)
    if opened then
        vehicle:playPartAnim(part, "Open")
        -- DebugLog.log ("FR_FUNCTIONS.OBJECTTOGGLEPART: " .. tostring(vehicleID) .. "'s " .. tostring(partString) .. " animation is open.")
    else
        vehicle:playPartAnim(part, "Close")
        -- DebugLog.log ("FR_FUNCTIONS.OBJECTTOGGLEPART: " .. tostring(vehicleID) .. "'s " .. tostring(partString) .. " animation is closed.")
    end
    local args = {
        vehicleID = vehicleID,
        doorOpen = opened,
        partID = partString
    }
    sendClientCommand(getPlayer(), 'FR_UpdateParts', 'FR_setPart', args)
    -- DebugLog.log ("FR_FUNCTIONS.OBJECTTOGGLEPART: Attempting to send client command to server")
end

-- Singleplayer trailer jack functions.
function FR_Functions.toggleTrailerJack(playerObj, vehicle, partString, opened)
    local vehicleID = vehicle
    local vehicle = getVehicleById(vehicleID)
    local trailer

    -- the attachTrailer function should have made sure the vehicle is a trailer with a jack already
    if opened == true and vehicleID then
        trailer = vehicle
    elseif opened == false and vehicleID then
        -- We need to get the closest vehicle to it and check if it's a trailer with part
        -- There's an issue, though, when a third vehicle is nearby. It can confuse it and the trailer.
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK Vehicle is " .. tostring(vehicle:getScriptName()) .. ", ID " .. tostring(vehicleID))
        trailer = ISVehicleTrailerUtils.getTowableVehicleNear(vehicle:getSquare(), vehicle, "trailer", "trailer")
        if not trailer then
            return
        end
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK Trailer is ".. tostring(trailer:getScriptName()))
    else
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK: No trailer, I guess.")
        return
    end

    local part = trailer:getPartById(partString)
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK: part = " .. tostring(part))
    if not part then
        return
    end
    part:getDoor():setOpen(opened)
    if opened then
        trailer:playPartAnim(part, "Open")
    else
        trailer:playPartAnim(part, "Close")
    end
    --	local args = { vehicleID = trailer:getId(), doorOpen = opened, partID = partString }
    --	sendClientCommand(getPlayer(), 'FR_UpdateParts', 'FR_setPart', args)
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLETRAILERJACK: Attempting to send client command to server")
end

function FR_Functions.toggleFridge(playerObj)
    -- DebugLog.log ("FR_FUNCTIONS.TOGGLEFRIDGE: Function is running")
    local vehicle = playerObj:getVehicle();

    if not vehicle then
        -- DebugLog.log ("FR_FUNCTIONS.TOGGLEFRIDGE: Player isn't in or near a vehicle.")
        return
    end

    local vehicleID = vehicle:getId();
    local partFridge = vehicle:getPartById("FR_Fridge");
    local active = partFridge:getModData().FR_FridgeActive;
    -- DebugLog.log ("FR_Functions.toggleFridge: Before sending ClientCommand, the " .. tostring(partFridge) .. " in " .. tostring(vehicleID) .. " is " .. tostring(active))
    local args = {
        vehicleID = vehicleID
    }
    sendClientCommand(getPlayer(), 'FR_UpdateParts', 'setFridge', args)

end

function FR_Functions.toggleOven(playerObj)
    -- DebugLog.log ("FR_FUNCTIONS.toggleOven: Function is running")
    local vehicle = playerObj:getVehicle();

    if not vehicle then
        -- DebugLog.log ("FR_Functions.toggleOven: Player isn't in or near a vehicle.")
        return
    end

    local vehicleID = vehicle:getId();
    local partOven = vehicle:getPartById("FR_Oven");
    local active = partOven:getModData().FR_OvenActive;
    -- DebugLog.log ("FR_Functions.toggleOven: Before sending ClientCommand, the " .. tostring(partOven) .. " in " .. tostring(vehicleID) .. " is " .. tostring(active))
    local args = {
        vehicleID = vehicleID
    }
    sendClientCommand(getPlayer(), 'FR_UpdateParts', 'setOven', args)
end
