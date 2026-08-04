-- Neat Building / Build 42.20 compatibility for concise stairs.
--
-- Correct only the concise stair currently being validated or created. Never
-- leave a modified type on the shared fixtures_stairs_01 sprites and never scan
-- loaded squares, because those sprites are also used by unrelated stairs.

NB_BuildRecipeCode = NB_BuildRecipeCode or {}
NB_BuildRecipeCode.ConciseStairs = NB_BuildRecipeCode.ConciseStairs or {}

-- SpriteConfig follows the same top/middle/bottom ordering as the working
-- vanilla and Neat Building stair entities: first sprite = top, second = middle,
-- third = bottom.
local STAIR_TYPE_BY_SPRITE = {
    -- Wooden concise stairs.
    fixtures_stairs_01_82 = IsoObjectType.stairsTN,
    fixtures_stairs_01_81 = IsoObjectType.stairsMN,
    fixtures_stairs_01_80 = IsoObjectType.stairsBN,

    fixtures_stairs_01_90 = IsoObjectType.stairsTW,
    fixtures_stairs_01_89 = IsoObjectType.stairsMW,
    fixtures_stairs_01_88 = IsoObjectType.stairsBW,

    -- Metal concise stairs.
    fixtures_stairs_01_2 = IsoObjectType.stairsTN,
    fixtures_stairs_01_1 = IsoObjectType.stairsMN,
    fixtures_stairs_01_0 = IsoObjectType.stairsBN,

    fixtures_stairs_01_10 = IsoObjectType.stairsTW,
    fixtures_stairs_01_9 = IsoObjectType.stairsMW,
    fixtures_stairs_01_8 = IsoObjectType.stairsBW,
}

local function getSpriteName(object)
    if not object then return nil end

    if object.getSpriteName then
        local name = object:getSpriteName()
        if name then return name end
    end

    if object.getTextureName then
        return object:getTextureName()
    end

    return nil
end

local function getVanillaStairsCode()
    if BuildRecipeCode and BuildRecipeCode.stairs then
        return BuildRecipeCode.stairs
    end
    return nil
end

function NB_BuildRecipeCode.ConciseStairs.OnIsValid(params)
    local vanilla = getVanillaStairsCode()
    if not vanilla or type(vanilla.OnIsValid) ~= "function" then
        return false
    end

    local tileInfo = params and params.tileInfo or nil
    local spriteName = tileInfo and tileInfo.getSpriteName and tileInfo:getSpriteName() or nil
    local expectedType = spriteName and STAIR_TYPE_BY_SPRITE[spriteName] or nil
    local sprite = expectedType and getSprite and getSprite(spriteName) or nil

    -- Vanilla reads the type from the shared sprite during validation. Give it
    -- the concise segment's correct type only for this synchronous call, then
    -- restore the original type immediately even if validation throws.
    if sprite and sprite.getType and sprite.setType then
        local originalType = sprite:getType()
        sprite:setType(expectedType)
        local ok, result = pcall(vanilla.OnIsValid, params)
        sprite:setType(originalType)
        if ok then return result end
        print("[ECZ3_3] Error validating concise stairs: " .. tostring(result))
        return false
    end

    return vanilla.OnIsValid(params)
end

function NB_BuildRecipeCode.ConciseStairs.OnCreate(params)
    local thumpable = params and params.thumpable or nil
    if not thumpable then return nil end

    -- Set only this newly created instance. A persistent getSprite():setType()
    -- would alter every unrelated stair that shares the tileset.
    local stairType = STAIR_TYPE_BY_SPRITE[getSpriteName(thumpable)]
    if stairType and thumpable.setType then
        thumpable:setType(stairType)
    end

    -- Vanilla remains authoritative for finalisation and landing placement.
    local vanilla = getVanillaStairsCode()
    if vanilla and type(vanilla.OnCreate) == "function" then
        return vanilla.OnCreate(params)
    end

    return nil
end
