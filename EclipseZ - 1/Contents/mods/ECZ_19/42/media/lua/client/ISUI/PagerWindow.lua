-- ============================================================
-- PagerWindow.lua
-- The pager device UI: Inbox / Compose / Groups / Contacts.
-- ============================================================

require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISTickBox"
require "PagerMod_Shared"
require "PagerMod_Client"

PagerWindow = ISCollapsableWindow:derive("PagerWindow")

local FONT_SMALL  = UIFont.Small
local FONT_MED    = UIFont.Medium
local SCREEN_BG   = { r = 0.06, g = 0.09, b = 0.06 }
local SCREEN_TXT  = { r = 0.45, g = 1.0, b = 0.55 }
local SCREEN_DIM  = { r = 0.25, g = 0.6,  b = 0.3 }
local TAB_ACTIVE  = { r = 0.18, g = 0.30, b = 0.20 }
local LOC_TXT     = { r = 0.55, g = 0.8,  b = 1.0 }
local SOS_TXT     = { r = 1.0,  g = 0.45, b = 0.3 }

local MODE_INBOX, MODE_COMPOSE, MODE_GROUPS, MODE_CONTACTS = 1, 2, 3, 4

-- ── Text helpers ───────────────────────────────────────────
local function truncate(text, maxWidth, font)
    local tm = getTextManager()
    if tm:MeasureStringX(font, text) <= maxWidth then return text end
    while #text > 1 and tm:MeasureStringX(font, text .. "...") > maxWidth do
        text = text:sub(1, #text - 1)
    end
    return text .. "..."
end

local function locationMode()
    local st = PagerMod.netStatus or {}
    return st.locationSharing or PagerMod.Config.locationSharing
end

-- ── Construction ───────────────────────────────────────────

function PagerWindow:new(x, y)
    local width, height = 460, 540
    if not x then x = (getCore():getScreenWidth() - width) / 2 end
    if not y then y = (getCore():getScreenHeight() - height) / 2 end
    local o = ISCollapsableWindow.new(self, x, y, width, height)
    o.resizable = false
    o.title = "Pager"
    o.mode = MODE_INBOX
    o.item = nil
    o.pagerNumber = nil
    o.md = nil
    o.targetChannel = nil
    return o
end

function PagerWindow:bindItem(item)
    self.item = item
    self.md = item and item:getModData() or nil
    if self.md then
        self.md.messages = self.md.messages or {}
        self.md.unread = self.md.unread or 0
    end
    self.pagerNumber = self.md and self.md.pagerNumber or nil
    self.title = self.md and (self.md.pagerName or "Pager") or "Pager"
end

-- ── Children ───────────────────────────────────────────────

function PagerWindow:createChildren()
    ISCollapsableWindow.createChildren(self)

    local th = self:titleBarHeight()
    local pad = 10
    local w = self.width
    local screenH = 58
    local tabsY = th + screenH + pad
    local tabH = 24
    local gap = 4
    local tabW = (w - pad * 2 - gap * 3) / 4
    local contentY = tabsY + tabH + pad

    -- Tabs
    local function mkTab(idx, key, label)
        local b = ISButton:new(pad + (tabW + gap) * idx, tabsY, tabW, tabH, label, self, PagerWindow.onTab)
        b.internal = key
        b:initialise(); b:instantiate()
        self:addChild(b)
        return b
    end
    self.tabInbox    = mkTab(0, "INBOX",    getText("IGUI_PagerMod_TabInbox"))
    self.tabCompose  = mkTab(1, "COMPOSE",  getText("IGUI_PagerMod_TabCompose"))
    self.tabGroups   = mkTab(2, "GROUPS",   getText("IGUI_PagerMod_TabGroups"))
    self.tabContacts = mkTab(3, "CONTACTS", getText("IGUI_PagerMod_TabContacts"))

    local listH = self.height - contentY - 44
    local bottomY = self.height - 34

    -- ── Inbox ──────────────────────────────────────────────
    self.inboxList = ISScrollingListBox:new(pad, contentY, w - pad * 2, listH)
    self.inboxList:initialise(); self.inboxList:instantiate()
    self.inboxList.itemheight = 58
    self.inboxList.font = FONT_SMALL
    self.inboxList.doDrawItem = PagerWindow.drawInboxItem
    self.inboxList.drawBorder = true
    self.inboxList.parentWin = self
    self:addChild(self.inboxList)

    local bw = 84
    self.btnReply = ISButton:new(pad, bottomY, bw, 26, getText("IGUI_PagerMod_Reply"), self, PagerWindow.onReply)
    self.btnReply:initialise(); self:addChild(self.btnReply)
    self.btnBlockMsg = ISButton:new(pad + (bw + 4), bottomY, bw, 26, getText("IGUI_PagerMod_Block"), self, PagerWindow.onBlockSender)
    self.btnBlockMsg:initialise(); self:addChild(self.btnBlockMsg)
    self.btnDelete = ISButton:new(pad + (bw + 4) * 2, bottomY, bw, 26, getText("IGUI_PagerMod_Delete"), self, PagerWindow.onDelete)
    self.btnDelete:initialise(); self:addChild(self.btnDelete)
    self.btnClear = ISButton:new(w - pad - 90, bottomY, 90, 26, getText("IGUI_PagerMod_ClearAll"), self, PagerWindow.onClear)
    self.btnClear:initialise(); self:addChild(self.btnClear)

    -- ── Compose ────────────────────────────────────────────
    local cy = contentY
    self.composeTo = ISTextEntryBox:new("", pad + 70, cy, w - pad * 2 - 70 - 96, 24)
    self.composeTo:initialise(); self.composeTo:instantiate()
    self.composeTo:setOnlyNumbers(true)
    self.composeTo:setMaxTextLength(7)
    self:addChild(self.composeTo)

    self.btnPick = ISButton:new(w - pad - 92, cy, 92, 24, getText("IGUI_PagerMod_Pick"), self, PagerWindow.onPickContact)
    self.btnPick:initialise(); self:addChild(self.btnPick)

    self.composeBody = ISTextEntryBox:new("", pad, cy + 34, w - pad * 2, 80)
    self.composeBody:initialise(); self.composeBody:instantiate()
    self.composeBody:setMultipleLine(true)
    PagerMod.refreshConfig()
    self.composeBody:setMaxTextLength(PagerMod.Config.messageMaxLength or 140)
    self:addChild(self.composeBody)

    self.locTick = ISTickBox:new(pad, cy + 120, w - pad * 2, 20, "", self, PagerWindow.onLocTick)
    self.locTick:initialise()
    self.locTick:addOption(getText("IGUI_PagerMod_AttachLocation"))
    self:addChild(self.locTick)

    self.btnSend = ISButton:new(pad, bottomY, 120, 26, getText("IGUI_PagerMod_Send"), self, PagerWindow.onSend)
    self.btnSend:initialise(); self:addChild(self.btnSend)
    self.btnBroadcast = ISButton:new(pad + 128, bottomY, 120, 26, getText("IGUI_PagerMod_Broadcast"), self, PagerWindow.onBroadcast)
    self.btnBroadcast:initialise(); self:addChild(self.btnBroadcast)
    self.btnSOS = ISButton:new(w - pad - 90, bottomY, 90, 26, getText("IGUI_PagerMod_SOS"), self, PagerWindow.onSOS)
    self.btnSOS:initialise()
    self.btnSOS.textColor = { r = SOS_TXT.r, g = SOS_TXT.g, b = SOS_TXT.b, a = 1 }
    self:addChild(self.btnSOS)

    -- ── Groups (channels) ──────────────────────────────────
    self.channelsList = ISScrollingListBox:new(pad, contentY, w - pad * 2, listH)
    self.channelsList:initialise(); self.channelsList:instantiate()
    self.channelsList.itemheight = 30
    self.channelsList.font = FONT_SMALL
    self.channelsList.doDrawItem = PagerWindow.drawChannelItem
    self.channelsList.drawBorder = true
    self.channelsList.parentWin = self
    self:addChild(self.channelsList)

    self.btnChNew = ISButton:new(pad, bottomY, 84, 26, getText("IGUI_PagerMod_NewChannel"), self, PagerWindow.onChannelNew)
    self.btnChNew:initialise(); self:addChild(self.btnChNew)
    self.btnChAdd = ISButton:new(pad + 88, bottomY, 110, 26, getText("IGUI_PagerMod_AddMember"), self, PagerWindow.onChannelAddMember)
    self.btnChAdd:initialise(); self:addChild(self.btnChAdd)
    self.btnChMsg = ISButton:new(pad + 202, bottomY, 90, 26, getText("IGUI_PagerMod_Message"), self, PagerWindow.onMessageChannel)
    self.btnChMsg:initialise(); self:addChild(self.btnChMsg)
    self.btnChDel = ISButton:new(w - pad - 84, bottomY, 84, 26, getText("IGUI_PagerMod_Delete"), self, PagerWindow.onChannelDelete)
    self.btnChDel:initialise(); self:addChild(self.btnChDel)

    -- ── Contacts ───────────────────────────────────────────
    self.contactsList = ISScrollingListBox:new(pad, contentY, w - pad * 2, listH)
    self.contactsList:initialise(); self.contactsList:instantiate()
    self.contactsList.itemheight = 30
    self.contactsList.font = FONT_SMALL
    self.contactsList.doDrawItem = PagerWindow.drawContactItem
    self.contactsList.drawBorder = true
    self.contactsList.parentWin = self
    self:addChild(self.contactsList)

    self.btnAddContact = ISButton:new(pad, bottomY, 84, 26, getText("IGUI_PagerMod_Add"), self, PagerWindow.onAddContact)
    self.btnAddContact:initialise(); self:addChild(self.btnAddContact)
    self.btnMsgContact = ISButton:new(pad + 88, bottomY, 90, 26, getText("IGUI_PagerMod_Message"), self, PagerWindow.onMessageContact)
    self.btnMsgContact:initialise(); self:addChild(self.btnMsgContact)
    self.btnBlockContact = ISButton:new(pad + 182, bottomY, 84, 26, getText("IGUI_PagerMod_Block"), self, PagerWindow.onBlockContact)
    self.btnBlockContact:initialise(); self:addChild(self.btnBlockContact)
    self.btnRemoveContact = ISButton:new(w - pad - 84, bottomY, 84, 26, getText("IGUI_PagerMod_Remove"), self, PagerWindow.onRemoveContact)
    self.btnRemoveContact:initialise(); self:addChild(self.btnRemoveContact)

    self:setMode(MODE_INBOX)
    self:refresh()
end

-- ── Mode switching ─────────────────────────────────────────

function PagerWindow:onTab(button)
    local map = { INBOX = MODE_INBOX, COMPOSE = MODE_COMPOSE, GROUPS = MODE_GROUPS, CONTACTS = MODE_CONTACTS }
    self:setMode(map[button.internal] or MODE_INBOX)
end

function PagerWindow:setMode(mode)
    self.mode = mode
    PagerMod.refreshConfig()
    local st = PagerMod.netStatus or {}
    local inbox = (mode == MODE_INBOX)
    local compose = (mode == MODE_COMPOSE)
    local groups = (mode == MODE_GROUPS)
    local contacts = (mode == MODE_CONTACTS)

    -- Switching away from a channel target unless we entered compose for one.
    if not compose then self.targetChannel = nil end

    self.inboxList:setVisible(inbox)
    self.btnReply:setVisible(inbox)
    self.btnBlockMsg:setVisible(inbox)
    self.btnDelete:setVisible(inbox)
    self.btnClear:setVisible(inbox)

    self.composeTo:setVisible(compose)
    self.btnPick:setVisible(compose)
    self.composeBody:setVisible(compose)
    self.btnSend:setVisible(compose)
    self.btnBroadcast:setVisible(compose and (st.allowBroadcast ~= false))
    self.btnSOS:setVisible(compose and (st.allowSOS ~= false))
    self.locTick:setVisible(compose and locationMode() == PagerMod.LocationMode.OPT_IN)

    self.channelsList:setVisible(groups)
    self.btnChNew:setVisible(groups)
    self.btnChAdd:setVisible(groups)
    self.btnChMsg:setVisible(groups)
    self.btnChDel:setVisible(groups)

    self.contactsList:setVisible(contacts)
    self.btnAddContact:setVisible(contacts)
    self.btnMsgContact:setVisible(contacts)
    self.btnBlockContact:setVisible(contacts and (st.allowBlocking ~= false))
    self.btnRemoveContact:setVisible(contacts)

    if inbox then self:markAllRead() end
    self:refresh()
end

function PagerWindow:onLocTick() end

-- ── Data refresh ───────────────────────────────────────────

function PagerWindow:markAllRead()
    if not self.md then return end
    local justRead = {}
    for _, m in ipairs(self.md.messages or {}) do
        if not m.read then
            m.read = true
            table.insert(justRead, m)
        end
    end
    self.md.unread = 0
    if #justRead > 0 then
        PagerMod.saveItem(self.item)
        PagerMod.sendReadReceipts(justRead, self.item)
    end
end

function PagerWindow:refresh()
    if not self.inboxList then return end
    if self.item then
        self.md = self.item:getModData()
        self.md.messages = self.md.messages or {}
        self.pagerNumber = self.md.pagerNumber
        self.title = self.md.pagerName or "Pager"
    end

    self.inboxList:clear()
    if self.md and self.md.messages then
        for i = #self.md.messages, 1, -1 do
            self.inboxList:addItem(self.md.messages[i].text or "", self.md.messages[i])
        end
    end

    self.contactsList:clear()
    for _, c in ipairs(PagerWindow.getContacts()) do
        self.contactsList:addItem(c.name or "?", c)
    end

    self.channelsList:clear()
    for _, ch in ipairs(PagerMod.getChannels()) do
        self.channelsList:addItem(ch.name or "?", ch)
    end
end

-- ── Contacts storage (player modData) ──────────────────────
-- Delegate to PagerMod so the persistence (transmitModData) happens in one place.

function PagerWindow.getContacts()
    return PagerMod.getContacts()
end

function PagerWindow.saveContacts(list)
    PagerMod.saveContacts(list)
end

-- ── Rendering ──────────────────────────────────────────────

function PagerWindow:prerender()
    ISCollapsableWindow.prerender(self)
    local th = self:titleBarHeight()
    local pad = 10
    local w = self.width

    self:drawRect(pad, th + 6, w - pad * 2, 50, 1, SCREEN_BG.r, SCREEN_BG.g, SCREEN_BG.b)
    self:drawRectBorder(pad, th + 6, w - pad * 2, 50, 1, SCREEN_DIM.r, SCREEN_DIM.g, SCREEN_DIM.b)

    local name = self.md and (self.md.pagerName or "Pager") or "Pager"
    local numStr = self.pagerNumber and PagerMod.formatNumber(self.pagerNumber) or "-------"
    self:drawText(name, pad + 8, th + 12, SCREEN_TXT.r, SCREEN_TXT.g, SCREEN_TXT.b, 1, FONT_MED)
    self:drawTextRight("#" .. numStr, w - pad - 8, th + 12, SCREEN_TXT.r, SCREEN_TXT.g, SCREEN_TXT.b, 1, FONT_MED)

    local st = PagerMod.netStatus or {}
    local sigLabel
    if st.signalMode == PagerMod.SignalMode.RANGE then
        sigLabel = getText("IGUI_PagerMod_SigRange") .. " " .. tostring(st.signalRange or "?")
    else
        sigLabel = getText("IGUI_PagerMod_SigGlobal")
    end
    local unread = self.md and (self.md.unread or 0) or 0
    local statLine = string.format("%s  |  %s: %d  |  %s: %d",
        sigLabel, getText("IGUI_PagerMod_Net"), st.knownPagers or 0,
        getText("IGUI_PagerMod_Unread"), unread)
    self:drawText(statLine, pad + 8, th + 34, SCREEN_DIM.r, SCREEN_DIM.g, SCREEN_DIM.b, 1, FONT_SMALL)

    -- Battery readout (right side of the screen, reddens when low)
    if self.item then
        local pct = PagerMod.batteryPercent(self.item)
        local br, bg, bb = SCREEN_TXT.r, SCREEN_TXT.g, SCREEN_TXT.b
        if pct <= 15 then br, bg, bb = 1.0, 0.45, 0.3 end
        self:drawTextRight(string.format("BAT %d%%", pct), w - pad - 8, th + 34, br, bg, bb, 1, FONT_SMALL)
    end

    local function tabTint(btn, active)
        if not btn then return end
        if active then btn:setBackgroundRGBA(TAB_ACTIVE.r, TAB_ACTIVE.g, TAB_ACTIVE.b, 1)
        else btn:setBackgroundRGBA(0, 0, 0, 0.5) end
    end
    tabTint(self.tabInbox, self.mode == MODE_INBOX)
    tabTint(self.tabCompose, self.mode == MODE_COMPOSE)
    tabTint(self.tabGroups, self.mode == MODE_GROUPS)
    tabTint(self.tabContacts, self.mode == MODE_CONTACTS)

    if self.mode == MODE_COMPOSE then
        -- "To" label / channel indicator
        if self.targetChannel then
            self:drawText(getText("IGUI_PagerMod_ChannelTo") .. ": " .. tostring(self.targetChannel.name),
                pad, self.composeTo.y + 4, LOC_TXT.r, LOC_TXT.g, LOC_TXT.b, 1, FONT_SMALL)
        else
            self:drawText(getText("IGUI_PagerMod_To") .. ":", pad, self.composeTo.y + 4, 1, 1, 1, 1, FONT_SMALL)
        end
        local bodyLen = #(self.composeBody:getText() or "")
        local maxLen = PagerMod.Config.messageMaxLength or 140
        self:drawTextRight(bodyLen .. "/" .. maxLen, w - pad, self.composeBody.y - 16, 0.7, 0.7, 0.7, 1, FONT_SMALL)
        if locationMode() == PagerMod.LocationMode.ALWAYS then
            self:drawText(getText("IGUI_PagerMod_LocAlways"), pad, self.locTick.y + 2, LOC_TXT.r, LOC_TXT.g, LOC_TXT.b, 1, FONT_SMALL)
        end
    end
end

function PagerWindow.drawInboxItem(self, y, item, alt)
    local msg = item.item
    local h = self.itemheight
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), h, 0.25, 0.4, 0.7, 0.4)
    end
    self:drawRectBorder(0, y + h - 1, self:getWidth(), 1, 0.4, 0.3, 0.3, 0.3)
    if not msg then return y + h end

    local fromLabel = msg.fromName and msg.fromName ~= "" and msg.fromName or PagerMod.formatNumber(msg.from)
    local when = PagerMod.stampToClock(msg.stamp) .. " " .. PagerMod.stampToDate(msg.stamp)
    local r, g, b = 0.8, 1.0, 0.85
    if msg.sos then r, g, b = SOS_TXT.r, SOS_TXT.g, SOS_TXT.b
    elseif not msg.read then r, g, b = 0.4, 0.85, 1.0 end

    local prefix = msg.sos and "[SOS] " or ""
    self:drawText(prefix .. truncate(fromLabel, self:getWidth() - 110, self.font), 6, y + 4, r, g, b, 1, self.font)
    self:drawTextRight(when, self:getWidth() - 6, y + 4, 0.6, 0.6, 0.6, 1, self.font)
    self:drawText(truncate(msg.text or "", self:getWidth() - 12, self.font), 6, y + 22, 0.85, 0.85, 0.85, 1, self.font)

    local loc = PagerMod.locationLine(msg)
    if loc then
        self:drawText(loc, 6, y + 40, LOC_TXT.r, LOC_TXT.g, LOC_TXT.b, 1, self.font)
    end
    return y + h
end

function PagerWindow.drawContactItem(self, y, item, alt)
    local c = item.item
    local h = self.itemheight
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), h, 0.25, 0.4, 0.7, 0.4)
    end
    self:drawRectBorder(0, y + h - 1, self:getWidth(), 1, 0.4, 0.3, 0.3, 0.3)
    if c then
        local blocked = PagerMod.isBlockedNumber(c.number)
        local mark = blocked and (" [" .. getText("IGUI_PagerMod_Blocked") .. "]") or ""
        local r, g, b = 0.9, 1.0, 0.9
        if blocked then r, g, b = 0.9, 0.5, 0.5 end
        self:drawText((c.name or "?") .. mark, 6, y + 6, r, g, b, 1, self.font)
        self:drawTextRight("#" .. PagerMod.formatNumber(c.number), self:getWidth() - 6, y + 6, 0.6, 0.8, 0.6, 1, self.font)
    end
    return y + h
end

function PagerWindow.drawChannelItem(self, y, item, alt)
    local ch = item.item
    local h = self.itemheight
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), h, 0.25, 0.4, 0.7, 0.4)
    end
    self:drawRectBorder(0, y + h - 1, self:getWidth(), 1, 0.4, 0.3, 0.3, 0.3)
    if ch then
        self:drawText(ch.name or "?", 6, y + 6, 0.9, 1.0, 0.9, 1, self.font)
        local n = ch.members and #ch.members or 0
        self:drawTextRight(n .. " " .. getText("IGUI_PagerMod_Members"), self:getWidth() - 6, y + 6, 0.6, 0.8, 0.6, 1, self.font)
    end
    return y + h
end

-- ── Compose: location helper ───────────────────────────────

function PagerWindow:wantsLocation()
    local mode = locationMode()
    if mode == PagerMod.LocationMode.ALWAYS then return true end
    if mode == PagerMod.LocationMode.OPT_IN then return self.locTick:isSelected(1) end
    return false
end

-- ── Inbox actions ──────────────────────────────────────────

function PagerWindow:getSelectedMessage()
    local sel = self.inboxList.selected
    if not sel or sel < 1 then return nil end
    local entry = self.inboxList.items[sel]
    return entry and entry.item or nil
end

function PagerWindow:onReply()
    local msg = self:getSelectedMessage()
    if not msg or not msg.from or msg.from == "SYSTEM" then
        PagerMod.halo(getText("IGUI_PagerMod_NoReply"), { r = 0.9, g = 0.7, b = 0.2 })
        return
    end
    self:setMode(MODE_COMPOSE)
    self.targetChannel = nil
    self.composeTo:setText(tostring(msg.from))
    self.composeBody:focus()
end

function PagerWindow:onBlockSender()
    local msg = self:getSelectedMessage()
    if not msg or not msg.from or msg.from == "SYSTEM" then return end
    local nowBlocked = PagerMod.toggleBlock(msg.from)
    PagerMod.halo(nowBlocked and getText("IGUI_PagerMod_BlockedNum") or getText("IGUI_PagerMod_UnblockedNum"))
    self:refresh()
end

function PagerWindow:onDelete()
    local sel = self.inboxList.selected
    if not sel or sel < 1 then return end
    local entry = self.inboxList.items[sel]
    if not entry or not entry.item or not self.md then return end
    local target = entry.item
    for i, m in ipairs(self.md.messages) do
        if m == target then
            if not m.read and self.md.unread > 0 then self.md.unread = self.md.unread - 1 end
            table.remove(self.md.messages, i)
            break
        end
    end
    PagerMod.saveItem(self.item)
    self:refresh()
end

function PagerWindow:onClear()
    if not self.md then return end
    self.md.messages = {}
    self.md.unread = 0
    PagerMod.saveItem(self.item)
    self:refresh()
end

-- ── Compose actions ────────────────────────────────────────

function PagerWindow:onSend()
    local body = self.composeBody:getText()
    if self.targetChannel then
        PagerMod.sendChannel(self.item, self.targetChannel, body, self:wantsLocation())
        return
    end
    local to = self.composeTo:getText()
    PagerMod.sendMessage(self.item, to, body, self:wantsLocation())
end

function PagerWindow:onBroadcast()
    PagerMod.broadcast(self.item, self.composeBody:getText(), self:wantsLocation())
end

function PagerWindow:onSOS()
    PagerMod.sendSOS(self.item, self.composeBody:getText())
end

function PagerWindow:onMessageSent()
    if self.composeBody then self.composeBody:setText("") end
end

-- ── Contact actions ────────────────────────────────────────

function PagerWindow:onPickContact() self:setMode(MODE_CONTACTS) end

function PagerWindow:getSelectedContact()
    local sel = self.contactsList.selected
    if not sel or sel < 1 then return nil end
    local entry = self.contactsList.items[sel]
    return entry and entry.item or nil
end

function PagerWindow:onMessageContact()
    local c = self:getSelectedContact()
    if not c then return end
    self:setMode(MODE_COMPOSE)
    self.targetChannel = nil
    self.composeTo:setText(tostring(c.number))
    self.composeBody:focus()
end

function PagerWindow:onBlockContact()
    local c = self:getSelectedContact()
    if not c then return end
    local nowBlocked = PagerMod.toggleBlock(c.number)
    PagerMod.halo(nowBlocked and getText("IGUI_PagerMod_BlockedNum") or getText("IGUI_PagerMod_UnblockedNum"))
    self:refresh()
end

function PagerWindow:onRemoveContact()
    local c = self:getSelectedContact()
    if not c then return end
    local list = PagerWindow.getContacts()
    for i, x in ipairs(list) do
        if x.number == c.number and x.name == c.name then
            table.remove(list, i)
            break
        end
    end
    PagerWindow.saveContacts(list)
    self:refresh()
end

function PagerWindow:onAddContact()
    local player = getPlayer()
    local win = self
    local function askName(number)
        local modal = ISTextBox:new(0, 0, 320, 160, getText("IGUI_PagerMod_EnterContactName"), "", number, function(num, button)
            if button.internal ~= "OK" then return end
            local name = button.parent.entry:getText()
            if not name or name == "" then name = PagerMod.formatNumber(num) end
            local list = PagerWindow.getContacts()
            table.insert(list, { name = name:sub(1, 24), number = num })
            PagerWindow.saveContacts(list)
            win:refresh()
        end, player:getPlayerNum())
        modal:initialise(); modal:addToUIManager()
    end
    local numModal = ISTextBox:new(0, 0, 320, 160, getText("IGUI_PagerMod_EnterContactNumber"), "", nil, function(_, button)
        if button.internal ~= "OK" then return end
        local num = PagerMod.sanitizeNumber(button.parent.entry:getText())
        if num == "" then
            PagerMod.halo(getText("IGUI_PagerMod_UnknownNumber"), { r = 0.9, g = 0.3, b = 0.2 })
            return
        end
        askName(num)
    end, player:getPlayerNum())
    numModal:initialise(); numModal:addToUIManager()
end

-- ── Channel actions ────────────────────────────────────────

function PagerWindow:getSelectedChannel()
    local sel = self.channelsList.selected
    if not sel or sel < 1 then return nil end
    local entry = self.channelsList.items[sel]
    return entry and entry.item or nil
end

function PagerWindow:onChannelNew()
    local win = self
    local modal = ISTextBox:new(0, 0, 320, 160, getText("IGUI_PagerMod_EnterChannelName"), "", nil, function(_, button)
        if button.internal ~= "OK" then return end
        local name = button.parent.entry:getText()
        if not name or name == "" then return end
        local list = PagerMod.getChannels()
        table.insert(list, { name = name:sub(1, 24), members = {} })
        PagerMod.saveChannels(list)
        win:refresh()
    end, getPlayer():getPlayerNum())
    modal:initialise(); modal:addToUIManager()
end

function PagerWindow:onChannelDelete()
    local ch = self:getSelectedChannel()
    if not ch then return end
    local list = PagerMod.getChannels()
    for i, x in ipairs(list) do
        if x == ch then table.remove(list, i) break end
    end
    PagerMod.saveChannels(list)
    self:refresh()
end

function PagerWindow:onChannelAddMember()
    local ch = self:getSelectedChannel()
    if not ch then
        PagerMod.halo(getText("IGUI_PagerMod_PickChannel"), { r = 0.9, g = 0.7, b = 0.2 })
        return
    end
    local win = self
    local modal = ISTextBox:new(0, 0, 320, 160, getText("IGUI_PagerMod_EnterContactNumber"), "", nil, function(_, button)
        if button.internal ~= "OK" then return end
        local num = PagerMod.sanitizeNumber(button.parent.entry:getText())
        if num == "" then return end
        ch.members = ch.members or {}
        for _, m in ipairs(ch.members) do if m == num then return end end
        table.insert(ch.members, num)
        PagerMod.saveChannels(PagerMod.getChannels())
        win:refresh()
    end, getPlayer():getPlayerNum())
    modal:initialise(); modal:addToUIManager()
end

function PagerWindow:onMessageChannel()
    local ch = self:getSelectedChannel()
    if not ch then return end
    self:setMode(MODE_COMPOSE)
    self.targetChannel = ch
    self.composeBody:focus()
end

-- ── Open / singleton ───────────────────────────────────────

function PagerMod.OpenPagerUI(item)
    -- Battery gate (covers every open path, including the hotkey).
    if item then
        PagerMod.ensureBattery(item)
        if PagerMod.batteryDead(item) then
            PagerMod.halo(getText("IGUI_PagerMod_BatteryDead"), { r = 0.9, g = 0.4, b = 0.2 })
            return
        end
    end
    PagerMod.pingNetwork()
    PagerMod.fetchInbox()
    if PagerMod.UI then
        PagerMod.UI:bindItem(item)
        if not PagerMod.UI:getIsVisible() then
            PagerMod.UI:setVisible(true)
            PagerMod.UI:addToUIManager()
        end
        PagerMod.UI:setMode(MODE_INBOX)
        PagerMod.UI:bringToTop()
        return
    end
    local win = PagerWindow:new()
    win:bindItem(item)
    win:initialise()
    win:addToUIManager()
    PagerMod.UI = win
end

function PagerWindow:close()
    self:setVisible(false)
    self:removeFromUIManager()
end

-- Open the UI straight into Compose, pre-targeted at a number.
function PagerMod.openComposeTo(item, toNumber)
    PagerMod.OpenPagerUI(item)
    local ui = PagerMod.UI
    if not ui then return end
    ui:setMode(MODE_COMPOSE)
    ui.targetChannel = nil
    ui.composeTo:setText(tostring(toNumber or ""))
    ui.composeBody:focus()
end

-- Open the UI straight into Compose, pre-targeted at a channel.
function PagerMod.openComposeChannel(item, channel)
    PagerMod.OpenPagerUI(item)
    local ui = PagerMod.UI
    if not ui then return end
    ui:setMode(MODE_COMPOSE)
    ui.targetChannel = channel
    ui.composeBody:focus()
end
