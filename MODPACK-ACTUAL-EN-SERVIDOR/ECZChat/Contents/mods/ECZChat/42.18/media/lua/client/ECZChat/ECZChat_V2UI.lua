require "ISUI/ISButton"
require "ISUI/ISContextMenu"
require "ECZChat/ECZChat_Config"
require "ECZChat/ECZChat_State"

ECZChatV2UI = ECZChatV2UI or {}
if ECZChatV2UI.installed then return end
ECZChatV2UI.installed = true

local CHANNEL_SUFFIX = "  >"

local function setButtonTitle(button, title)
    if not button then return end
    if button.setTitle then button:setTitle(title) else button.title = title end
end

local function activeStream(chat)
    if not chat or not chat.chatText or not chat.chatText.chatStreams then return nil end
    local index = tonumber(chat.chatText.streamID) or 1
    return chat.chatText.chatStreams[index]
end

local function streamLabel(stream)
    if not stream then return ECZChatConfig.text("UI_ECZChat_ChannelLocal", "Local") end
    return ECZChatConfig.getChannelLabel(stream.name)
end

local function rebuildPanel(panel, scrollToBottom)
    if not panel then return end
    local chunks = {}
    local lines = panel.chatTextLines or {}
    for index, line in ipairs(lines) do
        local value = line
        if index == #lines then value = value:gsub(" <LINE> $", "") end
        chunks[#chunks + 1] = value
    end
    panel.text = table.concat(chunks)
    panel:paginate()
    if scrollToBottom then panel:setYScroll(-10000) end
end

local function findTab(chat, tabID)
    if not chat then return nil end
    for _, tab in ipairs(chat.tabs or {}) do
        if tab and tab.tabID == tabID then return tab end
    end
    return chat.chatText or chat.defaultTab
end

local function localizePanel(panel)
    if not panel then return end
    for index, line in ipairs(panel.chatTextLines or {}) do
        panel.chatTextLines[index] = ECZChatConfig.localizeSystemText(line)
    end
    rebuildPanel(panel, false)
end

function ECZChatV2UI.addLocalNotice(chat, text, kind)
    chat = chat or ISChat.instance
    local panel = chat and (chat.chatText or chat.defaultTab) or nil
    if not panel or not text or text == "" then return end

    -- Los códigos *R,G,B* pertenecen al procesador del chat de red. Aquí
    -- escribimos directamente en ISRichTextPanel, que usa etiquetas RGB.
    local colour = "<PUSHRGB:0.494,0.776,0.553>"
    if kind == "warning" then colour = "<PUSHRGB:0.922,0.690,0.286>" end
    if kind == "error" then colour = "<PUSHRGB:0.886,0.322,0.286>" end

    panel.chatTextLines = panel.chatTextLines or {}
    table.insert(panel.chatTextLines, colour .. tostring(text) .. " <POPRGB> <LINE> ")
    while #panel.chatTextLines > ISChat.maxLine do table.remove(panel.chatTextLines, 1) end
    rebuildPanel(panel, true)
end

function ECZChatV2UI.refreshChannelButton(chat)
    if not chat or not chat.channelButton then return end
    setButtonTitle(chat.channelButton, streamLabel(activeStream(chat)) .. CHANNEL_SUFFIX)
end

function ECZChatV2UI.selectStream(chat, stream, index)
    if not chat or not chat.chatText or not stream then return end
    local current = chat.textEntry and (chat.textEntry:getText() or "") or ""

    for _, candidate in ipairs(chat.chatText.chatStreams or {}) do
        if current == candidate.command or current == candidate.shortCommand then
            current = ""
            break
        end
    end

    chat.chatText.streamID = index or 1
    chat.chatText.lastChatCommand = stream.command
    if chat.textEntry then
        chat.textEntry:setText(current)
        if ISChat.focused then chat.textEntry:focus() end
    end
    ECZChatV2UI.refreshChannelButton(chat)
end

function ECZChatV2UI.onChannelButtonClick(chat)
    if not chat or not chat.chatText then return end
    local x = chat.channelButton:getAbsoluteX()
    local y = chat.channelButton:getAbsoluteY() - 8
    local context = ISContextMenu.get(0, x, y)
    for index, stream in ipairs(chat.chatText.chatStreams or {}) do
        local option = context:addOption(streamLabel(stream), chat, ECZChatV2UI.selectStream, stream, index)
        if index == (chat.chatText.streamID or 1) then context:setOptionChecked(option, true) end
    end
end

local function layoutInput(chat)
    if not chat or not chat.textEntry or not chat.channelButton then return end
    local inset = chat.inset or 2
    local width = ECZChatConfig.CHANNEL_BUTTON_WIDTH
    chat.channelButton:setX(inset)
    chat.channelButton:setY(chat.textEntry:getY())
    chat.channelButton:setWidth(width)
    chat.channelButton:setHeight(chat.textEntry:getHeight())
    chat.channelButton.backgroundColor = { r = 0.025, g = 0.028, b = 0.035, a = 0.88 }
    chat.channelButton.backgroundColorMouseOver = { r = 0.24, g = 0.025, b = 0.035, a = 0.92 }
    chat.channelButton.borderColor = { r = 0.52, g = 0.055, b = 0.070, a = 0.78 }

    chat.textEntry:setX(inset + width + 4)
    chat.textEntry:setWidth(math.max(80, chat:getWidth() - chat.textEntry:getX() - inset))
    chat.textEntry.backgroundColor = { r = 0.012, g = 0.014, b = 0.019, a = math.max(0.58, chat.textEntry.backgroundColor and chat.textEntry.backgroundColor.a or 0.82) }
    chat.textEntry.borderColor = { r = 0.62, g = 0.055, b = 0.070, a = 0.78 }
    chat.textEntry:setHasFrame(true)
end

local function totalUnread(chat)
    local total = 0
    if chat and chat.tabs then
        for _, tab in ipairs(chat.tabs) do total = total + (tonumber(tab.eczUnread) or 0) end
    end
    return total
end

function ECZChatV2UI.clearCurrent(chat)
    if not chat or not chat.chatText then return end
    chat:onContextClear()
    chat.chatText.chatMessages = {}
    chat.chatText.log = {}
    ECZChatV2UI.addLocalNotice(chat, ECZChatConfig.text("UI_ECZChat_HistoryCleared", "This tab's history has been cleared."), "success")
end

function ECZChatV2UI.resetRPName(chat)
    local username = getOnlineUsername and getOnlineUsername() or "Unknown"
    local ok, name = ECZChatState.setRPName(username)
    if ok then
        rpName = name
        ECZChatV2UI.addLocalNotice(chat, ECZChatConfig.text("UI_ECZChat_NameAssigned", "Name set to: " .. name, name), "success")
    end
end

function ECZChatV2UI.toggleMute(chat, username)
    local muted = ECZChatState.toggleMute(username)
    local key = muted and "UI_ECZChat_UserMuted" or "UI_ECZChat_UserUnmuted"
    local fallback = muted and (username .. " has been muted.") or (username .. " is no longer muted.")
    ECZChatV2UI.addLocalNotice(chat, ECZChatConfig.text(key, fallback, username), "success")
end

local function addOnlinePlayersMenu(context, parentMenu, chat)
    local muteOption = parentMenu:addOption(ECZChatConfig.text("UI_ECZChat_MutePlayer", "Mute player"), chat)
    local muteMenu = context:getNew(context)
    context:addSubMenu(muteOption, muteMenu)

    local found = false
    local players = getOnlinePlayers and getOnlinePlayers() or nil
    if players and players.size then
        for index = 0, players:size() - 1 do
            local player = players:get(index)
            local username = player and player:getUsername() or nil
            if username and username ~= getOnlineUsername() then
                found = true
                local option = muteMenu:addOption(username, chat, ECZChatV2UI.toggleMute, username)
                muteMenu:setOptionChecked(option, ECZChatState.isMuted(username))
            end
        end
    end

    if not found then
        local option = muteMenu:addOption(ECZChatConfig.text("UI_ECZChat_NoPlayers", "No other players are connected"), chat)
        option.notAvailable = true
    end
end

function ECZChatV2UI.addSettings(context, chat)
    if not context or not chat then return end
    local root = context:addOption(ECZChatConfig.text("UI_ECZChat_V2Settings", "ECZ Chat v2"), chat)
    local menu = context:getNew(context)
    context:addSubMenu(root, menu)

    local authorsKey = ECZChatState.getShowAuthors() and "UI_ECZChat_HideUsernames" or "UI_ECZChat_ShowUsernames"
    local authorsFallback = ECZChatState.getShowAuthors() and "Hide usernames" or "Show usernames"
    local authors = menu:addOption(ECZChatConfig.text(authorsKey, authorsFallback), chat, ISChat.onToggleAuthors)
    menu:setOptionChecked(authors, ECZChatState.getShowAuthors())

    addOnlinePlayersMenu(context, menu, chat)
    menu:addOption(ECZChatConfig.text("UI_ECZChat_ClearHistory", "Clear current history"), chat, ECZChatV2UI.clearCurrent)
    menu:addOption(ECZChatConfig.text("UI_ECZChat_ResetRPName", "Reset RP name"), chat, ECZChatV2UI.resetRPName)
end

local originalPrerender = ISChat.prerender
function ISChat:prerender()
    layoutInput(self)
    originalPrerender(self)

    local alpha = math.max(0.35, self.backgroundColor.a or 0.8)
    local th = self:titleBarHeight()
    local iconSize = math.max(12, th - 2)

    -- Posiciones estables de la X, engranaje y candado.
    if self.closeButton then
        self.closeButton:setX(1)
        self.closeButton:setY(1)
        self.closeButton:setWidth(iconSize)
        self.closeButton:setHeight(iconSize)
        self.closeButton:setVisible(true)
        self.closeButton:bringToTop()
    end
    if self.lockButton then
        self.lockButton:setX(self:getWidth() - iconSize - 2)
        self.lockButton:setY(1)
        self.lockButton:setWidth(iconSize)
        self.lockButton:setHeight(iconSize)
        self.lockButton:setVisible(true)
        self.lockButton:bringToTop()
    end
    if self.gearButton then
        local lockX = self.lockButton and self.lockButton:getX() or (self:getWidth() - iconSize - 2)
        self.gearButton:setX(lockX - iconSize - 3)
        self.gearButton:setY(1)
        self.gearButton:setWidth(iconSize)
        self.gearButton:setHeight(iconSize)
        self.gearButton:setVisible(true)
        self.gearButton:bringToTop()
    end

    self:drawRect(0, 0, self:getWidth(), th, alpha, 0.018, 0.021, 0.027)
    self:drawRect(0, th - 2, self:getWidth(), 2, 0.90, 0.62, 0.055, 0.070)
    self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.78, 0.62, 0.055, 0.070)

    local titleX = (self.closeButton and self.closeButton:getRight() or th) + 5
    self:drawText("ECLIPSE Z", titleX, 3, 0.94, 0.94, 0.94, alpha, UIFont.Small)

    local unread = totalUnread(self)
    local status = ECZChatState.getRPName()
    if unread > 0 then
        status = status .. "  -  " .. ECZChatConfig.text("UI_ECZChat_Unread", tostring(unread) .. " unread", unread)
    end
    local right = (self.gearButton and self.gearButton:getX() or self:getWidth() - th * 2) - 7
    local available = math.max(0, right - titleX - getTextManager():MeasureStringX(UIFont.Small, "ECLIPSE Z") - 12)
    while #status > 0 and getTextManager():MeasureStringX(UIFont.Small, status) > available do
        status = status:sub(1, #status - 1)
    end
    self:drawTextRight(status, right, 3, 0.76, 0.82, 0.79, alpha, UIFont.Small)
end

local originalAddLine = ISChat.addLineInChat
ISChat.addLineInChat = function(message, tabID)
    local author = message and message.getAuthor and message:getAuthor() or nil
    if author and ECZChatState.isMuted(author) then return end
    originalAddLine(message, tabID)

    local chat = ISChat.instance
    if not chat then return end
    local tab = findTab(chat, tabID)
    if tab and tab.chatTextLines and #tab.chatTextLines > 0 then
        local last = #tab.chatTextLines
        tab.chatTextLines[last] = ECZChatConfig.localizeSystemText(tab.chatTextLines[last])
        rebuildPanel(tab, true)
    end
    if chat.servermsg then chat.servermsg = ECZChatConfig.localizeSystemText(chat.servermsg) end

    for _, candidate in ipairs(chat.tabs or {}) do
        if candidate and candidate.tabID == tabID and candidate ~= chat.chatText then
            candidate.eczUnread = (tonumber(candidate.eczUnread) or 0) + 1
            break
        end
    end
end

local originalUpdateChatPrefixSettings = ISChat.updateChatPrefixSettings
function ISChat:updateChatPrefixSettings()
    originalUpdateChatPrefixSettings(self)
    for _, tab in ipairs(self.tabs or {}) do localizePanel(tab) end
end

local originalOnCommandEntered = ISChat.onCommandEntered
function ISChat:onCommandEntered()
    local chat = ISChat.instance
    if not chat or not chat.textEntry then return originalOnCommandEntered(self) end

    local typed = chat.textEntry:getText() or ""
    local previousServerMessage = chat.servermsg
    local oldName = ECZChatState.getRPName()
    local selected = activeStream(chat)
    local explicit = luautils.stringStarts(typed, "/")
    local nameCommand = luautils.stringStarts(typed, "/name ") or luautils.stringStarts(typed, "/act ")

    if typed ~= "" and not explicit and selected and selected.command then
        chat.textEntry:setText(selected.command .. typed)
        nameCommand = selected.name == "name"
    end

    originalOnCommandEntered(self)

    if typed ~= "" and not explicit and chat.chatText and chat.chatText.log and chat.chatText.log[1] then
        chat.chatText.log[1] = typed
    end

    if chat.servermsg and chat.servermsg ~= "" and chat.servermsg ~= previousServerMessage then
        local changedName = ECZChatState.getRPName() ~= oldName
        local kind = (nameCommand and changedName) and "success" or "warning"
        ECZChatV2UI.addLocalNotice(chat, ECZChatConfig.localizeSystemText(chat.servermsg), kind)
        chat.servermsg = nil
        chat.servermsgTimer = 0
    end
end

ISChat.onSwitchStream = function()
    if not ISChat.focused then return end
    local chat = ISChat.instance
    local panel = chat and chat.chatText or nil
    local streams = panel and panel.chatStreams or nil
    if not streams or #streams == 0 then return end

    local currentText = chat.textEntry:getText() or ""
    local previous = streams[panel.streamID or 1]
    for _ = 1, #streams do
        panel.streamID = (panel.streamID or 1) % #streams + 1
        if checkPlayerCanUseChat(streams[panel.streamID].command) then break end
    end

    if previous then
        if luautils.stringStarts(currentText, previous.command) then
            currentText = currentText:sub(#previous.command + 1)
        elseif previous.shortCommand and luautils.stringStarts(currentText, previous.shortCommand) then
            currentText = currentText:sub(#previous.shortCommand + 1)
        end
    end

    panel.lastChatCommand = streams[panel.streamID].command
    chat.textEntry:setText(currentText)
    ECZChatV2UI.refreshChannelButton(chat)
end

local originalActivateView = ISChat.onActivateView
function ISChat:onActivateView()
    originalActivateView(self)
    if self.chatText then self.chatText.eczUnread = 0 end
    ECZChatV2UI.refreshChannelButton(self)
end

local originalTabAdded = ISChat.onTabAdded
ISChat.onTabAdded = function(tabTitle, tabID)
    originalTabAdded(tabTitle, tabID)
    local chat = ISChat.instance
    if chat and chat.tabs and chat.tabs[#chat.tabs] then chat.tabs[#chat.tabs].eczUnread = 0 end
    ECZChatV2UI.refreshChannelButton(chat)
end

local originalFocus = ISChat.focus
function ISChat:focus()
    originalFocus(self)
    if self.textEntry then self.textEntry:setText("") end
    ECZChatV2UI.refreshChannelButton(self)
end

print("[ECZChat v2.1] Visual and functional layer loaded")
