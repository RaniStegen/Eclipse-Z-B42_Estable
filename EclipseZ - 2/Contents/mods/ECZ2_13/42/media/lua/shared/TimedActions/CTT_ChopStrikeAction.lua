require "TimedActions/ISBaseTimedAction"
require "CutThatTree/CTT_Core"

CTT_ChopStrikeAction = ISBaseTimedAction:derive("CTT_ChopStrikeAction")

function CTT_ChopStrikeAction:isValid()
    local axe = self.character:getPrimaryHandItem()
    return CutThatTree.isValidTree(self.tree) and
        self.character:isEnduranceSufficientForAction() and
        CutThatTree.isChopTool(axe) and
        CutThatTree.hasMinigameAccess(self.character)
end

function CTT_ChopStrikeAction:waitToStart()
    self.character:faceThisObject(self.tree)
    return self.character:shouldBeTurning()
end

function CTT_ChopStrikeAction:update()
    if self.axe then
        self.axe:setJobDelta(0.0)
    end
    self.character:faceThisObject(self.tree)

    if instanceof(self.character, "IsoPlayer") then
        self.character:setMetabolicTarget(Metabolics.ForestryAxe)
    end

    if not isClient() and not self.applied and self.startedMs and getTimestampMs() >= self.startedMs + 1500 then
        self:applyStrike()
    end
end

function CTT_ChopStrikeAction:start()
    self.axe = self.character:getPrimaryHandItem()
    self.startedMs = getTimestampMs()
    self.axe:setJobType(CutThatTree.text("ContextMenu_CTT_ChopTimed"))
    self.axe:setJobDelta(0.0)
    self.character:setIsFarming(true)

    self:setActionAnim(CharacterActionAnims.Chop_tree)
    self:setOverrideHandModels(self.axe, nil)
end

function CTT_ChopStrikeAction:stop()
    if self.axe then
        self.axe:setJobDelta(0.0)
    end
    ISBaseTimedAction.stop(self)
end

function CTT_ChopStrikeAction:perform()
    if self.axe then
        self.axe:setJobDelta(0.0)
    end
    ISBaseTimedAction.perform(self)
end

function CTT_ChopStrikeAction:getDuration()
    return -1
end

function CTT_ChopStrikeAction:complete()
    return true
end

function CTT_ChopStrikeAction:forceDone()
    if isServer() and self.netAction then
        self.netAction:forceComplete()
    else
        self:forceComplete()
    end
end

function CTT_ChopStrikeAction:applyStrike()
    if self.applied then return end
    self.applied = true
    local treeArgs = CutThatTree.getTreeSquareArgs(self.tree)

    if not CutThatTree.isValidTree(self.tree) or not self.axe then
        if isServer() and CutThatTree.sendTreeState then
            CutThatTree.sendTreeState(self.character, self.tree, treeArgs)
        end
        self:forceDone()
        return
    end

    if not CutThatTree.hasMinigameAccess(self.character) then
        if isServer() and CutThatTree.sendTreeState then
            CutThatTree.sendTreeState(self.character, self.tree, treeArgs)
        end
        self:forceDone()
        return
    end

    if self.hitCount and self.hitCount > 0 and not self.visualOnly then
        local greenConditionSnapshot = nil
        if self.quality == "green" then
            greenConditionSnapshot = CutThatTree.getToolConditionSnapshot(self.axe)
        end

        for _ = 1, self.hitCount do
            if CutThatTree.isValidTree(self.tree) then
                self.tree:WeaponHit(self.character, self.axe)
            end
        end

        if greenConditionSnapshot then
            CutThatTree.restoreToolConditionSnapshot(self.axe, greenConditionSnapshot)
            CutThatTree.syncToolState(self.character, self.axe)
        end
    else
        if self.visualOnly and not isServer() and CutThatTree.isValidTree(self.tree) then
            pcall(function() self.tree:WeaponHitEffects(self.character, self.axe) end)
        end
        CutThatTree.addNoise(self.character, self.noiseRadius or 12)
    end

    local strainModifier = 1
    if self.character:getDescriptor():isCharacterProfession(CharacterProfession.LUMBERJACK) then
        strainModifier = 0.5
    end
    self.character:addCombatMuscleStrain(self.axe, 1, strainModifier)

    self:useEndurance()
    CutThatTree.damageTool(self.character, self.axe, self.extraWearRoll or 0)
    CutThatTree.damageToolSharpness(self.character, self.axe, self.quality)
    if isServer() and CutThatTree.sendTreeState then
        CutThatTree.sendTreeState(self.character, self.tree, treeArgs)
    end
    self:forceDone()
end

function CTT_ChopStrikeAction:animEvent(event, parameter)
    if event ~= "ChopTree" and event ~= "CutThatTreeStrike" then return end

    if not isClient() then
        self:applyStrike()
    elseif self.hitCount and self.hitCount > 0 and self.axe and CutThatTree.isValidTree(self.tree) then
        self.tree:WeaponHitEffects(self.character, self.axe)
    end
end

function CTT_ChopStrikeAction:useEndurance()
    if not self.axe then return end

    local use = 0.018
    if self.axe:isUseEndurance() then
        use = self.axe:getWeight() *
            self.axe:getFatigueMod(self.character) *
            self.character:getFatigueMod() *
            self.axe:getEnduranceMod() *
            0.1

        use = math.max(0.018, use * 0.041)
    end

    use = use * (self.enduranceMultiplier or 1.0)

    if self.axe:isTwoHandWeapon() and self.character:getSecondaryHandItem() ~= self.axe then
        use = use + self.axe:getWeight() / 1.5 / 10 / 20
    end

    if self.hitCount and self.hitCount > 1 then
        use = use * (1.0 + ((self.hitCount - 1) * 0.35))
    end

    use = use * 0.5
    use = use * CutThatTree.getEnduranceUseMultiplier()

    CutThatTree.removeEndurance(self.character, use)
end

function CTT_ChopStrikeAction:serverStart()
    self.axe = self.character:getPrimaryHandItem()
    emulateAnimEvent(self.netAction, 1500, "ChopTree", nil)
end

function CTT_ChopStrikeAction:new(character, tree, quality, hitCount, enduranceMultiplier, extraWearRoll, noiseRadius, visualOnly)
    local o = ISBaseTimedAction.new(self, character)
    o.tree = tree
    o.quality = quality or "red"
    o.hitCount = hitCount or 0
    o.visualOnly = visualOnly == true
    o.enduranceMultiplier = enduranceMultiplier or 1.0
    o.extraWearRoll = extraWearRoll or 0
    o.noiseRadius = noiseRadius or 12
    o.maxTime = o:getDuration()
    o.caloriesModifier = 8
    o.forceProgressBar = false
    return o
end
