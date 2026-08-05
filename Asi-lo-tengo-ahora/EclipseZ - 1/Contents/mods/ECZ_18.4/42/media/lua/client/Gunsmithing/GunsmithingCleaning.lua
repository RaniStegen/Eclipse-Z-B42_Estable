-- Scrubbing fouling out of the barrel: any cooking fat, grease or oil plus a rag. Maintenance
-- decides how much condition a pass recovers. The stock is repaired separately through the vanilla
-- glue/tape recipes, which the gun scripts opt into with base:repairwithtape / base:repairwithglue.
if isServer() then
    return
end

local Condition = require("Gunsmithing/GunsmithingCondition")

local GREASE_TYPES = { "Base.SesameOil" }
local RAG_TYPES = { "Base.RippedSheets", "Base.RippedSheetsDirty", "Base.DenimStrips", "Base.LeatherStrips" }
-- A cleaning pass uses a quarter of a bottle of oil, not the whole thing.
local GREASE_PER_CLEAN = 0.25

---@param inv ItemContainer
---@param types string[]
---@nodiscard
---@return InventoryItem|nil
local function firstOf(inv, types)
    for i = 1, #types do
        local it = inv:getFirstTypeRecurse(types[i])
        if it then
            return it
        end
    end
    return nil
end

---@param inv ItemContainer
---@nodiscard
---@return InventoryItem|nil
local function findGrease(inv)
    local it = inv:getFirstTagRecurse(ItemTag.BAKING_FAT)
    if it then
        return it
    end
    it = inv:getFirstTagRecurse(ItemTag.OIL)
    if it then
        return it
    end
    return firstOf(inv, GREASE_TYPES)
end

---@param inv ItemContainer
---@param grease InventoryItem
---@return nil
local function consumeGrease(inv, grease)
    if instanceof(grease, "DrainableComboItem") then
        local left = grease:getCurrentUsesFloat() - GREASE_PER_CLEAN
        if left <= 0 then
            inv:Remove(grease)
        else
            grease:setCurrentUsesFloat(left)
        end
        return
    end

    -- Food carries its remaining portion as a negative hunger value, so a partial use walks that
    -- value toward zero and the container is dropped once it can no longer cover a full pass.
    if instanceof(grease, "Food") and grease:getBaseHunger() < 0 then
        local step = grease:getBaseHunger() * GREASE_PER_CLEAN
        local left = grease:getHungChange() - step
        if left > step then
            inv:Remove(grease)
        else
            grease:setHungChange(left)
        end
        return
    end

    inv:Remove(grease)
end

---@param player IsoPlayer
---@param gun HandWeapon
---@return nil
local function cleanFirearm(player, gun)
    local inv = player:getInventory()
    local grease = findGrease(inv)
    local rag = firstOf(inv, RAG_TYPES)
    if not grease or not rag then
        return
    end
    if not Condition.isBarrelFouled(gun) then
        return
    end

    consumeGrease(inv, grease)
    inv:Remove(rag)

    local restore = 1 + math.floor(player:getPerkLevel(Perks.Maintenance) / 3)
    Condition.setBarrel(gun, Condition.getBarrel(gun) + restore)
    player:getXp():AddXP(Perks.Maintenance, 5)
    player:getEmitter():playSound("PZ_Dropitem")
end

---@param player number
---@param context ISContextMenu
---@param items table
---@return nil
local function onFirearmContextMenu(player, context, items)
    local playerObj = getSpecificPlayer(player)
    if not playerObj then
        return
    end

    local gun = nil
    for i = 1, #items do
        local entry = items[i]
        local it = entry
        if type(entry) == "table" and entry.items then
            it = entry.items[1]
        end
        if Condition.isGunsmithingFirearm(it) then
            gun = it
            break
        end
    end
    if not gun then
        return
    end

    local inv = playerObj:getInventory()
    local hasSupplies = findGrease(inv) and firstOf(inv, RAG_TYPES)
    local option = context:addOption(getText("ContextMenu_Gunsmithing_CleanFirearm"),
        playerObj, function() cleanFirearm(playerObj, gun) end)

    if hasSupplies and Condition.isBarrelFouled(gun) then
        return
    end

    option.notAvailable = true
    local tip = ISToolTip:new()
    tip:initialise()
    tip:setVisible(false)
    if Condition.isBarrelFouled(gun) then
        tip.description = getText("Tooltip_Gunsmithing_NeedsCleaningSupplies")
    else
        tip.description = getText("Tooltip_Gunsmithing_BarrelClean")
    end
    option.toolTip = tip
end

Events.OnFillInventoryObjectContextMenu.Add(onFirearmContextMenu)
