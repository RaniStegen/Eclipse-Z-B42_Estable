ECZChatConfig = ECZChatConfig or {}

ECZChatConfig.VERSION = "2.1.1"
ECZChatConfig.MAX_VISIBLE_LINES = 200
ECZChatConfig.MAX_STORED_MESSAGES = 250
ECZChatConfig.MAX_COMMAND_HISTORY = 40
ECZChatConfig.MAX_MESSAGE_LENGTH = 512
ECZChatConfig.CHANNEL_BUTTON_WIDTH = 96

ECZChatConfig.Channels = {
    say       = { label = "UI_ECZChat_ChannelLocal",     command = "/say ",       accent = {0.69, 0.82, 0.74}, cooldown = 550 },
    gritar    = { label = "UI_ECZChat_ChannelShout",     command = "/gritar ",    accent = {0.92, 0.30, 0.25}, cooldown = 1800 },
    whisper   = { label = "UI_ECZChat_ChannelWhisper",   command = "/whisper ",   accent = {0.72, 0.72, 0.72}, cooldown = 550 },
    faccion   = { label = "UI_ECZChat_ChannelFaction",   command = "/faccion ",   accent = {0.35, 0.62, 0.92}, cooldown = 900 },
    safehouse = { label = "UI_ECZChat_ChannelSafehouse", command = "/safehouse ", commandAlias = "/sh ", accent = {0.40, 0.70, 0.92}, cooldown = 900 },
    general   = { label = "UI_ECZChat_ChannelGeneral",   command = "/all ",       accent = {0.40, 0.82, 0.78}, cooldown = 2500 },
    admin     = { label = "UI_ECZChat_ChannelAdmin",     command = "/admin ",     accent = {0.95, 0.73, 0.24}, cooldown = 500 },
    me        = { label = "UI_ECZChat_ChannelMe",        command = "/me ",        accent = {0.18, 0.82, 0.88}, cooldown = 550 },
    name      = { label = "UI_ECZChat_ChannelName",      command = "/name ",      accent = {0.82, 0.82, 0.82}, cooldown = 1000 },
    looc      = { label = "UI_ECZChat_ChannelLOOC",      command = "/looc ",      accent = {0.22, 0.67, 0.67}, cooldown = 900 },
    ["do"]    = { label = "UI_ECZChat_ChannelDo",        command = "/do ",        accent = {0.95, 0.58, 0.20}, cooldown = 550 },
}

function ECZChatConfig.text(key, fallback, ...)
    local value = getText and getText(key, ...) or nil
    if value == nil or value == "" or value == key then return fallback or key end
    return value
end

function ECZChatConfig.getChannel(name)
    return name and ECZChatConfig.Channels[name] or nil
end

function ECZChatConfig.getChannelLabel(name)
    local channel = ECZChatConfig.getChannel(name)
    if not channel then return tostring(name or "") end
    return ECZChatConfig.text(channel.label, tostring(name or ""))
end

function ECZChatConfig.getCooldown(name)
    local channel = ECZChatConfig.getChannel(name)
    return channel and channel.cooldown or 700
end

function ECZChatConfig.localizeSystemText(value)
    if value == nil then return value end
    local text = tostring(value)

    text = text:gsub(
        "Press the Up arrow to cycle through your message history%. Click the Gear icon to customize chat%.",
        ECZChatConfig.text("UI_ECZChat_Help", "Use the Up arrow to browse message history. Open the gear menu to customize chat.")
    )
    text = text:gsub(
        "Happy surviving!",
        ECZChatConfig.text("UI_ECZChat_HappySurviving", "Good luck surviving!")
    )
    text = text:gsub("User ([%w_%.%-]+) is now admin", function(username)
        return ECZChatConfig.text("UI_ECZChat_UserNowAdmin", "User " .. username .. " is now an administrator.", username)
    end)

    -- Kahlua does not reliably pass every Lua-pattern capture to a gsub
    -- replacement callback.  The previous two-capture callback therefore
    -- received a nil username and failed whenever the item-search tool spawned
    -- an object.  Parse the whole message first and rebuild it without a
    -- multi-capture callback.
    local before, itemName, username, after = text:match("^(.-)Item (.-) Added in (.-)'s inventory%.(.*)$")
    if itemName ~= nil and username ~= nil then
        local fallback = tostring(itemName) .. " was added to " .. tostring(username) .. "'s inventory."
        local localized = ECZChatConfig.text(
            "UI_ECZChat_ItemAdded",
            fallback,
            tostring(itemName),
            tostring(username)
        )
        text = tostring(before or "") .. tostring(localized or fallback) .. tostring(after or "")
    end

    text = text:gsub("UI_ECZChat_VerbSays", ECZChatConfig.text("UI_ECZChat_VerbSays", "says:"))
    text = text:gsub("UI_ECZChat_Shouts", ECZChatConfig.text("UI_ECZChat_ChannelShout", "Shout"))
    return text
end

return ECZChatConfig
