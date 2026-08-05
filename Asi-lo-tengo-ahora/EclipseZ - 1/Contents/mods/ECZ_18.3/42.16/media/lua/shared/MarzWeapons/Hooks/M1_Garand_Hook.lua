require("TimedActions/ISReloadWeaponAction")
require("TimedActions/ISRackFirearm")

local SpentCasingPhysics = require("SpentCasingPhysics/Init")

local M1_CLIP_PARAMS = {
    forwardOffset = 0.30,
    sideOffset    = 0.10,
    heightOffset  = 0.45,
    shellForce    = 0.01,
    sideSpread    = 45,
    heightSpread  = { 70, 80 },
    customSound   = "M1PingDrop",
}

local function spawnM1Clip(player, weapon)
    if not SpentCasingPhysics then return end
    if isClient() then
        sendClientCommand("MarzGuns", "spawnM1Clip", { weaponId = weapon:getID() })
    elseif not isServer() then
        SpentCasingPhysics.doSpawnCasing(player, weapon, M1_CLIP_PARAMS, false, "MarzGuns.3006Clip8")
    end
end

------------------------------------------------
--  Play M1 Garand "ping" sound and spawn clip on empty fire
-------------------------------------------------
local old_ISReloadWeaponAction_onShoot = ISReloadWeaponAction.onShoot
Events.OnWeaponSwingHitPoint.Remove(ISReloadWeaponAction.onShoot)
ISReloadWeaponAction.onShoot = function(player, weapon)
    if weapon:getFullType() == "MarzGuns.M1_GARAND" then
        if weapon:isRoundChambered() and weapon:getCurrentAmmoCount() == 0 and weapon:isContainsClip() then
            player:getEmitter():playSound("M1Ping")
            if SpentCasingPhysics and SandboxVars.HB.PermanentCasings then
                spawnM1Clip(player, weapon)
                weapon:setContainsClip(false)
            end
        end
    end
    old_ISReloadWeaponAction_onShoot(player, weapon)
end
Events.OnWeaponSwingHitPoint.Add(ISReloadWeaponAction.onShoot)

------------------------------------------------
-- Play M1 Garand "ping" sound and spawn clip on empty rack
-------------------------------------------------
local ISRackFirearm_animEvent = ISRackFirearm.animEvent
function ISRackFirearm:animEvent(event, parameter)
    if event == 'ejectCasing' and self.gun:getFullType() == "MarzGuns.M1_GARAND" then
        if not self.gun:isRoundChambered() and self.gun:getCurrentAmmoCount() == 0 and self.gun:isContainsClip() then
            if self.racking and not self.emptyRack then
                self.character:getEmitter():playSound("M1Ping")
                if SpentCasingPhysics and SandboxVars.HB.PermanentCasings then
                    spawnM1Clip(self.character, self.gun)
                    self.gun:setContainsClip(false)
                end
            end
        end
    end
    return ISRackFirearm_animEvent(self, event, parameter)
end

------------------------------------------------
-- Server: handle spawnM1Clip command from client
------------------------------------------------
Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= "MarzGuns" or command ~= "spawnM1Clip" then return end
    if not player or not args then return end
    local weapon = player:getInventory():getItemById(args.weaponId)
    if not weapon then weapon = player:getPrimaryHandItem() end
    if not weapon then return end
    SpentCasingPhysics.doSpawnCasing(player, weapon, M1_CLIP_PARAMS, false, "MarzGuns.3006Clip8")
end)
