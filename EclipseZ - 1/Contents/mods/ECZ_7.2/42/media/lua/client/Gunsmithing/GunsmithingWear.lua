-- Per-shot black-powder fouling.
--
-- Vanilla PZ only wears a firearm when a shot HITS something (the engine sets its condition-loss
-- flag on a zombie/character/tree hit). Black-powder guns instead foul from powder residue on
-- EVERY shot, hit or miss, so we roll the wear ourselves per shot fired.
--
-- The trigger is OnWeaponSwing, which fires once per trigger-pull on the shooting path -- and,
-- importantly, does NOT fire when you unload the gun (unloading isn't an attack). We only foul a
-- LOADED gun, so a dry-fire on an empty chamber costs nothing. Rate = the item script's
-- ConditionLowerChanceOneIn (5), so ConditionMax 10 x 5 ~= 50 shots to break if never cleaned.
if isServer() then
    return
end

---@param item InventoryItem|nil
---@nodiscard
---@return boolean
local function isGunsmithingFirearm(item)
    return item ~= nil
        and instanceof(item, "HandWeapon")
        and item:isRanged()
        and item:getModule() == "Gunsmithing"
end

---@param character IsoGameCharacter
---@param weapon HandWeapon
---@return nil
local function onWeaponSwing(character, weapon)
    if not isGunsmithingFirearm(weapon) then
        return
    end
    -- Only a loaded gun burns a charge; an empty-chamber click doesn't foul. OnWeaponSwing fires
    -- before the round is consumed, so the count is still the pre-shot value here.
    if weapon:getCurrentAmmoCount() <= 0 or weapon:getCondition() <= 0 then
        return
    end

    local chance = weapon:getConditionLowerChance()
    if chance < 1 then
        chance = 1
    end
    if ZombRand(chance) == 0 then
        weapon:setCondition(weapon:getCondition() - 1)
    end
end

Events.OnWeaponSwing.Add(onWeaponSwing)
