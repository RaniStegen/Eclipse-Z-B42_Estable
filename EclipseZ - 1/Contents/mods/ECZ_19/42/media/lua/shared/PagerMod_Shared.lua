-- ============================================================
-- PagerMod_Shared.lua
-- Shared namespace, constants, config and helpers.
-- Loaded on both client and server.
-- ============================================================

PagerMod = PagerMod or {}

PagerMod.VERSION   = "1.0.0"
PagerMod.DEBUG     = false             -- set true for verbose console.txt diagnostics
PagerMod.MODULE    = "PagerMod"        -- network command module string
PagerMod.MODDATA   = "PagerMod"        -- global ModData key (server side routing/state)
-- We use the vanilla Base.Pager item (B42 ships it and spawns it in loot; the
-- B41 build defines it). All pager logic attaches via the item's ModData.
PagerMod.ITEM      = "Base.Pager"      -- full item type

-- ── Signal modes ───────────────────────────────────────────
PagerMod.SignalMode = {
    GLOBAL = 1, -- works map-wide (default; pagers are the long-range tier)
    RANGE  = 2, -- only delivered if recipient is within SignalRange tiles of sender
}

-- ── Location sharing modes ─────────────────────────────────
PagerMod.LocationMode = {
    OFF    = 1, -- coordinates are never attached to a page
    OPT_IN = 2, -- attached only when the sender ticks "attach location"
    ALWAYS = 3, -- every page carries the sender's coordinates
}

-- ── Faction scoping (PvPvE) ────────────────────────────────
PagerMod.FactionScope = {
    OFF       = 1, -- anyone can page anyone
    SAME_ONLY = 2, -- members of different factions cannot page each other
}

-- ── Battery life presets (in-game hours; 0 = never dies) ────
PagerMod.BatteryLife = { MONTH1 = 1, MONTH3 = 2, MONTH6 = 3, YEAR1 = 4, NEVER = 5 }
local BATTERY_HOURS = { [1] = 720, [2] = 2160, [3] = 4320, [4] = 8640, [5] = 0 }

-- ── Network commands ───────────────────────────────────────
-- Client -> Server
PagerMod.C2S = {
    REGISTER     = "Register",     -- announce which pager numbers I currently hold
    ASSIGN       = "AssignNumber", -- request a fresh unique number for a pager item
    SEND         = "SendMessage",  -- send a message to a number
    BROADCAST    = "Broadcast",    -- send to every known pager
    CHANNEL      = "Channel",      -- send to a list of numbers (a group/channel)
    SOS          = "SOS",          -- emergency broadcast (forces location when allowed)
    FETCH        = "FetchInbox",   -- pull queued messages for my numbers
    REQUEUE      = "Requeue",      -- bounce back a message we can't store (no longer holding)
    MARK_READ    = "MarkRead",     -- report read pages (drives read receipts)
    SHARE_NEARBY = "ShareNearby",  -- broadcast my number to nearby pagers
    PING         = "Ping",         -- request network/signal status
}
-- Server -> Client
PagerMod.S2C = {
    ASSIGNED     = "NumberAssigned",
    DELIVER      = "Deliver",      -- one or more messages delivered to a held number
    INBOX        = "Inbox",        -- response to FETCH
    STATUS       = "NetStatus",    -- response to PING
    INFO         = "Info",         -- generic toast/halo text
    SENT_OK      = "SentOk",       -- confirmation a message was routed
    SENT_FAIL    = "SentFail",     -- routing failed (no signal / unknown number)
    ADD_CONTACT  = "AddContact",   -- a nearby player shared their number
}

-- Distance (tiles) within which "Share my number nearby" reaches other pagers.
PagerMod.SHARE_RANGE = 40

-- Canned quick-page phrases offered in the radial/context menu.
-- Each entry is a translation key; English fallbacks live in the Translate files.
PagerMod.QuickPhrases = {
    "IGUI_PagerMod_Quick_OnMyWay",
    "IGUI_PagerMod_Quick_NeedBackup",
    "IGUI_PagerMod_Quick_MeetUp",
    "IGUI_PagerMod_Quick_AllClear",
    "IGUI_PagerMod_Quick_StayPut",
    "IGUI_PagerMod_Quick_Incoming",
}

-- ── Default config (overridden by sandbox at runtime) ───────
PagerMod.Config = {
    signalMode       = PagerMod.SignalMode.GLOBAL,
    signalRange      = 1500,   -- tiles, used only in RANGE mode
    allowBroadcast   = true,
    maxMessages      = 50,     -- max stored messages per pager
    messageMaxLength = 140,
    notifySound      = true,
    -- Expanded options
    locationSharing  = PagerMod.LocationMode.OPT_IN,
    sendCooldown     = 0,      -- seconds between pages per player (0 = no limit)
    readReceipts     = true,
    factionScope     = PagerMod.FactionScope.OFF,
    allowSOS         = true,
    allowBlocking    = true,
    batteryLife      = PagerMod.BatteryLife.MONTH3,
}

-- In-game hours a fresh battery lasts (0 = never dies).
function PagerMod.batteryLifeHours()
    return BATTERY_HOURS[PagerMod.Config.batteryLife] or 2160
end

-- Pull values from SandboxVars if present. Safe to call repeatedly.
function PagerMod.refreshConfig()
    local sv = SandboxVars and SandboxVars.PagerMod
    if not sv then return PagerMod.Config end
    local c = PagerMod.Config
    if sv.SignalMode       ~= nil then c.signalMode       = sv.SignalMode end
    if sv.SignalRange      ~= nil then c.signalRange      = sv.SignalRange end
    if sv.AllowBroadcast   ~= nil then c.allowBroadcast   = sv.AllowBroadcast end
    if sv.MaxMessages      ~= nil then c.maxMessages      = sv.MaxMessages end
    if sv.MessageMaxLength ~= nil then c.messageMaxLength = sv.MessageMaxLength end
    if sv.NotifySound      ~= nil then c.notifySound      = sv.NotifySound end
    if sv.LocationSharing  ~= nil then c.locationSharing  = sv.LocationSharing end
    if sv.SendCooldown     ~= nil then c.sendCooldown     = sv.SendCooldown end
    if sv.ReadReceipts     ~= nil then c.readReceipts     = sv.ReadReceipts end
    if sv.FactionScope     ~= nil then c.factionScope     = sv.FactionScope end
    if sv.AllowSOS         ~= nil then c.allowSOS         = sv.AllowSOS end
    if sv.AllowBlocking    ~= nil then c.allowBlocking    = sv.AllowBlocking end
    if sv.BatteryLife      ~= nil then c.batteryLife      = sv.BatteryLife end
    return c
end

-- ── Helpers ────────────────────────────────────────────────

-- Format a 7-digit pager number as XXX-XXXX for display.
function PagerMod.formatNumber(num)
    if not num then return "-------" end
    num = tostring(num)
    if #num == 7 then
        return num:sub(1,3) .. "-" .. num:sub(4,7)
    end
    return num
end

-- Strip everything except digits (for number entry fields).
function PagerMod.sanitizeNumber(str)
    if not str then return "" end
    return (tostring(str):gsub("[^%d]", ""))
end

-- Clamp/trim a message body to the configured maximum length.
function PagerMod.trimMessage(text)
    text = tostring(text or "")
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    local maxLen = PagerMod.Config.messageMaxLength or 140
    if #text > maxLen then
        text = text:sub(1, maxLen)
    end
    return text
end

-- Flat 2D distance between two world points.
function PagerMod.distance(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx * dx + dy * dy)
end

-- Build a compact timestamp table from the current in-game time.
function PagerMod.gameStamp()
    local gt = getGameTime()
    return {
        y = gt:getYear(),
        mo = gt:getMonth() + 1,
        d = gt:getDay() + 1,
        h = gt:getHour(),
        mi = gt:getMinutes(),
    }
end

-- Human readable clock from a stamp table.
function PagerMod.stampToClock(stamp)
    if not stamp then return "--:--" end
    return string.format("%02d:%02d", stamp.h or 0, stamp.mi or 0)
end

-- Human readable date from a stamp table.
function PagerMod.stampToDate(stamp)
    if not stamp then return "--/--" end
    return string.format("%02d/%02d", stamp.d or 0, stamp.mo or 0)
end

-- 8-point compass bearing from a delta (dx east, dy south in PZ coords).
function PagerMod.compass(dx, dy)
    local dirs = { "E", "SE", "S", "SW", "W", "NW", "N", "NE" }
    local ang = math.atan2(dy, dx) -- -pi..pi, 0 = east, +y = south
    local idx = math.floor((ang / (math.pi / 4)) + 0.5) % 8
    return dirs[idx + 1]
end

-- Short distance label in tiles ("≈ 340t").
function PagerMod.distanceLabel(dist)
    dist = math.floor(dist + 0.5)
    if dist >= 1000 then
        return string.format("~%.1fkt", dist / 1000)
    end
    return "~" .. dist .. "t"
end

if not PagerMod._announced then
    PagerMod._announced = true
    print("[PagerMod] Shared loaded v" .. PagerMod.VERSION)
end
