-- The Gunworks reload framework auto-reconciles only ONE flintlock (profile.partState.flint).
-- The double-barrel flintlock shotgun has TWO (left + right), each with a Cooked/Uncooked
-- variant, so we mirror the framework's per-ammo reconcile for both here: cocked when the gun
-- holds a charge, uncocked when empty. We stand down while a reload is in progress so the
-- reload clip's own prop/ramrod beats aren't fought, exactly like PartState.lua does.
if isServer() then
    return
end

local GUN = "Gunsmithing.DoubleBarrelFlintlockShotgun"

local LOCKS = {
    {
        partType = "GunsmithingDoubleBarrelFlintlockShotgun_Right",
        cooked = "Gunsmithing.DoubleBarrelFlintlockShotgun_RightCooked",
        uncooked = "Gunsmithing.DoubleBarrelFlintlockShotgun_RightUncooked",
    },
    {
        partType = "GunsmithingDoubleBarrelFlintlockShotgun_Left",
        cooked = "Gunsmithing.DoubleBarrelFlintlockShotgun_LeftCooked",
        uncooked = "Gunsmithing.DoubleBarrelFlintlockShotgun_LeftUncooked",
    },
}

---@param player IsoPlayer
---@param gun HandWeapon
---@param lock table
---@param want string fullType the lock should currently be
---@nodiscard
---@return boolean changed
local function applyLock(player, gun, lock, want)
    local cur = gun:getWeaponPart(lock.partType)
    if cur and cur:getFullType() == want then
        return false
    end
    if cur then
        gun:detachWeaponPart(player, cur, false)
    end
    local part = instanceItem(want)
    if part and instanceof(part, "WeaponPart") then
        gun:attachWeaponPart(player, part, false)
    end
    return true
end

---@param player IsoPlayer|nil
---@return nil
local function reconcileDoubleBarrelLocks(player)
    if not player then
        return
    end

    local gun = player:getPrimaryHandItem()
    if not instanceof(gun, "HandWeapon") or gun:getFullType() ~= GUN then
        return
    end

    -- The reload clip owns the visuals during a reload; let it run.
    if player:getVariableString("PerformingAction") == "Reload" then
        return
    end

    local cocked = gun:getCurrentAmmoCount() > 0
    local changed = false
    for i = 1, #LOCKS do
        local lock = LOCKS[i]
        local want = cocked and lock.cooked or lock.uncooked
        if applyLock(player, gun, lock, want) then
            changed = true
        end
    end

    if changed then
        player:resetEquippedHandsModels()
    end
end

-- Register with Gunworks' shared part-reconcile scheduler rather than adding our own OnPlayerUpdate
-- handler, so this runs in one ordered pass with the framework's reload reconciler (order 20 = after
-- reload). The two lock PartTypes are declared so the scheduler's boot-time conflict check can warn if
-- anything else ever claims them.
local PartReconcile = require("WeaponSystems/Utils/PartReconcile")
PartReconcile.register("gunsmithing-doublebarrel-locks", 20, reconcileDoubleBarrelLocks, {
    "GunsmithingDoubleBarrelFlintlockShotgun_Right",
    "GunsmithingDoubleBarrelFlintlockShotgun_Left",
})
