-- Eclipse Z: coloca exclusivamente los indicadores de Extensive Health
-- en una columna propia, a la izquierda de la columna de moodles vanilla.
-- Los moodles de Lifestyle y de cualquier otro mod conservan su posición.

local EHR_MOODLE_ORDER = {
    "EHR_MedicalAlert",
    "EHR_CorpseExposure",
    "EHR_CadavericExposure",
    "EHR_HeatExposure",
    "EHR_ColdExposure",
    "EHR_FreezingExposure",
}

local EHR_MOODLES = {}
for _, moodleName in ipairs(EHR_MOODLE_ORDER) do
    EHR_MOODLES[moodleName] = true
end

local function getStoredMoodle(playerNum, moodleName)
    if not MF then return nil end

    -- Utiliza primero la API pública del framework. El acceso directo al
    -- almacenamiento queda únicamente como respaldo para versiones antiguas.
    if MF.getMoodle then
        local ok, moodle = pcall(MF.getMoodle, moodleName, playerNum or 0)
        if ok and moodle then return moodle end
    end

    if not MF.MoodlesStorage then return nil end
    local playerMoodles = MF.MoodlesStorage[playerNum or 0]
    return playerMoodles and playerMoodles[moodleName] or nil
end

local function installSeparateColumn()
    if not MF or not MF.ISMoodle or not MF.ISMoodle.getXYPosition then
        return false
    end
    if MF.ISMoodle.EHRSeparateColumnInstalled then
        return true
    end

    local originalGetXYPosition = MF.ISMoodle.getXYPosition

    function MF.ISMoodle:getXYPosition()
        if not EHR_MOODLES[self.name] then
            return originalGetXYPosition(self)
        end

        local size = MF.getSize()
        if size ~= self.width then
            self:setWidth(size)
            self:updateTextures(size)
        end

        local playerNum = self.playerNum or 0
        local screenLeft = getPlayerScreenLeft(playerNum)
        local screenTop = getPlayerScreenTop(playerNum)
        local screenWidth = getPlayerScreenWidth(playerNum)

        local xOffset = MF.xOffset or 10
        local standardColumnX = screenLeft + screenWidth - xOffset - self:getWidth()
        local columnGap = math.max(8, math.floor(10 * (MF.scale or 1)))
        local x = standardColumnX - self:getWidth() - columnGap
        local y = screenTop + (MF.yOffset or 120)
        local distanceY = 10 + (MF.defaultWidth or self:getWidth()) * (MF.scale or 1)

        if self.disable then
            return x, y
        end

        -- Solo cuentan los seis indicadores médicos anteriores que estén activos.
        -- Así forman una pila independiente y estable, sin depender del orden de
        -- creación de los moodles de Lifestyle u otros mods.
        for _, moodleName in ipairs(EHR_MOODLE_ORDER) do
            if moodleName == self.name then
                break
            end

            local moodle = getStoredMoodle(playerNum, moodleName)
            if moodle and not moodle.disable and moodle:getLevel() ~= 0 then
                y = y + distanceY
            end
        end

        return x, y
    end

    MF.ISMoodle.EHRSeparateColumnInstalled = true
    return true
end

local function retryInstall()
    if installSeparateColumn() then
        Events.OnTick.Remove(retryInstall)
    end
end

if not installSeparateColumn() then
    Events.OnTick.Add(retryInstall)
end

Events.OnGameStart.Add(installSeparateColumn)
Events.OnCreatePlayer.Add(function()
    installSeparateColumn()
end)
