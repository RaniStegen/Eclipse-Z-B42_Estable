require("JaxeRevival")

JaxeRevival.Input = {}

local oldHandler = ISChat.onCommandEntered

local sendChatCommand = function(name, command, args)
  JaxeRevival.Input.addChatLine("Attempting to " .. name .. " " .. tostring(args.target) .. " <LINE> ")
  JaxeRevival.Side.reportChatCommand(command, args)
end

local validCommands = {
  down = function(target) sendChatCommand("force-incapacitate", JaxeRevival.Side.COMMAND_ADMIN_INCAPACITATE, { target = target }) end,
  sleep = function(target) sendChatCommand("force-sleep", JaxeRevival.Side.COMMAND_ADMIN_FASTFORWARD, { target = target }) end,
  revive = function(target) sendChatCommand("force-revive", JaxeRevival.Side.COMMAND_ADMIN_REVIVE, { target = target }) end,
  giveup = function(target) sendChatCommand("force-giveup", JaxeRevival.Side.COMMAND_ADMIN_GIVEUP, { target = target }) end
}

JaxeRevival.Input.addChatLine = function(text, color)
  local chatText = ISChat.instance.chatText

  if color then text = ("<RGB:%s,%s,%s>%s"):format(color.r, color.g, color.b, text) end

  local autoScroll = chatText:getScrollHeight() <= chatText:getHeight() or (chatText.vscroll and chatText.vscroll.pos == 1)
  local lines = chatText.chatTextLines
  if #lines > ISChat.maxLine then table.remove(lines, 1) end

  lines[#lines + 1] = text .. " <LINE> "

  local last = #lines
  lines[last] = lines[last]:gsub(" <LINE> $", "")

  chatText.text = table.concat(lines)
  chatText:paginate()

  if autoScroll then chatText:setYScroll(-10000) end
end

local onCommandEntered = function(self)
  if not JaxeRevival.Side.canUseAdminCommands(getPlayer()) then return oldHandler(self) end

  local chat = ISChat.instance
  local input = chat.textEntry:getText()

  local command, target = input:match("^/(%S+)%s*(%S*)$")
  if not command then return oldHandler(self) end

  command = command:lower():match("^" .. JaxeRevival.id:lower() .. "%.(.+)")
  if not command or not validCommands[command] then return oldHandler(self) end

  if not target or target == "" then
    JaxeRevival.Input.addChatLine("Target username missing for command")
  else
    validCommands[command](target)
  end

  chat:unfocus()
  chat:logChatCommand(input);
  doKeyPress(false)
  chat.timerTextEntry = 20
end
ISChat.onCommandEntered = onCommandEntered
