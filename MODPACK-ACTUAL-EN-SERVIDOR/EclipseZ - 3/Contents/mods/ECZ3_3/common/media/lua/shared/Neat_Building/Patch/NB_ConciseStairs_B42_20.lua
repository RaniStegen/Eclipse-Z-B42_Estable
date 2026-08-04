-- Neat Building / Build 42.20 compatibility for concise stairs.
--
-- This patch is deliberately local to the object being built.  It must not
-- modify the shared IsoSprite definitions or scan loaded grid squares: the
-- concise sprites belong to the global fixtures_stairs_01 tileset and changing
-- those shared types also changes unrelated stairs throughout the game.

NB_BuildRecipeCode = NB_BuildRecipeCode or {}
NB_BuildRecipeCode.ConciseStairs = NB_BuildRecipeCode.ConciseStairs or {}

-- SpriteConfig builds each three-part row from bottom to top.  The previous
-- compatibility patch interpreted that order backwards, so the bottom segment
-- was marked as the top stair.  Vanilla then created the landing from the wrong
-- square and movement advanced in visible steps.
local STAIR_TYPE_BY_SPRITE = {
    -- Wooden concise stairs: north/south axis, bottom/middle/top.
    fixtures_stairs_01_82 = IsoObjectType.stairsBN,
    fixtures_stairs_01_81 = IsoObjectType.stairsMN,
    fixtures_stairs_01_80 = IsoObjectType.stairsTN,

    -- Wooden concise stairs: west/east axis, bottom/middle/top.
    fixtures_stairs_01_90 = IsoObjectType.stairsBW,
    fixtures_stairs_01_89 = IsoObjectType.stairsMW,
    fixtures_stairs_01_88 = IsoObjectType.stairsTW,

    -- Metal concise stairs: north/south axis, bottom/middle/top.
    fixtures_stairs_01_2 = IsoObjectType.stairsBN,
    fixtures_stairs_01_1 = IsoObjectType.stairsMN,
    fixtures_stairs_01_0 = IsoObjectType.stairsTN,

    -- Metal concise stairs: west/east axis, bottom/middle/top.
    fixtures_stairs_01_10 = IsoObjectType.stairsBW,
    fixtures_stairs_01_9 = IsoObjectType.stairsMW,
    fixtures_stairs_01_8 = IsoObjectType.stairsTW,
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
    if vanilla and type(vanilla.OnIsValid) == "function" then
        return vanilla.OnIsValid(params)
    end
    return false
end

function NB_BuildRecipeCode.ConciseStairs.OnCreate(params)
    local thumpable = params and params.thumpable or nil
    if not thumpable then return nil end

    -- Set only this newly created instance.  Never call getSprite(...):setType()
    -- here because that mutates the shared tileset and alters every other stair
    -- that uses the same sprite.
    local stairType = STAIR_TYPE_BY_SPRITE[getSpriteName(thumpable)]
    if stairType and thumpable.setType then
        thumpable:setType(stairType)
    end

    -- Vanilla remains responsible for stair finalisation and for creating the
    -- wooden landing from the correctly identified top segment.
    local vanilla = getVanillaStairsCode()
    if vanilla and type(vanilla.OnCreate) == "function" then
        return vanilla.OnCreate(params)
    end

    return nil
end
