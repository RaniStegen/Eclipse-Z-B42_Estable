require("JaxeRevival")

JaxeRevival.State = {}

local FASTFORWARD_MIN = 5 / 60
local REMAINING_VARIANCE = 0.5

local getTimeUnit = function(output, units, singular, plural)
  if units ~= 0 then
    if #output > 0 then output = output .. ", " end
    output = output .. units .. " " .. getText(units > 1 and plural or singular)
  end

  return output
end

JaxeRevival.State.getTimeRemainingText = function(player, value)
  local total = value or 0
  local text = ""

  if SandboxVars.JaxeRevival.ShowExactCountdown then
    if total <= 0 then return end

    local units = ""
    units = getTimeUnit(units, math.floor(total / 24), "IGUI_Gametime_day", "IGUI_Gametime_days")

    local remaining = total % 24
    units = getTimeUnit(units, math.floor(remaining), "IGUI_Gametime_hour", "IGUI_Gametime_hours")
    units = getTimeUnit(units, math.floor((remaining * 60) % 60), "IGUI_Gametime_minute", "IGUI_Gametime_minutes")
    if #units == 0 then units = getTimeUnit(units, math.floor((remaining * 3600) % 60), "IGUI_Gametime_second", "IGUI_Gametime_secondes") end

    text = getText("UI_JaxeRevival_RemainingExact"):format(units)
  else
    if total < 1 then
      text = getText("UI_JaxeRevival_RemainingImminent")
    elseif total < 2 then
      text = getText("UI_JaxeRevival_RemainingVeryShort")
    elseif total < 6 then
      text = getText("UI_JaxeRevival_RemainingShort")
    elseif total < 12 then
      text = getText("UI_JaxeRevival_RemainingMid")
    elseif total < 24 then
      text = getText("UI_JaxeRevival_RemainingLong")
    else
      text = getText("UI_JaxeRevival_RemainingVeryLong")
    end
  end

  return getText(JaxeRevival.Incapacitation.canRecoverUnassisted(player) and "UI_JaxeRevival_WillRecover" or "UI_JaxeRevival_WillDie"):format(text)
end

JaxeRevival.State.getTimeRemaining = function(player)
  local limit = SandboxVars.JaxeRevival.IncapacitatedTime > 0 and SandboxVars.JaxeRevival.IncapacitatedTime or (JaxeRevival.Side.isMultiplayer() and nil or 1)
  if not limit then return end

  local currentTime = getGameTime():getWorldAgeHours()
  local modData = player:getModData()
  if not modData.JaxeRevival_IncapacitatedEnd then
    local variance = (ZombRand(SandboxVars.JaxeRevival.IncapacitatedTimeVariance + 1) - (SandboxVars.JaxeRevival.IncapacitatedTimeVariance / 2)) / 60
    modData.JaxeRevival_IncapacitatedEnd = limit + variance <= REMAINING_VARIANCE and REMAINING_VARIANCE or currentTime + limit + variance
  end

  local remaining = player:getModData().JaxeRevival_IncapacitatedEnd - currentTime
  if player:isAsleep() and remaining < FASTFORWARD_MIN then JaxeRevival.State.setFastForwarding(player, false) end
  return remaining
end

JaxeRevival.State.isSleepAllowed = function() return not JaxeRevival.Side.isMultiplayer() or getServerOptions():getBoolean("SleepAllowed") end

JaxeRevival.State.isFastForwarding = function(player) return player:getModData().JaxeRevival_FastForwarding end

JaxeRevival.State.setFastForwarding = function(player, value)
  player:getModData().JaxeRevival_FastForwarding = value or nil
  if isClient() then JaxeRevival.Side.reportFastForward() end
end

JaxeRevival.State.toggleFastForward = function(player)
  JaxeRevival.State.setFastForwarding(player, not player:getModData().JaxeRevival_FastForwarding)
end

JaxeRevival.State.getMaxRecovery = function(player)
  return SandboxVars.JaxeRevival.AssistedRecoveryTicks - ((SandboxVars.JaxeRevival.AssistedRecoveryTicks * player:getPerkLevel(Perks.Doctor)) / 20)
end

local onGameStart = function() JaxeRevival.Compatibility.initialize() end
Events.OnGameStart.Add(onGameStart)

local isNetworkReady
local onPlayerUpdate = function(player)
  if isNetworkReady or not player or player ~= getPlayer() then return end

  if isNetworkReady == false then
    if JaxeRevival.Incapacitation.isActive(player) then JaxeRevival.State.setFastForwarding(player, nil) end

    JaxeRevival.Side.requestSync()
    isNetworkReady = true

    Events.OnPlayerUpdate.Remove(onPlayerUpdate)
  else
    isNetworkReady = false
  end
end
if isClient() then Events.OnPlayerUpdate.Add(onPlayerUpdate) end

local onCreateLivingCharacter = function()
  if not isClient() then return end

  JaxeRevival.Side.requestSync()
end
Events.OnCreateLivingCharacter.Add(onCreateLivingCharacter)
