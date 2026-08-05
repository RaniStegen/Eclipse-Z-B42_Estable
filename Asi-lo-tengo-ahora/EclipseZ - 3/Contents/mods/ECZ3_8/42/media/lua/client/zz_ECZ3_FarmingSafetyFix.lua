-- ECZ3_8 / Neat Rocco - Build 42.20
-- Corrige parcelas destruidas con typeOfSeed="none", nombres Farming_none y errores
-- al abrir la información de un cultivo sin definición válida.

pcall(require, "Farming/ISUI/ISFarmingMenu")
pcall(require, "Farming/TimedActions/ISPlantInfoAction")
pcall(require, "NeatRocco/NR_Farming/NR_PlantPanel")

local function text(key, fallback)
    if getText then
        local value = getText(key)
        if value and value ~= key then
            return value
        end
    end
    return fallback or key
end

local function getSeedType(plant)
    if not plant then
        return nil
    end

    local seedType = plant.typeOfSeed
    if seedType == nil then
        return nil
    end

    seedType = tostring(seedType)
    if seedType == "" or string.lower(seedType) == "none" then
        return nil
    end

    local props = farming_vegetableconf
        and farming_vegetableconf.props
        and farming_vegetableconf.props[seedType]
        or nil

    return props and seedType or nil
end

local function isKnownCrop(plant)
    return getSeedType(plant) ~= nil
end

local function getSafePlotName(plant)
    local state = plant and plant.state or nil

    if state == "destroyed" then
        return text("Farming_ECZ_DestroyedPlot", "Parcela de cultivo destruida")
    elseif state == "dead" then
        return text("Farming_ECZ_DeadPlot", "Parcela de cultivo muerta")
    elseif state == "rotten" then
        return text("Farming_ECZ_RottenPlot", "Parcela de cultivo podrida")
    elseif state == "harvested" then
        return text("Farming_ECZ_HarvestedPlot", "Parcela de cultivo cosechada")
    elseif state == "plow" then
        return text("Farming_Plowed_Land", "Tierra arada")
    end

    return text("Farming_ECZ_UnknownPlot", "Parcela de cultivo")
end

local function disableInvalidInfoOptions(menu)
    if not menu or not menu.options then
        return
    end

    local infoName = text("ContextMenu_Info", "Información")
    for _, option in ipairs(menu.options) do
        if option and option.name == infoName then
            option.notAvailable = true
            option.isDisabled = true
            option.onSelect = nil

            if ISWorldObjectContextMenu and ISWorldObjectContextMenu.addToolTip then
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = text(
                    "Farming_ECZ_InvalidCropInfo",
                    "Esta parcela no contiene un cultivo válido del que mostrar información."
                )
                option.toolTip = tooltip
            end
        end

        if option and option.subOption and menu.getSubMenu then
            local subMenu = menu:getSubMenu(option.subOption)
            if subMenu then
                disableInvalidInfoOptions(subMenu)
            end
        end
    end
end

local function installFarmingSafetyFix()
    if not farming_vegetableconf or not ISFarmingMenu then
        return
    end
    if ISFarmingMenu.ECZInvalidCropSafetyPatched then
        return
    end

    -- El código vanilla concatena Farming_ con typeOfSeed incluso cuando vale "none".
    local originalGetObjectName = farming_vegetableconf.getObjectName
    farming_vegetableconf.getObjectName = function(plant)
        if plant and (plant.state == "plow" or isKnownCrop(plant)) then
            local ok, value = pcall(originalGetObjectName, plant)
            if ok and value and value ~= "" and not string.find(value, "Farming_none", 1, true) then
                return value
            end
        end
        return getSafePlotName(plant)
    end

    -- El menú vanilla ofrece "Información" a cualquier estado distinto de plow,
    -- aunque typeOfSeed sea "none". Se desactiva solamente en ese caso.
    local originalDoFarmingMenu2 = ISFarmingMenu.doFarmingMenu2
    ISFarmingMenu.doFarmingMenu2 = function(player, context, worldobjects, test)
        local invalidPlant = nil
        local playerObj = getSpecificPlayer and getSpecificPlayer(player) or nil
        if playerObj and ISFarmingMenu.getBestPlantFromTable then
            local ok, plant = pcall(ISFarmingMenu.getBestPlantFromTable, playerObj, worldobjects)
            if ok and plant and plant.state ~= "plow" and not isKnownCrop(plant) then
                invalidPlant = plant
            end
        end

        local result = originalDoFarmingMenu2(player, context, worldobjects, test)
        if invalidPlant and not test then
            disableInvalidInfoOptions(context)
        end
        return result
    end

    local originalOnInfo = ISFarmingMenu.onInfo
    ISFarmingMenu.onInfo = function(worldobjects, plant, square, playerObj)
        if not isKnownCrop(plant) then
            return
        end
        return originalOnInfo(worldobjects, plant, square, playerObj)
    end

    local originalOnInfoSquareSelected = ISFarmingMenu.onInfoSquareSelected
    ISFarmingMenu.onInfoSquareSelected = function(self)
        local cursor = ISFarmingMenu.cursor
        local plant = cursor and cursor.sq
            and CFarmingSystem.instance:getLuaObjectOnSquare(cursor.sq)
            or nil
        if not isKnownCrop(plant) then
            return
        end
        return originalOnInfoSquareSelected(self)
    end

    local originalIsInfoValid = ISFarmingMenu.isInfoValid
    ISFarmingMenu.isInfoValid = function(self)
        local cursor = ISFarmingMenu.cursor
        local plant = cursor and cursor.sq
            and CFarmingSystem.instance:getLuaObjectOnSquare(cursor.sq)
            or nil
        if not isKnownCrop(plant) then
            return false
        end
        return originalIsInfoValid(self)
    end

    -- Segunda barrera: ninguna acción de información puede ejecutarse con un cultivo inválido,
    -- incluso si otro mod la añade directamente a la cola.
    if ISPlantInfoAction and not ISPlantInfoAction.ECZInvalidCropSafetyPatched then
        local originalActionIsValid = ISPlantInfoAction.isValid
        ISPlantInfoAction.isValid = function(self)
            if not self or not isKnownCrop(self.plant) then
                return false
            end
            return originalActionIsValid(self)
        end
        ISPlantInfoAction.ECZInvalidCropSafetyPatched = true
    end

    -- Si una ventana ya estaba abierta y la parcela pasa a estado inválido, se cierra
    -- antes de que NR_PlantPanel intente acceder a props["none"].
    if NR_PlantPanel and not NR_PlantPanel.ECZInvalidCropSafetyPatched then
        local originalIsPlantValid = NR_PlantPanel.isPlantValid
        NR_PlantPanel.isPlantValid = function(self)
            if not self or not isKnownCrop(self.plant) then
                return false
            end
            local ok, value = pcall(originalIsPlantValid, self)
            return ok and value == true
        end

        local originalSetPlant = NR_PlantPanel.setPlant
        NR_PlantPanel.setPlant = function(self, plant)
            if not isKnownCrop(plant) then
                self.plant = plant
                self.vegetable = nil
                return false
            end
            return originalSetPlant(self, plant)
        end

        NR_PlantPanel.ECZInvalidCropSafetyPatched = true
    end

    ISFarmingMenu.ECZInvalidCropSafetyPatched = true
end

if Events and Events.OnGameStart then
    Events.OnGameStart.Add(installFarmingSafetyFix)
end
if Events and Events.OnCreatePlayer then
    Events.OnCreatePlayer.Add(installFarmingSafetyFix)
end
installFarmingSafetyFix()
