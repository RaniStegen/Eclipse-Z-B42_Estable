require("JaxeRevival")

JaxeRevival.UI = {}

local onReviveAction = function(player, target) ISTimedActionQueue.add(JaxeRevival.Action:new(player, target)) end

local onFillWorldObjectContextMenu = function(playerNum, context)
  local player = getSpecificPlayer(playerNum)
  if JaxeRevival.Incapacitation.isActive(player) then
    context:clear()
    return
  end

  if not clickedPlayer or not JaxeRevival.Incapacitation.isActive(clickedPlayer) then return end

  local clickedName = clickedPlayer:getDisplayName()

  if SandboxVars.JaxeRevival.FirstAidRequired > 0 and SandboxVars.JaxeRevival.FirstAidRequired > player:getPerkLevel(Perks.Doctor) then
    local option = context:addOptionOnTop(getText("ContextMenu_JaxeRevival_ActionFirstAidRequired"):format(clickedName, SandboxVars.JaxeRevival.FirstAidRequired))
    option.notAvailable = true
  elseif not JaxeRevival.Skills.canProfessionRevive(player) then
    local option = context:addOptionOnTop(getText((SandboxVars.JaxeRevival.ProfessionRequired == 2 and "ContextMenu_JaxeRevival_ActionDoctorProfessionRequired") or (SandboxVars.JaxeRevival.ProfessionRequired == 3 and "ContextMenu_JaxeRevival_ActionDoctorOrNurseProfessionRequired") or "ContextMenu_JaxeRevival_ActionProfessionRequired"):format(clickedName))
    option.notAvailable = true
  else
    context:addOptionOnTop(getText("ContextMenu_JaxeRevival_Action"):format(clickedName), player, onReviveAction, clickedPlayer)
  end
end
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)

local onFillInventoryObjectContextMenu = function(playerNum, context)
  local player = getSpecificPlayer(playerNum)
  if JaxeRevival.Incapacitation.isActive(player) then
    context:clear()
    return
  end
end
Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)

local original_ISFitnessUI_onClick = ISFitnessUI.onClick
ISFitnessUI.onClick = function(self, button)
  if button.internal == "OK" and JaxeRevival.Incapacitation.isActive(self.player) then return end
  original_ISFitnessUI_onClick(self, button)
end

local original_ISEmoteRadialMenu_checkKey = ISEmoteRadialMenu.checkKey
ISEmoteRadialMenu.checkKey = function(key)
  local player = getSpecificPlayer(0)
  if not player or JaxeRevival.Incapacitation.isActive(player) then return false end
  return original_ISEmoteRadialMenu_checkKey(key)
end

local original_ISSearchManager_toggleSearchMode = ISSearchManager.toggleSearchMode
ISSearchManager.toggleSearchMode = function(self, _isSearchMode)
  if JaxeRevival.Incapacitation.isActive(self.character) then
    self.updateTick = 0
    return
  end
  original_ISSearchManager_toggleSearchMode(self, _isSearchMode)
end
