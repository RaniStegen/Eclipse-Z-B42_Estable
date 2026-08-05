require "EBFCopyPaste/EBFCopyPaste_Shared"
require "EBFCopyPaste/EBFCopyPaste_UI"

local UI_BORDER_SPACING = 10
local adminPanelHookRetryCount = 0
local maxAdminPanelHookRetries = 600

local function loadAdminPanelUI()
    if ISAdminPanelUI then
        return true
    end
    local ok = pcall(require, "ISUI/AdminPanel/ISAdminPanelUI")
    return ok and ISAdminPanelUI ~= nil
end

local function openCopyPastePanel()
    if not EBFCopyPasteUI or not EBFCopyPasteUI.openPanel then
        pcall(require, "EBFCopyPaste/EBFCopyPaste_UI")
    end
    if EBFCopyPasteUI and EBFCopyPasteUI.openPanel then
        return EBFCopyPasteUI.openPanel(getPlayer())
    end
    print("EBFCopyPaste: la interfaz no está disponible.")
    return nil
end

local function getButtonHeight(panel)
    if panel.seeSafehousesBtn then
        return panel.seeSafehousesBtn:getHeight()
    end
    return getTextManager():getFontHeight(UIFont.Small) + 6
end

local function relayoutCancel(panel)
    if not panel.cancel then
        return
    end

    local bottom = 0
    for _, child in pairs(panel:getChildren()) do
        if child ~= panel.cancel then
            bottom = math.max(bottom, child:getBottom())
        end
    end
    panel.cancel:setY(bottom + UI_BORDER_SPACING)
    panel:setHeight(panel.cancel:getBottom() + UI_BORDER_SPACING + 1)
end

local function installSafeCopyPasteButton(panel)
    if panel.safeCopyPasteBtn or not panel.seeSafehousesBtn then
        return
    end

    local btn = ISButton:new(panel.seeSafehousesBtn:getX(), panel.seeSafehousesBtn:getBottom() + UI_BORDER_SPACING, panel.seeSafehousesBtn:getWidth(), getButtonHeight(panel), "Copiar y pegar zonas", panel, ISAdminPanelUI.onOptionMouseDown)
    btn.internal = "SAFE_COPY_PASTE"
    btn:initialise()
    btn:instantiate()
    btn.borderColor = panel.buttonBorderColor
    panel:addChild(btn)
    panel.safeCopyPasteBtn = btn

    local shift = btn:getHeight() + UI_BORDER_SPACING
    local columnX = panel.seeSafehousesBtn:getX()
    local minY = panel.seeSafehousesBtn:getBottom()

    for _, child in pairs(panel:getChildren()) do
        if child ~= btn and child ~= panel.cancel and child:getX() == columnX and child:getY() > minY then
            child:setY(child:getY() + shift)
        end
    end

    relayoutCancel(panel)
end

function EBFCopyPaste.installAdminPanelHook()
    if not loadAdminPanelUI() or not ISButton then
        return false
    end

    EBFCopyPaste.AdminPanelHooks = EBFCopyPaste.AdminPanelHooks or {}
    if EBFCopyPaste.AdminPanelHooks.create == ISAdminPanelUI.create
            and EBFCopyPaste.AdminPanelHooks.updateButtons == ISAdminPanelUI.updateButtons
            and EBFCopyPaste.AdminPanelHooks.onOptionMouseDown == ISAdminPanelUI.onOptionMouseDown then
        return true
    end

    local originalCreate = ISAdminPanelUI.create
    local originalUpdateButtons = ISAdminPanelUI.updateButtons
    local originalOnOptionMouseDown = ISAdminPanelUI.onOptionMouseDown

    ISAdminPanelUI.create = function(self, ...)
        if originalCreate then
            originalCreate(self, ...)
        end
        installSafeCopyPasteButton(self)
        if self.updateButtons then
            self:updateButtons()
        end
    end

    ISAdminPanelUI.updateButtons = function(self, ...)
        if originalUpdateButtons then
            originalUpdateButtons(self, ...)
        end
        if self.safeCopyPasteBtn then
            self.safeCopyPasteBtn.enable = EBFCopyPaste.hasCopyPasteAccess(getPlayer())
        end
    end

    ISAdminPanelUI.onOptionMouseDown = function(self, button, x, y)
        if button and button.internal == "SAFE_COPY_PASTE" then
            openCopyPastePanel()
            if self.updateButtons then
                self:updateButtons()
            end
            return
        end

        if originalOnOptionMouseDown then
            originalOnOptionMouseDown(self, button, x, y)
        end
    end

    EBFCopyPaste.AdminPanelHooks.create = ISAdminPanelUI.create
    EBFCopyPaste.AdminPanelHooks.updateButtons = ISAdminPanelUI.updateButtons
    EBFCopyPaste.AdminPanelHooks.onOptionMouseDown = ISAdminPanelUI.onOptionMouseDown
    return true
end

local function ensureAdminPanelHook()
    if EBFCopyPaste.installAdminPanelHook() then
        if Events.OnTick then
            Events.OnTick.Remove(ensureAdminPanelHook)
        end
        return
    end

    adminPanelHookRetryCount = adminPanelHookRetryCount + 1
    if adminPanelHookRetryCount >= maxAdminPanelHookRetries and Events.OnTick then
        Events.OnTick.Remove(ensureAdminPanelHook)
    end
end

ensureAdminPanelHook()

if Events.OnGameBoot then
    Events.OnGameBoot.Add(ensureAdminPanelHook)
end
if Events.OnGameStart then
    Events.OnGameStart.Add(ensureAdminPanelHook)
end
if Events.OnCreatePlayer then
    Events.OnCreatePlayer.Add(ensureAdminPanelHook)
end
if Events.OnTick and (not ISAdminPanelUI or not EBFCopyPaste.AdminPanelHooks or EBFCopyPaste.AdminPanelHooks.create ~= ISAdminPanelUI.create) then
    Events.OnTick.Add(ensureAdminPanelHook)
end
