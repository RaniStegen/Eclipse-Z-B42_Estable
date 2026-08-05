require "ISUI/ISPanel"
require "ISUI/ISButton"
require "CutThatTree/CTT_Core"
require "TimedActions/CTT_ChopStrikeAction"

CTT_ChopMinigameUI = ISPanel:derive("CTT_ChopMinigameUI")
CTT_ChopMinigameUI.instance = nil

local MODULE = "CutThatTree"
local STATE_SYNC_INTERVAL = 1200
local PANEL_W = 460
local PANEL_H = 552
local BAR_X = 378
local BAR_Y = 64
local BAR_W = 36
local BAR_H = 296
local TRUNK_X = 48
local TRUNK_Y = 62
local TRUNK_W = 150
local TRUNK_H = 420
local STATUS_X = 206
local STATUS_Y = 346
local STATUS_LINE_H = 22
local RESULT_Y = 66
local CANCEL_W = 86
local CANCEL_H = 24
local STRIKE_W = 86
local STRIKE_H = 24
local TEXTURE_DIR = "media/textures/"
local textureCache = {}
local trunkTextureNames = {
    [0] = "trunk_base",
    [1] = "trunk_cut_01",
    [2] = "trunk_cut_02",
    [3] = "trunk_cut_03",
    [4] = "trunk_cut_04",
    [5] = "trunk_cut_05",
}

local function getMinigameTexture(name)
    if textureCache[name] == nil then
        local ok, texture = pcall(function() return getTexture(TEXTURE_DIR .. name .. ".png") end)
        textureCache[name] = ok and texture or false
    end
    if textureCache[name] == false then return nil end
    return textureCache[name]
end

local function nowMs()
    return getTimestampMs()
end

function CTT_ChopMinigameUI.open(playerObj, tree)
    if CTT_ChopMinigameUI.instance then
        CTT_ChopMinigameUI.instance:close()
    end

    local x = (getCore():getScreenWidth() - PANEL_W) / 2
    local y = (getCore():getScreenHeight() - PANEL_H) / 2
    local ui = CTT_ChopMinigameUI:new(x, y, PANEL_W, PANEL_H, playerObj, tree)
    ui:initialise()
    ui:addToUIManager()
    ui:bringToTop()
    ui:setWantKeyEvents(true)
    CTT_ChopMinigameUI.instance = ui
    ui:requestTreeState(0)
    return ui
end

function CTT_ChopMinigameUI:initialise()
    ISPanel.initialise(self)
    self:rollTarget()
end

function CTT_ChopMinigameUI:createChildren()
    if ISPanel.createChildren then
        ISPanel.createChildren(self)
    end

    self.strikeButton = ISButton:new(self.width - CANCEL_W - STRIKE_W - 22, self.height - STRIKE_H - 12, STRIKE_W, STRIKE_H, CutThatTree.text("UI_CTT_Strike"), self, nil, CTT_ChopMinigameUI.onStrikeButton)
    self.strikeButton:initialise()
    self.strikeButton:instantiate()
    self:addChild(self.strikeButton)

    self.cancelButton = ISButton:new(self.width - CANCEL_W - 14, self.height - CANCEL_H - 12, CANCEL_W, CANCEL_H, CutThatTree.text("UI_CTT_Cancel"), self, CTT_ChopMinigameUI.onCancelButton)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self:addChild(self.cancelButton)
end

function CTT_ChopMinigameUI:onStrikeButton(button)
    if button and button.sounds and button.sounds.activate and getSoundManager then
        getSoundManager():playUISound(button.sounds.activate)
    end
    self:tryStrike()
end

function CTT_ChopMinigameUI:onCancelButton()
    self:close()
end

function CTT_ChopMinigameUI:isTreeGone()
    if self.syncedTreeValid == false then return true end
    return not CutThatTree.isValidTree(self.tree)
end

function CTT_ChopMinigameUI:getDamageFraction()
    if self.syncedTreeHealth and self.syncedTreeMaxHealth and self.syncedTreeMaxHealth > 0 then
        return CutThatTree.clamp(1.0 - (self.syncedTreeHealth / self.syncedTreeMaxHealth), 0.0, 1.0)
    end

    local healthFraction = CutThatTree.getTreeHealthFraction(self.tree)
    if healthFraction then
        return 1.0 - healthFraction
    end

    local health = CutThatTree.getTreeHealth(self.tree)
    if health and self.initialTreeHealth and self.initialTreeHealth > 0 then
        return CutThatTree.clamp(1.0 - (health / self.initialTreeHealth), 0.0, 1.0)
    end

    return 0.0
end

function CTT_ChopMinigameUI:close()
    if CTT_ChopMinigameUI.instance == self then
        CTT_ChopMinigameUI.instance = nil
    end
    if self.playerObj then
        self.playerObj:setIsFarming(false)
    end
    self:removeFromUIManager()
end

function CTT_ChopMinigameUI:requestTreeState(delayMs)
    if not isClient() or not sendClientCommand or not self.playerObj then return end
    if not CutThatTree.isValidTree(self.tree) then return end

    local current = nowMs()
    delayMs = delayMs or 0
    if self.nextTreeStateRequest and current + delayMs < self.nextTreeStateRequest then return end

    local args = CutThatTree.getTreeSquareArgs(self.tree)
    if not args then return end

    self.nextTreeStateRequest = current + delayMs + STATE_SYNC_INTERVAL
    sendClientCommand(self.playerObj, MODULE, "RequestTreeState", args)
end

function CTT_ChopMinigameUI:onTreeState(args)
    if not CutThatTree.isSameTreeSquare(self.tree, args) then return end

    self.syncedTreeValid = args.valid ~= false
    self.syncedTreeHealth = args.health
    self.syncedTreeMaxHealth = args.maxHealth
    self.syncedToolSharpness = args.toolSharpness
    self.syncedToolCondition = args.toolCondition
    self.syncedEndurance = args.endurance
    self.lastTreeStateMs = nowMs()

    if self.syncedTreeValid == false then
        self:close()
        return
    end

    local damage = self:getDamageFraction()
    local stage = 0
    if damage >= 0.95 then stage = 5
    elseif damage >= 0.75 then stage = 4
    elseif damage >= 0.50 then stage = 3
    elseif damage >= 0.25 then stage = 2
    elseif damage > 0.02 then stage = 1
    end
    if stage > self.visualStage then
        self.visualStage = stage
    end
end

function CTT_ChopMinigameUI:isTooFar()
    return CutThatTree.getTreeDistance(self.playerObj, self.tree) > CutThatTree.getMaxTreeDistance()
end

function CTT_ChopMinigameUI:getDifficultyStage()
    local stage = CutThatTree.getDamageStage(self.tree)
    local damage = self:getDamageFraction()
    local damageStage = 0
    if damage >= 0.95 then damageStage = 5
    elseif damage >= 0.75 then damageStage = 4
    elseif damage >= 0.50 then damageStage = 3
    elseif damage >= 0.25 then damageStage = 2
    elseif damage > 0.02 then damageStage = 1
    end
    stage = math.max(stage or 0, damageStage)

    if stage > self.visualStage then
        self.visualStage = stage
    end
    return self.visualStage
end

function CTT_ChopMinigameUI:rollTarget()
    local stage = self:getDifficultyStage()
    local axe = self.playerObj and self.playerObj:getPrimaryHandItem()
    local balance = CutThatTree.getControlBalance(self.playerObj, self.tree, axe, stage, self.combo or 0, self.instability or 0)
    self.lastBalance = balance

    local green = balance.green
    local yellow = balance.yellow

    if yellow < green + 0.08 then
        yellow = green + 0.08
    end

    local center = 0.18 + (ZombRand(640) / 1000)
    if balance.targetShift and balance.targetShift > 0 then
        local direction = ZombRand(2) == 0 and -1 or 1
        center = center + (direction * balance.targetShift)
    end

    local halfYellow = yellow / 2
    if center - halfYellow < 0.02 then center = 0.02 + halfYellow end
    if center + halfYellow > 0.98 then center = 0.98 - halfYellow end

    self.greenMin = center - (green / 2)
    self.greenMax = center + (green / 2)
    self.yellowMin = center - halfYellow
    self.yellowMax = center + halfYellow

    self.markerSpeed = balance.speed
    self.lastUpdateMs = nowMs()
    self.visibleMarker = self.marker
end

function CTT_ChopMinigameUI:getQuality()
    local marker = self.visibleMarker or self.marker
    local forgiveness = CutThatTree.Settings.hitForgiveness or 0
    if marker >= self.greenMin - forgiveness and marker <= self.greenMax + forgiveness then
        return "green"
    end
    if marker >= self.yellowMin and marker <= self.yellowMax then
        return "yellow"
    end
    return "red"
end

function CTT_ChopMinigameUI:updateStrikeState(quality)
    local settings = CutThatTree.Settings

    if quality == "green" then
        self.greenStreak = (self.greenStreak or 0) + 1
        if self.greenStreak >= settings.comboStart then
            self.combo = math.min(settings.comboMax, self.greenStreak - settings.comboStart + 1)
        else
            self.combo = 0
        end
        self.instability = math.max(0.0, (self.instability or 0.0) - 0.75)
        return
    end

    if quality == "yellow" then
        self.greenStreak = 0
        self.combo = math.max(0, (self.combo or 0) - 1)
        self.instability = math.max(0.0, (self.instability or 0.0) - 0.35)
        return
    end

    self.greenStreak = 0
    self.combo = 0
    self.instability = math.min(settings.redInstabilityMax, (self.instability or 0.0) + 1.0)
end

function CTT_ChopMinigameUI:tryStrike()
    if self.pendingStrike or self:isTreeGone() then return end

    if self:isTooFar() then
        CutThatTree.halo(self.playerObj, "UI_CTT_TooFar")
        self:close()
        return
    end

    local axe = self.playerObj:getPrimaryHandItem()
    if not CutThatTree.isChopTool(axe) then
        CutThatTree.halo(self.playerObj, "UI_CTT_NeedAxe")
        self:close()
        return
    end

    if not CutThatTree.hasMinigameAccess(self.playerObj) then
        CutThatTree.halo(self.playerObj, "UI_CTT_NeedAxeSkill", CutThatTree.getRequiredAxeSkillLevel())
        self:close()
        return
    end

    local quality = self:getQuality()
    local profile = CutThatTree.getStrikeProfile(quality)
    self:updateStrikeState(quality)

    local balance = self.lastBalance or CutThatTree.getControlBalance(self.playerObj, self.tree, axe, self:getDifficultyStage(), self.combo or 0, self.instability or 0)
    local impact = profile.impact
    if impact > 0 then
        impact = (impact * (balance.impactMultiplier or 1.0)) + ((self.combo or 0) * CutThatTree.Settings.comboImpactBonus)
        impact = impact * CutThatTree.getTreeDamageMultiplier()
    end

    if impact < 0 then
        self.impactBank = math.max(0.0, self.impactBank + impact)
    else
        self.impactBank = self.impactBank + impact
    end

    local hitCount = profile.baseHits or 0
    if quality == "green" and (self.combo or 0) > 0 then
        hitCount = hitCount + 1
        if self.combo >= 4 then
            hitCount = hitCount + 1
        end
    end

    while self.impactBank >= 1.0 do
        hitCount = hitCount + 1
        self.impactBank = self.impactBank - 1.0
    end

    self.lastQuality = quality
    self.pendingStrike = true
    self.pendingUntil = nowMs() + 1250
    self.lastResultText = CutThatTree.text(profile.text)
    self.lastResultQuality = quality
    self.resultUntil = nowMs() + 1800

    local visualOnly = quality == "red" and hitCount <= 0
    local actionHitCount = visualOnly and 1 or hitCount

    ISTimedActionQueue.add(CTT_ChopStrikeAction:new(
        self.playerObj,
        self.tree,
        quality,
        actionHitCount,
        profile.enduranceMultiplier,
        CutThatTree.adjustWearRoll(profile.extraWearRoll, self.playerObj, axe, quality),
        profile.noiseRadius,
        visualOnly
    ))

    self:rollTarget()
end

function CTT_ChopMinigameUI:advanceMarker()
    local current = nowMs()
    local delta = math.max(0, current - self.lastUpdateMs) / 1000
    self.lastUpdateMs = current

    if self.pendingStrike then
        self.visibleMarker = self.marker
        return
    end

    -- Keep the marker visually honest after frame drops or animation hitches.
    delta = math.min(delta, 0.035)

    self.marker = self.marker + (self.markerDirection * self.markerSpeed * delta)
    if self.marker > 1.0 then
        self.marker = 1.0
        self.markerDirection = -1
    elseif self.marker < 0.0 then
        self.marker = 0.0
        self.markerDirection = 1
    end

    self.visibleMarker = self.marker
end

function CTT_ChopMinigameUI:update()
    ISPanel.update(self)

    if self:isTreeGone() then
        self:close()
        return
    end

    if self:isTooFar() then
        CutThatTree.halo(self.playerObj, "UI_CTT_TooFar")
        self:close()
        return
    end

    self:requestTreeState()

    if self:pollKeys() then
        return
    end

    if self.pendingStrike then
        local current = nowMs()
        if current >= self.pendingUntil and not self.playerObj:hasTimedActions() then
            self.pendingStrike = false
            self.lastUpdateMs = current
        end
        return
    end
end

function CTT_ChopMinigameUI:pollKeys()
    if not isKeyDown then return false end

    local cancelDown = isKeyDown(Keyboard.KEY_ESCAPE)
    if cancelDown and not self.cancelKeyDown then
        self.cancelKeyDown = true
        self:handleKeyStart(Keyboard.KEY_ESCAPE)
        return true
    end
    self.cancelKeyDown = cancelDown

    local strikeDown = isKeyDown(Keyboard.KEY_X)
    if strikeDown and not self.strikeKeyDown then
        self.strikeKeyDown = true
        self:handleKeyStart(Keyboard.KEY_X)
        return false
    end
    self.strikeKeyDown = strikeDown

    return false
end

function CTT_ChopMinigameUI:consumeGameKey(key)
    return key == Keyboard.KEY_X or key == Keyboard.KEY_ESCAPE
end

function CTT_ChopMinigameUI:handleKeyStart(key)
    if key ~= Keyboard.KEY_X and key ~= Keyboard.KEY_ESCAPE then
        return false
    end

    local current = nowMs()
    if self.lastHandledKey == key and current - self.lastHandledKeyMs < 180 then
        return true
    end
    self.lastHandledKey = key
    self.lastHandledKeyMs = current

    if key == Keyboard.KEY_X then
        self:tryStrike()
        return true
    end
    if key == Keyboard.KEY_ESCAPE then
        self:close()
        return true
    end
    return false
end

function CTT_ChopMinigameUI:onKeyPress(key)
    if self:consumeGameKey(key) and GameKeyboard then
        GameKeyboard.eatKeyPress(key)
    end
end

function CTT_ChopMinigameUI:isKeyConsumed(key)
    return self:consumeGameKey(key)
end

function CTT_ChopMinigameUI.drawTextCentered(ui, text, x, y, width, r, g, b, a, font)
    local textW = getTextManager():MeasureStringX(font, text)
    ui:drawText(text, x + ((width - textW) / 2), y, r, g, b, a, font)
end

function CTT_ChopMinigameUI:drawTextShadow(text, x, y, r, g, b, a, font)
    self:drawText(text, x + 1, y + 1, 0, 0, 0, a * 0.65, font)
    self:drawText(text, x, y, r, g, b, a, font)
end

function CTT_ChopMinigameUI:drawTextCenteredShadow(text, x, y, width, r, g, b, a, font)
    local textW = getTextManager():MeasureStringX(font, text)
    self:drawTextShadow(text, x + ((width - textW) / 2), y, r, g, b, a, font)
end

function CTT_ChopMinigameUI:drawTrunk()
    local stage = self:getDifficultyStage()
    stage = CutThatTree.clamp(stage or 0, 0, 5)

    local texture = getMinigameTexture(trunkTextureNames[stage] or "trunk_base")
    if texture then
        self:drawTextureScaled(texture, TRUNK_X, TRUNK_Y, TRUNK_W, TRUNK_H, 1.0, 1, 1, 1)
        return
    end

    self:drawRect(TRUNK_X, TRUNK_Y, TRUNK_W, TRUNK_H, 1.0, 0.22, 0.14, 0.08)
    self:drawRectBorder(TRUNK_X, TRUNK_Y, TRUNK_W, TRUNK_H, 1.0, 0.45, 0.32, 0.20)

    for i = 0, 6 do
        local x = TRUNK_X + 12 + (i * ((TRUNK_W - 24) / 6))
        self:drawRect(x, TRUNK_Y + 8, 3, TRUNK_H - 16, 0.28, 0.52, 0.36, 0.22)
    end

    if stage <= 0 then return end

    local cutY = TRUNK_Y + (TRUNK_H * 0.58)
    local cutW = math.min(TRUNK_W - 18, 42 + (stage * 18))
    local cutX = TRUNK_X + ((TRUNK_W - cutW) / 2)
    self:drawRect(cutX, cutY, cutW, 8, 0.95, 0.74, 0.53, 0.35)
    self:drawRect(cutX + 10, cutY + 8, cutW - 20, 4, 0.95, 0.12, 0.08, 0.05)
end

function CTT_ChopMinigameUI:drawBar()
    self:drawRect(BAR_X, BAR_Y, BAR_W, BAR_H, 0.90, 0.06, 0.06, 0.06)
    self:drawRectBorder(BAR_X, BAR_Y, BAR_W, BAR_H, 1.0, 0.65, 0.65, 0.65)

    local yellowY = BAR_Y + (self.yellowMin * BAR_H)
    local yellowH = (self.yellowMax - self.yellowMin) * BAR_H
    self:drawRect(BAR_X + 3, yellowY, BAR_W - 6, yellowH, 0.95, 0.92, 0.70, 0.14)

    local greenY = BAR_Y + (self.greenMin * BAR_H)
    local greenH = (self.greenMax - self.greenMin) * BAR_H
    self:drawRect(BAR_X + 3, greenY, BAR_W - 6, greenH, 0.95, 0.24, 0.78, 0.30)

    local markerY = BAR_Y + ((self.visibleMarker or self.marker) * BAR_H)
    self:drawRect(BAR_X - 9, markerY - 3, BAR_W + 18, 6, 1.0, 0.95, 0.95, 0.95)
    self:drawRectBorder(BAR_X - 9, markerY - 3, BAR_W + 18, 6, 1.0, 0.08, 0.08, 0.08)
end

function CTT_ChopMinigameUI:drawStatus()
    local title = CutThatTree.text("UI_CTT_Title")
    self:drawTextCenteredShadow(title, 0, 12, self.width, 1, 1, 1, 1, UIFont.Medium)

    local headerY = RESULT_Y
    if self.lastResultText and self.resultUntil and nowMs() <= self.resultUntil then
        local r, g, b = 0.95, 0.95, 0.95
        if self.lastResultQuality == "green" then
            r, g, b = 0.32, 0.95, 0.46
        elseif self.lastResultQuality == "yellow" then
            r, g, b = 0.98, 0.82, 0.28
        elseif self.lastResultQuality == "red" then
            r, g, b = 0.95, 0.34, 0.26
        end
        self:drawTextShadow(self.lastResultText, STATUS_X, headerY, r, g, b, 1, UIFont.Small)
        headerY = headerY + STATUS_LINE_H
    end

    if self.combo and self.combo > 0 then
        self:drawTextShadow(CutThatTree.text("UI_CTT_Combo", self.combo + 1), STATUS_X, headerY, 0.30, 0.95, 0.46, 1, UIFont.Small)
    end

    local statusY = STATUS_Y
    local health = self.syncedTreeHealth or CutThatTree.getTreeHealth(self.tree)
    local maxHealth = self.syncedTreeMaxHealth or CutThatTree.getTreeMaxHealth(self.tree) or self.initialTreeHealth
    if health and maxHealth then
        self:drawTextShadow(CutThatTree.text("UI_CTT_HP", math.floor(health), math.floor(maxHealth)), STATUS_X, statusY, 0.9, 0.9, 0.9, 1, UIFont.Small)
    elseif health then
        self:drawTextShadow(CutThatTree.text("UI_CTT_HPNoMax", math.floor(health)), STATUS_X, statusY, 0.9, 0.9, 0.9, 1, UIFont.Small)
    end

    local damage = math.floor(self:getDamageFraction() * 100)
    self:drawTextShadow(CutThatTree.text("UI_CTT_Damage", damage), STATUS_X, statusY + STATUS_LINE_H, 0.9, 0.9, 0.9, 1, UIFont.Small)

    local difficulty = math.floor(((self.lastBalance and self.lastBalance.treeDifficulty) or CutThatTree.getTreeDifficulty(self.tree)) * 100)
    self:drawTextShadow(CutThatTree.text("UI_CTT_Difficulty", difficulty), STATUS_X, statusY + (STATUS_LINE_H * 2), 0.8, 0.8, 0.8, 1, UIFont.Small)

    local bank = math.floor(self.impactBank * 100)
    self:drawTextShadow(CutThatTree.text("UI_CTT_ImpactBank", bank), STATUS_X, statusY + (STATUS_LINE_H * 3), 0.75, 0.75, 0.75, 1, UIFont.Small)

    local endurance = math.floor((self.syncedEndurance or CutThatTree.getEndurance(self.playerObj)) * 100)
    self:drawTextShadow(CutThatTree.text("UI_CTT_Endurance", endurance), STATUS_X, statusY + (STATUS_LINE_H * 4), 0.68, 0.82, 0.95, 1, UIFont.Small)

    local axe = self.playerObj and self.playerObj:getPrimaryHandItem()
    local sharpness = math.floor((self.syncedToolSharpness or CutThatTree.getToolSharpness(axe)) * 100)
    self:drawTextShadow(CutThatTree.text("UI_CTT_Sharpness", sharpness), STATUS_X, statusY + (STATUS_LINE_H * 5), 0.92, 0.78, 0.55, 1, UIFont.Small)

end

function CTT_ChopMinigameUI:prerender()
    self:advanceMarker()
    ISPanel.prerender(self)
    local bg = getMinigameTexture("minigame_bg")
    if bg then
        self:drawTextureScaled(bg, 0, 0, self.width, self.height, 1.0, 1, 1, 1)
        self:drawRect(0, 0, self.width, self.height, 0.18, 0, 0, 0)
    else
        self:drawRect(0, 0, self.width, self.height, 0.88, 0.03, 0.03, 0.03)
    end
    self:drawRectBorder(0, 0, self.width, self.height, 1.0, 0.65, 0.65, 0.65)
end

function CTT_ChopMinigameUI:render()
    ISPanel.render(self)
    self:drawTrunk()
    self:drawBar()
    self:drawStatus()
end

function CTT_ChopMinigameUI:new(x, y, width, height, playerObj, tree)
    local o = ISPanel.new(self, x, y, width, height)
    o.playerObj = playerObj
    o.tree = tree
    o.moveWithMouse = true
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0 }
    o.borderColor = { r = 0, g = 0, b = 0, a = 0 }
    o.marker = ZombRand(1000) / 1000
    o.markerDirection = ZombRand(2) == 0 and 1 or -1
    o.markerSpeed = CutThatTree.Settings.markerBaseSpeed
    o.impactBank = 0.0
    o.greenStreak = 0
    o.combo = 0
    o.instability = 0.0
    o.initialTreeHealth = CutThatTree.getTreeHealth(tree)
    o.visualStage = CutThatTree.getDamageStage(tree)
    o.lastBalance = nil
    o.lastUpdateMs = nowMs()
    o.pendingStrike = false
    o.pendingUntil = 0
    o.lastHandledKey = nil
    o.lastHandledKeyMs = 0
    o.strikeKeyDown = false
    o.cancelKeyDown = false
    o.lastResultText = nil
    o.lastResultQuality = nil
    o.resultUntil = 0
    o.syncedTreeValid = nil
    o.syncedTreeHealth = nil
    o.syncedTreeMaxHealth = nil
    o.syncedToolSharpness = nil
    o.syncedToolCondition = nil
    o.syncedEndurance = nil
    o.lastTreeStateMs = 0
    o.nextTreeStateRequest = 0
    return o
end

local function onServerCommand(module, command, args)
    if module ~= MODULE then return end
    if command ~= "TreeState" then return end

    if CTT_ChopMinigameUI.instance then
        CTT_ChopMinigameUI.instance:onTreeState(args)
    end
end

local function onKeyStartPressed(key)
    if CTT_ChopMinigameUI.instance and CTT_ChopMinigameUI.instance:handleKeyStart(key) and GameKeyboard then
        GameKeyboard.eatKeyPress(key)
    end
end

local function onKeyPressed(key)
    if CTT_ChopMinigameUI.instance and CTT_ChopMinigameUI.instance:consumeGameKey(key) and GameKeyboard then
        GameKeyboard.eatKeyPress(key)
    end
end

if Events.OnServerCommand then
    Events.OnServerCommand.Add(onServerCommand)
end
Events.OnKeyStartPressed.Add(onKeyStartPressed)
Events.OnKeyPressed.Add(onKeyPressed)
