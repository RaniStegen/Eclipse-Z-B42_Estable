require("JaxeRevival")

JaxeRevival.Side = {}

JaxeRevival.Side.COMMAND_REQUEST_SYNC = "REQUEST_SYNC"
JaxeRevival.Side.COMMAND_REPORT_REVIVE = "REPORT_REVIVE"
JaxeRevival.Side.COMMAND_REPORT_FASTFORWARD = "REPORT_FASTFORWARD"
JaxeRevival.Side.COMMAND_REPORT_GIVEUP = "REPORT_GIVEUP"

JaxeRevival.Side.COMMAND_ADMIN_INCAPACITATE = "ADMIN_INCAPACITATE"
JaxeRevival.Side.COMMAND_ADMIN_FASTFORWARD = "ADMIN_FASTFORWARD"
JaxeRevival.Side.COMMAND_ADMIN_REVIVE = "ADMIN_REVIVE"
JaxeRevival.Side.COMMAND_ADMIN_GIVEUP = "ADMIN_GIVEUP"

JaxeRevival.Side.isMultiplayer = function() return isClient() or isServer() end

JaxeRevival.Side.isClientOrSingleplayer = function() return not isServer() end

JaxeRevival.Side.isServerOrSingleplayer = function() return isServer() or not isClient() end

JaxeRevival.Side.isRemoteClient = function(player) return not isServer() and isClient() and getPlayer() ~= player end

JaxeRevival.Side.canUseAdminCommands = function(player) return player:getRole():hasCapability(Capability.ToggleGodModHimself) end

JaxeRevival.Side.getOnlinePlayer = function(username)
  if not username then return end

  local players = getOnlinePlayers()
  for i = 0, players:size() - 1 do
    local player = players:get(i)
    if player and player:getUsername() == username then return player end
  end
end

local sendToServer = function(command, args)
  if not isClient() then return end

  JaxeRevival.log(("Sent to server '%s' with target '%s'"):format(command, tostring(args and args.target)))

  sendClientCommand(getPlayer(), JaxeRevival.id, command, args or {})
end

JaxeRevival.Side.requestSync = function() sendToServer(JaxeRevival.Side.COMMAND_REQUEST_SYNC) end

JaxeRevival.Side.reportRevive = function(target) sendToServer(JaxeRevival.Side.COMMAND_REPORT_REVIVE, { target = target:getUsername() }) end

JaxeRevival.Side.reportFastForward = function() sendToServer(JaxeRevival.Side.COMMAND_REPORT_FASTFORWARD, { value = getPlayer():getModData().JaxeRevival_FastForwarding or false }) end

JaxeRevival.Side.reportGiveUp = function() sendToServer(JaxeRevival.Side.COMMAND_REPORT_GIVEUP) end

JaxeRevival.Side.reportChatCommand = function(command, args) sendToServer(command, args) end

local onServerCommand = function(module, command, args)
  if isServer() or module ~= JaxeRevival.id then return end

  args = args or {}

  local target = JaxeRevival.Side.getOnlinePlayer(args.target)
  JaxeRevival.log(("Client received '%s' from server with target '%s'"):format(command, tostring(target and target:getUsername())))

  if command == JaxeRevival.Server.COMMAND_SEND_SYNC then
    local modData = getPlayer():getModData()
    for k, v in pairs(args.modData) do modData[k] = v end

    for k, v in pairs(args.incapacitatedPlayers) do
      local incapacitatedPlayer = JaxeRevival.Side.getOnlinePlayer(k)
      if incapacitatedPlayer then JaxeRevival.Incapacitation.apply(incapacitatedPlayer, v) end
    end
  elseif target then
    if command == JaxeRevival.Server.COMMAND_SEND_INCAPACITATE then
      JaxeRevival.Incapacitation.apply(target, args.value)
    elseif command == JaxeRevival.Server.COMMAND_SEND_REVIVE then
      JaxeRevival.Health.revive(target, args.bandage, args.restore)
    elseif command == JaxeRevival.Server.COMMAND_SEND_KILL then
      JaxeRevival.Health.kill(target)
    end
  end
end
Events.OnServerCommand.Add(onServerCommand)
