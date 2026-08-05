-- Recipe OnCreate hooks, resolved by name from the craftRecipe scripts, so this table must be global.
--
-- Stripping a gun splits its two wear tracks across two different output items: the barrel takes
-- HeadCondition and the stock takes Condition. The script-side inheritance flags cannot express
-- that, because they apply the same source field to every created item.

GunsmithingRecipeCode = {}

local BARREL = "Gunsmithing.Crafting_Barrel"
local STOCK = "Gunsmithing.Crafting_Stock"

---@param value number
---@param fromMax number
---@param toMax number
---@nodiscard
---@return number
local function rescale(value, fromMax, toMax)
    if fromMax <= 0 then
        return toMax
    end
    if fromMax == toMax then
        return value
    end
    return math.floor(toMax * (value / fromMax))
end

---@param data CraftRecipeData
---@nodiscard
---@return HandWeapon|nil
local function consumedGun(data)
    local items = data:getAllConsumedItems()
    if not items then
        return nil
    end

    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it and instanceof(it, "HandWeapon") and it:isRanged() then
            return it
        end
    end
    return nil
end

--- Carry the stripped gun's barrel wear onto the barrel parts and its stock wear onto the stock.
---@param data CraftRecipeData
---@param character IsoGameCharacter
---@return nil
function GunsmithingRecipeCode.stripFirearm(data, character)
    local gun = consumedGun(data)
    if not gun then
        return
    end

    local barrelWear = gun:getCondition()
    local barrelMax = gun:getConditionMax()
    if gun:hasHeadCondition() then
        barrelWear = gun:getHeadCondition()
        barrelMax = gun:getHeadConditionMax()
    end

    local created = data:getAllCreatedItems()
    if not created then
        return
    end

    for i = 0, created:size() - 1 do
        local it = created:get(i)
        if it then
            local fullType = it:getFullType()
            if fullType == BARREL then
                it:setCondition(rescale(barrelWear, barrelMax, it:getConditionMax()))
            elseif fullType == STOCK then
                it:setCondition(rescale(gun:getCondition(), gun:getConditionMax(), it:getConditionMax()))
            end
        end
    end
end
