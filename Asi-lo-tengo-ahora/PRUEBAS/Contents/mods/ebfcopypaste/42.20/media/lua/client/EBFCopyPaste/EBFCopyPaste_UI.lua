require "EBFCopyPaste/EBFCopyPaste_Shared"
require "EBFCopyPaste/EBFCopyPaste_LightSwitchGuard"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6
local SAFEHOUSE_COPY_MIN_TELEPORT_WAIT_MS = 5000
local SAFEHOUSE_BACKUP_INDEX_FILE = "EBFCopyPaste_SafeHouseBackup_Index.txt"
local uiClassesReady = false
local trimText
local makeDefaultSafehouseBackupName
local sanitizeBackupFilePart
local makeSafehouseBackupFileName
local makeSavedAreaExportFileName

EBFCopyPastePasteCursor = EBFCopyPastePasteCursor or {}
EBFCopyPasteUI = EBFCopyPasteUI or {}
EBFCopyPasteUI.instance = EBFCopyPasteUI.instance or nil
EBFCopyPasteSaveDialog = EBFCopyPasteSaveDialog or {}
EBFCopyPasteSaveDialog.instance = EBFCopyPasteSaveDialog.instance or nil
EBFCopyPasteSavedAreaDialog = EBFCopyPasteSavedAreaDialog or {}
EBFCopyPasteSavedAreaDialog.instance = EBFCopyPasteSavedAreaDialog.instance or nil
EBFCopyPasteDeleteConfirmDialog = EBFCopyPasteDeleteConfirmDialog or {}
EBFCopyPasteDeleteConfirmDialog.instance = EBFCopyPasteDeleteConfirmDialog.instance or nil
EBFCopyPasteSafehouseLoadDialog = EBFCopyPasteSafehouseLoadDialog or {}
EBFCopyPasteSafehouseLoadDialog.instance = EBFCopyPasteSafehouseLoadDialog.instance or nil
EBFCopyPasteBackupSafehouseDialog = EBFCopyPasteBackupSafehouseDialog or {}
EBFCopyPasteBackupSafehouseDialog.instance = EBFCopyPasteBackupSafehouseDialog.instance or nil
EBFCopyPasteBackupMenuDialog = EBFCopyPasteBackupMenuDialog or {}
EBFCopyPasteBackupMenuDialog.instance = EBFCopyPasteBackupMenuDialog.instance or nil
EBFCopyPasteExportBackupDialog = EBFCopyPasteExportBackupDialog or {}
EBFCopyPasteExportBackupDialog.instance = EBFCopyPasteExportBackupDialog.instance or nil
EBFCopyPasteImportFileDialog = EBFCopyPasteImportFileDialog or {}
EBFCopyPasteImportFileDialog.instance = EBFCopyPasteImportFileDialog.instance or nil
EBFCopyPasteImportBackupDialog = EBFCopyPasteImportBackupDialog or {}
EBFCopyPasteImportBackupDialog.instance = EBFCopyPasteImportBackupDialog.instance or nil
EBFCopyPasteImportBackupConfirmDialog = EBFCopyPasteImportBackupConfirmDialog or {}
EBFCopyPasteImportBackupConfirmDialog.instance = EBFCopyPasteImportBackupConfirmDialog.instance or nil

local function tryRequire(module)
    pcall(require, module)
end

local function loadUiDependencies()
    if not ISPanel then
        tryRequire("ISUI/ISPanel")
    end
    if not ISButton then
        tryRequire("ISUI/ISButton")
    end
    if not ISTextEntryBox then
        tryRequire("ISUI/ISTextEntryBox")
    end
    if not ISComboBox then
        tryRequire("ISUI/ISComboBox")
    end
    if not ISBuildingObject then
        tryRequire("BuildingObjects/ISBuildingObject")
    end

    return ISPanel and ISButton and ISTextEntryBox and ISComboBox and ISBuildingObject
end

function EBFCopyPaste.ensureUIClasses()
    if uiClassesReady then
        return true
    end
    if not loadUiDependencies() then
        return false
    end

    local cursorMethods = EBFCopyPastePasteCursor
    EBFCopyPastePasteCursor = ISBuildingObject:derive("EBFCopyPastePasteCursor")
    for key, value in pairs(cursorMethods) do
        EBFCopyPastePasteCursor[key] = value
    end

    local saveDialogMethods = EBFCopyPasteSaveDialog
    EBFCopyPasteSaveDialog = ISPanel:derive("EBFCopyPasteSaveDialog")
    for key, value in pairs(saveDialogMethods) do
        EBFCopyPasteSaveDialog[key] = value
    end
    EBFCopyPasteSaveDialog.instance = saveDialogMethods.instance

    local savedAreaDialogMethods = EBFCopyPasteSavedAreaDialog
    EBFCopyPasteSavedAreaDialog = ISPanel:derive("EBFCopyPasteSavedAreaDialog")
    for key, value in pairs(savedAreaDialogMethods) do
        EBFCopyPasteSavedAreaDialog[key] = value
    end
    EBFCopyPasteSavedAreaDialog.instance = savedAreaDialogMethods.instance

    local deleteConfirmDialogMethods = EBFCopyPasteDeleteConfirmDialog
    EBFCopyPasteDeleteConfirmDialog = ISPanel:derive("EBFCopyPasteDeleteConfirmDialog")
    for key, value in pairs(deleteConfirmDialogMethods) do
        EBFCopyPasteDeleteConfirmDialog[key] = value
    end
    EBFCopyPasteDeleteConfirmDialog.instance = deleteConfirmDialogMethods.instance

    local safehouseLoadDialogMethods = EBFCopyPasteSafehouseLoadDialog
    EBFCopyPasteSafehouseLoadDialog = ISPanel:derive("EBFCopyPasteSafehouseLoadDialog")
    for key, value in pairs(safehouseLoadDialogMethods) do
        EBFCopyPasteSafehouseLoadDialog[key] = value
    end
    EBFCopyPasteSafehouseLoadDialog.instance = safehouseLoadDialogMethods.instance

    local backupSafehouseDialogMethods = EBFCopyPasteBackupSafehouseDialog
    EBFCopyPasteBackupSafehouseDialog = ISPanel:derive("EBFCopyPasteBackupSafehouseDialog")
    for key, value in pairs(backupSafehouseDialogMethods) do
        EBFCopyPasteBackupSafehouseDialog[key] = value
    end
    EBFCopyPasteBackupSafehouseDialog.instance = backupSafehouseDialogMethods.instance

    local backupMenuDialogMethods = EBFCopyPasteBackupMenuDialog
    EBFCopyPasteBackupMenuDialog = ISPanel:derive("EBFCopyPasteBackupMenuDialog")
    for key, value in pairs(backupMenuDialogMethods) do
        EBFCopyPasteBackupMenuDialog[key] = value
    end
    EBFCopyPasteBackupMenuDialog.instance = backupMenuDialogMethods.instance

    local exportBackupDialogMethods = EBFCopyPasteExportBackupDialog
    EBFCopyPasteExportBackupDialog = ISPanel:derive("EBFCopyPasteExportBackupDialog")
    for key, value in pairs(exportBackupDialogMethods) do
        EBFCopyPasteExportBackupDialog[key] = value
    end
    EBFCopyPasteExportBackupDialog.instance = exportBackupDialogMethods.instance

    local importFileDialogMethods = EBFCopyPasteImportFileDialog
    EBFCopyPasteImportFileDialog = ISPanel:derive("EBFCopyPasteImportFileDialog")
    for key, value in pairs(importFileDialogMethods) do
        EBFCopyPasteImportFileDialog[key] = value
    end
    EBFCopyPasteImportFileDialog.instance = importFileDialogMethods.instance

    local importBackupDialogMethods = EBFCopyPasteImportBackupDialog
    EBFCopyPasteImportBackupDialog = ISPanel:derive("EBFCopyPasteImportBackupDialog")
    for key, value in pairs(importBackupDialogMethods) do
        EBFCopyPasteImportBackupDialog[key] = value
    end
    EBFCopyPasteImportBackupDialog.instance = importBackupDialogMethods.instance

    local importBackupConfirmDialogMethods = EBFCopyPasteImportBackupConfirmDialog
    EBFCopyPasteImportBackupConfirmDialog = ISPanel:derive("EBFCopyPasteImportBackupConfirmDialog")
    for key, value in pairs(importBackupConfirmDialogMethods) do
        EBFCopyPasteImportBackupConfirmDialog[key] = value
    end
    EBFCopyPasteImportBackupConfirmDialog.instance = importBackupConfirmDialogMethods.instance

    local uiMethods = EBFCopyPasteUI
    EBFCopyPasteUI = ISPanel:derive("EBFCopyPasteUI")
    for key, value in pairs(uiMethods) do
        EBFCopyPasteUI[key] = value
    end
    EBFCopyPasteUI.instance = uiMethods.instance

    uiClassesReady = true
    return true
end

local function getSafehouseList()
    if not SafeHouse or not SafeHouse.getSafehouseList then
        return nil
    end

    local ok, list = pcall(SafeHouse.getSafehouseList)
    if ok then
        return list
    end
    return nil
end

local function getSafehouseCount()
    local list = getSafehouseList()
    if not list then
        return 0
    end

    local ok, count = pcall(function()
        return list:size()
    end)
    if ok and count then
        return count
    end
    return 0
end

local function safehouseCall(safe, methodName, fallback)
    if not safe then
        return fallback
    end

    local ok, result = pcall(function()
        return safe[methodName](safe)
    end)
    if ok and result ~= nil then
        return result
    end
    return fallback
end

local function copySafehouseStringList(list)
    local copied = {}
    if not list then
        return copied
    end

    local ok, size = pcall(function()
        return list:size()
    end)
    if not ok or not size then
        return copied
    end

    for i = 0, size - 1 do
        local itemOk, value = pcall(function()
            return list:get(i)
        end)
        if itemOk and value ~= nil then
            table.insert(copied, tostring(value))
        end
    end
    return copied
end

local function makeSafehouseData(safe)
    if not safe then
        return nil
    end

    local x = math.floor(tonumber(safehouseCall(safe, "getX", 0)) or 0)
    local y = math.floor(tonumber(safehouseCall(safe, "getY", 0)) or 0)
    local w = math.max(1, math.floor(tonumber(safehouseCall(safe, "getW", 1)) or 1))
    local h = math.max(1, math.floor(tonumber(safehouseCall(safe, "getH", 1)) or 1))
    return {
        title = tostring(safehouseCall(safe, "getTitle", "Casa segura") or "Casa segura"),
        owner = tostring(safehouseCall(safe, "getOwner", "") or ""),
        members = copySafehouseStringList(safehouseCall(safe, "getPlayers", nil)),
        respawnMembers = copySafehouseStringList(safehouseCall(safe, "getPlayersRespawn", nil)),
        location = tostring(safehouseCall(safe, "getLocation", "") or ""),
        lastVisited = tonumber(safehouseCall(safe, "getLastVisited", 0)) or 0,
        datetimeCreated = tonumber(safehouseCall(safe, "getDatetimeCreated", 0)) or 0,
        hitPoints = tonumber(safehouseCall(safe, "getHitPoints", 0)) or 0,
        onlineID = tonumber(safehouseCall(safe, "getOnlineID", -1)) or -1,
        x = x,
        y = y,
        z = 0,
        w = w,
        h = h,
        x2 = x + w - 1,
        y2 = y + h - 1,
    }
end

local function safehouseDisplayName(safehouseData)
    if not safehouseData then
        return "Casa segura"
    end
    local title = tostring(safehouseData.title or "Casa segura")
    local owner = tostring(safehouseData.owner or "")
    if owner ~= "" then
        return title .. " - " .. owner
    end
    return title
end

function EBFCopyPastePasteCursor:create(x, y, z, north, sprite)
    local args = {
        x = math.floor(x),
        y = math.floor(y),
        z = math.floor(z),
    }
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.PasteArea, args)
    if getCell() then
        getCell():setDrag(nil, self.player)
    end
end

function EBFCopyPastePasteCursor:render(x, y, z, square)
    local r = 0.2
    local g = 1.0
    local b = 0.2
    local a = 0.75
    addAreaHighlightForPlayer(self.player, x, y, x + self.copyWidth, y + self.copyHeight, z, r, g, b, a)
end

function EBFCopyPastePasteCursor:new(character, copyWidth, copyHeight)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o:setSprite("carpentry_02_57")
    o:setNorthSprite("carpentry_02_57")
    o.character = character
    o.player = character:getPlayerNum()
    o.copyWidth = math.max(1, tonumber(copyWidth) or 1)
    o.copyHeight = math.max(1, tonumber(copyHeight) or 1)
    o.noNeedHammer = true
    o.skipBuildAction = true
    o.skipWalk2 = true
    o.canBeAlwaysPlaced = true
    o.isTileCursor = true
    return o
end

function EBFCopyPasteSaveDialog.open(parent)
    if EBFCopyPasteSaveDialog.instance then
        EBFCopyPasteSaveDialog.instance:close()
    end

    local width = 390
    local height = 150
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteSaveDialog:new(x, y, width, height, parent)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteSaveDialog:initialise()
    ISPanel.initialise(self)

    local btnWid = 110
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT - 1

    self.closeButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Cerrar", self, EBFCopyPasteSaveDialog.onClick)
    self.closeButton.internal = "CLOSE"
    self.closeButton.anchorTop = false
    self.closeButton.anchorBottom = true
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton:enableCancelColor()
    self:addChild(self.closeButton)

    self.completeButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Finalizar", self, EBFCopyPasteSaveDialog.onClick)
    self.completeButton.internal = "COMPLETE"
    self.completeButton.anchorTop = false
    self.completeButton.anchorBottom = true
    self.completeButton:initialise()
    self.completeButton:instantiate()
    self.completeButton:enableAcceptColor()
    self:addChild(self.completeButton)

    self.nameEntry = ISTextEntryBox:new(self.defaultName or "Zona copiada", UI_BORDER_SPACING, 62, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT)
    self.nameEntry:initialise()
    self.nameEntry:instantiate()
    self:addChild(self.nameEntry)
    if self.nameEntry.focus then
        self.nameEntry:focus()
    end
end

function EBFCopyPasteSaveDialog:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre("Guardar zona copiada", self.width / 2, UI_BORDER_SPACING + 2, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Nombre de la selección", UI_BORDER_SPACING, 42, 1, 1, 1, 1, UIFont.Small)
end

function EBFCopyPasteSaveDialog:onClick(button)
    if button.internal == "COMPLETE" and self.parentUI then
        local saveName = self.nameEntry and self.nameEntry:getInternalText() or ""
        self.parentUI:saveSelection(saveName)
    end
    self:close()
end

function EBFCopyPasteSaveDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    EBFCopyPasteSaveDialog.instance = nil
end

function EBFCopyPasteSaveDialog:new(x, y, width, height, parent)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.85 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.defaultName = parent and parent.titleEntry and parent.titleEntry:getInternalText() or "Zona copiada"
    o.moveWithMouse = true
    EBFCopyPasteSaveDialog.instance = o
    return o
end

function EBFCopyPasteSavedAreaDialog.open(parent, save)
    if EBFCopyPasteSavedAreaDialog.instance then
        EBFCopyPasteSavedAreaDialog.instance:close()
    end
    if not save then
        return nil
    end

    local width = 450
    local height = 170
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteSavedAreaDialog:new(x, y, width, height, parent, save)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteSavedAreaDialog:initialise()
    ISPanel.initialise(self)

    local btnWid = 120
    local deleteWid = 130
    local gap = UI_BORDER_SPACING
    local total = btnWid + btnWid + deleteWid + gap * 2
    local x = (self.width - total) / 2
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT - 1

    self.closeButton = ISButton:new(x, bottom, btnWid, BUTTON_HGT, "Cerrar", self, EBFCopyPasteSavedAreaDialog.onClick)
    self.closeButton.internal = "CLOSE"
    self.closeButton.anchorTop = false
    self.closeButton.anchorBottom = true
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton:enableCancelColor()
    self:addChild(self.closeButton)

    self.copyButton = ISButton:new(self.closeButton:getRight() + gap, bottom, btnWid, BUTTON_HGT, "Copiar", self, EBFCopyPasteSavedAreaDialog.onClick)
    self.copyButton.internal = "COPY"
    self.copyButton.anchorTop = false
    self.copyButton.anchorBottom = true
    self.copyButton:initialise()
    self.copyButton:instantiate()
    self.copyButton:enableAcceptColor()
    self:addChild(self.copyButton)

    self.deleteButton = ISButton:new(self.copyButton:getRight() + gap, bottom, deleteWid, BUTTON_HGT, "Eliminar guardado", self, EBFCopyPasteSavedAreaDialog.onClick)
    self.deleteButton.internal = "DELETE"
    self.deleteButton.anchorTop = false
    self.deleteButton.anchorBottom = true
    self.deleteButton:initialise()
    self.deleteButton:instantiate()
    self.deleteButton:enableCancelColor()
    self:addChild(self.deleteButton)
end

function EBFCopyPasteSavedAreaDialog:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    local dialogTitle = self.saveData and self.saveData.kind == "safehouse" and "Guardado de casa segura" or "Guardado personalizado"
    self:drawTextCentre(dialogTitle, self.width / 2, UI_BORDER_SPACING + 2, 1, 1, 1, 1, UIFont.Medium)

    local save = self.saveData or {}
    local name = tostring(save.name or "Zona copiada")
    local size = tostring(save.w or "?") .. "x" .. tostring(save.h or "?")
    local count = tostring(save.count or 0)
    self:drawText(name, UI_BORDER_SPACING, 44, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Tamaño: " .. size .. "    Sprites: " .. count, UI_BORDER_SPACING, 68, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Copiar carga este guardado para poder seleccionar el destino.", UI_BORDER_SPACING, 92, 0.86, 0.86, 0.86, 1, UIFont.Small)
end

function EBFCopyPasteSavedAreaDialog:onClick(button)
    if button.internal == "COPY" and self.parentUI then
        self.parentUI:loadSavedArea(self.saveData)
        self:close()
        return
    end

    if button.internal == "DELETE" and self.parentUI then
        EBFCopyPasteDeleteConfirmDialog.open(self.parentUI, self.saveData, self)
        return
    end

    self:close()
end

function EBFCopyPasteSavedAreaDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteSavedAreaDialog.instance == self then
        EBFCopyPasteSavedAreaDialog.instance = nil
    end
end

function EBFCopyPasteSavedAreaDialog:new(x, y, width, height, parent, save)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.85 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.saveData = save
    o.moveWithMouse = true
    EBFCopyPasteSavedAreaDialog.instance = o
    return o
end

function EBFCopyPasteDeleteConfirmDialog.open(parent, save, actionDialog)
    if EBFCopyPasteDeleteConfirmDialog.instance then
        EBFCopyPasteDeleteConfirmDialog.instance:close()
    end
    if not save then
        return nil
    end

    local width = 410
    local height = 145
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteDeleteConfirmDialog:new(x, y, width, height, parent, save, actionDialog)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteDeleteConfirmDialog:initialise()
    ISPanel.initialise(self)

    local btnWid = 110
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT - 1

    self.noButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "No", self, EBFCopyPasteDeleteConfirmDialog.onClick)
    self.noButton.internal = "NO"
    self.noButton.anchorTop = false
    self.noButton.anchorBottom = true
    self.noButton:initialise()
    self.noButton:instantiate()
    self.noButton:enableCancelColor()
    self:addChild(self.noButton)

    self.yesButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Sí", self, EBFCopyPasteDeleteConfirmDialog.onClick)
    self.yesButton.internal = "YES"
    self.yesButton.anchorTop = false
    self.yesButton.anchorBottom = true
    self.yesButton:initialise()
    self.yesButton:instantiate()
    self.yesButton:enableAcceptColor()
    self:addChild(self.yesButton)
end

function EBFCopyPasteDeleteConfirmDialog:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    local dialogTitle = self.saveData and self.saveData.kind == "safehouse" and "Eliminar guardado de casa segura" or "Eliminar guardado"
    self:drawTextCentre(dialogTitle, self.width / 2, UI_BORDER_SPACING + 2, 1, 1, 1, 1, UIFont.Medium)

    local saveName = tostring((self.saveData and self.saveData.name) or "Zona copiada")
    self:drawText("¿Quieres eliminar este guardado?", UI_BORDER_SPACING, 46, 1, 1, 1, 1, UIFont.Small)
    self:drawText(saveName, UI_BORDER_SPACING, 70, 0.95, 0.95, 0.95, 1, UIFont.Small)
end

function EBFCopyPasteDeleteConfirmDialog:onClick(button)
    if button.internal == "YES" and self.parentUI then
        self.parentUI:deleteSavedArea(self.saveData)
        if self.actionDialog then
            self.actionDialog:close()
        end
    end
    self:close()
end

function EBFCopyPasteDeleteConfirmDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteDeleteConfirmDialog.instance == self then
        EBFCopyPasteDeleteConfirmDialog.instance = nil
    end
end

function EBFCopyPasteDeleteConfirmDialog:new(x, y, width, height, parent, save, actionDialog)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.saveData = save
    o.actionDialog = actionDialog
    o.moveWithMouse = true
    EBFCopyPasteDeleteConfirmDialog.instance = o
    return o
end

function EBFCopyPasteSafehouseLoadDialog.open(parent, safehouseData)
    if EBFCopyPasteSafehouseLoadDialog.instance then
        EBFCopyPasteSafehouseLoadDialog.instance:close()
    end
    if not safehouseData then
        return nil
    end

    local width = 470
    local height = 180
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteSafehouseLoadDialog:new(x, y, width, height, parent, safehouseData)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteSafehouseLoadDialog:initialise()
    ISPanel.initialise(self)

    local btnWid = 140
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT - 1
    self.cancelButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Cancelar", self, EBFCopyPasteSafehouseLoadDialog.onClick)
    self.cancelButton.internal = "CANCEL"
    self.cancelButton.anchorTop = false
    self.cancelButton.anchorBottom = true
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self.cancelButton:enableCancelColor()
    self:addChild(self.cancelButton)

    self.teleportButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Teletransportar", self, EBFCopyPasteSafehouseLoadDialog.onClick)
    self.teleportButton.internal = "TELEPORT"
    self.teleportButton.anchorTop = false
    self.teleportButton.anchorBottom = true
    self.teleportButton:initialise()
    self.teleportButton:instantiate()
    self.teleportButton:enableAcceptColor()
    self:addChild(self.teleportButton)
end

function EBFCopyPasteSafehouseLoadDialog:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre("Casa segura no cargada", self.width / 2, UI_BORDER_SPACING + 2, 1, 1, 1, 1, UIFont.Medium)

    local safehouseName = safehouseDisplayName(self.safehouseData)
    self:drawText(safehouseName, UI_BORDER_SPACING, 44, 1, 1, 1, 1, UIFont.Small)
    self:drawText("El mapa de esta casa segura no está cargado ahora.", UI_BORDER_SPACING, 68, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Teletransportarte cargará la zona. Después, pulsa Copiar.", UI_BORDER_SPACING, 92, 0.86, 0.86, 0.86, 1, UIFont.Small)
end

function EBFCopyPasteSafehouseLoadDialog:onClick(button)
    if button.internal == "TELEPORT" and self.parentUI then
        self.parentUI:teleportToSafehouseAndCopy(self.safehouseData)
        self:close()
        return
    end
    if self.parentUI then
        self.parentUI.status = "Copia de la casa segura cancelada."
    end
    self:close()
end

function EBFCopyPasteSafehouseLoadDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteSafehouseLoadDialog.instance == self then
        EBFCopyPasteSafehouseLoadDialog.instance = nil
    end
end

function EBFCopyPasteSafehouseLoadDialog:new(x, y, width, height, parent, safehouseData)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.safehouseData = safehouseData
    o.moveWithMouse = true
    EBFCopyPasteSafehouseLoadDialog.instance = o
    return o
end

function EBFCopyPasteBackupSafehouseDialog.open(parent, step, dialogMode)
    if EBFCopyPasteBackupSafehouseDialog.instance then
        EBFCopyPasteBackupSafehouseDialog.instance:close()
    end

    local width = step == "confirm" and (dialogMode == "backup" and 430 or 360) or 560
    local height = step == "confirm" and (dialogMode == "backup" and 185 or 145) or 205
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteBackupSafehouseDialog:new(x, y, width, height, parent, step, dialogMode)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteBackupSafehouseDialog:initialise()
    ISPanel.initialise(self)

    local btnWid = 135
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT - 1
    local leftText = self.step == "confirm" and "No" or "Cancelar"
    local rightText = self.step == "confirm" and "Sí" or "Continuar"
    local leftInternal = self.step == "confirm" and "NO" or "CANCEL"
    local rightInternal = self.step == "confirm" and "YES" or "CONTINUE"

    self.leftButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, leftText, self, EBFCopyPasteBackupSafehouseDialog.onClick)
    self.leftButton.internal = leftInternal
    self.leftButton.anchorTop = false
    self.leftButton.anchorBottom = true
    self.leftButton:initialise()
    self.leftButton:instantiate()
    self.leftButton:enableCancelColor()
    self:addChild(self.leftButton)

    self.rightButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, rightText, self, EBFCopyPasteBackupSafehouseDialog.onClick)
    self.rightButton.internal = rightInternal
    self.rightButton.anchorTop = false
    self.rightButton.anchorBottom = true
    self.rightButton:initialise()
    self.rightButton:instantiate()
    self.rightButton:enableAcceptColor()
    self:addChild(self.rightButton)

    if self.step == "confirm" and self.dialogMode == "backup" then
        self.nameEntry = ISTextEntryBox:new(self.backupName or makeDefaultSafehouseBackupName(), UI_BORDER_SPACING, 88, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT)
        self.nameEntry:initialise()
        self.nameEntry:instantiate()
        self:addChild(self.nameEntry)
        if self.nameEntry.focus then
            self.nameEntry:focus()
        end
    end
end

function EBFCopyPasteBackupSafehouseDialog:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    if self.step == "confirm" then
        self:drawTextCentre("¿Continuar?", self.width / 2, UI_BORDER_SPACING + 8, 1, 1, 1, 1, UIFont.Medium)
        if self.dialogMode == "backup" then
            self:drawTextCentre("Nombre de la copia de seguridad que se creará", self.width / 2, 54, 1, 1, 1, 1, UIFont.Small)
            self:drawText("Este nombre se utilizará para elegir el archivo durante la exportación.", UI_BORDER_SPACING, 120, 0.86, 0.86, 0.86, 1, UIFont.Small)
        else
            self:drawTextCentre("¿Quieres empezar ahora?", self.width / 2, 58, 1, 1, 1, 1, UIFont.Small)
        end
        return
    end

    self:drawTextCentre("Atencao", self.width / 2, UI_BORDER_SPACING + 2, 1, 1, 1, 1, UIFont.Medium)
    if self.dialogMode == "restore" then
        local restoreLabel = self.parentUI and self.parentUI.pendingSafehouseRestoreLabel or "copia de seguridad seleccionada"
        local restoreCount = self.parentUI and self.parentUI.pendingSafehouseRestoreCount or 0
        self:drawText("Esto solo restaurará la copia de seguridad seleccionada.", UI_BORDER_SPACING, 48, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Cada ubicación original se cargará, limpiará y pegará de nuevo.", UI_BORDER_SPACING, 70, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Copia de seguridad: " .. tostring(restoreLabel), UI_BORDER_SPACING, 94, 0.9, 0.9, 0.9, 1, UIFont.Small)
        self:drawText("Casas seguras: " .. tostring(restoreCount), UI_BORDER_SPACING, 116, 0.9, 0.9, 0.9, 1, UIFont.Small)
        self:drawText("¿Quieres continuar?", UI_BORDER_SPACING, 140, 1, 1, 1, 1, UIFont.Small)
        return
    end

    self:drawText("Esto creará una copia de seguridad completa y actual de todas las casas seguras", UI_BORDER_SPACING, 48, 1, 1, 1, 1, UIFont.Small)
    self:drawText("existentes en el servidor.", UI_BORDER_SPACING, 70, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Puede tardar según la cantidad de casas seguras.", UI_BORDER_SPACING, 96, 0.9, 0.9, 0.9, 1, UIFont.Small)
    self:drawText("¿Quieres continuar?", UI_BORDER_SPACING, 122, 1, 1, 1, 1, UIFont.Small)
end

function EBFCopyPasteBackupSafehouseDialog:onClick(button)
    if button.internal == "CONTINUE" and self.parentUI then
        self:close()
        EBFCopyPasteBackupSafehouseDialog.open(self.parentUI, "confirm", self.dialogMode)
        return
    end

    if button.internal == "YES" and self.parentUI then
        self:close()
        if self.dialogMode == "restore" then
            local restoreList = self.parentUI.pendingSafehouseRestoreList
            local restoreLabel = self.parentUI.pendingSafehouseRestoreLabel
            self.parentUI.pendingSafehouseRestoreList = nil
            self.parentUI.pendingSafehouseRestoreLabel = nil
            self.parentUI.pendingSafehouseRestoreCount = nil
            self.parentUI:startSafehouseRestore(restoreList, restoreLabel)
        else
            local backupName = self.nameEntry and self.nameEntry:getInternalText() or nil
            self.parentUI:startSafehouseBackup(backupName)
        end
        return
    end

    if self.parentUI then
        self.parentUI.status = self.dialogMode == "restore" and "Restauración de casas seguras cancelada." or "Copia de seguridad de casas seguras cancelada."
        if self.dialogMode == "restore" then
            self.parentUI.pendingSafehouseRestoreList = nil
            self.parentUI.pendingSafehouseRestoreLabel = nil
            self.parentUI.pendingSafehouseRestoreCount = nil
        end
    end
    self:close()
end

function EBFCopyPasteBackupSafehouseDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteBackupSafehouseDialog.instance == self then
        EBFCopyPasteBackupSafehouseDialog.instance = nil
    end
end

function EBFCopyPasteBackupSafehouseDialog:new(x, y, width, height, parent, step, dialogMode)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.step = step or "warning"
    o.dialogMode = dialogMode or "backup"
    o.backupName = makeDefaultSafehouseBackupName()
    o.moveWithMouse = true
    EBFCopyPasteBackupSafehouseDialog.instance = o
    return o
end

local function setBackupMenuButtonColor(button)
    if not button then
        return
    end
    if button.enable then
        button:enableAcceptColor()
    else
        button:enableDisabledColor()
    end
end

function EBFCopyPasteBackupMenuDialog.open(parent)
    if EBFCopyPasteBackupMenuDialog.instance then
        EBFCopyPasteBackupMenuDialog.instance:close()
    end

    local width = 430
    local height = 280
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteBackupMenuDialog:new(x, y, width, height, parent)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteBackupMenuDialog:initialise()
    ISPanel.initialise(self)

    local colWid = (self.width - UI_BORDER_SPACING * 3) / 2
    local rowGap = 8
    local row1 = UI_BORDER_SPACING * 3 + FONT_HGT_MEDIUM
    local row2 = row1 + BUTTON_HGT + rowGap
    local row3 = row2 + BUTTON_HGT + rowGap
    local row4 = row3 + BUTTON_HGT + rowGap
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT

    self.saveSafehouseButton = ISButton:new(UI_BORDER_SPACING, row1, colWid, BUTTON_HGT, "Guardar casa segura", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.saveSafehouseButton.internal = "SAVE_SAFEHOUSE"
    self.saveSafehouseButton:initialise()
    self.saveSafehouseButton:instantiate()
    self.saveSafehouseButton:enableDisabledColor()
    self:addChild(self.saveSafehouseButton)

    self.backupAllButton = ISButton:new(self.saveSafehouseButton:getRight() + UI_BORDER_SPACING, row1, colWid, BUTTON_HGT, "Copia de seguridad de casas seguras", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.backupAllButton.internal = "BACKUP_SAFEHOUSE"
    self.backupAllButton:initialise()
    self.backupAllButton:instantiate()
    self.backupAllButton:enableDisabledColor()
    self:addChild(self.backupAllButton)

    self.exportButton = ISButton:new(UI_BORDER_SPACING, row2, colWid, BUTTON_HGT, "Exportar copia de seguridad", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.exportButton.internal = "EXPORT_SAFEHOUSE_BACKUP"
    self.exportButton:initialise()
    self.exportButton:instantiate()
    self.exportButton:enableDisabledColor()
    self:addChild(self.exportButton)

    self.importButton = ISButton:new(self.exportButton:getRight() + UI_BORDER_SPACING, row2, colWid, BUTTON_HGT, "Importar copia de seguridad", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.importButton.internal = "IMPORT_SAFEHOUSE_BACKUP"
    self.importButton:initialise()
    self.importButton:instantiate()
    self.importButton:enableDisabledColor()
    self:addChild(self.importButton)

    self.exportSavedAreaButton = ISButton:new(UI_BORDER_SPACING, row3, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT, "Exportar guardado personalizado", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.exportSavedAreaButton.internal = "EXPORT_SAVED_AREA"
    self.exportSavedAreaButton:initialise()
    self.exportSavedAreaButton:instantiate()
    self.exportSavedAreaButton:enableDisabledColor()
    self:addChild(self.exportSavedAreaButton)

    self.restoreButton = ISButton:new(UI_BORDER_SPACING, row4, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT, "Restaurar copia de seguridad", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.restoreButton.internal = "RESTORE_SAFEHOUSE_BACKUP"
    self.restoreButton:initialise()
    self.restoreButton:instantiate()
    self.restoreButton:enableDisabledColor()
    self:addChild(self.restoreButton)

    self.closeButton = ISButton:new(self.width - 105 - UI_BORDER_SPACING, bottom, 105, BUTTON_HGT, "FECHAR", self, EBFCopyPasteBackupMenuDialog.onClick)
    self.closeButton.internal = "CLOSE"
    self.closeButton.anchorTop = false
    self.closeButton.anchorBottom = true
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton:enableCancelColor()
    self:addChild(self.closeButton)
end

function EBFCopyPasteBackupMenuDialog:updateButtonStates()
    local parent = self.parentUI
    local hasAccess = parent and EBFCopyPaste.hasCopyPasteAccess(parent.character)
    local idle = parent and not parent.copyInProgress and not parent.pasteInProgress and not parent.safehouseSaveInProgress
            and not parent.safehouseExportInProgress and not parent.savedAreaExportInProgress and not parent.safehouseImportInProgress
            and parent.safehouseBackupJob == nil and parent.safehouseRestoreJob == nil

    self.saveSafehouseButton.enable = hasAccess and idle and parent.hasClipboard == true and parent.safehouseClipboardReady == true
    self.backupAllButton.enable = hasAccess and idle
    self.exportButton.enable = hasAccess and idle
    self.importButton.enable = hasAccess and idle
    self.exportSavedAreaButton.enable = hasAccess and idle
    local restoreGroups = parent and parent.getSafehouseRestoreGroups and parent:getSafehouseRestoreGroups() or {}
    self.restoreButton.enable = hasAccess and idle and #restoreGroups > 0

    setBackupMenuButtonColor(self.saveSafehouseButton)
    setBackupMenuButtonColor(self.backupAllButton)
    setBackupMenuButtonColor(self.exportButton)
    setBackupMenuButtonColor(self.importButton)
    setBackupMenuButtonColor(self.exportSavedAreaButton)
    setBackupMenuButtonColor(self.restoreButton)
end

function EBFCopyPasteBackupMenuDialog:prerender()
    self:updateButtonStates()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre("Copia de seguridad", self.width / 2, UI_BORDER_SPACING + 4, 1, 1, 1, 1, UIFont.Medium)
end

function EBFCopyPasteBackupMenuDialog:onClick(button)
    if button.internal == "CLOSE" then
        self:close()
        return
    end

    local parent = self.parentUI
    if not parent then
        self:close()
        return
    end

    if not button.enable then
        parent.status = "Espera a que termine la operación actual."
        return
    end

    self:close()
    if button.internal == "SAVE_SAFEHOUSE" then
        parent:saveSafehouseClipboard()
    elseif button.internal == "BACKUP_SAFEHOUSE" then
        parent:openSafehouseBackupWarning()
    elseif button.internal == "EXPORT_SAFEHOUSE_BACKUP" then
        parent:requestSafehouseBackupExport()
    elseif button.internal == "IMPORT_SAFEHOUSE_BACKUP" then
        parent:requestSafehouseBackupImport()
    elseif button.internal == "EXPORT_SAVED_AREA" then
        parent:requestSavedAreaExport()
    elseif button.internal == "RESTORE_SAFEHOUSE_BACKUP" then
        parent:requestSafehouseBackupRestore()
    end
end

function EBFCopyPasteBackupMenuDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteBackupMenuDialog.instance == self then
        EBFCopyPasteBackupMenuDialog.instance = nil
    end
end

function EBFCopyPasteBackupMenuDialog:new(x, y, width, height, parent)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.moveWithMouse = true
    EBFCopyPasteBackupMenuDialog.instance = o
    return o
end

trimText = function(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

makeDefaultSafehouseBackupName = function()
    if os and os.date then
        local ok, value = pcall(os.date, "%Y-%m-%d %H-%M")
        if ok and value then
            return "Copia de seguridad de casas seguras " .. tostring(value)
        end
    end
    return "Copia de seguridad de casas seguras " .. tostring(getTimestampMs and getTimestampMs() or 0)
end

sanitizeBackupFilePart = function(value)
    value = trimText(value)
    if value == "" then
        value = makeDefaultSafehouseBackupName()
    end
    value = value:gsub("[\\/:*?\"<>|]", "_")
    value = value:gsub("[%c]", "_")
    value = value:gsub("%s+", "_")
    value = value:gsub("_+", "_")
    value = value:gsub("^_+", ""):gsub("_+$", "")
    if value == "" then
        value = "SafeHouse_Backup"
    end
    return value
end

makeSafehouseBackupFileName = function(backupName)
    return "EBFCopyPaste_" .. sanitizeBackupFilePart(backupName) .. ".txt"
end

makeSavedAreaExportFileName = function(saveName)
    return "EBFCopyPaste_SavePersonalizado_" .. sanitizeBackupFilePart(saveName or "Guardado personalizado") .. ".txt"
end

local function importBackupEscapeLuaString(value)
    value = tostring(value or "")
    value = value:gsub("\\", "\\\\")
    value = value:gsub("\r", "\\r")
    value = value:gsub("\n", "\\n")
    value = value:gsub("\t", "\\t")
    value = value:gsub("\"", "\\\"")
    return "\"" .. value .. "\""
end

local function importBackupSerializeLuaValue(value, depth, seen)
    depth = depth or 0
    seen = seen or {}
    local valueType = type(value)

    if valueType == "nil" then
        return "nil"
    end
    if valueType == "number" then
        return tostring(value)
    end
    if valueType == "boolean" then
        return value and "true" or "false"
    end
    if valueType == "string" then
        return importBackupEscapeLuaString(value)
    end
    if valueType ~= "table" or depth > 96 then
        return "nil"
    end
    if seen[value] then
        return "nil"
    end
    seen[value] = true

    local parts = { "{" }
    local numericKeys = {}
    local otherKeys = {}
    for key, _ in pairs(value) do
        if type(key) == "number" then
            table.insert(numericKeys, key)
        elseif type(key) == "string" or type(key) == "boolean" then
            table.insert(otherKeys, key)
        end
    end
    table.sort(numericKeys)
    table.sort(otherKeys, function(a, b)
        return tostring(a) < tostring(b)
    end)

    for _, key in ipairs(numericKeys) do
        table.insert(parts, "[" .. importBackupSerializeLuaValue(key, depth + 1, seen) .. "]=" .. importBackupSerializeLuaValue(value[key], depth + 1, seen) .. ",")
    end
    for _, key in ipairs(otherKeys) do
        table.insert(parts, "[" .. importBackupSerializeLuaValue(key, depth + 1, seen) .. "]=" .. importBackupSerializeLuaValue(value[key], depth + 1, seen) .. ",")
    end
    table.insert(parts, "}")
    seen[value] = nil
    return table.concat(parts)
end

local function importBackupDeserializeLuaTable(text)
    if type(text) ~= "string" or text == "" or not loadstring then
        return nil
    end

    local chunk = loadstring(text)
    if not chunk then
        return nil
    end
    if setfenv then
        pcall(setfenv, chunk, {})
    end

    local ok, result = pcall(chunk)
    if ok and type(result) == "table" then
        return result
    end
    return nil
end

local function importBackupSaveCountMatches(payload)
    if type(payload) ~= "table" or type(payload.saves) ~= "table" then
        return false
    end

    local declaredCount = tonumber(payload.saveCount)
    if declaredCount ~= nil and declaredCount ~= #payload.saves then
        return false
    end
    return true
end

local function importBackupPayloadToText(payload)
    if type(payload) ~= "table" then
        return nil
    end
    payload.saveCount = type(payload.saves) == "table" and #payload.saves or 0
    payload.updatedAt = getTimestampMs and getTimestampMs() or nil
    return "-- EBFCopyPaste Casa segura Copia de seguridad\nreturn " .. importBackupSerializeLuaValue(payload, 0, {})
end

local function importBackupGetSafehouse(save)
    if type(save) ~= "table" then
        return {}
    end
    local clipboard = type(save.clipboard) == "table" and save.clipboard or {}
    return type(clipboard.safehouse) == "table" and clipboard.safehouse or {}
end

local function importBackupSaveName(save)
    local safehouse = importBackupGetSafehouse(save)
    return tostring(save and (save.name or save.title) or safehouse.title or "Casa segura")
end

local function importBackupSaveLabel(save, index)
    local safehouse = importBackupGetSafehouse(save)
    local clipboard = type(save.clipboard) == "table" and save.clipboard or {}
    local name = importBackupSaveName(save)
    local owner = tostring(save.owner or safehouse.owner or "")
    local x = tonumber(save.originalX or safehouse.x or clipboard.x) or 0
    local y = tonumber(save.originalY or safehouse.y or clipboard.y) or 0
    local z = tonumber(save.originalZ or safehouse.z or clipboard.z) or 0
    local count = tonumber(clipboard.count) or 0
    local ownerText = owner ~= "" and (" - " .. owner) or ""
    return tostring(index) .. ". " .. name .. ownerText .. " | " .. tostring(math.floor(x)) .. "x" .. tostring(math.floor(y)) .. " z" .. tostring(math.floor(z)) .. " | " .. tostring(count) .. " sprites"
end

local function importBackupSinglePayload(payload, saveIndex)
    if type(payload) ~= "table" or type(payload.saves) ~= "table" then
        return nil
    end

    local save = payload.saves[saveIndex]
    if type(save) ~= "table" then
        return nil
    end

    return {
        format = "EBFCopyPasteSafeHouseBackup",
        version = tonumber(payload.version) or 1,
        exportedAt = payload.exportedAt,
        saveCount = 1,
        nextId = tonumber(payload.nextId) or 1,
        saves = { save },
    }
end

function EBFCopyPasteExportBackupDialog.open(parent, groups, dialogMode)
    if EBFCopyPasteExportBackupDialog.instance then
        EBFCopyPasteExportBackupDialog.instance:close()
    end

    local width = math.min(getCore():getScreenWidth() - UI_BORDER_SPACING * 2, 620)
    local height = 210
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteExportBackupDialog:new(x, y, width, height, parent, groups or {}, dialogMode or "export")
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteExportBackupDialog:initialise()
    ISPanel.initialise(self)

    self.groupCombo = ISComboBox:new(UI_BORDER_SPACING, 66, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT, self, EBFCopyPasteExportBackupDialog.onGroupSelected)
    self.groupCombo:initialise()
    self.groupCombo:instantiate()
    self:addChild(self.groupCombo)

    for _, group in ipairs(self.groups or {}) do
        self.groupCombo:addOptionWithData(group.label, group)
    end
    if not self.groups or #self.groups == 0 then
        local emptyText = "No hay ninguna copia de seguridad que exportar"
        if self.dialogMode == "restore" then
            emptyText = "No hay ninguna copia de seguridad que restaurar"
        elseif self.dialogMode == "savedAreaExport" then
            emptyText = "No hay ningún guardado personalizado que exportar"
        end
        self.groupCombo:addOptionWithData(emptyText, nil)
    end
    self.groupCombo.selected = 1

    local btnWid = 120
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT
    self.cancelButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Cancelar", self, EBFCopyPasteExportBackupDialog.onClick)
    self.cancelButton.internal = "CANCEL"
    self.cancelButton.anchorTop = false
    self.cancelButton.anchorBottom = true
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self.cancelButton:enableCancelColor()
    self:addChild(self.cancelButton)

    local actionText = self.dialogMode == "restore" and "Restaurar" or "Exportar"
    self.exportButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, actionText, self, EBFCopyPasteExportBackupDialog.onClick)
    self.exportButton.internal = "EXPORT"
    self.exportButton.anchorTop = false
    self.exportButton.anchorBottom = true
    self.exportButton:initialise()
    self.exportButton:instantiate()
    self.exportButton:enableDisabledColor()
    self:addChild(self.exportButton)
end

function EBFCopyPasteExportBackupDialog:getSelectedGroup()
    if not self.groupCombo then
        return nil
    end
    return self.groupCombo:getOptionData(self.groupCombo.selected)
end

function EBFCopyPasteExportBackupDialog:updateButtonStates()
    local enabled = self:getSelectedGroup() ~= nil
    self.exportButton.enable = enabled
    if enabled then
        self.exportButton:enableAcceptColor()
    else
        self.exportButton:enableDisabledColor()
    end
end

function EBFCopyPasteExportBackupDialog:onGroupSelected()
    self:updateButtonStates()
end

function EBFCopyPasteExportBackupDialog:prerender()
    self:updateButtonStates()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    local title = self.dialogMode == "restore" and "Restaurar copia de seguridad" or "Exportar copia de seguridad"
    local hint = self.dialogMode == "restore" and "Elige qué lote se restaurará en el mapa" or "Elige qué lote se exportará a un archivo"
    if self.dialogMode == "savedAreaExport" then
        title = "Exportar guardado personalizado"
        hint = "Elige qué guardado personalizado se exportará a un archivo"
    end
    self:drawTextCentre(title, self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
    self:drawText(hint, UI_BORDER_SPACING, 42, 1, 1, 1, 1, UIFont.Small)
    local group = self:getSelectedGroup()
    if group then
        local infoLabel = self.dialogMode == "restore" and "Copia de seguridad: " or "Archivo: "
        self:drawText(infoLabel .. tostring(group.backupName or group.fileName or EBFCopyPaste.SafehouseBackupFileName), UI_BORDER_SPACING, 106, 0.9, 0.9, 0.9, 1, UIFont.Small)
        local countLabel = self.dialogMode == "savedAreaExport" and "Guardados personalizados: " or "Casas seguras: "
        self:drawText(countLabel .. tostring(group.count or 0), UI_BORDER_SPACING, 130, 0.9, 0.9, 0.9, 1, UIFont.Small)
    end
end

function EBFCopyPasteExportBackupDialog:onClick(button)
    if button.internal == "EXPORT" and self.parentUI then
        local group = self:getSelectedGroup()
        if group then
            if self.dialogMode == "restore" then
                self.parentUI:requestSafehouseBackupRestoreGroup(group)
            elseif self.dialogMode == "savedAreaExport" then
                self.parentUI:requestSavedAreaExportGroup(group)
            else
                self.parentUI:requestSafehouseBackupExportGroup(group)
            end
            self:close()
            return
        end
        self.parentUI.status = self.dialogMode == "restore" and "Selecciona una copia de seguridad para restaurarla." or "Selecciona una copia de seguridad para exportarla."
        return
    end
    if self.parentUI then
        self.parentUI.status = self.dialogMode == "restore" and "Restauración cancelada." or "Exportación cancelada."
    end
    self:close()
end

function EBFCopyPasteExportBackupDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteExportBackupDialog.instance == self then
        EBFCopyPasteExportBackupDialog.instance = nil
    end
end

function EBFCopyPasteExportBackupDialog:new(x, y, width, height, parent, groups, dialogMode)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.groups = groups or {}
    o.dialogMode = dialogMode or "export"
    o.moveWithMouse = true
    EBFCopyPasteExportBackupDialog.instance = o
    return o
end

function EBFCopyPasteImportFileDialog.open(parent, files)
    if EBFCopyPasteImportFileDialog.instance then
        EBFCopyPasteImportFileDialog.instance:close()
    end

    local width = math.min(getCore():getScreenWidth() - UI_BORDER_SPACING * 2, 620)
    local height = 205
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteImportFileDialog:new(x, y, width, height, parent, files or {})
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteImportFileDialog:initialise()
    ISPanel.initialise(self)

    self.fileCombo = ISComboBox:new(UI_BORDER_SPACING, 66, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT, self, EBFCopyPasteImportFileDialog.onFileSelected)
    self.fileCombo:initialise()
    self.fileCombo:instantiate()
    self:addChild(self.fileCombo)

    for _, fileData in ipairs(self.files or {}) do
        self.fileCombo:addOptionWithData(fileData.label, fileData)
    end
    if not self.files or #self.files == 0 then
        self.fileCombo:addOptionWithData("No se ha encontrado ningún archivo de copia de seguridad.", nil)
    end
    self.fileCombo.selected = 1

    local btnWid = 120
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT
    self.cancelButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Cancelar", self, EBFCopyPasteImportFileDialog.onClick)
    self.cancelButton.internal = "CANCEL"
    self.cancelButton.anchorTop = false
    self.cancelButton.anchorBottom = true
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self.cancelButton:enableCancelColor()
    self:addChild(self.cancelButton)

    self.openButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Abrir", self, EBFCopyPasteImportFileDialog.onClick)
    self.openButton.internal = "OPEN"
    self.openButton.anchorTop = false
    self.openButton.anchorBottom = true
    self.openButton:initialise()
    self.openButton:instantiate()
    self.openButton:enableDisabledColor()
    self:addChild(self.openButton)
end

function EBFCopyPasteImportFileDialog:getSelectedFile()
    if not self.fileCombo then
        return nil
    end
    return self.fileCombo:getOptionData(self.fileCombo.selected)
end

function EBFCopyPasteImportFileDialog:updateButtonStates()
    local enabled = self:getSelectedFile() ~= nil
    self.openButton.enable = enabled
    if enabled then
        self.openButton:enableAcceptColor()
    else
        self.openButton:enableDisabledColor()
    end
end

function EBFCopyPasteImportFileDialog:onFileSelected()
    self:updateButtonStates()
end

function EBFCopyPasteImportFileDialog:prerender()
    self:updateButtonStates()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre("Abrir copia de seguridad", self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Elige el archivo local que quieres importar", UI_BORDER_SPACING, 42, 1, 1, 1, 1, UIFont.Small)
    local fileData = self:getSelectedFile()
    if fileData then
        self:drawText("Archivo: " .. tostring(fileData.fileName), UI_BORDER_SPACING, 106, 0.9, 0.9, 0.9, 1, UIFont.Small)
    end
end

function EBFCopyPasteImportFileDialog:onClick(button)
    if button.internal == "OPEN" and self.parentUI then
        local fileData = self:getSelectedFile()
        if fileData then
            self.parentUI:openSafehouseBackupImportFile(fileData.fileName)
            self:close()
            return
        end
        self.parentUI.status = "Selecciona un archivo de copia de seguridad."
        return
    end
    if self.parentUI then
        self.parentUI.status = "Importación cancelada."
    end
    self:close()
end

function EBFCopyPasteImportFileDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteImportFileDialog.instance == self then
        EBFCopyPasteImportFileDialog.instance = nil
    end
end

function EBFCopyPasteImportFileDialog:new(x, y, width, height, parent, files)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.files = files or {}
    o.moveWithMouse = true
    EBFCopyPasteImportFileDialog.instance = o
    return o
end

function EBFCopyPasteImportBackupDialog.open(parent, payload, fileName)
    if EBFCopyPasteImportBackupConfirmDialog.instance then
        EBFCopyPasteImportBackupConfirmDialog.instance:close()
    end
    if EBFCopyPasteImportBackupDialog.instance then
        EBFCopyPasteImportBackupDialog.instance:close()
    end
    if type(payload) ~= "table" or type(payload.saves) ~= "table" then
        return nil
    end

    local width = math.min(getCore():getScreenWidth() - UI_BORDER_SPACING * 2, 680)
    local height = 260
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteImportBackupDialog:new(x, y, width, height, parent, payload, fileName)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteImportBackupDialog:initialise()
    ISPanel.initialise(self)

    self.backupCombo = ISComboBox:new(UI_BORDER_SPACING, 68, self.width - UI_BORDER_SPACING * 2, BUTTON_HGT, self, EBFCopyPasteImportBackupDialog.onBackupSelected)
    self.backupCombo:initialise()
    self.backupCombo:instantiate()
    self:addChild(self.backupCombo)

    local gap = UI_BORDER_SPACING
    local closeWid = 100
    local importWid = 105
    local restoreWid = 140
    local deleteWid = 140
    local total = closeWid + importWid + restoreWid + deleteWid + gap * 3
    local x = (self.width - total) / 2
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT

    self.closeButton = ISButton:new(x, bottom, closeWid, BUTTON_HGT, "Cancelar", self, EBFCopyPasteImportBackupDialog.onClick)
    self.closeButton.internal = "CANCEL"
    self.closeButton.anchorTop = false
    self.closeButton.anchorBottom = true
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton:enableCancelColor()
    self:addChild(self.closeButton)

    self.importButton = ISButton:new(self.closeButton:getRight() + gap, bottom, importWid, BUTTON_HGT, "Importar", self, EBFCopyPasteImportBackupDialog.onClick)
    self.importButton.internal = "IMPORT"
    self.importButton.anchorTop = false
    self.importButton.anchorBottom = true
    self.importButton:initialise()
    self.importButton:instantiate()
    self.importButton:enableDisabledColor()
    self:addChild(self.importButton)

    self.restoreAllButton = ISButton:new(self.importButton:getRight() + gap, bottom, restoreWid, BUTTON_HGT, "Restaurar todo", self, EBFCopyPasteImportBackupDialog.onClick)
    self.restoreAllButton.internal = "RESTORE_ALL"
    self.restoreAllButton.anchorTop = false
    self.restoreAllButton.anchorBottom = true
    self.restoreAllButton:initialise()
    self.restoreAllButton:instantiate()
    self.restoreAllButton:enableDisabledColor()
    self:addChild(self.restoreAllButton)

    self.deleteButton = ISButton:new(self.restoreAllButton:getRight() + gap, bottom, deleteWid, BUTTON_HGT, "Eliminar copia de seguridad", self, EBFCopyPasteImportBackupDialog.onClick)
    self.deleteButton.internal = "DELETE"
    self.deleteButton.anchorTop = false
    self.deleteButton.anchorBottom = true
    self.deleteButton:initialise()
    self.deleteButton:instantiate()
    self.deleteButton:enableDisabledColor()
    self:addChild(self.deleteButton)

    self:populateBackups()
end

function EBFCopyPasteImportBackupDialog:populateBackups()
    self.backupCombo:clear()
    local saves = self.payload and self.payload.saves or {}
    for index, save in ipairs(saves) do
        self.backupCombo:addOptionWithData(importBackupSaveLabel(save, index), {
            index = index,
            save = save,
        })
    end
    if #saves == 0 then
        self.backupCombo:addOptionWithData("El archivo no contiene copias de seguridad", nil)
    end
    self.backupCombo.selected = 1
end

function EBFCopyPasteImportBackupDialog:refreshPayload(payload)
    self.payload = payload or self.payload
    self:populateBackups()
end

function EBFCopyPasteImportBackupDialog:getSelectedData()
    if not self.backupCombo then
        return nil
    end
    return self.backupCombo:getOptionData(self.backupCombo.selected)
end

function EBFCopyPasteImportBackupDialog:updateButtonStates()
    local selected = self:getSelectedData()
    local enabled = selected ~= nil and selected.save ~= nil
    local restoreAllEnabled = self.payload and type(self.payload.saves) == "table" and #self.payload.saves > 0
    self.importButton.enable = enabled
    self.deleteButton.enable = enabled
    self.restoreAllButton.enable = restoreAllEnabled
    if enabled then
        self.importButton:enableAcceptColor()
        self.deleteButton:enableCancelColor()
    else
        self.importButton:enableDisabledColor()
        self.deleteButton:enableDisabledColor()
    end
    if restoreAllEnabled then
        self.restoreAllButton:enableAcceptColor()
    else
        self.restoreAllButton:enableDisabledColor()
    end
end

function EBFCopyPasteImportBackupDialog:onBackupSelected()
    self:updateButtonStates()
end

function EBFCopyPasteImportBackupDialog:prerender()
    self:updateButtonStates()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre("Importar copia de seguridad", self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Selecciona una copia de seguridad del archivo local", UI_BORDER_SPACING, 44, 1, 1, 1, 1, UIFont.Small)

    local selected = self:getSelectedData()
    if not selected or not selected.save then
        self:drawText("Archivo: " .. tostring(self.fileName or EBFCopyPaste.SafehouseBackupFileName), UI_BORDER_SPACING, 104, 0.86, 0.86, 0.86, 1, UIFont.Small)
        return
    end

    local save = selected.save
    local safehouse = importBackupGetSafehouse(save)
    local clipboard = type(save.clipboard) == "table" and save.clipboard or {}
    local name = importBackupSaveName(save)
    local owner = tostring(save.owner or safehouse.owner or "")
    local w = tonumber(clipboard.w or safehouse.w) or 1
    local h = tonumber(clipboard.h or safehouse.h) or 1
    local levels = tonumber(clipboard.levels or safehouse.levels) or 1
    local count = tonumber(clipboard.count) or 0
    self:drawText("Nombre: " .. name, UI_BORDER_SPACING, 104, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Propietario: " .. (owner ~= "" and owner or "sin propietario"), UI_BORDER_SPACING, 128, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Tamaño: " .. tostring(w) .. "x" .. tostring(h) .. " | Niveles: " .. tostring(levels) .. " | Sprites: " .. tostring(count), UI_BORDER_SPACING, 152, 0.9, 0.9, 0.9, 1, UIFont.Small)
    self:drawText("Importar, restaurar o eliminar siempre pedirá confirmación Sí/No.", UI_BORDER_SPACING, 176, 0.86, 0.86, 0.86, 1, UIFont.Small)
end

function EBFCopyPasteImportBackupDialog:onClick(button)
    if button.internal == "CANCEL" then
        EBFCopyPasteImportBackupConfirmDialog.open(self.parentUI, self, "cancel", self:getSelectedData())
        return
    end

    if button.internal == "RESTORE_ALL" then
        if self.payload and type(self.payload.saves) == "table" and #self.payload.saves > 0 then
            EBFCopyPasteImportBackupConfirmDialog.open(self.parentUI, self, "restoreAll", nil)
        elseif self.parentUI then
            self.parentUI.status = "Este lote no contiene ninguna casa segura válida."
        end
        return
    end

    local selected = self:getSelectedData()
    if not selected or not selected.save then
        if self.parentUI then
            self.parentUI.status = "Selecciona una copia de seguridad válida."
        end
        return
    end

    if button.internal == "IMPORT" then
        EBFCopyPasteImportBackupConfirmDialog.open(self.parentUI, self, "import", selected)
    elseif button.internal == "DELETE" then
        EBFCopyPasteImportBackupConfirmDialog.open(self.parentUI, self, "delete", selected)
    end
end

function EBFCopyPasteImportBackupDialog:close()
    if EBFCopyPasteImportBackupConfirmDialog.instance then
        EBFCopyPasteImportBackupConfirmDialog.instance:close()
    end
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteImportBackupDialog.instance == self then
        EBFCopyPasteImportBackupDialog.instance = nil
    end
end

function EBFCopyPasteImportBackupDialog:new(x, y, width, height, parent, payload, fileName)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.9 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.payload = payload
    o.fileName = fileName or EBFCopyPaste.SafehouseBackupFileName
    o.moveWithMouse = true
    EBFCopyPasteImportBackupDialog.instance = o
    return o
end

function EBFCopyPasteImportBackupConfirmDialog.open(parent, ownerDialog, action, selected)
    if EBFCopyPasteImportBackupConfirmDialog.instance then
        EBFCopyPasteImportBackupConfirmDialog.instance:close()
    end

    local width = 430
    local height = 150
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local dialog = EBFCopyPasteImportBackupConfirmDialog:new(x, y, width, height, parent, ownerDialog, action, selected)
    dialog:initialise()
    dialog:addToUIManager()
    return dialog
end

function EBFCopyPasteImportBackupConfirmDialog:initialise()
    ISPanel.initialise(self)

    local btnWid = 110
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT
    self.noButton = ISButton:new((self.width / 2) - btnWid - (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "No", self, EBFCopyPasteImportBackupConfirmDialog.onClick)
    self.noButton.internal = "NO"
    self.noButton.anchorTop = false
    self.noButton.anchorBottom = true
    self.noButton:initialise()
    self.noButton:instantiate()
    self.noButton:enableCancelColor()
    self:addChild(self.noButton)

    self.yesButton = ISButton:new((self.width / 2) + (UI_BORDER_SPACING / 2), bottom, btnWid, BUTTON_HGT, "Sí", self, EBFCopyPasteImportBackupConfirmDialog.onClick)
    self.yesButton.internal = "YES"
    self.yesButton.anchorTop = false
    self.yesButton.anchorBottom = true
    self.yesButton:initialise()
    self.yesButton:instantiate()
    self.yesButton:enableAcceptColor()
    self:addChild(self.yesButton)
end

function EBFCopyPasteImportBackupConfirmDialog:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    local selectedName = self.selected and self.selected.save and importBackupSaveName(self.selected.save) or "copia de seguridad"
    if self.action == "import" then
        self:drawTextCentre("¿Confirmar la importación?", self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
        self:drawText("Importar: " .. selectedName, UI_BORDER_SPACING, 56, 1, 1, 1, 1, UIFont.Small)
    elseif self.action == "restoreAll" then
        local saves = self.ownerDialog and self.ownerDialog.payload and self.ownerDialog.payload.saves or {}
        local total = type(saves) == "table" and #saves or 0
        local backupName = tostring(self.ownerDialog and self.ownerDialog.payload and self.ownerDialog.payload.backupName or self.ownerDialog and self.ownerDialog.fileName or "copia de seguridad")
        if backupName == "" then
            backupName = tostring(self.ownerDialog and self.ownerDialog.fileName or "copia de seguridad")
        end
        self:drawTextCentre("¿Restaurar todo?", self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
        self:drawText("Lote: " .. backupName, UI_BORDER_SPACING, 50, 1, 1, 1, 1, UIFont.Small)
        self:drawText("Restaurar " .. tostring(total) .. " casas seguras en sus ubicaciones originales.", UI_BORDER_SPACING, 74, 1, 1, 1, 1, UIFont.Small)
    elseif self.action == "delete" then
        self:drawTextCentre("¿Eliminar la copia de seguridad?", self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
        self:drawText("Eliminar del archivo local: " .. selectedName, UI_BORDER_SPACING, 56, 1, 1, 1, 1, UIFont.Small)
    else
        self:drawTextCentre("¿Cancelar la importación?", self.width / 2, UI_BORDER_SPACING + 3, 1, 1, 1, 1, UIFont.Medium)
        self:drawText("¿Cerrar esta ventana sin importar?", UI_BORDER_SPACING, 56, 1, 1, 1, 1, UIFont.Small)
    end
end

function EBFCopyPasteImportBackupConfirmDialog:onClick(button)
    if button.internal ~= "YES" then
        self:close()
        return
    end

    local ownerDialog = self.ownerDialog
    if self.action == "import" and self.parentUI and ownerDialog then
        if self.parentUI:importSelectedSafehouseBackup(ownerDialog.payload, self.selected and self.selected.index, ownerDialog.fileName) then
            self:close()
            ownerDialog:close()
            return
        end
    elseif self.action == "restoreAll" and self.parentUI and ownerDialog then
        if self.parentUI:restoreAllSafehouseBackupsFromPayload(ownerDialog.payload, ownerDialog.fileName) then
            self:close()
            ownerDialog:close()
            return
        end
    elseif self.action == "delete" and self.parentUI and ownerDialog then
        if self.parentUI:deleteSelectedSafehouseBackup(ownerDialog.payload, self.selected and self.selected.index, ownerDialog.fileName) then
            ownerDialog:refreshPayload(ownerDialog.payload)
        end
    elseif self.action == "cancel" then
        if self.parentUI then
            self.parentUI.status = "Importación cancelada."
        end
        self:close()
        if ownerDialog then
            ownerDialog:close()
        end
        return
    end
    self:close()
end

function EBFCopyPasteImportBackupConfirmDialog:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if EBFCopyPasteImportBackupConfirmDialog.instance == self then
        EBFCopyPasteImportBackupConfirmDialog.instance = nil
    end
end

function EBFCopyPasteImportBackupConfirmDialog:new(x, y, width, height, parent, ownerDialog, action, selected)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.92 }
    o.width = width
    o.height = height
    o.parentUI = parent
    o.ownerDialog = ownerDialog
    o.action = action or "cancel"
    o.selected = selected
    o.moveWithMouse = true
    EBFCopyPasteImportBackupConfirmDialog.instance = o
    return o
end

function EBFCopyPasteUI.openPanel(playerObj)
    if not EBFCopyPaste.ensureUIClasses() then
        print("EBFCopyPaste: las dependencias de la interfaz todavía no están listas.")
        return nil
    end
    if not playerObj then
        return nil
    end

    if EBFCopyPasteUI.instance then
        EBFCopyPasteUI.instance:close()
    end

    local fontSize = getCore():getOptionFontSizeReal()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local width = math.min(screenWidth - UI_BORDER_SPACING * 2, math.max(620, 460 + fontSize * 50))
    local height = math.min(screenHeight - UI_BORDER_SPACING * 2, math.max(560, 480 + fontSize * 35))
    local x = math.max(0, screenWidth / 2 - width / 2)
    local y = math.max(0, screenHeight / 2 - height / 2)
    local ui = EBFCopyPasteUI:new(x, y, width, height, playerObj)
    ui:initialise()
    ui:addToUIManager()
    return ui
end

function EBFCopyPasteUI:initialise()
    ISPanel.initialise(self)

    local btnWid = 105
    local stopBtnWid = 125
    local wideBtnWid = 140
    local bottom = self.height - UI_BORDER_SPACING - BUTTON_HGT - 1

    self.cancel = ISButton:new(self.width - stopBtnWid - UI_BORDER_SPACING - 1, bottom, stopBtnWid, BUTTON_HGT, "Parar/Cancelar", self, EBFCopyPasteUI.onClick)
    self.cancel.internal = "CANCEL"
    self.cancel.anchorTop = false
    self.cancel.anchorBottom = true
    self.cancel:initialise()
    self.cancel:instantiate()
    self.cancel:enableCancelColor()
    self:addChild(self.cancel)

    self.resumeButton = ISButton:new(self.cancel.x, bottom - BUTTON_HGT - UI_BORDER_SPACING, stopBtnWid, BUTTON_HGT, "Continuar", self, EBFCopyPasteUI.onClick)
    self.resumeButton.internal = "RESUME"
    self.resumeButton.anchorTop = false
    self.resumeButton.anchorBottom = true
    self.resumeButton:initialise()
    self.resumeButton:instantiate()
    self.resumeButton:enableAcceptColor()
    self.resumeButton:setVisible(false)
    self:addChild(self.resumeButton)

    self.closeTop = ISButton:new(self.width - btnWid - UI_BORDER_SPACING - 1, UI_BORDER_SPACING + 1, btnWid, BUTTON_HGT, "FECHAR", self, EBFCopyPasteUI.onClick)
    self.closeTop.internal = "CLOSE"
    self.closeTop.anchorLeft = false
    self.closeTop.anchorRight = true
    self.closeTop:initialise()
    self.closeTop:instantiate()
    self.closeTop:enableCancelColor()
    self:addChild(self.closeTop)

    self.pickDestination = ISButton:new(UI_BORDER_SPACING + 1, bottom, wideBtnWid, BUTTON_HGT, "Seleccionar destino", self, EBFCopyPasteUI.onClick)
    self.pickDestination.internal = "PICK_DESTINATION"
    self.pickDestination.anchorTop = false
    self.pickDestination.anchorBottom = true
    self.pickDestination:initialise()
    self.pickDestination:instantiate()
    self.pickDestination:enableDisabledColor()
    self:addChild(self.pickDestination)

    self.copy = ISButton:new(self.pickDestination:getRight() + UI_BORDER_SPACING, bottom, btnWid, BUTTON_HGT, "Copiar", self, EBFCopyPasteUI.onClick)
    self.copy.internal = "COPY"
    self.copy.anchorTop = false
    self.copy.anchorBottom = true
    self.copy:initialise()
    self.copy:instantiate()
    self.copy:enableDisabledColor()
    self:addChild(self.copy)

    self.save = ISButton:new(self.copy:getRight() + UI_BORDER_SPACING, bottom, btnWid, BUTTON_HGT, "Guardar", self, EBFCopyPasteUI.onClick)
    self.save.internal = "SAVE"
    self.save.anchorTop = false
    self.save.anchorBottom = true
    self.save:initialise()
    self.save:instantiate()
    self.save:enableDisabledColor()
    self:addChild(self.save)

    self.backupMenu = ISButton:new(self.save:getRight() + UI_BORDER_SPACING, bottom, btnWid, BUTTON_HGT, "Copia de seguridad", self, EBFCopyPasteUI.onClick)
    self.backupMenu.internal = "BACKUP_MENU"
    self.backupMenu.anchorTop = false
    self.backupMenu.anchorBottom = true
    self.backupMenu:initialise()
    self.backupMenu:instantiate()
    self.backupMenu:enableDisabledColor()
    self:addChild(self.backupMenu)

    self.confirm = ISButton:new(UI_BORDER_SPACING + 1, bottom - BUTTON_HGT - UI_BORDER_SPACING, wideBtnWid, BUTTON_HGT, "Confirmar selección", self, EBFCopyPasteUI.onClick)
    self.confirm.internal = "CONFIRM"
    self.confirm.anchorTop = false
    self.confirm.anchorBottom = true
    self.confirm:initialise()
    self.confirm:instantiate()
    self.confirm:enableAcceptColor()
    self:addChild(self.confirm)

    self.startingPoint = ISButton:new(self.confirm:getRight() + UI_BORDER_SPACING, self.confirm.y, wideBtnWid, BUTTON_HGT, "Iniciar selección", self, EBFCopyPasteUI.onClick)
    self.startingPoint.internal = "STARTINGPOINT"
    self.startingPoint.anchorTop = false
    self.startingPoint.anchorBottom = true
    self.startingPoint:initialise()
    self.startingPoint:instantiate()
    self.startingPoint:enableDisabledColor()
    self:addChild(self.startingPoint)

    self.titleEntry = ISTextEntryBox:new("Zona copiada #" .. tostring(getSafehouseCount() + 1), UI_BORDER_SPACING + 1, 10, 200, BUTTON_HGT)
    self.titleEntry:initialise()
    self.titleEntry:instantiate()
    self:addChild(self.titleEntry)

    self.savedCombo = ISComboBox:new(UI_BORDER_SPACING + 1, 10, 200, BUTTON_HGT, self, EBFCopyPasteUI.onSavedSelected)
    self.savedCombo:initialise()
    self.savedCombo:instantiate()
    self:addChild(self.savedCombo)

    self.safehouseSavedCombo = ISComboBox:new(UI_BORDER_SPACING + 1, 10, 200, BUTTON_HGT, self, EBFCopyPasteUI.onSafehouseSaveSelected)
    self.safehouseSavedCombo:initialise()
    self.safehouseSavedCombo:instantiate()
    self:addChild(self.safehouseSavedCombo)

    self.safehouseCombo = ISComboBox:new(UI_BORDER_SPACING + 1, 10, 200, BUTTON_HGT, self, EBFCopyPasteUI.onSafehouseSelected)
    self.safehouseCombo:initialise()
    self.safehouseCombo:instantiate()
    self:addChild(self.safehouseCombo)
    self:populateSafehouseCombo()
    self:populateSavedCombo()
    self:populateSafehouseSavedCombo()
    self:requestSavedAreas()
end

function EBFCopyPasteUI:populateSafehouseCombo()
    self.safehouseCombo:clear()
    self.safehouseCombo:addOptionWithData("Selección manual", nil)

    local list = getSafehouseList()
    if not list then
        self.safehouseCombo.selected = 1
        return
    end

    for i = 0, list:size() - 1 do
        local safe = list:get(i)
        if safe then
            local safehouseData = makeSafehouseData(safe)
            if safehouseData then
                self.safehouseCombo:addOptionWithData(safehouseDisplayName(safehouseData), safehouseData)
            end
        end
    end
    self.safehouseCombo.selected = 1
end

function EBFCopyPasteUI:populateSavedCombo(saves, selectedId)
    if saves then
        self.savedAreas = saves
    end

    self.savedCombo:clear()
    self.savedCombo:addOptionWithData("No hay guardados personalizados", nil)
    self.savedCombo.selected = 1

    for _, save in ipairs(self.savedAreas or {}) do
        local label = tostring(save.name or "Zona copiada")
        if save.w and save.h then
            label = label .. " - " .. tostring(save.w) .. "x" .. tostring(save.h)
        end
        if save.count then
            label = label .. " - " .. tostring(save.count) .. " sprites"
        end
        self.savedCombo:addOptionWithData(label, save)
        if selectedId and tostring(save.id) == tostring(selectedId) then
            self.savedCombo.selected = self.savedCombo:getOptionCount()
        end
    end
end

function EBFCopyPasteUI:populateSafehouseSavedCombo(saves, selectedId)
    if saves then
        self.safehouseSaves = saves
    end

    self.safehouseSavedCombo:clear()
    self.safehouseSavedCombo:addOptionWithData("No hay casas seguras guardadas", nil)
    self.safehouseSavedCombo.selected = 1

    for _, save in ipairs(self.safehouseSaves or {}) do
        local label = tostring(save.name or "Casa segura")
        if save.backupName and tostring(save.backupName) ~= "" then
            label = "[" .. tostring(save.backupName) .. "] " .. label
        end
        if save.owner and tostring(save.owner) ~= "" then
            label = label .. " - " .. tostring(save.owner)
        end
        if save.w and save.h then
            label = label .. " - " .. tostring(save.w) .. "x" .. tostring(save.h)
        end
        if save.count then
            label = label .. " - " .. tostring(save.count) .. " sprites"
        end
        save.kind = "safehouse"
        self.safehouseSavedCombo:addOptionWithData(label, save)
        if selectedId and tostring(save.id) == tostring(selectedId) then
            self.safehouseSavedCombo.selected = self.safehouseSavedCombo:getOptionCount()
        end
    end
end

function EBFCopyPasteUI:requestSavedAreas()
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.RequestSavedAreas, {})
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.RequestSafehouseSaves, {})
end

function EBFCopyPasteUI:setProgressPercent(percent)
    percent = tonumber(percent) or 0
    percent = math.max(0, math.min(100, percent))
    self.progressPercent = math.floor(percent + 0.5)
end

function EBFCopyPasteUI:updateProgress(processed, total, base, span)
    processed = tonumber(processed) or 0
    total = tonumber(total) or 0
    base = tonumber(base) or 0
    span = tonumber(span) or 100
    if total <= 0 then
        self:setProgressPercent(base)
        return
    end
    self:setProgressPercent(base + span * math.max(0, math.min(1, processed / total)))
end

function EBFCopyPasteUI:onSavedSelected(combo)
    local save = combo:getOptionData(combo.selected)
    if not save or not save.id then
        return
    end
    if self.copyInProgress or self.pasteInProgress or self.safehouseExportInProgress
            or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    EBFCopyPasteSavedAreaDialog.open(self, save)
    combo.selected = 1
    self.status = "Guardado personalizado seleccionado."
end

function EBFCopyPasteUI:onSafehouseSaveSelected(combo)
    local save = combo:getOptionData(combo.selected)
    if not save or not save.id then
        return
    end
    if self.copyInProgress or self.pasteInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    save.kind = "safehouse"
    EBFCopyPasteSavedAreaDialog.open(self, save)
    combo.selected = 1
    self.status = "Guardado de casa segura seleccionado."
end

function EBFCopyPasteUI:loadSavedArea(save)
    if not save or not save.id then
        self.status = "Guardado no válido."
        return
    end
    if self.copyInProgress or self.pasteInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    if save.kind == "safehouse" then
        self.status = "Cargando guardado de casa segura..."
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.LoadSafehouseSave, { id = tostring(save.id) })
    else
        self.status = "Cargando guardado personalizado..."
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.LoadSavedArea, { id = tostring(save.id) })
    end
end

function EBFCopyPasteUI:deleteSavedArea(save)
    if not save or not save.id then
        self.status = "Guardado no válido."
        return
    end
    if self.copyInProgress or self.pasteInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    if save.kind == "safehouse" then
        self.status = "Eliminando guardado de casa segura..."
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.DeleteSafehouseSave, { id = tostring(save.id) })
    else
        self.status = "Eliminando guardado personalizado..."
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.DeleteSavedArea, { id = tostring(save.id) })
    end
end

function EBFCopyPasteUI:isSafehouseAreaLoaded(safehouseData)
    if not safehouseData then
        return true
    end

    local cell = getCell()
    if not cell then
        return false
    end

    local z = tonumber(safehouseData.z) or 0
    if cell:getGridSquare(safehouseData.x, safehouseData.y, z) then
        return true
    end
    local sampleX = math.floor((safehouseData.x + safehouseData.x2) / 2)
    local sampleY = math.floor((safehouseData.y + safehouseData.y2) / 2)
    if cell:getGridSquare(sampleX, sampleY, z) then
        return true
    end
    if cell:getGridSquare(safehouseData.x2, safehouseData.y2, z) then
        return true
    end
    return false
end

function EBFCopyPasteUI:promptSafehouseTeleport(safehouseData)
    EBFCopyPasteSafehouseLoadDialog.open(self, safehouseData)
    self.status = "La casa segura está fuera del mapa cargado."
end

function EBFCopyPasteUI:onSafehouseSelected(combo)
    local safehouseData = combo:getOptionData(combo.selected)
    self.selectedSafehouseData = safehouseData
    if not safehouseData then
        self.selectionActive = false
        self.selectionLocked = false
        self.spriteCount = 0
        self.pendingSafehouseCopy = nil
        self.pendingSafehouseAutoCopy = false
        self.pendingSafehouseCopyReadyAt = nil
        self.status = "Pulsa Iniciar selección."
        self:setProgressPercent(0)
        return
    end

    self.X1 = safehouseData.x
    self.Y1 = safehouseData.y
    self.X2 = safehouseData.x2
    self.Y2 = safehouseData.y2
    self.Z = safehouseData.z or 0
    self.pendingSafehouseCopy = nil
    self.pendingSafehouseAutoCopy = false
    self.pendingSafehouseCopyReadyAt = nil
    self.selectionActive = true
    self.selectionLocked = false
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    self.titleEntry:setText("Copia - " .. tostring(safehouseData.title or "Casa segura"))
    self.status = "Casa segura seleccionada. Pulsa Confirmar selección."
    self.nextCountTime = 0
end

function EBFCopyPasteUI:highlightZone(area)
    if not area then
        return
    end

    local r = self.selectionLocked and 0.2 or 0.4
    local g = self.selectionLocked and 1.0 or 0.8
    local b = 1.0
    local a = 0.75
    addAreaHighlightForPlayer(self.character:getPlayerNum(), area.x, area.y, area.x2 + 1, area.y2 + 1, area.z, r, g, b, a)
end

function EBFCopyPasteUI:getCurrentArea()
    if not self.selectionActive then
        return nil
    end

    if self.selectedSafehouseData then
        return EBFCopyPaste.normalizeSelection(self.X1, self.Y1, self.X2, self.Y2, self.Z)
    end

    if self.selectionLocked then
        return EBFCopyPaste.normalizeSelection(self.X1, self.Y1, self.X2, self.Y2, self.Z)
    end

    local x2 = math.floor(self.character:getX())
    local y2 = math.floor(self.character:getY())
    local z = math.floor(self.character:getZ())
    return EBFCopyPaste.normalizeSelection(self.X1, self.Y1, x2, y2, z)
end

function EBFCopyPasteUI:estimateSpriteCount(area)
    local cell = getCell()
    if not cell or not area then
        return 0
    end

    local areaKey = tostring(area.x) .. ":" .. tostring(area.y) .. ":" .. tostring(area.z) .. ":" .. tostring(area.w) .. ":" .. tostring(area.h)
    if self.spriteCountAreaKey ~= areaKey then
        self.spriteCountAreaKey = areaKey
        self.spriteCountTileIndex = 1
        self.spriteCountValue = 0
        self.spriteCountComplete = false
    end

    if self.spriteCountComplete then
        return self.spriteCountValue or 0
    end

    local count = 0
    local totalTiles = math.max(1, (tonumber(area.w) or 1) * (tonumber(area.h) or 1))
    local tileIndex = math.max(1, tonumber(self.spriteCountTileIndex) or 1)
    local budget = totalTiles > 2500 and 1200 or totalTiles
    local processed = 0

    while tileIndex <= totalTiles and processed < budget do
        local zeroIndex = tileIndex - 1
        local dx = math.floor(zeroIndex / area.h)
        local dy = zeroIndex - (dx * area.h)
        local square = cell:getGridSquare(area.x + dx, area.y + dy, area.z)
        if square then
            local objects = square:getObjects()
            if objects then
                for i = 0, objects:size() - 1 do
                    local object = objects:get(i)
                    if object and object:getSprite() and object:getSprite():getName() then
                        count = count + 1
                    end
                end
            end
        end
        tileIndex = tileIndex + 1
        processed = processed + 1
    end

    self.spriteCountValue = (self.spriteCountValue or 0) + count
    self.spriteCountTileIndex = tileIndex
    if tileIndex > totalTiles then
        self.spriteCountComplete = true
    end
    return self.spriteCountValue or 0
end

function EBFCopyPasteUI:updateCounts(area)
    local now = getTimestampMs()
    if self.nextCountTime and now < self.nextCountTime then
        return
    end

    self.spriteCount = self:estimateSpriteCount(area)
    self.nextCountTime = now + 750
end

function EBFCopyPasteUI:updateButtons()
    local area = self:getCurrentArea()
    local areaSize = EBFCopyPaste.areaSize(area)
    local hasAccess = EBFCopyPaste.hasCopyPasteAccess(self.character)
    local maxW = EBFCopyPaste.toInt(EBFCopyPaste.MaxSelectionWidth, 100)
    local maxH = EBFCopyPaste.toInt(EBFCopyPaste.MaxSelectionHeight, 100)
    local manualDimensionLimit = self.selectedSafehouseData == nil
    local validDimensions = not manualDimensionLimit or not area or ((tonumber(area.w) or 0) <= maxW and (tonumber(area.h) or 0) <= maxH)
    local validArea = hasAccess and self.selectionActive == true and areaSize >= 1 and areaSize <= EBFCopyPaste.MaxArea and validDimensions
    local idle = self.operationPaused ~= true
            and not self.copyInProgress and not self.pasteInProgress and not self.safehouseSaveInProgress
            and not self.safehouseExportInProgress and not self.savedAreaExportInProgress and not self.safehouseImportInProgress
            and self.safehouseBackupJob == nil and self.safehouseRestoreJob == nil
    local selectionLoaded = true
    if self.selectedSafehouseData then
        selectionLoaded = self.pendingSafehouseCopy == nil and self:isSafehouseAreaLoaded(self.selectedSafehouseData)
    end

    self.confirm.enable = validArea and not self.selectionLocked and idle
    self.copy.enable = validArea and self.selectionLocked and selectionLoaded and idle and self.hasClipboard ~= true
    self.save.enable = self.hasClipboard == true and idle
    self.pickDestination.enable = self.hasClipboard == true and idle
    self.startingPoint.enable = hasAccess and idle
    self.backupMenu.enable = hasAccess and idle
    if self.resumeButton then
        local showResume = self.operationPaused == true
        self.resumeButton:setVisible(showResume)
        self.resumeButton.enable = showResume
        if showResume then
            self.resumeButton:enableAcceptColor()
        else
            self.resumeButton:enableDisabledColor()
        end
    end

    if self.copy.enable then
        self.copy:enableAcceptColor()
    else
        self.copy:enableDisabledColor()
    end

    if self.save.enable then
        self.save:enableAcceptColor()
    else
        self.save:enableDisabledColor()
    end

    if self.pickDestination.enable then
        self.pickDestination:enableAcceptColor()
    else
        self.pickDestination:enableDisabledColor()
    end

    if self.startingPoint.enable then
        self.startingPoint:enableAcceptColor()
    else
        self.startingPoint:enableDisabledColor()
    end

    if self.backupMenu.enable then
        self.backupMenu:enableAcceptColor()
    else
        self.backupMenu:enableDisabledColor()
    end

    if not hasAccess then
        self.status = "No tienes permisos de administrador para usar la herramienta."
    elseif manualDimensionLimit and area and not validDimensions then
        self.status = "La zona supera el límite de " .. tostring(maxW) .. " × " .. tostring(maxH) .. " casillas."
    elseif areaSize > EBFCopyPaste.MaxArea then
        self.status = "La zona supera el límite de " .. tostring(EBFCopyPaste.MaxArea) .. " casillas."
    end
end

function EBFCopyPasteUI:prerender()
    local splitPoint = 145 + getCore():getOptionFontSizeReal() * 20
    local area = self:getCurrentArea()
    self:updateCounts(area)
    self:updateButtons()

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawText("Zona copiada", self.width / 2 - (getTextManager():MeasureStringX(UIFont.Medium, "Zona copiada") / 2), UI_BORDER_SPACING + 1, 1, 1, 1, 1, UIFont.Medium)
    self.closeTop:setX(self.width - self.closeTop.width - UI_BORDER_SPACING - 1)
    self.closeTop:setY(UI_BORDER_SPACING + 1)

    local z = UI_BORDER_SPACING * 2 + FONT_HGT_MEDIUM + 1
    self:drawText("Título", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self.titleEntry:setX(splitPoint)
    self.titleEntry:setY(z)
    self.titleEntry:setWidth(self.width - splitPoint - UI_BORDER_SPACING - 1)
    self.titleEntry:setHeight(BUTTON_HGT)
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Guardado personalizado", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self.savedCombo:setX(splitPoint)
    self.savedCombo:setY(z)
    self.savedCombo:setWidth(self.width - splitPoint - UI_BORDER_SPACING - 1)
    self.savedCombo:setHeight(BUTTON_HGT)
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Guardado de casa segura", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self.safehouseSavedCombo:setX(splitPoint)
    self.safehouseSavedCombo:setY(z)
    self.safehouseSavedCombo:setWidth(self.width - splitPoint - UI_BORDER_SPACING - 1)
    self.safehouseSavedCombo:setHeight(BUTTON_HGT)
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Casa segura", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self.safehouseCombo:setX(splitPoint)
    self.safehouseCombo:setY(z)
    self.safehouseCombo:setWidth(self.width - splitPoint - UI_BORDER_SPACING - 1)
    self.safehouseCombo:setHeight(BUTTON_HGT)
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Inicial", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    if area then
        self:drawText(tostring(area.x) .. " x " .. tostring(area.y) .. " z " .. tostring(area.z), splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    else
        self:drawText("-", splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    end
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    local currentText = "-"
    if area then
        currentText = tostring(area.x2) .. " x " .. tostring(area.y2) .. " z " .. tostring(area.z)
    end
    if area and not self.selectionLocked then
        currentText = math.floor(self.character:getX()) .. " x " .. math.floor(self.character:getY()) .. " z " .. math.floor(self.character:getZ())
    end
    self:drawText("Actual/final", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self:drawText(currentText, splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Tamaño", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    if area then
        self:drawText(tostring(area.w) .. " x " .. tostring(area.h) .. " = " .. tostring(EBFCopyPaste.areaSize(area)) .. " casillas", splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    else
        self:drawText("-", splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    end
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Sprites", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self:drawText(tostring(self.spriteCount or 0), splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    z = z + UI_BORDER_SPACING + BUTTON_HGT

    self:drawText("Estado", UI_BORDER_SPACING + 1, z + 3, 1, 1, 1, 1, UIFont.Small)
    self:drawText(self.status or "Selecciona la zona copiada.", splitPoint, z + 3, 1, 1, 1, 1, UIFont.Small)
    local progressX = splitPoint
    local progressY = z + FONT_HGT_SMALL + 8
    local progressW = self.width - splitPoint - UI_BORDER_SPACING - 1
    local progressH = 16
    local percent = math.max(0, math.min(100, tonumber(self.progressPercent) or 0))
    local fillW = math.floor((progressW - 2) * percent / 100)
    self:drawRect(progressX, progressY, progressW, progressH, 0.78, 0, 0, 0)
    self:drawRectBorder(progressX, progressY, progressW, progressH, 1, 0.2, 1, 0.2)
    if fillW > 0 then
        self:drawRect(progressX + 1, progressY + 1, fillW, progressH - 2, 0.88, 0.1, 0.85, 0.1)
    end
    local progressText = tostring(math.floor(percent + 0.5)) .. "%"
    self:drawTextCentre(progressText, progressX + progressW / 2, progressY + 1, 1, 1, 1, 1, UIFont.Small)

    self:highlightZone(area)
end

function EBFCopyPasteUI:startSelection()
    self.selectedSafehouseData = nil
    self.pendingSafehouseCopy = nil
    self.pendingSafehouseAutoCopy = false
    self.pendingSafehouseCopyReadyAt = nil
    self.X1 = math.floor(self.character:getX())
    self.Y1 = math.floor(self.character:getY())
    self.X2 = self.X1
    self.Y2 = self.Y1
    self.Z = math.floor(self.character:getZ())
    self.selectionActive = true
    self.selectionLocked = false
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    self.status = "Selección iniciada. Ve hasta la casilla final."
    self:setProgressPercent(0)
    self.nextCountTime = 0
end

function EBFCopyPasteUI:confirmSelection()
    local area = self:getCurrentArea()
    if not area then
        self.status = "Primero pulsa Iniciar selección."
        return
    end

    self.X1 = area.x
    self.Y1 = area.y
    self.X2 = area.x2
    self.Y2 = area.y2
    self.Z = area.z
    self.selectionLocked = true
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    if self.selectedSafehouseData then
        local safehouseData = self.selectedSafehouseData
        self:setProgressPercent(0)
        self.nextCountTime = 0
        if self:isSafehouseAreaLoaded(safehouseData) then
            self.status = "Casa segura cargada y selección confirmada. Pulsa Copiar."
        else
            self:promptSafehouseTeleport(safehouseData)
        end
        return
    end
    self.status = "Selección confirmada. Pulsa Copiar."
    self:setProgressPercent(0)
    self.nextCountTime = 0
end

function EBFCopyPasteUI:decorateSafehouseCopyArgs(args)
    local safehouseData = self.selectedSafehouseData
    if not safehouseData then
        return args
    end

    args.source = "safehouse"
    args.safehouseTitle = tostring(safehouseData.title or "Casa segura")
    args.safehouseOwner = tostring(safehouseData.owner or "")
    args.safehouseX = safehouseData.x
    args.safehouseY = safehouseData.y
    args.safehouseZ = safehouseData.z or 0
    args.safehouseW = safehouseData.w
    args.safehouseH = safehouseData.h
    args.safehouseMembers = safehouseData.members or {}
    args.safehouseRespawnMembers = safehouseData.respawnMembers or {}
    args.safehouseLocation = safehouseData.location or ""
    args.safehouseLastVisited = safehouseData.lastVisited or 0
    args.safehouseDatetimeCreated = safehouseData.datetimeCreated or 0
    args.safehouseHitPoints = safehouseData.hitPoints or 0
    args.safehouseOnlineID = safehouseData.onlineID or -1
    return args
end

function EBFCopyPasteUI:teleportToSafehouseAndCopy(safehouseData, autoCopy)
    safehouseData = safehouseData or self.selectedSafehouseData
    if not safehouseData then
        self.status = "Casa segura no válida."
        return
    end

    self.selectedSafehouseData = safehouseData
    self.X1 = safehouseData.x
    self.Y1 = safehouseData.y
    self.X2 = safehouseData.x2
    self.Y2 = safehouseData.y2
    self.Z = safehouseData.z or 0
    self.selectionActive = true
    self.selectionLocked = true

    local targetX = math.floor(tonumber(safehouseData.x) or 0)
    local targetY = math.floor(tonumber(safehouseData.y) or 0)
    local targetZ = tonumber(safehouseData.z) or 0
    if isClient and isClient() and SendCommandToServer then
        SendCommandToServer("/teleportto " .. tostring(targetX) .. "," .. tostring(targetY) .. "," .. tostring(targetZ))
    elseif self.character and self.character.teleportTo then
        self.character:teleportTo(targetX + 0.5, targetY + 0.5, targetZ)
    end

    self.pendingSafehouseCopy = safehouseData
    self.pendingSafehouseAutoCopy = autoCopy == true
    self.pendingSafehouseCopyStart = getTimestampMs()
    self.pendingSafehouseCopyReadyAt = self.pendingSafehouseCopyStart + SAFEHOUSE_COPY_MIN_TELEPORT_WAIT_MS
    self.nextPendingSafehouseCopyCheck = 0
    self:setProgressPercent(0)
    self.status = "Teletransportando para cargar la casa segura. Esperando 5 segundos..."
end

function EBFCopyPasteUI:updatePendingSafehouseCopy()
    if not self.pendingSafehouseCopy then
        return
    end
    if self.operationPaused == true then
        return
    end
    if self.copyInProgress or self.pasteInProgress then
        return
    end

    local now = getTimestampMs()
    if self.nextPendingSafehouseCopyCheck and now < self.nextPendingSafehouseCopyCheck then
        return
    end
    self.nextPendingSafehouseCopyCheck = now + 500

    local readyAt = tonumber(self.pendingSafehouseCopyReadyAt) or 0
    if now < readyAt then
        local remaining = math.ceil((readyAt - now) / 1000)
        self.status = "Esperando a que el mapa se estabilice tras el teletransporte... " .. tostring(remaining) .. "s"
        return
    end

    if self:isSafehouseAreaLoaded(self.pendingSafehouseCopy) then
        local safehouseData = self.pendingSafehouseCopy
        local autoCopy = self.pendingSafehouseAutoCopy == true or self.safehouseBackupJob ~= nil
        self.pendingSafehouseCopy = nil
        self.pendingSafehouseAutoCopy = false
        self.pendingSafehouseCopyReadyAt = nil
        self.selectedSafehouseData = safehouseData
        if autoCopy then
            self.status = "Casa segura cargada. Iniciando copia..."
            self:copySelection(true)
        else
            self.status = "Casa segura cargada y selección confirmada. Pulsa Copiar."
        end
        return
    end

    local elapsed = math.floor((now - (self.pendingSafehouseCopyStart or now)) / 1000)
    if self.safehouseBackupJob and elapsed >= 180 then
        self:abortSafehouseBackup("El mapa de la casa segura no se cargó en 180 segundos.")
        return
    end
    self.status = "Esperando a que se cargue el mapa de la casa segura... " .. tostring(elapsed) .. "s"
end

function EBFCopyPasteUI:copySelection(forceSafehouseCopy)
    local area = self:getCurrentArea()
    if not area then
        self.status = "Primero pulsa Iniciar selección."
        return
    end
    if not self.selectionLocked then
        self.status = "Confirma la selección antes de copiar."
        return
    end
    if self.hasClipboard == true and not forceSafehouseCopy then
        self.status = "Esta selección ya se ha copiado. Selecciona el destino, guárdala o inicia una selección nueva."
        return
    end
    if self.selectedSafehouseData and not forceSafehouseCopy and not self:isSafehouseAreaLoaded(self.selectedSafehouseData) then
        self:promptSafehouseTeleport(self.selectedSafehouseData)
        return
    end

    local args = {
        title = self.titleEntry:getInternalText(),
        x = area.x,
        y = area.y,
        z = area.z,
        w = area.w,
        h = area.h,
        levels = EBFCopyPaste.DefaultZLevels,
        autoZ = true,
    }
    self:decorateSafehouseCopyArgs(args)
    self.copyInProgress = true
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    self:setProgressPercent(0)
    self.status = "Iniciando el escaneo en el servidor..."
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.CopyArea, args)
end

function EBFCopyPasteUI:openSaveDialog()
    if not self.hasClipboard then
        self.status = "Copia la selección antes de guardarla."
        return
    end
    EBFCopyPasteSaveDialog.open(self)
end

function EBFCopyPasteUI:saveSelection(saveName)
    saveName = tostring(saveName or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if saveName == "" then
        self.status = "Indica un nombre para el guardado."
        return
    end

    if not self.hasClipboard then
        self.status = "Copia la selección antes de guardarla."
        return
    end

    local args = {
        title = saveName,
        saveName = saveName,
    }
    self.copyInProgress = true
    self:setProgressPercent(0)
    self.status = "Guardando en el servidor el portapapeles copiado..."
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.SaveClipboard, args)
end

function EBFCopyPasteUI:saveSafehouseClipboard()
    if not self.safehouseClipboardReady then
        self.status = "Copia una casa segura antes de guardarla."
        return
    end
    if self.copyInProgress or self.pasteInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    self.safehouseSaveInProgress = true
    self.status = "Guardando la casa segura en el almacenamiento independiente..."
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.SaveSafehouseClipboard, {
        name = self.safehouseClipboardTitle or self.titleEntry:getInternalText(),
    })
end

local function splitClientBackupText(text)
    local chunks = {}
    local chunkSize = math.max(1000, tonumber(EBFCopyPaste.BackupChunkSize) or 12000)
    local length = string.len(text or "")
    local index = 1
    while index <= length do
        table.insert(chunks, string.sub(text, index, index + chunkSize - 1))
        index = index + chunkSize
    end
    if #chunks == 0 then
        table.insert(chunks, "")
    end
    return chunks
end

function EBFCopyPasteUI:writeSafehouseBackupFile(text, fileName)
    fileName = fileName or EBFCopyPaste.SafehouseBackupFileName
    local writer = getFileWriter(fileName, true, false)
    if not writer then
        return false
    end
    writer:write(text or "")
    writer:close()
    return true
end

function EBFCopyPasteUI:readSafehouseBackupFile(fileName)
    fileName = fileName or EBFCopyPaste.SafehouseBackupFileName
    local reader = getFileReader(fileName, true)
    if not reader then
        return nil
    end

    local lines = {}
    while true do
        local line = reader:readLine()
        if line == nil then
            break
        end
        table.insert(lines, line)
    end
    reader:close()
    if #lines == 0 then
        return nil
    end
    return table.concat(lines, "\n")
end

function EBFCopyPasteUI:readSafehouseBackupIndex()
    local text = self:readSafehouseBackupFile(SAFEHOUSE_BACKUP_INDEX_FILE)
    local payload = importBackupDeserializeLuaTable(text or "")
    if type(payload) ~= "table" or type(payload.files) ~= "table" then
        return { files = {} }
    end
    return payload
end

function EBFCopyPasteUI:writeSafehouseBackupIndex(index)
    index = index or { files = {} }
    index.format = "EBFCopyPasteSafeHouseBackupIndex"
    index.version = 1
    index.updatedAt = getTimestampMs and getTimestampMs() or nil
    local text = "return " .. importBackupSerializeLuaValue(index, 0, {})
    return self:writeSafehouseBackupFile(text, SAFEHOUSE_BACKUP_INDEX_FILE)
end

function EBFCopyPasteUI:rememberSafehouseBackupFile(fileName, backupName, saveCount)
    fileName = tostring(fileName or EBFCopyPaste.SafehouseBackupFileName)
    local index = self:readSafehouseBackupIndex()
    index.files = index.files or {}
    local updated = false
    for _, entry in ipairs(index.files) do
        if entry and tostring(entry.fileName or "") == fileName then
            entry.backupName = tostring(backupName or entry.backupName or fileName)
            entry.saveCount = tonumber(saveCount) or tonumber(entry.saveCount) or 0
            entry.updatedAt = getTimestampMs and getTimestampMs() or nil
            updated = true
            break
        end
    end
    if not updated then
        table.insert(index.files, {
            fileName = fileName,
            backupName = tostring(backupName or fileName),
            saveCount = tonumber(saveCount) or 0,
            updatedAt = getTimestampMs and getTimestampMs() or nil,
        })
    end
    table.sort(index.files, function(a, b)
        return tostring(a.backupName or a.fileName or ""):lower() < tostring(b.backupName or b.fileName or ""):lower()
    end)
    self:writeSafehouseBackupIndex(index)
end

function EBFCopyPasteUI:getSafehouseBackupFiles()
    local files = {}
    local index = self:readSafehouseBackupIndex()
    local seen = {}
    for _, entry in ipairs(index.files or {}) do
        local fileName = tostring(entry and entry.fileName or "")
        if fileName ~= "" and not seen[fileName] and self:readSafehouseBackupFile(fileName) then
            seen[fileName] = true
            local name = tostring(entry.backupName or fileName)
            local count = tonumber(entry.saveCount) or 0
            table.insert(files, {
                fileName = fileName,
                backupName = name,
                label = name .. " | " .. fileName .. " | " .. tostring(count) .. " casas seguras",
            })
        end
    end

    if not seen[EBFCopyPaste.SafehouseBackupFileName] and self:readSafehouseBackupFile(EBFCopyPaste.SafehouseBackupFileName) then
        table.insert(files, {
            fileName = EBFCopyPaste.SafehouseBackupFileName,
            backupName = "Copia de seguridad predeterminada",
            label = "Copia de seguridad predeterminada | " .. EBFCopyPaste.SafehouseBackupFileName,
        })
    end
    return files
end

function EBFCopyPasteUI:getSafehouseExportGroups()
    local groups = {}
    local grouped = {}
    local unnamedCount = 0
    for _, save in ipairs(self.safehouseSaves or {}) do
        local backupName = trimText(save and save.backupName or "")
        if backupName == "" then
            unnamedCount = unnamedCount + 1
        else
            grouped[backupName] = (grouped[backupName] or 0) + 1
        end
    end

    for backupName, count in pairs(grouped) do
        table.insert(groups, {
            backupName = backupName,
            count = count,
            fileName = makeSafehouseBackupFileName(backupName),
            label = backupName .. " | " .. tostring(count) .. " casas seguras",
        })
    end

    if unnamedCount > 0 then
        table.insert(groups, {
            backupName = "",
            count = unnamedCount,
            fileName = EBFCopyPaste.SafehouseBackupFileName,
            label = "Copias de seguridad sin nombre | " .. tostring(unnamedCount) .. " casas seguras",
        })
    end

    table.sort(groups, function(a, b)
        return tostring(a.label or ""):lower() < tostring(b.label or ""):lower()
    end)

    if #groups > 1 then
        table.insert(groups, 1, {
            backupName = nil,
            count = #self.safehouseSaves,
            fileName = EBFCopyPaste.SafehouseBackupFileName,
            label = "Todas las copias de seguridad | " .. tostring(#self.safehouseSaves) .. " casas seguras",
        })
    elseif #groups == 1 and groups[1].backupName ~= nil then
        table.insert(groups, {
            backupName = nil,
            count = #self.safehouseSaves,
            fileName = EBFCopyPaste.SafehouseBackupFileName,
            label = "Todas las copias de seguridad | " .. tostring(#self.safehouseSaves) .. " casas seguras",
        })
    end

    return groups
end

function EBFCopyPasteUI:getSavedAreaExportGroups()
    local groups = {}
    local saves = self.savedAreas or {}
    for _, save in ipairs(saves) do
        if save and save.id then
            local name = tostring(save.name or "Guardado personalizado")
            local count = tonumber(save.count) or 0
            local sizeText = ""
            if save.w and save.h then
                sizeText = " | " .. tostring(save.w) .. "x" .. tostring(save.h)
            end
            table.insert(groups, {
                id = tostring(save.id),
                name = name,
                count = 1,
                spriteCount = count,
                fileName = makeSavedAreaExportFileName(name),
                label = name .. sizeText .. " | " .. tostring(count) .. " sprites",
            })
        end
    end

    table.sort(groups, function(a, b)
        return tostring(a.label or ""):lower() < tostring(b.label or ""):lower()
    end)

    if #groups > 1 then
        table.insert(groups, 1, {
            id = nil,
            name = "Todos los guardados personalizados",
            count = #groups,
            fileName = EBFCopyPaste.SavedAreaExportFileName,
            label = "Todos los guardados personalizados | " .. tostring(#groups) .. " guardados",
        })
    end

    return groups
end

function EBFCopyPasteUI:getSafehouseRestoreGroups()
    local grouped = {}
    for _, save in ipairs(self.safehouseSaves or {}) do
        local backupName = trimText(save and save.backupName or "")
        if backupName ~= "" then
            grouped[backupName] = grouped[backupName] or {
                backupName = backupName,
                saves = {},
                count = 0,
            }
            table.insert(grouped[backupName].saves, save)
            grouped[backupName].count = grouped[backupName].count + 1
        end
    end

    local groups = {}
    for _, group in pairs(grouped) do
        group.fileName = makeSafehouseBackupFileName(group.backupName)
        group.label = tostring(group.backupName) .. " | " .. tostring(group.count or 0) .. " casas seguras"
        table.insert(groups, group)
    end

    table.sort(groups, function(a, b)
        return tostring(a.label or ""):lower() < tostring(b.label or ""):lower()
    end)
    return groups
end

function EBFCopyPasteUI:requestSafehouseBackupExport()
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    local groups = self:getSafehouseExportGroups()
    if #groups == 0 then
        self.status = "No se ha encontrado ningún guardado de casa segura que exportar."
        return
    end
    EBFCopyPasteExportBackupDialog.open(self, groups)
    self.status = "Selecciona la copia de seguridad que quieres exportar."
end

function EBFCopyPasteUI:requestSavedAreaExport()
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    local groups = self:getSavedAreaExportGroups()
    if #groups == 0 then
        self.status = "No se ha encontrado ningún guardado personalizado que exportar."
        return
    end
    EBFCopyPasteExportBackupDialog.open(self, groups, "savedAreaExport")
    self.status = "Selecciona el guardado personalizado que quieres exportar."
end

function EBFCopyPasteUI:requestSafehouseBackupRestore()
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseRestoreJob or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    local groups = self:getSafehouseRestoreGroups()
    if #groups == 0 then
        self.status = "No se ha encontrado ningún lote de copias de seguridad con nombre que restaurar."
        return
    end
    EBFCopyPasteExportBackupDialog.open(self, groups, "restore")
    self.status = "Selecciona la copia de seguridad que quieres restaurar."
end

function EBFCopyPasteUI:requestSafehouseBackupRestoreGroup(group)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseRestoreJob or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end
    if not group or type(group.saves) ~= "table" or #group.saves == 0 then
        self.status = "Selecciona una copia de seguridad válida para restaurarla."
        return
    end

    self:openSafehouseRestoreWarning(group.saves, tostring(group.backupName or "copia de seguridad seleccionada"))
end

function EBFCopyPasteUI:requestSafehouseBackupExportGroup(group)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end
    group = group or {}
    self.safehouseExportInProgress = true
    self.safehouseExportBuffer = nil
    self:setProgressPercent(0)
    self.status = "Preparando la exportación de la copia de seguridad de casas seguras..."
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.RequestSafehouseBackupExport, {
        backupName = group.backupName,
        fileName = group.fileName or EBFCopyPaste.SafehouseBackupFileName,
    })
end

function EBFCopyPasteUI:requestSavedAreaExportGroup(group)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end
    group = group or {}
    self.savedAreaExportInProgress = true
    self.savedAreaExportBuffer = nil
    self:setProgressPercent(0)
    self.status = "Preparando la exportación del guardado personalizado..."
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.RequestSavedAreaExport, {
        id = group.id,
        fileName = group.fileName or EBFCopyPaste.SavedAreaExportFileName,
    })
end

function EBFCopyPasteUI:startSafehouseBackupImportText(text, statusMessage, options)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return false
    end
    if not text or text == "" then
        self.status = "Copia de seguridad no válida para importar."
        return false
    end

    local chunks = splitClientBackupText(text)
    options = options or {}
    self.safehouseImportInProgress = true
    self.safehouseImportSendJob = {
        sessionId = tostring(getTimestampMs()) .. "-client",
        chunks = chunks,
        index = 1,
        total = #chunks,
        totalSize = string.len(text),
        started = false,
        restoreAfterImport = options.restoreAfterImport == true,
        restoreFileName = options.restoreFileName,
        restoreBackupName = options.restoreBackupName,
    }
    self:setProgressPercent(0)
    self.status = statusMessage or "Iniciando la importación de la copia de seguridad seleccionada..."
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.ImportSafehouseBackupStart, {
        sessionId = self.safehouseImportSendJob.sessionId,
        total = self.safehouseImportSendJob.total,
        totalSize = self.safehouseImportSendJob.totalSize,
        restoreAfterImport = self.safehouseImportSendJob.restoreAfterImport,
    })
    return true
end

function EBFCopyPasteUI:requestSafehouseBackupImport()
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    local files = self:getSafehouseBackupFiles()
    if #files == 0 then
        self.status = "No se ha encontrado ningún archivo de copia de seguridad en el cliente."
        return
    end
    EBFCopyPasteImportFileDialog.open(self, files)
    self.status = "Selecciona el archivo de copia de seguridad que quieres abrir."
end

function EBFCopyPasteUI:openSafehouseBackupImportFile(fileName)
    fileName = fileName or EBFCopyPaste.SafehouseBackupFileName
    local text = self:readSafehouseBackupFile(fileName)
    if not text or text == "" then
        self.status = "Archivo " .. tostring(fileName) .. " no se ha encontrado en el cliente."
        return
    end

    local payload = importBackupDeserializeLuaTable(text)
    if type(payload) ~= "table" or payload.format ~= "EBFCopyPasteSafeHouseBackup" or type(payload.saves) ~= "table" then
        self.status = "No se puede leer el archivo de copia de seguridad."
        return
    end
    if not importBackupSaveCountMatches(payload) then
        self.status = "Archivo de copia de seguridad incompleto o dañado: saveCount no coincide."
        return
    end
    if #payload.saves <= 0 then
        self.status = "El archivo de copia de seguridad no contiene casas seguras."
        return
    end

    EBFCopyPasteImportBackupDialog.open(self, payload, fileName)
    self.status = "Selecciona la copia de seguridad que quieres importar."
end

function EBFCopyPasteUI:importSelectedSafehouseBackup(payload, saveIndex, fileName)
    local singlePayload = importBackupSinglePayload(payload, saveIndex)
    if not singlePayload then
        self.status = "La copia de seguridad seleccionada no es válida."
        return false
    end

    local text = importBackupPayloadToText(singlePayload)
    if not text then
        self.status = "No se ha podido preparar la copia de seguridad seleccionada."
        return false
    end

    local saveName = importBackupSaveName(singlePayload.saves[1])
    return self:startSafehouseBackupImportText(text, "Importando la copia de seguridad seleccionada: " .. saveName)
end

function EBFCopyPasteUI:restoreAllSafehouseBackupsFromPayload(payload, fileName)
    if type(payload) ~= "table" or type(payload.saves) ~= "table" or #payload.saves <= 0 then
        self.status = "Lote de copias de seguridad no válido para restaurar."
        return false
    end
    if not importBackupSaveCountMatches(payload) then
        self.status = "Lote de copias de seguridad incompleto o dañado: saveCount no coincide."
        return false
    end

    local text = importBackupPayloadToText(payload)
    if not text then
        self.status = "No se ha podido preparar el lote para la restauración."
        return false
    end

    local backupName = tostring(payload.backupName or fileName or "copia de seguridad")
    if backupName == "" then
        backupName = tostring(fileName or "copia de seguridad")
    end
    return self:startSafehouseBackupImportText(text, "Importando el lote para la restauración: " .. backupName, {
        restoreAfterImport = true,
        restoreFileName = fileName,
        restoreBackupName = backupName,
    })
end

function EBFCopyPasteUI:deleteSelectedSafehouseBackup(payload, saveIndex, fileName)
    if self.safehouseImportInProgress or self.safehouseExportInProgress or self.savedAreaExportInProgress then
        self.status = "Espera a que termine la operación actual."
        return false
    end
    if type(payload) ~= "table" or type(payload.saves) ~= "table" or type(payload.saves[saveIndex]) ~= "table" then
        self.status = "La copia de seguridad seleccionada no es válida."
        return false
    end

    local saveName = importBackupSaveName(payload.saves[saveIndex])
    table.remove(payload.saves, saveIndex)
    payload.saveCount = #payload.saves
    local text = importBackupPayloadToText(payload)
    if not text or not self:writeSafehouseBackupFile(text, fileName or EBFCopyPaste.SafehouseBackupFileName) then
        self.status = "No se ha podido actualizar el archivo de copia de seguridad."
        return false
    end

    self.status = "Copia de seguridad eliminada del archivo local: " .. saveName
    return true
end

function EBFCopyPasteUI:updateSafehouseImportSender()
    local job = self.safehouseImportSendJob
    if not job or not job.started then
        return
    end
    if self.operationPaused == true or job.paused == true then
        return
    end

    local budget = 2
    while budget > 0 and job.index <= job.total do
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.ImportSafehouseBackupChunk, {
            sessionId = job.sessionId,
            index = job.index,
            total = job.total,
            data = job.chunks[job.index],
        })
        job.index = job.index + 1
        budget = budget - 1
    end

    if job.index > job.total and not job.finishSent then
        job.finishSent = true
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.ImportSafehouseBackupFinish, {
            sessionId = job.sessionId,
        })
        self.status = "Finalizando la importación en el servidor..."
    end
end

function EBFCopyPasteUI:getSafehouseBackupList()
    local safehouses = {}
    local list = getSafehouseList()
    if not list then
        return safehouses
    end

    for i = 0, list:size() - 1 do
        local safe = list:get(i)
        local safehouseData = makeSafehouseData(safe)
        if safehouseData then
            table.insert(safehouses, safehouseData)
        end
    end

    table.sort(safehouses, function(a, b)
        local ownerA = tostring(a.owner or "")
        local ownerB = tostring(b.owner or "")
        if ownerA ~= ownerB then
            return ownerA < ownerB
        end
        return tostring(a.title or "") < tostring(b.title or "")
    end)
    return safehouses
end

function EBFCopyPasteUI:openSafehouseBackupWarning()
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseRestoreJob or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end
    EBFCopyPasteBackupSafehouseDialog.open(self, "warning", "backup")
end

function EBFCopyPasteUI:openSafehouseRestoreWarning(sourceSaves, restoreLabel)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob
            or self.safehouseRestoreJob or self.safehouseExportInProgress or self.savedAreaExportInProgress or self.safehouseImportInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end
    if type(sourceSaves) ~= "table" or #sourceSaves == 0 then
        self.pendingSafehouseRestoreList = nil
        self.pendingSafehouseRestoreLabel = nil
        self.pendingSafehouseRestoreCount = nil
        self.status = "Selecciona una copia de seguridad concreta para restaurarla."
        return
    end

    self.pendingSafehouseRestoreList = sourceSaves
    self.pendingSafehouseRestoreLabel = tostring(restoreLabel or "copia de seguridad seleccionada")
    self.pendingSafehouseRestoreCount = #sourceSaves
    EBFCopyPasteBackupSafehouseDialog.open(self, "warning", "restore")
end

function EBFCopyPasteUI:startSafehouseBackup(backupName)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    backupName = trimText(backupName)
    if backupName == "" then
        backupName = makeDefaultSafehouseBackupName()
    end

    local safehouses = self:getSafehouseBackupList()
    if #safehouses == 0 then
        self.status = "No se ha encontrado ninguna casa segura para crear la copia de seguridad."
        return
    end

    self.safehouseBackupJob = {
        list = safehouses,
        index = 1,
        total = #safehouses,
        saved = 0,
        failed = 0,
        startedAt = getTimestampMs(),
        backupName = backupName,
        exportFileName = makeSafehouseBackupFileName(backupName),
    }
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    self:setProgressPercent(0)
    self:advanceSafehouseBackup()
end

function EBFCopyPasteUI:getCurrentBackupSafehouse()
    local job = self.safehouseBackupJob
    if not job or not job.list then
        return nil
    end
    return job.list[job.index]
end

function EBFCopyPasteUI:advanceSafehouseBackup()
    local job = self.safehouseBackupJob
    if not job then
        return
    end
    if self.operationPaused == true or job.paused == true then
        self.status = "Copia de seguridad de casas seguras pausada. Pulsa Continuar para reanudarla."
        return
    end

    if job.index > job.total then
        self:finishSafehouseBackup()
        return
    end

    local safehouseData = self:getCurrentBackupSafehouse()
    if not safehouseData then
        self:abortSafehouseBackup("Casa segura no válida durante la copia de seguridad.")
        return
    end

    job.phase = "loading"
    local label = safehouseDisplayName(safehouseData)
    self.status = "Copia de seguridad de casas seguras " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": cargando " .. label
    self:teleportToSafehouseAndCopy(safehouseData, true)
end

function EBFCopyPasteUI:handleSafehouseBackupCopyDone(args)
    local job = self.safehouseBackupJob
    if not job then
        return false
    end
    if self.operationPaused == true or job.paused == true then
        self.status = "Copia de seguridad de casas seguras pausada. Pulsa Continuar para reanudarla."
        return true
    end

    local safehouseData = self:getCurrentBackupSafehouse()
    if not safehouseData then
        self:abortSafehouseBackup("Casa segura no válida después de copiarla.")
        return true
    end

    job.phase = "saving"
    self.safehouseSaveInProgress = true
    self.status = "Copia de seguridad de casas seguras " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": guardando " .. safehouseDisplayName(safehouseData)
    sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.SaveSafehouseClipboard, {
        name = safehouseDisplayName(safehouseData),
        backupAll = true,
        backupIndex = job.index,
        backupTotal = job.total,
        backupName = job.backupName,
    })
    return true
end

function EBFCopyPasteUI:handleSafehouseBackupSaveDone(args)
    local job = self.safehouseBackupJob
    if not job then
        return false
    end

    self.safehouseSaveInProgress = false
    job.saved = (job.saved or 0) + 1
    job.index = job.index + 1
    self:setProgressPercent((job.saved / math.max(1, job.total)) * 100)
    if self.operationPaused == true or job.paused == true then
        self.status = "Copia de seguridad de casas seguras pausada. Pulsa Continuar para reanudarla."
        return true
    end
    self:advanceSafehouseBackup()
    return true
end

function EBFCopyPasteUI:finishSafehouseBackup()
    local job = self.safehouseBackupJob
    local saved = job and job.saved or 0
    local total = job and job.total or saved
    self.safehouseBackupJob = nil
    self.safehouseSaveInProgress = false
    self.pendingSafehouseCopy = nil
    self.pendingSafehouseAutoCopy = false
    self.pendingSafehouseCopyReadyAt = nil
    self:setProgressPercent(100)
    self.status = "Copia de seguridad de casas seguras completada: " .. tostring(job and job.backupName or "") .. " (" .. tostring(saved) .. "/" .. tostring(total) .. " casas seguras)."
end

function EBFCopyPasteUI:abortSafehouseBackup(message)
    local job = self.safehouseBackupJob
    local saved = job and job.saved or 0
    local total = job and job.total or 0
    self.safehouseBackupJob = nil
    self.safehouseSaveInProgress = false
    self.pendingSafehouseCopy = nil
    self.pendingSafehouseAutoCopy = false
    self.pendingSafehouseCopyReadyAt = nil
    self.copyInProgress = false
    self.status = (message or "Copia de seguridad de casas seguras interrumpida.") .. " Guardadas: " .. tostring(saved) .. "/" .. tostring(total) .. "."
end

function EBFCopyPasteUI:getSafehouseSaveArea(save)
    if not save then
        return nil
    end
    local x = math.floor(tonumber(save.x) or 0)
    local y = math.floor(tonumber(save.y) or 0)
    local z = math.floor(tonumber(save.z) or 0)
    local w = math.max(1, math.floor(tonumber(save.w) or 1))
    local h = math.max(1, math.floor(tonumber(save.h) or 1))
    return {
        x = x,
        y = y,
        z = z,
        w = w,
        h = h,
        x2 = tonumber(save.x2) or (x + w - 1),
        y2 = tonumber(save.y2) or (y + h - 1),
        title = tostring(save.name or "Casa segura"),
        owner = tostring(save.owner or ""),
    }
end

function EBFCopyPasteUI:teleportToSafehouseSave(save)
    local area = self:getSafehouseSaveArea(save)
    if not area then
        return false
    end

    local targetX = math.floor(tonumber(area.x) or 0)
    local targetY = math.floor(tonumber(area.y) or 0)
    local targetZ = tonumber(area.z) or 0
    if isClient and isClient() and SendCommandToServer then
        SendCommandToServer("/teleportto " .. tostring(targetX) .. "," .. tostring(targetY) .. "," .. tostring(targetZ))
    elseif self.character and self.character.teleportTo then
        self.character:teleportTo(targetX + 0.5, targetY + 0.5, targetZ)
    end
    return true
end

function EBFCopyPasteUI:getSafehouseSavesByIds(saveIds, saves)
    local result = {}
    if type(saveIds) ~= "table" then
        return result
    end

    local byId = {}
    for _, save in ipairs(saves or self.safehouseSaves or {}) do
        if save and save.id then
            byId[tostring(save.id)] = save
        end
    end

    local seen = {}
    for _, saveId in ipairs(saveIds) do
        local key = tostring(saveId or "")
        local save = byId[key]
        if save and not seen[key] then
            table.insert(result, save)
            seen[key] = true
        end
    end
    return result
end

function EBFCopyPasteUI:startSafehouseRestore(sourceSaves, restoreLabel)
    if self.copyInProgress or self.pasteInProgress or self.safehouseSaveInProgress or self.safehouseBackupJob or self.safehouseRestoreJob then
        self.status = "Espera a que termine la operación actual."
        return false
    end
    if type(sourceSaves) ~= "table" or #sourceSaves == 0 then
        self.status = "Selecciona una copia de seguridad concreta para restaurarla."
        return false
    end

    local restoreList = {}
    for _, save in ipairs(sourceSaves) do
        if save and save.id then
            table.insert(restoreList, save)
        end
    end
    if #restoreList == 0 then
        self.status = "No hay ningún guardado válido de casa segura que restaurar."
        return false
    end

    self.safehouseRestoreJob = {
        list = restoreList,
        index = 1,
        total = #restoreList,
        restored = 0,
        metadataFailed = 0,
        restoreLabel = restoreLabel,
        startedAt = getTimestampMs(),
    }
    self.pendingSafehouseRestore = nil
    self.pendingSafehouseRestoreReadyAt = nil
    self.safehouseRestoreWaiting = false
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    self:setProgressPercent(0)
    self:advanceSafehouseRestore()
    return true
end

function EBFCopyPasteUI:getCurrentRestoreSafehouse()
    local job = self.safehouseRestoreJob
    if not job or not job.list then
        return nil
    end
    return job.list[job.index]
end

function EBFCopyPasteUI:advanceSafehouseRestore()
    local job = self.safehouseRestoreJob
    if not job then
        return
    end
    if self.operationPaused == true or job.paused == true then
        self.status = "Restauración pausada. Pulsa Continuar para reanudarla."
        return
    end
    if job.index > job.total then
        self:finishSafehouseRestore()
        return
    end

    local save = self:getCurrentRestoreSafehouse()
    local area = self:getSafehouseSaveArea(save)
    if not save or not save.id or not area then
        self:abortSafehouseRestore("Guardado de casa segura no válido durante la restauración.")
        return
    end

    self.pendingSafehouseRestore = save
    self.safehouseRestoreWaiting = false
    self.pendingSafehouseRestoreStart = getTimestampMs()
    self.pendingSafehouseRestoreReadyAt = self.pendingSafehouseRestoreStart + SAFEHOUSE_COPY_MIN_TELEPORT_WAIT_MS
    self.nextPendingSafehouseRestoreCheck = 0
    self:setProgressPercent(((job.index - 1) / math.max(1, job.total)) * 100)
    self.status = "Restaurando casa segura " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": cargando " .. tostring(save.name or "Casa segura")
    self:teleportToSafehouseSave(save)
end

function EBFCopyPasteUI:updatePendingSafehouseRestore()
    if not self.pendingSafehouseRestore or self.safehouseRestoreWaiting then
        return
    end
    if self.operationPaused == true then
        return
    end
    if self.copyInProgress or self.pasteInProgress then
        return
    end

    local now = getTimestampMs()
    if self.nextPendingSafehouseRestoreCheck and now < self.nextPendingSafehouseRestoreCheck then
        return
    end
    self.nextPendingSafehouseRestoreCheck = now + 500

    local save = self.pendingSafehouseRestore
    local area = self:getSafehouseSaveArea(save)
    local readyAt = tonumber(self.pendingSafehouseRestoreReadyAt) or 0
    if now < readyAt then
        local remaining = math.ceil((readyAt - now) / 1000)
        self.status = "Esperando a que el mapa se estabilice antes de la restauración... " .. tostring(remaining) .. "s"
        return
    end

    if area and self:isSafehouseAreaLoaded(area) then
        local job = self.safehouseRestoreJob
        self.pendingSafehouseRestore = nil
        self.pendingSafehouseRestoreReadyAt = nil
        self.safehouseRestoreWaiting = true
        self.pasteInProgress = true
        self.status = "Zona cargada. Iniciando la restauración de " .. tostring(save.name or "Casa segura") .. "..."
        sendClientCommand(self.character, EBFCopyPaste.Module, EBFCopyPaste.Commands.RestoreSafehouseSave, {
            id = tostring(save.id),
            restoreIndex = job and job.index or 1,
            restoreTotal = job and job.total or 1,
        })
        return
    end

    local elapsed = math.floor((now - (self.pendingSafehouseRestoreStart or now)) / 1000)
    if elapsed >= 180 then
        self:abortSafehouseRestore("El mapa de la casa segura no se cargó en 180 segundos.")
        return
    end
    self.status = "Esperando a que se cargue la ubicación original... " .. tostring(elapsed) .. "s"
end

function EBFCopyPasteUI:updateSafehouseRestoreProgress(args)
    local job = self.safehouseRestoreJob
    if not job then
        return
    end
    self.pasteInProgress = true
    self.safehouseRestoreWaiting = true

    local processed = tonumber(args.processed) or 0
    local total = tonumber(args.total) or 1
    local phaseProgress = total > 0 and math.max(0, math.min(1, processed / total)) or 0
    if args.phase == "paste" then
        phaseProgress = 0.5 + phaseProgress * 0.45
    elseif args.phase == "finalizeRooms" or args.phase == "finalizeLights" then
        phaseProgress = 0.95 + phaseProgress * 0.05
    else
        phaseProgress = phaseProgress * 0.5
    end
    local base = ((job.index - 1) / math.max(1, job.total)) * 100
    self:setProgressPercent(base + (phaseProgress * 100 / math.max(1, job.total)))

    local blockText = ""
    if args.blockIndex and args.blockTotal and tonumber(args.blockTotal) and tonumber(args.blockTotal) > 1 then
        blockText = " bloque " .. tostring(args.blockIndex) .. "/" .. tostring(args.blockTotal)
    end
    if args.phase == "clear" then
        if args.loadingSource == true then
            self.status = "Restaurando " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": cargando destino" .. blockText .. "..."
        else
            self.status = "Restaurando " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": limpiando destino" .. blockText .. " " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        end
    elseif args.phase == "finalizeRooms" or args.phase == "finalizeLights" then
        self.status = "Restaurando " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": finalizando sistemas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
    else
        if args.loadingSource == true then
            self.status = "Restaurando " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": cargando destino" .. blockText .. "..."
            return
        end
        self.status = "Restaurando " .. tostring(job.index) .. "/" .. tostring(job.total) .. ": pegando objetos " .. tostring(processed) .. "/" .. tostring(total) .. "..."
    end
end

function EBFCopyPasteUI:handleSafehouseRestoreDone(args)
    local job = self.safehouseRestoreJob
    if not job then
        return false
    end

    self.pasteInProgress = false
    self.safehouseRestoreWaiting = false
    job.restored = (job.restored or 0) + 1
    if args.metadataOk ~= true then
        job.metadataFailed = (job.metadataFailed or 0) + 1
    end
    if args.roomLightWarning == true then
        job.roomLightWarnings = (job.roomLightWarnings or 0) + (tonumber(args.roomLightWarnings) or 1)
    end
    job.index = job.index + 1
    self:setProgressPercent((job.restored / math.max(1, job.total)) * 100)
    if self.operationPaused == true or job.paused == true then
        self.status = "Restauración pausada. Pulsa Continuar para reanudarla."
        return true
    end
    self:advanceSafehouseRestore()
    return true
end

function EBFCopyPasteUI:finishSafehouseRestore()
    local job = self.safehouseRestoreJob
    local restored = job and job.restored or 0
    local total = job and job.total or restored
    local metadataFailed = job and job.metadataFailed or 0
    local roomLightWarnings = job and job.roomLightWarnings or 0
    self.safehouseRestoreJob = nil
    self.pendingSafehouseRestore = nil
    self.pendingSafehouseRestoreReadyAt = nil
    self.safehouseRestoreWaiting = false
    self.pasteInProgress = false
    self:setProgressPercent(100)
    if metadataFailed > 0 then
        self.status = "Restauración completada: " .. tostring(restored) .. "/" .. tostring(total) .. ". Metadatos con errores: " .. tostring(metadataFailed) .. "."
    elseif roomLightWarnings > 0 then
        self.status = "Restauración completada con aviso: no se pudo verificar RoomLight interior en " .. tostring(roomLightWarnings) .. " habitaciones."
    else
        self.status = "Restauración completada: " .. tostring(restored) .. "/" .. tostring(total) .. " casas seguras restauradas."
    end
end

function EBFCopyPasteUI:abortSafehouseRestore(message)
    local job = self.safehouseRestoreJob
    local restored = job and job.restored or 0
    local total = job and job.total or 0
    self.safehouseRestoreJob = nil
    self.pendingSafehouseRestore = nil
    self.pendingSafehouseRestoreReadyAt = nil
    self.safehouseRestoreWaiting = false
    self.pasteInProgress = false
    self.status = (message or "Restauración de casas seguras interrumpida.") .. " Restauradas: " .. tostring(restored) .. "/" .. tostring(total) .. "."
end

function EBFCopyPasteUI:startPasteCursor()
    if not self.hasClipboard then
        self.status = "Copia o carga un guardado antes de seleccionar el destino."
        return
    end
    if self.pasteInProgress then
        self.status = "El pegado todavía está en curso."
        return
    end

    local cursor = EBFCopyPastePasteCursor:new(self.character, self.copiedWidth or 1, self.copiedHeight or 1)
    getCell():setDrag(cursor, self.character:getPlayerNum())
    self.status = "Pulsa la casilla inicial en la que se pegará la copia."
end

local fastMoveState = nil

local function stopFastMoveState()
    if fastMoveState and Events and Events.OnTick then
        Events.OnTick.Remove(EBFCopyPaste.processFastMoveState)
    end
    fastMoveState = nil
end

local function fastMoveStepValue(delta)
    if delta > 0 then
        return 1
    end
    if delta < 0 then
        return -1
    end
    return 0
end

function EBFCopyPaste.processFastMoveState()
    local state = fastMoveState
    if not state then
        stopFastMoveState()
        return
    end

    local player = state.character or getPlayer()
    if not player then
        stopFastMoveState()
        return
    end

    local targetX = math.floor(tonumber(state.x) or 0)
    local targetY = math.floor(tonumber(state.y) or 0)
    local targetZ = math.floor(tonumber(state.z) or 0)
    local currentX = math.floor(tonumber(player:getX()) or 0)
    local currentY = math.floor(tonumber(player:getY()) or 0)
    local currentZ = math.floor(tonumber(player:getZ()) or 0)

    if currentZ ~= targetZ then
        if player.setZ then
            pcall(function()
                player:setZ(targetZ)
            end)
        end
        if player.setLastZ then
            pcall(function()
                player:setLastZ(targetZ)
            end)
        end
        if ISFastTeleportMove then
            ISFastTeleportMove.currentZ = targetZ
        end
    end

    if currentX == targetX and currentY == targetY and currentZ == targetZ then
        stopFastMoveState()
        return
    end

    local stepX = fastMoveStepValue(targetX - currentX)
    local stepY = fastMoveStepValue(targetY - currentY)
    if stepX ~= 0 or stepY ~= 0 then
        if not ISFastTeleportMove then
            tryRequire("DebugUIs/ISFastTeleportMove")
        end
        if ISFastTeleportMove and ISFastTeleportMove.moveXY then
            pcall(ISFastTeleportMove.moveXY, player, stepX, stepY)
        elseif player.teleportTo then
            pcall(function()
                player:teleportTo(player:getX() + stepX, player:getY() + stepY, targetZ)
            end)
        end
    end

    state.steps = (state.steps or 0) + 1
    if state.steps > 512 then
        stopFastMoveState()
    end
end

function EBFCopyPasteUI:startFastMoveTo(targetX, targetY, targetZ, status)
    stopFastMoveState()
    fastMoveState = {
        character = self.character,
        x = math.floor(tonumber(targetX) or 0),
        y = math.floor(tonumber(targetY) or 0),
        z = math.floor(tonumber(targetZ) or 0),
        steps = 0,
    }
    if status then
        self.status = status
    end
    if Events and Events.OnTick then
        Events.OnTick.Add(EBFCopyPaste.processFastMoveState)
    else
        EBFCopyPaste.processFastMoveState()
    end
end

function EBFCopyPasteUI:onServerFeedback(args)
    args = args or {}

    if args.action == "operationPaused" then
        if args.ok then
            self.operationPaused = true
            self.status = args.message or "Operación pausada. Pulsa Continuar para reanudarla."
        else
            self.status = args.message or "No se ha podido pausar la operación."
        end
        return
    end

    if args.action == "operationResumed" then
        if args.ok then
            self.operationPaused = false
            if self.safehouseBackupJob then
                self.safehouseBackupJob.paused = false
            end
            if self.safehouseRestoreJob then
                self.safehouseRestoreJob.paused = false
            end
            if self.safehouseImportSendJob then
                self.safehouseImportSendJob.paused = false
            end
            self.status = args.message or "Operación reanudada."
        else
            self.status = args.message or "No se ha podido reanudar la operación."
        end
        return
    end

    if args.action == "operationCanceled" then
        if args.ok and self.operationPaused ~= true then
            self.copyInProgress = false
            self.pasteInProgress = false
            self.safehouseSaveInProgress = false
            self.safehouseExportInProgress = false
            self.savedAreaExportInProgress = false
            self.safehouseImportInProgress = false
            self.safehouseImportSendJob = nil
        end
        if args.ok and args.clipboardCleared == true then
            self.hasClipboard = false
            self.safehouseClipboardReady = false
        end
        if not args.ok then
            self.status = args.message or "No se ha podido cancelar la operación."
        end
        return
    end

    if args.action == "copyBlockTeleport" or args.action == "pasteBlockTeleport" or args.action == "pasteFinalizeMove" then
        if self.operationPaused == true then
            return
        end
        local targetX = math.floor(tonumber(args.x) or 0)
        local targetY = math.floor(tonumber(args.y) or 0)
        local targetZ = tonumber(args.z) or 0
        local label = "copia"
        if args.action == "pasteFinalizeMove" then
            label = "finalización"
        elseif args.action == "pasteBlockTeleport" then
            label = args.phase == "paste" and "pegado" or "limpieza"
        end
        local status = "Cargando bloque de " .. label .. " " .. tostring(args.blockIndex or "?") .. "/" .. tostring(args.blockTotal or "?") .. "..."
        if args.action == "pasteFinalizeMove" then
            status = "Moviéndose al centro de la zona para finalizar los sistemas..."
        end
        if args.moveMode == "fast" then
            self:startFastMoveTo(targetX, targetY, targetZ, status)
        elseif isClient and isClient() and SendCommandToServer then
            SendCommandToServer("/teleportto " .. tostring(targetX) .. "," .. tostring(targetY) .. "," .. tostring(targetZ))
        elseif self.character and self.character.teleportTo then
            self.character:teleportTo(targetX + 0.5, targetY + 0.5, targetZ)
        end
        self.status = status
        return
    end

    if args.action == "copyProgress" then
        if self.operationPaused == true then
            return
        end
        self.copyInProgress = true
        self.hasClipboard = false
        self.safehouseClipboardReady = false
        self.spriteCount = tonumber(args.count) or self.spriteCount
        local processed = tonumber(args.processed) or 0
        local total = tonumber(args.total) or 0
        self:updateProgress(processed, total, 0, 100)
        local blockText = ""
        if args.blockIndex and args.blockTotal and tonumber(args.blockTotal) and tonumber(args.blockTotal) > 1 then
            blockText = " bloque " .. tostring(args.blockIndex) .. "/" .. tostring(args.blockTotal) .. " -"
        end
        if args.loadingSource == true then
            self.status = "Cargando origen" .. blockText .. " " .. tostring(args.sourceLoadedCells or 0) .. "/" .. tostring(args.sourceTotalCells or 0) .. " celdas..."
        elseif args.mode == "save" then
            self.status = "Guardando" .. blockText .. " casillas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        else
            self.status = "Escaneando" .. blockText .. " casillas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        end
        return
    end

    if args.action == "savedAreas" then
        if args.ok and args.saves then
            self:populateSavedCombo(args.saves)
            self.status = "Guardados personalizados cargados."
        else
            self.status = args.message or "No se han podido cargar los guardados personalizados."
        end
        return
    end

    if args.action == "safehouseSaves" then
        if args.ok and args.saves then
            self:populateSafehouseSavedCombo(args.saves)
            self.status = "Guardados de casas seguras cargados."
        else
            self.status = args.message or "No se han podido cargar los guardados de casas seguras."
        end
        return
    end

    if args.action == "safehouseExportStart" and args.ok then
        self.safehouseExportInProgress = true
        self.safehouseExportBuffer = {
            sessionId = args.sessionId,
            chunks = {},
            received = 0,
            total = tonumber(args.total) or 1,
            fileName = args.fileName or EBFCopyPaste.SafehouseBackupFileName,
            backupName = args.backupName,
            saveCount = tonumber(args.saveCount) or 0,
        }
        self:setProgressPercent(0)
        self.status = "Exportando la copia de seguridad de casas seguras..."
        return
    end

    if args.action == "safehouseExportChunk" and args.ok then
        local buffer = self.safehouseExportBuffer
        local index = tonumber(args.index)
        if buffer and index and args.sessionId == buffer.sessionId then
            if buffer.chunks[index] == nil then
                buffer.received = buffer.received + 1
            end
            buffer.chunks[index] = args.data or ""
            self:updateProgress(buffer.received, buffer.total, 0, 100)
            self.status = "Recibiendo copia de seguridad " .. tostring(buffer.received) .. "/" .. tostring(buffer.total) .. "..."
        end
        return
    end

    if args.action == "safehouseExportDone" and args.ok then
        local buffer = self.safehouseExportBuffer
        self.safehouseExportInProgress = false
        if not buffer or args.sessionId ~= buffer.sessionId or buffer.received < buffer.total then
            self.safehouseExportBuffer = nil
            self.status = "Exportación incompleta."
            return
        end

        local text = table.concat(buffer.chunks)
        local fileName = buffer.fileName or EBFCopyPaste.SafehouseBackupFileName
        if self:writeSafehouseBackupFile(text, fileName) then
            self:rememberSafehouseBackupFile(fileName, buffer.backupName or fileName, buffer.saveCount)
            self:setProgressPercent(100)
            self.status = "Copia de seguridad exportada: " .. tostring(fileName) .. " (" .. tostring(buffer.saveCount) .. " casas seguras)."
        else
            self.status = "No se ha podido escribir el archivo en el cliente."
        end
        self.safehouseExportBuffer = nil
        return
    end

    if args.action == "savedAreaExportStart" and args.ok then
        self.savedAreaExportInProgress = true
        self.savedAreaExportBuffer = {
            sessionId = args.sessionId,
            chunks = {},
            received = 0,
            total = tonumber(args.total) or 1,
            fileName = args.fileName or EBFCopyPaste.SavedAreaExportFileName,
            saveCount = tonumber(args.saveCount) or 0,
        }
        self:setProgressPercent(0)
        self.status = "Exportando el guardado personalizado..."
        return
    end

    if args.action == "savedAreaExportChunk" and args.ok then
        local buffer = self.savedAreaExportBuffer
        local index = tonumber(args.index)
        if buffer and index and args.sessionId == buffer.sessionId then
            if buffer.chunks[index] == nil then
                buffer.received = buffer.received + 1
            end
            buffer.chunks[index] = args.data or ""
            self:updateProgress(buffer.received, buffer.total, 0, 100)
            self.status = "Recibiendo guardado personalizado " .. tostring(buffer.received) .. "/" .. tostring(buffer.total) .. "..."
        end
        return
    end

    if args.action == "savedAreaExportDone" and args.ok then
        local buffer = self.savedAreaExportBuffer
        self.savedAreaExportInProgress = false
        if not buffer or args.sessionId ~= buffer.sessionId or buffer.received < buffer.total then
            self.savedAreaExportBuffer = nil
            self.status = "Exportación del guardado personalizado incompleta."
            return
        end

        local text = table.concat(buffer.chunks)
        local fileName = buffer.fileName or EBFCopyPaste.SavedAreaExportFileName
        if self:writeSafehouseBackupFile(text, fileName) then
            self:setProgressPercent(100)
            self.status = "Guardado personalizado exportado: " .. tostring(fileName) .. " (" .. tostring(buffer.saveCount) .. " guardados)."
        else
            self.status = "No se ha podido escribir el archivo en el cliente."
        end
        self.savedAreaExportBuffer = nil
        return
    end

    if args.action == "safehouseImportStart" and args.ok then
        if self.safehouseImportSendJob and args.sessionId == self.safehouseImportSendJob.sessionId then
            self.safehouseImportSendJob.started = true
            if self.operationPaused == true then
                self.safehouseImportSendJob.paused = true
            else
                self.status = "Enviando la copia de seguridad al servidor..."
            end
        end
        return
    end

    if args.action == "safehouseImportProgress" and args.ok then
        local processed = tonumber(args.processed) or 0
        local total = tonumber(args.total) or 1
        self:updateProgress(processed, total, 0, 100)
        if self.operationPaused ~= true then
            self.status = "Importando copia de seguridad " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        end
        return
    end

    if args.action == "safehouseImportDone" and args.ok then
        local importJob = self.safehouseImportSendJob
        self.safehouseImportInProgress = false
        self.safehouseImportSendJob = nil
        if args.saves then
            self:populateSafehouseSavedCombo(args.saves)
        end
        self:setProgressPercent(100)
        if importJob and importJob.restoreAfterImport then
            local restoreList = self:getSafehouseSavesByIds(args.importedIds, args.saves)
            if #restoreList > 0 then
                local restoreLabel = tostring(importJob.restoreBackupName or importJob.restoreFileName or "lote importado")
                self.status = "Copia de seguridad importada. Iniciando la restauración del lote: " .. restoreLabel
                self:startSafehouseRestore(restoreList, restoreLabel)
            else
                self.status = "Copia de seguridad importada, pero no se han podido localizar los guardados importados que deben restaurarse."
            end
            return
        end
        self.status = "Copia de seguridad importada: " .. tostring(args.imported or 0) .. " casas seguras."
        return
    end

    if args.action == "safehouseRestoreProgress" then
        if self.operationPaused == true then
            return
        end
        self:updateSafehouseRestoreProgress(args)
        return
    end

    if args.action == "pasteProgress" then
        if self.operationPaused == true then
            return
        end
        self.pasteInProgress = true
        local processed = tonumber(args.processed) or 0
        local total = tonumber(args.total) or 0
        local blockText = ""
        if args.blockIndex and args.blockTotal and tonumber(args.blockTotal) and tonumber(args.blockTotal) > 1 then
            blockText = " bloque " .. tostring(args.blockIndex) .. "/" .. tostring(args.blockTotal) .. " -"
        end
        if args.mode == "blockPaste" then
            self:updateProgress(processed, total, 0, 95)
            if args.phase == "clear" then
                self.status = "Limpiando el destino" .. blockText .. " casillas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
            else
                self.status = "Pegando objetos" .. blockText .. " " .. tostring(processed) .. "/" .. tostring(total) .. "..."
            end
        elseif args.phase == "clear" then
            self:updateProgress(processed, total, 0, 50)
            self.status = "Limpiando el destino" .. blockText .. " casillas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        elseif args.phase == "finalizeRooms" and args.prePasteRooms == true then
            self:updateProgress(processed, total, 45, 5)
            self.status = "Asignando RoomDef y electricidad a las casillas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        elseif args.phase == "clientRoomDefReconcile" then
            self:updateProgress(processed, total, 50, 5)
            self.status = "Sincronizando RoomDef vanilla en el cliente " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        elseif args.phase == "finalizeRooms" or args.phase == "finalizeLights" then
            self:updateProgress(processed, total, 95, 5)
            self.status = "Finalizando sistemas " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        else
            self:updateProgress(processed, total, 50, 50)
            self.status = "Pegando objetos" .. blockText .. " " .. tostring(processed) .. "/" .. tostring(total) .. "..."
        end
        return
    end

    if args.action == "copy" and args.ok then
        self.copyInProgress = false
        if not self.safehouseBackupJob then
            self.operationPaused = false
        end
        self.hasClipboard = true
        self.copiedWidth = tonumber(args.w) or self:getCurrentArea().w
        self.copiedHeight = tonumber(args.h) or self:getCurrentArea().h
        self.spriteCount = tonumber(args.count) or self.spriteCount
        self.safehouseClipboardReady = args.source == "safehouse"
        self.safehouseClipboardTitle = args.safehouseTitle or args.title
        self:setProgressPercent(100)
        if self.safehouseClipboardReady then
            self.status = "Casa segura copiada. Ahora puedes guardarla o seleccionar el destino."
            if self:handleSafehouseBackupCopyDone(args) then
                return
            end
        else
            self.status = "Copia completada. Selecciona el destino."
            if self.safehouseBackupJob then
                self:abortSafehouseBackup("La copia actual no se ha identificado como una casa segura.")
                return
            end
        end
        return
    end

    if args.action == "save" and args.ok then
        self.copyInProgress = false
        self.operationPaused = false
        self.hasClipboard = true
        self.copiedWidth = tonumber(args.w) or self:getCurrentArea().w
        self.copiedHeight = tonumber(args.h) or self:getCurrentArea().h
        self.spriteCount = tonumber(args.count) or self.spriteCount
        if args.saves then
            self:populateSavedCombo(args.saves)
        end
        self.safehouseClipboardReady = args.source == "safehouse"
        self.safehouseClipboardTitle = args.safehouseTitle or args.title
        self:setProgressPercent(100)
        self.status = "Guardado personalizado completado. Selecciona el destino."
        return
    end

    if args.action == "safehouseSaved" and args.ok then
        self.safehouseSaveInProgress = false
        if not self.safehouseBackupJob then
            self.operationPaused = false
        end
        if args.saves then
            self:populateSafehouseSavedCombo(args.saves, args.id)
        end
        self:setProgressPercent(100)
        self.status = "Guardado de casa segura completado."
        if self:handleSafehouseBackupSaveDone(args) then
            return
        end
        return
    end

    if args.action == "savedLoaded" and args.ok then
        self.hasClipboard = true
        self.copyInProgress = false
        self.pasteInProgress = false
        self.copiedWidth = tonumber(args.w) or 1
        self.copiedHeight = tonumber(args.h) or 1
        self.spriteCount = tonumber(args.count) or self.spriteCount
        if args.saves then
            self:populateSavedCombo(args.saves)
        end
        self.safehouseClipboardReady = false
        self:setProgressPercent(100)
        self.status = "Guardado personalizado cargado. Selecciona el destino."
        return
    end

    if args.action == "safehouseSavedLoaded" and args.ok then
        self.hasClipboard = true
        self.copyInProgress = false
        self.pasteInProgress = false
        self.copiedWidth = tonumber(args.w) or 1
        self.copiedHeight = tonumber(args.h) or 1
        self.spriteCount = tonumber(args.count) or self.spriteCount
        self.safehouseClipboardReady = true
        self.safehouseClipboardTitle = args.title
        if args.saves then
            self:populateSafehouseSavedCombo(args.saves)
        end
        self:setProgressPercent(100)
        self.status = "Guardado de casa segura cargado. Selecciona el destino."
        return
    end

    if args.action == "saveDeleted" and args.ok then
        if args.saves then
            self:populateSavedCombo(args.saves)
        end
        self:setProgressPercent(100)
        self.status = "Guardado personalizado eliminado."
        return
    end

    if args.action == "safehouseSaveDeleted" and args.ok then
        if args.saves then
            self:populateSafehouseSavedCombo(args.saves)
        end
        self:setProgressPercent(100)
        self.status = "Guardado de casa segura eliminado."
        return
    end

    if args.action == "safehouseRestoreDone" and args.ok then
        if self:handleSafehouseRestoreDone(args) then
            return
        end
        return
    end

    if args.action == "paste" and args.ok then
        self.pasteInProgress = false
        if not self.safehouseRestoreJob then
            self.operationPaused = false
        end
        self:setProgressPercent(100)
        if args.roomLightWarning == true then
            self.status = "Pegado con aviso: no se pudo verificar RoomLight interior en " .. tostring(args.roomLightWarnings or 0) .. " habitaciones."
        else
            self.status = "Pegado: " .. tostring(args.count or 0) .. " sprites."
        end
        return
    end

    if args.action == "copy" then
        self.copyInProgress = false
        self.safehouseClipboardReady = false
    elseif args.action == "save" then
        self.copyInProgress = false
        self.safehouseClipboardReady = false
    elseif args.action == "paste" then
        self.pasteInProgress = false
    elseif args.action == "savedLoaded" then
        self.copyInProgress = false
        self.pasteInProgress = false
    elseif args.action == "safehouseSaved" then
        self.safehouseSaveInProgress = false
    elseif args.action == "safehouseSavedLoaded" then
        self.copyInProgress = false
        self.pasteInProgress = false
    elseif args.action == "safehouseSaveDeleted" then
        self.safehouseSaveInProgress = false
    elseif args.action == "safehouseExport" then
        self.safehouseExportInProgress = false
        self.safehouseExportBuffer = nil
    elseif args.action == "savedAreaExport" then
        self.savedAreaExportInProgress = false
        self.savedAreaExportBuffer = nil
    elseif args.action == "safehouseImport" then
        self.safehouseImportInProgress = false
        self.safehouseImportSendJob = nil
    elseif args.action == "safehouseRestore" then
        self.pasteInProgress = false
        self.safehouseRestoreWaiting = false
    end
    if self.safehouseBackupJob and (args.action == "copy" or args.action == "safehouseSaved") then
        self:abortSafehouseBackup(args.message or "La copia de seguridad de casas seguras ha fallado.")
        return
    end
    if self.safehouseRestoreJob and args.action == "safehouseRestore" then
        self:abortSafehouseRestore(args.message or "La restauración de casas seguras ha fallado.")
        return
    end
    self.status = args.message or "La operación ha fallado."
end

function EBFCopyPasteUI:hasActiveOperation()
    return self.copyInProgress == true
            or self.pasteInProgress == true
            or self.safehouseSaveInProgress == true
            or self.safehouseExportInProgress == true
            or self.savedAreaExportInProgress == true
            or self.safehouseImportInProgress == true
            or self.safehouseBackupJob ~= nil
            or self.safehouseRestoreJob ~= nil
            or self.pendingSafehouseCopy ~= nil
            or self.pendingSafehouseRestore ~= nil
            or self.safehouseImportSendJob ~= nil
end

function EBFCopyPasteUI:hasServerOperation()
    return self.copyInProgress == true
            or self.pasteInProgress == true
            or self.safehouseExportInProgress == true
            or self.savedAreaExportInProgress == true
            or (self.safehouseImportInProgress == true and self.safehouseImportSendJob and self.safehouseImportSendJob.started == true)
end

function EBFCopyPasteUI:sendJobControl(command, args)
    if self.character and command then
        sendClientCommand(self.character, EBFCopyPaste.Module, command, args or {})
    end
end

function EBFCopyPasteUI:pauseCurrentOperation()
    self.operationPaused = true
    if self.safehouseBackupJob then
        self.safehouseBackupJob.paused = true
    end
    if self.safehouseRestoreJob then
        self.safehouseRestoreJob.paused = true
    end
    if self.safehouseImportSendJob then
        self.safehouseImportSendJob.paused = true
    end
    stopFastMoveState()
    if getCell() then
        getCell():setDrag(nil, self.character:getPlayerNum())
    end
    if self:hasServerOperation() then
        self:sendJobControl(EBFCopyPaste.Commands.PauseCurrentJob)
    end
    self.status = "Operación pausada. Pulsa Continuar para reanudarla o Parar/Cancelar de nuevo para cancelarlo todo."
end

function EBFCopyPasteUI:resumeCurrentOperation()
    if self.operationPaused ~= true then
        return
    end
    self.operationPaused = false
    if self.safehouseBackupJob then
        self.safehouseBackupJob.paused = false
    end
    if self.safehouseRestoreJob then
        self.safehouseRestoreJob.paused = false
    end
    if self.safehouseImportSendJob then
        self.safehouseImportSendJob.paused = false
    end
    if self:hasServerOperation() then
        self:sendJobControl(EBFCopyPaste.Commands.ResumeCurrentJob)
    end
    self.status = "Reanudando la operación..."
    if self.safehouseBackupJob and not self.copyInProgress and not self.safehouseSaveInProgress then
        self:advanceSafehouseBackup()
    elseif self.safehouseRestoreJob and not self.pasteInProgress and not self.safehouseRestoreWaiting then
        self:advanceSafehouseRestore()
    end
end

function EBFCopyPasteUI:cancelAllCurrentState(message)
    self:sendJobControl(EBFCopyPaste.Commands.CancelCurrentJob, { clearClipboard = true })
    stopFastMoveState()
    if getCell() then
        getCell():setDrag(nil, self.character:getPlayerNum())
    end

    if EBFCopyPasteDeleteConfirmDialog.instance then
        EBFCopyPasteDeleteConfirmDialog.instance:close()
    end
    if EBFCopyPasteSavedAreaDialog.instance then
        EBFCopyPasteSavedAreaDialog.instance:close()
    end
    if EBFCopyPasteSaveDialog.instance then
        EBFCopyPasteSaveDialog.instance:close()
    end
    if EBFCopyPasteSafehouseLoadDialog.instance then
        EBFCopyPasteSafehouseLoadDialog.instance:close()
    end
    if EBFCopyPasteBackupSafehouseDialog.instance then
        EBFCopyPasteBackupSafehouseDialog.instance:close()
    end
    if EBFCopyPasteBackupMenuDialog.instance then
        EBFCopyPasteBackupMenuDialog.instance:close()
    end
    if EBFCopyPasteExportBackupDialog.instance then
        EBFCopyPasteExportBackupDialog.instance:close()
    end
    if EBFCopyPasteImportFileDialog.instance then
        EBFCopyPasteImportFileDialog.instance:close()
    end
    if EBFCopyPasteImportBackupConfirmDialog.instance then
        EBFCopyPasteImportBackupConfirmDialog.instance:close()
    end
    if EBFCopyPasteImportBackupDialog.instance then
        EBFCopyPasteImportBackupDialog.instance:close()
    end

    self.operationPaused = false
    self.copyInProgress = false
    self.pasteInProgress = false
    self.safehouseSaveInProgress = false
    self.safehouseExportInProgress = false
    self.safehouseExportBuffer = nil
    self.savedAreaExportInProgress = false
    self.savedAreaExportBuffer = nil
    self.safehouseImportInProgress = false
    self.safehouseImportSendJob = nil
    self.safehouseBackupJob = nil
    self.safehouseRestoreJob = nil
    self.safehouseRestoreWaiting = false
    self.pendingSafehouseRestore = nil
    self.pendingSafehouseRestoreReadyAt = nil
    self.pendingSafehouseCopy = nil
    self.pendingSafehouseAutoCopy = false
    self.pendingSafehouseCopyReadyAt = nil
    self.pendingSafehouseRestoreList = nil
    self.pendingSafehouseRestoreLabel = nil
    self.pendingSafehouseRestoreCount = nil
    self.selectedSafehouseData = nil
    self.selectionActive = false
    self.selectionLocked = false
    self.hasClipboard = false
    self.safehouseClipboardReady = false
    self.safehouseClipboardTitle = nil
    self.spriteCount = 0
    self.spriteCountAreaKey = nil
    self.spriteCountTileIndex = 1
    self.spriteCountValue = 0
    self.spriteCountComplete = false
    self.nextCountTime = 0
    if self.safehouseCombo then
        self.safehouseCombo.selected = 1
    end
    if self.savedCombo then
        self.savedCombo.selected = 1
    end
    if self.safehouseSavedCombo then
        self.safehouseSavedCombo.selected = 1
    end
    self:setProgressPercent(0)
    self.status = message or "Operación y selecciones actuales canceladas. Pulsa Iniciar selección."
end

function EBFCopyPasteUI:cancelCurrentAction()
    if self.operationPaused == true then
        self:cancelAllCurrentState("Operación pausada cancelada. Se han borrado la selección y la copia actuales.")
        return
    end

    if self:hasActiveOperation() then
        self:pauseCurrentOperation()
        return
    end

    if EBFCopyPasteDeleteConfirmDialog.instance then
        EBFCopyPasteDeleteConfirmDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteSavedAreaDialog.instance then
        EBFCopyPasteSavedAreaDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteSaveDialog.instance then
        EBFCopyPasteSaveDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteSafehouseLoadDialog.instance then
        EBFCopyPasteSafehouseLoadDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteBackupSafehouseDialog.instance then
        EBFCopyPasteBackupSafehouseDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteBackupMenuDialog.instance then
        EBFCopyPasteBackupMenuDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteExportBackupDialog.instance then
        EBFCopyPasteExportBackupDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteImportFileDialog.instance then
        EBFCopyPasteImportFileDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteImportBackupConfirmDialog.instance then
        EBFCopyPasteImportBackupConfirmDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end
    if EBFCopyPasteImportBackupDialog.instance then
        EBFCopyPasteImportBackupDialog.instance:close()
        self.status = "Acción cancelada."
        return
    end

    if self.copyInProgress or self.pasteInProgress then
        self.status = "Espera a que termine la operación actual."
        return
    end

    if self.safehouseRestoreJob then
        if self.safehouseRestoreWaiting then
            self.status = "Espera a que termine la restauración actual."
        else
            self:abortSafehouseRestore("Restauración cancelada.")
        end
        return
    end

    if getCell() then
        getCell():setDrag(nil, self.character:getPlayerNum())
    end

    if self.safehouseCombo then
        self.safehouseCombo.selected = 1
    end
    self.selectedSafehouseData = nil
    self.pendingSafehouseCopy = nil
    self.pendingSafehouseAutoCopy = false
    self.pendingSafehouseCopyReadyAt = nil
    self.selectionActive = false
    self.selectionLocked = false
    self.spriteCount = 0
    self:setProgressPercent(0)
    self.nextCountTime = 0
    self.status = "Acción cancelada. Pulsa Iniciar selección."
end

function EBFCopyPasteUI:onClick(button)
    if button.internal == "CANCEL" then
        self:cancelCurrentAction()
        return
    end
    if button.internal == "RESUME" then
        self:resumeCurrentOperation()
        return
    end
    if button.internal == "CLOSE" then
        self:close()
        return
    end
    if button.internal == "STARTINGPOINT" then
        self.safehouseCombo.selected = 1
        self:startSelection()
        return
    end
    if button.internal == "CONFIRM" then
        self:confirmSelection()
        return
    end
    if button.internal == "COPY" then
        self:copySelection()
        return
    end
    if button.internal == "SAVE" then
        self:openSaveDialog()
        return
    end
    if button.internal == "BACKUP_MENU" then
        EBFCopyPasteBackupMenuDialog.open(self)
        return
    end
    if button.internal == "SAVE_SAFEHOUSE" then
        self:saveSafehouseClipboard()
        return
    end
    if button.internal == "BACKUP_SAFEHOUSE" then
        self:openSafehouseBackupWarning()
        return
    end
    if button.internal == "EXPORT_SAFEHOUSE_BACKUP" then
        self:requestSafehouseBackupExport()
        return
    end
    if button.internal == "IMPORT_SAFEHOUSE_BACKUP" then
        self:requestSafehouseBackupImport()
        return
    end
    if button.internal == "RESTORE_SAFEHOUSE_BACKUP" then
        self:requestSafehouseBackupRestore()
        return
    end
    if button.internal == "PICK_DESTINATION" then
        self:startPasteCursor()
        return
    end
end

function EBFCopyPasteUI:close()
    if EBFCopyPasteDeleteConfirmDialog.instance then
        EBFCopyPasteDeleteConfirmDialog.instance:close()
    end
    if EBFCopyPasteSavedAreaDialog.instance then
        EBFCopyPasteSavedAreaDialog.instance:close()
    end
    if EBFCopyPasteSaveDialog.instance then
        EBFCopyPasteSaveDialog.instance:close()
    end
    if EBFCopyPasteSafehouseLoadDialog.instance then
        EBFCopyPasteSafehouseLoadDialog.instance:close()
    end
    if EBFCopyPasteBackupSafehouseDialog.instance then
        EBFCopyPasteBackupSafehouseDialog.instance:close()
    end
    if EBFCopyPasteBackupMenuDialog.instance then
        EBFCopyPasteBackupMenuDialog.instance:close()
    end
    if EBFCopyPasteExportBackupDialog.instance then
        EBFCopyPasteExportBackupDialog.instance:close()
    end
    if EBFCopyPasteImportFileDialog.instance then
        EBFCopyPasteImportFileDialog.instance:close()
    end
    if EBFCopyPasteImportBackupConfirmDialog.instance then
        EBFCopyPasteImportBackupConfirmDialog.instance:close()
    end
    if EBFCopyPasteImportBackupDialog.instance then
        EBFCopyPasteImportBackupDialog.instance:close()
    end
    self:setVisible(false)
    self:removeFromUIManager()
    EBFCopyPasteUI.instance = nil
end

function EBFCopyPasteUI:new(x, y, width, height, character)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.width = width
    o.height = height
    o.character = character
    o.moveWithMouse = true
    o.X1 = math.floor(character:getX())
    o.Y1 = math.floor(character:getY())
    o.X2 = o.X1
    o.Y2 = o.Y1
    o.Z = math.floor(character:getZ())
    o.selectionActive = false
    o.selectionLocked = false
    o.hasClipboard = false
    o.copyInProgress = false
    o.pasteInProgress = false
    o.operationPaused = false
    o.safehouseSaveInProgress = false
    o.safehouseClipboardReady = false
    o.safehouseClipboardTitle = nil
    o.selectedSafehouseData = nil
    o.pendingSafehouseCopy = nil
    o.pendingSafehouseAutoCopy = false
    o.pendingSafehouseCopyReadyAt = nil
    o.safehouseBackupJob = nil
    o.safehouseRestoreJob = nil
    o.pendingSafehouseRestore = nil
    o.pendingSafehouseRestoreReadyAt = nil
    o.safehouseRestoreWaiting = false
    o.safehouseExportInProgress = false
    o.safehouseExportBuffer = nil
    o.savedAreaExportInProgress = false
    o.savedAreaExportBuffer = nil
    o.safehouseImportInProgress = false
    o.safehouseImportSendJob = nil
    o.spriteCount = 0
    o.spriteCountAreaKey = nil
    o.spriteCountTileIndex = 1
    o.spriteCountValue = 0
    o.spriteCountComplete = false
    o.savedAreas = {}
    o.safehouseSaves = {}
    o.status = "Pulsa Iniciar selección."
    o.progressPercent = 0
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }
    EBFCopyPasteUI.instance = o
    return o
end

local function getReconcileZOffsets(args)
    local offsets = {}
    if type(args and args.zOffsets) == "table" then
        for _, value in ipairs(args.zOffsets) do
            local offset = tonumber(value)
            if offset ~= nil then
                table.insert(offsets, math.floor(offset))
            end
        end
    end
    if #offsets <= 0 then
        local levels = math.max(1, math.floor(tonumber(args and args.levels) or 1))
        for offset = 0, levels - 1 do
            table.insert(offsets, offset)
        end
    end
    return offsets
end

local function recalcClientSquareAfterReconcile(square)
    if not square then
        return
    end
    if square.RecalcProperties then
        pcall(function()
            square:RecalcProperties()
        end)
    end
    if square.RecalcAllWithNeighbours then
        pcall(function()
            square:RecalcAllWithNeighbours(true)
        end)
    end
    if square.invalidateRenderChunkLevel then
        pcall(function()
            square:invalidateRenderChunkLevel(64)
        end)
    end
end

local function getOrCreateClientSquare(cell, x, y, z)
    if not cell then
        return nil, false
    end

    local square = nil
    if cell.getGridSquare then
        local okSquare, existing = pcall(function()
            return cell:getGridSquare(x, y, z)
        end)
        if okSquare then
            square = existing
        end
    end
    if square then
        return square, false
    end

    if getWorld and getWorld() and getWorld().isValidSquare then
        local okValid, valid = pcall(function()
            return getWorld():isValidSquare(x, y, z)
        end)
        if okValid and valid == false then
            return nil, false
        end
    end

    local okCreate, created = pcall(function()
        return cell:getOrCreateGridSquare(x, y, z)
    end)
    if okCreate and created then
        return created, true
    end
    return nil, false
end

local function getClientReconcileBounds(args)
    local baseX = math.floor(tonumber(args and args.x) or 0)
    local baseY = math.floor(tonumber(args and args.y) or 0)
    local baseZ = math.floor(tonumber(args and args.z) or 0)
    local width = math.max(1, math.floor(tonumber(args and args.w) or 1))
    local height = math.max(1, math.floor(tonumber(args and args.h) or 1))
    return baseX, baseY, baseZ, width, height
end

local function clientRoomRectIntersectsArea(args, offsets, room, rect)
    if not room or not rect then
        return false
    end

    local baseX, baseY, baseZ, width, height = getClientReconcileBounds(args)
    local okLevel, level = pcall(function()
        return room:getLevel()
    end)
    if not okLevel then
        return false
    end

    local zMatches = false
    for _, dz in ipairs(offsets or { 0 }) do
        if tonumber(level) == baseZ + math.floor(tonumber(dz) or 0) then
            zMatches = true
            break
        end
    end
    if not zMatches then
        return false
    end

    local okRect, rectX, rectY, rectW, rectH = pcall(function()
        return rect:getX(), rect:getY(), rect:getW(), rect:getH()
    end)
    if not okRect then
        return false
    end

    rectX = math.floor(tonumber(rectX) or 0)
    rectY = math.floor(tonumber(rectY) or 0)
    rectW = math.max(1, math.floor(tonumber(rectW) or 1))
    rectH = math.max(1, math.floor(tonumber(rectH) or 1))

    return rectX < baseX + width
            and rectX + rectW > baseX
            and rectY < baseY + height
            and rectY + rectH > baseY
end

local function setClientCurrentBuilding(editor, building)
    if editor and building and editor.setCurrentBuilding then
        pcall(function()
            editor:setCurrentBuilding(building)
        end)
    end
end

local function setClientCurrentRoom(editor, room)
    if editor and room and editor.setCurrentRoom then
        pcall(function()
            editor:setCurrentRoom(room)
        end)
    end
end

local function clearClientRoomDefsAtReconcileArea(editor, args, offsets)
    if not editor then
        return 0
    end

    local okCount, buildingCount = pcall(function()
        return editor:getBuildingCount()
    end)
    if not okCount then
        return 0
    end

    local changed = 0
    for buildingIndex = math.max(0, math.floor(tonumber(buildingCount) or 0)) - 1, 0, -1 do
        local okBuilding, building = pcall(function()
            return editor:getBuildingByIndex(buildingIndex)
        end)
        if okBuilding and building then
            local okRoomCount, roomCount = pcall(function()
                return building:getRoomCount()
            end)
            for roomIndex = math.max(0, math.floor(tonumber(okRoomCount and roomCount or 0) or 0)) - 1, 0, -1 do
                local okRoom, room = pcall(function()
                    return building:getRoomByIndex(roomIndex)
                end)
                if okRoom and room then
                    local okRectCount, rectCount = pcall(function()
                        return room:getRectangleCount()
                    end)
                    for rectIndex = math.max(0, math.floor(tonumber(okRectCount and rectCount or 0) or 0)) - 1, 0, -1 do
                        local okRect, rect = pcall(function()
                            return room:getRectangle(rectIndex)
                        end)
                        if okRect and clientRoomRectIntersectsArea(args, offsets, room, rect) then
                            local okRemove = pcall(function()
                                room:removeRectangle(rectIndex)
                            end)
                            if okRemove then
                                changed = changed + 1
                            end
                        end
                    end

                    local okRemaining, remaining = pcall(function()
                        return room:getRectangleCount()
                    end)
                    if okRemaining and (tonumber(remaining) or 0) <= 0 then
                        pcall(function()
                            building:removeRoom(room)
                        end)
                    end
                end
            end

            local okRemainingRooms, remainingRooms = pcall(function()
                return building:getRoomCount()
            end)
            if okRemainingRooms and (tonumber(remainingRooms) or 0) <= 0 then
                pcall(function()
                    editor:removeBuilding(building)
                end)
            end
        end
    end
    return changed
end

local function applyClientRoomDefsFromReconcile(args)
    local expectedRooms = 0
    local expectedRects = 0
    if type(args and args.roomSpecs) == "table" then
        expectedRooms = #args.roomSpecs
        for _, spec in ipairs(args.roomSpecs) do
            expectedRects = expectedRects + #(spec.rects or {})
        end
    end
    print("[EBFCopyPaste] RoomDef gestionado por el servidor: BuildingRoomsEditor no se aplicará en el cliente"
            .. " habitacionesEsperadas=" .. tostring(expectedRooms)
            .. " rectángulosEsperados=" .. tostring(expectedRects)
            .. " motivo=" .. tostring(args and args.reason or "?"))
    return 0, 0, 0, 0
end

local function reloadClientLightSwitchChunksForReconcile(cell, baseX, baseY, baseZ, width, height, offsets)
    if not cell or not IsoLightSwitch or not IsoLightSwitch.chunkLoaded then
        return 0
    end

    local seen = {}
    local chunks = 0
    for _, dz in ipairs(offsets or { 0 }) do
        local z = baseZ + math.floor(tonumber(dz) or 0)
        for y = baseY, baseY + height - 1 do
            for x = baseX, baseX + width - 1 do
                local square = getOrCreateClientSquare(cell, x, y, z)
                local chunk = nil
                if square then
                    pcall(function()
                        chunk = square:getChunk()
                    end)
                end
                if chunk and not seen[chunk] then
                    seen[chunk] = true
                    local ok = pcall(function()
                        IsoLightSwitch.chunkLoaded(chunk)
                    end)
                    if ok then
                        chunks = chunks + 1
                    end
                end
            end
        end
    end
    return chunks
end

local pendingPasteAreaReconciles = {}

local function isPasteAreaReconcileReason(reason)
    reason = tostring(reason or "")
    return reason == "pasteStart"
            or reason == "restoreStart"
            or reason == "roomDefsApplied"
            or reason == "postFinalSync"
            or reason == "pasteDone"
            or reason == "restoreDone"
            or reason == "rollbackFailedPaste"
            or string.sub(reason, 1, 11) == "pasteStart:"
            or string.sub(reason, 1, 13) == "restoreStart:"
            or string.sub(reason, 1, 15) == "roomDefsApplied"
            or string.sub(reason, 1, 14) == "postFinalSync:"
            or string.sub(reason, 1, 10) == "pasteDone:"
            or string.sub(reason, 1, 12) == "restoreDone:"
            or string.sub(reason, 1, 20) == "rollbackFailedPaste:"
end

local function shouldApplyClientRoomDefsForReconcile(reason)
    -- The server owns RoomDef/BuildingRoomsEditor writes. Applying the same
    -- rectangles on the client can crash IsoRegions while server-owned
    -- buildings are being processed.
    return false
end

local function getClientCommandPlayer()
    if getPlayer then
        local player = getPlayer()
        if player then
            return player
        end
    end
    if getSpecificPlayer then
        for index = 0, 3 do
            local player = getSpecificPlayer(index)
            if player then
                return player
            end
        end
    end
    return nil
end

local function sendClientRoomDefReconcileAck(args, result)
    if tostring(args and args.reason or "") ~= "roomDefsApplied" then
        return
    end
    if not sendClientCommand or not EBFCopyPaste.Commands.RoomDefReconcileAck then
        return
    end

    local player = getClientCommandPlayer()
    if not player then
        print("[EBFCopyPaste] ACK RoomDef cliente no enviado: jugador local no disponible.")
        return
    end

    result = result or {}
    sendClientCommand(player, EBFCopyPaste.Module, EBFCopyPaste.Commands.RoomDefReconcileAck, {
        id = args.roomDefReconcileId,
        ok = result.ok == true,
        roomDefs = tonumber(result.roomDefs) or 0,
        roomRects = tonumber(result.roomRects) or 0,
        removedRoomRects = tonumber(result.removedRoomRects) or 0,
        skippedRoomRects = tonumber(result.skippedRoomRects) or 0,
        expectedRoomDefs = tonumber(result.expectedRoomDefs) or 0,
        expectedRoomRects = tonumber(result.expectedRoomRects) or 0,
        serverOwnedRoomDefs = result.serverOwnedRoomDefs == true,
        reason = tostring(args.reason or ""),
        message = tostring(result.message or ""),
    })
end

local function sendClientPasteVisualAck(args, result)
    local reason = tostring(args and args.reason or "")
    if reason ~= "pasteDone" and reason ~= "restoreDone" then
        return
    end
    if not sendClientCommand or not EBFCopyPaste.Commands.PasteVisualAck then
        return
    end

    local player = getClientCommandPlayer()
    if not player then
        print("[EBFCopyPaste] ACK visual final no enviado: jugador local no disponible.")
        return
    end

    result = result or {}
    sendClientCommand(player, EBFCopyPaste.Module, EBFCopyPaste.Commands.PasteVisualAck, {
        id = args.finalClientAckId,
        ok = result.ok == true,
        reason = reason,
        squares = tonumber(result.squares) or 0,
        materializedSquares = tonumber(result.materializedSquares) or 0,
        chunksLight = tonumber(result.chunksLight) or 0,
        expectedSquares = tonumber(args.expectedSquares) or 0,
        expectedObjects = tonumber(args.expectedObjects) or 0,
        expectedRoomDefs = tonumber(args.expectedRoomDefs) or 0,
        expectedRoomRects = tonumber(args.expectedRoomRects) or 0,
        message = tostring(result.message or ""),
    })
end

local function countExpectedClientRoomDefRects(args)
    local expectedRooms = 0
    local expectedRects = 0
    if type(args and args.roomSpecs) == "table" then
        expectedRooms = #args.roomSpecs
        for _, spec in ipairs(args.roomSpecs) do
            expectedRects = expectedRects + #(spec.rects or {})
        end
    end
    return expectedRooms, expectedRects
end

local function reconcilePasteArea(args)
    args = args or {}
    if not isPasteAreaReconcileReason(args.reason) then
        return nil
    end

    if EBFCopyPaste.LightSwitchGuard and EBFCopyPaste.LightSwitchGuard.markReconcileArea then
        pcall(function()
            EBFCopyPaste.LightSwitchGuard.markReconcileArea(args)
        end)
    end

    local expectedRooms, expectedRects = countExpectedClientRoomDefRects(args)
    local roomDefs = 0
    local roomRects = 0
    local removedRoomRects = 0
    local skippedRoomRects = 0
    if shouldApplyClientRoomDefsForReconcile(args.reason) then
        roomDefs, roomRects, removedRoomRects, skippedRoomRects = applyClientRoomDefsFromReconcile(args)
    end

    local cell = getCell and getCell() or nil
    if not cell or not cell.getGridSquare then
        return {
            ok = false,
            squares = 0,
            materializedSquares = 0,
            roomDefs = roomDefs,
            roomRects = roomRects,
            removedRoomRects = removedRoomRects,
            skippedRoomRects = skippedRoomRects,
            expectedRoomDefs = expectedRooms,
            expectedRoomRects = expectedRects,
            chunksLight = 0,
            message = "celda no disponible",
        }
    end

    local baseX = math.floor(tonumber(args.x) or 0)
    local baseY = math.floor(tonumber(args.y) or 0)
    local baseZ = math.floor(tonumber(args.z) or 0)
    local width = math.max(1, math.floor(tonumber(args.w) or 1))
    local height = math.max(1, math.floor(tonumber(args.h) or 1))
    local offsets = getReconcileZOffsets(args)
    local squares = 0
    local materializedSquares = 0

    for _, dz in ipairs(offsets) do
        local z = baseZ + dz
        for y = baseY, baseY + height - 1 do
            for x = baseX, baseX + width - 1 do
                local square, materialized = getOrCreateClientSquare(cell, x, y, z)
                if square then
                    squares = squares + 1
                    if materialized then
                        materializedSquares = materializedSquares + 1
                    end
                    recalcClientSquareAfterReconcile(square)
                end
            end
        end
    end

    local chunks = reloadClientLightSwitchChunksForReconcile(cell, baseX, baseY, baseZ, width, height, offsets)
    print("[EBFCopyPaste] reconcilePasteArea cliente: recalculados="
            .. tostring(squares)
            .. " materializados=" .. tostring(materializedSquares)
            .. " roomDefs=" .. tostring(roomDefs or 0)
            .. " roomRects=" .. tostring(roomRects or 0)
            .. " roomRectsEliminados=" .. tostring(removedRoomRects or 0)
            .. " roomRectsOmitidos=" .. tostring(skippedRoomRects or 0)
            .. " chunksLight=" .. tostring(chunks)
            .. " area=" .. tostring(baseX) .. "," .. tostring(baseY) .. "," .. tostring(baseZ)
            .. " tamaño=" .. tostring(width) .. "x" .. tostring(height)
            .. " motivo=" .. tostring(args.reason or "?"))
    local applyRoomDefs = shouldApplyClientRoomDefsForReconcile(args.reason)
    local ok = not applyRoomDefs
            or (expectedRooms > 0
                    and roomDefs >= expectedRooms
                    and roomRects >= math.max(1, expectedRects)
                    and (tonumber(skippedRoomRects) or 0) <= 0)
    return {
        ok = ok,
        squares = squares,
        materializedSquares = materializedSquares,
        roomDefs = roomDefs,
        roomRects = roomRects,
        removedRoomRects = removedRoomRects,
        skippedRoomRects = skippedRoomRects,
        expectedRoomDefs = expectedRooms,
        expectedRoomRects = expectedRects,
        serverOwnedRoomDefs = not applyRoomDefs and expectedRooms > 0,
        chunksLight = chunks,
        message = ok and (applyRoomDefs and "ok" or "RoomDef gestionado por el servidor; cliente recalculado") or "RoomDef del cliente incompleto",
    }
end

local function queueDelayedPasteAreaReconcile(args)
    if not args then
        return
    end

    local reason = tostring(args.reason or "")
    if reason ~= "postFinalSync"
            and reason ~= "pasteDone"
            and reason ~= "restoreDone"
            and reason ~= "rollbackFailedPaste" then
        return
    end

    local queued = {}
    for key, value in pairs(args) do
        if key == "zOffsets" and type(value) == "table" then
            queued.zOffsets = {}
            for index, offset in ipairs(value) do
                queued.zOffsets[index] = offset
            end
        elseif key ~= "roomSpecs" and key ~= "roomSpecVersion" then
            queued[key] = value
        end
    end

    queued.reason = reason .. ":delayed"
    table.insert(pendingPasteAreaReconciles, {
        args = queued,
        ticksUntilNext = 20,
        repeatsLeft = 3,
    })
end

local function processDelayedPasteAreaReconciles()
    for index = #pendingPasteAreaReconciles, 1, -1 do
        local task = pendingPasteAreaReconciles[index]
        task.ticksUntilNext = (tonumber(task.ticksUntilNext) or 0) - 1
        if task.ticksUntilNext <= 0 then
            local ok, err = pcall(function()
                reconcilePasteArea(task.args)
            end)
            if not ok then
                print("[EBFCopyPaste] reconcilePasteArea delayed ha fallado: " .. tostring(err))
            end
            task.repeatsLeft = (tonumber(task.repeatsLeft) or 1) - 1
            if task.repeatsLeft <= 0 then
                table.remove(pendingPasteAreaReconciles, index)
            else
                task.ticksUntilNext = 10
            end
        end
    end
end

local function onServerCommand(module, command, args)
    if module ~= EBFCopyPaste.Module then
        return
    end

    if command == EBFCopyPaste.Commands.ReconcilePasteArea then
        local ok, result = pcall(function()
            return reconcilePasteArea(args)
        end)
        if not ok then
            local expectedRooms, expectedRects = countExpectedClientRoomDefRects(args)
            print("[EBFCopyPaste] reconcilePasteArea cliente ha fallado: " .. tostring(result))
            result = {
                ok = false,
                roomDefs = 0,
                roomRects = 0,
                removedRoomRects = 0,
                skippedRoomRects = expectedRects,
                expectedRoomDefs = expectedRooms,
                expectedRoomRects = expectedRects,
                squares = 0,
                materializedSquares = 0,
                chunksLight = 0,
                message = tostring(result),
            }
        end
        sendClientRoomDefReconcileAck(args, result)
        sendClientPasteVisualAck(args, result)
        if ok then
            queueDelayedPasteAreaReconcile(args)
        end
        return
    end

    if command ~= EBFCopyPaste.Commands.Feedback then
        return
    end

    if EBFCopyPasteUI.instance then
        EBFCopyPasteUI.instance:onServerFeedback(args)
    end
end

local function onClientTick()
    processDelayedPasteAreaReconciles()

    if EBFCopyPasteUI.instance then
        EBFCopyPasteUI.instance:updatePendingSafehouseCopy()
        EBFCopyPasteUI.instance:updatePendingSafehouseRestore()
        EBFCopyPasteUI.instance:updateSafehouseImportSender()
    end
end

Events.OnServerCommand.Add(onServerCommand)
if Events.OnTick then
    Events.OnTick.Add(onClientTick)
end
