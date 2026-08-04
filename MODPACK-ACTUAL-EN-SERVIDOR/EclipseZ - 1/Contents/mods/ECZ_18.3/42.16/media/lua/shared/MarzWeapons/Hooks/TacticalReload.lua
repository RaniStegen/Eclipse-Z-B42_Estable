require("TimedActions/ISReloadWeaponAction")
require("TimedActions/ISEjectMagazine")
require("TimedActions/ISInsertMagazine")

local r = newrandom()
local Magazine = require("WeaponSystems/Utils/Magazine")
local Ammo = require("WeaponSystems/Utils/Ammo")
local SpentCasingPhysics = require("SpentCasingPhysics/Init")

local MODULE = "MarzGunsTacticalReload"


local function doTacticalEject(player, gun)
    if not gun:isContainsClip() then return end
    local magType   = gun:getMagazineType()
    local ammoCount = gun:getCurrentAmmoCount()
    if not magType then return end

    local gunModData     = gun:getModData()
    local gunAmmoList    = gunModData.AmmoList
    local ammoListForMag = nil

    if gunAmmoList and #gunAmmoList > 0 then
        if gun:isRoundChambered() and #gunAmmoList > 1 then
            ammoListForMag = {}
            for i = 1, #gunAmmoList - 1 do
                ammoListForMag[#ammoListForMag + 1] = gunAmmoList[i]
            end
            gunModData.AmmoList = { gunAmmoList[#gunAmmoList] }
        elseif gun:isRoundChambered() then
            gunModData.AmmoList = { gunAmmoList[#gunAmmoList] }
        else
            ammoListForMag = {}
            for i = 1, #gunAmmoList do
                ammoListForMag[i] = gunAmmoList[i]
            end
            gunModData.AmmoList = nil
        end
    else
        gunModData.AmmoList = nil
    end

    gun:setContainsClip(false)
    gun:setCurrentAmmoCount(0)
    Magazine.manageMagazineAttachment(gun)
    syncHandWeaponFields(player, gun)

    if gun:getEjectAmmoSound() then
        player:getEmitter():playSound(gun:getEjectAmmoSound())
    end

    local newMag = instanceItem(magType)
    if not newMag then return end
    newMag:setCurrentAmmoCount(ammoCount)
    if ammoListForMag then
        newMag:getModData().AmmoList = ammoListForMag
    end

    Ammo.SyncAmmoListToClient(player, gun)
    Ammo.SyncAmmoListToClient(player, newMag)
    local soundIndex = r:random(4)

    local MAG_DROP_PARAMS = {
        forwardOffset = 0.15,
        sideOffset    = 0.0,
        heightOffset  = 0.40,
        shellForce    = 0.08,
        sideSpread    = 6,
        heightSpread  = { 8, 12 },
        verticalForce = 0.02,
        customSound   = "MagDrop" .. soundIndex,
        floorBounces  = 0
    }

    if SpentCasingPhysics and SpentCasingPhysics.doSpawnCasing then
        SpentCasingPhysics.doSpawnCasing(player, gun, MAG_DROP_PARAMS, false, newMag)
    else
        local sq = player:getCurrentSquare()
        if sq then
            sq:AddWorldInventoryItem(newMag, 0, 0, 0)
        end
    end
end

local function getBestMagazine(player, gun)
    if Magazine.GetProfileForGun(gun) then
        return Magazine.getBestMagazineForGun(player, gun)
    end
    return gun:getBestMagazine(player)
end

local OnPressReload_Original = ISReloadWeaponAction.OnPressReloadButton

local function onPressReloadButtonTactical(player, gun)
    if ISReloadWeaponAction.disableReloading then return end

    gun = player:getPrimaryHandItem()
    if not gun then return end

    if not gun:getMagazineType()
        or not gun:isContainsClip()
        or not player:getVariableBoolean("isUnloading")
        or gun:getFullType() == "MarzGuns.M1_GARAND" then
        OnPressReload_Original(player, gun)
        return
    end

    ISTimedActionQueue.clear(player)

    if isClient() then
        sendClientCommand(MODULE, "ejectMag", {})
    else
        doTacticalEject(player, gun)
    end

    local nextMag = getBestMagazine(player, gun)
    if nextMag then
        ISInventoryPaneContextMenu.transferIfNeeded(player, nextMag)
        ISTimedActionQueue.add(ISInsertMagazine:new(player, gun, nextMag))
    end
end

local function onClientCommand(module, command, playerObj, args)
    if module ~= MODULE or command ~= "ejectMag" then return end
    local gun = playerObj:getPrimaryHandItem()
    if not gun then return end
    doTacticalEject(playerObj, gun)
end

Events.OnGameStart.Add(function()
    local enableTacticalReload = (SandboxVars and SandboxVars.MarzGuns and SandboxVars.MarzGuns.Enable_TacticalReload) or false
    if enableTacticalReload then
        Events.OnClientCommand.Add(onClientCommand)
        Events.OnPressReloadButton.Remove(ISReloadWeaponAction.OnPressReloadButton)
        Events.OnPressReloadButton.Add(onPressReloadButtonTactical)
    end
end)
