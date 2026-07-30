OfflineSurvivorV2 = OfflineSurvivorV2 or {}

local OS = OfflineSurvivorV2

OS.MODULE = "OfflineSurvivorV2"
OS.DATA_KEY = "OfflineSurvivorV2.Records"
OS.LOOT_DATA_KEY = "OfflineSurvivorV2.LootCooldowns"
OS.OFFLINE_MARKER = "offlineSurvivorV2"
OS.VISUAL_CLONE_MARKER = "offlineSurvivorV2VisualClone"
OS.RENDERER = "corpse"
-- Server authority: this does not depend on a client command arriving during logout.
OS.SERVER_SCAN_SECONDS = 1
OS.LOOT_SESSION_SECONDS = 60

-- IsoDeadBody uses the engine's frozen player dead-body pose.  It is a real
-- human mesh, not a mannequin, tile, sprite or live NPC.
OS.CORPSE_POSE = "player_deadbody"

OS.COMMAND_REQUEST_LOOT = "RequestLoot"
OS.COMMAND_COMMIT_LOOT = "CommitLoot"
OS.COMMAND_CANCEL_LOOT = "CancelLoot"
OS.COMMAND_OPEN_LOOT = "OpenLoot"
OS.COMMAND_LOOT_RESULT = "LootResult"
OS.COMMAND_LOOT_NOTICE = "LootNotice"

function OS.isEnabled()
    local options = SandboxVars and SandboxVars.OfflineSurvivorV2
    return not options or options.EnableMod ~= false
end

function OS.getOption(name, default)
    -- Never cache SandboxVars. The official B42 SandboxOptions packet calls
    -- toLua() on server and clients, so the next server tick sees its value.
    local options = SandboxVars and SandboxVars.OfflineSurvivorV2
    if options and options[name] ~= nil then return options[name] end
    return default
end

function OS.getSteamId(player)
    local steamId = player and player:getSteamID()
    if steamId and tostring(steamId) ~= "0" then return tostring(steamId) end
    return player and player:getUsername() or nil
end
