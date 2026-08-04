-- Barrel is B42's HeadCondition, stock is plain Condition. Guns saved before the split lack the
-- head attribute, so every barrel access falls back to plain condition.

local Condition = {}

---@param item InventoryItem|nil
---@nodiscard
---@return boolean
function Condition.isGunsmithingFirearm(item)
    return item ~= nil
        and instanceof(item, "HandWeapon")
        and item:isRanged()
        and item:getModule() == "Gunsmithing"
end

---@param gun HandWeapon
---@nodiscard
---@return number
function Condition.getBarrel(gun)
    if gun:hasHeadCondition() then
        return gun:getHeadCondition()
    end
    return gun:getCondition()
end

---@param gun HandWeapon
---@nodiscard
---@return number
function Condition.getBarrelMax(gun)
    if gun:hasHeadCondition() then
        return gun:getHeadConditionMax()
    end
    return gun:getConditionMax()
end

---@param gun HandWeapon
---@param value number
---@return nil
function Condition.setBarrel(gun, value)
    local max = Condition.getBarrelMax(gun)
    if value < 0 then
        value = 0
    end
    if value > max then
        value = max
    end

    if gun:hasHeadCondition() then
        gun:setHeadCondition(value)
    else
        gun:setCondition(value)
    end
    gun:syncItemFields()
end

---@param gun HandWeapon
---@nodiscard
---@return boolean
function Condition.isBarrelFouled(gun)
    return Condition.getBarrel(gun) < Condition.getBarrelMax(gun)
end

return Condition
