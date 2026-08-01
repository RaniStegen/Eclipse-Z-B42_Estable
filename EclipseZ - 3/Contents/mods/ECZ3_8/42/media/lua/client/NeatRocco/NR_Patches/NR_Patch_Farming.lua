-- NR_Patch_Farming.lua
-- Sustituye de forma segura la ventana de información agrícola.
-- Si el panel Neat falla con un cultivo o con otro parche de agricultura,
-- restaura inmediatamente la ventana vanilla durante el resto de la sesión.

require "NeatRocco/NR_Farming/NR_PlantPanel"

ISPlantInfoAction._NR_old_perform = ISPlantInfoAction._NR_old_perform or ISPlantInfoAction.perform

NR_FarmingUIState = NR_FarmingUIState or {
    disabledForSession = false,
    loggedErrors = {},
}

local function NR_traceback(err)
    local message = tostring(err)
    if debug and debug.traceback then
        return debug.traceback(message, 2)
    end
    return message
end

local function NR_closeFarmingPanels()
    if NR_PlantPanel and NR_PlantPanel.closeAll then
        pcall(NR_PlantPanel.closeAll)
        return
    end

    if NR_PlantPanel and NR_PlantPanel.panels then
        local panels = {}
        for _, panel in pairs(NR_PlantPanel.panels) do
            panels[#panels + 1] = panel
        end
        for _, panel in ipairs(panels) do
            if panel and panel.close then pcall(panel.close, panel) end
        end
        NR_PlantPanel.panels = {}
    end
end

function NR_FarmingUI_DisableForSession(stage, err)
    NR_FarmingUIState.disabledForSession = true
    NR_closeFarmingPanels()

    if ISPlantInfoAction and ISPlantInfoAction._NR_old_perform then
        ISPlantInfoAction.perform = ISPlantInfoAction._NR_old_perform
    end

    local key = tostring(stage) .. "|" .. tostring(err)
    if not NR_FarmingUIState.loggedErrors[key] then
        NR_FarmingUIState.loggedErrors[key] = true
        print("[ECZ3_8][NeatRocco][Farming] Panel desactivado durante esta sesión tras un error en "
            .. tostring(stage) .. ": " .. tostring(err))
        print("[ECZ3_8][NeatRocco][Farming] Se usará la ventana vanilla de estado de cosecha.")
    end
end

local NR_performPlantInfo

local function NR_fallbackToVanilla(self, stage, err)
    NR_FarmingUI_DisableForSession(stage, err)

    local vanillaPerform = ISPlantInfoAction and ISPlantInfoAction._NR_old_perform
    if vanillaPerform and vanillaPerform ~= NR_performPlantInfo then
        local ok, result = xpcall(function()
            return vanillaPerform(self)
        end, NR_traceback)
        if ok then return result end

        print("[ECZ3_8][NeatRocco][Farming] También falló la ventana vanilla: " .. tostring(result))
    end

    -- Último recurso: finalizar la acción para que nunca quede bloqueada en la cola.
    return ISBaseTimedAction.perform(self)
end

NR_performPlantInfo = function(self)
    if NR_FarmingUIState.disabledForSession then
        local vanillaPerform = ISPlantInfoAction._NR_old_perform
        if vanillaPerform and vanillaPerform ~= NR_performPlantInfo then
            return vanillaPerform(self)
        end
        return ISBaseTimedAction.perform(self)
    end

    local ok, err = xpcall(function()
        if not self or not self.character or not self.plant then
            error("acción de información agrícola sin personaje o cultivo")
        end

        local existing = NR_PlantPanel.panels[self.character]
        if existing and existing._closed then
            NR_PlantPanel.panels[self.character] = nil
            existing = nil
        end

        if existing then
            existing:setPlant(self.plant)
            existing:setVisible(true)

            local visible = false
            if existing.isReallyVisible then
                local visibleOK, visibleResult = pcall(existing.isReallyVisible, existing)
                visible = visibleOK and visibleResult == true
            end
            if not visible then existing:addToUIManager() end
        else
            local ui = NR_PlantPanel:new(
                getPlayerScreenLeft(self.playerNum) + 70,
                getPlayerScreenTop(self.playerNum) + 50,
                self.character,
                self.plant
            )
            ui:initialise()
            ui:addToUIManager()
        end

        local jd = JoypadState.players[self.playerNum + 1]
        if jd then jd.focus = NR_PlantPanel.panels[self.character] end
    end, NR_traceback)

    if not ok then
        return NR_fallbackToVanilla(self, "perform", err)
    end

    -- Imprescindible para retirar la acción de la cola y permitir la siguiente.
    return ISBaseTimedAction.perform(self)
end

local function NR_applyFarmingToggle(enabled)
    if enabled and not NR_FarmingUIState.disabledForSession then
        ISPlantInfoAction.perform = NR_performPlantInfo
    else
        ISPlantInfoAction.perform = ISPlantInfoAction._NR_old_perform
        NR_closeFarmingPanels()
    end
end

NR_RegisterWindowToggleCallback("Farming", NR_applyFarmingToggle)
