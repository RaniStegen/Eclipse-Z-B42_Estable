require("TimedActions/ISUpgradeWeapon")
require("TimedActions/ISRemoveWeaponUpgrade")

local Animations = require("WeaponSystems/Utils/Animations")
local StatsFactory = require("WeaponSystems/Utils/StatsFactory")

-- B42 caches several equipped-weapon fields, including the shot event. Applying
-- a suppressor changes SwingSound/SoundRadius/SoundVolume in Lua, but those
-- cached fields are not always rebuilt before the next shot. Refresh modifiers
-- first and then rebuild the equipped weapon immediately and once on the next
-- tick, after the vanilla timed action has fully finished.
local function refreshWeapon(character, weapon)
    if not character or not weapon or not instanceof(weapon, "HandWeapon") then return end

    StatsFactory.ReapplyAllModifiers(weapon)

    local equipped = character:getPrimaryHandItem() == weapon or character:getSecondaryHandItem() == weapon
    if equipped then
        Animations.CallSyncHandWeaponFields(character, weapon)
    end

    local function refreshNextTick()
        Events.OnTick.Remove(refreshNextTick)
        if not character or not weapon then return end
        StatsFactory.ReapplyAllModifiers(weapon)
        if character:getPrimaryHandItem() == weapon or character:getSecondaryHandItem() == weapon then
            Animations.CallSyncHandWeaponFields(character, weapon)
        end
    end
    Events.OnTick.Add(refreshNextTick)
end

if not ISUpgradeWeapon.MarzGunsImmediateRefresh then
    local originalComplete = ISUpgradeWeapon.complete
    function ISUpgradeWeapon:complete()
        local result = originalComplete(self)
        if result ~= false then
            refreshWeapon(self.character, self.weapon)
        end
        return result
    end
    ISUpgradeWeapon.MarzGunsImmediateRefresh = true
end

if not ISRemoveWeaponUpgrade.MarzGunsImmediateRefresh then
    local originalComplete = ISRemoveWeaponUpgrade.complete
    function ISRemoveWeaponUpgrade:complete()
        local result = originalComplete(self)
        if result ~= false then
            refreshWeapon(self.character, self.weapon)
        end
        return result
    end
    ISRemoveWeaponUpgrade.MarzGunsImmediateRefresh = true
end
