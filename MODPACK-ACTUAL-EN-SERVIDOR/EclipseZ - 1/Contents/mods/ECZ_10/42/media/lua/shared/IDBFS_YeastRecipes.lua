IDBFS = IDBFS or {}

IDBFS.YEAST_MIXTURE_MATURE_HOURS = 24

local function worldAgeHours()
    if IDBFS.getWorldAgeHours then
        return IDBFS.getWorldAgeHours()
    end
    local gameTime = getGameTime and getGameTime() or nil
    if gameTime and gameTime.getWorldAgeHours then
        return gameTime:getWorldAgeHours()
    end
    return 0
end

local function isYeastMixture(item)
    return item and item.getFullType and item:getFullType() == "IDBFS.YeastMixture"
end

local function getCreatedAt(item)
    local md = item and item.getModData and item:getModData() or nil
    return tonumber(md and md.IDBFS_YeastMixtureCreatedAt) or nil
end

local function markCreated(item)
    if not isYeastMixture(item) or not item.getModData then
        return
    end
    item:getModData().IDBFS_YeastMixtureCreatedAt = worldAgeHours()
    if item.transmitModData then
        item:transmitModData()
    end
end

local function isMature(item)
    if not isYeastMixture(item) then
        return false
    end
    local createdAt = getCreatedAt(item)
    if not createdAt then
        return false
    end
    return worldAgeHours() - createdAt >= IDBFS.YEAST_MIXTURE_MATURE_HOURS
end

local function forEachListItem(items, callback)
    if not items or not items.size then
        return nil
    end
    for i = 0, items:size() - 1 do
        local result = callback(items:get(i))
        if result ~= nil then
            return result
        end
    end
    return nil
end

local function findMixtureInRecipeData(recipeData)
    if not recipeData then
        return nil
    end
    local getters = {
        "getAllInputItems",
        "getAllConsumedItems",
        "getAllKeepInputItems",
    }
    for _, getter in ipairs(getters) do
        if recipeData[getter] then
            local found = forEachListItem(recipeData[getter](recipeData), function(item)
                if isYeastMixture(item) then
                    return item
                end
                return nil
            end)
            if found then
                return found
            end
        end
    end
    return nil
end

local function findMixture(value)
    if isYeastMixture(value) then
        return value
    end
    if type(value) ~= "table" and type(value) ~= "userdata" then
        return nil
    end
    if value.getRecipeData then
        local found = findMixtureInRecipeData(value:getRecipeData())
        if found then
            return found
        end
    end
    if value.recipeData then
        local found = findMixtureInRecipeData(value.recipeData)
        if found then
            return found
        end
    end
    if value.item and isYeastMixture(value.item) then
        return value.item
    end
    if value.items then
        return forEachListItem(value.items, function(item)
            if isYeastMixture(item) then
                return item
            end
            return nil
        end)
    end
    return nil
end

function IDBFS_OnCreateYeastMixture(craftRecipeData, character)
    local createdItems = craftRecipeData and craftRecipeData.getAllCreatedItems and craftRecipeData:getAllCreatedItems() or nil
    forEachListItem(createdItems, markCreated)
end

function IDBFS_OnTestYeastMixtureReady(...)
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if type(value) == "table" and value.shouldShowAll then
            return true
        end
        local mixture = findMixture(value)
        if mixture then
            return isMature(mixture)
        end
    end
    return false
end

function IDBFS_OnCreateStarterYeast(craftRecipeData, character)
    local mixture = findMixtureInRecipeData(craftRecipeData)
    if not mixture or isMature(mixture) then
        return
    end

    local inventory = character and character.getInventory and character:getInventory() or nil
    local createdItems = craftRecipeData and craftRecipeData.getAllCreatedItems and craftRecipeData:getAllCreatedItems() or nil
    local createdAt = getCreatedAt(mixture) or worldAgeHours()

    forEachListItem(createdItems, function(item)
        if item and item.getFullType and item:getFullType() == "IDBFS.StarterYeast" then
            local container = item.getContainer and item:getContainer() or inventory
            if container and container.Remove then
                container:Remove(item)
            elseif inventory and inventory.Remove then
                inventory:Remove(item)
            end
        end
        return nil
    end)

    if inventory and inventory.AddItem then
        local replacement = inventory:AddItem("IDBFS.YeastMixture")
        if replacement and replacement.getModData then
            replacement:getModData().IDBFS_YeastMixtureCreatedAt = createdAt
            if replacement.transmitModData then
                replacement:transmitModData()
            end
        end
    end
end
