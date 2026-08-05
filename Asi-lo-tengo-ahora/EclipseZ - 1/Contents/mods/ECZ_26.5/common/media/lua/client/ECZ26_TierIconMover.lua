--------------------------------------------------------------------------------
-- ECZ26 - Icono de Zona Movible
-- Mini-fix externo para More Difficult Zones / Moodle Framework.
--
-- Qué hace:
--   * Solo afecta a los moodles SD6Tier1..SD6Tier6 de ECZ26.
--   * Permite arrastrar el icono de Tier/Zona con clic izquierdo.
--   * Guarda una única posición por jugador, compartida por todos los tiers.
--   * Clic derecho sobre el icono: restablece la posición por defecto.
--   * No toca los moodles de Lifestyle ni los moodles vanilla.
--------------------------------------------------------------------------------

ECZ26_TierIconMover = ECZ26_TierIconMover or {}

if not ECZ26_TierIconMover.__loaded then
    ECZ26_TierIconMover.__loaded = true

    local M = ECZ26_TierIconMover
    M.modDataKey = "ECZ26_TierIconMover"
    M.dragKey = "dragging"
    M.patchTickRegistered = false

    local function isNumber(value)
        return type(value) == "number" and value == value
    end

    function M.isTierMoodle(moodle)
        return moodle ~= nil
            and type(moodle.name) == "string"
            and moodle.name:match("^SD6Tier[1-6]$") ~= nil
    end

    function M.getPlayerForMoodle(moodle)
        local playerNum = 0
        if moodle and moodle.playerNum then
            playerNum = moodle.playerNum
        end

        local player = nil
        if getSpecificPlayer then
            player = getSpecificPlayer(playerNum)
        end

        if not player and moodle and moodle.char then
            player = moodle.char
        end

        return player
    end

    function M.getData(moodle)
        local player = M.getPlayerForMoodle(moodle)
        if not player or not player.getModData then
            return nil
        end

        local md = player:getModData()
        md[M.modDataKey] = md[M.modDataKey] or {}
        local data = md[M.modDataKey]

        -- Limpieza de datos transitorios antiguos, por si el jugador salió mientras arrastraba.
        data[M.dragKey] = data[M.dragKey] or false
        data.dragDX = data.dragDX or nil
        data.dragDY = data.dragDY or nil

        return data
    end

    function M.getScreenBounds(playerNum)
        playerNum = playerNum or 0

        local left = 0
        local top = 0
        local width = 0
        local height = 0

        if getPlayerScreenLeft then left = getPlayerScreenLeft(playerNum) or 0 end
        if getPlayerScreenTop then top = getPlayerScreenTop(playerNum) or 0 end
        if getPlayerScreenWidth then width = getPlayerScreenWidth(playerNum) or 0 end
        if getPlayerScreenHeight then height = getPlayerScreenHeight(playerNum) or 0 end

        if width <= 0 or height <= 0 then
            local core = getCore and getCore() or nil
            if core then
                width = core:getScreenWidth() or width
                height = core:getScreenHeight() or height
            end
        end

        return left, top, width, height
    end

    function M.clampPosition(x, y, w, h, playerNum)
        local left, top, sw, sh = M.getScreenBounds(playerNum)
        w = w or 32
        h = h or w

        local minX = left
        local minY = top
        local maxX = left + math.max(0, sw - w)
        local maxY = top + math.max(0, sh - h)

        if x < minX then x = minX end
        if y < minY then y = minY end
        if x > maxX then x = maxX end
        if y > maxY then y = maxY end

        return x, y
    end

    function M.savePosition(moodle, x, y)
        local data = M.getData(moodle)
        if not data then return end

        x, y = M.clampPosition(x, y, moodle:getWidth(), moodle:getHeight(), moodle.playerNum)
        data.x = x
        data.y = y
        data[M.dragKey] = false
        data.dragDX = nil
        data.dragDY = nil

        local player = M.getPlayerForMoodle(moodle)
        if player and player.transmitModData then
            player:transmitModData()
        end
    end

    function M.resetPosition(moodle)
        local data = M.getData(moodle)
        if not data then return end

        data.x = nil
        data.y = nil
        data[M.dragKey] = false
        data.dragDX = nil
        data.dragDY = nil

        local player = M.getPlayerForMoodle(moodle)
        if player and player.transmitModData then
            player:transmitModData()
        end
    end

    function M.applyPatch()
        if not MF or not MF.ISMoodle then
            return false
        end

        local moodleClass = MF.ISMoodle
        if moodleClass.__ECZ26TierIconMoverPatched then
            return true
        end
        moodleClass.__ECZ26TierIconMoverPatched = true

        local originalGetXYPosition = moodleClass.getXYPosition
        local originalOnMouseDown = moodleClass.onMouseDown
        local originalOnMouseMove = moodleClass.onMouseMove
        local originalOnMouseMoveOutside = moodleClass.onMouseMoveOutside
        local originalOnMouseUp = moodleClass.onMouseUp
        local originalOnMouseUpOutside = moodleClass.onMouseUpOutside
        local originalOnRightMouseUp = moodleClass.onRightMouseUp
        local originalRender = moodleClass.render

        function moodleClass:getXYPosition()
            local defaultX, defaultY = originalGetXYPosition(self)

            if M.isTierMoodle(self) then
                local data = M.getData(self)
                if data and isNumber(data.x) and isNumber(data.y) then
                    local x, y = M.clampPosition(data.x, data.y, self:getWidth(), self:getHeight(), self.playerNum)
                    data.x = x
                    data.y = y
                    -- Evita que Moodle Framework haga una transición vertical lenta hacia la posición elegida.
                    self.posY = y
                    return x, y
                end
            end

            return defaultX, defaultY
        end

        function moodleClass:onMouseDown(x, y)
            if M.isTierMoodle(self) and self:getGoodBadNeutral() ~= 0 and not self.disable then
                local data = M.getData(self)
                if data then
                    data[M.dragKey] = true
                    data.dragDX = x or 0
                    data.dragDY = y or 0
                    data.x = self:getX()
                    data.y = self:getY()
                    return true
                end
            end

            if originalOnMouseDown then
                return originalOnMouseDown(self, x, y)
            end
            return false
        end

        local function doMouseMove(self, dx, dy, originalFunc)
            if M.isTierMoodle(self) then
                local data = M.getData(self)
                if data and data[M.dragKey] then
                    local newX = (data.x or self:getX()) + (dx or 0)
                    local newY = (data.y or self:getY()) + (dy or 0)
                    newX, newY = M.clampPosition(newX, newY, self:getWidth(), self:getHeight(), self.playerNum)

                    data.x = newX
                    data.y = newY
                    self:setX(newX)
                    self:setY(newY)
                    self.posY = newY
                    return true
                end
            end

            if originalFunc then
                return originalFunc(self, dx, dy)
            end
            return false
        end

        function moodleClass:onMouseMove(dx, dy)
            return doMouseMove(self, dx, dy, originalOnMouseMove)
        end

        function moodleClass:onMouseMoveOutside(dx, dy)
            return doMouseMove(self, dx, dy, originalOnMouseMoveOutside)
        end

        local function doMouseUp(self, x, y, originalFunc)
            if M.isTierMoodle(self) then
                local data = M.getData(self)
                if data and data[M.dragKey] then
                    M.savePosition(self, self:getX(), self:getY())
                    return true
                end
            end

            if originalFunc then
                return originalFunc(self, x, y)
            end
            return false
        end

        function moodleClass:onMouseUp(x, y)
            return doMouseUp(self, x, y, originalOnMouseUp)
        end

        function moodleClass:onMouseUpOutside(x, y)
            return doMouseUp(self, x, y, originalOnMouseUpOutside)
        end

        function moodleClass:onRightMouseUp(x, y)
            if M.isTierMoodle(self) and self:getGoodBadNeutral() ~= 0 and not self.disable then
                M.resetPosition(self)
                return true
            end

            if originalOnRightMouseUp then
                return originalOnRightMouseUp(self, x, y)
            end
            return false
        end

        function moodleClass:render()
            originalRender(self)

            -- Pequeña ayuda visual: borde blanco mientras el icono de zona está bajo el ratón.
            if M.isTierMoodle(self) and self:getGoodBadNeutral() ~= 0 and not self.disable then
                if self.isMouseOverMoodle and self:isMouseOverMoodle() and self.drawRectBorder then
                    self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.85, 1, 1, 1)
                end
            end
        end

        print("ECZ26_TierIconMover: icono de Tier/Zona movible activado.")
        return true
    end

    local function tryPatch()
        if M.applyPatch() then
            if Events and Events.OnTick then
                Events.OnTick.Remove(tryPatch)
            end
        end
    end

    if Events then
        if Events.OnGameStart then Events.OnGameStart.Add(tryPatch) end
        if Events.OnCreatePlayer then Events.OnCreatePlayer.Add(function() tryPatch() end) end
        if Events.OnTick then Events.OnTick.Add(tryPatch) end
    end
end
