-- Per-shot black-powder fouling of the barrel.
--
-- Vanilla PZ only wears a firearm when a shot HITS something. Black-powder guns instead foul from
-- powder residue on EVERY shot, hit or miss, so we roll the wear ourselves per shot fired.
--
-- The trigger is OnWeaponSwing, which fires once per trigger-pull on the shooting path -- and,
-- importantly, does NOT fire when you unload the gun (unloading isn't an attack). We only foul a
-- LOADED gun, so a dry-fire on an empty chamber costs nothing.
if isServer() then
    return
end

local Condition = require("Gunsmithing/GunsmithingCondition")

---@param character IsoGameCharacter
---@param weapon HandWeapon
---@return nil
local function onWeaponSwing(character, weapon)
    if not Condition.isGunsmithingFirearm(weapon) then
        return
    end
    -- OnWeaponSwing fires before the round is consumed, so the count is still the pre-shot value.
    if weapon:getCurrentAmmoCount() <= 0 or weapon:getCondition() <= 0 then
        return
    end
    if Condition.getBarrel(weapon) <= 0 then
        return
    end

    -- Maintenance thins the fouling exactly the way vanilla's own damageCheck does: the skill level
    -- is added to the one-in-N denominator, so level 10 fouls a third as fast as level 0.
    local chance = weapon:getConditionLowerChance() + character:getPerkLevel(Perks.Maintenance)
    if chance < 1 then
        chance = 1
    end
    if ZombRand(chance) == 0 then
        Condition.setBarrel(weapon, Condition.getBarrel(weapon) - 1)
    end
end

Events.OnWeaponSwing.Add(onWeaponSwing)
