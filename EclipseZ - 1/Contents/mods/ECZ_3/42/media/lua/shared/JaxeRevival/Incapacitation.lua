require("JaxeRevival")

JaxeRevival.Incapacitation = {}

local ANIMATION_VARIABLE = "JaxeRevival_Incapacitated"

local conclude = function(player)
  if JaxeRevival.Incapacitation.canRecoverUnassisted(player) then
    JaxeRevival.Health.revive(player)
  else
    JaxeRevival.Health.kill(player)
  end
end

JaxeRevival.Incapacitation.apply = function(player, value)
  local modData = player:getModData()
  local initial = value and not modData.JaxeRevival_Incapacitated

  modData.JaxeRevival_Incapacitated = value or nil

  if value then
    if initial then
      player:playDeadSound()
      player:dropHandItems()
    end

    if player:isSitOnGround() then player:setVariable("forcegetup", true) end
    player:clearVariable("ExerciseStarted")
    player:setVariable(ANIMATION_VARIABLE, true)
  else
    player:clearVariable(ANIMATION_VARIABLE)
  end

  player:setInvincible(value)
  player:setOnFloor(value)

  if JaxeRevival.Side.isRemoteClient(player) then return end

  if isServer() then player:setGhostMode(value) end

  if JaxeRevival.Side.isClientOrSingleplayer() then
    player:StopAllActionQueue()
    player:setBlockMovement(value)
    player:setIgnoreAimingInput(value)

    local playerNum = player:getPlayerNum()

    if value then
      player:nullifyAiming()
      player:setPerformingAnAction(false)

      local cursor = getCell():getDrag(playerNum)
      if cursor then cursor:exitCursor() end
    end

    JaxeRevival.Panel.show(player, value)

    if UIManager.getFadeAlpha(playerNum) == 1 then UIManager.FadeIn(playerNum, 0) end
  else
    JaxeRevival.Server.sendIncapacitate(player:getUsername(), value)
  end

  if value then
    if initial then
      if JaxeRevival.Side.isServerOrSingleplayer() and not JaxeRevival.Skills.checkPassives(player) then
        JaxeRevival.Health.kill(player)
        return
      end

      JaxeRevival.Skills.applyConsequences(player)
    end

    JaxeRevival.Health.stabilize(player)

    player:setAsleep(modData.JaxeRevival_FastForwarding or false)

    local remaining = JaxeRevival.State.getTimeRemaining(player)
    if remaining and JaxeRevival.Side.isServerOrSingleplayer() and remaining <= 0 then conclude(player) end
  else
    modData.JaxeRevival_IncapacitatedEnd = nil
  end
end

JaxeRevival.Incapacitation.isActive = function(player) return player:getModData().JaxeRevival_Incapacitated end

JaxeRevival.Incapacitation.canRecoverUnassisted = function(player)
  if JaxeRevival.Side.isMultiplayer() and not SandboxVars.JaxeRevival.UnassistedRecovery then return false end
  return JaxeRevival.Skills.checkPassives(player)
end

local OnTick = function(_)
  local players = JaxeRevival.Side.isMultiplayer() and getOnlinePlayers() or IsoPlayer.getPlayers()

  for i = 0, players:size() - 1 do
    local player = players:get(i)
    if player then
      if not player:isDead() and (JaxeRevival.Incapacitation.isActive(player) or player:getBodyDamage():getHealth() < SandboxVars.JaxeRevival.IncapacitatedHealth) then
        if not JaxeRevival.Compatibility.checkOnTick(player) then return end
        JaxeRevival.Incapacitation.apply(player, true)
      end
    end
  end
end
Events.OnTick.Add(OnTick)
