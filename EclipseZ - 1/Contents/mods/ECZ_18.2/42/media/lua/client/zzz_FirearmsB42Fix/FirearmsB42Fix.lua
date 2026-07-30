require "TimedActions/ISUpgradeWeapon"
require "TimedActions/ISRemoveWeaponUpgrade"

local CALIBERS = {
    bullets_22     = { "SuppressorEffectiveness22", "Firearm9mmSuppressed" },
    bullets_9mm    = { "SuppressorEffectiveness9mm", "Firearm9mmSuppressed" },
    bullets_45     = { "SuppressorEffectiveness45", "Firearm45Suppressed" },
    bullets_44     = { "SuppressorEffectiveness44", "Firearm45Suppressed" },
    bullets_44_40  = { "SuppressorEffectiveness44", "Firearm45Suppressed" },
    bullets_38     = { "SuppressorEffectiveness38", "Firearm45Suppressed" },
    bullets_357    = { "SuppressorEffectiveness38", "Firearm45Suppressed" },
    bullets_223    = { "SuppressorEffectiveness223", "FirearmARSuppressed" },
    bullets_556    = { "SuppressorEffectiveness223", "FirearmARSuppressed" },
    bullets_308    = { "SuppressorEffectiveness308", "FirearmARSuppressed" },
    bullets_762x51 = { "SuppressorEffectiveness308", "FirearmARSuppressed" },
    bullets_762x39 = { "SuppressorEffectiveness308", "FirearmARSuppressed" },
    bullets_30_06  = { "SuppressorEffectiveness308", "FirearmARSuppressed" },
    bullets_3030   = { "SuppressorEffectiveness308", "FirearmARSuppressed" },
    bullets_10mm   = { "SuppressorEffectiveness10mm", "Firearm45Suppressed" },
    shotgun_shells = { "SuppressorEffectivenessShotgunShells", "FirearmShotgunSilencerShot" },
}

local INTERNAL_MAGAZINES = {
    ["Base.223Clip_Attachment"] = true,
    ["Base.556Clip_Attachment"] = true,
    ["Base.AK_Mag_Attachment"] = true,
    ["Base.AKM_Mag_Attachment"] = true,
    ["Base.FN_FAL_Mag_Attachment"] = true,
    ["Base.G3_Mag_Attachment"] = true,
    ["Base.JS14_Clip_Attachment"] = true,
    ["Base.M14Clip_Attachment"] = true,
    ["Base.M60Mag_Attachment"] = true,
    ["Base.Mac10Mag_Attachment"] = true,
    ["Base.MP510Mag_Attachment"] = true,
    ["Base.MP5Mag_Attachment"] = true,
    ["Base.UZIMag_Attachment"] = true,
}

local function isLooseInternalMagazine(item)
    return item and INTERNAL_MAGAZINES[item:getFullType()] == true
end

local function purgeLooseInternalMagazines()
    for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex)
        if player then
            local items = player:getInventory():getAllEvalRecurse(isLooseInternalMagazine)
            for index = items:size() - 1, 0, -1 do
                local item = items:get(index)
                local container = item:getContainer()
                if container then
                    sendRemoveItemFromContainer(container, item)
                    container:Remove(item)
                end
            end
        end
    end
end

local purgeTick = 0
local function periodicallyPurgeLooseInternalMagazines()
    purgeTick = purgeTick + 1
    if purgeTick < 30 then return end
    purgeTick = 0
    purgeLooseInternalMagazines()
end

local function effectiveness(index)
    index = tonumber(index) or 1
    index = math.max(1, math.min(10, index))
    return (index - 1) / 10
end

local function suppressorFactor(part)
    local partType = part:getType()
    if partType == "ImprovisedSilencer" or partType == "Silencer_PopBottle" then
        return effectiveness(SandboxVars.Firearms.SuppressorEffectivenessImprovised)
    end
    return 1
end

local function isSuppressor(part)
    return part and FirearmsTags and FirearmsTags.firearmsSuppressor
        and part:hasTag(FirearmsTags.firearmsSuppressor)
end

local function ammoName(weapon)
    local ammoType = weapon:getAmmoType()
    if not ammoType then return nil end
    local name = string.lower(string.match(tostring(ammoType), "[:.]([^:.]+)$") or tostring(ammoType))

    -- Some B42 weapons expose the backing inventory-item name instead of the
    -- registered ammo ResourceLocation. Treat both forms as the same caliber.
    local aliases = {
        bullets22 = "bullets_22",
        bullets9mm = "bullets_9mm",
        bullets10mm = "bullets_10mm",
        bullets38 = "bullets_38",
        bullets357 = "bullets_357",
        bullets44 = "bullets_44",
        bullets4440 = "bullets_44_40",
        bullets45 = "bullets_45",
        bullets223 = "bullets_223",
        bullets556 = "bullets_556",
        bullets308 = "bullets_308",
        bullets762x39 = "bullets_762x39",
        bullets762x51 = "bullets_762x51",
        bullets3006 = "bullets_30_06",
        bullets3030 = "bullets_3030",
        shotgunshells = "shotgun_shells",
        ["9mmbullets"] = "bullets_9mm",
    }
    return aliases[name] or name
end

local function refreshSuppressor(weapon)
    if not weapon or not weapon:IsWeapon() or not weapon:isRanged() then return end

    local scriptItem = weapon:getScriptItem()
    if not scriptItem then return end

    local soundVolume = scriptItem:getSoundVolume()
    local soundRadius = scriptItem:getSoundRadius()
    local swingSound = scriptItem:getSwingSound()
    local canon = weapon:getWeaponPart("Canon")
    local integral = FirearmsTags and FirearmsTags.firearmsSuppressor
        and weapon:hasTag(FirearmsTags.firearmsSuppressor)

    if isSuppressor(canon) or integral then
        local caliber = CALIBERS[ammoName(weapon)]
        if caliber then
            local caliberFactor = effectiveness(SandboxVars.Firearms[caliber[1]])
            local factor = caliberFactor

            if canon then
                local partFactor = suppressorFactor(canon)
                factor = caliberFactor + ((1 - caliberFactor) * (1 - partFactor))
            end

            local reloadType = tostring(weapon:getWeaponReloadType())
            if string.lower(reloadType) == "revolver" then
                local revolverFactor = effectiveness(SandboxVars.Firearms.SuppressorEffectivenessRevolver)
                factor = factor + ((1 - factor) * (1 - revolverFactor))
            end

            soundVolume = soundVolume * 0.6
            soundRadius = soundRadius * factor
            swingSound = caliber[2]
        end
    end

    weapon:setSoundVolume(soundVolume)
    weapon:setSoundRadius(soundRadius)
    weapon:setSwingSound(swingSound)
end

local function refreshAndSync(character, weapon)
    refreshSuppressor(weapon)
    if character and weapon then
        syncHandWeaponFields(character, weapon)
    end
end

local originalUpgradeComplete = ISUpgradeWeapon.complete
function ISUpgradeWeapon:complete()
    local result = originalUpgradeComplete(self)
    refreshAndSync(self.character, self.weapon)
    return result
end

local originalRemoveComplete = ISRemoveWeaponUpgrade.complete
function ISRemoveWeaponUpgrade:complete()
    local result = originalRemoveComplete(self)
    refreshAndSync(self.character, self.weapon)
    return result
end

local function onEquipPrimary(character, weapon)
    refreshSuppressor(weapon)
end

local soundRefreshTick = 0
local function periodicallyRefreshPrimaryWeapon()
    soundRefreshTick = soundRefreshTick + 1
    if soundRefreshTick < 5 then return end
    soundRefreshTick = 0

    for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex)
        if player then
            -- Always recalculate from the script defaults. This also repairs
            -- cases where B42 restores a handgun's normal SwingSound after the
            -- suppressor was attached while the weapon remained equipped.
            refreshSuppressor(player:getPrimaryHandItem())
        end
    end
end

Events.OnEquipPrimary.Add(onEquipPrimary)

Events.OnContainerUpdate.Add(purgeLooseInternalMagazines)
Events.OnTick.Add(periodicallyPurgeLooseInternalMagazines)
Events.OnTick.Add(periodicallyRefreshPrimaryWeapon)

Events.OnGameStart.Add(function()
    purgeLooseInternalMagazines()
    local player = getPlayer()
    if not player then return end
    local weapon = player:getPrimaryHandItem()
    refreshAndSync(player, weapon)
end)
