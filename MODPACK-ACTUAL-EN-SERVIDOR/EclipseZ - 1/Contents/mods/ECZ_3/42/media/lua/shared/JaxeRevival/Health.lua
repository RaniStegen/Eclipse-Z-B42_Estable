require("JaxeRevival")

JaxeRevival.Health = {}

local playerActual = {}
local setActual = function(player, value)
  local playerNum = player:getPlayerNum()
  if playerActual[playerNum] then playerActual[playerNum] = value end
end

local getEffective = function(actual) return ((actual - SandboxVars.JaxeRevival.IncapacitatedHealth) / (100 - SandboxVars.JaxeRevival.IncapacitatedHealth)) * 100 end
local getActual = function(effective) return ((effective / 100) * (100 - SandboxVars.JaxeRevival.IncapacitatedHealth)) + SandboxVars.JaxeRevival.IncapacitatedHealth end

JaxeRevival.Health.applyEffective = function(value)
  if value then playerActual = {} end

  local players = JaxeRevival.Side.isMultiplayer() and getOnlinePlayers() or IsoPlayer.getPlayers()
  if not players then return end

  for i = 0, players:size() - 1 do
    local player = players:get(i)
    if player then
      local body = player:isLocalPlayer() and player:getBodyDamage() or player:getBodyDamageRemote()

      if value then
        playerActual[i] = body:getHealth()
        if JaxeRevival.Incapacitation.isActive(player) then
          body:setOverallBodyHealth(1)
        elseif not player:isDead() then
          body:setOverallBodyHealth(getEffective(playerActual[i]))
        end
      else
        body:setOverallBodyHealth(playerActual[i])
      end
    end
  end
end

JaxeRevival.Health.stabilize = function(player)
  local body = player:getBodyDamage()

  if SandboxVars.JaxeRevival.RecoveryRemovesInjuries then
    player:getBodyDamage():RestoreToFullHealth()
    setActual(player, 1)
    return
  end

  body:AddGeneralHealth(999)
  setActual(player, 1)

  body:setCatchACold(0)
  body:setHasACold(false)
  body:setColdStrength(0)
  body:setTimeToSneezeOrCough(-1)

  local parts = body:getBodyParts()
  for i = 0, BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
    local part = parts:get(i)

    part:setAdditionalPain(0)
    part:setInfectedWound(false)
    part:setWoundInfectionLevel(0)
    part:setNeedBurnWash(false)
    part:setLastTimeBurnWash(0)

    if not JaxeRevival.Side.isMultiplayer() then
      part:setBleeding(false)
      part:setBleedingTime(0)
    end
  end
end

JaxeRevival.Health.revive = function(player, bandage, restore)
  if player:isDead() or not JaxeRevival.Incapacitation.isActive(player) then return end

  local recoveryHealth

  local body = player:getBodyDamage()
  if restore then
    body:RestoreToFullHealth()
  else
    if SandboxVars.JaxeRevival.RecoveryHealth >= 100 then
      recoveryHealth = 100
    else
      recoveryHealth = getActual(SandboxVars.JaxeRevival.RecoveryHealth)

      body:AddGeneralHealth(999)
      body:ReduceGeneralHealth(100 - recoveryHealth)
    end

    local parts = body:getBodyParts()
    for i = 0, BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
      local part = parts:get(i)

      part:setAdditionalPain(0)
      part:setInfectedWound(false)
      part:setWoundInfectionLevel(0)
      part:setNeedBurnWash(false)
      part:setLastTimeBurnWash(0)

      if not JaxeRevival.Side.isMultiplayer() then
        part:setBleeding(false)
        part:setBleedingTime(0)
      elseif bandage then
        part:setBandaged(true, 0)
      end
    end
  end
  setActual(player, recoveryHealth)

  JaxeRevival.Incapacitation.apply(player, false)

  if isServer() then JaxeRevival.Server.sendRevive(player:getUsername(), bandage, restore) end
end

JaxeRevival.Health.kill = function(player)
  if player:isDead() or not JaxeRevival.Incapacitation.isActive(player) then return end

  JaxeRevival.Incapacitation.apply(player, false)

  player:getBodyDamage():ReduceGeneralHealth(999)
  setActual(player, 0)

  if isServer() then JaxeRevival.Server.sendKill(player:getUsername()) end
end

local onPlayerDeath = function(player) JaxeRevival.Panel.show(player, true) end
Events.OnPlayerDeath.Add(onPlayerDeath)

local onWeaponHitCharacter = function(attacker, defender, _, damage)
  if not JaxeRevival.Incapacitation.isActive(defender) or not instanceof(attacker, "IsoPlayer") or damage <= 0 then return end
  JaxeRevival.Health.kill(defender)
end
Events.OnWeaponHitCharacter.Add(onWeaponHitCharacter)

local onPreUIDraw = function()
  if not getPlayer() then return end
  JaxeRevival.Health.applyEffective(true)
end
Events.OnPreUIDraw.Add(onPreUIDraw)

local onPostUIDraw = function()
  if not getPlayer() then return end
  JaxeRevival.Health.applyEffective(false)
end
Events.OnPostUIDraw.Add(onPostUIDraw)
