-- Black-powder guns foul fast (they degrade quicker than modern firearms, see the lowered
-- ConditionLowerChanceOneIn) but are easy to maintain: a water + tallow (animal fat) solution and
-- a rag restore condition. Right-click a Gunsmithing firearm to clean it.
if isServer() then
    return
end

local TALLOW = { "Base.Butter", "Base.Lard", "Base.Tallow", "Base.AnimalFat" }
local RAG = { "Base.RippedSheets", "Base.RippedSheetsDirty", "Base.Rag" }
local CONDITION_PER_CLEAN = 3

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

---@param item InventoryItem|nil
---@nodiscard
---@return boolean
local function isGunsmithingFirearm(item)
    return item ~= nil
        and instanceof(item, "HandWeapon")
        and item:getModule() == "Gunsmithing"
        and item:isRanged()
end

---@param player IsoPlayer
---@param gun HandWeapon
---@return nil
local function cleanFirearm(player, gun)
    local inv = player:getInventory()
    local tallow = firstOf(inv, TALLOW)
    local rag = firstOf(inv, RAG)
    if not tallow or not rag then
        return
    end
    if gun:getCondition() >= gun:getConditionMax() then
        return
    end

    inv:Remove(tallow)
    inv:Remove(rag)
    gun:setCondition(math.min(gun:getConditionMax(), gun:getCondition() + CONDITION_PER_CLEAN))
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
        if isGunsmithingFirearm(it) then
            gun = it
            break
        end
    end
    if not gun then
        return
    end

    local inv = playerObj:getInventory()
    local hasSupplies = firstOf(inv, TALLOW) and firstOf(inv, RAG)
    local option = context:addOption(getText("ContextMenu_Gunsmithing_CleanFirearm") or "Clean Firearm",
        playerObj, function() cleanFirearm(playerObj, gun) end)

    if not hasSupplies or gun:getCondition() >= gun:getConditionMax() then
        option.notAvailable = true
        local tip = ISToolTip:new()
        tip:initialise()
        tip:setVisible(false)
        tip.description = gun:getCondition() >= gun:getConditionMax()
            and "Already in good condition."
            or "Needs a tallow/animal fat (butter, lard) and a rag."
        option.toolTip = tip
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFirearmContextMenu)
