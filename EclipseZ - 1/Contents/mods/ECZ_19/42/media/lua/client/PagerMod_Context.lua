-- ============================================================
-- PagerMod_Context.lua
-- Right-click options on a Pager item: open, quick-page a
-- contact/channel with canned phrases, SOS, share number,
-- say number aloud, mute, mark read, rename, activate.
-- ============================================================

require "PagerMod_Shared"
require "PagerMod_Client"

local WARN = { r = 0.9, g = 0.7, b = 0.2 }

local function resolveItem(entry)
    if not entry then return nil end
    if instanceof(entry, "InventoryItem") then return entry end
    if entry.items and entry.items[1] then
        local first = entry.items[1]
        if instanceof(first, "InventoryItem") then return first end
    end
    return nil
end

-- ── Actions ────────────────────────────────────────────────

local function openPager(item)
    if not item then return end
    if not item:getModData().pagerNumber then
        PagerMod.halo(getText("IGUI_PagerMod_NeedActivate"), WARN)
        return
    end
    PagerMod.ensureBattery(item)
    if PagerMod.batteryDead(item) then
        PagerMod.halo(getText("IGUI_PagerMod_BatteryDead"), { r = 0.9, g = 0.4, b = 0.2 })
        return
    end
    PagerMod.OpenPagerUI(item)
end

local function activatePager(item)
    if not item then return end
    local md = item:getModData()
    if md.pagerNumber then
        PagerMod.halo(getText("IGUI_PagerMod_AlreadyActive") .. " " .. PagerMod.formatNumber(md.pagerNumber))
        return
    end
    PagerMod.requestAssign(item, getText("IGUI_PagerMod_DefaultName"))
end

local function doRename(item, button)
    if button.internal ~= "OK" then return end
    local txt = button.parent.entry:getText()
    if txt and txt ~= "" then
        item:getModData().pagerName = txt:sub(1, 24)
        PagerMod.saveItem(item)
        PagerMod.halo(getText("IGUI_PagerMod_Renamed"))
        if PagerMod.UI and PagerMod.UI.refresh then PagerMod.UI:refresh() end
    end
end

local function renamePager(item)
    if not item then return end
    local player = getPlayer()
    local md = item:getModData()
    local modal = ISTextBox:new(0, 0, 320, 160,
        getText("IGUI_PagerMod_EnterName"), md.pagerName or "", item, doRename,
        player:getPlayerNum())
    modal:initialise()
    modal:addToUIManager()
end

-- ── Quick-page submenu builders ────────────────────────────

-- Build the canned-phrase submenu for a single target (contact or channel).
local function buildPhraseMenu(context, parentOption, item, sendFn)
    local sub = ISContextMenu:getNew(context)
    context:addSubMenu(parentOption, sub)
    for _, key in ipairs(PagerMod.QuickPhrases) do
        local phrase = getText(key)
        sub:addOption(phrase, nil, function() sendFn(phrase) end)
    end
    sub:addOption(getText("IGUI_PagerMod_CustomMsg"), nil, function() sendFn(nil) end)
end

local function buildQuickPageMenu(context, parentOption, item)
    local sub = ISContextMenu:getNew(context)
    context:addSubMenu(parentOption, sub)

    local contacts = PagerMod.getContacts()
    local channels = PagerMod.getChannels()

    if #contacts == 0 and #channels == 0 then
        local none = sub:addOption(getText("IGUI_PagerMod_NoContacts"), nil, nil)
        none.notAvailable = true
        return
    end

    for _, c in ipairs(contacts) do
        local opt = sub:addOption(c.name or PagerMod.formatNumber(c.number), nil, nil)
        buildPhraseMenu(sub, opt, item, function(phrase)
            if phrase then
                PagerMod.sendMessage(item, c.number, phrase)
            else
                PagerMod.openComposeTo(item, c.number)
            end
        end)
    end

    for _, ch in ipairs(channels) do
        local label = "[" .. getText("IGUI_PagerMod_TabGroups") .. "] " .. (ch.name or "?")
        local opt = sub:addOption(label, nil, nil)
        buildPhraseMenu(sub, opt, item, function(phrase)
            if phrase then
                PagerMod.sendChannel(item, ch, phrase)
            else
                PagerMod.openComposeChannel(item, ch)
            end
        end)
    end
end

-- ── Menu assembly ──────────────────────────────────────────

local function fillActivatedMenu(context, item)
    local md = item:getModData()
    local unread = md.unread or 0
    local st = PagerMod.netStatus or {}

    local openLabel = getText("IGUI_PagerMod_Open")
    if unread > 0 then openLabel = openLabel .. " (" .. unread .. ")" end
    context:addOption(openLabel, item, openPager)

    -- Quick page
    local qp = context:addOption(getText("IGUI_PagerMod_QuickPage"), nil, nil)
    buildQuickPageMenu(context, qp, item)

    -- SOS
    if st.allowSOS ~= false then
        context:addOption(getText("IGUI_PagerMod_SendSOS"), item, function() PagerMod.sendSOS(item) end)
    end

    -- Share / say number
    context:addOption(getText("IGUI_PagerMod_ShareNearby"), item, function() PagerMod.shareNearby(item) end)
    context:addOption(getText("IGUI_PagerMod_SayNumberOpt"), item, function() PagerMod.sayNumber(item) end)

    -- Mark all read
    if unread > 0 then
        context:addOption(getText("IGUI_PagerMod_MarkRead"), item, function() PagerMod.markPagerRead(item) end)
    end

    -- Replace battery (shows current charge; disabled if no spare battery)
    local pct = PagerMod.batteryPercent(item)
    local battOpt = context:addOption(
        getText("IGUI_PagerMod_ReplaceBattery") .. " (" .. pct .. "%)",
        item, function() PagerMod.replaceBattery(item) end)
    if not PagerMod.hasSpareBattery() then
        battOpt.notAvailable = true
        local tip = ISToolTip:new()
        tip:initialise()
        tip:setName(getText("IGUI_PagerMod_ReplaceBattery"))
        tip.description = getText("IGUI_PagerMod_NeedBattery")
        battOpt.toolTip = tip
    end

    -- Mute toggle
    local muteLabel = md.muted and getText("IGUI_PagerMod_Unmute") or getText("IGUI_PagerMod_Mute")
    context:addOption(muteLabel, item, function()
        local muted = PagerMod.toggleMute(item)
        PagerMod.halo(muted and getText("IGUI_PagerMod_Muted") or getText("IGUI_PagerMod_Unmuted"))
    end)

    context:addOption(getText("IGUI_PagerMod_Rename"), item, renamePager)
end

local function onFillContextMenu(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)
    if not player then return end

    for _, entry in ipairs(items) do
        local item = resolveItem(entry)
        if item and item:getFullType() == PagerMod.ITEM then
            if item:getModData().pagerNumber then
                fillActivatedMenu(context, item)
            else
                context:addOption(getText("IGUI_PagerMod_Activate"), item, activatePager)
            end
            return -- only add once
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillContextMenu)

print("[PagerMod] Context menu loaded")
