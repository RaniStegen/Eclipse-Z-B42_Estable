require "IDBFS_Core"

IDBFS = IDBFS or {}
IDBFS.Server = IDBFS.Server or {}
BuildRecipeCode = BuildRecipeCode or {}
BuildRecipeCode.IDBFS = BuildRecipeCode.IDBFS or {}

function BuildRecipeCode.IDBFS.OnCreateEmptyStorage(params)
    local obj = params and params.thumpable
    local objectType = obj and IDBFS.getObjectType(obj) or nil
    if not obj or not objectType then
        return nil
    end
    local data = IDBFS.ensureState(obj, objectType, false)
    if data then
        data.createdByIDBFS = true
        IDBFS.clearLiquid(data)
        IDBFS.syncObject(obj)
    end
    return nil
end

local function findObjectWithSprite(square, spriteName)
    if not square or not spriteName or not square.getObjects then
        return nil
    end
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)
        if IDBFS.getSpriteName(obj) == spriteName then
            return obj
        end
    end
    return nil
end

local function createCompositeTile(square, spriteName)
    if not square or not spriteName or findObjectWithSprite(square, spriteName) then
        return nil
    end
    local sprite = getSprite(spriteName)
    if not sprite then
        return nil
    end
    local obj = IsoObject.new(getCell(), square, sprite)
    square:AddTileObject(obj)
    if isClient and isClient() then
        obj:transmitCompleteItemToServer()
    end
    if isServer and isServer() then
        obj:transmitCompleteItemToClients()
    end
    if triggerEvent then
        triggerEvent("OnObjectAdded", obj)
    end
    return obj
end

local function getOrCreateSquare(x, y, z)
    local cell = getCell()
    local square = cell and cell:getGridSquare(x, y, z) or nil
    if square then
        return square
    end
    if cell and cell.getOrCreateGridSquare then
        local ok, created = pcall(cell.getOrCreateGridSquare, cell, x, y, z)
        if ok and created then
            return created
        end
    end
    if cell and cell.createNewGridSquare then
        local ok, created = pcall(cell.createNewGridSquare, cell, x, y, z, false)
        if ok and created then
            if cell.EnsureSurroundNotNull then
                pcall(cell.EnsureSurroundNotNull, cell, x, y, z)
            end
            return created
        end
    end
    return nil
end

function BuildRecipeCode.IDBFS.OnCreateCompositeStorage(params)
    local obj = params and params.thumpable
    local objectType = obj and IDBFS.getObjectType(obj) or nil
    if not obj or not objectType then
        return nil
    end

    local square = obj:getSquare()
    local placement = IDBFS.MoveableTiles
        and IDBFS.MoveableTiles.CompositePlacement
        and IDBFS.MoveableTiles.CompositePlacement["IDBFS.MoveableDistillationStill"]
        or nil
    if square and placement and objectType == "still" then
        for _, part in ipairs(placement.parts) do
            if part.sprite ~= placement.anchor then
                local partSquare = getOrCreateSquare(
                    square:getX() + (tonumber(part.x) or 0),
                    square:getY() + (tonumber(part.y) or 0),
                    square:getZ() + (tonumber(part.z) or 0)
                )
                createCompositeTile(partSquare, part.sprite)
            end
        end
    end

    return BuildRecipeCode.IDBFS.OnCreateEmptyStorage(params)
end

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

local function scanContainer(container, callback)
    if not container or not container.getItems then
        return false
    end
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if callback(item, container) then
            return true
        end
        if item and item.IsInventoryContainer and item:IsInventoryContainer() and item.getItemContainer then
            if scanContainer(item:getItemContainer(), callback) then
                return true
            end
        end
    end
    return false
end

local function findPlayerItem(playerObj, itemID)
    if not playerObj or itemID == nil then
        return nil, nil
    end
    local foundItem, foundContainer
    scanContainer(playerObj:getInventory(), function(item, container)
        if item and item.getID and item:getID() == itemID then
            foundItem = item
            foundContainer = container
            return true
        end
        return false
    end)
    return foundItem, foundContainer
end

local function collectMatchingItems(playerObj, matcher)
    local results = {}
    scanContainer(playerObj:getInventory(), function(item, container)
        if item and matcher(item) then
            table.insert(results, { item = item, container = container })
        end
        return false
    end)
    return results
end

local function findPlayerItemEntry(playerObj, itemID)
    local item, container = findPlayerItem(playerObj, itemID)
    if item and container then
        return { item = item, container = container }
    end
    return nil
end

local function isFullTypeInSet(fullType, list)
    if not fullType or not list then
        return false
    end
    for _, allowed in ipairs(list) do
        if fullType == allowed then
            return true
        end
    end
    return false
end

local function removeItem(container, item)
    if not container or not item then
        return
    end
    container:Remove(item)
    if sendRemoveItemFromContainer then
        sendRemoveItemFromContainer(container, item)
    end
    if container.setDrawDirty then
        container:setDrawDirty(true)
    end
end

local function consumeEntries(entries, count)
    for i = 1, count do
        local entry = entries[i]
        if entry then
            removeItem(entry.container, entry.item)
        end
    end
end

local function findPressContainer(playerObj, liquidType, amount, containerID)
    if containerID ~= nil then
        local item, container = findPlayerItem(playerObj, containerID)
        if item and IDBFS.isPressContainer(item) and IDBFS.canContainerAcceptLiquid(item, liquidType, amount or 0.001) then
            return { item = item, container = container }
        end
    end

    local matches = collectMatchingItems(playerObj, function(item)
        return IDBFS.isPressContainer(item) and IDBFS.canContainerAcceptLiquid(item, liquidType, amount or 0.001)
    end)
    return matches[1]
end

local function findPortableContainer(playerObj)
    local matches = collectMatchingItems(playerObj, function(item)
        return IDBFS.isPortableLiquidContainer(item)
    end)
    return matches[1]
end

local function findAvailableFluidContainer(playerObj, liquidType)
    local matches = collectMatchingItems(playerObj, function(item)
        return IDBFS.canContainerAcceptLiquid(item, liquidType, 0.001)
    end)
    return matches[1]
end

local function isWaterFluidItem(item)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    if not fluidContainer or fluidContainer:isEmpty() then
        return false
    end
    local primary = fluidContainer:getPrimaryFluid()
    if not primary then
        return false
    end
    return WATER_FLUIDS[primary:getFluidTypeString()] == true
end

local function getWaterUnitsForItem(item)
    if not item then
        return 0
    end
    if isWaterFluidItem(item) then
        return math.floor(item:getFluidContainer():getPrimaryFluidAmount())
    end
    if item.isWaterSource and item:isWaterSource() and item.getCurrentUses then
        return item:getCurrentUses()
    end
    return 0
end

local function findWaterItem(playerObj)
    local matches = collectMatchingItems(playerObj, function(item)
        return getWaterUnitsForItem(item) > 0
    end)
    return matches[1]
end

local function consumeWater(item, units)
    units = math.max(1, math.floor(tonumber(units) or 1))
    if isWaterFluidItem(item) then
        item:getFluidContainer():removeFluid(units, false)
        if item.syncItemFields then
            item:syncItemFields()
        end
        return true
    end
    if item and item.Use then
        for _ = 1, units do
            if item.getCurrentUsesFloat and item:getCurrentUsesFloat() <= 0 then
                break
            end
            item:Use()
        end
        return true
    end
    return false
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

local function findFireSource(playerObj, fireSourceID)
    local fireSourceItem = nil
    if fireSourceID ~= nil then
        fireSourceItem = findPlayerItem(playerObj, fireSourceID)
    end
    if isUsableFireSource(fireSourceItem) then
        return fireSourceItem
    end

    local fireSources = collectMatchingItems(playerObj, isUsableFireSource)
    return fireSources[1] and fireSources[1].item or nil
end

local function consumeFireSource(item)
    if not isUsableFireSource(item) then
        return false
    end
    if item.UseAndSync then
        item:UseAndSync()
    elseif item.Use then
        item:Use()
    end
    if item.syncItemFields then
        item:syncItemFields()
    end
    return true
end

local function consumeFuelByID(playerObj, fuelID)
    local fuelItem, fuelContainer = findPlayerItem(playerObj, fuelID)
    if not fuelItem or not fuelItem.getFullType or not FUEL_TYPES[fuelItem:getFullType()] then
        return false
    end
    removeItem(fuelContainer, fuelItem)
    return true
end

local function consumeStarterByID(playerObj, starterID)
    local starterItem = nil
    if starterID ~= nil then
        starterItem = findPlayerItem(playerObj, starterID)
    end
    if not starterItem then
        local starters = collectMatchingItems(playerObj, function(item)
            return item and item.getFullType and FERMENTATION_STARTERS[item:getFullType()] == true
        end)
        starterItem = starters[1] and starters[1].item or nil
    end
    if not starterItem or not starterItem.getFullType or not FERMENTATION_STARTERS[starterItem:getFullType()] then
        return false
    end
    if starterItem.UseAndSync then
        starterItem:UseAndSync()
    elseif starterItem.Use then
        starterItem:Use()
    end
    return true
end

local function consumeOilAdditiveByID(playerObj, additiveID)
    local additiveItem, additiveContainer = nil, nil
    if additiveID ~= nil then
        additiveItem, additiveContainer = findPlayerItem(playerObj, additiveID)
    end
    if not additiveItem then
        local additives = collectMatchingItems(playerObj, function(item)
            return IDBFS.getOilAdditiveForItem(item) ~= nil
        end)
        additiveItem = additives[1] and additives[1].item or nil
        additiveContainer = additives[1] and additives[1].container or nil
    end
    local fluidAdditiveInfo = IDBFS.getLiquidForFluidContainer(additiveItem)
    local itemAdditiveInfo = IDBFS.getLiquidForItem(additiveItem)
    local additiveInfo = fluidAdditiveInfo or itemAdditiveInfo
    local additiveDef = additiveInfo and IDBFS.getLiquidDef(additiveInfo.liquidType) or nil
    if not additiveItem or not additiveInfo or not additiveDef or additiveDef.oilAdditive ~= true then
        return 0
    end
    local amount = tonumber(additiveInfo.amount) or IDBFS.getLiquidBatchAmount(additiveInfo.liquidType)
    if fluidAdditiveInfo and fluidAdditiveInfo.fluidContainer then
        fluidAdditiveInfo.fluidContainer:removeFluid(amount, false)
        if additiveItem.syncItemFields then
            additiveItem:syncItemFields()
        end
    else
        removeItem(additiveContainer, additiveItem)
    end
    return amount
end

local function getFluidAmount(fluidContainer)
    if not fluidContainer then
        return 0
    end
    if fluidContainer.getPrimaryFluidAmount then
        return tonumber(fluidContainer:getPrimaryFluidAmount()) or 0
    end
    return tonumber(fluidContainer:getAmount()) or 0
end

local function removeFluid(fluidContainer, amount)
    if not fluidContainer or amount <= 0 then
        return
    end
    if fluidContainer.removeFluid then
        fluidContainer:removeFluid(amount, false)
    elseif fluidContainer.adjustAmount then
        fluidContainer:adjustAmount(math.max(0, (tonumber(fluidContainer:getAmount()) or 0) - amount))
    end
end

local function clearItemSourceIfEmpty(item)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    if fluidContainer and fluidContainer.isEmpty and fluidContainer:isEmpty() then
        IDBFS.clearItemSource(item)
    end
end

local function consumeLiquidSource(sourceItem, sourceContainer, fluidLiquidInfo, itemLiquidInfo, amount)
    if fluidLiquidInfo and not itemLiquidInfo then
        removeFluid(fluidLiquidInfo.fluidContainer, amount)
        clearItemSourceIfEmpty(sourceItem)
        if sourceItem.syncItemFields then
            sourceItem:syncItemFields()
        end
    else
        removeItem(sourceContainer, sourceItem)
    end
end

local function isBiofuelTank(objectType)
    return objectType == "tank"
end

local function isFermentationStorage(objectType)
    return objectType == "barrel" or objectType == "tanker"
end

local function isProcessing(data)
    return data and (data.state == "fermenting" or data.state == "acetifying" or data.state == "distilling")
end

local function addFluidToContainer(item, liquidType, amount, source)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    local fluid = IDBFS.getFluidForLiquid(liquidType)
    if not fluidContainer or not fluid or not IDBFS.canContainerAcceptLiquid(item, liquidType, amount) then
        return false
    end
    if fluidContainer:isEmpty() then
        fluidContainer:addFluid(fluid, amount)
    else
        fluidContainer:adjustAmount((tonumber(fluidContainer:getAmount()) or 0) + amount)
    end
    if item.syncItemFields then
        item:syncItemFields()
    end
    local liquidSource = IDBFS.normalizeSource(source) or IDBFS.getSourceForLiquid(liquidType)
    if liquidSource then
        IDBFS.setItemSource(item, liquidSource)
    end
    return true
end

local function removeCreatedRecipeItems(craftRecipeData)
    local createdItems = craftRecipeData and craftRecipeData.getAllCreatedItems and craftRecipeData:getAllCreatedItems() or nil
    if not createdItems then
        return
    end

    for i = 0, createdItems:size() - 1 do
        local item = createdItems:get(i)
        local container = item and item.getContainer and item:getContainer() or nil
        if container then
            removeItem(container, item)
            if container.setDrawDirty then
                container:setDrawDirty(true)
            end
        elseif item and item.Remove then
            item:Remove()
        end
    end
end

local function findPressBucketInList(items, liquidType)
    if not items then
        return nil
    end

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and IDBFS.isPressContainer(item) and IDBFS.canContainerAcceptLiquid(item, liquidType, 0.001) then
            return item
        end
    end
    return nil
end

local function findPressBucketInCraftData(craftRecipeData, liquidType)
    local items = nil
    if craftRecipeData and craftRecipeData.getAllInputItems then
        items = craftRecipeData:getAllInputItems()
    end
    local item = findPressBucketInList(items, liquidType)
    if item then
        return item
    end

    if craftRecipeData and craftRecipeData.getAllConsumedItems then
        items = craftRecipeData:getAllConsumedItems()
    end
    item = findPressBucketInList(items, liquidType)
    if item then
        return item
    end

    if craftRecipeData and craftRecipeData.getAllKeepInputItems then
        items = craftRecipeData:getAllKeepInputItems()
    end
    return findPressBucketInList(items, liquidType)
end

local function findCreatedPressBucket(craftRecipeData, liquidType)
    local createdItems = craftRecipeData and craftRecipeData.getAllCreatedItems and craftRecipeData:getAllCreatedItems() or nil
    return findPressBucketInList(createdItems, liquidType)
end

local function replaceCreatedBucketIfNeeded(createdBucket, sourceBucket)
    if not createdBucket or not sourceBucket or not createdBucket.getFullType or not sourceBucket.getFullType then
        return createdBucket, nil, false
    end
    local wantedType = sourceBucket:getFullType()
    if not wantedType or createdBucket:getFullType() == wantedType then
        return createdBucket, createdBucket.getContainer and createdBucket:getContainer() or nil, false
    end

    local container = createdBucket.getContainer and createdBucket:getContainer() or nil
    if not container or not container.AddItem then
        return createdBucket, container, false
    end

    local replacement = container:AddItem(wantedType)
    if not replacement then
        return createdBucket, container, false
    end

    removeItem(container, createdBucket)
    if container.setDrawDirty then
        container:setDrawDirty(true)
    end
    return replacement, container, true
end

local function fillPressRecipeBucket(craftRecipeData, liquidType)
    removeCreatedRecipeItems(craftRecipeData)

    local sourceBucket = findPressBucketInCraftData(craftRecipeData, liquidType)
    local bucket = findCreatedPressBucket(craftRecipeData, liquidType) or sourceBucket
    local addedContainer, addedReplacement
    bucket, addedContainer, addedReplacement = replaceCreatedBucketIfNeeded(bucket, sourceBucket)
    local fluidContainer = bucket and bucket.getFluidContainer and bucket:getFluidContainer() or nil
    local liquidDef = IDBFS.getLiquidDef(liquidType)
    local freeCapacity = fluidContainer and tonumber(fluidContainer:getFreeCapacity()) or 0
    local amount = math.min(IDBFS.getLiquidBatchAmount(liquidType), freeCapacity)
    if amount <= 0 or not addFluidToContainer(bucket, liquidType, amount, liquidDef and liquidDef.source) then
        return
    end

    local container = bucket.getContainer and bucket:getContainer() or nil
    if container and container.setDrawDirty then
        container:setDrawDirty(true)
    end
    if addedReplacement and addedContainer and sendAddItemToContainer then
        sendAddItemToContainer(addedContainer, bucket)
    end
end

function IDBFS_OnCreatePressFruitMash(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "fruit_mash")
end

function IDBFS_OnCreatePressGrainMash(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "grain_mash")
end

function IDBFS_OnCreatePressCornMash(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "corn_mash")
end

function IDBFS_OnCreatePressPotatoMash(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "potato_mash")
end

function IDBFS_OnCreatePressSugarWash(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "sugar_wash")
end

function IDBFS_OnCreatePressSunflowerOil(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "sunflower_oil")
end

function IDBFS_OnCreatePressOliveOil(craftRecipeData, character)
    fillPressRecipeBucket(craftRecipeData, "olive_oil")
end

local function resolveTarget(args)
    local obj = IDBFS.resolveObjectRef(args and args.obj)
    local objectType = obj and IDBFS.getObjectType(obj) or nil
    if args and args.objectType and objectType ~= args.objectType then
        return nil, nil
    end
    return obj, objectType
end

local function initializeAndUpdate(obj, objectType)
    local data = IDBFS.ensureState(obj, objectType, true)
    IDBFS.updateProgress(obj)
    return data
end

function IDBFS.Server.press(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or objectType ~= "press" then
        return
    end
    IDBFS.Server.pressWithObject(playerObj, obj, args and args.recipe, args and args.containerID, args)
end

local function collectPressIngredientEntries(playerObj, req, ingredientIDs, usedIDs)
    local entries = {}
    if type(ingredientIDs) == "table" then
        for _, itemID in ipairs(ingredientIDs) do
            if not usedIDs[itemID] then
                local entry = findPlayerItemEntry(playerObj, itemID)
                local fullType = entry and entry.item and entry.item.getFullType and entry.item:getFullType() or nil
                if fullType and isFullTypeInSet(fullType, req.anyOf) then
                    entries[#entries + 1] = entry
                    usedIDs[itemID] = true
                    if #entries >= req.count then
                        return entries
                    end
                end
            end
        end
    end

    if #entries >= req.count then
        return entries
    end

    local matches = collectMatchingItems(playerObj, function(item)
        return item.getFullType and isFullTypeInSet(item:getFullType(), req.anyOf)
    end)
    for _, entry in ipairs(matches) do
        local itemID = entry.item and entry.item.getID and entry.item:getID() or nil
        if not itemID or not usedIDs[itemID] then
            entries[#entries + 1] = entry
            if itemID then
                usedIDs[itemID] = true
            end
            if #entries >= req.count then
                break
            end
        end
    end
    return entries
end

function IDBFS.Server.pressWithObject(playerObj, obj, recipeKey, containerID, commandArgs)
    if not obj or IDBFS.getObjectType(obj) ~= "press" then
        return
    end
    local recipe = IDBFS.PressRecipes and IDBFS.PressRecipes[recipeKey]
    if not recipe then
        return
    end

    local pressContainerEntry = findPressContainer(playerObj, recipe.liquidType, 0.001, containerID)
    if not pressContainerEntry then
        return
    end
    local targetItem = pressContainerEntry.item
    local targetFluidContainer = targetItem and targetItem.getFluidContainer and targetItem:getFluidContainer() or nil
    local freeCapacity = targetFluidContainer and tonumber(targetFluidContainer:getFreeCapacity()) or 0
    local outputAmount = math.min(tonumber(recipe.amount) or IDBFS.LIQUID_BATCH_AMOUNT or 10, freeCapacity)
    if outputAmount <= 0 or not IDBFS.canContainerAcceptLiquid(targetItem, recipe.liquidType, outputAmount) then
        return
    end

    local ingredientEntries = {}
    local usedIngredientIDs = {}
    local ingredientIDs = commandArgs and commandArgs.ingredientIDs or nil
    for _, req in ipairs(recipe.ingredients or {}) do
        local matches = collectPressIngredientEntries(playerObj, req, ingredientIDs, usedIngredientIDs)
        if #matches < req.count then
            return
        end
        table.insert(ingredientEntries, { entries = matches, count = req.count })
    end

    local waterEntry = nil
    if recipe.needsWater then
        waterEntry = findWaterItem(playerObj)
        if not waterEntry then
            return
        end
    end

    for _, group in ipairs(ingredientEntries) do
        consumeEntries(group.entries, group.count)
    end
    if waterEntry then
        consumeWater(waterEntry.item, 1)
    end
    addFluidToContainer(targetItem, recipe.liquidType, outputAmount, IDBFS.getSourceForLiquid(recipe.liquidType))
end

function IDBFS.Server.fillStorage(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or objectType == "press" then
        return
    end
    local sourceItem, sourceContainer = findPlayerItem(playerObj, args.sourceID)
    local itemLiquidInfo = IDBFS.getLiquidForItem(sourceItem)
    local fluidLiquidInfo = IDBFS.getLiquidForFluidContainer(sourceItem)
    local liquidInfo = fluidLiquidInfo or itemLiquidInfo
    if not sourceItem or not sourceContainer or not liquidInfo then
        return
    end

    local liquidType = liquidInfo.liquidType
    local liquidDef = IDBFS.getLiquidDef(liquidType)
    local source = IDBFS.getItemSource(sourceItem) or IDBFS.getSourceForLiquid(liquidType)

    local data = initializeAndUpdate(obj, objectType)
    if not data or isProcessing(data) then
        return
    end

    local isTankOilAdditive = isBiofuelTank(objectType)
        and liquidDef
        and liquidDef.oilAdditive == true
        and data.liquidType == "ethanol"
        and (tonumber(data.amount) or 0) > 0
    if not isTankOilAdditive and not IDBFS.canObjectStoreLiquid(objectType, liquidType) then
        return
    end

    local amount = tonumber(liquidInfo.amount) or IDBFS.getLiquidBatchAmount(liquidType)
    if amount <= 0 then
        return
    end
    local used = (tonumber(data.amount) or 0) + (tonumber(data.oilAdditiveAmount) or 0)
    local free = (tonumber(data.capacity) or 0) - used
    if free < amount then
        return
    end

    if isBiofuelTank(objectType) then
        local currentDef = IDBFS.getLiquidDef(data.liquidType)
        if liquidDef and liquidDef.oilAdditive == true and data.liquidType == "ethanol" then
            data.oilAdditiveAmount = (tonumber(data.oilAdditiveAmount) or 0) + amount
            data.state = "stored"
            consumeLiquidSource(sourceItem, sourceContainer, fluidLiquidInfo, itemLiquidInfo, amount)
            IDBFS.syncObject(obj)
            return
        elseif liquidType == "ethanol" and currentDef and currentDef.oilAdditive == true and (tonumber(data.amount) or 0) > 0 then
            data.oilAdditiveAmount = (tonumber(data.oilAdditiveAmount) or 0) + (tonumber(data.amount) or 0)
            data.liquidType = nil
            data.amount = 0
            data.state = "empty"
            data.source = nil
            data.outputSource = nil
            data.outputItem = nil
        end
    end

    if not IDBFS.canAddLiquid(data, liquidType, amount) then
        IDBFS.contaminate(data, liquidType, amount)
    else
        IDBFS.addLiquid(data, liquidType, amount, source)
    end

    consumeLiquidSource(sourceItem, sourceContainer, fluidLiquidInfo, itemLiquidInfo, amount)
    IDBFS.syncObject(obj)
end

function IDBFS.Server.takeLiquid(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or objectType == "press" then
        return
    end
    local data = initializeAndUpdate(obj, objectType)
    if not data or isProcessing(data) then
        return
    end
    local liquidType = data.liquidType
    local liquidDef = IDBFS.getLiquidDef(liquidType)
    local storedAmount = tonumber(data.amount) or 0
    if data.outputItem and data.state == "distilled" and storedAmount > 0 then
        local convertedLiquidType = IDBFS.getDistilledLiquidForItem(data.outputItem)
        if convertedLiquidType then
            data.liquidType = convertedLiquidType
            data.outputItem = nil
            liquidType = convertedLiquidType
            liquidDef = IDBFS.getLiquidDef(liquidType)
        else
            local inventory = playerObj and playerObj.getInventory and playerObj:getInventory() or nil
            local outputItem = data.outputItem
            if not inventory or not outputItem then
                return
            end
            inventory:AddItem(outputItem)
            data.amount = storedAmount - math.min(storedAmount, IDBFS.getLiquidBatchAmount(liquidType))
            if data.amount <= 0 then
                IDBFS.clearLiquid(data)
            end
            IDBFS.syncObject(obj)
            return
        end
    end
    if liquidDef and liquidDef.storageOnly == true and liquidDef.item and storedAmount > 0 then
        local inventory = playerObj and playerObj.getInventory and playerObj:getInventory() or nil
        if not inventory then
            return
        end
        inventory:AddItem(liquidDef.item)
        data.amount = storedAmount - math.min(storedAmount, IDBFS.getLiquidBatchAmount(liquidType))
        if data.amount <= 0 then
            IDBFS.clearLiquid(data)
        end
        IDBFS.syncObject(obj)
        return
    end

    local containerItem, containerInventory = findPlayerItem(playerObj, args.containerID)
    if not containerItem or not containerInventory then
        local containerEntry = findPortableContainer(playerObj)
        containerItem = containerEntry and containerEntry.item or nil
    end
    if not containerItem then
        return
    end

    if not IDBFS.canContainerAcceptLiquid(containerItem, liquidType, 0.001) then
        local containerEntry = findAvailableFluidContainer(playerObj, liquidType)
        containerItem = containerEntry and containerEntry.item or nil
    end
    if not containerItem then
        return
    end
    local fluidContainer = containerItem.getFluidContainer and containerItem:getFluidContainer() or nil
    local maxBatch = IDBFS.getLiquidBatchAmount(liquidType)
    local freeCapacity = fluidContainer and tonumber(fluidContainer:getFreeCapacity()) or 0
    local amount = math.min(storedAmount, maxBatch, freeCapacity)
    if not fluidContainer or amount <= 0 or not IDBFS.canContainerAcceptLiquid(containerItem, liquidType, amount) then
        return
    end
    if not addFluidToContainer(containerItem, liquidType, amount, data.source) then
        return
    end

    data.amount = storedAmount - amount
    if data.amount <= 0 then
        IDBFS.clearLiquid(data)
    end
    IDBFS.syncObject(obj)
end

function IDBFS.Server.startFermentation(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or not isFermentationStorage(objectType) then
        return
    end
    local data = initializeAndUpdate(obj, objectType)
    if not data or data.contaminated or isProcessing(data) then
        return
    end
    local liquidDef = IDBFS.getLiquidDef(data.liquidType)
    if not liquidDef or not liquidDef.fermentable or (tonumber(data.amount) or 0) < IDBFS.getLiquidBatchAmount(data.liquidType) then
        return
    end
    if not consumeStarterByID(playerObj, args.starterID) then
        return
    end

    local now = IDBFS.getWorldAgeHours()
    data.state = "fermenting"
    data.startedAt = now
    data.finishedAt = now + (IDBFS.Config.fermentationHours or 48)
    data.outputLiquidType = liquidDef.fermentsTo or "fermented_wash"
    data.outputSource = IDBFS.normalizeSource(data.source) or IDBFS.getSourceForLiquid(data.liquidType) or "mixed"
    data.outputItem = nil
    IDBFS.syncObject(obj)
end

function IDBFS.Server.startVinegar(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or not isFermentationStorage(objectType) then
        return
    end
    local data = initializeAndUpdate(obj, objectType)
    if not data or data.contaminated or isProcessing(data) then
        return
    end
    if (data.liquidType ~= "wine" and data.liquidType ~= "cider")
            or (tonumber(data.amount) or 0) < IDBFS.getLiquidBatchAmount(data.liquidType) then
        return
    end

    local now = IDBFS.getWorldAgeHours()
    data.state = "acetifying"
    data.startedAt = now
    data.finishedAt = now + (IDBFS.Config.vinegarHours or 96)
    data.outputLiquidType = "vinegar"
    data.outputSource = IDBFS.normalizeSource(data.source) or "fruit"
    data.outputItem = nil
    IDBFS.syncObject(obj)
end

function IDBFS.Server.startDistillation(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or objectType ~= "still" then
        return
    end
    local data = initializeAndUpdate(obj, objectType)
    if not data or isProcessing(data) then
        return
    end
    local liquidDef = IDBFS.getLiquidDef(data.liquidType)
    if not liquidDef or not liquidDef.distillable or (tonumber(data.amount) or 0) < IDBFS.getLiquidBatchAmount(data.liquidType) then
        return
    end
    local fireSource = findFireSource(playerObj, args.fireSourceID)
    if not fireSource then
        return
    end
    if not consumeFuelByID(playerObj, args.fuelID) then
        return
    end
    if not consumeFireSource(fireSource) then
        return
    end

    local amount = tonumber(data.amount) or 0
    local outputAmount = math.max(1, math.floor(amount * (liquidDef.distillYield or 0.65)))
    local outputSource = IDBFS.normalizeSource(data.source) or IDBFS.getSourceForLiquid(data.liquidType) or "mixed"
    local now = IDBFS.getWorldAgeHours()
    data.state = "distilling"
    data.startedAt = now
    data.finishedAt = now + (IDBFS.Config.distillationHours or 6)
    data.inputLiquidType = data.liquidType
    data.inputAmount = amount
    if data.liquidType == "fermented_wash" then
        local selectedOutput = args and args.outputLiquidType or nil
        if not IDBFS.isDistillationOutputAllowed(outputSource, selectedOutput) then
            selectedOutput = liquidDef.distillsTo or "distilled_alcohol"
        end
        data.outputLiquidType = selectedOutput
    else
        data.outputLiquidType = liquidDef.distillsTo or "distilled_alcohol"
    end
    data.outputSource = outputSource
    data.outputItem = nil
    data.pendingOutputAmount = outputAmount
    IDBFS.syncObject(obj)
end

function IDBFS.Server.refineBiofuel(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or not isBiofuelTank(objectType) then
        return
    end

    local data = initializeAndUpdate(obj, objectType)
    if not data or data.contaminated or isProcessing(data) then
        return
    end
    if data.liquidType ~= "ethanol" or (tonumber(data.amount) or 0) <= 0 then
        return
    end
    local oilAmount = tonumber(data.oilAdditiveAmount) or 0
    if oilAmount <= 0 then
        oilAmount = consumeOilAdditiveByID(playerObj, args.additiveID)
        if oilAmount <= 0 then
            return
        end
    end

    data.liquidType = "biofuel"
    data.amount = math.min(tonumber(data.capacity) or data.amount or 0, (tonumber(data.amount) or 0) + oilAmount)
    data.state = "stored"
    data.startedAt = nil
    data.finishedAt = nil
    data.inputLiquidType = nil
    data.inputAmount = nil
    data.outputLiquidType = nil
    data.outputSource = nil
    data.outputItem = nil
    data.pendingOutputAmount = nil
    data.oilAdditiveAmount = nil
    IDBFS.syncObject(obj)
end

function IDBFS.Server.emptyStorage(playerObj, args)
    local obj, objectType = resolveTarget(args)
    if not obj or objectType == "press" then
        return
    end
    local data = initializeAndUpdate(obj, objectType)
    if not data or isProcessing(data) then
        return
    end
    IDBFS.clearLiquid(data)
    IDBFS.syncObject(obj)
end

function IDBFS.Server.debugFill(playerObj, args)
    local accessLevel = playerObj and playerObj.getAccessLevel and playerObj:getAccessLevel() or ""
    if accessLevel ~= "Admin" then
        return
    end
    local obj, objectType = resolveTarget(args)
    if not obj or objectType == "press" then
        return
    end
    local data = initializeAndUpdate(obj, objectType)
    local liquidType = args.liquidType or "fermented_wash"
    data.liquidType = liquidType
    data.amount = math.min(tonumber(data.capacity) or 100, tonumber(args.amount) or 40)
    data.state = IDBFS.getLiquidDef(liquidType) and IDBFS.getLiquidDef(liquidType).fermentable and "raw" or "stored"
    data.source = IDBFS.getSourceForLiquid(liquidType) or "mixed"
    data.outputSource = nil
    data.outputItem = nil
    data.oilAdditiveAmount = nil
    data.contaminated = false
    IDBFS.syncObject(obj)
end

function IDBFS.Server.onClientCommand(moduleName, command, playerObj, args)
    if moduleName ~= IDBFS.MOD_ID or not args then
        return
    end
    if command == "press" then
        IDBFS.Server.press(playerObj, args)
    elseif command == "fillStorage" then
        IDBFS.Server.fillStorage(playerObj, args)
    elseif command == "takeLiquid" then
        IDBFS.Server.takeLiquid(playerObj, args)
    elseif command == "startFermentation" then
        IDBFS.Server.startFermentation(playerObj, args)
    elseif command == "startVinegar" then
        IDBFS.Server.startVinegar(playerObj, args)
    elseif command == "startDistillation" then
        IDBFS.Server.startDistillation(playerObj, args)
    elseif command == "refineBiofuel" then
        IDBFS.Server.refineBiofuel(playerObj, args)
    elseif command == "emptyStorage" then
        IDBFS.Server.emptyStorage(playerObj, args)
    elseif command == "debugFill" then
        IDBFS.Server.debugFill(playerObj, args)
    end
end

local function initializeObject(obj, allowLoot)
    local objectType = IDBFS.getObjectType(obj)
    if not objectType then
        return
    end
    IDBFS.ensureState(obj, objectType, allowLoot)
    IDBFS.updateProgress(obj)
    IDBFS.syncObject(obj)
end

local function onLoadGridsquare(square)
    if isClient and isClient() then
        return
    end
    if not square or not square.getObjects then
        return
    end
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        initializeObject(objects:get(i), true)
    end
end

local function onEveryHours()
    if isClient and isClient() then
        return
    end
    local players = {}
    if isServer and isServer() then
        local onlinePlayers = getOnlinePlayers()
        for i = 0, onlinePlayers:size() - 1 do
            table.insert(players, onlinePlayers:get(i))
        end
    else
        for i = 0, getNumActivePlayers() - 1 do
            local playerObj = getSpecificPlayer(i)
            if playerObj then
                table.insert(players, playerObj)
            end
        end
    end

    local processed = {}
    for _, playerObj in ipairs(players) do
        if playerObj and not playerObj:isDead() then
            local z = math.floor(playerObj:getZ())
            for x = math.floor(playerObj:getX()) - 20, math.floor(playerObj:getX()) + 20 do
                for y = math.floor(playerObj:getY()) - 20, math.floor(playerObj:getY()) + 20 do
                    local square = getCell():getGridSquare(x, y, z)
                    if square and square.getObjects then
                        local objects = square:getObjects()
                        for i = 0, objects:size() - 1 do
                            local obj = objects:get(i)
                            local ref = IDBFS.getObjectRef(obj)
                            local key = ref and (tostring(ref.x) .. ":" .. tostring(ref.y) .. ":" .. tostring(ref.z) .. ":" .. tostring(ref.index)) or nil
                            if key and not processed[key] and IDBFS.isFunctionalObject(obj) then
                                processed[key] = true
                                initializeObject(obj, false)
                            end
                        end
                    end
                end
            end
        end
    end
end

Events.OnClientCommand.Add(IDBFS.Server.onClientCommand)
Events.LoadGridsquare.Add(onLoadGridsquare)
Events.EveryHours.Add(onEveryHours)
