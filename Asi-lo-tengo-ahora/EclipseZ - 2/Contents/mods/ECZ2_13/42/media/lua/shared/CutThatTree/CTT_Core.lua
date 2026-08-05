CutThatTree = CutThatTree or {}

CutThatTree.VERSION = "0.1.0"

CutThatTree.Settings = {
    greenBase = 0.12,
    yellowBase = 0.28,
    minGreen = 0.06,
    maxGreen = 0.18,
    minYellow = 0.20,
    maxYellow = 0.36,
    markerBaseSpeed = 0.74,
    markerMaxSpeed = 1.42,
    yellowImpact = 0.55,
    redImpactPenalty = 0.20,
    redNoiseRadius = 28,
    maxTreeDistance = 2.0,
    damageStageGreenPenalty = 0.010,
    damageStageYellowPenalty = 0.006,
    damageProgressGreenPenalty = 0.055,
    damageYellowPenalty = 0.025,
    damageProgressSpeedBonus = 0.055,
    comboStart = 3,
    comboMax = 5,
    comboImpactBonus = 0.18,
    comboSpeedBonus = 0.070,
    redInstabilityMax = 4,
    redTargetShift = 0.035,
    hitForgiveness = 0.020,
    sharpnessGreenRoll = 36,
    sharpnessGreenLoss = 0.003,
    sharpnessYellowRoll = 1,
    sharpnessYellowLoss = 0.006,
    sharpnessRedRoll = 1,
    sharpnessRedLoss = 0.110,
}

CutThatTree.Text = {
    EN = {
        ContextMenu_CTT_ChopTimed = "Cut That Tree!",
        Tooltip_CTT_NeedAxe = "Requires an axe or another tool tagged for chopping trees.",
        Tooltip_CTT_NeedAxeSkill = "Requires Axe skill level %1.",
        Tooltip_CTT_AlreadyOpen = "A chopping minigame is already open.",
        Tooltip_CTT_VanillaDisabled = "Vanilla tree cutting is disabled by Cut That Tree.",
        UI_CTT_Title = "Cut That Tree",
        UI_CTT_Damage = "Tree damage: %1%%",
        UI_CTT_HP = "Tree HP: %1/%2",
        UI_CTT_HPNoMax = "Tree HP: %1",
        UI_CTT_ImpactBank = "Rhythm: %1%%",
        UI_CTT_Endurance = "Endurance: %1%%",
        UI_CTT_Sharpness = "Sharpness: %1%%",
        UI_CTT_Difficulty = "Tree difficulty: %1%%",
        UI_CTT_Combo = "Combo: x%1",
        UI_CTT_Hint = "X",
        UI_CTT_Strike = "Hit",
        UI_CTT_Cancel = "Cancel",
        UI_CTT_NeedAxe = "Need an axe",
        UI_CTT_NeedAxeSkill = "Need Axe skill %1",
        UI_CTT_TooFar = "Too far from the tree",
        UI_CTT_Result_Green = "Clean hit",
        UI_CTT_Result_Yellow = "Glancing hit",
        UI_CTT_Result_Red = "Bad swing",
    },
    RU = {
        ContextMenu_CTT_ChopTimed = "Cut That Tree!",
        Tooltip_CTT_NeedAxe = "Нужен топор или другой инструмент с тегом рубки деревьев.",
        Tooltip_CTT_NeedAxeSkill = "Нужен навык топора %1.",
        Tooltip_CTT_AlreadyOpen = "Миниигра рубки уже открыта.",
        Tooltip_CTT_VanillaDisabled = "Ванильная рубка деревьев отключена настройками Cut That Tree.",
        UI_CTT_Title = "Cut That Tree",
        UI_CTT_Damage = "Урон дереву: %1%%",
        UI_CTT_HP = "HP дерева: %1/%2",
        UI_CTT_HPNoMax = "HP дерева: %1",
        UI_CTT_ImpactBank = "Ритм: %1%%",
        UI_CTT_Endurance = "Выносливость: %1%%",
        UI_CTT_Sharpness = "Острота: %1%%",
        UI_CTT_Difficulty = "Сложность дерева: %1%%",
        UI_CTT_Combo = "Комбо: x%1",
        UI_CTT_Hint = "X",
        UI_CTT_Strike = "Удар",
        UI_CTT_Cancel = "Отмена",
        UI_CTT_NeedAxe = "Нужен топор",
        UI_CTT_NeedAxeSkill = "Нужен навык топора %1",
        UI_CTT_TooFar = "Слишком далеко от дерева",
        UI_CTT_Result_Green = "Чистый удар",
        UI_CTT_Result_Yellow = "Скользящий удар",
        UI_CTT_Result_Red = "Плохой замах",
    },
}

local function clamp(value, minValue, maxValue)
    if value < minValue then return minValue end
    if value > maxValue then return maxValue end
    return value
end

function CutThatTree.clamp(value, minValue, maxValue)
    return clamp(value, minValue, maxValue)
end

function CutThatTree.getSandboxOptions()
    if not SandboxVars then return nil end
    return SandboxVars.CutThatTree
end

function CutThatTree.getSandboxBool(key, fallback)
    local options = CutThatTree.getSandboxOptions()
    if not options or options[key] == nil then return fallback end
    return options[key] == true
end

function CutThatTree.getSandboxNumber(key, fallback, minValue, maxValue)
    local options = CutThatTree.getSandboxOptions()
    if not options or options[key] == nil then return fallback end

    local value = tonumber(options[key])
    if not value then return fallback end
    if minValue then value = math.max(minValue, value) end
    if maxValue then value = math.min(maxValue, value) end
    return value
end

function CutThatTree.isAxeSkillRequired()
    return CutThatTree.getSandboxBool("RequireAxeSkill", false)
end

function CutThatTree.getRequiredAxeSkillLevel()
    return math.floor(CutThatTree.getSandboxNumber("RequiredAxeSkillLevel", 2, 0, 10))
end

function CutThatTree.getMaxTreeDistance()
    return CutThatTree.getSandboxNumber("MaxTreeDistance", CutThatTree.Settings.maxTreeDistance, 0.8, 5.0)
end

function CutThatTree.isVanillaTreeCutDisabled()
    return CutThatTree.getSandboxBool("DisableVanillaTreeCut", false)
end

function CutThatTree.getDifficultyMultiplier()
    return CutThatTree.getSandboxNumber("DifficultyMultiplier", 1.0, 0.5, 2.0)
end

function CutThatTree.getTreeDamageMultiplier()
    return CutThatTree.getSandboxNumber("TreeDamageMultiplier", 1.0, 0.25, 3.0)
end

function CutThatTree.getEnduranceUseMultiplier()
    return CutThatTree.getSandboxNumber("EnduranceUseMultiplier", 1.0, 0.0, 3.0)
end

function CutThatTree.getToolConditionWearMultiplier()
    return CutThatTree.getSandboxNumber("ToolConditionWearMultiplier", 1.0, 0.0, 3.0)
end

function CutThatTree.getSharpnessLossMultiplier()
    return CutThatTree.getSandboxNumber("SharpnessLossMultiplier", 1.0, 0.0, 3.0)
end

function CutThatTree.getComboSpeedMultiplier()
    return CutThatTree.getSandboxNumber("ComboSpeedMultiplier", 1.0, 0.0, 3.0)
end

function CutThatTree.getRedNoiseRadius()
    return math.floor(CutThatTree.getSandboxNumber("RedNoiseRadius", CutThatTree.Settings.redNoiseRadius, 0, 80))
end

function CutThatTree.isValidTree(tree)
    return tree ~= nil and tree:getObjectIndex() >= 0
end

function CutThatTree.isChopTool(item)
    return item ~= nil and not item:isBroken() and item:hasTag(ItemTag.CHOP_TREE)
end

function CutThatTree.getTreeDamage(item)
    if not item then return 0 end
    local ok, value = pcall(function() return item:getTreeDamage() end)
    if ok and value then return value end
    return 1
end

function CutThatTree.getBestAxe(playerObj)
    if not playerObj then return nil end

    local handItem = playerObj:getPrimaryHandItem()
    if CutThatTree.isChopTool(handItem) then
        return handItem
    end

    local axes = playerObj:getInventory():getAllEvalRecurse(CutThatTree.isChopTool)
    local best = nil
    for i = 0, axes:size() - 1 do
        local axe = axes:get(i)
        if not best or CutThatTree.getTreeDamage(best) < CutThatTree.getTreeDamage(axe) then
            best = axe
        end
    end
    return best
end

function CutThatTree.getAxeLevel(playerObj)
    if not playerObj then return 0 end
    if Perks and Perks.Axe then
        return playerObj:getPerkLevel(Perks.Axe)
    end
    return 0
end

function CutThatTree.hasMinigameAccess(playerObj)
    if not CutThatTree.isAxeSkillRequired() then return true end

    local requiredLevel = CutThatTree.getRequiredAxeSkillLevel()
    if requiredLevel <= 0 then return true end
    return CutThatTree.getAxeLevel(playerObj) >= requiredLevel
end

function CutThatTree.getEndurance(playerObj)
    if not playerObj or not CharacterStat or not CharacterStat.ENDURANCE then return 1.0 end
    local ok, value = pcall(function() return playerObj:getStats():get(CharacterStat.ENDURANCE) end)
    if ok and value then
        return clamp(value, 0.0, 1.0)
    end
    return 1.0
end

function CutThatTree.getStat(playerObj, stat, fallback)
    if not playerObj or not stat then return fallback end
    local ok, value = pcall(function() return playerObj:getStats():get(stat) end)
    if ok and value ~= nil then return value end
    return fallback
end

function CutThatTree.getFatigue(playerObj)
    if not CharacterStat or not CharacterStat.FATIGUE then return 0.0 end
    return clamp(CutThatTree.getStat(playerObj, CharacterStat.FATIGUE, 0.0) or 0.0, 0.0, 1.0)
end

function CutThatTree.getPain(playerObj)
    if not CharacterStat or not CharacterStat.PAIN then return 0.0 end
    local pain = CutThatTree.getStat(playerObj, CharacterStat.PAIN, 0.0) or 0.0
    if pain > 1.0 then
        pain = pain / 100.0
    end
    return clamp(pain, 0.0, 1.0)
end

function CutThatTree.getMaintenanceLevel(playerObj)
    if not playerObj or not Perks or not Perks.Maintenance then return 0 end
    return playerObj:getPerkLevel(Perks.Maintenance)
end

function CutThatTree.getToolConditionFraction(tool)
    if not tool then return 1.0 end

    local okMax, maxCondition = pcall(function() return tool:getConditionMax() end)
    local okValue, condition = pcall(function() return tool:getCondition() end)
    if okMax and okValue and maxCondition and maxCondition > 0 and condition then
        return clamp(condition / maxCondition, 0.0, 1.0)
    end
    return 1.0
end

local SHARPNESS_EPSILON = 0.0001

function CutThatTree.getVanillaToolSharpness(tool)
    if not tool then return nil end
    local ok, value = pcall(function() return tool:getSharpness() end)
    if ok and value ~= nil then
        return clamp(value, 0.0, 1.0)
    end
    return nil
end

function CutThatTree.getStoredToolSharpness(tool)
    if not tool then return nil end

    local okModData, modData = pcall(function() return tool:getModData() end)
    if not okModData or not modData then return nil end

    local value = tonumber(modData.CTT_Sharpness)
    if value == nil then return nil, nil, modData end

    local vanillaAtWrite = tonumber(modData.CTT_SharpnessVanillaAtWrite)
    if vanillaAtWrite ~= nil then
        vanillaAtWrite = clamp(vanillaAtWrite, 0.0, 1.0)
    end

    return clamp(value, 0.0, 1.0), vanillaAtWrite, modData
end

function CutThatTree.storeToolSharpness(tool, value, vanillaAtWrite)
    if not tool then return end

    local okModData, modData = pcall(function() return tool:getModData() end)
    if not okModData or not modData then return end

    modData.CTT_Sharpness = clamp(value, 0.0, 1.0)
    modData.CTT_SharpnessVanillaAtWrite = clamp(vanillaAtWrite or value, 0.0, 1.0)
end

function CutThatTree.getToolSharpness(tool)
    if not tool then return 1.0 end

    local vanilla = CutThatTree.getVanillaToolSharpness(tool)
    local stored, vanillaAtWrite = CutThatTree.getStoredToolSharpness(tool)
    if stored ~= nil then
        if vanilla ~= nil then
            if vanillaAtWrite ~= nil then
                if math.abs(vanilla - vanillaAtWrite) > SHARPNESS_EPSILON then
                    CutThatTree.storeToolSharpness(tool, vanilla, vanilla)
                    return vanilla
                end
            elseif vanilla > stored + SHARPNESS_EPSILON then
                CutThatTree.storeToolSharpness(tool, vanilla, vanilla)
                return vanilla
            end
        end
        return stored
    end

    if vanilla ~= nil then return vanilla end
    return 1.0
end

function CutThatTree.syncToolState(playerObj, tool)
    if not tool then return end

    if tool.syncItemFields then
        pcall(function() tool:syncItemFields() end)
    end

    if syncItemFields and playerObj then
        pcall(function() syncItemFields(playerObj, tool) end)
    end

    if sendItemStats then
        pcall(function() sendItemStats(tool) end)
    end

    if tool.transmitModData then
        pcall(function() tool:transmitModData() end)
    end
end

function CutThatTree.setToolSharpness(tool, value)
    if not tool then return false end

    value = clamp(value, 0.0, 1.0)
    local ok = pcall(function() tool:setSharpness(value) end)
    CutThatTree.storeToolSharpness(tool, value, CutThatTree.getVanillaToolSharpness(tool) or value)

    return ok
end

function CutThatTree.getToolConditionSnapshot(tool)
    if not tool then return nil end

    local snapshot = {}
    local ok, value = pcall(function() return tool:getCondition() end)
    if ok and value ~= nil then snapshot.condition = value end

    return snapshot
end

function CutThatTree.restoreToolConditionSnapshot(tool, snapshot)
    if not tool or not snapshot then return end

    if snapshot.condition ~= nil then
        local ok, current = pcall(function() return tool:getCondition() end)
        if ok and current ~= nil and current < snapshot.condition then
            pcall(function() tool:setCondition(snapshot.condition) end)
        end
    end
end

function CutThatTree.getRainIntensity()
    if not getClimateManager then return 0.0 end
    local ok, value = pcall(function() return getClimateManager():getPrecipitationIntensity() end)
    if ok and value then
        return clamp(value, 0.0, 1.0)
    end
    return 0.0
end

function CutThatTree.getDarkness(playerObj, tree)
    if not playerObj then return 0.0 end

    local square = tree and tree:getSquare() or playerObj:getSquare()
    if not square then return 0.0 end

    local ok, light = pcall(function() return square:getLightLevel(playerObj:getPlayerNum()) end)
    if not ok or not light then return 0.0 end

    local okTorch, torch = pcall(function() return playerObj:getTorchStrength() end)
    if okTorch and torch and square == playerObj:getSquare() then
        light = math.max(light, math.min(1.0, torch))
    end

    return clamp((0.75 - light) / 0.75, 0.0, 1.0)
end

function CutThatTree.getTreeHealth(tree)
    if not tree then return nil end
    local ok, value = pcall(function() return tree:getHealth() end)
    if ok then return value end
    return nil
end

function CutThatTree.getTreeMaxHealth(tree)
    if not tree then return nil end
    local ok, value = pcall(function() return tree:getMaxHealth() end)
    if ok then return value end
    return nil
end

function CutThatTree.getTreeSquareArgs(tree)
    if not tree then return nil end

    local ok, square = pcall(function() return tree:getSquare() end)
    if not ok or not square then return nil end

    return {
        x = square:getX(),
        y = square:getY(),
        z = square:getZ(),
    }
end

function CutThatTree.findTreeAt(args)
    if not args or not args.x or not args.y or args.z == nil or not getCell then return nil end

    local square = getCell():getGridSquare(args.x, args.y, args.z)
    if square and square:HasTree() then
        return square:getTree()
    end
    return nil
end

function CutThatTree.isSameTreeSquare(tree, args)
    local treeArgs = CutThatTree.getTreeSquareArgs(tree)
    return treeArgs and args and
        treeArgs.x == args.x and
        treeArgs.y == args.y and
        treeArgs.z == args.z
end

function CutThatTree.getTreeStateArgs(tree, fallbackArgs)
    local args = CutThatTree.getTreeSquareArgs(tree) or fallbackArgs
    if not args then return nil end

    local state = {
        x = args.x,
        y = args.y,
        z = args.z,
        valid = CutThatTree.isValidTree(tree),
    }

    local health = CutThatTree.getTreeHealth(tree)
    local maxHealth = CutThatTree.getTreeMaxHealth(tree)
    if health ~= nil then state.health = health end
    if maxHealth ~= nil then state.maxHealth = maxHealth end

    return state
end

function CutThatTree.getTreeHealthFraction(tree)
    local health = CutThatTree.getTreeHealth(tree)
    local maxHealth = CutThatTree.getTreeMaxHealth(tree)
    if not health or not maxHealth or maxHealth <= 0 then return nil end
    return clamp(health / maxHealth, 0.0, 1.0)
end

function CutThatTree.getTreeDifficulty(tree)
    local maxHealth = CutThatTree.getTreeMaxHealth(tree) or CutThatTree.getTreeHealth(tree)
    if not maxHealth then return 0.35 end
    return clamp((maxHealth - 80.0) / 260.0, 0.0, 1.0)
end

function CutThatTree.getToolControl(tool)
    local treeDamage = CutThatTree.getTreeDamage(tool)
    local condition = CutThatTree.getToolConditionFraction(tool)
    local sharpness = CutThatTree.getToolSharpness(tool)
    local strongTool = clamp((treeDamage - 15.0) / 40.0, 0.0, 1.0)
    local quickTool = clamp((20.0 - treeDamage) / 20.0, 0.0, 1.0)
    local edge = (sharpness * 0.70) + (condition * 0.30)
    local dullness = 1.0 - edge

    return {
        treeDamage = treeDamage,
        condition = condition,
        sharpness = sharpness,
        greenBonus = ((edge - 0.5) * 0.035) + (quickTool * 0.008) - (strongTool * 0.006),
        yellowBonus = ((edge - 0.5) * 0.026) + (quickTool * 0.006),
        speedBonus = (dullness * 0.22) + (strongTool * 0.04) - (quickTool * 0.035),
        impactMultiplier = 0.90 + (strongTool * 0.14),
    }
end

function CutThatTree.getControlBalance(playerObj, tree, tool, stage, combo, instability)
    local settings = CutThatTree.Settings
    local difficultyScale = math.sqrt(CutThatTree.getDifficultyMultiplier())
    local skill = CutThatTree.getAxeLevel(playerObj)
    local maintenance = CutThatTree.getMaintenanceLevel(playerObj)
    local endurance = CutThatTree.getEndurance(playerObj)
    local fatigue = CutThatTree.getFatigue(playerObj)
    local pain = CutThatTree.getPain(playerObj)
    local rain = CutThatTree.getRainIntensity()
    local darkness = CutThatTree.getDarkness(playerObj, tree)
    local treeDifficulty = CutThatTree.getTreeDifficulty(tree)
    local toolControl = CutThatTree.getToolControl(tool)

    combo = combo or 0
    instability = instability or 0
    stage = stage or 0

    local lowEndurance = 1.0 - endurance
    local comboBonus = combo * 0.004
    local healthFraction = CutThatTree.getTreeHealthFraction(tree)
    local damageProgress = healthFraction and (1.0 - healthFraction) or clamp(stage / 5.0, 0.0, 1.0)
    local damagePressure = math.sqrt(clamp(damageProgress, 0.0, 1.0))

    local green = settings.greenBase +
        (skill * 0.009) +
        (maintenance * 0.002) +
        (endurance * 0.014) +
        comboBonus +
        toolControl.greenBonus -
        (stage * settings.damageStageGreenPenalty) -
        (damagePressure * settings.damageProgressGreenPenalty) -
        (treeDifficulty * 0.034) -
        (lowEndurance * 0.020) -
        (fatigue * 0.030) -
        (pain * 0.024) -
        (rain * 0.012) -
        (darkness * 0.018) -
        (instability * 0.012)

    local yellow = settings.yellowBase +
        (skill * 0.006) +
        (maintenance * 0.0015) +
        (combo * 0.003) +
        toolControl.yellowBonus -
        (stage * settings.damageStageYellowPenalty) -
        (damagePressure * settings.damageYellowPenalty) -
        (treeDifficulty * 0.022) -
        (fatigue * 0.018) -
        (pain * 0.014) -
        (rain * 0.008) -
        (darkness * 0.012) -
        (instability * 0.008)

    local speed = settings.markerBaseSpeed +
        (stage * 0.070) +
        (lowEndurance * 0.220) +
        (fatigue * 0.200) +
        (pain * 0.140) +
        (treeDifficulty * 0.100) +
        (rain * 0.050) +
        (darkness * 0.060) +
        (instability * 0.150) +
        (combo * settings.comboSpeedBonus * CutThatTree.getComboSpeedMultiplier()) +
        (damagePressure * settings.damageProgressSpeedBonus) +
        toolControl.speedBonus -
        (skill * 0.018) -
        (maintenance * 0.006)

    return {
        green = clamp(green / difficultyScale, settings.minGreen, settings.maxGreen),
        yellow = clamp(yellow / difficultyScale, settings.minYellow, settings.maxYellow),
        speed = clamp(speed * difficultyScale, 0.55, settings.markerMaxSpeed),
        treeDifficulty = treeDifficulty,
        condition = toolControl.condition,
        sharpness = toolControl.sharpness,
        impactMultiplier = toolControl.impactMultiplier,
        targetShift = clamp(instability * settings.redTargetShift, 0.0, 0.22),
    }
end

function CutThatTree.getLanguageCode()
    if Translator and Translator.getLanguage then
        local ok, lang = pcall(function() return Translator.getLanguage():name() end)
        if ok and lang then
            lang = tostring(lang):upper()
            if string.find(lang, "RU", 1, true) or string.find(lang, "RUSSIAN", 1, true) then return "RU" end
        end
    end
    return "EN"
end

function CutThatTree.formatText(text, ...)
    local args = { ... }
    for i = 1, #args do
        text = string.gsub(text, "%%" .. tostring(i), tostring(args[i]))
    end
    text = string.gsub(text, "%%%%", "%%")
    return text
end

function CutThatTree.text(key, ...)
    local translated = getText(key, ...)
    if translated and translated ~= key then
        return CutThatTree.formatText(translated)
    end

    local lang = CutThatTree.getLanguageCode()
    local fallback = (CutThatTree.Text[lang] and CutThatTree.Text[lang][key]) or CutThatTree.Text.EN[key] or key
    return CutThatTree.formatText(fallback, ...)
end

function CutThatTree.getTreeDistance(playerObj, tree)
    if not playerObj or not tree then return 999 end

    local square = tree:getSquare()
    if not square then return 999 end

    local dx = playerObj:getX() - (square:getX() + 0.5)
    local dy = playerObj:getY() - (square:getY() + 0.5)
    return math.sqrt((dx * dx) + (dy * dy))
end

function CutThatTree.getDamageStage(tree)
    local fraction = CutThatTree.getTreeHealthFraction(tree)
    if not fraction then return 0 end
    local damage = 1.0 - fraction
    if damage >= 0.95 then return 5 end
    if damage >= 0.75 then return 4 end
    if damage >= 0.50 then return 3 end
    if damage >= 0.25 then return 2 end
    if damage > 0.02 then return 1 end
    return 0
end

function CutThatTree.getStrikeProfile(quality)
    if quality == "green" then
        return {
            impact = 1.0,
            baseHits = 1,
            enduranceMultiplier = 1.0,
            extraWearRoll = 0,
            noiseRadius = 8,
            text = "UI_CTT_Result_Green",
        }
    end
    if quality == "yellow" then
        return {
            impact = CutThatTree.Settings.yellowImpact,
            baseHits = 1,
            enduranceMultiplier = 1.16,
            extraWearRoll = 18,
            noiseRadius = 11,
            text = "UI_CTT_Result_Yellow",
        }
    end
    return {
        impact = -CutThatTree.Settings.redImpactPenalty,
        baseHits = 0,
        enduranceMultiplier = 1.45,
        extraWearRoll = 4,
        noiseRadius = CutThatTree.getRedNoiseRadius(),
        text = "UI_CTT_Result_Red",
    }
end

function CutThatTree.adjustWearRoll(baseRoll, playerObj, tool, quality)
    if not baseRoll or baseRoll <= 0 then return 0 end

    local maintenance = CutThatTree.getMaintenanceLevel(playerObj)
    local condition = CutThatTree.getToolConditionFraction(tool)
    local roll = baseRoll + (maintenance * 4)

    if condition < 0.35 then
        roll = roll - 5
    end
    if quality == "red" then
        roll = roll - 2
    end

    return math.max(2, math.floor(roll))
end

function CutThatTree.getSharpnessWearProfile(quality)
    local settings = CutThatTree.Settings
    if quality == "green" then
        return settings.sharpnessGreenRoll, settings.sharpnessGreenLoss
    end
    if quality == "yellow" then
        return settings.sharpnessYellowRoll, settings.sharpnessYellowLoss
    end
    return settings.sharpnessRedRoll, settings.sharpnessRedLoss
end

function CutThatTree.damageToolSharpness(playerObj, tool, quality)
    if not tool then return end

    local roll, loss = CutThatTree.getSharpnessWearProfile(quality)
    if not roll or roll <= 0 or not loss or loss <= 0 then return end

    local sharpnessMultiplier = CutThatTree.getSharpnessLossMultiplier()
    if sharpnessMultiplier <= 0 then return end
    loss = loss * sharpnessMultiplier

    if roll > 1 then
        roll = roll + (CutThatTree.getMaintenanceLevel(playerObj) * 3)
        if ZombRand(math.max(2, math.floor(roll))) ~= 0 then return end
    end

    local maintenanceLossReduction = math.min(0.30, CutThatTree.getMaintenanceLevel(playerObj) * 0.025)
    local current = CutThatTree.getToolSharpness(tool)
    CutThatTree.setToolSharpness(tool, current - (loss * (1.0 - maintenanceLossReduction)))
    CutThatTree.syncToolState(playerObj, tool)
end

function CutThatTree.removeEndurance(playerObj, amount)
    if not playerObj or amount <= 0 then return end
    if CharacterStat and CharacterStat.ENDURANCE then
        local before = CutThatTree.getEndurance(playerObj)
        local ok = pcall(function() playerObj:getStats():remove(CharacterStat.ENDURANCE, amount) end)
        local after = CutThatTree.getEndurance(playerObj)
        if not ok or after >= before then
            pcall(function()
                playerObj:getStats():set(CharacterStat.ENDURANCE, CutThatTree.clamp(before - amount, 0.0, 1.0))
            end)
        end
    end
end

function CutThatTree.damageTool(playerObj, tool, roll)
    if not tool or roll <= 0 then return end

    local wearMultiplier = CutThatTree.getToolConditionWearMultiplier()
    if wearMultiplier <= 0 then return end
    roll = math.max(1, math.floor(roll / wearMultiplier))

    if ZombRand(roll) ~= 0 then return end
    if tool:getCondition() <= 0 then return end

    tool:setCondition(tool:getCondition() - 1)
    CutThatTree.syncToolState(playerObj, tool)

    if ISWorldObjectContextMenu and ISWorldObjectContextMenu.checkWeapon and playerObj then
        ISWorldObjectContextMenu.checkWeapon(playerObj)
    end
end

function CutThatTree.addNoise(playerObj, radius)
    if not playerObj or not radius or radius <= 0 then return end
    addSound(playerObj, playerObj:getX(), playerObj:getY(), playerObj:getZ(), radius, radius)
end

function CutThatTree.halo(playerObj, textKey, ...)
    if not playerObj or not textKey then return end
    playerObj:setHaloNote(CutThatTree.text(textKey, ...))
end
