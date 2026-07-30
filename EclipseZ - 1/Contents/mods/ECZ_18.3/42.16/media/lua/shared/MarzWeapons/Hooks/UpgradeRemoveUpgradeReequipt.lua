require("TimedActions/ISUpgradeWeapon")
require("TimedActions/ISRemoveWeaponUpgrade")

local Animations = require("WeaponSystems/Utils/Animations")

local _ISUpgradeWeapon_complete = ISUpgradeWeapon.complete
function ISUpgradeWeapon:complete()
    _ISUpgradeWeapon_complete(self)
    Animations.CallSyncHandWeaponFields(self.character, self.weapon)
end

local _ISRemoveWeaponUpgrade_complete = ISRemoveWeaponUpgrade.complete
function ISRemoveWeaponUpgrade:complete()
    _ISRemoveWeaponUpgrade_complete(self)
    Animations.CallSyncHandWeaponFields(self.character, self.weapon)
end
