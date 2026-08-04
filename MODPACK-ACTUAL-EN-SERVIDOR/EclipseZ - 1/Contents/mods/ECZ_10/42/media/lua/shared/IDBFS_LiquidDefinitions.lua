IDBFS = IDBFS or {}
IDBFS.LIQUID_BATCH_AMOUNT = 10

local function text(key, fallback)
    if getText then
        local value = getText(key)
        if value and value ~= key then
            return value
        end
    end
    return fallback or key
end

IDBFS.Liquids = {
    fruit_mash = {
        label = "Fruit Mash",
        fluidType = "IDBFSFruitMash",
        source = "fruit",
        fermentable = true,
        fermentsTo = "fermented_wash",
        item = "IDBFS.MashContainer_Fruit",
        amountPerItem = 10,
    },
    grain_mash = {
        label = "Grain Mash",
        fluidType = "IDBFSGrainMash",
        source = "grain",
        fermentable = true,
        fermentsTo = "fermented_wash",
        item = "IDBFS.MashContainer_Grain",
        amountPerItem = 10,
    },
    corn_mash = {
        label = "Corn Mash",
        fluidType = "IDBFSCornMash",
        source = "corn",
        fermentable = true,
        fermentsTo = "fermented_wash",
        item = "IDBFS.MashContainer_Corn",
        amountPerItem = 10,
    },
    potato_mash = {
        label = "Potato Mash",
        fluidType = "IDBFSPotatoMash",
        source = "potato",
        fermentable = true,
        fermentsTo = "fermented_wash",
        item = "IDBFS.MashContainer_Potato",
        amountPerItem = 10,
    },
    sugar_wash = {
        label = "Sugar Wash",
        fluidType = "IDBFSSugarWash",
        source = "sugar",
        fermentable = true,
        fermentsTo = "fermented_wash",
        item = "IDBFS.WashContainer_Sugar",
        amountPerItem = 10,
    },
    fermented_wash = {
        label = "Fermented Wash",
        fluidType = "IDBFSFermentedWash",
        distillable = true,
        distillsTo = "distilled_alcohol",
        distillYield = 0.65,
        item = "IDBFS.FermentedLiquid",
        amountPerItem = 10,
    },
    distilled_alcohol = {
        label = "Distilled Alcohol",
        fluidType = "IDBFSDistilledAlcohol",
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        item = "IDBFS.DistilledAlcoholContainer",
        amountPerItem = 10,
    },
    ethanol = {
        label = "Ethanol",
        fluidType = "IDBFSEthanol",
        fuel = true,
        fuelEfficiency = 0.70,
        item = "IDBFS.EthanolContainer",
        amountPerItem = 10,
    },
    biofuel = {
        label = "Biofuel",
        fluidType = "IDBFSBiofuel",
        fuel = true,
        fuelEfficiency = 0.27,
        item = "IDBFS.BiofuelContainer",
        amountPerItem = 10,
    },
    beer = {
        label = "Beer",
        fluidType = "Beer",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    whiskey = {
        label = "Whiskey",
        fluidType = "Whiskey",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    wine = {
        label = "Wine",
        fluidType = "Wine",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    vinegar = {
        label = "Vinegar",
        fluidType = "IDBFSVinegar",
        source = "fruit",
        amountPerItem = 10,
    },
    rum = {
        label = "Rum",
        fluidType = "Rum",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    vodka = {
        label = "Vodka",
        fluidType = "Vodka",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    brandy = {
        label = "Brandy",
        fluidType = "Brandy",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    champagne = {
        label = "Champagne",
        fluidType = "Champagne",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    cider = {
        label = "Cider",
        fluidType = "Cider",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    gin = {
        label = "Gin",
        fluidType = "Gin",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    tequila = {
        label = "Tequila",
        fluidType = "Tequila",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    vermouth = {
        label = "Vermouth",
        fluidType = "Vermouth",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    scotch = {
        label = "Scotch",
        fluidType = "Scotch",
        alcoholic = true,
        distillable = true,
        distillsTo = "ethanol",
        distillYield = 0.75,
        amountPerItem = 10,
    },
    sunflower_oil = {
        label = "Sunflower Oil",
        fluidType = "IDBFSSunflowerOil",
        amountPerItem = 10,
        oilAdditive = true,
    },
    olive_oil = {
        label = "Olive Oil",
        fluidType = "IDBFSOliveOil",
        amountPerItem = 10,
        oilAdditive = true,
    },
    vegetable_oil = {
        label = "Sunflower Oil",
        fluidType = "IDBFSSunflowerOil",
        amountPerItem = 10,
        oilAdditive = true,
    },
    tainted_wash = {
        label = "Tainted Wash",
        fluidType = "IDBFSTaintedWash",
        contaminated = true,
        distillable = true,
        distillsTo = "distilled_alcohol",
        distillYield = 0.65,
        item = "IDBFS.MashContainer",
        amountPerItem = 10,
    },

    -- Short aliases kept for other add-ons that follow the early design notes.
    fermented = {
        label = "Fermented Liquid",
        fluidType = "IDBFSFermentedWash",
        distillable = true,
        distillsTo = "distilled_alcohol",
        distillYield = 0.65,
        item = "IDBFS.FermentedLiquid",
        amountPerItem = 10,
    },
}

IDBFS.SourceLabels = {
    fruit = "Fruit",
    grain = "Grain",
    corn = "Corn",
    potato = "Potato",
    sugar = "Sugar",
    mixed = "Mixed",
}

IDBFS.DistilledProducts = {
    fruit = {
        "wine",
        "brandy",
        "champagne",
        "cider",
        "vermouth",
        "distilled_alcohol",
    },
    grain = {
        "whiskey",
        "scotch",
        "gin",
        "beer",
        "vodka",
        "distilled_alcohol",
    },
    corn = {
        "whiskey",
        "scotch",
        "gin",
        "beer",
        "vodka",
        "distilled_alcohol",
    },
    potato = {
        "vodka",
        "distilled_alcohol",
    },
    sugar = {
        "rum",
        "tequila",
        "vodka",
        "distilled_alcohol",
    },
    mixed = {
        "vodka",
        "distilled_alcohol",
    },
}

IDBFS.ItemDistilledLiquids = {
    ["Base.BeerBottle"] = "beer",
    ["Base.Brandy"] = "brandy",
    ["Base.Champagne"] = "champagne",
    ["Base.Cider"] = "cider",
    ["Base.Gin"] = "gin",
    ["Base.Rum"] = "rum",
    ["Base.Scotch"] = "scotch",
    ["Base.Tequila"] = "tequila",
    ["Base.Vermouth"] = "vermouth",
    ["Base.Vodka"] = "vodka",
    ["Base.Whiskey"] = "whiskey",
    ["Base.WhiskeyFull"] = "whiskey",
    ["Base.Wine"] = "wine",
    ["Base.Wine2"] = "wine",
}

IDBFS.ItemLiquids = {
    ["IDBFS.MashContainer"] = { liquidType = "fruit_mash", amount = 10 },
    ["IDBFS.MashContainer_Fruit"] = { liquidType = "fruit_mash", amount = 10 },
    ["IDBFS.MashContainer_Grain"] = { liquidType = "grain_mash", amount = 10 },
    ["IDBFS.MashContainer_Corn"] = { liquidType = "corn_mash", amount = 10 },
    ["IDBFS.MashContainer_Potato"] = { liquidType = "potato_mash", amount = 10 },
    ["IDBFS.WashContainer_Sugar"] = { liquidType = "sugar_wash", amount = 10 },
    ["IDBFS.FermentedLiquid"] = { liquidType = "fermented_wash", amount = 10 },
    ["IDBFS.FermentedLiquidContainer"] = { liquidType = "fermented_wash", amount = 10 },
    ["IDBFS.DistilledAlcoholContainer"] = { liquidType = "distilled_alcohol", amount = 10 },
    ["IDBFS.Ethanol"] = { liquidType = "ethanol", amount = 10 },
    ["IDBFS.EthanolContainer"] = { liquidType = "ethanol", amount = 10 },
    ["IDBFS.Biofuel"] = { liquidType = "biofuel", amount = 10 },
    ["IDBFS.BiofuelContainer"] = { liquidType = "biofuel", amount = 10 },
    ["Base.OilVegetable"] = { liquidType = "sunflower_oil", amount = 1 },
    ["Base.OilOlive"] = { liquidType = "olive_oil", amount = 1 },
}

IDBFS.CanonicalLiquidTypes = {
    "fruit_mash",
    "grain_mash",
    "corn_mash",
    "potato_mash",
    "sugar_wash",
    "fermented_wash",
    "distilled_alcohol",
    "ethanol",
    "biofuel",
    "beer",
    "whiskey",
    "wine",
    "vinegar",
    "rum",
    "vodka",
    "brandy",
    "champagne",
    "cider",
    "gin",
    "tequila",
    "vermouth",
    "scotch",
    "sunflower_oil",
    "olive_oil",
    "tainted_wash",
}

IDBFS.PressContainerTypes = {
    ["Base.BucketEmpty"] = true,
    ["Base.Bucket"] = true,
    ["Base.BucketWood"] = true,
    ["Base.BucketLargeWood"] = true,
    ["Base.BucketCarved"] = true,
    ["Base.BucketForged"] = true,
    ["Base.PaintbucketEmpty"] = true,
}

IDBFS.LegacyContainerTypes = {
    ["IDBFS.LiquidContainerEmpty"] = true,
    ["IDBFS.EmptyJug"] = true,
    ["IDBFS.EmptyCanister"] = true,
    ["IDBFS.TransferContainer"] = true,
}

IDBFS.PressRecipes = {
    fruit = {
        label = "Fruit Mash",
        liquidType = "fruit_mash",
        output = "IDBFS.MashContainer_Fruit",
        amount = 10,
        ingredients = {
            { count = 5, anyOf = {
                "Base.Apple", "Base.BerryBlack", "Base.BerryBlue", "Base.BerryGeneric1",
                "Base.BerryGeneric2", "Base.BerryGeneric3", "Base.BerryGeneric4",
                "Base.BerryGeneric5", "Base.BeautyBerry", "Base.Cherry", "Base.Grapefruit",
                "Base.Grapes", "Base.Peach", "Base.Pear", "Base.Strewberrie",
                "Base.WinterBerry",
            } },
        },
    },
    grain = {
        label = "Grain Mash",
        liquidType = "grain_mash",
        output = "IDBFS.MashContainer_Grain",
        amount = 10,
        needsWater = true,
        waterAmount = 0.25,
        ingredients = {
            { count = 1, anyOf = {
                "Base.BarleySheafDried",
                "Base.RyeSheafDried",
                "Base.WheatSheafDried",
            } },
        },
    },
    corn = {
        label = "Corn Mash",
        liquidType = "corn_mash",
        output = "IDBFS.MashContainer_Corn",
        amount = 10,
        ingredients = {
            { count = 4, anyOf = { "Base.Corn" } },
        },
    },
    potato = {
        label = "Potato Mash",
        liquidType = "potato_mash",
        output = "IDBFS.MashContainer_Potato",
        amount = 10,
        ingredients = {
            { count = 4, anyOf = { "Base.Potato" } },
        },
    },
    sugar = {
        label = "Sugar Wash",
        liquidType = "sugar_wash",
        output = "IDBFS.WashContainer_Sugar",
        amount = 10,
        needsWater = true,
        waterAmount = 0.25,
        ingredients = {
            { count = 1, anyOf = { "Base.Sugar" }, tags = { "base:sugar" } },
        },
    },
    sunflower_oil = {
        label = "Sunflower Oil",
        liquidType = "sunflower_oil",
        amount = 10,
        ingredients = {
            { count = 4, anyOf = { "Base.SunflowerHeadDried", "Base.Corn" } },
        },
    },
    olive_oil = {
        label = "Olive Oil",
        liquidType = "olive_oil",
        amount = 10,
        ingredients = {
            { count = 2, anyOf = { "Base.Olives" } },
        },
    },
}

local function getItemData(item, create)
    if not item or not item.getModData then
        return nil
    end
    local md = item:getModData()
    local key = IDBFS.MOD_DATA_KEY or "IDBFS"
    if type(md[key]) ~= "table" and create ~= false then
        md[key] = {}
    end
    return md[key]
end

function IDBFS.normalizeSource(source)
    if not source then
        return nil
    end
    source = tostring(source)
    if IDBFS.SourceLabels[source] then
        return source
    end
    return nil
end

function IDBFS.getSourceForLiquid(liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    return IDBFS.normalizeSource(def and def.source)
end

function IDBFS.getSourceLabel(source)
    source = IDBFS.normalizeSource(source) or "mixed"
    local key = "FluidSource_IDBFS_" .. source
    local value = text(key, nil)
    if value and value ~= key then
        return value
    end
    return IDBFS.SourceLabels[source] or source
end

function IDBFS.getItemSource(item)
    local data = getItemData(item, false)
    return IDBFS.normalizeSource(data and data.source)
end

function IDBFS.setItemSource(item, source)
    local normalized = IDBFS.normalizeSource(source)
    local data = getItemData(item, normalized ~= nil)
    if not data then
        return
    end
    data.source = normalized
end

function IDBFS.clearItemSource(item)
    local data = getItemData(item, false)
    if data then
        data.source = nil
    end
end

function IDBFS.getDistilledLiquid(source)
    source = IDBFS.normalizeSource(source) or "mixed"
    local products = IDBFS.DistilledProducts[source] or IDBFS.DistilledProducts.mixed
    if not products or #products == 0 then
        return nil
    end
    local index = 1
    if ZombRand and #products > 1 then
        index = ZombRand(#products) + 1
    end
    return products[index]
end

function IDBFS.getDistillationOutputs(source)
    source = IDBFS.normalizeSource(source) or "mixed"
    return IDBFS.DistilledProducts[source] or IDBFS.DistilledProducts.mixed or {}
end

function IDBFS.isDistillationOutputAllowed(source, liquidType)
    if not liquidType or not IDBFS.getLiquidDef(liquidType) then
        return false
    end
    for _, candidate in ipairs(IDBFS.getDistillationOutputs(source)) do
        if candidate == liquidType then
            return true
        end
    end
    return false
end

function IDBFS.getDistilledProduct(source)
    return IDBFS.getDistilledLiquid(source)
end

function IDBFS.getDistilledLiquidForItem(itemOrFullType)
    local fullType = itemOrFullType
    if type(itemOrFullType) ~= "string" and itemOrFullType and itemOrFullType.getFullType then
        fullType = itemOrFullType:getFullType()
    end
    return fullType and IDBFS.ItemDistilledLiquids and IDBFS.ItemDistilledLiquids[fullType] or nil
end

function IDBFS.getItemDisplayName(fullType)
    if not fullType then
        return nil
    end
    local scriptItem = getScriptManager and getScriptManager():FindItem(fullType) or nil
    if scriptItem and scriptItem.getDisplayName then
        return scriptItem:getDisplayName()
    end
    return tostring(fullType)
end

function IDBFS.getLiquidDef(liquidType)
    return liquidType and IDBFS.Liquids and IDBFS.Liquids[liquidType] or nil
end

function IDBFS.canObjectStoreLiquid(objectType, liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    if not objectType or not def then
        return false
    end
    if objectType == "still" then
        return def.distillable == true
    end
    if objectType == "tank" then
        return liquidType == "distilled_alcohol"
            or liquidType == "ethanol"
            or liquidType == "biofuel"
            or def.alcoholic == true
    end
    if objectType == "barrel" or objectType == "tanker" then
        return liquidType ~= "ethanol" and liquidType ~= "biofuel"
    end
    return true
end

function IDBFS.getLiquidBatchAmount(liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    return tonumber(def and def.amountPerItem) or IDBFS.LIQUID_BATCH_AMOUNT or 10
end

function IDBFS.getLiquidLabel(liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    if liquidType then
        local key = "Fluid_IDBFS_" .. tostring(liquidType)
        local value = text(key, nil)
        if value and value ~= key then
            return value
        end
    end
    return def and def.label or tostring(liquidType or "Unknown")
end

function IDBFS.getLiquidForItem(itemOrFullType)
    local fullType = itemOrFullType
    if type(itemOrFullType) ~= "string" and itemOrFullType and itemOrFullType.getFullType then
        fullType = itemOrFullType:getFullType()
    end
    return fullType and IDBFS.ItemLiquids and IDBFS.ItemLiquids[fullType] or nil
end

function IDBFS.isOilAdditiveLiquid(liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    return def and def.oilAdditive == true
end

function IDBFS.getOilAdditiveForItem(itemOrFullType)
    local liquidInfo = nil
    if type(itemOrFullType) ~= "string" then
        liquidInfo = IDBFS.getLiquidForFluidContainer(itemOrFullType)
    end
    liquidInfo = liquidInfo or IDBFS.getLiquidForItem(itemOrFullType)
    local def = liquidInfo and IDBFS.getLiquidDef(liquidInfo.liquidType) or nil
    if def and def.oilAdditive == true then
        return liquidInfo, def
    end
    return nil, nil
end

function IDBFS.getFluidTypeForLiquid(liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    return def and def.fluidType or nil
end

function IDBFS.getLiquidForFluidType(fluidType)
    if not fluidType then
        return nil
    end
    local fluidName = tostring(fluidType)
    local lowerName = string.lower(fluidName)
    local shortName = string.match(fluidName, "%.([^%.]+)$")
    local lowerShortName = shortName and string.lower(shortName) or nil
    for _, liquidType in ipairs(IDBFS.CanonicalLiquidTypes or {}) do
        local def = IDBFS.Liquids and IDBFS.Liquids[liquidType] or nil
        if def and def.fluidType and (fluidName == def.fluidType or lowerName == string.lower(def.fluidType)
                or shortName == def.fluidType or lowerShortName == string.lower(def.fluidType)) then
            return liquidType
        end
    end
    for liquidType, def in pairs(IDBFS.Liquids or {}) do
        if def.fluidType and (fluidName == def.fluidType or lowerName == string.lower(def.fluidType)
                or shortName == def.fluidType or lowerShortName == string.lower(def.fluidType)) then
            return liquidType
        end
    end
    return nil
end

function IDBFS.getLiquidForFluidContainer(itemOrContainer)
    local fluidContainer = nil
    if itemOrContainer and itemOrContainer.getFluidContainer then
        fluidContainer = itemOrContainer:getFluidContainer()
    elseif itemOrContainer and itemOrContainer.getPrimaryFluid then
        fluidContainer = itemOrContainer
    end
    if not fluidContainer or fluidContainer:isEmpty() then
        return nil
    end

    local primary = fluidContainer:getPrimaryFluid()
    local liquidType = primary and IDBFS.getLiquidForFluidType(primary:getFluidTypeString()) or nil
    if not liquidType then
        return nil
    end

    local amount = fluidContainer.getPrimaryFluidAmount and fluidContainer:getPrimaryFluidAmount() or fluidContainer:getAmount()
    return {
        liquidType = liquidType,
        amount = amount,
        fluidContainer = fluidContainer,
    }
end

function IDBFS.isLiquidItem(itemOrFullType)
    return IDBFS.getLiquidForItem(itemOrFullType) ~= nil
end

local function getFullType(itemOrFullType)
    local fullType = itemOrFullType
    if type(itemOrFullType) ~= "string" and itemOrFullType and itemOrFullType.getFullType then
        fullType = itemOrFullType:getFullType()
    end
    return fullType
end

local function hasTag(tags, tagName)
    if not tags then
        return false
    end
    local wanted = string.lower(tostring(tagName))
    local okContains, contains = pcall(function()
        return tags.contains and tags:contains(tagName)
    end)
    if okContains and contains then
        return true
    end

    local okSize, size = pcall(function()
        return tags.size and tags:size() or 0
    end)
    if okSize and tonumber(size) and tonumber(size) > 0 then
        for i = 0, tonumber(size) - 1 do
            local okTag, tag = pcall(function()
                return tags:get(i)
            end)
            tag = okTag and tag and tostring(tag) or nil
            if tag and string.lower(tag) == wanted then
                return true
            end
        end
    end

    return false
end

function IDBFS.hasItemTag(itemOrFullType, tagName)
    if type(itemOrFullType) ~= "string" and itemOrFullType then
        local okTags, tags = pcall(function()
            return itemOrFullType.getTags and itemOrFullType:getTags() or nil
        end)
        if okTags and hasTag(tags, tagName) then
            return true
        end

        local okScriptItem, scriptItem = pcall(function()
            return itemOrFullType.getScriptItem and itemOrFullType:getScriptItem() or nil
        end)
        if okScriptItem and scriptItem then
            local okScriptTags, scriptTags = pcall(function()
                return scriptItem.getTags and scriptItem:getTags() or nil
            end)
            if okScriptTags and hasTag(scriptTags, tagName) then
                return true
            end
        end
    end

    local fullType = getFullType(itemOrFullType)
    local okScriptManager, scriptItem = pcall(function()
        return fullType and getScriptManager and getScriptManager():FindItem(fullType) or nil
    end)
    if okScriptManager and scriptItem then
        local okScriptTags, scriptTags = pcall(function()
            return scriptItem.getTags and scriptItem:getTags() or nil
        end)
        if okScriptTags and hasTag(scriptTags, tagName) then
            return true
        end
    end

    if fullType and string.lower(tostring(tagName)) == "base:bucket" then
        return string.find(string.lower(tostring(fullType)), "bucket", 1, true) ~= nil
    end

    return false
end

function IDBFS.getItemCount(item)
    if not item then
        return 0
    end
    local count = 1
    if item.getCount then
        local ok, value = pcall(function()
            return item:getCount()
        end)
        if ok and tonumber(value) then
            count = tonumber(value)
        end
    end
    return math.max(1, math.floor(count))
end

function IDBFS.matchesIngredient(itemOrFullType, requirement)
    if not itemOrFullType or not requirement then
        return false
    end

    local fullType = getFullType(itemOrFullType)
    for _, allowed in ipairs(requirement.anyOf or {}) do
        if fullType == allowed then
            return true
        end
    end

    for _, tagName in ipairs(requirement.tags or {}) do
        if IDBFS.hasItemTag(itemOrFullType, tagName) then
            return true
        end
    end

    return false
end

local function isBucketLikeFullType(fullType)
    if not fullType then
        return false
    end
    local lowerFullType = string.lower(tostring(fullType))
    return string.find(lowerFullType, "bucket", 1, true) ~= nil
end

function IDBFS.isPressContainer(itemOrFullType)
    local fullType = getFullType(itemOrFullType)
    if fullType and IDBFS.PressContainerTypes and IDBFS.PressContainerTypes[fullType] == true then
        return true
    end
    if type(itemOrFullType) == "string" or not itemOrFullType or not itemOrFullType.getFluidContainer then
        return false
    end
    return itemOrFullType:getFluidContainer() ~= nil and isBucketLikeFullType(fullType)
end

function IDBFS.isPortableLiquidContainer(itemOrFullType)
    local fullType = getFullType(itemOrFullType)
    if fullType and IDBFS.PressContainerTypes and IDBFS.PressContainerTypes[fullType] == true then
        return true
    end
    if fullType and IDBFS.LegacyContainerTypes and IDBFS.LegacyContainerTypes[fullType] == true then
        return true
    end
    if type(itemOrFullType) ~= "string" and itemOrFullType and itemOrFullType.getFluidContainer then
        local fluidContainer = itemOrFullType:getFluidContainer()
        if fluidContainer then
            return true
        end
    end
    if type(itemOrFullType) ~= "string" and itemOrFullType and itemOrFullType.isWaterSource and itemOrFullType:isWaterSource() then
        return true
    end
    return false
end

function IDBFS.isEmptyContainer(itemOrFullType)
    return IDBFS.isPortableLiquidContainer(itemOrFullType)
end

function IDBFS.getItemForLiquid(liquidType)
    local def = IDBFS.getLiquidDef(liquidType)
    return def and def.item or nil
end

function IDBFS.getFluidForLiquid(liquidType)
    local fluidType = IDBFS.getFluidTypeForLiquid(liquidType)
    if fluidType and Fluid and Fluid.Get then
        return Fluid.Get(fluidType) or Fluid.Get("IDBFS." .. fluidType)
    end
    return nil
end

function IDBFS.canContainerAcceptLiquid(item, liquidType, amount)
    local fluidContainer = item and item.getFluidContainer and item:getFluidContainer() or nil
    if not fluidContainer then
        return false
    end

    amount = tonumber(amount) or 0
    if amount > 0 and fluidContainer.getFreeCapacity and fluidContainer:getFreeCapacity() < amount then
        return false
    end
    if fluidContainer:isEmpty() then
        return true
    end

    local fluid = IDBFS.getFluidForLiquid(liquidType)
    if fluid and fluidContainer.isPureFluid and fluidContainer:isPureFluid(fluid) then
        return true
    end

    local primary = fluidContainer:getPrimaryFluid()
    return primary and IDBFS.getLiquidForFluidType(primary:getFluidTypeString()) == liquidType
end
