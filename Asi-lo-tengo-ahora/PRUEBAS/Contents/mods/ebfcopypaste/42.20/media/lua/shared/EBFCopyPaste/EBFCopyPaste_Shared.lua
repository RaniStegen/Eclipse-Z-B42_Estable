EBFCopyPaste = EBFCopyPaste or {}

-- B42.20 mantiene PlayerRoomsFile como clase Java pública, pero no siempre la
-- registra como global de Lua. Este puente la enlaza explícitamente antes de
-- reconstruir habitaciones; el fallback físico solo se usa si el enlace falla.
local function bindJavaClassSafe(className)
    if not luajava or not luajava.bindClass then
        return nil
    end
    local ok, classRef = pcall(function()
        return luajava.bindClass(className)
    end)
    if ok and classRef then
        return classRef
    end
    return nil
end

function EBFCopyPaste.ensureJavaRoomDefBridge()
    if not BuildingRoomsEditor then
        BuildingRoomsEditor = bindJavaClassSafe("zombie.buildingRooms.BuildingRoomsEditor")
    end
    if not PlayerRoomsFile then
        PlayerRoomsFile = bindJavaClassSafe("zombie.buildingRooms.PlayerRoomsFile")
    end
    return BuildingRoomsEditor ~= nil, PlayerRoomsFile ~= nil
end

EBFCopyPaste.ensureJavaRoomDefBridge()

EBFCopyPaste.Module = "EBFCopyPaste"
EBFCopyPaste.TargetBuild = "42.20"
EBFCopyPaste.ClipboardFormat = "EBFCopyPasteArea"
EBFCopyPaste.SchemaVersion = 4220001
EBFCopyPaste.ScannerMetadataVersion = 6
EBFCopyPaste.RoomSpecsVersion = 4
EBFCopyPaste.RequireCurrentSaveSchema = true
EBFCopyPaste.Commands = {
    CopyArea = "copyArea",
    PasteArea = "pasteArea",
    SaveClipboard = "saveClipboard",
    SaveSafehouseClipboard = "saveSafehouseClipboard",
    LoadSavedArea = "loadSavedArea",
    DeleteSavedArea = "deleteSavedArea",
    RequestSavedAreas = "requestSavedAreas",
    RequestSavedAreaExport = "requestSavedAreaExport",
    LoadSafehouseSave = "loadSafehouseSave",
    DeleteSafehouseSave = "deleteSafehouseSave",
    RequestSafehouseSaves = "requestSafehouseSaves",
    RequestSafehouseBackupExport = "requestSafehouseBackupExport",
    ImportSafehouseBackupStart = "importSafehouseBackupStart",
    ImportSafehouseBackupChunk = "importSafehouseBackupChunk",
    ImportSafehouseBackupFinish = "importSafehouseBackupFinish",
    RestoreSafehouseSave = "restoreSafehouseSave",
    Feedback = "feedback",
    ReconcilePasteArea = "reconcilePasteArea",
    RoomDefReconcileAck = "roomDefReconcileAck",
    PasteVisualAck = "pasteVisualAck",
    ToggleManagedLightSwitch = "toggleManagedLightSwitch",
    PauseCurrentJob = "pauseCurrentJob",
    ResumeCurrentJob = "resumeCurrentJob",
    CancelCurrentJob = "cancelCurrentJob",
}

EBFCopyPaste.MaxArea = 1600
EBFCopyPaste.MaxSelectionWidth = 40
EBFCopyPaste.MaxSelectionHeight = 40
EBFCopyPaste.DefaultZLevels = 8
EBFCopyPaste.MaxZLevels = 13
EBFCopyPaste.AutoZMin = -2
EBFCopyPaste.AutoZMax = 10
EBFCopyPaste.CopyBlockSize = 40
EBFCopyPaste.CopySimpleTilesPerTick = 24
EBFCopyPaste.CopyHeavyTilesPerTick = 1
EBFCopyPaste.CopyTimeBudgetMs = 4
EBFCopyPaste.CopyMaxSimpleTilesPerTick = 120
EBFCopyPaste.CopyContainerItemsPerTick = 80
EBFCopyPaste.PasteClearSimpleTilesPerTick = 24
EBFCopyPaste.PasteClearHeavyTilesPerTick = 1
EBFCopyPaste.PasteClearTimeBudgetMs = 4
EBFCopyPaste.PasteClearMaxSimpleTilesPerTick = 160
EBFCopyPaste.PasteSimpleObjectsPerTick = 8
EBFCopyPaste.PasteHeavyObjectsPerTick = 1
EBFCopyPaste.PasteObjectTimeBudgetMs = 4
EBFCopyPaste.PasteMaxSimpleObjectsPerTick = 32
EBFCopyPaste.PasteContainerItemsPerTick = 80
EBFCopyPaste.PasteFinalizeTilesPerTick = 160
EBFCopyPaste.PasteFinalizeObjectsPerTick = 16
EBFCopyPaste.PasteVerificationObjectsPerTick = 24
EBFCopyPaste.ClientRoomDefSyncTicks = 12
EBFCopyPaste.ClientRoomDefAckTimeoutTicks = 90
EBFCopyPaste.PostFinalSyncSettleTicks = 30
EBFCopyPaste.FinalClientAckMinTicks = 2
EBFCopyPaste.FinalClientAckTimeoutTicks = 90
EBFCopyPaste.ProgressIntervalMs = 750
EBFCopyPaste.StageLogEnabled = true
-- Diagnóstico temporal 42.20.3: registra cada objeto que no se crea, no queda
-- registrado en la casilla o cambia de sprite durante el pegado.
EBFCopyPaste.DiagnosticMode = true
EBFCopyPaste.DiagnosticMaxEntries = 500
EBFCopyPaste.DiagnosticMaxText = 700
EBFCopyPaste.RebuildRoomDefs = true
EBFCopyPaste.SaveRebuiltRoomDefs = true
-- B42.20 no expone PlayerRoomsFile a Lua en todos los entornos. En ese caso,
-- se completa el pegado físico sin crear RoomDef transitorios que puedan dañar map_meta.bin.
EBFCopyPaste.RoomDefFallbackMode = "physicalOnly"
EBFCopyPaste.AllowStructuralIsoObjectFallback = true
EBFCopyPaste.UseVanillaRuntimeRoomLights = true
EBFCopyPaste.SafehouseBackupFileName = "EBFCopyPaste_SafeHouseBackup.txt"
EBFCopyPaste.SavedAreaExportFileName = "EBFCopyPaste_SavePersonalizado.txt"
EBFCopyPaste.BackupChunkSize = 12000
EBFCopyPaste.SavedAreasModDataKey = "EBFCopyPasteSavedAreas"
EBFCopyPaste.SafehouseSavesModDataKey = "EBFCopyPasteSafehouseSaves"
EBFCopyPaste.PasteKeyModDataKey = "EBFCopyPastePasteKey"
EBFCopyPaste.ManagedResidentialLightSwitchModDataKey = "EBFCopyPasteManagedResidentialLightSwitch"
EBFCopyPaste.ManagedLightRoomKeyModDataKey = "EBFCopyPasteManagedLightRoomKey"
EBFCopyPaste.ManagedLightRoomIDStringModDataKey = "EBFCopyPasteManagedLightRoomIDString"
EBFCopyPaste.ManagedLightRoomNameModDataKey = "EBFCopyPasteManagedLightRoomName"
EBFCopyPaste.ManagedLightRoomDzModDataKey = "EBFCopyPasteManagedLightRoomDz"

function EBFCopyPaste.toInt(value, fallback)
    local number = tonumber(value)
    if number == nil then
        return fallback
    end
    return math.floor(number)
end

function EBFCopyPaste.normalizeSelection(x1, y1, x2, y2, z)
    x1 = EBFCopyPaste.toInt(x1, 0)
    y1 = EBFCopyPaste.toInt(y1, 0)
    x2 = EBFCopyPaste.toInt(x2, x1)
    y2 = EBFCopyPaste.toInt(y2, y1)
    z = EBFCopyPaste.toInt(z, 0)

    local minX = math.min(x1, x2)
    local maxX = math.max(x1, x2)
    local minY = math.min(y1, y2)
    local maxY = math.max(y1, y2)

    return {
        x = minX,
        y = minY,
        z = z,
        x2 = maxX,
        y2 = maxY,
        w = maxX - minX + 1,
        h = maxY - minY + 1,
    }
end

function EBFCopyPaste.normalizeAreaArgs(args)
    args = args or {}
    if args.w ~= nil and args.h ~= nil then
        local x = EBFCopyPaste.toInt(args.x, 0)
        local y = EBFCopyPaste.toInt(args.y, 0)
        local z = EBFCopyPaste.toInt(args.z, 0)
        local w = math.max(1, EBFCopyPaste.toInt(args.w, 1))
        local h = math.max(1, EBFCopyPaste.toInt(args.h, 1))
        return {
            x = x,
            y = y,
            z = z,
            x2 = x + w - 1,
            y2 = y + h - 1,
            w = w,
            h = h,
        }
    end

    return EBFCopyPaste.normalizeSelection(args.x1, args.y1, args.x2, args.y2, args.z)
end

function EBFCopyPaste.areaSize(area)
    if not area then
        return 0
    end
    return math.max(0, (tonumber(area.w) or 0) * (tonumber(area.h) or 0))
end

function EBFCopyPaste.clampZLevels(levels)
    levels = EBFCopyPaste.toInt(levels, EBFCopyPaste.DefaultZLevels)
    levels = math.max(1, levels)
    return math.min(levels, EBFCopyPaste.MaxZLevels)
end

function EBFCopyPaste.normalizeZOffsets(zOffsets, levels)
    local offsets = {}
    local seen = {}

    if type(zOffsets) == "table" then
        for _, value in ipairs(zOffsets) do
            local offset = EBFCopyPaste.toInt(value, nil)
            if offset ~= nil and not seen[offset] then
                seen[offset] = true
                table.insert(offsets, offset)
            end
        end
    end

    if #offsets == 0 then
        local count = EBFCopyPaste.clampZLevels(levels)
        for dz = 0, count - 1 do
            table.insert(offsets, dz)
        end
    end

    table.sort(offsets)
    while #offsets > EBFCopyPaste.MaxZLevels do
        table.remove(offsets)
    end
    return offsets
end

function EBFCopyPaste.hasCopyPasteAccess(playerObj)
    if not playerObj or not playerObj.getRole then
        return not (isClient and isClient())
    end

    local role = playerObj:getRole()
    if not role then
        return false
    end

    if role.hasAdminPower and role:hasAdminPower() then
        return true
    end

    if Capability and role.hasCapability then
        if Capability.CanSetupSafehouses and role:hasCapability(Capability.CanSetupSafehouses) then
            return true
        end
        if Capability.CanModifyWorld and role:hasCapability(Capability.CanModifyWorld) then
            return true
        end
    end

    return false
end

function EBFCopyPaste.getGeneratorRadius()
    local radius = nil
    if SandboxOptions and SandboxOptions.instance and SandboxOptions.instance.generatorTileRange then
        local ok, value = pcall(function()
            return SandboxOptions.instance.generatorTileRange:getValue()
        end)
        if ok then
            radius = tonumber(value)
        end
    end

    radius = radius or 20
    return math.max(4, math.floor(radius))
end
