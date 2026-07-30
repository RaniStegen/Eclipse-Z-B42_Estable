IDBFS = IDBFS or {}
IDBFS.BiofuelCompatibility = IDBFS.BiofuelCompatibility or {}

local BIOFUEL_FLUID_TYPES = {
    IDBFSBiofuel = true,
    ["IDBFS.IDBFSBiofuel"] = true,
    ["Fluid.IDBFSBiofuel"] = true,
    idbfsbiofuel = true,
}

local function getBiofuelFluid()
    if Fluid and Fluid.IDBFSBiofuel then
        return Fluid.IDBFSBiofuel
    end
    if Fluid and Fluid.Get then
        return Fluid.Get("IDBFSBiofuel") or Fluid.Get("IDBFS.IDBFSBiofuel")
    end
    return nil
end

local function getPrimaryFluidTypeString(fluidContainer)
    if not fluidContainer or fluidContainer:isEmpty() then
        return nil
    end
    if fluidContainer.getPrimaryFluid then
        local primary = fluidContainer:getPrimaryFluid()
        if primary and primary.getFluidTypeString then
            return primary:getFluidTypeString()
        end
    end
    if fluidContainer.getPrimaryFluidTypeString then
        return fluidContainer:getPrimaryFluidTypeString()
    end
    return nil
end

local function containerContains(container, fluid)
    return container and fluid and container.contains and container:contains(fluid)
end

local function isBiofuelContainer(item)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    if not fluidContainer or fluidContainer:isEmpty() then
        return false
    end

    if containerContains(fluidContainer, getBiofuelFluid()) then
        return true
    end

    local fluidType = getPrimaryFluidTypeString(fluidContainer)
    local lowerFluidType = fluidType and string.lower(tostring(fluidType)) or nil
    if fluidType and (BIOFUEL_FLUID_TYPES[tostring(fluidType)] or BIOFUEL_FLUID_TYPES[lowerFluidType] or string.find(lowerFluidType, "biofuel", 1, true)) then
        return true
    end

    if IDBFS.getLiquidForFluidContainer then
        local liquidInfo = IDBFS.getLiquidForFluidContainer(item)
        if liquidInfo and liquidInfo.liquidType == "biofuel" and (liquidInfo.amount or 0) > 0 then
            return true
        end
    end

    local modData = item.getModData and item:getModData() or nil
    return modData and (modData.IDBFS_liquidType == "biofuel" or modData.liquidType == "biofuel")
end

local function isUsableEngineFuel(item)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    if not fluidContainer or fluidContainer:isEmpty() then
        return false
    end
    if Fluid and containerContains(fluidContainer, Fluid.Petrol) then
        return true
    end
    return isBiofuelContainer(item)
end

local function hasPetrolContainer(item)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    return Fluid and fluidContainer and not fluidContainer:isEmpty() and containerContains(fluidContainer, Fluid.Petrol)
end

local function sortContainersByName(containers)
    table.sort(containers, function(a, b)
        return not string.sort(a:getName(), b:getName())
    end)
end

local function groupContainersByName(containers)
    local groups = {}
    local group = {}
    local previous = nil
    for _, container in ipairs(containers) do
        if previous ~= nil and container:getName() ~= previous:getName() then
            table.insert(groups, group)
            group = {}
        end
        table.insert(group, container)
        previous = container
    end
    if #group > 0 then
        table.insert(groups, group)
    end
    return groups
end

local function getFuelContainers(playerObj)
    local inventory = playerObj and playerObj:getInventory() or nil
    if not inventory then
        return nil
    end
    return inventory:getAllEvalRecurse(isUsableEngineFuel)
end

local function hasContextOption(context, text)
    if not context or not context.options then
        return false
    end
    for i = 1, #context.options do
        local option = context.options[i]
        if option and option.name == text then
            return true
        end
    end
    return false
end

local function addGeneratorFuelOptions(worldobjects, generator, player, context)
    local playerObj = getSpecificPlayer(player)
    local playerNum = playerObj:getPlayerNum()
    local pourOut = getFuelContainers(playerObj)

    if not pourOut or pourOut:isEmpty() then
        return
    end

    local fillOption = context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, nil)
    if not generator:getSquare() or not AdjacentFreeTileFinder.Find(generator:getSquare(), playerObj) then
        fillOption.notAvailable = true
        return
    end

    local allContainers = {}
    for i = 0, pourOut:size() - 1 do
        table.insert(allContainers, pourOut:get(i))
    end
    sortContainersByName(allContainers)

    local containerMenu = ISContextMenu:getNew(context)
    context:addSubMenu(fillOption, containerMenu)

    if pourOut:size() > 1 then
        containerMenu:addGetUpOption(getText("ContextMenu_AddAll"), worldobjects, ISWorldObjectContextMenu.doAddFuelGenerator, generator, allContainers, nil, playerNum)
    end

    for _, containerType in ipairs(groupContainersByName(allContainers)) do
        local destItem = containerType[1]
        local containerOption
        if #containerType > 1 then
            containerOption = containerMenu:addOption(destItem:getName() .. " (" .. #containerType .. ")", worldobjects, nil)
            containerOption.itemForTexture = destItem
            local containerTypeMenu = ISContextMenu:getNew(containerMenu)
            containerMenu:addSubMenu(containerOption, containerTypeMenu)
            containerTypeMenu:addGetUpOption(getText("ContextMenu_AddOne"), worldobjects, ISWorldObjectContextMenu.doAddFuelGenerator, generator, {}, destItem, playerNum)
            if containerType[2] ~= nil then
                containerTypeMenu:addGetUpOption(getText("ContextMenu_AddAll"), worldobjects, ISWorldObjectContextMenu.doAddFuelGenerator, generator, containerType, nil, playerNum)
            end
        else
            containerOption = containerMenu:addGetUpOption(destItem:getName(), worldobjects, ISWorldObjectContextMenu.doAddFuelGenerator, generator, {}, destItem, playerNum)
            containerOption.itemForTexture = destItem
            if destItem:getFluidContainer() then
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.maxLineWidth = 512
                tooltip.description = getText("ContextMenu_FuelCapacity") .. "+" .. math.ceil(destItem:getFluidContainer():getAmount() * 10) .. "%"
                containerOption.toolTip = tooltip
            end
        end
    end
end

local function generatorFuelMenuPatch(worldobjects, petrolCan, generator, player, context)
    addGeneratorFuelOptions(worldobjects, generator, player, context)
end

local function vehicleGetGasCanPatch(playerObj, typeToItem)
    local equipped = playerObj:getPrimaryHandItem()
    if equipped and isUsableEngineFuel(equipped) then
        return equipped
    end

    local pourOut = getFuelContainers(playerObj)
    if not pourOut or pourOut:isEmpty() then
        return nil
    end

    local gasCan = nil
    local amount = -1
    for j = 1, pourOut:size() do
        local item = pourOut:get(j - 1)
        local itemAmount = item:getFluidContainer():getAmount()
        if itemAmount > amount then
            gasCan = item
            amount = itemAmount
        end
    end
    return gasCan
end

local function vehicleAddFuelMenuPatch(playerObj, part, context)
    local source = part:getVehicle()
    local playerNum = playerObj:getPlayerNum()
    local pourOut = getFuelContainers(playerObj)
    if not pourOut or pourOut:isEmpty() then
        return
    end

    local fillOption = context:addOption(getText("ContextMenu_VehicleAddGas"), worldobjects, nil)
    if not source:getSquare() or not AdjacentFreeTileFinder.Find(source:getSquare(), playerObj) then
        fillOption.notAvailable = true
        return
    end

    local allContainers = {}
    for i = 0, pourOut:size() - 1 do
        table.insert(allContainers, pourOut:get(i))
    end
    sortContainersByName(allContainers)

    local containerMenu = ISContextMenu:getNew(context)
    context:addSubMenu(fillOption, containerMenu)

    if pourOut:size() > 1 then
        containerMenu:addOption(getText("ContextMenu_AddAll"), worldobjects, ISVehiclePartMenu.onAddFuelNew, part, allContainers, nil, playerNum)
    end

    for _, containerType in ipairs(groupContainersByName(allContainers)) do
        local destItem = containerType[1]
        local containerOption
        if #containerType > 1 then
            containerOption = containerMenu:addOption(destItem:getName() .. " (" .. #containerType .. ")", worldobjects, nil)
            containerOption.itemForTexture = destItem
            local containerTypeMenu = ISContextMenu:getNew(containerMenu)
            containerMenu:addSubMenu(containerOption, containerTypeMenu)
            containerTypeMenu:addOption(getText("ContextMenu_AddOne"), worldobjects, ISVehiclePartMenu.onAddFuelNew, part, nil, destItem, playerNum)
            if containerType[2] ~= nil then
                containerTypeMenu:addOption(getText("ContextMenu_AddAll"), worldobjects, ISVehiclePartMenu.onAddFuelNew, part, containerType, nil, playerNum)
            end
        else
            containerOption = containerMenu:addOption(destItem:getName(), worldobjects, ISVehiclePartMenu.onAddFuelNew, part, nil, destItem, playerNum)
            containerOption.itemForTexture = destItem
            if destItem:getFluidContainer() then
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.maxLineWidth = 512
                tooltip.description = getText("ContextMenu_FuelCapacity") .. string.format("%s / %s", destItem:getFluidContainer():getFreeCapacity(), destItem:getFluidContainer():getCapacity())
                containerOption.toolTip = tooltip
            end
        end
    end
end

local function vehicleFillPartMenuPatch(playerIndex, context, slice, vehicle)
    local original = ISVehicleMenu and ISVehicleMenu.IDBFSOriginalFillPartMenu or nil
    if original then
        original(playerIndex, context, slice, vehicle)
    end

    local playerObj = getSpecificPlayer(playerIndex)
    if not playerObj or playerObj:DistToProper(vehicle) >= 4 then
        return
    end

    local inventory = playerObj:getInventory()
    if not inventory
            or inventory:containsEvalRecurse(hasPetrolContainer)
            or not inventory:containsEvalRecurse(isBiofuelContainer) then
        return
    end

    for i = 1, vehicle:getPartCount() do
        local part = vehicle:getPartByIndex(i - 1)
        if not vehicle:isEngineStarted()
                and part:isContainer()
                and part:getContainerContentType() == "Gasoline"
                and part:getContainerContentAmount() < part:getContainerCapacity() then
            if slice then
                slice:addSlice(getText("ContextMenu_VehicleAddGas"), getTexture("media/ui/vehicles/gas_refuel.png"), ISVehiclePartMenu.onAddGasoline, playerObj, part)
            elseif context and not hasContextOption(context, getText("ContextMenu_VehicleAddGas")) then
                ISVehiclePartMenu.doAddFuelMenu(playerObj, part, context)
            end
            return
        end
    end
end

local function installGeneratorPatch()
    if not ISWorldObjectContextMenu then
        return
    end
    if ISWorldObjectContextMenu.IDBFSOriginalCreateMenu
            and ISWorldObjectContextMenu.createMenu == IDBFS.BiofuelCompatibility.createMenuPatch then
        ISWorldObjectContextMenu.createMenu = ISWorldObjectContextMenu.IDBFSOriginalCreateMenu
        ISWorldObjectContextMenu.IDBFSOriginalCreateMenu = nil
    end
    if ISWorldObjectContextMenu.onAddFuelGenerator ~= generatorFuelMenuPatch then
        ISWorldObjectContextMenu.onAddFuelGenerator = generatorFuelMenuPatch
    end
end

local function installVehiclePatch()
    if not ISVehiclePartMenu then
        return
    end
    if ISVehiclePartMenu.getGasCanNotEmpty ~= vehicleGetGasCanPatch then
        ISVehiclePartMenu.getGasCanNotEmpty = vehicleGetGasCanPatch
    end
    if ISVehiclePartMenu.doAddFuelMenu ~= vehicleAddFuelMenuPatch then
        ISVehiclePartMenu.doAddFuelMenu = vehicleAddFuelMenuPatch
    end
    if ISVehicleMenu and not ISVehicleMenu.IDBFSFillPartMenuPatched then
        ISVehicleMenu.IDBFSOriginalFillPartMenu = ISVehicleMenu.FillPartMenu
        ISVehicleMenu.FillPartMenu = vehicleFillPartMenuPatch
        ISVehicleMenu.IDBFSFillPartMenuPatched = true
    end
end

local function findGenerator(worldobjects)
    if not worldobjects then
        return nil
    end
    for _, worldObject in ipairs(worldobjects) do
        if worldObject and instanceof(worldObject, "IsoGenerator") then
            return worldObject
        end
        local square = worldObject and worldObject.getSquare and worldObject:getSquare() or nil
        if square and square:getObjects() then
            for i = 0, square:getObjects():size() - 1 do
                local object = square:getObjects():get(i)
                if object and instanceof(object, "IsoGenerator") then
                    return object
                end
            end
        end
    end
    return nil
end

local function addGeneratorFallback(player, context, worldobjects, test)
    if test then
        return
    end
    IDBFS.BiofuelCompatibility.install()

    local generator = findGenerator(worldobjects)
    if not generator or generator:getFuelPercentage() >= 100 then
        return
    end

    local optionText = getText("ContextMenu_GeneratorAddFuel")
    if hasContextOption(context, optionText) then
        return
    end

    local playerObj = getSpecificPlayer(player)
    local inventory = playerObj and playerObj:getInventory() or nil
    if not inventory or inventory:containsEvalRecurse(hasPetrolContainer) then
        return
    end
    if inventory:containsEvalRecurse(isBiofuelContainer) then
        addGeneratorFuelOptions(worldobjects, generator, player, context)
    end
end

function IDBFS.BiofuelCompatibility.install()
    pcall(require, "ISUI/ISWorldObjectContextMenu")
    pcall(require, "Vehicles/ISUI/ISVehiclePartMenu")
    pcall(require, "Vehicles/ISUI/ISVehicleMenu")
    installGeneratorPatch()
    installVehiclePatch()
end

local function addEvent(event, callback)
    if event and event.Add then
        event.Add(callback)
    end
end

addEvent(Events.OnGameBoot, IDBFS.BiofuelCompatibility.install)
addEvent(Events.OnGameStart, IDBFS.BiofuelCompatibility.install)
addEvent(Events.OnCreatePlayer, IDBFS.BiofuelCompatibility.install)
addEvent(Events.OnPreFillWorldObjectContextMenu, addGeneratorFallback)
addEvent(Events.OnFillWorldObjectContextMenu, addGeneratorFallback)

IDBFS.BiofuelCompatibility.isUsableEngineFuel = isUsableEngineFuel
IDBFS.BiofuelCompatibility.isBiofuelContainer = isBiofuelContainer
IDBFS.BiofuelCompatibility.install()
