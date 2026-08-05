require "Vehicles/Vehicles"
local FR_tableStorage = require("FR_Tables")
local FR_windowTable = FR_tableStorage.FR_windowTable
local FR_roofTypes = FR_tableStorage.FR_roofTypes
local partCanFall = SandboxVars.FRUsedCars.LowConPartsFall
local childPartFalls = SandboxVars.FRUsedCars.PartFallsWithParent
DebugLog.log("Sandbox Variable: Low condition parts fall: " .. tostring(partCanFall))
DebugLog.log("Sandbox Variable: Parts fall with parent: " .. tostring(childPartFalls))

-- Test functions: These run before you do something and test if you're able to.
-- For example, access a container or uninstall a part.

-- Defunct
--[[
function Vehicles.UninstallTest.MultiItems(vehicle, part, chr)
	--DebugLog.log ("UninstallTest.MultiItems: Fucking special uninstall shit is running.")
	local canDo = Vehicles.UninstallTest.Default(vehicle, part, chr);
	if not canDo then
		return false;
	end

	local keyvalues = part:getTable("uninstall")
	if not keyvalues then return false end
	if keyvalues.requireUninstalled2 and (vehicle:getPartById(keyvalues.requireUninstalled2) and vehicle:getPartById(keyvalues.requireUninstalled2):getInventoryItem()) then
		print(getText("ContextMenu_FR_RemoveExtraPart") .. getText(tostring("IGUI_VehiclePart" .. keyvalues.requireUninstalled2)))
		return false;
	end
	if keyvalues.requireUninstalled3 and (vehicle:getPartById(keyvalues.requireUninstalled3) and vehicle:getPartById(keyvalues.requireUninstalled3):getInventoryItem()) then
		print(getText("ContextMenu_FR_RemoveExtraPart") .. getText(tostring("IGUI_VehiclePart" .. keyvalues.requireUninstalled3)))
		return false;
	end
	return true;
end
--]]

function Vehicles.UninstallTest.FR_Default(vehicle, part, chr)
    -- DebugLog.log ("UninstallTest.FR_Default: is running")
    if ISVehicleMechanics.cheat then
        return true;
    end
    local keyvalues = part:getTable("uninstall")
    if not keyvalues then
        return false
    end
    if not part:getInventoryItem() then
        return false
    end
    if not part:getItemType() or part:getItemType():isEmpty() then
        return false
    end
    local typeToItem = VehicleUtils.getItems(chr:getPlayerNum())

    --[[if keyvalues.requireUninstalled and (vehicle:getPartById(keyvalues.requireUninstalled) and vehicle:getPartById(keyvalues.requireUninstalled):getInventoryItem()) then
		return false;
	end--]]
    --[[if keyvalues.requireInstalled then
		local split = keyvalues.requireInstalled:split(";");
		for i,v in ipairs(split) do
			if not vehicle:getPartById(v) or not vehicle:getPartById(v):getInventoryItem() then
				tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. " " .. getText("Tooltip_vehicle_requireInstalled", getText("IGUI_VehiclePart" .. v)) .. " <LINE>";
			end
		end
	end]] --
    if keyvalues.requireUninstalled then
        local split = keyvalues.requireUninstalled:split(";");
        local endFunction
        local cannotRemoveText = ""
        for i, v in ipairs(split) do
            -- tooltip.description = tooltip.description .. " " .. ISVehicleMechanics.bhs .. " " .. getText("Tooltip_vehicle_requireInstalled", getText("IGUI_VehiclePart" .. v)) .. " <LINE>";
            if vehicle:getPartById(v) and vehicle:getPartById(v):getInventoryItem() then
                -- DebugLog.log ("UninstallTest.FR_Default: " .. tostring(keyvalues.requireUninstalled))
                endFunction = true
                local addPartText = getText(tostring("IGUI_VehiclePart" .. v))
                cannotRemoveText = cannotRemoveText .. ": " .. addPartText
            end
        end
        if endFunction then
            print(getText("ContextMenu_FR_RemoveExtraPart") .. cannotRemoveText)
            return false
        end
    end

    if not VehicleUtils.testProfession(chr, keyvalues.professions) then
        return false
    end
    -- allow all perk, but calculate success/failure risk
    --	if not VehicleUtils.testPerks(chr, keyvalues.skills) then return false end
    if not VehicleUtils.testRecipes(chr, keyvalues.recipes) then
        return false
    end
    if not VehicleUtils.testTraits(chr, keyvalues.traits) then
        return false
    end
    if not VehicleUtils.testItems(chr, keyvalues.items, typeToItem) then
        return false
    end

    if keyvalues.requireEmpty and (round(part:getContainerContentAmount(), 3) > 0 or
        (part:getItemContainer() and (part:getItemContainer():getCapacityWeight() > 0))) then
        if part:getItemContainer():getCapacityWeight() then
            -- DebugLog.log("UninstallTest.FR_Default: part:getContainerContentAmount is " .. tostring(part:getItemContainer():getCapacityWeight()))
        end
        return false
    end
    local seatNumber = part:getContainerSeatNumber()
    local seatOccupied = (seatNumber ~= -1) and vehicle:isSeatOccupied(seatNumber)
    if keyvalues.requireEmpty and seatOccupied then
        return false
    end
    -- if doing mechanics on this part require key but player doesn't have it, we'll check that door or windows aren't unlocked also
    if VehicleUtils.RequiredKeyNotFound(part, chr) then
        return false
    end
    return true
end

-- Containers, fridges and other interior items!
function Vehicles.ContainerAccess.FR_VehicleArmory(vehicle, part, chr)
    if chr:getVehicle() == vehicle then
        local seat = vehicle:getSeat(chr)
        -- Characters in the front seats cannot access it.
        return seat ~= 1 and seat ~= 0;
    elseif chr:getVehicle() then
        -- Can't reach from inside a different vehicle.
        return false
    else
        -- Standing outside the vehicle.
        if not vehicle:isInArea("SeatRearLeft", chr) and not vehicle:isInArea("SeatRearRight", chr) then
            return false
        end
        local whichDoor
        if vehicle:isInArea("SeatRearLeft", chr) then
            whichDoor = "DoorRearLeft"
        else
            whichDoor = "DoorRearRight"
        end
        local doorPart = vehicle:getPartById(whichDoor)
        if doorPart and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
            return false
        end
        return true
    end
end

-- Add canAccessInterior = TRUE, in the FRPartInfo table to the seats that can access the trunk
function Vehicles.ContainerAccess.FR_InteriorContainer(vehicle, part, chr)
    if chr:getVehicle() and chr:getVehicle() == vehicle then
        local seatIndex = vehicle:getSeat(chr)
        local seatPart = vehicle:getPartForSeatContainer(seatIndex)
        local keyvaluesContainer = part:getTable("FRPartInfo")
        local keyvaluesSeat = seatPart:getTable("FRPartInfo")
        if keyvaluesSeat and keyvaluesSeat.canAccessInterior and keyvaluesContainer and
            keyvaluesContainer.interiorAccess then
            return true
        end
    elseif chr:getVehicle() then
        -- Can't reach from inside a different vehicle.
        return false
    end
end

-- Old function
--[[
function Vehicles.ContainerAccess.FR_InteriorContainer(vehicle, part, chr)
	if chr:getVehicle() == vehicle then
		local seat = vehicle:getSeat(chr)
		-- Characters in the front seats cannot access it.
		return seat ~= 1 and seat ~= 0 or string.match(string.lower(vehicle:getScriptName()), "trailer_fr_camper" ) ~= nil;
	elseif chr:getVehicle() then
		-- Can't reach from inside a different vehicle.
		return false
	end
	
end
--]]

function Vehicles.ContainerAccess.FR_FillerTrunk(vehicle, part, chr)
    if chr:getVehicle() and chr:getVehicle() == vehicle then
        local seatIndex = vehicle:getSeat(chr)
        local seatPart = vehicle:getPartForSeatContainer(seatIndex)
        local keyvaluesContainer = part:getTable("FRPartInfo")
        local keyvaluesSeat = seatPart:getTable("FRPartInfo")
        if keyvaluesSeat and keyvaluesSeat.canAccessInterior and keyvaluesContainer and
            keyvaluesContainer.interiorAccess then
            return true
        end
    elseif chr:getVehicle() then
        return false
    end
    if not vehicle:isInArea(part:getArea(), chr) then
        return false
    end
    local trunkDoor = vehicle:getPartById("TrunkDoor") or vehicle:getPartById("DoorRear")
    if trunkDoor and trunkDoor:getDoor() then
        if not trunkDoor:getInventoryItem() then
            VehicleUtils.FillTrunk(vehicle, part, true)
            return true
        end
        if not trunkDoor:getDoor():isOpen() then
            return false
        end
    end
    VehicleUtils.FillTrunk(vehicle, part, true)
    return true
end

function Vehicles.ContainerAccess.FR_FillerTrunkInterior(vehicle, part, chr)
    -- DebugLog.log ("ContainerAccess.FR_FillerTrunkInterior is running.")
    if chr:getVehicle() and chr:getVehicle() == vehicle then
        local seatIndex = vehicle:getSeat(chr)
        local seatPart = vehicle:getPartForSeatContainer(seatIndex)
        local keyvaluesSeat = seatPart:getTable("FRPartInfo")
        local trunkDoor = vehicle:getPartById("InteriorTrunkDoor")
        if keyvaluesSeat and keyvaluesSeat.canAccessInterior and
            not (trunkDoor and trunkDoor:getInventoryItem() and trunkDoor:getDoor() and not trunkDoor:getDoor():isOpen()) then
            return true
        else
            return false
        end
    elseif chr:getVehicle() then
        -- DebugLog.log ("ContainerAccess.FR_FillerTrunkInterior chr:getVehicle is " .. tostring(chr:getVehicle()))
        return false
    end
    if not vehicle:isInArea(part:getArea(), chr) then
        -- DebugLog.log ("ContainerAccess.FR_FillerTrunkInterior player is not in area.")
        return false
    end
    local keyvalues = part:getTable("FRPartInfo")
    if not keyvalues or (keyvalues and not keyvalues.blocksTrunk) then
        -- DebugLog.log ("ContainerAccess.FR_FillerTrunkInterior no keyvalues or keyvalues.blocksTrunk.")
        return false
    end

    local trunkBlocker = vehicle:getPartById(tostring(keyvalues.blocksTrunk))
    if not trunkBlocker or (trunkBlocker and trunkBlocker:getInventoryItem()) then
        -- DebugLog.log ("ContainerAccess.FR_FillerTrunkInterior no trunkBlocker or trinkBlocker:getInventoryItem.")
        return false
    end

    local trunkDoor = vehicle:getPartById("InteriorTrunkDoor")
    if trunkDoor and trunkDoor:getDoor() then
        if not trunkDoor:getInventoryItem() then
            VehicleUtils.FillTrunk(vehicle, part, true)
            return true
        end
        if not trunkDoor:getDoor():isOpen() then
            -- DebugLog.log ("ContainerAccess.FR_FillerTrunkInterior trunk door is closed.")
            return false
        end
    end
    VehicleUtils.FillTrunk(vehicle, part, true)
    return true
end

function Vehicles.ContainerAccess.FR_FillerTrunkMultiAccess(vehicle, part, chr)
    if chr:getVehicle() and chr:getVehicle() == vehicle then
        local seatIndex = vehicle:getSeat(chr)
        local seatPart = vehicle:getPartForSeatContainer(seatIndex)
        local keyvaluesContainer = part:getTable("FRPartInfo")
        local keyvaluesSeat = seatPart:getTable("FRPartInfo")
        if keyvaluesSeat and keyvaluesSeat.canAccessInterior and keyvaluesContainer and
            keyvaluesContainer.interiorAccess then
            return true
        end
    elseif chr:getVehicle() then
        return false
    end

    local trunkDoor = vehicle:getPartById("TrunkDoor")
    local trunkSideDoor = vehicle:getPartById("TrunkSideDoor")
    local trunkAccess
    if trunkDoor and vehicle:isInArea(trunkDoor:getArea(), chr) then
        trunkAccess = trunkDoor
    elseif trunkSideDoor and vehicle:isInArea(trunkSideDoor:getArea(), chr) then
        trunkAccess = trunkSideDoor
    else
        return false
    end

    if trunkAccess and trunkAccess:getDoor() then
        if not trunkAccess:getInventoryItem() then
            VehicleUtils.FillTrunk(vehicle, part, true)
            return true
        end
        if not trunkAccess:getDoor():isOpen() then
            return false
        end
    end
    VehicleUtils.FillTrunk(vehicle, part, true)
    return true
end

-- Original multi-trunk access script
--[[function Vehicles.ContainerAccess.FR_FillerTrunkMultiAccess(vehicle, part, chr)
	if chr:getVehicle() then return false end
	local trunkDoor = vehicle:getPartById("TrunkDoor") 
	local trunkSideDoor = vehicle:getPartById("TrunkSideDoor")
	local trunkAccess
	if trunkDoor and vehicle:isInArea(trunkDoor:getArea(), chr) then
		trunkAccess = trunkDoor
	elseif trunkSideDoor and vehicle:isInArea(trunkSideDoor:getArea(), chr) then
		trunkAccess = trunkSideDoor
	else
	return false end
	
	if trunkAccess and trunkAccess:getDoor() then
		if not trunkAccess:getInventoryItem() then
			VehicleUtils.FillTrunk(vehicle, part, true)
			return true
		end
		if not trunkAccess:getDoor():isOpen() then return false end
	end
	VehicleUtils.FillTrunk(vehicle, part, true)
	return true
end--]]

function Vehicles.ContainerAccess.FR_VisualTruckBedFiller(vehicle, part, chr)
    if chr:getVehicle() and chr:getVehicle() == vehicle then
        local seatIndex = vehicle:getSeat(chr)
        local seatPart = vehicle:getPartForSeatContainer(seatIndex)
        local keyvaluesContainer = part:getTable("FRPartInfo")
        local keyvaluesSeat = seatPart:getTable("FRPartInfo")
        if keyvaluesSeat and keyvaluesSeat.canAccessInterior and keyvaluesContainer and
            keyvaluesContainer.interiorAccess then
            return true
        end
    elseif chr:getVehicle() then
        return false
    end
    local bedAttachmentUserdata = vehicle:getPartById("FRAttachmentBed")
    if vehicle:isInArea(part:getArea(), chr) then
        local bedAttachment = bedAttachmentUserdata and bedAttachmentUserdata:getInventoryItem() and
                                  bedAttachmentUserdata:getInventoryItem():getType()
        if not bedAttachment or bedAttachment == "FRRollcage" then
            VehicleUtils.FillTrunk(vehicle, part, true)
            -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: There's nothing blocking the trunk. ")
            return true
        end
        -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: The trunk was blocked.")		
    end
    if bedAttachmentUserdata and vehicle:isInArea(bedAttachmentUserdata:getArea(), chr) then
        -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: Player is in trunk area.")
        local trunkDoor = vehicle:getPartById("TrunkDoor") or vehicle:getPartById("DoorRear")
        if trunkDoor and trunkDoor:getDoor() then
            -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: Checking trunk doors.")
            if not trunkDoor:getInventoryItem() or trunkDoor:getDoor():isOpen() then
                -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: Trunk access.")
                VehicleUtils.FillTrunk(vehicle, part, true)
                return true
            end
            if not trunkDoor:getDoor():isOpen() then
                -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: Door's closed, ending function.")
                return false
            end
        end
    else
        -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: Player isn't in either area.")
        return false
    end
    -- DebugLog.log ("ContainerAccess.FR_VisualTruckBedFiller: Something went wrong. Shit.")
end

function Vehicles.ContainerAccess.FR_FillerTrunkSideContainer(vehicle, part, chr)
    if chr:getVehicle() then
        return false
    end
    if not vehicle:isInArea(part:getArea(), chr) then
        return false
    end
    local trunkDoor = vehicle:getPartById("FRSideContainerDoor")
    if trunkDoor and trunkDoor:getDoor() then
        if not trunkDoor:getInventoryItem() then
            VehicleUtils.FillTrunk(vehicle, part, true)
            return true
        end
        if not trunkDoor:getDoor():isOpen() then
            return false
        end
    end
    VehicleUtils.FillTrunk(vehicle, part, true)
    return true
end

-- Complete: These functions run when an action, such as installing a part, is complete.

function VehicleUtils.FR_GetDeafultMaxCapacity(vehicle, part)
    if not part and part:getInventoryItem() then
        -- DebugLog.log ("VehicleUtils.FR_ResetMaxCapacity: Nothing to check! Ending function!")
        return
    end
    local oldItem = part:getInventoryItem()
    local itemType = oldItem:getType()
    -- DebugLog.log ("VehicleUtils.FR_ResetMaxCapacity: oldItem (" .. tostring(itemType) .. ") maxCapacity is " .. tostring(oldItem:getMaxCapacity()))
    local newItem = instanceItem(itemType)
    -- part:setInventoryItem(newItem)
    local defaultCap = newItem:getMaxCapacity()
    -- DebugLog.log ("VehicleUtils.FR_ResetMaxCapacity: newItem (" .. tostring(newItem:getType()) .. ") maxCapacity is " .. tostring(newItem:getMaxCapacity()))
    return defaultCap
end

function Vehicles.InstallComplete.FR_VisualBedAttachment(vehicle, part)
    -- Vanilla code
    vehicle:doDamageOverlay()
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
    local trunkPart = vehicle:getPartById("TruckBed")
    local trunkItem = trunkPart:getInventoryItem()
    local bedAttItem = part:getInventoryItem()
    if not trunkItem then
        -- DebugLog.log ("InstallComplete.FR_VisualBedAttachment: No trunk item, ending function.")
        return
    end

    local trunkDefaultMaxCap = VehicleUtils.FR_GetDeafultMaxCapacity(vehicle, trunkPart)
    local maxCapMulti = 0
    if bedAttItem and bedAttItem:getType() == "Tarp" then
        maxCapMulti = 3
    elseif bedAttItem then
        maxCapMulti = VehicleUtils.FR_GetDeafultMaxCapacity(vehicle, part)
    end

    local trunkMaxCap = trunkDefaultMaxCap + (trunkDefaultMaxCap * (maxCapMulti / 100))
    trunkItem:setMaxCapacity(trunkMaxCap)

    -- Cap after damage formula
    local conAdjustedCap = (trunkMaxCap * 0.2) + ((trunkMaxCap * 0.8) * trunkPart:getCondition() / 100)
    if isServer() then
        -- DebugLog.log("InstallComplete.FR_VisualBedAttachment: IsServer: " .. tostring(isServer()) .. ", (should be true), isClient: " .. tostring(isClient()))
        local vehicleID = vehicle:getId()
        local partID = part:getId()
        local args = {
            vehicleID = vehicleID,
            capacity = conAdjustedCap
        }
        sendServerCommand('FR_UpdateParts', 'FR_UpdateTrunkCapacity', args)
    else
        -- DebugLog.log("InstallComplete.FR_VisualBedAttachment: IsServer: " .. tostring(isServer()) .. ", (should be false), isClient: " .. tostring(isClient()))
        trunkPart:setContainerCapacity(conAdjustedCap)
    end
    -- DebugLog.log ("InstallComplete.FR_VisualBedAttachment: trunkItem:        " .. tostring(trunkItem:getType()) .. ". maxCapacity: " .. tostring(trunkItem:getMaxCapacity()) .. ". getContainerCapacity: " .. tostring(trunkPart:getContainerCapacity()) .. ". getItemCapacity is: " .. tostring(trunkItem:getItemCapacity()))
    -- DebugLog.log ("InstallComplete.FR_VisualBedAttachment: bedAttItem:       " .. tostring(bedAttItem:getType()) .. ". maxCapacity: " .. tostring(bedAttItem:getMaxCapacity()) .. ". getContainerCapacity: " .. tostring(part:getContainerCapacity()) .. ". getItemCapacity is: " .. tostring(bedAttItem:getItemCapacity()))
end

function Vehicles.UninstallComplete.FR_VisualBedAttachment(vehicle, part, item)
    vehicle:doDamageOverlay()
    -- My code
    part:setAllModelsVisible(false)
    -- DebugLog.log ("UninstallComplete.FR_VisualBedAttachment: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " models to hidden.")
    local keyvalues = part:getTable("FRPartInfo")
    local childPart = keyvalues and keyvalues.childVisual
    -- DebugLog.log ("UninstallComplete.FR_VisualBedAttachment: childPart is " .. tostring(childPart))
    if childPart then
        VehicleUtils.FR_SetVisualDefault(vehicle, part)
    end

    local trunkPart = vehicle:getPartById("TruckBed")
    local trunkItem = trunkPart:getInventoryItem()
    if not trunkItem then
        -- DebugLog.log ("UninstallComplete.FR_VisualBedAttachment: No trunk item, ending function.")
        return
    end

    local trunkMaxCap = VehicleUtils.FR_GetDeafultMaxCapacity(vehicle, trunkPart)
    trunkItem:setMaxCapacity(trunkMaxCap)

    -- Cap after damage formula
    --[[local conAdjustedCap = (trunkMaxCap*0.2) + ((trunkMaxCap*0.8)*trunkPart:getCondition()/100)
	trunkPart:setContainerCapacity(conAdjustedCap)
	--DebugLog.log ("UninstallComplete.FR_VisualBedAttachment: trunkItem:        " .. tostring(trunkItem:getType()) .. ". maxCapacity: " .. tostring(trunkItem:getMaxCapacity()) .. ". getContainerCapacity: " .. tostring(trunkPart:getContainerCapacity()) .. ". getItemCapacity is: " .. tostring(trunkItem:getItemCapacity()))
	--]]
    local conAdjustedCap = (trunkMaxCap * 0.2) + ((trunkMaxCap * 0.8) * trunkPart:getCondition() / 100)
    if isServer() then
        -- DebugLog.log("UninstallComplete.FR_VisualBedAttachment: IsServer: " .. tostring(isServer()) .. ", (should be true)  isClient: " .. tostring(isClient()))
        local vehicleID = vehicle:getId()
        local partID = part:getId()
        local args = {
            vehicleID = vehicleID,
            capacity = conAdjustedCap
        }
        sendServerCommand('FR_UpdateParts', 'FR_UpdateTrunkCapacity', args)
    else
        -- DebugLog.log("UninstallComplete.FR_VisualBedAttachment: IsServer: " .. tostring(isServer()) .. ", (should be false) isClient: " .. tostring(isClient()))
        trunkPart:setContainerCapacity(conAdjustedCap)
    end
    -- DebugLog.log ("UninstallComplete.FR_VisualBedAttachment: trunkItem:        " .. tostring(trunkItem:getType()) .. ". maxCapacity: " .. tostring(trunkItem:getMaxCapacity()) .. ". getContainerCapacity: " .. tostring(trunkPart:getContainerCapacity()) .. ". getItemCapacity is: " .. tostring(trunkItem:getItemCapacity()))
end

function Vehicles.InstallComplete.FR_VisualDefault(vehicle, part)
    -- Vanilla code
    vehicle:doDamageOverlay()
    -- My code
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
end

-- Part, vehicle ID and vehicle work
function Vehicles.UninstallComplete.FR_VisualDefault(vehicle, part, item)
    vehicle:doDamageOverlay()
    -- My code
    part:setAllModelsVisible(false)
    -- DebugLog.log ("UninstallComplete.FR_VisualDefault: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " models to hidden.")
    local keyvalues = part:getTable("FRPartInfo")
    local childPart = keyvalues and keyvalues.childVisual
    -- DebugLog.log ("UninstallComplete.FR_VisualDefault: childPart is " .. tostring(childPart))
    if childPart then
        VehicleUtils.FR_SetVisualDefault(vehicle, part)
    end
    if vehicle:hasLightbar() and item and string.match(item:getType(), "FRTopLightBar") then
        -- DebugLog.log("UninstallComplete.FR_VisualDefault: Item is " .. tostring(item:getType()))
        -- vehicle:getLightbarLightsMode(0)
        -- vehicle:setLightbarSirenMode(0)
        -- activeSiren = false
        -- activeLights = false
        if vehicle:getLightbarLightsMode() > 0 then
            vehicle:setLightbarLightsMode(0)
            activeLights = false
        end
        if vehicle:getLightbarSirenMode() > 0 then
            vehicle:setLightbarSirenMode(0)
            activeSiren = false
        end
    end
end

function Vehicles.InstallComplete.FR_VisualDoor(vehicle, part)
    local item = part:getInventoryItem()
    if not item then
        return
    end
    part:getDoor():setLocked(false)
    part:getDoor():setLockBroken(item:getModData().lockBroken or false)
    vehicle:transmitPartDoor(part)
    vehicle:doDamageOverlay()

    VehicleUtils.FR_SetVisualDefault(vehicle, part)
end

function Vehicles.UninstallComplete.FR_VisualDoor(vehicle, part, item)
    if not item then
        return
    end
    item:getModData().lockBroken = part:getDoor():isLockBroken()
    vehicle:transmitPartDoor(part)
    vehicle:doDamageOverlay()

    -- DebugLog.log ("Hiding all models for " .. tostring(part:getId()))
    part:setAllModelsVisible(false)
    -- DebugLog.log ("Vehicles.UninstallComplete.FR_VisualDoor: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " models to hidden.")
end

function Vehicles.InstallComplete.FR_VisualHubcap(vehicle, part)
    local item = part:getInventoryItem()
    if not item then
        return
    end
    vehicle:doDamageOverlay()
    VehicleUtils.FR_SetVisualTire(vehicle, part)
end

function Vehicles.UninstallComplete.FR_VisualHubcap(vehicle, part, item)
    if not item then
        return
    end
    vehicle:doDamageOverlay()
    VehicleUtils.FR_SetVisualTire(vehicle, part)
end

function Vehicles.InstallComplete.FR_VisualRadio(vehicle, part)
    local deviceData = part:createSignalDevice()
    local invItem = VehicleUtils.createPartInventoryItem(part)
    local media
    -- Disabled for future work
    -- if invItem and invItem:getDeviceData() then
    -- media = invItem:getDeviceData():removeMediaItem(player:getInventory())
    -- end
    if deviceData and invItem then
        deviceData:setDeviceName(invItem:getDeviceData():getDeviceName())
        deviceData:setIsTwoWay(invItem:getDeviceData():getIsTwoWay())
        deviceData:setTransmitRange(invItem:getDeviceData():getTransmitRange())
        deviceData:setMicRange(invItem:getDeviceData():getMicRange())
        deviceData:setBaseVolumeRange(invItem:getDeviceData():getBaseVolumeRange())
        deviceData:setIsPortable(false)
        deviceData:setIsTelevision(invItem:getDeviceData():getIsTelevision())
        deviceData:setMinChannelRange(invItem:getDeviceData():getMinChannelRange())
        deviceData:setMaxChannelRange(invItem:getDeviceData():getMaxChannelRange())
        deviceData:setIsBatteryPowered(false)
        deviceData:setIsHighTier(invItem:getDeviceData():getIsHighTier())
        deviceData:setUseDelta(invItem:getDeviceData():getUseDelta())
        deviceData:setMediaType(invItem:getDeviceData():getMediaType())
        deviceData:setChannel(invItem:getDeviceData():getChannel())
    end
    vehicle:transmitPartItem(part);
    -- My code
    VehicleUtils.SetVisualRadio(vehicle, part)
end

function Vehicles.InstallComplete.FR_VisualTire(vehicle, part)
    local wheelIndex = part:getWheelIndex()
    vehicle:setTireRemoved(wheelIndex, false)
    local partID = tostring(part:getId())
    if partID:match("Spare") then
        VehicleUtils.FR_SetVisualDefault(vehicle, part)
    else
        VehicleUtils.FR_SetVisualTire(vehicle, part)
    end
end

function Vehicles.UninstallComplete.FR_VisualTire(vehicle, part, item)
    local wheelIndex = part:getWheelIndex()
    vehicle:setTireRemoved(wheelIndex, true)
    -- DebugLog.log ("Hiding all models for " .. tostring(part:getId()))
    part:setAllModelsVisible(false)
end

function Vehicles.InstallComplete.FR_VisualDualTire(vehicle, part)
    VehicleUtils.FR_VisualOuterTire(vehicle, part)
end

function Vehicles.UninstallComplete.FR_VisualDualTire(vehicle, part, item)
    VehicleUtils.FR_VisualOuterTire(vehicle, part)
end

function Vehicles.InstallComplete.FR_VisualRemovableBed(vehicle, part)
    -- Vanilla code
    vehicle:doDamageOverlay()
    -- My code
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
    VehicleUtils.FillTrunk(vehicle, part, false)
end

function Vehicles.UninstallTest.FR_TrailerHitch(vehicle, part, chr)
    local canDo = Vehicles.UninstallTest.Default(vehicle, part, chr);
    if not canDo then
        return false;
    end
    if vehicle:getVehicleTowing() then
        print("Disconnnect the trailer, my dude!")
        return false;
    end
    return true;
end

function Vehicles.InstallComplete.FR_VisualWindow(vehicle, part)
    if part:getWindow() then
        vehicle:transmitPartWindow(part)
    end
    vehicle:doDamageOverlay()
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
end

-- Create: These functions run when the vehicle is created.
-- I have ADHD.

function Vehicles.Create.FR_NoKeyEngine(vehicle, part)
    vehicle:setHotwired(true)
    -- DebugLog.log ("FR_NOKEYENGINE: Spawning vehicle as hotwired: " .. tostring(vehicle:isHotwired()))
    if SandboxVars.VehicleEasyUse then
        vehicle:setEngineFeature(100, 30, vehicle:getScript():getEngineForce());
        return;
    end
    part:setRandomCondition(nil);
    local type = VehicleType.getTypeFromName(vehicle:getVehicleType());
    local engineQuality = 100;
    if type then
        local baseQuality = vehicle:getScript():getEngineQuality() * type:getBaseVehicleQuality();
        -- bit of randomize
        engineQuality = ZombRand(baseQuality - 10, baseQuality + 10);
    end
    engineQuality = ZombRand(engineQuality - 5, engineQuality + 5);
    engineQuality = math.max(engineQuality, 0)
    engineQuality = math.min(engineQuality, 100)

    local engineLoudness = vehicle:getScript():getEngineLoudness() or 100;
    engineLoudness = engineLoudness * (SandboxVars.ZombieAttractionMultiplier or 1);

    local qualityBoosted = engineQuality * 1.6;
    if qualityBoosted > 100 then
        qualityBoosted = 100;
    end
    local qualityModifier = math.max(0.6, ((qualityBoosted) / 100));
    local enginePower = vehicle:getScript():getEngineForce() * qualityModifier;

    vehicle:setEngineFeature(engineQuality, engineLoudness, enginePower);
end

-- This runs when the car is created. Use it for any spawn type info.
function Vehicles.Create.FR_OnCarCreate(vehicle, part)
    if not vehicle then
        return
    end
    if part:getTable("FR_PaintInfo") then
        local keyvalues = part:getTable("FR_PaintInfo")
        local colorHue = vehicle:getColorHue()
        local colorSat = vehicle:getColorSaturation()
        local colorValue = vehicle:getColorValue()

        -- DebugLog.log ("Create.FR_OnCarCreate: Original: Hue: " .. tostring(colorHue) .. ", Sat: " .. tostring(colorSat) .. ", Value: " .. tostring(colorValue))
        -- This checks if setHue is in use.
        -- If it is, it sets it to the setHue.
        if keyvalues.setHue then
            colorHue = tonumber(keyvalues.setHue)
            -- If not and it has a min value, it checks if the hue is below the min value.
            -- If it is, it sets the Hue to the min.
        elseif keyvalues.minHue and colorHue < tonumber(keyvalues.minHue) then
            colorHue = tonumber(keyvalues.minHue)
            -- If it's not below the min or there is none set and there is a max set, it checks if the hue is above the max.
            -- If it's above the max, it sets the Hue to the max.
        elseif keyvalues.maxHue and colorHue > tonumber(keyvalues.maxHue) then
            colorHue = tonumber(keyvalues.maxHue)
        end

        if keyvalues.setSat then
            colorSat = tonumber(keyvalues.setSat)
        elseif keyvalues.minSat and colorSat < tonumber(keyvalues.minSat) then
            colorSat = tonumber(keyvalues.minSat)
        elseif keyvalues.maxSat and colorSat > tonumber(keyvalues.maxSat) then
            colorSat = tonumber(keyvalues.maxSat)
        end

        if keyvalues.setValue then
            colorValue = tonumber(keyvalues.setValue)
        elseif keyvalues.minValue and colorValue < tonumber(keyvalues.minValue) then
            colorValue = tonumber(keyvalues.minValue)
        elseif keyvalues.maxValue and colorValue > tonumber(keyvalues.maxValue) then
            colorValue = tonumber(keyvalues.maxValue)
        end

        -- If the Hue is above 0.99 or below 0.0, it sets it to one of those numbers.
        if tonumber(colorHue) >= 1 then
            colorHue = 0.99
            -- DebugLog.log ("Create.FR_OnCarCreate: WARNING! Hue is over 0.99!!! Setting to " .. tostring(colorHue) .. ".")
        elseif tonumber(colorHue) < 0 then
            colorHue = 0.0
            -- DebugLog.log ("Create.FR_OnCarCreate: WARNING! Hue is under 0.0!!! Setting to " .. tostring(colorHue) .. ".")
        end

        if tonumber(colorSat) >= 1 then
            colorSat = 0.99
            -- DebugLog.log ("Create.FR_OnCarCreate: WARNING! Sat is over 0.99!!! Setting to " .. tostring(colorSat) .. ".")
        elseif tonumber(colorSat) < 0 then
            colorSat = 0.0
            -- DebugLog.log ("Create.FR_OnCarCreate: WARNING! Sat is under 0.0!!! Setting to " .. tostring(colorSat) .. ".")
        end

        if tonumber(colorValue) >= 1 then
            colorValue = 0.99
            -- DebugLog.log ("Create.FR_OnCarCreate: WARNING! Value is over 0.99!!! Setting to " .. tostring(colorValue) .. ".")
        elseif tonumber(colorValue) < 0 then
            colorValue = 0.0
            -- DebugLog.log ("Create.FR_OnCarCreate: WARNING! Value is under 0.0!!! Setting to " .. tostring(colorValue) .. ".")
        end

        -- DebugLog.log ("Create.FR_OnCarCreate: Updated:  Hue: " .. tostring(colorHue) .. ", Sat: " .. tostring(colorSat) .. ", Value: " .. tostring(colorValue))
        -- This sends the new hue off to the color factory or whatever.
        vehicle:setColorHSV(colorHue, colorSat, colorValue)
    end
end

function Vehicles.Create.FR_VisualDefault(vehicle, part)
    if VehicleUtils.FR_ReturnSpawn(vehicle, part) then
        return
    end
    -- DebugLog.log ("Create.FR_VisualDefault: Passed check. Spawning " .. tostring(part:getId()))
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    -- DebugLog.log ("Create.FR_VisualDefault: " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()) .. " Spawning. Item is " .. tostring(item))
    VehicleUtils.FR_SetVisualDefault(vehicle, part)

    local keyvalues = part:getTable("FRPartInfo")
    if part:getInventoryItem() and part:getDoor() and keyvalues and tonumber(keyvalues.openChance) then
        local openChance = (keyvalues and tonumber(keyvalues.openChance))
        if keyvalues.openChance and ZombRand(100) < openChance then
            part:getDoor():setOpen(true)
            -- vehicle:playPartAnim(part, "Opened")
        else
            part:getDoor():setOpen(false)
            -- vehicle:playPartAnim(part, "Closed")
        end
    end
end

function Vehicles.Create.FR_VisualDoor(vehicle, part)
    if VehicleUtils.FR_ReturnSpawn(vehicle, part) then
        return
    end
    -- DebugLog.log ("Create.FR_VisualDoor: Passed check. Spawning " .. tostring(part:getId()))
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    VehicleUtils.FR_SetVisualDefault(vehicle, part)

    if SandboxVars.VehicleEasyUse then
        part:getDoor():setOpen(false);
        part:getDoor():setLocked(false);
        part:getDoor():setLockBroken(false);
        return;
    end
    if vehicle:isGoodCar() then
        part:getDoor():setOpen(false);
        part:getDoor():setLocked(SandboxVars.LockedCar ~= 1);
        part:getDoor():setLockBroken(false);
        return;
    end
    local chance = 50;
    if SandboxVars.LockedCar == 1 then
        chance = -1;
    elseif SandboxVars.LockedCar == 2 then
        chance = 15;
    elseif SandboxVars.LockedCar == 3 then
        chance = 30;
    elseif SandboxVars.LockedCar == 5 then
        chance = 65;
    elseif SandboxVars.LockedCar == 6 then
        chance = 80;
    end
    local doorFrontLeft = vehicle:getPartById("DoorFrontLeft");
    if doorFrontLeft and doorFrontLeft:getDoor() and doorFrontLeft ~= part then
        part:getDoor():setOpen(doorFrontLeft:getDoor():isOpen());
        part:getDoor():setLocked(doorFrontLeft:getDoor():isLocked())
        part:getDoor():setLockBroken(ZombRand(1, 100) < 5) -- 5%
        return
    end
    local locked = false;
    if ZombRand(100) <= chance then
        locked = true;
    else -- car is open, no alarm
        part:getVehicle():setAlarmed(false);
    end
    part:getDoor():setOpen(false);
    part:getDoor():setLocked(locked);
    part:getDoor():setLockBroken(ZombRand(1, 100) < 5) -- 5%
end

function Vehicles.Create.FR_VisualHubcap(vehicle, part)
    local keyvalues = part:getTable("FRPartInfo")
    local noPartsChance = keyvalues and keyvalues.noPartsChance
    local allPartsChance = keyvalues and keyvalues.allPartsChance
    local doSpawn
    local doNotSpawn
    local frontLeftPart = vehicle:getPartById("FRHubcapFrontLeft")
    -- DebugLog.log ("Create.FR_VisualHubcap: part is " .. tostring(part:getId()))
    if allPartsChance then
        if part == frontLeftPart and tonumber(allPartsChance) > ZombRand(100) then
            doSpawn = true
            part:getModData().doSpawn = true
            -- DebugLog.log ("Create.FR_VisualHubcap: part is frontLeftPart and allPartsChance is " .. tonumber(allPartsChance) .. "% and passed the check.")
        elseif frontLeftPart and part ~= frontLeftPart and frontLeftPart:getModData().doSpawn == true then
            doSpawn = true
            -- DebugLog.log ("Create.FR_VisualHubcap: allPartsChance is true and part is not frontLeftPart. doSpawn is true.")
        end
    end

    if noPartsChance and not doSpawn then
        if part == frontLeftPart and tonumber(noPartsChance) > ZombRand(100) then
            doNotSpawn = true
            part:getModData().doNotSpawn = true
            -- DebugLog.log ("Create.FR_VisualHubcap: part is frontLeftPart and noPartsChance is " .. tonumber(noPartsChance) .. "% and passed the check.")
        elseif frontLeftPart and part ~= frontLeftPart and frontLeftPart:getModData().doNotSpawn == true then
            doNotSpawn = true
            -- DebugLog.log ("Create.FR_VisualHubcap: noPartsChance is true and part is not frontLeftPart. doNotSpawn is true.")
        end
    end
    -- DebugLog.log ("Create.FR_VisualHubcap: doSpawn is " .. tostring(doSpawn) .. ", doNotSpawn is " .. tostring(doNotSpawn))

    if doNotSpawn or (not doSpawn and VehicleUtils.FR_ReturnSpawn(vehicle, part)) then
        return
    end
    -- DebugLog.log ("Create.FR_VisualHubcap: Passed check. Spawning " .. tostring(part:getId()))
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    -- DebugLog.log ("Create.FR_VisualHubcap: Passed check. Spawning " .. tostring(part:getId()) .. ". Item is " .. tostring(item))
    VehicleUtils.FR_SetVisualTire(vehicle, part)
end

-- This works, but not how I want it to. Switching to a moddata method.
--[[
function Vehicles.Create.FR_VisualHubcap(vehicle, part)
	local keyvalues = part:getTable("FRPartInfo")
	local noPartsChance = keyvalues and keyvalues.noPartsChance
	local allPartsChance = keyvalues and keyvalues.allPartsChance
	local doSpawn
	local doNotSpawn
	local frontLeftPart = vehicle:getPartById("FRHubcapFrontLeft")
	--DebugLog.log ("Create.FR_VisualHubcap: part is " .. tostring(part:getId()))
	if allPartsChance then
		if part == frontLeftPart and tonumber(allPartsChance) > ZombRand(100) then
			doSpawn = true
			--DebugLog.log ("Create.FR_VisualHubcap: part is frontLeftPart and allPartsChance is " .. tonumber(allPartsChance) .. "% and passed the check.")
		elseif frontLeftPart and part ~= frontLeftPart and frontLeftPart:getInventoryItem() then
			doSpawn = true
			--DebugLog.log ("Create.FR_VisualHubcap: allPartsChance is true and part is not frontLeftPart. doSpawn is true.")
		end
	end
	
	if noPartsChance and not doSpawn then
		if part == frontLeftPart and tonumber(noPartsChance) > ZombRand(100) then
			doNotSpawn = true
			--DebugLog.log ("Create.FR_VisualHubcap: part is frontLeftPart and noPartsChance is " .. tonumber(noPartsChance) .. "% and passed the check.")
		elseif frontLeftPart and part ~= frontLeftPart and not frontLeftPart:getInventoryItem() then
			doNotSpawn = true
			--DebugLog.log ("Create.FR_VisualHubcap: noPartsChance is true and part is not frontLeftPart. doNotSpawn is true.")
		end
	end
	--DebugLog.log ("Create.FR_VisualHubcap: doSpawn is " .. tostring(doSpawn) .. ", doNotSpawn is " .. tostring(doNotSpawn))
	
	if doNotSpawn or (not doSpawn and VehicleUtils.FR_ReturnSpawn(vehicle, part)) then
	return end
	--DebugLog.log ("Create.FR_VisualHubcap: Passed check. Spawning " .. tostring(part:getId()))
	local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
	--DebugLog.log ("Create.FR_VisualHubcap: Passed check. Item is " .. tostring(item))
	VehicleUtils.FR_SetVisualTire(vehicle, part)
end
--]]

function Vehicles.Create.FR_VisualTrunkDoor(vehicle, part)
    if VehicleUtils.FR_ReturnSpawn(vehicle, part) then
        return
    end
    -- DebugLog.log ("Create.FR_VisualTrunkDoor: Passed check. Spawning " .. tostring(part:getId()))
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
    if SandboxVars.VehicleEasyUse then
        part:getDoor():setOpen(false)
        part:getDoor():setLocked(false)
        part:getDoor():setLockBroken(false)
        return
    end
    if vehicle:isGoodCar() then
        part:getDoor():setOpen(false)
        part:getDoor():setLocked(SandboxVars.LockedCar ~= 1)
        part:getDoor():setLockBroken(false)
        return
    end
    local chance = 50
    if SandboxVars.LockedCar == 1 then
        chance = -1
    elseif SandboxVars.LockedCar == 2 then
        chance = 15
    elseif SandboxVars.LockedCar == 3 then
        chance = 30
    elseif SandboxVars.LockedCar == 5 then
        chance = 65
    elseif SandboxVars.LockedCar == 6 then
        chance = 80
    end
    local locked = ZombRand(100) <= chance
    part:getDoor():setOpen(false)
    part:getDoor():setLocked(locked)
    part:getDoor():setLockBroken(ZombRand(1, 100) < 5) -- 5%
end

function Vehicles.Create.FR_Fridge(vehicle, part)
    local invItem = VehicleUtils.createPartInventoryItem(part);

    if part:getInventoryItem() and part:getItemContainer() then
        part:getModData().FR_FridgeActive = false
        part:getItemContainer():setType("fridge")
        part:getItemContainer():setCustomTemperature(1)
    end
end

function Vehicles.Create.FR_Oven(vehicle, part)
    local invItem = VehicleUtils.createPartInventoryItem(part);

    if part:getInventoryItem() and part:getItemContainer() then
        part:getModData().FR_OvenActive = false
        part:getItemContainer():setType("stove")
        part:getItemContainer():setCustomTemperature(1)
    end
end

function Vehicles.Create.FR_VisualRadio(vehicle, part)
    local deviceData = part:createSignalDevice()
    local invItem = VehicleUtils.createPartInventoryItem_FRRadio(part)
    if deviceData and invItem then -- safety in case mods interfere with this function
        deviceData:setDeviceName(invItem:getDeviceData():getDeviceName())
        deviceData:setIsTwoWay(invItem:getDeviceData():getIsTwoWay())
        deviceData:setTransmitRange(invItem:getDeviceData():getTransmitRange())
        deviceData:setMicRange(invItem:getDeviceData():getMicRange())
        deviceData:setBaseVolumeRange(invItem:getDeviceData():getBaseVolumeRange())
        deviceData:setIsPortable(false)
        deviceData:setIsTelevision(invItem:getDeviceData():getIsTelevision())
        deviceData:setMinChannelRange(invItem:getDeviceData():getMinChannelRange())
        deviceData:setMaxChannelRange(invItem:getDeviceData():getMaxChannelRange())
        deviceData:setIsBatteryPowered(false)
        deviceData:setIsHighTier(invItem:getDeviceData():getIsHighTier())
        deviceData:setUseDelta(invItem:getDeviceData():getUseDelta())
        deviceData:setMediaType(invItem:getDeviceData():getMediaType())
        deviceData:generatePresets()
        deviceData:setRandomChannel()
    end
    -- My code
    VehicleUtils.SetVisualRadio(vehicle, part)
end

function Vehicles.Create.FR_VisualRadio_HAM(vehicle, part)
    local deviceData = part:createSignalDevice()
    local invItem = VehicleUtils.createPartInventoryItem_FRHAMRadio(part)
    if deviceData and invItem then -- safety in case mods interfere with this function
        deviceData:setDeviceName(invItem:getDeviceData():getDeviceName())
        deviceData:setIsTwoWay(invItem:getDeviceData():getIsTwoWay())
        deviceData:setTransmitRange(invItem:getDeviceData():getTransmitRange())
        deviceData:setMicRange(invItem:getDeviceData():getMicRange())
        deviceData:setBaseVolumeRange(invItem:getDeviceData():getBaseVolumeRange())
        deviceData:setIsPortable(false)
        deviceData:setIsTelevision(invItem:getDeviceData():getIsTelevision())
        deviceData:setMinChannelRange(invItem:getDeviceData():getMinChannelRange())
        deviceData:setMaxChannelRange(invItem:getDeviceData():getMaxChannelRange())
        deviceData:setIsBatteryPowered(false)
        deviceData:setIsHighTier(invItem:getDeviceData():getIsHighTier())
        deviceData:setUseDelta(invItem:getDeviceData():getUseDelta())
        deviceData:setMediaType(invItem:getDeviceData():getMediaType())
        deviceData:generatePresets()
        deviceData:setRandomChannel()
    end
    -- My code
    VehicleUtils.SetVisualRadio(vehicle, part)
end

function Vehicles.Create.FR_VisualTire(vehicle, part)
    if VehicleUtils.FR_ReturnSpawn(vehicle, part) then
        return
    end
    -- DebugLog.log ("Create.FR_VisualTire: Passed check. Spawning " .. tostring(part:getId()))
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    local partID = tostring(part:getId())
    if partID:match("Spare") then
        VehicleUtils.FR_SetVisualDefault(vehicle, part)
    else
        VehicleUtils.FR_SetVisualTire(vehicle, part)
    end

    local keyvalues = part:getTable("FRPartInfo")
    local capacityMulti = keyvalues and keyvalues.capacityMulti or 1
    local capacityYearMulti = keyvalues and keyvalues.capacityYearMulti
    if capacityYearMulti then
        -- DebugLog.log ("Create.FR_VisualDefault: capacityYearMulti is " .. tostring(capacityYearMulti))
        local year = VehicleUtils.FR_GetYear(vehicle)
        capacityMulti = year * capacityYearMulti / 100
    end
    -- DebugLog.log ("Create.FR_VisualTire: capacityMulti is: " .. tostring(capacityMulti))
    local capacity
    if vehicle:isGoodCar() then
        capacity = ZombRand(part:getContainerCapacity() / 1.5, part:getContainerCapacity())
    else
        capacity = ZombRand((part:getContainerCapacity() - (part:getContainerCapacity() / 3)),
            part:getContainerCapacity())
    end
    -- DebugLog.log ("Create.FR_VisualTire: capacity was " .. tostring(capacity))
    capacity = capacity * capacityMulti
    if capacity > part:getContainerCapacity() then
        capacity = part:getContainerCapacity()
    end
    -- DebugLog.log ("Create.FR_VisualTire: " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()) .. " is spawning. capacity is " .. tostring(capacity))
    part:setContainerContentAmount(capacity, false, true)
end

function Vehicles.Create.FR_VisualDualTire(vehicle, part)
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    if vehicle:isGoodCar() then
        part:setContainerContentAmount(ZombRand(part:getContainerCapacity() / 1.5, part:getContainerCapacity()), false,
            true);
        return;
    end
    local capacity = ZombRand((part:getContainerCapacity() - (part:getContainerCapacity() / 3)),
        part:getContainerCapacity());
    part:setContainerContentAmount(capacity, false, true);
    -- DebugLog.log ("Running VehicleUtils.FR_VisualOuterTire for " .. tostring(part:getId()))
    VehicleUtils.FR_VisualOuterTire(vehicle, part)
end

function Vehicles.Create.FR_FillerTrunk(vehicle, part)
    local invItem = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part);
    -- Run removable truck beds function here first.
    -- DebugLog.log ("Hiding all models for " .. tostring(part:getId()))
    part:setAllModelsVisible(false)
    VehicleUtils.FillTrunk(vehicle, part, false)
    part:setModelVisible("TrunkFillerEmpty", true)
end

function Vehicles.Create.FR_VisualRemovableBed(vehicle, part)
    local keyvalues = part:getTable("FRPartInfo")
    local partChance = (keyvalues and tonumber(keyvalues.partChance)) or 100
    if ZombRand(1, 100) > partChance then
        return
    end
    local item = VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
    VehicleUtils.FillTrunk(vehicle, part, false)
    part:setModelVisible("TrunkFillerEmpty", true)
end

-- Init: These run when you enter an area and, I think, when the vehicle is created.

function Vehicles.Init.FR_VisualBedAttachment(vehicle, part)
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
    local trunkPart = vehicle:getPartById("TruckBed")
    local trunkItem = trunkPart:getInventoryItem()
    local bedAttItem = part:getInventoryItem()
    if not trunkItem then
        -- DebugLog.log ("InstallComplete.FR_VisualBedAttachment: No trunk item, ending function.")
        return
    end

    local trunkDefaultMaxCap = VehicleUtils.FR_GetDeafultMaxCapacity(vehicle, trunkPart)
    local maxCapMulti = 0
    if bedAttItem and bedAttItem:getType() == "Tarp" then
        maxCapMulti = 3
    elseif bedAttItem then
        maxCapMulti = VehicleUtils.FR_GetDeafultMaxCapacity(vehicle, part)
    end

    local trunkMaxCap = trunkDefaultMaxCap + (trunkDefaultMaxCap * (maxCapMulti / 100))
    trunkItem:setMaxCapacity(trunkMaxCap)

    -- Cap after damage formula
    local conAdjustedCap = (trunkMaxCap * 0.2) + ((trunkMaxCap * 0.8) * trunkPart:getCondition() / 100)
    trunkPart:setContainerCapacity(conAdjustedCap)
    -- DebugLog.log ("InstallComplete.FR_VisualBedAttachment: trunkItem:        " .. tostring(trunkItem:getType()) .. ". maxCapacity: " .. tostring(trunkItem:getMaxCapacity()) .. ". getContainerCapacity: " .. tostring(trunkPart:getContainerCapacity()) .. ". getItemCapacity is: " .. tostring(trunkItem:getItemCapacity()))

end

function Vehicles.Init.FR_VisualDefault(vehicle, part)
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
end

function Vehicles.Init.FR_Fridge(vehicle, part, player)
    -- Will probably need to redo this, too.
    if part:getModData().FR_FridgeActive then
        part:getItemContainer():setCustomTemperature(0.2)
    else
        part:getItemContainer():setCustomTemperature(1)
    end
end

function Vehicles.Init.FR_Oven(vehicle, part, player)
    -- Will probably need to redo this, too.
    if part:getModData().FR_OvenActive then
        part:getItemContainer():setCustomTemperature(2)
    else
        part:getItemContainer():setCustomTemperature(1)
    end
end

-- Vehicle parts!
function Vehicles.Init.FR_PopUpLights(vehicle, part)
    -- DebugLog.log ("POPUP LIGHTS INITIATING!")
    local part = vehicle:getPartById("FRPopUpLightsDoor")
    local opened = part:getDoor():isOpen()
    local active = vehicle:getHeadlightsOn()

    if not active and opened then
        part:getDoor():setOpen(false)
        -- DebugLog.log ("INITIATED: POPUP LIGHTS ARE CLOSED!")

    elseif active and not opened then
        part:getDoor():setOpen(true)
        -- DebugLog.log ("INITIATED: POPUP LIGHTS ARE OPEN!")
    end
    -- DebugLog.log ("POPUP LIGHTS INITIATED!")
end

function Vehicles.Init.FR_VisualRadio(vehicle, part)
    VehicleUtils.SetVisualRadio(vehicle, part)
end

function Vehicles.Init.FR_VisualTire(vehicle, part)
    local wheelIndex = part:getWheelIndex()
    vehicle:setTireRemoved(wheelIndex, part:getInventoryItem() == nil)
    local partID = tostring(part:getId())
    if partID:match("Spare") then
        VehicleUtils.FR_SetVisualDefault(vehicle, part)
    else
        VehicleUtils.FR_SetVisualTire(vehicle, part)
    end
end

function Vehicles.Init.FR_VisualDualTire(vehicle, part)
    VehicleUtils.FR_VisualOuterTire(vehicle, part)
end

function Vehicles.Init.FR_VisualHubcap(vehicle, part)
    VehicleUtils.FR_SetVisualTire(vehicle, part)
end

function Vehicles.Init.FR_FillerTrunk(vehicle, part)
    VehicleUtils.FillTrunk(vehicle, part, false)
end

function Vehicles.Init.FR_VisualRemovableBed(vehicle, part)
    VehicleUtils.FR_SetVisualDefault(vehicle, part)
    VehicleUtils.FillTrunk(vehicle, part, false)
end

-- Update: This function runs every few minutes, best I can tell.

function Vehicles.Update.FR_FrontBumper(vehicle, part, elapsedMinutes)
    -- DebugLog.log ("RUNNING UPDATE.FR_FRONTBUMPER for " .. tostring(vehicle:getScriptName()) .. " - " .. tostring(vehicle:getId()))

    local bumperPart = vehicle:getPartById("FRBumperFront")
    local bumperCon
    local invBumperPart
    if bumperPart then
        bumperCon = bumperPart:getCondition()
        invBumperPart = bumperPart:getInventoryItem()
    end

    local bumperBarPart = vehicle:getPartById("FRBumperBar")
    local bumperBarCon
    local invBumperBarPart
    if bumperBarPart then
        bumperBarCon = bumperBarPart:getCondition()
        invBumperBarPart = bumperBarPart:getInventoryItem()
    end

    local hoodPart = vehicle:getPartById("EngineDoor")
    local enginePart = vehicle:getPartById("Engine")

    -- If there's a hood installed, partB will be the hood. If not, partB will be the engine.
    local partB
    if hoodPart:getInventoryItem() and hoodPart:getCondition() > 0 then
        partB = vehicle:getPartById("EngineDoor")
    elseif enginePart then
        partB = vehicle:getPartById("Engine")
    else
        -- DebugLog.log ("UPDATE.FR_FRONTBUMPER: partB is " .. tostring(partB:getId()))
        return
    end

    -- DebugLog.log ("UPDATE.FR_FRONTBUMPER: partB is " .. tostring(partB:getId()))

    local newPartCon = partB:getCondition()
    local invPart = partB:getInventoryItem() or partB
    -- DebugLog.log ("UPDATE.FR_FRONTBUMPER: invPart is " .. tostring(invPart))
    -- DebugLog.log ("UPDATE.FR_FRONTBUMPER: new" .. tostring(partB:getId()) .. "Con is " .. tostring(newPartCon))

    -- If there's no data in fr_condtion, this sets it to the current partB condition
    if not invPart:getModData().fr_condition then
        invPart:getModData().fr_condition = math.floor(newPartCon)
        -- DebugLog.log ("UPDATE.FR_FRONTBUMPER: Set partB modData to newPartCon")
    end
    -- This is the condition on the last update

    local oldPartCon = invPart:getModData().fr_condition
    -- DebugLog.log ("UPDATE.FR_FRONTBUMPER: old" .. tostring(partB:getId()) .. "Con is " .. tostring(oldPartCon))

    local damage = oldPartCon - newPartCon
    -- DebugLog.log ("UPDATE.FR_FRONTBUMPER damage is " .. tostring(damage))

    local partPercent
    local speed

    if partCanFall == true and part:getInventoryItem() then
        partPercent = VehicleUtils.FR_GetConPercent(part) or 0
        speed = vehicle:getCurrentSpeedKmHour()
        if (partPercent and partPercent < 1) or (speed > 0 and (partPercent and partPercent <= 20)) then
            local fallChance = 100
            if speed and speed > 0 then
                fallChance = (50 - partPercent) + (speed / 10)
            end
            -- DebugLog.log("Vehicles.Update.FR_FrontBumper: Fall chance is " .. tostring(fallChance) .. " and speed is " .. tostring(speed))
            if fallChance > ZombRand(100) then
                -- DebugLog.log("Vehicles.Update.FR_FrontBumper: Uh oh! " .. tostring(part) .. " fell off!!!")
                vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
                VehicleUtils.FR_RemovePart(part, "VehicleCrash1")
            end
        end
    end

    if damage <= 0 then
        invPart:getModData().fr_condition = partB:getCondition()
        -- DebugLog.log ("Damage is " .. tostring(damage) .. ", ending function.")
        return
    end

    local multiplier = (ZombRand(20) / 100) + 0.9
    damage = damage * multiplier
    -- DebugLog.log ("UPDATE.FR_FRONTBUMPER random damage is " .. tostring(damage))

    if damage > 0 and
        ((bumperPart and invBumperPart and bumperCon > 0) or (bumperBarPart and invBumperBarPart and bumperBarCon > 0)) then

        if bumperBarPart and invBumperBarPart then
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER bumperBarCon is:     " .. tostring(bumperBarCon) .. ". Applying " ..tostring(damage) .. " damage to " .. tostring(bumperBarPart:getId()))
            bumperBarCon = bumperBarCon - damage
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER bumperBarCon is now: " .. tostring(bumperBarCon))
            bumperBarPart:setCondition(bumperBarCon)
            vehicle:transmitPartCondition(bumperBarPart)
            damage = damage * 0.50
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER reducing damage to " .. tostring(damage))
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER " .. tostring(bumperBarPart:getId()) .. " condition is " .. tostring(bumperBarPart:getCondition()))
        end
        if bumperPart and invBumperPart then
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER bumperCon is:     " .. tostring(bumperCon) .. ". Applying " ..tostring(damage) .. " damage to " .. tostring(bumperPart:getId()))
            bumperCon = bumperCon - damage
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER bumperCon is now: " .. tostring(bumperCon))
            bumperPart:setCondition(bumperCon)
            vehicle:transmitPartCondition(bumperPart)
            -- DebugLog.log ("UPDATE.FR_FRONTBUMPER " .. tostring(bumperPart:getId()) .. " condition is " .. tostring(bumperPart:getCondition()))
        end
    elseif damage > 0 and (not invBumperPart or bumperCon < 1) then
        -- DebugLog.log ("UPDATE.FR_FRONTBUMPER Applying " ..tostring(damage) .. " more damage to " .. tostring(partB:getId()))
        newPartCon = newPartCon - damage
        -- DebugLog.log ("UPDATE.FR_FRONTBUMPER newPartCon is " .. tostring(newPartCon))
        partB:setCondition(newPartCon)
        vehicle:transmitPartCondition(partB)
        -- DebugLog.log ("UPDATE.FR_FRONTBUMPER " .. tostring(partB:getId()) .. " condition is " .. tostring(partB:getCondition()))
    end
    invPart:getModData().fr_condition = partB:getCondition()

    -- DebugLog.log("Vehicles.Update.FR_FrontBumper: partPercent is " .. tostring(partPercent) .. " and speed is " .. tostring(speed))
    if partCanFall == true and part:getInventoryItem() and partPercent <= 40 then
        local fallChance = 100 - (partPercent * 1.875)
        -- DebugLog.log("Vehicles.Update.FR_FrontBumper: " .. tostring(part:getId()) .. " took damage. Fall chance is " .. tostring(fallChance))
        if fallChance > ZombRand(100) then
            -- DebugLog.log("Vehicles.Update.FR_FrontBumper: Uh oh! " .. tostring(part) .. " fell off!!!")
            vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
            VehicleUtils.FR_RemovePart(part, "VehicleCrash1")
        end
    end
end

-- As above, so below.
function Vehicles.Update.FR_RearBumper(vehicle, part, elapsedMinutes)
    -- DebugLog.log ("RUNNING UPDATE.FR_REARBUMPER for " .. tostring(vehicle:getScriptName()) .. " - " .. tostring(vehicle:getId()))
    local partPercent
    local speed

    if partCanFall == true and part:getInventoryItem() then
        partPercent = VehicleUtils.FR_GetConPercent(part) or 0
        speed = vehicle:getCurrentSpeedKmHour()
        if (partPercent and partPercent < 1) or (speed > 0 and (partPercent and partPercent <= 20)) then
            local fallChance = 100
            if speed and speed > 0 then
                fallChance = (50 - partPercent) + (speed / 10)
            end
            -- DebugLog.log("Vehicles.Update.FR_RearBumper: Fall chance is " .. tostring(fallChance) .. " and speed is " .. tostring(speed))
            if fallChance > ZombRand(100) then
                -- DebugLog.log("Vehicles.Update.FR_RearBumper: Uh oh! " .. tostring(part) .. " fell off!!!")
                vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
                VehicleUtils.FR_RemovePart(part, "VehicleCrash1")
            end
        end
    end
end

function Vehicles.Update.FR_Muffler(vehicle, part, elapsedMinutes)
    Vehicles.LowerCondition(vehicle, part, elapsedMinutes);
    if partCanFall == true and part:getInventoryItem() then
        local partCon = part:getCondition()
        local speed = vehicle:getCurrentSpeedKmHour() or 0
        if partCon == 0 or (speed > 0 and partCon <= 15 and ((100 - ((partCon) * 5.0)) > ZombRand(100))) then
            -- DebugLog.log("Vehicles.Update.FR_Muffler: Uh oh! " .. tostring(part) .. " fell off!!!")
            vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
            VehicleUtils.FR_RemovePart(part, "VehicleCrash")
        end
    end
end

function Vehicles.Update.FR_Fridge(vehicle, part, elapsedMinutes)
    -- DebugLog.log ("UPDATE FR_FRIDGE: Running update")
    if part:getModData().FR_FridgeActive then
        local batteryChange = -0.001;
        local id = vehicle:getId()
        -- DebugLog.log ("UPDATE FR_FRIDGE: The fridge in vehicle with ID " .. tostring(id) .. " is: " .. part:getItemContainer():getTemprature())
        -- Check if the fridge is on. If it is, get the temp, then multiply elapsedminutes 
        -- by whatever whatever incriment to change the temp and add it to the original temp
        -- Then we'll need to store that temp or set it or whatever. If the temp is >1, set it to 1.
        -- If it's < .2, set it to .2
        -- Maybe get the battery charge too, and if the battery has been off for x amount of hours
        -- set the temp to 1
        if vehicle:getBatteryCharge() <= 0.0 then
            part:getModData().FR_FridgeActive = false
        else
            part:getItemContainer():setCustomTemperature(0.2)

            if not vehicle:isEngineRunning() and not vehicle:getSquare():haveElectricity() then
                VehicleUtils.chargeBattery(vehicle, batteryChange * elapsedMinutes)
            end
        end
    elseif part:getItemContainer():getTemprature() < 1 then
        part:getItemContainer():setCustomTemperature(1)
    end
    vehicle:transmitPartModData(part);
end

function Vehicles.Update.FR_Oven(vehicle, part, elapsedMinutes)
    -- DebugLog.log ("UPDATE FR_Oven: Running update")
    if part:getModData().FR_OvenActive then
        local batteryChange = -0.005;
        local id = vehicle:getId()
        -- DebugLog.log ("UPDATE FR_Oven: The Oven in vehicle with ID " .. tostring(id) .. " is: " .. part:getItemContainer():getTemprature())
        -- Check if the Oven is on. If it is, get the temp, then multiply elapsedminutes 
        -- by whatever whatever incriment to change the temp and add it to the original temp
        -- Then we'll need to store that temp or set it or whatever. If the temp is >1, set it to 1.
        -- If it's < .2, set it to .2
        -- Maybe get the battery charge too, and if the battery has been off for x amount of hours
        -- set the temp to 1
        if vehicle:getBatteryCharge() <= 0.0 then
            part:getModData().FR_OvenActive = false
        else
            part:getItemContainer():setCustomTemperature(2)

            if not vehicle:isEngineRunning() and not vehicle:getSquare():haveElectricity() then
                VehicleUtils.chargeBattery(vehicle, batteryChange * elapsedMinutes)
            end
        end
    elseif part:getItemContainer():getTemprature() > 1 then
        part:getItemContainer():setCustomTemperature(1)
    end
    vehicle:transmitPartModData(part);
end

-- Copied and modified the vanilla function to account for the added roofs
function Vehicles.Update.FR_PassengerCompartment(vehicle, part, elapsedMinutes)
    --	--DebugLog.log ("UPDATE.FR_PASSENGERCOMPARTMENT IS RUNNING")
    local pc = vehicle:getPartById("PassengerCompartment")
    local heater = vehicle:getHeater();
    if not pc or not heater then
        return
    end
    -- local partRoof = vehicle:getPartById("FRHardRoof") or vehicle:getPartById("FRCanvasRoof") or vehicle:getPartById("FRConRoof") or vehicle:getPartById("FRConHardRoof") or vehicle:getPartById("FRTTopRoof")
    local partRoof
    for i, v in ipairs(FR_roofTypes) do
        if vehicle:getPartById(v) then
            partRoof = vehicle:getPartById(v)
            break
        end
    end

    --	--DebugLog.log ("ROOF PART IS: " .. tostring(partRoof))
    local pcData = pc:getModData()
    if not pcData.windowtemperature then
        pcData.windowtemperature = 0.0;
    end
    if not pcData.temperature then
        pcData.temperature = 0.0;
    end

    local windowCount = 0
    local partWindshieldFrame = vehicle:getPartById("FRFrameWindshieldFolding")
    --		--DebugLog.log ("Window start count is " .. tostring(windowCount))

    for i, v in ipairs(FR_windowTable) do
        local window = vehicle:getPartById(v)
        -- DebugLog.log ("Looking for window " .. tostring(v) .. ", it is " .. tostring(window))
        if window and ((not window:getInventoryItem()) or (window:getWindow() and window:getWindow():isOpen()) or
            (window:getId() == "Windshield" and partWindshieldFrame and partWindshieldFrame:getDoor() and
                partWindshieldFrame:getDoor():isOpen())) then
            windowCount = windowCount + 1
            -- DebugLog.log ("Window part is " .. tostring(window:getInventoryItem()))
        end
    end

    --	--DebugLog.log ("Window count: windows open is " .. tostring(windowCount))

    if partRoof and (not partRoof:getInventoryItem() or
        (partRoof:getId() == "FRConRoof" and partRoof:getDoor() and partRoof:getDoor():isOpen())) then
        pcData.temperature = math.max(pcData.temperature - 1 * elapsedMinutes, -5);
        pcData.windowtemperature = math.max(pcData.windowtemperature - 1 * elapsedMinutes, 0);
        --		--DebugLog.log ("UPDATE.FR_PASSENGERCOMPARTMENT: The passenger compartment is open to the air")

    elseif windowCount > 0 then
        pcData.temperature = math.max(pcData.temperature - (0.1 * windowCount) * elapsedMinutes, -5);
        pcData.windowtemperature = math.max(pcData.windowtemperature - (0.1 * windowCount) * elapsedMinutes, 0);
        --		--DebugLog.log ("UPDATE.FR_PASSENGERCOMPARTMENT: The windows are open")
    else
        if not heater:getModData().active then
            pcData.windowtemperature = math.min(pcData.windowtemperature + 0.1 * elapsedMinutes, 5);
            --		--DebugLog.log ("UPDATE.FR_PASSENGERCOMPARTMENT: Heater active: " .. tostring(not heater:getModData().active))
        else
            pcData.windowtemperature = math.max(pcData.windowtemperature - 0.1 * elapsedMinutes, 0);
            --		--DebugLog.log ("UPDATE.FR_PASSENGERCOMPARTMENT: Heater active: " .. tostring(heater:getModData().active))
        end
    end
    --	--DebugLog.log ("UPDATE.FR_PASSENGERCOMPARTMENT WINDOWS: " .. tostring(windowCount) .. " windows are down. Temperature is " .. tostring(pcData.temperature) .. " and windowtemperature is ".. tostring(pcData.windowtemperature))
end

function Vehicles.Update.FR_PopUpLights(vehicle, part, elapsedMinutes)
    local part = vehicle:getPartById("FRPopUpLightsDoor")
    local opened = part:getDoor():isOpen()
    local active = vehicle:getHeadlightsOn()
    -- DebugLog.log ("POPUP LIGHTS UPDATING!")

    if not active and opened then
        vehicle:playPartAnim(part, "Closed")
        part:getDoor():setOpen(false)
        -- DebugLog.log ("UPDATE: POPUP LIGHTS ARE CLOSED!")

    elseif active and not opened then
        vehicle:playPartAnim(part, "Opened")
        part:getDoor():setOpen(true)
        -- DebugLog.log ("UPDATE: POPUP LIGHTS ARE OPEN!")
    end
    -- DebugLog.log ("POPUP LIGHTS UPDATED!")
end

-- Edited the vanilla one to tell the hubcaps to fall off when the tire does
-- lower the tire condition depending on your speed/current steering
-- also handle tire explosing because of condition/lack of air here
function Vehicles.Update.FR_Tire(vehicle, part, elapsedMinutes)
    -- DebugLog.log("Vehicles.Update.FR_Tire is running.")
    if vehicle:isEngineRunning() and vehicle:getCurrentSpeedKmHour() > 10 and part:getInventoryItem() then
        local chance = Vehicles.LowerCondition(vehicle, part, elapsedMinutes);

        -- randomly losing air
        if part:getContainerContentAmount() > 0 and ZombRandFloat(0, 100) < (chance / 2) then
            part:setContainerContentAmount(part:getContainerContentAmount() - 1, false, true);
        end

        -- chance of tire explosing
        -- because of it not containing enough air
        if part:getContainerContentAmount() < 5 then
            local contentMod = (part:getInventoryItem():getMaxCapacity() - part:getContainerContentAmount()) / 350;
            if part:getContainerContentAmount() == 0 or ZombRandFloat(0, 100) < contentMod then
                vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
                VehicleUtils.RemoveTire(part, false);
                local hubcap = VehicleUtils.FR_GetCapTire(vehicle, part)
                if childPartFalls == true and hubcap then
                    vehicle:getSquare():AddWorldInventoryItem(hubcap:getInventoryItem(), 0, 0, 0);
                    VehicleUtils.FR_RemovePart(hubcap, "hubcap_fall")
                end
            end
        end

        -- then because of condition
        if part:getCondition() < 15 then
            local condMod = (100 - part:getCondition()) / 350;
            if part:getCondition() == 0 or ZombRandFloat(0, 100) < condMod then
                VehicleUtils.RemoveTire(part, true);
                local hubcap = VehicleUtils.FR_GetCapTire(vehicle, part)
                -- DebugLog.log("Vehicles.Update.FR_Tire: hubcap is " .. tostring(hubcap))
                if childPartFalls == true and hubcap then
                    vehicle:getSquare():AddWorldInventoryItem(hubcap:getInventoryItem(), 0, 0, 0);
                    VehicleUtils.FR_RemovePart(hubcap, "hubcap_fall")
                end
            end
        end
    end
end

function Vehicles.Update.FR_VisualDualTire(vehicle, part, elapsedMinutes)
    local partID = tostring(part:getId())
    -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " UPDATING ")
    local outerTire
    local outerTireID
    local innerTire
    local innerTireID
    local innerTireInstalled = false
    local outerTireInstalled = false

    if partID:match("Outer") then
        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " " .. tostring(partID) .. " has Outer in it.")
        outerTire = part
        outerTireID = partID
        local before, matched, after = outerTireID:match('^(.*)(Outer)(.*)$')
        innerTireID = after
        innerTire = vehicle:getPartById(tostring(innerTireID))
    else
        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " " .. tostring(partID) .. " does not have Outer in it. Should be the inner tire.")
        innerTire = part
        innerTireID = tostring(part:getId())
        outerTireID = tostring("Outer" .. innerTireID)
        outerTire = vehicle:getPartById(outerTireID)
    end

    if innerTire and innerTire:getInventoryItem() then
        innerTireInstalled = true
    end
    if outerTire and outerTire:getInventoryItem() then
        outerTireInstalled = true
    end

    local capacityPercent = VehicleUtils.PercentFull(vehicle)
    -- In progress code
    if part == outerTire and not outerTireInstalled then
        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " Part is outerTire and it is not installed. Ending function")
        return
    end
    if part == innerTire and not innerTireInstalled then
        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " Part is innerTire and it is not installed. Ending function")
        return
    end

    if capacityPercent > 50 and ZombRand(100) < capacityPercent and vehicle:getCurrentSpeedKmHour() > 1 then
        if part == innerTire and outerTire and not outerTireInstalled then
            vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
            VehicleUtils.RemoveTire(part, false);
            -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " The load is at " .. tostring(capacityPercent) .. "%. " .. tostring(partID) .. " has failed.")
            VehicleUtils.FR_VisualOuterTire(vehicle, part)
            return
        elseif part == outerTire and
            not (innerTireInstalled and innerTire:getContainerContentAmount() > 0 and innerTire:getCondition() > 0) then
            vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
            VehicleUtils.RemoveFakeTire(part, false);
            -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " The load is at " .. tostring(capacityPercent) .. "%. " .. tostring(partID) .. " has failed.")
            VehicleUtils.FR_VisualOuterTire(vehicle, part)
            return
        end
    end

    if vehicle:isEngineRunning() and vehicle:getCurrentSpeedKmHour() > 10 and part:getInventoryItem() then
        local chance = Vehicles.LowerCondition(vehicle, part, elapsedMinutes);

        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " " .. tostring(partID) .. " over 10KmH and is there.")

        -- randomly losing air
        if part:getContainerContentAmount() > 0 and ZombRandFloat(0, 100) < (chance / 2) then
            part:setContainerContentAmount(part:getContainerContentAmount() - 1, false, true);
        end

        -- chance of tire explosing
        -- because of it not containing enough air
        local contentMod = (part:getInventoryItem():getMaxCapacity() - part:getContainerContentAmount()) / 350;
        if part:getContainerContentAmount() == 0 or ZombRandFloat(0, 100) < contentMod then
            if part == innerTire then
                -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " Part is innerTire")
                -- if it's the inner tire and there's no outer tire installed, it flies off.
                if not outerTire or (outerTire and not outerTireInstalled) then
                    -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " The inner tire should fall off.")
                    vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
                    VehicleUtils.RemoveTire(part, false);
                    VehicleUtils.FR_VisualOuterTire(vehicle, part)
                end
            elseif part == outerTire then
                -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " Part is outerTire")
                vehicle:getSquare():AddWorldInventoryItem(part:getInventoryItem(), 0, 0, 0);
                VehicleUtils.FR_VisualOuterTire(vehicle, part)
                -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " The outer tire should fall off.")
            end
        end

        -- then because of condition
        if part:getCondition() < 15 --[[and (part == outerTire or not outerTireInstalled)--]] then
            -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " Running ExlpodeCode.")
            local condMod = (100 - part:getCondition()) / 350;
            if part:getCondition() == 0 or ZombRandFloat(0, 100) < condMod then
                if part == innerTire then
                    -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " ExlpodeCode. Part is innerTire.")
                    local tirePart = part:getInventoryItem()
                    if not outerTire or (outerTire and not outerTireInstalled) then
                        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " ExplodeCode. No outerTire or outertire Installed, inner tire should explode.")
                        VehicleUtils.RemoveTire(part, true)
                    elseif outerTire and outerTireInstalled then
                        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " ExplodeCode. There's an outer tire, so it should make an explosion sound once.")
                        if not tirePart:getModData().FR_TireDestroyed then
                            part:getVehicle():playSound("VehicleTireExplode")
                        end
                        part:setContainerContentAmount(0)
                        tirePart:getModData().FR_TireDestroyed = true
                        -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring(partID) .. ", " .. tostring(tirePart) .. " is destroyed, setting moddata to destroyed.")
                    end
                elseif part == outerTire then
                    -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " ExplodeCode. Part is outerTire, should be exploding.")
                    VehicleUtils.RemoveFakeTire(part, true)
                end
                -- DebugLog.log ("Vehicles.Update.FR_VisualDualTire: " .. tostring (partID) .. " ExplodeCode: Running VehicleUtils.FR_VisualOuterTire to update the visuals.")
                VehicleUtils.FR_VisualOuterTire(vehicle, part)
            end
        end
    end
end

function Vehicles.Update.FR_VisualHubcap(vehicle, part)
    -- Use this function to have the hubcap fly off if the tire is low durability or something.
    -- DebugLog.log("Vehicles.Update.FR_VisualHubcap is running.")
    local hubcapPart = part
    local hubcapID = tostring(part:getId())
    local invHubcapPart = hubcapPart:getInventoryItem()
    local damage = 0
    local hubcapCon = hubcapPart:getCondition()
    local tirePart = VehicleUtils.FR_GetCapTire(vehicle, part)
    if not (invHubcapPart and tirePart) then
        return
    end
    local tireID = tire and tostring(tire:getId())
    local tireDamage = VehicleUtils.FR_GetConChange(tirePart)
    -- Just switched this to go with the change to FR_GetConChange
    if tireDamage < 0 then
        local randNum = ZombRandFloat(0.9, 1.1)
        damage = tireDamage * randNum
        -- DebugLog.log ("Vehicles.Update.FR_VisualHubcap: Tire has taken " .. tostring(tireDamage) .. " damage. Damage multiplier is " .. tostring(randNum) .. ". Hubcap should take " .. tostring(damage) .. " damage.")
        -- DebugLog.log("Vehicles.Update.FR_VisualHubcap: " .. tostring(hubcapID) .. " old con is " .. tostring(hubcapPart:getCondition()) .. ". tireDamage*randNum=damage: " .. tostring(tireDamage) .. "*" .. tostring(randNum) .. "=" .. tostring(damage))
        hubcapCon = hubcapCon + damage
        hubcapPart:setCondition(hubcapCon)
        -- DebugLog.log("Vehicles.Update.FR_VisualHubcap: " .. tostring(hubcapID) .. " new con is " .. tostring(hubcapPart:getCondition()))
    end
    local hubcapPercent = VehicleUtils.FR_GetConPercent(part) or 0
    local tirePercent = VehicleUtils.FR_GetConPercent(tirePart) or 0
    -- DebugLog.log("Vehicles.Update.FR_VisualHubcap: " .. tostring(hubcapID) .. " new con is " .. tostring(hubcapPart:getCondition()) .. " percent is " .. tostring(hubcapPercent) .. " and " .. tostring(tirePart:getId()) .. " percent is " .. tostring(tirePercent))
    local speed = vehicle:getCurrentSpeedKmHour()
    if partCanFall == true and speed > 0 and
        ((hubcapPercent and hubcapPercent < 40) or (tirePercent and tirePercent < 40)) then
        local fallChance = (100 - ((hubcapPercent * tirePercent) / 2)) + (speed / 10)
        -- DebugLog.log("Vehicles.Update.FR_VisualHubcap: Fall chance is " .. tostring(fallChance) .. " and speed is " .. tostring(speed))
        if fallChance > ZombRand(100) then
            -- DebugLog.log("Vehicles.Update.FR_VisualHubcap: Uh oh! " .. tostring(hubcapPart) .. " fell off!!!")
            vehicle:getSquare():AddWorldInventoryItem(hubcapPart:getInventoryItem(), 0, 0, 0);
            VehicleUtils.FR_RemovePart(hubcapPart, "hubcap_fall")
            tirePart:setModelVisible(tostring(invHubcapPart:getType()), false)
            -- VehicleUtils.FR_SetVisualTire(vehicle, part)
        end
    end

    -- Can't use this on update functions, it loads the model in before the scale for a split second.
    -- VehicleUtils.FR_SetVisualTire(vehicle, part)
end

function Vehicles.Update.FR_FillerTrunk(vehicle, part, elapsedMinutes)
    -- VehicleUtils.FillTrunk(vehicle, part, true)

    local trunkPart = vehicle:getPartById("TruckBed")
    local trunkDoorPart = vehicle:getPartById("TrunkDoor")

    -- If there's no trunk or truck door installed, the function ends
    if not ((trunkPart and trunkPart:getInventoryItem()) or (trunkDoorPart and trunkDoorPart:getInventoryItem())) then
        -- DebugLog.log ("No trunk or trunk door installed, ending function")
        return
    end

    local trunkDamage = 0
    local trunkDoorDamage = 0
    local newTrunkCon = 0
    local newTrunkDoorCon = 0
    if trunkPart then
        local trunkConChange = VehicleUtils.FR_GetConChange(trunkPart)
        if trunkConChange < 0 then
            trunkDamage = math.abs(trunkConChange)
        end
        newTrunkCon = trunkPart:getCondition()
    end
    if trunkDoorPart then
        local trunkDoorConChange = VehicleUtils.FR_GetConChange(trunkDoorPart)
        if trunkDoorConChange < 0 then
            trunkDoorDamage = math.abs(trunkDoorConChange)
        end
        newTrunkDoorCon = 0 and trunkDoorPart:getCondition()
    end
    local damage = trunkDamage + trunkDoorDamage

    --[[
	local trunkConChange = VehicleUtils.FR_GetConChange(trunkPart)
	local trunkDoorConChange = VehicleUtils.FR_GetConChange(trunkDoorPart)
	local trunkDamage = 0
	local trunkDoorDamage = 0
	if trunkConChange < 0 then
		trunkDamage = math.abs(trunkConChange)
	end
	if trunkDoorConChange < 0 then
		trunkDoorDamage = math.abs(trunkDoorConChange)
	end
	local damage = trunkDamage + trunkDoorDamage
	local newTrunkCon = 0 and trunkPart:getCondition()
	local newTrunkDoorCon = 0 and trunkDoorPart:getCondition()
	]] --

    -- This sets the damage for other parts that don't take damage by default
    if damage > 0 then
        local bumperPart = vehicle:getPartById("FRBumperRear")
        local bedAttachmentPart = vehicle:getPartById("FRAttachmentBed")
        local oldTrunkCon = 0 and trunkPart:getCondition()
        local oldTrunkDoorCon = 0 and trunkDoorPart:getCondition()

        -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: oldTrunkCon is " .. tostring(oldTrunkCon))
        -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: oldTrunkDoorCon is " .. tostring(oldTrunkDoorCon))

        if bumperPart and bumperPart:getInventoryItem() and bumperPart:getCondition() > 0 then
            local bumperCon = bumperPart:getCondition()
            local damageMulti = ZombRand(8, 12) / 10
            -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: damageMulti: " .. tostring(damageMulti))
            if trunkPart and trunkDoorPart then
                -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: bumperCon: " .. tostring(bumperCon - ((damage/2)*damageMulti)) .. " = "  .. tostring(bumperCon) .. " - " .. tostring(damage/2) .. " * " .. tostring(damageMulti))
                bumperCon = bumperCon - ((damage / 2) * damageMulti)
            elseif trunkPart or trunkDoorPart then
                -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: bumperCon: " .. tostring(bumperCon - ((damage)*damageMulti)) .. " = "  .. tostring(bumperCon) " - " .. tostring(damage) .. " * " .. tostring(damageMulti))
                bumperCon = bumperCon - ((damage) * damageMulti)
            end
            bumperPart:setCondition(bumperCon)
            vehicle:transmitPartCondition(bumperPart)
        elseif bumperPart and (not bumperPart:getInventoryItem() or bumperPart:getCondition() < 1) then
            -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: Bumper is damaged or missing, will apply " .. tostring(trunkDamage) .. " more trunkDamage and " .. tostring(trunkDoorDamage) .. " more trunkDoorDamage.")
            newTrunkCon = oldTrunkCon - trunkDamage
            newTrunkDoorCon = oldTrunkDoorCon - trunkDoorDamage
        end

        if bedAttachmentPart and bedAttachmentPart:getInventoryItem() and bedAttachmentPart:getCondition() > 0 and
            trunkPart and trunkDamage > 0 then
            local bedAttachmentCon = bedAttachmentPart:getCondition()
            local damageMulti = ZombRand(10, 14) / 10
            -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: bedAttachmentCon: " .. tostring(bedAttachmentCon - ((damage)*damageMulti)) .. " = "  .. tostring(bedAttachmentCon) .. " - " .. tostring(damage) .. " * " .. tostring(damageMulti))
            bedAttachmentCon = bedAttachmentCon - (trunkDamage * damageMulti)
            bedAttachmentPart:setCondition(bedAttachmentCon)
            vehicle:transmitPartCondition(bedAttachmentPart)
            local bedAttachmentItem = bedAttachmentPart:getInventoryItem()
            -- Add health back to the trunk
            -- Can use getConditionMax to store the protection values. Need to come up with a good formula for it.
            -- 100 is no protection. 200 is total protection. Less than 100 applies more damage.
            local protection = 100
            if bedAttachmentItem and not bedAttachmentItem:getType() == "Tarp" then
                protection = bedAttachmentItem:getConditionMax()
            end

            -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: Protection of " .. tostring(bedAttachmentItem) .. " is " .. tostring(protection) .. ", and it should be " .. tostring(bedAttachmentItem:getConditionMax()))
            if protection ~= 100 then
                -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: Adding protection back: " .. tostring(newTrunkCon + ((oldTrunkCon - newTrunkCon + trunkDamage)*((protection-100)/100))) .. " = " .. tostring(newTrunkCon) .. " +  ((" .. tostring(oldTrunkCon) .. " - " .. tostring(newTrunkCon) .. " + " .. tostring(trunkDamage) .. ")*((" .. tostring(protection) .. "-100)/100))")
                newTrunkCon = newTrunkCon + ((oldTrunkCon - newTrunkCon + trunkDamage) * ((protection - 100) / 100))
                -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk: Applying protection of " .. tostring(bedAttachmentItem) .. " is " .. tostring(protection) .. ". Adding back " .. tostring(((oldTrunkCon - newTrunkCon + trunkDamage)*((protection-100)/100))) .. " condition. newTrunkCon is " .. tostring(newTrunkCon))
            end
        end
    end

    if trunkPart and trunkPart:getInventoryItem() then
        local invTrunkPart = trunkPart:getInventoryItem()
        -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk Setting trunkPart to newTrunkCon: " ..tostring(newTrunkCon))
        trunkPart:setCondition(math.floor(newTrunkCon))
        vehicle:transmitPartCondition(trunkPart)
        invTrunkPart:getModData().fr_condition = math.floor(newTrunkCon)
        -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk Trunk condition is now: " .. tostring(trunkPart:getCondition()))
    end

    if trunkDoorPart and trunkDoorPart:getInventoryItem() then
        local invTrunkDoorPart = trunkDoorPart:getInventoryItem()
        -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk Setting trunkDoorPart to newTrunkDoorCon: " ..tostring(newTrunkDoorCon))
        trunkDoorPart:setCondition(math.floor(newTrunkDoorCon))
        vehicle:transmitPartCondition(trunkDoorPart)
        invTrunkDoorPart:getModData().fr_condition = math.floor(newTrunkDoorCon)
        -- DebugLog.log ("Vehicles.Update.FR_FillerTrunk TrunkDoor condition is now: " .. tostring(trunkDoorPart:getCondition()))
    end
end

-- Other functions

function VehicleUtils.FR_GetConChange(part)
    -- DebugLog.log("VehicleUtils.FR_GetConChange running!")
    local part = part
    local newPartCon = 0
    local invPart
    local oldPartCon = 0
    local partConChange = 0
    if part and part:getInventoryItem() then
        newPartCon = part:getCondition()
        invPart = part:getInventoryItem()
        if not invPart:getModData().fr_condition then
            invPart:getModData().fr_condition = newPartCon
        end
        oldPartCon = invPart:getModData().fr_condition
        -- Just changed this so it the part loses condition, it'll return a negative number. This should be more straight forward.
        partConChange = newPartCon - oldPartCon
        invPart:getModData().fr_condition = newPartCon
    else
        partConChange = 0
    end
    -- DebugLog.log("VehicleUtils.FR_GetConChange: partConChange for " .. tostring(part:getId()) .. " is: " .. tostring(partConChange))
    return partConChange
end

function VehicleUtils.FR_GetConPercent(part)
    -- DebugLog.log("VehicleUtils.FR_GetConPercent running!")
    local invPart = part and part:getInventoryItem()
    if not invPart then
        return
    end
    local maxCon = invPart:getConditionMax()
    local partCon = part:getCondition()
    local conPercent = (partCon / maxCon) * 100
    -- DebugLog.log("VehicleUtils.FR_GetConPercent: Condition percent is " .. tostring(conPercent))
    return conPercent
end

function VehicleUtils.FR_GetYear(vehicle)
    local year = string.match(vehicle:getScript():getName(), "_%d%d$") or 80
    year = string.match(year, "%d%d")
    -- local yearChance = yearChance*1.2-40
    return year
end

function VehicleUtils.FR_GetMake(vehicle)
    local make = string.match(vehicle:getScript():getName(), "fr_%a%a_") or "fr_none_"
    -- DebugLog.log ("VehicleUtils.FR_GetMake: Vehicle make is " .. tostring(make))
    return make
end

function VehicleUtils.FR_GetCapTire(vehicle, part)

    local partID = tostring(part:getId())
    -- DebugLog.log ("VehicleUtils.FR_GetCapTire is running. partID is " .. tostring(partID) .. " and part is " .. tostring(part))
    local tire
    local tireID
    local hubcap
    local hubcapID

    if partID:match("Tire") then
        tire = part
        tireID = partID
        local before, matched, after = tireID:match('^(.*)(Tire)(.*)$')
        hubcapID = tostring("FRHubcap" .. after)
        hubcap = vehicle:getPartById(tostring(hubcapID))
        return hubcap
    elseif partID:match("FRHubcap") then
        hubcap = part
        hubcapID = partID
        local before, matched, after = hubcapID:match('^(.*)(FRHubcap)(.*)$')
        tireID = tostring("Tire" .. after)
        tire = vehicle:getPartById(tostring(tireID))
        return tire
    else
        -- DebugLog.log ("VehicleUtils.FR_GetCapTire: Neither part detected, ending function. Oops!")
        return nil
    end
end

function VehicleUtils.FR_RemovePart(part, sound)
    part:setInventoryItem(nil);
    part:getVehicle():transmitPartItem(part);
    -- DebugLog.log ("VehicleUtils.FR_RemovePart: dropping part " .. tostring(part:getId()) .. ", the sound is " .. tostring(sound))
    if sound then
        part:getVehicle():playSound(sound);
        -- DebugLog.log ("VehicleUtils.FR_RemovePart: Playing sound " .. tostring(sound))
    end
end

function VehicleUtils.FR_ReturnSpawn(vehicle, part)
    -- DebugLog.log ("FR_ReturnSpawn running.")
    local keyvalues = part:getTable("FRPartInfo")
    local partChance = (keyvalues and tonumber(keyvalues.partChance)) or 100
    -- DebugLog.log ("FR_ReturnSpawn is running. partChance is ".. tostring(partChance))
    local parentPart = keyvalues and keyvalues.parentPart and vehicle:getPartById(keyvalues.parentPart)
    local partChanceYearMulti = keyvalues and keyvalues.partChanceYearMulti
    local randNum = ZombRand(1, 100)
    -- This sets the part's chance to spawn by year and multiplier.
    -- In the script, add "partChanceYearMulti = 0.8," and change the multiplier to whatever.
    -- It'll max at 100% spawn chance
    if partChanceYearMulti then
        -- DebugLog.log ("FR_ReturnSpawn: partChanceYearMulti is " .. tostring(partChanceYearMulti))
        local year = VehicleUtils.FR_GetYear(vehicle)
        local yearChance = (year * partChanceYearMulti)
        if yearChance > 100 then
            partChance = 100
        else
            partChance = yearChance
        end
        -- DebugLog.log ("FR_ReturnSpawn: partChanceYearMulti is " .. tostring(partChanceYearMulti) .. ", partChance is now " .. tostring(partChance))
    end

    -- This checks if there's a part chance or a parent and ends the function if not.
    if not (partChance and randNum <= partChance and
        ((not parentPart or (parentPart and part == parentPart)) or (parentPart and parentPart:getInventoryItem()))) then
        -- DebugLog.log ("FR_ReturnSpawn:      " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()) .. ": Spawn check failed. Ending function.")
        return true
    end
    -- DebugLog.log ("FR_ReturnSpawn:      " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()) .. ": Spawn roll is " ..tostring(randNum) .. "/" .. tostring(partChance) .. ". The parent part is " .. tostring(parentPart))
end

function VehicleUtils.FR_CreatePartInventoryItem(vehicle, part)
    -- DebugLog.log ("FR_CreatePartInventoryItem running for " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()))
    if not part:getItemType() or part:getItemType():isEmpty() then
        return nil
    end
    local item;
    if not part:getInventoryItem() then
        local v = part:getVehicle();
        local keyvalues = part:getTable("FRPartInfo")
        local selectItemType
        local selectChance = (keyvalues and tonumber(keyvalues.selectChance)) or 100
        local partTable = {}
        local chosenKey = ""
        if selectGenericType then
            -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": selectGenericType is " .. tostring(selectGenericType))
        end
        -- This creates a custom table with the parts I want to spawn. It doesn't add selectItemType because that gets checked by itself later.
        -- It also uses the exclude chance and runs a check to not add excludeItemType to the list.
        -- If there are no excludeItemType or selectItemType, it skips to a shorter code segment.
        -- Added in some code to spawn items based on the make of the vehicle, selectMakeType and selectGenericType
        if keyvalues and
            (keyvalues.excludeItemType or keyvalues.selectItemType or keyvalues.selectGenericType or
                keyvalues.selectMakeType) then
            -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": A spawn item spawn limiter is being used, creating custom list.")
            local excludeItemType
            local excludeChance = (keyvalues and tonumber(keyvalues.excludeChance)) or 100
            local selectMakeType = (keyvalues and keyvalues.selectMakeType and
                                       string.lower(tostring(keyvalues.selectMakeType))) or "false"
            local selectMakeChance = (keyvalues and tonumber(keyvalues.selectMakeChance)) or 100
            local selectGenericType = (keyvalues and keyvalues.selectGenericType and
                                          string.lower(tostring(keyvalues.selectGenericType))) or "false"
            local selectGenericChance = (keyvalues and tonumber(keyvalues.selectGenericChance)) or 100
            local make = VehicleUtils.FR_GetMake(vehicle)

            for i = 1, part:getItemType():size() do
                chosenKey = chosenKey .. part:getItemType():get(i - 1) .. ';'
                if keyvalues.selectItemType and
                    string.match(string.lower(tostring(part:getItemType():get(i - 1))),
                        string.lower(tostring(keyvalues.selectItemType))) then
                    selectItemType = part:getItemType():get(i - 1)
                    -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": " .. tostring(selectItemType) .. " has a " .. tostring(selectChance) .. "% chance to spawn and has been excluded from the list.")
                elseif keyvalues.excludeItemType and
                    string.match(string.lower(tostring(part:getItemType():get(i - 1))),
                        string.lower(tostring(keyvalues.excludeItemType))) and excludeChance >= ZombRand(1, 100) then
                    excludeItemType = part:getItemType():get(i - 1)
                    -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": " .. tostring(excludeItemType) .. " has been excluded from the list.")
                elseif selectMakeType == "true" or selectGenericType == "true" then
                    if selectMakeType == "true" and
                        string.match(string.lower(tostring(part:getItemType():get(i - 1))), string.lower(tostring(make))) and
                        selectMakeChance >= ZombRand(1, 100) then
                        table.insert(partTable, part:getItemType():get(i - 1))
                        -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": Part matches vehicle make. " .. tostring(part:getItemType():get(i-1)) .. " has been added to the list (" .. tostring(i-1) .. ").")
                    elseif selectGenericType == "true" and
                        not string.match(string.lower(tostring(part:getItemType():get(i - 1))), "fr_%a%a_") and
                        selectGenericChance >= ZombRand(1, 100) then
                        table.insert(partTable, part:getItemType():get(i - 1))
                        -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": Part should have no make. " .. tostring(part:getItemType():get(i-1)) .. " has been added to the list (" .. tostring(i-1) .. ").")
                    end
                else
                    table.insert(partTable, part:getItemType():get(i - 1))
                    -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": Part make doesn't matter. " .. tostring(part:getItemType():get(i-1)) .. " has been added to the list (" .. tostring(i-1) .. ").")
                end
            end
        else
            -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": excludeItemType or selectItemType are not being used, using original list.")
            for i = 1, part:getItemType():size() do
                chosenKey = chosenKey .. part:getItemType():get(i - 1) .. ';'
                table.insert(partTable, part:getItemType():get(i - 1))
            end
        end

        -- This looks like it checks through the spawned parts and compares the created chosenKey above to
        -- see if any other parts of the same name have spawned. If they have, it sets them to the same.
        local itemType

        local skipGetChosenParts = keyvalues and keyvalues.skipGetChosenParts and
                                       string.lower(tostring(keyvalues.skipGetChosenParts))
        -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": skipGetChosenParts is " .. tostring(skipGetChosenParts))

        -- Unless selectItemType is used, then it overwrites it.
        if selectItemType and ZombRand(1, 100) <= selectChance then
            itemType = selectItemType
            -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": spawning selectItemType " .. tostring(itemType))
            v:getChoosenParts():put(chosenKey, itemType)
        elseif skipGetChosenParts ~= "true" then
            itemType = v:getChoosenParts():get(chosenKey)
            -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": skipGetChosenParts is " .. tostring(skipGetChosenParts) .. ", checking other parts for item type.")
        end

        -- If there's no item type from another part or a selectItemType, then it'll use the partTable as a list to choose a part from.
        if not itemType then
            local randNum = ZombRand(#partTable) + 1
            itemType = tostring(partTable[randNum] or part:getItemType():get(0))
            -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": itemType is " .. tostring(randNum) .. "/" .. tostring(#partTable) .. " " .. tostring(part:getItemType():get(0)))
            v:getChoosenParts():put(chosenKey, itemType)
        end

        -- DebugLog.log ("FR_CreatePartInventoryItem, " .. tostring(part:getId()) .. ": itemType has been selected. It is " .. tostring(itemType))

        item = instanceItem(itemType);

        -- DebugLog.log ("FR_CreatePartInventoryItem, item is " .. tostring(item))

        local conditionMultiply = 100 / item:getConditionMax();
        if part:getContainerCapacity() and part:getContainerCapacity() > 0 then
            item:setMaxCapacity(part:getContainerCapacity());
        end
        item:setConditionMax(item:getConditionMax() * conditionMultiply);
        item:setCondition(item:getCondition() * conditionMultiply);
        --[[
		--This is supposed to set the item's condtion. Come back to this later.
		local conditionYearMulti = keyvalues and keyvalues.conditionYearMulti
		if conditionYearMulti then
			--DebugLog.log ("FR_CreatePartInventoryItem: conditionYearMulti is " .. tostring(conditionYearMulti) .. ". conditionMultiply starts as " .. tostring(conditionMultiply))
			local year = VehicleUtils.FR_GetYear(vehicle)
			local yearChance = (year*conditionYearMulti)/100
			if yearChance >1 then
				conditionMultiply = 1
			else
				conditionMultiply = yearChance
			end
			--DebugLog.log ("FR_CreatePartInventoryItem: conditionMultiply is now " .. tostring(conditionMultiply))
			item:setCondition(item:getCondition()*conditionMultiply);
		end
		--]]
        part:setRandomCondition(item);
        part:setInventoryItem(item)
    end
    return part:getInventoryItem()
end

-- This can be changed so it doesn't do the script name check.
-- I can have it check for the part in my custom table.
function VehicleUtils.createPartInventoryItem_FRRadio(part)
    if not part:getItemType() or part:getItemType():isEmpty() then
        return nil
    end
    local item;
    if not part:getInventoryItem() then
        --[[local v = part:getVehicle();
		local chosenKey = ""
		for i=1,part:getItemType():size() do
			chosenKey = chosenKey .. part:getItemType():get(i-1) .. ';'
		end
		local itemType = v:getChoosenParts():get(chosenKey);
		if not itemType then
			for i=0, part:getItemType():size() - 1 do
				if ZombRand(100) > (100 - (100/part:getItemType():size())) or i == part:getItemType():size() - 1 then
					itemType = part:getItemType():get(i);				
					itemType = itemType:gsub("Base.RadioMakeShift", "Base.RadioBlack");
					itemType = itemType:gsub("Base.HamRadio1", "Base.RadioBlack");
					itemType = itemType:gsub("Base.HamRadio2", "Base.RadioBlack");
					itemType = itemType:gsub("Base.HamRadioMakeShift", "Base.RadioBlack");
					v:getChoosenParts():put(chosenKey, itemType);
					break;
				end
			end
		end
		local year = string.match(v:getScript():getName(), "_%d%d$")
		if year then
			year = tonumber(string.match(year,"%d%d"))
			--DebugLog.log (tostring(v:getScript():getName()) .. "'s year is " .. year)
			if v:getScript():getName():contains("Modern") or  v:getScript():getName():contains("Luxury") then				
				itemType = itemType:gsub("Base.RadioBlack", "Base.RadioRed");
				v:getChoosenParts():put(chosenKey, itemType);
			end
		end--]]
        local vehicle = part:getVehicle()
        local year = string.match(vehicle:getScript():getName(), "_%d%d$") or 80
        local itemType = "Base.RadioBlack"
        if year then
            year = tonumber(string.match(year, "%d%d"))
            local randNum = ZombRand(100)
            -- DebugLog.log (randNum .. " is greater than " .. year*1.2-40 .. " or 25")
            if randNum <= (year * 1.2 - 40) or randNum < 20 then
                itemType = "Base.RadioRed"
            else
                itemType = "Base.RadioBlack"
            end
        end

        item = instanceItem(itemType);
        -- DebugLog.log ("createPartInventoryItem_FRRadio: itemType is " .. itemType)
        local conditionMultiply = 100 / item:getConditionMax();
        if part:getContainerCapacity() and part:getContainerCapacity() > 0 then
            item:setMaxCapacity(part:getContainerCapacity());
        end
        item:setConditionMax(item:getConditionMax() * conditionMultiply);
        item:setCondition(item:getCondition() * conditionMultiply);
        part:setRandomCondition(item);
        part:setInventoryItem(item)
    end
    return part:getInventoryItem()
end

function VehicleUtils.createPartInventoryItem_FRHAMRadio(part)
    if not part:getItemType() or part:getItemType():isEmpty() then
        return nil
    end
    local item;
    if not part:getInventoryItem() then
        --[[local v = part:getVehicle();
		local chosenKey = ""
		for i=1,part:getItemType():size() do
			chosenKey = chosenKey .. part:getItemType():get(i-1) .. ';'
		end
		local itemType = v:getChoosenParts():get(chosenKey);
		if not itemType then
			for i=0, part:getItemType():size() - 1 do
				if ZombRand(100) > (100 - (100/part:getItemType():size())) or i == part:getItemType():size() - 1 then
					itemType = part:getItemType():get(i);
					itemType = itemType:gsub("Base.HamRadioMakeShift", "Base.HamRadio1");
					v:getChoosenParts():put(chosenKey, itemType);
					break;
				end
			end
		end
		if v:getScript():getName():contains("Police") then				
			itemType = itemType:gsub("Base.HamRadio1", "Base.HamRadio2");	
			v:getChoosenParts():put(chosenKey, itemType);
		else			
			itemType = itemType:gsub("Base.HamRadio2", "Base.HamRadio1");
			v:getChoosenParts():put(chosenKey, itemType);			
		end--]]
        local vehicle = part:getVehicle()
        local itemType = "Base.HamRadio1"
        -- DebugLog.log ("createPartInventoryItem_FRHAMRadio: Vehicles is " .. vehicle:getScriptName())
        if vehicle:getScriptName():contains("_mil") then
            -- DebugLog.log ("createPartInventoryItem_FRHAMRadio: Vehicles is military, spawning military ham.")
            itemType = "Base.HamRadio2"
        else
            -- DebugLog.log ("createPartInventoryItem_FRHAMRadio: Vehicles is NOT military, spawning ham.")
            itemType = "Base.HamRadio1"
        end
        item = instanceItem(itemType);
        -- DebugLog.log ("createPartInventoryItem_FRHAMRadio: itemType is " .. itemType)
        local conditionMultiply = 100 / item:getConditionMax();
        if part:getContainerCapacity() and part:getContainerCapacity() > 0 then
            item:setMaxCapacity(part:getContainerCapacity());
        end
        item:setConditionMax(item:getConditionMax() * conditionMultiply);
        item:setCondition(item:getCondition() * conditionMultiply);
        part:setRandomCondition(item);
        part:setInventoryItem(item)
    end
    return part:getInventoryItem()
end

function VehicleUtils.FR_SetVisualDefault(vehicle, part)
    local keyvalues = part:getTable("FRPartInfo")
    local childPart = keyvalues and keyvalues.childVisual

    if part:getInventoryItem() then
        local oneModel = keyvalues and keyvalues.oneModel and string.lower(tostring(keyvalues.oneModel))
        local partType = part:getInventoryItem():getType()
        local partName = string.match(partType, "%D+")
        local seeNumbers = keyvalues and keyvalues.seeNumbers and string.lower(tostring(keyvalues.seeNumbers))
        if seeNumbers and seeNumbers == "true" then
            partName = tostring(partType)
        end

        --[[
		if childPart then
			childPart = vehicle:getPartById(childPart)
			local childType = (childPart:getInventoryItem() and childPart:getInventoryItem():getType()) and string.match(childPart:getInventoryItem():getType(), "%D+") or ""
			local childName = childType
			--DebugLog.log ("FR_SetVisualDefault: childPart detected, childType is " .. tostring(childType) .. " and childName is " .. tostring(childName))
			childName = partName .. childName
			childPart:setAllModelsVisible(false)
			childPart:setModelVisible(tostring(childName), true)
		end
		--]]
        if childPart and vehicle:getPartById(childPart) then
            -- DebugLog.log ("FR_SetVisualDefault: ChildPart detected, childPart is " .. tostring(childPart))
            childPart = vehicle:getPartById(childPart)
            VehicleUtils.FR_SetVisualDefault(vehicle, childPart)
        end

        local shownByParent = keyvalues and keyvalues.shownByParent and string.lower(tostring(keyvalues.shownByParent))
        -- DebugLog.log ("FR_SetVisualDefault: oneModel is " .. tostring(oneModel))
        -- DebugLog.log ("FR_SetVisualDefault: shownByParent is " .. tostring(shownByParent))
        if oneModel and oneModel == "true" and not (shownByParent and shownByParent == "true") then -- and part NOT set to shownByParent
            -- DebugLog.log ("FR_SetVisualDefault: Ending function, oneModel is " .. tostring(keyvalues.oneModel))
            -- DebugLog.log ("FR_SetVisualDefault: " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()) .. ", " .. tostring(partType) .. ": oneModel is " .. tostring(oneModel) .. ", shownByParent is " .. tostring(shownByParent) .. " - ENDING FUCNTION")
            return
        end

        part:setAllModelsVisible(false)
        -- DebugLog.log ("FR_SetVisualDefault: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " models to hidden.")
        local v = part:getVehicle()
        local parentPart = keyvalues and keyvalues.parentVisual and vehicle:getPartById(keyvalues.parentVisual)
        -- DebugLog.log ("FR_SetVisualDefault: parentPart is " .. tostring(keyvalues and keyvalues.parentVisual).. " partType is " .. tostring(partType) .. " partName is " .. tostring(partName))

        if parentPart then
            local parentType = (parentPart:getInventoryItem() and parentPart:getInventoryItem():getType()) and
                                   string.match(parentPart:getInventoryItem():getType(), "%D+") -- or ""
            local parentName = parentType or ""
            local parentItemsVisual = keyvalues and keyvalues.parentItemsVisual and
                                          string.match(keyvalues.parentItemsVisual, "%D+")
            -- DebugLog.log ("FR_SetVisualDefault: parentPart detected, entering if statement. parentName is " .. tostring(parentName) .. ", parenItemsVisual is " .. tostring(parentItemsVisual))
            -- This will make any items not matching the parentItemsVisual list appear as the default item, like "TrunkDoor" instead of "FRBedBigTrunkDoor" for example.
            if parentItemsVisual and ((parentType and not string.match(parentItemsVisual, parentType) or
                (parentType and string.match(parentItemsVisual, parentType) and oneModel == "true" and shownByParent ==
                    "true"))) or not parentType then
                -- if parentName matches the parentItemsVisual list, it skips to check the part name and the model should be something like FRBedBigTrunkDoor
                -- if there is a match, but there's only one model and it's supposed to be shown by the parent, it'll be just TrunkDoor. Another part will set it to hide the models if onemodel and shownparent but no match.
                -- If parentname is nil, then it'll also set it to ""
                -- DebugLog.log("FR_SetVisualDefault: parentType is " .. tostring(parentType) .. ", parentItemsVisual match: " .. tostring(parentType and string.match(parentItemsVisual, parentType)) .. ", oneModel is " .. tostring(oneModel) .. ", shownByParent is " .. tostring(shownByParent))
                parentName = ""
                -- DebugLog.log("FR_SetVisualDefault: if parentItemsVisual " .. tostring(parentItemsVisual) .. " and match " .. tostring(parentType and string.match(parentItemsVisual, parentType)) .. " and oneModel " .. tostring(oneModel) .. " and shownByParent " .. tostring(shownByParent))
                if parentItemsVisual and
                    (not parentType or (parentType and not string.match(parentItemsVisual, parentType))) and oneModel ==
                    "true" and shownByParent == "true" then
                    -- if the parentName does not match with parentItemVisual and there's only one model, and it's shown by parent, the partname gets cleared out, too.
                    partName = ""
                    -- DebugLog.log("FR_SetVisualDefault: parentItemsVisual has not found a match. partName should be blank. " .. tostring(string.match(parentItemsVisual, parentName)))
                end
            end
            -- DebugLog.log ("FR_SetVisualDefault: parentPart detected, parentType is " .. tostring(parentType) .. " and parentName is " .. tostring(parentName))
            partName = parentName .. partName
        end

        part:setModelVisible(tostring(partName), true)
        -- DebugLog.log ("FR_SetVisualDefault: Completed. " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " model should be " .. tostring(partName))

        local offroadSpare = keyvalues and keyvalues.offroadSpare and string.lower(tostring(keyvalues.offroadSpare))
        if offroadSpare == "true" then
            local tarp = keyvalues and keyvalues.tarp and string.lower(tostring(keyvalues.tarp))
            local partBedAt = vehicle:getPartById("FRAttachmentBed")
            local partBedAt = partBedAt and partBedAt:getInventoryItem() and partBedAt:getInventoryItem():getType()
            if tarp == "true" and partBedAt == "Tarp" then
                part:setModelVisible("TireTarp", true)
            else
                part:setModelVisible("TireStrap", true)
            end
        end

        -- DebugLog.log ("FR_SetVisualDefault: " .. tostring(vehicle:getScriptName()) .. ", " .. tostring(part:getId()) .. ", " .. tostring(partType) .. ": parentName is: " .. tostring(parentName) .. ", model name is " .. tostring(partName))

    elseif childPart and vehicle:getPartById(childPart) then
        -- DebugLog.log ("FR_SetVisualDefault: Only childPart detected, childPart is " .. tostring(childPart))
        childPart = vehicle:getPartById(childPart)
        VehicleUtils.FR_SetVisualDefault(vehicle, childPart)
    end

    -- Origal childPart shit
    --[[
	elseif childPart and vehicle:getPartById(childPart) and vehicle:getPartById(childPart):getInventoryItem() then
		childPart = vehicle:getPartById(childPart)
		local childType = (childPart:getInventoryItem() and childPart:getInventoryItem():getType()) and string.match(childPart:getInventoryItem():getType(), "%D+") or ""
		local childName = childType
		--DebugLog.log ("FR_SetVisualDefault: Only childPart detected, childType is " .. tostring(childType) .. " and childName is " .. tostring(childName))
		childName = childName
		childPart:setAllModelsVisible(false)
		childPart:setModelVisible(tostring(childName), true)
	end
	--]]
end

function VehicleUtils.SetVisualRadio(vehicle, part)
    -- My code
    -- DebugLog.log ("Hiding all models for " .. tostring(part:getId()))
    part:setAllModelsVisible(false)
    -- DebugLog.log ("VehicleUtils.SetVisualRadio: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " models to hidden.")
    if part:getInventoryItem() then
        local partName = part:getInventoryItem():getType()
        -- DebugLog.log ("VehicleUtils.SetVisualRadio: Attempting to set " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(part:getId()) .. " model to " .. tostring(partName))
        part:setModelVisible(tostring(partName), true)
        -- This should print out the antenna, either Antenna, AntennaMake, HamAntenna or HamAntennaMake
        local ham = string.match(tostring(partName), "Ham")
        local makeshift = string.match(tostring(partName), "Make")
        local num = string.match(tostring(partName), "%d")
        if not makeshift then
            makeshift = ""
        end
        if not ham then
            ham = ""
        end
        if not num then
            num = ""
        end
        local antennaName = ham .. "Antenna" .. makeshift .. num
        part:setModelVisible(antennaName, true)
        -- DebugLog.log ("VehicleUtils.SetVisualRadio: Completed. " .. tostring(vehicle:getScriptName()) .. "'s radio model should be " .. tostring(partName) .. " and the antenna should be " .. tostring(antennaName))
    end
end

function VehicleUtils.RemoveFakeTire(part, explosion)
    part:setInventoryItem(nil);
    part:getVehicle():transmitPartItem(part);
    if explosion then
        part:getVehicle():playSound("VehicleTireExplode");
    end
end

function VehicleUtils.PercentFull(vehicle)
    local maxCapacity = 0
    local trunk = vehicle:getPartById("TruckBed")
    local fuelTank = vehicle:getPartById("FRFuelTank")
    local propaneTank = vehicle:getPartById("FRPropaneTank")
    local amount = 0
    local percent = 0

    if trunk then
        maxCapacity = (125 * trunk:getContainerCapacity()) / (trunk:getCondition() + 25)
        amount = amount + trunk:getItemContainer():getCapacityWeight()
    end
    if fuelTank then
        maxCapacity = maxCapacity + ((125 * fuelTank:getContainerCapacity()) / (fuelTank:getCondition() + 25))
        amount = amount + fuelTank:getContainerContentAmount()
    elseif propaneTank then
        maxCapacity = maxCapacity + ((125 * propaneTank:getContainerCapacity()) / (propaneTank:getCondition() + 25))
        amount = amount + propaneTank:getContainerContentAmount()
    end
    if maxCapacity > 0 then
        percent = (amount / maxCapacity) * 100
    end
    -- DebugLog.log ("VehicleUtils.PercentFull: The vehicle is " .. tostring(percent) .. "% full out of " .. tostring(maxCapacity))
    return percent
end

function VehicleUtils.FillTrunk(vehicle, part, skip)
    --[[	local oldAmount = part:getModData().FR_TrunkCapAmount
	if not oldAmount then
		oldAmount = 0
	end
	local amount = part:getItemContainer():getCapacityWeight()
		--DebugLog.log ("amount: " .. tostring(amount) .. ", Old Amount is " .. tostring(oldAmount))
	if amount == oldAmount then
		--DebugLog.log ("Amount hasn't changed, ending function.")
	return end--]]

    local oldAmountTier = part:getModData().FR_TrunkCapAmount
    if not oldAmountTier then
        oldAmountTier = 0
    end
    local amount = part:getItemContainer():getCapacityWeight()
    local amountTier = 0
    if amount > 0 then
        amountTier = math.floor(amount / 40) + 1
    end

    -- DebugLog.log ("amountTier: " .. tostring(amountTier) .. ", Old amountTier is " .. tostring(oldAmountTier))
    if amountTier == oldAmountTier and skip then
        -- DebugLog.log ("amountTier hasn't changed, ending function.")
        return
    end

    part:setModelVisible("TrunkFillerEmpty", false)
    local capacity = part:getContainerCapacity()
    -- DebugLog.log("VehicleUtils.FillTrunk: getCapacity is " .. tostring(part:getItemContainer():getCapacity()) .. " and my formula is " .. tostring((125 * capacity) / (part:getCondition() + 25)))
    local maxCapacity = (125 * capacity) / (part:getCondition() + 25)
    -- local maxCapacity = part:getItemContainer():getCapacity()
    -- DebugLog.log ("Trunk capacity is " .. tostring(amount) .. " out of " .. tostring(capacity) .. " with a max capacity of " .. tostring(maxCapacity))
    local capTier = math.floor(maxCapacity / 40) + 1
    -- local amountTier = math.floor(amount / 40 ) + 1
    if capTier >= 5 then
        capTier = 5
    elseif capTier <= 2 then
        capTier = 2
    end

    if amountTier >= capTier then
        amountTier = capTier
    end
    -- DebugLog.log("ammount is  " .. amount .. ", amountTier is " .. amountTier)

    -- DebugLog.log("capacity is " .. capacity .. ", capTier is    " .. capTier)
    for i = 1, amountTier do
        part:setModelVisible("TrunkFiller" .. i, true)
        -- DebugLog.log("Showing TrunkFiller" .. i)
    end
    for i = (amountTier + 1), capTier do
        part:setModelVisible("TrunkFiller" .. i, false)
        -- DebugLog.log ("Hiding TrunkFiller" .. i)
    end
    -- part:getModData().FR_TrunkCapAmount = amount
    part:getModData().FR_TrunkCapAmount = amountTier
    -- Added this to try to fix the damage resetting.
    vehicle:doDamageOverlay()
end

function VehicleUtils.FR_VisualOuterTire(vehicle, part)
    local partID = tostring(part:getId())
    -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire is running. partID is " .. tostring(partID) .. " and part is " .. tostring(part))
    local outerTire
    local outerTireID
    local innerTire
    local innerTireID
    local innerTireInstalled = false
    local outerTireInstalled = false
    local innerTireType
    local outerTireType
    local outerTireName
    local innerTireType
    local innerTireName
    -- NEED TO INCLUDE THIS
    -- local partID = string.match(partType, "%D+")
    if partID:match("Outer") then
        -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: " .. tostring(partID) .. " has Outer in it.")
        outerTire = part
        outerTireID = partID
        local before, matched, after = outerTireID:match('^(.*)(Outer)(.*)$')
        innerTireID = after
        innerTire = vehicle:getPartById(tostring(innerTireID))
    else
        -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: " .. tostring(partID) .. " does not have Outer in it. Should be the inner tire.")
        innerTire = part
        innerTireID = tostring(part:getId())
        outerTireID = tostring("Outer" .. innerTireID)
        outerTire = vehicle:getPartById(outerTireID)
    end
    -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: innerTire is " .. tostring(innerTire) .. ", innerTireID is " .. tostring(innerTireID))
    -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: outerTire is " .. tostring(outerTire) .. ", outerTireID is " .. tostring(outerTireID))

    if innerTire and innerTire:getInventoryItem() and innerTire:getInventoryItem():getType() then
        innerTireInstalled = true
        innerTireType = innerTire:getInventoryItem():getType()
        innerTireName = string.match(innerTireType, "%D+")
    end

    if outerTire and outerTire:getInventoryItem() and outerTire:getInventoryItem():getType() then
        outerTireInstalled = true
        outerTireType = outerTire:getInventoryItem():getType()
        outerTireName = tostring("Outer" .. string.match(outerTireType, "%D+"))
    end
    -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: innerTireInstalled: " .. tostring(innerTireInstalled))
    -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: outerTireInstalled: " .. tostring(outerTireInstalled))

    innerTire:setAllModelsVisible(false)

    if innerTireInstalled and outerTireInstalled then
        -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: attempting to set " .. tostring("Outer" .. innerTireName) .. " to visible.")
        innerTire:setModelVisible(tostring(outerTireName), true)
    elseif innerTireInstalled and not outerTireInstalled then
        -- DebugLog.log ("VehicleUtils.FR_VisualOuterTire: attempting to set " .. tostring(innerTireName) .. " to visible.")
        innerTire:setModelVisible(tostring(innerTireName), true)
    else
        return
    end
end

function VehicleUtils.FR_SetVisualTire(vehicle, part)
    local partID = tostring(part:getId())
    -- DebugLog.log ("VehicleUtils.FR_SetVisualTire is running. partID is " .. tostring(partID) .. " and part is " .. tostring(part))
    local tire
    local tireID
    local hubcap
    local hubcapID

    if partID:match("Tire") then
        tire = part
        hubcap = VehicleUtils.FR_GetCapTire(vehicle, part)
    elseif partID:match("FRHubcap") then
        hubcap = part
        tire = VehicleUtils.FR_GetCapTire(vehicle, part)
    else
        -- DebugLog.log ("VehicleUtils.FR_SetVisualTire: Neither part detected, ending function. Oops!")
        return
    end
    tireID = tire and tire:getId()
    hubcapID = hubcap and hubcap:getId()
    -- DebugLog.log ("VehicleUtils.FR_SetVisualTire: tireID is " .. tostring(tireID) .. " and hubcapID is " .. tostring(hubcapID))
    tire:setAllModelsVisible(false)

    if tire and tire:getInventoryItem() and tire:getInventoryItem():getType() then
        local tireType = tire:getInventoryItem():getType()
        local tireName = string.match(tireType, "%D+")
        -- DebugLog.log ("VehicleUtils.FR_SetVisualTire: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(partID) .. " model to " .. tostring(tireName))
        tire:setModelVisible(tostring(tireName), true)
        if hubcap and hubcap:getInventoryItem() and hubcap:getInventoryItem():getType() then
            local hubcapType = hubcap:getInventoryItem():getType()
            local hubcapName = tostring(hubcapType)
            -- DebugLog.log ("VehicleUtils.FR_SetVisualTire: Setting " .. tostring(vehicle:getScriptName()) .. "'s " .. tostring(hubcapID) .. " model to " .. tostring(hubcapName))
            tire:setModelVisible(tostring(hubcapName), true)
        end
    else
        return
    end
end

-- Backup
--[[
function VehicleUtils.FR_SetVisualTire(vehicle, part)
	local partID = tostring(part:getId())
	--DebugLog.log ("VehicleUtils.FR_SetVisualTire is running. partID is " .. tostring(partID) .. " and part is " .. tostring(part))
	local tire
	local tireID
	local hubcap
	local hubcapID

	if partID:match("Tire") then
		tire = part
		tireID = partID
		local before, matched, after = tireID:match('^(.*)(Tire)(.*)$')
		hubcapID = tostring("FRHubcap" .. after)
		hubcap = vehicle:getPartById(tostring(hubcapID))
	elseif partID:match("FRHubcap") then
		hubcap = part
		hubcapID = partID
		local before, matched, after = hubcapID:match('^(.*)(FRHubcap)(.*)$')
		tireID = tostring("Tire" .. after)
		tire = vehicle:getPartById(tostring(tireID))
	else
		--DebugLog.log ("VehicleUtils.FR_SetVisualTire: Neither part detected, ending function. Oops!")
		return
	end
	--DebugLog.log ("VehicleUtils.FR_SetVisualTire: tireID is " .. tostring(tireID) .. " and hubcapID is " .. tostring(hubcapID)))
	tire:setAllModelsVisible(false)
	
	if tire and tire:getInventoryItem() and tire:getInventoryItem():getType() then
		local tireType = tire:getInventoryItem():getType()
		local tireName = string.match(tireType, "%D+")
		--DebugLog.log ("VehicleUtils.FR_SetVisualTire: Attempting to set Tire " .. tostring(tireName) .. " to visible.")
		tire:setModelVisible(tostring(tireName), true)
		if hubcap and hubcap:getInventoryItem() and hubcap:getInventoryItem():getType() then
			local hubcapType = hubcap:getInventoryItem():getType()
			local hubcapName = tostring(hubcapType)
			--DebugLog.log ("VehicleUtils.FR_SetVisualTire: Attempting to set Hubcap " .. tostring(hubcapName) .. " to visible.")
			tire:setModelVisible(tostring(hubcapName), true)
		end
	else return end
end
--]]

Events.OnGameBoot.Add(function()
    Translator.loadFiles()
end)
