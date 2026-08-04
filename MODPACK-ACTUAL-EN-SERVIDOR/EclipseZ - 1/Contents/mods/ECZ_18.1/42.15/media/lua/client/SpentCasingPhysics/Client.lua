local SpentCasingPhysics = require("SpentCasingPhysics/Init")

function SpentCasingPhysics.HBVCEF_onWeaponSwing(player, weapon)
    if not player or not weapon then return end
    if player:isDoShove() then return end
    if weapon:isRackAfterShoot() or SpentCasingPhysics.usesManualSpentRoundRemoval(weapon) or weapon:isMelee() or SpentCasingPhysics.AMMOMAKER then return end

    if isClient() and player.isLocalPlayer and not player:isLocalPlayer() then
        return
    end

    if isClient() then
        sendClientCommand("HBVCEF", "spawnCasing", {
            weaponId = weapon:getID(),
        })
    else
        if SpentCasingPhysics.spawnCasing then
            SpentCasingPhysics.spawnCasing(player, weapon)
        end
    end
end

function SpentCasingPhysics.onServerCommand(module, command, args)
    if module ~= "HBVCEF" then return end
    if command ~= "playCasingImpactSound" then return end
    if not args or not args.sound then return end

    local player = getPlayer()
    if not player then return end

    player:getEmitter():playSound(args.sound)
end

Events.OnWeaponSwing.Add(SpentCasingPhysics.HBVCEF_onWeaponSwing)
Events.OnServerCommand.Add(SpentCasingPhysics.onServerCommand)
