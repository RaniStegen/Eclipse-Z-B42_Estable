-- ============================================================
-- PagerMod_Client.lua
-- Client side: tracks held pagers, registers numbers with the
-- server, receives messages, stores them on the physical pager
-- item, and fires notifications. Exposes the API the UI uses.
-- ============================================================

require "PagerMod_Shared"

local C2S = PagerMod.C2S
local S2C = PagerMod.S2C

PagerMod._pending = PagerMod._pending or {}  -- reqId -> item awaiting a number
PagerMod._reqSeq  = PagerMod._reqSeq or 0
PagerMod._lastRegistered = PagerMod._lastRegistered or ""
PagerMod.netStatus = PagerMod.netStatus or {}

local INFO_COLOR  = { r = 0.2, g = 0.9, b = 0.4 }
local ALERT_COLOR = { r = 0.3, g = 0.8, b = 1.0 }
local ERROR_COLOR = { r = 0.9, g = 0.3, b = 0.2 }

-- The HaloTextHelper API differs between builds and the two share this Lua,
-- so detect at runtime:
--   B42: addGoodText(player,text) / addBadText(player,text); no coloured addText.
--   B41: addText(player, text, Color); no addGoodText/addBadText.
local function halo(text, color)
    local player = getPlayer()
    if not player or not text then return end
    color = color or INFO_COLOR
    local bad = (color.r or 0) >= 0.7 and (color.g or 0) < 0.78  -- reddish / warning
    local H = HaloTextHelper
    if not H then return end
    if H.addBadText and H.addGoodText then            -- B42
        if bad then H.addBadText(player, text) else H.addGoodText(player, text) end
    elseif H.addText then                              -- B41 (3-arg + Color)
        local col
        if bad then col = H.getColorRed and H.getColorRed() or nil
        else        col = H.getColorGreen and H.getColorGreen() or nil end
        if col ~= nil then H.addText(player, text, col)
        else pcall(function() H.addText(player, text) end) end
    end
end
PagerMod.halo = halo

-- ── Sound ──────────────────────────────────────────────────
-- Uses the standard UI sound; ship a dedicated "PagerBeep" bank later
-- and it will be preferred automatically.
local BEEP_CANDIDATES = { "PagerBeep", "UIActivateButton" }
function PagerMod.playBeep()
    PagerMod.refreshConfig()
    if not PagerMod.Config.notifySound then return end
    local sm = getSoundManager()
    if not sm then return end
    for _, name in ipairs(BEEP_CANDIDATES) do
        local ok, handle = pcall(function() return sm:playUISound(name) end)
        if ok and handle then return end
    end
end

-- ── Held pager helpers ─────────────────────────────────────

-- Recursively collect every Pager the player carries, including inside bags.
local function collectPagers(container, out)
    if not container then return end
    local items = container:getItems()
    if not items then return end
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:getFullType() == PagerMod.ITEM then
            local md = it:getModData()
            md.messages = md.messages or {}
            table.insert(out, { item = it, number = md.pagerNumber, name = md.pagerName, md = md })
        end
        if instanceof(it, "InventoryContainer") then
            collectPagers(it:getInventory(), out)
        end
    end
end

function PagerMod.getHeldPagers()
    local out = {}
    local player = getPlayer()
    if not player or not player:getInventory() then return out end
    collectPagers(player:getInventory(), out)
    return out
end

-- ── Battery ────────────────────────────────────────────────
-- Time-based drain off the in-game world clock. md.batteryAge is the world
-- age (hours) when the current battery was installed; it drains over
-- PagerMod.batteryLifeHours() and then the pager goes dead until replaced.

local function worldAge()
    local gt = getGameTime()
    if not gt then return 0 end
    local ok, h = pcall(function() return gt:getWorldAgeHours() end)
    return (ok and h) or 0
end

-- 0..1 remaining charge (1 when life is infinite or the clock hasn't started).
function PagerMod.batteryFraction(item)
    PagerMod.refreshConfig()
    local life = PagerMod.batteryLifeHours()
    if life <= 0 then return 1 end
    local md = item:getModData()
    if not md.batteryAge then return 1 end
    local frac = 1 - ((worldAge() - md.batteryAge) / life)
    if frac < 0 then return 0 end
    if frac > 1 then return 1 end
    return frac
end

function PagerMod.batteryPercent(item)
    return math.floor(PagerMod.batteryFraction(item) * 100 + 0.5)
end

function PagerMod.batteryDead(item)
    return PagerMod.batteryFraction(item) <= 0
end

-- Start the battery clock on first real use (so old/looted pagers don't
-- retroactively die before you ever switch them on).
function PagerMod.ensureBattery(item)
    local md = item:getModData()
    if md.batteryAge == nil then
        md.batteryAge = worldAge()
        PagerMod.saveItem(item)
    end
end

local function findItemRecurse(container, fullType)
    if not container then return nil end
    local items = container:getItems()
    if not items then return nil end
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:getFullType() == fullType then return it end
        if instanceof(it, "InventoryContainer") then
            local f = findItemRecurse(it:getInventory(), fullType)
            if f then return f end
        end
    end
    return nil
end

function PagerMod.hasSpareBattery()
    local p = getPlayer()
    return p ~= nil and findItemRecurse(p:getInventory(), "Base.Battery") ~= nil
end

-- Consume one Base.Battery from inventory and refresh the pager's charge.
function PagerMod.replaceBattery(item)
    local p = getPlayer()
    if not p then return false end
    local batt = findItemRecurse(p:getInventory(), "Base.Battery")
    if not batt then
        PagerMod.halo(getText("IGUI_PagerMod_NeedBattery"), { r = 0.9, g = 0.4, b = 0.2 })
        return false
    end
    local cont = batt:getContainer()
    if cont then cont:Remove(batt) end
    item:getModData().batteryAge = worldAge()
    PagerMod.saveItem(item)
    PagerMod.playBeep()
    PagerMod.halo(getText("IGUI_PagerMod_BatteryReplaced"))
    if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
    return true
end

function PagerMod.getHeldNumbers()
    local nums = {}
    for _, p in ipairs(PagerMod.getHeldPagers()) do
        if p.number then table.insert(nums, p.number) end
    end
    return nums
end

function PagerMod.findHeldByNumber(number)
    if not number then return nil end
    for _, p in ipairs(PagerMod.getHeldPagers()) do
        if p.number == number then return p end
    end
    return nil
end

function PagerMod.totalUnread()
    local n = 0
    for _, p in ipairs(PagerMod.getHeldPagers()) do
        n = n + (p.md.unread or 0)
    end
    return n
end

-- ── Registration ───────────────────────────────────────────

-- ── Persistence ────────────────────────────────────────────
-- Client modData edits are only saved if synced to the (authoritative) server
-- copy; without this the pager number, messages, battery and contacts are lost
-- on logout in multiplayer. The item-sync API differs by build and pcall does
-- NOT swallow a nil-method call, so we feature-detect:
--   B41: item:transmitModData()
--   B42: syncItemModData(player, item)  (InventoryItem has no transmitModData)
function PagerMod.saveItem(item)
    if not item then return end
    if item.transmitModData then            -- B41
        item:transmitModData()
    elseif syncItemModData then             -- B42 (item modData sync)
        syncItemModData(getPlayer(), item)
    elseif item.syncItemFields then         -- B42 fallback
        item:syncItemFields()
    end
end
function PagerMod.savePlayer()
    local p = getPlayer()
    if p and p.transmitModData then p:transmitModData() end
end

-- ── Per-character pager data (contacts / channels / block list) ─────
local function pagerData()
    local md = getPlayer():getModData()
    md.pagerMod = md.pagerMod or {}
    md.pagerMod.contacts = md.pagerMod.contacts or {}
    md.pagerMod.channels = md.pagerMod.channels or {}
    md.pagerMod.blocked  = md.pagerMod.blocked  or {}
    return md.pagerMod
end

function PagerMod.getBlocked() return pagerData().blocked end

function PagerMod.isBlockedNumber(n)
    for _, x in ipairs(PagerMod.getBlocked()) do
        if x == n then return true end
    end
    return false
end

-- Returns the new blocked state (true = now blocked).
function PagerMod.toggleBlock(number)
    number = PagerMod.sanitizeNumber(number)
    if number == "" then return false end
    local list = PagerMod.getBlocked()
    for i, x in ipairs(list) do
        if x == number then
            table.remove(list, i)
            PagerMod.savePlayer()
            PagerMod.registerNumbers(true)
            return false
        end
    end
    table.insert(list, number)
    PagerMod.savePlayer()
    PagerMod.registerNumbers(true)
    return true
end

function PagerMod.getChannels() return pagerData().channels end
function PagerMod.saveChannels(list) pagerData().channels = list; PagerMod.savePlayer() end

function PagerMod.getContacts() return pagerData().contacts end
function PagerMod.saveContacts(list) pagerData().contacts = list; PagerMod.savePlayer() end

-- Add (or update) a contact; returns true if it was newly added.
function PagerMod.addContact(number, name)
    number = PagerMod.sanitizeNumber(number)
    if number == "" then return false end
    local list = PagerMod.getContacts()
    for _, c in ipairs(list) do
        if c.number == number then
            if name and name ~= "" then c.name = name:sub(1, 24) end
            PagerMod.savePlayer()
            return false
        end
    end
    table.insert(list, { number = number, name = (name and name ~= "" and name:sub(1, 24)) or PagerMod.formatNumber(number) })
    PagerMod.savePlayer()
    return true
end

function PagerMod.registerNumbers(force)
    local nums = PagerMod.getHeldNumbers()
    table.sort(nums)
    local key = table.concat(nums, ",")
    if not force and key == PagerMod._lastRegistered then return end
    PagerMod._lastRegistered = key
    sendClientCommand(PagerMod.MODULE, C2S.REGISTER, {
        numbers = nums,
        blocked = PagerMod.getBlocked(),
    })
end

function PagerMod.requestAssign(item, name)
    PagerMod._reqSeq = PagerMod._reqSeq + 1
    local reqId = PagerMod._reqSeq
    PagerMod._pending[reqId] = item
    -- Pass the item's network id so the SERVER writes the number onto the exact
    -- pager you clicked. Item modData is server-authoritative in B42 (client
    -- sync is a no-op), so the server must set it for it to persist.
    local itemId = nil
    if item and item.getID then
        local ok, id = pcall(function() return item:getID() end); itemId = ok and id or nil
    end
    sendClientCommand(PagerMod.MODULE, C2S.ASSIGN, { reqId = reqId, name = name, itemId = itemId })
end

-- ── Sending ────────────────────────────────────────────────

local function senderFields(fromItem)
    local md = fromItem and fromItem:getModData() or {}
    return md.pagerNumber, md.pagerName or getPlayer():getUsername()
end

-- Returns true (and warns) if the sending pager's battery is dead.
local function batteryBlocks(fromItem)
    if fromItem and PagerMod.batteryDead(fromItem) then
        halo(getText("IGUI_PagerMod_BatteryDead"), ERROR_COLOR)
        return true
    end
    return false
end

function PagerMod.sendMessage(fromItem, toNumber, text, withLocation)
    if batteryBlocks(fromItem) then return false end
    text = PagerMod.trimMessage(text)
    toNumber = PagerMod.sanitizeNumber(toNumber)
    if text == "" or toNumber == "" then
        halo(getText("IGUI_PagerMod_EmptyMessage"), ERROR_COLOR)
        return false
    end
    local from, fromName = senderFields(fromItem)
    sendClientCommand(PagerMod.MODULE, C2S.SEND, {
        to = toNumber, text = text, from = from, fromName = fromName,
        location = withLocation == true,
    })
    return true
end

function PagerMod.broadcast(fromItem, text, withLocation)
    if batteryBlocks(fromItem) then return false end
    text = PagerMod.trimMessage(text)
    if text == "" then
        halo(getText("IGUI_PagerMod_EmptyMessage"), ERROR_COLOR)
        return false
    end
    local from, fromName = senderFields(fromItem)
    sendClientCommand(PagerMod.MODULE, C2S.BROADCAST, {
        text = text, from = from, fromName = fromName,
        location = withLocation == true,
    })
    return true
end

function PagerMod.sendChannel(fromItem, channel, text, withLocation)
    if batteryBlocks(fromItem) then return false end
    text = PagerMod.trimMessage(text)
    if text == "" then
        halo(getText("IGUI_PagerMod_EmptyMessage"), ERROR_COLOR)
        return false
    end
    if not channel or not channel.members or #channel.members == 0 then
        halo(getText("IGUI_PagerMod_EmptyChannel"), ERROR_COLOR)
        return false
    end
    local from, fromName = senderFields(fromItem)
    sendClientCommand(PagerMod.MODULE, C2S.CHANNEL, {
        members = channel.members, channelName = channel.name,
        text = text, from = from, fromName = fromName,
        location = withLocation == true,
    })
    return true
end

function PagerMod.sendSOS(fromItem, text)
    if batteryBlocks(fromItem) then return false end
    local from, fromName = senderFields(fromItem)
    sendClientCommand(PagerMod.MODULE, C2S.SOS, {
        text = PagerMod.trimMessage(text or ""),
        from = from, fromName = fromName,
    })
    return true
end

-- Broadcast my number to nearby pagers so they can save me as a contact.
function PagerMod.shareNearby(fromItem)
    local md = fromItem and fromItem:getModData() or {}
    if not md.pagerNumber then
        halo(getText("IGUI_PagerMod_NeedActivate"), ERROR_COLOR)
        return
    end
    sendClientCommand(PagerMod.MODULE, C2S.SHARE_NEARBY, {
        from = md.pagerNumber,
        fromName = md.pagerName or getPlayer():getUsername(),
    })
end

-- Toggle "do not disturb" on a specific pager. Returns the new muted state.
function PagerMod.toggleMute(item)
    local md = item:getModData()
    md.muted = not md.muted
    PagerMod.saveItem(item)
    return md.muted == true
end

-- Mark every page on a pager as read (and fire read receipts).
function PagerMod.markPagerRead(item)
    local md = item:getModData()
    md.messages = md.messages or {}
    local justRead = {}
    for _, m in ipairs(md.messages) do
        if not m.read then m.read = true; table.insert(justRead, m) end
    end
    md.unread = 0
    PagerMod.saveItem(item)
    PagerMod.sendReadReceipts(justRead, item)
    if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
end

-- Speak the pager's number aloud (handy to share over proximity voice chat).
function PagerMod.sayNumber(fromItem)
    local md = fromItem and fromItem:getModData() or {}
    if not md.pagerNumber then
        halo(getText("IGUI_PagerMod_NeedActivate"), ERROR_COLOR)
        return
    end
    getPlayer():Say(string.format(getText("IGUI_PagerMod_SayNumber"), PagerMod.formatNumber(md.pagerNumber)))
end

-- Tell the server which pages we just read (drives read receipts).
function PagerMod.sendReadReceipts(messages, myItem)
    PagerMod.refreshConfig()
    if not PagerMod.Config.readReceipts or not messages or #messages == 0 then return end
    local acks = {}
    for _, m in ipairs(messages) do
        if m.fromUser then table.insert(acks, { toUser = m.fromUser }) end
    end
    if #acks == 0 then return end
    local md = myItem and myItem:getModData() or {}
    local label = md.pagerName
        or (md.pagerNumber and PagerMod.formatNumber(md.pagerNumber))
        or getPlayer():getUsername()
    sendClientCommand(PagerMod.MODULE, C2S.MARK_READ, { acks = acks, readerName = label })
end

-- A one-line location/distance summary for a received page, or nil.
function PagerMod.locationLine(msg)
    if not msg or not msg.x or not msg.y then return nil end
    local label = "@ " .. msg.x .. "," .. msg.y
    local p = getPlayer()
    if p then
        local dist = PagerMod.distance(p:getX(), p:getY(), msg.x, msg.y)
        label = label .. "  " .. PagerMod.distanceLabel(dist)
            .. " " .. PagerMod.compass(msg.x - p:getX(), msg.y - p:getY())
    end
    return label
end

function PagerMod.fetchInbox()
    sendClientCommand(PagerMod.MODULE, C2S.FETCH, { numbers = PagerMod.getHeldNumbers() })
end

function PagerMod.pingNetwork()
    sendClientCommand(PagerMod.MODULE, C2S.PING, {})
end

-- ── Storing received messages on the physical pager ─────────

local function storeMessages(number, messages, markRead)
    local p = PagerMod.findHeldByNumber(number)
    if not p then return 0 end
    local md = p.md
    md.messages = md.messages or {}
    md.unread = md.unread or 0

    local added = 0
    for _, msg in ipairs(messages) do
        msg.read = markRead == true
        table.insert(md.messages, msg)
        if not msg.read then md.unread = md.unread + 1 end
        added = added + 1
    end

    -- Enforce the per-pager cap (oldest first).
    PagerMod.refreshConfig()
    local cap = PagerMod.Config.maxMessages or 50
    while #md.messages > cap do
        local removed = table.remove(md.messages, 1)
        if removed and not removed.read and md.unread > 0 then
            md.unread = md.unread - 1
        end
    end
    if added > 0 then PagerMod.saveItem(p.item) end
    return added
end

-- ── Server -> Client handlers ──────────────────────────────

local function onAssigned(args)
    local item = PagerMod._pending[args.reqId]
    PagerMod._pending[args.reqId] = nil
    if not item then
        -- The reqId round-trip can miss (serialization/SP loopback); fall back
        -- to the first held pager that still lacks a number so activation never
        -- silently fails.
        for _, p in ipairs(PagerMod.getHeldPagers()) do
            if not p.number then item = p.item break end
        end
    end
    if not item then return end
    local md = item:getModData()
    md.pagerNumber = args.number
    md.pagerName = md.pagerName or getText("IGUI_PagerMod_DefaultName")
    md.messages = md.messages or {}
    md.unread = md.unread or 0
    PagerMod.ensureBattery(item)
    PagerMod.saveItem(item)   -- persist the new number/name so it survives logout
    halo(getText("IGUI_PagerMod_NumberIs") .. " " .. PagerMod.formatNumber(args.number))
    PagerMod.registerNumbers(true)
    if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
    -- If activation was triggered by the hotkey, open the pager now.
    if PagerMod._openAfterAssign then
        PagerMod._openAfterAssign = nil
        if PagerMod.OpenPagerUI then PagerMod.OpenPagerUI(item) end
    end
end

local SOS_COLOR = { r = 1.0, g = 0.35, b = 0.2 }

local function preview(text)
    text = tostring(text or "")
    if #text > 40 then text = text:sub(1, 40) .. "..." end
    return text
end

local function notifyNewMessage(number, messages)
    -- Suppress the beep if the UI is open on this exact pager.
    local viewing = PagerMod.UI and PagerMod.UI:getIsVisible() and PagerMod.UI.pagerNumber == number
    local first = messages[1]
    local fromLabel = first and (first.fromName or PagerMod.formatNumber(first.from)) or "?"
    if viewing then return end

    -- Respect per-pager "Do not disturb" (mute) unless it is an SOS.
    local held = PagerMod.findHeldByNumber(number)
    local muted = held and held.md and held.md.muted
    local sosOverride = false
    for _, m in ipairs(messages) do if m.sos then sosOverride = true break end end
    if muted and not sosOverride then return end
    -- A dead pager doesn't beep (the message is still stored for later).
    if held and held.item and PagerMod.batteryDead(held.item) then return end

    PagerMod.playBeep()
    local anySOS = false
    for _, m in ipairs(messages) do if m.sos then anySOS = true break end end

    local n = #messages
    if anySOS then
        PagerMod.playBeep()
        halo(getText("IGUI_PagerMod_SOSFrom") .. " " .. fromLabel .. "! " .. preview(first.text), SOS_COLOR)
    elseif n == 1 then
        halo(fromLabel .. ": " .. preview(first.text), ALERT_COLOR)
    else
        halo(string.format("%d %s", n, getText("IGUI_PagerMod_NewMessages")), ALERT_COLOR)
    end
end

local function onDeliver(args)
    -- If we no longer hold a pager with this number (dropped/traded mid-flight),
    -- bounce the messages back to the server so they aren't lost.
    if not PagerMod.findHeldByNumber(args.number) then
        sendClientCommand(PagerMod.MODULE, C2S.REQUEUE, { number = args.number, messages = args.messages })
        return
    end
    local added = storeMessages(args.number, args.messages or {}, false)
    if added > 0 then
        -- Remember the most recent real sender for "Page last sender".
        for i = #args.messages, 1, -1 do
            local f = args.messages[i].from
            if f and f ~= "SYSTEM" then PagerMod.lastSender = f break end
        end
        notifyNewMessage(args.number, args.messages)
        if PagerMod.UI and PagerMod.UI:getIsVisible() and PagerMod.UI.pagerNumber == args.number then
            PagerMod.UI:markAllRead()
            PagerMod.UI:refresh()
        elseif PagerMod.UI and PagerMod.UI.refresh then
            PagerMod.UI:refresh()
        end
    end
end

local function onInbox(args)
    local total = 0
    for number, messages in pairs(args.inbox or {}) do
        total = total + storeMessages(number, messages, false)
    end
    if total > 0 then
        PagerMod.playBeep()
        halo(string.format("%d %s", total, getText("IGUI_PagerMod_QueuedDelivered")), ALERT_COLOR)
    end
    if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
end

local function onStatus(args)
    PagerMod.netStatus = args or {}
    if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
end

local function onSentOk(args)
    if args.sos then
        halo(string.format(getText("IGUI_PagerMod_SOSSent"), args.count or 0), SOS_COLOR)
    elseif args.channel then
        halo(string.format(getText("IGUI_PagerMod_ChannelSent"), tostring(args.channel), args.count or 0))
    elseif args.broadcast then
        halo(string.format(getText("IGUI_PagerMod_BroadcastSent"), args.count or 0))
    elseif args.delivered then
        halo(getText("IGUI_PagerMod_Delivered"))
    else
        halo(getText("IGUI_PagerMod_Queued"))
    end
    if PagerMod.UI and PagerMod.UI.onMessageSent then PagerMod.UI:onMessageSent() end
end

local function onSentFail(args)
    halo(args.reason or getText("IGUI_PagerMod_SendFailed"), ERROR_COLOR)
end

local function onInfo(args)
    halo(args.text or "", args.isError and ERROR_COLOR or INFO_COLOR)
end

local function onAddContact(args)
    if not args.number then return end
    local added = PagerMod.addContact(args.number, args.name)
    if added then
        PagerMod.playBeep()
        halo(string.format(getText("IGUI_PagerMod_GotNumberFrom"), args.name or PagerMod.formatNumber(args.number)), ALERT_COLOR)
        if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
    end
end

local DISPATCH = {
    [S2C.ASSIGNED]    = onAssigned,
    [S2C.DELIVER]     = onDeliver,
    [S2C.INBOX]       = onInbox,
    [S2C.STATUS]      = onStatus,
    [S2C.SENT_OK]     = onSentOk,
    [S2C.SENT_FAIL]   = onSentFail,
    [S2C.INFO]        = onInfo,
    [S2C.ADD_CONTACT] = onAddContact,
}

-- Exposed so the server can deliver directly in singleplayer, where
-- Events.OnServerCommand never fires (the command bus is one-way in SP).
function PagerMod.handleServerCommand(command, args)
    local h = DISPATCH[command]
    if h then h(args or {}) end
end

local function onServerCommand(module, command, args)
    if module ~= PagerMod.MODULE then return end
    PagerMod.handleServerCommand(command, args)
end

-- ── Lifecycle: keep registration in sync ───────────────────

local started = false
local function onPlayerStart()
    if started then return end
    started = true
    PagerMod.refreshConfig()
    PagerMod.registerNumbers(true)
    PagerMod.fetchInbox()
    PagerMod.pingNetwork()
end

-- Periodically re-sync the held-number set (covers loot/trade/drop).
-- OnTick's argument is a frame counter, so throttle on real seconds.
local lastCheck = 0
local function onTick()
    if not started then return end
    local now = getTimestamp()
    if now - lastCheck < 5 then return end
    lastCheck = now
    PagerMod.registerNumbers(false)
end

Events.OnServerCommand.Add(onServerCommand)
Events.OnCreatePlayer.Add(onPlayerStart)
Events.OnGameStart.Add(onPlayerStart)
Events.OnTick.Add(onTick)

print("[PagerMod] Client loaded")
