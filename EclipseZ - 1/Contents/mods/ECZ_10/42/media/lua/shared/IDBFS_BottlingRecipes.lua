IDBFS = IDBFS or {}
IDBFS.BottlingRecipes = IDBFS.BottlingRecipes or {}

IDBFS.BottlingRecipes.BlockedSourceTypes = {
    ["Base.BeerBottle"] = true,
    ["Base.Brandy"] = true,
    ["Base.Champagne"] = true,
    ["Base.Cider"] = true,
    ["Base.Gin"] = true,
    ["Base.OilOlive"] = true,
    ["Base.OilVegetable"] = true,
    ["Base.Rum"] = true,
    ["Base.Scotch"] = true,
    ["Base.Tequila"] = true,
    ["Base.Vermouth"] = true,
    ["Base.Vinegar2"] = true,
    ["Base.Vodka"] = true,
    ["Base.Whiskey"] = true,
    ["Base.Wine"] = true,
    ["Base.Wine2"] = true,
    ["Base.WineOpen"] = true,
    ["Base.Wine2Open"] = true,
    ["Base.WineAged"] = true,
    ["Base.WineScrewtop"] = true,
    ["IDBFS.DistilledAlcoholContainer"] = true,
}

local function isBlockedSource(item)
    local fullType = item and item.getFullType and item:getFullType() or nil
    return fullType and IDBFS.BottlingRecipes.BlockedSourceTypes[fullType] == true
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

local function hasBlockedSourceInRecipeData(recipeData)
    if not recipeData then
        return false
    end

    local getters = {
        "getAllInputItems",
        "getAllConsumedItems",
        "getAllKeepInputItems",
    }
    for _, getter in ipairs(getters) do
        if recipeData[getter] then
            local blocked = forEachListItem(recipeData[getter](recipeData), function(item)
                if isBlockedSource(item) then
                    return true
                end
                return nil
            end)
            if blocked then
                return true
            end
        end
    end
    return false
end

local function hasBlockedSource(value)
    if isBlockedSource(value) then
        return true
    end
    if type(value) ~= "table" and type(value) ~= "userdata" then
        return false
    end
    if value.getRecipeData and hasBlockedSourceInRecipeData(value:getRecipeData()) then
        return true
    end
    if value.recipeData and hasBlockedSourceInRecipeData(value.recipeData) then
        return true
    end
    if isBlockedSource(value.item) then
        return true
    end
    if value.items then
        return forEachListItem(value.items, function(item)
            if isBlockedSource(item) then
                return true
            end
            return nil
        end) == true
    end
    return false
end

function IDBFS_OnTestBottlingSource(...)
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if type(value) == "table" and value.shouldShowAll then
            return true
        end
        if hasBlockedSource(value) then
            return false
        end
    end
    return true
end
