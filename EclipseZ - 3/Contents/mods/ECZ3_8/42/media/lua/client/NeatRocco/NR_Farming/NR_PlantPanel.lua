-- NR_PlantPanel.lua
-- Ventana NeatUI para la información del cultivo.
-- Compatible con la cadena vanilla de ISFarmingInfo y protegida frente a errores
-- de cultivos personalizados o parches de terceros.

require "NeatRocco/NR_Utils/NR_BasePanel"
require "NeatRocco/NR_Utils/NR_CollapseUtils"
require "NeatRocco/NR_Config"

NR_PlantPanel = ISFarmingInfo:derive("NR_PlantPanel")
NR_PlantPanel.panels = NR_PlantPanel.panels or {} -- indexado por personaje

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local VALUE_GAP = 10

local DRAW_HOOK_KEYS = {
    "drawText",
    "drawTextRight",
    "drawRect",
    "drawRectBorder",
    "drawTextureScaled",
    "setHeightAndParentHeight",
}

local function NR_traceback(err)
    local message = tostring(err)
    if debug and debug.traceback then
        return debug.traceback(message, 2)
    end
    return message
end

local function NR_safePlantTexture(plant)
    if not plant or not plant.typeOfSeed then return nil end

    local ok, icon = pcall(function()
        local props = farming_vegetableconf
            and farming_vegetableconf.props
            and farming_vegetableconf.props[plant.typeOfSeed]
        return props and props.icon or nil
    end)
    if not ok or not icon then return nil end

    local textureOK, texture = pcall(getTexture, icon)
    if textureOK then return texture end
    return nil
end

local function NR_reportFatal(panel, stage, err)
    if panel._fatalHandled then return end
    panel._fatalHandled = true

    local message = tostring(err)
    if type(NR_FarmingUI_DisableForSession) == "function" then
        NR_FarmingUI_DisableForSession(stage, message)
    else
        print("[ECZ3_8][NeatRocco][Farming] Error en " .. tostring(stage) .. ": " .. message)
        pcall(function() panel:close() end)
    end
end

-- ----------------------------------------------------------------------------------------------------- --
-- Anchura
-- ----------------------------------------------------------------------------------------------------- --

local function computeKeyW()
    local tm = getTextManager()
    local sep = tm:MeasureStringX(UIFont.Small, " : ")
    local labels = {
        getText("Farming_Current_growing_phase"),
        getText("Farming_Next_growing_phase"),
        "hoursElapsed",
        getText("Farming_Fertilized"),
        getText("Farming_Compost"),
        getText("Farming_Health"),
        getText("Farming_Aphid"),
        getText("Farming_Mildew"),
        getText("Farming_Pest_Flies"),
        getText("Farming_Slugs"),
        getText("Farming_Water_levels"),
    }
    local maxW = 0
    for _, label in ipairs(labels) do
        maxW = math.max(maxW, tm:MeasureStringX(UIFont.Small, tostring(label or "")))
    end
    return maxW + sep
end

local function computeValueW()
    local tm = getTextManager()
    local values = {
        getText("Farming_Flourishing"),
        getText("Farming_Verdant"),
        getText("Farming_Healthy"),
        getText("Farming_Sickly"),
        getText("Farming_Dying"),
        getText("Farming_Dead"),
        getText("Farming_Well_watered"),
        getText("Farming_Fine"),
        getText("Farming_Thirsty"),
        getText("Farming_Dry"),
        getText("Farming_Parched"),
        getText("Farming_Compost_True"),
        getText("Farming_Compost_False"),
        getText("Farming_Fertilizer_TooMuch"),
        getText("Farming_Light"),
        getText("Farming_Moderate"),
        getText("Farming_Heavy"),
        getText("UI_FriendState_Unknown"),
    }
    local maxW = 0
    for _, value in ipairs(values) do
        maxW = math.max(maxW, tm:MeasureStringX(UIFont.Small, tostring(value or "")))
    end
    return maxW
end

-- ----------------------------------------------------------------------------------------------------- --
-- Constructor
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:new(x, y, character, plant)
    if not character or not plant then
        error("NR_PlantPanel:new requiere personaje y cultivo")
    end

    local pad = NR_Config.padding
    local keyW = computeKeyW()
    local width = pad + keyW + VALUE_GAP + computeValueW() + pad
    local height = NR_Config.headerHeight + NR_Config.padding * 4

    local o = ISPanelJoypad.new(self, x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.character = character
    o.playerNum = character:getPlayerNum()
    o.plant = plant
    o.vegetable = NR_safePlantTexture(plant)
    o._keyW = keyW
    o._closed = false
    o._fatalHandled = false
    o._drawHooksActive = false
    o._drawHookSaved = nil

    NR_CollapseUtils.init(o)
    NR_BasePanel.initBase(o)

    NR_PlantPanel.panels[character] = o
    return o
end

-- ----------------------------------------------------------------------------------------------------- --
-- Identidad y cultivo
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:getWindowTitle()
    local plant = self.plant
    if plant and plant.typeOfSeed then
        local ok, text = pcall(getText, "Farming_" .. tostring(plant.typeOfSeed))
        if ok and text then return text end
    end
    return getText("Farming_Plant_Information")
end

function NR_PlantPanel:getWindowIcon()
    return self.vegetable
end

function NR_PlantPanel:setPlant(plant)
    if not plant then error("se intentó mostrar un cultivo nulo") end
    self.plant = plant
    self.vegetable = NR_safePlantTexture(plant)
    self._fatalHandled = false
end

-- ----------------------------------------------------------------------------------------------------- --
-- Anchura dinámica
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:updateDynamicWidth()
    if not self.header then return end

    local tm = getTextManager()
    local hh = NR_Config.headerHeight
    local pad = NR_Config.padding
    local iconSize = math.floor((hh * 0.8) / 4) * 4
    local minW = iconSize + pad * 2
        + tm:MeasureStringX(UIFont.Medium, tostring(self:getWindowTitle() or "")) + pad * 2
        + NR_Config.buttonSize + pad

    if minW > self.width then
        self:setWidth(minW)
        self.header:setWidth(minW)
        self.header:calculateLayout(minW, hh)
    end
end

-- ----------------------------------------------------------------------------------------------------- --
-- Validez
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:isPlantValid()
    local plant = self.plant
    if not plant then return false end

    local updateOK = pcall(function()
        plant:updateFromIsoObject()
    end)
    if not updateOK then return false end

    local objectOK, object = pcall(function()
        return plant:getIsoObject()
    end)
    return objectOK and object ~= nil
end

-- ----------------------------------------------------------------------------------------------------- --
-- Ciclo de vida
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:createChildren()
    NR_BasePanel.createChildren(self)
end

function NR_PlantPanel:prerender()
    if self._closed then return end
    if not self:isPlantValid() then
        self:close()
        return
    end

    local ok, err = xpcall(function()
        ISFarmingInfo.prerender(self)

        if not NR_CollapseUtils.isBodyVisible(self) then return end
        self:updateDynamicWidth()
        NR_BasePanel.prerender(self)
    end, NR_traceback)

    if not ok then NR_reportFatal(self, "prerender", err) end
end

-- ----------------------------------------------------------------------------------------------------- --
-- Intercepción segura del render vanilla
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:_restoreDrawHooks()
    if not self._drawHooksActive then return end

    local saved = self._drawHookSaved or {}
    for _, key in ipairs(DRAW_HOOK_KEYS) do
        rawset(self, key, saved[key])
    end

    self._drawHooksActive = false
    self._drawHookSaved = nil
end

function NR_PlantPanel:_collectVanillaDrawOps()
    local ops = {}
    local pendLbl = nil
    local pendLR, pendLG, pendLB = 1, 1, 1

    local saved = {}
    for _, key in ipairs(DRAW_HOOK_KEYS) do
        saved[key] = rawget(self, key)
    end
    self._drawHookSaved = saved
    self._drawHooksActive = true

    self.drawText = function(_, text, x, _, r, g, b)
        local numericX = tonumber(x) or 0
        if numericX > 50 then return end

        if pendLbl then
            ops[#ops + 1] = {
                t = "text",
                text = tostring(pendLbl or ""),
                r = pendLR,
                g = pendLG,
                b = pendLB,
            }
        end

        pendLbl = tostring(text or "")
        pendLR, pendLG, pendLB = r or 1, g or 1, b or 1
    end

    self.drawTextRight = function(_, text, _, _, r, g, b)
        local value = tostring(text or "")
        if pendLbl then
            ops[#ops + 1] = {
                t = "row",
                lbl = tostring(pendLbl or ""),
                val = value,
                vr = r or 1,
                vg = g or 1,
                vb = b or 1,
            }
            pendLbl = nil
        else
            ops[#ops + 1] = {
                t = "val",
                val = value,
                vr = r or 1,
                vg = g or 1,
                vb = b or 1,
            }
        end
    end

    self.drawRect = function(_, x, _, w, h, _, r, g, b)
        if tonumber(x) == 14 and tonumber(h) == 10 then
            local totalW = math.max(1, (tonumber(self.width) or 0) - 27)
            local pct = (tonumber(w) or 0) / totalW
            pct = math.max(0, math.min(1, pct))
            ops[#ops + 1] = {
                t = "bar",
                pct = pct,
                r = r or 0.15,
                g = g or 0.3,
                b = b or 0.63,
            }
        end
    end

    self.drawRectBorder = function() end
    self.drawTextureScaled = function() end
    self.setHeightAndParentHeight = function() end

    local ok, err = xpcall(function()
        ISFarmingInfo.render(self)
    end, NR_traceback)

    -- Restauración tipo finally: se ejecuta tanto con éxito como con error.
    self:_restoreDrawHooks()

    if not ok then return nil, err end

    if pendLbl then
        ops[#ops + 1] = {
            t = "text",
            text = tostring(pendLbl or ""),
            r = pendLR,
            g = pendLG,
            b = pendLB,
        }
    end

    return ops, nil
end

function NR_PlantPanel:_renderBody()
    ISPanelJoypad.render(self)

    local pad = NR_Config.padding
    local lh = NR_Config.lineHeight
    local barH = NR_Config.barHeight
    local textOffY = math.floor((lh - FONT_HGT_SMALL) / 2)
    local xPivot = pad + self._keyW
    local valX = xPivot + VALUE_GAP

    local ops, collectError = self:_collectVanillaDrawOps()
    if not ops then error(collectError) end

    local tm = getTextManager()
    local maxValW = 0
    for _, op in ipairs(ops) do
        if op.val then
            maxValW = math.max(maxValW, tm:MeasureStringX(UIFont.Small, tostring(op.val)))
        end
    end

    local neededW = pad + self._keyW + VALUE_GAP + maxValW + pad
    if neededW > self.width and self.header then
        self:setWidth(neededW)
        self.header:setWidth(neededW)
        self.header:calculateLayout(neededW, NR_Config.headerHeight)
    end

    local curY = NR_Config.headerHeight + pad
    for _, op in ipairs(ops) do
        if op.t == "row" then
            NR_DrawUtils.drawLabelValue(
                self, op.lbl, op.val, xPivot, valX,
                curY + textOffY, 0.7, op.vr, op.vg, op.vb
            )
            curY = curY + lh
        elseif op.t == "text" then
            self:drawText(op.text, pad, curY + textOffY, op.r, op.g, op.b, 1)
            curY = curY + lh
        elseif op.t == "val" then
            self:drawText(op.val, valX, curY + textOffY, op.vr, op.vg, op.vb, 1)
            curY = curY + lh
        elseif op.t == "bar" then
            NR_DrawBar.drawBar(
                self, pad, curY, self.width - pad * 2,
                barH, op.pct, op.r, op.g, op.b
            )
            curY = curY + barH + math.floor(pad / 2)
        end
    end

    self:setHeight(curY + pad)
end

function NR_PlantPanel:render()
    if self._closed then return end
    if not self:isPlantValid() then
        self:close()
        return
    end
    if not NR_CollapseUtils.isBodyVisible(self) then return end

    local ok, err = xpcall(function()
        self:_renderBody()
    end, NR_traceback)

    if not ok then
        self:_restoreDrawHooks()
        NR_reportFatal(self, "render", err)
    end
end

-- ----------------------------------------------------------------------------------------------------- --
-- Actualización y autocierre
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:update()
    if self._closed then return end

    local ok, err = xpcall(function()
        local plant = self.plant
        if not plant then
            self:close()
            return
        end

        local objectOK, object = pcall(function()
            return plant:getObject()
        end)
        if not objectOK then error(object) end
        if not object then
            self:close()
            return
        end

        ISPanelJoypad.update(self)

        if not self:isPlantValid() then
            self:close()
            return
        end

        local squareOK, square = pcall(function()
            return plant:getSquare()
        end)
        if not squareOK then error(square) end

        if square then
            local distanceOK, distance = pcall(function()
                return self.character:DistTo(square:getX(), square:getY())
            end)
            if not distanceOK then error(distance) end
            if distance > 6 then
                self:close()
                return
            end
        end

        NR_CollapseUtils.update(self)
    end, NR_traceback)

    if not ok then NR_reportFatal(self, "update", err) end
end

-- ----------------------------------------------------------------------------------------------------- --
-- Colapsar / expandir
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:onClickCollapse()
    NR_CollapseUtils.onClickCollapse(self)
end

function NR_PlantPanel:_onHeaderHover()
    NR_CollapseUtils.onHeaderHover(self)
end

-- ----------------------------------------------------------------------------------------------------- --
-- Cierre
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:close()
    if self._closed then return end
    self._closed = true
    self:_restoreDrawHooks()

    if self.character and NR_PlantPanel.panels[self.character] == self then
        NR_PlantPanel.panels[self.character] = nil
    end

    pcall(NR_BasePanel.closeBase, self)
end

function NR_PlantPanel.closeAll()
    local panels = {}
    for _, panel in pairs(NR_PlantPanel.panels or {}) do
        panels[#panels + 1] = panel
    end

    for _, panel in ipairs(panels) do
        if panel and panel.close then pcall(panel.close, panel) end
    end

    NR_PlantPanel.panels = {}
end

-- ----------------------------------------------------------------------------------------------------- --
-- Mando y teclado
-- ----------------------------------------------------------------------------------------------------- --

function NR_PlantPanel:onGainJoypadFocus(_)
    self.drawJoypadFocus = true
end

function NR_PlantPanel:onLoseJoypadFocus(_)
    self.drawJoypadFocus = false
end

function NR_PlantPanel:onJoypadDown(button, joypadData)
    if button == Joypad.BButton then
        self:close()
        return
    end
    ISPanelJoypad.onJoypadDown(self, button, joypadData)
end

function NR_PlantPanel:isKeyConsumed(_)
    return false
end

function NR_PlantPanel:onKeyRelease(key)
    if key == Keyboard.KEY_ESCAPE then
        self:close()
        return true
    end
end
