require "ECZChat/ECZChat_Config"

ECZChatState = ECZChatState or {}
ECZChatState._fallback = ECZChatState._fallback or {
    mutedUsers = {},
    showAuthors = false,
}
ECZChatState._runtime = ECZChatState._runtime or {
    lastSent = {},
    repeated = {},
}

local function trim(value)
    value = tostring(value or "")
    value = value:gsub("^%s+", ""):gsub("%s+$", "")
    value = value:gsub("%s+", " ")
    return value
end

local function nowMs()
    if getTimestampMs then
        local ok, value = pcall(getTimestampMs)
        if ok and value then return tonumber(value) or 0 end
    end
    return (os.time() or 0) * 1000
end

local function mergeFallback(data)
    if data.mutedUsers == nil then data.mutedUsers = ECZChatState._fallback.mutedUsers end
    if data.showAuthors == nil then data.showAuthors = ECZChatState._fallback.showAuthors end
    data.mutedUsers = data.mutedUsers or {}
    return data
end

local function transmit()
    local player = getPlayer and getPlayer() or nil
    if player and player.transmitModData then
        pcall(function() player:transmitModData() end)
    end
end

function ECZChatState.getData()
    local player = getPlayer and getPlayer() or nil
    if not player then return ECZChatState._fallback end
    local modData = player:getModData()
    modData.ECZChatV2 = modData.ECZChatV2 or {}
    return mergeFallback(modData.ECZChatV2)
end

function ECZChatState.cleanRPName(value)
    local name = trim(value)
    name = name:gsub("[%c]", "")
    name = name:gsub("[%*<>%[%]{}]", "")
    return trim(name)
end

function ECZChatState.validateRPName(value)
    local name = ECZChatState.cleanRPName(value)
    if #name < 3 then return false, nil, ECZChatConfig.text("UI_ECZChat_NameTooShort", "The RP name must contain at least 3 characters.") end
    if #name > 32 then return false, nil, ECZChatConfig.text("UI_ECZChat_NameTooLong", "The RP name cannot exceed 32 characters.") end
    if not name:find("%S") then return false, nil, ECZChatConfig.text("UI_ECZChat_NameInvalid", "The RP name is not valid.") end
    return true, name, nil
end

local function safeOnlineUsername()
    local player = getPlayer and getPlayer() or nil
    if not player then return nil end

    if getOnlineUsername then
        local ok, value = pcall(getOnlineUsername)
        if ok and value and tostring(value) ~= "" then return tostring(value) end
    end
    if player.getUsername then
        local ok, value = pcall(function() return player:getUsername() end)
        if ok and value and tostring(value) ~= "" then return tostring(value) end
    end
    if player.getDisplayName then
        local ok, value = pcall(function() return player:getDisplayName() end)
        if ok and value and tostring(value) ~= "" then return tostring(value) end
    end
    return nil
end

function ECZChatState.getRPName()
    local data = ECZChatState.getData()
    if data.rpName and data.rpName ~= "" then return data.rpName end

    -- Durante la carga todavía no existe IsoPlayer. No se debe llamar a
    -- getOnlineUsername() hasta que el personaje haya sido creado.
    local username = safeOnlineUsername()
    if not username then return "Superviviente" end

    data.rpName = username
    return username
end

function ECZChatState.setRPName(value)
    local valid, name, reason = ECZChatState.validateRPName(value)
    if not valid then return false, nil, reason end
    ECZChatState.getData().rpName = name
    transmit()
    return true, name, nil
end

function ECZChatState.getShowAuthors()
    return ECZChatState.getData().showAuthors == true
end

function ECZChatState.toggleShowAuthors()
    local data = ECZChatState.getData()
    data.showAuthors = not (data.showAuthors == true)
    transmit()
    return data.showAuthors
end

function ECZChatState.isMuted(username)
    if not username or username == "" then return false end
    return ECZChatState.getData().mutedUsers[tostring(username)] == true
end

function ECZChatState.toggleMute(username)
    if not username or username == "" then return false end
    local data = ECZChatState.getData()
    username = tostring(username)
    data.mutedUsers[username] = not (data.mutedUsers[username] == true)
    transmit()
    return data.mutedUsers[username]
end

function ECZChatState.getMutedUsers()
    return ECZChatState.getData().mutedUsers
end

function ECZChatState.canSend(channelName, text)
    text = trim(text)
    local runtime = ECZChatState._runtime
    local current = nowMs()
    local cooldown = ECZChatConfig.getCooldown(channelName)
    local last = tonumber(runtime.lastSent[channelName]) or 0

    if current > 0 and last > 0 and current >= last and current - last < cooldown then
        return false, ECZChatConfig.text("UI_ECZChat_SlowDown", "You are sending messages too quickly.")
    end

    local repeatData = runtime.repeated[channelName] or { text = "", count = 0, time = 0 }
    local repeatTime = tonumber(repeatData.time) or 0
    if repeatData.text == text and current >= repeatTime and current - repeatTime < 8000 then
        repeatData.count = (tonumber(repeatData.count) or 0) + 1
    else
        repeatData.text = text
        repeatData.count = 1
    end
    repeatData.time = current
    runtime.repeated[channelName] = repeatData

    if repeatData.count >= 3 then
        return false, ECZChatConfig.text("UI_ECZChat_RepeatedMessage", "Do not repeatedly send the same message.")
    end

    runtime.lastSent[channelName] = current
    return true, nil
end

return ECZChatState
