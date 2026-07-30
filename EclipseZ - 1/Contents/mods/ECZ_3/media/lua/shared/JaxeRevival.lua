JaxeRevival = {}
JaxeRevival.id = "JaxeRevival"

local prefixMessage = function(message) return "[" .. JaxeRevival.id .. "] " .. message end

JaxeRevival.log = function(message)
  if not getDebug() and not JaxeRevival.debug then return end
  print(prefixMessage(message))
end

JaxeRevival.logAdmin = function(message) writeLog("admin", prefixMessage(message)) end

JaxeRevival.error = function(message) error(prefixMessage(message)) end

JaxeRevival.down = function(target) JaxeRevival.Side.reportChatCommand(JaxeRevival.Side.COMMAND_ADMIN_INCAPACITATE, { target = target }) end

JaxeRevival.sleep = function(target) JaxeRevival.Side.reportChatCommand(JaxeRevival.Side.COMMAND_ADMIN_FASTFORWARD, { target = target }) end

JaxeRevival.revive = function(target) JaxeRevival.Side.reportChatCommand(JaxeRevival.Side.COMMAND_ADMIN_REVIVE, { target = target }) end

JaxeRevival.giveup = function(target) JaxeRevival.Side.reportChatCommand(JaxeRevival.Side.COMMAND_ADMIN_GIVEUP, { target = target }) end

JaxeRevival.log("Initialized.")
