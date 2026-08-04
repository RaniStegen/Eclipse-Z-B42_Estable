local SL = require("SkillLimiter42_Runtime")

SL.Pending = SL.Pending or {}
SL.AuditCountdown = SL.AuditCountdown or {}
SL.InitializationCountdown = SL.InitializationCountdown or {}

local INITIAL_CAPTURE_DELAY = 120

local function normalized(value)
    if value == nil then return nil end
    local text = string.lower(tostring(value))
    text = string.gsub(text, ".*:", "")
    text = string.gsub(text, "[%s_%.%-]", "")
    return text
end

local function queuePerk(player, perkObject, perkEnum, perkId, cap)
    local playerKey = SL.GetPlayerKey(player)
    SL.Pending[playerKey] = SL.Pending[playerKey] or {}
    SL.Pending[playerKey][normalized(perkId)] = {
        object = perkObject,
        enum = perkEnum,
        cap = cap,
    }
end

local function applyOnePending(player)
    local playerKey = SL.GetPlayerKey(player)
    local pending = SL.Pending[playerKey]
    if not pending then return end

    local targetKey = nil
    local data = nil
    for key, value in pairs(pending) do
        targetKey = key
        data = value
        break
    end

    if targetKey and data then
        SL.ClampPerk(player, data.enum, data.cap, true)
        pending[targetKey] = nil
    end

    if next(pending) == nil then
        SL.Pending[playerKey] = nil
    end
end

local function scheduleInitialCapture(player, delay)
    if not player then return end
    local playerKey = SL.GetPlayerKey(player)
    SL.InitializationCountdown[playerKey] = delay or INITIAL_CAPTURE_DELAY
    SL.AuditCountdown[playerKey] = nil
end

local function onAddXP(player, perk, amount)
    if not player or not perk or not amount or amount <= 0 then return end

    local cfg = SL.Settings or SL.LoadSettings()
    if not cfg.Enable then return end

    local perkObject = SL.GetPerkObject(perk)
    local perkEnum = SL.GetPerkEnum(perkObject, perk)
    local perkId = SL.GetPerkId(perkObject, perkEnum)
    if not perkObject or not perkEnum or not perkId then return end
    if SL.IsExcludedPerk(perkObject, perkId) then return end

    -- No se aplica ningún límite hasta que los puntos iniciales se hayan
    -- capturado y guardado de forma fiable para este personaje.
    if SL.GetStoredInitialPoints(player, perkId) == nil then return end

    local cap = SL.GetMaxSkill(player, perkObject)
    if cap == nil then return end

    local ok, level = pcall(function() return player:getPerkLevel(perkEnum) end)
    if ok and level and level >= cap then
        queuePerk(player, perkObject, perkEnum, perkId, cap)
    end
end

local function onPlayerUpdate(player)
    if not player then return end
    applyOnePending(player)

    local playerKey = SL.GetPlayerKey(player)
    local initialization = SL.InitializationCountdown[playerKey]
    if initialization ~= nil then
        initialization = initialization - 1
        if initialization <= 0 then
            SL.InitializationCountdown[playerKey] = nil
            SL.AuditCountdown[playerKey] = 300
            SL.AuditPlayer(player)
        else
            SL.InitializationCountdown[playerKey] = initialization
        end
        return
    end

    local countdown = (SL.AuditCountdown[playerKey] or 1) - 1
    if countdown <= 0 then
        SL.AuditCountdown[playerKey] = 300
        SL.AuditPlayer(player)
    else
        SL.AuditCountdown[playerKey] = countdown
    end
end

local function onCreatePlayer(playerIndex, player)
    SL.LoadSettings()
    local target = player
    if not target and getSpecificPlayer then
        target = getSpecificPlayer(playerIndex or 0)
    end
    if target then scheduleInitialCapture(target, INITIAL_CAPTURE_DELAY) end
end

local function onGameStart()
    SL.LoadSettings()
    if getNumActivePlayers and getSpecificPlayer then
        local count = getNumActivePlayers()
        for index = 0, count - 1 do
            local player = getSpecificPlayer(index)
            if player then scheduleInitialCapture(player, INITIAL_CAPTURE_DELAY) end
        end
    elseif getPlayer then
        local player = getPlayer()
        if player then scheduleInitialCapture(player, INITIAL_CAPTURE_DELAY) end
    end
end

if not SL._eventsRegistered and Events then
    if Events.OnInitGlobalModData then Events.OnInitGlobalModData.Add(SL.LoadSettings) end
    if Events.OnGameStart then Events.OnGameStart.Add(onGameStart) end
    if Events.OnCreatePlayer then Events.OnCreatePlayer.Add(onCreatePlayer) end
    if Events.OnPlayerUpdate then Events.OnPlayerUpdate.Add(onPlayerUpdate) end
    if Events.AddXP then Events.AddXP.Add(onAddXP) end
    if Events.OnSandboxOptionsChanged then Events.OnSandboxOptionsChanged.Add(SL.LoadSettings) end
    SL._eventsRegistered = true
end

return SL
