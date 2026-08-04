-- ============================================================
-- PagerMod_TowerSprite.lua
-- Custom pager-tower sprite (rendered from the 3D model by
-- tools/render_tower_sprite.py). TrampleSteam pattern:
--   * register named sprites at boot: an invisible 1px base (given a solidtrans
--     flag so the object is SOLID) + one art sprite per facing;
--   * the object's MAIN sprite is the base; the visible art is an ATTACHED anim
--     (a runtime LoadSingleTexture sprite won't render via the main-sprite path);
--   * attached anims don't persist, so re-apply on OnObjectAdded/LoadGridsquare.
-- ============================================================

require "PagerMod_Shared"

local function spriteHasTexture(spr)
    if not spr then return false end
    if spr.hasNoTextures then
        local ok, none = pcall(function() return spr:hasNoTextures() end)
        if ok then return not none end
    end
    return true
end

local function ensureSprite(name, tex)
    local mgr = IsoSpriteManager and IsoSpriteManager.instance
    if not mgr then return nil end
    local spr = mgr:getSprite(name)
    if not spr then
        local ok, s = pcall(function() return mgr:AddSprite(name) end)
        spr = (ok and s) or nil
    end
    if spr and not spriteHasTexture(spr) then
        local base = tex:gsub("^media/textures/", ""):gsub("%.png$", "")
        for _, t in ipairs({ tex, base, "media/textures/" .. base }) do
            pcall(function() spr:LoadSingleTexture(t) end)
            if spriteHasTexture(spr) then break end
        end
    end
    return spr
end

function PagerMod.registerTowerSprites()
    -- Register the invisible base sprite. We deliberately do NOT touch its
    -- solidtrans flag: IsoSpriteProperties:set(IsoFlagType) throws in B41, and
    -- collision is already guaranteed on the deployed object itself
    -- (deployTower: setBlockAllTheSquare(true) + setCanPassThrough(false)), so
    -- the sprite flag is redundant.
    ensureSprite(PagerMod.TOWER_BASE_SPRITE, PagerMod.TOWER_BASE_TEX)
    for _, d in pairs(PagerMod.TOWER_SPRITES) do
        ensureSprite(d.name, d.tex)
    end
end

function PagerMod.towerSpriteReady()
    local mgr = IsoSpriteManager and IsoSpriteManager.instance
    return mgr ~= nil and spriteHasTexture(mgr:getSprite(PagerMod.TOWER_SPRITES[0].name))
end

-- Identify a deployed tower object (by our object name or modData tag).
function PagerMod.isTowerObject(o)
    if not o or not o.getModData then return false end
    local ok, name = pcall(function() return o:getName() end)
    if ok and name == PagerMod.TOWER_OBJECT_NAME then return true end
    local md = o:getModData()
    return md ~= nil and md.pagerTower == true
end

-- Put the visible tower art on a deployed object (invisible base + attached
-- anim, using the facing stored in modData). Client-only; safe to call often.
function PagerMod.applyTowerVisual(obj)
    if not obj then return end
    if isServer and isServer() then return end
    pcall(function()
        PagerMod.registerTowerSprites()
        local mgr = IsoSpriteManager.instance
        local base = mgr:getSprite(PagerMod.TOWER_BASE_SPRITE)
        if base and obj:getSprite() ~= base then obj:setSprite(base) end
        local soff = PagerMod.TOWER_DEPTH_SOFF or 0
        if obj.setOffsetX then obj:setOffsetX(PagerMod.TOWER_SPRITE_OFFSET_X or 0) end
        if obj.setOffsetY then obj:setOffsetY((PagerMod.TOWER_SPRITE_OFFSET_Y or 0) + soff) end
        if obj.RemoveAttachedAnims then obj:RemoveAttachedAnims() end
        local dir = obj:getModData().towerDir or 0
        local def = PagerMod.TOWER_SPRITES[dir] or PagerMod.TOWER_SPRITES[0]
        local spr = mgr:getSprite(def.name)
        if spr and spriteHasTexture(spr) and obj.AttachExistingAnim then
            local tint = ColorInfo.new(1, 1, 1, 1)
            obj:AttachExistingAnim(spr, 0, -soff, false, 0, false, 0, tint)
        end
        if obj.invalidateRenderChunkLevel and FBORenderChunk then
            obj:invalidateRenderChunkLevel(FBORenderChunk.DIRTY_REDRAW)
        end
    end)
end

local function reapply(o)
    if PagerMod.isTowerObject(o) then PagerMod.applyTowerVisual(o) end
end

local function onLoadGridsquare(sq)
    if not sq then return end
    local objs = sq:getObjects()
    if not objs then return end
    for i = 0, objs:size() - 1 do reapply(objs:get(i)) end
end

Events.OnGameBoot.Add(PagerMod.registerTowerSprites)
if Events.OnServerStarted then Events.OnServerStarted.Add(PagerMod.registerTowerSprites) end
Events.OnObjectAdded.Add(reapply)
Events.LoadGridsquare.Add(onLoadGridsquare)
