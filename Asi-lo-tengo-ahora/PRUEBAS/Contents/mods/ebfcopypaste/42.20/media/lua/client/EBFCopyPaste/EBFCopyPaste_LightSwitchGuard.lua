require "EBFCopyPaste/EBFCopyPaste_Shared"

EBFCopyPaste.LightSwitchGuard = EBFCopyPaste.LightSwitchGuard or {}

-- B42.20 sigue mezclando, según la ruta de interacción, el número de jugador y
-- el objeto IsoPlayer. Normalizamos ambos formatos antes de llamar a acciones
-- vanilla o de enviar órdenes al servidor.
function EBFCopyPaste.LightSwitchGuard.normalizePlayerArgs(playerNum, playerObj)
    if type(playerObj) == "number" and playerNum == nil then
        playerNum = playerObj
        playerObj = nil
    elseif playerObj == nil and playerNum ~= nil and type(playerNum) ~= "number" then
        playerObj = playerNum
        playerNum = nil
    end
    return playerNum, playerObj
end

function EBFCopyPaste.LightSwitchGuard.getPlayerNum(playerNum, playerObj)
    playerNum, playerObj = EBFCopyPaste.LightSwitchGuard.normalizePlayerArgs(playerNum, playerObj)
    if playerNum ~= nil then
        return playerNum
    end
    if playerObj and playerObj.getPlayerNum then
        local ok, value = pcall(function()
            return playerObj:getPlayerNum()
        end)
        if ok then
            return value
        end
    end
    return nil
end

function EBFCopyPaste.LightSwitchGuard.isBatteryPowered(object)
    if not object then
        return false
    end
    local okUse, useBattery = pcall(function()
        return object:getUseBattery()
    end)
    if not okUse or useBattery ~= true then
        return false
    end
    local okHas, hasBattery = pcall(function()
        return object:getHasBattery()
    end)
    return okHas == true and hasBattery == true
end

function EBFCopyPaste.LightSwitchGuard.hasSquareElectricity(object)
    local square = nil
    local okSquare = pcall(function()
        square = object and object:getSquare() or nil
    end)
    if not okSquare or not square then
        return false
    end
    local okPower, hasPower = pcall(function()
        return square:haveElectricity()
    end)
    return okPower == true and hasPower == true
end

function EBFCopyPaste.LightSwitchGuard.getSpriteName(object)
    local sprite = nil
    local okSprite = pcall(function()
        sprite = object and object:getSprite() or nil
    end)
    if not okSprite or not sprite then
        return nil
    end

    local okName, spriteName = pcall(function()
        return sprite:getName()
    end)
    if okName then
        return spriteName
    end
    return nil
end

function EBFCopyPaste.LightSwitchGuard.isOutdoorLight(object)
    local spriteName = EBFCopyPaste.LightSwitchGuard.getSpriteName(object)
    return type(spriteName) == "string"
            and string.sub(spriteName, 1, string.len("lighting_outdoor_")) == "lighting_outdoor_"
end

function EBFCopyPaste.LightSwitchGuard.nowMs()
    if getTimestampMs then
        local ok, value = pcall(getTimestampMs)
        if ok and tonumber(value) then
            return tonumber(value)
        end
    end
    return os.time() * 1000
end

function EBFCopyPaste.LightSwitchGuard.markReconcileArea(args)
    if not args then
        return
    end

    local x = math.floor(tonumber(args.x) or 0)
    local y = math.floor(tonumber(args.y) or 0)
    local z = math.floor(tonumber(args.z) or 0)
    local w = math.max(1, math.floor(tonumber(args.w) or 1))
    local h = math.max(1, math.floor(tonumber(args.h) or 1))
    local offsets = {}
    local offsetSet = {}
    if type(args.zOffsets) == "table" then
        for _, value in ipairs(args.zOffsets) do
            local offset = tonumber(value)
            if offset ~= nil then
                offset = math.floor(offset)
                if not offsetSet[offset] then
                    offsetSet[offset] = true
                    table.insert(offsets, offset)
                end
            end
        end
    end
    if #offsets <= 0 then
        local levels = math.max(1, math.floor(tonumber(args.levels) or 1))
        for offset = 0, levels - 1 do
            offsetSet[offset] = true
            table.insert(offsets, offset)
        end
    end

    EBFCopyPaste.LightSwitchGuard.reconcileWindows = EBFCopyPaste.LightSwitchGuard.reconcileWindows or {}
    table.insert(EBFCopyPaste.LightSwitchGuard.reconcileWindows, {
        x = x,
        y = y,
        z = z,
        w = w,
        h = h,
        offsets = offsetSet,
        expiresAt = EBFCopyPaste.LightSwitchGuard.nowMs() + 45000,
        reason = tostring(args.reason or ""),
    })
    while #EBFCopyPaste.LightSwitchGuard.reconcileWindows > 12 do
        table.remove(EBFCopyPaste.LightSwitchGuard.reconcileWindows, 1)
    end
end

function EBFCopyPaste.LightSwitchGuard.isInRecentReconcileArea(object)
    local windows = EBFCopyPaste.LightSwitchGuard.reconcileWindows
    if not object or type(windows) ~= "table" or #windows <= 0 then
        return false
    end

    local square = nil
    local okSquare = pcall(function()
        square = object:getSquare()
    end)
    if not okSquare or not square then
        return false
    end

    local okPos, x, y, z = pcall(function()
        return square:getX(), square:getY(), square:getZ()
    end)
    if not okPos then
        return false
    end

    local now = EBFCopyPaste.LightSwitchGuard.nowMs()
    for index = #windows, 1, -1 do
        local window = windows[index]
        if not window or (tonumber(window.expiresAt) or 0) < now then
            table.remove(windows, index)
        else
            local dz = math.floor((tonumber(z) or 0) - (tonumber(window.z) or 0))
            if x >= window.x and x < window.x + window.w
                    and y >= window.y and y < window.y + window.h
                    and window.offsets and window.offsets[dz] then
                return true
            end
        end
    end
    return false
end

function EBFCopyPaste.LightSwitchGuard.canToggle(object, playerNum, playerObj)
    if not object or not instanceof or not instanceof(object, "IsoLightSwitch") then
        return true
    end

    local indexOk, index = pcall(function()
        return object:getObjectIndex()
    end)
    if indexOk and tonumber(index) == -1 then
        return false
    end

    if EBFCopyPaste.LightSwitchGuard.isInRecentReconcileArea(object) then
        return true
    end

    local ok, canSwitch = pcall(function()
        return object:canSwitchLight()
    end)
    if not ok or canSwitch ~= true then
        return false
    end

    if EBFCopyPaste.LightSwitchGuard.isOutdoorLight(object)
            and not EBFCopyPaste.LightSwitchGuard.isBatteryPowered(object)
            and not EBFCopyPaste.LightSwitchGuard.hasSquareElectricity(object) then
        return false
    end

    if ISWorldObjectContextMenu and ISWorldObjectContextMenu.isSomethingTo then
        local resolvedPlayerNum = EBFCopyPaste.LightSwitchGuard.getPlayerNum(playerNum, playerObj)
        if resolvedPlayerNum ~= nil then
            local blockOk, blocked = pcall(ISWorldObjectContextMenu.isSomethingTo, object, resolvedPlayerNum)
            if blockOk and blocked == true then
                return false
            end
        end
    end

    return true
end

function EBFCopyPaste.LightSwitchGuard.getCommandPlayer(playerNum, playerObj)
    playerNum, playerObj = EBFCopyPaste.LightSwitchGuard.normalizePlayerArgs(playerNum, playerObj)
    if playerObj then
        return playerObj
    end
    if playerNum ~= nil and getSpecificPlayer then
        local player = getSpecificPlayer(playerNum)
        if player then
            return player
        end
    end
    if getPlayer then
        return getPlayer()
    end
    return nil
end

function EBFCopyPaste.LightSwitchGuard.isManagedResidentialSwitch(object)
    if not object or not object.getModData or not instanceof or not instanceof(object, "IsoLightSwitch") then
        return false
    end

    local ok, modData = pcall(function()
        return object:getModData()
    end)
    return ok == true
            and modData ~= nil
            and modData[EBFCopyPaste.ManagedResidentialLightSwitchModDataKey] == true
end

function EBFCopyPaste.LightSwitchGuard.getObjectIndex(object)
    local ok, index = pcall(function()
        return object:getObjectIndex()
    end)
    if ok then
        return tonumber(index)
    end
    return nil
end

function EBFCopyPaste.LightSwitchGuard.requestManagedServerToggle(object, playerNum, playerObj)
    if not EBFCopyPaste.LightSwitchGuard.isManagedResidentialSwitch(object) then
        return false
    end
    if not isClient or not isClient() or not sendClientCommand then
        return false
    end

    local index = EBFCopyPaste.LightSwitchGuard.getObjectIndex(object)
    if index == nil or index < 0 then
        return true
    end

    local square = nil
    local okSquare = pcall(function()
        square = object:getSquare()
    end)
    if not okSquare or not square then
        return true
    end

    local okPos, x, y, z = pcall(function()
        return square:getX(), square:getY(), square:getZ()
    end)
    if not okPos then
        return true
    end

    local active = false
    pcall(function()
        active = object:isActivated() == true
    end)
    local desiredActive = not active
    local spriteName = EBFCopyPaste.LightSwitchGuard.getSpriteName(object)
    local player = EBFCopyPaste.LightSwitchGuard.getCommandPlayer(playerNum, playerObj)
    if not player then
        return true
    end

    local key = tostring(x) .. ":" .. tostring(y) .. ":" .. tostring(z)
            .. ":" .. tostring(index) .. ":" .. tostring(desiredActive)
    local now = EBFCopyPaste.LightSwitchGuard.nowMs()
    EBFCopyPaste.LightSwitchGuard.lastManagedToggleRequests = EBFCopyPaste.LightSwitchGuard.lastManagedToggleRequests or {}
    if (EBFCopyPaste.LightSwitchGuard.lastManagedToggleRequests[key] or 0) + 350 > now then
        return true
    end
    EBFCopyPaste.LightSwitchGuard.lastManagedToggleRequests[key] = now

    sendClientCommand(player, EBFCopyPaste.Module, EBFCopyPaste.Commands.ToggleManagedLightSwitch, {
        x = x,
        y = y,
        z = z,
        index = index,
        sprite = spriteName,
        active = desiredActive,
    })
    return true
end

function EBFCopyPaste.LightSwitchGuard.installClickHandler()
    if EBFCopyPaste.LightSwitchGuard.clickInstalled then
        return true
    end

    pcall(require, "ISObjectClickHandler")
    if not ISObjectClickHandler or not ISObjectClickHandler.doClickLightSwitch then
        return false
    end

    local original = ISObjectClickHandler.doClickLightSwitch
    EBFCopyPaste.LightSwitchGuard.originalDoClickLightSwitch = original
    ISObjectClickHandler.doClickLightSwitch = function(object, playerNum, playerObj)
        if EBFCopyPaste.LightSwitchGuard.requestManagedServerToggle(object, playerNum, playerObj) then
            return false
        end
        if not EBFCopyPaste.LightSwitchGuard.canToggle(object, playerNum, playerObj) then
            return false
        end
        return original(object, playerNum, playerObj)
    end

    EBFCopyPaste.LightSwitchGuard.clickInstalled = true
    return true
end

function EBFCopyPaste.LightSwitchGuard.installTimedAction()
    if EBFCopyPaste.LightSwitchGuard.actionInstalled then
        return true
    end

    pcall(require, "TimedActions/ISToggleLightAction")
    if not ISToggleLightAction then
        return false
    end

    local originalIsValid = ISToggleLightAction.isValid
    local originalComplete = ISToggleLightAction.complete
    EBFCopyPaste.LightSwitchGuard.originalToggleLightIsValid = originalIsValid
    EBFCopyPaste.LightSwitchGuard.originalToggleLightComplete = originalComplete

    ISToggleLightAction.isValid = function(action)
        if EBFCopyPaste.LightSwitchGuard.isManagedResidentialSwitch(action and action.object) then
            return true
        end
        if not EBFCopyPaste.LightSwitchGuard.canToggle(action and action.object, nil, action and action.character) then
            return false
        end
        if originalIsValid then
            return originalIsValid(action)
        end
        return true
    end

    ISToggleLightAction.complete = function(action)
        if EBFCopyPaste.LightSwitchGuard.requestManagedServerToggle(action and action.object, nil, action and action.character) then
            return true
        end
        if not EBFCopyPaste.LightSwitchGuard.canToggle(action and action.object, nil, action and action.character) then
            return false
        end
        if originalComplete then
            return originalComplete(action)
        end
        return true
    end

    EBFCopyPaste.LightSwitchGuard.actionInstalled = true
    return true
end

function EBFCopyPaste.LightSwitchGuard.installContextMenu()
    if EBFCopyPaste.LightSwitchGuard.contextInstalled then
        return true
    end

    pcall(require, "ISUI/ISWorldObjectContextMenu")
    if not ISWorldObjectContextMenu or not ISWorldObjectContextMenu.onToggleLight then
        return false
    end

    local original = ISWorldObjectContextMenu.onToggleLight
    EBFCopyPaste.LightSwitchGuard.originalOnToggleLight = original
    ISWorldObjectContextMenu.onToggleLight = function(worldobjects, light, player)
        -- En el menú contextual vanilla, `player` suele ser el índice local,
        -- no un IsoPlayer. Pasarlo como playerObj impedía enviar correctamente
        -- la orden de interruptores residenciales gestionados.
        if EBFCopyPaste.LightSwitchGuard.requestManagedServerToggle(light, player, nil) then
            return false
        end
        if not EBFCopyPaste.LightSwitchGuard.canToggle(light, player, nil) then
            return false
        end
        return original(worldobjects, light, player)
    end

    EBFCopyPaste.LightSwitchGuard.contextInstalled = true
    return true
end

function EBFCopyPaste.LightSwitchGuard.installButtonPrompt()
    if EBFCopyPaste.LightSwitchGuard.buttonPromptInstalled then
        return true
    end

    pcall(require, "ISUI/ISButtonPrompt")
    if not ISButtonPrompt or not ISButtonPrompt.cmdToggleLight then
        return false
    end

    local original = ISButtonPrompt.cmdToggleLight
    EBFCopyPaste.LightSwitchGuard.originalCmdToggleLight = original
    ISButtonPrompt.cmdToggleLight = function(prompt, light)
        local promptPlayer = prompt and prompt.player or nil
        if EBFCopyPaste.LightSwitchGuard.requestManagedServerToggle(light, nil, promptPlayer) then
            return false
        end
        if not EBFCopyPaste.LightSwitchGuard.canToggle(light, nil, promptPlayer) then
            return false
        end
        return original(prompt, light)
    end

    EBFCopyPaste.LightSwitchGuard.buttonPromptInstalled = true
    return true
end

function EBFCopyPaste.LightSwitchGuard.install()
    if EBFCopyPaste.LightSwitchGuard.installed then
        return true
    end

    local clickOk = EBFCopyPaste.LightSwitchGuard.installClickHandler()
    local actionOk = EBFCopyPaste.LightSwitchGuard.installTimedAction()
    local contextOk = EBFCopyPaste.LightSwitchGuard.installContextMenu()
    local buttonPromptOk = EBFCopyPaste.LightSwitchGuard.installButtonPrompt()

    if clickOk and actionOk and contextOk and buttonPromptOk then
        EBFCopyPaste.LightSwitchGuard.installed = true
        print("[EBFCopyPaste] LightSwitch guard instalado: toggle respeita o mesmo bloqueio del menu vanilla.")
        return true
    end

    return false
end

if not EBFCopyPaste.LightSwitchGuard.install() and Events and Events.OnGameStart then
    Events.OnGameStart.Add(EBFCopyPaste.LightSwitchGuard.install)
end

if Events and Events.OnCreatePlayer then
    Events.OnCreatePlayer.Add(EBFCopyPaste.LightSwitchGuard.install)
end
