-- Neat Building / Build 42.20 compatibility for concise stairs.
--
-- Correct only the newly created concise-stair object. Never mutate the shared
-- fixtures_stairs_01 sprites and never scan loaded squares, because those
-- sprites are also used by unrelated stairs.

NB_BuildRecipeCode = NB_BuildRecipeCode or {}
NB_BuildRecipeCode.ConciseStairs = NB_BuildRecipeCode.ConciseStairs or {}

-- SpriteConfig uses the same top/middle/bottom ordering as the working vanilla
-- and Neat Building stairs: the first sprite in each three-part row is the top
-- segment, the second is the middle and the third is the bottom.
local STAIR_TYPE_BY_SPRITE = {
    -- Wooden concise stairs: top/middle/bottom.
    fixtures_stairs_01_82 = IsoObjectType.stairsTN,
    fixtures_stairs_01_81 = IsoObjectType.stairsMN,
    fixtures_stairs_01_80 = IsoObjectType.stairsBN,

    fixtures_stairs_01_90 = IsoObjectType.stairsTW,
    fixtures_stairs_01_89 = IsoObjectType.stairsMW,
    fixtures_stairs_01_88 = IsoObjectType.stairsBW,

    -- Metal concise stairs use the same ordering.
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
    local tileInfo = params and params.tileInfo or nil
    local spriteName = tileInfo and tileInfo.getSpriteName and tileInfo:getSpriteName() or nil
    local expectedType = spriteName and STAIR_TYPE_BY_SPRITE[spriteName] or nil

    -- Vanilla validates using the shared sprite type. Concise sprites are not
    -- reliably typed in B42.20, so reproduce only the missing type-dependent
    -- parts locally and leave every unrelated validation to the vanilla code
    -- whenever the sprite already has a recognised stair type.
    if expectedType and tileInfo and tileInfo.getSpriteName then
        local sprite = getSprite and getSprite(spriteName) or nil
        local currentType = sprite and sprite.getType and sprite:getType() or nil
        local recognised = currentType == IsoObjectType.stairsTN
            or currentType == IsoObjectType.stairsMN
            or currentType == IsoObjectType.stairsBN
            or currentType == IsoObjectType.stairsTW
            or currentType == IsoObjectType.stairsMW
            or currentType == IsoObjectType.stairsBW

        if not recognised then
            if not params.square or params.square:getZ() >= getMaximumWorldLevel() then
                return false
            end
            if params.square:getModData()["ConnectedToStairs" .. tostring(not params.north)] then
                return false
            end
            local above = getCell():getGridSquare(
                params.square:getX(),
                params.square:getY(),
                params.square:getZ() + 1
            )
            if above and above:getFloor() then
                return false
            end
            return true
        end
    end

    local vanilla = getVanillaStairsCode()
    if vanilla and type(vanilla.OnIsValid) == "function" then
        return vanilla.OnIsValid(params)
    end
    return false
end

function NB_BuildRecipeCode.ConciseStairs.OnCreate(params)
    local thumpable = params and params.thumpable or nil
    if not thumpable then return nil end

    -- Set only this instance. getSprite(...):setType() would alter all stairs
    -- using the same global tileset.
    local stairType = STAIR_TYPE_BY_SPRITE[getSpriteName(thumpable)]
    if stairType and thumpable.setType then
        thumpable:setType(stairType)
    end

    -- Vanilla remains authoritative for landing placement and finalisation.
    local vanilla = getVanillaStairsCode()
    if vanilla and type(vanilla.OnCreate) == "function" then
        return vanilla.OnCreate(params)
    end

    return nil
end
