require "TimedActions/ISBaseTimedAction"
require "CutThatTree/CTT_Core"
require "CutThatTree/CTT_ChopMinigameUI"

CTT_OpenChopMinigameAction = ISBaseTimedAction:derive("CTT_OpenChopMinigameAction")

function CTT_OpenChopMinigameAction:isValid()
    return CutThatTree.isValidTree(self.tree) and
        CutThatTree.isChopTool(self.character:getPrimaryHandItem()) and
        CutThatTree.hasMinigameAccess(self.character)
end

function CTT_OpenChopMinigameAction:waitToStart()
    self.character:faceThisObject(self.tree)
    return self.character:shouldBeTurning()
end

function CTT_OpenChopMinigameAction:perform()
    CTT_ChopMinigameUI.open(self.character, self.tree)
    ISBaseTimedAction.perform(self)
end

function CTT_OpenChopMinigameAction:new(character, tree)
    local o = ISBaseTimedAction.new(self, character)
    o.tree = tree
    o.maxTime = 1
    o.stopOnWalk = true
    o.stopOnRun = true
    o.stopOnAim = true
    return o
end
