require "EBFCopyPaste/EBFCopyPaste_Shared"

EBFCopyPasteServer = EBFCopyPasteServer or {}
EBFCopyPasteServer.clipboards = EBFCopyPasteServer.clipboards or {}
EBFCopyPasteServer.copyJobs = EBFCopyPasteServer.copyJobs or {}
EBFCopyPasteServer.pasteJobs = EBFCopyPasteServer.pasteJobs or {}
EBFCopyPasteServer.exportJobs = EBFCopyPasteServer.exportJobs or {}
EBFCopyPasteServer.importJobs = EBFCopyPasteServer.importJobs or {}
EBFCopyPasteServer.canceledImportSessions = EBFCopyPasteServer.canceledImportSessions or {}

pcall(require, "EBFCopyPaste/Server/FidelityAudit")

if EBFCopyPaste.ensureJavaRoomDefBridge then
    local editorBridgeOk, roomsFileBridgeOk = EBFCopyPaste.ensureJavaRoomDefBridge()
    print("[EBFCopyPaste] Puente RoomDef B42.20: BuildingRoomsEditor="
            .. tostring(editorBridgeOk) .. " PlayerRoomsFile=" .. tostring(roomsFileBridgeOk))
end

function EBFCopyPasteServer.allowPersistentRoomDefWrites()
    return EBFCopyPaste.RebuildRoomDefs ~= false
end

function EBFCopyPasteServer.isAuthoritativeWorld()
    return not (isClient and isClient())
end

local function clientReconcileShouldIncludeRoomDefs(reason)
    reason = tostring(reason or "")
    return reason == "roomDefsApplied"
end

function EBFCopyPasteServer.buildClientRoomDefReconcilePayload(job, reason)
    if not job or not job.clipboard or not clientReconcileShouldIncludeRoomDefs(reason) then
        return nil
    end

    local specs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard) or {}
    if #specs <= 0 then
        return nil
    end

    local payload = {}
    for _, spec in ipairs(specs) do
        local rects = {}
        for _, rect in ipairs(spec.rects or {}) do
            local rectW = math.max(1, EBFCopyPaste.toInt(rect.w, 1))
            local rectH = math.max(1, EBFCopyPaste.toInt(rect.h, 1))
            table.insert(rects, {
                x = EBFCopyPaste.toInt(rect.x, 0),
                y = EBFCopyPaste.toInt(rect.y, 0),
                w = rectW,
                h = rectH,
            })
        end
        if #rects > 0 then
            table.insert(payload, {
                key = tostring(spec.key or ""),
                dz = EBFCopyPaste.toInt(spec.dz, 0),
                name = tostring(spec.name or spec.sourceRoomDefName or "room"),
                lightsActive = spec.lightsActive == true,
                rects = rects,
            })
        end
    end

    if #payload <= 0 then
        return nil
    end
    return payload
end

local function getPlayerKey(playerObj)
    if playerObj and playerObj.getUsername then
        return playerObj:getUsername()
    end
    return "singleplayer"
end

local function sendFeedback(playerObj, args)
    args = args or {}
    if sendServerCommand then
        sendServerCommand(playerObj, EBFCopyPaste.Module, EBFCopyPaste.Commands.Feedback, args)
    end
end

function EBFCopyPasteServer.sendClientPasteAreaReconcile(job, reason)
    if not job or not job.clipboard or not sendServerCommand then
        return false
    end

    local reasonText = reason or "pasteStart"
    local finalAckReason = reasonText == "pasteDone" or reasonText == "restoreDone"
    local offsets = {}
    if type(job.clipboard.zOffsets) == "table" then
        for _, value in ipairs(job.clipboard.zOffsets) do
            local offset = tonumber(value)
            if offset ~= nil then
                table.insert(offsets, math.floor(offset))
            end
        end
    end

    local width = math.max(1, math.floor(tonumber(job.clipboard.w) or 1))
    local height = math.max(1, math.floor(tonumber(job.clipboard.h) or 1))
    local levelCount = #offsets > 0 and #offsets or math.max(1, math.floor(tonumber(job.clipboard.levels) or 1))
    local expectedSquares = width * height * levelCount
    local roomSpecs = EBFCopyPasteServer.buildClientRoomDefReconcilePayload(job, reason)
    local expectedRoomRects = nil
    if finalAckReason and roomSpecs and EBFCopyPasteServer.countRoomSpecRects then
        expectedRoomRects = EBFCopyPasteServer.countRoomSpecRects(roomSpecs)
    end
    sendServerCommand(EBFCopyPaste.Module, EBFCopyPaste.Commands.ReconcilePasteArea, {
        x = job.targetX,
        y = job.targetY,
        z = job.targetZ,
        w = width,
        h = height,
        levels = tonumber(job.clipboard.levels) or 1,
        zOffsets = offsets,
        roomSpecs = roomSpecs,
        roomSpecVersion = roomSpecs and 1 or nil,
        roomDefReconcileId = roomSpecs and job.clientRoomDefReconcileId or nil,
        finalClientAckId = finalAckReason and job.finalClientAckId or nil,
        expectedSquares = finalAckReason and expectedSquares or nil,
        expectedObjects = finalAckReason and #(job.clipboard.objects or {}) or nil,
        expectedRoomDefs = finalAckReason and roomSpecs and #roomSpecs or nil,
        expectedRoomRects = expectedRoomRects,
        reason = reasonText,
    })
    job.clientAreaReconcileSent = true
    job.clientAreaReconcileReason = reasonText
    EBFCopyPasteServer.logStage(job, EBFCopyPasteServer.makeStageKey("clientAreaReconcile", reasonText),
            "CLIENT reconcilePasteArea enviado: destino="
            .. tostring(job.targetX) .. "," .. tostring(job.targetY) .. "," .. tostring(job.targetZ)
            .. " tamanho=" .. tostring(width) .. "x" .. tostring(height)
            .. " levels=" .. tostring(tonumber(job.clipboard.levels) or 1)
            .. " roomSpecs=" .. tostring(roomSpecs and #roomSpecs or 0)
            .. " motivo=" .. tostring(reasonText)
            .. " finalAckId=" .. tostring(finalAckReason and job.finalClientAckId or "")
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    return true
end

local function nowMs()
    if getTimestampMs then
        return getTimestampMs()
    end
    return os.time() * 1000
end

function EBFCopyPasteServer.stageLogEnabled()
    return EBFCopyPaste.StageLogEnabled ~= false
end

function EBFCopyPasteServer.getStageJobPlayerName(job)
    local playerObj = job and job.playerObj or nil
    if playerObj and playerObj.getUsername then
        return tostring(playerObj:getUsername())
    end
    return "singleplayer"
end

function EBFCopyPasteServer.getStageJobTitle(job)
    local clipboard = job and job.clipboard or nil
    return tostring(clipboard and clipboard.title or job and job.saveName or "Zona Copy")
end

function EBFCopyPasteServer.logStage(job, key, message)
    if not EBFCopyPasteServer.stageLogEnabled() then
        return
    end
    if job and key then
        job.stageLogKeys = job.stageLogKeys or {}
        if job.stageLogKeys[key] then
            return
        end
        job.stageLogKeys[key] = true
    end
    print("[EBFCopyPaste][ETAPA] " .. tostring(message))
end

function EBFCopyPasteServer.stampCurrentClipboardSchema(clipboard)
    if type(clipboard) ~= "table" then
        return clipboard
    end

    clipboard.format = EBFCopyPaste.ClipboardFormat or "EBFCopyPasteArea"
    clipboard.targetBuild = EBFCopyPaste.TargetBuild or "42.20"
    clipboard.buildTarget = EBFCopyPaste.TargetBuild or "42.20"
    clipboard.schemaVersion = EBFCopyPaste.SchemaVersion or 4220001
    clipboard.scannerMetadataVersion = EBFCopyPaste.ScannerMetadataVersion or 4
    clipboard.compatibility = "b42.20-strict"
    return clipboard
end

function EBFCopyPasteServer.isCurrentClipboardSchema(clipboard)
    if EBFCopyPaste.RequireCurrentSaveSchema ~= true then
        return type(clipboard) == "table"
    end
    if type(clipboard) ~= "table" then
        return false
    end
    if tostring(clipboard.format or "") ~= tostring(EBFCopyPaste.ClipboardFormat or "EBFCopyPasteArea") then
        return false
    end
    if tonumber(clipboard.schemaVersion) ~= tonumber(EBFCopyPaste.SchemaVersion or 4220001) then
        return false
    end
    local expectedScannerVersion = tonumber(EBFCopyPaste.ScannerMetadataVersion or 0) or 0
    local scannerVersion = tonumber(clipboard.scannerMetadataVersion or 0) or 0
    if expectedScannerVersion > 0 and scannerVersion < expectedScannerVersion then
        return false
    end
    local targetBuild = tostring(EBFCopyPaste.TargetBuild or "42.20")
    return tostring(clipboard.targetBuild or clipboard.buildTarget or "") == targetBuild
end

function EBFCopyPasteServer.currentSchemaRejectMessage()
    return "Save antigo/incompativel. Esta versao limpa aceita somente copias novas do EBFCopyPaste B42.20; reescaneie a area."
end

function EBFCopyPasteServer.makeStageKey(prefix, value)
    return tostring(prefix or "stage") .. ":" .. tostring(value or "")
end

local function escapeLuaString(value)
    value = tostring(value or "")
    value = value:gsub("\\", "\\\\")
    value = value:gsub("\r", "\\r")
    value = value:gsub("\n", "\\n")
    value = value:gsub("\t", "\\t")
    value = value:gsub("\"", "\\\"")
    return "\"" .. value .. "\""
end

local function serializeLuaValue(value, depth, seen)
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
        return escapeLuaString(value)
    end
    if valueType ~= "table" or depth > 64 then
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
        table.insert(parts, "[" .. serializeLuaValue(key, depth + 1, seen) .. "]=" .. serializeLuaValue(value[key], depth + 1, seen) .. ",")
    end
    for _, key in ipairs(otherKeys) do
        table.insert(parts, "[" .. serializeLuaValue(key, depth + 1, seen) .. "]=" .. serializeLuaValue(value[key], depth + 1, seen) .. ",")
    end
    table.insert(parts, "}")
    seen[value] = nil
    return table.concat(parts)
end

local function deserializeLuaTable(text)
    if type(text) ~= "string" or text == "" or not loadstring then
        return nil
    end

    local chunk, loadError = loadstring(text)
    if not chunk then
        print("[EBFCopyPaste] Ha fallado la carga de la importación de la copia de seguridad de la casa segura: " .. tostring(loadError))
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

local function payloadSaveCountMatches(payload)
    if type(payload) ~= "table" or type(payload.saves) ~= "table" then
        return false
    end

    local declaredCount = tonumber(payload.saveCount)
    if declaredCount ~= nil and declaredCount ~= #payload.saves then
        return false
    end
    return true
end

local function isPrimitive(value)
    local valueType = type(value)
    return valueType == "string" or valueType == "number" or valueType == "boolean"
end

function EBFCopyPasteServer.isInternalModDataKey(key)
    if type(key) ~= "string" then
        return false
    end
    if key == (EBFCopyPaste.PasteKeyModDataKey or "EBFCopyPastePasteKey")
            or key == "EBFCopyPasteB42EntityInitialized" then
        return true
    end
    return string.sub(key, 1, 12) == "EBFCopyPaste"
end

function EBFCopyPasteServer.isTransientPlacementModDataKey(key)
    if type(key) ~= "string" then
        return false
    end
    if key == "itemCondition" then
        return true
    end
    return string.match(key, "_customContainerName$") ~= nil
end

function EBFCopyPasteServer.tableHasEntries(value)
    if type(value) ~= "table" then
        return false
    end

    for _ in pairs(value) do
        return true
    end
    return false
end

function EBFCopyPasteServer.copyModDataValue(value, depth, seen)
    depth = depth or 0
    if isPrimitive(value) then
        return value
    end
    if type(value) ~= "table" or depth > 8 then
        return nil
    end
    seen = seen or {}
    if seen[value] then
        return nil
    end
    seen[value] = true

    local copied = {}
    for key, child in pairs(value) do
        if isPrimitive(key) then
            local copiedChild = EBFCopyPasteServer.copyModDataValue(child, depth + 1, seen)
            if copiedChild ~= nil then
                copied[key] = copiedChild
            end
        end
    end

    seen[value] = nil
    return copied
end

local function sanitizeSaveName(value)
    value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then
        value = "Zona Copy"
    end
    return value:sub(1, 64)
end

local function copyModData(object)
    if not object or not object.hasModData or not object.getModData or not object:hasModData() then
        return nil
    end

    local copied = nil
    local source = object:getModData()
    for key, value in pairs(source) do
        if isPrimitive(key) and not EBFCopyPasteServer.isInternalModDataKey(key) then
            local copiedValue = EBFCopyPasteServer.copyModDataValue(value, 0, {})
            if copiedValue ~= nil then
                copied = copied or {}
                copied[key] = copiedValue
            end
        end
    end
    return copied
end

local function applyModData(object, modData, options)
    if not object or not modData or not object.getModData then
        return
    end

    local skipKeys = options and options.skipKeys or nil
    local target = object:getModData()
    for key, value in pairs(modData) do
        if not EBFCopyPasteServer.isInternalModDataKey(key) and (not skipKeys or not skipKeys[key]) then
            target[key] = value
        end
    end
end

function EBFCopyPasteServer.clearTransientPlacementModData(object, entry, transmit)
    if not object or not object.getModData then
        return false
    end

    local modData = object:getModData()
    if not modData then
        return false
    end

    local sourceModData = entry and entry.modData or nil
    local changed = false
    for key, _ in pairs(modData) do
        if EBFCopyPasteServer.isTransientPlacementModDataKey(key)
                and not (sourceModData and sourceModData[key] ~= nil) then
            modData[key] = nil
            changed = true
        end
    end

    if changed and transmit == true and object.transmitModData then
        pcall(function()
            object:transmitModData()
        end)
    end
    return changed
end

local function getMethod(object, methodName)
    if not object then
        return nil
    end

    local ok, method = pcall(function()
        return object[methodName]
    end)
    if ok then
        return method
    end
    return nil
end

local function callMethod(object, methodName, ...)
    local method = getMethod(object, methodName)
    if not method then
        return nil
    end

    local ok, result = pcall(method, object, ...)
    if ok then
        return result
    end
    return nil
end

function EBFCopyPasteServer.tryCallMethod(object, methodName, ...)
    local method = getMethod(object, methodName)
    if not method then
        return false, nil
    end

    local ok, result = pcall(method, object, ...)
    if ok then
        return true, result
    end
    return false, nil
end

local function isInstance(object, className)
    if not object or not instanceof then
        return false
    end

    local ok, result = pcall(instanceof, object, className)
    return ok and result == true
end

local function getSpritePropertiesByName(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return nil
    end

    local sprite = getSprite(spriteName)
    return sprite and sprite:getProperties() or nil
end

function EBFCopyPasteServer.spritePropsHas(props, propertyName, isoFlag)
    if not props then
        return false
    end

    if propertyName ~= nil then
        local ok, hasProperty = pcall(function()
            return props:has(propertyName)
        end)
        if ok and hasProperty then
            return true
        end
    end

    if isoFlag ~= nil then
        local ok, hasFlag = pcall(function()
            return props:has(isoFlag)
        end)
        if ok and hasFlag then
            return true
        end
    end
    return false
end

local function spriteHasAnyProperty(spriteName, names)
    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return false
    end

    for _, name in ipairs(names) do
        if EBFCopyPasteServer.spritePropsHas(props, name) then
            return true
        end
    end
    return false
end

function EBFCopyPasteServer.getSpritePropertyValue(spriteName, name)
    local props = getSpritePropertiesByName(spriteName)
    if not props or type(name) ~= "string" or name == "" then
        return nil
    end

    local ok, value = pcall(function()
        return props:get(name)
    end)
    if ok then
        return value
    end
    return nil
end

function EBFCopyPasteServer.getSpriteIsoType(spriteName)
    local isoType = EBFCopyPasteServer.getSpritePropertyValue(spriteName, "IsoType")
    if type(isoType) == "string" and isoType ~= "" then
        return isoType
    end
    return nil
end

function EBFCopyPasteServer.javaListToStringArray(list, limit)
    if not list then
        return nil
    end

    local size = tonumber(callMethod(list, "size")) or 0
    if size <= 0 then
        return nil
    end

    limit = math.max(1, tonumber(limit) or size)
    local result = {}
    for index = 0, math.min(size - 1, limit - 1) do
        local value = callMethod(list, "get", index)
        if value ~= nil then
            local text = tostring(value)
            if text ~= "" then
                table.insert(result, text)
            end
        end
    end

    if #result == 0 then
        return nil
    end
    return result
end

function EBFCopyPasteServer.captureSpriteFactoryInfo(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return nil
    end

    local sprite = getSprite(spriteName)
    if not sprite then
        return nil
    end

    local info = {
        sprite = spriteName,
        isoType = EBFCopyPasteServer.getSpriteIsoType(spriteName),
    }

    local spriteType = sprite.getType and sprite:getType() or nil
    if spriteType ~= nil then
        info.spriteType = tostring(spriteType)
    end

    local propsClass = EBFCopyPasteServer.ensureMoveableSpriteProps and EBFCopyPasteServer.ensureMoveableSpriteProps() or nil
    if propsClass and propsClass.new then
        local ok, props = pcall(function()
            return propsClass.new(sprite)
        end)
        if ok and props then
            info.hasMoveableProps = true
            info.moveable = props.isMoveable == true
            info.type = type(props.type) == "string" and props.type or nil
            info.moveableIsoType = type(props.isoType) == "string" and props.isoType or nil
            info.container = type(props.container) == "string" and props.container or nil
            info.isTable = props.isTable == true
            info.isTableTop = props.isTableTop == true
            info.isMultiSprite = props.isMultiSprite == true
        end
    end

    return info
end

EBFCopyPasteServer.SpritePropertySnapshotNames = EBFCopyPasteServer.SpritePropertySnapshotNames or {
    "IsoType",
    "MoveType",
    "CustomItem",
    "CustomName",
    "GroupName",
    "Material",
    "MaterialType",
    "container",
    "Facing",
    "Noffset",
    "Soffset",
    "Woffset",
    "Eoffset",
    "Surface",
    "IsSurfaceOffset",
    "IsTable",
    "IsTableTop",
    "IsMoveAble",
    "PickUpWeight",
    "waterPiped",
    "lightR",
    "lightG",
    "lightB",
    "LightRadius",
    "LightSwitch",
    "lightswitch",
    "streetlight",
    "BlocksPlacement",
    "CanScrap",
    "ScrapSize",
    "AmbientSound",
}

EBFCopyPasteServer.SpriteFlagSnapshotNames = EBFCopyPasteServer.SpriteFlagSnapshotNames or {
    "solid",
    "solidtrans",
    "solidfloor",
    "trans",
    "invisible",
    "hidewalls",
    "exterior",
    "NoWallLighting",
    "WallN",
    "WallW",
    "WallNW",
    "WallSE",
    "WallNTrans",
    "WallWTrans",
    "windowN",
    "windowW",
    "WindowN",
    "WindowW",
    "doorN",
    "doorW",
    "DoorWallN",
    "DoorWallW",
    "cutN",
    "cutW",
    "NeverCutaway",
    "forceRender",
    "alwaysDraw",
    "transparentN",
    "transparentW",
    "transparentFloor",
    "WallOverlay",
    "FloorOverlay",
    "HasLightOnSprite",
    "unlit",
    "open",
    "canBeRemoved",
    "collideN",
    "collideW",
    "waterPiped",
    "water",
    "container",
    "SpriteConfig",
    "EntityScript",
    "BlockRain",
    "isEave",
    "openAir",
    "IsFloorAttached",
    "attachedN",
    "attachedS",
    "attachedE",
    "attachedW",
    "attachedFloor",
    "attachedSurface",
    "attachedCeiling",
    "attachedNW",
    "attachedSE",
    "FloorAttachmentN",
    "FloorAttachmentS",
    "FloorAttachmentE",
    "FloorAttachmentW",
}

function EBFCopyPasteServer.resolveIsoFlagType(flagName)
    if not IsoFlagType or type(flagName) ~= "string" or flagName == "" then
        return nil
    end

    local ok, flag = pcall(function()
        return IsoFlagType[flagName]
    end)
    if ok then
        return flag
    end
    return nil
end

function EBFCopyPasteServer.captureSpriteProperties(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return nil
    end

    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return nil
    end

    local snapshot = {}
    for _, propertyName in ipairs(EBFCopyPasteServer.SpritePropertySnapshotNames or {}) do
        local value = EBFCopyPasteServer.getSpritePropertyValue(spriteName, propertyName)
        if isPrimitive(value) then
            snapshot[propertyName] = value
        end
    end

    local propertyNames = EBFCopyPasteServer.javaListToStringArray(callMethod(props, "getPropertyNames"), 512)
    local allProperties = {}
    for _, propertyName in ipairs(propertyNames or {}) do
        local value = EBFCopyPasteServer.getSpritePropertyValue(spriteName, propertyName)
        if isPrimitive(value) then
            snapshot[propertyName] = value
            allProperties[propertyName] = value
        end
    end
    if propertyNames then
        snapshot.propertyNames = propertyNames
    end
    if EBFCopyPasteServer.tableHasEntries(allProperties) then
        snapshot.allProperties = allProperties
    end

    local flags = {}
    local flagNames = EBFCopyPasteServer.javaListToStringArray(callMethod(props, "getFlagsList"), 512)
    for _, flagName in ipairs(flagNames or {}) do
        flags[flagName] = true
    end
    for _, flagName in ipairs(EBFCopyPasteServer.SpriteFlagSnapshotNames or {}) do
        local isoFlag = EBFCopyPasteServer.resolveIsoFlagType(flagName)
        if EBFCopyPasteServer.spritePropsHas(props, flagName, isoFlag) then
            flags[flagName] = true
        end
    end
    if flagNames then
        snapshot.flagNames = flagNames
    end
    if EBFCopyPasteServer.tableHasEntries(flags) then
        snapshot.flags = flags
    end

    if not EBFCopyPasteServer.tableHasEntries(snapshot) then
        return nil
    end
    return snapshot
end

function EBFCopyPasteServer.captureSpritePropertiesSafe(spriteName)
    local ok, result = pcall(EBFCopyPasteServer.captureSpriteProperties, spriteName)
    if ok then
        return result
    end
    return nil
end

function EBFCopyPasteServer.captureVanillaPlacementIdentity(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return nil
    end

    local props = EBFCopyPasteServer.getVanillaMoveableProps and EBFCopyPasteServer.getVanillaMoveableProps({ sprite = spriteName }) or nil
    if not props then
        return nil
    end

    local identity = {
        sprite = spriteName,
        isoType = props.isoType,
        moveType = props.type,
        name = props.name,
        groupName = props.groupName,
        customItem = props.customItem,
        facing = props.facing,
        container = props.container,
        isMoveable = props.isMoveable == true,
        isTable = props.isTable == true,
        isTableTop = props.isTableTop == true,
        isMultiSprite = props.isMultiSprite == true,
        ignoreSurfaceSnap = props.ignoreSurfaceSnap == true,
        isGridExtensionTile = props.isGridExtensionTile == true,
        rawWeight = tonumber(props.rawWeight),
        weight = tonumber(props.weight),
        canUsePlaceMoveableInternal = props.placeMoveableInternal ~= nil,
    }

    if type(identity.customItem) == "string"
            and identity.customItem ~= ""
            and identity.customItem ~= "Moveables.Moveable" then
        identity.customItemExists = EBFCopyPasteServer.itemScriptExists(identity.customItem)
    end
    return identity
end

function EBFCopyPasteServer.splitSpriteSheetAndNumber(spriteName)
    if type(spriteName) ~= "string" then
        return nil, nil
    end

    local sheet, numberText = string.match(spriteName, "^(.*)_(%d+)$")
    local number = tonumber(numberText)
    if type(sheet) == "string" and number then
        return sheet, number
    end
    return nil, nil
end

function EBFCopyPasteServer.propsNumericValue(props, propertyName)
    if not props or type(propertyName) ~= "string" then
        return nil
    end

    local ok, value = pcall(function()
        return props:get(propertyName)
    end)
    if ok then
        return tonumber(value)
    end
    return nil
end

function EBFCopyPasteServer.spriteHasDoorFlag(spriteName, north)
    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return false
    end

    if north == true then
        return EBFCopyPasteServer.spritePropsHas(props, "doorN", IsoFlagType and IsoFlagType.doorN or nil)
    end
    if north == false then
        return EBFCopyPasteServer.spritePropsHas(props, "doorW", IsoFlagType and IsoFlagType.doorW or nil)
    end
    return EBFCopyPasteServer.spritePropsHas(props, "doorN", IsoFlagType and IsoFlagType.doorN or nil)
            or EBFCopyPasteServer.spritePropsHas(props, "doorW", IsoFlagType and IsoFlagType.doorW or nil)
end

function EBFCopyPasteServer.spriteHasWindowFlag(spriteName, north)
    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return false
    end

    if north == true then
        return EBFCopyPasteServer.spritePropsHas(props, "windowN", IsoFlagType and IsoFlagType.windowN or nil)
    end
    if north == false then
        return EBFCopyPasteServer.spritePropsHas(props, "windowW", IsoFlagType and IsoFlagType.windowW or nil)
    end
    return EBFCopyPasteServer.spritePropsHas(props, "windowN", IsoFlagType and IsoFlagType.windowN or nil)
            or EBFCopyPasteServer.spritePropsHas(props, "windowW", IsoFlagType and IsoFlagType.windowW or nil)
end

function EBFCopyPasteServer.getCanonicalWindowSprite(spriteName, state, north)
    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return spriteName
    end

    local sheet, number = EBFCopyPasteServer.splitSpriteSheetAndNumber(spriteName)
    local stateMethods = state and state.methods or {}
    if state and state.open == true and sheet and number then
        for _, offsetProperty in ipairs({ "OpenTileOffset", "SmashedTileOffset", "GlassRemovedOffset" }) do
            for offset = 1, 128 do
                local candidate = sheet .. "_" .. tostring(number - offset)
                local candidateProps = getSpritePropertiesByName(candidate)
                if candidateProps
                        and EBFCopyPasteServer.getSpritePropertyValue(candidate, "MoveType") == "Window"
                        and EBFCopyPasteServer.propsNumericValue(candidateProps, offsetProperty) == offset then
                    return candidate
                end
            end
        end
    end

    if EBFCopyPasteServer.spriteHasWindowFlag(spriteName, north)
            or EBFCopyPasteServer.spritePropsHas(props, "IsClosedState")
            or EBFCopyPasteServer.propsNumericValue(props, "OpenTileOffset")
            or EBFCopyPasteServer.propsNumericValue(props, "SmashedTileOffset")
            or EBFCopyPasteServer.propsNumericValue(props, "GlassRemovedOffset") then
        return spriteName
    end

    if not sheet or not number then
        return spriteName
    end

    local preferredOffsets = {}
    if state and state.open == true then
        table.insert(preferredOffsets, "OpenTileOffset")
    end
    if stateMethods.setSmashed == true or stateMethods.setBroken == true then
        table.insert(preferredOffsets, "SmashedTileOffset")
    end
    if stateMethods.setGlassRemoved == true then
        table.insert(preferredOffsets, "GlassRemovedOffset")
    end
    table.insert(preferredOffsets, "OpenTileOffset")
    table.insert(preferredOffsets, "SmashedTileOffset")
    table.insert(preferredOffsets, "GlassRemovedOffset")

    local checked = {}
    for _, offsetProperty in ipairs(preferredOffsets) do
        if not checked[offsetProperty] then
            checked[offsetProperty] = true
            for offset = 1, 128 do
                local candidate = sheet .. "_" .. tostring(number - offset)
                local candidateProps = getSpritePropertiesByName(candidate)
                if candidateProps
                        and EBFCopyPasteServer.getSpritePropertyValue(candidate, "MoveType") == "Window"
                        and EBFCopyPasteServer.propsNumericValue(candidateProps, offsetProperty) == offset then
                    return candidate
                end
            end
        end
    end

    return spriteName
end

function EBFCopyPasteServer.getCanonicalDoorSprite(spriteName, state, north)
    local sheet, number = EBFCopyPasteServer.splitSpriteSheetAndNumber(spriteName)
    if state and state.open == true and sheet and number then
        for offset = 1, 8 do
            local candidate = sheet .. "_" .. tostring(number - offset)
            if EBFCopyPasteServer.spriteHasDoorFlag(candidate, north) then
                return candidate
            end
        end
    end

    if EBFCopyPasteServer.spriteHasDoorFlag(spriteName, north) then
        return spriteName
    end

    if not sheet or not number then
        return spriteName
    end

    local maxOffset = state and state.open == true and 8 or 4
    for offset = 1, maxOffset do
        local candidate = sheet .. "_" .. tostring(number - offset)
        if EBFCopyPasteServer.spriteHasDoorFlag(candidate, north) then
            return candidate
        end
    end

    return spriteName
end

local function isLightSwitchSprite(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return false
    end

    local sprite = getSprite(spriteName)
    if not sprite then
        return false
    end

    if IsoObjectType then
        local ok, spriteType = pcall(function()
            return sprite:getType()
        end)
        if ok and spriteType == IsoObjectType.lightswitch then
            return true
        end
    end

    return spriteHasAnyProperty(spriteName, {
        "LightSwitch",
        "lightswitch",
        "streetlight",
        "lightR",
        "lightG",
        "lightB",
        "lightRadius",
    })
end

local function getObjectSpriteName(object)
    local sprite = callMethod(object, "getSprite")
    return sprite and callMethod(sprite, "getName") or nil
end

function EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object)
    if type(entry) == "table" then
        if entry.isResidentialSwitch == true
                or entry.objectLayer == "residentialLightSwitch"
                or entry.classificationSubtype == "residentialSwitch" then
            return true
        end
        local classification = entry.classification or (entry.identity and entry.identity.classification) or nil
        if classification and classification.subtype == "residentialSwitch" then
            return true
        end
        local binding = entry.lightBinding
        if binding and (binding.isResidentialSwitch == true
                or binding.objectLayer == "residentialLightSwitch"
                or binding.classificationSubtype == "residentialSwitch") then
            return true
        end
    end

    local spriteName = entry and entry.sprite or getObjectSpriteName(object)
    if type(spriteName) ~= "string" or string.sub(spriteName, 1, 19) ~= "lighting_indoor_01_" then
        return false
    end

    local customName = EBFCopyPasteServer.getSpritePropertyValue(spriteName, "CustomName")
    return type(customName) == "string" and string.lower(customName) == "switch"
end

function EBFCopyPasteServer.entryIsOutdoorLight(entry, object)
    local spriteName = entry and entry.sprite or getObjectSpriteName(object)
    return EBFCopyPasteServer.spriteNameStartsWith(spriteName, "lighting_outdoor_")
end

local function objectLooksLikeLightSwitch(object)
    if isInstance(object, "IsoLightSwitch") then
        return true
    end

    return isLightSwitchSprite(getObjectSpriteName(object))
end

function EBFCopyPasteServer.containerTypeLooksLikeStove(containerType)
    containerType = type(containerType) == "string" and containerType:lower() or ""
    return containerType == "microwave" or containerType == "stove"
end

function EBFCopyPasteServer.spriteLooksLikeStove(spriteName)
    local isoType = EBFCopyPasteServer.getSpritePropertyValue(spriteName, "IsoType")
    if isoType == "IsoStove" then
        return true
    end
    return EBFCopyPasteServer.containerTypeLooksLikeStove(EBFCopyPasteServer.getSpritePropertyValue(spriteName, "container"))
end

function EBFCopyPasteServer.objectLooksLikeStove(object)
    if isInstance(object, "IsoStove") then
        return true
    end
    if EBFCopyPasteServer.spriteLooksLikeStove(getObjectSpriteName(object)) then
        return true
    end

    local count = tonumber(callMethod(object, "getContainerCount") or 0) or 0
    for i = 0, count - 1 do
        local container = callMethod(object, "getContainerByIndex", i)
        if EBFCopyPasteServer.containerTypeLooksLikeStove(callMethod(container, "getType")) then
            return true
        end
    end

    local container = callMethod(object, "getContainer")
    return EBFCopyPasteServer.containerTypeLooksLikeStove(callMethod(container, "getType"))
end

function EBFCopyPasteServer.entryLooksLikeStove(entry)
    if not entry then
        return false
    end
    if entry.objectClass == "IsoStove" or EBFCopyPasteServer.spriteLooksLikeStove(entry.sprite) then
        return true
    end
    for _, snapshot in ipairs(entry.containers or {}) do
        if EBFCopyPasteServer.containerTypeLooksLikeStove(snapshot and snapshot.type) then
            return true
        end
    end
    return false
end

local function copyIfSupported(source, target, getterName, setterName)
    local value = callMethod(source, getterName)
    if value ~= nil then
        callMethod(target, setterName, value)
    end
end

local itemCopyMethods = {
    { "getCondition", "setCondition" },
    { "getUsedDelta", "setUsedDelta" },
    { "getCurrentUses", "setCurrentUses" },
    { "getCurrentUsesFloat", "setCurrentUsesFloat" },
    { "getCurrentAmmoCount", "setCurrentAmmoCount" },
    { "isRoundChambered", "setRoundChambered" },
    { "isContainsClip", "setContainsClip" },
    { "isFavorite", "setFavorite" },
    { "isActivated", "setActivated" },
    { "getHaveBeenRepaired", "setHaveBeenRepaired" },
    { "getKeyId", "setKeyId" },
    { "getAge", "setAge" },
    { "getCookingTime", "setCookingTime" },
    { "isCooked", "setCooked" },
    { "isBurnt", "setBurnt" },
    { "isFrozen", "setFrozen" },
    { "isTaintedWater", "setTaintedWater" },
    { "getColor", "setColor" },
    { "getName", "setName" },
    { "getWorldTexture", "setWorldTexture" },
    { "getWorldStaticItem", "setWorldStaticItem" },
    { "getWorldStaticModel", "setWorldStaticModel" },
    { "getWorldZRotation", "setWorldZRotation" },
    { "getWorldYRotation", "setWorldYRotation" },
    { "getWorldXRotation", "setWorldXRotation" },
    { "getWorldScale", "setWorldScale" },
    { "isLight", "setLight" },
    { "getLightUseBattery", "setLightUseBattery" },
    { "getLightHasBattery", "setLightHasBattery" },
    { "getLightBulbItem", "setLightBulbItem" },
    { "getLightPower", "setLightPower" },
    { "getLightDelta", "setLightDelta" },
    { "getLightR", "setLightR" },
    { "getLightG", "setLightG" },
    { "getLightB", "setLightB" },
}

local objectCopyMethods = {
    { "getName", "setName" },
    { "getHealth", "setHealth" },
    { "getMaxHealth", "setMaxHealth" },
    { "getThumpDmg", "setThumpDmg" },
    { "getKeyId", "setKeyId" },
    { "isLocked", "setIsLocked" },
    { "isLockedByKey", "setLockedByKey" },
    { "isLockedByPadlock", "setLockedByPadlock" },
    { "getLockedByCode", "setLockedByCode" },
    { "isPermaLocked", "setPermaLocked" },
    { "isSmashed", "setSmashed" },
    { "isGlassRemoved", "setGlassRemoved" },
    { "isBroken", "setBroken" },
    { "Activated", "setActivated" },
    { "getTimer", "setTimer" },
    { "getMaxTemperature", "setMaxTemperature" },
    { "isMovedThumpable", "setMovedThumpable" },
    { "isThumpable", "setIsThumpable" },
    { "isBlockAllTheSquare", "setBlockAllTheSquare" },
    { "getCanPassThrough", "setCanPassThrough" },
    { "isCanPassThrough", "setCanPassThrough" },
    { "isHoppable", "setHoppable" },
    { "isCanBarricade", "setCanBarricade" },
    { "canBePlastered", "setCanBePlastered" },
    { "isPaintable", "setPaintable" },
    { "isFloor", "setIsFloor" },
    { "isStairs", "setIsStairs" },
    { "isCorner", "setIsCorner" },
    { "getRenderYOffset", "setRenderYOffset" },
}

local lightCopyMethods = {
    { "isActivated", "setActivated" },
    { "getUseBattery", "setUseBattery" },
    { "getHasBattery", "setHasBattery" },
    { "getPower", "setPower" },
    { "getCanBeModified", "setCanBeModified" },
    { "getDelta", "setDelta" },
    { "getPrimaryR", "setPrimaryR" },
    { "getPrimaryG", "setPrimaryG" },
    { "getPrimaryB", "setPrimaryB" },
}

function EBFCopyPasteServer.capturePrimitiveMethodValues(object, specs)
    local values = {}
    local methods = {}
    for _, spec in ipairs(specs or {}) do
        local getterName = type(spec) == "table" and spec[1] or spec
        local keyName = type(spec) == "table" and (spec[2] or spec[1]) or spec
        if type(getterName) == "string" and getterName ~= "" then
            if getMethod(object, getterName) then
                methods[getterName] = true
                local value = callMethod(object, getterName)
                if isPrimitive(value) then
                    values[keyName] = value
                end
            end
        end
    end

    if not EBFCopyPasteServer.tableHasEntries(values) then
        values = nil
    end
    if not EBFCopyPasteServer.tableHasEntries(methods) then
        methods = nil
    end
    return values, methods
end

function EBFCopyPasteServer.captureDeviceData(object)
    local deviceData = callMethod(object, "getDeviceData")
    if not deviceData then
        return nil
    end

    local properties, methods = EBFCopyPasteServer.capturePrimitiveMethodValues(deviceData, {
        { "getDeviceName", "deviceName" },
        { "getDeviceVolume", "deviceVolume" },
        { "getPower", "power" },
        { "getChannel", "channel" },
        { "getIsTurnedOn", "turnedOn" },
        { "getIsBatteryPowered", "batteryPowered" },
        { "getHasBattery", "hasBattery" },
        { "getUseDelta", "useDelta" },
        { "getHeadphoneType", "headphoneType" },
        { "getMicRange", "micRange" },
        { "getBaseVolumeRange", "baseVolumeRange" },
        { "getMinChannelRange", "minChannelRange" },
        { "getMaxChannelRange", "maxChannelRange" },
        { "getDeviceVolumeRange", "deviceVolumeRange" },
        { "getIsHighTier", "highTier" },
        { "getIsTelevision", "television" },
        { "getIsPortable", "portable" },
        { "getTwoWay", "twoWay" },
        { "getTransmitRange", "transmitRange" },
    })

    local snapshot = {
        turnedOn = callMethod(deviceData, "getIsTurnedOn"),
        channel = callMethod(deviceData, "getChannel"),
        volume = callMethod(deviceData, "getDeviceVolume"),
        power = callMethod(deviceData, "getPower"),
    }

    if properties then
        snapshot.properties = properties
    end
    if methods then
        snapshot.methods = methods
    end

    local mediaItem = callMethod(deviceData, "getMediaItem")
    if mediaItem then
        local mediaFullType = callMethod(mediaItem, "getFullType")
        if type(mediaFullType) ~= "string" or mediaFullType == "" then
            local moduleName = callMethod(mediaItem, "getModule")
            local typeName = callMethod(mediaItem, "getType")
            if type(moduleName) == "string" and type(typeName) == "string" then
                mediaFullType = moduleName .. "." .. typeName
            end
        end
        snapshot.mediaItem = {
            fullType = mediaFullType,
            id = tonumber(callMethod(mediaItem, "getID")),
            name = callMethod(mediaItem, "getName"),
            type = callMethod(mediaItem, "getType"),
            module = callMethod(mediaItem, "getModule"),
        }
    end

    if snapshot.turnedOn ~= nil
            or snapshot.channel ~= nil
            or snapshot.volume ~= nil
            or snapshot.power ~= nil
            or snapshot.properties ~= nil
            or snapshot.methods ~= nil
            or snapshot.mediaItem ~= nil then
        return snapshot
    end
    return nil
end

function EBFCopyPasteServer.deviceTargetHasSquare(object)
    if not object then
        return false
    end
    if callMethod(object, "getSquare") ~= nil then
        return true
    end
    local worldItem = callMethod(object, "getWorldItem")
    return worldItem and callMethod(worldItem, "getSquare") ~= nil
end

function EBFCopyPasteServer.applyDeviceDataSnapshot(object, snapshot, options)
    if not object or not snapshot then
        return false
    end
    options = options or {}

    local deviceData = callMethod(object, "getDeviceData")
    if not deviceData then
        return false
    end

    if snapshot.channel ~= nil then
        local channel = math.floor(tonumber(snapshot.channel) or 0)
        if getMethod(deviceData, "setChannelRaw") then
            callMethod(deviceData, "setChannelRaw", channel)
        else
            EBFCopyPasteServer.tryCallMethod(deviceData, "setChannel", channel, false)
        end
    end
    if snapshot.volume ~= nil then
        if getMethod(deviceData, "setDeviceVolumeRaw") then
            callMethod(deviceData, "setDeviceVolumeRaw", snapshot.volume)
        else
            EBFCopyPasteServer.tryCallMethod(deviceData, "setDeviceVolume", snapshot.volume)
        end
    end
    if snapshot.power ~= nil and options.skipPower ~= true then
        EBFCopyPasteServer.tryCallMethod(deviceData, "setPower", snapshot.power)
    end

    if getMethod(deviceData, "setTurnedOnRaw") then
        callMethod(deviceData, "setTurnedOnRaw", false)
    elseif EBFCopyPasteServer.deviceTargetHasSquare(object) then
        callMethod(deviceData, "setIsTurnedOn", false)
    end

    return true
end

function EBFCopyPasteServer.applySafeWaveSignalSnapshot(object, snapshot)
    if not object or not snapshot then
        return false
    end

    return EBFCopyPasteServer.applyDeviceDataSnapshot(object, {
        channel = snapshot.channel,
        volume = snapshot.volume,
        turnedOn = false,
    }, { skipPower = true })
end

local function getItemFullType(item)
    if not item then
        return nil
    end

    local ok, fullType = pcall(function()
        return item:getFullType()
    end)
    if type(fullType) == "string" and fullType ~= "" then
        return fullType
    end

    fullType = callMethod(item, "getFullType")
    if type(fullType) == "string" and fullType ~= "" then
        return fullType
    end

    local moduleName = nil
    local typeName = nil
    ok, moduleName = pcall(function()
        return item:getModule()
    end)
    if not ok then
        moduleName = nil
    end
    ok, typeName = pcall(function()
        return item:getType()
    end)
    if not ok then
        typeName = nil
    end
    if type(moduleName) ~= "string" or moduleName == "" then
        moduleName = callMethod(item, "getModule")
    end
    if type(typeName) ~= "string" or typeName == "" then
        typeName = callMethod(item, "getType")
    end
    if type(moduleName) == "string" and type(typeName) == "string" then
        return moduleName .. "." .. typeName
    end
    return nil
end

local function getItemSnapshotFullType(itemSnapshot)
    if type(itemSnapshot) ~= "table" then
        return nil
    end
    if type(itemSnapshot.fullType) == "string" and itemSnapshot.fullType ~= "" then
        return itemSnapshot.fullType
    end

    local moduleName = itemSnapshot.module or itemSnapshot.moduleName
    local typeName = itemSnapshot.type or itemSnapshot.typeName
    if type(moduleName) == "string" and moduleName ~= "" and type(typeName) == "string" and typeName ~= "" then
        return moduleName .. "." .. typeName
    end
    return nil
end

function EBFCopyPasteServer.getWorldInventoryObjectItem(worldObject)
    if not worldObject then
        return nil
    end

    local ok, item = pcall(function()
        return worldObject:getItem()
    end)
    if ok and item then
        return item
    end

    item = callMethod(worldObject, "getItem")
    if item then
        return item
    end

    if EBFCopyPasteServer.safeField then
        item = EBFCopyPasteServer.safeField(worldObject, "item")
        if item then
            return item
        end
    end

    local ok, fieldItem = pcall(function()
        return worldObject.item
    end)
    if ok and fieldItem then
        return fieldItem
    end
    return nil
end

function EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, axis)
    if not worldObject then
        return nil
    end

    local methodName = nil
    local fieldName = nil
    if axis == "x" or axis == "X" then
        methodName = "getOffX"
        fieldName = "xoff"
    elseif axis == "y" or axis == "Y" then
        methodName = "getOffY"
        fieldName = "yoff"
    elseif axis == "z" or axis == "Z" then
        methodName = "getOffZ"
        fieldName = "zoff"
    end
    if not methodName then
        return nil
    end

    local ok, value = nil, nil
    if methodName == "getOffX" then
        ok, value = pcall(function()
            return worldObject:getOffX()
        end)
    elseif methodName == "getOffY" then
        ok, value = pcall(function()
            return worldObject:getOffY()
        end)
    elseif methodName == "getOffZ" then
        ok, value = pcall(function()
            return worldObject:getOffZ()
        end)
    end
    if ok and tonumber(value) ~= nil then
        return tonumber(value)
    end

    value = callMethod(worldObject, methodName)
    if tonumber(value) ~= nil then
        return tonumber(value)
    end

    if EBFCopyPasteServer.safeField then
        value = EBFCopyPasteServer.safeField(worldObject, fieldName)
        if tonumber(value) ~= nil then
            return tonumber(value)
        end
    end
    local okField, fieldValue = pcall(function()
        return worldObject[fieldName]
    end)
    if okField and tonumber(fieldValue) ~= nil then
        return tonumber(fieldValue)
    end
    return nil
end

function EBFCopyPasteServer.itemScriptExists(fullType)
    if type(fullType) ~= "string" or fullType == "" then
        return false
    end

    local manager = getScriptManager and getScriptManager() or (ScriptManager and ScriptManager.instance) or nil
    if not manager then
        return true
    end

    local ok, scriptItem = pcall(function()
        return manager:FindItem(fullType)
    end)
    if ok then
        return scriptItem ~= nil
    end

    ok, scriptItem = pcall(function()
        return manager:getItem(fullType)
    end)
    return ok and scriptItem ~= nil
end

function EBFCopyPasteServer.safeInstanceItem(fullType)
    if type(fullType) ~= "string" or fullType == "" or not EBFCopyPasteServer.itemScriptExists(fullType) then
        return nil
    end

    if instanceItem then
        local ok, item = pcall(instanceItem, fullType)
        if ok and item then
            return item
        end
    end

    if InventoryItemFactory and InventoryItemFactory.CreateItem then
        local ok, item = pcall(function()
            return InventoryItemFactory.CreateItem(fullType)
        end)
        if ok and item then
            return item
        end
    end

    return nil
end

local cloneItemObject
local makePersistentItemSnapshot

function EBFCopyPasteServer.prepareSpawnedInventoryItem(item)
    if item and callMethod(item, "getType") == "CorpseAnimal" then
        callMethod(item, "createAndStoreDefaultDeadBody", nil)
    end
    return item
end

local function clearItemContainer(container, transmit)
    if not container then
        return
    end

    local items = callMethod(container, "getItems")
    if items then
        for i = items:size() - 1, 0, -1 do
            local item = items:get(i)
            callMethod(container, "Remove", item)
            if transmit and sendRemoveItemFromContainer then
                sendRemoveItemFromContainer(container, item)
            end
        end
    end

    if callMethod(container, "isEmpty") == false and getMethod(container, "clear") then
        callMethod(container, "clear")
    end
end

local function addItemCloneToContainer(container, sourceItem, transmit, depth, stats)
    if not container or not sourceItem then
        return nil
    end

    local cloned = cloneItemObject(sourceItem, depth or 0, stats)
    if not cloned then
        return nil
    end

    callMethod(container, "AddItem", cloned)
    if transmit and sendAddItemToContainer then
        sendAddItemToContainer(container, cloned)
    end
    return cloned
end

local function cloneContainerItems(sourceContainer, targetContainer, transmit, depth, stats)
    if not sourceContainer or not targetContainer or (depth or 0) > 12 then
        return
    end

    clearItemContainer(targetContainer, transmit)
    local items = callMethod(sourceContainer, "getItems")
    if not items then
        return
    end

    for i = 0, items:size() - 1 do
        addItemCloneToContainer(targetContainer, items:get(i), transmit, (depth or 0) + 1, stats)
    end
end

local function copyItemState(sourceItem, targetItem)
    if not sourceItem or not targetItem then
        return
    end

    for _, methodPair in ipairs(itemCopyMethods) do
        copyIfSupported(sourceItem, targetItem, methodPair[1], methodPair[2])
    end

    local sourceFluid = callMethod(sourceItem, "getFluidContainer")
    local targetFluid = callMethod(targetItem, "getFluidContainer")
    if sourceFluid and targetFluid then
        callMethod(targetFluid, "copyFluidsFrom", sourceFluid)
    end

    EBFCopyPasteServer.applyDeviceDataSnapshot(targetItem, EBFCopyPasteServer.captureDeviceData(sourceItem))

    local sourceModData = callMethod(sourceItem, "getModData")
    if sourceModData then
        callMethod(targetItem, "copyModData", sourceModData)
    end

    callMethod(targetItem, "copyBloodLevelFrom", sourceItem)
    callMethod(sourceItem, "copyPatchesTo", targetItem)
end

cloneItemObject = function(sourceItem, depth, stats)
    depth = depth or 0
    if not sourceItem or depth > 12 then
        return nil
    end

    local fullType = getItemFullType(sourceItem)
    if not fullType then
        return nil
    end

    local cloned = EBFCopyPasteServer.safeInstanceItem(fullType)
    if not cloned then
        return nil
    end
    EBFCopyPasteServer.prepareSpawnedInventoryItem(cloned)

    if stats then
        stats.items = (stats.items or 0) + 1
    end

    copyItemState(sourceItem, cloned)

    local sourceContainer = callMethod(sourceItem, "getItemContainer")
    local targetContainer = callMethod(cloned, "getItemContainer")
    if sourceContainer and targetContainer then
        cloneContainerItems(sourceContainer, targetContainer, false, depth + 1, stats)
    end

    return cloned
end

local function createContainerSnapshot(container, index, stats)
    if not container then
        return nil
    end

    local explored = callMethod(container, "isExplored")
    if explored == nil then
        explored = callMethod(container, "getExplored")
    end

    local customName = nil
    local parent = callMethod(container, "getParent")
    if parent then
        customName = callMethod(container, "getCustomName") or callMethod(container, "getName")
    end
    customName = customName or callMethod(container, "getType")

    local snapshot = {
        index = index or 0,
        type = callMethod(container, "getType"),
        explored = explored ~= false,
        capacity = callMethod(container, "getCapacity"),
        weightReduction = callMethod(container, "getWeightReduction"),
        customName = customName,
        items = {},
    }

    if stats then
        stats.containers = (stats.containers or 0) + 1
    end

    return snapshot
end

local function copyContainerSnapshot(container, index, stats, depth)
    local snapshot = createContainerSnapshot(container, index, stats)
    if not snapshot then
        return nil
    end

    local items = callMethod(container, "getItems")
    if items then
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            local itemSnapshot = makePersistentItemSnapshot and makePersistentItemSnapshot(item, (depth or 0) + 1) or nil
            if itemSnapshot then
                if stats then
                    stats.items = (stats.items or 0) + 1
                end
                table.insert(snapshot.items, itemSnapshot)
            else
                local cloned = cloneItemObject(item, 0, stats)
                if cloned then
                    table.insert(snapshot.items, cloned)
                end
            end
        end
    end

    return snapshot
end

local function queueContainerCopySnapshot(container, snapshot, stats, deferredQueue)
    if not container or not snapshot or type(deferredQueue) ~= "table" then
        return
    end

    table.insert(deferredQueue, {
        container = container,
        snapshot = snapshot,
        stats = stats,
        itemIndex = 0,
    })
end

local function copyObjectContainers(object, stats, deferredQueue)
    local result = {}
    local count = callMethod(object, "getContainerCount")
    if type(count) == "number" and count > 0 then
        for i = 0, count - 1 do
            local container = callMethod(object, "getContainerByIndex", i)
            local snapshot = nil
            if deferredQueue then
                snapshot = createContainerSnapshot(container, i, stats)
                queueContainerCopySnapshot(container, snapshot, stats, deferredQueue)
            else
                snapshot = copyContainerSnapshot(container, i, stats)
            end
            if snapshot then
                table.insert(result, snapshot)
            end
        end
    end

    if #result == 0 then
        local container = callMethod(object, "getContainer")
        local snapshot = nil
        if deferredQueue then
            snapshot = createContainerSnapshot(container, 0, stats)
            queueContainerCopySnapshot(container, snapshot, stats, deferredQueue)
        else
            snapshot = copyContainerSnapshot(container, 0, stats)
        end
        if snapshot then
            table.insert(result, snapshot)
        end
    end

    if #result == 0 then
        return nil
    end
    return result
end

local createItemFromPersistentSnapshot
local transmitCompleteObject

function EBFCopyPasteServer.containerCanApplyWorldName(container)
    return container and callMethod(container, "getParent") ~= nil
end

function EBFCopyPasteServer.applyContainerNameSnapshot(container, customName)
    if customName == nil or not EBFCopyPasteServer.containerCanApplyWorldName(container) then
        return
    end
    callMethod(container, "setCustomName", customName)
    callMethod(container, "setName", customName)
end

local function applyContainerSnapshot(container, snapshot, transmit)
    if not container or not snapshot then
        return
    end
    if transmit == nil then
        transmit = true
    end

    if snapshot.type then
        callMethod(container, "setType", snapshot.type)
    end
    if snapshot.capacity ~= nil then
        callMethod(container, "setCapacity", snapshot.capacity)
    end
    if snapshot.weightReduction ~= nil then
        callMethod(container, "setWeightReduction", snapshot.weightReduction)
    end
    EBFCopyPasteServer.applyContainerNameSnapshot(container, snapshot.customName)
    callMethod(container, "setExplored", snapshot.explored ~= false)
    clearItemContainer(container, transmit)

    for _, prototype in ipairs(snapshot.items or {}) do
        if type(prototype) == "table" and prototype.fullType and createItemFromPersistentSnapshot then
            local item = createItemFromPersistentSnapshot(prototype, 0)
            if item then
                callMethod(container, "AddItem", item)
                if transmit and sendAddItemToContainer then
                    sendAddItemToContainer(container, item)
                end
            end
        else
            addItemCloneToContainer(container, prototype, transmit, 0)
        end
    end

    callMethod(container, "setExplored", snapshot.explored ~= false)
    if transmit and triggerEvent then
        triggerEvent("OnContainerUpdate")
    end
end

local function queueContainerApplySnapshot(container, snapshot, transmit, deferredQueue, object)
    if not container or not snapshot or type(deferredQueue) ~= "table" then
        return
    end
    if transmit == nil then
        transmit = true
    end

    if snapshot.type then
        callMethod(container, "setType", snapshot.type)
    end
    if snapshot.capacity ~= nil then
        callMethod(container, "setCapacity", snapshot.capacity)
    end
    if snapshot.weightReduction ~= nil then
        callMethod(container, "setWeightReduction", snapshot.weightReduction)
    end
    EBFCopyPasteServer.applyContainerNameSnapshot(container, snapshot.customName)
    callMethod(container, "setExplored", snapshot.explored ~= false)
    clearItemContainer(container, transmit)

    table.insert(deferredQueue, {
        container = container,
        snapshot = snapshot,
        transmit = transmit,
        itemIndex = 1,
        object = object,
    })
end

function EBFCopyPasteServer.objectHasContainerForApply(object)
    if not object then
        return false
    end

    local count = callMethod(object, "getContainerCount")
    if type(count) == "number" and count > 0 then
        return true
    end

    return callMethod(object, "getContainer") ~= nil
end

function EBFCopyPasteServer.ensureObjectContainersForApply(object)
    if EBFCopyPasteServer.objectHasContainerForApply(object) then
        return true
    end
    callMethod(object, "createContainersFromSpriteProperties")
    return EBFCopyPasteServer.objectHasContainerForApply(object)
end

local function applyObjectContainers(object, containers, transmit, deferredQueue)
    if not object or not containers then
        return false
    end

    if #containers > 0 then
        EBFCopyPasteServer.ensureObjectContainersForApply(object)
    end

    local queued = false
    for _, snapshot in ipairs(containers) do
        local container = callMethod(object, "getContainerByIndex", snapshot.index or 0)
        if not container and (snapshot.index or 0) == 0 then
            container = callMethod(object, "getContainer")
        end
        if not container then
            EBFCopyPasteServer.ensureObjectContainersForApply(object)
            container = callMethod(object, "getContainerByIndex", snapshot.index or 0)
            if not container and (snapshot.index or 0) == 0 then
                container = callMethod(object, "getContainer")
            end
        end
        if container then
            if deferredQueue then
                queueContainerApplySnapshot(container, snapshot, transmit, deferredQueue, object)
                queued = true
            else
                applyContainerSnapshot(container, snapshot, transmit)
            end
        end
    end
    return queued
end

local function copyPersistentValue(value, depth)
    depth = depth or 0
    if isPrimitive(value) then
        return value
    end
    if type(value) ~= "table" or depth > 24 then
        return nil
    end

    local copied = {}
    for key, child in pairs(value) do
        if isPrimitive(key) then
            local childCopy = copyPersistentValue(child, depth + 1)
            if childCopy ~= nil then
                copied[key] = childCopy
            end
        end
    end
    return copied
end

local function getFluidByName(fluidName)
    if type(fluidName) ~= "string" or fluidName == "" or not Fluid or not Fluid.Get then
        return nil
    end
    local ok, fluid = pcall(function()
        return Fluid.Get(fluidName)
    end)
    if ok then
        return fluid
    end
    return nil
end

local function getAllFluidNames()
    if not FluidType or not FluidType.getAllFluidName then
        return nil
    end
    local ok, names = pcall(function()
        return FluidType.getAllFluidName()
    end)
    if ok then
        return names
    end
    return nil
end

function EBFCopyPasteServer.resolveFluidTypeForApply(fluidName)
    if type(fluidName) ~= "string" or fluidName == "" then
        return nil
    end

    local lowerName = string.lower(fluidName)
    if FluidType and FluidType.FromNameLower then
        local ok, fluidType = pcall(function()
            return FluidType.FromNameLower(lowerName)
        end)
        if ok and fluidType then
            return fluidType
        end
    end

    if Fluid and Fluid[fluidName] then
        return Fluid[fluidName]
    end
    if Fluid and Fluid.Get then
        local ok, fluid = pcall(function()
            return Fluid.Get(fluidName)
        end)
        if ok and fluid then
            return fluid
        end
    end
    return fluidName
end

function EBFCopyPasteServer.syncFluidOwner(owner)
    if not owner then
        return
    end

    if owner.getFullType then
        callMethod(owner, "syncItemFields")
        if sendItemStats then
            pcall(sendItemStats, owner)
        end
        return
    end

    callMethod(owner, "transmitModData")
    local square = callMethod(owner, "getSquare")
    local objectIndex = tonumber(callMethod(owner, "getObjectIndex") or -1) or -1
    if square and objectIndex >= 0 then
        transmitCompleteObject(owner)
    elseif sendItemStats then
        pcall(sendItemStats, owner)
    end
end

local function captureFluidSnapshot(item)
    local container = callMethod(item, "getFluidContainer")
    if not container then
        return nil
    end

    local snapshot = {
        amount = callMethod(container, "getAmount") or 0,
        capacity = callMethod(container, "getCapacity"),
        rainCatcher = callMethod(container, "getRainCatcher"),
        fluids = {},
    }

    local names = getAllFluidNames()
    if names then
        for i = 0, names:size() - 1 do
            local fluidName = names:get(i)
            local fluid = getFluidByName(fluidName)
            local amount = fluid and callMethod(container, "getSpecificFluidAmount", fluid) or 0
            if amount and amount > 0 then
                table.insert(snapshot.fluids, {
                    type = fluidName,
                    amount = amount,
                })
            end
        end
    end

    if #snapshot.fluids == 0 then
        local primary = callMethod(container, "getPrimaryFluid")
        local primaryType = primary and callMethod(primary, "getFluidTypeString") or nil
        local primaryAmount = callMethod(container, "getPrimaryFluidAmount") or snapshot.amount
        if primaryType and primaryAmount and primaryAmount > 0 then
            table.insert(snapshot.fluids, {
                type = primaryType,
                amount = primaryAmount,
            })
        end
    end

    if #snapshot.fluids == 0 and snapshot.amount and snapshot.amount > 0 then
        table.insert(snapshot.fluids, {
            type = callMethod(item, "isTaintedWater") == true and "TaintedWater" or "Water",
            amount = snapshot.amount,
        })
    end

    if #snapshot.fluids == 0 and (not snapshot.amount or snapshot.amount <= 0) then
        return nil
    end
    return snapshot
end

local function applyFluidSnapshot(item, snapshot, suppressSync)
    if not item or not snapshot then
        return false
    end

    local container = callMethod(item, "getFluidContainer")
    if not container then
        return false
    end

    local changed = false
    if getMethod(container, "removeFluid") then
        callMethod(container, "removeFluid")
        changed = true
    elseif getMethod(container, "emptyFluid") then
        callMethod(container, "emptyFluid")
        changed = true
    end
    if snapshot.capacity then
        callMethod(container, "setCapacity", snapshot.capacity)
        changed = true
    end
    if snapshot.rainCatcher then
        callMethod(container, "setRainCatcher", snapshot.rainCatcher)
        changed = true
    end
    for _, fluid in ipairs(snapshot.fluids or {}) do
        if fluid.type and fluid.amount and fluid.amount > 0 then
            local fluidType = EBFCopyPasteServer.resolveFluidTypeForApply(fluid.type)
            local ok = fluidType and EBFCopyPasteServer.tryCallMethod(container, "addFluid", fluidType, fluid.amount) or false
            if not ok then
                ok = EBFCopyPasteServer.tryCallMethod(container, "addFluid", tostring(fluid.type), fluid.amount)
            end
            changed = changed or ok == true
        end
    end
    if changed and suppressSync ~= true then
        EBFCopyPasteServer.syncFluidOwner(item)
    end
    return changed == true
end

function EBFCopyPasteServer.spriteHasWaterPiped(spriteName)
    local props = getSpritePropertiesByName(spriteName)
    return EBFCopyPasteServer.spritePropsHas(props, "waterPiped", IsoFlagType and IsoFlagType.waterPiped or nil)
end

function EBFCopyPasteServer.spriteIsWaterDispenser(spriteName)
    if type(spriteName) ~= "string"
            or string.sub(spriteName, 1, string.len("location_business_office_generic_01_")) ~= "location_business_office_generic_01_" then
        return false
    end

    local customName = EBFCopyPasteServer.getSpritePropertyValue(spriteName, "CustomName")
    return type(customName) == "string" and string.lower(customName) == "dispenser"
end

function EBFCopyPasteServer.getBooleanStateFromMethods(object, methodNames)
    for _, methodName in ipairs(methodNames or {}) do
        local value = callMethod(object, methodName)
        if value ~= nil then
            return value == true
        end
    end
    return nil
end

function EBFCopyPasteServer.captureWaterRuntimeMetadata(object)
    local properties, methods = EBFCopyPasteServer.capturePrimitiveMethodValues(object, {
        { "getWaterAmount", "waterAmount" },
        { "getWaterMax", "waterMax" },
        { "getFluidAmount", "fluidAmount" },
        { "getFluidCapacity", "fluidCapacity" },
        { "hasFluid", "hasFluid" },
        { "hasWater", "hasWater" },
        { "isTaintedWater", "taintedWater" },
        { "usesExternalWaterSource", "usesExternalWaterSource" },
        { "isUsesExternalWaterSource", "isUsesExternalWaterSource" },
        { "getUsesExternalWaterSource", "getUsesExternalWaterSource" },
        { "hasExternalWaterSource", "hasExternalWaterSource" },
        { "canStoreWater", "canStoreWater" },
        { "canHaveWater", "canHaveWater" },
        { "isWaterSource", "waterSource" },
        { "hasWaterToDrink", "hasWaterToDrink" },
        { "isRainCollector", "rainCollector" },
    })

    local metadata = {
        properties = properties,
        methods = methods,
    }

    local container = callMethod(object, "getFluidContainer")
    if container then
        local containerProperties, containerMethods = EBFCopyPasteServer.capturePrimitiveMethodValues(container, {
            { "getAmount", "amount" },
            { "getCapacity", "capacity" },
            { "getRainCatcher", "rainCatcher" },
            { "getInputLocked", "inputLocked" },
            { "isInputLocked", "isInputLocked" },
            { "getPrimaryFluidAmount", "primaryFluidAmount" },
            { "getPrimaryFluidName", "primaryFluidName" },
            { "getPrimaryFluidTypeString", "primaryFluidTypeString" },
        })
        metadata.fluidContainer = {
            properties = containerProperties,
            methods = containerMethods,
            hasPrimaryFluid = callMethod(container, "getPrimaryFluid") ~= nil,
        }
    end

    if not metadata.properties and not metadata.methods and not metadata.fluidContainer then
        return nil
    end
    return metadata
end

function EBFCopyPasteServer.getWaterFluidType(tainted)
    if FluidType then
        return tainted and FluidType.TaintedWater or FluidType.Water
    end
    if Fluid and Fluid.Get then
        return Fluid.Get(tainted and "TaintedWater" or "Water")
    end
    return tainted and "TaintedWater" or "Water"
end

function EBFCopyPasteServer.captureObjectWaterState(object, spriteName)
    local waterPiped = EBFCopyPasteServer.spriteHasWaterPiped(spriteName)
    local waterDispenser = EBFCopyPasteServer.spriteIsWaterDispenser(spriteName)
    local fluidAmount = tonumber(callMethod(object, "getFluidAmount"))
    local fluidCapacity = tonumber(callMethod(object, "getFluidCapacity"))
    local hasFluid = callMethod(object, "hasFluid")
    local tainted = callMethod(object, "isTaintedWater")
    local usesExternal = EBFCopyPasteServer.getBooleanStateFromMethods(object, {
        "usesExternalWaterSource",
        "isUsesExternalWaterSource",
        "getUsesExternalWaterSource",
        "hasExternalWaterSource",
    })

    local modData = object and object.getModData and object:getModData() or nil
    local canBeWaterPiped = modData and modData.canBeWaterPiped
    local waterMax = modData and modData.waterMax
    local fluidSnapshot = captureFluidSnapshot(object)
    local runtimeMetadata = EBFCopyPasteServer.captureWaterRuntimeMetadata(object)
    local hasMeaningfulFluidState = hasFluid == true
            or (fluidAmount ~= nil and fluidAmount > 0)
            or (fluidCapacity ~= nil and fluidCapacity > 0)

    if not waterPiped
            and not waterDispenser
            and not fluidSnapshot
            and not hasMeaningfulFluidState
            and canBeWaterPiped == nil
            and waterMax == nil then
        return nil
    end

    return {
        waterPiped = waterPiped == true,
        waterDispenser = waterDispenser == true,
        fluidAmount = fluidAmount,
        fluidCapacity = fluidCapacity,
        hasFluid = hasFluid == true,
        tainted = tainted == true,
        usesExternalWaterSource = usesExternal,
        canBeWaterPiped = canBeWaterPiped,
        waterMax = waterMax,
        fluid = fluidSnapshot,
        runtime = runtimeMetadata,
    }
end

function EBFCopyPasteServer.applyObjectWaterState(square, object, waterState, suppressSync)
    if not object or not waterState then
        return false
    end

    local changed = false
    local modDataChanged = false
    local modData = object.getModData and object:getModData() or nil
    if modData then
        if waterState.canBeWaterPiped ~= nil then
            modData.canBeWaterPiped = waterState.canBeWaterPiped
            changed = true
            modDataChanged = true
        elseif waterState.waterPiped == true and waterState.usesExternalWaterSource ~= true then
            modData.canBeWaterPiped = true
            changed = true
            modDataChanged = true
        end
        if waterState.waterMax ~= nil then
            modData.waterMax = waterState.waterMax
            changed = true
            modDataChanged = true
        end
    end

    local shouldUseExternal = waterState.usesExternalWaterSource == true

    if shouldUseExternal and getMethod(object, "setUsesExternalWaterSource") then
        if modData and modData.canBeWaterPiped ~= false then
            modData.canBeWaterPiped = false
            modDataChanged = true
        end
        local ok = EBFCopyPasteServer.tryCallMethod(object, "setUsesExternalWaterSource", true)
        if ok then
            changed = true
        end
        if modDataChanged and object.transmitModData and suppressSync ~= true then
            object:transmitModData()
            modDataChanged = false
        end
        if suppressSync ~= true then
            callMethod(object, "sendObjectChange", "usesExternalWaterSource", { value = true })
            if IsoObjectChange and IsoObjectChange.USES_EXTERNAL_WATER_SOURCE then
                callMethod(object, "sendObjectChange", IsoObjectChange.USES_EXTERNAL_WATER_SOURCE, { value = true })
            end
        end
    elseif waterState.usesExternalWaterSource == false and getMethod(object, "setUsesExternalWaterSource") then
        local ok = EBFCopyPasteServer.tryCallMethod(object, "setUsesExternalWaterSource", false)
        if ok then
            changed = true
        end
        if suppressSync ~= true then
            callMethod(object, "sendObjectChange", "usesExternalWaterSource", { value = false })
        end
    end

    if modDataChanged and object.transmitModData and suppressSync ~= true then
        object:transmitModData()
    end

    if waterState.fluidAmount ~= nil and getMethod(object, "emptyFluid") and getMethod(object, "addFluid") then
        local amount = math.max(0, tonumber(waterState.fluidAmount) or 0)
        callMethod(object, "emptyFluid")
        if amount > 0 then
            callMethod(object, "addFluid", EBFCopyPasteServer.getWaterFluidType(waterState.tainted == true), amount)
        end
        if suppressSync ~= true then
            EBFCopyPasteServer.syncFluidOwner(object)
        end
        changed = true
    elseif waterState.fluid then
        changed = applyFluidSnapshot(object, waterState.fluid, suppressSync) or changed
    end

    if changed then
        if buildUtil and buildUtil.setHaveConstruction and square then
            pcall(buildUtil.setHaveConstruction, square, true)
        end
    end
    return changed == true
end

function EBFCopyPasteServer.applyWaterDispenserFluidState(object, entry, suppressSync)
    if not object or not entry or not EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return false
    end

    local container = callMethod(object, "getFluidContainer")
    local waterState = entry.waterState
    local changed = false
    if container then
        EBFCopyPasteServer.tryCallMethod(container, "setInputLocked", false)
        if waterState and waterState.fluid then
            changed = applyFluidSnapshot(object, waterState.fluid, suppressSync) or changed
        elseif waterState then
            if getMethod(container, "removeFluid") then
                callMethod(container, "removeFluid")
                changed = true
            elseif getMethod(container, "emptyFluid") then
                callMethod(container, "emptyFluid")
                changed = true
            end
            local amount = math.max(0, tonumber(waterState.fluidAmount) or 0)
            if amount > 0 then
                local fluidType = EBFCopyPasteServer.getWaterFluidType(waterState.tainted == true)
                changed = EBFCopyPasteServer.tryCallMethod(container, "addFluid", fluidType, amount) or changed
            end
        else
            if getMethod(container, "removeFluid") then
                callMethod(container, "removeFluid")
                changed = true
            elseif getMethod(container, "emptyFluid") then
                callMethod(container, "emptyFluid")
                changed = true
            end
        end
        EBFCopyPasteServer.tryCallMethod(container, "setInputLocked", true)
    end

    if suppressSync ~= true then
        callMethod(object, "sync")
    end
    if changed and suppressSync ~= true then
        EBFCopyPasteServer.syncFluidOwner(object)
    end
    return changed == true
end

function EBFCopyPasteServer.finalizePastedPlumbingFixture(square, object, entry, suppressTransmit)
    if not square or not object or not EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        return false
    end

    local changed = false
    local waterState = entry and entry.waterState or nil
    local usesExternal = waterState and waterState.usesExternalWaterSource
    if usesExternal == nil then
        usesExternal = false
    end
    local canBeWaterPiped = waterState and waterState.canBeWaterPiped
    if canBeWaterPiped == nil then
        canBeWaterPiped = not EBFCopyPasteServer.spriteHasWaterPiped(entry and entry.sprite)
    end

    local modData = object.getModData and object:getModData() or nil
    if modData then
        if usesExternal then
            if modData.canBeWaterPiped ~= false then
                modData.canBeWaterPiped = false
                changed = true
            end
        elseif canBeWaterPiped ~= nil then
            if modData.canBeWaterPiped ~= (canBeWaterPiped == true) then
                modData.canBeWaterPiped = canBeWaterPiped == true
                changed = true
            end
        end
        if object.transmitModData and suppressTransmit ~= true then
            object:transmitModData()
        end
    end

    if getMethod(object, "setUsesExternalWaterSource") then
        local ok = EBFCopyPasteServer.tryCallMethod(object, "setUsesExternalWaterSource", usesExternal == true)
        changed = changed or ok == true
        if suppressTransmit ~= true then
            callMethod(object, "sendObjectChange", "usesExternalWaterSource", { value = usesExternal == true })
            if IsoObjectChange and IsoObjectChange.USES_EXTERNAL_WATER_SOURCE then
                callMethod(object, "sendObjectChange", IsoObjectChange.USES_EXTERNAL_WATER_SOURCE, { value = usesExternal == true })
            end
        end
        if usesExternal and getMethod(object, "doFindExternalWaterSource") then
            EBFCopyPasteServer.tryCallMethod(object, "doFindExternalWaterSource")
        end
    end

    if buildUtil and buildUtil.setHaveConstruction then
        pcall(buildUtil.setHaveConstruction, square, true)
    end
    callMethod(object, "createContainersFromSpriteProperties")
    if IsoObjectChange and IsoObjectChange.CONTAINERS and suppressTransmit ~= true then
        callMethod(object, "sendObjectChange", IsoObjectChange.CONTAINERS)
    end
    if changed and suppressTransmit ~= true then
        transmitCompleteObject(object)
        callMethod(square, "RecalcProperties")
        callMethod(square, "RecalcAllWithNeighbours", true)
        if IsoGenerator and IsoGenerator.updateGenerator then
            pcall(IsoGenerator.updateGenerator, square)
        end
    end
    return changed == true
end

local function makePersistentContainerSnapshot(snapshot, depth)
    if not snapshot then
        return nil
    end

    local persisted = {
        index = snapshot.index or 0,
        type = snapshot.type,
        explored = snapshot.explored ~= false,
        capacity = snapshot.capacity,
        weightReduction = snapshot.weightReduction,
        customName = snapshot.customName,
        items = {},
    }

    for _, item in ipairs(snapshot.items or {}) do
        local itemSnapshot = nil
        if type(item) == "table" and item.fullType then
            itemSnapshot = copyPersistentValue(item, depth or 0)
        else
            itemSnapshot = makePersistentItemSnapshot(item, depth or 0)
        end
        if itemSnapshot then
            table.insert(persisted.items, itemSnapshot)
        end
    end
    return persisted
end

makePersistentItemSnapshot = function(item, depth)
    depth = depth or 0
    if not item or depth > 12 then
        return nil
    end

    local fullType = getItemFullType(item)
    if not fullType then
        return nil
    end

    local snapshot = {
        fullType = fullType,
        methods = {},
        modData = copyPersistentValue(callMethod(item, "getModData"), 0),
        fluid = captureFluidSnapshot(item),
        deviceData = EBFCopyPasteServer.captureDeviceData(item),
        containers = {},
    }

    for _, methodPair in ipairs(itemCopyMethods) do
        local value = callMethod(item, methodPair[1])
        if isPrimitive(value) then
            snapshot.methods[methodPair[2]] = value
        end
    end

    local sourceContainer = callMethod(item, "getItemContainer")
    if sourceContainer then
        local containerSnapshot = copyContainerSnapshot(sourceContainer, 0, nil, depth + 1)
        local persistedContainer = makePersistentContainerSnapshot(containerSnapshot, depth + 1)
        if persistedContainer then
            table.insert(snapshot.containers, persistedContainer)
        end
    end

    return snapshot
end

createItemFromPersistentSnapshot = function(snapshot, depth, options)
    depth = depth or 0
    if not snapshot or type(snapshot.fullType) ~= "string" or depth > 12 then
        return nil
    end
    options = options or {}

    local item = EBFCopyPasteServer.safeInstanceItem(snapshot.fullType)
    if not item then
        return nil
    end
    EBFCopyPasteServer.prepareSpawnedInventoryItem(item)

    local skipSetters = {}
    for setterName, skip in pairs(options.skipSetters or {}) do
        skipSetters[setterName] = skip
    end
    skipSetters.setActivated = true
    for setterName, value in pairs(snapshot.methods or {}) do
        if not skipSetters[setterName] then
            callMethod(item, setterName, value)
        end
    end
    if snapshot.modData then
        applyModData(item, snapshot.modData)
    end
    applyFluidSnapshot(item, snapshot.fluid)
    if options.skipDeviceData ~= true then
        EBFCopyPasteServer.applyDeviceDataSnapshot(item, snapshot.deviceData)
    end

    local targetContainer = callMethod(item, "getItemContainer")
    if targetContainer then
        for _, containerSnapshot in ipairs(snapshot.containers or {}) do
            applyContainerSnapshot(targetContainer, containerSnapshot, false)
        end
    end

    return item
end

local function makePersistentEntry(entry)
    local persisted = {}
    for key, value in pairs(entry) do
        if key == "containers" then
            persisted.containers = {}
            for _, containerSnapshot in ipairs(value or {}) do
                local persistedContainer = makePersistentContainerSnapshot(containerSnapshot, 0)
                if persistedContainer then
                    table.insert(persisted.containers, persistedContainer)
                end
            end
        elseif key == "lightSettings" then
            persisted.lightSettings = makePersistentItemSnapshot(value, 0)
        elseif key == "modData" then
            local copiedModData = copyPersistentValue(value, 0)
            if type(copiedModData) == "table" then
                for modKey, _ in pairs(copiedModData) do
                    if EBFCopyPasteServer.isInternalModDataKey(modKey) then
                        copiedModData[modKey] = nil
                    end
                end
                if EBFCopyPasteServer.tableHasEntries(copiedModData) then
                    persisted.modData = copiedModData
                end
            end
        else
            local copied = copyPersistentValue(value, 0)
            if copied ~= nil then
                persisted[key] = copied
            end
        end
    end
    return persisted
end

local function ensureClipboardZOffsets(clipboard)
    if not clipboard then
        return nil
    end

    clipboard.zOffsets = EBFCopyPaste.normalizeZOffsets(clipboard.zOffsets, clipboard.levels)
    clipboard.levels = #clipboard.zOffsets
    return clipboard
end

local function getClipboardZRange(clipboard)
    ensureClipboardZOffsets(clipboard)
    local offsets = clipboard and clipboard.zOffsets or nil
    local minOffset = offsets and offsets[1] or 0
    local maxOffset = offsets and offsets[#offsets] or minOffset
    return minOffset, maxOffset, offsets or { 0 }
end

function EBFCopyPasteServer.makeClipboardRoomKey(tile)
    if not tile or tile.missing == true or tile.hasRoom ~= true or tile.roomDefIsEmptyOutside == true then
        return nil
    end

    local dz = EBFCopyPaste.toInt(tile.dz, 0)
    local roomDefID = tile.roomDefIDString
    local roomID = tile.roomIDString
    local name = tostring(tile.roomDefName or tile.roomName or "room")
    if name == "" or name == "emptyoutside" then
        return nil
    end

    return tostring(dz) .. ":" .. tostring(roomDefID or roomID or name), dz, name
end

function EBFCopyPasteServer.clipRoomRectToClipboard(rect, width, height)
    if not rect then
        return nil
    end

    local rectX = EBFCopyPaste.toInt(rect.x, nil)
    local rectY = EBFCopyPaste.toInt(rect.y, nil)
    local rectW = EBFCopyPaste.toInt(rect.w, nil)
    local rectH = EBFCopyPaste.toInt(rect.h, nil)
    if rectX == nil or rectY == nil or rectW == nil or rectH == nil or rectW <= 0 or rectH <= 0 then
        return nil
    end

    local clipX1 = math.max(0, rectX)
    local clipY1 = math.max(0, rectY)
    local clipX2 = math.min(math.max(1, width), rectX + rectW)
    local clipY2 = math.min(math.max(1, height), rectY + rectH)
    if clipX2 <= clipX1 or clipY2 <= clipY1 then
        return nil
    end

    return {
        x = clipX1,
        y = clipY1,
        w = clipX2 - clipX1,
        h = clipY2 - clipY1,
        source = rect.source or "roomDef",
        sourceX = rect.sourceX,
        sourceY = rect.sourceY,
    }
end

function EBFCopyPasteServer.buildClipboardRoomTileMasks(clipboard)
    local masks = {}
    local seen = {}
    if not clipboard then
        return masks
    end

    for _, tile in ipairs(clipboard.tiles or {}) do
        local key = EBFCopyPasteServer.makeClipboardRoomKey(tile)
        if key then
            local dx = EBFCopyPaste.toInt(tile.dx, nil)
            local dy = EBFCopyPaste.toInt(tile.dy, nil)
            if dx ~= nil and dy ~= nil then
                masks[key] = masks[key] or {}
                seen[key] = seen[key] or {}
                local tileKey = tostring(dx) .. ":" .. tostring(dy)
                if not seen[key][tileKey] then
                    seen[key][tileKey] = true
                    table.insert(masks[key], {
                        x = dx,
                        y = dy,
                    })
                end
            end
        end
    end

    for _, mask in pairs(masks) do
        table.sort(mask, function(a, b)
            local ay = EBFCopyPaste.toInt(a.y, 0)
            local by = EBFCopyPaste.toInt(b.y, 0)
            if ay ~= by then
                return ay < by
            end
            return EBFCopyPaste.toInt(a.x, 0) < EBFCopyPaste.toInt(b.x, 0)
        end)
    end
    return masks
end

function EBFCopyPasteServer.buildRoomRectsFromTileMask(tileMask)
    if type(tileMask) ~= "table" or #tileMask <= 0 then
        return {}
    end

    local rows = {}
    for _, tile in ipairs(tileMask) do
        local x = EBFCopyPaste.toInt(tile.x, nil)
        local y = EBFCopyPaste.toInt(tile.y, nil)
        if x ~= nil and y ~= nil then
            rows[y] = rows[y] or {}
            rows[y][x] = true
        end
    end

    local rowKeys = {}
    for y in pairs(rows) do
        table.insert(rowKeys, y)
    end
    table.sort(rowKeys)

    local rects = {}
    for _, y in ipairs(rowKeys) do
        local xKeys = {}
        for x in pairs(rows[y]) do
            table.insert(xKeys, x)
        end
        table.sort(xKeys)

        local runStart = nil
        local previous = nil
        for _, x in ipairs(xKeys) do
            if runStart == nil then
                runStart = x
                previous = x
            elseif x == previous + 1 then
                previous = x
            else
                table.insert(rects, {
                    x = runStart,
                    y = y,
                    w = previous - runStart + 1,
                    h = 1,
                    source = "tileMask",
                })
                runStart = x
                previous = x
            end
        end
        if runStart ~= nil then
            table.insert(rects, {
                x = runStart,
                y = y,
                w = previous - runStart + 1,
                h = 1,
                source = "tileMask",
            })
        end
    end

    return rects
end

function EBFCopyPasteServer.collectRoomDefRects(roomDef, sourceX, sourceY)
    local rects = callMethod(roomDef, "getRects")
    local rectCount = tonumber(callMethod(rects, "size")) or 0
    if rectCount <= 0 then
        return {}
    end

    local collected = {}
    for rectIndex = 0, rectCount - 1 do
        local rect = callMethod(rects, "get", rectIndex)
        local rectX = tonumber(callMethod(rect, "getX"))
        local rectY = tonumber(callMethod(rect, "getY"))
        local rectW = tonumber(callMethod(rect, "getW"))
        local rectH = tonumber(callMethod(rect, "getH"))
        if rectX and rectY and rectW and rectH and rectW > 0 and rectH > 0 then
            table.insert(collected, {
                x = math.floor(rectX - sourceX),
                y = math.floor(rectY - sourceY),
                w = math.floor(rectW),
                h = math.floor(rectH),
                source = "roomDef",
                sourceX = math.floor(rectX),
                sourceY = math.floor(rectY),
            })
        end
    end
    return collected
end

function EBFCopyPasteServer.captureClipboardRoomBlueprint(clipboard, tileSnapshot, square)
    if not clipboard or not tileSnapshot or not square then
        return nil
    end

    local key, fallbackDz, fallbackName = EBFCopyPasteServer.makeClipboardRoomKey(tileSnapshot)
    if not key then
        return nil
    end

    clipboard.roomBlueprints = clipboard.roomBlueprints or {}
    clipboard.roomBlueprintOrder = clipboard.roomBlueprintOrder or {}
    if clipboard.roomBlueprints[key] then
        return clipboard.roomBlueprints[key]
    end

    local room = callMethod(square, "getRoom")
    local roomDef = room and callMethod(room, "getRoomDef") or nil
    if not roomDef or callMethod(roomDef, "isEmptyOutside") == true then
        return nil
    end

    local sourceX = EBFCopyPaste.toInt(clipboard.x, EBFCopyPaste.toInt(tileSnapshot.x, 0) - EBFCopyPaste.toInt(tileSnapshot.dx, 0))
    local sourceY = EBFCopyPaste.toInt(clipboard.y, EBFCopyPaste.toInt(tileSnapshot.y, 0) - EBFCopyPaste.toInt(tileSnapshot.dy, 0))
    local sourceZ = EBFCopyPaste.toInt(clipboard.z, EBFCopyPaste.toInt(tileSnapshot.z, 0) - EBFCopyPaste.toInt(tileSnapshot.dz, 0))
    local roomLevel = EBFCopyPaste.toInt(callMethod(roomDef, "getZ"), EBFCopyPaste.toInt(tileSnapshot.z, sourceZ))
    local rects = EBFCopyPasteServer.collectRoomDefRects(roomDef, sourceX, sourceY)
    if #rects <= 0 then
        return nil
    end

    local blueprint = {
        key = key,
        dz = roomLevel - sourceZ,
        name = tostring(callMethod(roomDef, "getName") or fallbackName or "room"),
        sourceRoomIDString = tileSnapshot.roomIDString,
        sourceRoomDefIDString = EBFCopyPasteServer.getRoomDefIdString(roomDef) or tileSnapshot.roomDefIDString,
        sourceRoomDefName = callMethod(roomDef, "getName") or tileSnapshot.roomDefName,
        lightsActive = tileSnapshot.roomDefLightsActive == true,
        sourceLevel = roomLevel,
        sourceOriginX = sourceX,
        sourceOriginY = sourceY,
        sourceOriginZ = sourceZ,
        rects = rects,
        source = "roomDefRects",
        tileCount = 0,
    }

    clipboard.roomBlueprints[key] = blueprint
    table.insert(clipboard.roomBlueprintOrder, key)
    clipboard.stats = clipboard.stats or {}
    clipboard.stats.roomBlueprints = #(clipboard.roomBlueprintOrder or {})
    return blueprint
end

function EBFCopyPasteServer.buildClipboardRoomSpecs(clipboard)
    if not clipboard then
        return {}
    end

    local groups = {}
    for _, tile in ipairs(clipboard.tiles or {}) do
        local key = EBFCopyPasteServer.makeClipboardRoomKey(tile)
        if key then
            groups[key] = (groups[key] or 0) + 1
        end
    end

    local specs = {}
    local width = math.max(1, EBFCopyPaste.toInt(clipboard.w, 1))
    local height = math.max(1, EBFCopyPaste.toInt(clipboard.h, 1))
    local roomTileMasks = EBFCopyPasteServer.buildClipboardRoomTileMasks(clipboard)
    local roomBlueprintOrder = clipboard.roomBlueprintOrder or {}
    local roomBlueprints = clipboard.roomBlueprints or {}
    for _, key in ipairs(roomBlueprintOrder) do
        local blueprint = roomBlueprints[key]
        if blueprint and type(blueprint.rects) == "table" then
            local tileMask = roomTileMasks[key] or {}
            local rects = {}
            local source = "roomDefRects"
            for _, rect in ipairs(blueprint.rects) do
                local clipped = EBFCopyPasteServer.clipRoomRectToClipboard(rect, width, height)
                if clipped then
                    table.insert(rects, clipped)
                end
            end
            if #rects <= 0 then
                source = "tileMask"
                rects = EBFCopyPasteServer.buildRoomRectsFromTileMask(tileMask)
            end
            if #rects > 0 then
                table.insert(specs, {
                    key = blueprint.key or key,
                    dz = EBFCopyPaste.toInt(blueprint.dz, 0),
                    name = blueprint.name or "room",
                    sourceRoomIDString = blueprint.sourceRoomIDString,
                    sourceRoomDefIDString = blueprint.sourceRoomDefIDString,
                    sourceRoomDefName = blueprint.sourceRoomDefName,
                    lightsActive = blueprint.lightsActive == true,
                    sourceLevel = blueprint.sourceLevel,
                    source = source,
                    tileCount = #tileMask > 0 and #tileMask or groups[key] or blueprint.tileCount or 0,
                    tileMask = tileMask,
                    rects = rects,
                })
            end
        end
    end

    return specs
end

function EBFCopyPasteServer.clipboardRoomSpecsAreValid(clipboard)
    if not clipboard or type(clipboard.roomSpecs) ~= "table" then
        return false, 0, 0
    end

    local expectedVersion = tonumber(EBFCopyPaste.RoomSpecsVersion) or 4
    if tonumber(clipboard.roomSpecsVersion) ~= expectedVersion then
        return false, 0, 0
    end

    local specs = clipboard.roomSpecs
    if #specs <= 0 then
        for _, entry in ipairs(clipboard.objects or {}) do
            if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry)
                    and (entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key)) then
                return false, 0, 0
            end
        end
        local blueprintCount = type(clipboard.roomBlueprintOrder) == "table" and #clipboard.roomBlueprintOrder or 0
        return blueprintCount <= 0, 0, 0
    end

    local rects = 0
    local specKeys = {}
    for _, spec in ipairs(specs) do
        if type(spec) ~= "table" or tostring(spec.key or "") == "" or type(spec.rects) ~= "table" then
            return false, 0, 0
        end
        specKeys[tostring(spec.key)] = true
        if EBFCopyPaste.toInt(spec.dz, nil) == nil then
            return false, 0, 0
        end
        if #spec.rects <= 0 then
            return false, 0, 0
        end
        for _, rect in ipairs(spec.rects) do
            local x = EBFCopyPaste.toInt(rect and rect.x, nil)
            local y = EBFCopyPaste.toInt(rect and rect.y, nil)
            local w = EBFCopyPaste.toInt(rect and rect.w, nil)
            local h = EBFCopyPaste.toInt(rect and rect.h, nil)
            if x == nil or y == nil or w == nil or h == nil or w <= 0 or h <= 0 then
                return false, 0, 0
            end
            rects = rects + 1
        end
    end

    for _, entry in ipairs(clipboard.objects or {}) do
        if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
            local key = entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key)
            if key and not specKeys[tostring(key)] then
                return false, 0, 0
            end
        end
    end

    return true, #specs, rects
end

function EBFCopyPasteServer.ensureClipboardRoomSpecs(clipboard, options)
    if not clipboard then
        return {}
    end

    options = options or {}
    local valid, specCount = EBFCopyPasteServer.clipboardRoomSpecsAreValid(clipboard)
    if valid and options.rebuild ~= true then
        clipboard.stats = clipboard.stats or {}
        clipboard.stats.roomSpecs = specCount
        return clipboard.roomSpecs or {}
    end

    clipboard.roomSpecs = EBFCopyPasteServer.buildClipboardRoomSpecs(clipboard)
    clipboard.stats = clipboard.stats or {}
    clipboard.stats.roomSpecs = #(clipboard.roomSpecs or {})
    clipboard.roomSpecsVersion = tonumber(EBFCopyPaste.RoomSpecsVersion) or 4
    return clipboard.roomSpecs or {}
end

function EBFCopyPasteServer.makeLightBindingKey(entry)
    if not entry then
        return nil
    end
    local scanOrder = tonumber(entry.scanOrder)
    if scanOrder then
        return "light:" .. tostring(scanOrder)
    end
    return "light:"
            .. tostring(entry.dx or 0) .. ":"
            .. tostring(entry.dy or 0) .. ":"
            .. tostring(entry.dz or 0) .. ":"
            .. tostring(entry.index or 0) .. ":"
            .. tostring(entry.sprite or "")
end

function EBFCopyPasteServer.captureLightBinding(clipboard, tileSnapshot, entry)
    if not clipboard or not tileSnapshot or not entry or not EBFCopyPasteServer.entryIsLighting(entry) then
        return nil
    end

    if EBFCopyPasteServer.entryIsMoveableLamp(entry) then
        entry.lightBindingKey = nil
        entry.lightBinding = nil
        return nil
    end

    local key = EBFCopyPasteServer.makeLightBindingKey(entry)
    if not key then
        return nil
    end

    clipboard.lightBindings = clipboard.lightBindings or {}
    clipboard.lightBindingOrder = clipboard.lightBindingOrder or {}
    if clipboard.lightBindings[key] then
        return clipboard.lightBindings[key]
    end

    local controlled = copyPersistentValue(entry.controlledLightSources, 0)
    local classification = entry.classification or {}
    local binding = {
        key = key,
        scanOrder = entry.scanOrder,
        tileOrder = entry.tileOrder,
        sourceKind = entry.sourceKind,
        sprite = entry.sprite,
        objectClass = entry.objectClass,
        isoType = entry.isoType,
        dx = entry.dx,
        dy = entry.dy,
        dz = entry.dz,
        index = entry.index,
        objectLayer = entry.objectLayer,
        classificationFamily = classification.family,
        classificationSubtype = classification.subtype,
        isResidentialSwitch = EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) == true,
        isOutdoorLight = EBFCopyPasteServer.entryIsOutdoorLight(entry) == true,
        isMoveableLamp = false,
        sourceRoomKey = entry.sourceRoomKey,
        sourceRoom = copyPersistentValue(entry.sourceRoom, 0),
        sourceSquare = {
            x = tileSnapshot.x,
            y = tileSnapshot.y,
            z = tileSnapshot.z,
            dx = tileSnapshot.dx,
            dy = tileSnapshot.dy,
            dz = tileSnapshot.dz,
            roomIDString = tileSnapshot.roomIDString,
            roomDefIDString = tileSnapshot.roomDefIDString,
            roomDefName = tileSnapshot.roomDefName,
            roomName = tileSnapshot.roomName,
            roomDefLightsActive = tileSnapshot.roomDefLightsActive == true,
        },
        controlledLightSources = controlled,
        controlledLightSourceCount = type(controlled) == "table" and #controlled or 0,
        sourceRoomLightsActive = tileSnapshot.roomDefLightsActive == true,
        lightState = copyPersistentValue(entry.lightState, 0),
        lightSource = copyPersistentValue(entry.lightSource, 0),
    }

    clipboard.lightBindings[key] = binding
    table.insert(clipboard.lightBindingOrder, key)
    clipboard.stats = clipboard.stats or {}
    clipboard.stats.lightBindings = #(clipboard.lightBindingOrder or {})
    entry.lightBindingKey = key
    entry.lightBinding = {
        key = key,
        sourceRoomKey = binding.sourceRoomKey,
        controlledLightSourceCount = binding.controlledLightSourceCount,
    }
    return binding
end

function EBFCopyPasteServer.ensureClipboardLightBindings(clipboard)
    if not clipboard then
        return {}
    end

    EBFCopyPasteServer.ensureClipboardRoomSpecs(clipboard)
    local specsByKey = {}
    for _, spec in ipairs(clipboard.roomSpecs or {}) do
        if spec and spec.key then
            specsByKey[spec.key] = spec
        end
    end

    local count = 0
    for _, key in ipairs(clipboard.lightBindingOrder or {}) do
        local binding = clipboard.lightBindings and clipboard.lightBindings[key] or nil
        if binding then
            count = count + 1
            local spec = binding.sourceRoomKey and specsByKey[binding.sourceRoomKey] or nil
            if spec then
                binding.sourceRoomName = spec.name or spec.sourceRoomDefName
                binding.sourceRoomRectCount = #(spec.rects or {})
                binding.sourceRoomTileCount = #(spec.tileMask or {})
                binding.sourceRoomTileMask = copyPersistentValue(spec.tileMask, 0)
            end
        end
    end

    clipboard.stats = clipboard.stats or {}
    clipboard.stats.lightBindings = count
    clipboard.lightBindingsVersion = 1
    return clipboard.lightBindings or {}
end

function EBFCopyPasteServer.buildClipboardElectricalBlueprint(clipboard)
    if not clipboard then
        return {}
    end

    EBFCopyPasteServer.ensureClipboardRoomSpecs(clipboard)
    local bindings = EBFCopyPasteServer.ensureClipboardLightBindings(clipboard)
    local rooms = {}
    local roomOrder = {}
    for _, spec in ipairs(clipboard.roomSpecs or {}) do
        if spec and spec.key then
            rooms[spec.key] = {
                key = spec.key,
                name = spec.name or spec.sourceRoomDefName or "room",
                dz = EBFCopyPaste.toInt(spec.dz, 0),
                tileCount = #(spec.tileMask or {}),
                rectCount = #(spec.rects or {}),
                switches = {},
                controlledLightSources = {},
            }
            table.insert(roomOrder, spec.key)
        end
    end

    local looseSwitches = {}
    for _, key in ipairs(clipboard.lightBindingOrder or {}) do
        local binding = bindings and bindings[key] or nil
        if binding then
            local switchSnapshot = {
                key = binding.key,
                sprite = binding.sprite,
                objectClass = binding.objectClass,
                dx = binding.dx,
                dy = binding.dy,
                dz = binding.dz,
                index = binding.index,
                controlledLightSourceCount = binding.controlledLightSourceCount or 0,
            }
            local isRoomSwitch = binding.isResidentialSwitch == true
                    or binding.objectLayer == "residentialLightSwitch"
                    or binding.classificationSubtype == "residentialSwitch"
            local room = binding.sourceRoomKey and rooms[binding.sourceRoomKey] or nil
            if room and isRoomSwitch then
                table.insert(room.switches, switchSnapshot)
                for _, source in ipairs(binding.controlledLightSources or {}) do
                    table.insert(room.controlledLightSources, copyPersistentValue(source, 0))
                end
            else
                table.insert(looseSwitches, switchSnapshot)
            end
        end
    end

    local blueprint = {
        version = 1,
        source = "scannerRoomLightBindings",
        roomOrder = roomOrder,
        rooms = rooms,
        looseSwitches = looseSwitches,
    }
    local roomCount = 0
    local switchCount = #looseSwitches
    local sourceCount = 0
    for _, room in pairs(rooms) do
        roomCount = roomCount + 1
        switchCount = switchCount + #(room.switches or {})
        sourceCount = sourceCount + #(room.controlledLightSources or {})
    end
    blueprint.stats = {
        rooms = roomCount,
        switches = switchCount,
        controlledLightSources = sourceCount,
        looseSwitches = #looseSwitches,
    }
    clipboard.electricalBlueprint = blueprint
    clipboard.stats = clipboard.stats or {}
    clipboard.stats.electricalRooms = roomCount
    clipboard.stats.electricalSwitches = switchCount
    clipboard.stats.electricalControlledSources = sourceCount
    clipboard.electricalBlueprintVersion = blueprint.version
    return blueprint
end

local function makePersistentClipboard(clipboard)
    if not clipboard then
        return nil
    end

    EBFCopyPasteServer.stampCurrentClipboardSchema(clipboard)
    ensureClipboardZOffsets(clipboard)
    EBFCopyPasteServer.ensureClipboardRoomSpecs(clipboard)
    EBFCopyPasteServer.ensureClipboardLightBindings(clipboard)
    EBFCopyPasteServer.buildClipboardElectricalBlueprint(clipboard)
    local persisted = copyPersistentValue(clipboard, 0) or {}
    EBFCopyPasteServer.stampCurrentClipboardSchema(persisted)
    persisted.objects = {}
    for _, entry in ipairs(clipboard.objects or {}) do
        table.insert(persisted.objects, makePersistentEntry(entry))
    end
    persisted.tiles = {}
    for _, tile in ipairs(clipboard.tiles or {}) do
        local persistedTile = copyPersistentValue(tile, 0) or {}
        persistedTile.objects = {}
        for _, entry in ipairs(tile.objects or {}) do
            table.insert(persistedTile.objects, makePersistentEntry(entry))
        end
        persistedTile.worldObjects = {}
        for _, entry in ipairs(tile.worldObjects or {}) do
            table.insert(persistedTile.worldObjects, makePersistentEntry(entry))
        end
        table.insert(persisted.tiles, persistedTile)
    end
    return persisted
end

local function makeRuntimeClipboard(persisted)
    local clipboard = copyPersistentValue(persisted, 0)
    if not EBFCopyPasteServer.isCurrentClipboardSchema(clipboard) then
        return nil
    end
    ensureClipboardZOffsets(clipboard)
    EBFCopyPasteServer.ensureClipboardRoomSpecs(clipboard)
    EBFCopyPasteServer.ensureClipboardLightBindings(clipboard)
    EBFCopyPasteServer.buildClipboardElectricalBlueprint(clipboard)
    return clipboard
end

local function captureObjectState(object)
    local state = {
        methods = {},
        open = callMethod(object, "IsOpen"),
    }

    for _, methodPair in ipairs(objectCopyMethods) do
        local value = callMethod(object, methodPair[1])
        if value ~= nil then
            state.methods[methodPair[2]] = value
        end
    end

    return state
end

local function applyObjectState(object, state)
    if not object or not state then
        return
    end

    local doorSyncSetters = {
        setIsLocked = true,
        setLockedByKey = true,
        setLockedByPadlock = true,
        setLockedByCode = true,
        setPermaLocked = true,
    }

    for setterName, value in pairs(state.methods or {}) do
        if isInstance(object, "IsoDoor") and doorSyncSetters[setterName] then
            -- Several IsoDoor lock setters sync immediately. During paste the object
            -- may not be registered on the square yet, which logs "IsoDoor not found".
            -- Doors are born from canonical closed sprites and remain usable without
            -- running these sync setters during construction.
        elseif setterName ~= "setActivated" then
            callMethod(object, setterName, value)
        end
    end
    if not isInstance(object, "IsoStove") then
        callMethod(object, "setActivated", false)
    end

    -- Doors and windows are pasted from canonical closed sprites; do not run toggle actions during paste.
end

local function getObjectClass(object)
    if isInstance(object, "IsoWorldInventoryObject") or callMethod(object, "getObjectName") == "WorldInventoryItem" then
        return "IsoWorldInventoryObject"
    end
    if isInstance(object, "IsoDoor") then
        return "IsoDoor"
    end
    if isInstance(object, "IsoWindow") then
        return "IsoWindow"
    end
    if isInstance(object, "IsoCurtain") then
        return "IsoCurtain"
    end
    if isInstance(object, "IsoWindowFrame") then
        return "IsoWindowFrame"
    end
    if EBFCopyPasteServer.objectLooksLikeStove(object) then
        return "IsoStove"
    end
    if isInstance(object, "IsoBarbecue") then
        return "IsoBarbecue"
    end
    if isInstance(object, "IsoFireplace") then
        return "IsoFireplace"
    end
    if isInstance(object, "IsoJukebox") then
        return "IsoJukebox"
    end
    if isInstance(object, "IsoCompost") then
        return "IsoCompost"
    end
    if isInstance(object, "IsoFeedingTrough") then
        return "IsoFeedingTrough"
    end
    if isInstance(object, "IsoMannequin") then
        return "IsoMannequin"
    end
    if isInstance(object, "IsoBrokenGlass") then
        return "IsoBrokenGlass"
    end
    if isInstance(object, "IsoCombinationWasherDryer") then
        return "IsoCombinationWasherDryer"
    end
    if isInstance(object, "IsoClothingDryer") then
        return "IsoClothingDryer"
    end
    if isInstance(object, "IsoClothingWasher") then
        return "IsoClothingWasher"
    end
    if isInstance(object, "IsoRadio") then
        return "IsoRadio"
    end
    if isInstance(object, "IsoTelevision") then
        return "IsoTelevision"
    end
    if isInstance(object, "IsoThumpable") then
        return "IsoThumpable"
    end
    if objectLooksLikeLightSwitch(object) then
        return "IsoLightSwitch"
    end
    local isoType = EBFCopyPasteServer.getSpriteIsoType(getObjectSpriteName(object))
    if isoType and isoType ~= "IsoObject" then
        return isoType
    end
    return "IsoObject"
end

function EBFCopyPasteServer.isWorldInventoryObject(object)
    return getObjectClass(object) == "IsoWorldInventoryObject"
end

local function createMoveableSnapshotItem(spriteName)
    if not instanceItem or type(spriteName) ~= "string" or spriteName == "" then
        return nil
    end

    local item = instanceItem("Moveables.Moveable")
    if not item then
        item = instanceItem("Moveables." .. spriteName)
    end
    if item then
        callMethod(item, "ReadFromWorldSprite", spriteName)
    end
    return item
end

local function createSafeWaveSignalPlacementItem()
    if not instanceItem then
        return nil
    end

    local item = instanceItem("Moveables.Moveable") or instanceItem("Base.Plank")
    if item and isInstance(item, "Radio") then
        item = instanceItem("Base.Plank")
    end
    if item and isInstance(item, "Radio") then
        return nil
    end
    return item
end

function EBFCopyPasteServer.spriteHasVanillaMoveableItem(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return false
    end

    local props = EBFCopyPasteServer.getVanillaMoveableProps and EBFCopyPasteServer.getVanillaMoveableProps({ sprite = spriteName }) or nil
    return props ~= nil and props.isMoveable == true
end

function EBFCopyPasteServer.createBrushToolPlacementItem()
    if not instanceItem then
        return nil
    end

    local item = nil
    if ItemKey and ItemKey.Weapon and ItemKey.Weapon.PLANK then
        item = instanceItem(ItemKey.Weapon.PLANK)
    end
    return item or instanceItem("Base.Plank")
end

local function copyLightSettingsItem(object, spriteName)
    if not object or not getMethod(object, "setCustomSettingsToItem") then
        return nil
    end

    if not EBFCopyPasteServer.spriteHasVanillaMoveableItem(spriteName) then
        return nil
    end

    local item = createMoveableSnapshotItem(spriteName)
    if not item then
        return nil
    end
    callMethod(object, "setCustomSettingsToItem", item)
    return makePersistentItemSnapshot(item, 0) or item
end

function EBFCopyPasteServer.captureMoveablePlacementItemSnapshot(object, spriteName, entry)
    if not object or type(spriteName) ~= "string" or spriteName == "" then
        return nil
    end

    local probeEntry = entry or { sprite = spriteName }
    if EBFCopyPasteServer.entryIsWaveSignal(probeEntry) then
        return nil
    end
    local forceMoveableSnapshot = EBFCopyPasteServer.entryIsMoveableLamp(probeEntry, object)
    if not forceMoveableSnapshot then
        if (EBFCopyPasteServer.entryIsPlumbingFixture and EBFCopyPasteServer.entryIsPlumbingFixture(probeEntry))
                or (EBFCopyPasteServer.entryIsWaterDispenser and EBFCopyPasteServer.entryIsWaterDispenser(probeEntry))
                or (EBFCopyPasteServer.entryLooksLikeStove and EBFCopyPasteServer.entryLooksLikeStove(probeEntry)) then
            return nil
        end
    end
    local props = EBFCopyPasteServer.getVanillaMoveableProps and EBFCopyPasteServer.getVanillaMoveableProps({ sprite = spriteName }) or nil
    if not props then
        return nil
    end
    if not forceMoveableSnapshot
            and EBFCopyPasteServer.shouldUseVanillaMoveablePaste
            and not EBFCopyPasteServer.shouldUseVanillaMoveablePaste(probeEntry, props) then
        return nil
    end
    if props.isMoveable ~= true and not forceMoveableSnapshot then
        return nil
    end

    local item = nil
    if props.instanceItem then
        local created = props:instanceItem(spriteName)
        if created then
            item = created
        end
    end
    item = item or createMoveableSnapshotItem(spriteName)
    if not item then
        return nil
    end

    if callMethod(item, "getFullType") == "Moveables.Moveable" then
        callMethod(item, "ReadFromWorldSprite", spriteName)
    end

    if getMethod(object, "setCustomSettingsToItem") then
        callMethod(object, "setCustomSettingsToItem", item)
    end
    if isInstance(object, "IsoStove") and callMethod(object, "isBroken") == true then
        callMethod(item, "setCondition", 0)
    end

    local sourceModData = object.getModData and object:getModData() or nil
    local itemModData = item.getModData and item:getModData() or nil
    if sourceModData and itemModData then
        if sourceModData.movableData then
            itemModData.movableData = copyPersistentValue(sourceModData.movableData, 0)
        end
        if sourceModData.itemCondition then
            itemModData.itemCondition = copyPersistentValue(sourceModData.itemCondition, 0)
        end
    end

    local containerCount = tonumber(callMethod(object, "getContainerCount") or 0) or 0
    if itemModData and containerCount > 0 then
        for i = 0, containerCount - 1 do
            local container = callMethod(object, "getContainerByIndex", i)
            local parent = callMethod(container, "getParent")
            local customName = parent and callMethod(container, "getCustomName") or nil
            local containerType = callMethod(container, "getType")
            if customName and containerType then
                itemModData[tostring(containerType) .. "_customContainerName"] = customName
            end
        end
    end

    return makePersistentItemSnapshot(item, 0)
end

function EBFCopyPasteServer.entryHasContainers(entry)
    return type(entry and entry.containers) == "table" and #entry.containers > 0
end

function EBFCopyPasteServer.entryHasFunctionalState(entry)
    if not entry then
        return false
    end
    if entry.deviceData
            or EBFCopyPasteServer.entryHasRelevantWaterState(entry)
            or entry.lightSettings
            or entry.lightState
            or entry.lightSource
            or entry.controlledLightSources then
        return true
    end
    if EBFCopyPasteServer.entryHasContainers(entry) then
        return true
    end
    if entry.isDoor == true or entry.isDoorFrame == true or entry.isWindow == true then
        return true
    end
    if EBFCopyPasteServer.entryLooksLikeStove(entry) then
        return true
    end
    return entry.objectClass == "IsoDoor"
            or entry.objectClass == "IsoWindow"
            or entry.objectClass == "IsoCurtain"
            or entry.objectClass == "IsoWindowFrame"
            or entry.objectClass == "IsoLightSwitch"
            or entry.objectClass == "IsoRadio"
            or entry.objectClass == "IsoTelevision"
            or entry.objectClass == "IsoBarbecue"
            or entry.objectClass == "IsoFireplace"
            or entry.objectClass == "IsoJukebox"
            or entry.objectClass == "IsoCompost"
            or entry.objectClass == "IsoFeedingTrough"
            or entry.objectClass == "IsoMannequin"
            or entry.objectClass == "IsoCombinationWasherDryer"
            or entry.objectClass == "IsoClothingDryer"
            or entry.objectClass == "IsoClothingWasher"
            or isLightSwitchSprite(entry.sprite)
end

function EBFCopyPasteServer.spriteNameStartsWith(spriteName, prefix)
    return type(spriteName) == "string"
            and type(prefix) == "string"
            and string.sub(spriteName, 1, string.len(prefix)) == prefix
end

function EBFCopyPasteServer.entryIsWaveSignal(entry)
    return EBFCopyPasteServer.entryIsRadio(entry) or EBFCopyPasteServer.entryIsTelevision(entry)
end

function EBFCopyPasteServer.entryIsRadio(entry)
    if not entry then
        return false
    end
    return entry.objectClass == "IsoRadio"
            or entry.isoType == "IsoRadio"
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "appliances_radio_")
end

function EBFCopyPasteServer.entryIsTelevision(entry)
    if not entry then
        return false
    end
    return entry.objectClass == "IsoTelevision"
            or entry.isoType == "IsoTelevision"
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "appliances_television_")
end

function EBFCopyPasteServer.entryIsLighting(entry)
    if not entry then
        return false
    end
    if (EBFCopyPasteServer.entryIsMicrowave and EBFCopyPasteServer.entryIsMicrowave(entry))
            or (EBFCopyPasteServer.entryLooksLikeStove and EBFCopyPasteServer.entryLooksLikeStove(entry))
            or (EBFCopyPasteServer.entryIsTelevision and EBFCopyPasteServer.entryIsTelevision(entry))
            or (EBFCopyPasteServer.entryIsRadio and EBFCopyPasteServer.entryIsRadio(entry))
            or (EBFCopyPasteServer.entryIsWaterDispenser and EBFCopyPasteServer.entryIsWaterDispenser(entry)) then
        return false
    end
    return entry.objectClass == "IsoLightSwitch"
            or isLightSwitchSprite(entry.sprite)
            or entry.lightState ~= nil
            or entry.lightSettings ~= nil
            or entry.lightSource ~= nil
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "lighting_indoor_")
end

function EBFCopyPasteServer.entryIsMoveableLamp(entry, object)
    local spriteName = entry and entry.sprite or getObjectSpriteName(object)
    if not EBFCopyPasteServer.spriteNameStartsWith(spriteName, "lighting_indoor_") then
        return false
    end
    if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
        return false
    end

    local customName = EBFCopyPasteServer.getSpritePropertyValue(spriteName, "CustomName")
    return type(customName) == "string" and string.lower(customName) == "lamp"
end

function EBFCopyPasteServer.entryIsPlumbingFixture(entry)
    if not entry then
        return false
    end
    if entry.waterState and entry.waterState.waterPiped == true then
        return true
    end
    if EBFCopyPasteServer.spriteHasWaterPiped(entry.sprite) then
        return true
    end

    local customName = tostring(EBFCopyPasteServer.getSpritePropertyValue(entry.sprite, "CustomName") or ""):lower()
    return customName == "sink"
            or customName == "toilet"
            or customName == "shower"
            or customName == "bathtub"
            or customName == "bath"
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "fixtures_sinks_")
end

function EBFCopyPasteServer.entryIsPrimaryAppliance(entry)
    if not entry then
        return false
    end
    return EBFCopyPasteServer.entryLooksLikeStove(entry)
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "appliances_refrigeration_")
end

function EBFCopyPasteServer.entryIsMicrowave(entry)
    if not entry then
        return false
    end
    if EBFCopyPasteServer.containerTypeLooksLikeStove(EBFCopyPasteServer.getSpritePropertyValue(entry.sprite, "container"))
            and tostring(EBFCopyPasteServer.getSpritePropertyValue(entry.sprite, "container") or ""):lower() == "microwave" then
        return true
    end
    for _, snapshot in ipairs(entry.containers or {}) do
        if tostring(snapshot and snapshot.type or ""):lower() == "microwave" then
            return true
        end
    end
    return false
end

function EBFCopyPasteServer.entryIsWaterDispenser(entry)
    if not entry then
        return false
    end
    if entry.waterState and entry.waterState.waterDispenser == true then
        return true
    end
    return EBFCopyPasteServer.spriteIsWaterDispenser(entry.sprite)
end

function EBFCopyPasteServer.entryHasRelevantWaterState(entry)
    local waterState = entry and entry.waterState or nil
    if not waterState then
        return false
    end
    if EBFCopyPasteServer.entryIsWaterDispenser(entry)
            or EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        return true
    end
    return waterState.waterPiped == true
            or waterState.waterDispenser == true
            or waterState.hasFluid == true
            or tonumber(waterState.fluidAmount or 0) > 0
            or tonumber(waterState.fluidCapacity or 0) > 0
            or waterState.fluid ~= nil
            or waterState.usesExternalWaterSource == true
            or waterState.canBeWaterPiped ~= nil
            or waterState.waterMax ~= nil
end

function EBFCopyPasteServer.entryIsWaterDispenserWithFluid(entry)
    if not entry or not entry.waterState then
        return false
    end

    if not EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return false
    end

    local waterState = entry.waterState
    return waterState.hasFluid == true
            or tonumber(waterState.fluidAmount or 0) > 0
            or waterState.fluid ~= nil
end

function EBFCopyPasteServer.entryUsesConservativeVanillaState(entry)
    if not entry then
        return false
    end
    return EBFCopyPasteServer.entryIsTelevision(entry)
            or EBFCopyPasteServer.entryIsRadio(entry)
            or EBFCopyPasteServer.entryIsLighting(entry)
            or EBFCopyPasteServer.entryIsMoveableLamp(entry)
            or EBFCopyPasteServer.entryIsMicrowave(entry)
            or EBFCopyPasteServer.entryIsWaterDispenser(entry)
            or EBFCopyPasteServer.entryIsPlumbingFixture(entry)
            or EBFCopyPasteServer.entryIsPrimaryAppliance(entry)
end

function EBFCopyPasteServer.entryIsResidentialLighting(entry)
    return EBFCopyPasteServer.entryIsResidentialLightSwitch(entry)
end

function EBFCopyPasteServer.entryIsWallRoofOrCutawayStructural(entry)
    if not entry or entry.floor or type(entry.sprite) ~= "string" or entry.sprite == "" then
        return false
    end
    if EBFCopyPasteServer.entryIsLighting(entry)
            or EBFCopyPasteServer.entryIsTelevision(entry)
            or EBFCopyPasteServer.entryIsRadio(entry)
            or EBFCopyPasteServer.entryIsWaterDispenser(entry)
            or EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        return false
    end

    local props = getSpritePropertiesByName(entry.sprite)
    if EBFCopyPasteServer.spritePropsHas(props, "WallN", IsoFlagType and IsoFlagType.WallN or nil)
            or EBFCopyPasteServer.spritePropsHas(props, "WallW", IsoFlagType and IsoFlagType.WallW or nil)
            or EBFCopyPasteServer.spritePropsHas(props, "WallNW", IsoFlagType and IsoFlagType.WallNW or nil)
            or EBFCopyPasteServer.spritePropsHas(props, "WallSE", IsoFlagType and IsoFlagType.WallSE or nil)
            or EBFCopyPasteServer.spritePropsHas(props, "wall") then
        return true
    end

    local factory = entry.factory or {}
    local spriteProperties = entry.spriteProperties or {}
    local customName = spriteProperties.CustomName or spriteProperties.customName
    if factory.spriteType == "wall" or customName == "Wall" then
        return EBFCopyPasteServer.spritePropsHas(props, "collideN", IsoFlagType and IsoFlagType.collideN or nil)
                or EBFCopyPasteServer.spritePropsHas(props, "collideW", IsoFlagType and IsoFlagType.collideW or nil)
                or EBFCopyPasteServer.spritePropsHas(props, "CanScrap")
                or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "walls_")
    end

    return EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "walls_exterior_roofs_")
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "roofs_")
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "z_templates_wallcutaways_")
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "walls_interior_cutaways_")
            or EBFCopyPasteServer.spriteNameStartsWith(entry.sprite, "walls_exterior_cutaways_")
end

function EBFCopyPasteServer.entryIsStructural(entry)
    if not entry then
        return false
    end
    if entry.floor then
        return true
    end

    local props = getSpritePropertiesByName(entry.sprite)
    return EBFCopyPasteServer.entryIsWallRoofOrCutawayStructural(entry)
            or EBFCopyPasteServer.spritePropsHas(props, "solidfloor", IsoFlagType and IsoFlagType.solidfloor or nil)
end

function EBFCopyPasteServer.getPasteCategoryOrder(entry)
    if not entry then
        return 999
    end
    if EBFCopyPasteServer.entryIsStructural(entry) then
        return 10
    end
    if EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        return 40
    end
    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return 45
    end
    if EBFCopyPasteServer.entryIsMicrowave(entry) then
        return 55
    end
    if EBFCopyPasteServer.entryIsPrimaryAppliance(entry) then
        return 50
    end
    if EBFCopyPasteServer.entryIsTelevision(entry) then
        return 60
    end
    if EBFCopyPasteServer.entryIsRadio(entry) then
        return 61
    end
    if EBFCopyPasteServer.entryIsResidentialLighting(entry) then
        return 71
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        return 70
    end
    if EBFCopyPasteServer.entryHasContainers(entry) then
        return 20
    end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return 80
    end
    return 30
end

function EBFCopyPasteServer.entryShouldPasteAfterRoomDefs(entry)
    if not entry then
        return false
    end
    return EBFCopyPasteServer.entryIsLighting(entry) == true
end

function EBFCopyPasteServer.getPasteStageCategoryName(entry)
    if not entry then
        return "objetos"
    end
    if entry.floor then
        return "pisos"
    end
    if EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        return "hidraulica"
    end
    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return "bebedouro"
    end
    if EBFCopyPasteServer.entryIsMicrowave(entry) then
        return "microondas"
    end
    if EBFCopyPasteServer.entryIsPrimaryAppliance(entry) then
        return "geladeira/fogao"
    end
    if EBFCopyPasteServer.entryIsTelevision(entry) then
        return "televisao"
    end
    if EBFCopyPasteServer.entryIsRadio(entry) then
        return "radio"
    end
    if EBFCopyPasteServer.entryIsResidentialLighting(entry) then
        return "interruptores/luz residencial"
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        return "luces/lámparas"
    end
    if EBFCopyPasteServer.entryHasContainers(entry) then
        return "moveis/conteiners"
    end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return "objetos en el suelo"
    end
    if EBFCopyPasteServer.entryIsStructural(entry) then
        return "paredes/tetos/estrutura"
    end
    return "moveis/decoracoes"
end

function EBFCopyPasteServer.logPasteEntryStage(job, entry)
    local categoryName = EBFCopyPasteServer.getPasteStageCategoryName(entry)
    EBFCopyPasteServer.logStage(job, "pasteCategory:" .. tostring(categoryName), "PASTE categoria iniciada: "
            .. tostring(categoryName)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.selectPasteStrategy(entry)
    if not entry then
        return "invalid"
    end
    if entry.floor then
        return "floor"
    end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return "worldInventory"
    end
    if EBFCopyPasteServer.entryLooksLikeStove(entry) then
        return "manualClass"
    end
    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return "manualClass"
    end
    if EBFCopyPasteServer.entryIsTelevision(entry)
            or EBFCopyPasteServer.entryIsRadio(entry) then
        return "vanillaMoveable"
    end
    if entry.objectClass == "IsoDoor"
            or entry.objectClass == "IsoWindow"
            or entry.objectClass == "IsoWindowFrame"
            or entry.objectClass == "IsoCurtain"
            or entry.isoType == "IsoWindowFrame"
            or entry.isoType == "IsoCurtain"
            or entry.isDoor == true
            or entry.isDoorFrame == true
            or entry.isWindow == true then
        return "manualClass"
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        if EBFCopyPasteServer.entryIsMoveableLamp(entry) then
            return "vanillaMoveable"
        end
        return "manualClass"
    end
    if EBFCopyPasteServer.entryUsesBrushCreateTile and EBFCopyPasteServer.entryUsesBrushCreateTile(entry) then
        return "brushCreateTile"
    end

    local props = EBFCopyPasteServer.getVanillaMoveableProps and EBFCopyPasteServer.getVanillaMoveableProps(entry) or nil
    if EBFCopyPasteServer.shouldUseVanillaMoveablePaste and EBFCopyPasteServer.shouldUseVanillaMoveablePaste(entry, props) then
        return "vanillaMoveable"
    end
    -- Paredes, cubiertas y cutaways del mapa suelen ser IsoObject simples. No tienen
    -- una ruta Moveable/Brush, pero deben recrearse como objetos de tesela estructurales.
    if EBFCopyPaste.AllowStructuralIsoObjectFallback ~= false
            and entry.objectClass == "IsoObject"
            and EBFCopyPasteServer.entryIsStructural(entry)
            and not EBFCopyPasteServer.entryHasFunctionalState(entry)
            and not EBFCopyPasteServer.entryHasContainers(entry)
            and not EBFCopyPasteServer.entryIsLighting(entry) then
        return "structuralIsoObject"
    end
    return "unknown"
end

function EBFCopyPasteServer.tableEntryCount(value)
    if type(value) ~= "table" then
        return 0
    end

    local count = 0
    for _ in pairs(value) do
        count = count + 1
    end
    return count
end

function EBFCopyPasteServer.getPasteCategoryName(order)
    if order == 10 then return "structural" end
    if order == 20 then return "container" end
    if order == 30 then return "general" end
    if order == 35 then return "worldInventoryLegacy" end
    if order == 40 then return "plumbing" end
    if order == 45 then return "waterDispenser" end
    if order == 50 then return "primaryAppliance" end
    if order == 55 then return "microwave" end
    if order == 60 then return "television" end
    if order == 61 then return "radio" end
    if order == 70 then return "lighting" end
    if order == 71 then return "residentialLighting" end
    if order == 80 then return "worldInventory" end
    return "unknown"
end

function EBFCopyPasteServer.captureContainerMetadata(object, entry)
    local metadata = {
        count = 0,
        primary = false,
        containers = {},
    }

    local count = tonumber(callMethod(object, "getContainerCount")) or 0
    if count > 0 then
        metadata.count = count
        for i = 0, count - 1 do
            local container = callMethod(object, "getContainerByIndex", i)
            if container then
                local items = callMethod(container, "getItems")
                table.insert(metadata.containers, {
                    index = i,
                    type = callMethod(container, "getType"),
                    name = callMethod(container, "getName"),
                    capacity = tonumber(callMethod(container, "getCapacity")),
                    itemCount = items and items:size() or 0,
                })
            end
        end
    end

    local primary = callMethod(object, "getContainer")
    if primary then
        metadata.primary = true
        if metadata.count == 0 then
            local items = callMethod(primary, "getItems")
            metadata.count = 1
            table.insert(metadata.containers, {
                index = 0,
                type = callMethod(primary, "getType"),
                name = callMethod(primary, "getName"),
                capacity = tonumber(callMethod(primary, "getCapacity")),
                itemCount = items and items:size() or 0,
            })
        end
    end

    if entry and EBFCopyPasteServer.entryHasContainers(entry) and metadata.count == 0 then
        metadata.count = #entry.containers
        for i, snapshot in ipairs(entry.containers) do
            table.insert(metadata.containers, {
                index = i - 1,
                type = snapshot and snapshot.type or nil,
                name = snapshot and snapshot.name or nil,
                capacity = tonumber(snapshot and snapshot.capacity),
                itemCount = snapshot and snapshot.items and #snapshot.items or 0,
                deferred = snapshot and snapshot.deferred == true,
            })
        end
    end

    if metadata.count == 0 and not metadata.primary then
        return nil
    end
    return metadata
end

function EBFCopyPasteServer.captureAttachedSpriteDetails(object)
    if not object or not object.getAttachedAnimSprite then
        return nil
    end

    local attached = object:getAttachedAnimSprite()
    if not attached or attached:isEmpty() then
        return nil
    end

    local result = {}
    for i = 0, attached:size() - 1 do
        local spriteInstance = attached:get(i)
        local sprite = spriteInstance and spriteInstance:getParentSprite() or nil
        local spriteName = sprite and sprite:getName() or nil
        if spriteName then
            table.insert(result, {
                index = i,
                sprite = spriteName,
                isLightSwitchSprite = isLightSwitchSprite(spriteName) == true,
                spriteProperties = EBFCopyPasteServer.captureSpritePropertiesSafe(spriteName),
                isoType = EBFCopyPasteServer.getSpriteIsoType(spriteName),
            })
        end
    end

    if #result == 0 then
        return nil
    end
    return result
end

function EBFCopyPasteServer.captureObjectCapabilities(object, entry)
    local spriteName = entry and entry.sprite or getObjectSpriteName(object)
    local capabilities = {
        methods = {},
        sprite = {
            name = spriteName,
            isoType = entry and entry.isoType or EBFCopyPasteServer.getSpriteIsoType(spriteName),
            propertyCount = EBFCopyPasteServer.tableEntryCount(entry and entry.spriteProperties),
            hasFactory = entry and entry.factory ~= nil or false,
        },
        hasSquare = callMethod(object, "getSquare") ~= nil,
        hasSprite = spriteName ~= nil,
        hasModData = entry and entry.modData ~= nil
                or EBFCopyPasteServer.tableHasEntries(copyModData(object)),
        hasOverlay = entry and entry.overlay ~= nil or false,
        hasAttachedSprites = entry and entry.attached ~= nil or false,
        attachedSpriteCount = entry and entry.attached and #entry.attached or 0,
        hasMoveableItem = entry and entry.moveableItem ~= nil or false,
        hasDeviceData = entry and entry.deviceData ~= nil or callMethod(object, "getDeviceData") ~= nil,
        hasWaterState = entry and entry.waterState ~= nil or false,
        hasFluidContainer = callMethod(object, "getFluidContainer") ~= nil,
        hasFluid = callMethod(object, "hasFluid") == true,
        hasLightSettings = entry and entry.lightSettings ~= nil or false,
        hasLightState = entry and entry.lightState ~= nil or false,
        hasLightSource = entry and entry.lightSource ~= nil or callMethod(object, "getLightSource") ~= nil,
        hasControlledLightSources = entry and entry.controlledLightSources ~= nil or false,
        controlledLightSourceCount = entry and entry.controlledLightSources and #entry.controlledLightSources or 0,
        hasContainers = EBFCopyPasteServer.entryHasContainers(entry),
        isWorldInventory = entry and (entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil) or false,
        isDoor = entry and (entry.isDoor == true or entry.objectClass == "IsoDoor") or false,
        isWindow = entry and (entry.isWindow == true or entry.objectClass == "IsoWindow") or false,
        isCurtain = entry and entry.objectClass == "IsoCurtain" or false,
        isThumpable = entry and entry.objectClass == "IsoThumpable" or false,
        isTelevision = EBFCopyPasteServer.entryIsTelevision(entry),
        isRadio = EBFCopyPasteServer.entryIsRadio(entry),
        isMicrowave = EBFCopyPasteServer.entryIsMicrowave(entry),
        isPrimaryAppliance = EBFCopyPasteServer.entryIsPrimaryAppliance(entry),
        isPlumbing = EBFCopyPasteServer.entryIsPlumbingFixture(entry),
        isWaterDispenser = EBFCopyPasteServer.entryIsWaterDispenser(entry),
        isLighting = EBFCopyPasteServer.entryIsLighting(entry),
        isResidentialLighting = EBFCopyPasteServer.entryIsResidentialLighting(entry),
        isStructural = EBFCopyPasteServer.entryIsStructural(entry),
    }

    local methodNames = {
        "getContainer",
        "getContainerCount",
        "getContainerByIndex",
        "getDeviceData",
        "getModData",
        "getFluidContainer",
        "getWaterAmount",
        "hasWater",
        "useWater",
        "getLightSource",
        "getLights",
        "isLightSourceOn",
        "canSwitchLight",
        "getCustomSettingsToItem",
        "getObjectName",
        "getNorth",
        "getSquare",
        "transmitCompleteItemToClients",
        "syncIsoObject",
    }
    for _, methodName in ipairs(methodNames) do
        capabilities.methods[methodName] = getMethod(object, methodName) ~= nil
    end

    capabilities.containers = EBFCopyPasteServer.captureContainerMetadata(object, entry)
    if capabilities.containers then
        capabilities.hasContainers = true
        capabilities.containerCount = capabilities.containers.count or 0
    else
        capabilities.containerCount = 0
    end

    return capabilities
end

function EBFCopyPasteServer.buildEntryClassification(entry, capabilities)
    local order = EBFCopyPasteServer.getPasteCategoryOrder(entry)
    local category = EBFCopyPasteServer.getPasteCategoryName(order)
    local family = "object"
    local subtype = "generic"

    if (entry and entry.objectClass == "IsoWorldInventoryObject") or (entry and entry.worldItem ~= nil) then
        family = "worldInventory"
        subtype = entry and entry.worldItem and entry.worldItem.item and entry.worldItem.item.fullType or "item"
    elseif entry and entry.floor then
        family = "structure"
        subtype = "floor"
    elseif EBFCopyPasteServer.entryIsStructural(entry) then
        family = "structure"
        if (entry and entry.isDoor == true) or (entry and entry.objectClass == "IsoDoor") then
            subtype = "door"
        elseif (entry and entry.isWindow == true) or (entry and entry.objectClass == "IsoWindow") then
            subtype = "window"
        else
            subtype = "wallOrSurface"
        end
    elseif EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        family = "plumbing"
        subtype = tostring(EBFCopyPasteServer.getSpritePropertyValue(entry and entry.sprite, "CustomName") or "fixture")
    elseif EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        family = "water"
        subtype = "dispenser"
    elseif EBFCopyPasteServer.entryIsMicrowave(entry) then
        family = "appliance"
        subtype = "microwave"
    elseif EBFCopyPasteServer.entryIsPrimaryAppliance(entry) then
        family = "appliance"
        if EBFCopyPasteServer.entryLooksLikeStove(entry) then
            subtype = "stove"
        else
            subtype = "refrigeration"
        end
    elseif EBFCopyPasteServer.entryIsTelevision(entry) then
        family = "device"
        subtype = "television"
    elseif EBFCopyPasteServer.entryIsRadio(entry) then
        family = "device"
        subtype = "radio"
    elseif EBFCopyPasteServer.entryIsResidentialLighting(entry) then
        family = "lighting"
        subtype = "residentialSwitch"
    elseif EBFCopyPasteServer.entryIsLighting(entry) then
        family = "lighting"
        subtype = EBFCopyPasteServer.entryIsMoveableLamp(entry) and "moveableLamp" or "light"
    elseif EBFCopyPasteServer.entryHasContainers(entry) then
        family = "container"
        subtype = tostring(entry and entry.containers and entry.containers[1] and entry.containers[1].type or "container")
    end

    local finalizers = {}
    if entry and entry.modData then table.insert(finalizers, "modData") end
    if entry and entry.containers then table.insert(finalizers, "containers") end
    if entry and entry.waterState then table.insert(finalizers, "waterState") end
    if entry and entry.deviceData then table.insert(finalizers, "deviceData") end
    if entry and entry.lightState then table.insert(finalizers, "lightState") end
    if entry and entry.lightSource then table.insert(finalizers, "lightSource") end
    if entry and entry.controlledLightSources then table.insert(finalizers, "controlledLightSources") end
    if entry and entry.lightSettings then table.insert(finalizers, "lightSettings") end
    if entry and entry.overlay then table.insert(finalizers, "overlay") end
    if entry and entry.attached then table.insert(finalizers, "attachedSprites") end
    if entry and entry.moveableItem then table.insert(finalizers, "moveableItem") end

    return {
        categoryOrder = order,
        category = category,
        family = family,
        subtype = subtype,
        pasteStrategy = entry and entry.pasteStrategy or "unknown",
        finalizers = finalizers,
        signals = {
            objectClass = entry and entry.objectClass or nil,
            objectName = entry and entry.objectName or nil,
            sprite = entry and entry.sprite or nil,
            isoType = entry and entry.isoType or nil,
            customName = EBFCopyPasteServer.getSpritePropertyValue(entry and entry.sprite, "CustomName"),
            groupName = EBFCopyPasteServer.getSpritePropertyValue(entry and entry.sprite, "GroupName"),
            container = EBFCopyPasteServer.getSpritePropertyValue(entry and entry.sprite, "container"),
            hasDeviceData = capabilities and capabilities.hasDeviceData == true or false,
            hasWaterState = capabilities and capabilities.hasWaterState == true or false,
            hasLightState = capabilities and capabilities.hasLightState == true or false,
            hasContainers = capabilities and capabilities.hasContainers == true or false,
        },
    }
end

function EBFCopyPasteServer.buildEntryFingerprint(entry, capabilities)
    local containers = capabilities and capabilities.containers or nil
    local itemCount = 0
    if containers and containers.containers then
        for _, container in ipairs(containers.containers) do
            itemCount = itemCount + (tonumber(container.itemCount) or 0)
        end
    end

    local worldItemFullType = nil
    local worldItemOffX = nil
    local worldItemOffY = nil
    local worldItemOffZ = nil
    if entry and entry.worldItem then
        worldItemFullType = getItemSnapshotFullType(entry.worldItem.item)
        worldItemOffX = entry.worldItem.offX
        worldItemOffY = entry.worldItem.offY
        worldItemOffZ = entry.worldItem.offZ
    end

    local lightActivated = nil
    if entry and entry.lightState and entry.lightState.methods then
        lightActivated = entry.lightState.methods.setActivated
    end

    return {
        objectClass = entry and entry.objectClass or nil,
        objectName = entry and entry.objectName or nil,
        sprite = entry and entry.sprite or nil,
        isoType = entry and entry.isoType or nil,
        floor = entry and entry.floor == true or false,
        north = entry and entry.north or nil,
        index = entry and entry.index or nil,
        objectLayer = entry and entry.objectLayer or nil,
        needsSupportBeforePaste = entry and entry.needsSupportBeforePaste == true or false,
        pasteStrategy = entry and entry.pasteStrategy or nil,
        category = entry and entry.classification and entry.classification.category or nil,
        family = entry and entry.classification and entry.classification.family or nil,
        subtype = entry and entry.classification and entry.classification.subtype or nil,
        containerCount = capabilities and capabilities.containerCount or 0,
        itemCount = itemCount,
        hasDeviceData = capabilities and capabilities.hasDeviceData == true or false,
        hasWaterState = capabilities and capabilities.hasWaterState == true or false,
        hasFluid = capabilities and (capabilities.hasFluid == true or capabilities.hasFluidContainer == true) or false,
        hasLightState = capabilities and capabilities.hasLightState == true or false,
        hasLightSource = capabilities and capabilities.hasLightSource == true or false,
        controlledLightSourceCount = capabilities and capabilities.controlledLightSourceCount or 0,
        hasModData = capabilities and capabilities.hasModData == true or false,
        hasOverlay = capabilities and capabilities.hasOverlay == true or false,
        attachedSpriteCount = capabilities and capabilities.attachedSpriteCount or 0,
        worldItemFullType = worldItemFullType,
        worldItemOffX = worldItemOffX,
        worldItemOffY = worldItemOffY,
        worldItemOffZ = worldItemOffZ,
        lightActivated = lightActivated,
        stateMethodCount = EBFCopyPasteServer.tableEntryCount(entry and entry.state and entry.state.methods),
        modDataKeyCount = EBFCopyPasteServer.tableEntryCount(entry and entry.modData),
        spritePropertyCount = EBFCopyPasteServer.tableEntryCount(entry and entry.spriteProperties),
        hasVanillaPlacement = entry and entry.vanillaPlacement ~= nil or false,
        vanillaCustomItem = entry and entry.vanillaPlacement and entry.vanillaPlacement.customItem or nil,
        vanillaIsoType = entry and entry.vanillaPlacement and entry.vanillaPlacement.isoType or nil,
        vanillaMoveType = entry and entry.vanillaPlacement and entry.vanillaPlacement.moveType or nil,
    }
end

function EBFCopyPasteServer.getEntryContainerSummary(entry, capabilities)
    local summary = {
        count = 0,
        itemCount = 0,
        deferredCount = 0,
        types = {},
    }

    if capabilities and capabilities.containers and capabilities.containers.containers then
        summary.count = tonumber(capabilities.containers.count) or 0
        for _, container in ipairs(capabilities.containers.containers) do
            local itemCount = tonumber(container and container.itemCount) or 0
            summary.itemCount = summary.itemCount + itemCount
            if container and container.type then
                summary.types[tostring(container.type)] = (summary.types[tostring(container.type)] or 0) + 1
            end
            if container and container.deferred == true then
                summary.deferredCount = summary.deferredCount + 1
            end
        end
    elseif entry and entry.containers then
        summary.count = #entry.containers
        for _, container in ipairs(entry.containers) do
            local itemCount = container and container.items and #container.items or 0
            summary.itemCount = summary.itemCount + itemCount
            if container and container.type then
                summary.types[tostring(container.type)] = (summary.types[tostring(container.type)] or 0) + 1
            end
            if container and container.deferred == true then
                summary.deferredCount = summary.deferredCount + 1
            end
        end
    end

    if summary.count == 0 and summary.itemCount == 0 and not EBFCopyPasteServer.tableHasEntries(summary.types) then
        return nil
    end
    return summary
end

function EBFCopyPasteServer.buildEntryIdentity(entry)
    if not entry then
        return nil
    end
    local spriteProperties = entry.spriteProperties or {}

    return {
        schemaVersion = EBFCopyPaste.SchemaVersion or 4220001,
        targetBuild = EBFCopyPaste.TargetBuild or "42.20",
        objectClass = entry.objectClass,
        objectName = entry.objectName,
        name = entry.name,
        sprite = entry.sprite,
        isoType = entry.isoType,
        factory = entry.factory,
        spriteProperties = entry.spriteProperties,
        spritePropertyNames = spriteProperties.propertyNames,
        spriteFlagNames = spriteProperties.flagNames,
        spriteFlags = spriteProperties.flags,
        spriteAllProperties = spriteProperties.allProperties,
        vanillaPlacement = entry.vanillaPlacement,
        objectIndex = entry.index,
        north = entry.north,
        floor = entry.floor == true,
        door = entry.isDoor == true or entry.objectClass == "IsoDoor",
        doorFrame = entry.isDoorFrame == true,
        window = entry.isWindow == true or entry.objectClass == "IsoWindow",
        curtain = entry.objectClass == "IsoCurtain",
        wallOrSurface = EBFCopyPasteServer.entryIsStructural(entry),
        container = EBFCopyPasteServer.entryHasContainers(entry),
        device = EBFCopyPasteServer.entryIsWaveSignal(entry) or entry.deviceData ~= nil,
        light = EBFCopyPasteServer.entryIsLighting(entry),
        water = EBFCopyPasteServer.entryIsPlumbingFixture(entry) or EBFCopyPasteServer.entryIsWaterDispenser(entry),
        worldInventory = entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil,
        relative = {
            dx = entry.dx,
            dy = entry.dy,
            dz = entry.dz,
        },
        classification = entry.classification,
        pasteStrategy = entry.pasteStrategy,
    }
end

function EBFCopyPasteServer.buildEntryVanillaDescriptor(entry, capabilities)
    if not entry then
        return nil
    end

    local classification = entry.classification or {}
    local properties = entry.spriteProperties or {}
    return {
        schemaVersion = EBFCopyPaste.SchemaVersion or 4220001,
        targetBuild = EBFCopyPaste.TargetBuild or "42.20",
        sprite = entry.sprite,
        objectClass = entry.objectClass,
        objectName = entry.objectName,
        isoType = entry.isoType,
        factoryType = entry.factory and entry.factory.type or nil,
        spriteType = entry.factory and entry.factory.spriteType or nil,
        moveType = entry.vanillaPlacement and entry.vanillaPlacement.moveType or properties.MoveType,
        customName = properties.CustomName,
        customItem = entry.vanillaPlacement and entry.vanillaPlacement.customItem or properties.CustomItem,
        groupName = properties.GroupName,
        flags = properties.flags,
        flagNames = properties.flagNames,
        propertyNames = properties.propertyNames,
        allProperties = properties.allProperties,
        family = classification.family,
        subtype = classification.subtype,
        category = classification.category,
        pasteStrategy = entry.pasteStrategy,
        requiredCreationPath = entry.pasteStrategy,
        capabilities = {
            hasContainers = capabilities and capabilities.hasContainers == true or false,
            hasDeviceData = capabilities and capabilities.hasDeviceData == true or false,
            hasWaterState = capabilities and capabilities.hasWaterState == true or false,
            hasFluid = capabilities and (capabilities.hasFluid == true or capabilities.hasFluidContainer == true) or false,
            hasLight = capabilities and (capabilities.hasLightState == true
                    or capabilities.hasLightSource == true
                    or capabilities.hasLightSettings == true
                    or capabilities.hasControlledLightSources == true) or false,
            isStructural = capabilities and capabilities.isStructural == true or false,
            isWorldInventory = capabilities and capabilities.isWorldInventory == true or false,
        },
    }
end

function EBFCopyPasteServer.buildEntryStateBlock(entry, capabilities)
    if not entry then
        return nil
    end

    local containerSummary = EBFCopyPasteServer.getEntryContainerSummary(entry, capabilities)
    local moveableItem = entry.moveableItem and {
        fullType = entry.moveableItem.fullType,
        name = entry.moveableItem.name,
        hasModData = entry.moveableItem.modData ~= nil,
        hasDeviceData = entry.moveableItem.deviceData ~= nil,
        hasFluid = entry.moveableItem.fluid ~= nil,
    } or nil

    return {
        objectState = entry.state,
        modData = entry.modData,
        overlay = entry.overlay,
        attached = entry.attached,
        attachedDetails = entry.attachedDetails,
        containers = containerSummary,
        deviceData = entry.deviceData,
        waterData = entry.waterState,
        lightData = {
            settings = entry.lightSettings,
            state = entry.lightState,
            source = entry.lightSource,
            controlledSources = entry.controlledLightSources,
        },
        worldItem = entry.worldItem and {
            fullType = entry.worldItem.item and entry.worldItem.item.fullType or nil,
            itemId = entry.worldItem.itemId,
            offX = entry.worldItem.offX,
            offY = entry.worldItem.offY,
            offZ = entry.worldItem.offZ,
            worldZRotation = entry.worldItem.worldZRotation,
            extendedPlacement = entry.worldItem.extendedPlacement == true,
        } or nil,
        moveableItem = moveableItem,
        capabilities = {
            hasContainer = capabilities and capabilities.hasContainers == true or false,
            hasDeviceData = capabilities and capabilities.hasDeviceData == true or false,
            hasFluid = capabilities and (capabilities.hasFluid == true or capabilities.hasFluidContainer == true) or false,
            hasWaterState = capabilities and capabilities.hasWaterState == true or false,
            hasLight = capabilities and (capabilities.hasLightState == true
                    or capabilities.hasLightSource == true
                    or capabilities.hasLightSettings == true
                    or capabilities.hasControlledLightSources == true) or false,
            hasModData = capabilities and capabilities.hasModData == true or false,
        },
    }
end

function EBFCopyPasteServer.entryIsWorldInventoryEntry(entry)
    if not entry then
        return false
    end
    local classification = entry.classification or {}
    return entry.objectClass == "IsoWorldInventoryObject"
            or entry.worldItem ~= nil
            or classification.family == "worldInventory"
end

function EBFCopyPasteServer.getEntryWorldItemFullType(entry)
    if not entry or not entry.worldItem then
        return nil
    end
    return getItemSnapshotFullType(entry.worldItem.item)
end

function EBFCopyPasteServer.getEntryScannerWarnings(entry)
    local warnings = {}
    if not entry then
        return warnings
    end

    local classification = entry.classification or {}
    local capabilities = entry.capabilities or {}
    local family = classification.family or "unknown"
    local category = classification.category or "unknown"
    local strategy = entry.pasteStrategy or "unknown"

    local isWorldInventory = EBFCopyPasteServer.entryIsWorldInventoryEntry(entry)

    if not isWorldInventory and (type(entry.sprite) ~= "string" or entry.sprite == "") then
        table.insert(warnings, "missingSprite")
    end
    if category == "unknown" then
        table.insert(warnings, "unknownCategory")
    end
    if capabilities.hasContainers == true and not EBFCopyPasteServer.entryHasContainers(entry) then
        table.insert(warnings, "containerCapabilityWithoutSnapshot")
    end
    if capabilities.hasDeviceData == true and entry.deviceData == nil then
        table.insert(warnings, "deviceCapabilityWithoutSnapshot")
    end
    if capabilities.hasFluidContainer == true and entry.waterState == nil then
        table.insert(warnings, "fluidCapabilityWithoutWaterState")
    end
    if capabilities.isLighting == true and entry.lightState == nil and entry.lightSource == nil and entry.lightSettings == nil then
        table.insert(warnings, "lightingWithoutLightState")
    end
    if family == "device" and entry.deviceData == nil then
        table.insert(warnings, "deviceWithoutDeviceData")
    end
    if family == "worldInventory" and not EBFCopyPasteServer.getEntryWorldItemFullType(entry) then
        table.insert(warnings, "worldItemWithoutFullType")
    end
    return warnings
end

function EBFCopyPasteServer.buildEntryScanValidation(entry)
    local validation = {
        ok = true,
        critical = false,
        family = entry and entry.classification and entry.classification.family or "unknown",
        subtype = entry and entry.classification and entry.classification.subtype or "unknown",
        pasteStrategy = entry and entry.pasteStrategy or "unknown",
        missing = {},
        warnings = {},
    }

    if not entry then
        validation.ok = false
        validation.critical = true
        table.insert(validation.missing, "missingEntry")
        return validation
    end

    local function requireData(condition, code)
        if condition then
            return
        end
        validation.ok = false
        validation.critical = true
        table.insert(validation.missing, code)
    end

    local function warnIfMissing(condition, code)
        if condition then
            return
        end
        table.insert(validation.warnings, code)
    end

    local sprite = entry.sprite
    local properties = entry.spriteProperties or {}
    local vanillaPlacement = entry.vanillaPlacement
    local strategy = entry.pasteStrategy or "unknown"
    local family = validation.family
    local customItem = vanillaPlacement and vanillaPlacement.customItem or properties.CustomItem

    local isWorldInventory = EBFCopyPasteServer.entryIsWorldInventoryEntry(entry)
    if isWorldInventory then
        warnIfMissing(type(sprite) == "string" and sprite ~= "", "worldItemSprite")
    else
        requireData(type(sprite) == "string" and sprite ~= "", "sprite")
    end
    warnIfMissing(entry.objectClass ~= nil or entry.isoType ~= nil or entry.floor == true, "objectClassOrIsoType")

    if isWorldInventory then
        requireData(entry.worldItem ~= nil, "worldItemSnapshot")
        requireData(EBFCopyPasteServer.getEntryWorldItemFullType(entry), "worldItemFullType")
        warnIfMissing(entry.worldItem and entry.worldItem.offX ~= nil and entry.worldItem.offY ~= nil, "worldItemOffsets")
    end

    if EBFCopyPasteServer.entryHasContainers(entry) then
        for index, snapshot in ipairs(entry.containers or {}) do
            requireData(snapshot.items ~= nil, "containerItems:" .. tostring(index))
            warnIfMissing(snapshot.type ~= nil, "containerType:" .. tostring(index))
            warnIfMissing(snapshot.capacity ~= nil, "containerCapacity:" .. tostring(index))
        end
    elseif entry.capabilities and entry.capabilities.hasContainers == true then
        requireData(false, "containerSnapshot")
    end

    if EBFCopyPasteServer.entryIsTelevision(entry) then
        requireData(vanillaPlacement ~= nil, "televisionVanillaPlacement")
        requireData(type(customItem) == "string" and customItem ~= "" and customItem ~= "Moveables.Moveable", "televisionCustomItem")
        requireData(not (vanillaPlacement and vanillaPlacement.customItemExists == false), "televisionCustomItemExists")
        requireData(entry.objectClass == "IsoTelevision"
                or entry.isoType == "IsoTelevision"
                or (vanillaPlacement and vanillaPlacement.isoType == "IsoTelevision"), "televisionIsoType")
        requireData(strategy == "vanillaMoveable", "televisionVanillaMoveableStrategy")
        warnIfMissing(entry.deviceData ~= nil, "televisionDeviceData")
    elseif EBFCopyPasteServer.entryIsRadio(entry) then
        requireData(vanillaPlacement ~= nil, "radioVanillaPlacement")
        requireData(entry.objectClass == "IsoRadio"
                or entry.isoType == "IsoRadio"
                or (vanillaPlacement and vanillaPlacement.isoType == "IsoRadio"), "radioIsoType")
        requireData(strategy == "vanillaMoveable", "radioVanillaMoveableStrategy")
        warnIfMissing(entry.deviceData ~= nil, "radioDeviceData")
    end

    if EBFCopyPasteServer.entryIsMoveableLamp(entry) then
        requireData(vanillaPlacement ~= nil, "lampVanillaPlacement")
        requireData(strategy == "vanillaMoveable", "lampVanillaMoveableStrategy")
        warnIfMissing(vanillaPlacement and vanillaPlacement.canUsePlaceMoveableInternal == true, "lampPlaceMoveableInternal")
        warnIfMissing(entry.lightState ~= nil or entry.lightSource ~= nil or entry.lightSettings ~= nil, "lampLightState")
    elseif EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
        requireData(entry.sourceRoomKey ~= nil or entry.sourceRoom ~= nil, "residentialLightSourceRoom")
        requireData(entry.objectClass == "IsoLightSwitch"
                or entry.isoType == "IsoLightSwitch"
                or isLightSwitchSprite(sprite), "residentialLightSwitchIdentity")
        warnIfMissing(entry.lightState ~= nil or entry.controlledLightSources ~= nil, "residentialLightRuntimeState")
        warnIfMissing(entry.sourceRoom and entry.sourceRoom.roomDefName ~= nil, "residentialLightRoomName")
    elseif EBFCopyPasteServer.entryIsLighting(entry) then
        requireData(entry.objectClass == "IsoLightSwitch"
                or entry.isoType == "IsoLightSwitch"
                or isLightSwitchSprite(sprite)
                or vanillaPlacement ~= nil, "lightingIdentity")
        warnIfMissing(entry.lightState ~= nil or entry.lightSource ~= nil or entry.lightSettings ~= nil, "lightingRuntimeState")
    end

    if EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        requireData(entry.waterState ~= nil, "plumbingWaterState")
    end

    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        requireData(entry.waterState ~= nil, "waterDispenserState")
        warnIfMissing(entry.waterState and (entry.waterState.fluid ~= nil
                or entry.waterState.fluidAmount ~= nil
                or entry.waterState.hasFluid ~= nil), "waterDispenserFluidSnapshot")
    end

    if EBFCopyPasteServer.entryIsMicrowave(entry) then
        warnIfMissing(EBFCopyPasteServer.entryHasContainers(entry), "microwaveContainer")
    end

    validation.missingCount = #validation.missing
    validation.warningCount = #validation.warnings
    return validation
end

function EBFCopyPasteServer.refreshEntryScanValidation(entry)
    if not entry then
        return nil
    end

    entry.scanValidation = EBFCopyPasteServer.buildEntryScanValidation(entry)
    entry.auditWarnings = EBFCopyPasteServer.getEntryScannerWarnings(entry)
    for _, issue in ipairs(entry.scanValidation.missing or {}) do
        table.insert(entry.auditWarnings, "scanMissing:" .. tostring(issue))
    end
    for _, issue in ipairs(entry.scanValidation.warnings or {}) do
        table.insert(entry.auditWarnings, "scanWarn:" .. tostring(issue))
    end
    return entry.scanValidation
end

function EBFCopyPasteServer.decorateScannerEntry(entry, object)
    if not entry then
        return nil
    end
    if not entry.pasteStrategy then
        entry.pasteStrategy = EBFCopyPasteServer.selectPasteStrategy(entry)
    end
    entry.attachedDetails = EBFCopyPasteServer.captureAttachedSpriteDetails(object)
    entry.capabilities = EBFCopyPasteServer.captureObjectCapabilities(object, entry)
    entry.classification = EBFCopyPasteServer.buildEntryClassification(entry, entry.capabilities)
    entry.objectLayer = EBFCopyPasteServer.getEntryObjectLayer(entry)
    entry.needsSupportBeforePaste = EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry)
    entry.identity = EBFCopyPasteServer.buildEntryIdentity(entry)
    entry.stateBlock = EBFCopyPasteServer.buildEntryStateBlock(entry, entry.capabilities)
    entry.fingerprint = EBFCopyPasteServer.buildEntryFingerprint(entry, entry.capabilities)
    entry.vanillaDescriptor = EBFCopyPasteServer.buildEntryVanillaDescriptor(entry, entry.capabilities)
    EBFCopyPasteServer.refreshEntryScanValidation(entry)
    return entry
end

function EBFCopyPasteServer.bumpScannerStat(stats, group, key, amount)
    if not stats or not key then
        return
    end
    stats[group] = stats[group] or {}
    stats[group][key] = (stats[group][key] or 0) + (amount or 1)
end

function EBFCopyPasteServer.recordScannerAudit(stats, tileSnapshot, entry)
    if not entry then
        return
    end

    local classification = entry.classification or EBFCopyPasteServer.buildEntryClassification(entry, entry.capabilities)
    local capabilities = entry.capabilities
    local family = classification and classification.family or "unknown"
    local subtype = classification and classification.subtype or "unknown"
    local category = classification and classification.category or "unknown"
    local strategy = entry.pasteStrategy or "unknown"

    EBFCopyPasteServer.bumpScannerStat(stats, "families", family)
    EBFCopyPasteServer.bumpScannerStat(stats, "subtypes", subtype)
    EBFCopyPasteServer.bumpScannerStat(stats, "categories", category)
    EBFCopyPasteServer.bumpScannerStat(stats, "strategies", strategy)

    if stats then
        if family == "device" then stats.deviceObjects = (stats.deviceObjects or 0) + 1 end
        if family == "lighting" then stats.lightObjects = (stats.lightObjects or 0) + 1 end
        if family == "plumbing" or family == "water" then stats.waterObjects = (stats.waterObjects or 0) + 1 end
        if family == "worldInventory" then stats.worldItems = (stats.worldItems or 0) + 1 end
        if family == "container" or (capabilities and capabilities.hasContainers == true) then
            stats.containerObjects = (stats.containerObjects or 0) + 1
        end
        if family == "structure" then stats.structuralObjects = (stats.structuralObjects or 0) + 1 end
        local auditWarnings = entry.auditWarnings or {}
        if #auditWarnings > 0 then
            stats.warningObjects = (stats.warningObjects or 0) + 1
            stats.warningIssueCount = (stats.warningIssueCount or 0) + #auditWarnings
            stats.scanWarningExamples = stats.scanWarningExamples or {}
            if #stats.scanWarningExamples < 32 then
                table.insert(stats.scanWarningExamples, {
                    sprite = entry.sprite,
                    objectClass = entry.objectClass,
                    family = family,
                    subtype = subtype,
                    worldItemFullType = EBFCopyPasteServer.getEntryWorldItemFullType(entry),
                    dx = entry.dx,
                    dy = entry.dy,
                    dz = entry.dz,
                    tileOrder = entry.tileOrder,
                    index = entry.index,
                    scanOrder = entry.scanOrder,
                    warnings = copyPersistentValue(auditWarnings, 0),
                })
            end
        end
        for _, warning in ipairs(auditWarnings) do
            EBFCopyPasteServer.bumpScannerStat(stats, "warnings", warning)
        end
        local validation = entry.scanValidation
        if validation then
            stats.scanValidatedObjects = (stats.scanValidatedObjects or 0) + 1
            if validation.ok == true then
                stats.scanValidationOkObjects = (stats.scanValidationOkObjects or 0) + 1
            else
                stats.scanValidationMissingObjects = (stats.scanValidationMissingObjects or 0) + 1
                stats.scanValidationMissingCount = (stats.scanValidationMissingCount or 0) + (validation.missingCount or 0)
                if validation.critical == true then
                    stats.scanValidationCriticalObjects = (stats.scanValidationCriticalObjects or 0) + 1
                end
                stats.scanValidationExamples = stats.scanValidationExamples or {}
                if #stats.scanValidationExamples < 8 then
                    table.insert(stats.scanValidationExamples, {
                        sprite = entry.sprite,
                        objectClass = entry.objectClass,
                        family = validation.family,
                        subtype = validation.subtype,
                        worldItemFullType = EBFCopyPasteServer.getEntryWorldItemFullType(entry),
                        dx = entry.dx,
                        dy = entry.dy,
                        dz = entry.dz,
                        missing = copyPersistentValue(validation.missing, 0),
                    })
                end
            end
            for _, issue in ipairs(validation.missing or {}) do
                EBFCopyPasteServer.bumpScannerStat(stats, "scanMissing", issue)
            end
            for _, issue in ipairs(validation.warnings or {}) do
                EBFCopyPasteServer.bumpScannerStat(stats, "scanValidationWarnings", issue)
            end
        end
    end

    if tileSnapshot then
        tileSnapshot.summary = tileSnapshot.summary or {
            families = {},
            categories = {},
            strategies = {},
            warnings = {},
            hasContainer = false,
            hasDevice = false,
            hasWater = false,
            hasLight = false,
            hasWorldItem = false,
            hasStructural = false,
        }
        tileSnapshot.summary.families[family] = (tileSnapshot.summary.families[family] or 0) + 1
        tileSnapshot.summary.categories[category] = (tileSnapshot.summary.categories[category] or 0) + 1
        tileSnapshot.summary.strategies[strategy] = (tileSnapshot.summary.strategies[strategy] or 0) + 1
        tileSnapshot.summary.hasContainer = tileSnapshot.summary.hasContainer or (capabilities and capabilities.hasContainers == true) or false
        tileSnapshot.summary.hasDevice = tileSnapshot.summary.hasDevice or family == "device"
        tileSnapshot.summary.hasWater = tileSnapshot.summary.hasWater or family == "plumbing" or family == "water"
        tileSnapshot.summary.hasLight = tileSnapshot.summary.hasLight or family == "lighting"
        tileSnapshot.summary.hasWorldItem = tileSnapshot.summary.hasWorldItem or family == "worldInventory"
        tileSnapshot.summary.hasStructural = tileSnapshot.summary.hasStructural or family == "structure"
        for _, warning in ipairs(entry.auditWarnings or {}) do
            tileSnapshot.summary.warnings[warning] = (tileSnapshot.summary.warnings[warning] or 0) + 1
        end
    end
end

local function captureLightState(object)
    if not objectLooksLikeLightSwitch(object) then
        return nil
    end

    local canSwitch = nil
    if not EBFCopyPasteServer.entryIsMoveableLamp(nil, object) then
        canSwitch = callMethod(object, "canSwitchLight")
    end

    local state = {
        methods = {},
        hasLightBulb = callMethod(object, "hasLightBulb"),
        bulbItem = callMethod(object, "getBulbItem"),
        canSwitch = canSwitch,
    }

    local hasValues = state.hasLightBulb ~= nil or state.bulbItem ~= nil or state.canSwitch ~= nil
    for _, methodPair in ipairs(lightCopyMethods) do
        local value = callMethod(object, methodPair[1])
        if value ~= nil then
            state.methods[methodPair[2]] = value
            hasValues = true
        end
    end

    if hasValues then
        return state
    end
    return nil
end

function EBFCopyPasteServer.captureLightSourceState(object)
    if not object then
        return nil
    end

    local radius = tonumber(callMethod(object, "getLightSourceRadius")) or 0
    local lightSource = callMethod(object, "getLightSource")
    if radius <= 0 and not lightSource then
        return nil
    end

    local state = {
        radius = radius > 0 and radius or tonumber(callMethod(lightSource, "getRadius")) or nil,
        xoffset = tonumber(callMethod(object, "getLightSourceXOffset")) or 0,
        yoffset = tonumber(callMethod(object, "getLightSourceYOffset")) or 0,
        life = tonumber(callMethod(object, "getLightSourceLife")),
        lifeLeft = tonumber(callMethod(object, "getLifeLeft")),
        fuel = callMethod(object, "getLightSourceFuel"),
        on = callMethod(object, "isLightSourceOn"),
        haveFuel = callMethod(object, "haveFuel"),
    }

    if lightSource then
        state.active = callMethod(lightSource, "isActive")
        state.wasActive = callMethod(lightSource, "wasActive")
        state.r = tonumber(callMethod(lightSource, "getR"))
        state.g = tonumber(callMethod(lightSource, "getG"))
        state.b = tonumber(callMethod(lightSource, "getB"))
    end

    return state
end

function EBFCopyPasteServer.captureControlledLightSources(object, square, copyDx, copyDy, dz)
    if not object or not square then
        return nil
    end

    local sourceX = EBFCopyPaste.toInt(square:getX(), 0) - EBFCopyPaste.toInt(copyDx, 0)
    local sourceY = EBFCopyPaste.toInt(square:getY(), 0) - EBFCopyPaste.toInt(copyDy, 0)
    local sourceZ = EBFCopyPaste.toInt(square:getZ(), 0) - EBFCopyPaste.toInt(dz, 0)
    local lights = callMethod(object, "getLights")
    local count = tonumber(callMethod(lights, "size")) or 0
    if count <= 0 and EBFCopyPasteServer.entryIsResidentialLightSwitch(nil, object) then
        local room = callMethod(square, "getRoom")
        local roomLights = EBFCopyPasteServer.getRoomLightList and EBFCopyPasteServer.getRoomLightList(room) or nil
        if (tonumber(callMethod(roomLights, "size")) or 0) <= 0 and room and getMethod(room, "createLights") then
            EBFCopyPasteServer.tryCallMethod(room, "createLights", false)
            roomLights = EBFCopyPasteServer.getRoomLightList and EBFCopyPasteServer.getRoomLightList(room) or nil
        end

        local roomDef = room and callMethod(room, "getRoomDef") or nil
        local roomLightsActive = roomDef and EBFCopyPasteServer.safeField(roomDef, "lightsActive") == true or false
        local roomLightCount = tonumber(callMethod(roomLights, "size")) or 0
        if roomLightCount > 0 then
            local roomResult = {}
            for i = 0, roomLightCount - 1 do
                local roomLight = callMethod(roomLights, "get", i)
                local lightX = tonumber(EBFCopyPasteServer.safeField(roomLight, "x"))
                local lightY = tonumber(EBFCopyPasteServer.safeField(roomLight, "y"))
                local lightZ = tonumber(EBFCopyPasteServer.safeField(roomLight, "z")) or square:getZ()
                local width = math.max(1, tonumber(EBFCopyPasteServer.safeField(roomLight, "width")) or 1)
                local height = math.max(1, tonumber(EBFCopyPasteServer.safeField(roomLight, "height")) or 1)
                if lightX ~= nil and lightY ~= nil then
                    local centerX = lightX + math.floor((width - 1) / 2)
                    local centerY = lightY + math.floor((height - 1) / 2)
                    table.insert(roomResult, {
                        kind = "roomLight",
                        dx = math.floor(centerX - sourceX),
                        dy = math.floor(centerY - sourceY),
                        dz = math.floor(lightZ - sourceZ),
                        radius = math.max(4, math.min(18, math.ceil(math.max(width, height) * 1.4))),
                        r = 0.9,
                        g = 0.8,
                        b = 0.7,
                        active = roomLightsActive == true,
                        wasActive = roomLightsActive == true,
                        roomRect = {
                            dx = math.floor(lightX - sourceX),
                            dy = math.floor(lightY - sourceY),
                            dz = math.floor(lightZ - sourceZ),
                            w = width,
                            h = height,
                        },
                    })
                end
            end
            if #roomResult > 0 then
                return roomResult
            end
        end
        return nil
    elseif count <= 0 then
        return nil
    end

    local result = {}
    for i = 0, count - 1 do
        local light = callMethod(lights, "get", i)
        if light then
            local lightX = tonumber(callMethod(light, "getX"))
            local lightY = tonumber(callMethod(light, "getY"))
            local lightZ = tonumber(callMethod(light, "getZ"))
            if lightX ~= nil and lightY ~= nil and lightZ ~= nil then
                table.insert(result, {
                    dx = math.floor(lightX - sourceX),
                    dy = math.floor(lightY - sourceY),
                    dz = math.floor(lightZ - sourceZ),
                    radius = tonumber(callMethod(light, "getRadius")) or 4,
                    r = tonumber(callMethod(light, "getR")) or 1,
                    g = tonumber(callMethod(light, "getG")) or 1,
                    b = tonumber(callMethod(light, "getB")) or 1,
                    active = callMethod(light, "isActive") == true,
                    wasActive = callMethod(light, "wasActive") == true,
                })
            end
        end
    end

    if #result == 0 then
        return nil
    end
    return result
end

local function copyAttachedSprites(object)
    if not object or not object.getAttachedAnimSprite then
        return nil
    end

    local attached = object:getAttachedAnimSprite()
    if not attached or attached:isEmpty() then
        return nil
    end

    local result = {}
    for i = 0, attached:size() - 1 do
        local spriteInstance = attached:get(i)
        local sprite = spriteInstance and spriteInstance:getParentSprite() or nil
        local spriteName = sprite and sprite:getName() or nil
        if spriteName and not isLightSwitchSprite(spriteName) then
            table.insert(result, spriteName)
        end
    end

    if #result == 0 then
        return nil
    end
    return result
end

local function copyAttachedLightEntries(square, object, dx, dy, dz, stats)
    if not object or not object.getAttachedAnimSprite then
        return nil
    end
    if objectLooksLikeLightSwitch(object) then
        return nil
    end

    local attached = object:getAttachedAnimSprite()
    if not attached or attached:isEmpty() then
        return nil
    end

    local result = nil
    local baseIndex = object.getObjectIndex and object:getObjectIndex() or 0
    for i = 0, attached:size() - 1 do
        local spriteInstance = attached:get(i)
        local sprite = spriteInstance and spriteInstance:getParentSprite() or nil
        local spriteName = sprite and sprite:getName() or nil
        if isLightSwitchSprite(spriteName) then
            result = result or {}
            local lightEntry = {
                dx = dx,
                dy = dy,
                dz = dz,
                index = baseIndex + 0.01 + (i / 1000),
                objectClass = "IsoLightSwitch",
                sprite = spriteName,
                floor = false,
                north = callMethod(object, "getNorth"),
                state = { methods = {} },
                lightState = {
                    methods = {
                        setCanBeModified = false,
                        setUseBattery = false,
                        setHasBattery = false,
                        setPower = 1,
                    },
                    hasLightBulb = true,
                    canSwitch = true,
                },
                attachedGenerated = true,
            }
            table.insert(result, EBFCopyPasteServer.decorateScannerEntry(lightEntry, nil))
            if stats then
                stats.lights = (stats.lights or 0) + 1
            end
        end
    end

    return result
end

local function applyAttachedSprites(object, attached)
    if not object or not attached or #attached == 0 then
        return
    end

    object:setAttachedAnimSprite(ArrayList:new())
    for _, spriteName in ipairs(attached) do
        local sprite = getSprite(spriteName)
        if sprite then
            object:getAttachedAnimSprite():add(sprite:newInstance())
        end
    end
end

local function getSpriteName(object)
    local sprite = object and object:getSprite() or nil
    return sprite and sprite:getName() or nil
end

local function serializeObject(square, object, dx, dy, dz, stats, deferredContainerCopies)
    local spriteName = getSpriteName(object)
    if not spriteName then
        return nil
    end

    local objectClass = getObjectClass(object)
    local state = captureObjectState(object)
    local north = callMethod(object, "getNorth")
    if objectClass == "IsoWindow" then
        spriteName = EBFCopyPasteServer.getCanonicalWindowSprite(spriteName, state, north)
    elseif objectClass == "IsoDoor" then
        spriteName = EBFCopyPasteServer.getCanonicalDoorSprite(spriteName, state, north)
    end

    local overlaySprite = object.getOverlaySprite and object:getOverlaySprite() or nil
    local overlayName = overlaySprite and overlaySprite:getName() or nil
    local name = nil
    if object.getName then
        name = object:getName()
    end

    local entry = {
        dx = dx,
        dy = dy,
        dz = dz,
        index = object.getObjectIndex and object:getObjectIndex() or 0,
        objectClass = objectClass,
        objectName = callMethod(object, "getObjectName"),
        isoType = EBFCopyPasteServer.getSpriteIsoType(spriteName),
        factory = EBFCopyPasteServer.captureSpriteFactoryInfo(spriteName),
        spriteProperties = EBFCopyPasteServer.captureSpritePropertiesSafe(spriteName),
        vanillaPlacement = EBFCopyPasteServer.captureVanillaPlacementIdentity(spriteName),
        sprite = spriteName,
        name = type(name) == "string" and name or nil,
        floor = square:getFloor() == object,
        north = north,
        isDoor = callMethod(object, "isDoor"),
        isDoorFrame = callMethod(object, "isDoorFrame"),
        isWindow = callMethod(object, "isWindow"),
        overlay = overlayName,
        attached = copyAttachedSprites(object),
        modData = copyModData(object),
        state = state,
        waterState = EBFCopyPasteServer.captureObjectWaterState(object, spriteName),
        lightSettings = copyLightSettingsItem(object, spriteName),
        lightState = captureLightState(object),
        lightSource = EBFCopyPasteServer.captureLightSourceState(object),
        controlledLightSources = EBFCopyPasteServer.captureControlledLightSources(object, square, dx, dy, dz),
        deviceData = EBFCopyPasteServer.captureDeviceData(object),
        containers = copyObjectContainers(object, stats, deferredContainerCopies),
    }
    if EBFCopyPasteServer.entryIsWaveSignal(entry) then
        entry.deviceData = nil
    end
    entry.moveableItem = EBFCopyPasteServer.captureMoveablePlacementItemSnapshot(object, spriteName, entry)
    entry.pasteStrategy = EBFCopyPasteServer.selectPasteStrategy(entry)
    return EBFCopyPasteServer.decorateScannerEntry(entry, object)
end

function EBFCopyPasteServer.serializeWorldInventoryObject(square, object, dx, dy, dz, stats)
    local item = EBFCopyPasteServer.getWorldInventoryObjectItem(object)
    local itemSnapshot = makePersistentItemSnapshot(item, 0)
    if not itemSnapshot then
        return nil
    end

    if stats then
        stats.items = (stats.items or 0) + 1
    end

    local entry = {
        dx = dx,
        dy = dy,
        dz = dz,
        index = object.getObjectIndex and object:getObjectIndex() or 0,
        objectClass = "IsoWorldInventoryObject",
        objectName = callMethod(object, "getObjectName"),
        sprite = getObjectSpriteName(object),
        spriteProperties = EBFCopyPasteServer.captureSpritePropertiesSafe(getObjectSpriteName(object)),
        vanillaPlacement = EBFCopyPasteServer.captureVanillaPlacementIdentity(getObjectSpriteName(object)),
        floor = false,
        modData = copyModData(object),
        worldItem = {
            item = itemSnapshot,
            itemId = tonumber(callMethod(item, "getID")),
            offX = EBFCopyPasteServer.getWorldInventoryObjectOffset(object, "x") or 0.5,
            offY = EBFCopyPasteServer.getWorldInventoryObjectOffset(object, "y") or 0.5,
            offZ = EBFCopyPasteServer.getWorldInventoryObjectOffset(object, "z") or 0,
            worldZRotation = tonumber(callMethod(object, "getWorldZRotation")),
            extendedPlacement = callMethod(object, "isExtendedPlacement") == true,
        },
    }
    return EBFCopyPasteServer.decorateScannerEntry(entry, object)
end

local function getSquareChunk(square)
    if not square then
        return nil
    end

    local chunk = callMethod(square, "getChunk")
    if chunk then
        return chunk
    end

    local ok, fieldChunk = pcall(function()
        return square.chunk
    end)
    if ok then
        return fieldChunk
    end
    return nil
end

function EBFCopyPasteServer.squareHasLoadedChunk(square)
    return getSquareChunk(square) ~= nil
end

local function getOrCreateSquare(x, y, z)
    if not getWorld():isValidSquare(x, y, z) then
        return nil
    end

    local cell = getCell()
    local square = cell:getGridSquare(x, y, z)
    if square then
        if EBFCopyPasteServer.squareHasLoadedChunk(square) then
            return square
        end
        return nil
    end

    square = callMethod(cell, "getOrCreateGridSquare", x, y, z)
    if square then
        if EBFCopyPasteServer.squareHasLoadedChunk(square) then
            return square
        end
        return nil
    end
    return nil
end

local function getServerMapInstance()
    if not ServerMap or not ServerMap.instance then
        return nil
    end
    return ServerMap.instance
end

local function getSourceSquare(x, y, z)
    local cell = getCell()
    local square = nil
    if cell then
        local ok, cellSquare = pcall(function()
            return cell:getGridSquare(x, y, z)
        end)
        if ok then
            square = cellSquare
        end
    end
    if square then
        return square
    end

    local serverMap = getServerMapInstance()
    local getGridSquare = getMethod(serverMap, "getGridSquare")
    if not getGridSquare then
        return nil
    end

    local ok, serverSquare = pcall(getGridSquare, serverMap, x, y, z)
    if ok then
        return serverSquare
    end
    return nil
end

local function keepSourceCellsReady(job)
    if job then
        job.sourceReady = true
        job.sourceWaitTicks = 0
        job.sourceLoadedCells = 0
        job.sourceTotalCells = 0
    end
    return true
end

local function buildCopyBlockList(area)
    local blocks = {}
    if not area then
        return blocks
    end

    table.insert(blocks, {
        index = 1,
        x = area.x,
        y = area.y,
        z = area.z,
        sampleZ = area.sampleZ or area.z,
        w = area.w,
        h = area.h,
        offsetX = 0,
        offsetY = 0,
        sourceCells = nil,
        sourceReady = false,
        positionChecked = true,
        zDetected = false,
        tileIndex = 1,
        totalTiles = 0,
    })
    return blocks
end

function EBFCopyPasteServer.getAllowedAbsoluteZRange()
    local minZ = EBFCopyPaste.toInt(EBFCopyPaste.AutoZMin, -2)
    local maxZ = EBFCopyPaste.toInt(EBFCopyPaste.AutoZMax, 10)
    if maxZ < minZ then
        minZ, maxZ = maxZ, minZ
    end
    return minZ, maxZ
end

function EBFCopyPasteServer.areaBaseZIsAllowed(area)
    local minZ, maxZ = EBFCopyPasteServer.getAllowedAbsoluteZRange()
    local z = EBFCopyPaste.toInt(area and area.z, 0)
    return z >= minZ and z <= maxZ, minZ, maxZ
end

function EBFCopyPasteServer.areaDimensionsAreAllowed(area)
    local maxW = EBFCopyPaste.toInt(EBFCopyPaste.MaxSelectionWidth, 100)
    local maxH = EBFCopyPaste.toInt(EBFCopyPaste.MaxSelectionHeight, 100)
    return (tonumber(area and area.w) or 0) <= maxW and (tonumber(area and area.h) or 0) <= maxH, maxW, maxH
end

function EBFCopyPasteServer.clampCopyZOffsetsToAllowedRange(area, levels)
    local minZ, maxZ = EBFCopyPasteServer.getAllowedAbsoluteZRange()
    local offsets = EBFCopyPaste.normalizeZOffsets(area and area.zOffsets or nil, levels)
    local clamped = {}
    local baseZ = EBFCopyPaste.toInt(area and area.z, 0)
    for _, dz in ipairs(offsets) do
        local absoluteZ = baseZ + dz
        if absoluteZ >= minZ and absoluteZ <= maxZ then
            table.insert(clamped, dz)
        end
    end
    if #clamped == 0 then
        return {}
    end
    return EBFCopyPaste.normalizeZOffsets(clamped, #clamped)
end

local function setCopyJobSourceCells(job, block)
    if not job or not block then
        return
    end

    block.sourceCells = {}
    block.sourceReady = true
    job.sourceCells = block.sourceCells
    job.sourceReady = true
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
end

local function newClipboard(area, levels, title)
    local zOffsets = EBFCopyPaste.normalizeZOffsets(area and area.zOffsets or nil, levels)
    return EBFCopyPasteServer.stampCurrentClipboardSchema({
        title = title or "Zona Copy",
        x = area.x,
        y = area.y,
        z = area.z,
        w = area.w,
        h = area.h,
        levels = #zOffsets,
        zOffsets = zOffsets,
        tiles = {},
        objects = {},
        roomBlueprints = {},
        roomBlueprintOrder = {},
        lightBindings = {},
        lightBindingOrder = {},
        count = 0,
        nextScanOrder = 1,
        pendingContainerCopies = {},
        pendingContainerCopyHead = 1,
        stats = {
            tiles = 0,
            objects = 0,
            containers = 0,
            items = 0,
            lights = 0,
            poweredTiles = 0,
            missingTiles = 0,
            failures = 0,
            families = {},
            subtypes = {},
            categories = {},
            strategies = {},
            warnings = {},
            deviceObjects = 0,
            waterObjects = 0,
            lightObjects = 0,
            lightBindings = 0,
            roomBlueprints = 0,
            worldItems = 0,
            containerObjects = 0,
            structuralObjects = 0,
            warningObjects = 0,
            warningIssueCount = 0,
        },
    })
end

local function getTileOffsets(area, levels, tileIndex)
    local zOffsets = area and area.zOffsets
    if type(zOffsets) ~= "table" or #zOffsets == 0 then
        zOffsets = EBFCopyPaste.normalizeZOffsets(nil, levels)
    end
    local perLevel = math.max(1, area.w * area.h)
    local zeroIndex = math.max(0, tileIndex - 1)
    local dz = math.floor(zeroIndex / perLevel)
    if dz >= #zOffsets then
        dz = #zOffsets - 1
    end

    local remainder = zeroIndex - (dz * perLevel)
    local dx = math.floor(remainder / area.h)
    local dy = remainder - (dx * area.h)
    return dx, dy, zOffsets[dz + 1] or 0
end

local function getSquareForTile(area, levels, tileIndex)
    local dx, dy, dz = getTileOffsets(area, levels, tileIndex)
    local square = getSourceSquare(area.x + dx, area.y + dy, area.z + dz)
    return square, dx, dy, dz
end

local function objectHasContainers(object)
    if not object then
        return false
    end

    local count = callMethod(object, "getContainerCount")
    if type(count) == "number" and count > 0 then
        return true
    end

    return callMethod(object, "getContainer") ~= nil
end

local function squareHasCopyablePower(square)
    if not square then
        return false
    end

    if callMethod(square, "haveElectricity") == true then
        return true
    end

    if callMethod(square, "hasGridPower") == true and callMethod(square, "getRoom") ~= nil then
        return true
    end
    return false
end

function EBFCopyPasteServer.squareHasDevicePower(square)
    if not square then
        return false
    end

    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end

    if callMethod(square, "haveElectricity") == true then
        return true
    end
    if callMethod(square, "hasGridPower") == true then
        return true
    end

    local cell = getCell and getCell() or nil
    if not cell then
        return false
    end

    local baseX = square:getX()
    local baseY = square:getY()
    local z = square:getZ()
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local neighbor = cell:getGridSquare(baseX + dx, baseY + dy, z)
                if neighbor and callMethod(neighbor, "haveElectricity") == true then
                    return true
                end
                if neighbor and callMethod(neighbor, "hasGridPower") == true then
                    return true
                end
            end
        end
    end
    return false
end

function EBFCopyPasteServer.squareHasVanillaLightSwitchPower(square, object)
    if not square then
        return false
    end

    local objectIndex = object and callMethod(object, "getObjectIndex") or nil
    if object and objectIndex == -1 then
        return false
    end

    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end

    if callMethod(square, "haveElectricity") == true then
        return true
    end

    local gridPower = callMethod(square, "hasGridPower") == true
    local streetLight = object and EBFCopyPasteServer.safeField(object, "streetLight") == true
    local function squareLooksLikeBuilding(candidate)
        if not candidate then
            return false
        end
        if callMethod(candidate, "getRoom") ~= nil then
            return true
        end
        if callMethod(candidate, "getBuilding") ~= nil then
            return true
        end
        if callMethod(candidate, "getBuildingDef") ~= nil then
            return true
        end
        return false
    end

    if gridPower and (streetLight or squareLooksLikeBuilding(square)) then
        return true
    end

    local cell = getCell and getCell() or nil
    if not cell then
        return false
    end

    local baseX = square:getX()
    local baseY = square:getY()
    local baseZ = square:getZ()
    for dz = 0, -1, -1 do
        if baseZ + dz >= -32 then
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if dx ~= 0 or dy ~= 0 or dz ~= 0 then
                        local neighbor = cell:getGridSquare(baseX + dx, baseY + dy, baseZ + dz)
                        if neighbor then
                            if callMethod(neighbor, "haveElectricity") == true then
                                return true
                            end
                            if gridPower and callMethod(neighbor, "hasGridPower") == true
                                    and (streetLight or squareLooksLikeBuilding(neighbor)) then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

function EBFCopyPasteServer.captureTileSnapshot(square, absoluteX, absoluteY, absoluteZ, copyDx, copyDy, dz)
    local tile = {
        x = absoluteX,
        y = absoluteY,
        z = absoluteZ,
        dx = copyDx,
        dy = copyDy,
        dz = dz,
        objects = {},
        worldObjects = {},
    }

    if not square then
        tile.missing = true
        return tile
    end

    tile.roomIDString = callMethod(square, "getRoomIDString")
    if tile.roomIDString ~= nil then
        tile.roomIDString = tostring(tile.roomIDString)
    end
    tile.haveElectricity = callMethod(square, "haveElectricity") == true
    tile.hasGridPower = callMethod(square, "hasGridPower") == true
    tile.powered = squareHasCopyablePower(square)

    local room = callMethod(square, "getRoom")
    if room then
        tile.hasRoom = true
        tile.roomName = callMethod(room, "getName")
        local roomDef = callMethod(room, "getRoomDef")
        if roomDef then
            tile.roomDefIDString = EBFCopyPasteServer.getRoomDefIdString(roomDef)
            if tile.roomDefIDString then
                tile.roomIDString = tile.roomDefIDString
            end
            tile.roomDefName = callMethod(roomDef, "getName")
            tile.roomDefIsEmptyOutside = callMethod(roomDef, "isEmptyOutside") == true
            tile.roomDefLightsActive = EBFCopyPasteServer.safeField(roomDef, "lightsActive") == true
        end
    end

    local zone = callMethod(square, "getZone")
    if zone then
        tile.zoneType = callMethod(zone, "getType")
        tile.zoneName = callMethod(zone, "getName")
    end

    local objects = square.getObjects and square:getObjects() or nil
    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
    tile.objectCount = objects and objects:size() or 0
    tile.worldObjectCount = worldObjects and worldObjects:size() or 0
    return tile
end

local function squareHasCopyableSprites(square)
    local worldObjects = square and square.getWorldObjects and square:getWorldObjects() or nil
    if worldObjects and worldObjects:size() > 0 then
        return true
    end

    local objects = square and square:getObjects() or nil
    if not objects then
        return false
    end

    for i = 0, objects:size() - 1 do
        if getObjectSpriteName(objects:get(i)) ~= "underground_01_0" then
            return true
        end
    end
    return false
end

local AUTOZ_BORDER_EMPTY_STOP = 2

local function areaZHasCopyableSpritesFull(area, z)
    for dx = 0, area.w - 1 do
        for dy = 0, area.h - 1 do
            if squareHasCopyableSprites(getSourceSquare(area.x + dx, area.y + dy, z)) then
                return true
            end
        end
    end
    return false
end

local function areaZHasCopyableSpritesBorder(area, z)
    local maxDx = math.max(0, (tonumber(area.w) or 1) - 1)
    local maxDy = math.max(0, (tonumber(area.h) or 1) - 1)

    for dy = 0, maxDy do
        if squareHasCopyableSprites(getSourceSquare(area.x, area.y + dy, z)) then
            return true
        end
        if maxDx > 0 and squareHasCopyableSprites(getSourceSquare(area.x + maxDx, area.y + dy, z)) then
            return true
        end
    end

    for dx = 1, maxDx - 1 do
        if squareHasCopyableSprites(getSourceSquare(area.x + dx, area.y, z)) then
            return true
        end
        if maxDy > 0 and squareHasCopyableSprites(getSourceSquare(area.x + dx, area.y + maxDy, z)) then
            return true
        end
    end

    return false
end

local function scanAutoZDirection(area, startZ, step, minZ, maxZ, rememberZ)
    local z = startZ
    local fullScan = true
    local borderEmptyCount = 0

    while z >= minZ and z <= maxZ do
        if fullScan then
            if areaZHasCopyableSpritesFull(area, z) then
                rememberZ(z)
                borderEmptyCount = 0
            else
                fullScan = false
                borderEmptyCount = 0
            end
        elseif areaZHasCopyableSpritesBorder(area, z) then
            if areaZHasCopyableSpritesFull(area, z) then
                rememberZ(z)
            end
            fullScan = true
            borderEmptyCount = 0
        else
            borderEmptyCount = borderEmptyCount + 1
            if borderEmptyCount >= AUTOZ_BORDER_EMPTY_STOP then
                break
            end
        end
        z = z + step
    end
end

local function detectAreaZOffsets(area, emptyReturnsNil)
    if not area then
        if emptyReturnsNil then
            return nil
        end
        return EBFCopyPaste.normalizeZOffsets(nil, EBFCopyPaste.DefaultZLevels)
    end

    local minZ = EBFCopyPaste.toInt(EBFCopyPaste.AutoZMin, -2)
    local maxZ = EBFCopyPaste.toInt(EBFCopyPaste.AutoZMax, 10)
    if maxZ < minZ then
        minZ, maxZ = maxZ, minZ
    end

    local foundMinZ = nil
    local foundMaxZ = nil
    local function rememberZ(z)
        foundMinZ = foundMinZ and math.min(foundMinZ, z) or z
        foundMaxZ = foundMaxZ and math.max(foundMaxZ, z) or z
    end

    local baseZ = EBFCopyPaste.toInt(area.z, 0)
    baseZ = math.max(minZ, math.min(maxZ, baseZ))
    if areaZHasCopyableSpritesFull(area, baseZ) then
        rememberZ(baseZ)
    end
    scanAutoZDirection(area, baseZ - 1, -1, minZ, maxZ, rememberZ)
    scanAutoZDirection(area, baseZ + 1, 1, minZ, maxZ, rememberZ)

    if foundMinZ == nil then
        if emptyReturnsNil then
            return nil
        end
        return EBFCopyPaste.normalizeZOffsets(nil, EBFCopyPaste.DefaultZLevels)
    end

    local offsets = {}
    local anchorZ = EBFCopyPaste.toInt(area.z, 0)
    for z = foundMinZ, foundMaxZ do
        table.insert(offsets, z - anchorZ)
        if #offsets >= EBFCopyPaste.MaxZLevels then
            break
        end
    end
    return EBFCopyPaste.normalizeZOffsets(offsets, #offsets)
end

local function mergeClipboardZOffsets(clipboard, zOffsets)
    if not clipboard or type(zOffsets) ~= "table" or #zOffsets == 0 then
        return
    end

    local merged = {}
    local seen = {}
    for _, value in ipairs(clipboard.zOffsets or {}) do
        local offset = EBFCopyPaste.toInt(value, nil)
        if offset ~= nil and not seen[offset] then
            seen[offset] = true
            table.insert(merged, offset)
        end
    end
    for _, value in ipairs(zOffsets) do
        local offset = EBFCopyPaste.toInt(value, nil)
        if offset ~= nil and not seen[offset] then
            seen[offset] = true
            table.insert(merged, offset)
        end
    end

    table.sort(merged)
    while #merged > EBFCopyPaste.MaxZLevels do
        table.remove(merged)
    end
    clipboard.zOffsets = merged
    clipboard.levels = #merged
    if clipboard.safehouse then
        clipboard.safehouse.zOffsets = merged
        clipboard.safehouse.levels = #merged
    end
end

local function makeBlockScanArea(job, block, zOffsets)
    return {
        x = block.x,
        y = block.y,
        z = job.area.z,
        w = block.w,
        h = block.h,
        zOffsets = zOffsets,
        clipboardDx = block.offsetX or 0,
        clipboardDy = block.offsetY or 0,
    }
end

local function entryIsHeavy(entry)
    return entry and (entry.containers ~= nil or entry.worldItem ~= nil)
end

local function getBudgetValue(value, fallback, minimum)
    local number = tonumber(value)
    if number == nil then
        number = fallback
    end
    number = math.floor(tonumber(number) or 0)
    return math.max(minimum or 0, number)
end

local function reachedSimpleWorkBudget(startMs, timeBudgetMs, processed, minimum, maximum)
    if processed >= maximum then
        return true
    end
    if timeBudgetMs <= 0 then
        return processed >= minimum
    end
    if processed < minimum then
        return false
    end
    return nowMs() - startMs >= timeBudgetMs
end

local function sortClipboardObjects(data)
    table.sort(data.objects, function(a, b)
        if a.dz ~= b.dz then return a.dz < b.dz end
        if a.dy ~= b.dy then return a.dy < b.dy end
        if a.dx ~= b.dx then return a.dx < b.dx end
        if a.floor ~= b.floor then return a.floor == true end
        if (a.index or 0) ~= (b.index or 0) then return (a.index or 0) < (b.index or 0) end
        return (a.scanOrder or 0) < (b.scanOrder or 0)
    end)
end

function EBFCopyPasteServer.getEntryObjectLayer(entry)
    if not entry then
        return "unknown"
    end
    local classification = entry.classification or {}
    local family = classification.family or "object"
    local subtype = classification.subtype or "generic"
    if entry.floor == true then return "floor" end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then return "worldItem" end
    if family == "structure" then return subtype == "floor" and "floor" or "structure" end
    if family == "container" then return "supportContainer" end
    if family == "plumbing" then return "plumbing" end
    if family == "water" then return "waterDispenser" end
    if family == "device" then return subtype == "television" and "television" or "radio" end
    if family == "lighting" then return subtype == "residentialSwitch" and "residentialLightSwitch" or "moveableLight" end
    if family == "appliance" then return subtype == "microwave" and "microwave" or "primaryAppliance" end
    return family
end

function EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry)
    if not entry then
        return false
    end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return true
    end
    local factory = entry.factory or {}
    if factory.isTableTop == true or factory.isTable == true then
        return true
    end
    local props = entry.spriteProperties or {}
    if props.IsTableTop ~= nil or props.IsSurfaceOffset ~= nil or props.Surface ~= nil then
        return true
    end
    return EBFCopyPasteServer.entryIsTelevision(entry)
            or EBFCopyPasteServer.entryIsMicrowave(entry)
            or EBFCopyPasteServer.entryIsMoveableLamp(entry)
            or EBFCopyPasteServer.entryIsPlumbingFixture(entry)
end

function EBFCopyPasteServer.buildEntryDependencyHints(entry)
    local hints = {}
    if not entry then
        return hints
    end

    local layer = EBFCopyPasteServer.getEntryObjectLayer(entry)
    if layer ~= "floor" then
        table.insert(hints, "floorBeforePaste")
    end
    if EBFCopyPasteServer.entryIsStructural(entry) and not entry.floor then
        table.insert(hints, "structureBeforeObjects")
    end
    if EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry) then
        table.insert(hints, "supportSurfaceBeforePaste")
    end
    if EBFCopyPasteServer.entryHasContainers(entry) then
        table.insert(hints, "containerItemsAfterObject")
    end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        table.insert(hints, "worldItemAfterSupport")
    end
    if EBFCopyPasteServer.entryIsPlumbingFixture(entry) then
        table.insert(hints, "waterStateAfterObject")
    end
    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        table.insert(hints, "fluidStateAfterObject")
    end
    if EBFCopyPasteServer.entryIsWaveSignal(entry) or entry.deviceData ~= nil then
        table.insert(hints, "deviceDataAfterSquare")
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        table.insert(hints, "lightFinalizeAfterStructure")
    end
    if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
        table.insert(hints, "roomDefLightBinding")
    end
    return hints
end

function EBFCopyPasteServer.findSurfaceOwnerSnapshot(tileSnapshot, entry)
    if not tileSnapshot or not EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry) then
        return nil
    end

    local objects = tileSnapshot.objects or {}
    for i = #objects, 1, -1 do
        local candidate = objects[i]
        if candidate
                and candidate ~= entry
                and candidate.dx == entry.dx
                and candidate.dy == entry.dy
                and candidate.dz == entry.dz
                and not (candidate.objectClass == "IsoWorldInventoryObject" or candidate.worldItem ~= nil)
                and not EBFCopyPasteServer.entryIsTelevision(candidate)
                and not EBFCopyPasteServer.entryIsRadio(candidate)
                and not EBFCopyPasteServer.entryIsLighting(candidate) then
            local candidateLayer = candidate.objectLayer or EBFCopyPasteServer.getEntryObjectLayer(candidate)
            if candidateLayer == "supportContainer"
                    or candidateLayer == "primaryAppliance"
                    or candidateLayer == "structure"
                    or candidateLayer == "object" then
                return {
                    scanOrder = candidate.scanOrder,
                    tileOrder = candidate.tileOrder,
                    index = candidate.index,
                    sprite = candidate.sprite,
                    objectClass = candidate.objectClass,
                    layer = candidateLayer,
                }
            end
        end
    end
    return nil
end

function EBFCopyPasteServer.annotateScannedEntry(data, tileSnapshot, entry, sourceKind, parentEntry)
    if not entry then
        return nil
    end

    local scanOrder = tonumber(data.nextScanOrder) or 1
    data.nextScanOrder = scanOrder + 1
    tileSnapshot.objectOrderCount = (tileSnapshot.objectOrderCount or 0) + 1

    entry.scanOrder = scanOrder
    entry.tileOrder = tileSnapshot.objectOrderCount
    entry.sourceKind = sourceKind
    entry.objectLayer = EBFCopyPasteServer.getEntryObjectLayer(entry)
    entry.needsSupportBeforePaste = EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry)
    entry.dependencyHints = EBFCopyPasteServer.buildEntryDependencyHints(entry)
    entry.surfaceOwner = EBFCopyPasteServer.findSurfaceOwnerSnapshot(tileSnapshot, entry)
    entry.sourceRoomKey = EBFCopyPasteServer.makeClipboardRoomKey(tileSnapshot)
    if entry.sourceRoomKey then
        entry.sourceRoom = {
            key = entry.sourceRoomKey,
            dx = tileSnapshot.dx,
            dy = tileSnapshot.dy,
            dz = tileSnapshot.dz,
            name = tileSnapshot.roomDefName or tileSnapshot.roomName,
            roomIDString = tileSnapshot.roomIDString,
            roomDefIDString = tileSnapshot.roomDefIDString,
            roomDefName = tileSnapshot.roomDefName,
            lightsActive = tileSnapshot.roomDefLightsActive == true,
        }
    end
    if parentEntry then
        entry.attachedTo = {
            scanOrder = parentEntry.scanOrder,
            tileOrder = parentEntry.tileOrder,
            index = parentEntry.index,
            sprite = parentEntry.sprite,
            objectClass = parentEntry.objectClass,
        }
    end

    if entry.identity then
        entry.identity.scanOrder = entry.scanOrder
        entry.identity.tileOrder = entry.tileOrder
        entry.identity.objectLayer = entry.objectLayer
        entry.identity.dependencyHints = entry.dependencyHints
        entry.identity.surfaceOwner = entry.surfaceOwner
        entry.identity.attachedTo = entry.attachedTo
        entry.identity.sourceRoom = entry.sourceRoom
    end
    if entry.fingerprint then
        entry.fingerprint.scanOrder = entry.scanOrder
        entry.fingerprint.tileOrder = entry.tileOrder
        entry.fingerprint.objectLayer = entry.objectLayer
        entry.fingerprint.needsSupportBeforePaste = entry.needsSupportBeforePaste
        entry.fingerprint.sourceRoomKey = entry.sourceRoomKey
    end
    if entry.classification then
        entry.classification.objectLayer = entry.objectLayer
        entry.classification.dependencyHints = entry.dependencyHints
        entry.classification.sourceRoomKey = entry.sourceRoomKey
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        EBFCopyPasteServer.captureLightBinding(data, tileSnapshot, entry)
    end
    EBFCopyPasteServer.refreshEntryScanValidation(entry)

    return entry
end

local function collectTile(data, area, tileIndex)
    local square, dx, dy, dz = getSquareForTile(area, data.levels, tileIndex)
    local heavy = false
    local copyDx = dx + (area.clipboardDx or 0)
    local copyDy = dy + (area.clipboardDy or 0)
    data.tiles = data.tiles or {}
    local tileSnapshot = EBFCopyPasteServer.captureTileSnapshot(square, area.x + dx, area.y + dy, area.z + dz, copyDx, copyDy, dz)
    EBFCopyPasteServer.captureClipboardRoomBlueprint(data, tileSnapshot, square)
    table.insert(data.tiles, tileSnapshot)
    data.stats.tiles = (data.stats.tiles or 0) + 1

    if not square then
        data.stats.missingTiles = (data.stats.missingTiles or 0) + 1
        return false
    end

    if squareHasCopyablePower(square) then
        data.powered = true
        data.stats.poweredTiles = (data.stats.poweredTiles or 0) + 1
    end

    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
    if worldObjects and worldObjects:size() > 0 then
        heavy = true
        for i = 0, worldObjects:size() - 1 do
            local ok, entry = pcall(EBFCopyPasteServer.serializeWorldInventoryObject, square, worldObjects:get(i), copyDx, copyDy, dz, data.stats)
            if ok and entry then
                EBFCopyPasteServer.annotateScannedEntry(data, tileSnapshot, entry, "worldInventory", nil)
                table.insert(data.objects, entry)
                table.insert(tileSnapshot.worldObjects, entry)
                data.count = data.count + 1
                data.stats.objects = (data.stats.objects or 0) + 1
                EBFCopyPasteServer.recordScannerAudit(data.stats, tileSnapshot, entry)
            elseif not ok then
                tileSnapshot.failures = (tileSnapshot.failures or 0) + 1
                data.stats.failures = (data.stats.failures or 0) + 1
                local sourceObject = worldObjects:get(i)
                print("[EBF-DIAG-COPY] status=serializeWorldInventoryError"
                        .. " source=" .. tostring(area.x + dx) .. "," .. tostring(area.y + dy) .. "," .. tostring(area.z + dz)
                        .. " rel=" .. tostring(copyDx) .. "," .. tostring(copyDy) .. "," .. tostring(dz)
                        .. " index=" .. tostring(i)
                        .. " sprite=" .. tostring(getObjectSpriteName(sourceObject))
                        .. " class=" .. tostring(getObjectClass(sourceObject))
                        .. " error=" .. tostring(entry))
            end
        end
    end

    local objects = square:getObjects()
    if not objects then
        return heavy
    end

    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if getObjectSpriteName(object) == "underground_01_0" then
            -- Generated by the engine for negative Z squares; it is not real player-built content.
        elseif EBFCopyPasteServer.isWorldInventoryObject(object) then
            -- World inventory objects are copied from square:getWorldObjects() to preserve item state and offsets.
        else
        if objectHasContainers(object) then
            heavy = true
        end
        local ok, entry = pcall(serializeObject, square, object, copyDx, copyDy, dz, data.stats, data.pendingContainerCopies)
        if ok and entry then
            EBFCopyPasteServer.annotateScannedEntry(data, tileSnapshot, entry, "squareObject", nil)
            table.insert(data.objects, entry)
            table.insert(tileSnapshot.objects, entry)
            data.count = data.count + 1
            data.stats.objects = (data.stats.objects or 0) + 1
            if entry.objectClass == "IsoLightSwitch" then
                data.stats.lights = (data.stats.lights or 0) + 1
            end
            EBFCopyPasteServer.recordScannerAudit(data.stats, tileSnapshot, entry)
            local attachedLights = copyAttachedLightEntries(square, object, copyDx, copyDy, dz, data.stats)
            if attachedLights then
                for _, lightEntry in ipairs(attachedLights) do
                    EBFCopyPasteServer.annotateScannedEntry(data, tileSnapshot, lightEntry, "attachedLight", entry)
                    table.insert(data.objects, lightEntry)
                    table.insert(tileSnapshot.objects, lightEntry)
                    data.count = data.count + 1
                    data.stats.objects = (data.stats.objects or 0) + 1
                    EBFCopyPasteServer.recordScannerAudit(data.stats, tileSnapshot, lightEntry)
                end
            end
        elseif not ok then
            tileSnapshot.failures = (tileSnapshot.failures or 0) + 1
            data.stats.failures = (data.stats.failures or 0) + 1
            print("[EBF-DIAG-COPY] status=serializeObjectError"
                    .. " source=" .. tostring(area.x + dx) .. "," .. tostring(area.y + dy) .. "," .. tostring(area.z + dz)
                    .. " rel=" .. tostring(copyDx) .. "," .. tostring(copyDy) .. "," .. tostring(dz)
                    .. " index=" .. tostring(i)
                    .. " sprite=" .. tostring(getObjectSpriteName(object))
                    .. " class=" .. tostring(getObjectClass(object))
                    .. " error=" .. tostring(entry))
        end
        end
    end
    return heavy
end

local function hasPendingContainerCopies(clipboard)
    if not clipboard or type(clipboard.pendingContainerCopies) ~= "table" then
        return false
    end
    local head = tonumber(clipboard.pendingContainerCopyHead) or 1
    return head <= #clipboard.pendingContainerCopies
end

local function processPendingContainerCopies(clipboard)
    if not hasPendingContainerCopies(clipboard) then
        return false
    end

    local budget = getBudgetValue(EBFCopyPaste.CopyContainerItemsPerTick, 80, 1)
    local queue = clipboard.pendingContainerCopies
    local head = tonumber(clipboard.pendingContainerCopyHead) or 1
    while budget > 0 and head <= #queue do
        local task = queue[head]
        local items = task and callMethod(task.container, "getItems") or nil
        local size = items and items:size() or 0
        if task and (task.itemIndex or 0) < size then
            local item = items:get(task.itemIndex or 0)
            local itemSnapshot = makePersistentItemSnapshot and makePersistentItemSnapshot(item, 0) or nil
            if itemSnapshot then
                if task.stats then
                    task.stats.items = (task.stats.items or 0) + 1
                end
                table.insert(task.snapshot.items, itemSnapshot)
            else
                local cloned = cloneItemObject(item, 0, task.stats)
                if cloned then
                    table.insert(task.snapshot.items, cloned)
                end
            end
            task.itemIndex = (task.itemIndex or 0) + 1
            budget = budget - 1
        else
            head = head + 1
            clipboard.pendingContainerCopyHead = head
        end
    end

    return head <= #queue
end

local function shouldSendProgress(job, force)
    if force then
        job.lastFeedback = nowMs()
        return true
    end

    local now = nowMs()
    if now - (job.lastFeedback or 0) >= EBFCopyPaste.ProgressIntervalMs then
        job.lastFeedback = now
        return true
    end
    return false
end

local function sendCopyProgress(job, force)
    if not shouldSendProgress(job, force) then
        return
    end

    local stats = job.clipboard.stats or {}
    local block = job.blocks and job.blocks[job.blockIndex] or nil
    local processed = math.max(0, job.tileIndex - 1)
    if job.blocks then
        processed = math.max(0, job.processedTiles or 0)
        if block then
            processed = processed + math.max(0, (block.tileIndex or 1) - 1)
        end
    end
    sendFeedback(job.playerObj, {
        action = "copyProgress",
        ok = true,
        mode = job.saveName and "save" or "copy",
        title = job.clipboard.title,
        processed = processed,
        total = job.totalTiles,
        count = job.clipboard.count,
        blockIndex = block and block.index or job.blockIndex,
        blockTotal = job.blocks and #job.blocks or nil,
        containers = stats.containers or 0,
        items = stats.items or 0,
        lights = stats.lights or 0,
        poweredTiles = stats.poweredTiles or 0,
        missingTiles = stats.missingTiles or 0,
        failures = stats.failures or 0,
        loadingSource = not job.sourceReady,
        sourceLoadedCells = job.sourceLoadedCells or 0,
        sourceTotalCells = job.sourceTotalCells or 0,
    })
end

local function sendPasteProgress(job, force)
    if not shouldSendProgress(job, force) then
        return
    end

    local processed = math.max(0, job.tileIndex - 1)
    local total = job.totalTiles
    local block = nil
    local mode = nil
    if job.phase == "clear" or job.phase == "paste" then
        mode = "blockPaste"
        total = math.max(1, (tonumber(job.totalTiles) or 0) + #(job.clipboard.objects or {}))
        if job.phase == "paste" then
            block = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
            processed = math.max(0, job.processedClearTiles or 0) + math.max(0, job.processedPasteObjects or 0)
            if block then
                processed = processed + math.max(0, (block.objectIndex or 1) - 1)
            end
        else
            block = job.clearBlocks and job.clearBlocks[job.clearBlockIndex] or nil
            processed = math.max(0, job.processedClearTiles or 0) + math.max(0, job.processedPasteObjects or 0)
            if block then
                processed = processed + math.max(0, (block.tileIndex or 1) - 1)
            end
        end
    elseif job.phase == "pasteDeferredLights" then
        local group = job.deferredLightGroups and job.deferredLightGroups[job.deferredLightGroupIndex or 1] or nil
        block = group and group.blocks and group.blocks[job.deferredLightBlockIndex or 1]
                or job.deferredLightBlocks and job.deferredLightBlocks[job.deferredLightBlockIndex] or nil
        processed = math.max(0, job.processedDeferredLightObjects or 0)
        if block then
            processed = processed + math.max(0, (block.objectIndex or 1) - 1)
        end
        total = math.max(1, tonumber(job.deferredLightingTotal) or #(job.deferredLightingEntries or {}))
    elseif job.phase == "clientRoomDefReconcile" then
        processed = math.max(0, tonumber(job.clientRoomDefReconcileTicks) or 0)
        total = math.max(1, tonumber(job.clientRoomDefReconcileTotal) or 1)
    elseif job.phase == "finalizeRooms" or job.phase == "finalizeLights" or job.phase == "finalizeSync" then
        processed = math.max(0, (job.finalizeIndex or 1) - 1)
        total = math.max(1, tonumber(job.finalizeTotal) or 1)
    elseif job.phase == "verifyPaste" then
        processed = math.max(0, (job.verifyIndex or 1) - 1)
        total = math.max(1, tonumber(job.verifyTotal) or #(job.clipboard.objects or {}))
    elseif job.phase == "finalClientAck" then
        processed = math.max(0, tonumber(job.finalClientAckTicks) or 0)
        total = math.max(1, tonumber(job.finalClientAckTotal) or 1)
    end

    sendFeedback(job.playerObj, {
        action = job.restoreSafehouse and "safehouseRestoreProgress" or "pasteProgress",
        ok = true,
        phase = job.phase,
        mode = mode,
        prePasteRooms = job.phase == "finalizeRooms" and job.prePasteRoomsDone ~= true,
        processed = processed,
        total = total,
        count = job.pasted or 0,
        id = job.restoreSaveId,
        title = job.restoreName,
        restoreIndex = job.restoreIndex,
        restoreTotal = job.restoreTotal,
        blockIndex = block and block.index or job.clearBlockIndex,
        blockTotal = block and (
                job.phase == "paste"
                    and job.pasteBlocks
                    and #job.pasteBlocks
                or job.phase == "pasteDeferredLights"
                    and block
                    and (group and group.blocks and #group.blocks or job.deferredLightBlocks and #job.deferredLightBlocks)
                or job.clearBlocks
                    and #job.clearBlocks)
                or nil,
        loadingSource = (job.phase == "clear"
                or job.phase == "paste"
                or job.phase == "pasteDeferredLights")
                and not job.sourceReady
                or false,
        sourceLoadedCells = job.sourceLoadedCells or 0,
        sourceTotalCells = job.sourceTotalCells or 0,
    })
end

local saveClipboardToStorage
local buildSavedAreaList
local saveSafehouseClipboardToStorage
local buildSafehouseSaveList

local function failCopyJob(key, job, message)
    EBFCopyPasteServer.logStage(job, nil, "COPIA fallida: " .. tostring(message or "No se ha podido copiar la zona.")
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    EBFCopyPasteServer.copyJobs[key] = nil
    local stats = job and job.clipboard and job.clipboard.stats or {}
    sendFeedback(job and job.playerObj or nil, {
        action = job and job.saveName and "save" or "copy",
        ok = false,
        title = job and job.clipboard and job.clipboard.title or "Zona Copy",
        count = job and job.clipboard and job.clipboard.count or 0,
        tiles = stats.tiles or 0,
        containers = stats.containers or 0,
        items = stats.items or 0,
        lights = stats.lights or 0,
        poweredTiles = stats.poweredTiles or 0,
        missingTiles = stats.missingTiles or 0,
        failures = stats.failures or 0,
        message = message or "No se ha podido copiar la zona.",
    })
end

local function formatScannerCountMap(map, limit)
    if type(map) ~= "table" then
        return ""
    end

    local keys = {}
    for key, _ in pairs(map) do
        table.insert(keys, tostring(key))
    end
    table.sort(keys)

    local parts = {}
    local maxItems = tonumber(limit) or 12
    for index, key in ipairs(keys) do
        if index > maxItems then
            table.insert(parts, "...+" .. tostring(#keys - maxItems))
            break
        end
        table.insert(parts, key .. "=" .. tostring(map[key]))
    end
    return table.concat(parts, ",")
end

local function finishCopyJob(key, job)
    if hasPendingContainerCopies(job.clipboard) then
        sendCopyProgress(job, true)
        return
    end
    job.clipboard.pendingContainerCopies = nil
    job.clipboard.pendingContainerCopyHead = nil
    sortClipboardObjects(job.clipboard)
    EBFCopyPasteServer.stampCurrentClipboardSchema(job.clipboard)
    ensureClipboardZOffsets(job.clipboard)
    EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard, { rebuild = true })
    EBFCopyPasteServer.ensureClipboardLightBindings(job.clipboard)
    if job.clipboard.safehouse then
        job.clipboard.safehouse.levels = job.clipboard.levels
        job.clipboard.safehouse.zOffsets = job.clipboard.zOffsets
    end
    if (job.clipboard.count or 0) <= 0 or not job.clipboard.objects or #job.clipboard.objects <= 0 then
        failCopyJob(key, job, "El origen no ha cargado ningún sprite. No se ha copiado nada para evitar limpiar el destino con una copia vacía.")
        return
    end

    local stats = job.clipboard.stats or {}
    local safehouse = job.clipboard.safehouse or {}
    EBFCopyPasteServer.logStage(job, nil, "COPIA completada: sprites=" .. tostring(job.clipboard.count or 0)
            .. " objetos=" .. tostring(#(job.clipboard.objects or {}))
            .. " tiles=" .. tostring(stats.tiles or 0)
            .. " containers=" .. tostring(stats.containers or 0)
            .. " objetos=" .. tostring(stats.items or 0)
            .. " luces=" .. tostring(stats.lights or 0)
            .. " roomBlueprints=" .. tostring(stats.roomBlueprints or 0)
            .. " lightBindings=" .. tostring(stats.lightBindings or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")

    if EBFCopyPaste.DiagnosticMode == true then
        local countsByZ = {}
        for _, diagnosticEntry in ipairs(job.clipboard.objects or {}) do
            local dz = EBFCopyPaste.toInt(diagnosticEntry and diagnosticEntry.dz, 0)
            countsByZ[dz] = (countsByZ[dz] or 0) + 1
        end
        local zKeys = {}
        for dz in pairs(countsByZ) do table.insert(zKeys, dz) end
        table.sort(zKeys)
        local zParts = {}
        for _, dz in ipairs(zKeys) do
            table.insert(zParts, tostring(dz) .. "=" .. tostring(countsByZ[dz]))
        end
        print("[EBF-DIAG-COPY-SUMMARY] title=" .. tostring(job.clipboard.title)
                .. " base=" .. tostring(job.clipboard.x) .. "," .. tostring(job.clipboard.y) .. "," .. tostring(job.clipboard.z)
                .. " size=" .. tostring(job.clipboard.w) .. "x" .. tostring(job.clipboard.h)
                .. " zOffsets=" .. tostring(table.concat(job.clipboard.zOffsets or {}, ","))
                .. " objectsByDz=" .. tostring(table.concat(zParts, ","))
                .. " objects=" .. tostring(#(job.clipboard.objects or {}))
                .. " failures=" .. tostring(stats.failures or 0)
                .. " missingTiles=" .. tostring(stats.missingTiles or 0))
    end

    if (stats.scanValidatedObjects or 0) > 0 then
        EBFCopyPasteServer.logStage(job, "copy:scanAudit", "SCAN AUDIT: validados=" .. tostring(stats.scanValidatedObjects or 0)
                .. " ok=" .. tostring(stats.scanValidationOkObjects or 0)
                .. " incompletos=" .. tostring(stats.scanValidationMissingObjects or 0)
                .. " criticos=" .. tostring(stats.scanValidationCriticalObjects or 0)
                .. " avisos=" .. tostring(stats.warningIssueCount or stats.warningObjects or 0)
                .. " objetosComAviso=" .. tostring(stats.warningObjects or 0)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        local warningSummary = formatScannerCountMap(stats.warnings, 16)
        if warningSummary ~= "" then
            EBFCopyPasteServer.logStage(job, "copy:scanAudit:warningsResumo",
                    "SCAN AUDIT warningsResumo: " .. warningSummary
                    .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        end
        for index, sample in ipairs(stats.scanWarningExamples or {}) do
            EBFCopyPasteServer.logStage(job, "copy:scanAudit:warning", "SCAN AUDIT warning[" .. tostring(index) .. "]: scan="
                    .. tostring(sample.scanOrder)
                    .. " sprite=" .. tostring(sample.sprite)
                    .. " class=" .. tostring(sample.objectClass)
                    .. " family=" .. tostring(sample.family)
                    .. " subtype=" .. tostring(sample.subtype)
                    .. " worldItem=" .. tostring(sample.worldItemFullType)
                    .. " rel=" .. tostring(sample.dx) .. "," .. tostring(sample.dy) .. "," .. tostring(sample.dz)
                    .. " tileOrder=" .. tostring(sample.tileOrder)
                    .. " index=" .. tostring(sample.index)
                    .. " warnings=" .. table.concat(sample.warnings or {}, ","))
        end
        for index, sample in ipairs(stats.scanValidationExamples or {}) do
            EBFCopyPasteServer.logStage(job, "copy:scanAudit:missing", "SCAN AUDIT missing[" .. tostring(index) .. "]: sprite="
                    .. tostring(sample.sprite)
                    .. " class=" .. tostring(sample.objectClass)
                    .. " family=" .. tostring(sample.family)
                    .. " subtype=" .. tostring(sample.subtype)
                    .. " worldItem=" .. tostring(sample.worldItemFullType)
                    .. " rel=" .. tostring(sample.dx) .. "," .. tostring(sample.dy) .. "," .. tostring(sample.dz)
                    .. " missing=" .. table.concat(sample.missing or {}, ","))
        end
    end

    EBFCopyPasteServer.clipboards[key] = job.clipboard
    EBFCopyPasteServer.copyJobs[key] = nil

    if job.saveName then
        local saved = saveClipboardToStorage(job.playerObj, job.saveName, job.clipboard)
        sendFeedback(job.playerObj, {
            action = "save",
            ok = saved ~= nil,
            id = saved and saved.id or nil,
            title = saved and saved.name or job.saveName,
            x = job.clipboard.x,
            y = job.clipboard.y,
            z = job.clipboard.z,
            w = job.clipboard.w,
            h = job.clipboard.h,
            levels = job.clipboard.levels,
            count = job.clipboard.count,
            tiles = stats.tiles or 0,
            containers = stats.containers or 0,
            items = stats.items or 0,
            lights = stats.lights or 0,
            missingTiles = stats.missingTiles or 0,
            failures = stats.failures or 0,
            source = job.clipboard.source,
            safehouseTitle = safehouse.title,
            safehouseOwner = safehouse.owner,
            saves = buildSavedAreaList(),
            message = saved and nil or "No se ha podido guardar la zona.",
        })
        return
    end

    sendFeedback(job.playerObj, {
        action = "copy",
        ok = true,
        title = job.clipboard.title,
        x = job.clipboard.x,
        y = job.clipboard.y,
        z = job.clipboard.z,
        w = job.clipboard.w,
        h = job.clipboard.h,
        levels = job.clipboard.levels,
        count = job.clipboard.count,
        tiles = stats.tiles or 0,
        containers = stats.containers or 0,
        items = stats.items or 0,
        lights = stats.lights or 0,
        missingTiles = stats.missingTiles or 0,
        failures = stats.failures or 0,
        source = job.clipboard.source,
        safehouseTitle = safehouse.title,
        safehouseOwner = safehouse.owner,
    })
end

local function advanceCopyBlock(job)
    local block = job.blocks and job.blocks[job.blockIndex] or nil
    if block then
        job.processedTiles = (job.processedTiles or 0) + (block.totalTiles or 0)
    end
    job.blockIndex = (job.blockIndex or 1) + 1
    job.tileIndex = 1
    job.sourceCells = nil
    job.sourceReady = false
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
end

local function ensureCurrentCopyBlockReady(key, job)
    local block = job.blocks and job.blocks[job.blockIndex] or nil
    if not block then
        return true
    end

    if not block.positionChecked then
        block.positionChecked = true
        EBFCopyPasteServer.logStage(job, "copy:block:" .. tostring(block.index or job.blockIndex), "SCAN bloco "
                .. tostring(block.index or job.blockIndex) .. "/" .. tostring(job.blocks and #job.blocks or 1)
                .. " origen=" .. tostring(block.x) .. "," .. tostring(block.y)
                .. " tamanho=" .. tostring(block.w) .. "x" .. tostring(block.h)
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        setCopyJobSourceCells(job, block)
    end

    if not block.sourceReady then
        if not block.sourceCells or job.sourceCells ~= block.sourceCells then
            setCopyJobSourceCells(job, block)
        end
        if not keepSourceCellsReady(job) then
            sendCopyProgress(job, false)
            return false
        end
        block.sourceReady = true
    end

    if not block.zDetected then
        local zOffsets = nil
        if job.autoZ then
            zOffsets = detectAreaZOffsets(block, true)
        else
            zOffsets = job.clipboard.zOffsets
        end

        if type(zOffsets) ~= "table" or #zOffsets == 0 then
            block.zDetected = true
            block.totalTiles = 0
            advanceCopyBlock(job)
            sendCopyProgress(job, true)
            return false
        end

        block.zOffsets = EBFCopyPaste.normalizeZOffsets(zOffsets, #zOffsets)
        block.levels = #block.zOffsets
        block.scanArea = makeBlockScanArea(job, block, block.zOffsets)
        block.totalTiles = block.w * block.h * block.levels
        block.tileIndex = 1
        block.zDetected = true
        mergeClipboardZOffsets(job.clipboard, block.zOffsets)
        EBFCopyPasteServer.logStage(job, "copy:blockZ:" .. tostring(block.index or job.blockIndex), "SCAN AutoZ bloco "
                .. tostring(block.index or job.blockIndex) .. ": zOffsets="
                .. tostring(table.concat(block.zOffsets or {}, ","))
                .. " tiles=" .. tostring(block.totalTiles or 0)
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        sendCopyProgress(job, true)
    end

    return true
end

local function processCopyJob(key, job)
    if not job.blocks then
        job.blocks = buildCopyBlockList(job.area)
        job.blockIndex = 1
        job.processedTiles = 0
    end

    if (job.blockIndex or 1) > #job.blocks then
        finishCopyJob(key, job)
        return
    end

    local ready, finished = ensureCurrentCopyBlockReady(key, job)
    if finished then
        return
    end
    if not ready then
        if (job.blockIndex or 1) > #job.blocks then
            finishCopyJob(key, job)
        end
        return
    end

    if processPendingContainerCopies(job.clipboard) then
        sendCopyProgress(job, false)
        return
    end

    local block = job.blocks[job.blockIndex]
    if not block or not block.scanArea or (block.totalTiles or 0) <= 0 then
        advanceCopyBlock(job)
        sendCopyProgress(job, true)
        return
    end

    local simpleBudget = getBudgetValue(EBFCopyPaste.CopySimpleTilesPerTick, 24, 1)
    local simpleMaxBudget = getBudgetValue(EBFCopyPaste.CopyMaxSimpleTilesPerTick, simpleBudget * 5, simpleBudget)
    local simpleTimeBudgetMs = getBudgetValue(EBFCopyPaste.CopyTimeBudgetMs, 4, 0)
    local simpleProcessed = 0
    local tickStartMs = nowMs()
    local heavyBudget = getBudgetValue(EBFCopyPaste.CopyHeavyTilesPerTick, 1, 1)
    while block.tileIndex <= block.totalTiles do
        local wasHeavy = collectTile(job.clipboard, block.scanArea, block.tileIndex)
        block.tileIndex = block.tileIndex + 1
        job.tileIndex = block.tileIndex
        if processPendingContainerCopies(job.clipboard) then
            break
        end
        if wasHeavy then
            heavyBudget = heavyBudget - 1
            if heavyBudget <= 0 then
                break
            end
        else
            simpleProcessed = simpleProcessed + 1
            if reachedSimpleWorkBudget(tickStartMs, simpleTimeBudgetMs, simpleProcessed, simpleBudget, simpleMaxBudget) then
                break
            end
        end
    end

    if hasPendingContainerCopies(job.clipboard) then
        sendCopyProgress(job, false)
        return
    end

    if block.tileIndex > block.totalTiles then
        advanceCopyBlock(job)
        if (job.blockIndex or 1) > #job.blocks then
            finishCopyJob(key, job)
            return
        end
    end

    sendCopyProgress(job, false)
end

local copyStringList

local function getSavedAreaStorage()
    if not ModData or not ModData.getOrCreate then
        EBFCopyPasteServer.savedAreas = EBFCopyPasteServer.savedAreas or { saves = {}, nextId = 1 }
        return EBFCopyPasteServer.savedAreas
    end

    local data = ModData.getOrCreate(EBFCopyPaste.SavedAreasModDataKey)
    data.saves = data.saves or {}
    data.nextId = tonumber(data.nextId) or 1
    return data
end

local function getSafehouseSaveStorage()
    if not ModData or not ModData.getOrCreate then
        EBFCopyPasteServer.safehouseSaves = EBFCopyPasteServer.safehouseSaves or { saves = {}, nextId = 1 }
        return EBFCopyPasteServer.safehouseSaves
    end

    local data = ModData.getOrCreate(EBFCopyPaste.SafehouseSavesModDataKey)
    data.saves = data.saves or {}
    data.nextId = tonumber(data.nextId) or 1
    return data
end

local function transmitSavedAreas()
    if ModData and ModData.transmit then
        ModData.transmit(EBFCopyPaste.SavedAreasModDataKey)
    end
end

local function transmitSafehouseSaves()
    if ModData and ModData.transmit then
        ModData.transmit(EBFCopyPaste.SafehouseSavesModDataKey)
    end
end

local function getSavedAreaById(saveId)
    local storage = getSavedAreaStorage()
    saveId = tostring(saveId or "")
    if saveId == "" then
        return nil
    end
    return storage.saves and storage.saves[saveId] or nil
end

local function getSafehouseSaveById(saveId)
    local storage = getSafehouseSaveStorage()
    saveId = tostring(saveId or "")
    if saveId == "" then
        return nil
    end
    return storage.saves and storage.saves[saveId] or nil
end

buildSavedAreaList = function()
    local storage = getSavedAreaStorage()
    local list = {}
    for saveId, save in pairs(storage.saves or {}) do
        if save and save.clipboard and EBFCopyPasteServer.isCurrentClipboardSchema(save.clipboard) then
            table.insert(list, {
                id = tostring(save.id or saveId),
                name = tostring(save.name or save.clipboard.title or "Zona Copy"),
                w = tonumber(save.clipboard.w) or 1,
                h = tonumber(save.clipboard.h) or 1,
                levels = tonumber(save.clipboard.levels) or 1,
                count = tonumber(save.clipboard.count) or 0,
            })
        end
    end
    table.sort(list, function(a, b)
        return tostring(a.name):lower() < tostring(b.name):lower()
    end)
    return list
end

buildSafehouseSaveList = function()
    local storage = getSafehouseSaveStorage()
    local list = {}
    for saveId, save in pairs(storage.saves or {}) do
        if save and save.clipboard and EBFCopyPasteServer.isCurrentClipboardSchema(save.clipboard) then
            local safehouse = save.clipboard.safehouse or {}
            table.insert(list, {
                id = tostring(save.id or saveId),
                kind = "safehouse",
                name = tostring(save.name or safehouse.title or save.clipboard.title or "Safehouse"),
                owner = tostring(save.owner or safehouse.owner or ""),
                backupName = tostring(save.backupName or save.clipboard.backupName or ""),
                w = tonumber(save.clipboard.w) or 1,
                h = tonumber(save.clipboard.h) or 1,
                levels = tonumber(save.clipboard.levels) or 1,
                count = tonumber(save.clipboard.count) or 0,
                x = tonumber(safehouse.x or save.clipboard.x) or 0,
                y = tonumber(safehouse.y or save.clipboard.y) or 0,
                z = tonumber(safehouse.z or save.originalZ or save.clipboard.z) or 0,
                x2 = (tonumber(safehouse.x or save.clipboard.x) or 0) + (tonumber(safehouse.w or save.clipboard.w) or 1) - 1,
                y2 = (tonumber(safehouse.y or save.clipboard.y) or 0) + (tonumber(safehouse.h or save.clipboard.h) or 1) - 1,
                members = safehouse.members or {},
                respawnMembers = safehouse.respawnMembers or {},
                location = tostring(safehouse.location or ""),
            })
        end
    end
    table.sort(list, function(a, b)
        return tostring(a.name):lower() < tostring(b.name):lower()
    end)
    return list
end

local getOrCreateSafehouseSaveId

local function sendSavedAreaList(playerObj)
    sendFeedback(playerObj, {
        action = "savedAreas",
        ok = true,
        saves = buildSavedAreaList(),
    })
end

local function sendSafehouseSaveList(playerObj)
    sendFeedback(playerObj, {
        action = "safehouseSaves",
        ok = true,
        saves = buildSafehouseSaveList(),
    })
end

local function buildSafehouseBackupPayload(backupName)
    local storage = getSafehouseSaveStorage()
    backupName = backupName ~= nil and tostring(backupName or "") or nil
    local saves = {}
    for saveId, save in pairs(storage.saves or {}) do
        local saveBackupName = tostring(save and (save.backupName or save.clipboard and save.clipboard.backupName) or "")
        local include = backupName == nil or saveBackupName == backupName
        if include and save and save.clipboard and EBFCopyPasteServer.isCurrentClipboardSchema(save.clipboard) then
            local copied = copyPersistentValue(save, 0)
            if copied then
                copied.id = tostring(save.id or saveId)
                table.insert(saves, copied)
            end
        end
    end
    table.sort(saves, function(a, b)
        return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
    end)

    return {
        format = "EBFCopyPasteSafeHouseBackup",
        version = EBFCopyPaste.SchemaVersion or 4220001,
        targetBuild = EBFCopyPaste.TargetBuild or "42.20",
        exportedAt = nowMs(),
        backupName = backupName,
        saveCount = #saves,
        nextId = tonumber(storage.nextId) or (#saves + 1),
        saves = saves,
    }
end

local function buildSavedAreaExportPayload(saveId)
    local storage = getSavedAreaStorage()
    saveId = saveId ~= nil and tostring(saveId or "") or nil
    if saveId == "" then
        saveId = nil
    end

    local saves = {}
    for storageId, save in pairs(storage.saves or {}) do
        local currentId = tostring(save and save.id or storageId)
        local include = saveId == nil or currentId == saveId
        if include and save and save.clipboard and EBFCopyPasteServer.isCurrentClipboardSchema(save.clipboard) then
            local copied = copyPersistentValue(save, 0)
            if copied then
                copied.id = currentId
                table.insert(saves, copied)
            end
        end
    end
    table.sort(saves, function(a, b)
        return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
    end)

    return {
        format = "EBFCopyPasteSavedAreaExport",
        version = EBFCopyPaste.SchemaVersion or 4220001,
        targetBuild = EBFCopyPaste.TargetBuild or "42.20",
        exportedAt = nowMs(),
        saveId = saveId,
        saveCount = #saves,
        nextId = tonumber(storage.nextId) or (#saves + 1),
        saves = saves,
    }
end

local function splitBackupText(text)
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

local function importedSafehouseSaveRecord(importedSave)
    if type(importedSave) ~= "table" or type(importedSave.clipboard) ~= "table" then
        return nil
    end

    local persisted = copyPersistentValue(importedSave.clipboard, 0)
    if not persisted or persisted.source ~= "safehouse" or type(persisted.safehouse) ~= "table" then
        return nil
    end
    if not EBFCopyPasteServer.isCurrentClipboardSchema(persisted) then
        return nil
    end

    local safehouse = persisted.safehouse
    local name = sanitizeSaveName(importedSave.name or persisted.title or safehouse.title or "Safehouse")
    persisted.title = name
    persisted.source = "safehouse"

    local record = {
        name = name,
        owner = tostring(importedSave.owner or safehouse.owner or ""),
        members = copyStringList(importedSave.members or safehouse.members),
        respawnMembers = copyStringList(importedSave.respawnMembers or safehouse.respawnMembers),
        originalX = tonumber(importedSave.originalX or safehouse.x or persisted.x) or 0,
        originalY = tonumber(importedSave.originalY or safehouse.y or persisted.y) or 0,
        originalZ = tonumber(importedSave.originalZ or safehouse.z or persisted.z) or 0,
        backupName = tostring(importedSave.backupName or persisted.backupName or ""),
        savedAt = tonumber(importedSave.savedAt) or nowMs(),
        importedAt = nowMs(),
        clipboard = persisted,
    }
    return record
end

local function importSafehouseBackupRecord(storage, importedSave)
    local record = importedSafehouseSaveRecord(importedSave)
    if not record then
        return false
    end

    local safehouse = record.clipboard.safehouse or {}
    local saveId, safehouseKey = getOrCreateSafehouseSaveId(storage, record.name, safehouse, record.backupName)
    if not saveId then
        return false
    end

    record.id = saveId
    record.safehouseKey = safehouseKey
    storage.saves[saveId] = record
    return record
end

local function getOrCreateSaveId(storage, saveName)
    for saveId, save in pairs(storage.saves or {}) do
        if save and tostring(save.name or "") == saveName then
            return tostring(save.id or saveId)
        end
    end

    local saveId = tostring(math.floor(tonumber(storage.nextId) or 1))
    storage.nextId = (tonumber(storage.nextId) or 1) + 1
    return saveId
end

local function getSafehouseKey(safehouse, backupName)
    safehouse = safehouse or {}
    local baseKey = tostring(safehouse.owner or "") .. "|" ..
            tostring(safehouse.title or "") .. "|" ..
            tostring(safehouse.x or 0) .. "|" ..
            tostring(safehouse.y or 0) .. "|" ..
            tostring(safehouse.w or 0) .. "|" ..
            tostring(safehouse.h or 0)
    if backupName ~= nil and tostring(backupName or "") ~= "" then
        return baseKey .. "|" .. tostring(backupName or "")
    end
    return baseKey
end

getOrCreateSafehouseSaveId = function(storage, saveName, safehouse, backupName)
    local safehouseKey = getSafehouseKey(safehouse, backupName)
    for saveId, save in pairs(storage.saves or {}) do
        if save and tostring(save.safehouseKey or "") == safehouseKey then
            return tostring(save.id or saveId), safehouseKey
        end
    end
    for saveId, save in pairs(storage.saves or {}) do
        if save and tostring(save.name or "") == saveName then
            return tostring(save.id or saveId), safehouseKey
        end
    end

    local saveId = tostring(math.floor(tonumber(storage.nextId) or 1))
    storage.nextId = (tonumber(storage.nextId) or 1) + 1
    return saveId, safehouseKey
end

saveClipboardToStorage = function(playerObj, saveName, clipboard)
    local persisted = makePersistentClipboard(clipboard)
    if not persisted then
        return nil
    end

    local storage = getSavedAreaStorage()
    saveName = sanitizeSaveName(saveName or persisted.title)
    local saveId = getOrCreateSaveId(storage, saveName)
    persisted.title = saveName

    storage.saves[saveId] = {
        id = saveId,
        name = saveName,
        owner = getPlayerKey(playerObj),
        savedAt = nowMs(),
        clipboard = persisted,
    }
    transmitSavedAreas()
    return storage.saves[saveId]
end

saveSafehouseClipboardToStorage = function(playerObj, saveName, clipboard, backupName)
    if not clipboard or clipboard.source ~= "safehouse" or not clipboard.safehouse then
        return nil
    end

    local persisted = makePersistentClipboard(clipboard)
    if not persisted then
        return nil
    end

    local safehouse = persisted.safehouse or clipboard.safehouse or {}
    local storage = getSafehouseSaveStorage()
    saveName = sanitizeSaveName(saveName or safehouse.title or persisted.title or "Safehouse")
    backupName = tostring(backupName or persisted.backupName or clipboard.backupName or ""):gsub("^%s+", ""):gsub("%s+$", ""):sub(1, 64)
    if backupName == "" then
        backupName = nil
    end
    local saveId, safehouseKey = getOrCreateSafehouseSaveId(storage, saveName, safehouse, backupName)
    persisted.title = saveName
    persisted.source = "safehouse"
    persisted.safehouse = safehouse
    persisted.backupName = backupName

    storage.saves[saveId] = {
        id = saveId,
        name = saveName,
        owner = tostring(safehouse.owner or getPlayerKey(playerObj)),
        backupName = backupName,
        members = safehouse.members or {},
        respawnMembers = safehouse.respawnMembers or {},
        originalX = tonumber(safehouse.x) or tonumber(persisted.x) or 0,
        originalY = tonumber(safehouse.y) or tonumber(persisted.y) or 0,
        originalZ = tonumber(safehouse.z) or tonumber(persisted.z) or 0,
        safehouseKey = safehouseKey,
        savedAt = nowMs(),
        clipboard = persisted,
    }
    transmitSafehouseSaves()
    return storage.saves[saveId]
end

local function clearJavaList(list)
    if list and list.clear then
        pcall(function()
            list:clear()
        end)
    end
end

function EBFCopyPasteServer.getJavaListSize(list)
    return math.max(0, tonumber(callMethod(list, "size")) or 0)
end

EBFCopyPasteServer.javaFieldCache = EBFCopyPasteServer.javaFieldCache or {}
EBFCopyPasteServer.roomLightProofByRoom = EBFCopyPasteServer.roomLightProofByRoom or {}

function EBFCopyPasteServer.getJavaField(object, fieldName)
    -- PZ's Kahlua runtime exposes many Java instance fields directly, but Java
    -- Class reflection methods are not safe to index from Lua in multiplayer.
    -- Keep this as a compatibility stub so callers use direct field fallbacks.
    return nil
end

function EBFCopyPasteServer.getJavaFieldValue(object, fieldName)
    if not object or type(fieldName) ~= "string" or fieldName == "" then
        return nil, false
    end

    local ok, value = pcall(function()
        return object[fieldName]
    end)
    if ok then
        return value, true
    end
    return nil, false
end

function EBFCopyPasteServer.setJavaBooleanField(object, fieldName, value)
    if not object or type(fieldName) ~= "string" or fieldName == "" then
        return false
    end

    local target = value == true
    local setterName = nil
    if string.sub(fieldName, 1, 2) == "is" and string.len(fieldName) > 2 then
        setterName = "set" .. string.sub(fieldName, 3)
    else
        setterName = "set" .. string.upper(string.sub(fieldName, 1, 1)) .. string.sub(fieldName, 2)
    end

    if setterName and getMethod(object, setterName) then
        return EBFCopyPasteServer.tryCallMethod(object, setterName, target) == true
    end
    return false
end

function EBFCopyPasteServer.getRoomLightList(room)
    if not room then
        return nil, false
    end

    local lights, known = EBFCopyPasteServer.getJavaFieldValue(room, "roomLights")
    if known and lights then
        return lights, true
    end

    lights = callMethod(room, "getRoomLights")
    if lights then
        return lights, true
    end

    local ok, lights = pcall(function()
        return room.roomLights
    end)
    if ok and lights then
        return lights, true
    end
    return nil, false
end

function EBFCopyPasteServer.cacheRoomLightProof(room, count, source)
    if not room then
        return
    end
    count = math.max(0, tonumber(count) or 0)
    if count <= 0 then
        EBFCopyPasteServer.roomLightProofByRoom[room] = nil
        return
    end
    EBFCopyPasteServer.roomLightProofByRoom[room] = {
        count = count,
        source = tostring(source or "unknown"),
        time = nowMs and nowMs() or nil,
    }
end

function EBFCopyPasteServer.getCachedRoomLightProof(room)
    local proof = room and EBFCopyPasteServer.roomLightProofByRoom[room] or nil
    local count = proof and math.max(0, tonumber(proof.count) or 0) or 0
    if count > 0 then
        return count, true, proof.source
    end
    return 0, false, nil
end

function EBFCopyPasteServer.getChunkRoomLightList(chunk)
    if not chunk then
        return nil, false
    end

    local lights, known = EBFCopyPasteServer.getJavaFieldValue(chunk, "roomLights")
    if known and lights then
        return lights, true
    end

    local ok, value = pcall(function()
        return chunk.roomLights
    end)
    if ok and value then
        return value, true
    end
    return nil, false
end

function EBFCopyPasteServer.roomLightIntersectsRoomDef(light, roomDef)
    if not light or not roomDef then
        return false
    end

    local lightX = tonumber(EBFCopyPasteServer.safeField(light, "x"))
    local lightY = tonumber(EBFCopyPasteServer.safeField(light, "y"))
    local lightZ = tonumber(EBFCopyPasteServer.safeField(light, "z"))
    local width = math.max(1, tonumber(EBFCopyPasteServer.safeField(light, "width")) or 1)
    local height = math.max(1, tonumber(EBFCopyPasteServer.safeField(light, "height")) or 1)
    if lightX == nil or lightY == nil then
        return false
    end

    local roomLevel = tonumber(callMethod(roomDef, "getLevel"))
            or tonumber(EBFCopyPasteServer.safeField(roomDef, "level"))
    if lightZ ~= nil and roomLevel ~= nil and math.floor(lightZ) ~= math.floor(roomLevel) then
        return false
    end

    local rects = EBFCopyPasteServer.safeField(roomDef, "rects") or callMethod(roomDef, "getRects")
    local rectCount = EBFCopyPasteServer.getJavaListSize(rects)
    local lightX2 = lightX + width
    local lightY2 = lightY + height
    for index = 0, rectCount - 1 do
        local rect = callMethod(rects, "get", index)
        local rectX = tonumber(callMethod(rect, "getX")) or tonumber(EBFCopyPasteServer.safeField(rect, "x"))
        local rectY = tonumber(callMethod(rect, "getY")) or tonumber(EBFCopyPasteServer.safeField(rect, "y"))
        local rectW = math.max(1, tonumber(callMethod(rect, "getW"))
                or tonumber(EBFCopyPasteServer.safeField(rect, "w")) or 1)
        local rectH = math.max(1, tonumber(callMethod(rect, "getH"))
                or tonumber(EBFCopyPasteServer.safeField(rect, "h")) or 1)
        if rectX ~= nil and rectY ~= nil then
            local rectX2 = rectX + rectW
            local rectY2 = rectY + rectH
            if lightX < rectX2 and lightX2 > rectX and lightY < rectY2 and lightY2 > rectY then
                return true
            end
        end
    end
    return false
end

function EBFCopyPasteServer.roomLightBelongsToRoom(light, room)
    if not light or not room then
        return false
    end

    local lightRoom = EBFCopyPasteServer.safeField(light, "room")
    if lightRoom == room then
        return true
    end

    local roomDef = callMethod(room, "getRoomDef")
    local lightRoomDef = lightRoom and callMethod(lightRoom, "getRoomDef") or nil
    if roomDef and lightRoomDef and roomDef == lightRoomDef then
        return true
    end

    return EBFCopyPasteServer.roomLightIntersectsRoomDef(light, roomDef)
end

function EBFCopyPasteServer.proveRoomLightsViaChunk(room, sampleSquare, reason)
    if not room or not sampleSquare then
        return EBFCopyPasteServer.getCachedRoomLightProof(room)
    end

    local chunk = callMethod(sampleSquare, "getChunk")
    local chunkLights, chunkKnown = EBFCopyPasteServer.getChunkRoomLightList(chunk)
    if not chunkKnown or not chunkLights then
        return EBFCopyPasteServer.getCachedRoomLightProof(room)
    end

    local chunkCount = EBFCopyPasteServer.getJavaListSize(chunkLights)
    if chunkCount <= 0 then
        return EBFCopyPasteServer.getCachedRoomLightProof(room)
    end

    local matched = 0
    for index = 0, chunkCount - 1 do
        local light = callMethod(chunkLights, "get", index)
        if EBFCopyPasteServer.roomLightBelongsToRoom(light, room) then
            matched = matched + 1
        end
    end

    if matched > 0 then
        EBFCopyPasteServer.cacheRoomLightProof(room, matched, "IsoChunk.roomLights/" .. tostring(reason or "audit"))
        return matched, true, "IsoChunk.roomLights"
    end

    local roomDef = callMethod(room, "getRoomDef")
    local rectCount = EBFCopyPasteServer.getRoomDefRectCount(roomDef)
    local switchCount = EBFCopyPasteServer.getJavaListSize(callMethod(room, "getLightSwitches"))
    local hasLightSwitches = callMethod(room, "hasLightSwitches") == true
    if rectCount > 0 and (switchCount > 0 or hasLightSwitches) then
        local provenCount = math.max(1, math.min(chunkCount, rectCount))
        EBFCopyPasteServer.cacheRoomLightProof(room, provenCount, "IsoChunk.roomLights/fallback/" .. tostring(reason or "audit"))
        return provenCount, true, "IsoChunk.roomLights/fallback"
    end

    return EBFCopyPasteServer.getCachedRoomLightProof(room)
end

function EBFCopyPasteServer.getRoomLightCount(room)
    local lights, known = EBFCopyPasteServer.getRoomLightList(room)
    if lights then
        return EBFCopyPasteServer.getJavaListSize(lights), known == true
    end
    local cachedCount, cachedKnown = EBFCopyPasteServer.getCachedRoomLightProof(room)
    if cachedKnown then
        return cachedCount, true
    end
    return 0, false
end

function EBFCopyPasteServer.getEffectiveRoomLightCount(room, sampleSquare)
    local count, known = EBFCopyPasteServer.getRoomLightCount(room)
    if known then
        return count, true
    end

    local provenCount, provenKnown = EBFCopyPasteServer.proveRoomLightsViaChunk(room, sampleSquare, "effectiveCount")
    if provenKnown then
        return provenCount, true
    end

    local roomDef = room and callMethod(room, "getRoomDef") or nil
    local rectCount = EBFCopyPasteServer.getRoomDefRectCount
            and EBFCopyPasteServer.getRoomDefRectCount(roomDef) or 0
    local switchCount = EBFCopyPasteServer.getJavaListSize(room and callMethod(room, "getLightSwitches") or nil)
    if rectCount > 0 and switchCount > 0 then
        return rectCount, false
    end
    return 0, false
end

function EBFCopyPasteServer.safeField(object, fieldName)
    if not object then
        return nil
    end

    local value, known = EBFCopyPasteServer.getJavaFieldValue(object, fieldName)
    if known then
        return value
    end

    local ok, value = pcall(function()
        return object[fieldName]
    end)
    if ok then
        return value
    end
    return nil
end

function EBFCopyPasteServer.auditValue(value)
    if value == nil then
        return "nil"
    end
    if value == true then
        return "true"
    end
    if value == false then
        return "false"
    end
    return tostring(value)
end

function EBFCopyPasteServer.getRoomAuditLabel(room)
    if not room then
        return "room=nil"
    end

    local roomName = callMethod(room, "getName") or EBFCopyPasteServer.safeField(room, "roomDef")
    local roomDef = callMethod(room, "getRoomDef") or EBFCopyPasteServer.safeField(room, "def")
    local defName = callMethod(roomDef, "getName") or EBFCopyPasteServer.safeField(roomDef, "name")
    local defId = callMethod(roomDef, "getID") or EBFCopyPasteServer.safeField(roomDef, "ID")
    local building = callMethod(room, "getBuilding") or EBFCopyPasteServer.safeField(room, "building")
    local buildingId = callMethod(building, "getID") or EBFCopyPasteServer.safeField(building, "ID")

    return "room=" .. EBFCopyPasteServer.auditValue(roomName)
        .. " def=" .. EBFCopyPasteServer.auditValue(defName)
        .. " defId=" .. EBFCopyPasteServer.auditValue(defId)
        .. " building=" .. EBFCopyPasteServer.auditValue(buildingId)
end

function EBFCopyPasteServer.getLightAuditSquareLabel(square)
    if not square then
        return "square=nil"
    end

    local x = callMethod(square, "getX")
    local y = callMethod(square, "getY")
    local z = callMethod(square, "getZ")
    local roomId = callMethod(square, "getRoomID")
    local haveElectricity = callMethod(square, "haveElectricity")
    local hasGridPower = callMethod(square, "hasGridPower")
    return tostring(x or "?") .. "," .. tostring(y or "?") .. "," .. tostring(z or "?")
        .. " roomId=" .. EBFCopyPasteServer.auditValue(roomId)
        .. " haveElectricity=" .. EBFCopyPasteServer.auditValue(haveElectricity)
        .. " hasGridPower=" .. EBFCopyPasteServer.auditValue(hasGridPower)
end

function EBFCopyPasteServer.formatRoomLightTiles(light)
    local x = tonumber(EBFCopyPasteServer.safeField(light, "x")) or 0
    local y = tonumber(EBFCopyPasteServer.safeField(light, "y")) or 0
    local z = tonumber(EBFCopyPasteServer.safeField(light, "z")) or 0
    local width = math.max(0, tonumber(EBFCopyPasteServer.safeField(light, "width")) or 0)
    local height = math.max(0, tonumber(EBFCopyPasteServer.safeField(light, "height")) or 0)
    local count = width * height
    local x2 = x + math.max(0, width - 1)
    local y2 = y + math.max(0, height - 1)
    local summary = x .. "," .. y .. "," .. z .. "->" .. x2 .. "," .. y2 .. "," .. z .. " total=" .. count

    if count <= 0 or count > 48 then
        return summary
    end

    local tiles = {}
    for ty = y, y2 do
        for tx = x, x2 do
            table.insert(tiles, tx .. "," .. ty .. "," .. z)
        end
    end
    return summary .. " tiles=[" .. table.concat(tiles, ";") .. "]"
end

function EBFCopyPasteServer.logRoomLightsForAudit(phase, ownerLabel, room, sampleSquare)
    local lights = EBFCopyPasteServer.getRoomLightList(room)
    local count, known = EBFCopyPasteServer.getEffectiveRoomLightCount(room, sampleSquare)
    print("[EBFCopyPaste][LightAudit][" .. phase .. "] " .. ownerLabel
            .. " roomLights=" .. tostring(count)
            .. " roomLightsKnown=" .. tostring(known)
            .. " " .. EBFCopyPasteServer.getRoomAuditLabel(room))
    if not known or count <= 0 or not lights then
        return
    end

    local maxLights = math.min(count, 24)
    for index = 0, maxLights - 1 do
        local light = callMethod(lights, "get", index)
        local lightRoom = EBFCopyPasteServer.safeField(light, "room")
        local id = EBFCopyPasteServer.safeField(light, "id")
        local active = EBFCopyPasteServer.safeField(light, "active")
        local hydro = EBFCopyPasteServer.safeField(light, "hydroPowered")
        local r = EBFCopyPasteServer.safeField(light, "r")
        local g = EBFCopyPasteServer.safeField(light, "g")
        local b = EBFCopyPasteServer.safeField(light, "b")
        print("[EBFCopyPaste][LightAudit][" .. phase .. "] " .. ownerLabel
            .. " roomLight#" .. index
            .. " id=" .. EBFCopyPasteServer.auditValue(id)
            .. " active=" .. EBFCopyPasteServer.auditValue(active)
            .. " hydro=" .. EBFCopyPasteServer.auditValue(hydro)
            .. " rgb=" .. EBFCopyPasteServer.auditValue(r) .. "," .. EBFCopyPasteServer.auditValue(g) .. "," .. EBFCopyPasteServer.auditValue(b)
            .. " lightRoom={" .. EBFCopyPasteServer.getRoomAuditLabel(lightRoom) .. "}"
            .. " controlledTiles=" .. EBFCopyPasteServer.formatRoomLightTiles(light))
    end
    if count > maxLights then
        print("[EBFCopyPaste][LightAudit][" .. phase .. "] " .. ownerLabel .. " roomLights_truncated=" .. (count - maxLights))
    end
end

function EBFCopyPasteServer.javaListContains(list, value)
    if not list then
        return false
    end

    local contains = callMethod(list, "contains", value)
    if contains ~= nil then
        return contains == true
    end

    local count = EBFCopyPasteServer.getJavaListSize(list)
    for index = 0, count - 1 do
        if callMethod(list, "get", index) == value then
            return true
        end
    end
    return false
end

function EBFCopyPasteServer.logSwitchLightSourcesForAudit(phase, object)
    local lights = callMethod(object, "getLights")
    local count = EBFCopyPasteServer.getJavaListSize(lights)
    print("[EBFCopyPaste][LightAudit][" .. phase .. "] ownLightSources=" .. count)
    if count <= 0 then
        return
    end

    local maxLights = math.min(count, 24)
    for index = 0, maxLights - 1 do
        local light = callMethod(lights, "get", index)
        local x = callMethod(light, "getX") or EBFCopyPasteServer.safeField(light, "x")
        local y = callMethod(light, "getY") or EBFCopyPasteServer.safeField(light, "y")
        local z = callMethod(light, "getZ") or EBFCopyPasteServer.safeField(light, "z")
        local radius = callMethod(light, "getRadius") or EBFCopyPasteServer.safeField(light, "radius")
        local active = callMethod(light, "isActive")
        if active == nil then
            active = EBFCopyPasteServer.safeField(light, "active")
        end
        local hydro = callMethod(light, "isHydroPowered")
        if hydro == nil then
            hydro = EBFCopyPasteServer.safeField(light, "hydroPowered")
        end
        local switchList = callMethod(light, "getSwitches") or EBFCopyPasteServer.safeField(light, "switches")
        local switchCount = EBFCopyPasteServer.getJavaListSize(switchList)
        local r = callMethod(light, "getR") or EBFCopyPasteServer.safeField(light, "r")
        local g = callMethod(light, "getG") or EBFCopyPasteServer.safeField(light, "g")
        local b = callMethod(light, "getB") or EBFCopyPasteServer.safeField(light, "b")
        local minX = (tonumber(x) or 0) - (tonumber(radius) or 0)
        local maxX = (tonumber(x) or 0) + (tonumber(radius) or 0)
        local minY = (tonumber(y) or 0) - (tonumber(radius) or 0)
        local maxY = (tonumber(y) or 0) + (tonumber(radius) or 0)
        print("[EBFCopyPaste][LightAudit][" .. phase .. "] ownLight#" .. index
            .. " pos=" .. EBFCopyPasteServer.auditValue(x) .. "," .. EBFCopyPasteServer.auditValue(y) .. "," .. EBFCopyPasteServer.auditValue(z)
            .. " radius=" .. EBFCopyPasteServer.auditValue(radius)
            .. " active=" .. EBFCopyPasteServer.auditValue(active)
            .. " hydro=" .. EBFCopyPasteServer.auditValue(hydro)
            .. " rgb=" .. EBFCopyPasteServer.auditValue(r) .. "," .. EBFCopyPasteServer.auditValue(g) .. "," .. EBFCopyPasteServer.auditValue(b)
            .. " linkedSwitches=" .. switchCount
            .. " controlledBounds=" .. minX .. "," .. minY .. "," .. EBFCopyPasteServer.auditValue(z) .. "->" .. maxX .. "," .. maxY .. "," .. EBFCopyPasteServer.auditValue(z))
    end
end

function EBFCopyPasteServer.logRoomsLinkedToSwitchForAudit(phase, object, squareRoom)
    local building = squareRoom and (callMethod(squareRoom, "getBuilding") or EBFCopyPasteServer.safeField(squareRoom, "building")) or nil
    local rooms = building and EBFCopyPasteServer.safeField(building, "rooms") or nil
    local roomCount = EBFCopyPasteServer.getJavaListSize(rooms)
    if roomCount <= 0 then
        print("[EBFCopyPaste][LightAudit][" .. phase .. "] linkedRooms=0 buildingRooms=0")
        return
    end

    local linked = 0
    local maxRooms = math.min(roomCount, 32)
    for index = 0, maxRooms - 1 do
        local room = callMethod(rooms, "get", index)
        local switches = callMethod(room, "getLightSwitches") or EBFCopyPasteServer.safeField(room, "lightSwitches")
        if EBFCopyPasteServer.javaListContains(switches, object) then
            linked = linked + 1
            local label = "linkedRoom#" .. linked
            print("[EBFCopyPaste][LightAudit][" .. phase .. "] " .. label .. " " .. EBFCopyPasteServer.getRoomAuditLabel(room)
                .. " switchCount=" .. EBFCopyPasteServer.getJavaListSize(switches))
            EBFCopyPasteServer.logRoomLightsForAudit(phase, label, room)
        end
    end
    print("[EBFCopyPaste][LightAudit][" .. phase .. "] linkedRooms=" .. linked .. " buildingRooms=" .. roomCount)
end

function EBFCopyPasteServer.logLightSwitchToggleAudit(phase, object, character)
    if not object or not isInstance(object, "IsoLightSwitch") then
        return
    end

    local square = callMethod(object, "getSquare")
    local room = square and callMethod(square, "getRoom") or nil
    local spriteName = getObjectSpriteName(object)
    local activated = callMethod(object, "isActivated")
    if activated == nil then
        activated = EBFCopyPasteServer.safeField(object, "activated")
    end
    local canSwitch = callMethod(object, "canSwitchLight")
    local vanillaPowerAround = EBFCopyPasteServer.squareHasVanillaLightSwitchPower(square, object)
    local objectRoomId = EBFCopyPasteServer.safeField(object, "roomId")
    local lightRoom = EBFCopyPasteServer.safeField(object, "lightRoom")
    local streetLight = EBFCopyPasteServer.safeField(object, "streetLight")
    local playerName = character and callMethod(character, "getUsername") or nil

    print("[EBFCopyPaste][LightAudit][" .. phase .. "] switch=" .. EBFCopyPasteServer.getLightAuditSquareLabel(square)
        .. " sprite=" .. EBFCopyPasteServer.auditValue(spriteName)
        .. " active=" .. EBFCopyPasteServer.auditValue(activated)
        .. " canSwitch=" .. EBFCopyPasteServer.auditValue(canSwitch)
        .. " vanillaPowerAround=" .. EBFCopyPasteServer.auditValue(vanillaPowerAround)
        .. " objectRoomId=" .. EBFCopyPasteServer.auditValue(objectRoomId)
        .. " lightRoom=" .. EBFCopyPasteServer.auditValue(lightRoom)
        .. " streetLight=" .. EBFCopyPasteServer.auditValue(streetLight)
        .. " player=" .. EBFCopyPasteServer.auditValue(playerName)
        .. " squareRoom={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
    EBFCopyPasteServer.logRoomLightsForAudit(phase, "squareRoom", room, square)
    EBFCopyPasteServer.logRoomsLinkedToSwitchForAudit(phase, object, room)
    EBFCopyPasteServer.logSwitchLightSourcesForAudit(phase, object)
end

function EBFCopyPasteServer.clearRuntimeRoomLights(room)
    if room then
        EBFCopyPasteServer.roomLightProofByRoom[room] = nil
    end

    local lights = EBFCopyPasteServer.getRoomLightList(room)
    if not lights then
        return 0
    end

    local count = EBFCopyPasteServer.getJavaListSize(lights)
    if count <= 0 then
        return 0
    end

    for index = count - 1, 0, -1 do
        local light = callMethod(lights, "get", index)
        if light then
            EBFCopyPasteServer.tryCallMethod(light, "clearInfluence")
        end
    end
    clearJavaList(lights)
    return count
end

function EBFCopyPasteServer.getRoomDefRectCount(roomDef)
    if not roomDef then
        return 0
    end

    local rects = EBFCopyPasteServer.safeField(roomDef, "rects") or callMethod(roomDef, "getRects")
    return EBFCopyPasteServer.getJavaListSize(rects)
end

function EBFCopyPasteServer.reloadLightSwitchChunk(square)
    if not square or not IsoLightSwitch or not IsoLightSwitch.chunkLoaded then
        return false
    end

    local chunk = callMethod(square, "getChunk")
    if not chunk then
        return false
    end

    local ok = pcall(function()
        IsoLightSwitch.chunkLoaded(chunk)
    end)
    return ok == true
end

function EBFCopyPasteServer.ensureRoomLightsForRoom(room, reason, sampleSquare)
    if not room then
        return 0, 0, 0
    end

    local roomDef = callMethod(room, "getRoomDef")
    EBFCopyPasteServer.tryCallMethod(roomDef, "refreshSquares")
    EBFCopyPasteServer.tryCallMethod(room, "refreshSquares")

    local before, beforeKnown = EBFCopyPasteServer.getRoomLightCount(room)
    if beforeKnown ~= true then
        before, beforeKnown = EBFCopyPasteServer.proveRoomLightsViaChunk(room, sampleSquare, reason)
    end
    local after, afterKnown = before, beforeKnown
    local created = 0
    local rectCount = EBFCopyPasteServer.getRoomDefRectCount(roomDef)
    local switchCount = EBFCopyPasteServer.getJavaListSize(callMethod(room, "getLightSwitches"))

    if beforeKnown == true
            and before <= 0
            and rectCount > 0
            and switchCount > 0
            and getMethod(room, "createLights") then
        local ok = EBFCopyPasteServer.tryCallMethod(room, "createLights", false)
        if ok then
            EBFCopyPasteServer.tryCallMethod(roomDef, "refreshSquares")
            EBFCopyPasteServer.tryCallMethod(room, "refreshSquares")
            after, afterKnown = EBFCopyPasteServer.getRoomLightCount(room)
            if afterKnown ~= true then
                after, afterKnown = EBFCopyPasteServer.proveRoomLightsViaChunk(room, sampleSquare, reason)
            end
            created = math.max(0, (tonumber(after) or 0) - (tonumber(before) or 0))
        end
    end

    local effectiveAfter, effectiveKnown = after, afterKnown
    if not afterKnown then
        effectiveAfter, effectiveKnown = EBFCopyPasteServer.getEffectiveRoomLightCount(room, sampleSquare)
    end
    if effectiveAfter <= 0 then
        print("[EBFCopyPaste] RoomLight vanilla ausente después de asegurarla: "
                .. EBFCopyPasteServer.getRoomAuditLabel(room)
                .. " rects=" .. tostring(rectCount)
                .. " switches=" .. tostring(switchCount)
                .. " roomLightListKnown=" .. tostring(afterKnown)
                .. " reason=" .. tostring(reason or ""))
    end
    return effectiveAfter, beforeKnown and before or 0, created, effectiveKnown
end

function EBFCopyPasteServer.getRoomSpecSampleSquare(job, spec)
    if not job or not spec or not getCell then
        return nil
    end

    local cell = getCell()
    if not cell then
        return nil
    end

    local targetX = EBFCopyPaste.toInt(job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
    local found = nil
    EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
        if found then
            return
        end
        found = callMethod(cell, "getGridSquare", targetX + dx, targetY + dy, targetZ + dz)
                or getOrCreateSquare(targetX + dx, targetY + dy, targetZ + dz)
    end)
    return found
end

function EBFCopyPasteServer.reloadLightSwitchChunksForRoomSpec(job, spec)
    if not job or not spec or not getCell or not IsoLightSwitch or not IsoLightSwitch.chunkLoaded then
        return 0
    end

    local cell = getCell()
    if not cell then
        return 0
    end

    local targetX = EBFCopyPaste.toInt(job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
    local seen = {}
    local chunks = 0
    EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
        local square = callMethod(cell, "getGridSquare", targetX + dx, targetY + dy, targetZ + dz)
                or getOrCreateSquare(targetX + dx, targetY + dy, targetZ + dz)
        local chunk = square and callMethod(square, "getChunk") or nil
        if chunk and not seen[chunk] then
            seen[chunk] = true
            local ok = pcall(function()
                IsoLightSwitch.chunkLoaded(chunk)
            end)
            if ok then
                chunks = chunks + 1
            end
        end
    end)
    return chunks
end

function EBFCopyPasteServer.ensureRuntimeRoomLights(job, reason)
    if not job or not job.clipboard then
        return 0
    end

    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)

    local rooms = 0
    local switches = 0
    local lights = 0
    local created = 0
    local chunks = 0
    local missing = 0
    local seenRooms = {}
    for _, runtime in pairs(job.roomDefRuntimeBySpec or {}) do
        local spec = runtime and runtime.spec or nil
        local room = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)) or nil
        if room and not seenRooms[room] then
            seenRooms[room] = true
            runtime.room = room
            rooms = rooms + 1
            local switchList = callMethod(room, "getLightSwitches")
            switches = switches + EBFCopyPasteServer.getJavaListSize(switchList)
            local sampleSquare = nil
            if spec then
                chunks = chunks + EBFCopyPasteServer.reloadLightSwitchChunksForRoomSpec(job, spec)
                sampleSquare = EBFCopyPasteServer.getRoomSpecSampleSquare(job, spec)
            else
                sampleSquare = EBFCopyPasteServer.getRoomSpecSampleSquare(job, spec)
                if EBFCopyPasteServer.reloadLightSwitchChunk(sampleSquare) then
                    chunks = chunks + 1
                end
            end
            local roomLights, _, newLights = EBFCopyPasteServer.ensureRoomLightsForRoom(room, reason, sampleSquare)
            lights = lights + roomLights
            created = created + newLights
        else
            missing = missing + 1
        end
    end

    print("[EBFCopyPaste] RoomLights vanilla auditados por chunkLoaded: rooms=" .. tostring(rooms)
            .. " switches=" .. tostring(switches)
            .. " roomLights=" .. tostring(lights)
            .. " criadosManual=" .. tostring(created)
            .. " chunks=" .. tostring(chunks)
            .. " semRoom=" .. tostring(missing)
            .. " reason=" .. tostring(reason or ""))
    return lights
end

function EBFCopyPasteServer.forceRoomLightsInactive(room, reason)
    if not room then
        return 0, 0
    end

    local changedDefs = 0
    local changedLights = 0
    local roomDef = callMethod(room, "getRoomDef")
    if roomDef then
        if EBFCopyPasteServer.setJavaBooleanField(roomDef, "lightsActive", false) then
            changedDefs = changedDefs + 1
        end
    end

    local lights = EBFCopyPasteServer.getRoomLightList(room)
    if lights then
        for index = 0, EBFCopyPasteServer.getJavaListSize(lights) - 1 do
            local light = callMethod(lights, "get", index)
            if light then
                local changedLight = false
                if EBFCopyPasteServer.setJavaBooleanField(light, "active", false) then
                    changedLight = true
                end
                if EBFCopyPasteServer.setJavaBooleanField(light, "activeJni", false) then
                    changedLight = true
                end
                if changedLight then
                    changedLights = changedLights + 1
                end
            end
        end
    end

    return changedDefs, changedLights
end

function EBFCopyPasteServer.forceRuntimeRoomLightsInactive(job, reason)
    if not job or not job.clipboard then
        return 0, 0
    end

    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)

    local rooms = 0
    local defs = 0
    local lights = 0
    local missing = 0
    local seenRooms = {}
    for _, runtime in pairs(job.roomDefRuntimeBySpec or {}) do
        local spec = runtime and runtime.spec or nil
        local room = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)) or nil
        if room and not seenRooms[room] then
            seenRooms[room] = true
            runtime.room = room
            rooms = rooms + 1
            local changedDefs, changedLights = EBFCopyPasteServer.forceRoomLightsInactive(room, reason)
            defs = defs + changedDefs
            lights = lights + changedLights
        else
            missing = missing + 1
        end
    end

    print("[EBFCopyPaste] RoomDef lightsActive resetado para false: rooms=" .. tostring(rooms)
            .. " defs=" .. tostring(defs)
            .. " roomLights=" .. tostring(lights)
            .. " semRoom=" .. tostring(missing)
            .. " reason=" .. tostring(reason or ""))
    return defs, lights
end

function EBFCopyPasteServer.ensureIsoRoomBuilding(room, cell)
    if not room then
        return false, false
    end

    local building = callMethod(room, "getBuilding") or EBFCopyPasteServer.safeField(room, "building")
    if building then
        return true, false
    end

    if not cell then
        return false, false
    end

    local ok, created = EBFCopyPasteServer.tryCallMethod(room, "CreateBuilding", cell)
    if ok then
        building = callMethod(room, "getBuilding")
                or EBFCopyPasteServer.safeField(room, "building")
                or created
        if building then
            return true, true
        end
    end

    return false, false
end

function EBFCopyPasteServer.ensureRuntimeRoomsHaveBuildings(job, reason)
    if not job or not job.clipboard or not getCell then
        return 0
    end

    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)

    local cell = getCell()
    if not cell then
        return 0
    end

    local rooms = 0
    local okRooms = 0
    local repaired = 0
    local missing = 0
    local seenRooms = {}

    for _, runtime in pairs(job.roomDefRuntimeBySpec or {}) do
        local spec = runtime and runtime.spec or nil
        local room = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)) or nil
        if room and not seenRooms[room] then
            seenRooms[room] = true
            runtime.room = room
            rooms = rooms + 1
            local hasBuilding, wasRepaired = EBFCopyPasteServer.ensureIsoRoomBuilding(room, cell)
            if hasBuilding then
                okRooms = okRooms + 1
                if wasRepaired then
                    repaired = repaired + 1
                end
            else
                missing = missing + 1
            end
        elseif runtime then
            missing = missing + 1
        end
    end

    job.runtimeRoomBuildingAudit = {
        rooms = rooms,
        ok = okRooms,
        repaired = repaired,
        missing = missing,
        reason = reason,
    }

    print("[EBFCopyPaste] RoomDef building audit: rooms=" .. tostring(rooms)
            .. " ok=" .. tostring(okRooms)
            .. " reparados=" .. tostring(repaired)
            .. " semBuilding=" .. tostring(missing)
            .. " reason=" .. tostring(reason or ""))
    return missing
end

local function safehouseStringListContains(list, username)
    username = tostring(username or "")
    if username == "" or type(list) ~= "table" then
        return false
    end
    for _, value in ipairs(list) do
        if tostring(value or "") == username then
            return true
        end
    end
    return false
end

local function addSafehouseMember(safehouse, username, owner)
    username = tostring(username or "")
    owner = tostring(owner or "")
    if username == "" or username == owner or not safehouse then
        return
    end
    if safehouse.addPlayer then
        pcall(function()
            safehouse:addPlayer(username)
        end)
    end
end

local function restoreSafehouseMetadata(job)
    if not job or not job.clipboard or not job.clipboard.safehouse then
        return false, "La copia de seguridad no contiene metadatos de la casa segura."
    end
    if not SafeHouse or not SafeHouse.addSafeHouse then
        return false, "La API de SafeHouse no está disponible."
    end

    local clipboard = job.clipboard
    local safehouseData = clipboard.safehouse or {}
    local record = job.restoreRecord or {}
    local x = tonumber(job.targetX) or tonumber(record.originalX) or tonumber(safehouseData.x) or tonumber(clipboard.x) or 0
    local y = tonumber(job.targetY) or tonumber(record.originalY) or tonumber(safehouseData.y) or tonumber(clipboard.y) or 0
    local w = math.max(1, tonumber(safehouseData.w) or tonumber(clipboard.w) or 1)
    local h = math.max(1, tonumber(safehouseData.h) or tonumber(clipboard.h) or 1)
    local title = sanitizeSaveName(record.name or safehouseData.title or clipboard.title or "Safehouse")
    local owner = tostring(record.owner or safehouseData.owner or "")
    if owner == "" then
        owner = getPlayerKey(job.playerObj)
    end

    local safehouse = nil
    if SafeHouse.getSafehouseOverlapping then
        local ok, existing = pcall(function()
            return SafeHouse.getSafehouseOverlapping(x, y, x + w - 1, y + h - 1)
        end)
        if ok then
            safehouse = existing
        end
    end
    if not safehouse and SafeHouse.getSafeHouse then
        local ok, existing = pcall(function()
            return SafeHouse.getSafeHouse(x, y, w, h)
        end)
        if ok then
            safehouse = existing
        end
    end
    if not safehouse then
        local ok, created = pcall(function()
            return SafeHouse.addSafeHouse(x, y, w, h, owner)
        end)
        if ok then
            safehouse = created
        end
    end
    if not safehouse then
        return false, "No se ha podido crear la SafeHouse vanilla."
    end

    callMethod(safehouse, "setX", x)
    callMethod(safehouse, "setY", y)
    callMethod(safehouse, "setW", w)
    callMethod(safehouse, "setH", h)
    callMethod(safehouse, "setOwner", owner)
    callMethod(safehouse, "setTitle", title)
    callMethod(safehouse, "setLocation", tostring(safehouseData.location or record.location or ""))
    callMethod(safehouse, "setLastVisited", tonumber(safehouseData.lastVisited or record.lastVisited) or 0)
    local createdAt = tonumber(safehouseData.datetimeCreated or record.datetimeCreated) or 0
    if createdAt > 0 then
        callMethod(safehouse, "setDatetimeCreated", createdAt)
    end
    local hitPoints = tonumber(safehouseData.hitPoints or record.hitPoints) or 0
    if hitPoints > 0 then
        callMethod(safehouse, "setHitPoints", hitPoints)
    end

    local members = copyStringList(record.members or safehouseData.members)
    local respawnMembers = copyStringList(record.respawnMembers or safehouseData.respawnMembers)
    clearJavaList(callMethod(safehouse, "getPlayers"))
    for _, username in ipairs(members) do
        addSafehouseMember(safehouse, username, owner)
    end

    clearJavaList(callMethod(safehouse, "getPlayersRespawn"))
    for _, username in ipairs(respawnMembers) do
        username = tostring(username or "")
        if username ~= "" and safehouse.setRespawnInSafehouse then
            pcall(function()
                safehouse:setRespawnInSafehouse(true, username)
            end)
            if username ~= owner and not safehouseStringListContains(members, username) then
                addSafehouseMember(safehouse, username, owner)
            end
        end
    end

    if SafeHouse.updateSafehousePlayersConnected then
        pcall(SafeHouse.updateSafehousePlayersConnected)
    end
    if GameServer and GameServer.sendSafehouse then
        pcall(function()
            GameServer.sendSafehouse(safehouse)
        end)
    end
    if triggerEvent then
        triggerEvent("OnSafehousesChanged")
    end
    return true, nil
end

local finalizePastedLightSwitches
local finalizePastedLightSwitchEntry

local function failPasteJob(key, job, message)
    if EBFCopyPasteServer.printPasteDiagnosticReport then
        EBFCopyPasteServer.printPasteDiagnosticReport(job, "failed")
    end
    EBFCopyPasteServer.logStage(job, nil, "PEGADO fallido: " .. tostring(message or "No se ha podido pegar la zona.")
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    EBFCopyPasteServer.pasteJobs[key] = nil
    sendFeedback(job and job.playerObj or nil, {
        action = job and job.restoreSafehouse and "safehouseRestore" or "paste",
        ok = false,
        id = job and job.restoreSaveId or nil,
        title = job and job.restoreName or nil,
        restoreIndex = job and job.restoreIndex or nil,
        restoreTotal = job and job.restoreTotal or nil,
        message = message or "No se ha podido pegar la zona.",
    })
end

local function finishPasteJob(key, job)
    if EBFCopyPasteServer.printPasteDiagnosticReport then
        EBFCopyPasteServer.printPasteDiagnosticReport(job, "completed")
    end
    EBFCopyPasteServer.pasteJobs[key] = nil
    if EBFCopyPasteServer.clearPasteMarkersForJob then
        EBFCopyPasteServer.clearPasteMarkersForJob(job)
    end
    local detachedRooms = tonumber(job and job.detachedRooms) or 0
    local verification = job and job.verification or {}
    local finalizedLights = tonumber(job and job.finalizedLights) or 0
    local finalizedFunctional = tonumber(job and job.finalizedFunctional) or 0
    local verifyFieldSummary = formatScannerCountMap(verification.fieldCounts, 16)
    EBFCopyPasteServer.logStage(job, nil, "PEGADO completado: pegados=" .. tostring(job and job.pasted or 0)
            .. " luzesFinalizadas=" .. tostring(finalizedLights)
            .. " dispositivosFinalizados=" .. tostring(finalizedFunctional)
            .. " tvFinalizadas=" .. tostring(job and job.televisionsFinalized or 0)
            .. " tvDeviceUnsafe=" .. tostring(job and job.televisionsUnsafeDeviceData or 0)
            .. " vanillaRoomBindings=" .. tostring(job and job.vanillaRoomLightBindingsApplied or 0)
            .. " vanillaRoomFalhas=" .. tostring(job and ((job.vanillaRoomLightBindingFailures or 0)
                    + (job.vanillaRoomLightAuditFailures or 0)) or 0)
            .. " exactLampBindingsIgnorados=" .. tostring(job and job.exactLightBindingsSkippedMoveableLamp or 0)
            .. " lightRoomLinksBloqueados=" .. tostring(job and job.roomRuntimeSwitchRoomFallbackBlocked or 0)
            .. " lightRoomLinksRemovidos=" .. tostring(job and job.roomRuntimeSwitchesDetached or 0)
            .. " lightSwitchesAuditados=" .. tostring(job and job.roomRuntimeSwitchesAudited or 0)
            .. " roomSwitchListsRuntimeLimpas=" .. tostring(job and job.runtimeRoomSwitchListsClearedFinal or 0)
            .. " roomLightsRuntimeLimpos=" .. tostring(job and job.runtimeRoomLightsClearedFinal or 0)
            .. " immediateTransmits=" .. tostring(job and job.pasteImmediateTransmits or 0)
            .. " detachedRooms=" .. tostring(detachedRooms)
            .. " verifyChecked=" .. tostring(verification.checked or 0)
            .. " verifyMissing=" .. tostring(verification.missing or 0)
            .. " verifyMismatch=" .. tostring(verification.mismatched or 0)
            .. " verifyExtra=" .. tostring(verification.extraObjects or 0)
            .. " verifyFields=" .. tostring(verifyFieldSummary ~= "" and verifyFieldSummary or "ninguno")
            .. " clientFinalAck=" .. tostring(job and job.finalClientAckOk == true)
            .. " clientSquares=" .. tostring(job and job.finalClientAckSquares or 0)
            .. "/" .. tostring(job and job.finalClientAckExpectedSquares or 0)
            .. " clientMaterialized=" .. tostring(job and job.finalClientAckMaterializedSquares or 0)
            .. " clientChunksLight=" .. tostring(job and job.finalClientAckChunksLight or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    for i, sample in ipairs(verification.samples or {}) do
        if i > 8 then
            break
        end
        local detailText = tostring(sample.details or "")
        if type(sample.details) == "table" then
            local parts = {}
            for _, diff in ipairs(sample.details) do
                if type(diff) == "table" then
                    table.insert(parts, tostring(diff.field)
                            .. "=" .. EBFCopyPasteServer.auditValue(diff.source)
                            .. "->" .. EBFCopyPasteServer.auditValue(diff.target))
                else
                    table.insert(parts, tostring(diff))
                end
                if #parts >= 6 then
                    break
                end
            end
            detailText = table.concat(parts, "; ")
        end
        EBFCopyPasteServer.logStage(job, nil, "VERIFY amostra " .. tostring(i)
                .. ": status=" .. tostring(sample.status)
                .. " pos=" .. tostring(sample.dx) .. "," .. tostring(sample.dy) .. "," .. tostring(sample.dz)
                .. " sprite=" .. tostring(sample.sprite)
                .. " class=" .. tostring(sample.objectClass)
                .. " detalhes=" .. detailText)
    end
    if job.restoreSafehouse then
        local metadataOk, metadataMessage = restoreSafehouseMetadata(job)
        sendFeedback(job.playerObj, {
            action = "safehouseRestoreDone",
            ok = true,
            id = job.restoreSaveId,
            title = job.restoreName,
            restoreIndex = job.restoreIndex,
            restoreTotal = job.restoreTotal,
            x = job.targetX,
            y = job.targetY,
            z = job.targetZ,
            w = job.clipboard.w,
            h = job.clipboard.h,
            levels = job.clipboard.levels,
            count = job.pasted or 0,
            lights = finalizedLights,
            devices = finalizedFunctional,
            detachedRooms = detachedRooms,
            verification = job.verification,
            finalClientAck = job.finalClientAckOk == true,
            metadataOk = metadataOk == true,
            metadataMessage = metadataMessage,
        })
        return
    end
    sendFeedback(job.playerObj, {
        action = "paste",
        ok = true,
        x = job.targetX,
        y = job.targetY,
        z = job.targetZ,
        w = job.clipboard.w,
        h = job.clipboard.h,
        levels = job.clipboard.levels,
        count = job.pasted or 0,
        lights = finalizedLights,
        devices = finalizedFunctional,
        detachedRooms = detachedRooms,
        verification = job.verification,
        finalClientAck = job.finalClientAckOk == true,
    })
end

local clearSquare
local pasteFloor
local pasteObject
local startPasteFinalizeMove
local startPasteFinalizeRooms
local startPasteDeferredLights

local function refreshSquareSystems(square)
    if not square then
        return
    end
    if EBFCopyPasteServer.squareHasLoadedChunk
            and not EBFCopyPasteServer.squareHasLoadedChunk(square) then
        return
    end

    callMethod(square, "EnsureSurroundNotNull")
    square:RecalcProperties()
    square:RecalcAllWithNeighbours(true)
    if EBFCopyPasteServer.removeUndergroundPlaceholders then
        EBFCopyPasteServer.removeUndergroundPlaceholders(square)
    end

    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end
end

function EBFCopyPasteServer.squareHasValidRoomDef(square)
    local room = square and callMethod(square, "getRoom") or nil
    return room ~= nil and callMethod(room, "getRoomDef") ~= nil
end

function EBFCopyPasteServer.pasteRoomRectOverlapsExistingRoom(absX, absY, absZ, width, height)
    local cell = getCell and getCell() or nil
    if not cell then
        return true
    end
    local metaGrid = EBFCopyPasteServer.getWorldMetaGrid()

    for y = 0, math.max(0, height - 1) do
        for x = 0, math.max(0, width - 1) do
            local roomDef = metaGrid and callMethod(metaGrid, "getRoomAt", absX + x, absY + y, absZ) or nil
            if roomDef and callMethod(roomDef, "isEmptyOutside") ~= true then
                return true
            end

            local square = cell:getGridSquare(absX + x, absY + y, absZ)
            if EBFCopyPasteServer.squareHasValidRoomDef(square) then
                return true
            end
        end
    end
    return false
end

function EBFCopyPasteServer.getPasteRoomBounds(job)
    if not job or not job.clipboard then
        return nil
    end

    local minOffset, maxOffset = getClipboardZRange(job.clipboard)
    local minX = EBFCopyPaste.toInt(job.targetX, 0)
    local minY = EBFCopyPaste.toInt(job.targetY, 0)
    local minZ = EBFCopyPaste.toInt(job.targetZ, 0) + minOffset
    return {
        minX = minX,
        minY = minY,
        minZ = minZ,
        maxX = minX + math.max(1, EBFCopyPaste.toInt(job.clipboard.w, 1)),
        maxY = minY + math.max(1, EBFCopyPaste.toInt(job.clipboard.h, 1)),
        maxZ = EBFCopyPaste.toInt(job.targetZ, 0) + maxOffset,
    }
end

function EBFCopyPasteServer.roomRectIntersectsPasteArea(job, room, rect)
    local bounds = EBFCopyPasteServer.getPasteRoomBounds(job)
    if not bounds or not room or not rect then
        return false
    end

    local level = tonumber(callMethod(room, "getLevel"))
    local rectX = tonumber(callMethod(rect, "getX"))
    local rectY = tonumber(callMethod(rect, "getY"))
    local rectW = tonumber(callMethod(rect, "getW"))
    local rectH = tonumber(callMethod(rect, "getH"))
    if not level or not rectX or not rectY or not rectW or not rectH then
        return false
    end

    local rectMaxX = rectX + math.max(1, rectW)
    local rectMaxY = rectY + math.max(1, rectH)
    return level >= bounds.minZ
            and level <= bounds.maxZ
            and rectX < bounds.maxX
            and rectMaxX > bounds.minX
            and rectY < bounds.maxY
            and rectMaxY > bounds.minY
end

function EBFCopyPasteServer.countRoomRectIntersectionsInEditor(editor, job)
    if not editor or not job then
        return 0
    end

    local intersections = 0
    local buildingCount = tonumber(callMethod(editor, "getBuildingCount")) or 0
    for buildingIndex = 0, buildingCount - 1 do
        local building = callMethod(editor, "getBuildingByIndex", buildingIndex)
        local roomCount = tonumber(callMethod(building, "getRoomCount")) or 0
        for roomIndex = 0, roomCount - 1 do
            local room = callMethod(building, "getRoomByIndex", roomIndex)
            local rectCount = tonumber(callMethod(room, "getRectangleCount")) or 0
            for rectIndex = 0, rectCount - 1 do
                local rect = callMethod(room, "getRectangle", rectIndex)
                if EBFCopyPasteServer.roomRectIntersectsPasteArea(job, room, rect) then
                    intersections = intersections + 1
                end
            end
        end
    end
    return intersections
end

function EBFCopyPasteServer.initBuildingRoomsEditorForPaste(editor, job)
    if not editor or not job or not job.clipboard or not editor.init then
        return false
    end

    local centerX = EBFCopyPaste.toInt(job.targetX, 0)
            + math.floor(math.max(1, EBFCopyPaste.toInt(job.clipboard.w, 1)) / 2)
    local centerY = EBFCopyPaste.toInt(job.targetY, 0)
            + math.floor(math.max(1, EBFCopyPaste.toInt(job.clipboard.h, 1)) / 2)
    local ok = pcall(function()
        editor:init(centerX, centerY)
    end)
    return ok == true
end

function EBFCopyPasteServer.setCurrentPasteBuilding(editor, building)
    if not editor or not building then
        return false
    end
    if editor.setCurrentBuilding then
        pcall(function()
            editor:setCurrentBuilding(building)
        end)
    end
    return true
end

function EBFCopyPasteServer.setCurrentPasteRoom(editor, room)
    if not editor or not room then
        return false
    end
    if editor.setCurrentRoom then
        pcall(function()
            editor:setCurrentRoom(room)
        end)
    end
    return true
end

function EBFCopyPasteServer.getBuildingRoomsEditorForPaste(job)
    if EBFCopyPaste.ensureJavaRoomDefBridge then
        EBFCopyPaste.ensureJavaRoomDefBridge()
    end
    if not EBFCopyPasteServer.allowPersistentRoomDefWrites() then
        return nil, "La reconstrucción de RoomDef está desactivada."
    end

    if not BuildingRoomsEditor then
        return nil, "El juego no expone BuildingRoomsEditor."
    end

    if BuildingRoomsEditor.Reset then
        pcall(function()
            BuildingRoomsEditor.Reset()
        end)
    end

    local ok, editor = pcall(function()
        if BuildingRoomsEditor.getInstance then
            return BuildingRoomsEditor.getInstance()
        end
        return nil
    end)
    if not ok or not editor then
        return nil, "No se ha podido obtener BuildingRoomsEditor."
    end
    EBFCopyPasteServer.initBuildingRoomsEditorForPaste(editor, job)
    return editor, nil
end

function EBFCopyPasteServer.canSavePlayerRoomsFile()
    if EBFCopyPaste.ensureJavaRoomDefBridge then
        EBFCopyPaste.ensureJavaRoomDefBridge()
    end
    if not EBFCopyPasteServer.allowPersistentRoomDefWrites() then
        return false, "La reconstrucción de RoomDef está desactivada."
    end
    if EBFCopyPaste.SaveRebuiltRoomDefs == false then
        return false, "SaveRebuiltRoomDefs=false."
    end
    if not PlayerRoomsFile then
        return false, "No se ha podido enlazar zombie.buildingRooms.PlayerRoomsFile mediante luajava. Sin PlayerRoomsFile.save, BuildingRoomsEditor.applyChanges crearía RoomDef solo en tiempo de ejecución y podría dejar roomID/metaID huérfanos."
    end
    return true, nil
end

function EBFCopyPasteServer.trySavePlayerRoomsFile()
    local canSave, reason = EBFCopyPasteServer.canSavePlayerRoomsFile()
    if canSave == false then
        return false, reason
    end
    if canSave == nil then
        return false, reason or "La persistencia de PlayerRoomsFile no está disponible."
    end

    local ok, file = pcall(function()
        if PlayerRoomsFile.new then
            return PlayerRoomsFile.new()
        end
        return PlayerRoomsFile()
    end)
    if not ok or not file then
        return false, "No se ha podido crear PlayerRoomsFile: " .. tostring(file)
    end

    local saveOk, saveError = pcall(function()
        callMethod(file, "save")
    end)
    if saveOk ~= true then
        return false, "PlayerRoomsFile.save ha fallado: " .. tostring(saveError)
    end
    return true, nil
end

function EBFCopyPasteServer.clearClipboardRoomDefsAtTarget(job)
    if not job or not job.clipboard or job.roomDefCleanupAttempted == true then
        return 0
    end
    job.roomDefCleanupAttempted = true

    if not EBFCopyPasteServer.allowPersistentRoomDefWrites() then
        return 0
    end

    local editor = EBFCopyPasteServer.getBuildingRoomsEditorForPaste(job)
    if not editor then
        return 0
    end

    local changed = 0
    local buildingCount = tonumber(callMethod(editor, "getBuildingCount")) or 0
    for buildingIndex = buildingCount - 1, 0, -1 do
        local building = callMethod(editor, "getBuildingByIndex", buildingIndex)
        local roomCount = tonumber(callMethod(building, "getRoomCount")) or 0
        for roomIndex = roomCount - 1, 0, -1 do
            local room = callMethod(building, "getRoomByIndex", roomIndex)
            local rectCount = tonumber(callMethod(room, "getRectangleCount")) or 0
            for rectIndex = rectCount - 1, 0, -1 do
                local rect = callMethod(room, "getRectangle", rectIndex)
                if EBFCopyPasteServer.roomRectIntersectsPasteArea(job, room, rect) then
                    local okRemove = pcall(function()
                        room:removeRectangle(rectIndex)
                    end)
                    if okRemove then
                        changed = changed + 1
                    end
                end
            end

            if room and (tonumber(callMethod(room, "getRectangleCount")) or 0) <= 0 then
                pcall(function()
                    building:removeRoom(room)
                end)
            end
        end

        if building and (tonumber(callMethod(building, "getRoomCount")) or 0) <= 0 then
            pcall(function()
                editor:removeBuilding(building)
            end)
        end
    end

    if changed > 0 then
        local okApply, applyError = pcall(function()
            editor:applyChanges(false)
        end)
        if okApply then
            local saved, saveError = EBFCopyPasteServer.trySavePlayerRoomsFile()
            if saved ~= true then
                job.roomDefCleanupFailed = true
                job.roomDefCleanupSaveFailed = true
                job.roomDefCleanupSaveError = tostring(saveError)
                print("[EBFCopyPaste] No se ha podido guardar la limpieza de RoomDef antiguos: " .. tostring(saveError))
            elseif saveError then
                print("[EBFCopyPaste] AVISO de limpieza de RoomDef: " .. tostring(saveError))
            end
            job.roomDefRuntimeBySpec = nil
            job.roomDefRuntimeByKey = nil
            EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
            print("[EBFCopyPaste] RoomDef antiguos eliminados por intersección con la zona de destino: rectángulos="
                    .. tostring(changed))
        else
            print("[EBFCopyPaste] No se han podido limpiar los RoomDef antiguos: " .. tostring(applyError))
            job.roomDefCleanupFailed = true
        end
    end

    local remaining = EBFCopyPasteServer.countRoomRectIntersectionsInEditor(editor, job)
    job.roomDefCleanupRemainingIntersections = remaining
    print("[EBFCopyPaste] AUDITORÍA de limpieza de RoomDef del destino: eliminados="
            .. tostring(changed)
            .. " restantesIntersecao=" .. tostring(remaining)
            .. " alvo=" .. tostring(job.targetX) .. "," .. tostring(job.targetY) .. "," .. tostring(job.targetZ))
    if remaining > 0 then
        job.roomDefCleanupFailed = true
    end

    if BuildingRoomsEditor and BuildingRoomsEditor.Reset then
        pcall(function()
            BuildingRoomsEditor.Reset()
        end)
    end
    return changed
end

function EBFCopyPasteServer.getWorldMetaGrid()
    local world = nil
    if type(getWorld) == "function" then
        local okWorld, result = pcall(getWorld)
        if okWorld then
            world = result
        end
    end

    local metaGrid = callMethod(world, "getMetaGrid")
    if metaGrid then
        return metaGrid
    end

    if IsoWorld and IsoWorld.instance then
        return callMethod(IsoWorld.instance, "getMetaGrid")
    end
    return nil
end

function EBFCopyPasteServer.getRoomDefId(roomDef)
    if not roomDef then
        return -1
    end

    local id = callMethod(roomDef, "getID")
    if id == nil then
        id = callMethod(roomDef, "getId")
    end
    if id ~= nil then
        return id
    end
    return -1
end

function EBFCopyPasteServer.getRoomDefIdString(roomDef)
    if not roomDef then
        return nil
    end

    local idString = callMethod(roomDef, "getIDString")
    if idString ~= nil then
        return tostring(idString)
    end

    local id = EBFCopyPasteServer.getRoomDefId(roomDef)
    if id ~= nil and id ~= -1 then
        return tostring(id)
    end
    return nil
end

function EBFCopyPasteServer.forEachRoomSpecTile(spec, callback)
    if not spec or type(callback) ~= "function" then
        return 0
    end

    local count = 0
    local dz = EBFCopyPaste.toInt(spec.dz, 0)
    if type(spec.tileMask) == "table" and #spec.tileMask > 0 then
        for _, tile in ipairs(spec.tileMask) do
            local dx = EBFCopyPaste.toInt(tile.x, nil)
            local dy = EBFCopyPaste.toInt(tile.y, nil)
            if dx ~= nil and dy ~= nil then
                count = count + 1
                callback(dx, dy, dz, count)
            end
        end
        return count
    end

    for _, rect in ipairs(spec.rects or {}) do
        local startX = EBFCopyPaste.toInt(rect.x, 0)
        local startY = EBFCopyPaste.toInt(rect.y, 0)
        local w = math.max(1, EBFCopyPaste.toInt(rect.w, 1))
        local h = math.max(1, EBFCopyPaste.toInt(rect.h, 1))
        for y = startY, startY + h - 1 do
            for x = startX, startX + w - 1 do
                count = count + 1
                callback(x, y, dz, count)
            end
        end
    end
    return count
end

function EBFCopyPasteServer.getRoomSpecTileCount(spec)
    return EBFCopyPasteServer.forEachRoomSpecTile(spec, function()
    end)
end

function EBFCopyPasteServer.formatRoomSpecRectSummary(spec)
    if not spec or type(spec.rects) ~= "table" or #spec.rects <= 0 then
        return "rects=0"
    end

    local parts = {}
    local maxRects = math.min(#spec.rects, 12)
    for index = 1, maxRects do
        local rect = spec.rects[index]
        parts[#parts + 1] = tostring(EBFCopyPaste.toInt(rect.x, 0))
                .. "," .. tostring(EBFCopyPaste.toInt(rect.y, 0))
                .. " " .. tostring(math.max(1, EBFCopyPaste.toInt(rect.w, 1)))
                .. "x" .. tostring(math.max(1, EBFCopyPaste.toInt(rect.h, 1)))
    end
    if #spec.rects > maxRects then
        parts[#parts + 1] = "...+" .. tostring(#spec.rects - maxRects)
    end
    return "rects=" .. tostring(#spec.rects) .. " [" .. table.concat(parts, ";") .. "]"
end

function EBFCopyPasteServer.formatRoomSpecTileSample(job, spec, maxTiles)
    if not spec then
        return "tiles=0"
    end

    local targetX = EBFCopyPaste.toInt(job and job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job and job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job and job.targetZ, 0)
    local maxCount = math.max(1, tonumber(maxTiles) or 12)
    local total = 0
    local parts = {}
    EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
        total = total + 1
        if #parts < maxCount then
            parts[#parts + 1] = tostring(targetX + dx) .. "," .. tostring(targetY + dy) .. "," .. tostring(targetZ + dz)
        end
    end)
    if total > #parts then
        parts[#parts + 1] = "...+" .. tostring(total - #parts)
    end
    return "tiles=" .. tostring(total) .. " sample=[" .. table.concat(parts, ";") .. "]"
end

function EBFCopyPasteServer.logRoomSpecDiagnostics(job, phase)
    if not job or not job.clipboard then
        return 0
    end

    local roomSpecs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard) or {}
    print("[EBFCopyPaste][RoomAudit][" .. tostring(phase or "room") .. "] specs=" .. tostring(#roomSpecs)
            .. " target=" .. tostring(job.targetX) .. "," .. tostring(job.targetY) .. "," .. tostring(job.targetZ))
    for index, spec in ipairs(roomSpecs) do
        local runtime = EBFCopyPasteServer.getRuntimeRoomForSpecTile(job, spec)
        local room = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)) or nil
        local roomDef = room and callMethod(room, "getRoomDef") or runtime and runtime.roomDef or nil
        print("[EBFCopyPaste][RoomAudit][" .. tostring(phase or "room") .. "] spec#" .. tostring(index)
                .. " key=" .. tostring(spec.key or "?")
                .. " name=" .. tostring(spec.name or spec.sourceRoomDefName or "?")
                .. " dz=" .. tostring(EBFCopyPaste.toInt(spec.dz, 0))
                .. " " .. EBFCopyPasteServer.formatRoomSpecRectSummary(spec)
                .. " " .. EBFCopyPasteServer.formatRoomSpecTileSample(job, spec, 10)
                .. " runtimeDef=" .. EBFCopyPasteServer.auditValue(EBFCopyPasteServer.getRoomDefId(roomDef))
                .. " runtime={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
    end
    return #roomSpecs
end

function EBFCopyPasteServer.roomSpecContainsEntry(spec, entry)
    if not spec or not entry then
        return false
    end

    local entryDz = EBFCopyPaste.toInt(entry.dz, 0)
    if EBFCopyPaste.toInt(spec.dz, 0) ~= entryDz then
        return false
    end

    local dx = EBFCopyPaste.toInt(entry.dx, nil)
    local dy = EBFCopyPaste.toInt(entry.dy, nil)
    if dx == nil or dy == nil then
        return false
    end

    local found = false
    EBFCopyPasteServer.forEachRoomSpecTile(spec, function(tileDx, tileDy)
        if dx == tileDx and dy == tileDy then
            found = true
        end
    end)
    return found
end

function EBFCopyPasteServer.roomDefMatchesRuntime(roomDef, runtime)
    if not roomDef or not runtime then
        return false
    end
    if runtime.roomDef and roomDef == runtime.roomDef then
        return true
    end
    local roomDefIDString = EBFCopyPasteServer.getRoomDefIdString(roomDef)
    if runtime.roomIDString and roomDefIDString and roomDefIDString == runtime.roomIDString then
        return true
    end
    if runtime.roomIDString or roomDefIDString then
        return false
    end

    local runtimeID = tonumber(runtime.roomID)
    local roomDefID = tonumber(EBFCopyPasteServer.getRoomDefId(roomDef))
    if runtimeID ~= nil and roomDefID ~= nil
            and math.abs(runtimeID) < 9007199254740992
            and math.abs(roomDefID) < 9007199254740992
            and runtimeID == roomDefID then
        return true
    end
    return false
end

function EBFCopyPasteServer.squareRoomMatchesRuntime(square, runtime)
    local room = square and callMethod(square, "getRoom") or nil
    local roomDef = room and callMethod(room, "getRoomDef") or nil
    return EBFCopyPasteServer.roomDefMatchesRuntime(roomDef, runtime)
end

function EBFCopyPasteServer.getRuntimeRoomFromRoomDef(roomDef, metaGrid)
    if not roomDef then
        return nil
    end

    local room = callMethod(roomDef, "getIsoRoom")
    if room then
        return room
    end

    local roomID = EBFCopyPasteServer.getRoomDefId(roomDef)
    if roomID ~= nil and roomID ~= -1 then
        metaGrid = metaGrid or EBFCopyPasteServer.getWorldMetaGrid()
        room = metaGrid and callMethod(metaGrid, "getRoomByID", roomID) or nil
        if room then
            return room
        end
    end
    return nil
end

function EBFCopyPasteServer.applyRoomDefToSquare(square, roomDef, metaGrid, shouldRefresh)
    if not square then
        return false, nil
    end
    if EBFCopyPasteServer.squareHasLoadedChunk
            and not EBFCopyPasteServer.squareHasLoadedChunk(square) then
        return false, nil
    end

    if not roomDef or callMethod(roomDef, "isEmptyOutside") == true then
        EBFCopyPasteServer.tryCallMethod(square, "setRoomID", -1)
        EBFCopyPasteServer.tryCallMethod(square, "setRoom", nil)
        if shouldRefresh ~= false then
            EBFCopyPasteServer.refreshSquareAfterRoomDef(square)
        end
        return true, nil
    end

    local roomID = EBFCopyPasteServer.getRoomDefId(roomDef)
    if roomID == nil or roomID == -1 then
        return false, nil
    end

    local runtime = {
        roomDef = roomDef,
        roomID = roomID,
        roomIDString = EBFCopyPasteServer.getRoomDefIdString(roomDef),
    }
    local setID = EBFCopyPasteServer.tryCallMethod(square, "setRoomID", roomID)
    local room = callMethod(square, "getRoom")
    local roomDefObject = room and callMethod(room, "getRoomDef") or nil
    if room and not EBFCopyPasteServer.roomDefMatchesRuntime(roomDefObject, runtime) then
        room = nil
    end
    if not room then
        room = EBFCopyPasteServer.getRuntimeRoomFromRoomDef(roomDef, metaGrid)
        if room then
            EBFCopyPasteServer.tryCallMethod(square, "setRoom", room)
        end
    end

    roomDefObject = room and callMethod(room, "getRoomDef") or callMethod(square, "getRoomDef")
    local matched = EBFCopyPasteServer.roomDefMatchesRuntime(roomDefObject, runtime)
    if not matched then
        local correctRoom = EBFCopyPasteServer.getRuntimeRoomFromRoomDef(roomDef, metaGrid)
        if correctRoom then
            room = correctRoom
            EBFCopyPasteServer.tryCallMethod(square, "setRoom", room)
        elseif room then
            EBFCopyPasteServer.tryCallMethod(square, "setRoom", room)
        end
        roomDefObject = callMethod(square, "getRoomDef")
        matched = EBFCopyPasteServer.roomDefMatchesRuntime(roomDefObject, runtime)
    end

    if shouldRefresh ~= false then
        EBFCopyPasteServer.refreshSquareAfterRoomDef(square)
    end
    return (setID == true and matched == true), room
end

function EBFCopyPasteServer.setSquareRuntimeRoom(square, runtime)
    if not square or not runtime then
        return false
    end

    if EBFCopyPasteServer.squareRoomMatchesRuntime(square, runtime) then
        return true
    end

    if runtime.roomDef then
        local applied, room = EBFCopyPasteServer.applyRoomDefToSquare(square, runtime.roomDef, nil, true)
        if applied and room then
            runtime.room = room
        end
    else
        EBFCopyPasteServer.refreshSquareAfterRoomDef(square)
    end
    return EBFCopyPasteServer.squareRoomMatchesRuntime(square, runtime)
end

function EBFCopyPasteServer.auditAndAlignRuntimeRoomSpecTiles(job)
    if not job or not job.clipboard or not getCell then
        return 0
    end

    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    local cell = getCell()
    if not cell then
        return 0
    end

    local targetX = EBFCopyPaste.toInt(job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
    local matched = 0
    local fixed = 0
    local missing = 0
    local unmapped = 0
    local total = 0
    local rooms = 0
    local uniqueRuntimeRoomDefs = 0
    local duplicateRuntimeRoomDefs = 0
    local seenRuntimeRoomDefs = {}

    local roomSpecs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard) or {}
    for _, spec in ipairs(roomSpecs) do
        local runtime = job.roomDefRuntimeBySpec and job.roomDefRuntimeBySpec[spec] or nil
        if not runtime and spec.key and job.roomDefRuntimeByKey then
            runtime = job.roomDefRuntimeByKey[spec.key]
        end
        if runtime then
            rooms = rooms + 1
            local runtimeKey = runtime.roomIDString
                    or EBFCopyPasteServer.getRoomDefIdString(runtime.roomDef)
                    or tostring(runtime.roomDef or runtime.room or spec.key or "")
            if runtimeKey ~= "" then
                if seenRuntimeRoomDefs[runtimeKey] then
                    duplicateRuntimeRoomDefs = duplicateRuntimeRoomDefs + 1
                else
                    seenRuntimeRoomDefs[runtimeKey] = true
                    uniqueRuntimeRoomDefs = uniqueRuntimeRoomDefs + 1
                end
            end
        end

        EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
            total = total + 1
            if not runtime then
                unmapped = unmapped + 1
                return
            end

            local square = callMethod(cell, "getGridSquare", targetX + dx, targetY + dy, targetZ + dz)
                    or getOrCreateSquare(targetX + dx, targetY + dy, targetZ + dz)
            if not square then
                missing = missing + 1
                return
            end

            if EBFCopyPasteServer.squareRoomMatchesRuntime(square, runtime) then
                matched = matched + 1
            elseif EBFCopyPasteServer.setSquareRuntimeRoom(square, runtime) then
                fixed = fixed + 1
            else
                missing = missing + 1
            end
        end)
    end

    job.roomMaskAudit = {
        rooms = rooms,
        total = total,
        matched = matched,
        fixed = fixed,
        missing = missing,
        unmapped = unmapped,
        uniqueRoomDefs = uniqueRuntimeRoomDefs,
        duplicateRoomDefs = duplicateRuntimeRoomDefs,
    }

    print("[EBFCopyPaste] RoomDef tileMask audit: rooms="
            .. tostring(rooms)
            .. " tiles=" .. tostring(total)
            .. " ok=" .. tostring(matched)
            .. " realinhados=" .. tostring(fixed)
            .. " ausentes=" .. tostring(missing)
            .. " semRuntime=" .. tostring(unmapped))
    print("[EBFCopyPaste] RoomDef runtime unique audit: specs="
            .. tostring(#roomSpecs)
            .. " mapeados=" .. tostring(rooms)
            .. " uniqueRoomDefs=" .. tostring(uniqueRuntimeRoomDefs)
            .. " duplicados=" .. tostring(duplicateRuntimeRoomDefs))
    return matched + fixed
end

function EBFCopyPasteServer.getRuntimeRoomForSpecTile(job, spec)
    if not job or not spec then
        return nil
    end
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    local runtime = job.roomDefRuntimeBySpec and job.roomDefRuntimeBySpec[spec] or nil
    if not runtime and spec.key and job.roomDefRuntimeByKey then
        runtime = job.roomDefRuntimeByKey[spec.key]
    end
    return runtime
end

function EBFCopyPasteServer.findRuntimeRoomDefOnSpecTiles(job, spec)
    if not job or not spec then
        return nil
    end

    local metaGrid = EBFCopyPasteServer.getWorldMetaGrid()
    if not metaGrid then
        return nil
    end

    local targetX = EBFCopyPaste.toInt(job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
    local found = nil
    EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
        if found then
            return
        end
        local roomDef = callMethod(metaGrid, "getRoomAt", targetX + dx, targetY + dy, targetZ + dz)
        if roomDef and callMethod(roomDef, "isEmptyOutside") ~= true then
            found = roomDef
        end
    end)
    return found
end

function EBFCopyPasteServer.findRuntimeRoomObjectOnSpecTiles(job, spec, runtime)
    if not job or not spec or not getCell then
        return nil
    end

    local cell = getCell()
    if not cell then
        return nil
    end

    local targetX = EBFCopyPaste.toInt(job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
    local found = nil
    EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
        if found then
            return
        end
        local square = callMethod(cell, "getGridSquare", targetX + dx, targetY + dy, targetZ + dz)
                or getOrCreateSquare(targetX + dx, targetY + dy, targetZ + dz)
        if square and runtime and not EBFCopyPasteServer.squareRoomMatchesRuntime(square, runtime) then
            EBFCopyPasteServer.setSquareRuntimeRoom(square, runtime)
        end
        local room = square and callMethod(square, "getRoom") or nil
        local roomDef = room and callMethod(room, "getRoomDef") or nil
        if room and roomDef and EBFCopyPasteServer.roomDefMatchesRuntime(roomDef, runtime) then
            found = room
        end
    end)
    return found
end

function EBFCopyPasteServer.ensureRoomSpecLookup(job)
    if not job or not job.clipboard then
        return nil
    end
    if job.roomSpecsByKey then
        return job.roomSpecsByKey
    end

    local byKey = {}
    local specs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard)
    for _, spec in ipairs(specs or {}) do
        if spec.key then
            byKey[spec.key] = spec
        end
    end
    job.roomSpecsByKey = byKey
    return byKey
end

function EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
    if not job or not entry then
        return nil
    end

    local byKey = EBFCopyPasteServer.ensureRoomSpecLookup(job)
    local key = entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key)
    if key and byKey and byKey[key] then
        return byKey[key]
    end

    local specs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard)
    for _, spec in ipairs(specs or {}) do
        if EBFCopyPasteServer.roomSpecContainsEntry(spec, entry) then
            return spec
        end
    end
    return nil
end

function EBFCopyPasteServer.findRuntimeRoomDefForSpec(job, spec)
    return EBFCopyPasteServer.findRuntimeRoomDefOnSpecTiles(job, spec)
end

function EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)
    return EBFCopyPasteServer.findRuntimeRoomObjectOnSpecTiles(job, spec, runtime)
end

function EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    if not job or not job.clipboard then
        return nil
    end
    if job.roomDefRuntimeBySpec then
        return job.roomDefRuntimeBySpec
    end

    local bySpec = {}
    local byKey = {}
    local created = 0
    local specs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard)
    for _, spec in ipairs(specs or {}) do
        local roomDef = EBFCopyPasteServer.findRuntimeRoomDefForSpec(job, spec)
        if roomDef then
            local runtime = {
                roomDef = roomDef,
                spec = spec,
                roomID = EBFCopyPasteServer.getRoomDefId(roomDef),
                roomIDString = EBFCopyPasteServer.getRoomDefIdString(roomDef),
                runtimeKey = EBFCopyPasteServer.getRoomDefIdString(roomDef) or tostring(spec.key or ""),
                name = callMethod(roomDef, "getName"),
            }
            runtime.room = EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)
            bySpec[spec] = runtime
            if spec.key then
                byKey[spec.key] = runtime
            end
            created = created + 1
        end
    end

    job.roomDefRuntimeBySpec = bySpec
    job.roomDefRuntimeByKey = byKey
    job.roomDefRuntimeMapped = created
    if created > 0 then
        print("[EBFCopyPaste] RoomDef runtime blueprint mapeado: " .. tostring(created) .. " habitaciones")
    end
    return bySpec
end

function EBFCopyPasteServer.getRuntimeRoomForEntry(job, entry)
    if not job or not entry then
        return nil
    end

    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    local key = entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key)
    if key and job.roomDefRuntimeByKey and job.roomDefRuntimeByKey[key] then
        return job.roomDefRuntimeByKey[key]
    end

    local spec = EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
    if spec and job.roomDefRuntimeBySpec then
        return job.roomDefRuntimeBySpec[spec]
    end
    return nil
end

function EBFCopyPasteServer.getRuntimeRoomObjectForEntry(job, entry)
    local runtime = EBFCopyPasteServer.getRuntimeRoomForEntry(job, entry)
    if not runtime then
        return nil
    end

    if runtime.room and callMethod(runtime.room, "getRoomDef") then
        return runtime.room
    end

    local spec = runtime.spec or EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
    if spec then
        runtime.room = EBFCopyPasteServer.findRuntimeRoomForSpec(job, spec, runtime)
    end
    return runtime.room
end

function EBFCopyPasteServer.roomsReferToSameRoomDef(roomA, roomB)
    if not roomA or not roomB then
        return false
    end
    if roomA == roomB then
        return true
    end

    local roomDefA = callMethod(roomA, "getRoomDef")
    local roomDefB = callMethod(roomB, "getRoomDef")
    local idA = EBFCopyPasteServer.getRoomDefIdString(roomDefA)
    local idB = EBFCopyPasteServer.getRoomDefIdString(roomDefB)
    return idA ~= nil and idB ~= nil and tostring(idA) == tostring(idB)
end

function EBFCopyPasteServer.forEachLightSwitchCandidateRoom(job, square, callback)
    if type(callback) ~= "function" then
        return 0
    end

    local visited = 0
    local seenRooms = {}
    local function visit(room)
        if not room or seenRooms[room] then
            return
        end

        seenRooms[room] = true
        visited = visited + 1
        callback(room)

        local building = callMethod(room, "getBuilding") or EBFCopyPasteServer.safeField(room, "building")
        local rooms = building and EBFCopyPasteServer.safeField(building, "rooms") or nil
        local roomCount = EBFCopyPasteServer.getJavaListSize(rooms)
        for index = 0, roomCount - 1 do
            visit(callMethod(rooms, "get", index))
        end
    end

    if job then
        EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
        for _, runtime in pairs(job.roomDefRuntimeBySpec or {}) do
            visit(runtime and runtime.room or nil)
        end
    end

    visit(square and callMethod(square, "getRoom") or nil)

    if job and job.clipboard and getCell then
        local cell = getCell()
        local targetX = EBFCopyPaste.toInt(job.targetX, 0)
        local targetY = EBFCopyPaste.toInt(job.targetY, 0)
        local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
        if cell then
            for _, spec in ipairs(EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard) or {}) do
                EBFCopyPasteServer.forEachRoomSpecTile(spec, function(dx, dy, dz)
                    local sq = callMethod(cell, "getGridSquare", targetX + dx, targetY + dy, targetZ + dz)
                    visit(sq and callMethod(sq, "getRoom") or nil)
                end)
            end
        end
    end

    return visited
end

function EBFCopyPasteServer.removeLightSwitchFromRoom(room, object)
    if not room or not object then
        return 0
    end

    local switches = callMethod(room, "getLightSwitches")
    if not switches then
        return 0
    end

    local removed = 0
    local guard = (tonumber(callMethod(switches, "size")) or 0) + 4
    while guard > 0 and EBFCopyPasteServer.javaListContains(switches, object) do
        guard = guard - 1
        local before = tonumber(callMethod(switches, "size")) or 0
        pcall(function()
            switches:remove(object)
        end)
        local after = tonumber(callMethod(switches, "size")) or 0
        if after < before then
            removed = removed + (before - after)
        else
            local removedByIndex = false
            for index = before - 1, 0, -1 do
                if callMethod(switches, "get", index) == object then
                    local okRemoveIndex = pcall(function()
                        switches:remove(index)
                    end)
                    if okRemoveIndex then
                        local afterIndex = tonumber(callMethod(switches, "size")) or 0
                        if afterIndex < before then
                            removed = removed + (before - afterIndex)
                            removedByIndex = true
                        end
                    end
                    break
                end
            end
            if not removedByIndex then
                break
            end
        end
    end
    return removed
end

function EBFCopyPasteServer.countLightSwitchInRoom(room, object)
    if not room or not object then
        return 0
    end

    local switches = callMethod(room, "getLightSwitches")
    if not switches then
        return 0
    end

    local found = 0
    local size = tonumber(callMethod(switches, "size")) or 0
    for index = 0, size - 1 do
        if callMethod(switches, "get", index) == object then
            found = found + 1
        end
    end
    return found
end

function EBFCopyPasteServer.removeLightSwitchFromRuntimeRooms(job, object)
    if not job or not object then
        return 0
    end

    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    local removed = 0
    local seenRooms = {}
    for _, runtime in pairs(job.roomDefRuntimeBySpec or {}) do
        local room = runtime and runtime.room or nil
        if room and not seenRooms[room] then
            seenRooms[room] = true
            removed = removed + EBFCopyPasteServer.removeLightSwitchFromRoom(room, object)
        end
    end
    return removed
end

function EBFCopyPasteServer.removeLightSwitchFromKnownPasteRooms(job, square, object)
    if not object then
        return 0
    end

    local removed = 0
    EBFCopyPasteServer.forEachLightSwitchCandidateRoom(job, square, function(room)
        removed = removed + EBFCopyPasteServer.removeLightSwitchFromRoom(room, object)
    end)

    return removed
end

function EBFCopyPasteServer.countLightSwitchLinksInKnownPasteRooms(job, square, object, expectedRoom)
    if not object then
        return 0, 0
    end

    local linked = 0
    local wrong = 0
    local function inspectRoom(room)
        local occurrences = EBFCopyPasteServer.countLightSwitchInRoom(room, object)
        if occurrences > 0 then
            linked = linked + occurrences
            if expectedRoom and not EBFCopyPasteServer.roomsReferToSameRoomDef(room, expectedRoom) then
                wrong = wrong + occurrences
            end
        end
    end

    EBFCopyPasteServer.forEachLightSwitchCandidateRoom(job, square, inspectRoom)

    return linked, wrong
end

function EBFCopyPasteServer.entryUsesCopiedRuntimeRoom(job, entry)
    if not entry then
        return false
    end
    if entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key) then
        return true
    end
    return job ~= nil and EBFCopyPasteServer.findRoomSpecForEntry(job, entry) ~= nil
end

function EBFCopyPasteServer.auditPastedResidentialLightSwitchFidelity(job, phase)
    if not job or not job.clipboard or not job.clipboard.objects then
        return 0
    end

    local checked = 0
    local vanillaOk = 0
    local missingRoom = 0
    local wrongRoom = 0
    local missingSwitchLink = 0
    local missingRoomLights = 0
    local roomLightsUnproven = 0
    local ownSources = 0
    local lightRoomFalse = 0
    local rectMismatch = 0
    local activeMismatch = 0
    local extraSwitchLinks = 0
    local canSwitchTrue = 0
    local canSwitchFalse = 0
    local detailLines = 0

    for _, entry in ipairs(job.clipboard.objects or {}) do
        if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
            local square = getOrCreateSquare(
                    job.targetX + EBFCopyPaste.toInt(entry.dx, 0),
                    job.targetY + EBFCopyPaste.toInt(entry.dy, 0),
                    job.targetZ + EBFCopyPaste.toInt(entry.dz, 0))
            local object = square and (EBFCopyPasteServer.findObjectForEntry(square, entry, job)
                    or EBFCopyPasteServer.findLightSwitchForEntry(square, entry)) or nil
            if object and isInstance(object, "IsoLightSwitch") then
                checked = checked + 1

                local runtime = EBFCopyPasteServer.getRuntimeRoomForEntry(job, entry)
                local expectedRoom = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, runtime.spec, runtime)) or nil
                local squareRoom = square and callMethod(square, "getRoom") or nil
                local room = nil
                if runtime == nil then
                    room = squareRoom or expectedRoom
                elseif squareRoom and EBFCopyPasteServer.roomDefMatchesRuntime(callMethod(squareRoom, "getRoomDef"), runtime) then
                    room = squareRoom
                else
                    room = expectedRoom
                end
                local roomDef = room and callMethod(room, "getRoomDef") or nil
                local roomMatches = runtime == nil or EBFCopyPasteServer.roomDefMatchesRuntime(roomDef, runtime)
                local switches = room and callMethod(room, "getLightSwitches") or nil
                local inSwitchList = EBFCopyPasteServer.javaListContains(switches, object)
                local roomLightCount, roomLightKnown = EBFCopyPasteServer.getEffectiveRoomLightCount(room, square)
                local sourceCount = EBFCopyPasteServer.getJavaListSize(callMethod(object, "getLights"))
                local lightRoom = EBFCopyPasteServer.safeField(object, "lightRoom")
                local linkedRooms, wrongLinkedRooms = EBFCopyPasteServer.countLightSwitchLinksInKnownPasteRooms(
                        job, square, object, room)
                local spec = EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
                local expectedRects = spec and #(spec.rects or {}) or nil
                local actualRects = EBFCopyPasteServer.getRoomDefRectCount(roomDef)
                local expectedActive = EBFCopyPasteServer.getEntryRoomLightsActive(job, entry)
                local actualActive = roomDef and EBFCopyPasteServer.safeField(roomDef, "lightsActive") or nil
                if not room then
                    missingRoom = missingRoom + 1
                elseif not roomMatches then
                    wrongRoom = wrongRoom + 1
                end
                if not inSwitchList then
                    missingSwitchLink = missingSwitchLink + 1
                end
                if roomLightCount <= 0 then
                    missingRoomLights = missingRoomLights + 1
                elseif roomLightKnown ~= true then
                    roomLightsUnproven = roomLightsUnproven + 1
                end
                if sourceCount > 0 then
                    ownSources = ownSources + 1
                end
                if lightRoom == nil and inSwitchList and sourceCount == 0 and EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
                    lightRoom = true
                end
                if lightRoom ~= true then
                    lightRoomFalse = lightRoomFalse + 1
                end
                if expectedRects ~= nil and actualRects ~= expectedRects then
                    rectMismatch = rectMismatch + 1
                end
                if expectedActive ~= nil and actualActive ~= nil and actualActive ~= expectedActive then
                    activeMismatch = activeMismatch + 1
                end
                if wrongLinkedRooms > 0 or linkedRooms > 1 then
                    extraSwitchLinks = extraSwitchLinks + math.max(wrongLinkedRooms, linkedRooms - 1)
                end

                local canSwitch = callMethod(object, "canSwitchLight")
                if canSwitch == true then
                    canSwitchTrue = canSwitchTrue + 1
                elseif canSwitch == false then
                    canSwitchFalse = canSwitchFalse + 1
                end
                if checked <= 32 then
                    EBFCopyPasteServer.logLightSwitchToggleAudit("audit:" .. tostring(phase or ""), object, nil)
                end

                local okVanilla = room ~= nil
                        and roomMatches == true
                        and inSwitchList == true
                        and roomLightCount > 0
                        and sourceCount == 0
                        and lightRoom == true
                        and linkedRooms == 1
                        and wrongLinkedRooms == 0
                        and (expectedRects == nil or actualRects == expectedRects)
                        and (expectedActive == nil or actualActive == nil or actualActive == expectedActive)
                if okVanilla then
                    vanillaOk = vanillaOk + 1
                end

                if detailLines < 16 and not okVanilla then
                    detailLines = detailLines + 1
                    print("[EBFCopyPaste] AUDIT lighting_indoor vanilla divergente: switch="
                            .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                            .. " sprite=" .. tostring(entry.sprite)
                            .. " roomKey=" .. tostring(entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key) or "?")
                            .. " lightRoom=" .. tostring(lightRoom)
                            .. " ownSources=" .. tostring(sourceCount)
                            .. " roomLights=" .. tostring(roomLightCount)
                            .. " roomLightsKnown=" .. tostring(roomLightKnown)
                            .. " inSwitchList=" .. tostring(inSwitchList)
                            .. " linkedRooms=" .. tostring(linkedRooms)
                            .. " wrongLinkedRooms=" .. tostring(wrongLinkedRooms)
                            .. " roomMatches=" .. tostring(roomMatches)
                            .. " rects=" .. tostring(actualRects) .. "/" .. tostring(expectedRects or "?")
                            .. " lightsActive=" .. tostring(actualActive) .. "/" .. tostring(expectedActive)
                            .. " canSwitch=" .. tostring(canSwitch)
                            .. " phase=" .. tostring(phase or ""))
                end
            end
        end
    end

    job.roomRuntimeSwitchesAudited = (tonumber(job.roomRuntimeSwitchesAudited) or 0) + checked
    job.vanillaRoomLightAuditFailures = (tonumber(job.vanillaRoomLightAuditFailures) or 0)
            + (checked - vanillaOk)
    job.vanillaRoomLightWrongRoomFailures = (tonumber(job.vanillaRoomLightWrongRoomFailures) or 0) + wrongRoom
    job.vanillaRoomLightMissingSwitchLinkFailures = (tonumber(job.vanillaRoomLightMissingSwitchLinkFailures) or 0)
            + missingSwitchLink
    job.vanillaRoomLightExtraSwitchLinkFailures = (tonumber(job.vanillaRoomLightExtraSwitchLinkFailures) or 0)
            + extraSwitchLinks
    if checked > 0 then
                print("[EBFCopyPaste] AUDIT lighting_indoor vanilla resumo: checked=" .. tostring(checked)
                        .. " vanillaOk=" .. tostring(vanillaOk)
                        .. " failures=" .. tostring(checked - vanillaOk)
                        .. " missingRoom=" .. tostring(missingRoom)
                        .. " wrongRoom=" .. tostring(wrongRoom)
                        .. " missingSwitchLink=" .. tostring(missingSwitchLink)
                        .. " missingRoomLights=" .. tostring(missingRoomLights)
                        .. " roomLightsUnproven=" .. tostring(roomLightsUnproven)
                        .. " ownSources=" .. tostring(ownSources)
                .. " lightRoomFalse=" .. tostring(lightRoomFalse)
                .. " rectMismatch=" .. tostring(rectMismatch)
                .. " activeMismatch=" .. tostring(activeMismatch)
                .. " extraSwitchLinks=" .. tostring(extraSwitchLinks)
                .. " canSwitchTrue=" .. tostring(canSwitchTrue)
                .. " canSwitchFalse=" .. tostring(canSwitchFalse)
                .. " phase=" .. tostring(phase or ""))
    end
    return checked
end

function EBFCopyPasteServer.resetRuntimeRoomLightSwitchLists(job, force, reason)
    if not job or (job.runtimeRoomLightSwitchListsReset == true and force ~= true) then
        return 0
    end

    job.runtimeRoomLightSwitchListsReset = true
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)

    local clearedSwitchRooms = 0
    local clearedLightRooms = 0
    local clearedLights = 0
    local seenRooms = {}
    for _, runtime in pairs(job.roomDefRuntimeBySpec or {}) do
        local room = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, runtime.spec, runtime)) or nil
        if room and not seenRooms[room] then
            seenRooms[room] = true
            runtime.room = room
            local switches = callMethod(room, "getLightSwitches")
            if switches then
                clearJavaList(switches)
                clearedSwitchRooms = clearedSwitchRooms + 1
            end
            local lights = EBFCopyPasteServer.clearRuntimeRoomLights(room)
            if lights > 0 then
                clearedLights = clearedLights + lights
                clearedLightRooms = clearedLightRooms + 1
            end
        end
    end

    if clearedSwitchRooms > 0 or clearedLightRooms > 0 then
        print("[EBFCopyPaste] RoomDef luz runtime resetada: switchRooms="
                .. tostring(clearedSwitchRooms)
                .. " lightRooms=" .. tostring(clearedLightRooms)
                .. " roomLights=" .. tostring(clearedLights)
                .. " reason=" .. tostring(reason or ""))
    end
    if force == true then
        job.runtimeRoomSwitchListsClearedFinal = (tonumber(job.runtimeRoomSwitchListsClearedFinal) or 0) + clearedSwitchRooms
        job.runtimeRoomLightsClearedFinal = (tonumber(job.runtimeRoomLightsClearedFinal) or 0) + clearedLights
    end
    return clearedSwitchRooms + clearedLightRooms
end

function EBFCopyPasteServer.applyRuntimeRoomForEntrySquare(job, square, entry)
    if not job or not square or not entry then
        return nil
    end

    local runtime = EBFCopyPasteServer.getRuntimeRoomForEntry(job, entry)
    if runtime then
        if EBFCopyPasteServer.setSquareRuntimeRoom(square, runtime) then
            return callMethod(square, "getRoomID")
        end
    end
    return nil
end

function EBFCopyPasteServer.getSquareObjectsSize(objects)
    return math.max(0, tonumber(callMethod(objects, "size")) or 0)
end

function EBFCopyPasteServer.getSquareObjectAt(objects, index)
    if not objects then
        return nil
    end
    return callMethod(objects, "get", index)
end

function EBFCopyPasteServer.refreshSquareAfterRoomDef(square)
    if not square then
        return
    end
    if EBFCopyPasteServer.squareHasLoadedChunk
            and not EBFCopyPasteServer.squareHasLoadedChunk(square) then
        return
    end

    callMethod(square, "RecalcProperties")
    EBFCopyPasteServer.tryCallMethod(square, "RecalcAllWithNeighbours", true)
    EBFCopyPasteServer.tryCallMethod(square, "setSquareChanged")
    EBFCopyPasteServer.tryCallMethod(square, "invalidateRenderChunkLevel", 2112)

    if PolygonalMap2 and PolygonalMap2.instance then
        pcall(function()
            PolygonalMap2.instance:squareChanged(square)
        end)
    end

    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end
end

function EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
    if not job or not job.clipboard or not getCell then
        return 0
    end

    local metaGrid = EBFCopyPasteServer.getWorldMetaGrid()
    local cell = getCell()
    if not metaGrid or not cell then
        return 0
    end

    local width = math.max(1, EBFCopyPaste.toInt(job.clipboard.w, 1))
    local height = math.max(1, EBFCopyPaste.toInt(job.clipboard.h, 1))
    local targetX = EBFCopyPaste.toInt(job.targetX, 0)
    local targetY = EBFCopyPaste.toInt(job.targetY, 0)
    local targetZ = EBFCopyPaste.toInt(job.targetZ, 0)
    local _, _, zOffsets = getClipboardZRange(job.clipboard)

    local refreshedSquares = 0
    local refreshedRooms = {}
    local refreshedRoomCount = 0
    local assignedRoomSquares = 0
    local clearedRoomSquares = 0
    local failedRoomSquares = 0
    local materializedRoomSquares = 0

    for _, dz in ipairs(zOffsets or { 0 }) do
        local z = targetZ + EBFCopyPaste.toInt(dz, 0)
        for dy = 0, height - 1 do
            local y = targetY + dy
            for dx = 0, width - 1 do
                local x = targetX + dx
                local roomDef = callMethod(metaGrid, "getRoomAt", x, y, z)
                local hasRoomDef = roomDef and callMethod(roomDef, "isEmptyOutside") ~= true
                local square = callMethod(cell, "getGridSquare", x, y, z)
                if not square and hasRoomDef then
                    square = getOrCreateSquare(x, y, z)
                    if square then
                        materializedRoomSquares = materializedRoomSquares + 1
                    end
                end
                if square then
                    if hasRoomDef then
                        local applied = EBFCopyPasteServer.applyRoomDefToSquare(square, roomDef, metaGrid, false)
                        if applied then
                            assignedRoomSquares = assignedRoomSquares + 1
                        else
                            failedRoomSquares = failedRoomSquares + 1
                        end
                    else
                        local hadRoom = callMethod(square, "getRoom") ~= nil
                        local roomID = callMethod(square, "getRoomID")
                        if roomID ~= nil and tostring(roomID) ~= "-1" then
                            hadRoom = true
                        end
                        EBFCopyPasteServer.applyRoomDefToSquare(square, nil, metaGrid, false)
                        if hadRoom then
                            clearedRoomSquares = clearedRoomSquares + 1
                        end
                    end

                    local room = callMethod(square, "getRoom")
                    if room then
                        local roomDefObject = callMethod(room, "getRoomDef") or roomDef
                        if roomDefObject and not refreshedRooms[roomDefObject] then
                            refreshedRooms[roomDefObject] = true
                            refreshedRoomCount = refreshedRoomCount + 1
                            EBFCopyPasteServer.tryCallMethod(roomDefObject, "refreshSquares")
                            EBFCopyPasteServer.tryCallMethod(room, "refreshSquares")
                        end

                    end

                    EBFCopyPasteServer.refreshSquareAfterRoomDef(square)
                    refreshedSquares = refreshedSquares + 1
                end
            end
        end
    end

    job.roomSquaresRefreshed = refreshedSquares
    job.roomRuntimeRoomCount = refreshedRoomCount
    if refreshedSquares > 0 then
        print("[EBFCopyPaste] RoomDefs runtime atualizados: squares="
                .. tostring(refreshedSquares)
                .. " rooms=" .. tostring(refreshedRoomCount)
                .. " setRoomID=" .. tostring(assignedRoomSquares)
                .. " cleared=" .. tostring(clearedRoomSquares)
                .. " failed=" .. tostring(failedRoomSquares)
                .. " materialized=" .. tostring(materializedRoomSquares)
                .. " switches=deferred")
    end
    return refreshedSquares
end

function EBFCopyPasteServer.applyClipboardRoomDefs(job)
    if not job or not job.clipboard then
        return 0
    end
    if job.roomDefApplyAttempted == true then
        return tonumber(job.roomDefsCreated) or 0
    end
    job.roomDefApplyAttempted = true
    job.roomDefsCreated = 0
    job.roomRectsCreated = 0
    job.roomSpecsByKey = nil
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    job.roomDefRuntimeMapped = 0

    local roomSpecs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard)
    if not roomSpecs or #roomSpecs == 0 then
        return 0
    end
    local function markRoomDefApplyFailure(reason, message)
        job.roomDefApplyFailed = true
        job.roomDefApplyFailureReason = tostring(reason or "No se ha aplicado el RoomDef vanilla.")
        job.roomDefApplyFailureMessage = tostring(message or job.roomDefApplyFailureReason)
        print("[EBFCopyPaste] FALHA RoomDef: " .. tostring(job.roomDefApplyFailureMessage))
    end
    EBFCopyPasteServer.logRoomSpecDiagnostics(job, "antesRoomDefApply")

    if not EBFCopyPasteServer.allowPersistentRoomDefWrites() then
        job.roomDefPersistenceDisabled = true
        EBFCopyPasteServer.logStage(job, "finalize:roomsRebuildSkipped",
            "FINALIZACIÓN: reconstrucción de RoomDef desactivada; los interruptores residenciales podrían quedarse sin RoomDef.")
        return 0
    end

    local canSaveRooms, saveCapabilityError = EBFCopyPasteServer.canSavePlayerRoomsFile()
    if canSaveRooms == false then
        -- En B42.20 PlayerRoomsFile puede no estar expuesto a Lua. No se llama a
        -- BuildingRoomsEditor.applyChanges sin una ruta de guardado: eso crearía RoomDef
        -- transitorios. Se continúa con la construcción física y la sincronización final.
        if EBFCopyPaste.RoomDefFallbackMode == "physicalOnly" then
            job.roomDefPersistenceDisabled = true
            job.roomDefApplyFailed = false
            job.roomDefApplyFailureReason = nil
            job.roomDefApplyFailureMessage = nil
            job.roomDefFallbackWarning = "RoomDef no persistido: " .. tostring(saveCapabilityError)
            EBFCopyPasteServer.logStage(job, "finalize:roomsFallback",
                    "FINALIZACIÓN: PlayerRoomsFile no disponible; se omite RoomDef y continúa el pegado físico seguro. "
                    .. tostring(saveCapabilityError))
            print("[EBFCopyPaste] AVISO RoomDef: " .. tostring(job.roomDefFallbackWarning))
            return 0
        end
        job.roomDefApplyFailed = true
        job.roomDefApplyFailureReason = "El RoomDef vanilla no puede persistirse."
        job.roomDefApplyFailureMessage = "El RoomDef vanilla no puede persistirse: "
                .. tostring(saveCapabilityError)
                .. " Se ha interrumpido el pegado para evitar un roomID huérfano en la siguiente carga."
        print("[EBFCopyPaste] FALLO RoomDef: " .. tostring(job.roomDefApplyFailureMessage))
        return 0
    elseif canSaveRooms ~= true and saveCapabilityError then
        job.roomDefExternalSaveWarning = tostring(saveCapabilityError)
        print("[EBFCopyPaste] AVISO RoomDef: " .. tostring(saveCapabilityError))
    end

    EBFCopyPasteServer.clearClipboardRoomDefsAtTarget(job)
    if job.roomDefCleanupFailed == true then
        job.roomDefApplyFailed = true
        if job.roomDefCleanupSaveFailed == true then
            job.roomDefApplyFailureReason = "La limpieza de RoomDef no se ha persistido."
            job.roomDefApplyFailureMessage = "La limpieza de RoomDef antiguos no se ha guardado en player_buildings.bin: "
                    .. tostring(job.roomDefCleanupSaveError)
                    .. " Se ha interrumpido el pegado para evitar un roomID huérfano en la siguiente carga."
        else
            job.roomDefApplyFailureReason = "RoomDef antigo ainda intersecta a area de destino."
        end
        print("[EBFCopyPaste] FALLO de RoomDef: limpieza del destino incompleta; se cancela la reconstrucción. interseccionesRestantes="
                .. tostring(job.roomDefCleanupRemainingIntersections or 0))
        return 0
    end

    local editor, editorError = EBFCopyPasteServer.getBuildingRoomsEditorForPaste(job)
    if not editor then
        markRoomDefApplyFailure("El RoomDef vanilla no está disponible.",
                "El RoomDef vanilla no está disponible: " .. tostring(editorError)
                .. " Se ha interrumpido el pegado para evitar objetos o luces sin RoomDef vanilla.")
        return 0
    end

    local building = nil
    local function ensurePasteBuilding()
        if building then
            EBFCopyPasteServer.setCurrentPasteBuilding(editor, building)
            return building
        end

        local okBuilding, createdBuilding = pcall(function()
            return editor:createBuilding()
        end)
        if okBuilding and createdBuilding then
            building = createdBuilding
            EBFCopyPasteServer.setCurrentPasteBuilding(editor, building)
            return building
        end
        return nil
    end

    local createdRooms = 0
    local createdRects = 0
    local skippedRects = 0
    local skippedRectDetails = 0
    for _, spec in ipairs(roomSpecs) do
        local absZ = EBFCopyPaste.toInt(job.targetZ, 0) + EBFCopyPaste.toInt(spec.dz, 0)
        local room = nil
        local roomRects = 0
        local pendingRects = {}
        for _, rect in ipairs(spec.rects or {}) do
            table.insert(pendingRects, rect)
        end

        while #pendingRects > 0 do
            local nextPending = {}
            local progressed = false
            for _, rect in ipairs(pendingRects) do
            local absX = EBFCopyPaste.toInt(job.targetX, 0) + EBFCopyPaste.toInt(rect.x, 0)
            local absY = EBFCopyPaste.toInt(job.targetY, 0) + EBFCopyPaste.toInt(rect.y, 0)
            local rectW = math.max(1, EBFCopyPaste.toInt(rect.w, 1))
            local rectH = math.max(1, EBFCopyPaste.toInt(rect.h, 1))

            if EBFCopyPasteServer.pasteRoomRectOverlapsExistingRoom(absX, absY, absZ, rectW, rectH) then
                skippedRects = skippedRects + 1
                if skippedRectDetails < 24 then
                    skippedRectDetails = skippedRectDetails + 1
                    print("[EBFCopyPaste][RoomAudit][skippedRect] motivo=overlapExistente"
                            .. " roomKey=" .. tostring(spec.key or "?")
                            .. " name=" .. tostring(spec.name or spec.sourceRoomDefName or "?")
                            .. " rect=" .. tostring(absX) .. "," .. tostring(absY) .. "," .. tostring(absZ)
                            .. " " .. tostring(rectW) .. "x" .. tostring(rectH))
                end
            else
                local activeBuilding = ensurePasteBuilding()
                if activeBuilding then
                    EBFCopyPasteServer.setCurrentPasteBuilding(editor, activeBuilding)
                    EBFCopyPasteServer.setCurrentPasteRoom(editor, room)

                    local canAdd = true
                    if editor.canAddRoomRectangle then
                        local okCan, result = pcall(function()
                            return editor:canAddRoomRectangle(room, absX, absY, rectW, rectH, absZ)
                        end)
                        canAdd = okCan == true and result == true
                    end

                    if canAdd then
                        if not room then
                            local okRoom, createdRoom = pcall(function()
                                return activeBuilding:createRoom(absZ)
                            end)
                            if okRoom then
                                room = createdRoom
                                EBFCopyPasteServer.setCurrentPasteRoom(editor, room)
                            end
                            if room and room.setName then
                                pcall(function()
                                    room:setName(tostring(spec.name or spec.sourceRoomDefName or "room"))
                                end)
                            end
                        end

                        if room then
                            local okRect = pcall(function()
                                room:addRectangle(absX, absY, rectW, rectH)
                            end)
                            if okRect then
                                roomRects = roomRects + 1
                                createdRects = createdRects + 1
                                progressed = true
                            else
                                table.insert(nextPending, rect)
                            end
                        else
                            table.insert(nextPending, rect)
                        end
                    else
                        if skippedRectDetails < 24 then
                            skippedRectDetails = skippedRectDetails + 1
                            print("[EBFCopyPaste][RoomAudit][skippedRect] motivo=canAddRoomRectangleFalse"
                                    .. " roomKey=" .. tostring(spec.key or "?")
                                    .. " name=" .. tostring(spec.name or spec.sourceRoomDefName or "?")
                                    .. " rect=" .. tostring(absX) .. "," .. tostring(absY) .. "," .. tostring(absZ)
                                    .. " " .. tostring(rectW) .. "x" .. tostring(rectH))
                        end
                        table.insert(nextPending, rect)
                    end
                else
                    skippedRects = skippedRects + 1
                    if skippedRectDetails < 24 then
                        skippedRectDetails = skippedRectDetails + 1
                        print("[EBFCopyPaste][RoomAudit][skippedRect] motivo=semBuilding"
                                .. " roomKey=" .. tostring(spec.key or "?")
                                .. " name=" .. tostring(spec.name or spec.sourceRoomDefName or "?")
                                .. " rect=" .. tostring(absX) .. "," .. tostring(absY) .. "," .. tostring(absZ)
                                .. " " .. tostring(rectW) .. "x" .. tostring(rectH))
                    end
                end
            end
            end

            if not progressed then
                skippedRects = skippedRects + #nextPending
                break
            end
            pendingRects = nextPending
        end
        if room and roomRects > 0 then
            createdRooms = createdRooms + 1
        end
    end

    if createdRooms <= 0 then
        if BuildingRoomsEditor and BuildingRoomsEditor.Reset then
            pcall(function()
                BuildingRoomsEditor.Reset()
            end)
        end
        markRoomDefApplyFailure("El RoomDef vanilla no ha creado habitaciones.",
                "RoomDef vanilla no aplicado: habitaciones=0 rectángulos=0 rectángulosOmitidos=" .. tostring(skippedRects)
                .. " Se ha interrumpido el pegado para evitar objetos o luces sin RoomDef vanilla.")
        return 0
    end

    local valid = true
    if editor.isValid then
        local okValid, result = pcall(function()
            return editor:isValid()
        end)
        valid = okValid == true and result == true
    end
    if not valid then
        local invalidString = callMethod(editor, "getInvalidString")
        markRoomDefApplyFailure("El RoomDef vanilla no es válido.",
                "El RoomDef vanilla no es válido: " .. tostring(invalidString)
                .. " Se ha interrumpido el pegado para evitar objetos o luces sin RoomDef vanilla.")
        if BuildingRoomsEditor and BuildingRoomsEditor.Reset then
            pcall(function()
                BuildingRoomsEditor.Reset()
            end)
        end
        return 0
    end

    local okApply, applyError = pcall(function()
        editor:applyChanges(false)
    end)
    if not okApply then
        markRoomDefApplyFailure("Falha ao aplicar RoomDef vanilla.",
                "Falha ao aplicar RoomDef vanilla: " .. tostring(applyError)
                .. " Se ha interrumpido el pegado para evitar objetos o luces sin RoomDef vanilla.")
        if BuildingRoomsEditor and BuildingRoomsEditor.Reset then
            pcall(function()
                BuildingRoomsEditor.Reset()
            end)
        end
        return 0
    end

    local savedRooms, saveRoomsError = EBFCopyPasteServer.trySavePlayerRoomsFile()
    if savedRooms ~= true then
        job.roomDefApplyFailed = true
        job.roomDefApplyFailureReason = "RoomDef vanilla aplicado, pero no persistido."
        job.roomDefApplyFailureMessage = "RoomDef vanilla aplicado en tiempo de ejecución, pero no guardado en player_buildings.bin: "
                .. tostring(saveRoomsError)
                .. " Se ha interrumpido el pegado para evitar un roomID huérfano en la siguiente carga."
        print("[EBFCopyPaste] FALHA RoomDef: " .. tostring(job.roomDefApplyFailureMessage))
        if BuildingRoomsEditor and BuildingRoomsEditor.Reset then
            pcall(function()
                BuildingRoomsEditor.Reset()
            end)
        end
        return 0
    elseif saveRoomsError then
        job.roomDefExternalSaveWarning = tostring(saveRoomsError)
        print("[EBFCopyPaste] AVISO de guardado adicional de RoomDef: " .. tostring(saveRoomsError))
    end
    EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    EBFCopyPasteServer.forceRuntimeRoomLightsInactive(job, "aposRoomDefApply")
    EBFCopyPasteServer.logRoomSpecDiagnostics(job, "aposRoomDefApply")
    EBFCopyPasteServer.auditAndAlignRuntimeRoomSpecTiles(job)
    local missingRuntimeBuildings = EBFCopyPasteServer.ensureRuntimeRoomsHaveBuildings(job, "applyRoomDefs")
    local roomMaskTotal = job.roomMaskAudit and tonumber(job.roomMaskAudit.total) or 0
    local roomMaskOk = job.roomMaskAudit
            and ((tonumber(job.roomMaskAudit.matched) or 0) + (tonumber(job.roomMaskAudit.fixed) or 0)) or 0
    if skippedRects > 0
            or (roomMaskTotal > 0 and roomMaskOk < roomMaskTotal)
            or missingRuntimeBuildings > 0 then
        job.roomDefApplyFailed = true
        job.roomDefApplyFailureMessage = "RoomDef en tiempo de ejecución incompleto después de la reconstrucción: "
                .. tostring(roomMaskOk) .. "/" .. tostring(roomMaskTotal)
                .. " tiles ligados, semBuilding=" .. tostring(missingRuntimeBuildings)
                .. ", skippedRects=" .. tostring(skippedRects)
                .. ". Se ha interrumpido el pegado para evitar un fallo en IsoRoom/building."
        print("[EBFCopyPaste] RoomDef vanilla BLOQUEADO: " .. tostring(job.roomDefApplyFailureMessage))
    else
        job.roomDefApplyFailed = false
        job.roomDefApplyFailureMessage = nil
    end
    job.roomDefsCreated = createdRooms
    job.roomRectsCreated = createdRects
    print("[EBFCopyPaste] RoomDefs vanilla aplicados: rooms="
            .. tostring(createdRooms)
            .. " rects=" .. tostring(createdRects)
            .. " skippedRects=" .. tostring(skippedRects))
    EBFCopyPasteServer.logStage(job, "finalize:roomsApplied", "FINALIZE RoomDef aplicado: rooms="
            .. tostring(createdRooms)
            .. " rects=" .. tostring(createdRects)
            .. " runtimeSquares=" .. tostring(job.roomSquaresRefreshed or 0)
            .. " roomMaskOk=" .. tostring(job.roomMaskAudit and ((job.roomMaskAudit.matched or 0) + (job.roomMaskAudit.fixed or 0)) or 0)
            .. "/" .. tostring(job.roomMaskAudit and job.roomMaskAudit.total or 0)
            .. " switchesVinculados=deferred"
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    return createdRooms
end

function EBFCopyPasteServer.refreshRuntimeRoomsAfterDeferredLights(job)
    if not job or not job.clipboard or job.postDeferredLightRoomRefreshDone == true then
        return 0
    end

    job.postDeferredLightRoomRefreshDone = true
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    local refreshed = EBFCopyPasteServer.refreshClipboardRuntimeRoomDefs(job)
    job.roomDefRuntimeBySpec = nil
    job.roomDefRuntimeByKey = nil
    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    return refreshed
end

local function buildPasteClearBlockList(job)
    if not job or not job.clipboard then
        return {}
    end
    return buildCopyBlockList({
        x = job.targetX,
        y = job.targetY,
        z = job.targetZ,
        w = job.clipboard.w,
        h = job.clipboard.h,
    })
end

EBFCopyPasteServer.PasteCategoryOrderSequence = { 10, 20, 30, 40, 45, 50, 55, 60, 61, 70, 71, 80, 999 }

function EBFCopyPasteServer.getPasteBlockNumber(value, fallback)
    local ok, number = pcall(function()
        return tonumber(value)
    end)
    if not ok or number == nil then
        return fallback or 0
    end
    return number
end

function EBFCopyPasteServer.getPasteBlockInt(value, fallback)
    return math.floor(EBFCopyPasteServer.getPasteBlockNumber(value, fallback or 0))
end

function EBFCopyPasteServer.sortPasteEntriesWithinCategory(entries)
    if not entries or #entries <= 1 then
        return entries
    end

    local tileOrder = {}
    local tileGroups = {}
    for _, entry in ipairs(entries) do
        local tileKey = tostring(entry.dz or 0) .. ":" .. tostring(entry.dy or 0) .. ":" .. tostring(entry.dx or 0)
        local group = tileGroups[tileKey]
        if not group then
            group = {}
            tileGroups[tileKey] = group
            table.insert(tileOrder, tileKey)
        end
        table.insert(group, entry)
    end

    local ordered = {}
    for _, tileKey in ipairs(tileOrder) do
        local group = tileGroups[tileKey]
        table.sort(group, function(a, b)
            if a.floor ~= b.floor then
                return a.floor == true
            end
            return (tonumber(a.index) or 0) < (tonumber(b.index) or 0)
        end)
        for i = 1, #group do
            table.insert(ordered, group[i])
        end
    end
    return ordered
end

local function buildPasteObjectBlockList(job)
    local blocks = buildPasteClearBlockList(job)
    if not job or not job.clipboard then
        return blocks
    end
    job.deferredLightingEntries = {}
    job.deferredLightingTotal = 0

    local blockSize = math.max(1, EBFCopyPaste.toInt(EBFCopyPaste.CopyBlockSize, 50))
    local blocksPerRow = math.max(1, math.ceil((tonumber(job.clipboard.w) or 1) / blockSize))
    for _, block in ipairs(blocks) do
        block.objects = {}
        block.objectIndex = 1
        block.totalObjects = 0
        block.sourceCells = nil
        block.sourceReady = false
        block.positionChecked = false
        block.categoryBuckets = {}
    end

    for _, entry in ipairs(job.clipboard.objects or {}) do
        if type(entry) == "table" then
            if EBFCopyPasteServer.entryShouldPasteAfterRoomDefs(entry) then
                table.insert(job.deferredLightingEntries, entry)
                job.deferredLightingTotal = job.deferredLightingTotal + 1
            else
                local dx = math.max(0, EBFCopyPasteServer.getPasteBlockInt(entry.dx, 0))
                local dy = math.max(0, EBFCopyPasteServer.getPasteBlockInt(entry.dy, 0))
                local blockX = math.floor(dx / blockSize)
                local blockY = math.floor(dy / blockSize)
                local blockIndex = (blockY * blocksPerRow) + blockX + 1
                local block = blocks[blockIndex]
                if block then
                    local order = EBFCopyPasteServer.getPasteCategoryOrder(entry)
                    local bucket = block.categoryBuckets[order]
                    if not bucket then
                        bucket = {}
                        block.categoryBuckets[order] = bucket
                    end
                    table.insert(bucket, entry)
                    block.totalObjects = block.totalObjects + 1
                end
            end
        end
    end

    for _, block in ipairs(blocks) do
        local ordered = {}
        for _, order in ipairs(EBFCopyPasteServer.PasteCategoryOrderSequence) do
            local bucket = block.categoryBuckets and block.categoryBuckets[order] or nil
            if bucket then
                bucket = EBFCopyPasteServer.sortPasteEntriesWithinCategory(bucket)
                for i = 1, #bucket do
                    table.insert(ordered, bucket[i])
                end
            end
        end
        block.objects = ordered
        block.categoryBuckets = nil
        block.totalObjects = #block.objects
    end

    return blocks
end

local function setupPasteClearBlocks(job)
    if job.clearBlocks then
        return
    end

    job.clearBlocks = buildPasteObjectBlockList(job)
    job.pasteBlocks = job.clearBlocks
    job.clearBlockIndex = 1
    job.processedClearTiles = 0
    job.pendingContainerApplies = job.pendingContainerApplies or {}
    job.pendingContainerApplyHead = job.pendingContainerApplyHead or 1
end

local function setupPasteObjectBlocks(job)
    job.pendingContainerApplies = job.pendingContainerApplies or {}
    job.pendingContainerApplyHead = job.pendingContainerApplyHead or 1
    if job.pasteBlocks then
        return
    end

    job.pasteBlocks = buildPasteObjectBlockList(job)
    job.pasteBlockIndex = 1
    job.processedPasteObjects = 0
end

local function setPasteClearJobSourceCells(job, block)
    if not job or not block then
        return
    end

    block.sourceCells = {}
    block.sourceReady = true
    job.sourceCells = block.sourceCells
    job.sourceReady = true
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
end

local function setPasteObjectJobSourceCells(job, block)
    setPasteClearJobSourceCells(job, block)
end

local function hasPendingPasteContainerApplies(job)
    if not job or type(job.pendingContainerApplies) ~= "table" then
        return false
    end
    local head = tonumber(job.pendingContainerApplyHead) or 1
    return head <= #job.pendingContainerApplies
end

local function processPendingPasteContainerApplies(job)
    if not hasPendingPasteContainerApplies(job) then
        return false
    end

    EBFCopyPasteServer.logStage(job, "pasteCategory:objetos internos", "PEGADO: iniciada la categoría de objetos internos de contenedores"
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    local budget = getBudgetValue(EBFCopyPaste.PasteContainerItemsPerTick, 80, 1)
    local queue = job.pendingContainerApplies
    local head = tonumber(job.pendingContainerApplyHead) or 1
    while budget > 0 and head <= #queue do
        local task = queue[head]
        local items = task and task.snapshot and task.snapshot.items or {}
        if task and (task.itemIndex or 1) <= #items then
            local prototype = items[task.itemIndex or 1]
            if type(prototype) == "table" and prototype.fullType and createItemFromPersistentSnapshot then
                local item = createItemFromPersistentSnapshot(prototype, 0)
                if item then
                    callMethod(task.container, "AddItem", item)
                    if task.transmit and sendAddItemToContainer then
                        sendAddItemToContainer(task.container, item)
                    end
                end
            else
                addItemCloneToContainer(task.container, prototype, task.transmit, 0)
            end
            task.itemIndex = (task.itemIndex or 1) + 1
            budget = budget - 1
        else
            if task and task.container then
                callMethod(task.container, "setExplored", task.snapshot and task.snapshot.explored ~= false)
                if task.transmit and triggerEvent then
                    triggerEvent("OnContainerUpdate")
                end
                EBFCopyPasteServer.queueJobObjectForFinalSync(job, task.object)
            end
            head = head + 1
            job.pendingContainerApplyHead = head
        end
    end

    return head <= #queue
end

local function startPasteCurrentBlock(job)
    setupPasteObjectBlocks(job)
    job.phase = "paste"
    job.pasteBlockIndex = job.pasteBlockIndex or 1
    job.objectIndex = (job.processedPasteObjects or 0) + 1
    local block = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
    job.sourceReady = block and block.sourceReady == true or false
    job.lastFeedback = 0
    EBFCopyPasteServer.logStage(job, "paste:block:" .. tostring(job.pasteBlockIndex or 1), "PASTE bloco "
            .. tostring(job.pasteBlockIndex or 1) .. "/" .. tostring(job.pasteBlocks and #job.pasteBlocks or 1)
            .. " objetos=" .. tostring(block and block.totalObjects or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

local function ensureCurrentPasteClearBlockReady(key, job)
    setupPasteClearBlocks(job)
    local block = job.clearBlocks and job.clearBlocks[job.clearBlockIndex] or nil
    if not block then
        startPasteCurrentBlock(job)
        return false
    end

    if not block.positionChecked then
        block.positionChecked = true
        EBFCopyPasteServer.logStage(job, "clear:block:" .. tostring(block.index or job.clearBlockIndex), "CLEAR bloco "
                .. tostring(block.index or job.clearBlockIndex) .. "/" .. tostring(job.clearBlocks and #job.clearBlocks or 1)
                .. " destino=" .. tostring(block.x) .. "," .. tostring(block.y)
                .. " tamanho=" .. tostring(block.w) .. "x" .. tostring(block.h)
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        setPasteClearJobSourceCells(job, block)
    end

    if not block.sourceReady then
        if not block.sourceCells or job.sourceCells ~= block.sourceCells then
            setPasteClearJobSourceCells(job, block)
        end
        if not keepSourceCellsReady(job) then
            sendPasteProgress(job, false)
            return false
        end
        block.sourceReady = true
    end

    if not block.clearArea then
        local zOffsets = EBFCopyPaste.normalizeZOffsets(job.clipboard.zOffsets, job.clipboard.levels)
        block.clearArea = {
            x = block.x,
            y = block.y,
            z = job.targetZ,
            w = block.w,
            h = block.h,
            levels = #zOffsets,
            zOffsets = zOffsets,
        }
        block.totalTiles = block.w * block.h * #zOffsets
        block.tileIndex = 1
    end

    return true
end

function EBFCopyPasteServer.auditPasteClearResidue(job)
    local result = {
        tiles = 0,
        loadedTiles = 0,
        remaining = 0,
        objectCount = 0,
        worldObjectCount = 0,
        samples = {},
    }
    if not job or not job.clipboard or not getCell then
        return result
    end

    local cell = getCell()
    if not cell or not cell.getGridSquare then
        return result
    end

    local width = math.max(1, math.floor(tonumber(job.clipboard.w) or 1))
    local height = math.max(1, math.floor(tonumber(job.clipboard.h) or 1))
    local zOffsets = EBFCopyPaste.normalizeZOffsets(job.clipboard.zOffsets, job.clipboard.levels)
    local function addSample(square, object, source)
        if #result.samples >= 8 then
            return
        end
        table.insert(result.samples, tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                .. ":" .. tostring(source)
                .. ":" .. tostring(getObjectSpriteName(object) or callMethod(object, "getObjectName") or "?"))
    end

    for _, dz in ipairs(zOffsets) do
        local z = math.floor((tonumber(job.targetZ) or 0) + dz)
        for x = math.floor(tonumber(job.targetX) or 0), math.floor(tonumber(job.targetX) or 0) + width - 1 do
            for y = math.floor(tonumber(job.targetY) or 0), math.floor(tonumber(job.targetY) or 0) + height - 1 do
                result.tiles = result.tiles + 1
                local square = getOrCreateSquare(x, y, z) or cell:getGridSquare(x, y, z)
                if square then
                    result.loadedTiles = result.loadedTiles + 1
                    local objects = square.getObjects and square:getObjects() or nil
                    local objectCount = objects and objects:size() or 0
                    result.objectCount = result.objectCount + objectCount
                    result.remaining = result.remaining + objectCount
                    if objects and objectCount > 0 then
                        for i = 0, objectCount - 1 do
                            addSample(square, objects:get(i), "object")
                        end
                    end

                    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
                    local worldObjectCount = worldObjects and worldObjects:size() or 0
                    result.worldObjectCount = result.worldObjectCount + worldObjectCount
                    result.remaining = result.remaining + worldObjectCount
                    if worldObjects and worldObjectCount > 0 then
                        for i = 0, worldObjectCount - 1 do
                            addSample(square, worldObjects:get(i), "world")
                        end
                    end
                end
            end
        end
    end
    return result
end

local function resetPasteClearBlocksForRetry(job)
    if not job then
        return
    end
    for _, block in ipairs(job.clearBlocks or {}) do
        block.tileIndex = 1
        block.clearArea = nil
        block.totalTiles = 0
        block.sourceReady = false
        block.positionChecked = false
    end
    job.clearBlockIndex = 1
    job.processedClearTiles = 0
    job.tileIndex = 1
    job.sourceCells = nil
    job.sourceReady = false
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
end

local function processPasteClear(job)
    local ready, finished = ensureCurrentPasteClearBlockReady(getPlayerKey(job.playerObj), job)
    if finished or not ready then
        return
    end

    local block = job.clearBlocks and job.clearBlocks[job.clearBlockIndex] or nil
    if not block or not block.clearArea or (block.totalTiles or 0) <= 0 then
        if not block then
            startPasteCurrentBlock(job)
        else
            job.processedClearTiles = (job.processedClearTiles or 0) + (block.totalTiles or 0)
            job.clearBlockIndex = (job.clearBlockIndex or 1) + 1
            job.tileIndex = (job.processedClearTiles or 0) + 1
        end
        return
    end

    local simpleBudget = getBudgetValue(EBFCopyPaste.PasteClearSimpleTilesPerTick, 24, 1)
    local simpleMaxBudget = getBudgetValue(EBFCopyPaste.PasteClearMaxSimpleTilesPerTick, simpleBudget * 6, simpleBudget)
    local simpleTimeBudgetMs = getBudgetValue(EBFCopyPaste.PasteClearTimeBudgetMs, 4, 0)
    local simpleProcessed = 0
    local tickStartMs = nowMs()
    local heavyBudget = getBudgetValue(EBFCopyPaste.PasteClearHeavyTilesPerTick, 1, 1)
    while block.tileIndex <= block.totalTiles do
        local dx, dy, dz = getTileOffsets(block.clearArea, block.clearArea.levels, block.tileIndex)
        local square = nil
        local ok, targetSquare = pcall(function()
            return getOrCreateSquare(block.x + dx, block.y + dy, job.targetZ + dz)
        end)
        if ok then
            square = targetSquare
        end
        local okClear, _, wasHeavy = pcall(clearSquare, square)
        if not okClear then
            wasHeavy = false
        end
        block.tileIndex = block.tileIndex + 1
        job.tileIndex = (job.processedClearTiles or 0) + block.tileIndex
        if wasHeavy then
            heavyBudget = heavyBudget - 1
            if heavyBudget <= 0 then
                break
            end
        else
            simpleProcessed = simpleProcessed + 1
            if reachedSimpleWorkBudget(tickStartMs, simpleTimeBudgetMs, simpleProcessed, simpleBudget, simpleMaxBudget) then
                break
            end
        end
    end

    if block.tileIndex > block.totalTiles then
        job.processedClearTiles = (job.processedClearTiles or 0) + (block.totalTiles or 0)
        job.clearBlockIndex = (job.clearBlockIndex or 1) + 1
        job.tileIndex = (job.processedClearTiles or 0) + 1
        if (job.clearBlockIndex or 1) > #(job.clearBlocks or {}) then
            local residue = EBFCopyPasteServer.auditPasteClearResidue(job)
            EBFCopyPasteServer.logStage(job, "clear:audit", "CLEAR audit destino"
                    .. " tiles=" .. tostring(residue.tiles or 0)
                    .. " carregados=" .. tostring(residue.loadedTiles or 0)
                    .. " restantes=" .. tostring(residue.remaining or 0)
                    .. " objetos=" .. tostring(residue.objectCount or 0)
                    .. " worldObjects=" .. tostring(residue.worldObjectCount or 0)
                    .. " samples=" .. table.concat(residue.samples or {}, "|")
                    .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                    .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
            if (tonumber(residue.remaining) or 0) > 0 then
                if job.clearResidueRetryDone ~= true then
                    job.clearResidueRetryDone = true
                    resetPasteClearBlocksForRetry(job)
                    EBFCopyPasteServer.logStage(job, "clear:retry", "LIMPIEZA: el destino todavía contenía objetos; se repite la limpieza"
                            .. " restantes=" .. tostring(residue.remaining or 0)
                            .. " samples=" .. table.concat(residue.samples or {}, "|")
                            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
                    return
                end
                failPasteJob(getPlayerKey(job.playerObj), job,
                        "Limpieza del destino incompleta; se ha cancelado el pegado para no pegar sobre objetos restantes: "
                        .. tostring(table.concat(residue.samples or {}, "|")))
                return
            end
            startPasteCurrentBlock(job)
        end
    end
end

local function advancePasteObjectBlock(job)
    local block = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
    if block then
        job.processedPasteObjects = (job.processedPasteObjects or 0) + (block.totalObjects or 0)
    end
    job.pasteBlockIndex = (job.pasteBlockIndex or 1) + 1
    job.objectIndex = (job.processedPasteObjects or 0) + 1
    job.sourceCells = nil
    job.sourceReady = false
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
    if (job.pasteBlockIndex or 1) > #(job.pasteBlocks or {}) then
        startPasteFinalizeRooms(job)
    else
        job.phase = "paste"
        local nextBlock = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
        EBFCopyPasteServer.logStage(job, "paste:block:" .. tostring(job.pasteBlockIndex or 1), "PASTE bloco "
                .. tostring(job.pasteBlockIndex or 1) .. "/" .. tostring(job.pasteBlocks and #job.pasteBlocks or 1)
                .. " objetos=" .. tostring(nextBlock and nextBlock.totalObjects or 0)
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    end
end

local function ensureCurrentPasteObjectBlockReady(key, job)
    setupPasteObjectBlocks(job)
    local block = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
    if not block then
        return false
    end

    if not block.positionChecked then
        block.positionChecked = true
        setPasteObjectJobSourceCells(job, block)
    end

    if not block.sourceReady then
        if not block.sourceCells or job.sourceCells ~= block.sourceCells then
            setPasteObjectJobSourceCells(job, block)
        end
        if not keepSourceCellsReady(job) then
            sendPasteProgress(job, false)
            return false
        end
        block.sourceReady = true
        job.sourceReady = true
    end

    return true
end

local function diagnosticText(value)
    local text = tostring(value == nil and "" or value)
    text = string.gsub(text, "[\r\n\t]+", " ")
    local maxText = math.max(80, tonumber(EBFCopyPaste.DiagnosticMaxText) or 700)
    if string.len(text) > maxText then
        text = string.sub(text, 1, maxText) .. "..."
    end
    return text
end

function EBFCopyPasteServer.recordPasteDiagnostic(job, entry, status, detail, object, square)
    if EBFCopyPaste.DiagnosticMode ~= true or not job then
        return
    end

    local diagnostic = job.diagnostic
    if not diagnostic then
        diagnostic = {
            total = 0,
            created = 0,
            warnings = 0,
            failures = 0,
            byStatus = {},
            byStrategy = {},
            bySprite = {},
            items = {},
        }
        job.diagnostic = diagnostic
    end

    status = tostring(status or "unknown")
    diagnostic.total = diagnostic.total + 1
    diagnostic.byStatus[status] = (diagnostic.byStatus[status] or 0) + 1
    local strategy = tostring(entry and (entry.pasteStrategy or EBFCopyPasteServer.selectPasteStrategy(entry)) or "unknown")
    diagnostic.byStrategy[strategy] = (diagnostic.byStrategy[strategy] or 0) + 1
    local sourceSprite = tostring(entry and entry.sprite or "")
    if status ~= "created" then
        diagnostic.bySprite[sourceSprite] = (diagnostic.bySprite[sourceSprite] or 0) + 1
    end

    local failure = status == "luaError"
            or status == "notCreated"
            or status == "notRegistered"
            or status == "spriteMissing"
            or status == "squareMissing"
    local warning = status == "spriteChanged"
    if failure then
        diagnostic.failures = diagnostic.failures + 1
    elseif warning then
        diagnostic.warnings = diagnostic.warnings + 1
    else
        diagnostic.created = diagnostic.created + 1
    end

    if status == "created" then
        return
    end

    local targetX = square and tonumber(callMethod(square, "getX"))
            or (tonumber(job.targetX) or 0) + EBFCopyPaste.toInt(entry and entry.dx, 0)
    local targetY = square and tonumber(callMethod(square, "getY"))
            or (tonumber(job.targetY) or 0) + EBFCopyPaste.toInt(entry and entry.dy, 0)
    local targetZ = square and tonumber(callMethod(square, "getZ"))
            or (tonumber(job.targetZ) or 0) + EBFCopyPaste.toInt(entry and entry.dz, 0)
    local actualSprite = object and getObjectSpriteName(object) or nil
    local actualClass = object and getObjectClass(object) or nil
    local registered = object and square and EBFCopyPasteServer.objectIsRegisteredOnSquare
            and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) == true or false
    local item = {
        status = status,
        targetX = targetX,
        targetY = targetY,
        targetZ = targetZ,
        dx = entry and entry.dx or nil,
        dy = entry and entry.dy or nil,
        dz = entry and entry.dz or nil,
        sourceSprite = sourceSprite,
        actualSprite = actualSprite,
        sourceClass = entry and entry.objectClass or nil,
        actualClass = actualClass,
        isoType = entry and entry.isoType or nil,
        strategy = strategy,
        category = entry and entry.classification and entry.classification.category or nil,
        floor = entry and entry.floor == true or false,
        registered = registered,
        detail = diagnosticText(detail),
    }
    if #diagnostic.items < math.max(1, tonumber(EBFCopyPaste.DiagnosticMaxEntries) or 500) then
        table.insert(diagnostic.items, item)
    end

    print("[EBF-DIAG-ITEM] status=" .. tostring(item.status)
            .. " target=" .. tostring(item.targetX) .. "," .. tostring(item.targetY) .. "," .. tostring(item.targetZ)
            .. " rel=" .. tostring(item.dx) .. "," .. tostring(item.dy) .. "," .. tostring(item.dz)
            .. " sprite=" .. tostring(item.sourceSprite)
            .. " actualSprite=" .. tostring(item.actualSprite)
            .. " class=" .. tostring(item.sourceClass)
            .. " actualClass=" .. tostring(item.actualClass)
            .. " isoType=" .. tostring(item.isoType)
            .. " strategy=" .. tostring(item.strategy)
            .. " category=" .. tostring(item.category)
            .. " floor=" .. tostring(item.floor)
            .. " registered=" .. tostring(item.registered)
            .. " detail=" .. tostring(item.detail))
end

function EBFCopyPasteServer.printPasteDiagnosticReport(job, outcome)
    if EBFCopyPaste.DiagnosticMode ~= true or not job then
        return
    end
    local diagnostic = job.diagnostic or {
        total = 0, created = 0, warnings = 0, failures = 0,
        byStatus = {}, byStrategy = {}, bySprite = {}, items = {},
    }
    local function mapSummary(map, limit)
        local rows = {}
        for key, value in pairs(map or {}) do
            table.insert(rows, { key = tostring(key), value = tonumber(value) or 0 })
        end
        table.sort(rows, function(a, b)
            if a.value == b.value then return a.key < b.key end
            return a.value > b.value
        end)
        local parts = {}
        for index, row in ipairs(rows) do
            if index > (limit or 30) then break end
            table.insert(parts, row.key .. "=" .. tostring(row.value))
        end
        return table.concat(parts, ",")
    end

    local verification = job.verification or {}
    print("[EBF-DIAG-BEGIN] outcome=" .. tostring(outcome or "unknown")
            .. " title=" .. tostring(job.clipboard and job.clipboard.title or "")
            .. " source=" .. tostring(job.clipboard and job.clipboard.x) .. "," .. tostring(job.clipboard and job.clipboard.y) .. "," .. tostring(job.clipboard and job.clipboard.z)
            .. " target=" .. tostring(job.targetX) .. "," .. tostring(job.targetY) .. "," .. tostring(job.targetZ)
            .. " size=" .. tostring(job.clipboard and job.clipboard.w) .. "x" .. tostring(job.clipboard and job.clipboard.h)
            .. " zOffsets=" .. tostring(job.clipboard and table.concat(job.clipboard.zOffsets or {}, ",") or ""))
    print("[EBF-DIAG-SUMMARY] attempted=" .. tostring(diagnostic.total or 0)
            .. " created=" .. tostring(diagnostic.created or 0)
            .. " warnings=" .. tostring(diagnostic.warnings or 0)
            .. " failures=" .. tostring(diagnostic.failures or 0)
            .. " pastedCounter=" .. tostring(job.pasted or 0)
            .. " sourceObjects=" .. tostring(job.clipboard and #(job.clipboard.objects or {}) or 0)
            .. " verifyChecked=" .. tostring(verification.checked or 0)
            .. " verifyMissing=" .. tostring(verification.missing or 0)
            .. " verifyMismatch=" .. tostring(verification.mismatched or 0)
            .. " verifyExtra=" .. tostring(verification.extraObjects or 0))
    print("[EBF-DIAG-STATUS] " .. mapSummary(diagnostic.byStatus, 40))
    print("[EBF-DIAG-STRATEGY] " .. mapSummary(diagnostic.byStrategy, 40))
    print("[EBF-DIAG-SPRITES] " .. mapSummary(diagnostic.bySprite, 80))
    print("[EBF-DIAG-END] recordedItems=" .. tostring(#(diagnostic.items or {})))
end

local function processPasteObjects(job)
    local key = getPlayerKey(job.playerObj)
    setupPasteObjectBlocks(job)
    local block = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
    if block and (not block.objects or #block.objects == 0) then
        advancePasteObjectBlock(job)
        return
    end
    if not block then
        startPasteFinalizeRooms(job)
        return
    end

    local ready, finished = ensureCurrentPasteObjectBlockReady(key, job)
    if finished or not ready then
        return
    end

    block = job.pasteBlocks and job.pasteBlocks[job.pasteBlockIndex] or nil
    if not block then
        startPasteFinalizeRooms(job)
        return
    end

    if processPendingPasteContainerApplies(job) then
        sendPasteProgress(job, false)
        return
    end

    local simpleBudget = getBudgetValue(EBFCopyPaste.PasteSimpleObjectsPerTick, 8, 1)
    local simpleMaxBudget = getBudgetValue(EBFCopyPaste.PasteMaxSimpleObjectsPerTick, simpleBudget * 4, simpleBudget)
    local simpleTimeBudgetMs = getBudgetValue(EBFCopyPaste.PasteObjectTimeBudgetMs, 4, 0)
    local simpleProcessed = 0
    local tickStartMs = nowMs()
    local heavyBudget = getBudgetValue(EBFCopyPaste.PasteHeavyObjectsPerTick, 1, 1)
    local refreshSquare = nil
    local refreshX = nil
    local refreshY = nil
    local refreshZ = nil
    local function flushRefreshSquare()
        if refreshSquare then
            refreshSquareSystems(refreshSquare)
            refreshSquare = nil
            refreshX = nil
            refreshY = nil
            refreshZ = nil
        end
    end

    while block.objectIndex <= #block.objects do
        local entry = block.objects[block.objectIndex]
        local wasHeavy = entryIsHeavy(entry)
        local targetX = job.targetX + entry.dx
        local targetY = job.targetY + entry.dy
        local targetZ = job.targetZ + entry.dz
        local square = getOrCreateSquare(targetX, targetY, targetZ)
        if not square then
            flushRefreshSquare()
            failPasteJob(key, job, "El destino no está cargado en el servidor: "
                    .. tostring(targetX) .. "," .. tostring(targetY) .. "," .. tostring(targetZ)
                    .. ". Acerca al jugador a la zona y espera a que se carguen los chunks antes de pegar.")
            return
        end

        EBFCopyPasteServer.logPasteEntryStage(job, entry)
        if refreshSquare and (targetX ~= refreshX or targetY ~= refreshY or targetZ ~= refreshZ) then
            flushRefreshSquare()
        end

        local ok, object = false, nil
        if entry.floor then
            ok, object = pcall(pasteFloor, square, entry, job)
        else
            ok, object = pcall(pasteObject, square, entry, job.pendingContainerApplies, job)
        end
        if ok and object then
            job.pasted = (job.pasted or 0) + 1
            local actualSprite = getObjectSpriteName(object)
            local registered = entry.floor == true
                    or (EBFCopyPasteServer.objectIsRegisteredOnSquare
                        and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) == true)
            if not registered then
                EBFCopyPasteServer.recordPasteDiagnostic(job, entry, "notRegistered",
                        "El constructor devolvió un objeto, pero no figura en la lista de la casilla.", object, square)
            elseif entry.sprite and actualSprite and tostring(entry.sprite) ~= tostring(actualSprite) then
                EBFCopyPasteServer.recordPasteDiagnostic(job, entry, "spriteChanged",
                        "El objeto se creó con un sprite distinto del capturado.", object, square)
            else
                EBFCopyPasteServer.recordPasteDiagnostic(job, entry, "created", nil, object, square)
            end
        elseif not ok then
            EBFCopyPasteServer.recordPasteDiagnostic(job, entry, "luaError", object, nil, square)
        else
            local spriteExists = entry and entry.sprite and getSprite(entry.sprite) ~= nil
            EBFCopyPasteServer.recordPasteDiagnostic(job, entry,
                    spriteExists and "notCreated" or "spriteMissing",
                    spriteExists
                        and "La ruta de creación devolvió nil. Revisa strategy/class/isoType."
                        or "El sprite no existe en el servidor o no está cargado por los mods activos.",
                    nil, square)
        end
        refreshSquare = square
        refreshX = targetX
        refreshY = targetY
        refreshZ = targetZ
        block.objectIndex = block.objectIndex + 1
        job.objectIndex = (job.processedPasteObjects or 0) + block.objectIndex
        if processPendingPasteContainerApplies(job) then
            break
        end
        if wasHeavy then
            heavyBudget = heavyBudget - 1
            if heavyBudget <= 0 then
                break
            end
        else
            simpleProcessed = simpleProcessed + 1
            if reachedSimpleWorkBudget(tickStartMs, simpleTimeBudgetMs, simpleProcessed, simpleBudget, simpleMaxBudget) then
                break
            end
        end
    end
    flushRefreshSquare()
    if hasPendingPasteContainerApplies(job) then
        return
    end
    if block.objectIndex > #block.objects then
        advancePasteObjectBlock(job)
    end
end

startPasteFinalizeMove = function(job)
    if not job then
        return
    end
    job.sourceCells = nil
    job.sourceReady = true
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
    EBFCopyPasteServer.logStage(job, "finalize:moveSkipped", "FINALIZACIÓN: se omite el centro de la zona; selección limitada a 40×40 sin teletransporte.")
    startPasteFinalizeRooms(job)
end

startPasteFinalizeRooms = function(job)
    if job and job.powerZoneRegistered ~= true then
        job.powerZoneRegistered = true
    end
    if job and job.clipboard then
        EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard)
    end
    local _, _, zOffsets = getClipboardZRange(job.clipboard)
    job.phase = "finalizeRooms"
    job.finalizeZOffsets = zOffsets
    job.finalizeIndex = 1
    job.finalizeTotal = math.max(1, (tonumber(job.clipboard.w) or 1) * (tonumber(job.clipboard.h) or 1) * #zOffsets)
    job.detachedRooms = 0
    job.roomDefApplyAttempted = false
    job.roomDefsCreated = 0
    job.roomRectsCreated = 0
    job.lastFeedback = 0
    job.sourceReady = true
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
    EBFCopyPasteServer.logStage(job, "finalize:rooms", "FINALIZACIÓN de RoomDef: aplicando habitaciones vanilla; iluminación residencial fiel al RoomDef"
            .. " totalTiles=" .. tostring(job.finalizeTotal)
            .. " zOffsets=" .. tostring(table.concat(zOffsets or {}, ","))
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

local function startPasteFinalizeLights(job)
    if EBFCopyPasteServer.refreshRuntimeRoomsAfterDeferredLights then
        EBFCopyPasteServer.refreshRuntimeRoomsAfterDeferredLights(job)
    end
    job.phase = "finalizeLights"
    job.finalizeIndex = 1
    job.finalizeTotal = math.max(1, #(job.clipboard.objects or {}))
    job.finalizedLights = tonumber(job.finalizedLights) or 0
    job.finalizedFunctional = 0
    job.lastFeedback = 0
    EBFCopyPasteServer.logStage(job, "finalize:lights", "FINALIZACIÓN de luz/energía: validando interruptores, luces y dispositivos"
            .. " objetos=" .. tostring(job.finalizeTotal)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

local function buildDeferredLightingBlockList(job, entriesOverride)
    local blocks = buildPasteClearBlockList(job)
    local entries = entriesOverride or job and job.deferredLightingEntries or {}
    if not job then
        return blocks
    end

    local blockSize = math.max(1, EBFCopyPaste.toInt(EBFCopyPaste.CopyBlockSize, 50))
    local blocksPerRow = math.max(1, math.ceil((tonumber(job.clipboard and job.clipboard.w) or 1) / blockSize))
    for _, block in ipairs(blocks) do
        block.objects = {}
        block.objectIndex = 1
        block.totalObjects = 0
        block.sourceCells = nil
        block.sourceReady = false
        block.positionChecked = false
        block.categoryBuckets = {}
    end

    for _, entry in ipairs(entries) do
        if type(entry) == "table" then
            local dx = math.max(0, EBFCopyPasteServer.getPasteBlockInt(entry.dx, 0))
            local dy = math.max(0, EBFCopyPasteServer.getPasteBlockInt(entry.dy, 0))
            local blockX = math.floor(dx / blockSize)
            local blockY = math.floor(dy / blockSize)
            local blockIndex = (blockY * blocksPerRow) + blockX + 1
            local block = blocks[blockIndex]
            if block then
                table.insert(block.objects, entry)
                block.totalObjects = block.totalObjects + 1
            end
        end
    end

    for _, block in ipairs(blocks) do
        block.objects = EBFCopyPasteServer.sortPasteEntriesWithinCategory(block.objects or {})
        block.totalObjects = #block.objects
    end

    return blocks
end

function EBFCopyPasteServer.getDeferredLightEntryRoomKey(entry)
    if not entry then
        return nil
    end
    return entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key) or nil
end

function EBFCopyPasteServer.getDeferredLightGroupLabel(group)
    if not group then
        return "desconhecido"
    end
    if group.kind == "room" then
        return tostring(group.name or "room") .. " key=" .. tostring(group.key or "?")
    end
    return tostring(group.name or group.kind or "luces")
end

function EBFCopyPasteServer.buildDeferredLightingGroups(job)
    local entries = job and job.deferredLightingEntries or {}
    if not job or #entries == 0 then
        return {}
    end

    local groups = {}
    local byKey = {}
    local roomSpecs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard)
    for _, spec in ipairs(roomSpecs or {}) do
        if spec and spec.key then
            local group = {
                kind = "room",
                key = spec.key,
                name = spec.name or spec.sourceRoomDefName or "room",
                dz = EBFCopyPaste.toInt(spec.dz, 0),
                spec = spec,
                entries = {},
            }
            byKey[spec.key] = group
            table.insert(groups, group)
        end
    end

    local residentialWithoutRoom = {
        kind = "unmappedRoom",
        key = "__unmapped_residential_lights",
        name = "interruptores residenciales sin RoomDef",
        entries = {},
    }
    local ownLightGroup = {
        kind = "ownLight",
        key = "__own_light_switches",
        name = "luces propias, exteriores y lámparas",
        entries = {},
    }

    for _, entry in ipairs(entries) do
        if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
            local key = EBFCopyPasteServer.getDeferredLightEntryRoomKey(entry)
            local group = key and byKey[key] or nil
            if not group then
                local spec = EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
                group = spec and spec.key and byKey[spec.key] or nil
            end
            table.insert((group or residentialWithoutRoom).entries, entry)
        else
            table.insert(ownLightGroup.entries, entry)
        end
    end

    local result = {}
    for _, group in ipairs(groups) do
        if #group.entries > 0 then
            group.blocks = buildDeferredLightingBlockList(job, group.entries)
            table.insert(result, group)
        end
    end
    if #residentialWithoutRoom.entries > 0 then
        residentialWithoutRoom.blocks = buildDeferredLightingBlockList(job, residentialWithoutRoom.entries)
        table.insert(result, residentialWithoutRoom)
    end
    if #ownLightGroup.entries > 0 then
        ownLightGroup.blocks = buildDeferredLightingBlockList(job, ownLightGroup.entries)
        table.insert(result, ownLightGroup)
    end
    return result
end

function EBFCopyPasteServer.getCurrentDeferredLightGroup(job)
    return job and job.deferredLightGroups and job.deferredLightGroups[job.deferredLightGroupIndex or 1] or nil
end

function EBFCopyPasteServer.getCurrentDeferredLightBlock(job)
    local group = EBFCopyPasteServer.getCurrentDeferredLightGroup(job)
    if group and group.blocks then
        return group.blocks[job.deferredLightBlockIndex or 1]
    end
    return job and job.deferredLightBlocks and job.deferredLightBlocks[job.deferredLightBlockIndex or 1] or nil
end

function EBFCopyPasteServer.refreshDeferredLightGroupRoom(job, group, phase)
    if not job or not group or group.kind ~= "room" or not group.spec then
        return false
    end

    EBFCopyPasteServer.buildRuntimeRoomDefLookup(job)
    local runtime = job.roomDefRuntimeBySpec and job.roomDefRuntimeBySpec[group.spec] or nil
    if not runtime and group.key and job.roomDefRuntimeByKey then
        runtime = job.roomDefRuntimeByKey[group.key]
    end
    if not runtime then
        return false
    end

    local roomDef = runtime.roomDef
    local room = runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, group.spec, runtime)
    runtime.room = room
    if roomDef then
        EBFCopyPasteServer.tryCallMethod(roomDef, "refreshSquares")
    end
    if room then
        EBFCopyPasteServer.tryCallMethod(room, "refreshSquares")
    end
    group.lastRoomRefreshPhase = phase
    return room ~= nil
end

function EBFCopyPasteServer.prepareDeferredLightGroup(job, group)
    if not job or not group or group.prepared == true then
        return
    end

    group.prepared = true
    EBFCopyPasteServer.refreshDeferredLightGroupRoom(job, group, "start")
    EBFCopyPasteServer.logStage(job,
            EBFCopyPasteServer.makeStageKey("pasteDeferredLights:groupStart", group.key or job.deferredLightGroupIndex),
            "PASTE luz grupo iniciado: "
            .. EBFCopyPasteServer.getDeferredLightGroupLabel(group)
            .. " entradas=" .. tostring(#(group.entries or {}))
            .. " blocos=" .. tostring(#(group.blocks or {}))
            .. " grupo=" .. tostring(job.deferredLightGroupIndex or 1)
            .. "/" .. tostring(#(job.deferredLightGroups or {}))
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.finishDeferredLightGroup(job, group)
    if not job or not group or group.completed == true then
        return
    end

    group.completed = true
    EBFCopyPasteServer.refreshDeferredLightGroupRoom(job, group, "done")
    EBFCopyPasteServer.logStage(job,
            EBFCopyPasteServer.makeStageKey("pasteDeferredLights:groupDone", group.key or job.deferredLightGroupIndex),
            "PEGADO: grupo de luces completado: "
            .. EBFCopyPasteServer.getDeferredLightGroupLabel(group)
            .. " entradas=" .. tostring(#(group.entries or {}))
            .. " switchesVinculados=" .. tostring(job.roomRuntimeSwitchesBound or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.markDeferredLightEntryFinalized(job, entry)
    if not job or not entry then
        return
    end

    local key = EBFCopyPasteServer.makeEntryPasteKey and EBFCopyPasteServer.makeEntryPasteKey(job, entry) or nil
    if not key then
        return
    end
    job.deferredLightFinalizedEntries = job.deferredLightFinalizedEntries or {}
    job.deferredLightFinalizedEntries[key] = true
end

function EBFCopyPasteServer.deferredLightEntryWasFinalized(job, entry)
    if not job or not entry or not job.deferredLightFinalizedEntries then
        return false
    end

    local key = EBFCopyPasteServer.makeEntryPasteKey and EBFCopyPasteServer.makeEntryPasteKey(job, entry) or nil
    return key ~= nil and job.deferredLightFinalizedEntries[key] == true
end

startPasteDeferredLights = function(job)
    if not job then
        return
    end
    if not job.deferredLightingEntries or #job.deferredLightingEntries == 0 then
        EBFCopyPasteServer.logStage(job, "pasteDeferredLights:none", "PEGADO de luces diferidas: no hay luces esperando RoomDef"
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        startPasteFinalizeLights(job)
        return
    end

    job.phase = "pasteDeferredLights"
    job.deferredLightGroups = EBFCopyPasteServer.buildDeferredLightingGroups(job)
    job.deferredLightBlocks = nil
    if #job.deferredLightGroups == 0 then
        EBFCopyPasteServer.logStage(job, "pasteDeferredLights:none", "PEGADO de luces diferidas: no hay ningún grupo válido"
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        startPasteFinalizeLights(job)
        return
    end
    job.deferredLightGroupIndex = 1
    job.deferredLightBlockIndex = 1
    job.deferredLightObjectIndex = 1
    job.processedDeferredLightObjects = 0
    job.deferredLightInitialWaitTicks = 0
    job.deferredLightFinalizedEntries = {}
    job.finalizeIndex = 1
    job.finalizeTotal = math.max(1, #job.deferredLightingEntries)
    job.sourceCells = nil
    job.sourceReady = false
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
    job.lastFeedback = 0
    EBFCopyPasteServer.forceRuntimeRoomLightsInactive(job, "antesDeferredLights")
    EBFCopyPasteServer.ensureRuntimeRoomLights(job, "antesDeferredLightsVanilla")
    EBFCopyPasteServer.logStage(job, "pasteDeferredLights:start", "PEGADO de luces diferidas iniciado: luces="
            .. tostring(#job.deferredLightingEntries)
            .. " grupos=" .. tostring(#(job.deferredLightGroups or {}))
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

local function advanceDeferredLightBlock(job)
    local group = EBFCopyPasteServer.getCurrentDeferredLightGroup(job)
    local block = EBFCopyPasteServer.getCurrentDeferredLightBlock(job)
    if block then
        job.processedDeferredLightObjects = (job.processedDeferredLightObjects or 0) + (block.totalObjects or 0)
    end
    job.deferredLightBlockIndex = (job.deferredLightBlockIndex or 1) + 1
    job.deferredLightObjectIndex = (job.processedDeferredLightObjects or 0) + 1
    job.finalizeIndex = job.deferredLightObjectIndex
    job.sourceCells = nil
    job.sourceReady = false
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0
    if group and (job.deferredLightBlockIndex or 1) > #(group.blocks or {}) then
        EBFCopyPasteServer.finishDeferredLightGroup(job, group)
        job.deferredLightGroupIndex = (job.deferredLightGroupIndex or 1) + 1
        job.deferredLightBlockIndex = 1
        job.deferredLightInitialWaitTicks = 0
    end
    if (job.deferredLightGroupIndex or 1) > #(job.deferredLightGroups or {}) then
        startPasteFinalizeLights(job)
    end
end

local function ensureCurrentDeferredLightBlockReady(key, job)
    local group = EBFCopyPasteServer.getCurrentDeferredLightGroup(job)
    if not group then
        startPasteFinalizeLights(job)
        return false, true
    end

    EBFCopyPasteServer.prepareDeferredLightGroup(job, group)
    local block = EBFCopyPasteServer.getCurrentDeferredLightBlock(job)
    if not block then
        startPasteFinalizeLights(job)
        return false, true
    end

    if not block.objects or #block.objects == 0 then
        advanceDeferredLightBlock(job)
        return false, false
    end

    if (job.deferredLightInitialWaitTicks or 0) > 0 then
        job.deferredLightInitialWaitTicks = job.deferredLightInitialWaitTicks - 1
        sendPasteProgress(job, false)
        return false
    end

    if not block.positionChecked then
        block.positionChecked = true
    end
    block.sourceReady = true
    job.sourceReady = true
    job.sourceLoadedCells = job.sourceTotalCells or 0

    return true
end

local function processPasteDeferredLights(job)
    local key = getPlayerKey(job.playerObj)
    local ready, finished = ensureCurrentDeferredLightBlockReady(key, job)
    if finished or not ready then
        return
    end

    local block = EBFCopyPasteServer.getCurrentDeferredLightBlock(job)
    if not block then
        startPasteFinalizeLights(job)
        return
    end

    local budget = getBudgetValue(EBFCopyPaste.PasteFinalizeObjectsPerTick, 16, 1)
    while budget > 0 and block.objectIndex <= #block.objects do
        local entry = block.objects[block.objectIndex]

        local targetX = job.targetX + entry.dx
        local targetY = job.targetY + entry.dy
        local targetZ = job.targetZ + entry.dz
        local square = getOrCreateSquare(targetX, targetY, targetZ)
        if not square then
            failPasteJob(key, job, "El destino no está cargado en el servidor para la luz: "
                    .. tostring(targetX) .. "," .. tostring(targetY) .. "," .. tostring(targetZ)
                    .. ". Acerca al jugador a la zona y espera a que se carguen los chunks antes de pegar.")
            return
        end

        EBFCopyPasteServer.logPasteEntryStage(job, entry)
        local ok, object = pcall(pasteObject, square, entry, job.pendingContainerApplies, job)
        if ok and object then
            job.pasted = (job.pasted or 0) + 1
            if finalizePastedLightSwitchEntry then
                local finalized = finalizePastedLightSwitchEntry(job, entry) or 0
                if finalized > 0 then
                    job.finalizedLights = (tonumber(job.finalizedLights) or 0) + finalized
                    EBFCopyPasteServer.markDeferredLightEntryFinalized(job, entry)
                end
            end
            refreshSquareSystems(square)
        end

        block.objectIndex = block.objectIndex + 1
        job.deferredLightObjectIndex = (job.processedDeferredLightObjects or 0) + block.objectIndex
        job.finalizeIndex = job.deferredLightObjectIndex
        budget = budget - 1
    end

    if block.objectIndex > #block.objects then
        advanceDeferredLightBlock(job)
    end
end

function EBFCopyPasteServer.startPasteFinalizeSync(job)
    local missingRuntimeBuildings = 0
    if job.roomDefPersistenceDisabled ~= true then
        missingRuntimeBuildings = EBFCopyPasteServer.ensureRuntimeRoomsHaveBuildings(job, "finalizeSync")
    end
    if missingRuntimeBuildings > 0 then
        failPasteJob(getPlayerKey(job.playerObj), job,
                "RoomDef en tiempo de ejecución sin IsoBuilding durante la finalización: "
                .. tostring(missingRuntimeBuildings)
                .. " habitaciones no válidas. Se ha interrumpido el pegado para evitar un error vanilla.")
        return false
    end
    EBFCopyPasteServer.reorderPastedSquareObjects(job)
    EBFCopyPasteServer.restorePastedWorldInventoryOffsets(job, "preFinalSync")
    EBFCopyPasteServer.logStage(job, "finalize:lightsPrepared", "FINALIZACIÓN: luz preparada para sincronizar; luces="
            .. tostring(job.finalizedLights or 0)
            .. " switchesVinculados=" .. tostring(job.roomRuntimeSwitchesBound or 0)
            .. " switchesAuditados=" .. tostring(job.roomRuntimeSwitchesAudited or 0)
            .. " vanillaRoomBindings=" .. tostring(job.vanillaRoomLightBindingsApplied or 0)
            .. " vanillaRoomFalhas=" .. tostring((job.vanillaRoomLightBindingFailures or 0) + (job.vanillaRoomLightAuditFailures or 0))
            .. " exactLampBindingsIgnorados=" .. tostring(job.exactLightBindingsSkippedMoveableLamp or 0)
            .. " exactRoomSwitchBindingsIgnorados=" .. tostring(job.exactLightBindingsSkippedResidentialSwitch or 0)
            .. " roomLinksBloqueados=" .. tostring(job.roomRuntimeSwitchRoomFallbackBlocked or 0)
            .. " roomLinksRemovidos=" .. tostring(job.roomRuntimeSwitchesDetached or 0)
            .. " roomSwitchListsRuntimeLimpas=" .. tostring(job.runtimeRoomSwitchListsClearedFinal or 0)
            .. " roomLightsRuntimeLimpos=" .. tostring(job.runtimeRoomLightsClearedFinal or 0)
            .. " roomDefFallback=" .. tostring(job.roomDefPersistenceDisabled == true)
            .. " estructurasIsoObject=" .. tostring(job.structuralIsoObjectsCreated or 0)
            .. " estructurasIsoObjectFallidas=" .. tostring(job.structuralIsoObjectsFailed or 0)
            .. " fallbackBrushEstructural=" .. tostring(job.structuralBrushFallbackCreated or 0)
            .. " fallbackBrushEstructuralFallido=" .. tostring(job.structuralBrushFallbackFailed or 0)
            .. " ordemSquares=" .. tostring(job.objectOrderRebuildChanged or 0)
            .. " worldItemOffsets=" .. tostring(job.worldItemOffsetsRestored or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    local entryCount = #(job.clipboard.objects or {})
    local extraCount = #(job.finalSyncObjects or {})
    job.phase = "finalizeSync"
    job.finalizeIndex = 1
    job.finalizeTotal = math.max(1, entryCount + extraCount)
    job.finalSyncEntryTotal = entryCount
    job.finalSyncSent = 0
    job.finalSyncSentSet = {}
    job.finalSyncDone = false
    job.lastFeedback = 0
    EBFCopyPasteServer.logStage(job, "finalize:sync", "FINALIZE sync: transmitindo objetos finais"
            .. " objetos=" .. tostring(entryCount)
            .. " extras=" .. tostring(extraCount)
            .. " jaAdicionadosVanillaReenviados=" .. tostring(job.finalSyncAlreadyAddedQueued or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    return true
end

local function processPasteFinalizeRooms(job)
    if job.roomDefApplyAttempted ~= true then
        EBFCopyPasteServer.applyClipboardRoomDefs(job)
    end
    if job.roomDefApplyFailed == true then
        failPasteJob(getPlayerKey(job.playerObj), job,
                job.roomDefApplyFailureMessage or "RoomDef en tiempo de ejecución incompleto; pegado interrumpido.")
        return
    end
    job.finalizeIndex = math.max(1, tonumber(job.finalizeTotal) or 1) + 1
    job.prePasteRoomsDone = true
    if job.roomDefPersistenceDisabled == true then
        -- No se pide al cliente reconciliar RoomDef que deliberadamente no se han creado.
        startPasteDeferredLights(job)
    elseif EBFCopyPasteServer.startClientRoomDefReconcile(job) ~= true then
        startPasteDeferredLights(job)
    end
end

local function processPasteFinalizeLights(job)
    local objects = job.clipboard.objects or {}
    local budget = getBudgetValue(EBFCopyPaste.PasteFinalizeObjectsPerTick, 16, 1)
    while budget > 0 and (job.finalizeIndex or 1) <= #objects do
        local entry = objects[job.finalizeIndex or 1]
        if EBFCopyPasteServer.finalizePastedFunctionalEntry then
            job.finalizedFunctional = (job.finalizedFunctional or 0) + (EBFCopyPasteServer.finalizePastedFunctionalEntry(job, entry) or 0)
        end
        if finalizePastedLightSwitchEntry
                and not EBFCopyPasteServer.deferredLightEntryWasFinalized(job, entry)
                and not EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
            job.finalizedLights = (job.finalizedLights or 0) + (finalizePastedLightSwitchEntry(job, entry) or 0)
        end
        job.finalizeIndex = (job.finalizeIndex or 1) + 1
        budget = budget - 1
    end
end

local function processPasteClientAreaReconcile(job)
    if not job then
        return
    end
    if job.clientAreaReconcileSent ~= true then
        EBFCopyPasteServer.sendClientPasteAreaReconcile(job, job.restoreSafehouse and "restoreStart" or "pasteStart")
    end
    job.clientAreaReconcileTicks = (tonumber(job.clientAreaReconcileTicks) or 0) + 1
    if job.clientAreaReconcileTicks < 3 then
        sendPasteProgress(job, false)
        return
    end
    job.phase = "clear"
    job.tileIndex = 1
    job.lastFeedback = 0
end

function EBFCopyPasteServer.startClientRoomDefReconcile(job)
    if not job or not job.clipboard then
        return false
    end
    if job.roomDefPersistenceDisabled == true then
        return false
    end

    local roomSpecs = EBFCopyPasteServer.ensureClipboardRoomSpecs(job.clipboard) or {}
    local residentialSwitches = EBFCopyPasteServer.countResidentialLightSwitchEntries(job.clipboard)
    if #roomSpecs <= 0 then
        if residentialSwitches > 0 then
            job.phase = "clientRoomDefReconcile"
            job.clientRoomDefReconcileTicks = 0
            job.clientRoomDefReconcileMinTicks = 1
            job.clientRoomDefReconcileTimeoutTicks = 1
            job.clientRoomDefReconcileTotal = 1
            job.clientRoomDefResidentialSwitches = residentialSwitches
            job.clientRoomDefExpectedRooms = 0
            job.clientRoomDefExpectedRects = 0
            job.clientRoomDefReconcileStrict = true
            job.clientRoomDefReconcileFailed = true
            job.clientRoomDefReconcileFailureMessage = "Falta el RoomDef del interruptor interior; se ha interrumpido el pegado antes de las luces."
            EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync",
                    "Falta el RoomDef del portapapeles; SE BLOQUEAN las luces interiores"
                            .. " residentialSwitches=" .. tostring(residentialSwitches))
            return true
        end
        return false
    end

    local expectedRects = EBFCopyPasteServer.countRoomSpecRects(roomSpecs)
    if expectedRects <= 0 and residentialSwitches > 0 then
        job.phase = "clientRoomDefReconcile"
        job.clientRoomDefReconcileTicks = 0
        job.clientRoomDefReconcileMinTicks = 1
        job.clientRoomDefReconcileTimeoutTicks = 1
        job.clientRoomDefReconcileTotal = 1
        job.clientRoomDefResidentialSwitches = residentialSwitches
        job.clientRoomDefExpectedRooms = #roomSpecs
        job.clientRoomDefExpectedRects = expectedRects
        job.clientRoomDefReconcileStrict = true
        job.clientRoomDefReconcileFailed = true
        job.clientRoomDefReconcileFailureMessage = "RoomDef sin rectángulos para el interruptor interior; se ha interrumpido el pegado antes de las luces."
        EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync",
                "RoomDef del portapapeles sin rectángulos; SE BLOQUEAN las luces interiores"
                        .. " roomSpecs=" .. tostring(#roomSpecs)
                        .. " residentialSwitches=" .. tostring(residentialSwitches))
        return true
    end
    job.clientRoomDefReconcileId = tostring(nowMs()) .. ":" .. tostring(math.floor((tonumber(job.targetX) or 0) % 100000))
            .. ":" .. tostring(math.floor((tonumber(job.targetY) or 0) % 100000))
    job.clientRoomDefReconcileAck = false
    job.clientRoomDefReconcileAckOk = nil
    job.clientRoomDefReconcileAckRooms = 0
    job.clientRoomDefReconcileAckRects = 0
    job.clientRoomDefReconcileLastSendTick = 0
    job.clientRoomDefResidentialSwitches = residentialSwitches
    job.clientRoomDefExpectedRooms = #roomSpecs
    job.clientRoomDefExpectedRects = expectedRects
    job.clientRoomDefReconcileStrict = residentialSwitches > 0
    local sent = EBFCopyPasteServer.sendClientPasteAreaReconcile(job, "roomDefsApplied")
    if sent ~= true and job.clientRoomDefReconcileStrict == true then
        job.phase = "clientRoomDefReconcile"
        job.clientRoomDefReconcileTicks = 0
        job.clientRoomDefReconcileMinTicks = 1
        job.clientRoomDefReconcileTimeoutTicks = 1
        job.clientRoomDefReconcileTotal = 1
        job.clientRoomDefReconcileFailed = true
        job.clientRoomDefReconcileFailureMessage = "El RoomDef del cliente no puede sincronizarse; se ha interrumpido el pegado antes de las luces interiores."
        EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync",
                "RoomDef del cliente sin canal de reconciliación; SE BLOQUEAN las luces interiores"
                        .. " residentialSwitches=" .. tostring(residentialSwitches))
        return true
    elseif sent ~= true then
        return false
    end
    job.phase = "clientRoomDefReconcile"
    job.clientRoomDefReconcileTicks = 0
    job.clientRoomDefReconcileMinTicks = math.max(1, tonumber(EBFCopyPaste.ClientRoomDefSyncTicks) or 12)
    job.clientRoomDefReconcileTimeoutTicks = math.max(job.clientRoomDefReconcileMinTicks,
            tonumber(EBFCopyPaste.ClientRoomDefAckTimeoutTicks) or 90)
    job.clientRoomDefReconcileTotal = job.clientRoomDefReconcileTimeoutTicks
    job.lastFeedback = 0
    EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync", "FINALIZACIÓN: RoomDef del cliente esperando reconciliación"
            .. " minTicks=" .. tostring(job.clientRoomDefReconcileMinTicks)
            .. " timeoutTicks=" .. tostring(job.clientRoomDefReconcileTimeoutTicks)
            .. " roomSpecs=" .. tostring(#roomSpecs)
            .. " expectedRects=" .. tostring(expectedRects)
            .. " residentialSwitches=" .. tostring(residentialSwitches)
            .. " strict=" .. tostring(job.clientRoomDefReconcileStrict)
            .. " id=" .. tostring(job.clientRoomDefReconcileId)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    return true
end

function EBFCopyPasteServer.processClientRoomDefReconcile(job)
    if not job then
        return false
    end
    if job.clientRoomDefReconcileFailed == true then
        return false
    end

    job.clientRoomDefReconcileTicks = (tonumber(job.clientRoomDefReconcileTicks) or 0) + 1
    local ticks = tonumber(job.clientRoomDefReconcileTicks) or 0
    local minTicks = math.max(1, tonumber(job.clientRoomDefReconcileMinTicks) or tonumber(EBFCopyPaste.ClientRoomDefSyncTicks) or 12)
    local timeoutTicks = math.max(minTicks, tonumber(job.clientRoomDefReconcileTimeoutTicks)
            or tonumber(EBFCopyPaste.ClientRoomDefAckTimeoutTicks) or 90)
    if job.clientRoomDefReconcileAckOk == true and ticks >= minTicks then
        return true
    end
    if ticks < timeoutTicks
            and ticks - (tonumber(job.clientRoomDefReconcileLastSendTick) or 0) >= 20 then
        job.clientRoomDefReconcileLastSendTick = ticks
        EBFCopyPasteServer.sendClientPasteAreaReconcile(job, "roomDefsApplied")
        EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync", "RoomDef del cliente sin ACK positivo; se reenvía la reconciliación"
                .. " tick=" .. tostring(ticks)
                .. " id=" .. tostring(job.clientRoomDefReconcileId)
                .. " ack=" .. tostring(job.clientRoomDefReconcileAck)
                .. " ok=" .. tostring(job.clientRoomDefReconcileAckOk)
                .. " rooms=" .. tostring(job.clientRoomDefReconcileAckRooms or 0)
                .. " rects=" .. tostring(job.clientRoomDefReconcileAckRects or 0))
    end
    if ticks >= timeoutTicks then
        if job.clientRoomDefReconcileStrict == true then
            job.clientRoomDefReconcileFailed = true
            job.clientRoomDefReconcileFailureMessage = "RoomDef del cliente sin ACK positivo; se ha interrumpido el pegado antes de las luces interiores."
            EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync", "Tiempo de espera del ACK de RoomDef del cliente agotado; SE BLOQUEAN las luces interiores"
                    .. " id=" .. tostring(job.clientRoomDefReconcileId)
                    .. " ack=" .. tostring(job.clientRoomDefReconcileAck)
                    .. " ok=" .. tostring(job.clientRoomDefReconcileAckOk)
                    .. " rooms=" .. tostring(job.clientRoomDefReconcileAckRooms or 0)
                    .. " rects=" .. tostring(job.clientRoomDefReconcileAckRects or 0)
                    .. " residentialSwitches=" .. tostring(job.clientRoomDefResidentialSwitches or 0))
            return false
        end
        EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync", "Tiempo de espera del ACK de RoomDef del cliente agotado; se continúa para no bloquear el pegado"
                .. " id=" .. tostring(job.clientRoomDefReconcileId)
                .. " ack=" .. tostring(job.clientRoomDefReconcileAck)
                .. " ok=" .. tostring(job.clientRoomDefReconcileAckOk)
                .. " rooms=" .. tostring(job.clientRoomDefReconcileAckRooms or 0)
                .. " rects=" .. tostring(job.clientRoomDefReconcileAckRects or 0))
        return true
    end
    return false
end

function EBFCopyPasteServer.countResidentialLightSwitchEntries(clipboard)
    local count = 0
    for _, entry in ipairs(clipboard and clipboard.objects or {}) do
        if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry) then
            count = count + 1
        end
    end
    return count
end

function EBFCopyPasteServer.countRoomSpecRects(roomSpecs)
    local count = 0
    for _, spec in ipairs(roomSpecs or {}) do
        count = count + #(spec.rects or {})
    end
    return count
end

function EBFCopyPasteServer.handleClientRoomDefReconcileAck(playerObj, args)
    local key = getPlayerKey(playerObj)
    local job = EBFCopyPasteServer.pasteJobs[key]
    if not job or job.phase ~= "clientRoomDefReconcile" then
        return
    end

    local ackId = tostring(args and args.id or "")
    if ackId == "" or ackId ~= tostring(job.clientRoomDefReconcileId or "") then
        EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync", "ACK RoomDef cliente ignorado: id inesperado"
                .. " recebido=" .. tostring(ackId)
                .. " esperado=" .. tostring(job.clientRoomDefReconcileId))
        return
    end

    job.clientRoomDefReconcileAck = true
    job.clientRoomDefReconcileAckRooms = math.max(0, tonumber(args and args.roomDefs) or 0)
    job.clientRoomDefReconcileAckRects = math.max(0, tonumber(args and args.roomRects) or 0)
    job.clientRoomDefReconcileAckSkipped = math.max(0, tonumber(args and args.skippedRoomRects) or 0)
    job.clientRoomDefReconcileAckExpectedRooms = math.max(0, tonumber(args and args.expectedRoomDefs) or 0)
    job.clientRoomDefReconcileAckExpectedRects = math.max(0, tonumber(args and args.expectedRoomRects) or 0)
    job.clientRoomDefReconcileServerOwned = args and args.serverOwnedRoomDefs == true
    local expectedRooms = math.max(0, tonumber(job.clientRoomDefExpectedRooms) or 0)
    local expectedRects = math.max(0, tonumber(job.clientRoomDefExpectedRects) or 0)
    local clientExpectedRooms = math.max(0, tonumber(job.clientRoomDefReconcileAckExpectedRooms) or 0)
    local clientExpectedRects = math.max(0, tonumber(job.clientRoomDefReconcileAckExpectedRects) or 0)
    local expectedCountsOk = (clientExpectedRooms <= 0 or clientExpectedRooms == expectedRooms)
            and (clientExpectedRects <= 0 or clientExpectedRects == expectedRects)
    local ackCountsOk = false
    if job.clientRoomDefReconcileServerOwned == true then
        ackCountsOk = expectedCountsOk and job.clientRoomDefReconcileAckSkipped <= 0
    else
        ackCountsOk = job.clientRoomDefReconcileAckRooms >= expectedRooms
                and job.clientRoomDefReconcileAckRects >= expectedRects
                and job.clientRoomDefReconcileAckSkipped <= 0
                and expectedCountsOk
    end
    job.clientRoomDefReconcileAckOk = args and args.ok == true and ackCountsOk == true
    if job.clientRoomDefReconcileAckOk ~= true and job.clientRoomDefReconcileStrict == true then
        job.clientRoomDefReconcileFailed = true
        job.clientRoomDefReconcileFailureMessage = "ACK de RoomDef del cliente no válido; se ha interrumpido el pegado antes de las luces interiores."
    end
    EBFCopyPasteServer.logStage(job, "finalize:clientRoomDefSync", "ACK RoomDef cliente recebido"
            .. " ok=" .. tostring(job.clientRoomDefReconcileAckOk)
            .. " clientOk=" .. tostring(args and args.ok == true)
            .. " rooms=" .. tostring(job.clientRoomDefReconcileAckRooms)
            .. "/" .. tostring(expectedRooms)
            .. " rects=" .. tostring(job.clientRoomDefReconcileAckRects)
            .. "/" .. tostring(expectedRects)
            .. " skipped=" .. tostring(job.clientRoomDefReconcileAckSkipped)
            .. " clientExpected=" .. tostring(clientExpectedRooms) .. "/" .. tostring(clientExpectedRects)
            .. " serverOwned=" .. tostring(job.clientRoomDefReconcileServerOwned)
            .. " id=" .. tostring(ackId)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.computeFinalClientAckExpectedSquares(job)
    local clipboard = job and job.clipboard or {}
    local width = math.max(1, math.floor(tonumber(clipboard.w) or 1))
    local height = math.max(1, math.floor(tonumber(clipboard.h) or 1))
    local levels = 0
    if type(clipboard.zOffsets) == "table" then
        for _, value in ipairs(clipboard.zOffsets) do
            if tonumber(value) ~= nil then
                levels = levels + 1
            end
        end
    end
    if levels <= 0 then
        levels = math.max(1, math.floor(tonumber(clipboard.levels) or 1))
    end
    return width * height * levels
end

function EBFCopyPasteServer.startFinalClientAck(job)
    if not job then
        return false
    end

    job.phase = "finalClientAck"
    job.finalClientAckId = tostring(nowMs()) .. ":" .. tostring(math.floor((tonumber(job.targetX) or 0) % 100000))
            .. ":" .. tostring(math.floor((tonumber(job.targetY) or 0) % 100000))
    job.finalClientAckTicks = 0
    job.finalClientAckMinTicks = math.max(1, tonumber(EBFCopyPaste.FinalClientAckMinTicks) or 2)
    job.finalClientAckTimeoutTicks = math.max(job.finalClientAckMinTicks,
            tonumber(EBFCopyPaste.FinalClientAckTimeoutTicks) or 90)
    job.finalClientAckTotal = job.finalClientAckTimeoutTicks
    job.finalClientAckExpectedSquares = EBFCopyPasteServer.computeFinalClientAckExpectedSquares(job)
    job.finalClientAckExpectedObjects = #(job.clipboard and job.clipboard.objects or {})
    job.finalClientAckReceived = false
    job.finalClientAckOk = nil
    job.finalClientAckLastSendTick = 0
    job.finalClientAckFailureMessage = nil
    job.lastFeedback = 0

    local sent = EBFCopyPasteServer.sendClientPasteAreaReconcile(job, job.restoreSafehouse and "restoreDone" or "pasteDone")
    if sent ~= true then
        job.finalClientAckFailed = true
        job.finalClientAckFailureMessage = "El cliente no puede recibir la reconciliación visual final; se ha interrumpido el pegado para evitar un falso éxito."
        EBFCopyPasteServer.logStage(job, "final:clientAck", "ACK visual final sin canal de envío; SE BLOQUEA el resultado correcto"
                .. " id=" .. tostring(job.finalClientAckId)
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        return false
    end

    EBFCopyPasteServer.logStage(job, "final:clientAck", "FINAL: esperando el ACK visual del cliente"
            .. " id=" .. tostring(job.finalClientAckId)
            .. " expectedSquares=" .. tostring(job.finalClientAckExpectedSquares)
            .. " expectedObjects=" .. tostring(job.finalClientAckExpectedObjects)
            .. " minTicks=" .. tostring(job.finalClientAckMinTicks)
            .. " timeoutTicks=" .. tostring(job.finalClientAckTimeoutTicks)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    return true
end

function EBFCopyPasteServer.processFinalClientAck(job)
    if not job then
        return false
    end
    if job.finalClientAckFailed == true then
        return false
    end

    job.finalClientAckTicks = (tonumber(job.finalClientAckTicks) or 0) + 1
    local ticks = tonumber(job.finalClientAckTicks) or 0
    local minTicks = math.max(1, tonumber(job.finalClientAckMinTicks) or tonumber(EBFCopyPaste.FinalClientAckMinTicks) or 2)
    local timeoutTicks = math.max(minTicks, tonumber(job.finalClientAckTimeoutTicks)
            or tonumber(EBFCopyPaste.FinalClientAckTimeoutTicks) or 90)

    if job.finalClientAckOk == true and ticks >= minTicks then
        return true
    end

    if ticks < timeoutTicks
            and ticks - (tonumber(job.finalClientAckLastSendTick) or 0) >= 20 then
        job.finalClientAckLastSendTick = ticks
        EBFCopyPasteServer.sendClientPasteAreaReconcile(job, job.restoreSafehouse and "restoreDone" or "pasteDone")
        EBFCopyPasteServer.logStage(job, "final:clientAck:resend", "ACK visual final pendente; reenviando reconcile"
                .. " tick=" .. tostring(ticks)
                .. " id=" .. tostring(job.finalClientAckId)
                .. " recebido=" .. tostring(job.finalClientAckReceived)
                .. " ok=" .. tostring(job.finalClientAckOk)
                .. " squares=" .. tostring(job.finalClientAckSquares or 0)
                .. "/" .. tostring(job.finalClientAckExpectedSquares or 0))
    end

    if ticks >= timeoutTicks then
        job.finalClientAckFailed = true
        job.finalClientAckFailureMessage = "El cliente no ha confirmado la sincronización visual final; se ha interrumpido el pegado para evitar objetos invisibles hasta volver a entrar."
        EBFCopyPasteServer.logStage(job, "final:clientAck:timeout", "ACK visual final timeout; BLOQUEANDO sucesso"
                .. " id=" .. tostring(job.finalClientAckId)
                .. " recebido=" .. tostring(job.finalClientAckReceived)
                .. " ok=" .. tostring(job.finalClientAckOk)
                .. " squares=" .. tostring(job.finalClientAckSquares or 0)
                .. "/" .. tostring(job.finalClientAckExpectedSquares or 0)
                .. " materializados=" .. tostring(job.finalClientAckMaterializedSquares or 0)
                .. " chunksLight=" .. tostring(job.finalClientAckChunksLight or 0)
                .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
        return false
    end

    return false
end

function EBFCopyPasteServer.handleClientPasteVisualAck(playerObj, args)
    local key = getPlayerKey(playerObj)
    local job = EBFCopyPasteServer.pasteJobs[key]
    if not job or job.phase ~= "finalClientAck" then
        return
    end

    local ackId = tostring(args and args.id or "")
    if ackId == "" or ackId ~= tostring(job.finalClientAckId or "") then
        EBFCopyPasteServer.logStage(job, "final:clientAck:ignored", "ACK visual final ignorado: id inesperado"
                .. " recebido=" .. tostring(ackId)
                .. " esperado=" .. tostring(job.finalClientAckId))
        return
    end

    job.finalClientAckReceived = true
    job.finalClientAckSquares = math.max(0, tonumber(args and args.squares) or 0)
    job.finalClientAckMaterializedSquares = math.max(0, tonumber(args and args.materializedSquares) or 0)
    job.finalClientAckChunksLight = math.max(0, tonumber(args and args.chunksLight) or 0)
    job.finalClientAckExpectedSquaresFromClient = math.max(0, tonumber(args and args.expectedSquares) or 0)
    local expectedSquares = math.max(1, tonumber(job.finalClientAckExpectedSquares) or 1)
    local clientExpectedSquares = tonumber(job.finalClientAckExpectedSquaresFromClient) or 0
    local expectedSquaresOk = clientExpectedSquares <= 0 or clientExpectedSquares == expectedSquares
    local squaresOk = job.finalClientAckSquares >= expectedSquares
    job.finalClientAckOk = args and args.ok == true and expectedSquaresOk and squaresOk

    EBFCopyPasteServer.logStage(job, "final:clientAck:received", "ACK visual final recebido"
            .. " ok=" .. tostring(job.finalClientAckOk)
            .. " clientOk=" .. tostring(args and args.ok == true)
            .. " squares=" .. tostring(job.finalClientAckSquares)
            .. "/" .. tostring(expectedSquares)
            .. " materializados=" .. tostring(job.finalClientAckMaterializedSquares)
            .. " chunksLight=" .. tostring(job.finalClientAckChunksLight)
            .. " clientExpected=" .. tostring(clientExpectedSquares)
            .. " id=" .. tostring(ackId)
            .. " message=\"" .. tostring(args and args.message or "") .. "\""
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.transmitFinalSyncObject(job, object)
    if not job or not object then
        return 0
    end
    if job.finalSyncSkipObjectSet and job.finalSyncSkipObjectSet[object] then
        return 0
    end
    job.finalSyncSentSet = job.finalSyncSentSet or {}
    if job.finalSyncSentSet[object] then
        return 0
    end
    if transmitCompleteObject(object) then
        job.finalSyncSentSet[object] = true
        job.finalSyncSent = (job.finalSyncSent or 0) + 1
        return 1
    end
    return 0
end

function EBFCopyPasteServer.processPasteFinalizeSync(job)
    local objects = job.clipboard.objects or {}
    local extras = job.finalSyncObjects or {}
    local entryTotal = tonumber(job.finalSyncEntryTotal) or #objects
    local total = math.max(1, tonumber(job.finalizeTotal) or (entryTotal + #extras))
    local budget = getBudgetValue(EBFCopyPaste.PasteFinalizeObjectsPerTick, 16, 1)

    while budget > 0 and (job.finalizeIndex or 1) <= total do
        local index = job.finalizeIndex or 1
        local object = nil

        if index <= entryTotal then
            local entry = objects[index]
            if entry and not entry.floor then
                local square = getOrCreateSquare(job.targetX + entry.dx, job.targetY + entry.dy, job.targetZ + entry.dz)
                local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
                local skipFinalSync = pasteKey
                        and job.finalSyncSkipPasteKeys
                        and job.finalSyncSkipPasteKeys[pasteKey] == true
                if not skipFinalSync then
                    object = pasteKey and job.pastedObjectMap and job.pastedObjectMap[pasteKey] or nil
                    if object and callMethod(object, "getSquare") ~= square then
                        object = nil
                    end
                    if EBFCopyPasteServer.transmitFinalSyncObject(job, object) == 0
                            and not (entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil) then
                        object = EBFCopyPasteServer.findObjectForEntry(square, entry, job)
                        EBFCopyPasteServer.transmitFinalSyncObject(job, object)
                    end
                end
            end
        else
            object = extras[index - entryTotal]
            EBFCopyPasteServer.transmitFinalSyncObject(job, object)
        end

        job.finalizeIndex = index + 1
        budget = budget - 1
    end

    if (job.finalizeIndex or 1) > total then
        job.finalSyncDone = true
    end
end

function EBFCopyPasteServer.finalizeRuntimeLightingAfterFinalSync(job)
    if not job or job.runtimeLightingFinalizedAfterFinalSync == true then
        return true
    end

    job.runtimeLightingFinalizedAfterFinalSync = true
    local missingRuntimeBuildings = 0
    if job.roomDefPersistenceDisabled ~= true then
        missingRuntimeBuildings = EBFCopyPasteServer.ensureRuntimeRoomsHaveBuildings(job, "postFinalSyncLighting")
    end
    if missingRuntimeBuildings > 0 then
        failPasteJob(getPlayerKey(job.playerObj), job,
                "RoomDef en tiempo de ejecución sin IsoBuilding después de la sincronización final: "
                .. tostring(missingRuntimeBuildings)
                .. " habitaciones no válidas. Se ha interrumpido el pegado para evitar un error vanilla.")
        return false
    end

    EBFCopyPasteServer.forceRuntimeRoomLightsInactive(job, "postFinalSyncPreAudit")
    EBFCopyPasteServer.ensureRuntimeRoomLights(job, "postFinalSyncVanillaExact")
    EBFCopyPasteServer.restoreCapturedLightSwitchActiveStates(job, "postFinalSyncCapturedState")
    EBFCopyPasteServer.restorePastedWorldInventoryOffsets(job, "postFinalSync")
    EBFCopyPasteServer.auditPastedResidentialLightSwitchFidelity(job, "postFinalSync")
    local criticalLightSwitchLinks = (tonumber(job.vanillaRoomLightWrongRoomFailures) or 0)
            + (tonumber(job.vanillaRoomLightMissingSwitchLinkFailures) or 0)
            + (tonumber(job.vanillaRoomLightExtraSwitchLinkFailures) or 0)
    if job.roomDefPersistenceDisabled == true then
        criticalLightSwitchLinks = 0
    end
    if criticalLightSwitchLinks > 0 then
        failPasteJob(getPlayerKey(job.playerObj), job,
                "AUDITORÍA lighting_indoor: se ha detectado un vínculo vanilla incorrecto; vínculosCríticos="
                .. tostring(criticalLightSwitchLinks)
                .. " wrongRoom=" .. tostring(job.vanillaRoomLightWrongRoomFailures or 0)
                .. " missingSwitchLink=" .. tostring(job.vanillaRoomLightMissingSwitchLinkFailures or 0)
                .. " extraSwitchLinks=" .. tostring(job.vanillaRoomLightExtraSwitchLinkFailures or 0)
                .. ". Se ha interrumpido el pegado para evitar que un interruptor encienda otra habitación.")
        return false
    end
    EBFCopyPasteServer.logStage(job, "finalize:lightingPostSync", "FINALIZACIÓN: luz posterior a la sincronización completada; luces="
            .. tostring(job.finalizedLights or 0)
            .. " switchesVinculados=" .. tostring(job.roomRuntimeSwitchesBound or 0)
            .. " switchesAuditados=" .. tostring(job.roomRuntimeSwitchesAudited or 0)
            .. " vanillaRoomBindings=" .. tostring(job.vanillaRoomLightBindingsApplied or 0)
            .. " vanillaRoomFalhas=" .. tostring((job.vanillaRoomLightBindingFailures or 0) + (job.vanillaRoomLightAuditFailures or 0))
            .. " exactLampBindingsIgnorados=" .. tostring(job.exactLightBindingsSkippedMoveableLamp or 0)
            .. " exactRoomSwitchBindingsIgnorados=" .. tostring(job.exactLightBindingsSkippedResidentialSwitch or 0)
            .. " roomLinksBloqueados=" .. tostring(job.roomRuntimeSwitchRoomFallbackBlocked or 0)
            .. " roomLinksRemovidos=" .. tostring(job.roomRuntimeSwitchesDetached or 0)
            .. " roomSwitchListsRuntimeLimpas=" .. tostring(job.runtimeRoomSwitchListsClearedFinal or 0)
            .. " roomLightsRuntimeLimpos=" .. tostring(job.runtimeRoomLightsClearedFinal or 0)
            .. " lightStatesRestaurados=" .. tostring(job.capturedLightStatesRestored or 0)
            .. " lightStateFalhas=" .. tostring(job.capturedLightStateRestoreFailures or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    EBFCopyPasteServer.sendClientPasteAreaReconcile(job, "postFinalSync")
    return true
end

function EBFCopyPasteServer.startPostFinalSyncDelay(job)
    if not job then
        return
    end
    job.phase = "postFinalSyncDelay"
    job.postFinalSyncDelayTicks = 0
    job.postFinalSyncDelayTotal = math.max(1, tonumber(EBFCopyPaste.PostFinalSyncSettleTicks) or 30)
    job.lastFeedback = 0
    EBFCopyPasteServer.logStage(job, "finalize:syncDelay", "FINALIZACIÓN: sincronización esperando a que el cliente aplique AddItemToMap"
            .. " ticks=" .. tostring(job.postFinalSyncDelayTotal)
            .. " enviados=" .. tostring(job.finalSyncSent or 0)
            .. " vanillaReenviados=" .. tostring(job.finalSyncAlreadyAddedQueued or 0)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.processPostFinalSyncDelay(job)
    if not job then
        return false
    end
    job.postFinalSyncDelayTicks = (tonumber(job.postFinalSyncDelayTicks) or 0) + 1
    return job.postFinalSyncDelayTicks >= math.max(1, tonumber(job.postFinalSyncDelayTotal) or 10)
end

function EBFCopyPasteServer.startPasteVerification(job)
    local total = #(job and job.clipboard and job.clipboard.objects or {})
    local clearedMarkers = 0
    if EBFCopyPasteServer.clearPasteMarkersForJob then
        clearedMarkers = EBFCopyPasteServer.clearPasteMarkersForJob(job) or 0
    end
    job.phase = "verifyPaste"
    job.verifyIndex = 1
    job.verifyTotal = math.max(1, total)
    job.verification = {
        metadataVersion = 2,
        checked = 0,
        matched = 0,
        mismatched = 0,
        missing = 0,
        skippedUnloaded = 0,
        warnings = 0,
        fieldCounts = {},
        samples = {},
    }
    job.lastFeedback = 0
    EBFCopyPasteServer.logStage(job, "verify:start", "VERIFICACIÓN iniciada: comparando referencia y pegado"
            .. " objetos=" .. tostring(total)
            .. " marcadoresInternosLimpos=" .. tostring(clearedMarkers)
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
end

function EBFCopyPasteServer.addVerificationSample(verification, entry, status, details)
    if not verification or #(verification.samples or {}) >= 40 then
        return
    end
    verification.samples = verification.samples or {}
    table.insert(verification.samples, {
        status = status,
        dx = entry and entry.dx or nil,
        dy = entry and entry.dy or nil,
        dz = entry and entry.dz or nil,
        sprite = entry and entry.sprite or nil,
        objectClass = entry and entry.objectClass or nil,
        classification = entry and entry.classification or nil,
        worldItemFullType = EBFCopyPasteServer.getEntryWorldItemFullType(entry),
        worldItemOffX = entry and entry.worldItem and entry.worldItem.offX or nil,
        worldItemOffY = entry and entry.worldItem and entry.worldItem.offY or nil,
        worldItemOffZ = entry and entry.worldItem and entry.worldItem.offZ or nil,
        details = details,
    })
end

function EBFCopyPasteServer.getVerificationExtraObjectClass(entry)
    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return "WaterDispenser"
    end
    return tostring(entry and entry.objectClass or "")
end

function EBFCopyPasteServer.makeVerificationExtraKey(entry)
    if not entry then
        return nil
    end
    local worldItemFullType = EBFCopyPasteServer.getEntryWorldItemFullType(entry)
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return tostring(EBFCopyPaste.toInt(entry.dx, 0))
                .. ":" .. tostring(EBFCopyPaste.toInt(entry.dy, 0))
                .. ":" .. tostring(EBFCopyPaste.toInt(entry.dz, 0))
                .. ":worldItem:"
                .. EBFCopyPasteServer.getVerificationExtraObjectClass(entry)
                .. ":" .. tostring(worldItemFullType or "")
    end
    return tostring(EBFCopyPaste.toInt(entry.dx, 0))
            .. ":" .. tostring(EBFCopyPaste.toInt(entry.dy, 0))
            .. ":" .. tostring(EBFCopyPaste.toInt(entry.dz, 0))
            .. ":" .. tostring(entry.sprite or "")
            .. ":" .. EBFCopyPasteServer.getVerificationExtraObjectClass(entry)
            .. ":" .. tostring(worldItemFullType or "")
            .. ":" .. tostring(entry.floor == true)
end

function EBFCopyPasteServer.addVerificationCount(map, samples, entry)
    local key = EBFCopyPasteServer.makeVerificationExtraKey(entry)
    if not key then
        return
    end
    map[key] = (map[key] or 0) + 1
    samples[key] = samples[key] or entry
end

function EBFCopyPasteServer.buildVerificationSourceEntryLookup(job)
    if not job then
        return {}
    end
    if job.verificationSourceEntryByPasteKey then
        return job.verificationSourceEntryByPasteKey
    end

    local lookup = {}
    for _, entry in ipairs(job.clipboard and job.clipboard.objects or {}) do
        local pasteKey = EBFCopyPasteServer.makeEntryPasteKey and EBFCopyPasteServer.makeEntryPasteKey(job, entry) or nil
        if pasteKey then
            lookup[pasteKey] = entry
        end
    end
    job.verificationSourceEntryByPasteKey = lookup
    return lookup
end

function EBFCopyPasteServer.getVerificationSourceEntryForObject(job, object)
    if not job or not object then
        return nil
    end

    local lookup = EBFCopyPasteServer.buildVerificationSourceEntryLookup(job)
    for pasteKey, mappedObject in pairs(job.pastedObjectMap or {}) do
        if mappedObject == object then
            return lookup[pasteKey]
        end
    end

    local pasteKey = EBFCopyPasteServer.getObjectPasteKey and EBFCopyPasteServer.getObjectPasteKey(object) or nil
    return pasteKey and lookup[pasteKey] or nil
end

function EBFCopyPasteServer.buildVerificationEntryForActualObject(job, square, object, isWorldObject)
    if not job or not square or not object then
        return nil
    end

    local dx = EBFCopyPaste.toInt(square:getX(), 0) - EBFCopyPaste.toInt(job.targetX, 0)
    local dy = EBFCopyPaste.toInt(square:getY(), 0) - EBFCopyPaste.toInt(job.targetY, 0)
    local dz = EBFCopyPaste.toInt(square:getZ(), 0) - EBFCopyPaste.toInt(job.targetZ, 0)
    if isWorldObject == true then
        local sourceEntry = EBFCopyPasteServer.getVerificationSourceEntryForObject(job, object)
        local item = EBFCopyPasteServer.getWorldInventoryObjectItem(object)
        local fullType = getItemFullType(item) or EBFCopyPasteServer.getEntryWorldItemFullType(sourceEntry)
        local sourceWorldItem = sourceEntry and sourceEntry.worldItem or nil
        local offX = EBFCopyPasteServer.getWorldInventoryObjectOffset(object, "x")
        local offY = EBFCopyPasteServer.getWorldInventoryObjectOffset(object, "y")
        local offZ = EBFCopyPasteServer.getWorldInventoryObjectOffset(object, "z")
        if sourceWorldItem then
            offX = offX ~= nil and offX or sourceWorldItem.offX
            offY = offY ~= nil and offY or sourceWorldItem.offY
            offZ = offZ ~= nil and offZ or sourceWorldItem.offZ
        end
        return {
            dx = dx,
            dy = dy,
            dz = dz,
            index = object.getObjectIndex and object:getObjectIndex() or 0,
            objectClass = "IsoWorldInventoryObject",
            objectName = callMethod(object, "getObjectName"),
            sprite = getObjectSpriteName(object),
            floor = false,
            worldItem = {
                item = {
                    fullType = fullType,
                    name = callMethod(item, "getName"),
                    type = callMethod(item, "getType"),
                    module = callMethod(item, "getModule"),
                },
                itemId = tonumber(callMethod(item, "getID")),
                offX = offX,
                offY = offY,
                offZ = offZ,
            },
        }
    end

    local spriteName = getObjectSpriteName(object)
    if spriteName == "underground_01_0" then
        return nil
    end
    return {
        dx = dx,
        dy = dy,
        dz = dz,
        index = object.getObjectIndex and object:getObjectIndex() or 0,
        objectClass = getObjectClass(object),
        objectName = callMethod(object, "getObjectName"),
        sprite = spriteName,
        floor = square.getFloor and square:getFloor() == object or false,
        north = callMethod(object, "getNorth"),
        waterState = EBFCopyPasteServer.captureObjectWaterState(object, spriteName),
    }
end

function EBFCopyPasteServer.auditPasteVerificationExtras(job)
    local verification = job and job.verification or nil
    if not job or not job.clipboard or not verification or verification.extraAuditDone == true then
        return 0
    end

    verification.extraAuditDone = true
    local expectedCounts = {}
    local expectedSamples = {}
    for _, entry in ipairs(job.clipboard.objects or {}) do
        EBFCopyPasteServer.addVerificationCount(expectedCounts, expectedSamples, entry)
    end

    local actualCounts = {}
    local actualSamples = {}
    local offsets = {}
    if type(job.clipboard.zOffsets) == "table" then
        for _, value in ipairs(job.clipboard.zOffsets) do
            local offset = tonumber(value)
            if offset ~= nil then
                table.insert(offsets, math.floor(offset))
            end
        end
    end
    if #offsets <= 0 then
        local levels = math.max(1, math.floor(tonumber(job.clipboard.levels) or 1))
        for offset = 0, levels - 1 do
            table.insert(offsets, offset)
        end
    end

    local width = math.max(1, math.floor(tonumber(job.clipboard.w) or 1))
    local height = math.max(1, math.floor(tonumber(job.clipboard.h) or 1))
    for _, dzOffset in ipairs(offsets) do
        local z = EBFCopyPaste.toInt(job.targetZ, 0) + dzOffset
        for y = EBFCopyPaste.toInt(job.targetY, 0), EBFCopyPaste.toInt(job.targetY, 0) + height - 1 do
            for x = EBFCopyPaste.toInt(job.targetX, 0), EBFCopyPaste.toInt(job.targetX, 0) + width - 1 do
                local square = getCell() and getCell():getGridSquare(x, y, z) or nil
                if square then
                    local objects = square.getObjects and square:getObjects() or nil
                    if objects then
                        for index = 0, objects:size() - 1 do
                            local entry = EBFCopyPasteServer.buildVerificationEntryForActualObject(job, square, objects:get(index), false)
                            EBFCopyPasteServer.addVerificationCount(actualCounts, actualSamples, entry)
                        end
                    end
                    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
                    if worldObjects then
                        for index = 0, worldObjects:size() - 1 do
                            local entry = EBFCopyPasteServer.buildVerificationEntryForActualObject(job, square, worldObjects:get(index), true)
                            EBFCopyPasteServer.addVerificationCount(actualCounts, actualSamples, entry)
                        end
                    end
                end
            end
        end
    end

    local extras = 0
    for key, actualCount in pairs(actualCounts) do
        local expectedCount = expectedCounts[key] or 0
        if actualCount > expectedCount then
            local extraCount = actualCount - expectedCount
            extras = extras + extraCount
            local sample = actualSamples[key]
            if sample then
                EBFCopyPasteServer.addVerificationSample(verification, sample, "extra",
                        "Objeto extra no destino count=" .. tostring(extraCount)
                                .. " expected=" .. tostring(expectedCount)
                                .. " actual=" .. tostring(actualCount))
            end
        end
    end

    verification.extraObjects = extras
    if extras > 0 then
        verification.fieldCounts = verification.fieldCounts or {}
        verification.fieldCounts.extraObject = (verification.fieldCounts.extraObject or 0) + extras
    end
    return extras
end

function EBFCopyPasteServer.processPasteVerification(job)
    local objects = job.clipboard.objects or {}
    local budget = getBudgetValue(EBFCopyPaste.PasteVerificationObjectsPerTick, 24, 1)
    local verification = job.verification or {}
    job.verification = verification

    while budget > 0 and (job.verifyIndex or 1) <= #objects do
        local entry = objects[job.verifyIndex or 1]
        if entry then
            if not entry.fingerprint or not entry.classification or not entry.capabilities then
                EBFCopyPasteServer.decorateScannerEntry(entry, nil)
            end

            local square, object, unloaded = EBFCopyPasteServer.getVerificationTargetObject(job, entry)
            if unloaded then
                verification.skippedUnloaded = (verification.skippedUnloaded or 0) + 1
            elseif not object then
                verification.missing = (verification.missing or 0) + 1
                EBFCopyPasteServer.addVerificationSample(verification, entry, "missing", "No se ha encontrado el objeto en el destino cargado.")
            else
                local ok, targetEntry = nil, nil
                if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
                    ok, targetEntry = pcall(EBFCopyPasteServer.buildVerificationEntryForWorldObject, square, object, entry)
                else
                    ok, targetEntry = pcall(EBFCopyPasteServer.buildVerificationEntryForObject, square, object, entry)
                end
                if ok and targetEntry then
                    local differences = EBFCopyPasteServer.compareEntryFingerprints(entry, targetEntry)
                    if #differences == 0 then
                        verification.matched = (verification.matched or 0) + 1
                    else
                        verification.mismatched = (verification.mismatched or 0) + 1
                        verification.fieldCounts = verification.fieldCounts or {}
                        for _, diff in ipairs(differences) do
                            local field = tostring(diff and diff.field or "?")
                            verification.fieldCounts[field] = (verification.fieldCounts[field] or 0) + 1
                        end
                        EBFCopyPasteServer.addVerificationSample(verification, entry, "mismatch", differences)
                    end
                    if targetEntry.auditWarnings and #targetEntry.auditWarnings > 0 then
                        verification.warnings = (verification.warnings or 0) + #targetEntry.auditWarnings
                    end
                    verification.checked = (verification.checked or 0) + 1
                else
                    verification.missing = (verification.missing or 0) + 1
                    EBFCopyPasteServer.addVerificationSample(verification, entry, "scanFailed", "No se ha podido crear la huella del objeto pegado.")
                end
            end
        end
        job.verifyIndex = (job.verifyIndex or 1) + 1
        budget = budget - 1
    end

    if (job.verifyIndex or 1) > #objects then
        EBFCopyPasteServer.auditPasteVerificationExtras(job)
        job.verifyDone = true
    end
end

local function removeObjectFromSquare(square, object)
    if not square or not object then
        return
    end

    if isInstance(object, "IsoLightSwitch") then
        local room = callMethod(square, "getRoom")
        EBFCopyPasteServer.removeLightSwitchFromRoom(room, object)
        if EBFCopyPasteServer.clearLightSwitchOwnSources then
            EBFCopyPasteServer.clearLightSwitchOwnSources(object)
        end
        EBFCopyPasteServer.applyLightSwitchActive(object, false)
        callMethod(object, "updateLightSource")
        callMethod(object, "checkLightSourceActive")
    end

    if isServer and isServer() and square.transmitRemoveItemFromSquareOnClients then
        pcall(function()
            square:transmitRemoveItemFromSquareOnClients(object)
        end)
    elseif square.transmitRemoveItemFromSquare then
        pcall(function()
            square:transmitRemoveItemFromSquare(object)
        end)
    end

    if EBFCopyPasteServer.isWorldInventoryObject(object) and square.removeWorldObject then
        pcall(function()
            square:removeWorldObject(object)
        end)
        return
    end

    if square.RemoveTileObject then
        pcall(function()
            square:RemoveTileObject(object)
        end)
    end
end

function EBFCopyPasteServer.removeUndergroundPlaceholders(square)
    if not square or not square.getObjects or (tonumber(square:getZ()) or 0) >= 0 then
        return 0
    end

    local objects = square:getObjects()
    if not objects then
        return 0
    end

    local removed = 0
    for i = objects:size() - 1, 0, -1 do
        local object = objects:get(i)
        if getObjectSpriteName(object) == "underground_01_0" then
            removeObjectFromSquare(square, object)
            removed = removed + 1
        end
    end
    if removed > 0 then
        pcall(function()
            square:RecalcProperties()
        end)
        pcall(function()
            square:RecalcAllWithNeighbours(true)
        end)
    end
    return removed
end

local function processPasteJob(key, job)
    if job.phase == "clientAreaReconcile" then
        processPasteClientAreaReconcile(job)
        sendPasteProgress(job, false)
        return
    elseif job.phase == "clear" then
        processPasteClear(job)
        sendPasteProgress(job, false)
        return
    elseif job.phase == "paste" then
        processPasteObjects(job)
        sendPasteProgress(job, false)
        return
    elseif job.phase == "finalizeRooms" then
        processPasteFinalizeRooms(job)
        sendPasteProgress(job, false)
        return
    elseif job.phase == "clientRoomDefReconcile" then
        if EBFCopyPasteServer.processClientRoomDefReconcile(job) == true then
            startPasteDeferredLights(job)
            sendPasteProgress(job, true)
        elseif job.clientRoomDefReconcileFailed == true then
            failPasteJob(key, job, job.clientRoomDefReconcileFailureMessage
                    or "RoomDef del cliente no confirmado; se ha interrumpido el pegado antes de las luces interiores.")
        else
            sendPasteProgress(job, false)
        end
        return
    elseif job.phase == "pasteDeferredLights" then
        processPasteDeferredLights(job)
        sendPasteProgress(job, false)
        return
    elseif job.phase == "finalizeLights" then
        processPasteFinalizeLights(job)
        if (job.finalizeIndex or 1) > #(job.clipboard.objects or {}) then
            if EBFCopyPasteServer.startPasteFinalizeSync(job) ~= false then
                sendPasteProgress(job, true)
            end
        else
            sendPasteProgress(job, false)
        end
        return
    elseif job.phase == "finalizeSync" then
        EBFCopyPasteServer.processPasteFinalizeSync(job)
        if job.finalSyncDone == true then
            EBFCopyPasteServer.startPostFinalSyncDelay(job)
            sendPasteProgress(job, true)
        else
            sendPasteProgress(job, false)
        end
        return
    elseif job.phase == "postFinalSyncDelay" then
        if EBFCopyPasteServer.processPostFinalSyncDelay(job) == true then
            if EBFCopyPasteServer.finalizeRuntimeLightingAfterFinalSync(job) ~= false then
                EBFCopyPasteServer.startPasteVerification(job)
                sendPasteProgress(job, true)
            end
        else
            sendPasteProgress(job, false)
        end
        return
    elseif job.phase == "verifyPaste" then
        EBFCopyPasteServer.processPasteVerification(job)
        if job.verifyDone == true then
            local verification = job.verification or {}
            local verifyFailures = (tonumber(verification.missing) or 0)
                    + (tonumber(verification.mismatched) or 0)
                    + (tonumber(verification.extraObjects) or 0)
            if verifyFailures > 0 then
                local fieldSummary = formatScannerCountMap(verification.fieldCounts, 16)
                EBFCopyPasteServer.logStage(job, nil, "VERIFICACIÓN fallida: comprobados=" .. tostring(verification.checked or 0)
                        .. " missing=" .. tostring(verification.missing or 0)
                        .. " mismatch=" .. tostring(verification.mismatched or 0)
                        .. " extra=" .. tostring(verification.extraObjects or 0)
                        .. " fields=" .. tostring(fieldSummary ~= "" and fieldSummary or "ninguno")
                        .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
                        .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
                for i, sample in ipairs(verification.samples or {}) do
                    if i > 8 then
                        break
                    end
                    local detailText = tostring(sample.details or "")
                    if type(sample.details) == "table" then
                        local parts = {}
                        for _, diff in ipairs(sample.details) do
                            if type(diff) == "table" then
                                table.insert(parts, tostring(diff.field)
                                        .. "=" .. EBFCopyPasteServer.auditValue(diff.source)
                                        .. "->" .. EBFCopyPasteServer.auditValue(diff.target))
                            else
                                table.insert(parts, tostring(diff))
                            end
                            if #parts >= 6 then
                                break
                            end
                        end
                        detailText = table.concat(parts, "; ")
                    end
                    EBFCopyPasteServer.logStage(job, nil, "VERIFY amostra " .. tostring(i)
                            .. ": status=" .. tostring(sample.status)
                            .. " pos=" .. tostring(sample.dx) .. "," .. tostring(sample.dy) .. "," .. tostring(sample.dz)
                            .. " sprite=" .. tostring(sample.sprite)
                            .. " class=" .. tostring(sample.objectClass)
                            .. " worldItem=" .. tostring(sample.worldItemFullType)
                            .. " off=" .. tostring(sample.worldItemOffX) .. "," .. tostring(sample.worldItemOffY) .. "," .. tostring(sample.worldItemOffZ)
                            .. " detalhes=" .. detailText)
                end
                failPasteJob(key, job, "La VERIFICACIÓN ha detectado diferencias entre el origen y el pegado; consulta verifyFields/muestras en el registro.")
                return
            end
            if EBFCopyPasteServer.startFinalClientAck(job) ~= false then
                sendPasteProgress(job, true)
            else
                failPasteJob(key, job, job.finalClientAckFailureMessage
                        or "El cliente no ha confirmado la sincronización visual final; se ha interrumpido el pegado.")
            end
        else
            sendPasteProgress(job, false)
        end
        return
    elseif job.phase == "finalClientAck" then
        if EBFCopyPasteServer.processFinalClientAck(job) == true then
            finishPasteJob(key, job)
        elseif job.finalClientAckFailed == true then
            failPasteJob(key, job, job.finalClientAckFailureMessage
                    or "El cliente no ha confirmado la sincronización visual final; se ha interrumpido el pegado.")
        else
            sendPasteProgress(job, false)
        end
        return
    end

    sendPasteProgress(job, false)
end

clearSquare = function(square)
    if not square then
        return false, false
    end

    local removed = false
    local heavy = false

    local function removeWorldObjects()
        local count = 0
        local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
        if worldObjects and worldObjects:size() > 0 then
            for i = worldObjects:size() - 1, 0, -1 do
                removeObjectFromSquare(square, worldObjects:get(i))
                removed = true
                count = count + 1
            end
        end
        return count
    end

    local function removeFloorObject()
        local floor = square.getFloor and square:getFloor() or nil
        if not floor then
            return 0
        end

        if objectHasContainers(floor) then
            heavy = true
        end
        removeObjectFromSquare(square, floor)
        if square.removeFloor then
            pcall(function()
                square:removeFloor()
            end)
        end
        removed = true
        return 1
    end

    local function removeTileObjects()
        local count = 0
        local objects = square:getObjects()
        if objects and objects:size() > 0 then
            for i = objects:size() - 1, 0, -1 do
                local object = objects:get(i)
                if objectHasContainers(object) then
                    heavy = true
                end
                removeObjectFromSquare(square, object)
                removed = true
                count = count + 1
            end
        end
        return count
    end

    for _ = 1, 4 do
        local count = removeWorldObjects() + removeFloorObject() + removeTileObjects()
        if count <= 0 then
            break
        end
    end

    if removed then
        if square.InvalidateSpecialObjectPaths then
            pcall(function()
                square:InvalidateSpecialObjectPaths()
            end)
        end
        refreshSquareSystems(square)
    end
    return removed, heavy
end

pasteFloor = function(square, entry, job)
    if EBFCopyPasteServer.squareHasLoadedChunk
            and not EBFCopyPasteServer.squareHasLoadedChunk(square) then
        return nil
    end

    local existing = EBFCopyPasteServer.getAlreadyPastedObject(job, square, entry)
    if existing ~= nil then
        return existing
    end

    if EBFCopyPasteServer.removeUndergroundPlaceholders then
        EBFCopyPasteServer.removeUndergroundPlaceholders(square)
    end

    local currentFloor = square.getFloor and square:getFloor() or nil
    if currentFloor then
        removeObjectFromSquare(square, currentFloor)
        if square.removeFloor then
            pcall(function()
                square:removeFloor()
            end)
        end
    end

    square:addFloor(entry.sprite)
    local floor = square:getFloor()
    if floor then
        EBFCopyPasteServer.notePastedObject(job, entry, floor)
        if EBFCopyPasteServer.removeUndergroundPlaceholders and entry.sprite ~= "underground_01_0" then
            EBFCopyPasteServer.removeUndergroundPlaceholders(square)
        end
        applyModData(floor, entry.modData)
        applyAttachedSprites(floor, entry.attached)
        if entry.overlay and floor.setOverlaySprite then
            floor:setOverlaySprite(entry.overlay)
        end
        transmitCompleteObject(floor)
    end
    return floor
end

local function createIsoDoor(square, spriteName, north)
    if not IsoDoor then
        return nil
    end

    local ok, object = pcall(function()
        return IsoDoor.new(getCell(), square, spriteName, north == true)
    end)
    if ok and object then
        return object
    end

    local sprite = getSprite(spriteName)
    ok, object = pcall(function()
        return IsoDoor.new(getCell(), square, sprite, north == true)
    end)
    if ok then
        return object
    end
    return nil
end

local function createIsoWindow(square, spriteName, north)
    if not IsoWindow then
        return nil
    end

    local sprite = getSprite(spriteName)
    if not sprite then
        return nil
    end

    local ok, object = pcall(function()
        return IsoWindow.new(getCell(), square, sprite, north == true)
    end)
    if ok then
        return object
    end
    return nil
end

function EBFCopyPasteServer.createIsoCurtain(square, spriteName, north)
    if not IsoCurtain then
        return nil
    end

    local ok, object = pcall(function()
        return IsoCurtain.new(getCell(), square, spriteName, north == true)
    end)
    if ok and object then
        return object
    end

    local sprite = getSprite(spriteName)
    ok, object = pcall(function()
        return IsoCurtain.new(getCell(), square, sprite, north == true, false)
    end)
    if ok then
        return object
    end
    return nil
end

function EBFCopyPasteServer.createIsoWindowFrame(square, spriteName, north)
    if not IsoWindowFrame then
        return nil
    end

    local sprite = getSprite(spriteName)
    if not sprite then
        return nil
    end

    local ok, object = pcall(function()
        return IsoWindowFrame.new(getCell(), square, sprite, north == true)
    end)
    if ok then
        return object
    end
    return nil
end

local function createIsoSpriteObject(square, spriteName, classRef)
    if not classRef then
        return nil
    end

    local sprite = getSprite(spriteName)
    if not sprite then
        return nil
    end

    local ok, object = pcall(function()
        return classRef.new(getCell(), square, sprite)
    end)
    if not ok or not object then
        return nil
    end
    return object
end

-- Ruta B42.20 para paredes/tejados/cutaways que son IsoObject sin clase especializada.
-- Se limita deliberadamente a entradas estructurales sin estado funcional.
local function createStructuralIsoObject(square, entry)
    if not square or not entry or not IsoObject or not entry.sprite then
        return nil
    end
    if EBFCopyPasteServer.entryIsStructural(entry) ~= true
            or entry.objectClass ~= "IsoObject"
            or EBFCopyPasteServer.entryHasFunctionalState(entry)
            or EBFCopyPasteServer.entryHasContainers(entry)
            or EBFCopyPasteServer.entryIsLighting(entry) then
        return nil
    end

    local sprite = getSprite(entry.sprite)
    if not sprite then
        print("[EBFCopyPaste] estructura omitida: sprite inexistente " .. tostring(entry.sprite))
        return nil
    end

    local constructors = {
        function() return IsoObject.new(getCell(), square, sprite) end,
        function() return IsoObject.new(getCell(), square, entry.sprite) end,
        function() return IsoObject.new(square, entry.sprite) end,
    }
    for _, constructor in ipairs(constructors) do
        local ok, object = pcall(constructor)
        if ok and object then
            if object.setSquare then
                pcall(function() object:setSquare(square) end)
            end
            return object
        end
    end

    print("[EBFCopyPaste] estructura omitida: no hay constructor IsoObject válido para "
            .. tostring(entry.sprite))
    return nil
end

function EBFCopyPasteServer.createIsoBrokenGlass(square)
    if not IsoBrokenGlass then
        return nil
    end

    local ok, object = pcall(function()
        return IsoBrokenGlass.new(getCell())
    end)
    if ok and object then
        callMethod(object, "setSquare", square)
        return object
    end
    return nil
end

function EBFCopyPasteServer.createIsoFeedingTrough(square, spriteName)
    if not IsoFeedingTrough then
        return nil
    end

    local ok, object = pcall(function()
        return IsoFeedingTrough.new(square, spriteName, nil)
    end)
    if ok then
        return object
    end
    return nil
end

local function getSafeLightSwitchRoomID(square)
    if not square then
        return nil
    end

    local roomID = callMethod(square, "getRoomID")
    if roomID == nil then
        return nil
    end
    local okNegative, isNegative = pcall(function()
        return roomID < 0
    end)
    if okNegative and isNegative then
        return nil
    end

    local room = callMethod(square, "getRoom")
    if not room or not callMethod(room, "getRoomDef") then
        return nil
    end

    return roomID
end

function EBFCopyPasteServer.lightSwitchSpriteHasOwnLight(spriteName)
    if type(spriteName) ~= "string" or spriteName == "" then
        return false
    end

    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return false
    end

    if IsoPropertyType then
        local ok, hasRedLight = pcall(function()
            return props:has(IsoPropertyType.RED_LIGHT)
        end)
        if ok and hasRedLight then
            return true
        end
    end

    return spriteHasAnyProperty(spriteName, {
        "lightR",
        "LightR",
        "RED_LIGHT",
        "redLight",
    })
end

function EBFCopyPasteServer.lightSwitchEntryHasOwnLight(entry, object)
    local spriteName = entry and entry.sprite or getObjectSpriteName(object)
    return EBFCopyPasteServer.lightSwitchSpriteHasOwnLight(spriteName)
end

local function createIsoLightSwitch(square, entry, job)
    if not IsoLightSwitch then
        return nil
    end

    local sprite = getSprite(entry.sprite)
    if not sprite then
        return nil
    end

    local isResidentialSwitch = EBFCopyPasteServer.entryIsResidentialLightSwitch(entry)
    local roomID = -1
    local runtimeRoomID = EBFCopyPasteServer.applyRuntimeRoomForEntrySquare(job, square, entry)
    if isResidentialSwitch and (runtimeRoomID == nil or runtimeRoomID == -1) then
        print("[EBFCopyPaste] IsoLightSwitch residencial no creado: falta el RoomDef en tiempo de ejecución; sprite="
                .. tostring(entry and entry.sprite)
                .. " dx=" .. tostring(entry and entry.dx)
                .. " dy=" .. tostring(entry and entry.dy)
                .. " dz=" .. tostring(entry and entry.dz))
        return nil
    end
    roomID = runtimeRoomID or getSafeLightSwitchRoomID(square) or -1

    local ok, object = pcall(function()
        return IsoLightSwitch.new(getCell(), square, sprite, roomID)
    end)
    if not ok or not object then
        return nil
    end

    if EBFCopyPasteServer.lightSwitchEntryHasOwnLight(entry, object) then
        callMethod(object, "addLightSourceFromSprite")
    end
    if EBFCopyPasteServer.applyCustomSettingsItem then
        EBFCopyPasteServer.applyCustomSettingsItem(object, entry.lightSettings)
    end
    return object
end

local function getLightStateValue(lightState, directName, setterName, fallback)
    if not lightState then
        return fallback
    end

    if lightState[directName] ~= nil then
        return lightState[directName]
    end

    local methods = lightState.methods or {}
    if methods[setterName] ~= nil then
        return methods[setterName]
    end

    if setterName == "setUseBatteryDirect" and methods.setUseBattery ~= nil then
        return methods.setUseBattery
    end
    if setterName == "setHasBatteryRaw" and methods.setHasBattery ~= nil then
        return methods.setHasBattery
    end
    return fallback
end

local function getLightRadius(spriteName)
    local props = getSpritePropertiesByName(spriteName)
    if not props then
        return 10
    end

    for _, name in ipairs({ "LightRadius", "lightRadius" }) do
        local ok, value = pcall(function()
            return props:get(name)
        end)
        local radius = ok and tonumber(value) or nil
        if radius and radius > 0 then
            return math.max(1, math.min(20, radius))
        end
    end
    return 10
end

local function normalizeLightColor(value, fallback)
    local number = tonumber(value)
    if number == nil then
        return fallback
    end
    if number > 1 then
        number = number / 255
    end
    return math.max(0, math.min(1, number))
end

local function getSpriteLightColor(spriteName, propertyName, fallback)
    local value = EBFCopyPasteServer.getSpritePropertyValue(spriteName, propertyName)
    return normalizeLightColor(value, fallback)
end

local function getOwnLightSwitchColor(object, spriteName, getterName, propertyName, fallback)
    local value = callMethod(object, getterName)
    if value ~= nil then
        return normalizeLightColor(value, fallback)
    end
    return getSpriteLightColor(spriteName, propertyName, fallback)
end

local function getLightStateActive(entry)
    local value = getLightStateValue(entry and entry.lightState or nil, "activated", "setActivated", nil)
    if value == nil then
        value = getLightStateValue(entry and entry.lightState or nil, "Activated", "setActivated", nil)
    end
    return value == true
end

local function getLightStateNumber(entry, directName, setterName, fallback)
    local value = tonumber(getLightStateValue(entry and entry.lightState or nil, directName, setterName, nil))
    if value == nil then
        value = fallback
    end
    return value
end

function EBFCopyPasteServer.getEntryRoomLightsActive(job, entry)
    if entry and entry.sourceRoom and entry.sourceRoom.lightsActive ~= nil then
        return entry.sourceRoom.lightsActive == true
    end

    local spec = EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
    if spec and spec.lightsActive ~= nil then
        return spec.lightsActive == true
    end

    local binding = EBFCopyPasteServer.getLightBindingForEntry(job, entry)
    if binding and binding.sourceRoomLightsActive ~= nil then
        return binding.sourceRoomLightsActive == true
    end
    return nil
end

function EBFCopyPasteServer.syncRoomLightActiveFlags(room, active)
    -- B42.20 keeps IsoRoomLight.active in Java and drives room lighting through
    -- RoomDef.lightsActive via IsoLightSwitch.switchLight().
    return 0
end

function EBFCopyPasteServer.applyRoomDefLightsActiveForEntry(job, entry, room)
    local roomDef = room and callMethod(room, "getRoomDef") or nil
    if not roomDef then
        return nil
    end

    local active = EBFCopyPasteServer.getEntryRoomLightsActive(job, entry)
    if active == nil then
        return EBFCopyPasteServer.safeField(roomDef, "lightsActive") == true
    end

    return active == true
end

function EBFCopyPasteServer.markManagedResidentialLightSwitch(object, entry, room, square)
    if not object or not object.getModData or not isInstance(object, "IsoLightSwitch") then
        return false
    end
    if not EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
        return false
    end

    local roomDef = room and callMethod(room, "getRoomDef") or nil
    if not roomDef then
        return false
    end

    local modData = object:getModData()
    if not modData then
        return false
    end

    modData[EBFCopyPaste.ManagedResidentialLightSwitchModDataKey] = true
    if entry and (entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key)) then
        modData[EBFCopyPaste.ManagedLightRoomKeyModDataKey] = entry.sourceRoomKey or entry.sourceRoom.key
    end
    modData[EBFCopyPaste.ManagedLightRoomIDStringModDataKey] = EBFCopyPasteServer.getRoomDefIdString(roomDef)
    modData[EBFCopyPaste.ManagedLightRoomNameModDataKey] = callMethod(roomDef, "getName") or callMethod(room, "getName")
    modData[EBFCopyPaste.ManagedLightRoomDzModDataKey] = EBFCopyPaste.toInt(square and callMethod(square, "getZ") or entry and entry.dz, 0)

    if object.transmitModData then
        pcall(function()
            object:transmitModData()
        end)
    end
    return true
end

function EBFCopyPasteServer.bindLightSwitchToRoom(square, object, entry, targetRoom, job)
    if not square or not object or not isInstance(object, "IsoLightSwitch") then
        return false
    end
    local isResidential = EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object)
    if not isResidential and EBFCopyPasteServer.lightSwitchEntryHasOwnLight(nil, object) then
        return false
    end

    local room = targetRoom or callMethod(square, "getRoom")
    if not room then
        return false
    end
    local roomDef = callMethod(room, "getRoomDef")
    if not roomDef then
        return false
    end

    local detached = EBFCopyPasteServer.removeLightSwitchFromKnownPasteRooms(job, square, object)
    EBFCopyPasteServer.applyRoomDefToSquare(square, roomDef, nil, true)
    local squareRoom = callMethod(square, "getRoom")
    if EBFCopyPasteServer.roomsReferToSameRoomDef(squareRoom, room) then
        room = squareRoom
        roomDef = callMethod(room, "getRoomDef") or roomDef
    else
        EBFCopyPasteServer.tryCallMethod(square, "setRoom", room)
        squareRoom = callMethod(square, "getRoom")
        if EBFCopyPasteServer.roomsReferToSameRoomDef(squareRoom, room) then
            room = squareRoom
            roomDef = callMethod(room, "getRoomDef") or roomDef
        end
    end
    if not EBFCopyPasteServer.roomsReferToSameRoomDef(callMethod(square, "getRoom"), room) then
        print("[EBFCopyPaste] FALLO DE FIDELIDAD lighting_indoor: squareRoom no aceptó el RoomDef de destino; interruptor="
                .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                .. " targetRoom={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}"
                .. " squareRoom={" .. EBFCopyPasteServer.getRoomAuditLabel(callMethod(square, "getRoom")) .. "}")
        return false
    end
    detached = detached + EBFCopyPasteServer.removeLightSwitchFromKnownPasteRooms(job, square, object)
    if job and detached > 0 then
        job.roomRuntimeSwitchesDetached = (tonumber(job.roomRuntimeSwitchesDetached) or 0) + detached
    end
    EBFCopyPasteServer.tryCallMethod(roomDef, "refreshSquares")
    EBFCopyPasteServer.tryCallMethod(room, "refreshSquares")

    EBFCopyPasteServer.clearLightSwitchOwnSources(object)
    local switches = callMethod(room, "getLightSwitches")
    if switches and callMethod(switches, "contains", object) ~= true then
        callMethod(switches, "add", object)
    end

    EBFCopyPasteServer.applyLightSwitchInitialActiveNoSync(object, false, room)
    EBFCopyPasteServer.forceRoomLightsInactive(room, "bindLightSwitch")
    EBFCopyPasteServer.reloadLightSwitchChunk(square)
    EBFCopyPasteServer.ensureRoomLightsForRoom(room, "bindLightSwitch")
    EBFCopyPasteServer.markManagedResidentialLightSwitch(object, entry, room, square)

    return true
end

function EBFCopyPasteServer.createVanillaHydroLightSourceForSwitch(square, object, x, y, z, r, g, b, radius)
    if not square or not object or not isInstance(object, "IsoLightSwitch") then
        return nil
    end

    local lights = callMethod(object, "getLights")
    if not lights then
        return nil
    end

    local function appendFromCurrentSprite()
        local before = tonumber(callMethod(lights, "size")) or 0
        local ok = EBFCopyPasteServer.tryCallMethod(object, "addLightSourceFromSprite")
        if ok ~= true then
            return nil
        end
        local after = tonumber(callMethod(lights, "size")) or 0
        if after > before then
            return callMethod(lights, "get", after - 1)
        end
        return nil
    end

    local originalSpriteName = getObjectSpriteName(object)
    local originalSprite = originalSpriteName and getSprite(originalSpriteName) or nil
    local light = appendFromCurrentSprite()
    if not light then
        for _, templateSpriteName in ipairs({ "lighting_indoor_01_10", "lighting_indoor_01_11", "lighting_outdoor_01_25" }) do
            local templateSprite = getSprite(templateSpriteName)
            if templateSprite and EBFCopyPasteServer.lightSwitchSpriteHasOwnLight(templateSpriteName) then
                callMethod(object, "setSprite", templateSprite)
                light = appendFromCurrentSprite()
                if originalSprite then
                    callMethod(object, "setSprite", originalSprite)
                elseif originalSpriteName then
                    callMethod(object, "setSprite", originalSpriteName)
                end
                if light then
                    break
                end
            end
        end
        if originalSpriteName and getObjectSpriteName(object) ~= originalSpriteName then
            callMethod(object, "setSprite", originalSpriteName)
        end
    end
    if not light then
        return nil
    end

    callMethod(light, "setX", EBFCopyPaste.toInt(x, square:getX()))
    callMethod(light, "setY", EBFCopyPaste.toInt(y, square:getY()))
    callMethod(light, "setZ", EBFCopyPaste.toInt(z, square:getZ()))
    callMethod(light, "setR", tonumber(r) or 1)
    callMethod(light, "setG", tonumber(g) or 1)
    callMethod(light, "setB", tonumber(b) or 1)
    callMethod(light, "setRadius", math.max(1, EBFCopyPaste.toInt(radius, 8)))
    callMethod(light, "setActive", false)
    callMethod(light, "setWasActive", false)

    local switches = callMethod(light, "getSwitches")
    if switches and callMethod(switches, "contains", object) ~= true then
        callMethod(switches, "add", object)
    end

    local cell = getCell and getCell() or nil
    if cell and cell.addLamppost then
        pcall(function()
            cell:addLamppost(light)
        end)
    end
    callMethod(light, "update")

    return light
end

function EBFCopyPasteServer.applyLightSwitchActive(object, active)
    if active == nil or not object then
        return false
    end

    local target = active == true
    if getMethod(object, "setActive") then
        if target then
            local ok, result = EBFCopyPasteServer.tryCallMethod(object, "setActive", true)
            if ok then
                return result == true
            end
        else
            local ok = EBFCopyPasteServer.tryCallMethod(object, "setActive", false, false, true)
            if ok then
                return true
            end
            ok = EBFCopyPasteServer.tryCallMethod(object, "setActive", false)
            if ok then
                return true
            end
        end
    end

    if not target then
        callMethod(object, "setActivated", false)
        return true
    end
    return false
end

function EBFCopyPasteServer.applyLightSwitchInitialActiveNoSync(object, active, room)
    if not object then
        return false
    end

    -- B42.20 logs noisy errors when Lua writes RoomDef.lightsActive directly.
    -- Callers that are still constructing RoomDef pass false. After sync final,
    -- callers can pass the captured state safely for own-source lights.
    local target = active == true
    callMethod(object, "setActivated", target)

    local lights = callMethod(object, "getLights")
    if lights then
        for i = 0, (tonumber(callMethod(lights, "size")) or 0) - 1 do
            local light = callMethod(lights, "get", i)
            if light then
                callMethod(light, "setActive", target)
                callMethod(light, "setWasActive", target)
            end
        end
    end

    return true
end

EBFCopyPasteServer.handledLightStateSetters = EBFCopyPasteServer.handledLightStateSetters or {
    setActivated = true,
    setUseBattery = true,
    setUseBatteryDirect = true,
    setHasBattery = true,
    setHasBatteryRaw = true,
    setPower = true,
    setCanBeModified = true,
    setDelta = true,
    setPrimaryR = true,
    setPrimaryG = true,
    setPrimaryB = true,
}

function EBFCopyPasteServer.clearLightSwitchOwnSources(object)
    local lights = callMethod(object, "getLights")
    if not lights then
        return 0
    end

    local size = tonumber(callMethod(lights, "size")) or 0
    if size <= 0 then
        return 0
    end

    local cell = getCell and getCell() or nil
    for index = size - 1, 0, -1 do
        local light = callMethod(lights, "get", index)
        if light then
            callMethod(light, "setActive", false)
            callMethod(light, "setWasActive", false)
            if cell and cell.removeLamppost then
                pcall(function()
                    cell:removeLamppost(light)
                end)
            end
        end
        pcall(function()
            lights:remove(index)
        end)
    end
    return size
end

function EBFCopyPasteServer.addLightSourceToSwitch(square, object, entry, forceLocalSource, job)
    if not square or not object or not IsoLightSource then
        return
    end

    if forceLocalSource ~= true and not EBFCopyPasteServer.lightSwitchEntryHasOwnLight(entry, object) then
        EBFCopyPasteServer.clearLightSwitchOwnSources(object)
        local targetRoom = nil
        if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
            targetRoom = EBFCopyPasteServer.getRuntimeRoomObjectForEntry(job, entry)
        end
        EBFCopyPasteServer.bindLightSwitchToRoom(square, object, entry, targetRoom, job)
        return
    end

    local lights = callMethod(object, "getLights")
    if not lights then
        return
    end

    local active = callMethod(object, "isActivated") == true
    local spriteName = entry and entry.sprite or getObjectSpriteName(object)
    local radius = getLightRadius(spriteName)
    local r = getOwnLightSwitchColor(object, spriteName, "getPrimaryR", "lightR", 0.9)
    local g = getOwnLightSwitchColor(object, spriteName, "getPrimaryG", "lightG", 0.8)
    local b = getOwnLightSwitchColor(object, spriteName, "getPrimaryB", "lightB", 0.7)

    if lights:size() == 0 then
        local light = EBFCopyPasteServer.createVanillaHydroLightSourceForSwitch(
                square, object, square:getX(), square:getY(), square:getZ(), r, g, b, radius)
        if light then
            callMethod(light, "setActive", active)
            callMethod(light, "setWasActive", active)
        end
    else
        for i = 0, lights:size() - 1 do
            local light = lights:get(i)
            callMethod(light, "setX", square:getX())
            callMethod(light, "setY", square:getY())
            callMethod(light, "setZ", square:getZ())
            callMethod(light, "setRadius", radius)
            callMethod(light, "setR", r)
            callMethod(light, "setG", g)
            callMethod(light, "setB", b)
            callMethod(light, "setActive", active)
            callMethod(light, "setWasActive", active)
            local switches = callMethod(light, "getSwitches")
            local contains = false
            if switches then
                contains = switches:contains(object) == true
            end
            if switches and not contains then
                switches:add(object)
            end
        end
    end
end

function EBFCopyPasteServer.setLightSwitchSourcesActive(object, active)
    local lights = callMethod(object, "getLights")
    if not lights then
        return 0
    end

    local target = active == true
    if target and callMethod(object, "canSwitchLight") ~= true then
        target = false
    end

    local changed = 0
    local cell = getCell()
    for i = 0, lights:size() - 1 do
        local light = lights:get(i)
        if light then
            callMethod(light, "setActive", target)
            callMethod(light, "setWasActive", target)
            if cell and cell.addLamppost then
                pcall(function()
                    cell:addLamppost(light)
                end)
            end
            callMethod(light, "update")
            changed = changed + 1
        end
    end
    return changed
end

function EBFCopyPasteServer.applyCapturedLightSwitchActiveState(job, square, object, entry, phase)
    if not square or not object or not entry or not isInstance(object, "IsoLightSwitch") then
        return false
    end

    local capturedActive = getLightStateActive(entry) == true
    local isResidential = EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object)
    if isResidential then
        local runtime = EBFCopyPasteServer.getRuntimeRoomForEntry(job, entry)
        local room = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, runtime.spec, runtime))
                or EBFCopyPasteServer.getRuntimeRoomObjectForEntry(job, entry)
                or callMethod(square, "getRoom")
        if runtime and room then
            runtime.room = room
        end
        if room then
            local bound = EBFCopyPasteServer.bindLightSwitchToRoom(square, object, entry, room, job)
            if not bound then
                print("[EBFCopyPaste] Restauración del estado de luz interior bloqueada: falló el vínculo vanilla; interruptor="
                        .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                        .. " phase=" .. tostring(phase)
                        .. " room={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
                return false
            end
            room = callMethod(square, "getRoom") or room
        end

        local roomLightsActive = EBFCopyPasteServer.getEntryRoomLightsActive(job, entry)
        if roomLightsActive == true then
            local previousActive = callMethod(object, "isActivated") == true
            callMethod(object, "setActivated", false)
            local ok = EBFCopyPasteServer.tryCallMethod(object, "setActive", true)
            if ok ~= true or callMethod(object, "isActivated") ~= true then
                callMethod(object, "setActivated", previousActive)
                print("[EBFCopyPaste] Falló la restauración del estado de luz interior mediante setActive vanilla; interruptor="
                        .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                        .. " phase=" .. tostring(phase)
                        .. " room={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
                return false
            end
        else
            callMethod(object, "setActivated", capturedActive)
            if room then
                EBFCopyPasteServer.forceRoomLightsInactive(room, tostring(phase or "restoreCapturedActive"))
            end
        end
    else
        EBFCopyPasteServer.addLightSourceToSwitch(square, object, entry,
                EBFCopyPasteServer.lightSwitchEntryHasOwnLight(entry, object) == true,
                job)
        EBFCopyPasteServer.applyCapturedControlledLightSources(square, object, entry, job)
        EBFCopyPasteServer.applyLightSwitchInitialActiveNoSync(object, capturedActive)
        EBFCopyPasteServer.setLightSwitchSourcesActive(object, capturedActive)
    end

    callMethod(object, "updateLightSource")
    callMethod(object, "checkLightSourceActive")
    transmitCompleteObject(object)
    EBFCopyPasteServer.queueJobObjectForFinalSync(job, object)
    return true
end

function EBFCopyPasteServer.restoreCapturedLightSwitchActiveStates(job, phase)
    if not job or not job.clipboard or type(job.clipboard.objects) ~= "table" then
        return 0
    end

    local restored = 0
    local failures = 0
    for _, entry in ipairs(job.clipboard.objects or {}) do
        if entry
                and not entry.floor
                and (entry.objectClass == "IsoLightSwitch" or isLightSwitchSprite(entry.sprite)) then
            local square = getOrCreateSquare(
                    EBFCopyPaste.toInt(job.targetX, 0) + EBFCopyPaste.toInt(entry.dx, 0),
                    EBFCopyPaste.toInt(job.targetY, 0) + EBFCopyPaste.toInt(entry.dy, 0),
                    EBFCopyPaste.toInt(job.targetZ, 0) + EBFCopyPaste.toInt(entry.dz, 0))
            local object = square and (EBFCopyPasteServer.findObjectForEntry(square, entry, job)
                    or EBFCopyPasteServer.findLightSwitchForEntry(square, entry)) or nil
            if object and EBFCopyPasteServer.applyCapturedLightSwitchActiveState(job, square, object, entry, phase) then
                restored = restored + 1
            else
                failures = failures + 1
            end
        end
    end

    job.capturedLightStatesRestored = (tonumber(job.capturedLightStatesRestored) or 0) + restored
    job.capturedLightStateRestoreFailures = (tonumber(job.capturedLightStateRestoreFailures) or 0) + failures
    print("[EBFCopyPaste] Estados capturados de luz restaurados: restored=" .. tostring(restored)
            .. " failures=" .. tostring(failures)
            .. " phase=" .. tostring(phase))
    return restored
end

function EBFCopyPasteServer.getLightBindingForEntry(job, entry)
    if not job or not job.clipboard or not entry then
        return nil
    end

    local key = entry.lightBindingKey or (entry.lightBinding and entry.lightBinding.key)
    if key and job.clipboard.lightBindings then
        local binding = job.clipboard.lightBindings[key]
        if binding then
            return binding
        end
    end
    return nil
end

function EBFCopyPasteServer.getControlledLightSourcesForEntry(job, entry)
    local binding = EBFCopyPasteServer.getLightBindingForEntry(job, entry)
    if binding and type(binding.controlledLightSources) == "table" and #binding.controlledLightSources > 0 then
        return binding.controlledLightSources, binding
    end
    if entry and type(entry.controlledLightSources) == "table" and #entry.controlledLightSources > 0 then
        return entry.controlledLightSources, binding
    end
    local stateBlock = entry and entry.stateBlock or nil
    local lightData = stateBlock and stateBlock.lightData or nil
    if lightData and type(lightData.controlledSources) == "table" and #lightData.controlledSources > 0 then
        return lightData.controlledSources, binding
    end
    return nil, binding
end

function EBFCopyPasteServer.applyCapturedControlledLightSources(square, object, entry, job)
    local controlledSources, binding = EBFCopyPasteServer.getControlledLightSourcesForEntry(job, entry)
    if not square or not object or not entry or type(controlledSources) ~= "table" or #controlledSources <= 0 or not IsoLightSource then
        return false
    end
    if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
        if job then
            job.exactLightBindingsSkippedResidentialSwitch = (tonumber(job.exactLightBindingsSkippedResidentialSwitch) or 0) + 1
        end
        return false
    end
    local lights = callMethod(object, "getLights")
    if not lights then
        return false
    end

    local cell = getCell and getCell() or nil
    if cell and cell.removeLamppost then
        for i = 0, lights:size() - 1 do
            local light = lights:get(i)
            if light then
                callMethod(light, "setActive", false)
                callMethod(light, "setWasActive", false)
                pcall(function()
                    cell:removeLamppost(light)
                end)
            end
        end
    end

    if lights.clear then
        pcall(function()
            lights:clear()
        end)
    else
        for i = (tonumber(callMethod(lights, "size")) or 0) - 1, 0, -1 do
            pcall(function()
                lights:remove(i)
            end)
        end
    end

    local baseX = EBFCopyPaste.toInt(job and job.targetX, square:getX() - EBFCopyPaste.toInt(entry.dx, 0))
    local baseY = EBFCopyPaste.toInt(job and job.targetY, square:getY() - EBFCopyPaste.toInt(entry.dy, 0))
    local baseZ = EBFCopyPaste.toInt(job and job.targetZ, square:getZ() - EBFCopyPaste.toInt(entry.dz, 0))
    local created = 0

    for _, source in ipairs(controlledSources or {}) do
        local lightX = baseX + EBFCopyPaste.toInt(source.dx, EBFCopyPaste.toInt(entry.dx, 0))
        local lightY = baseY + EBFCopyPaste.toInt(source.dy, EBFCopyPaste.toInt(entry.dy, 0))
        local lightZ = baseZ + EBFCopyPaste.toInt(source.dz, EBFCopyPaste.toInt(entry.dz, 0))
        local radius = math.max(1, tonumber(source.radius) or getLightRadius(entry.sprite))
        local r = tonumber(source.r) or getOwnLightSwitchColor(object, entry.sprite, "getPrimaryR", "lightR", 1)
        local g = tonumber(source.g) or getOwnLightSwitchColor(object, entry.sprite, "getPrimaryG", "lightG", 1)
        local b = tonumber(source.b) or getOwnLightSwitchColor(object, entry.sprite, "getPrimaryB", "lightB", 1)

        local light = EBFCopyPasteServer.createVanillaHydroLightSourceForSwitch(
                square, object, lightX, lightY, lightZ, r, g, b, radius)
        if light then
            created = created + 1
        end
    end

    if created > 0 and job then
        job.exactLightBindingsApplied = (tonumber(job.exactLightBindingsApplied) or 0) + 1
        if binding then
            print("[EBFCopyPaste] LightBinding exato aplicado: switch="
                    .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                    .. " room=" .. tostring(binding.sourceRoomName or binding.sourceRoomKey or "?")
                    .. " key=" .. tostring(binding.key or "?")
                    .. " sources=" .. tostring(created))
        end
    end

    return created > 0
end

function EBFCopyPasteServer.prepareLightSwitchForVanillaPower(square, object, entry, canBeModified, forceLocalSource, job)
    if not square or not object or not isInstance(object, "IsoLightSwitch") then
        return false
    end

    local lightState = entry and entry.lightState or {}
    if type(lightState.bulbItem) == "string" and lightState.bulbItem ~= "" then
        callMethod(object, "setBulbItemRaw", lightState.bulbItem)
    elseif lightState.hasLightBulb == true and callMethod(object, "hasLightBulb") == false then
        callMethod(object, "setBulbItemRaw", "Base.LightBulb")
    end

    if canBeModified ~= nil then
        callMethod(object, "setCanBeModified", canBeModified == true)
    end
    if getMethod(object, "setUseBatteryDirect") then
        callMethod(object, "setUseBatteryDirect", false)
    else
        callMethod(object, "setUseBattery", false)
    end
    if getMethod(object, "setHasBatteryRaw") then
        callMethod(object, "setHasBatteryRaw", false)
    else
        callMethod(object, "setHasBattery", false)
    end

    EBFCopyPasteServer.applyLightSwitchInitialActiveNoSync(object, false)
    EBFCopyPasteServer.addLightSourceToSwitch(square, object, entry, forceLocalSource == true, job)
    EBFCopyPasteServer.applyCapturedControlledLightSources(square, object, entry, job)
    EBFCopyPasteServer.setLightSwitchSourcesActive(object, false)
    callMethod(object, "updateLightSource")
    callMethod(object, "checkLightSourceActive")
    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end
    return true
end

function EBFCopyPasteServer.materializePersistentItemSnapshot(snapshot)
    if type(snapshot) == "table" and snapshot.fullType and createItemFromPersistentSnapshot then
        return createItemFromPersistentSnapshot(snapshot, 0)
    end
    return snapshot
end

function EBFCopyPasteServer.applyCustomSettingsItem(object, settingsItem)
    if not object or not settingsItem or not getMethod(object, "getCustomSettingsFromItem") then
        return false
    end
    if not isInstance(object, "IsoLightSwitch") then
        return false
    end

    settingsItem = EBFCopyPasteServer.materializePersistentItemSnapshot(settingsItem)
    if not settingsItem then
        return false
    end

    local ok = EBFCopyPasteServer.tryCallMethod(object, "getCustomSettingsFromItem", settingsItem)
    return ok == true
end

function EBFCopyPasteServer.applyLightSourceState(square, object, state)
    if not square or not object or not state then
        return false
    end

    local changed = false
    local radius = tonumber(state.radius) or tonumber(callMethod(object, "getLightSourceRadius")) or 0
    local xoffset = tonumber(state.xoffset) or tonumber(callMethod(object, "getLightSourceXOffset")) or 0
    local yoffset = tonumber(state.yoffset) or tonumber(callMethod(object, "getLightSourceYOffset")) or 0
    local life = tonumber(state.life) or 0
    local lifeLeft = tonumber(state.lifeLeft)
    local fuel = type(state.fuel) == "string" and state.fuel or nil

    if radius > 0 and not callMethod(object, "getLightSource") and getMethod(object, "createLightSource") then
        local ok = EBFCopyPasteServer.tryCallMethod(object, "createLightSource", radius, xoffset, yoffset, 0, life, fuel, nil, nil)
        changed = changed or ok == true
    end

    if radius > 0 then
        callMethod(object, "setLightSourceRadius", radius)
    end
    callMethod(object, "setLightSourceXOffset", xoffset)
    callMethod(object, "setLightSourceYOffset", yoffset)
    if life > 0 then
        callMethod(object, "setLightSourceLife", life)
    end
    if lifeLeft ~= nil then
        callMethod(object, "setLifeLeft", lifeLeft)
    end
    if fuel then
        callMethod(object, "setLightSourceFuel", fuel)
    end

    local hasFuel = state.haveFuel
    if hasFuel == nil and lifeLeft ~= nil then
        hasFuel = lifeLeft > 0
    end
    if hasFuel ~= nil then
        callMethod(object, "setHaveFuel", hasFuel == true)
    end

    callMethod(object, "setLightSourceOn", false)

    local lightSource = callMethod(object, "getLightSource")
    if lightSource then
        callMethod(lightSource, "setX", square:getX())
        callMethod(lightSource, "setY", square:getY())
        callMethod(lightSource, "setZ", square:getZ())
        if radius > 0 then
            callMethod(lightSource, "setRadius", radius)
        end
        if state.r ~= nil then callMethod(lightSource, "setR", tonumber(state.r) or state.r) end
        if state.g ~= nil then callMethod(lightSource, "setG", tonumber(state.g) or state.g) end
        if state.b ~= nil then callMethod(lightSource, "setB", tonumber(state.b) or state.b) end
        callMethod(lightSource, "setActive", false)
        callMethod(lightSource, "setWasActive", false)
        local cell = getCell()
        if cell and cell.addLamppost then
            pcall(cell.addLamppost, cell, lightSource)
        end
        callMethod(lightSource, "update")
        changed = true
    end

    callMethod(object, "addLightSourceToWorld")
    callMethod(object, "checkLightSourceActive")
    return changed
end

local function registerLightSwitchSources(square, object, entry, job)
    if not square or not object or not isInstance(object, "IsoLightSwitch") then
        return
    end

    EBFCopyPasteServer.addLightSourceToSwitch(square, object, entry, false, job)

    local lights = callMethod(object, "getLights")
    local cell = getCell()
    if lights and cell and cell.addLamppost then
        for i = 0, lights:size() - 1 do
            callMethod(cell, "addLamppost", lights:get(i))
        end
    end
end

local function prepareResidentialLightSwitch(square, object, entry, job)
    if not square or not object then
        return false
    end

    local runtime = EBFCopyPasteServer.getRuntimeRoomForEntry(job, entry)
    if runtime then
        EBFCopyPasteServer.setSquareRuntimeRoom(square, runtime)
    else
        EBFCopyPasteServer.applyRuntimeRoomForEntrySquare(job, square, entry)
    end
    local targetRoom = runtime and (runtime.room or EBFCopyPasteServer.findRuntimeRoomForSpec(job, runtime.spec, runtime))
            or EBFCopyPasteServer.getRuntimeRoomObjectForEntry(job, entry)
    if runtime and targetRoom then
        runtime.room = targetRoom
    end
    local lightState = entry and entry.lightState or {}
    if type(lightState.bulbItem) == "string" and lightState.bulbItem ~= "" then
        callMethod(object, "setBulbItemRaw", lightState.bulbItem)
    elseif lightState.hasLightBulb == true and callMethod(object, "hasLightBulb") == false then
        callMethod(object, "setBulbItemRaw", "Base.LightBulb")
    end
    callMethod(object, "setCanBeModified", false)
    if getMethod(object, "setUseBatteryDirect") then
        callMethod(object, "setUseBatteryDirect", false)
    else
        callMethod(object, "setUseBattery", false)
    end
    if getMethod(object, "setHasBatteryRaw") then
        callMethod(object, "setHasBatteryRaw", false)
    else
        callMethod(object, "setHasBattery", false)
    end
    callMethod(object, "setActivated", false)

    local bound = EBFCopyPasteServer.bindLightSwitchToRoom(square, object, entry, targetRoom, job)
    if bound then
        local room = callMethod(square, "getRoom") or targetRoom
        local spec = EBFCopyPasteServer.findRoomSpecForEntry(job, entry)
        local squareRoom = callMethod(square, "getRoom")
        local switches = EBFCopyPasteServer.getJavaListSize(room and callMethod(room, "getLightSwitches") or nil)
        local roomLights, roomLightsKnown = EBFCopyPasteServer.getEffectiveRoomLightCount(room, square)
        local lightRoom = EBFCopyPasteServer.safeField(object, "lightRoom")
        if lightRoom == nil and switches > 0 and EBFCopyPasteServer.getJavaListSize(callMethod(object, "getLights")) == 0 then
            lightRoom = true
        end
        if job then
            job.vanillaRoomLightBindingsApplied = (tonumber(job.vanillaRoomLightBindingsApplied) or 0) + 1
        end
        print("[EBFCopyPaste] lighting_indoor vanilla fiel vinculado: switch="
                .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                .. " sprite=" .. tostring(entry.sprite)
                .. " roomKey=" .. tostring(entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key) or "?")
                .. " roomLights=" .. tostring(roomLights)
                .. " roomLightsKnown=" .. tostring(roomLightsKnown)
                .. " roomSwitches=" .. tostring(switches)
                .. " lightRoom=" .. tostring(lightRoom)
                .. " lightsActive=" .. tostring(room and callMethod(room, "getRoomDef")
                        and EBFCopyPasteServer.safeField(callMethod(room, "getRoomDef"), "lightsActive"))
                .. " expectedRoom={" .. EBFCopyPasteServer.getRoomAuditLabel(targetRoom) .. "}"
                .. " squareRoom={" .. EBFCopyPasteServer.getRoomAuditLabel(squareRoom) .. "}"
                .. " " .. EBFCopyPasteServer.formatRoomSpecTileSample(job, spec, 8))
    end
    if not bound then
        if job then
            job.vanillaRoomLightBindingFailures = (tonumber(job.vanillaRoomLightBindingFailures) or 0) + 1
        end
        print("[EBFCopyPaste] FALLO DE FIDELIDAD lighting_indoor sin RoomDef vanilla válido; interruptor="
                .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ())
                .. " sprite=" .. tostring(entry.sprite)
                .. " roomKey=" .. tostring(entry.sourceRoomKey or (entry.sourceRoom and entry.sourceRoom.key) or "?"))
        bound = false
    end

    if bound then
        callMethod(object, "updateLightSource")
        callMethod(object, "checkLightSourceActive")
        if IsoGenerator and IsoGenerator.updateGenerator then
            pcall(IsoGenerator.updateGenerator, square)
        end
        if job then
            job.roomRuntimeSwitchesBound = (tonumber(job.roomRuntimeSwitchesBound) or 0) + 1
        end
        EBFCopyPasteServer.logLightSwitchToggleAudit("prepareResidentialLightSwitch", object, nil)
        return true
    end

    return false
end

local function prepareLightSwitchState(square, object, entry, job)
    if not object or not entry or not isInstance(object, "IsoLightSwitch") then
        return
    end

    if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
        prepareResidentialLightSwitch(square, object, entry, job)
        return
    end

    EBFCopyPasteServer.applyCustomSettingsItem(object, entry.lightSettings)

    local lightState = entry.lightState or {}
    local isMoveableLamp = EBFCopyPasteServer.entryIsMoveableLamp(entry, object)
    local active = false
    if type(lightState.bulbItem) == "string" and lightState.bulbItem ~= "" then
        callMethod(object, "setBulbItemRaw", lightState.bulbItem)
    elseif lightState.hasLightBulb == true and callMethod(object, "hasLightBulb") == false then
        callMethod(object, "setBulbItemRaw", "Base.LightBulb")
    end

    local canBeModified = getLightStateValue(lightState, "canBeModified", "setCanBeModified", nil)
    if canBeModified ~= nil then
        callMethod(object, "setCanBeModified", canBeModified == true)
    elseif isMoveableLamp then
        callMethod(object, "setCanBeModified", true)
    end

    local useBattery = getLightStateValue(lightState, "useBattery", "setUseBattery", nil)
    if useBattery ~= nil then
        if getMethod(object, "setUseBatteryDirect") then
            callMethod(object, "setUseBatteryDirect", useBattery == true)
        else
            callMethod(object, "setUseBattery", useBattery == true)
        end
    end

    local hasBattery = getLightStateValue(lightState, "hasBattery", "setHasBattery", nil)
    if hasBattery ~= nil and (not isMoveableLamp or useBattery == true) then
        if getMethod(object, "setHasBatteryRaw") then
            callMethod(object, "setHasBatteryRaw", hasBattery == true)
        else
            callMethod(object, "setHasBattery", hasBattery == true)
        end
    end

    local power = tonumber(getLightStateValue(lightState, "power", "setPower", nil))
    if power ~= nil and (not isMoveableLamp or useBattery == true) then
        callMethod(object, "setPower", power)
    end

    local delta = tonumber(getLightStateValue(lightState, "delta", "setDelta", nil))
    if delta ~= nil then
        callMethod(object, "setDelta", delta)
    end

    local r = tonumber(getLightStateValue(lightState, "primaryR", "setPrimaryR", nil))
    local g = tonumber(getLightStateValue(lightState, "primaryG", "setPrimaryG", nil))
    local b = tonumber(getLightStateValue(lightState, "primaryB", "setPrimaryB", nil))
    if r ~= nil then callMethod(object, "setPrimaryR", r) end
    if g ~= nil then callMethod(object, "setPrimaryG", g) end
    if b ~= nil then callMethod(object, "setPrimaryB", b) end

    for setterName, value in pairs(lightState.methods or {}) do
        if not EBFCopyPasteServer.handledLightStateSetters[setterName] then
            callMethod(object, setterName, value)
        end
    end

    EBFCopyPasteServer.addLightSourceToSwitch(square, object, entry)
    EBFCopyPasteServer.applyCapturedControlledLightSources(square, object, entry, job)
    EBFCopyPasteServer.applyLightSwitchInitialActiveNoSync(object, active)
end

function EBFCopyPasteServer.ensureMoveableSpriteProps()
    if not ISMoveableSpriteProps and require then
        pcall(require, "Moveables/ISMoveableSpriteProps")
    end
    return ISMoveableSpriteProps
end

function EBFCopyPasteServer.getVanillaMoveableProps(entry)
    if not entry or type(entry.sprite) ~= "string" or entry.sprite == "" then
        return nil
    end

    local sprite = getSprite(entry.sprite)
    local propsClass = EBFCopyPasteServer.ensureMoveableSpriteProps()
    if not sprite or not propsClass or not propsClass.new then
        return nil
    end

    local ok, props = pcall(function()
        return propsClass.new(sprite)
    end)
    if ok and props then
        props.rawWeight = props.rawWeight or 10
        return props
    end
    return nil
end

function EBFCopyPasteServer.shouldUseVanillaMoveablePaste(entry, props)
    if not entry or entry.floor or entry.objectClass == "IsoWorldInventoryObject" or not props then
        return false
    end

    if props.type == "FloorTile" or props.type == "WallOverlay" then
        return false
    end

    if entry.objectClass == "IsoDoor"
            or entry.objectClass == "IsoWindow"
            or entry.objectClass == "IsoWindowFrame"
            or entry.objectClass == "IsoCurtain"
            or entry.isoType == "IsoWindowFrame"
            or entry.isoType == "IsoCurtain"
            or entry.isDoor == true
            or entry.isDoorFrame == true
            or entry.isWindow == true then
        return false
    end
    local forceMoveableLamp = EBFCopyPasteServer.entryIsMoveableLamp(entry)
    if EBFCopyPasteServer.entryIsWaterDispenser(entry)
            or EBFCopyPasteServer.entryIsTelevision(entry)
            or EBFCopyPasteServer.entryIsRadio(entry) then
        return false
    end

    if props.type == "Window" then
        return true
    end

    if entry.sprite == "camping_01_04" or entry.sprite == "camping_01_05" or entry.sprite == "camping_01_06" then
        return false
    end

    local spriteProps = props.spriteProps
    if spriteProps and spriteProps.has and spriteProps:has("streetlight") then
        return false
    end

    if string.sub(entry.sprite, 1, string.len("blends_natural_02")) == "blends_natural_02" then
        return false
    end

    if props.isMoveable and entry.objectClass ~= "IsoObject" then
        return true
    end

    if entry.objectClass == "IsoThumpable" then
        return true
    end

    local factory = entry.factory
    if entry.objectClass ~= "IsoObject"
            and factory
            and factory.hasMoveableProps
            and (factory.type == nil or factory.type == "Object" or factory.type == "WallObject" or factory.type == "FloorRug") then
        return true
    end

    return false
end

function EBFCopyPasteServer.entryUsesBrushCreateTile(entry)
    if not entry or type(entry.sprite) ~= "string" or entry.sprite == "" then
        return false
    end

    if EBFCopyPasteServer.entryIsLighting(entry) then
        return false
    end

    if EBFCopyPasteServer.entryIsWallRoofOrCutawayStructural(entry) == true then
        return true
    end

    if entry.objectClass == "IsoObject"
            and not entry.floor
            and entry.objectClass ~= "IsoWorldInventoryObject"
            and entry.worldItem == nil
            and not EBFCopyPasteServer.entryIsTelevision(entry)
            and not EBFCopyPasteServer.entryIsRadio(entry) then
        return true
    end

    local props = getSpritePropertiesByName(entry.sprite)
    return props and props.has and props:has("streetlight")
end

function EBFCopyPasteServer.applyEntryLightStateToMoveableItem(item, entry)
    if not item or not entry or not entry.lightState then
        return
    end

    local lightState = entry.lightState
    local isMoveableLamp = EBFCopyPasteServer.entryIsMoveableLamp(entry)
    callMethod(item, "setLight", true)

    local useBattery = getLightStateValue(lightState, "useBattery", "setUseBattery", nil)
    if useBattery ~= nil then
        callMethod(item, "setLightUseBattery", useBattery == true)
    end

    local hasBattery = getLightStateValue(lightState, "hasBattery", "setHasBattery", nil)
    if hasBattery ~= nil and (not isMoveableLamp or useBattery == true) then
        callMethod(item, "setLightHasBattery", hasBattery == true)
    end

    local bulbItem = lightState.bulbItem
    if type(bulbItem) == "string" and bulbItem ~= "" then
        callMethod(item, "setLightBulbItem", bulbItem)
    elseif lightState.hasLightBulb == true then
        callMethod(item, "setLightBulbItem", "Base.LightBulb")
    end

    local power = tonumber(getLightStateValue(lightState, "power", "setPower", nil))
    if power and (not isMoveableLamp or useBattery == true) then
        callMethod(item, "setLightPower", power)
    end

    local delta = tonumber(getLightStateValue(lightState, "delta", "setDelta", nil))
    if delta then
        callMethod(item, "setLightDelta", delta)
    end

    local r = tonumber(getLightStateValue(lightState, "primaryR", "setPrimaryR", nil))
    local g = tonumber(getLightStateValue(lightState, "primaryG", "setPrimaryG", nil))
    local b = tonumber(getLightStateValue(lightState, "primaryB", "setPrimaryB", nil))
    if r then callMethod(item, "setLightR", r) end
    if g then callMethod(item, "setLightG", g) end
    if b then callMethod(item, "setLightB", b) end
end

function EBFCopyPasteServer.applyEntryLightSourceToMoveableItem(item, entry)
    if not item or not item.getModData or not entry or not entry.lightSource then
        return
    end

    local state = entry.lightSource
    local radius = tonumber(state.radius) or 0
    if radius <= 0 then
        return
    end

    local modData = item:getModData()
    modData.lightSource = {
        radius = radius,
        xoffset = tonumber(state.xoffset) or 0,
        yoffset = tonumber(state.yoffset) or 0,
        life = tonumber(state.lifeLeft) or tonumber(state.life) or 0,
        fuel = state.fuel,
    }
end

function EBFCopyPasteServer.entryUsesWaveSignalMoveable(props, entry)
    return EBFCopyPasteServer.entryUsesRadioMoveable(props, entry)
            or EBFCopyPasteServer.entryUsesTelevisionMoveable(props, entry)
end

function EBFCopyPasteServer.entryUsesRadioMoveable(props, entry)
    if props and props.isoType == "IsoRadio" then
        return true
    end
    return EBFCopyPasteServer.entryIsRadio(entry)
end

function EBFCopyPasteServer.entryUsesTelevisionMoveable(props, entry)
    if props and props.isoType == "IsoTelevision" then
        return true
    end
    return EBFCopyPasteServer.entryIsTelevision(entry)
end

function EBFCopyPasteServer.sanitizeWaveSignalPlacementItem(item)
    local deviceData = callMethod(item, "getDeviceData")
    if not deviceData then
        return
    end

    if getMethod(deviceData, "setTurnedOnRaw") then
        callMethod(deviceData, "setTurnedOnRaw", false)
        return
    end
    EBFCopyPasteServer.tryCallMethod(deviceData, "setIsTurnedOn", false)
end

function EBFCopyPasteServer.sanitizeRadioPlacementItem(item)
    EBFCopyPasteServer.sanitizeWaveSignalPlacementItem(item)
end

function EBFCopyPasteServer.sanitizeTelevisionPlacementItem(item)
    EBFCopyPasteServer.sanitizeWaveSignalPlacementItem(item)
end

function EBFCopyPasteServer.ensureWaveSignalPlacementItemParent(square, item, entry)
    if not square or not item then
        return false
    end

    local deviceData = callMethod(item, "getDeviceData")
    if not deviceData then
        return true
    end

    local parent = callMethod(deviceData, "getParent")
    if parent and callMethod(parent, "getSquare") ~= nil then
        return true
    end

    local spriteName = entry and entry.sprite or nil
    local sprite = spriteName and getSprite(spriteName) or nil
    if not sprite then
        return false
    end

    local ok, proxy = pcall(function()
        if EBFCopyPasteServer.entryIsTelevision(entry) and IsoTelevision then
            return IsoTelevision.new(getCell(), square, sprite)
        elseif EBFCopyPasteServer.entryIsRadio(entry) and IsoRadio then
            return IsoRadio.new(getCell(), square, sprite)
        end
        return nil
    end)
    if not ok or not proxy then
        return false
    end

    local setOk = EBFCopyPasteServer.tryCallMethod(deviceData, "setParent", proxy)
    return setOk == true
end

function EBFCopyPasteServer.getTelevisionPlacementItemFullType(props, entry)
    local candidates = {}
    local function addCandidate(value)
        if type(value) == "string" and value ~= "" and value ~= "Moveables.Moveable" then
            table.insert(candidates, value)
        end
    end

    addCandidate(props and props.customItem)
    addCandidate(entry and entry.vanillaPlacement and entry.vanillaPlacement.customItem)
    addCandidate(entry and entry.spriteProperties and entry.spriteProperties.CustomItem)
    addCandidate(entry and entry.spriteProperties and entry.spriteProperties.customItem)
    addCandidate(entry and entry.moveableItem and entry.moveableItem.fullType)

    for _, fullType in ipairs(candidates) do
        if EBFCopyPasteServer.itemScriptExists(fullType) then
            return fullType
        end
    end
    return nil
end

function EBFCopyPasteServer.createTelevisionPlacementItem(props, entry)
    if not entry then
        return nil
    end

    local item = nil
    local fullType = EBFCopyPasteServer.getTelevisionPlacementItemFullType(props, entry)
    if fullType then
        item = EBFCopyPasteServer.safeInstanceItem(fullType)
    end

    if not item and props and props.instanceItem then
        local ok, created = pcall(function()
            return props:instanceItem(entry.sprite)
        end)
        if ok and created then
            item = created
        end
    end

    if not item then
        return nil
    end

    local itemFullType = callMethod(item, "getFullType")
    if itemFullType == "Moveables.Moveable" then
        print("[EBFCopyPaste] television paste skipped generic Moveables.Moveable item for " .. tostring(entry.sprite))
        return nil
    end

    EBFCopyPasteServer.sanitizeTelevisionPlacementItem(item)
    return item
end

function EBFCopyPasteServer.sanitizeMoveableLampPlacementSnapshot(snapshot, entry)
    if not snapshot or not EBFCopyPasteServer.entryIsMoveableLamp(entry) then
        return
    end

    local methods = snapshot.methods
    if not methods then
        return
    end

    local useBattery = getLightStateValue(entry and entry.lightState, "useBattery", "setUseBattery", nil)
    if useBattery ~= true then
        methods.setLightHasBattery = nil
        methods.setLightPower = nil
    end
end

function EBFCopyPasteServer.prepareVanillaMoveablePlacementItem(props, entry)
    if not props or not entry then
        return nil
    end

    local isRadioMoveable = EBFCopyPasteServer.entryUsesRadioMoveable(props, entry)
    local isTelevisionMoveable = EBFCopyPasteServer.entryUsesTelevisionMoveable(props, entry)
    local isWaveSignalMoveable = isRadioMoveable or isTelevisionMoveable
    if isTelevisionMoveable then
        return EBFCopyPasteServer.createTelevisionPlacementItem(props, entry)
    end
    if isRadioMoveable then
        return createSafeWaveSignalPlacementItem()
    end

    local moveableItemSnapshot = entry.moveableItem
    if moveableItemSnapshot then
        moveableItemSnapshot = copyPersistentValue(moveableItemSnapshot, 0)
        if moveableItemSnapshot then
            moveableItemSnapshot.deviceData = nil
            EBFCopyPasteServer.sanitizeMoveableLampPlacementSnapshot(moveableItemSnapshot, entry)
            if isWaveSignalMoveable and moveableItemSnapshot.fullType == "Moveables.Moveable" then
                moveableItemSnapshot = nil
            end
        end
    end
    local item = createItemFromPersistentSnapshot(moveableItemSnapshot, 0, {
        skipDeviceData = true,
        skipSetters = {
            setActivated = true,
        },
    })

    if not item and not isWaveSignalMoveable then
        item = EBFCopyPasteServer.materializePersistentItemSnapshot(entry.lightSettings)
    end

    if not item and props.instanceItem then
        local created = props:instanceItem(entry.sprite)
        if created then
            item = created
        end
    end
    if not item and not props.isMoveable then
        item = EBFCopyPasteServer.createBrushToolPlacementItem()
    end
    item = item or createMoveableSnapshotItem(entry.sprite)
    if not item then
        return nil
    end

    if props.isMoveable or callMethod(item, "getFullType") == "Moveables.Moveable" then
        callMethod(item, "ReadFromWorldSprite", entry.sprite)
    end
    local isResidentialLightSwitch = EBFCopyPasteServer.entryIsResidentialLightSwitch(entry)
    local conservativeVanillaState = EBFCopyPasteServer.entryUsesConservativeVanillaState(entry)
    if isWaveSignalMoveable then
        if isTelevisionMoveable then
            EBFCopyPasteServer.sanitizeTelevisionPlacementItem(item)
        elseif isRadioMoveable then
            EBFCopyPasteServer.sanitizeRadioPlacementItem(item)
        end
    end
    if entry.modData and not isResidentialLightSwitch and not conservativeVanillaState then
        applyModData(item, entry.modData)
    end

    if entry.state and entry.state.methods and entry.state.methods.setBroken == true then
        callMethod(item, "setCondition", 0)
    end
    if not isResidentialLightSwitch and not conservativeVanillaState then
        EBFCopyPasteServer.applyEntryLightStateToMoveableItem(item, entry)
        EBFCopyPasteServer.applyEntryLightSourceToMoveableItem(item, entry)
    end
    return item
end

function EBFCopyPasteServer.placeEntryWithBrushCreateTile(square, entry)
    if not square or not EBFCopyPasteServer.entryUsesBrushCreateTile(entry) or not createTile then
        return nil, false
    end

    local brushSprite = entry and entry.sprite or nil
    if not brushSprite or brushSprite == "" then
        return nil, false
    end

    local objects = square:getObjects()
    local before = {}
    if objects then
        for i = 0, objects:size() - 1 do
            before[objects:get(i)] = true
        end
    end

    local ok, result = pcall(function()
        return createTile(brushSprite, square)
    end)
    if not ok then
        print("[EBFCopyPaste] brush createTile paste failed for " .. tostring(brushSprite) .. ": " .. tostring(result))
        return nil, false
    end
    if result and type(result) ~= "boolean" and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, result) then
        return result, true
    elseif result and type(result) ~= "boolean" then
        EBFCopyPasteServer.discardUnregisteredVanillaObject(result)
    end

    objects = square:getObjects()
    if objects then
        for i = 0, objects:size() - 1 do
            local candidate = objects:get(i)
            if not before[candidate]
                    and getObjectSpriteName(candidate) == brushSprite
                    and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, candidate) then
                return candidate, true
            end
        end
    end
    return nil, false
end

function EBFCopyPasteServer.markVanillaMoveableObjectInitialized(object)
    if object and object.getModData then
        object:getModData().EBFCopyPasteB42EntityInitialized = true
    end
end

function EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object)
    if not square or not object then
        return false
    end

    if callMethod(object, "getSquare") ~= square then
        return false
    end

    if EBFCopyPasteServer.squareContainsObjectForTransmit then
        return EBFCopyPasteServer.squareContainsObjectForTransmit(square, object) == true
    end

    local objects = square.getObjects and square:getObjects() or nil
    if not objects then
        return false
    end
    for i = 0, objects:size() - 1 do
        if objects:get(i) == object then
            return true
        end
    end
    return false
end

function EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
    if not object then
        return
    end
    if callMethod(object, "getSquare") ~= nil then
        return
    end
    callMethod(object, "removeFromWorld")
    callMethod(object, "removeFromSquare")
end

function EBFCopyPasteServer.placeTelevisionWithVanillaMoveable(square, entry)
    if not square or not EBFCopyPasteServer.entryIsTelevision(entry) then
        return nil, false
    end

    local props = EBFCopyPasteServer.getVanillaMoveableProps(entry)
    if not props or not props.placeMoveableInternal then
        return nil, false
    end

    local item = EBFCopyPasteServer.prepareVanillaMoveablePlacementItem(props, entry)
    if not item then
        return nil, false
    end
    if not EBFCopyPasteServer.ensureWaveSignalPlacementItemParent(square, item, entry) then
        print("[EBFCopyPaste] television paste skipped unsafe DeviceData parent for " .. tostring(entry.sprite))
        return nil, false
    end

    local objects = square:getObjects()
    local before = {}
    if objects then
        for i = 0, objects:size() - 1 do
            before[objects:get(i)] = true
        end
    end

    local ok, object = pcall(function()
        return props:placeMoveableInternal(square, item, entry.sprite)
    end)
    if not ok then
        print("[EBFCopyPaste] vanilla television moveable paste failed for " .. tostring(entry.sprite) .. ": " .. tostring(object))
        return nil, false
    end

    if object and isInstance(object, "IsoTelevision")
            and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        EBFCopyPasteServer.ensureWaveSignalDeviceSafe(square, object)
        if triggerEvent then
            triggerEvent("OnObjectAdded", object)
        end
        EBFCopyPasteServer.markVanillaMoveableObjectInitialized(object)
        return object, true
    elseif object and isInstance(object, "IsoTelevision") then
        EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
    end

    objects = square:getObjects()
    if objects then
        for i = 0, objects:size() - 1 do
            local candidate = objects:get(i)
            if not before[candidate]
                    and getObjectSpriteName(candidate) == entry.sprite
                    and isInstance(candidate, "IsoTelevision")
                    and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, candidate) then
                EBFCopyPasteServer.ensureWaveSignalDeviceSafe(square, candidate)
                EBFCopyPasteServer.markVanillaMoveableObjectInitialized(candidate)
                return candidate, true
            end
        end
    end
    return nil, false
end

function EBFCopyPasteServer.placeWaveSignalWithVanillaMoveable(square, entry)
    if not square or not EBFCopyPasteServer.entryIsWaveSignal(entry) then
        return nil, false
    end
    if EBFCopyPasteServer.entryIsTelevision(entry) then
        return nil, false
    end

    local props = EBFCopyPasteServer.getVanillaMoveableProps(entry)
    if not props or not props.placeMoveableInternal then
        return nil, false
    end

    local item = EBFCopyPasteServer.prepareVanillaMoveablePlacementItem(props, entry)
    if not item then
        return nil, false
    end
    local wantsRadio = EBFCopyPasteServer.entryIsRadio(entry)
    if wantsRadio and isInstance(item, "Radio") then
        item = createSafeWaveSignalPlacementItem()
    end

    if not item or (wantsRadio and isInstance(item, "Radio")) then
        print("[EBFCopyPaste] wave-signal paste skipped because placement item is unsafe for " .. tostring(entry.sprite))
        return nil, false
    end
    if wantsRadio then
        EBFCopyPasteServer.sanitizeRadioPlacementItem(item)
        if not EBFCopyPasteServer.ensureWaveSignalPlacementItemParent(square, item, entry) then
            print("[EBFCopyPaste] wave-signal paste skipped unsafe DeviceData parent for " .. tostring(entry.sprite))
            return nil, false
        end
    end

    local objects = square:getObjects()
    local before = {}
    if objects then
        for i = 0, objects:size() - 1 do
            before[objects:get(i)] = true
        end
    end

    local ok, object = pcall(function()
        return props:placeMoveableInternal(square, item, entry.sprite)
    end)
    if not ok then
        print("[EBFCopyPaste] vanilla wave-signal paste failed for " .. tostring(entry.sprite) .. ": " .. tostring(object))
        return nil, false
    end
    if object
            and wantsRadio
            and isInstance(object, "IsoRadio")
            and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        EBFCopyPasteServer.markVanillaMoveableObjectInitialized(object)
        return object, true
    elseif object
            and wantsRadio
            and isInstance(object, "IsoRadio") then
        EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
    end

    objects = square:getObjects()
    if objects then
        for i = 0, objects:size() - 1 do
            local candidate = objects:get(i)
            if not before[candidate]
                    and getObjectSpriteName(candidate) == entry.sprite
                    and wantsRadio
                    and isInstance(candidate, "IsoRadio")
                    and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, candidate) then
                EBFCopyPasteServer.markVanillaMoveableObjectInitialized(candidate)
                return candidate, true
            end
        end
    end
    return nil, false
end

function EBFCopyPasteServer.placeEntryWithVanillaMoveable(square, entry)
    local props = EBFCopyPasteServer.getVanillaMoveableProps(entry)
    if not square or not EBFCopyPasteServer.shouldUseVanillaMoveablePaste(entry, props) then
        return nil, false
    end

    local item = EBFCopyPasteServer.prepareVanillaMoveablePlacementItem(props, entry)
    if not item then
        return nil, false
    end
    if EBFCopyPasteServer.entryIsWaveSignal(entry)
            and not EBFCopyPasteServer.ensureWaveSignalPlacementItemParent(square, item, entry) then
        print("[EBFCopyPaste] vanilla moveable paste skipped unsafe DeviceData parent for " .. tostring(entry.sprite))
        return nil, false
    end

    local objects = square:getObjects()
    local before = {}
    if objects then
        for i = 0, objects:size() - 1 do
            before[objects:get(i)] = true
        end
    end

    local ok, object = pcall(function()
        return props:placeMoveableInternal(square, item, entry.sprite)
    end)
    if not ok then
        print("[EBFCopyPaste] vanilla moveable paste failed for " .. tostring(entry.sprite) .. ": " .. tostring(object))
        return nil, false
    end
    if object and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        EBFCopyPasteServer.markVanillaMoveableObjectInitialized(object)
        return object, true
    elseif object then
        EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
    end

    objects = square:getObjects()
    if objects then
        for i = 0, objects:size() - 1 do
            local candidate = objects:get(i)
            if not before[candidate]
                    and getObjectSpriteName(candidate) == entry.sprite
                    and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, candidate) then
                EBFCopyPasteServer.markVanillaMoveableObjectInitialized(candidate)
                return candidate, true
            end
        end
    end
    return nil, false
end

local function createIsoThumpable(square, entry)
    if not IsoThumpable then
        return nil
    end

    local sprite = getSprite(entry.sprite)
    if not sprite then
        return nil
    end

    local ok, object = pcall(function()
        return IsoThumpable.new(getCell(), square, sprite, entry.north == true, {})
    end)
    if not ok or not object then
        return nil
    end

    if entry.isDoor ~= nil then
        callMethod(object, "setIsDoor", entry.isDoor == true)
    end
    if entry.isDoorFrame ~= nil then
        callMethod(object, "setIsDoorFrame", entry.isDoorFrame == true)
    end
    if entry.isWindow ~= nil then
        callMethod(object, "setIsWindow", entry.isWindow == true)
    end
    return object
end

function EBFCopyPasteServer.initializeB42ObjectEntity(object)
    if not object or not GameEntityFactory or not GameEntityFactory.CreateIsoEntityFromCellLoading then
        return false
    end

    if callMethod(object, "isEntityValid") == true then
        return true
    end
    local componentMap = callMethod(object, "getECSComponentMap")
    local componentCount = componentMap and tonumber(callMethod(componentMap, "size")) or 0
    if componentCount and componentCount > 0 then
        return true
    end
    if object.getModData and object:getModData().EBFCopyPasteB42EntityInitialized == true then
        return true
    end

    local ok = pcall(function()
        GameEntityFactory.CreateIsoEntityFromCellLoading(object)
    end)
    if ok and object.getModData then
        object:getModData().EBFCopyPasteB42EntityInitialized = true
    end
    return ok == true
end

function EBFCopyPasteServer.makeWorldItemIdKey(square, originalItemId)
    originalItemId = tonumber(originalItemId)
    if not square or originalItemId == nil then
        return nil
    end
    return tostring(square:getX()) .. ":" .. tostring(square:getY()) .. ":" .. tostring(square:getZ()) .. ":" .. tostring(originalItemId)
end

function EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    if not job or not entry then
        return nil
    end
    return tostring(EBFCopyPaste.toInt(job.targetX, 0) + EBFCopyPaste.toInt(entry.dx, 0))
            .. ":" .. tostring(EBFCopyPaste.toInt(job.targetY, 0) + EBFCopyPaste.toInt(entry.dy, 0))
            .. ":" .. tostring(EBFCopyPaste.toInt(job.targetZ, 0) + EBFCopyPaste.toInt(entry.dz, 0))
            .. ":" .. tostring(entry.index or 0)
            .. ":" .. tostring(entry.sprite or "")
end

local function getPasteKeyModDataName()
    return EBFCopyPaste.PasteKeyModDataKey or "EBFCopyPastePasteKey"
end

function EBFCopyPasteServer.markObjectPasteKey(object, pasteKey)
    if not object or not pasteKey or not object.getModData then
        return false
    end

    object:getModData()[getPasteKeyModDataName()] = pasteKey
    return true
end

function EBFCopyPasteServer.getObjectPasteKey(object)
    if not object or not object.getModData then
        return nil
    end

    local modData = object:getModData()
    return modData and modData[getPasteKeyModDataName()] or nil
end

function EBFCopyPasteServer.isPersistentManagedLightSwitchModDataKey(key)
    return key == EBFCopyPaste.ManagedResidentialLightSwitchModDataKey
            or key == EBFCopyPaste.ManagedLightRoomKeyModDataKey
            or key == EBFCopyPaste.ManagedLightRoomIDStringModDataKey
            or key == EBFCopyPaste.ManagedLightRoomNameModDataKey
            or key == EBFCopyPaste.ManagedLightRoomDzModDataKey
end

function EBFCopyPasteServer.findObjectByPasteKey(square, pasteKey)
    if not square or not pasteKey then
        return nil
    end

    local objects = square.getObjects and square:getObjects() or nil
    if objects then
        for i = 0, objects:size() - 1 do
            local object = objects:get(i)
            if EBFCopyPasteServer.getObjectPasteKey(object) == pasteKey then
                return object
            end
        end
    end

    local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
    if worldObjects then
        for i = 0, worldObjects:size() - 1 do
            local object = worldObjects:get(i)
            if EBFCopyPasteServer.getObjectPasteKey(object) == pasteKey then
                return object
            end
        end
    end

    return nil
end

function EBFCopyPasteServer.getAlreadyPastedObject(job, square, entry)
    local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    if not job or not pasteKey then
        return nil, pasteKey
    end

    job.pastedEntryKeys = job.pastedEntryKeys or {}
    job.pastedObjectMap = job.pastedObjectMap or {}

    local mapped = job.pastedObjectMap[pasteKey]
    if mapped then
        return mapped, pasteKey
    end

    local existing = EBFCopyPasteServer.findObjectByPasteKey(square, pasteKey)
    if existing then
        job.pastedObjectMap[pasteKey] = existing
        job.pastedEntryKeys[pasteKey] = true
        return existing, pasteKey
    end

    if job.pastedEntryKeys[pasteKey] == true then
        return false, pasteKey
    end

    return nil, pasteKey
end

function EBFCopyPasteServer.notePastedObject(job, entry, object)
    local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    if not job or not pasteKey or not object then
        return nil
    end

    job.pastedEntryKeys = job.pastedEntryKeys or {}
    job.pastedObjectMap = job.pastedObjectMap or {}
    job.pastedEntryKeys[pasteKey] = true
    job.pastedObjectMap[pasteKey] = object
    EBFCopyPasteServer.markObjectPasteKey(object, pasteKey)
    EBFCopyPasteServer.clearTransientPlacementModData(object, entry, false)
    return pasteKey
end

function EBFCopyPasteServer.clearInternalObjectModData(object, transmit)
    if not object or not object.getModData then
        return false
    end

    local modData = object:getModData()
    if not modData then
        return false
    end

    local changed = false
    for key, _ in pairs(modData) do
        if EBFCopyPasteServer.isInternalModDataKey(key)
                and not EBFCopyPasteServer.isPersistentManagedLightSwitchModDataKey(key) then
            modData[key] = nil
            changed = true
        end
    end

    return changed
end

function EBFCopyPasteServer.clearPasteMarkersForJob(job)
    if not job then
        return 0
    end

    local seen = {}
    local cleared = 0
    local function clearOne(object)
        if object and not seen[object] then
            seen[object] = true
            if EBFCopyPasteServer.clearInternalObjectModData(object, false) then
                cleared = cleared + 1
            end
        end
    end

    for _, object in pairs(job.pastedObjectMap or {}) do
        clearOne(object)
    end
    for _, object in ipairs(job.finalSyncObjects or {}) do
        clearOne(object)
    end
    return cleared
end

EBFCopyPasteServer.FullWaterDispenserSprites = {
    location_business_office_generic_01_48 = true,
    location_business_office_generic_01_49 = true,
    location_business_office_generic_01_56 = true,
    location_business_office_generic_01_57 = true,
}

EBFCopyPasteServer.EmptyWaterDispenserSprites = {
    location_business_office_generic_01_58 = true,
    location_business_office_generic_01_59 = true,
    location_business_office_generic_01_60 = true,
    location_business_office_generic_01_61 = true,
}

EBFCopyPasteServer.EmptyToFullWaterDispenserSprite = {
    location_business_office_generic_01_58 = "location_business_office_generic_01_48",
    location_business_office_generic_01_59 = "location_business_office_generic_01_49",
    location_business_office_generic_01_60 = "location_business_office_generic_01_56",
    location_business_office_generic_01_61 = "location_business_office_generic_01_57",
}

function EBFCopyPasteServer.getWaterDispenserEntityPlacement(entry)
    if not EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return nil, nil
    end

    local spriteName = entry.sprite
    local waterState = entry.waterState or {}
    local hasFluid = waterState.hasFluid == true
            or tonumber(waterState.fluidAmount or 0) > 0
            or waterState.fluid ~= nil
    if hasFluid then
        return "WaterDispenser", EBFCopyPasteServer.EmptyToFullWaterDispenserSprite[spriteName] or spriteName
    end
    if EBFCopyPasteServer.EmptyWaterDispenserSprites[spriteName] then
        return "WaterDispenserNoBottle", spriteName
    end
    if EBFCopyPasteServer.FullWaterDispenserSprites[spriteName] then
        return "WaterDispenser", spriteName
    end
    return "WaterDispenser", spriteName
end

function EBFCopyPasteServer.createWaterDispenserEntity(square, entry)
    if not square or not square.addWorkstationEntity or not EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        return nil, false
    end

    local entityName, spriteName = EBFCopyPasteServer.getWaterDispenserEntityPlacement(entry)
    if not entityName or not spriteName then
        return nil, false
    end

    local ok, object = pcall(function()
        return square:addWorkstationEntity(entityName, spriteName)
    end)
    if ok and object then
        return object, true
    end
    return nil, false
end

function EBFCopyPasteServer.createManualObjectForEntry(square, entry, job)
    if not square or not entry then
        return nil
    end
    if entry.objectClass == "IsoDoor" then
        return createIsoDoor(square, entry.sprite, entry.north)
    end
    if entry.objectClass == "IsoWindow" then
        return createIsoWindow(square, entry.sprite, entry.north)
    end
    if entry.objectClass == "IsoCurtain" or entry.isoType == "IsoCurtain" then
        local curtain = EBFCopyPasteServer.createIsoCurtain(square, entry.sprite, entry.north)
        if curtain then
            return curtain
        end
    end
    if entry.objectClass == "IsoWindowFrame" or entry.isoType == "IsoWindowFrame" then
        local windowFrame = EBFCopyPasteServer.createIsoWindowFrame(square, entry.sprite, entry.north)
        if windowFrame then
            return windowFrame
        end
    end
    if EBFCopyPasteServer.entryLooksLikeStove(entry) then
        local stove = createIsoSpriteObject(square, entry.sprite, IsoStove)
        if stove then
            callMethod(stove, "setMovedThumpable", true)
            return stove
        end
    end
    if entry.objectClass == "IsoBarbecue" or entry.isoType == "IsoBarbecue" then
        local barbecue = createIsoSpriteObject(square, entry.sprite, IsoBarbecue)
        if barbecue then
            return barbecue
        end
    end
    if entry.objectClass == "IsoFireplace" or entry.isoType == "IsoFireplace" then
        local fireplace = createIsoSpriteObject(square, entry.sprite, IsoFireplace)
        if fireplace then
            return fireplace
        end
    end
    if entry.objectClass == "IsoJukebox" or entry.isoType == "IsoJukebox" then
        local jukebox = createIsoSpriteObject(square, entry.sprite, IsoJukebox)
        if jukebox then
            return jukebox
        end
    end
    if entry.objectClass == "IsoCompost" or entry.isoType == "IsoCompost" then
        local compost = createIsoSpriteObject(square, entry.sprite, IsoCompost)
        if compost then
            return compost
        end
    end
    if entry.objectClass == "IsoFeedingTrough" or entry.isoType == "IsoFeedingTrough" then
        local feedingTrough = EBFCopyPasteServer.createIsoFeedingTrough(square, entry.sprite)
        if feedingTrough then
            return feedingTrough
        end
    end
    if entry.objectClass == "IsoMannequin" or entry.isoType == "IsoMannequin" then
        local mannequin = createIsoSpriteObject(square, entry.sprite, IsoMannequin)
        if mannequin then
            callMethod(mannequin, "setSquare", square)
            return mannequin
        end
    end
    if entry.objectClass == "IsoBrokenGlass" or entry.isoType == "IsoBrokenGlass" then
        local brokenGlass = EBFCopyPasteServer.createIsoBrokenGlass(square)
        if brokenGlass then
            return brokenGlass
        end
    end
    if entry.objectClass == "IsoLightSwitch" or isLightSwitchSprite(entry.sprite) then
        local lightSwitch = createIsoLightSwitch(square, entry, job)
        if lightSwitch then
            return lightSwitch
        end
    end
    if entry.objectClass == "IsoCombinationWasherDryer" or entry.isoType == "IsoCombinationWasherDryer" then
        local washerDryer = createIsoSpriteObject(square, entry.sprite, IsoCombinationWasherDryer)
        if washerDryer then
            return washerDryer
        end
    end
    if entry.objectClass == "IsoClothingDryer" or entry.isoType == "IsoClothingDryer" then
        local dryer = createIsoSpriteObject(square, entry.sprite, IsoClothingDryer)
        if dryer then
            return dryer
        end
    end
    if entry.objectClass == "IsoClothingWasher" or entry.isoType == "IsoClothingWasher" then
        local washer = createIsoSpriteObject(square, entry.sprite, IsoClothingWasher)
        if washer then
            return washer
        end
    end
    if EBFCopyPasteServer.entryIsRadio(entry) or EBFCopyPasteServer.entryIsTelevision(entry) then
        return nil
    end
    if entry.objectClass == "IsoThumpable" then
        local thumpable = createIsoThumpable(square, entry)
        if thumpable then
            return thumpable
        end
    end

    return nil
end

local function createObjectForEntry(square, entry, job)
    if not square or not entry then
        return nil, false
    end

    if EBFCopyPasteServer.entryIsWaterDispenser(entry) then
        local dispenserObject, dispenserAdded = EBFCopyPasteServer.createWaterDispenserEntity(square, entry)
        if dispenserObject then
            return dispenserObject, dispenserAdded == true
        end
    end

    if EBFCopyPasteServer.entryIsTelevision(entry) then
        local tvObject, tvAdded = EBFCopyPasteServer.placeTelevisionWithVanillaMoveable(square, entry)
        if tvObject then
            return tvObject, tvAdded == true
        end
        print("[EBFCopyPaste] television paste skipped because vanilla television placement failed for " .. tostring(entry.sprite))
        return nil, false
    end

    if EBFCopyPasteServer.entryIsRadio(entry) then
        local waveObject, waveAdded = EBFCopyPasteServer.placeWaveSignalWithVanillaMoveable(square, entry)
        if waveObject then
            return waveObject, waveAdded == true
        end
        print("[EBFCopyPaste] wave-signal paste skipped because vanilla moveable placement failed for " .. tostring(entry.sprite))
        return nil, false
    end

    local requiresVanillaMoveable = EBFCopyPasteServer.entryIsMoveableLamp(entry)
    local requiresBrushCreateTile = EBFCopyPasteServer.entryUsesBrushCreateTile
            and EBFCopyPasteServer.entryUsesBrushCreateTile(entry)
    local requiresIsoLightSwitch = EBFCopyPasteServer.entryIsLighting(entry)
            and not requiresVanillaMoveable
            and not requiresBrushCreateTile
    local strategy = nil
    if requiresBrushCreateTile then
        strategy = "brushCreateTile"
    elseif requiresIsoLightSwitch then
        strategy = "manualClass"
    elseif requiresVanillaMoveable then
        strategy = "vanillaMoveable"
    elseif EBFCopyPasteServer.entryLooksLikeStove(entry) then
        strategy = "manualClass"
    else
        local savedStrategy = entry.pasteStrategy
        if savedStrategy == "unknown" then
            savedStrategy = nil
        end
        strategy = savedStrategy or EBFCopyPasteServer.selectPasteStrategy(entry)
    end

    if strategy == "genericIsoObject" and EBFCopyPasteServer.entryIsStructural(entry) == true then
        strategy = "structuralIsoObject"
    end
    if strategy == "structuralIsoObject" then
        local structuralObject = createStructuralIsoObject(square, entry)
        if structuralObject then
            if job then
                job.structuralIsoObjectsCreated = (tonumber(job.structuralIsoObjectsCreated) or 0) + 1
            end
            return structuralObject, false
        end
        if job then
            job.structuralIsoObjectsFailed = (tonumber(job.structuralIsoObjectsFailed) or 0) + 1
        end
        return nil, false
    end
    if strategy == "genericIsoObject" then
        print("[EBFCopyPaste] generic paste skipped in strict mode for sprite="
                .. tostring(entry.sprite)
                .. " class=" .. tostring(entry.objectClass)
                .. " isoType=" .. tostring(entry.isoType))
        return nil, false
    end
    if strategy == "unknown" or strategy == nil then
        print("[EBFCopyPaste] paste skipped: no vanilla creation path for sprite="
                .. tostring(entry.sprite)
                .. " class=" .. tostring(entry.objectClass)
                .. " isoType=" .. tostring(entry.isoType)
                .. " category=" .. tostring(entry.classification and entry.classification.category))
        return nil, false
    end

    if strategy == "brushCreateTile" then
        local brushObject, brushAdded = EBFCopyPasteServer.placeEntryWithBrushCreateTile(square, entry)
        if brushObject then
            return brushObject, brushAdded == true
        end
        -- createTile no materializa de forma fiable ciertos tejados, paredes y cutaways
        -- del mapa en B42.20. Para IsoObject estructurales usamos la ruta Java vanilla
        -- equivalente y dejamos que addObjectToSquare los registre como TileObject.
        if EBFCopyPaste.AllowStructuralIsoObjectFallback ~= false
                and entry.objectClass == "IsoObject"
                and EBFCopyPasteServer.entryIsStructural(entry) == true then
            local structuralObject = createStructuralIsoObject(square, entry)
            if structuralObject then
                if job then
                    job.structuralBrushFallbackCreated = (tonumber(job.structuralBrushFallbackCreated) or 0) + 1
                    job.structuralIsoObjectsCreated = (tonumber(job.structuralIsoObjectsCreated) or 0) + 1
                end
                print("[EBFCopyPaste] fallback estructural IsoObject usado para " .. tostring(entry.sprite))
                return structuralObject, false
            end
            if job then
                job.structuralBrushFallbackFailed = (tonumber(job.structuralBrushFallbackFailed) or 0) + 1
                job.structuralIsoObjectsFailed = (tonumber(job.structuralIsoObjectsFailed) or 0) + 1
            end
        end
        if requiresBrushCreateTile then
            print("[EBFCopyPaste] brush createTile paste skipped because vanilla createTile failed for " .. tostring(entry.sprite))
            return nil, false
        end
    elseif strategy == "vanillaMoveable" then
        local vanillaObject, vanillaAdded = EBFCopyPasteServer.placeEntryWithVanillaMoveable(square, entry)
        if vanillaObject then
            return vanillaObject, vanillaAdded == true
        end
        print("[EBFCopyPaste] vanilla moveable paste skipped because vanilla placement failed for " .. tostring(entry.sprite))
        return nil, false
    end

    if strategy == "manualClass" then
        local manualObject = EBFCopyPasteServer.createManualObjectForEntry(square, entry, job)
        if manualObject then
            return manualObject, false
        end
    end

    return nil, false
end

function EBFCopyPasteServer.squareContainsObjectForTransmit(square, object)
    if not square or not object then
        return false
    end

    if EBFCopyPasteServer.isWorldInventoryObject and EBFCopyPasteServer.isWorldInventoryObject(object) then
        local worldObjects = square.getWorldObjects and square:getWorldObjects() or nil
        if not worldObjects then
            return false
        end
        for i = 0, worldObjects:size() - 1 do
            if worldObjects:get(i) == object then
                return true
            end
        end
        return false
    end

    local objects = square.getObjects and square:getObjects() or nil
    if not objects then
        return false
    end

    local index = tonumber(callMethod(object, "getObjectIndex"))
    if index and index >= 0 and index < objects:size() then
        return objects:get(index) == object
    end

    for i = 0, objects:size() - 1 do
        if objects:get(i) == object then
            return true
        end
    end
    return false
end

function EBFCopyPasteServer.objectReadyForCompleteTransmit(object)
    local square = callMethod(object, "getSquare")
    if not square then
        return false
    end
    return EBFCopyPasteServer.squareContainsObjectForTransmit(square, object)
end

transmitCompleteObject = function(object)
    if isServer and isServer() and EBFCopyPasteServer.objectReadyForCompleteTransmit(object) then
        callMethod(object, "transmitCompleteItemToClients")
        return true
    end
    return false
end

function EBFCopyPasteServer.queueJobObjectForFinalSync(job, object)
    if not job or not object then
        return
    end
    if job.finalSyncSkipObjectSet and job.finalSyncSkipObjectSet[object] then
        return
    end
    job.finalSyncObjects = job.finalSyncObjects or {}
    job.finalSyncObjectSet = job.finalSyncObjectSet or {}
    if not job.finalSyncObjectSet[object] then
        job.finalSyncObjectSet[object] = true
        table.insert(job.finalSyncObjects, object)
    end
end

function EBFCopyPasteServer.entryShouldTransmitDuringPaste(entry)
    if not entry or entry.floor then
        return false
    end
    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return false
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        return false
    end

    local classification = entry.classification or {}
    local descriptor = entry.vanillaDescriptor or {}
    local strategy = entry.pasteStrategy
            or classification.pasteStrategy
            or descriptor.pasteStrategy
            or descriptor.requiredCreationPath

    return EBFCopyPasteServer.entryIsStructural(entry) == true
            or strategy == "brushCreateTile"
            or strategy == "manualClass"
end

function EBFCopyPasteServer.entryShouldUseTileObjectAdd(entry, object)
    if not entry or not object or entry.floor then
        return false
    end
    if entry.objectClass ~= "IsoObject" then
        return false
    end
    if EBFCopyPasteServer.entryHasFunctionalState(entry)
            or EBFCopyPasteServer.entryHasContainers(entry)
            or EBFCopyPasteServer.entryIsLighting(entry)
            or entry.objectClass == "IsoWorldInventoryObject"
            or entry.worldItem ~= nil then
        return false
    end
    return EBFCopyPasteServer.entryIsStructural(entry) == true
end

function EBFCopyPasteServer.markPasteObjectTransmitted(job, entry, object)
    if not job or not object then
        return
    end
    job.pasteImmediateTransmits = (tonumber(job.pasteImmediateTransmits) or 0) + 1
    job.finalSyncSkipObjectSet = job.finalSyncSkipObjectSet or {}
    if entry
            and not EBFCopyPasteServer.entryHasFunctionalState(entry)
            and not EBFCopyPasteServer.entryHasContainers(entry)
            and not EBFCopyPasteServer.entryIsLighting(entry) then
        job.finalSyncSkipObjectSet[object] = true
        local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
        if pasteKey then
            job.finalSyncSkipPasteKeys = job.finalSyncSkipPasteKeys or {}
            job.finalSyncSkipPasteKeys[pasteKey] = true
        end
    end
end

local function addObjectToSquare(square, object, index, transmitNow, entry)
    if not square or not object then
        return false
    end

    local objects = square:getObjects()
    local objectCount = objects and objects:size() or 0
    local targetIndex = math.floor(tonumber(index) or objectCount)
    if targetIndex < 0 or targetIndex > objectCount then
        targetIndex = objectCount
    end
    local ok = pcall(function()
        if EBFCopyPasteServer.entryShouldUseTileObjectAdd(entry, object) and square.AddTileObject then
            square:AddTileObject(object, targetIndex)
        else
            square:AddSpecialObject(object, targetIndex)
        end
    end)
    if not ok then
        return false
    end

    if transmitNow ~= false then
        transmitCompleteObject(object)
    end
    if triggerEvent then
        triggerEvent("OnObjectAdded", object)
    end
    return true
end

function EBFCopyPasteServer.getPastedObjectForEntry(job, square, entry)
    if not job or not square or not entry then
        return nil
    end

    local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    local object = pasteKey and job.pastedObjectMap and job.pastedObjectMap[pasteKey] or nil
    if object and callMethod(object, "getSquare") == square then
        return object
    end
    return EBFCopyPasteServer.findObjectForEntry(square, entry, job)
end

function EBFCopyPasteServer.transmitRemoveObjectOnClients(square, object)
    if not square or not object or not isServer or not isServer() then
        return false
    end
    if square.transmitRemoveItemFromSquareOnClients then
        local ok = pcall(function()
            square:transmitRemoveItemFromSquareOnClients(object)
        end)
        return ok == true
    end
    if square.transmitRemoveItemFromSquare then
        local ok = pcall(function()
            square:transmitRemoveItemFromSquare(object, true)
        end)
        return ok == true
    end
    return false
end

function EBFCopyPasteServer.findObjectListIndex(objects, object)
    if not objects or not object then
        return -1
    end
    for index = 0, objects:size() - 1 do
        if objects:get(index) == object then
            return index
        end
    end
    return -1
end

function EBFCopyPasteServer.removeObjectFromListForReorder(objects, object, fallbackIndex)
    if not objects or not object then
        return false
    end

    local removed = false
    pcall(function()
        removed = objects:remove(object) == true
    end)
    if EBFCopyPasteServer.findObjectListIndex(objects, object) < 0 then
        return true
    end

    local index = EBFCopyPasteServer.findObjectListIndex(objects, object)
    if index < 0 then
        index = tonumber(fallbackIndex) or -1
    end
    if index >= 0 and index < objects:size() then
        pcall(function()
            objects:remove(index)
        end)
    end
    return EBFCopyPasteServer.findObjectListIndex(objects, object) < 0 or removed == true
end

function EBFCopyPasteServer.reorderPastedSquareObjects(job)
    if not job or not job.clipboard or type(job.clipboard.objects) ~= "table" then
        return 0
    end

    local groups = {}
    for _, entry in ipairs(job.clipboard.objects or {}) do
        if entry
                and not entry.floor
                and entry.objectClass ~= "IsoWorldInventoryObject"
                and entry.worldItem == nil then
            local square = getOrCreateSquare(
                    EBFCopyPaste.toInt(job.targetX, 0) + EBFCopyPaste.toInt(entry.dx, 0),
                    EBFCopyPaste.toInt(job.targetY, 0) + EBFCopyPaste.toInt(entry.dy, 0),
                    EBFCopyPaste.toInt(job.targetZ, 0) + EBFCopyPaste.toInt(entry.dz, 0))
            local object = square and EBFCopyPasteServer.getPastedObjectForEntry(job, square, entry) or nil
            if square and object and callMethod(object, "getSquare") == square then
                local groupKey = tostring(square:getX()) .. ":" .. tostring(square:getY()) .. ":" .. tostring(square:getZ())
                groups[groupKey] = groups[groupKey] or { square = square, entries = {} }
                table.insert(groups[groupKey].entries, {
                    entry = entry,
                    object = object,
                    tileOrder = tonumber(entry.tileOrder) or 0,
                    index = tonumber(entry.index) or 0,
                    scanOrder = tonumber(entry.scanOrder) or 0,
                })
            end
        end
    end

    local changedSquares = 0
    local movedObjects = 0
    for _, group in pairs(groups) do
        local entries = group.entries or {}
        if #entries > 1 then
            table.sort(entries, function(a, b)
                if a.tileOrder ~= b.tileOrder then
                    return a.tileOrder < b.tileOrder
                end
                if a.index ~= b.index then
                    return a.index < b.index
                end
                return a.scanOrder < b.scanOrder
            end)

            local objects = group.square:getObjects()
            local current = {}
            local minIndex = objects and objects:size() or 0
            if objects then
                for _, item in ipairs(entries) do
                    for index = 0, objects:size() - 1 do
                        if objects:get(index) == item.object then
                            table.insert(current, { index = index, item = item })
                            if index < minIndex then
                                minIndex = index
                            end
                            break
                        end
                    end
                end
            end

            if #current == #entries then
                table.sort(current, function(a, b)
                    return a.index < b.index
                end)
                local alreadyOrdered = true
                for index, currentItem in ipairs(current) do
                    if currentItem.item.object ~= entries[index].object then
                        alreadyOrdered = false
                        break
                    end
                end

                if not alreadyOrdered then
                    table.sort(current, function(a, b)
                        return a.index > b.index
                    end)
                    for _, currentItem in ipairs(current) do
                        EBFCopyPasteServer.removeObjectFromListForReorder(
                                objects,
                                currentItem.item.object,
                                currentItem.index)
                    end

                    local insertAt = math.max(0, math.min(minIndex, objects:size()))
                    for offset, item in ipairs(entries) do
                        EBFCopyPasteServer.removeObjectFromListForReorder(objects, item.object, nil)
                        local inserted = pcall(function()
                            objects:add(insertAt + offset - 1, item.object)
                        end)
                        if not inserted then
                            pcall(function()
                                objects:add(item.object)
                            end)
                        end
                        EBFCopyPasteServer.queueJobObjectForFinalSync(job, item.object)
                        movedObjects = movedObjects + 1
                    end
                    refreshSquareSystems(group.square)
                    changedSquares = changedSquares + 1
                end
            end
        end
    end

    job.objectOrderRebuilt = true
    job.objectOrderRebuildChanged = changedSquares
    job.objectOrderRebuildMovedObjects = movedObjects
    if changedSquares > 0 then
        print("[EBFCopyPaste] Ordem vanilla dos objetos restaurada: squares=" .. tostring(changedSquares)
                .. " objetos=" .. tostring(movedObjects))
    end
    return changedSquares
end

function EBFCopyPasteServer.applyWorldInventoryObjectOffsets(worldObject, snapshot)
    if not worldObject or not snapshot then
        return false
    end

    local offX = tonumber(snapshot.offX) or 0.5
    local offY = tonumber(snapshot.offY) or 0.5
    local offZ = tonumber(snapshot.offZ) or 0
    local currentX = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "x")
    local currentY = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "y")
    local currentZ = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "z")
    local epsilon = 0.0001
    if currentX and currentY and currentZ
            and math.abs(currentX - offX) <= epsilon
            and math.abs(currentY - offY) <= epsilon
            and math.abs(currentZ - offZ) <= epsilon then
        return false
    end

    local changed = false
    if getMethod(worldObject, "setOffset") then
        local ok = EBFCopyPasteServer.tryCallMethod(worldObject, "setOffset", offX, offY, offZ)
        changed = ok == true
    end
    if not changed then
        if getMethod(worldObject, "setOffX") then
            changed = EBFCopyPasteServer.tryCallMethod(worldObject, "setOffX", offX) == true or changed
        end
        if getMethod(worldObject, "setOffY") then
            changed = EBFCopyPasteServer.tryCallMethod(worldObject, "setOffY", offY) == true or changed
        end
        if getMethod(worldObject, "setOffZ") then
            changed = EBFCopyPasteServer.tryCallMethod(worldObject, "setOffZ", offZ) == true or changed
        end
    end
    if changed then
        callMethod(worldObject, "update")
    end
    return changed
end

function EBFCopyPasteServer.pasteWorldInventoryObject(square, entry, job)
    local snapshot = entry and entry.worldItem or nil
    local itemSnapshot = snapshot and snapshot.item or nil
    local item = createItemFromPersistentSnapshot(itemSnapshot, 0)
    if not square then
        return nil
    end
    local existing = EBFCopyPasteServer.getAlreadyPastedObject(job, square, entry)
    if existing ~= nil then
        return existing
    end
    if not item then
        print("[EBFCopyPaste] world item paste failed: cannot create item " .. tostring(itemSnapshot and itemSnapshot.fullType))
        return nil
    end

    if EBFCopyPasteServer.removeUndergroundPlaceholders then
        EBFCopyPasteServer.removeUndergroundPlaceholders(square)
    end

    local offX = tonumber(snapshot.offX) or 0.5
    local offY = tonumber(snapshot.offY) or 0.5
    local offZ = tonumber(snapshot.offZ) or 0
    if snapshot.worldZRotation ~= nil then
        callMethod(item, "setWorldZRotation", snapshot.worldZRotation)
    end
    local ok, addedItem = pcall(function()
        return square:AddWorldInventoryItem(item, offX, offY, offZ, false)
    end)
    if not ok or not addedItem then
        ok, addedItem = pcall(function()
            return square:AddWorldInventoryItem(item, offX, offY, offZ)
        end)
    end
    if not ok or not addedItem then
        print("[EBFCopyPaste] world item paste failed: AddWorldInventoryItem rejected " .. tostring(itemSnapshot and itemSnapshot.fullType) .. " at " .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ()))
        return nil
    end

    local worldObject = callMethod(addedItem, "getWorldItem") or callMethod(item, "getWorldItem")
    if worldObject then
        if EBFCopyPasteServer.applyWorldInventoryObjectOffsets(worldObject, snapshot) and job then
            job.worldItemOffsetsRestored = (tonumber(job.worldItemOffsetsRestored) or 0) + 1
        end
        local originalItemId = snapshot and snapshot.itemId or nil
        local newItemId = tonumber(callMethod(item, "getID"))
        local key = EBFCopyPasteServer.makeWorldItemIdKey(square, originalItemId)
        if job and key and newItemId then
            job.worldItemIdMap = job.worldItemIdMap or {}
            job.worldItemIdMap[key] = newItemId
        end
        applyModData(worldObject, entry.modData)
        if snapshot.extendedPlacement == true then
            callMethod(worldObject, "setExtendedPlacement", true)
        end
        callMethod(worldObject, "setIgnoreRemoveSandbox", true)
        EBFCopyPasteServer.notePastedObject(job, entry, worldObject)
        EBFCopyPasteServer.queueJobObjectForFinalSync(job, worldObject)
        return worldObject
    end

    return addedItem
end

function EBFCopyPasteServer.restorePastedWorldInventoryOffsets(job, phase)
    if not job or not job.clipboard or type(job.clipboard.objects) ~= "table" then
        return 0
    end

    local restored = 0
    local missing = 0
    for _, entry in ipairs(job.clipboard.objects or {}) do
        if entry and (entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil) then
            local square = getOrCreateSquare(
                    EBFCopyPaste.toInt(job.targetX, 0) + EBFCopyPaste.toInt(entry.dx, 0),
                    EBFCopyPaste.toInt(job.targetY, 0) + EBFCopyPaste.toInt(entry.dy, 0),
                    EBFCopyPaste.toInt(job.targetZ, 0) + EBFCopyPaste.toInt(entry.dz, 0))
            local object = square and EBFCopyPasteServer.findWorldObjectForEntry(square, entry, job) or nil
            if object then
                if EBFCopyPasteServer.applyWorldInventoryObjectOffsets(object, entry.worldItem) then
                    restored = restored + 1
                    transmitCompleteObject(object)
                end
            else
                missing = missing + 1
            end
        end
    end

    job.worldItemOffsetsRestored = (tonumber(job.worldItemOffsetsRestored) or 0) + restored
    job.worldItemOffsetRestoreMissing = (tonumber(job.worldItemOffsetRestoreMissing) or 0) + missing
    if restored > 0 or missing > 0 then
        print("[EBFCopyPaste] WorldItem offsets restaurados: restored=" .. tostring(restored)
                .. " missing=" .. tostring(missing)
                .. " phase=" .. tostring(phase or ""))
    end
    return restored
end

pasteObject = function(square, entry, deferredContainerApplies, job)
    local existing = EBFCopyPasteServer.getAlreadyPastedObject(job, square, entry)
    if existing ~= nil then
        return existing
    end

    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return EBFCopyPasteServer.pasteWorldInventoryObject(square, entry, job)
    end

    if EBFCopyPasteServer.removeUndergroundPlaceholders then
        EBFCopyPasteServer.removeUndergroundPlaceholders(square)
    end

    local object, alreadyAdded = createObjectForEntry(square, entry, job)
    if not object then
        return nil
    end

    local isLightSwitchEntry = EBFCopyPasteServer.entryIsLighting(entry)
    local isTelevisionEntry = EBFCopyPasteServer.entryIsTelevision(entry)
    local isRadioEntry = EBFCopyPasteServer.entryIsRadio(entry)
    local isPlumbingEntry = EBFCopyPasteServer.entryIsPlumbingFixture(entry)
    local isWaterDispenserEntry = EBFCopyPasteServer.entryIsWaterDispenser(entry)
    local hasRelevantWaterState = EBFCopyPasteServer.entryHasRelevantWaterState(entry)
    local isResidentialLightSwitchEntry = EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object)
    local conservativeVanillaState = EBFCopyPasteServer.entryUsesConservativeVanillaState(entry)

    if isLightSwitchEntry and not isInstance(object, "IsoLightSwitch") then
        print("[EBFCopyPaste] light paste skipped because object was not IsoLightSwitch for " .. tostring(entry.sprite))
        if alreadyAdded and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
            EBFCopyPasteServer.transmitRemoveObjectOnClients(square, object)
            callMethod(object, "removeFromWorld")
            callMethod(object, "removeFromSquare")
        else
            EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
        end
        return nil
    end

    if alreadyAdded and not EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        local registeredObject = EBFCopyPasteServer.findObjectForEntry(square, entry, job)
        if registeredObject and EBFCopyPasteServer.objectIsRegisteredOnSquare(square, registeredObject) then
            object = registeredObject
        else
            EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
            return nil
        end
    end

    if not conservativeVanillaState then
        applyModData(object, entry.modData)
    end
    if not conservativeVanillaState and job and entry.modData and entry.modData.RadioItemID and object.getModData then
        local key = EBFCopyPasteServer.makeWorldItemIdKey(square, entry.modData.RadioItemID)
        local newItemId = key and job.worldItemIdMap and job.worldItemIdMap[key] or nil
        if newItemId then
            object:getModData().RadioItemID = newItemId
        end
    end
    applyAttachedSprites(object, entry.attached)
    if not objectHasContainers(object) then
        callMethod(object, "createContainersFromSpriteProperties")
    end
    if not conservativeVanillaState then
        applyObjectState(object, entry.state)
    end
    if isTelevisionEntry then
        -- Vanilla moveable placement owns television state.
    elseif isRadioEntry then
        -- Vanilla moveable placement owns radio state.
    elseif not conservativeVanillaState then
        EBFCopyPasteServer.applyDeviceDataSnapshot(object, entry.deviceData)
    end
    if isTelevisionEntry and EBFCopyPasteServer.finalizePastedTelevision then
        local tvSafe = EBFCopyPasteServer.finalizePastedTelevision(square, object, entry)
        if job then
            if tvSafe then
                job.televisionsFinalized = (tonumber(job.televisionsFinalized) or 0) + 1
            else
                job.televisionsUnsafeDeviceData = (tonumber(job.televisionsUnsafeDeviceData) or 0) + 1
            end
        end
    elseif isRadioEntry and EBFCopyPasteServer.finalizePastedRadio then
        EBFCopyPasteServer.finalizePastedRadio(square, object, entry)
    end
    if not conservativeVanillaState and not EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
        EBFCopyPasteServer.applyCustomSettingsItem(object, entry.lightSettings)
    end
    if not conservativeVanillaState and not EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) and not (alreadyAdded and isLightSwitchEntry) then
        EBFCopyPasteServer.applyLightSourceState(square, object, entry.lightSource)
    end
    if not alreadyAdded then
        EBFCopyPasteServer.initializeB42ObjectEntity(object)
    end
    if not alreadyAdded then
        addObjectToSquare(
                square,
                object,
                tonumber(entry.index) or square:getObjects():size(),
                false,
                entry)
    end
    if not EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        EBFCopyPasteServer.discardUnregisteredVanillaObject(object)
        return nil
    end
    if not conservativeVanillaState and isWaterDispenserEntry then
        EBFCopyPasteServer.applyWaterDispenserFluidState(object, entry, true)
    elseif not conservativeVanillaState and hasRelevantWaterState then
        EBFCopyPasteServer.applyObjectWaterState(square, object, entry.waterState, true)
    end
    if not conservativeVanillaState and isPlumbingEntry then
        EBFCopyPasteServer.finalizePastedPlumbingFixture(square, object, entry, true)
    end
    if isLightSwitchEntry and not conservativeVanillaState then
        prepareLightSwitchState(square, object, entry, job)
        if not isResidentialLightSwitchEntry then
            registerLightSwitchSources(square, object, entry, job)
        end
    end
    applyObjectContainers(object, entry.containers, false, deferredContainerApplies)
    local objectIndex = object.getObjectIndex and tonumber(object:getObjectIndex()) or -1
    if entry.overlay and object.setOverlaySprite and objectIndex >= 0 then
        pcall(function()
            object:setOverlaySprite(entry.overlay)
        end)
    end
    callMethod(object, "afterRotated")
    if isLightSwitchEntry and not conservativeVanillaState and not isResidentialLightSwitchEntry then
        if EBFCopyPasteServer.entryIsMoveableLamp(entry, object) and IsoGenerator and IsoGenerator.updateGenerator then
            pcall(IsoGenerator.updateGenerator, square)
        end
        callMethod(object, "updateLightSource")
        callMethod(object, "checkLightSourceActive")
    end
    if EBFCopyPasteServer.entryShouldTransmitDuringPaste(entry)
            and transmitCompleteObject(object) then
        EBFCopyPasteServer.markPasteObjectTransmitted(job, entry, object)
    end
    EBFCopyPasteServer.notePastedObject(job, entry, object)
    if alreadyAdded and job then
        job.finalSyncAlreadyAddedQueued = (tonumber(job.finalSyncAlreadyAddedQueued) or 0) + 1
        EBFCopyPasteServer.queueJobObjectForFinalSync(job, object)
    else
        EBFCopyPasteServer.queueJobObjectForFinalSync(job, object)
    end
    return object
end

function EBFCopyPasteServer.findLightSwitchForEntry(square, entry)
    if not square or not square.getObjects or not entry then
        return nil
    end

    local objects = square:getObjects()
    if not objects then
        return nil
    end

    for i = objects:size() - 1, 0, -1 do
        local object = objects:get(i)
        if isInstance(object, "IsoLightSwitch") and getObjectSpriteName(object) == entry.sprite then
            return object
        end
    end
    return nil
end

function EBFCopyPasteServer.findObjectForEntry(square, entry, job)
    if not square or not square.getObjects or not entry then
        return nil
    end

    local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    local mappedObject = pasteKey and job and job.pastedObjectMap and job.pastedObjectMap[pasteKey] or nil
    if mappedObject and getObjectSpriteName(mappedObject) == entry.sprite then
        local mappedSquare = callMethod(mappedObject, "getSquare")
        if mappedSquare == square then
            return mappedObject
        end
    end

    local objects = square:getObjects()
    if not objects then
        return nil
    end

    local stoveEntry = EBFCopyPasteServer.entryLooksLikeStove(entry)
    for i = objects:size() - 1, 0, -1 do
        local object = objects:get(i)
        if getObjectSpriteName(object) == entry.sprite then
            if entry.objectClass == "IsoTelevision" and not isInstance(object, "IsoTelevision") then
                -- keep searching
            elseif entry.objectClass == "IsoRadio" and not isInstance(object, "IsoRadio") then
                -- keep searching
            elseif entry.objectClass == "IsoCurtain" and not isInstance(object, "IsoCurtain") then
                -- keep searching
            elseif entry.objectClass == "IsoWindowFrame" and not isInstance(object, "IsoWindowFrame") then
                -- keep searching
            elseif stoveEntry and not isInstance(object, "IsoStove") then
                -- keep searching
            else
                return object
            end
        end
    end
    return nil
end

function EBFCopyPasteServer.copyObjectContainerHeaders(object)
    local result = {}
    local count = tonumber(callMethod(object, "getContainerCount")) or 0
    if count > 0 then
        for i = 0, count - 1 do
            local snapshot = createContainerSnapshot(callMethod(object, "getContainerByIndex", i), i, nil)
            if snapshot then
                local items = callMethod(callMethod(object, "getContainerByIndex", i), "getItems")
                snapshot.itemCount = items and items:size() or 0
                table.insert(result, snapshot)
            end
        end
    end

    if #result == 0 then
        local container = callMethod(object, "getContainer")
        local snapshot = createContainerSnapshot(container, 0, nil)
        if snapshot then
            local items = callMethod(container, "getItems")
            snapshot.itemCount = items and items:size() or 0
            table.insert(result, snapshot)
        end
    end

    if #result == 0 then
        return nil
    end
    return result
end

function EBFCopyPasteServer.buildVerificationEntryForObject(square, object, sourceEntry)
    local spriteName = getSpriteName(object)
    if not spriteName then
        return nil
    end

    local objectClass = getObjectClass(object)
    local state = captureObjectState(object)
    local north = callMethod(object, "getNorth")
    if objectClass == "IsoWindow" then
        spriteName = EBFCopyPasteServer.getCanonicalWindowSprite(spriteName, state, north)
    elseif objectClass == "IsoDoor" then
        spriteName = EBFCopyPasteServer.getCanonicalDoorSprite(spriteName, state, north)
    end

    local overlaySprite = object.getOverlaySprite and object:getOverlaySprite() or nil
    local overlayName = overlaySprite and overlaySprite:getName() or nil
    local name = object.getName and object:getName() or nil
    local entry = {
        dx = sourceEntry and sourceEntry.dx or 0,
        dy = sourceEntry and sourceEntry.dy or 0,
        dz = sourceEntry and sourceEntry.dz or 0,
        index = object.getObjectIndex and object:getObjectIndex() or 0,
        objectClass = objectClass,
        objectName = callMethod(object, "getObjectName"),
        isoType = EBFCopyPasteServer.getSpriteIsoType(spriteName),
        factory = EBFCopyPasteServer.captureSpriteFactoryInfo(spriteName),
        spriteProperties = EBFCopyPasteServer.captureSpritePropertiesSafe(spriteName),
        sprite = spriteName,
        name = type(name) == "string" and name or nil,
        floor = square and square:getFloor() == object or false,
        north = north,
        isDoor = callMethod(object, "isDoor"),
        isDoorFrame = callMethod(object, "isDoorFrame"),
        isWindow = callMethod(object, "isWindow"),
        overlay = overlayName,
        attached = copyAttachedSprites(object),
        modData = copyModData(object),
        state = state,
        waterState = EBFCopyPasteServer.captureObjectWaterState(object, spriteName),
        lightSettings = copyLightSettingsItem(object, spriteName),
        lightState = captureLightState(object),
        lightSource = EBFCopyPasteServer.captureLightSourceState(object),
        controlledLightSources = EBFCopyPasteServer.captureControlledLightSources(
                object,
                square,
                sourceEntry and sourceEntry.dx or 0,
                sourceEntry and sourceEntry.dy or 0,
                sourceEntry and sourceEntry.dz or 0),
        deviceData = EBFCopyPasteServer.captureDeviceData(object),
        containers = EBFCopyPasteServer.copyObjectContainerHeaders(object),
    }
    entry.objectLayer = EBFCopyPasteServer.getEntryObjectLayer(entry)
    entry.needsSupportBeforePaste = EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry)
    entry.pasteStrategy = EBFCopyPasteServer.selectPasteStrategy(entry)
    return EBFCopyPasteServer.decorateScannerEntry(entry, object)
end

function EBFCopyPasteServer.buildVerificationEntryForWorldObject(square, worldObject, sourceEntry)
    local item = EBFCopyPasteServer.getWorldInventoryObjectItem(worldObject)
    local fullType = getItemFullType(item)
    if not fullType then
        return nil
    end

    local entry = {
        dx = sourceEntry and sourceEntry.dx or 0,
        dy = sourceEntry and sourceEntry.dy or 0,
        dz = sourceEntry and sourceEntry.dz or 0,
        index = worldObject.getObjectIndex and worldObject:getObjectIndex() or 0,
        objectClass = "IsoWorldInventoryObject",
        objectName = callMethod(worldObject, "getObjectName"),
        sprite = getObjectSpriteName(worldObject),
        spriteProperties = EBFCopyPasteServer.captureSpritePropertiesSafe(getObjectSpriteName(worldObject)),
        floor = false,
        modData = copyModData(worldObject),
        worldItem = {
            item = {
                fullType = fullType,
                name = callMethod(item, "getName"),
                type = callMethod(item, "getType"),
                module = callMethod(item, "getModule"),
            },
            itemId = tonumber(callMethod(item, "getID")),
            offX = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "x") or 0.5,
            offY = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "y") or 0.5,
            offZ = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "z") or 0,
            worldZRotation = tonumber(callMethod(worldObject, "getWorldZRotation")),
            extendedPlacement = callMethod(worldObject, "isExtendedPlacement") == true,
        },
    }
    entry.objectLayer = EBFCopyPasteServer.getEntryObjectLayer(entry)
    entry.needsSupportBeforePaste = EBFCopyPasteServer.entryNeedsSupportBeforePaste(entry)
    entry.pasteStrategy = EBFCopyPasteServer.selectPasteStrategy(entry)
    return EBFCopyPasteServer.decorateScannerEntry(entry, worldObject)
end

function EBFCopyPasteServer.findWorldObjectForEntry(square, entry, job)
    local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    local mappedObject = pasteKey and job and job.pastedObjectMap and job.pastedObjectMap[pasteKey] or nil
    if mappedObject and callMethod(mappedObject, "getSquare") == square then
        return mappedObject
    end

    local worldObjects = square and square.getWorldObjects and square:getWorldObjects() or nil
    if not worldObjects then
        return nil
    end

    local expectedFullType = EBFCopyPasteServer.getEntryWorldItemFullType(entry)
    local expectedOffX = entry and entry.worldItem and tonumber(entry.worldItem.offX) or nil
    local expectedOffY = entry and entry.worldItem and tonumber(entry.worldItem.offY) or nil
    local expectedOffZ = entry and entry.worldItem and tonumber(entry.worldItem.offZ) or nil
    local bestObject = nil
    local bestScore = nil
    for i = 0, worldObjects:size() - 1 do
        local worldObject = worldObjects:get(i)
        local item = EBFCopyPasteServer.getWorldInventoryObjectItem(worldObject)
        if not expectedFullType or getItemFullType(item) == expectedFullType then
            if expectedOffX == nil or expectedOffY == nil or expectedOffZ == nil then
                return worldObject
            end

            local offX = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "x")
            local offY = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "y")
            local offZ = EBFCopyPasteServer.getWorldInventoryObjectOffset(worldObject, "z")
            local score = nil
            if offX ~= nil and offY ~= nil and offZ ~= nil then
                score = math.abs(offX - expectedOffX)
                        + math.abs(offY - expectedOffY)
                        + math.abs(offZ - expectedOffZ)
            end
            if bestObject == nil or (score ~= nil and (bestScore == nil or score < bestScore)) then
                bestObject = worldObject
                bestScore = score
            end
        end
    end
    return bestObject
end

function EBFCopyPasteServer.getVerificationTargetObject(job, entry)
    if not job or not entry then
        return nil, nil, false
    end

    local pasteKey = EBFCopyPasteServer.makeEntryPasteKey(job, entry)
    local mappedObject = pasteKey and job.pastedObjectMap and job.pastedObjectMap[pasteKey] or nil
    local square = mappedObject and callMethod(mappedObject, "getSquare") or nil
    if mappedObject and square then
        return square, mappedObject, false
    end

    local cell = getCell()
    if not cell then
        return nil, nil, true
    end

    local ok, targetSquare = pcall(function()
        return cell:getGridSquare(
                EBFCopyPaste.toInt(job.targetX, 0) + EBFCopyPaste.toInt(entry.dx, 0),
                EBFCopyPaste.toInt(job.targetY, 0) + EBFCopyPaste.toInt(entry.dy, 0),
                EBFCopyPaste.toInt(job.targetZ, 0) + EBFCopyPaste.toInt(entry.dz, 0))
    end)
    if ok then
        square = targetSquare
    end
    if not square then
        return nil, nil, true
    end

    if entry.objectClass == "IsoWorldInventoryObject" or entry.worldItem ~= nil then
        return square, EBFCopyPasteServer.findWorldObjectForEntry(square, entry, job), false
    end
    return square, EBFCopyPasteServer.findObjectForEntry(square, entry, job), false
end

function EBFCopyPasteServer.compareEntryFingerprints(sourceEntry, targetEntry)
    local source = sourceEntry and sourceEntry.fingerprint or EBFCopyPasteServer.buildEntryFingerprint(sourceEntry, sourceEntry and sourceEntry.capabilities)
    local target = targetEntry and targetEntry.fingerprint or nil
    local differences = {}
    local fields = {
        "objectClass",
        "objectName",
        "sprite",
        "isoType",
        "floor",
        "north",
        "index",
        "objectLayer",
        "needsSupportBeforePaste",
        "pasteStrategy",
        "category",
        "family",
        "subtype",
        "containerCount",
        "itemCount",
        "hasDeviceData",
        "hasWaterState",
        "hasFluid",
        "hasLightState",
        "hasLightSource",
        "controlledLightSourceCount",
        "hasModData",
        "modDataKeyCount",
        "hasOverlay",
        "attachedSpriteCount",
        "worldItemFullType",
        "worldItemOffX",
        "worldItemOffY",
        "worldItemOffZ",
        "lightActivated",
        "stateMethodCount",
        "spritePropertyCount",
    }
    if EBFCopyPasteServer.FidelityAudit
            and EBFCopyPasteServer.FidelityAudit.getCompareFields then
        local moduleFields = EBFCopyPasteServer.FidelityAudit.getCompareFields()
        if type(moduleFields) == "table" and #moduleFields > 0 then
            fields = moduleFields
        end
    end

    for _, field in ipairs(fields) do
        local sourceValue = source and source[field] or nil
        local targetValue = target and target[field] or nil
        if sourceValue ~= targetValue then
            local isWaterDispenser = EBFCopyPasteServer.entryIsWaterDispenser
                    and EBFCopyPasteServer.entryIsWaterDispenser(sourceEntry)
            local vanillaWaterDispenserEntity =
                    isWaterDispenser
                    and ((field == "objectClass" and sourceValue == "IsoObject" and targetValue == "IsoThumpable")
                        or (field == "objectName" and sourceValue == "IsoObject" and targetValue == "Thumpable")
                        or field == "stateMethodCount")
            if not vanillaWaterDispenserEntity then
                table.insert(differences, {
                    field = field,
                    source = sourceValue,
                    target = targetValue,
                })
            end
        end
    end
    return differences
end

function EBFCopyPasteServer.ensureWaveSignalDeviceSafe(square, object)
    if not square or not object or not EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        return false
    end

    local deviceData = callMethod(object, "getDeviceData")
    if not deviceData then
        return false
    end

    EBFCopyPasteServer.tryCallMethod(deviceData, "setParent", object)
    if getMethod(deviceData, "setTurnedOnRaw") then
        callMethod(deviceData, "setTurnedOnRaw", false)
    elseif EBFCopyPasteServer.deviceTargetHasSquare(object) then
        EBFCopyPasteServer.tryCallMethod(deviceData, "setIsTurnedOn", false)
    end
    return true
end

function EBFCopyPasteServer.finalizePastedTelevision(square, object, entry)
    if not square or not object or not EBFCopyPasteServer.entryIsTelevision(entry) then
        return false
    end
    if not EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        return false
    end
    if not isInstance(object, "IsoTelevision") then
        print("[EBFCopyPaste] TV finalizada rechazada: el objeto final no es IsoTelevision; sprite="
                .. tostring(entry and entry.sprite)
                .. " class=" .. tostring(getObjectClass(object)))
        return false
    end

    callMethod(object, "setMovedThumpable", true)
    local deviceSafe = EBFCopyPasteServer.ensureWaveSignalDeviceSafe(square, object)
    local deviceData = callMethod(object, "getDeviceData")
    local parent = deviceData and callMethod(deviceData, "getParent") or nil
    local parentSquare = parent and callMethod(parent, "getSquare") or nil
    if entry then
        entry.televisionDeviceSafe = deviceSafe == true
    end
    print("[EBFCopyPaste] TV finalizada vanilla: sprite=" .. tostring(entry and entry.sprite)
            .. " class=" .. tostring(getObjectClass(object))
            .. " customItem=" .. tostring(entry and entry.spriteProperties and (entry.spriteProperties.CustomItem or entry.spriteProperties.customItem) or "?")
            .. " deviceData=" .. tostring(deviceData ~= nil)
            .. " deviceSafe=" .. tostring(deviceSafe)
            .. " parentHasSquare=" .. tostring(parentSquare ~= nil)
            .. " pos=" .. tostring(square:getX()) .. "," .. tostring(square:getY()) .. "," .. tostring(square:getZ()))
    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end
    return deviceSafe == true
end

function EBFCopyPasteServer.finalizePastedRadio(square, object, entry)
    if not square or not object or not EBFCopyPasteServer.entryIsRadio(entry) then
        return false
    end
    if not EBFCopyPasteServer.objectIsRegisteredOnSquare(square, object) then
        return false
    end

    EBFCopyPasteServer.ensureWaveSignalDeviceSafe(square, object)
    if IsoGenerator and IsoGenerator.updateGenerator then
        pcall(IsoGenerator.updateGenerator, square)
    end
    return true
end

function EBFCopyPasteServer.finalizePastedFunctionalEntry(job, entry)
    if not job or not entry or entry.floor or entry.objectClass == "IsoWorldInventoryObject" then
        return 0
    end
    if EBFCopyPasteServer.entryIsLighting(entry) then
        return 0
    end
    if EBFCopyPasteServer.entryUsesConservativeVanillaState(entry) then
        return 0
    end
    local needsFinalize = entry.deviceData
            or entry.objectClass == "IsoCurtain"
            or (entry.modData and entry.modData.RadioItemID)
    if not needsFinalize then
        return 0
    end

    local square = getOrCreateSquare(job.targetX + entry.dx, job.targetY + entry.dy, job.targetZ + entry.dz)
    local object = EBFCopyPasteServer.findObjectForEntry(square, entry, job)
    if not square or not object then
        return 0
    end

    local changed = 0
    if entry.modData and entry.modData.RadioItemID and object.getModData then
        local key = EBFCopyPasteServer.makeWorldItemIdKey(square, entry.modData.RadioItemID)
        local newItemId = key and job.worldItemIdMap and job.worldItemIdMap[key] or nil
        if newItemId then
            object:getModData().RadioItemID = newItemId
            changed = 1
        end
    end

    if entry.objectClass == "IsoCurtain" then
        changed = 1
    end

    EBFCopyPasteServer.initializeB42ObjectEntity(object)
    callMethod(object, "afterRotated")
    callMethod(object, "updateLightSource")
    callMethod(object, "checkLightSourceActive")

    if changed > 0 then
        EBFCopyPasteServer.queueJobObjectForFinalSync(job, object)
        refreshSquareSystems(square)
    end
    return changed
end

finalizePastedLightSwitchEntry = function(job, entry)
    if not job or not entry then
        return 0
    end
    if entry.floor or (entry.objectClass ~= "IsoLightSwitch" and not isLightSwitchSprite(entry.sprite)) then
        return 0
    end

    local square = getOrCreateSquare(job.targetX + entry.dx, job.targetY + entry.dy, job.targetZ + entry.dz)
    if not square then
        return 0
    end

    local object = EBFCopyPasteServer.findObjectForEntry(square, entry, job)
            or EBFCopyPasteServer.findLightSwitchForEntry(square, entry)
    if not object then
        return 0
    end

    if EBFCopyPasteServer.entryIsResidentialLightSwitch(entry, object) then
        prepareResidentialLightSwitch(square, object, entry, job)
    else
        local canModifyOwnLight = EBFCopyPasteServer.entryIsMoveableLamp(entry, object)
                or EBFCopyPasteServer.lightSwitchEntryHasOwnLight(entry, object)
        EBFCopyPasteServer.prepareLightSwitchForVanillaPower(
                square,
                object,
                entry,
                canModifyOwnLight,
                false,
                job)
        registerLightSwitchSources(square, object, entry, job)
        EBFCopyPasteServer.applyLightSwitchInitialActiveNoSync(object, getLightStateActive(entry) == true)
    end

    EBFCopyPasteServer.queueJobObjectForFinalSync(job, object)
    refreshSquareSystems(square)
    return 1
end

finalizePastedLightSwitches = function(job)
    if not job or not job.clipboard or not job.clipboard.objects then
        return 0
    end

    local finalized = 0
    for _, entry in ipairs(job.clipboard.objects) do
        finalized = finalized + (finalizePastedLightSwitchEntry(job, entry) or 0)
    end
    return finalized
end

copyStringList = function(value)
    local copied = {}
    if type(value) ~= "table" then
        return copied
    end

    for _, item in ipairs(value) do
        if item ~= nil then
            table.insert(copied, tostring(item))
        end
    end
    return copied
end

local function makeSafehouseMetadata(args, area, levels, title)
    if not args or args.source ~= "safehouse" then
        return nil
    end

    return {
        title = sanitizeSaveName(args.safehouseTitle or title or "Safehouse"),
        owner = tostring(args.safehouseOwner or ""),
        members = copyStringList(args.safehouseMembers),
        respawnMembers = copyStringList(args.safehouseRespawnMembers),
        location = tostring(args.safehouseLocation or ""),
        lastVisited = tonumber(args.safehouseLastVisited) or 0,
        datetimeCreated = tonumber(args.safehouseDatetimeCreated) or 0,
        hitPoints = tonumber(args.safehouseHitPoints) or 0,
        onlineID = tonumber(args.safehouseOnlineID) or -1,
        x = EBFCopyPaste.toInt(args.safehouseX, area.x),
        y = EBFCopyPaste.toInt(args.safehouseY, area.y),
        z = EBFCopyPaste.toInt(args.safehouseZ, area.z),
        w = math.max(1, EBFCopyPaste.toInt(args.safehouseW, area.w)),
        h = math.max(1, EBFCopyPaste.toInt(args.safehouseH, area.h)),
        levels = levels,
    }
end

function EBFCopyPasteServer.copyArea(playerObj, args)
    local saveName = args and args.saveName and sanitizeSaveName(args.saveName) or nil
    local feedbackAction = saveName and "save" or "copy"
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local area = EBFCopyPaste.normalizeAreaArgs(args)
    local areaSize = EBFCopyPaste.areaSize(area)
    if areaSize < 1 or areaSize > EBFCopyPaste.MaxArea then
        sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "La zona no es válida o supera el límite permitido." })
        return
    end
    local dimensionsOk, maxW, maxH = EBFCopyPasteServer.areaDimensionsAreAllowed(area)
    if args and args.source ~= "safehouse" and not dimensionsOk then
        sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "La zona manual supera el límite de " .. tostring(maxW) .. " x " .. tostring(maxH) .. " tiles." })
        return
    end
    local zOk, minZ, maxZ = EBFCopyPasteServer.areaBaseZIsAllowed(area)
    if not zOk then
        sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "Z fora do limite permitido (" .. tostring(minZ) .. " ate " .. tostring(maxZ) .. ")." })
        return
    end

    local levels = EBFCopyPaste.clampZLevels(args and args.levels)
    local autoZ = args == nil or args.autoZ ~= false
    if not autoZ then
        area.zOffsets = EBFCopyPasteServer.clampCopyZOffsetsToAllowedRange(area, levels)
        levels = #area.zOffsets
        if levels < 1 then
            sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "No hay ninguna planta Z dentro del límite permitido." })
            return
        end
    end
    local title = saveName or (args and args.title) or "Zona Copy"
    local safehouse = makeSafehouseMetadata(args, area, levels, title)
    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "La copia todavía está en curso." })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = feedbackAction, ok = false, message = "El pegado todavía está en curso." })
        return
    end

    local clipboard = newClipboard(area, levels, title)
    if autoZ then
        clipboard.zOffsets = {}
        clipboard.levels = 0
    end
    if safehouse then
        clipboard.source = "safehouse"
        clipboard.safehouse = safehouse
    end
    local blocks = buildCopyBlockList(area)
    local job = {
        playerObj = playerObj,
        area = area,
        clipboard = clipboard,
        tileIndex = 1,
        totalTiles = areaSize * levels,
        blocks = blocks,
        blockIndex = 1,
        processedTiles = 0,
        lastFeedback = 0,
        saveName = saveName,
        sourceCells = nil,
        sourceReady = true,
        sourceWaitTicks = 0,
        autoZ = autoZ,
        zDetected = not autoZ,
        movementMode = "none",
    }
    EBFCopyPasteServer.copyJobs[key] = job
    EBFCopyPasteServer.logStage(job, "copy:start", "COPY iniciado: area=" .. tostring(area.x) .. "," .. tostring(area.y) .. "," .. tostring(area.z)
            .. " tamanho=" .. tostring(area.w) .. "x" .. tostring(area.h)
            .. " autoZ=" .. tostring(autoZ == true)
            .. " modo=simples"
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    sendCopyProgress(job, true)
end

function EBFCopyPasteServer.pasteArea(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "La copia todavía está en curso." })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "Ya hay un pegado en curso." })
        return
    end

    local clipboard = EBFCopyPasteServer.clipboards[key]
    if not clipboard then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "No hay ninguna zona copiada." })
        return
    end
    if not EBFCopyPasteServer.isCurrentClipboardSchema(clipboard) then
        sendFeedback(playerObj, { action = "paste", ok = false, message = EBFCopyPasteServer.currentSchemaRejectMessage() })
        return
    end
    ensureClipboardZOffsets(clipboard)
    if not clipboard.objects or #clipboard.objects <= 0 or (tonumber(clipboard.count) or 0) <= 0 then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "La zona copiada está vacía. Pega una copia válida antes de limpiar el destino." })
        return
    end

    local targetX = EBFCopyPaste.toInt(args and args.x, nil)
    local targetY = EBFCopyPaste.toInt(args and args.y, nil)
    local targetZ = EBFCopyPaste.toInt(args and args.z, nil)
    if targetX == nil or targetY == nil or targetZ == nil then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "El destino no es válido." })
        return
    end
    local minOffset, maxOffset = getClipboardZRange(clipboard)
    local minZ, maxZ = EBFCopyPasteServer.getAllowedAbsoluteZRange()
    if targetZ + minOffset < minZ or targetZ + maxOffset > maxZ then
        sendFeedback(playerObj, { action = "paste", ok = false, message = "Destino fora do limite Z permitido (" .. tostring(minZ) .. " ate " .. tostring(maxZ) .. ")." })
        return
    end

    local job = {
        playerObj = playerObj,
        clipboard = clipboard,
        targetX = targetX,
        targetY = targetY,
        targetZ = targetZ,
        phase = "clientAreaReconcile",
        tileIndex = 1,
        totalTiles = clipboard.w * clipboard.h * clipboard.levels,
        objectIndex = 1,
        pasted = 0,
        worldItemIdMap = {},
        lastFeedback = 0,
        sourceCells = nil,
        sourceReady = true,
        sourceWaitTicks = 0,
        movementMode = "none",
    }
    EBFCopyPasteServer.pasteJobs[key] = job
    EBFCopyPasteServer.logStage(job, "paste:start", "PASTE iniciado: destino=" .. tostring(targetX) .. "," .. tostring(targetY) .. "," .. tostring(targetZ)
            .. " tamanho=" .. tostring(clipboard.w) .. "x" .. tostring(clipboard.h)
            .. " levels=" .. tostring(clipboard.levels)
            .. " objetos=" .. tostring(#(clipboard.objects or {}))
            .. " player=" .. EBFCopyPasteServer.getStageJobPlayerName(job)
            .. " titulo=\"" .. EBFCopyPasteServer.getStageJobTitle(job) .. "\"")
    sendPasteProgress(job, true)
end

function EBFCopyPasteServer.resetPausedJobMovement(job)
    if not job then
        return
    end

    job.sourceReady = false
    job.sourceWaitTicks = 0
    job.sourceLoadedCells = 0
    job.sourceTotalCells = 0

    if job.blocks and job.blockIndex then
        local block = job.blocks[job.blockIndex]
        if block then
            block.positionChecked = false
            block.sourceReady = false
        end
    end

    if job.phase == "clear" and job.clearBlocks and job.clearBlockIndex then
        local block = job.clearBlocks[job.clearBlockIndex]
        if block then
            block.positionChecked = false
            block.sourceReady = false
        end
    elseif job.phase == "paste" and job.pasteBlocks and job.pasteBlockIndex then
        local block = job.pasteBlocks[job.pasteBlockIndex]
        if block then
            block.positionChecked = false
            block.sourceReady = false
        end
    end
end

function EBFCopyPasteServer.getActiveJobForPlayer(key)
    if EBFCopyPasteServer.copyJobs[key] then
        return EBFCopyPasteServer.copyJobs[key], "copy"
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        return EBFCopyPasteServer.pasteJobs[key], "paste"
    end
    if EBFCopyPasteServer.exportJobs[key] then
        return EBFCopyPasteServer.exportJobs[key], "export"
    end
    if EBFCopyPasteServer.importJobs[key] then
        return EBFCopyPasteServer.importJobs[key], "import"
    end
    return nil, nil
end

function EBFCopyPasteServer.pauseCurrentJob(playerObj)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "operationPaused", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    local job, kind = EBFCopyPasteServer.getActiveJobForPlayer(key)
    if not job then
        sendFeedback(playerObj, { action = "operationPaused", ok = false, message = "No hay ninguna operación en curso que pausar." })
        return
    end

    job.paused = true
    sendFeedback(playerObj, {
        action = "operationPaused",
        ok = true,
        kind = kind,
        message = "Operación pausada. Pulsa Continuar para reanudarla o Parar/Cancelar de nuevo para cancelarlo todo.",
    })
end

function EBFCopyPasteServer.resumeCurrentJob(playerObj)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "operationResumed", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    local job, kind = EBFCopyPasteServer.getActiveJobForPlayer(key)
    if not job then
        sendFeedback(playerObj, { action = "operationResumed", ok = false, message = "No hay ninguna operación pausada que reanudar." })
        return
    end

    job.paused = false
    EBFCopyPasteServer.resetPausedJobMovement(job)
    sendFeedback(playerObj, {
        action = "operationResumed",
        ok = true,
        kind = kind,
        message = "Operacao retomada.",
    })
end

function EBFCopyPasteServer.cancelCurrentJob(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "operationCanceled", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    local importJob = EBFCopyPasteServer.importJobs[key]
    if importJob and importJob.sessionId then
        EBFCopyPasteServer.canceledImportSessions[key] = tostring(importJob.sessionId)
    end

    local hadJob = EBFCopyPasteServer.copyJobs[key] ~= nil
            or EBFCopyPasteServer.pasteJobs[key] ~= nil
            or EBFCopyPasteServer.exportJobs[key] ~= nil
            or EBFCopyPasteServer.importJobs[key] ~= nil
    EBFCopyPasteServer.copyJobs[key] = nil
    EBFCopyPasteServer.pasteJobs[key] = nil
    EBFCopyPasteServer.exportJobs[key] = nil
    EBFCopyPasteServer.importJobs[key] = nil

    if args and args.clearClipboard == true then
        EBFCopyPasteServer.clipboards[key] = nil
    end

    sendFeedback(playerObj, {
        action = "operationCanceled",
        ok = true,
        hadJob = hadJob,
        clipboardCleared = args and args.clearClipboard == true,
        message = "Operacao cancelada.",
    })
end

function EBFCopyPasteServer.requestSavedAreas(playerObj)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "savedAreas", ok = false, message = "No tienes permisos de administrador.", saves = {} })
        return
    end
    sendSavedAreaList(playerObj)
end

function EBFCopyPasteServer.requestSafehouseSaves(playerObj)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseSaves", ok = false, message = "No tienes permisos de administrador.", saves = {} })
        return
    end
    sendSafehouseSaveList(playerObj)
end

function EBFCopyPasteServer.requestSafehouseBackupExport(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseExport", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.exportJobs[key] then
        sendFeedback(playerObj, { action = "safehouseExport", ok = false, message = "Ya hay una exportación en curso." })
        return
    end

    local backupName = args and args.backupName
    if backupName ~= nil then
        backupName = tostring(backupName or "")
    end
    local fileName = tostring(args and args.fileName or EBFCopyPaste.SafehouseBackupFileName)
    if fileName == "" then
        fileName = EBFCopyPaste.SafehouseBackupFileName
    end
    local payload = buildSafehouseBackupPayload(backupName)
    if not payload.saves or #payload.saves == 0 then
        sendFeedback(playerObj, { action = "safehouseExport", ok = false, message = "No se ha encontrado ningún guardado de casa segura que exportar." })
        return
    end

    local text = "-- EBFCopyPaste SafeHouse Backup\nreturn " .. serializeLuaValue(payload, 0, {})
    local chunks = splitBackupText(text)
    EBFCopyPasteServer.exportJobs[key] = {
        playerObj = playerObj,
        sessionId = tostring(nowMs()) .. "-" .. tostring(key),
        chunks = chunks,
        index = 1,
        total = #chunks,
        totalSize = string.len(text),
        saveCount = #payload.saves,
        fileName = fileName,
        backupName = backupName,
        chunkAction = "safehouseExportChunk",
        doneAction = "safehouseExportDone",
    }
    sendFeedback(playerObj, {
        action = "safehouseExportStart",
        ok = true,
        sessionId = EBFCopyPasteServer.exportJobs[key].sessionId,
        total = #chunks,
        totalSize = string.len(text),
        saveCount = #payload.saves,
        fileName = fileName,
        backupName = backupName,
    })
end

function EBFCopyPasteServer.requestSavedAreaExport(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "savedAreaExport", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.exportJobs[key] then
        sendFeedback(playerObj, { action = "savedAreaExport", ok = false, message = "Ya hay una exportación en curso." })
        return
    end

    local saveId = args and args.id
    if saveId ~= nil then
        saveId = tostring(saveId or "")
    end
    local fileName = tostring(args and args.fileName or EBFCopyPaste.SavedAreaExportFileName)
    if fileName == "" then
        fileName = EBFCopyPaste.SavedAreaExportFileName
    end

    local payload = buildSavedAreaExportPayload(saveId)
    if not payload.saves or #payload.saves == 0 then
        sendFeedback(playerObj, { action = "savedAreaExport", ok = false, message = "No se ha encontrado ningún guardado personalizado que exportar." })
        return
    end

    local text = "-- EBFCopyPaste Save Personalizado\nreturn " .. serializeLuaValue(payload, 0, {})
    local chunks = splitBackupText(text)
    EBFCopyPasteServer.exportJobs[key] = {
        playerObj = playerObj,
        sessionId = tostring(nowMs()) .. "-" .. tostring(key),
        chunks = chunks,
        index = 1,
        total = #chunks,
        totalSize = string.len(text),
        saveCount = #payload.saves,
        fileName = fileName,
        saveId = saveId,
        chunkAction = "savedAreaExportChunk",
        doneAction = "savedAreaExportDone",
    }
    sendFeedback(playerObj, {
        action = "savedAreaExportStart",
        ok = true,
        sessionId = EBFCopyPasteServer.exportJobs[key].sessionId,
        total = #chunks,
        totalSize = string.len(text),
        saveCount = #payload.saves,
        fileName = fileName,
        saveId = saveId,
    })
end

function EBFCopyPasteServer.processExportJob(key, job)
    if not job or not job.chunks then
        EBFCopyPasteServer.exportJobs[key] = nil
        return
    end
    if job.paused == true then
        return
    end

    local budget = 2
    local chunkAction = job.chunkAction or "safehouseExportChunk"
    while budget > 0 and job.index <= job.total do
        sendFeedback(job.playerObj, {
            action = chunkAction,
            ok = true,
            sessionId = job.sessionId,
            index = job.index,
            total = job.total,
            data = job.chunks[job.index],
        })
        job.index = job.index + 1
        budget = budget - 1
    end

    if job.index > job.total then
        local doneAction = job.doneAction or "safehouseExportDone"
        sendFeedback(job.playerObj, {
            action = doneAction,
            ok = true,
            sessionId = job.sessionId,
            total = job.total,
            totalSize = job.totalSize,
            saveCount = job.saveCount,
            fileName = job.fileName,
            backupName = job.backupName,
            saveId = job.saveId,
        })
        EBFCopyPasteServer.exportJobs[key] = nil
    end
end

function EBFCopyPasteServer.importSafehouseBackupStart(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    EBFCopyPasteServer.canceledImportSessions[key] = nil
    local total = math.max(1, tonumber(args and args.total) or 1)
    EBFCopyPasteServer.importJobs[key] = {
        playerObj = playerObj,
        sessionId = tostring(args and args.sessionId or nowMs()),
        total = total,
        chunks = {},
        received = 0,
        totalSize = tonumber(args and args.totalSize) or 0,
        restoreAfterImport = args and args.restoreAfterImport == true,
        importedIds = {},
    }
    sendFeedback(playerObj, {
        action = "safehouseImportStart",
        ok = true,
        sessionId = EBFCopyPasteServer.importJobs[key].sessionId,
        total = total,
    })
end

function EBFCopyPasteServer.importSafehouseBackupChunk(playerObj, args)
    local key = getPlayerKey(playerObj)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        EBFCopyPasteServer.importJobs[key] = nil
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local job = EBFCopyPasteServer.importJobs[key]
    if not job then
        if EBFCopyPasteServer.canceledImportSessions[key] == tostring(args and args.sessionId or "") then
            return
        end
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "La importación no se ha iniciado." })
        return
    end

    local index = tonumber(args and args.index)
    local data = args and args.data
    if not index or index < 1 or index > job.total or type(data) ~= "string" then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "El bloque de importación no es válido." })
        EBFCopyPasteServer.importJobs[key] = nil
        return
    end

    if job.chunks[index] == nil then
        job.received = job.received + 1
    end
    job.chunks[index] = data
    sendFeedback(playerObj, {
        action = "safehouseImportProgress",
        ok = true,
        sessionId = job.sessionId,
        processed = job.received,
        total = job.total,
    })
end

function EBFCopyPasteServer.importSafehouseBackupFinish(playerObj, args)
    local key = getPlayerKey(playerObj)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        EBFCopyPasteServer.importJobs[key] = nil
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local job = EBFCopyPasteServer.importJobs[key]
    if not job then
        if EBFCopyPasteServer.canceledImportSessions[key] == tostring(args and args.sessionId or "") then
            return
        end
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "La importación no se ha iniciado." })
        return
    end

    if job.received < job.total then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "Importacao incompleta." })
        EBFCopyPasteServer.importJobs[key] = nil
        return
    end

    local text = table.concat(job.chunks)
    local payload = deserializeLuaTable(text)
    if not payload or type(payload) ~= "table" or payload.format ~= "EBFCopyPasteSafeHouseBackup" or type(payload.saves) ~= "table" then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "No se puede leer el archivo de copia de seguridad." })
        EBFCopyPasteServer.importJobs[key] = nil
        return
    end

    if not payloadSaveCountMatches(payload) then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "El archivo de copia de seguridad está incompleto o dañado: saveCount no coincide." })
        EBFCopyPasteServer.importJobs[key] = nil
        return
    end

    if tonumber(payload.version) ~= tonumber(EBFCopyPaste.SchemaVersion or 4220001)
            or tostring(payload.targetBuild or "") ~= tostring(EBFCopyPaste.TargetBuild or "42.20") then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = EBFCopyPasteServer.currentSchemaRejectMessage() })
        EBFCopyPasteServer.importJobs[key] = nil
        return
    end

    if #payload.saves <= 0 then
        sendFeedback(playerObj, { action = "safehouseImport", ok = false, message = "El archivo de copia de seguridad no contiene casas seguras." })
        EBFCopyPasteServer.importJobs[key] = nil
        return
    end

    job.phase = "import"
    job.payload = payload
    job.chunks = nil
    job.importIndex = 1
    job.imported = 0
    job.failed = 0
    job.storage = getSafehouseSaveStorage()
    job.nextId = tonumber(payload.nextId) or 1
    sendFeedback(playerObj, {
        action = "safehouseImportProgress",
        ok = true,
        sessionId = job.sessionId,
        processed = 0,
        total = #payload.saves,
    })
end

function EBFCopyPasteServer.processImportJob(key, job)
    if not job or job.phase ~= "import" then
        return
    end
    if job.paused == true then
        return
    end

    local payload = job.payload or {}
    local saves = payload.saves or {}
    local budget = 1
    while budget > 0 and job.importIndex <= #saves do
        local ok, imported = pcall(importSafehouseBackupRecord, job.storage, saves[job.importIndex])
        if ok and imported then
            job.imported = (job.imported or 0) + 1
            if imported.id then
                table.insert(job.importedIds, tostring(imported.id))
            end
        else
            job.failed = (job.failed or 0) + 1
            if not ok then
                print("[EBFCopyPaste] Ha fallado el registro importado de la copia de seguridad de la casa segura: " .. tostring(imported))
            end
        end
        job.importIndex = job.importIndex + 1
        budget = budget - 1
    end

    local processed = math.min(#saves, math.max(0, (job.importIndex or 1) - 1))
    sendFeedback(job.playerObj, {
        action = "safehouseImportProgress",
        ok = true,
        sessionId = job.sessionId,
        processed = processed,
        total = #saves,
    })

    if job.importIndex <= #saves then
        return
    end

    if job.storage then
        job.storage.nextId = math.max(tonumber(job.storage.nextId) or 1, tonumber(job.nextId) or 1)
    end
    transmitSafehouseSaves()
    EBFCopyPasteServer.importJobs[key] = nil

    if (job.imported or 0) <= 0 then
        sendFeedback(job.playerObj, { action = "safehouseImport", ok = false, message = "No se ha importado ninguna casa segura." })
        return
    end

    sendFeedback(job.playerObj, {
        action = "safehouseImportDone",
        ok = true,
        imported = job.imported or 0,
        failed = job.failed or 0,
        importedIds = job.importedIds or {},
        restoreAfterImport = job.restoreAfterImport == true,
        saves = buildSafehouseSaveList(),
    })
end

function EBFCopyPasteServer.saveClipboard(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "save", ok = false, message = "No tienes permisos de administrador.", saves = buildSavedAreaList() })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = "save", ok = false, message = "La copia todavía está en curso.", saves = buildSavedAreaList() })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = "save", ok = false, message = "El pegado todavía está en curso.", saves = buildSavedAreaList() })
        return
    end

    local clipboard = EBFCopyPasteServer.clipboards[key]
    if not clipboard or not clipboard.objects or #clipboard.objects <= 0 or (tonumber(clipboard.count) or 0) <= 0 then
        sendFeedback(playerObj, { action = "save", ok = false, message = "No hay ninguna copia cargada que guardar.", saves = buildSavedAreaList() })
        return
    end

    local saveName = sanitizeSaveName(args and (args.saveName or args.title) or clipboard.title or "Zona Copy")
    local saved = saveClipboardToStorage(playerObj, saveName, clipboard)
    local stats = clipboard.stats or {}
    local safehouse = clipboard.safehouse or {}
    sendFeedback(playerObj, {
        action = "save",
        ok = saved ~= nil,
        id = saved and saved.id or nil,
        title = saved and saved.name or saveName,
        x = clipboard.x,
        y = clipboard.y,
        z = clipboard.z,
        w = clipboard.w,
        h = clipboard.h,
        levels = clipboard.levels,
        count = clipboard.count,
        tiles = stats.tiles or 0,
        containers = stats.containers or 0,
        items = stats.items or 0,
        lights = stats.lights or 0,
        missingTiles = stats.missingTiles or 0,
        failures = stats.failures or 0,
        source = clipboard.source,
        safehouseTitle = safehouse.title,
        safehouseOwner = safehouse.owner,
        saves = buildSavedAreaList(),
        message = saved and nil or "No se ha podido guardar el portapapeles.",
    })
end

function EBFCopyPasteServer.saveSafehouseClipboard(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseSaved", ok = false, message = "No tienes permisos de administrador.", saves = buildSafehouseSaveList() })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = "safehouseSaved", ok = false, message = "La copia todavía está en curso.", saves = buildSafehouseSaveList() })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = "safehouseSaved", ok = false, message = "El pegado todavía está en curso.", saves = buildSafehouseSaveList() })
        return
    end

    local clipboard = EBFCopyPasteServer.clipboards[key]
    if not clipboard or not clipboard.objects or #clipboard.objects <= 0 or (tonumber(clipboard.count) or 0) <= 0 then
        sendFeedback(playerObj, { action = "safehouseSaved", ok = false, message = "No hay ninguna casa segura copiada que guardar.", saves = buildSafehouseSaveList() })
        return
    end
    if clipboard.source ~= "safehouse" or not clipboard.safehouse then
        sendFeedback(playerObj, { action = "safehouseSaved", ok = false, message = "Copia una casa segura antes de usar Guardar casa segura.", saves = buildSafehouseSaveList() })
        return
    end

    local saved = saveSafehouseClipboardToStorage(playerObj, args and args.name, clipboard, args and args.backupName)
    sendFeedback(playerObj, {
        action = "safehouseSaved",
        ok = saved ~= nil,
        id = saved and saved.id or nil,
        title = saved and saved.name or nil,
        count = clipboard.count,
        saves = buildSafehouseSaveList(),
        message = saved and nil or "No se ha podido guardar la casa segura.",
    })
end

function EBFCopyPasteServer.loadSavedArea(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "savedLoaded", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = "savedLoaded", ok = false, message = "La copia todavía está en curso." })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = "savedLoaded", ok = false, message = "El pegado todavía está en curso." })
        return
    end

    local saved = getSavedAreaById(args and args.id)
    if not saved or not saved.clipboard then
        sendFeedback(playerObj, { action = "savedLoaded", ok = false, message = "No se ha encontrado el guardado.", saves = buildSavedAreaList() })
        return
    end

    local clipboard = makeRuntimeClipboard(saved.clipboard)
    if not clipboard then
        sendFeedback(playerObj, { action = "savedLoaded", ok = false, message = EBFCopyPasteServer.currentSchemaRejectMessage(), saves = buildSavedAreaList() })
        return
    end

    EBFCopyPasteServer.clipboards[key] = clipboard
    sendFeedback(playerObj, {
        action = "savedLoaded",
        ok = true,
        id = tostring(saved.id or args.id),
        title = tostring(saved.name or clipboard.title or "Zona Copy"),
        w = tonumber(clipboard.w) or 1,
        h = tonumber(clipboard.h) or 1,
        levels = tonumber(clipboard.levels) or 1,
        count = tonumber(clipboard.count) or 0,
        saves = buildSavedAreaList(),
    })
end

function EBFCopyPasteServer.loadSafehouseSave(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseSavedLoaded", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = "safehouseSavedLoaded", ok = false, message = "La copia todavía está en curso." })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = "safehouseSavedLoaded", ok = false, message = "El pegado todavía está en curso." })
        return
    end

    local saved = getSafehouseSaveById(args and args.id)
    if not saved or not saved.clipboard then
        sendFeedback(playerObj, { action = "safehouseSavedLoaded", ok = false, message = "No se ha encontrado el guardado de la casa segura.", saves = buildSafehouseSaveList() })
        return
    end

    local clipboard = makeRuntimeClipboard(saved.clipboard)
    if not clipboard then
        sendFeedback(playerObj, { action = "safehouseSavedLoaded", ok = false, message = EBFCopyPasteServer.currentSchemaRejectMessage(), saves = buildSafehouseSaveList() })
        return
    end

    EBFCopyPasteServer.clipboards[key] = clipboard
    sendFeedback(playerObj, {
        action = "safehouseSavedLoaded",
        ok = true,
        id = tostring(saved.id or args.id),
        title = tostring(saved.name or clipboard.title or "Safehouse"),
        w = tonumber(clipboard.w) or 1,
        h = tonumber(clipboard.h) or 1,
        levels = tonumber(clipboard.levels) or 1,
        count = tonumber(clipboard.count) or 0,
        saves = buildSafehouseSaveList(),
    })
end

function EBFCopyPasteServer.restoreSafehouseSave(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseRestore", ok = false, message = "No tienes permisos de administrador." })
        return
    end

    local key = getPlayerKey(playerObj)
    if EBFCopyPasteServer.copyJobs[key] then
        sendFeedback(playerObj, { action = "safehouseRestore", ok = false, message = "La copia todavía está en curso." })
        return
    end
    if EBFCopyPasteServer.pasteJobs[key] then
        sendFeedback(playerObj, { action = "safehouseRestore", ok = false, message = "El pegado todavía está en curso." })
        return
    end

    local saved = getSafehouseSaveById(args and args.id)
    if not saved or not saved.clipboard then
        sendFeedback(playerObj, { action = "safehouseRestore", ok = false, message = "No se ha encontrado el guardado de la casa segura.", saves = buildSafehouseSaveList() })
        return
    end

    local clipboard = makeRuntimeClipboard(saved.clipboard)
    if not clipboard or not clipboard.objects or #clipboard.objects <= 0 or (tonumber(clipboard.count) or 0) <= 0 then
        sendFeedback(playerObj, { action = "safehouseRestore", ok = false, message = EBFCopyPasteServer.currentSchemaRejectMessage(), saves = buildSafehouseSaveList() })
        return
    end

    local safehouse = clipboard.safehouse or {}
    local targetX = tonumber(saved.originalX) or tonumber(safehouse.x) or tonumber(clipboard.x)
    local targetY = tonumber(saved.originalY) or tonumber(safehouse.y) or tonumber(clipboard.y)
    local targetZ = tonumber(saved.originalZ) or tonumber(safehouse.z) or tonumber(clipboard.z) or 0
    if targetX == nil or targetY == nil then
        sendFeedback(playerObj, { action = "safehouseRestore", ok = false, message = "La ubicación original de la casa segura no es válida.", saves = buildSafehouseSaveList() })
        return
    end

    local job = {
        playerObj = playerObj,
        clipboard = clipboard,
        targetX = math.floor(targetX),
        targetY = math.floor(targetY),
        targetZ = math.floor(targetZ),
        phase = "clientAreaReconcile",
        tileIndex = 1,
        totalTiles = clipboard.w * clipboard.h * clipboard.levels,
        objectIndex = 1,
        pasted = 0,
        worldItemIdMap = {},
        lastFeedback = 0,
        sourceCells = nil,
        sourceReady = false,
        sourceWaitTicks = 0,
        movementMode = "teleport",
        restoreSafehouse = true,
        restoreSaveId = tostring(saved.id or args.id),
        restoreName = tostring(saved.name or safehouse.title or clipboard.title or "Safehouse"),
        restoreIndex = tonumber(args and args.restoreIndex) or 1,
        restoreTotal = tonumber(args and args.restoreTotal) or 1,
        restoreRecord = saved,
    }
    EBFCopyPasteServer.pasteJobs[key] = job
    sendPasteProgress(job, true)
end

function EBFCopyPasteServer.deleteSavedArea(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "saveDeleted", ok = false, message = "No tienes permisos de administrador.", saves = buildSavedAreaList() })
        return
    end

    local saveId = tostring(args and args.id or "")
    if saveId == "" then
        sendFeedback(playerObj, { action = "saveDeleted", ok = false, message = "El guardado no es válido.", saves = buildSavedAreaList() })
        return
    end

    local storage = getSavedAreaStorage()
    local saved = storage.saves and storage.saves[saveId] or nil
    if not saved then
        sendFeedback(playerObj, { action = "saveDeleted", ok = false, message = "No se ha encontrado el guardado.", saves = buildSavedAreaList() })
        return
    end

    local saveName = tostring(saved.name or "Zona Copy")
    storage.saves[saveId] = nil
    transmitSavedAreas()
    sendFeedback(playerObj, {
        action = "saveDeleted",
        ok = true,
        id = saveId,
        title = saveName,
        saves = buildSavedAreaList(),
    })
end

function EBFCopyPasteServer.deleteSafehouseSave(playerObj, args)
    if not EBFCopyPaste.hasCopyPasteAccess(playerObj) then
        sendFeedback(playerObj, { action = "safehouseSaveDeleted", ok = false, message = "No tienes permisos de administrador.", saves = buildSafehouseSaveList() })
        return
    end

    local saveId = tostring(args and args.id or "")
    if saveId == "" then
        sendFeedback(playerObj, { action = "safehouseSaveDeleted", ok = false, message = "El guardado de la casa segura no es válido.", saves = buildSafehouseSaveList() })
        return
    end

    local storage = getSafehouseSaveStorage()
    local saved = storage.saves and storage.saves[saveId] or nil
    if not saved then
        sendFeedback(playerObj, { action = "safehouseSaveDeleted", ok = false, message = "No se ha encontrado el guardado de la casa segura.", saves = buildSafehouseSaveList() })
        return
    end

    local saveName = tostring(saved.name or "Safehouse")
    storage.saves[saveId] = nil
    transmitSafehouseSaves()
    sendFeedback(playerObj, {
        action = "safehouseSaveDeleted",
        ok = true,
        id = saveId,
        title = saveName,
        saves = buildSafehouseSaveList(),
    })
end

function EBFCopyPasteServer.onTick()
    for key, job in pairs(EBFCopyPasteServer.copyJobs) do
        if job.paused ~= true then
            processCopyJob(key, job)
        end
    end

    for key, job in pairs(EBFCopyPasteServer.pasteJobs) do
        if job.paused ~= true then
            processPasteJob(key, job)
        end
    end

    for key, job in pairs(EBFCopyPasteServer.exportJobs) do
        if job.paused ~= true then
            EBFCopyPasteServer.processExportJob(key, job)
        end
    end

    for key, job in pairs(EBFCopyPasteServer.importJobs) do
        if job.paused ~= true then
            EBFCopyPasteServer.processImportJob(key, job)
        end
    end
end

function EBFCopyPasteServer.playerCanReachManagedLightSwitch(playerObj, square)
    if not playerObj or not square then
        return false
    end

    local playerSquare = callMethod(playerObj, "getSquare")
    if not playerSquare then
        return false
    end

    local dx = math.abs((tonumber(callMethod(playerSquare, "getX")) or 0) - (tonumber(callMethod(square, "getX")) or 0))
    local dy = math.abs((tonumber(callMethod(playerSquare, "getY")) or 0) - (tonumber(callMethod(square, "getY")) or 0))
    local dz = math.abs((tonumber(callMethod(playerSquare, "getZ")) or 0) - (tonumber(callMethod(square, "getZ")) or 0))
    return dx <= 12 and dy <= 12 and dz <= 2
end

function EBFCopyPasteServer.getManagedLightSwitchModData(object)
    if not object or not object.getModData or not isInstance(object, "IsoLightSwitch") then
        return nil
    end

    local modData = object:getModData()
    if not modData or modData[EBFCopyPaste.ManagedResidentialLightSwitchModDataKey] ~= true then
        return nil
    end
    return modData
end

function EBFCopyPasteServer.findManagedLightSwitchForToggle(square, args)
    if not square or not square.getObjects then
        return nil
    end

    local objects = square:getObjects()
    if not objects then
        return nil
    end

    local wantedIndex = tonumber(args and args.index)
    local wantedSprite = tostring(args and args.sprite or "")
    local function matches(object)
        if not EBFCopyPasteServer.getManagedLightSwitchModData(object) then
            return false
        end
        if wantedSprite ~= "" and getObjectSpriteName(object) ~= wantedSprite then
            return false
        end
        return true
    end

    if wantedIndex and wantedIndex >= 0 and wantedIndex < objects:size() then
        local object = objects:get(wantedIndex)
        if matches(object) then
            return object
        end
    end

    for index = objects:size() - 1, 0, -1 do
        local object = objects:get(index)
        if matches(object) then
            return object
        end
    end
    return nil
end

function EBFCopyPasteServer.managedLightSwitchRoomMatches(room, modData)
    if not room or not modData then
        return false
    end

    local roomDef = callMethod(room, "getRoomDef")
    if not roomDef then
        return false
    end

    local expectedID = modData[EBFCopyPaste.ManagedLightRoomIDStringModDataKey]
    if expectedID ~= nil and tostring(expectedID) ~= "" then
        return tostring(EBFCopyPasteServer.getRoomDefIdString(roomDef) or "") == tostring(expectedID)
    end

    local expectedName = modData[EBFCopyPaste.ManagedLightRoomNameModDataKey]
    if expectedName ~= nil and tostring(expectedName) ~= "" then
        return tostring(callMethod(roomDef, "getName") or callMethod(room, "getName") or "") == tostring(expectedName)
    end
    return true
end

function EBFCopyPasteServer.resolveManagedLightSwitchRoom(square, object)
    local modData = EBFCopyPasteServer.getManagedLightSwitchModData(object)
    if not square or not modData then
        return nil
    end

    local expectedDz = tonumber(modData[EBFCopyPaste.ManagedLightRoomDzModDataKey])
    local squareZ = tonumber(callMethod(square, "getZ")) or 0
    if expectedDz ~= nil and expectedDz ~= squareZ then
        return nil
    end

    local room = callMethod(square, "getRoom")
    if EBFCopyPasteServer.managedLightSwitchRoomMatches(room, modData) then
        return room
    end

    local expectedIDString = modData[EBFCopyPaste.ManagedLightRoomIDStringModDataKey]
    if expectedIDString ~= nil then
        expectedIDString = tostring(expectedIDString)
    end
    local metaGrid = EBFCopyPasteServer.getWorldMetaGrid()
    if expectedIDString and expectedIDString ~= "" then
        local roomDefAtSquare = metaGrid and callMethod(
                metaGrid,
                "getRoomAt",
                EBFCopyPaste.toInt(callMethod(square, "getX"), 0),
                EBFCopyPaste.toInt(callMethod(square, "getY"), 0),
                EBFCopyPaste.toInt(callMethod(square, "getZ"), 0)) or nil
        if roomDefAtSquare
                and tostring(EBFCopyPasteServer.getRoomDefIdString(roomDefAtSquare) or "") == expectedIDString then
            EBFCopyPasteServer.applyRoomDefToSquare(square, roomDefAtSquare, metaGrid, true)
            local squareRoom = callMethod(square, "getRoom")
            if EBFCopyPasteServer.managedLightSwitchRoomMatches(squareRoom, modData) then
                return squareRoom
            end
            local candidate = EBFCopyPasteServer.getRuntimeRoomFromRoomDef(roomDefAtSquare, metaGrid)
            if EBFCopyPasteServer.managedLightSwitchRoomMatches(candidate, modData) then
                EBFCopyPasteServer.tryCallMethod(square, "setRoom", candidate)
                return candidate
            end
        end
    end

    local expectedIDNumber = tonumber(expectedIDString)
    if expectedIDNumber ~= nil and math.abs(expectedIDNumber) < 9007199254740992 then
        local candidate = metaGrid and callMethod(metaGrid, "getRoomByID", expectedIDNumber) or nil
        if EBFCopyPasteServer.managedLightSwitchRoomMatches(candidate, modData) then
            local roomDef = callMethod(candidate, "getRoomDef")
            EBFCopyPasteServer.applyRoomDefToSquare(square, roomDef, metaGrid, true)
            if EBFCopyPasteServer.managedLightSwitchRoomMatches(callMethod(square, "getRoom"), modData) then
                return callMethod(square, "getRoom")
            end
            return candidate
        end
    end

    return nil
end

function EBFCopyPasteServer.handleManagedLightSwitchToggle(playerObj, args)
    args = args or {}
    local x = EBFCopyPaste.toInt(args.x, nil)
    local y = EBFCopyPaste.toInt(args.y, nil)
    local z = EBFCopyPaste.toInt(args.z, nil)
    if x == nil or y == nil or z == nil then
        return
    end

    local cell = getCell and getCell() or nil
    local square = cell and cell:getGridSquare(x, y, z) or nil
    if not square then
        print("[EBFCopyPaste] Interruptor interior gestionado por el servidor ignorado: falta la casilla " .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z))
        return
    end
    if not EBFCopyPasteServer.playerCanReachManagedLightSwitch(playerObj, square) then
        print("[EBFCopyPaste] Interruptor interior gestionado por el servidor bloqueado: el jugador está lejos del interruptor "
                .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z))
        return
    end

    local object = EBFCopyPasteServer.findManagedLightSwitchForToggle(square, args)
    local modData = EBFCopyPasteServer.getManagedLightSwitchModData(object)
    if not object or not modData then
        print("[EBFCopyPaste] Interruptor interior gestionado por el servidor ignorado: no se ha encontrado el interruptor gestionado "
                .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z))
        return
    end

    local room = EBFCopyPasteServer.resolveManagedLightSwitchRoom(square, object)
    if not room then
        print("[EBFCopyPaste] Interruptor interior gestionado por el servidor bloqueado: falta el RoomDef de destino; interruptor="
                .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
                .. " expectedRoomID=" .. tostring(modData[EBFCopyPaste.ManagedLightRoomIDStringModDataKey])
                .. " expectedDz=" .. tostring(modData[EBFCopyPaste.ManagedLightRoomDzModDataKey]))
        return
    end

    if not EBFCopyPasteServer.bindLightSwitchToRoom(square, object, nil, room, nil) then
        print("[EBFCopyPaste] Interruptor interior gestionado por el servidor bloqueado: no se ha podido rehacer el vínculo vanilla; interruptor="
                .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
                .. " room={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
        return
    end
    local linkedRooms, wrongLinkedRooms = EBFCopyPasteServer.countLightSwitchLinksInKnownPasteRooms(nil, square, object, room)
    if linkedRooms ~= 1 or wrongLinkedRooms > 0 then
        print("[EBFCopyPaste] Interruptor interior gestionado por el servidor bloqueado: vínculo vanilla ambiguo; interruptor="
                .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
                .. " linkedRooms=" .. tostring(linkedRooms)
                .. " wrongLinkedRooms=" .. tostring(wrongLinkedRooms)
                .. " room={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
        return
    end
    local active = args.active == true
    local previousActive = callMethod(object, "isActivated") == true
    callMethod(object, "setActivated", not active)
    local ok = EBFCopyPasteServer.tryCallMethod(object, "setActive", active)
    if ok ~= true or callMethod(object, "isActivated") ~= active then
        callMethod(object, "setActivated", previousActive)
        print("[EBFCopyPaste] Toggle indoor server-owned bloqueado pelo setActive vanilla: switch="
                .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
                .. " active=" .. tostring(active)
                .. " canSwitch=" .. tostring(callMethod(object, "canSwitchLight"))
                .. " room={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}")
        return
    end

    local roomDef = callMethod(room, "getRoomDef")
    print("[EBFCopyPaste] Toggle indoor server-owned aplicado: switch="
            .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(z)
            .. " active=" .. tostring(active)
            .. " room={" .. EBFCopyPasteServer.getRoomAuditLabel(room) .. "}"
            .. " lightsActive=" .. tostring(roomDef and EBFCopyPasteServer.safeField(roomDef, "lightsActive"))
            .. " player=" .. EBFCopyPasteServer.auditValue(playerObj and callMethod(playerObj, "getUsername")))
end

function EBFCopyPasteServer.onClientCommand(module, command, playerObj, args)
    if module ~= EBFCopyPaste.Module then
        return
    end

    if command == EBFCopyPaste.Commands.CopyArea then
        EBFCopyPasteServer.copyArea(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.SaveClipboard then
        EBFCopyPasteServer.saveClipboard(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.SaveSafehouseClipboard then
        EBFCopyPasteServer.saveSafehouseClipboard(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.PasteArea then
        EBFCopyPasteServer.pasteArea(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.RoomDefReconcileAck then
        EBFCopyPasteServer.handleClientRoomDefReconcileAck(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.PasteVisualAck then
        EBFCopyPasteServer.handleClientPasteVisualAck(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.ToggleManagedLightSwitch then
        EBFCopyPasteServer.handleManagedLightSwitchToggle(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.PauseCurrentJob then
        EBFCopyPasteServer.pauseCurrentJob(playerObj)
        return
    end

    if command == EBFCopyPaste.Commands.ResumeCurrentJob then
        EBFCopyPasteServer.resumeCurrentJob(playerObj)
        return
    end

    if command == EBFCopyPaste.Commands.CancelCurrentJob then
        EBFCopyPasteServer.cancelCurrentJob(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.RequestSavedAreas then
        EBFCopyPasteServer.requestSavedAreas(playerObj)
        return
    end

    if command == EBFCopyPaste.Commands.RequestSafehouseSaves then
        EBFCopyPasteServer.requestSafehouseSaves(playerObj)
        return
    end

    if command == EBFCopyPaste.Commands.RequestSafehouseBackupExport then
        EBFCopyPasteServer.requestSafehouseBackupExport(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.RequestSavedAreaExport then
        EBFCopyPasteServer.requestSavedAreaExport(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.ImportSafehouseBackupStart then
        EBFCopyPasteServer.importSafehouseBackupStart(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.ImportSafehouseBackupChunk then
        EBFCopyPasteServer.importSafehouseBackupChunk(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.ImportSafehouseBackupFinish then
        EBFCopyPasteServer.importSafehouseBackupFinish(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.LoadSavedArea then
        EBFCopyPasteServer.loadSavedArea(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.LoadSafehouseSave then
        EBFCopyPasteServer.loadSafehouseSave(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.RestoreSafehouseSave then
        EBFCopyPasteServer.restoreSafehouseSave(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.DeleteSavedArea then
        EBFCopyPasteServer.deleteSavedArea(playerObj, args)
        return
    end

    if command == EBFCopyPaste.Commands.DeleteSafehouseSave then
        EBFCopyPasteServer.deleteSafehouseSave(playerObj, args)
        return
    end

end

function EBFCopyPasteServer.onLoadGridSquare(square)
    return
end

function EBFCopyPasteServer.onInitGlobalModData()
    getSavedAreaStorage()
    getSafehouseSaveStorage()
end

if EBFCopyPasteServer.isAuthoritativeWorld() then
    Events.OnClientCommand.Add(EBFCopyPasteServer.onClientCommand)
    if Events.OnInitGlobalModData then
        Events.OnInitGlobalModData.Add(EBFCopyPasteServer.onInitGlobalModData)
    end
    Events.OnTick.Add(EBFCopyPasteServer.onTick)
end
