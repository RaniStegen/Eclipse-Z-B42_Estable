require("JaxeRevival")
require "TimedActions/ISBaseTimedAction"

JaxeRevival.Action = ISBaseTimedAction:derive("JaxeRevival.Action")

JaxeRevival.Action.isValid = function() return true end

JaxeRevival.Action.update = function(self) self.character:faceThisObject(self.target) end

JaxeRevival.Action.waitToStart = function(self)
  self.character:faceThisObject(self.target)
  return self.character:shouldBeTurning()
end

JaxeRevival.Action.start = function(self)
  self:setActionAnim("Loot")
  self.character:SetVariable("LootPosition", "Low")
end

JaxeRevival.Action.stop = function(self) ISBaseTimedAction.stop(self) end

JaxeRevival.Action.perform = function(self)
  ISBaseTimedAction.perform(self)
  JaxeRevival.Side.reportRevive(self.target)
end

JaxeRevival.Action.new = function(self, character, target)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.maxTime = SandboxVars.JaxeRevival.AssistedRecoveryTicks - ((SandboxVars.JaxeRevival.AssistedRecoveryTicks * character:getPerkLevel(Perks.Doctor)) / 20)
  o.stopOnWalk = true
  o.stopOnRun = true

  o.target = target
  o.character = character
  if o.character:isTimedActionInstant() then o.maxTime = 1 end

  luautils.walkAdj(character, target:getSquare())

  return o
end
