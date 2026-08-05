require "IDBFS_LiquidDefinitions"
require "IDBFS_Tiles"
require "IDBFS_MoveableTiles"
require "IDBFS_Compatibility"

IDBFS = IDBFS or {}

IDBFS.MOD_ID = "IDBFS"
IDBFS.MOD_DATA_KEY = "IDBFS"
IDBFS.INITIAL_LOOT_VERSION = 2

IDBFS.Config = IDBFS.Config or {
    fermentationHours = 48,
    vinegarHours = 96,
    distillationHours = 6,
    capacities = {
        press = 0,
        barrel = 100,
        still = 60,
        tank = 1200,
        tanker = 200,
    },
}

local function getByIndex(list, index)
    if not list or index == nil or index < 0 then
        return nil
    end
    if index < list:size() then
        return list:get(index)
    end
    return nil
end

local function getIndexInList(list, obj)
    if not list or not obj then
        return nil
    end
    for i = 0, list:size() - 1 do
        if list:get(i) == obj then
            return i
        end
    end
    return nil
end

local function getObjectItem(obj)
    if not obj then
        return nil
    end
    if obj.getItem then
        return obj:getItem()
    end
    if obj.getInventoryItem then
        return obj:getInventoryItem()
    end
    return nil
end

local function getObjectIdentity(obj)
    local item = getObjectItem(obj)
    if item and item.getFullType then
        return item:getFullType(), item.getType and item:getType() or nil, IDBFS.getSpriteName(obj)
    end
    if obj and obj.getFullType then
        return obj:getFullType(), obj.getType and obj:getType() or nil, IDBFS.getSpriteName(obj)
    end
    return nil, nil, IDBFS.getSpriteName(obj)
end

local function findByIdentity(list, ref)
    if not list or not ref then
        return nil
    end
    for i = 0, list:size() - 1 do
        local candidate = list:get(i)
        local fullType, itemType, sprite = getObjectIdentity(candidate)
        if ref.fullType and fullType == ref.fullType then
            return candidate
        end
        if ref.itemType and itemType == ref.itemType then
            return candidate
        end
        if ref.sprite and sprite == ref.sprite then
            return candidate
        end
    end
    return nil
end

local function text(key, fallback)
    if getText then
        local value = getText(key)
        if value and value ~= key then
            return value
        end
    end
    return fallback or key
end

local function canonicalObject(obj)
    if obj and IDBFS.getCompositeAnchor then
        return IDBFS.getCompositeAnchor(obj) or obj
    end
    return obj
end

local function getRawData(obj, create)
    if not obj or not obj.getModData then
        return nil
    end
    local md = obj:getModData()
    if type(md[IDBFS.MOD_DATA_KEY]) ~= "table" and create ~= false then
        md[IDBFS.MOD_DATA_KEY] = {}
    end
    return md[IDBFS.MOD_DATA_KEY]
end

local function migrateCompositeData(anchorData, oldData)
    if type(anchorData) ~= "table" or type(oldData) ~= "table" then
        return false
    end
    local oldAmount = tonumber(oldData.amount) or 0
    local oldOilAmount = tonumber(oldData.oilAdditiveAmount) or 0
    local anchorAmount = tonumber(anchorData.amount) or 0
    local anchorOilAmount = tonumber(anchorData.oilAdditiveAmount) or 0
    if oldData.initialized ~= true or (oldAmount <= 0 and oldOilAmount <= 0) then
        return false
    end
    if anchorData.initialized == true and (anchorAmount > 0 or anchorOilAmount > 0) then
        return false
    end
    for key, value in pairs(oldData) do
        anchorData[key] = value
    end
    oldData.amount = 0
    oldData.oilAdditiveAmount = nil
    oldData.state = "empty"
    oldData.liquidType = nil
    oldData.source = nil
    oldData.outputLiquidType = nil
    oldData.outputSource = nil
    oldData.outputItem = nil
    oldData.pendingOutputAmount = nil
    oldData.inputLiquidType = nil
    oldData.inputAmount = nil
    oldData.migratedToCompositeAnchor = true
    return true
end

function IDBFS.getWorldAgeHours()
    local gameTime = getGameTime and getGameTime() or nil
    if gameTime and gameTime.getWorldAgeHours then
        return gameTime:getWorldAgeHours()
    end
    return 0
end

function IDBFS.getObjectRef(obj)
    obj = canonicalObject(obj)
    if not obj or not obj.getSquare then
        return nil
    end
    local square = obj:getSquare()
    if not square then
        return nil
    end
    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
    local objects = square.getObjects and square:getObjects() or nil
    local worldIndex = getIndexInList(worldObjects, obj)
    local objectIndex = getIndexInList(objects, obj)
    local fullType, itemType, sprite = getObjectIdentity(obj)

    return {
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
        worldIndex = worldIndex,
        objectIndex = objectIndex,
        index = worldIndex or objectIndex or -1,
        isWorldObject = worldIndex ~= nil,
        fullType = fullType,
        itemType = itemType,
        sprite = sprite,
        objectType = IDBFS.getObjectType(obj),
    }
end

function IDBFS.resolveObjectRef(ref)
    if not ref then
        return nil
    end
    local square = getCell():getGridSquare(ref.x, ref.y, ref.z)
    if not square then
        return nil
    end
    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
    local objects = square.getObjects and square:getObjects() or nil

    local obj = nil
    if ref.isWorldObject then
        obj = getByIndex(worldObjects, ref.worldIndex)
            or getByIndex(worldObjects, ref.index)
            or findByIdentity(worldObjects, ref)
    else
        obj = getByIndex(objects, ref.objectIndex)
            or getByIndex(objects, ref.index)
            or findByIdentity(objects, ref)
            or findByIdentity(worldObjects, ref)
    end

    return canonicalObject(obj)
end

function IDBFS.getCapacityForType(objectType)
    local capacities = IDBFS.Config and IDBFS.Config.capacities or {}
    return capacities[objectType] or 0
end

function IDBFS.getData(obj, create)
    local originalObj = obj
    obj = canonicalObject(obj)
    local data = getRawData(obj, create)
    if obj ~= originalObj then
        local oldData = getRawData(originalObj, false)
        if migrateCompositeData(data, oldData) then
            if obj and obj.transmitModData then
                obj:transmitModData()
            end
            if originalObj and originalObj.transmitModData then
                originalObj:transmitModData()
            end
        end
    end
    return data
end

local function getRoomName(obj)
    local square = obj and obj.getSquare and obj:getSquare() or nil
    local room = square and square.getRoom and square:getRoom() or nil
    local name = room and room.getName and room:getName() or nil
    return type(name) == "string" and string.lower(name) or ""
end

function IDBFS.isWorldLootEligible(obj, objectType)
    if objectType ~= "barrel" and objectType ~= "tanker" and objectType ~= "tank" then
        return false
    end
    if obj and obj.getModData then
        local data = IDBFS.getData(obj, false)
        if data and data.createdByIDBFS == true then
            return false
        end
    end
    return true
end

local function rand(max)
    if max <= 0 then
        return 0
    end
    return ZombRand and ZombRand(max) or 0
end

local function randRange(min, max)
    min = math.floor(tonumber(min) or 0)
    max = math.floor(tonumber(max) or min)
    if max <= min then
        return min
    end
    return ZombRand and ZombRand(min, max + 1) or min
end

local function pick(list)
    if not list or #list == 0 then
        return nil
    end
    return list[rand(#list) + 1]
end

local function setInitialLoot(data, liquidType, amount, state, source)
    data.liquidType = liquidType
    data.amount = math.min(tonumber(data.capacity) or amount, tonumber(amount) or 0)
    data.state = state or "stored"
    data.source = IDBFS.normalizeSource(source) or IDBFS.getSourceForLiquid(liquidType)
    data.contaminated = false
    data.outputLiquidType = nil
    data.outputSource = nil
    data.outputItem = nil
    data.pendingOutputAmount = nil
    data.inputLiquidType = nil
    data.inputAmount = nil
    data.oilAdditiveAmount = nil
    return data.amount > 0
end

local function randomBatchAmount(minAmount, maxAmount, batch)
    batch = math.max(1, tonumber(batch) or IDBFS.LIQUID_BATCH_AMOUNT or 10)
    local minBatches = math.max(1, math.ceil((tonumber(minAmount) or batch) / batch))
    local maxBatches = math.max(minBatches, math.floor((tonumber(maxAmount) or minAmount or batch) / batch))
    return randRange(minBatches, maxBatches) * batch
end

function IDBFS.applyInitialLoot(obj, objectType, data)
    if data and data.createdByIDBFS == true then
        return false
    end
    if not IDBFS.isWorldLootEligible(obj, objectType) then
        return false
    end
    local roll = ZombRand and ZombRand(100) or 100
    local batch = IDBFS.LIQUID_BATCH_AMOUNT or 10
    local capacity = tonumber(data.capacity) or IDBFS.getCapacityForType(objectType)

    if objectType == "barrel" or objectType == "tanker" then
        if roll >= 45 then
            return false
        end

        local amount = randRange(1, math.max(1, math.floor(capacity / batch))) * batch
        if roll < 14 then
            local liquidType = pick({ "fruit_mash", "grain_mash", "corn_mash", "potato_mash", "sugar_wash" })
            return setInitialLoot(data, liquidType, amount, "raw")
        elseif roll < 24 then
            local source = pick({ "fruit", "grain", "corn", "potato", "sugar" })
            return setInitialLoot(data, "fermented_wash", amount, "fermented", source)
        elseif roll < 36 then
            local liquidType = pick({
                "wine",
                "brandy",
                "champagne",
                "cider",
                "vermouth",
                "whiskey",
                "scotch",
                "gin",
                "beer",
                "vodka",
                "rum",
                "tequila",
                "distilled_alcohol",
            })
            return setInitialLoot(data, liquidType, amount, "stored")
        else
            local liquidType = pick({ "sunflower_oil", "olive_oil" })
            return setInitialLoot(data, liquidType, amount, "stored")
        end
    elseif objectType == "tank" then
        if roll < 18 then
            local maxAmount = math.max(batch, math.floor(capacity * 0.65))
            local amount = randomBatchAmount(math.min(80, maxAmount), maxAmount, batch)
            return setInitialLoot(data, "ethanol", amount, "stored")
        elseif roll < 30 then
            local maxAmount = math.max(batch, math.floor(capacity * 0.45))
            local amount = randomBatchAmount(math.min(60, maxAmount), maxAmount, batch)
            return setInitialLoot(data, "biofuel", amount, "stored")
        end
    end
    return false
end

function IDBFS.ensureState(obj, objectType, allowLoot)
    obj = canonicalObject(obj)
    if not obj then
        return nil
    end
    objectType = IDBFS.getObjectType(obj) or objectType
    if not objectType then
        return nil
    end
    local data = IDBFS.getData(obj, true)
    if data.initialized ~= true then
        data.initialized = true
        data.objectType = objectType
        data.capacity = IDBFS.getCapacityForType(objectType)
        data.amount = tonumber(data.amount) or 0
        data.state = data.amount > 0 and (data.state or "stored") or (data.state or "empty")
        data.contaminated = data.contaminated == true
        data.createdAt = IDBFS.getWorldAgeHours()
        if allowLoot and data.initialLootRolled ~= true then
            data.initialLootRolled = true
            data.initialLootVersion = IDBFS.INITIAL_LOOT_VERSION
            IDBFS.applyInitialLoot(obj, objectType, data)
        end
    else
        data.objectType = data.objectType or objectType
        data.capacity = tonumber(data.capacity) or IDBFS.getCapacityForType(objectType)
        data.amount = tonumber(data.amount) or 0
        data.state = data.state or (data.amount > 0 and "stored" or "empty")
        local needsInitialLootRoll = data.initialLootRolled ~= true
            or data.initialLootVersion ~= IDBFS.INITIAL_LOOT_VERSION
        if allowLoot and needsInitialLootRoll and data.createdByIDBFS ~= true and data.amount <= 0 then
            data.initialLootRolled = true
            data.initialLootVersion = IDBFS.INITIAL_LOOT_VERSION
            IDBFS.applyInitialLoot(obj, objectType, data)
        end
    end
    return data
end

function IDBFS.syncObject(obj)
    obj = canonicalObject(obj)
    if obj and obj.transmitModData then
        obj:transmitModData()
    end
end

function IDBFS.clearLiquid(data)
    data.liquidType = nil
    data.amount = 0
    data.state = "empty"
    data.source = nil
    data.startedAt = nil
    data.finishedAt = nil
    data.outputLiquidType = nil
    data.outputSource = nil
    data.outputItem = nil
    data.pendingOutputAmount = nil
    data.inputLiquidType = nil
    data.inputAmount = nil
    data.oilAdditiveAmount = nil
    data.contaminated = false
end

function IDBFS.getStateLabel(state)
    if not state then
        return text("State_IDBFS_unknown", "unknown")
    end
    return text("State_IDBFS_" .. tostring(state), tostring(state))
end

function IDBFS.canAddLiquid(data, liquidType, amount)
    if not data or not liquidType or amount <= 0 then
        return false
    end
    local capacity = tonumber(data.capacity) or 0
    local current = tonumber(data.amount) or 0
    if capacity > 0 and current >= capacity then
        return false
    end
    if current > 0 and data.liquidType and data.liquidType ~= liquidType then
        return false
    end
    return true
end

function IDBFS.addLiquid(data, liquidType, amount, source)
    if not IDBFS.canAddLiquid(data, liquidType, amount) then
        return 0
    end
    local capacity = tonumber(data.capacity) or amount
    local current = tonumber(data.amount) or 0
    local add = math.min(amount, math.max(0, capacity - current))
    if add <= 0 then
        return 0
    end
    data.liquidType = liquidType
    data.amount = current + add
    local liquidSource = IDBFS.normalizeSource(source) or IDBFS.getSourceForLiquid(liquidType)
    if current <= 0 then
        data.source = liquidSource
        data.outputItem = nil
    elseif liquidSource and data.source and data.source ~= liquidSource then
        data.source = "mixed"
    elseif not data.source and liquidSource then
        data.source = liquidSource
    end
    if not data.state or data.state == "empty" then
        local def = IDBFS.getLiquidDef(liquidType)
        data.state = def and def.fermentable and "raw" or "stored"
    end
    return add
end

function IDBFS.contaminate(data, liquidType, amount)
    data.liquidType = "tainted_wash"
    data.amount = math.min(tonumber(data.capacity) or amount, (tonumber(data.amount) or 0) + (tonumber(amount) or 0))
    data.state = "contaminated"
    data.source = "mixed"
    data.outputSource = nil
    data.outputItem = nil
    data.oilAdditiveAmount = nil
    data.contaminated = true
end

function IDBFS.updateProgress(obj)
    obj = canonicalObject(obj)
    if not obj then
        return false
    end
    local objectType = IDBFS.getObjectType(obj)
    local data = IDBFS.ensureState(obj, objectType, false)
    if not data then
        return false
    end
    local now = IDBFS.getWorldAgeHours()
    local changed = false

    if data.state == "fermenting" and data.finishedAt and now >= tonumber(data.finishedAt) then
        data.liquidType = data.outputLiquidType or "fermented_wash"
        data.outputLiquidType = nil
        data.source = IDBFS.normalizeSource(data.outputSource) or IDBFS.normalizeSource(data.source) or "mixed"
        data.outputSource = nil
        data.state = "fermented"
        changed = true
    elseif data.state == "acetifying" and data.finishedAt and now >= tonumber(data.finishedAt) then
        data.liquidType = data.outputLiquidType or "vinegar"
        data.outputLiquidType = nil
        data.source = IDBFS.normalizeSource(data.outputSource) or IDBFS.normalizeSource(data.source) or "fruit"
        data.outputSource = nil
        data.state = "stored"
        changed = true
    elseif data.state == "distilling" and data.finishedAt and now >= tonumber(data.finishedAt) then
        data.liquidType = data.outputLiquidType or "distilled_alcohol"
        data.amount = tonumber(data.pendingOutputAmount) or math.floor((tonumber(data.amount) or 0) * 0.65)
        data.source = IDBFS.normalizeSource(data.outputSource) or IDBFS.normalizeSource(data.source) or "mixed"
        data.outputLiquidType = nil
        data.outputSource = nil
        data.pendingOutputAmount = nil
        data.inputLiquidType = nil
        data.inputAmount = nil
        data.state = "distilled"
        data.contaminated = false
        changed = true
    end

    if changed then
        IDBFS.syncObject(obj)
    end
    return changed
end

function IDBFS.getStateDescription(obj)
    obj = canonicalObject(obj)
    local objectType = IDBFS.getObjectType(obj)
    local data = IDBFS.ensureState(obj, objectType, false)
    if not data then
        return text("Tooltip_IDBFS_NoState", "No distillery state.")
    end
    local amount = math.floor((tonumber(data.amount) or 0) + 0.5)
    local capacity = math.floor((tonumber(data.capacity) or 0) + 0.5)
    if amount <= 0 then
        return text("Tooltip_IDBFS_Empty", "Empty") .. " ("
            .. text("Tooltip_IDBFS_Capacity", "capacity")
            .. ": " .. tostring(capacity) .. " "
            .. text("Tooltip_IDBFS_Units", "units") .. ")"
    end
    local legacyOutputLiquid = data.outputItem and data.state == "distilled" and IDBFS.getDistilledLiquidForItem(data.outputItem) or nil
    local liquidLabel = IDBFS.getLiquidLabel(data.liquidType)
    if legacyOutputLiquid then
        liquidLabel = IDBFS.getLiquidLabel(legacyOutputLiquid)
    elseif data.outputItem and data.state == "distilled" then
        liquidLabel = IDBFS.getItemDisplayName(data.outputItem)
    end
    local textValue = liquidLabel .. ": " .. tostring(amount) .. "/" .. tostring(capacity) .. " " .. text("Tooltip_IDBFS_Units", "units")
    if data.state then
        textValue = textValue .. " <LINE> " .. text("Tooltip_IDBFS_State", "State") .. ": " .. IDBFS.getStateLabel(data.state)
    end
    if data.source then
        textValue = textValue .. " <LINE> " .. text("Tooltip_IDBFS_Source", "Source") .. ": " .. IDBFS.getSourceLabel(data.source)
    end
    if (tonumber(data.oilAdditiveAmount) or 0) > 0 then
        textValue = textValue .. " <LINE> " .. text("Tooltip_IDBFS_OilAdditive", "Oil additive") .. ": "
            .. tostring(math.floor((tonumber(data.oilAdditiveAmount) or 0) + 0.5)) .. " "
            .. text("Tooltip_IDBFS_Units", "units")
    end
    if data.finishedAt and (data.state == "fermenting" or data.state == "acetifying" or data.state == "distilling") then
        local remaining = math.max(0, tonumber(data.finishedAt) - IDBFS.getWorldAgeHours())
        textValue = textValue .. " <LINE> " .. text("Tooltip_IDBFS_TimeRemaining", "Time remaining") .. ": " .. tostring(math.ceil(remaining)) .. " " .. text("Tooltip_IDBFS_Hours", "hours")
    end
    if data.contaminated then
        textValue = textValue .. " <LINE> " .. text("Tooltip_IDBFS_Contaminated", "Contaminated")
    end
    return textValue
end
