require "IDBFS_Core"
require "TimedActions/ISTimedActionQueue"
require "TimedActions/ISWalkToTimedAction"
require "IDBFS/TimedActions/ISIDBFSTimedCommandAction"

IDBFS = IDBFS or {}
IDBFS.Client = IDBFS.Client or {}

local FUEL_TYPES = {
    ["Base.Charcoal"] = true,
    ["Base.CharcoalCrafted"] = true,
    ["Base.Log"] = true,
    ["Base.Plank"] = true,
}

local FIRE_SOURCE_TYPES = {
    ["Base.Lighter"] = true,
    ["Base.LighterDisposable"] = true,
    ["Base.LighterBBQ"] = true,
    ["Base.Lighter_Battery"] = true,
    ["Base.Matches"] = true,
    ["Base.Matchbox"] = true,
    ["Base.MagnesiumFirestarter"] = true,
    ["Base.BlowTorch"] = true,
}

local FERMENTATION_STARTERS = {
    ["IDBFS.StarterYeast"] = true,
    ["Base.Yeast"] = true,
}

local WATER_FLUIDS = {
    Water = true,
    TaintedWater = true,
    CarbonatedWater = true,
}

local function text(key, fallback)
    if getText then
        local value = getText(key)
        if value and value ~= key then
            return value
        end
    end
    return fallback or key
end

local function addTooltip(option, description)
    if not option or not description then
        return
    end
    option.toolTip = ISWorldObjectContextMenu.addToolTip()
    option.toolTip.description = description
end

local function scanContainer(container, callback)
    if not container or not container.getItems then
        return
    end
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        callback(item, container)
        if item and item.IsInventoryContainer and item:IsInventoryContainer() and item.getItemContainer then
            scanContainer(item:getItemContainer(), callback)
        end
    end
end

local function collectItems(playerObj, matcher)
    local results = {}
    scanContainer(playerObj:getInventory(), function(item)
        if item and matcher(item) then
            table.insert(results, item)
        end
    end)
    return results
end

local function getTargetObject(worldobjects)
    for _, obj in ipairs(worldobjects) do
        if obj and IDBFS.isFunctionalObject(obj) then
            return obj, IDBFS.getObjectType(obj)
        end
    end
    return nil, nil
end

local function getData(obj)
    local objectType = IDBFS.getObjectType(obj)
    return IDBFS.ensureState(obj, objectType, false)
end

local function getWaterAmountForItem(item)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    if fluidContainer and not fluidContainer:isEmpty() then
        local primary = fluidContainer:getPrimaryFluid()
        if primary and WATER_FLUIDS[primary:getFluidTypeString()] == true then
            return tonumber(fluidContainer:getPrimaryFluidAmount()) or 0
        end
    end
    if item and item.isWaterSource and item:isWaterSource() and item.getCurrentUses then
        return tonumber(item:getCurrentUses()) or 0
    end
    return 0
end

local function hasWater(playerObj, requiredAmount)
    requiredAmount = math.max(0.001, tonumber(requiredAmount) or 0.25)
    local water = collectItems(playerObj, function(item)
        local amount = getWaterAmountForItem(item)
        local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
        if fluidContainer then
            return amount + 0.0001 >= requiredAmount
        end
        return amount >= 1
    end)
    return #water > 0
end

local function countMatching(playerObj, requirement)
    local count = 0
    collectItems(playerObj, function(item)
        if IDBFS.matchesIngredient(item, requirement) then
            count = count + IDBFS.getItemCount(item)
            return true
        end
        return false
    end)
    return count
end

local function getPressAvailability(playerObj, recipe)
    for _, req in ipairs(recipe.ingredients or {}) do
        if countMatching(playerObj, req) < (tonumber(req.count) or 0) then
            return false, "Tooltip_IDBFS_NeedIngredients"
        end
    end
    if recipe.needsWater and not hasWater(playerObj, recipe.waterAmount) then
        return false, "Tooltip_IDBFS_NeedWater"
    end
    local outputAmount = tonumber(recipe.amount) or IDBFS.LIQUID_BATCH_AMOUNT or 10
    local containers = collectItems(playerObj, function(item)
        return IDBFS.isPressContainer(item)
            and IDBFS.canContainerAcceptLiquid(item, recipe.liquidType, outputAmount)
    end)
    if #containers == 0 then
        return false, "Tooltip_IDBFS_NeedPressContainer"
    end
    return true, nil
end

local function hasPressIngredients(playerObj, recipe)
    local available = getPressAvailability(playerObj, recipe)
    return available == true
end

local function collectPressContainers(playerObj, liquidType, amount)
    return collectItems(playerObj, function(item)
        return IDBFS.isPressContainer(item) and IDBFS.canContainerAcceptLiquid(item, liquidType, amount or 0.001)
    end)
end

local function collectLiquidItems(playerObj, objectType, data)
    return collectItems(playerObj, function(item)
        local liquidInfo = IDBFS.getLiquidForFluidContainer(item) or IDBFS.getLiquidForItem(item)
        if not liquidInfo then
            return false
        end
        local liquidDef = IDBFS.getLiquidDef(liquidInfo.liquidType)
        if objectType == "tank"
                and data
                and data.liquidType == "ethanol"
                and liquidDef
                and liquidDef.oilAdditive == true then
            return true
        end
        return IDBFS.canObjectStoreLiquid(objectType, liquidInfo.liquidType)
    end)
end

local function collectPortableContainers(playerObj, liquidType)
    return collectItems(playerObj, function(item)
        if liquidType then
            return IDBFS.canContainerAcceptLiquid(item, liquidType, 0.001)
        end
        return IDBFS.isPortableLiquidContainer(item)
    end)
end

local function collectFuelItems(playerObj)
    return collectItems(playerObj, function(item)
        return item and item.getFullType and FUEL_TYPES[item:getFullType()] == true
    end)
end

local function isUsableFireSource(item)
    if not item or not item.getFullType or not FIRE_SOURCE_TYPES[item:getFullType()] then
        return false
    end
    if item.getCurrentUsesFloat and item:getCurrentUsesFloat() <= 0 then
        return false
    end
    if item.getDelta and item:getDelta() <= 0 then
        return false
    end
    return true
end

local function collectFireSourceItems(playerObj)
    return collectItems(playerObj, isUsableFireSource)
end

local function collectFermentationStarters(playerObj)
    return collectItems(playerObj, function(item)
        return item and item.getFullType and FERMENTATION_STARTERS[item:getFullType()] == true
    end)
end

local function collectOilAdditives(playerObj)
    return collectItems(playerObj, function(item)
        return IDBFS.getOilAdditiveForItem(item) ~= nil
    end)
end

local function isSameItem(a, b)
    return a and b and a.getID and b.getID and a:getID() == b:getID()
end

local function isProcessing(data)
    return data and (data.state == "fermenting" or data.state == "acetifying" or data.state == "distilling")
end

local function getHandPriority(playerObj, item)
    if not playerObj or not item then
        return 3
    end
    if isSameItem(playerObj:getPrimaryHandItem(), item) then
        return 0
    end
    if isSameItem(playerObj:getSecondaryHandItem(), item) then
        return 1
    end
    return 2
end

local function sortItemsByHand(playerObj, items)
    table.sort(items, function(a, b)
        local priorityA = getHandPriority(playerObj, a)
        local priorityB = getHandPriority(playerObj, b)
        if priorityA ~= priorityB then
            return priorityA < priorityB
        end
        local nameA = a and a.getName and a:getName() or ""
        local nameB = b and b.getName and b:getName() or ""
        return nameA < nameB
    end)
end

local function squareKey(square)
    if not square then
        return nil
    end
    return tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
end

local function addUniqueSquare(squares, seen, square)
    local key = squareKey(square)
    if not key or seen[key] then
        return
    end
    seen[key] = true
    table.insert(squares, square)
end

local function squareHasObjectType(square, objectType)
    if not square or not objectType or not square.getObjects then
        return false
    end
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)
        if IDBFS.getObjectType(obj) == objectType then
            return true
        end
    end
    return false
end

local function getCompositePartSquares(obj)
    local anchor = obj and IDBFS.getCompositeAnchor and IDBFS.getCompositeAnchor(obj) or obj
    local anchorSquare = anchor and anchor.getSquare and anchor:getSquare() or nil
    if not anchorSquare then
        return {}
    end

    local objectType = IDBFS.getObjectType(anchor)
    local composite = objectType and IDBFS.CompositeAnchors and IDBFS.CompositeAnchors[objectType] or nil
    if not composite or not composite.offsets then
        return { anchorSquare }
    end

    local squares = {}
    local seen = {}
    local function addOffsetSquare(offset)
        if type(offset) ~= "table" then
            return
        end
        local square = getCell():getGridSquare(
            anchorSquare:getX() - (tonumber(offset.x) or 0),
            anchorSquare:getY() - (tonumber(offset.y) or 0),
            anchorSquare:getZ() - (tonumber(offset.z) or 0)
        )
        if squareHasObjectType(square, objectType) then
            addUniqueSquare(squares, seen, square)
        end
    end
    for _, offset in pairs(composite.offsets) do
        if type(offset) == "table" and type(offset[1]) == "table" then
            for _, childOffset in ipairs(offset) do
                addOffsetSquare(childOffset)
            end
        else
            addOffsetSquare(offset)
        end
    end
    if #squares == 0 then
        addUniqueSquare(squares, seen, anchorSquare)
    end
    return squares
end

local function getSquareDistanceToPlayer(playerObj, square)
    if not playerObj or not square then
        return 0
    end
    local px = playerObj.getX and playerObj:getX() or nil
    local py = playerObj.getY and playerObj:getY() or nil
    if not px or not py then
        local playerSquare = playerObj.getSquare and playerObj:getSquare() or nil
        px = playerSquare and playerSquare:getX() or 0
        py = playerSquare and playerSquare:getY() or 0
    end
    local dx = px - square:getX()
    local dy = py - square:getY()
    return dx * dx + dy * dy
end

local function findBestWalkSquare(playerObj, obj)
    local objectSquares = getCompositePartSquares(obj)
    local candidates = {}
    local seen = {}

    for _, objectSquare in ipairs(objectSquares) do
        local walkSquare = nil
        if AdjacentFreeTileFinder and AdjacentFreeTileFinder.Find then
            walkSquare = AdjacentFreeTileFinder.Find(objectSquare, playerObj)
        end
        addUniqueSquare(candidates, seen, walkSquare)
    end

    table.sort(candidates, function(a, b)
        return getSquareDistanceToPlayer(playerObj, a) < getSquareDistanceToPlayer(playerObj, b)
    end)

    return candidates[1]
end

local function queueCommand(playerObj, obj, command, args, time, transferItem)
    if not playerObj or not obj then
        return
    end
    if ISWalkToTimedAction and AdjacentFreeTileFinder and AdjacentFreeTileFinder.Find then
        local walkSquare = findBestWalkSquare(playerObj, obj)
        if not walkSquare then
            return
        end
        ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, walkSquare))
    elseif luautils and luautils.walkToObject then
        if not luautils.walkToObject(playerObj, obj, true) then
            return
        end
    else
        local square = obj:getSquare()
        if not square then
            return
        end
        if ISWalkToTimedAction then
            ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
        end
    end
    if transferItem and ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.transferIfNeeded then
        ISInventoryPaneContextMenu.transferIfNeeded(playerObj, transferItem)
    end
    ISTimedActionQueue.add(ISIDBFSTimedCommandAction:new(playerObj, obj, command, args, time, transferItem))
end

local function addInspectOption(subMenu, obj)
    local option = subMenu:addOption(text("ContextMenu_IDBFS_Inspect", "Inspect Contents"), obj, nil)
    option.notAvailable = true
    addTooltip(option, IDBFS.getStateDescription(obj))
end

local function openPressInterface(playerObj, obj)
    if ISEntityUI and ISEntityUI.CanOpenWindowFor and ISEntityUI.OpenWindow
            and ISEntityUI.CanOpenWindowFor(playerObj, obj) then
        ISEntityUI.OpenWindow(playerObj, obj)
        return
    end
    if ISEntityUI and ISEntityUI.OpenHandcraftWindow then
        ISEntityUI.OpenHandcraftWindow(playerObj, obj, "IDBFSPress", true)
    end
end

local function addPressOptions(subMenu, playerObj, obj)
    local openOption = subMenu:addOption(text("ContextMenu_IDBFS_OpenPressInterface", "Open Press Interface"), nil, function()
        openPressInterface(playerObj, obj)
    end)
    if not ISEntityUI or not ISEntityUI.OpenHandcraftWindow then
        openOption.notAvailable = true
    end
    addInspectOption(subMenu, obj)
    local recipeOrder = { "fruit", "grain", "corn", "potato", "sugar", "sunflower_oil", "olive_oil" }
    for _, key in ipairs(recipeOrder) do
        local recipe = IDBFS.PressRecipes and IDBFS.PressRecipes[key] or nil
        if recipe then
            local recipeLabel = recipe.liquidType and IDBFS.getLiquidLabel(recipe.liquidType) or recipe.label
            local label = text("ContextMenu_IDBFS_Process", "Process") .. " " .. recipeLabel
            local option = subMenu:addOption(label, nil, function()
                local outputAmount = tonumber(recipe.amount) or IDBFS.LIQUID_BATCH_AMOUNT or 10
                local containers = collectPressContainers(playerObj, recipe.liquidType, outputAmount)
                sortItemsByHand(playerObj, containers)
                local container = containers[1]
                queueCommand(
                    playerObj, obj, "press",
                    { recipe = key, containerID = container and container:getID() or nil },
                    180, container
                )
            end)
            local available, reasonKey = getPressAvailability(playerObj, recipe)
            if not available then
                option.notAvailable = true
                addTooltip(option, text(reasonKey, "The requirements for this press recipe are not met."))
            end
        end
    end
end

local function addFillOption(subMenu, playerObj, obj, objectType, data)
    local fillOption = subMenu:addOption(text("ContextMenu_IDBFS_Fill", "Fill / Load Liquid"), nil, nil)
    if isProcessing(data) then
        fillOption.notAvailable = true
        addTooltip(fillOption, text("Tooltip_IDBFS_Busy", "This station is currently processing."))
        return
    end

    local liquidItems = collectLiquidItems(playerObj, objectType, data)
    if #liquidItems == 0 then
        fillOption.notAvailable = true
        addTooltip(fillOption, text("Tooltip_IDBFS_NoLiquidItems", "No valid liquid containers in inventory."))
        return
    end

    local fillSubMenu = ISContextMenu:getNew(subMenu)
    subMenu:addSubMenu(fillOption, fillSubMenu)
    sortItemsByHand(playerObj, liquidItems)
    for _, item in ipairs(liquidItems) do
        local liquidInfo = IDBFS.getLiquidForFluidContainer(item) or IDBFS.getLiquidForItem(item)
        local label = item:getName() .. " - " .. IDBFS.getLiquidLabel(liquidInfo.liquidType)
        local source = IDBFS.getItemSource(item) or IDBFS.getSourceForLiquid(liquidInfo.liquidType)
        if source then
            label = label .. " (" .. IDBFS.getSourceLabel(source) .. ")"
        end
        fillSubMenu:addOption(label, nil, function()
            queueCommand(playerObj, obj, "fillStorage", { sourceID = item:getID() }, 120, item)
        end)
    end
end

local function addTakeOption(subMenu, playerObj, obj, objectType, data)
    local amount = data and tonumber(data.amount) or 0
    local liquidType = data and data.liquidType or nil
    local liquidDef = IDBFS.getLiquidDef(liquidType)
    local legacyOutputLiquid = data and data.outputItem and IDBFS.getDistilledLiquidForItem(data.outputItem) or nil
    if legacyOutputLiquid then
        liquidType = legacyOutputLiquid
        liquidDef = IDBFS.getLiquidDef(liquidType)
    end
    local hasProduct = data and ((data.outputItem and data.state == "distilled" and not legacyOutputLiquid)
        or (liquidDef and liquidDef.storageOnly == true and liquidDef.item and amount > 0))
    local option = subMenu:addOption(
        hasProduct and text("ContextMenu_IDBFS_TakeProduct", "Take Product") or text("ContextMenu_IDBFS_TakeLiquid", "Take Liquid"),
        nil,
        nil
    )
    if hasProduct then
        if amount <= 0 then
            option.notAvailable = true
            addTooltip(option, text("Tooltip_IDBFS_NoTakeableLiquid", "No takeable liquid batch is ready."))
            return
        end
        option.onSelect = function()
            queueCommand(playerObj, obj, "takeLiquid", {}, 100)
        end
        return
    end

    local containers = collectPortableContainers(playerObj, liquidType)
    if amount <= 0 or not liquidDef or isProcessing(data) then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NoTakeableLiquid", "No takeable liquid batch is ready."))
        return
    end
    if #containers == 0 then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedEmptyContainer", "Requires a compatible liquid container."))
        return
    end

    sortItemsByHand(playerObj, containers)
    option.onSelect = function()
        queueCommand(playerObj, obj, "takeLiquid", { containerID = containers[1]:getID() }, 100, containers[1])
    end
end

local function addFermentationOption(subMenu, playerObj, obj, data)
    local option = subMenu:addOption(text("ContextMenu_IDBFS_StartFermentation", "Start Fermentation"), nil, function()
        local starters = collectFermentationStarters(playerObj)
        sortItemsByHand(playerObj, starters)
        queueCommand(playerObj, obj, "startFermentation", { starterID = starters[1] and starters[1]:getID() or nil }, 120, starters[1])
    end)
    local liquidDef = data and IDBFS.getLiquidDef(data.liquidType) or nil
    if not data or data.contaminated or isProcessing(data) or not liquidDef or not liquidDef.fermentable
            or (tonumber(data.amount) or 0) < IDBFS.getLiquidBatchAmount(data.liquidType) then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedFermentable", "Requires at least one raw fermentable liquid batch."))
        return
    end
    local starters = collectFermentationStarters(playerObj)
    if #starters == 0 then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedFermentationStarter", "Requires fermentation starter."))
    end
end

local function addVinegarOption(subMenu, playerObj, obj, data)
    local option = subMenu:addOption(text("ContextMenu_IDBFS_StartVinegar", "Start Vinegar"), nil, function()
        queueCommand(playerObj, obj, "startVinegar", {}, 120)
    end)
    local isVinegarBase = data and (data.liquidType == "wine" or data.liquidType == "cider")
    if not data or data.contaminated or isProcessing(data) or not isVinegarBase
            or (tonumber(data.amount) or 0) < IDBFS.getLiquidBatchAmount(data.liquidType) then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedWine", "Requires wine or cider stored in this barrel."))
    end
end

local function addDistillationOption(subMenu, playerObj, obj, data)
    local option = subMenu:addOption(text("ContextMenu_IDBFS_StartDistillation", "Start Distillation"), nil, nil)
    local liquidDef = data and IDBFS.getLiquidDef(data.liquidType) or nil
    local fuelItems = collectFuelItems(playerObj)
    local fireSourceItems = collectFireSourceItems(playerObj)
    if not data or isProcessing(data) or not liquidDef or not liquidDef.distillable
            or (tonumber(data.amount) or 0) < IDBFS.getLiquidBatchAmount(data.liquidType) then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedDistillable", "Requires distillable liquid loaded in the still."))
        return
    end
    if #fuelItems == 0 then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedFuel", "Requires charcoal, a log, or a plank for heat."))
        return
    end
    if #fireSourceItems == 0 then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedFireSource", "Requires a lighter, matches, firestarter, or blowtorch to ignite."))
        return
    end
    sortItemsByHand(playerObj, fuelItems)
    sortItemsByHand(playerObj, fireSourceItems)
    local baseArgs = { fuelID = fuelItems[1]:getID(), fireSourceID = fireSourceItems[1]:getID() }
    if data.liquidType ~= "fermented_wash" then
        option.onSelect = function()
            queueCommand(playerObj, obj, "startDistillation", baseArgs, 180, fireSourceItems[1])
        end
        return
    end

    local outputSource = IDBFS.normalizeSource(data.source) or IDBFS.getSourceForLiquid(data.liquidType) or "mixed"
    local outputs = IDBFS.getDistillationOutputs(outputSource)
    if not outputs or #outputs == 0 then
        option.onSelect = function()
            queueCommand(playerObj, obj, "startDistillation", baseArgs, 180, fireSourceItems[1])
        end
        return
    end

    local outputSubMenu = ISContextMenu:getNew(subMenu)
    subMenu:addSubMenu(option, outputSubMenu)
    for _, outputLiquidType in ipairs(outputs) do
        local selectedOutputLiquidType = outputLiquidType
        local label = text("ContextMenu_IDBFS_DistillTo", "Distill to") .. " " .. IDBFS.getLiquidLabel(outputLiquidType)
        outputSubMenu:addOption(label, nil, function()
            local args = {
                fuelID = baseArgs.fuelID,
                fireSourceID = baseArgs.fireSourceID,
                outputLiquidType = selectedOutputLiquidType,
            }
            queueCommand(playerObj, obj, "startDistillation", args, 180, fireSourceItems[1])
        end)
    end
end

local function addRefineBiofuelOption(subMenu, playerObj, obj, data)
    local option = subMenu:addOption(text("ContextMenu_IDBFS_RefineBiofuel", "Refine Biofuel"), nil, nil)
    local additives = collectOilAdditives(playerObj)
    local storedOil = data and tonumber(data.oilAdditiveAmount) or 0
    if not data or data.contaminated or isProcessing(data)
            or data.liquidType ~= "ethanol" or (tonumber(data.amount) or 0) <= 0 then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedEthanol", "Requires ethanol stored in this station."))
        return
    end
    if storedOil <= 0 and #additives == 0 then
        option.notAvailable = true
        addTooltip(option, text("Tooltip_IDBFS_NeedFuelAdditive", "Requires vegetable or olive oil."))
        return
    end
    sortItemsByHand(playerObj, additives)
    option.onSelect = function()
        if storedOil > 0 then
            queueCommand(playerObj, obj, "refineBiofuel", {}, 120)
        else
            queueCommand(playerObj, obj, "refineBiofuel", { additiveID = additives[1]:getID() }, 120, additives[1])
        end
    end
end

local function addEmptyOption(subMenu, playerObj, obj, data)
    local option = subMenu:addOption(text("ContextMenu_IDBFS_Empty", "Empty Contents"), nil, function()
        queueCommand(playerObj, obj, "emptyStorage", {}, 80)
    end)
    if not data or (tonumber(data.amount) or 0) <= 0 or isProcessing(data) then
        option.notAvailable = true
    end
end

local function addDebugOption(subMenu, playerObj, obj)
    if not playerObj or not playerObj.getAccessLevel or playerObj:getAccessLevel() ~= "Admin" then
        return
    end
    subMenu:addOption(text("ContextMenu_IDBFS_DebugFill", "[Debug] Fill Fermented Wash"), nil, function()
        queueCommand(playerObj, obj, "debugFill", { liquidType = "fermented_wash", amount = 40 }, 1)
    end)
end

function IDBFS.Client.onFillWorldObjectContextMenu(playerNum, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then
        return true
    end

    local playerObj = getSpecificPlayer(playerNum)
    if not playerObj or playerObj:getVehicle() then
        return false
    end

    local obj, objectType = getTargetObject(worldobjects)
    if not obj or not objectType then
        return false
    end

    if test then
        return ISWorldObjectContextMenu.setTest()
    end

    local data = getData(obj)
    local parentOption = context:addOption(text("ContextMenu_IDBFS_Distillery", "Distillery"), worldobjects, nil)
    local subMenu = ISContextMenu:getNew(context)
    context:addSubMenu(parentOption, subMenu)

    if objectType == "press" then
        addPressOptions(subMenu, playerObj, obj)
    elseif objectType == "barrel" or objectType == "tanker" then
        addInspectOption(subMenu, obj)
        addFillOption(subMenu, playerObj, obj, objectType, data)
        addFermentationOption(subMenu, playerObj, obj, data)
        addVinegarOption(subMenu, playerObj, obj, data)
        addTakeOption(subMenu, playerObj, obj, objectType, data)
        addEmptyOption(subMenu, playerObj, obj, data)
        addDebugOption(subMenu, playerObj, obj)
    elseif objectType == "still" then
        addInspectOption(subMenu, obj)
        addFillOption(subMenu, playerObj, obj, objectType, data)
        addDistillationOption(subMenu, playerObj, obj, data)
        addTakeOption(subMenu, playerObj, obj, objectType, data)
        addEmptyOption(subMenu, playerObj, obj, data)
        addDebugOption(subMenu, playerObj, obj)
    elseif objectType == "tank" then
        addInspectOption(subMenu, obj)
        addFillOption(subMenu, playerObj, obj, objectType, data)
        addRefineBiofuelOption(subMenu, playerObj, obj, data)
        addTakeOption(subMenu, playerObj, obj, objectType, data)
        addEmptyOption(subMenu, playerObj, obj, data)
        addDebugOption(subMenu, playerObj, obj)
    end

    return true
end

Events.OnFillWorldObjectContextMenu.Add(IDBFS.Client.onFillWorldObjectContextMenu)
