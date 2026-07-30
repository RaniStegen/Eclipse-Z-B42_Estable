require "OfflineSurvivorV2/OS_Constants"

local OS = OfflineSurvivorV2
local records = {}
local lootCooldowns = {}
local runtimeObjects = {}
local runtimePlayers = {}
local lootSessions = {}
local nextMaintenance = 0
local nextSessionId = 1
local lastHeartbeatLog = {}

local function numberOr(value, fallback)
    local number = tonumber(value)
    if number == nil then return fallback end
    return number
end

local function nowSeconds()
    return numberOr(getTimestamp(), 0)
end

local function nowMs()
    if getTimestampMs then return numberOr(getTimestampMs(), 0) end
    return nowSeconds() * 1000
end

local function nowHours()
    return getGameTime():getWorldAgeHours()
end

local function gridCoordinate(value)
    return math.floor(numberOr(value, 0))
end

local function sendTo(player, command, args)
    if not player then return end
    pcall(function()
        sendServerCommand(player, OS.MODULE, command, args or {})
    end)
end

-- Global ModData is saved by the server.  It is deliberately not transmitted:
-- the target inventory snapshot must never be replicated to every client.
local function persistentDataChanged()
    pcall(function() ModData.add(OS.DATA_KEY, records) end)
    pcall(function() ModData.add(OS.LOOT_DATA_KEY, lootCooldowns) end)
end

local function getRecordSquare(record)
    local x = record.objectX or record.x
    local y = record.objectY or record.y
    local z = record.objectZ
    if z == nil then z = record.z end
    if x == nil or y == nil or z == nil then return nil end
    return getWorld():getCell():getGridSquare(gridCoordinate(x), gridCoordinate(y), gridCoordinate(z))
end

local function getObjectProperty(object, key)
    if not object or not key then return nil end
    local properties = nil
    local ok, sprite = pcall(function() return object:getSprite() end)
    if ok and sprite then
        ok, properties = pcall(function() return sprite:getProperties() end)
    end
    if not properties then
        ok, properties = pcall(function() return object:getProperties() end)
    end
    if not properties then return nil end
    local valueOk, value = pcall(function() return properties:get(key) end)
    return valueOk and value or nil
end

-- Chairs and sofas also use the engine's generic "bed" flag (it is used for
-- sleep quality).  Only a real bed may take priority over a sofa, otherwise a
-- nearby chair would incorrectly be chosen as a sleeping surface.
local function isActualBed(object)
    local customName = tostring(getObjectProperty(object, "CustomName") or ""):lower()
    if customName:find("bed", 1, true)
        or customName:find("mattress", 1, true)
        or customName:find("futon", 1, true)
        or customName:find("cot", 1, true) then
        return true
    end
    -- A mod may omit CustomName but preserve the standard quality value.
    local bedType = tostring(getObjectProperty(object, "BedType") or ""):lower()
    return bedType == "goodbed"
end

local function getBedOnSquare(square)
    if not square then return nil end

    local ok, bed = pcall(function() return square:getBed() end)
    if ok and bed and isActualBed(bed) then return bed end

    -- getBed() is the native B42 route.  This fallback also supports tiles
    -- whose bed marker is exposed only through the square/object properties.
    if IsoFlagType and IsoFlagType.bed then
        local hasBed = false
        ok, hasBed = pcall(function() return square:has(IsoFlagType.bed) end)
        if ok and hasBed then
            local objects = square:getObjects()
            for index = 0, objects:size() - 1 do
                local object = objects:get(index)
                local propertiesOk, properties = pcall(function() return object:getProperties() end)
                local objectIsBed = false
                if propertiesOk and properties then
                    local flagOk, flagged = pcall(function() return properties:has(IsoFlagType.bed) end)
                    objectIsBed = flagOk and flagged == true
                end
                if objectIsBed and isActualBed(object) then return object end
            end
        end
    end
    return nil
end

local function getBedFacing(bed)
    if not bed then return nil end
    local facing = getObjectProperty(bed, "Facing")
    if not facing then return nil end
    facing = tostring(facing):upper()
    if facing == "N" or facing == "S" or facing == "E" or facing == "W" then
        return facing
    end
    return nil
end

local function getSpriteGridSize(object)
    if not object then return nil, nil end
    local grid = nil
    local ok = false
    ok, grid = pcall(function() return object:getSpriteGrid() end)
    if (not ok or not grid) then
        local sprite = nil
        ok, sprite = pcall(function() return object:getSprite() end)
        if ok and sprite then
            ok, grid = pcall(function() return sprite:getSpriteGrid() end)
        end
    end
    if not grid then return nil end

    local widthOk, width = pcall(function() return grid:getWidth() end)
    local heightOk, height = pcall(function() return grid:getHeight() end)
    if not widthOk or not heightOk then return nil end
    width = numberOr(width, 0)
    height = numberOr(height, 0)
    return width, height
end

-- Sprite-grid dimensions identify the long side of rectangular furniture.
-- On square beds, Facing identifies the headboard/lateral side, so the body
-- must use the perpendicular axis of that value.
local function getFurnitureAxis(object)
    local width, height = getSpriteGridSize(object)
    if width and height then
        if width > height then return "x" end
        if height > width then return "y" end
    end

    local facing = getBedFacing(object)
    if facing == "N" or facing == "S" then return "x" end
    if facing == "E" or facing == "W" then return "y" end
    return nil
end

local function getBedAxis(bed)
    return getFurnitureAxis(bed)
end

local function getObjectSearchText(object)
    local values = {}
    local function add(value)
        if value and tostring(value) ~= "" then table.insert(values, tostring(value):lower()) end
    end

    pcall(function() add(object:getName()) end)
    local sprite = nil
    pcall(function() sprite = object:getSprite() end)
    if sprite then
        pcall(function() add(sprite:getName()) end)
        pcall(function() add(sprite.tilesetName) end)
    end

    local properties = nil
    pcall(function() properties = object:getProperties() end)
    if properties then
        pcall(function() add(properties:get("CustomName")) end)
        pcall(function() add(properties:get("GroupName")) end)
        pcall(function() add(properties:get("FurnitureType")) end)
        pcall(function() add(properties:get("Type")) end)
    end
    return table.concat(values, " ")
end

-- Restrict this to multi-tile seating (or explicitly named sofas) so normal
-- chairs are never selected. Vanilla large sofas use the furniture_seating
-- tileset and a multi-tile sprite grid; mod sofas normally expose Sofa/Couch
-- in their name or custom property.
local function isLargeSofa(object)
    if not object or isActualBed(object) then return false end
    local text = getObjectSearchText(object)
    local namedSofa = text:find("sofa", 1, true)
        or text:find("couch", 1, true)
        or text:find("loveseat", 1, true)
        or text:find("sectional", 1, true)
    local width, height = getSpriteGridSize(object)
    local multiTile = width and height and (width > 1 or height > 1)
    if namedSofa then return true end
    return multiTile and text:find("furniture_seating", 1, true) ~= nil
end

local function getLargeSofaOnSquare(square)
    if not square then return nil end
    local objects = square:getObjects()
    for index = 0, objects:size() - 1 do
        local object = objects:get(index)
        if isLargeSofa(object) then return object end
    end
    return nil
end

-- Surface offsets are stored in pixels by the tileset.  The engine converts
-- them to world Z with /96 when it places an item on furniture.  IsoDeadBody
-- does not perform that conversion itself, so a corpse otherwise remains on
-- the floor and is visually hidden by a bed.
local function getBedSurfaceOffset(bed)
    if not bed then return nil end
    local ok, offset = pcall(function() return bed:getSurfaceOffsetNoTable() end)
    if not ok or offset == nil then return nil end
    offset = numberOr(offset, 0)
    return offset > 0 and offset or nil
end

local function getFurnitureCenter(object, square)
    local defaultX = square:getX() + 0.5
    local defaultY = square:getY() + 0.5
    if not object then return defaultX, defaultY end

    local grid = nil
    local sprite = nil
    pcall(function() grid = object:getSpriteGrid() end)
    pcall(function() sprite = object:getSprite() end)
    if not grid or not sprite then return defaultX, defaultY end

    local okX, gridX = pcall(function() return grid:getSpriteGridPosX(sprite) end)
    local okY, gridY = pcall(function() return grid:getSpriteGridPosY(sprite) end)
    local okW, width = pcall(function() return grid:getWidth() end)
    local okH, height = pcall(function() return grid:getHeight() end)
    if not okX or not okY or not okW or not okH then return defaultX, defaultY end

    gridX = numberOr(gridX, -1)
    gridY = numberOr(gridY, -1)
    width = numberOr(width, 0)
    height = numberOr(height, 0)
    if gridX < 0 or gridY < 0 or width <= 0 or height <= 0 then return defaultX, defaultY end

    -- The selected bed object can be any tile of a multi-tile furniture grid.
    -- Convert it to the grid origin, then use the center of the full mattress.
    return square:getX() - gridX + (width / 2), square:getY() - gridY + (height / 2)
end

local function getCorpseRenderPosition(record, square)
    return numberOr(record.renderX, square:getX() + 0.5), numberOr(record.renderY, square:getY() + 0.5)
end

local function getCorpseRenderZ(record, square)
    if not square or (record.placement ~= "bed" and record.placement ~= "sofa") then
        return square and square:getZ() or 0
    end

    local isBed = record.placement == "bed"
    local surfaceOffset = numberOr(isBed and record.bedSurfaceOffset or record.sofaSurfaceOffset, nil)
    if surfaceOffset == nil then
        local furniture = isBed and getBedOnSquare(square) or getLargeSofaOnSquare(square)
        surfaceOffset = getBedSurfaceOffset(furniture)
    end

    -- Most vanilla beds expose Surface.  The fallback keeps beds from mods
    -- without that tile property at mattress height (roughly 32 pixels).
    if surfaceOffset == nil then surfaceOffset = 32 end
    return square:getZ() + (surfaceOffset + 1) / 96
end

local function isSamePlacementArea(origin, candidate)
    if not origin or not candidate or origin:getZ() ~= candidate:getZ() then return false end

    local outsideOk, originOutside = pcall(function() return origin:isOutside() end)
    local candidateOutsideOk, candidateOutside = pcall(function() return candidate:isOutside() end)
    if outsideOk and candidateOutsideOk and originOutside ~= candidateOutside then return false end

    local roomOk, originRoom = pcall(function() return origin:getRoom() end)
    local candidateRoomOk, candidateRoom = pcall(function() return candidate:getRoom() end)
    if roomOk and candidateRoomOk and originRoom ~= candidateRoom then return false end
    return true
end

local function setBedPlacement(record, square, bed)
    record.objectX = square:getX()
    record.objectY = square:getY()
    record.objectZ = square:getZ()
    record.renderX, record.renderY = getFurnitureCenter(bed, square)
    record.placement = "bed"
    record.bedFacing = getBedFacing(bed)
    record.bedAxis = getBedAxis(bed)
    record.bedSurfaceOffset = getBedSurfaceOffset(bed)
    record.sofaFacing = nil
    record.sofaAxis = nil
    record.sofaSurfaceOffset = nil
end

local function setSofaPlacement(record, square, sofa)
    record.objectX = square:getX()
    record.objectY = square:getY()
    record.objectZ = square:getZ()
    record.renderX, record.renderY = getFurnitureCenter(sofa, square)
    record.placement = "sofa"
    record.bedFacing = nil
    record.bedAxis = nil
    record.bedSurfaceOffset = nil
    record.sofaFacing = getBedFacing(sofa)
    record.sofaAxis = getFurnitureAxis(sofa)
    record.sofaSurfaceOffset = getBedSurfaceOffset(sofa)
end

local function chooseCorpsePlacement(record)
    local cell = getWorld():getCell()
    local originX = gridCoordinate(record.x)
    local originY = gridCoordinate(record.y)
    local originZ = gridCoordinate(record.z)
    local radius = math.max(0, math.floor(numberOr(OS.getOption("BedRadius", 1), 1)))
    local origin = cell:getGridSquare(originX, originY, originZ)

    -- A bed in the logout square always wins, regardless of where inside the
    -- square the player stood.
    local directBed = getBedOnSquare(origin)
    if directBed then
        setBedPlacement(record, origin, directBed)
        return
    end

    local bestSquare = nil
    local bestBed = nil
    local bestDistance = nil

    for offsetX = -radius, radius do
        for offsetY = -radius, radius do
            local square = cell:getGridSquare(originX + offsetX, originY + offsetY, originZ)
            local bed = isSamePlacementArea(origin, square) and getBedOnSquare(square) or nil
            if bed then
                local dx = (square:getX() + 0.5) - numberOr(record.x, originX)
                local dy = (square:getY() + 0.5) - numberOr(record.y, originY)
                local distance = (dx * dx) + (dy * dy)
                if distance <= (radius * radius) and (not bestDistance or distance < bestDistance) then
                    bestSquare = square
                    bestBed = bed
                    bestDistance = distance
                end
            end
        end
    end

    if bestSquare then
        setBedPlacement(record, bestSquare, bestBed)
        return
    end

    -- Sofas deliberately come after every nearby bed.  This keeps a player
    -- who logs out in a bedroom on the bed, while allowing a large couch to
    -- behave as a raised sleeping surface in a living room.
    local sofaRadius = math.max(0, math.floor(numberOr(OS.getOption("SofaRadius", 1), 1)))
    local directSofa = getLargeSofaOnSquare(origin)
    if directSofa then
        setSofaPlacement(record, origin, directSofa)
        return
    end

    local bestSofaSquare = nil
    local bestSofa = nil
    bestDistance = nil
    for offsetX = -sofaRadius, sofaRadius do
        for offsetY = -sofaRadius, sofaRadius do
            local square = cell:getGridSquare(originX + offsetX, originY + offsetY, originZ)
            local sofa = isSamePlacementArea(origin, square) and getLargeSofaOnSquare(square) or nil
            if sofa then
                local dx = (square:getX() + 0.5) - numberOr(record.x, originX)
                local dy = (square:getY() + 0.5) - numberOr(record.y, originY)
                local distance = (dx * dx) + (dy * dy)
                if distance <= (sofaRadius * sofaRadius) and (not bestDistance or distance < bestDistance) then
                    bestSofaSquare = square
                    bestSofa = sofa
                    bestDistance = distance
                end
            end
        end
    end

    if bestSofaSquare then
        setSofaPlacement(record, bestSofaSquare, bestSofa)
        return
    end

    record.objectX = originX
    record.objectY = originY
    record.objectZ = originZ
    record.renderX = originX + 0.5
    record.renderY = originY + 0.5
    record.placement = "floor"
    record.bedFacing = nil
    record.bedAxis = nil
    record.bedSurfaceOffset = nil
    record.sofaFacing = nil
    record.sofaAxis = nil
    record.sofaSurfaceOffset = nil
end

local function sameSteamId(left, right)
    return left ~= nil and right ~= nil and tostring(left) == tostring(right)
end

local function isNativeCorpse(object)
    if not object then return false end
    local ok, index = pcall(function() return object:getStaticMovingObjectIndex() end)
    return ok and numberOr(index, -1) >= 0
end

local function findOfflineObject(record)
    local object = runtimeObjects[record.steamId]
    if object then return object end

    local square = getRecordSquare(record)
    if not square then return nil end

    local function findIn(list)
        if not list then return nil end
        for index = 0, list:size() - 1 do
            local candidate = list:get(index)
            local data = candidate and candidate:getModData()
            if data and data[OS.OFFLINE_MARKER] and sameSteamId(data.steamId, record.steamId) then
                runtimeObjects[record.steamId] = candidate
                return candidate
            end
        end
        return nil
    end

    -- IsoDeadBody lives in staticMovingObjects, unlike the V2's retired
    -- mannequin implementation which lived in square.objects.
    return findIn(square:getStaticMovingObjects()) or findIn(square:getObjects())
end

local function setOfflineObjectData(object, record)
    local data = object:getModData()
    data[OS.OFFLINE_MARKER] = true
    data.steamId = record.steamId
    data.username = record.username
    data.offlineAt = record.offlineAt
    data.renderer = OS.RENDERER
    data.pose = OS.CORPSE_POSE
    data.placement = record.placement or "floor"
    data.bedFacing = record.bedFacing
    data.bedAxis = record.bedAxis
    data.sofaFacing = record.sofaFacing
    data.sofaAxis = record.sofaAxis
end

local function getCorpseDirection(record)
    local directionName = tostring(record.direction or ""):upper()
    -- The dead-body pose must use the long axis of the furniture. Facing is
    -- only used for head/foot selection when it agrees with that axis; on many
    -- beds Facing identifies a side of the mattress instead.
    if record.placement == "bed" or record.placement == "sofa" then
        local facing = record.placement == "bed" and record.bedFacing or record.sofaFacing
        local axis = record.placement == "bed" and record.bedAxis or record.sofaAxis
        if axis == "x" then
            directionName = (facing == "E" or facing == "W") and facing or "E"
        elseif axis == "y" then
            directionName = (facing == "N" or facing == "S") and facing or "S"
        elseif facing == "N" or facing == "E" or facing == "S" or facing == "W" then
            directionName = facing
        end
    end

    local ok, direction = pcall(function() return IsoDirections[directionName] end)
    if ok and direction then return direction end
    ok, direction = pcall(function() return IsoDirections.S end)
    return ok and direction or nil
end

local function applyCorpseDirection(corpse, direction)
    if not corpse or not direction then return end
    corpse:setForwardIsoDirection(direction)

    -- IsoDeadBody stores a separate render angle. Set it explicitly so the
    -- frozen player/deadbody animation follows the selected bed axis.
    local ok, angle = pcall(function() return direction:toAngle() end)
    if ok and angle then corpse:setForwardDirectionAngle(angle) end
end

local function markVisualClone(item, record)
    if not item then return end
    local data = item:getModData()
    data[OS.VISUAL_CLONE_MARKER] = true
    data.offlineSurvivorV2Owner = tostring(record.steamId)
end

local function cloneHandItem(source, record)
    if not source or not instanceItem then return nil end
    local ok, fullType = pcall(function() return source:getFullType() end)
    if not ok or not fullType or tostring(fullType) == "" then return nil end

    local clone = nil
    ok, clone = pcall(function() return instanceItem(tostring(fullType)) end)
    if not ok or not clone then return nil end
    markVisualClone(clone, record)
    return clone
end

local function createOfflineCorpse(record, square)
    local player = runtimePlayers[record.steamId]
    if not player then return nil, "last player visual is unavailable" end

    local ok, result = pcall(function()
        if not IsoPlayer or not IsoDeadBody or not ItemVisuals or not sendCorpse then
            error("IsoPlayer, IsoDeadBody, ItemVisuals or sendCorpse is unavailable")
        end

        -- The surrogate exists only long enough to use the engine's own
        -- IsoDeadBody conversion. It is never added to the player list and
        -- its inventory only contains rendering-only clones.
        local surrogate = IsoPlayer.new(getWorld():getCell())
        if not surrogate then error("failed to create the visual surrogate") end
        local x, y = getCorpseRenderPosition(record, square)
        local z = getCorpseRenderZ(record, square)
        surrogate:setX(x)
        surrogate:setY(y)
        surrogate:setZ(z)
        surrogate:setNextX(x)
        surrogate:setNextY(y)
        surrogate:setCurrentSquare(square)
        surrogate:setFemale(player:isFemale() == true)

        local direction = getCorpseDirection(record)
        if direction then surrogate:setForwardIsoDirection(direction) end
        surrogate:setFallOnFront(false)
        -- A non-zombie player corpse with KilledByFall uses the native player
        -- "deadbody" pose, rather than the zombie on-ground animation.
        surrogate:setKilledByFall(true)

        local sourceVisuals = ItemVisuals.new()
        player:getItemVisuals(sourceVisuals)
        local worn = surrogate:getWornItems()
        local container = surrogate:getInventory()
        if not worn or not container then error("surrogate did not create a visual container") end

        worn:clear()
        container:clear()
        worn:setFromItemVisuals(sourceVisuals)
        worn:addItemsToItemContainer(container)
        for index = 0, worn:size() - 1 do
            local item = worn:getItemByIndex(index)
            markVisualClone(item, record)
        end

        -- HumanVisual contains skin, hair, beard, blood, dirt and body
        -- details. Its native copyFrom is a deep visual copy.
        surrogate:getHumanVisual():copyFrom(player:getHumanVisual())

        -- Hand models are not part of ItemVisuals.  Use fresh item instances
        -- so neither the real player's item nor its inventory is touched.
        local sourcePrimary = player:getPrimaryHandItem()
        local sourceSecondary = player:getSecondaryHandItem()
        local primary = cloneHandItem(sourcePrimary, record)
        local secondary = sourceSecondary == sourcePrimary and primary or cloneHandItem(sourceSecondary, record)
        if primary then
            container:AddItem(primary)
            surrogate:setPrimaryHandItem(primary)
        end
        if secondary then
            if secondary ~= primary then container:AddItem(secondary) end
            surrogate:setSecondaryHandItem(secondary)
        end

        local corpse = IsoDeadBody.new(surrogate, true, false)
        if not corpse then error("engine did not create the offline corpse") end
        applyCorpseDirection(corpse, direction)
        corpse:setFallOnFront(false)
        corpse:setKilledByFall(true)
        if primary then corpse:setPrimaryHandItem(primary) end
        if secondary then corpse:setSecondaryHandItem(secondary) end

        setOfflineObjectData(corpse, record)
        corpse:setOutlineOnMouseover(true)
        square:addCorpse(corpse, false)
        -- This is the native server packet used by normal corpses. It sends
        -- HumanVisual, worn-item visuals, position and ModData to relevant
        -- clients immediately.
        sendCorpse(corpse)
        -- sendCorpse already serializes this corpse's ModData. Sending an
        -- additional ObjectChange packet here can race the corpse packet on
        -- multiplayer clients, so it must not be transmitted a second time.
        return corpse
    end)

    if not ok then return nil, tostring(result) end
    return result, nil
end

local function createOfflineCorpseObject(record)
    local existing = findOfflineObject(record)
    if existing then
        local data = existing:getModData()
        if isNativeCorpse(existing) and data and data.renderer == OS.RENDERER then
            record.objectCreated = true
            return existing
        end

        -- Clean up a mannequin left by an older V2 build before replacing it.
        local oldSquare = existing:getSquare()
        if oldSquare then
            if isNativeCorpse(existing) then
                oldSquare:removeCorpse(existing, false)
            else
                oldSquare:transmitRemoveItemFromSquare(existing)
            end
        end
        runtimeObjects[record.steamId] = nil
    end

    local square = getRecordSquare(record)
    if not square then
        print("[OfflineSurvivor V2] Logout square is not loaded for " .. tostring(record.username))
        return nil
    end

    local corpse, corpseReason = createOfflineCorpse(record, square)
    if not corpse then
        record.corpseFailure = tostring(corpseReason)
        if not record.corpseFailureReported then
            record.corpseFailureReported = true
            print("[OfflineSurvivor V2] Native corpse failed for " .. tostring(record.username) .. ": " .. record.corpseFailure)
        end
        return nil
    end

    record.corpseFailure = nil
    record.corpseFailureReported = nil
    record.objectCreated = true
    runtimeObjects[record.steamId] = corpse
    print("[OfflineSurvivor V2] Created native player corpse for " .. tostring(record.username) .. " on " .. tostring(record.placement or "floor"))
    return corpse
end

local function removeTrackedObject(record)
    local object = findOfflineObject(record)
    if not object then
        -- A square can be unavailable after a restart.  Do not clear this
        -- record until the square can be inspected for real.
        return getRecordSquare(record) ~= nil
    end

    local square = object:getSquare()
    if not square then return false end
    if isNativeCorpse(object) then
        square:removeCorpse(object, false)
    else
        -- Compatibility cleanup for an object made by an older V2 build.
        square:transmitRemoveItemFromSquare(object)
    end
    runtimeObjects[record.steamId] = nil
    return true
end

local function isCurrentOfflineCorpse(object)
    if not isNativeCorpse(object) then return false end
    local ok, data = pcall(function() return object:getModData() end)
    return ok and data and data[OS.OFFLINE_MARKER] and data.renderer == OS.RENDERER
end

-- Handles update migration as well as a corpse removed by external game
-- systems. A loaded square with no matching object is safe to recreate.
local function refreshTrackedObject(record)
    if not record.objectCreated then return false end
    local object = findOfflineObject(record)
    if object and isCurrentOfflineCorpse(object) then return false end

    if object then
        if not removeTrackedObject(record) then return false end
    elseif not getRecordSquare(record) then
        return false
    end

    record.objectCreated = nil
    runtimeObjects[record.steamId] = nil
    return true
end

local function getInventory(player)
    if not player then return nil end
    local ok, inventory = pcall(function() return player:getInventory() end)
    if ok then return inventory end
    return nil
end

local function getContainerItems(container)
    if not container then return nil end
    local ok, items = pcall(function() return container:getItems() end)
    if ok then return items end
    return nil
end

local function isInventoryContainer(item)
    if not item then return false end
    local ok, result = pcall(function() return item:IsInventoryContainer() end)
    return ok and result == true
end

local function getInnerContainer(item)
    if not isInventoryContainer(item) then return nil end

    local ok, container = pcall(function() return item:getInventory() end)
    if ok and container then return container end

    ok, container = pcall(function() return item:getItemContainer() end)
    if ok and container then return container end
    return nil
end

local function isClothing(item)
    if not item then return false end
    local ok, result = pcall(function() return item:IsClothing() end)
    return ok and result == true
end

local function isWornItem(player, item)
    if not player or not item then return false end
    local ok, worn = pcall(function() return player:getWornItems() end)
    if not ok or not worn then return false end

    local containsOk, result = pcall(function() return worn:contains(item) end)
    return containsOk and result == true
end

local function itemName(item)
    local ok, name = pcall(function() return item:getName() end)
    if ok and name and tostring(name) ~= "" then return tostring(name) end

    ok, name = pcall(function() return item:getFullType() end)
    if ok and name then return tostring(name) end
    return "Item"
end

local function itemId(item)
    local ok, id = pcall(function() return item:getID() end)
    if not ok or id == nil then return nil end
    return tostring(id)
end

local function itemFullType(item)
    local ok, fullType = pcall(function() return item:getFullType() end)
    return ok and tostring(fullType or "") or ""
end

local function itemWeight(item)
    local ok, weight = pcall(function() return item:getActualWeight() end)
    if ok and weight ~= nil then return numberOr(weight, 0) end

    ok, weight = pcall(function() return item:getWeight() end)
    if ok and weight ~= nil then return numberOr(weight, 0) end
    return 0
end

local function itemCondition(item)
    local ok, condition = pcall(function() return item:getCondition() end)
    if ok and condition ~= nil then return numberOr(condition, 0) end
    return 0
end

local function isLootableItem(player, item)
    -- Bags themselves and every clothing item are protected.  Contents of a
    -- bag are scanned separately and remain eligible for theft.
    if isInventoryContainer(item) then return false end
    if isClothing(item) then return false end
    if isWornItem(player, item) then return false end
    return itemId(item) ~= nil
end

local function addLootInfo(result, item, path)
    local id = itemId(item)
    if not id then return end

    result[#result + 1] = {
        itemId = id,
        fullType = itemFullType(item),
        displayName = itemName(item),
        weight = itemWeight(item),
        condition = itemCondition(item),
        containerPath = path,
    }
end

local function buildLootSnapshot(player)
    local result = {}
    local root = getInventory(player)
    if not root then return result end

    local visited = {}
    local function scan(container, path, depth)
        if not container or visited[container] or depth > 8 then return end
        visited[container] = true

        local items = getContainerItems(container)
        if not items then return end

        for index = 0, items:size() - 1 do
            local item = items:get(index)
            local inner = getInnerContainer(item)
            if inner then
                scan(inner, path .. " / " .. itemName(item), depth + 1)
            elseif isLootableItem(player, item) then
                addLootInfo(result, item, path)
            end
        end
    end

    scan(root, "Body", 0)
    table.sort(result, function(left, right)
        return tostring(left.displayName) < tostring(right.displayName)
    end)
    return result
end

local function isPendingTheft(record, wantedId)
    for _, entry in ipairs(record.pendingThefts or {}) do
        if sameSteamId(entry.itemId, wantedId) then return true end
    end
    return false
end

local function removeSnapshotItem(record, wantedId)
    local items = record.lootItems or {}
    for index = #items, 1, -1 do
        if sameSteamId(items[index].itemId, wantedId) then
            table.remove(items, index)
        end
    end
end

local function removePendingTheft(record, wantedId)
    local pending = record.pendingThefts or {}
    for index = #pending, 1, -1 do
        if sameSteamId(pending[index].itemId, wantedId) then
            table.remove(pending, index)
        end
    end
    if #pending == 0 then record.pendingThefts = nil end
end

local function addPendingTheft(record, wantedId, thiefSteamId)
    if isPendingTheft(record, wantedId) then return end
    record.pendingThefts = record.pendingThefts or {}
    record.pendingThefts[#record.pendingThefts + 1] = {
        itemId = tostring(wantedId),
        thiefSteamId = tostring(thiefSteamId),
        atMs = nowMs(),
    }
end

local function findItemInContainer(container, wantedId)
    if not container then return nil end
    local numericId = tonumber(wantedId)
    if not numericId then return nil end

    local ok, item = pcall(function() return container:getItemWithIDRecursiv(numericId) end)
    if ok and item then return item end
    return nil
end

local function playerHasEquippedItem(player, item)
    if not player or not item then return false end
    local ok, result = pcall(function() return player:isEquipped(item) end)
    return ok and result == true
end

local function markInventoryDirty(container)
    if not container then return end
    pcall(function() container:setDrawDirty(true) end)
end

local function removeItemFromPlayer(player, item)
    if not player or not item then return false end

    local ok, source = pcall(function() return item:getContainer() end)
    if not ok or not source then return false end

    local equipped = playerHasEquippedItem(player, item)
    if equipped then pcall(function() player:removeFromHands(item) end) end

    ok = pcall(function() source:Remove(item) end)
    if not ok then return false end

    pcall(sendRemoveItemFromContainer, source, item)
    if equipped then pcall(sendEquip, player) end
    markInventoryDirty(source)
    return true
end

-- The corpse needs cloned InventoryItems for the native renderer to keep
-- modded clothing/backpacks visible. They are never loot: normal clients are
-- blocked in OS_Client and this server-side sweep removes any clone that a
-- modified client somehow transferred into a real player's inventory.
local function isVisualClone(item)
    if not item then return false end
    local ok, data = pcall(function() return item:getModData() end)
    return ok and data and data[OS.VISUAL_CLONE_MARKER] == true
end

local function purgeVisualClones(player)
    local root = getInventory(player)
    if not root then return end

    local visited = {}
    local function scan(container, depth)
        if not container or visited[container] or depth > 8 then return end
        visited[container] = true
        local items = getContainerItems(container)
        if not items then return end

        for index = items:size() - 1, 0, -1 do
            local item = items:get(index)
            if isVisualClone(item) then
                removeItemFromPlayer(player, item)
            else
                scan(getInnerContainer(item), depth + 1)
            end
        end
    end
    scan(root, 0)
end

local function moveItemToRobber(target, robber, item)
    if not target or not robber or not item then return false end

    local destination = getInventory(robber)
    if not destination then return false end

    local ok, source = pcall(function() return item:getContainer() end)
    if not ok or not source then return false end

    local equipped = playerHasEquippedItem(target, item)
    if equipped then pcall(function() target:removeFromHands(item) end) end

    -- AddItem(InventoryItem) keeps the original instance, including modded
    -- item data, and detaches it from its old ItemContainer.
    local added
    ok, added = pcall(function() return destination:AddItem(item) end)
    if not ok or not added then return false end

    pcall(sendRemoveItemFromContainer, source, item)
    pcall(sendAddItemToContainer, destination, item)
    if equipped then pcall(sendEquip, target) end
    markInventoryDirty(source)
    markInventoryDirty(destination)
    return true
end

local function reconcilePendingThefts(record, player)
    local pending = record.pendingThefts
    if not pending or #pending == 0 then return end

    local inventory = getInventory(player)
    if not inventory then return end

    for index = #pending, 1, -1 do
        local entry = pending[index]
        local item = findItemInContainer(inventory, entry.itemId)
        -- If it is absent, the save already reflects the transfer.  If it is
        -- present, remove the saved copy before this player can use it.
        if not item or removeItemFromPlayer(player, item) then
            table.remove(pending, index)
        end
    end
    if #pending == 0 then record.pendingThefts = nil end
end

local function discardPendingEntriesFromSnapshot(record)
    for _, entry in ipairs(record.pendingThefts or {}) do
        removeSnapshotItem(record, entry.itemId)
    end
end

local function isStaffPlayer(player)
    if not player then return false end
    local ok, accessLevel = pcall(function() return player:getAccessLevel() end)
    if not ok or accessLevel == nil then return false end
    accessLevel = tostring(accessLevel):lower()
    return accessLevel ~= "" and accessLevel ~= "none"
end

local function isAdminTestActive(player)
    if OS.getOption("AdminTestBodyWhenHidden", false) == false or not isStaffPlayer(player) then return false end

    local invisible = false
    local noClip = false
    pcall(function() invisible = player:isInvisible() == true end)
    pcall(function() noClip = player:isNoClip() == true end)
    return invisible or noClip
end

local function shouldBlockAdminOfflineBody(record)
    return record.testBody ~= true
        and OS.getOption("BlockAdminOfflineBodies", false) ~= false
        and record.adminBody == true
end

local function markOffline(record, isTestBody)
    if record.state == "offline" or record.state == "test_offline" then return end

    record.state = isTestBody and "test_offline" or "offline"
    record.testBody = isTestBody == true or nil
    record.offlineAt = nowSeconds()
    record.offlineAtHours = nowHours()
    chooseCorpsePlacement(record)
    record.despawned = nil
    record.corpseFailure = nil
    record.corpseFailureReported = nil

    local player = runtimePlayers[record.steamId]
    record.adminBody = isStaffPlayer(player) == true or nil
    record.lootItems = buildLootSnapshot(player)
    record.lootSnapshotAtMs = nowMs()
    record.lootSnapshotAvailable = player ~= nil
    discardPendingEntriesFromSnapshot(record)

    if shouldBlockAdminOfflineBody(record) then
        record.bodySuppressed = true
        record.objectCreated = nil
        print("[OfflineSurvivor V2] Offline body suppressed for administrator " .. tostring(record.username))
    else
        record.bodySuppressed = nil
        if isTestBody then
            print("[OfflineSurvivor V2] Admin hidden/noclip test body created for " .. tostring(record.username))
        else
            print("[OfflineSurvivor V2] Player disconnected: " .. tostring(record.username))
        end
        createOfflineCorpseObject(record)
    end
    persistentDataChanged()
end

local function restoreRecord(record)
    local removed = removeTrackedObject(record)
    record.pendingRemoval = not removed
    if removed then
        record.objectX, record.objectY, record.objectZ, record.objectCreated = nil, nil, nil, nil
        record.placement, record.bedFacing, record.bedAxis, record.bedSurfaceOffset = nil, nil, nil, nil
        record.sofaFacing, record.sofaAxis, record.sofaSurfaceOffset = nil, nil, nil
    end
    record.state = "online"
    record.offlineAt = nil
    record.offlineAtHours = nil
    record.despawned = nil
    record.corpseFailure = nil
    record.corpseFailureReported = nil
    record.testBody = nil
    record.adminBody = nil
    record.bodySuppressed = nil
end

local function trackOnlinePlayer(player)
    if not OS.isEnabled() then return end
    local steamId = OS.getSteamId(player)
    if not steamId then return end

    local hadRecord = records[steamId] ~= nil
    local record = records[steamId] or { steamId = steamId }
    local previousState = record.state
    runtimePlayers[steamId] = player

    -- A real reconnection must reconcile saved theft before control returns.
    -- A test body is different: its owner never left the server.
    if previousState == "offline" then
        reconcilePendingThefts(record, player)
        restoreRecord(record)
    elseif previousState == "test_offline" and not isAdminTestActive(player) then
        restoreRecord(record)
    end

    record.username = player:getUsername()
    record.x = player:getX()
    record.y = player:getY()
    record.z = player:getZ()
    record.direction = tostring(player:getDir())
    record.lastSeen = nowSeconds()

    if isAdminTestActive(player) then
        if record.state ~= "test_offline" then
            markOffline(record, true)
        end
        records[steamId] = record
        return
    end

    record.state = "online"
    record.lootItems = nil
    record.lootSnapshotAtMs = nil
    record.lootSnapshotAvailable = nil
    records[steamId] = record

    if not lastHeartbeatLog[steamId] or nowSeconds() - lastHeartbeatLog[steamId] >= 10 then
        lastHeartbeatLog[steamId] = nowSeconds()
        print("[OfflineSurvivor V2] SERVER tracking active player " .. tostring(record.username))
    end
    if previousState == "offline" or previousState == "test_offline" or not hadRecord then persistentDataChanged() end
end

local function scanOnlinePlayers()
    local connected = {}
    local players = getOnlinePlayers()
    for index = 0, players:size() - 1 do
        local player = players:get(index)
        local steamId = OS.getSteamId(player)
        if steamId then
            connected[steamId] = true
            purgeVisualClones(player)
            trackOnlinePlayer(player)
        end
    end
    return connected
end

local function getMaxLootItems()
    local value = math.floor(numberOr(OS.getOption("LootMaxItems", 3), 3))
    return math.max(1, math.min(value, 20))
end

local function cooldownRemainingMs(steamId)
    local hours = math.max(0, numberOr(OS.getOption("LootCooldownHours", 24), 24))
    if hours <= 0 then return 0 end

    local lastLoot = numberOr(lootCooldowns[steamId], 0)
    local remaining = (lastLoot + (hours * 60 * 60 * 1000)) - nowMs()
    return math.max(0, remaining)
end

local function cooldownMessage(remainingMs)
    local minutes = math.max(1, math.ceil(remainingMs / 60000))
    local hours = math.floor(minutes / 60)
    local rest = minutes % 60
    if hours > 0 then
        return "You can search again in " .. hours .. "h " .. rest .. "min."
    end
    return "You can search again in " .. minutes .. " minute(s)."
end

local function isNearRecord(player, record)
    if not player or record.objectX == nil or record.objectY == nil or record.objectZ == nil then return false end
    if math.floor(player:getZ()) ~= math.floor(record.objectZ) then return false end

    local radius = math.max(1, numberOr(OS.getOption("LootDistance", 2), 2))
    local targetX = numberOr(record.renderX, record.objectX + 0.5)
    local targetY = numberOr(record.renderY, record.objectY + 0.5)
    local dx = player:getX() - targetX
    local dy = player:getY() - targetY
    return (dx * dx) + (dy * dy) <= (radius * radius)
end

local function hasValidOfflineObject(record)
    if not record or (record.state ~= "offline" and record.state ~= "test_offline") or record.despawned then return false end
    local object = findOfflineObject(record)
    if not object then return false end
    local data = object:getModData()
    return data and data[OS.OFFLINE_MARKER] and sameSteamId(data.steamId, record.steamId)
end

local function buildAvailableLoot(record)
    local result = {}
    for _, info in ipairs(record.lootItems or {}) do
        if info and info.itemId and not isPendingTheft(record, info.itemId) then
            result[#result + 1] = {
                itemId = tostring(info.itemId),
                fullType = tostring(info.fullType or ""),
                displayName = tostring(info.displayName or "Item"),
                weight = numberOr(info.weight, 0),
                condition = numberOr(info.condition, 0),
                containerPath = tostring(info.containerPath or "Body"),
            }
        end
    end
    return result
end

local function makeAvailableItemMap(record)
    local map = {}
    for _, info in ipairs(record.lootItems or {}) do
        if info and info.itemId and not isPendingTheft(record, info.itemId) then
            map[tostring(info.itemId)] = info
        end
    end
    return map
end

local function denyLoot(player, message)
    sendTo(player, OS.COMMAND_LOOT_NOTICE, { message = message })
end

local function clearLootSession(steamId, sessionId)
    local session = lootSessions[steamId]
    if not session then return nil end
    if sessionId and tonumber(session.id) ~= tonumber(sessionId) then return nil end
    lootSessions[steamId] = nil
    return session
end

local function requestLoot(player, args)
    if not OS.isEnabled() or OS.getOption("EnableLoot", true) == false then
        denyLoot(player, "Offline survivor looting is disabled.")
        return
    end

    local looterSteamId = OS.getSteamId(player)
    local targetSteamId = args and args.targetSteamId and tostring(args.targetSteamId) or nil
    if not looterSteamId or not targetSteamId or targetSteamId == "" or sameSteamId(looterSteamId, targetSteamId) then
        denyLoot(player, "Invalid target.")
        return
    end

    local record = records[targetSteamId]
    if not record or not hasValidOfflineObject(record) then
        denyLoot(player, "This offline survivor is no longer available.")
        return
    end
    if not isNearRecord(player, record) then
        denyLoot(player, "You are too far away to search this survivor.")
        return
    end
    if not runtimePlayers[targetSteamId] then
        denyLoot(player, "This inventory can only be searched while the server still retains the disconnected player in memory.")
        return
    end

    local remaining = cooldownRemainingMs(looterSteamId)
    if remaining > 0 then
        denyLoot(player, cooldownMessage(remaining))
        return
    end

    local items = buildAvailableLoot(record)
    if #items == 0 then
        denyLoot(player, "There are no items available to steal here.")
        return
    end

    local sessionId = nextSessionId
    nextSessionId = nextSessionId + 1
    lootSessions[looterSteamId] = {
        id = sessionId,
        targetSteamId = targetSteamId,
        expiresAtMs = nowMs() + (OS.LOOT_SESSION_SECONDS * 1000),
        allowedItems = makeAvailableItemMap(record),
    }

    sendTo(player, OS.COMMAND_OPEN_LOOT, {
        sessionId = sessionId,
        targetName = tostring(record.username or "Player"),
        maxItems = getMaxLootItems(),
        items = items,
    })
end

local function collectRequestedIds(rawIds, limit)
    local ids = {}
    local seen = {}
    if type(rawIds) ~= "table" then return ids end

    for _, rawId in pairs(rawIds) do
        local id = tostring(rawId)
        if id ~= "" and not seen[id] then
            seen[id] = true
            ids[#ids + 1] = id
            if #ids > limit then return nil end
        end
    end
    return ids
end

local function finishLoot(player, looterSteamId, sessionId, success, message, count)
    clearLootSession(looterSteamId, sessionId)
    sendTo(player, OS.COMMAND_LOOT_RESULT, {
        sessionId = sessionId,
        success = success == true,
        count = count or 0,
        message = message,
    })
end

local function commitLoot(player, args)
    local looterSteamId = OS.getSteamId(player)
    local requestedSessionId = args and args.sessionId
    local session = looterSteamId and lootSessions[looterSteamId] or nil
    if not session or tonumber(session.id) ~= tonumber(requestedSessionId) then
        denyLoot(player, "The search session expired. Open the list again.")
        return
    end

    if nowMs() > session.expiresAtMs then
        finishLoot(player, looterSteamId, session.id, false, "The search session expired.", 0)
        return
    end
    if not OS.isEnabled() or OS.getOption("EnableLoot", true) == false then
        finishLoot(player, looterSteamId, session.id, false, "Offline survivor looting is disabled.", 0)
        return
    end

    local record = records[session.targetSteamId]
    local target = runtimePlayers[session.targetSteamId]
    if not record or not target or not hasValidOfflineObject(record) then
        finishLoot(player, looterSteamId, session.id, false, "This offline survivor is no longer available.", 0)
        return
    end
    if not isNearRecord(player, record) then
        finishLoot(player, looterSteamId, session.id, false, "You moved too far away from the survivor.", 0)
        return
    end

    local remaining = cooldownRemainingMs(looterSteamId)
    if remaining > 0 then
        finishLoot(player, looterSteamId, session.id, false, cooldownMessage(remaining), 0)
        return
    end

    local limit = getMaxLootItems()
    local requestedIds = collectRequestedIds(args and args.itemIds, limit)
    if not requestedIds or #requestedIds == 0 then
        finishLoot(player, looterSteamId, session.id, false, "Select at least one valid item.", 0)
        return
    end

    local currentItems = makeAvailableItemMap(record)
    local targetInventory = getInventory(target)
    if not targetInventory then
        finishLoot(player, looterSteamId, session.id, false, "The survivor's inventory is not available right now.", 0)
        return
    end

    local taken = 0
    for _, wantedId in ipairs(requestedIds) do
        local snapshotInfo = session.allowedItems[wantedId]
        local currentInfo = currentItems[wantedId]
        local item = findItemInContainer(targetInventory, wantedId)
        if snapshotInfo and currentInfo and item and isLootableItem(target, item) then
            -- Register the pending deletion first.  If the victim's saved
            -- inventory still contains this item on reconnect, it is removed
            -- before control returns to the victim.
            addPendingTheft(record, wantedId, looterSteamId)
            persistentDataChanged()
            if moveItemToRobber(target, player, item) then
                removeSnapshotItem(record, wantedId)
                taken = taken + 1
            else
                removePendingTheft(record, wantedId)
            end
        end
    end

    if taken <= 0 then
        finishLoot(player, looterSteamId, session.id, false, "None of the selected items were still available.", 0)
        return
    end

    -- One cooldown is global to the looter, as requested: after a successful
    -- search they cannot search another offline survivor until it expires.
    lootCooldowns[looterSteamId] = nowMs()
    persistentDataChanged()
    finishLoot(player, looterSteamId, session.id, true, "Stole " .. taken .. " item(s).", taken)
end

local function cancelLoot(player, args)
    local looterSteamId = OS.getSteamId(player)
    if looterSteamId then clearLootSession(looterSteamId, args and args.sessionId) end
end

local function expireLootSessions()
    local current = nowMs()
    for steamId, session in pairs(lootSessions) do
        if current > session.expiresAtMs then
            lootSessions[steamId] = nil
        end
    end
end

local function maintainOfflineRecords(connected)
    local changed = false

    -- EnableMod is read live. Disabling it removes existing V2 corpses;
    -- enabling it later recreates eligible offline records without restart.
    if not OS.isEnabled() then
        for _, record in pairs(records) do
            if record.objectCreated and removeTrackedObject(record) then
                record.objectCreated = nil
                changed = true
            end
        end
        if changed then persistentDataChanged() end
        return
    end

    local maxHours = math.max(0, numberOr(OS.getOption("DespawnHours", 0), 0))

    for steamId, record in pairs(records) do
        if record.state == "online" and not connected[steamId] then
            markOffline(record)
        elseif record.state == "test_offline" then
            if refreshTrackedObject(record) then changed = true end
            -- Recreate a test corpse if EnableMod was toggled off and back on
            -- while the administrator remained invisible/noclip.
            if isAdminTestActive(runtimePlayers[steamId])
                and not record.objectCreated
                and not record.corpseFailure
                and createOfflineCorpseObject(record) then
                changed = true
            end
        elseif record.state == "offline" then
            if refreshTrackedObject(record) then changed = true end
            local expired = false
            if not record.despawned and maxHours > 0 then
                local offlineAtHours = numberOr(record.offlineAtHours, nowHours())
                expired = nowHours() - offlineAtHours >= maxHours
            end

            if expired then
                if removeTrackedObject(record) then changed = true end
                record.objectCreated = nil
                record.despawned = true
                runtimeObjects[steamId] = nil
                changed = true
            -- This setting is evaluated every second, so turning it on removes
            -- an existing administrator body and turning it off can create it.
            elseif shouldBlockAdminOfflineBody(record) then
                if record.objectCreated and removeTrackedObject(record) then
                    record.objectCreated = nil
                    changed = true
                end
                record.bodySuppressed = true
            elseif record.bodySuppressed then
                record.bodySuppressed = nil
                changed = true
                if not record.corpseFailure and createOfflineCorpseObject(record) then changed = true end
            elseif not record.despawned and not record.objectCreated and not record.corpseFailure then
                if createOfflineCorpseObject(record) then changed = true end
            end
        end

        if record.pendingRemoval and removeTrackedObject(record) then
            record.pendingRemoval = nil
            record.objectX, record.objectY, record.objectZ, record.objectCreated = nil, nil, nil, nil
            record.placement, record.bedFacing, record.bedAxis, record.bedSurfaceOffset = nil, nil, nil, nil
            record.sofaFacing, record.sofaAxis, record.sofaSurfaceOffset = nil, nil, nil
            changed = true
        end
    end

    if changed then persistentDataChanged() end
end

local function onTick()
    if nowSeconds() < nextMaintenance then return end
    nextMaintenance = nowSeconds() + OS.SERVER_SCAN_SECONDS
    expireLootSessions()
    maintainOfflineRecords(scanOnlinePlayers())
end

local function onInitGlobalModData()
    records = ModData.getOrCreate(OS.DATA_KEY)
    lootCooldowns = ModData.getOrCreate(OS.LOOT_DATA_KEY)
    runtimeObjects = {}
    runtimePlayers = {}
    lootSessions = {}
    print("[OfflineSurvivor V2] SERVER script initialized.")
end

local function onClientCommand(module, command, player, args)
    if module ~= OS.MODULE then return end

    if command == OS.COMMAND_REQUEST_LOOT then
        requestLoot(player, args)
    elseif command == OS.COMMAND_COMMIT_LOOT then
        commitLoot(player, args)
    elseif command == OS.COMMAND_CANCEL_LOOT then
        cancelLoot(player, args)
    end
end

Events.OnInitGlobalModData.Add(onInitGlobalModData)
Events.OnClientCommand.Add(onClientCommand)
Events.OnTick.Add(onTick)
