require('TimedActions/ISReloadWeaponAction')
require('TimedActions/ISRackFirearm')

local SpentCasingPhysics = require("SpentCasingPhysics/Init")
local Ammo = require("WeaponSystems/Utils/Ammo")

local function applyTimedActionHooks()
    ------- Racking ---------------
    local ISRackFirearm_removeBullets = ISRackFirearm.removeBullet
    function ISRackFirearm:removeBullet()
        if SpentCasingPhysics.usesManualSpentRoundRemoval(self.gun) or not SandboxVars.HB.PermanentCasings then
            ISRackFirearm_removeBullets(self)
        else
            self.emptyRack = false
            if SpentCasingPhysics.GWG and Ammo then
                local ammoList = self.gun:getModData().AmmoList
                if ammoList and #ammoList > 0 then
                    local bulletType = ammoList[#ammoList]
                    Ammo.AmmoProfileSetter(self.gun, bulletType)
                    ammoList[#ammoList] = nil
                    if #ammoList == 0 then
                        self.gun:getModData().AmmoList = nil
                    end
                    Ammo.SyncAmmoListToClient(self.character, self.gun)
                end
            end
        end
    end

    local ISRackFirearm_ejectSpentRounds = ISRackFirearm.ejectSpentRounds
    function ISRackFirearm:ejectSpentRounds()
        if SpentCasingPhysics and not SpentCasingPhysics.AMMOMAKER then
            if SpentCasingPhysics.GWG and Ammo and self.gun:getModData().SpentAmmoList then
                if not isClient() then
                    local spentList = self.gun:getModData().SpentAmmoList
                    for _, bulletType in ipairs(spentList) do
                        Ammo.AmmoProfileSetter(self.gun, bulletType)
                        SpentCasingPhysics.rackCasing(self.character, self.gun, false)
                    end
                end
                self.gun:getModData().SpentAmmoList = nil
                self.gun:setSpentRoundCount(0)
                syncHandWeaponFields(self.character, self.gun)
            elseif self.gun:getSpentRoundCount() > 0 then
                if not isClient() then
                    for i = 1, self.gun:getSpentRoundCount() do
                        SpentCasingPhysics.rackCasing(self.character, self.gun, false)
                    end
                end
                self.gun:setSpentRoundCount(0)
                syncHandWeaponFields(self.character, self.gun)
            elseif self.gun:isSpentRoundChambered() then
                self.gun:setSpentRoundChambered(false)
                self.ejectingSpentRound = true
                self.racking = false
                syncHandWeaponFields(self.character, self.gun)
            else
                return
            end
        else
            ISRackFirearm_ejectSpentRounds(self)
        end
    end

    local ISRackFirearm_animEvent = ISRackFirearm.animEvent
    function ISRackFirearm:animEvent(event, parameter)
        if event == 'ejectCasing' then
            if self.ejectingSpentRound then
                if isClient() then
                    sendClientCommand("HBVCEF", "rackCasing", {
                        weaponId = self.gun:getID(),
                        racking  = false,
                    })
                else
                    SpentCasingPhysics.rackCasing(self.character, self.gun, false)
                end
            end
            local hasRoundToEject = not self.emptyRack
            if not hasRoundToEject
                and isClient()
                and not SpentCasingPhysics.usesManualSpentRoundRemoval(self.gun)
                and not self.gun:isJammed() then
                hasRoundToEject = self.hadRoundChambered
            end
            if self.racking and hasRoundToEject then
                if isClient() then
                    sendClientCommand("HBVCEF", "rackCasing", {
                        weaponId = self.gun:getID(),
                        racking  = true,
                    })
                else
                    SpentCasingPhysics.rackCasing(self.character, self.gun, true)
                end
            end
        end
        return ISRackFirearm_animEvent(self, event, parameter)
    end

    local ISRackFirearm_new = ISRackFirearm.new
    function ISRackFirearm:new(character, gun)
        local o = ISRackFirearm_new(self, character, gun)
        o.ejectingSpentRound = false
        o.racking = true
        o.emptyRack = true
        o.hadRoundChambered = gun:isRoundChambered()
        return o
    end

    ------- Reloading -------------
    local ISReloadWeaponAction_ejectSpentRounds = ISReloadWeaponAction.ejectSpentRounds
    function ISReloadWeaponAction:ejectSpentRounds()
        if SpentCasingPhysics and not SpentCasingPhysics.AMMOMAKER then
            if SpentCasingPhysics.GWG and Ammo and self.gun:getModData().SpentAmmoList then
                if not isClient() then
                    local spentList = self.gun:getModData().SpentAmmoList
                    for _, bulletType in ipairs(spentList) do
                        Ammo.AmmoProfileSetter(self.gun, bulletType)
                        SpentCasingPhysics.rackCasing(self.character, self.gun, false)
                    end
                end
                self.gun:getModData().SpentAmmoList = nil
                self.gun:setSpentRoundCount(0)
                syncHandWeaponFields(self.character, self.gun)
            elseif self.gun:getSpentRoundCount() > 0 then
                if not isClient() then
                    for i = 1, self.gun:getSpentRoundCount() do
                        SpentCasingPhysics.rackCasing(self.character, self.gun, false)
                    end
                end
                self.gun:setSpentRoundCount(0)
                syncHandWeaponFields(self.character, self.gun)
            elseif self.gun:isSpentRoundChambered() then
                self.gun:setSpentRoundChambered(false)
                if not isClient() then
                    SpentCasingPhysics.rackCasing(self.character, self.gun, false)
                end
                syncHandWeaponFields(self.character, self.gun)
            else
                return
            end
        else
            ISReloadWeaponAction_ejectSpentRounds(self)
        end
    end

    ------- Attack Hook for SpentAmmoList -------------
    local Attack_Hook_Original = ISReloadWeaponAction.attackHook
    Hook.Attack.Remove(ISReloadWeaponAction.attackHook)

    ISReloadWeaponAction.attackHook = function(character, chargeDelta, weapon)
        if weapon:isRanged() and not character:isDoShove() then
            if ISReloadWeaponAction.canShoot(character, weapon) then
                if SpentCasingPhysics.usesManualSpentRoundRemoval(weapon) and SpentCasingPhysics.GWG and not SpentCasingPhysics.AMMOMAKER and Ammo then
                    local ammoList = weapon:getModData().AmmoList
                    if ammoList and #ammoList > 0 then
                        local bulletType = ammoList[#ammoList]
                        local spentList = weapon:getModData().SpentAmmoList
                        if not spentList then
                            spentList = {}
                            weapon:getModData().SpentAmmoList = spentList
                        end
                        spentList[#spentList + 1] = bulletType

                        if isClient() then
                            sendClientCommand(character, "HBVCEF", "appendSpent", {
                                weaponId   = weapon:getID(),
                                bulletType = bulletType,
                            })
                        end
                    end
                end
            end
            Attack_Hook_Original(character, chargeDelta, weapon)
        else
            Attack_Hook_Original(character, chargeDelta, weapon)
        end
    end

    Hook.Attack.Add(ISReloadWeaponAction.attackHook)
end

Events.OnGameStart.Add(applyTimedActionHooks)
Events.OnServerStarted.Add(applyTimedActionHooks)

------- OnShoot -------------
Events.OnWeaponSwingHitPoint.Remove(ISReloadWeaponAction.onShoot)
ISReloadWeaponAction.onShoot = function(player, weapon)
    if not weapon:isRanged() then return; end

    if MoodlesUI.getInstance() then
        MoodlesUI.getInstance():wiggle(MoodleType.PANIC);
        MoodlesUI.getInstance():wiggle(MoodleType.STRESS);
        MoodlesUI.getInstance():wiggle(MoodleType.DRUNK);
        MoodlesUI.getInstance():wiggle(MoodleType.TIRED);
        MoodlesUI.getInstance():wiggle(MoodleType.ENDURANCE);
        local body = player:getBodyDamage():getBodyParts()
        for x = BodyPartType.ToIndex(BodyPartType.Hand_L), BodyPartType.ToIndex(BodyPartType.UpperArm_R), 1 do
            if body:get(x):getPain() then
                MoodlesUI.getInstance():wiggle(MoodleType.PAIN);
                break
            end
        end
    end

    if getDebug() and player:isUnlimitedAmmo() then
        return;
    end

    if weapon:haveChamber() then
        weapon:setRoundChambered(false);
        weapon:setSpentRoundChambered(true)
    end
    if not weapon:isRackAfterShoot() then
        if not SpentCasingPhysics.usesManualSpentRoundRemoval(weapon) then
            weapon:setSpentRoundChambered(false)
        end
        if weapon:getCurrentAmmoCount() >= weapon:getAmmoPerShoot() then
            if weapon:haveChamber() then
                weapon:setRoundChambered(true);
            end
            if not isClient() then
                weapon:setCurrentAmmoCount(weapon:getCurrentAmmoCount() - weapon:getAmmoPerShoot())
            end
            if (weapon:getJamGunChance() > 0) then
                weapon:checkJam(player, false)
            end
        end
    end
    if SpentCasingPhysics.usesManualSpentRoundRemoval(weapon) then
        weapon:setSpentRoundCount(weapon:getSpentRoundCount() + weapon:getAmmoPerShoot())
    end

    syncHandWeaponFields(player, weapon)
end

Events.OnWeaponSwingHitPoint.Add(ISReloadWeaponAction.onShoot)
