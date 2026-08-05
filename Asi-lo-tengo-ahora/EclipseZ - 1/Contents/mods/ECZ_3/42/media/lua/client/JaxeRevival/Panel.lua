require("JaxeRevival")

JaxeRevival.Panel = ISPanelJoypad:derive("JaxeRevival.Panel")
JaxeRevival.Panel.instance = {}

local FADE_SECONDS = 1

local PADDING_MEDIUM = 8
local PADDING_SMALL = 2

local BUTTON_WIDTH = 250
local BUTTON_HEIGHT = 40
local BUTTON_GROUP_OFFSET = (BUTTON_HEIGHT * 4) + (PADDING_MEDIUM * 3) + 85

local DIALOG_WIDTH = 380
local DIALOG_HEIGHT = 120

local TEXT_Y_OFFSET = 150

local FONT_LARGE_HEIGHT = getTextManager():getFontHeight(UIFont.Large)

local function dialogConfirm(self, text, onClick)
	local playerNum = self.player:getPlayerNum()

	local screenLeft, screenTop, screenWidth, screenHeight = getPlayerScreenLeft(playerNum), getPlayerScreenTop(playerNum), getPlayerScreenWidth(playerNum), getPlayerScreenHeight(playerNum)

	local x = screenLeft + (screenWidth - DIALOG_WIDTH) / 2
	local y = screenTop + (screenHeight - DIALOG_HEIGHT) / 2

	local modal = ISModalDialog:new(x, y, DIALOG_WIDTH, DIALOG_HEIGHT, text, true, self, onClick, playerNum)

	modal:initialise()
	modal:addToUIManager()
	modal:bringToTop()

	local joypadPlayer = JoypadState.players[playerNum + 1]
	if joypadPlayer then
		modal.prevFocus = joypadPlayer.focus
		setJoypadFocus(playerNum, modal)
	end

	return modal
end

local addButton = function(self, y, title, onClick)
	local button = ISButton:new(0, y, BUTTON_WIDTH, BUTTON_HEIGHT, title, self, onClick)
	button.anchorLeft = false
	button.anchorTop = false
	button.backgroundColor.a = 0.8
	button.borderColor.a = 0.3

	self:addChild(button)
	return button
end

local drawCenterText = function(self, text, y)
	local width = getTextManager():MeasureStringX(UIFont.Large, text) + (PADDING_MEDIUM * 2)

	local x = self.screenX + ((self.screenWidth - width) / 2)

	self:drawRect(x - self:getAbsoluteX(), y - self:getAbsoluteY(), width, FONT_LARGE_HEIGHT, 0.5, 0, 0, 0)
	getTextManager():DrawString(UIFont.Large, x + PADDING_MEDIUM, y, text, 1, 1, 1, 1)

	return y + FONT_LARGE_HEIGHT
end

JaxeRevival.Panel.createChildren = function(self)
	self:setWidth(BUTTON_WIDTH)
	self:setHeight(BUTTON_GROUP_OFFSET)
	self:setX(self.screenX + (self.screenWidth - BUTTON_WIDTH) / 2)
	self:setY(self.screenY + (self.screenHeight - BUTTON_GROUP_OFFSET))

	local buttonY = 0

	self.buttonToggleFastForward = addButton(self, buttonY, "", self.onToggleFastForward)
	buttonY = buttonY + BUTTON_HEIGHT + PADDING_MEDIUM

	self.buttonGiveUp = addButton(self, buttonY, getText("UI_JaxeRevival_GiveUp"), self.onGiveUp)
	buttonY = buttonY + BUTTON_HEIGHT + PADDING_MEDIUM

	self.buttonQuitMenu = addButton(self, buttonY, getText("IGUI_PostDeath_Exit"), self.onQuitMenu)
	buttonY = buttonY + BUTTON_HEIGHT + PADDING_MEDIUM

	self.buttonQuitDesktop = addButton(self, buttonY, getText("IGUI_PostDeath_Quit"), self.onQuitDesktop)
end

JaxeRevival.Panel.prerender = function(self)
	local playerNum = self.player:getPlayerNum()
	local screenWidth = getPlayerScreenWidth(playerNum)
	local sceenHeight = getPlayerScreenHeight(playerNum)

	if self.screenWidth ~= screenWidth or self.screenHeight ~= sceenHeight then
		self.screenX = getPlayerScreenLeft(playerNum)
		self.screenY = getPlayerScreenTop(playerNum)
		self.screenWidth = screenWidth
		self.screenHeight = sceenHeight

		self:setX(self.screenX + (self.screenWidth - self.width) / 2)
		self:setY(self.screenY + (self.screenHeight - self.height))
	end

	if not self.fadeComplete then self.fadeComplete = getTimestamp() >= self.fadeStart + FADE_SECONDS end

	self.lines = {}
	table.insert(self.lines, getText("UI_JaxeRevival_IsIncapacitated"))

	local timeRemaining = JaxeRevival.State.getTimeRemaining(self.player)
	if timeRemaining then
		local timeRemainingText = JaxeRevival.State.getTimeRemainingText(self.player, timeRemaining)
		if timeRemainingText then table.insert(self.lines, timeRemainingText) end

		local fastForwarding = JaxeRevival.State.isFastForwarding(self.player)
		self.buttonToggleFastForward:setTitle(getText(fastForwarding and "UI_JaxeRevival_StayAwake" or "UI_JaxeRevival_Sleep"))
		self.buttonToggleFastForward:setVisible(self.fadeComplete and JaxeRevival.State.isSleepAllowed())
	end

	self.buttonGiveUp:setVisible(self.fadeComplete)
	self.buttonQuitDesktop:setVisible(self.fadeComplete)
	self.buttonQuitMenu:setVisible(self.fadeComplete)

	ISPanelJoypad.prerender(self)

	self:setStencilRect(self.screenX - self.x, self.screenY - self.y, self.screenWidth, self.screenHeight)
end

JaxeRevival.Panel.render = function(self)
	ISPanelJoypad.render(self)

	if not (self.dialogQuitConfirm and self.dialogQuitConfirm:isReallyVisible()) and not (self.dialogGiveUpConfirm and self.dialogGiveUpConfirm:isReallyVisible()) then
		if self.fadeComplete then
			local y = self.screenY + self.textY
			for _, line in ipairs(self.lines) do y = drawCenterText(self, line, y) + PADDING_SMALL end

			drawCenterText(self, self.deathDetails, y)
		end
	end

	self:clearStencilRect()

	if self.player:isDead() or not JaxeRevival.Incapacitation.isActive(self.player) then JaxeRevival.Panel.show(self.player, false) end
end

JaxeRevival.Panel.onToggleFastForward = function(self)
	if MainScreen.instance:isReallyVisible() then return end

	JaxeRevival.State.toggleFastForward(self.player)
end

JaxeRevival.Panel.onGiveUp = function(self)
	if MainScreen.instance:isReallyVisible() then return end

	if self.dialogGiveUpConfirm then self.dialogGiveUpConfirm:destroy() end
	self.dialogGiveUpConfirm = dialogConfirm(self, getText("UI_JaxeRevival_GiveUpConfirm"), self.onGiveUpConfirm)
end

JaxeRevival.Panel.onGiveUpConfirm = function(self, button)
	self.dialogGiveUpConfirm = nil

	if button.internal == "YES" then
		if MainScreen.instance:isReallyVisible() then return end

		JaxeRevival.Side.reportGiveUp()
	end
end

JaxeRevival.Panel.onQuitMenu = function(self)
	if MainScreen.instance:isReallyVisible() then return end

	self:removeFromUIManager()
	getCore():exitToMenu()
end

JaxeRevival.Panel.onQuitDesktop = function(self)
	if MainScreen.instance:isReallyVisible() then return end

	if self.dialogQuitConfirm then self.dialogQuitConfirm:destroy() end
	self.dialogQuitConfirm = dialogConfirm(self, getText("IGUI_ConfirmQuitToDesktop"), self.onQuitDesktopConfirm)
end

JaxeRevival.Panel.onQuitDesktopConfirm = function(self, button)
	self.dialogConfirmQuit = nil

	if button.internal == "YES" then
		setGameSpeed(1)
		pauseSoundAndMusic()
		setShowPausedMessage(true)
		getCore():quitToDesktop()
	end
end

JaxeRevival.Panel.onMouseDown = function(_, _, _) return false end

JaxeRevival.Panel.onMouseUp = function(_, _, _) return false end

JaxeRevival.Panel.onMouseMove = function(_, _, _) return false end

JaxeRevival.Panel.onMouseWheel = function(_, _) return false end

JaxeRevival.Panel.onGainJoypadFocus = function(self, _)
	self:setISButtonForA(self.buttonToggleFastForward)
	self:setISButtonForB(self.buttonQuitMenu)
	self:setISButtonForY(self.buttonQuitDesktop)
	self:setISButtonForX(self.buttonGiveUp)
end

JaxeRevival.Panel.onJoypadBeforeDeactivate = function(self, _)
	self.buttonToggleFastForward:clearJoypadButton()
	self.buttonQuitMenu:clearJoypadButton()
	self.buttonQuitDesktop:clearJoypadButton()
	self.buttonGiveUp:clearJoypadButton()
end

JaxeRevival.Panel.onJoypadReactivate = function(self, _)
	self:setISButtonForA(self.buttonToggleFastForward)
	self:setISButtonForB(self.buttonQuitMenu)
	self:setISButtonForY(self.buttonQuitDesktop)
	self:setISButtonForX(self.buttonGiveUp)
end

JaxeRevival.Panel.new = function(self, player)
	local playerNum = player:getPlayerNum()

	local x = getPlayerScreenLeft(playerNum)
	local y = getPlayerScreenTop(playerNum)
	local width = getPlayerScreenWidth(playerNum)
	local height = getPlayerScreenHeight(playerNum)
	local instance = ISPanelJoypad:new(x, y, width, height)

	setmetatable(instance, self)
	self.__index = self

	instance:setAnchorLeft(false)
	instance:setAnchorTop(false)
	instance.background = false
	instance.screenX = x
	instance.screenY = y
	instance.screenWidth = width
	instance.screenHeight = height
	instance.player = player
	instance.textY = (height / 2) + TEXT_Y_OFFSET

	instance:instantiate()
	instance:setAlwaysOnTop(true)
	instance.javaObject:setIgnoreLossControl(true)
	JaxeRevival.Panel.instance[playerNum] = instance

	return instance
end

JaxeRevival.Panel.show = function(player, value)
	local playerNum = player:getPlayerNum()

	if value then
		if JaxeRevival.Panel.instance[playerNum] then
			JaxeRevival.Panel.instance[playerNum]:setVisible(true)
			return
		end

		local panel = JaxeRevival.Panel:new(player)

		panel.fadeStart = getTimestamp()
		panel.deathDetails = getGameTime():getDeathString(player)
		local zombiesKilled = getGameTime():getZombieKilledText(player)
		if zombiesKilled then panel.deathDetails = panel.deathDetails .. " " .. zombiesKilled end

		panel:addToUIManager()

		if MainScreen.instance:isVisible() then
			table.insert(ISUIHandler.visibleUI, panel.javaObject:toString())
			panel:setVisible(false)
			if JoypadState.players[playerNum + 1] and JoypadState.saveFocus then JoypadState.saveFocus[playerNum + 1] = panel end
		else
			if JoypadState.players[playerNum + 1] then JoypadState.players[playerNum + 1].focus = panel end
		end
	else
		if not JaxeRevival.Panel.instance[playerNum] then return end

		JaxeRevival.Panel.instance[playerNum]:removeFromUIManager()
		JaxeRevival.Panel.instance[playerNum] = nil
	end
end
