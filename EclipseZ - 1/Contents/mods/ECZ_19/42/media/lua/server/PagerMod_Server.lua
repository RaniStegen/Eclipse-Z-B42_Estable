-- ============================================================
-- PagerMod_Server.lua
-- Authoritative routing + persistence for the pager network.
-- Runs on the host (dedicated server or singleplayer host).
-- ============================================================

require "PagerMod_Shared"

local C2S = PagerMod.C2S
local S2C = PagerMod.S2C

-- ── Server state (persisted via global ModData) ────────────
-- md.numbers[number]   = { owner=username, name=pagerName, lastPos={x,y,z} }
-- md.queue[number]     = { msg, msg, ... }   (awaiting delivery)
-- md.holders[number]   = username            (transient, current online holder)
-- md.online[username]  = { x, y, z }         (transient, last known position)
-- md.seq               = running message id counter
local function getData()
    local md = ModData.getOrCreate(PagerMod.MODDATA)
    md.numbers   = md.numbers   or {}
    md.queue     = md.queue     or {}
    md.holders   = md.holders   or {}
    md.online    = md.online    or {}
    md.blockedBy = md.blockedBy or {}  -- username -> { fromNumber=true }
    md.factionOf = md.factionOf or {}  -- username -> factionName
    md.lastSend  = md.lastSend  or {}  -- username -> timestamp (transient)
    md.seq       = md.seq       or 0
    return md
end

-- Find an un-numbered pager in a player's inventory (recursive, server-side).
local function findFreshPager(container)
    if not container then return nil end
    local items = container:getItems()
    if not items then return nil end
    for i = 0, items:size() - 1 do
        local it = items:get(i)
        if it:getFullType() == PagerMod.ITEM and not it:getModData().pagerNumber then
            return it
        end
        if instanceof(it, "InventoryContainer") then
            local f = findFreshPager(it:getInventory())
            if f then return f end
        end
    end
    return nil
end

-- Push an item's (server-set) modData to its owning client. Decompiled fact:
-- syncItemModData only acts when GameServer.server (sends SyncItemModDataPacket,
-- which the client applies to its copy). In SP it's a no-op but unnecessary
-- (same Lua VM / same item object). Either way the SERVER's copy is what saves.
local function pushItemModData(player, item)
    if syncItemModData then pcall(function() syncItemModData(player, item) end) end
end

-- Faction name of a player, or nil. Guarded: the faction API may be absent
-- or the player may be factionless.
local function getFactionName(player)
    if not player then return nil end
    local ok, name = pcall(function()
        if not Faction or not Faction.getPlayerFaction then return nil end
        local f = Faction.getPlayerFaction(player)
        return f and f:getName() or nil
    end)
    if ok then return name end
    return nil
end

-- ── Utilities ──────────────────────────────────────────────

local function findOnlinePlayer(username)
    local players = getOnlinePlayers()
    if not players then return nil end
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p and p:getUsername() == username then
            return p
        end
    end
    return nil
end

local function toClient(player, command, args)
    args = args or {}
    if isServer() then
        -- Dedicated server / co-op host: route over the network to that client.
        if player then sendServerCommand(player, PagerMod.MODULE, command, args) end
    elseif PagerMod.handleServerCommand then
        -- Singleplayer: OnServerCommand never fires (the command bus is one-way
        -- in SP). Client and server share one Lua VM, so deliver directly.
        PagerMod.handleServerCommand(command, args)
    else
        -- Fallback if the client module somehow isn't loaded yet.
        sendServerCommand(PagerMod.MODULE, command, args)
    end
end

local function info(player, text, isError)
    toClient(player, S2C.INFO, { text = text, isError = isError == true })
end

local function generateNumber(md)
    for _ = 1, 200 do
        local n = tostring(ZombRand(1000000, 9999999))
        if not md.numbers[n] then
            return n
        end
    end
    -- Fallback: linear scan upward from a random seed.
    local seed = ZombRand(1000000, 9999999)
    for i = 0, 8999999 do
        local n = tostring(1000000 + ((seed - 1000000 + i) % 9000000))
        if not md.numbers[n] then return n end
    end
    return nil
end

-- ── Position tracking ──────────────────────────────────────

local function updatePosition(player)
    if not player then return end
    local md = getData()
    local username = player:getUsername()
    local pos = {
        x = math.floor(player:getX()),
        y = math.floor(player:getY()),
        z = math.floor(player:getZ()),
    }
    md.online[username] = pos
    md.factionOf[username] = getFactionName(player)
    -- Refresh last known position of every number this user holds.
    for number, holder in pairs(md.holders) do
        if holder == username and md.numbers[number] then
            md.numbers[number].lastPos = pos
        end
    end
end

-- PvPvE: when faction scoping is on, members of two different factions
-- cannot page each other. Factionless players are never cut off.
local function factionAllows(md, senderFaction, holderUser)
    PagerMod.refreshConfig()
    if PagerMod.Config.factionScope ~= PagerMod.FactionScope.SAME_ONLY then
        return true
    end
    local holderFaction = md.factionOf[holderUser]
    if not senderFaction or not holderFaction then return true end
    return senderFaction == holderFaction
end

-- Anti-grief: a recipient can block a sender's number.
local function isBlocked(md, holderUser, fromNumber)
    PagerMod.refreshConfig()
    if not PagerMod.Config.allowBlocking then return false end
    local set = md.blockedBy[holderUser]
    return set ~= nil and set[fromNumber] == true
end

-- Anti-spam send cooldown (PvP server health). Returns ok, secondsLeft.
local function cooldownOk(md, username)
    PagerMod.refreshConfig()
    local cd = PagerMod.Config.sendCooldown or 0
    if cd <= 0 then return true, 0 end
    local now = getTimestamp()
    local last = md.lastSend[username] or 0
    local elapsed = now - last
    if elapsed < cd then
        return false, math.ceil(cd - elapsed)
    end
    md.lastSend[username] = now
    return true, 0
end

-- ── Delivery ───────────────────────────────────────────────

-- Push a single message to whoever holds `number` if they are online,
-- otherwise enqueue it for later catch-up. `ctx` carries the sender's
-- faction for PvPvE scoping. Returns "delivered", "queued" or "blocked".
local function deliverOrQueue(md, number, msg, ctx)
    ctx = ctx or {}
    local holder = md.holders[number]

    -- Block list & faction scoping are evaluated against the (known) holder,
    -- even if they are currently offline.
    if holder then
        if isBlocked(md, holder, msg.from) then return "blocked" end
        if not factionAllows(md, ctx.senderFaction, holder) then return "blocked" end
    end

    local player = holder and findOnlinePlayer(holder) or nil
    if player then
        toClient(player, S2C.DELIVER, { number = number, messages = { msg } })
        return "delivered"
    end
    -- Offline: queue, respecting the per-pager cap.
    md.queue[number] = md.queue[number] or {}
    local q = md.queue[number]
    table.insert(q, msg)
    local cap = PagerMod.Config.maxMessages or 50
    while #q > cap do
        table.remove(q, 1)
    end
    return "queued"
end

-- ── Command handlers ───────────────────────────────────────

local function onAssign(player, args)
    local md = getData()
    local number = generateNumber(md)
    if not number then
        info(player, getText("IGUI_PagerMod_NoNumbersLeft"), true)
        return
    end
    md.numbers[number] = {
        owner = player:getUsername(),
        name  = args.name or getText("IGUI_PagerMod_DefaultName"),
        lastPos = { x = math.floor(player:getX()), y = math.floor(player:getY()), z = math.floor(player:getZ()) },
    }
    md.holders[number] = player:getUsername()

    -- Write the number onto the player's pager on the SERVER (authoritative copy
    -- that persists across logout). Prefer the exact pager clicked (by network
    -- id), else the first un-numbered one carried.
    local item = nil
    if args.itemId then
        local ok, found = pcall(function() return player:getInventory():getItemById(args.itemId) end)
        if ok and found and found:getFullType() == PagerMod.ITEM then item = found end
    end
    if not item then item = findFreshPager(player:getInventory()) end
    if item then
        local imd = item:getModData()
        imd.pagerNumber = number
        imd.pagerName   = imd.pagerName or args.name or getText("IGUI_PagerMod_DefaultName")
        imd.messages    = imd.messages or {}
        imd.unread      = imd.unread or 0
        if imd.batteryAge == nil then
            local gt = getGameTime()
            imd.batteryAge = (gt and gt:getWorldAgeHours()) or 0
        end
        pushItemModData(player, item)
    end

    toClient(player, S2C.ASSIGNED, { number = number, reqId = args.reqId })
    print(string.format("[PagerMod] Assigned %s to %s", number, player:getUsername()))
end

local function onRegister(player, args)
    local md = getData()
    md.heldByUser = md.heldByUser or {}
    local username = player:getUsername()
    updatePosition(player)

    -- Store this player's block list (number set) for delivery filtering.
    if args.blocked then
        local set = {}
        for _, n in ipairs(args.blocked) do set[tostring(n)] = true end
        md.blockedBy[username] = set
    end

    -- Release holder bindings this user previously claimed; we re-add the
    -- ones they still carry below. Numbers they dropped become "offline"
    -- so future pages queue instead of vanishing into thin air.
    local prev = md.heldByUser[username]
    if prev then
        for _, n in ipairs(prev) do
            if md.holders[n] == username then md.holders[n] = nil end
        end
    end

    local numbers = args.numbers or {}
    local current = {}
    for _, number in ipairs(numbers) do
        number = tostring(number)
        if not md.numbers[number] then
            -- A pager that exists but the server never saw (e.g. wiped save).
            md.numbers[number] = {
                owner = username,
                name = getText("IGUI_PagerMod_DefaultName"),
                lastPos = md.online[username],
            }
        end
        md.holders[number] = username
        md.numbers[number].lastPos = md.online[username]
        table.insert(current, number)

        -- Flush any messages queued while this pager was offline.
        local q = md.queue[number]
        if q and #q > 0 then
            toClient(player, S2C.DELIVER, { number = number, messages = q })
            md.queue[number] = nil
        end
    end
    md.heldByUser[username] = current
end

-- A page was delivered to a player who no longer holds the pager (dropped /
-- traded in a race). Detach the holder and re-queue for the next holder.
local function onRequeue(player, args)
    local md = getData()
    local number = tostring(args.number or "")
    if number == "" or not md.numbers[number] then return end
    if md.holders[number] == player:getUsername() then
        md.holders[number] = nil
    end
    md.queue[number] = md.queue[number] or {}
    for _, msg in ipairs(args.messages or {}) do
        table.insert(md.queue[number], msg)
    end
    local cap = PagerMod.Config.maxMessages or 50
    while #md.queue[number] > cap do
        table.remove(md.queue[number], 1)
    end
end

-- Whether coordinates may be attached to this page.
local function locationAllowed(wantsLocation, forceForSOS)
    PagerMod.refreshConfig()
    local mode = PagerMod.Config.locationSharing
    if mode == PagerMod.LocationMode.OFF then return false end
    if mode == PagerMod.LocationMode.ALWAYS then return true end
    -- OPT_IN: only if the sender asked, or it's an SOS.
    return wantsLocation == true or forceForSOS == true
end

local function buildMessage(md, args, toNumber, text, player, includeLoc, isSOS)
    md.seq = md.seq + 1
    local msg = {
        id = md.seq,
        from = args.from or "SYSTEM",
        fromName = args.fromName or "SYSTEM",
        fromUser = player and player:getUsername() or nil,
        to = toNumber,
        text = text,
        stamp = PagerMod.gameStamp(),
        sos = isSOS == true,
    }
    if includeLoc and player then
        msg.x = math.floor(player:getX())
        msg.y = math.floor(player:getY())
    end
    return msg
end

-- Decide whether a message can physically reach `toNumber` from the sender.
local function hasSignal(md, player, toNumber)
    PagerMod.refreshConfig()
    if PagerMod.Config.signalMode ~= PagerMod.SignalMode.RANGE then
        return true
    end
    local target = md.numbers[toNumber]
    if not target or not target.lastPos then
        return false -- never seen on the network -> no signal
    end
    local dist = PagerMod.distance(player:getX(), player:getY(), target.lastPos.x, target.lastPos.y)
    return dist <= (PagerMod.Config.signalRange or 1500)
end

local function onSend(player, args)
    local md = getData()
    PagerMod.refreshConfig()
    updatePosition(player)

    local ok, left = cooldownOk(md, player:getUsername())
    if not ok then
        toClient(player, S2C.SENT_FAIL, { reason = string.format(getText("IGUI_PagerMod_Cooldown"), left) })
        return
    end

    local toNumber = tostring(args.to or "")
    local text = PagerMod.trimMessage(args.text)
    if text == "" then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_EmptyMessage") })
        return
    end
    if not md.numbers[toNumber] then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_UnknownNumber"), to = toNumber })
        return
    end
    if not hasSignal(md, player, toNumber) then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_NoSignal"), to = toNumber })
        return
    end

    local includeLoc = locationAllowed(args.location, false)
    local ctx = { senderFaction = getFactionName(player) }
    local msg = buildMessage(md, args, toNumber, text, player, includeLoc, false)
    local result = deliverOrQueue(md, toNumber, msg, ctx)
    if result == "blocked" then
        -- Don't reveal blocks/faction filtering; report as delivered.
        toClient(player, S2C.SENT_OK, { to = toNumber, delivered = true })
    else
        toClient(player, S2C.SENT_OK, { to = toNumber, delivered = (result == "delivered") })
    end
end

-- Shared fan-out used by Broadcast / Channel / SOS.
local function fanOut(player, args, numbers, text, includeLoc, isSOS)
    local md = getData()
    local ctx = { senderFaction = getFactionName(player) }
    local from = args.from
    local count = 0
    for _, number in ipairs(numbers) do
        number = tostring(number)
        if number ~= from and md.numbers[number] and hasSignal(md, player, number) then
            local msg = buildMessage(md, args, number, text, player, includeLoc, isSOS)
            local r = deliverOrQueue(md, number, msg, ctx)
            if r ~= "blocked" then count = count + 1 end
        end
    end
    return count
end

local function onBroadcast(player, args)
    local md = getData()
    PagerMod.refreshConfig()
    if not PagerMod.Config.allowBroadcast then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_BroadcastDisabled") })
        return
    end
    updatePosition(player)
    local ok, left = cooldownOk(md, player:getUsername())
    if not ok then
        toClient(player, S2C.SENT_FAIL, { reason = string.format(getText("IGUI_PagerMod_Cooldown"), left) })
        return
    end
    local text = PagerMod.trimMessage(args.text)
    if text == "" then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_EmptyMessage") })
        return
    end

    local includeLoc = locationAllowed(args.location, false)
    local all = {}
    for number, _ in pairs(md.numbers) do table.insert(all, number) end
    local count = fanOut(player, args, all, text, includeLoc, false)
    toClient(player, S2C.SENT_OK, { broadcast = true, count = count })
end

local function onChannel(player, args)
    local md = getData()
    PagerMod.refreshConfig()
    updatePosition(player)
    local ok, left = cooldownOk(md, player:getUsername())
    if not ok then
        toClient(player, S2C.SENT_FAIL, { reason = string.format(getText("IGUI_PagerMod_Cooldown"), left) })
        return
    end
    local text = PagerMod.trimMessage(args.text)
    if text == "" then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_EmptyMessage") })
        return
    end
    local members = args.members or {}
    if #members == 0 then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_EmptyChannel") })
        return
    end
    local includeLoc = locationAllowed(args.location, false)
    local count = fanOut(player, args, members, text, includeLoc, false)
    toClient(player, S2C.SENT_OK, { channel = args.channelName, count = count })
end

local function onSOS(player, args)
    local md = getData()
    PagerMod.refreshConfig()
    if not PagerMod.Config.allowSOS then
        toClient(player, S2C.SENT_FAIL, { reason = getText("IGUI_PagerMod_SOSDisabled") })
        return
    end
    updatePosition(player)
    local ok, left = cooldownOk(md, player:getUsername())
    if not ok then
        toClient(player, S2C.SENT_FAIL, { reason = string.format(getText("IGUI_PagerMod_Cooldown"), left) })
        return
    end
    local text = PagerMod.trimMessage(args.text)
    if text == "" then text = getText("IGUI_PagerMod_SOSDefault") end
    -- SOS forces location (unless sharing is fully OFF) and pages everyone.
    local includeLoc = locationAllowed(true, true)
    local all = {}
    for number, _ in pairs(md.numbers) do table.insert(all, number) end
    local count = fanOut(player, args, all, text, includeLoc, true)
    toClient(player, S2C.SENT_OK, { sos = true, count = count })
end

-- "Share my number nearby": push the sender's number+name to every pager
-- whose holder is online and standing within SHARE_RANGE tiles.
local function onShareNearby(player, args)
    local md = getData()
    updatePosition(player)
    local fromNumber = args.from
    local fromName = args.fromName or "?"
    if not fromNumber then return end

    local px, py = player:getX(), player:getY()
    local range = PagerMod.SHARE_RANGE or 40
    local count = 0
    local seen = {}
    for number, info in pairs(md.numbers) do
        local holder = md.holders[number]
        if number ~= fromNumber and holder and not seen[holder] then
            local pos = info.lastPos
            if pos and PagerMod.distance(px, py, pos.x, pos.y) <= range then
                local target = findOnlinePlayer(holder)
                if target then
                    seen[holder] = true
                    toClient(target, S2C.ADD_CONTACT, { number = fromNumber, name = fromName })
                    count = count + 1
                end
            end
        end
    end
    toClient(player, S2C.INFO, {
        text = string.format(getText("IGUI_PagerMod_SharedNearby"), count),
    })
end

-- Read receipts: notify the original senders that their page was read.
local function onMarkRead(player, args)
    PagerMod.refreshConfig()
    if not PagerMod.Config.readReceipts then return end
    local readerLabel = args.readerName or "?"
    local notified = {}
    for _, ack in ipairs(args.acks or {}) do
        local toUser = ack.toUser
        if toUser and not notified[toUser] then
            notified[toUser] = true
            local target = findOnlinePlayer(toUser)
            if target then
                info(target, string.format(getText("IGUI_PagerMod_ReadReceipt"), readerLabel), false)
            end
        end
    end
end

local function onFetch(player, args)
    local md = getData()
    local username = player:getUsername()
    updatePosition(player)

    local result = {}
    for _, number in ipairs(args.numbers or {}) do
        number = tostring(number)
        md.holders[number] = username
        local q = md.queue[number]
        if q and #q > 0 then
            result[number] = q
            md.queue[number] = nil
        end
    end
    toClient(player, S2C.INBOX, { inbox = result })
end

local function onPing(player, args)
    PagerMod.refreshConfig()
    local md = getData()
    local known = 0
    for _ in pairs(md.numbers) do known = known + 1 end
    local onlineCount = 0
    local players = getOnlinePlayers()
    if players then onlineCount = players:size() end
    toClient(player, S2C.STATUS, {
        signalMode = PagerMod.Config.signalMode,
        signalRange = PagerMod.Config.signalRange,
        allowBroadcast = PagerMod.Config.allowBroadcast,
        locationSharing = PagerMod.Config.locationSharing,
        allowSOS = PagerMod.Config.allowSOS,
        allowBlocking = PagerMod.Config.allowBlocking,
        factionScope = PagerMod.Config.factionScope,
        sendCooldown = PagerMod.Config.sendCooldown,
        knownPagers = known,
        onlinePlayers = onlineCount,
    })
end

-- ── Event wiring ───────────────────────────────────────────

local handlers = {
    [C2S.ASSIGN]    = onAssign,
    [C2S.REGISTER]  = onRegister,
    [C2S.SEND]      = onSend,
    [C2S.BROADCAST] = onBroadcast,
    [C2S.CHANNEL]   = onChannel,
    [C2S.SOS]       = onSOS,
    [C2S.FETCH]        = onFetch,
    [C2S.REQUEUE]      = onRequeue,
    [C2S.MARK_READ]    = onMarkRead,
    [C2S.SHARE_NEARBY] = onShareNearby,
    [C2S.PING]         = onPing,
}

local function onClientCommand(module, command, player, args)
    if module ~= PagerMod.MODULE then return end
    local h = handlers[command]
    if h then
        h(player, args or {})
    end
end

-- Periodic position refresh so RANGE mode stays current. OnTick's argument
-- is a frame counter, so we throttle on real wall-clock seconds instead.
local lastTick = 0
local TICK_INTERVAL = 30 -- seconds
local function onTick()
    local now = getTimestamp()
    if now - lastTick < TICK_INTERVAL then return end
    lastTick = now
    local players = getOnlinePlayers()
    if not players then return end
    for i = 0, players:size() - 1 do
        updatePosition(players:get(i))
    end
end

local function onServerStart()
    PagerMod.refreshConfig()
    getData()
    print("[PagerMod] Server routing online. Signal mode: " .. tostring(PagerMod.Config.signalMode))
end

Events.OnClientCommand.Add(onClientCommand)
Events.OnTick.Add(onTick)
Events.OnServerStarted.Add(onServerStart)
Events.OnInitGlobalModData.Add(function() getData() end)

print("[PagerMod] Server loaded")
