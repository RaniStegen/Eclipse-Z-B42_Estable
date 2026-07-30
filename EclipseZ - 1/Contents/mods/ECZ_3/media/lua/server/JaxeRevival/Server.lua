require("JaxeRevival")

JaxeRevival.Server = {}

JaxeRevival.Server.COMMAND_SEND_SYNC = "SEND_SYNC"
JaxeRevival.Server.COMMAND_SEND_INCAPACITATE = "SEND_INCAPACITATE"
JaxeRevival.Server.COMMAND_SEND_FASTFORWARD = "SEND_FASTFORWARD"
JaxeRevival.Server.COMMAND_SEND_REVIVE = "SEND_REVIVE"
JaxeRevival.Server.COMMAND_SEND_KILL = "SEND_KILL"

local sendToClients = function(command, args, player)
  if player then
    sendServerCommand(player, JaxeRevival.id, command, args)
  else
    sendServerCommand(JaxeRevival.id, command, args)
  end
end

local incapacitatedPlayers = {}
local sendSync = function(player)
  local args = {}
  args.modData = {}
  args.incapacitatedPlayers = incapacitatedPlayers

  for k, v in pairs(player:getModData()) do if k:sub(1, 12) == "JaxeRevival_" then args.modData[k] = v end end

  sendToClients(JaxeRevival.Server.COMMAND_SEND_SYNC, args, player)
end

local sendIncapacitate = function(initiator, target, value)
  incapacitatedPlayers[target] = value or nil
  sendToClients(JaxeRevival.Server.COMMAND_SEND_INCAPACITATE, { initiator = initiator, target = target, value = value })
end

local sendRevive = function(initiator, target, bandage, restore)
  incapacitatedPlayers[target] = nil
  sendToClients(JaxeRevival.Server.COMMAND_SEND_REVIVE, { initiator = initiator, target = target, bandage = bandage, restore = restore })
end

local sendKill = function(initiator, target)
  incapacitatedPlayers[target] = nil
  sendToClients(JaxeRevival.Server.COMMAND_SEND_KILL, { initiator = initiator, target = target })
end

local logAdminCommandInvalidTarget = function(player, command, target) JaxeRevival.log(("%s attempts command %s on invalid target '%s'"):format(player:getUsername(), command, tostring(target))) end

local logAdminCommandSuccess = function(player, command, target) JaxeRevival.log(("%s attempts command %s on %s"):format(player:getUsername(), command, tostring(target))) end

local onClientCommand = function(module, command, player, args)
  if module ~= JaxeRevival.id then return end

  args = args or {}

  local target = JaxeRevival.Side.getOnlinePlayer(args.target)
  JaxeRevival.log(("Server received '%s' from '%s' with target '%s'"):format(command, tostring(player and player:getUsername() or player), tostring(target and target:getUsername() or args.target)))

  if command == JaxeRevival.Side.COMMAND_REQUEST_SYNC then
    sendSync(player)
  elseif command == JaxeRevival.Side.COMMAND_REPORT_INCAPACITATE then
    sendIncapacitate(player, args.target, args.value)
  elseif command == JaxeRevival.Side.COMMAND_REPORT_REVIVE then
    sendRevive(player, args.target, args.bandage, args.restore)
  elseif command == JaxeRevival.Side.COMMAND_REPORT_GIVEUP then
    sendKill(player, args.target)
  elseif command == JaxeRevival.Side.COMMAND_REPORT_FASTFORWARD then
    JaxeRevival.State.setFastForwarding(player, args.value)
  else
    if not target then return logAdminCommandInvalidTarget(player, command, args.target) end
    logAdminCommandSuccess(player, command, args.target)

    if command == JaxeRevival.Side.COMMAND_ADMIN_INCAPACITATE then
      sendIncapacitate(nil, args.target, true)
    elseif command == JaxeRevival.Side.COMMAND_ADMIN_FASTFORWARD then
      JaxeRevival.State.setFastForwarding(target, true)
      sendSync(target)
    elseif command == JaxeRevival.Side.COMMAND_ADMIN_REVIVE then
      sendRevive(nil, args.target, nil, true)
    elseif command == JaxeRevival.Side.COMMAND_ADMIN_GIVEUP then
      sendKill(nil, args.target)
    end
  end
end
Events.OnClientCommand.Add(onClientCommand)

local onServerStarted = function() JaxeRevival.Compatibility.initialize() end
Events.OnServerStarted.Add(onServerStarted)
