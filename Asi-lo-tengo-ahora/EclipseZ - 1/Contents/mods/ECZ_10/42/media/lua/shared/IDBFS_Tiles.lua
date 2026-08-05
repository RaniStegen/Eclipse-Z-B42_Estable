IDBFS = IDBFS or {}

IDBFS.Tiles = {
    press = {
        crafted_05_0 = true,
        crafted_05_1 = true,
        crafted_05_2 = true,
        crafted_05_3 = true,
    },
    barrel = {
        location_business_distillery_01_8 = true,
        location_business_distillery_01_9 = true,
        location_business_distillery_01_10 = true,
    },
    still = {
        industry_02_34 = true,
        location_business_distillery_01_11 = true,
        location_business_distillery_01_12 = true,
        location_business_distillery_01_13 = true,
        location_business_distillery_01_24 = true,
        location_business_distillery_01_25 = true,
        location_business_distillery_01_26 = true,
        location_business_distillery_01_29 = true,
        location_business_distillery_01_30 = true,
    },
    tank = {
        industry_02_72 = true,
        industry_02_73 = true,
        industry_02_74 = true,
        industry_02_75 = true,
    },
    tanker = {
        location_business_distillery_01_1 = true,
        location_business_distillery_01_3 = true,
        location_business_distillery_01_4 = true,
    },
}

IDBFS.WorldItemTypes = IDBFS.WorldItemTypes or {}

IDBFS.CompositeAnchors = {
    press = {
        anchor = "crafted_05_0",
        legacyAnchors = {
            "crafted_05_3",
        },
        offsets = {
            crafted_05_0 = { x = 0, y = 0, z = 0 },
            crafted_05_1 = { x = -1, y = 0, z = 0 },
            crafted_05_3 = { x = 0, y = 0, z = 0 },
            crafted_05_2 = { x = 0, y = -1, z = 0 },
        },
    },
    still = {
        anchor = "location_business_distillery_01_29",
        legacyAnchors = {
            "location_business_distillery_01_25",
        },
        offsets = {
            location_business_distillery_01_29 = { x = 0, y = 0, z = 0 },
            location_business_distillery_01_30 = { x = 0, y = 1, z = 0 },
            location_business_distillery_01_26 = {
                { x = 0, y = -1, z = 0 },
                { x = 0, y = 1, z = 0 },
            },
            location_business_distillery_01_25 = { x = 0, y = -2, z = 0 },
            location_business_distillery_01_24 = {
                { x = 1, y = -2, z = 0 },
                { x = 1, y = 0, z = 0 },
            },
            location_business_distillery_01_13 = { x = 0, y = 0, z = -1 },
            location_business_distillery_01_12 = { x = 0, y = -1, z = -1 },
            location_business_distillery_01_11 = { x = 0, y = -2, z = -1 },
            industry_02_34 = { x = 1, y = 1, z = 0 },
        },
    },
    tank = {
        anchor = "industry_02_73",
        offsets = {
            industry_02_73 = { x = 0, y = 0 },
            industry_02_72 = { x = 1, y = 0 },
            industry_02_75 = { x = 0, y = 1 },
            industry_02_74 = { x = 1, y = 1 },
        },
    },
}

function IDBFS.getSpriteName(obj)
    if not obj then
        return nil
    end
    if obj.getSprite then
        local sprite = obj:getSprite()
        if sprite and sprite.getName then
            local name = sprite:getName()
            if name and name ~= "" then
                return name
            end
        end
    end
    if obj.getTextureName then
        local name = obj:getTextureName()
        if name and name ~= "" then
            return name
        end
    end
    return nil
end

local function hasSprite(obj, group)
    local spriteName = IDBFS.getSpriteName(obj)
    return spriteName and IDBFS.Tiles[group] and IDBFS.Tiles[group][spriteName] == true
end

function IDBFS.isPressObject(obj)
    return hasSprite(obj, "press")
end

function IDBFS.isBarrelObject(obj)
    return hasSprite(obj, "barrel")
end

function IDBFS.isStillObject(obj)
    return hasSprite(obj, "still")
end

function IDBFS.isTankObject(obj)
    return hasSprite(obj, "tank")
end

function IDBFS.isTankerObject(obj)
    return hasSprite(obj, "tanker")
end

function IDBFS.getObjectType(obj)
    if IDBFS.isPressObject(obj) then
        return "press"
    end
    if IDBFS.isBarrelObject(obj) then
        return "barrel"
    end
    if IDBFS.isStillObject(obj) then
        return "still"
    end
    if IDBFS.isTankObject(obj) then
        return "tank"
    end
    if IDBFS.isTankerObject(obj) then
        return "tanker"
    end
    return nil
end

local function findObjectWithSprite(square, spriteName)
    if not square or not spriteName then
        return nil
    end
    local objects = square.getObjects and square:getObjects() or nil
    if objects then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if IDBFS.getSpriteName(obj) == spriteName then
                return obj
            end
        end
    end
    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
    if worldObjects then
        for i = 0, worldObjects:size() - 1 do
            local obj = worldObjects:get(i)
            if IDBFS.getSpriteName(obj) == spriteName then
                return obj
            end
        end
    end
    return nil
end

local function findAnchorFromOffsets(square, anchorSprite, offsets)
    if not square or not anchorSprite or not offsets then
        return nil
    end
    for _, offset in ipairs(offsets) do
        local anchorSquare = getCell():getGridSquare(
            square:getX() + (tonumber(offset.x) or 0),
            square:getY() + (tonumber(offset.y) or 0),
            square:getZ() + (tonumber(offset.z) or 0)
        )
        local anchorObj = findObjectWithSprite(anchorSquare, anchorSprite)
        if anchorObj then
            return anchorObj
        end
    end
    return nil
end

function IDBFS.getCompositeAnchor(obj)
    if not obj or not obj.getSquare then
        return obj
    end
    local objectType = IDBFS.getObjectType(obj)
    local composite = objectType and IDBFS.CompositeAnchors and IDBFS.CompositeAnchors[objectType] or nil
    if not composite then
        return obj
    end
    local spriteName = IDBFS.getSpriteName(obj)
    local offset = spriteName and composite.offsets and composite.offsets[spriteName] or nil
    if not offset then
        return obj
    end
    if spriteName == composite.anchor then
        return obj
    end
    local square = obj:getSquare()
    local isLegacyAnchor = false
    if composite.legacyAnchors then
        for _, legacyAnchor in ipairs(composite.legacyAnchors) do
            if spriteName == legacyAnchor then
                isLegacyAnchor = true
                break
            end
        end
    end
    if type(offset[1]) == "table" then
        local anchorObj = findAnchorFromOffsets(square, composite.anchor, offset)
        if not anchorObj and composite.legacyAnchors then
            for _, legacyAnchor in ipairs(composite.legacyAnchors) do
                anchorObj = findAnchorFromOffsets(square, legacyAnchor, offset)
                if anchorObj then
                    break
                end
            end
        end
        return anchorObj or obj
    end
    local anchorSquare = square and getCell():getGridSquare(
        square:getX() + (tonumber(offset.x) or 0),
        square:getY() + (tonumber(offset.y) or 0),
        square:getZ() + (tonumber(offset.z) or 0)
    ) or nil
    local anchorObj = findObjectWithSprite(anchorSquare, composite.anchor)
    if not anchorObj and composite.legacyAnchors then
        for _, legacyAnchor in ipairs(composite.legacyAnchors) do
            anchorObj = findObjectWithSprite(anchorSquare, legacyAnchor)
            if anchorObj then
                break
            end
        end
    end
    if not anchorObj and isLegacyAnchor then
        return obj
    end
    return anchorObj or obj
end

function IDBFS.isFunctionalObject(obj)
    return IDBFS.getObjectType(obj) ~= nil
end
