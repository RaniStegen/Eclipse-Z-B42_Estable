-- Neat Building / Build 42.20 compatibility.
--
-- The decorative "concise" stair sprites are visually correct, but their
-- IsoObjectType is not recognised as a stair in B42.20.  Vanilla therefore
-- creates ordinary pass-through thumpables: the player cannot climb them and
-- BuildRecipeCode.stairs.OnCreate never creates the upper landing.
--
-- Keep vanilla authoritative and only restore the missing stair type for the
-- exact concise sprite families before delegating to the vanilla callbacks.

NB_BuildRecipeCode = NB_BuildRecipeCode or {}
NB_BuildRecipeCode.ConciseStairs = NB_BuildRecipeCode.ConciseStairs or {}

local REPAIR_MARKER = "ECZ_B4220_ConciseStairs_Repaired"

local STAIR_TYPE_BY_SPRITE = {
    -- Wooden concise stairs: north-facing top/middle/bottom.
    fixtures_stairs_01_82 = IsoObjectType.stairsTN,
    fixtures_stairs_01_81 = IsoObjectType.stairsMN,
    fixtures_stairs_01_80 = IsoObjectType.stairsBN,

    -- Wooden concise stairs: west-facing top/middle/bottom.
    fixtures_stairs_01_90 = IsoObjectType.stairsTW,
    fixtures_stairs_01_89 = IsoObjectType.stairsMW,
    fixtures_stairs_01_88 = IsoObjectType.stairsBW,

    -- Metal concise stairs: north-facing top/middle/bottom.
    fixtures_stairs_01_2 = IsoObjectType.stairsTN,
    fixtures_stairs_01_1 = IsoObjectType.stairsMN,
    fixtures_stairs_01_0 = IsoObjectType.stairsBN,

    -- Metal concise stairs: west-facing top/middle/bottom.
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

local function patchSpriteType(spriteName)
    local stairType = spriteName and STAIR_TYPE_BY_SPRITE[spriteName] or nil
    if not stairType then return nil end

    local sprite = getSprite and getSprite(spriteName) or nil
    if sprite and sprite.setType then
        sprite:setType(stairType)
    end

    return stairType
end

local function patchAllSpriteTypes()
    for spriteName, _ in pairs(STAIR_TYPE_BY_SPRITE) do
        patchSpriteType(spriteName)
    end
end

local function getVanillaStairsCode()
    if BuildRecipeCode and BuildRecipeCode.stairs then
        return BuildRecipeCode.stairs
    end
    return nil
end

local function isTopStairType(stairType)
    return stairType == IsoObjectType.stairsTN or stairType == IsoObjectType.stairsTW
end

function NB_BuildRecipeCode.ConciseStairs.OnIsValid(params)
    local tileInfo = params and params.tileInfo or nil
    local spriteName = tileInfo and tileInfo.getSpriteName and tileInfo:getSpriteName() or nil
    patchSpriteType(spriteName)

    local vanilla = getVanillaStairsCode()
    if vanilla and type(vanilla.OnIsValid) == "function" then
        return vanilla.OnIsValid(params)
    end

    -- Never permit a malformed placement if the vanilla validator is absent.
    return false
end

function NB_BuildRecipeCode.ConciseStairs.OnCreate(params)
    local thumpable = params and params.thumpable or nil
    if not thumpable then return nil end

    local spriteName = getSpriteName(thumpable)
    local stairType = patchSpriteType(spriteName)

    -- The object was already constructed before OnCreate, so update the
    -- instance as well as the shared sprite metadata.
    if stairType and thumpable.setType then
        thumpable:setType(stairType)
    end

    local vanilla = getVanillaStairsCode()
    local result = nil
    if vanilla and type(vanilla.OnCreate) == "function" then
        result = vanilla.OnCreate(params)
    end

    if stairType and thumpable.getModData then
        thumpable:getModData()[REPAIR_MARKER] = true
    end

    return result
end

-- Repair concise stairs already present in a save without touching unrelated
-- objects or chunks.  Clients receive the corrected object type locally;
-- only the server/single-player instance may create a missing landing.
local function repairLoadedSquare(square)
    if not square or not square.getObjects then return end

    local objects = square:getObjects()
    if not objects then return end

    local snapshot = {}
    for index = 0, objects:size() - 1 do
        snapshot[#snapshot + 1] = objects:get(index)
    end

    local changed = false
    for _, object in ipairs(snapshot) do
        local spriteName = getSpriteName(object)
        local stairType = spriteName and STAIR_TYPE_BY_SPRITE[spriteName] or nil

        if stairType then
            patchSpriteType(spriteName)
            if object.setType then
                object:setType(stairType)
            end
            changed = true

            local remoteClient = isClient and isClient()
            if not remoteClient and object.getModData then
                local modData = object:getModData()
                if isTopStairType(stairType) and not modData[REPAIR_MARKER] then
                    local vanilla = getVanillaStairsCode()
                    if vanilla and type(vanilla.OnCreate) == "function" then
                        vanilla.OnCreate({ thumpable = object })
                        modData[REPAIR_MARKER] = true
                    end
                else
                    modData[REPAIR_MARKER] = true
                end

                if isServer and isServer() and object.transmitCompleteItemToClients then
                    object:transmitCompleteItemToClients()
                end
            end
        end
    end

    if changed and square.RecalcAllWithNeighbours then
        square:RecalcAllWithNeighbours(true)
    end
end

-- Try immediately, then retry at the lifecycle points where the tileset is
-- guaranteed to exist.  Reapplying the same IsoObjectType is idempotent.
patchAllSpriteTypes()

if Events then
    if Events.OnGameBoot then
        Events.OnGameBoot.Add(patchAllSpriteTypes)
    end
    if Events.OnGameStart then
        Events.OnGameStart.Add(patchAllSpriteTypes)
    end
    if Events.OnServerStarted then
        Events.OnServerStarted.Add(patchAllSpriteTypes)
    end
    if Events.LoadGridsquare then
        Events.LoadGridsquare.Add(repairLoadedSquare)
    end
end
