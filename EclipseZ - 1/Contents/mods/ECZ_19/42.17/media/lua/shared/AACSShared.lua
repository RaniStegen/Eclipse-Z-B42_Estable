-- AACSShared.lua (Build 42.17 / MP-safe)
-- Shared helpers. The server owns the authoritative registry.

AACS = AACS or {}
AACS.UI = AACS.UI or {}

AACS.MOD_ID = "AACS"
AACS.REGISTRY_KEY = "AACS_Registry"
AACS.REGISTRY_META_KEY = "AACS_RegistryMeta"
AACS.LASTLOGIN_KEY = "AACS_PlayerLastLogin"
AACS.REGISTRY_SCHEMA_VERSION = 2

-- Registry transport states
AACS.TRANSPORT_WORLD = "world"
AACS.TRANSPORT_INVENTORY = "inventory"
AACS.TRANSPORT_TRAILER = "trailer"
AACS.TRANSPORT_HUTCH = "hutch"

-- Per-animal modData keys
AACS.MD_UID        = "AACS_UID"
AACS.MD_OWNER      = "AACS_Owner"
AACS.MD_NICKNAME   = "AACS_Nickname"
AACS.MD_PICKUPMODE = "AACS_PickupMode"
AACS.MD_LEASHMODE  = "AACS_LeashMode"
AACS.MD_ALLOWLIST  = "AACS_AllowList"
AACS.MD_LASTX      = "AACS_LastX"
AACS.MD_LASTY      = "AACS_LastY"
AACS.MD_LASTZ      = "AACS_LastZ"
AACS.MD_LASTSEEN   = "AACS_LastSeen"

-- Flat AnimalInventoryItem snapshot keys
AACS.ITEM_MD_SCHEMA     = "AACSItemSchemaVersion"
AACS.ITEM_MD_UID        = "AACSItemUID"
AACS.ITEM_MD_OWNER      = "AACSItemOwner"
AACS.ITEM_MD_PICKUPMODE = "AACSItemPickupMode"
AACS.ITEM_MD_LEASHMODE  = "AACSItemLeashMode"
AACS.ITEM_MD_ALLOWLIST  = "AACSItemAllowList"
AACS.ITEM_MD_NICKNAME   = "AACSItemNickname"

-- Permission modes
AACS.MODE_OWNER_ONLY   = 1
AACS.MODE_SAFEHOUSE    = 2
AACS.MODE_FACTION      = 3
AACS.MODE_SAFE_OR_FACT = 4

local function _sv()
    return (SandboxVars and SandboxVars.AACS) or {}
end

local function _trim(s)
    s = tostring(s or "")
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function _normText(s)
    if s == nil then return "" end
    s = tostring(s)
    s = s:gsub("<[^>]+>", "")
    s = s:gsub("%s+", " ")
    s = _trim(s)
    return string.lower(s)
end

local function _firstNonEmpty(...)
    local count = select("#", ...)
    for i = 1, count do
        local value = select(i, ...)
        if value ~= nil then
            local text = tostring(value)
            if text ~= "" then
                return text
            end
        end
    end
    return nil
end

local function _firstNumber(...)
    local count = select("#", ...)
    for i = 1, count do
        local value = select(i, ...)
        local n = tonumber(value)
        if n ~= nil then
            return n
        end
    end
    return nil
end

local function _clearOnServer(animal)
    -- Dedicated-server-safe: live animal modData is server-local only.
    -- Clients learn claim state through explicit cache snapshots and commands.
    return
end

local function _getItemModData(item)
    if not item or not item.getModData then return nil end
    return item:getModData()
end

local function _iterJavaList(listObj, fn)
    if not listObj or not fn then return false end

    if type(listObj) == "table" then
        for _, value in ipairs(listObj) do
            if fn(value) == true then
                return true
            end
        end
        return false
    end

    local iteratorFn = nil
    pcall(function() iteratorFn = listObj.iterator end)
    if type(iteratorFn) == "function" then
        local okIter, it = pcall(function() return iteratorFn(listObj) end)
        if okIter and it then
            while true do
                local okHas, hasNext = pcall(function() return it:hasNext() end)
                if not okHas or hasNext ~= true then
                    break
                end
                local okNext, value = pcall(function() return it:next() end)
                if okNext and fn(value) == true then
                    return true
                end
            end
            return false
        end
    end

    local sizeFn = nil
    pcall(function() sizeFn = listObj.size end)
    if type(sizeFn) == "function" then
        local okSize, size = pcall(function() return sizeFn(listObj) end)
        size = okSize and tonumber(size) or nil
        if size ~= nil and size > 0 then
            local getFn = nil
            pcall(function() getFn = listObj.get end)
            if type(getFn) ~= "function" then
                return false
            end
            for i = 0, size - 1 do
                local okItem, value = pcall(function() return getFn(listObj, i) end)
                if okItem and fn(value) == true then
                    return true
                end
            end
        end
    end

    return false
end

function AACS.SanitizeMode(mode)
    mode = tonumber(mode) or AACS.MODE_OWNER_ONLY
    if mode < 1 or mode > 4 then
        return AACS.MODE_OWNER_ONLY
    end

    local allowSafehouse = _sv().AllowSafehouse == true
    local allowFaction = _sv().AllowFaction == true

    if mode == AACS.MODE_SAFEHOUSE and not allowSafehouse then
        return AACS.MODE_OWNER_ONLY
    end
    if mode == AACS.MODE_FACTION and not allowFaction then
        return AACS.MODE_OWNER_ONLY
    end
    if mode == AACS.MODE_SAFE_OR_FACT then
        if allowSafehouse and allowFaction then
            return mode
        end
        if allowSafehouse then
            return AACS.MODE_SAFEHOUSE
        end
        if allowFaction then
            return AACS.MODE_FACTION
        end
        return AACS.MODE_OWNER_ONLY
    end
    return mode
end

function AACS.GetAllowedModes()
    local modes = { AACS.MODE_OWNER_ONLY }
    if _sv().AllowSafehouse then
        table.insert(modes, AACS.MODE_SAFEHOUSE)
    end
    if _sv().AllowFaction then
        table.insert(modes, AACS.MODE_FACTION)
    end
    if _sv().AllowSafehouse and _sv().AllowFaction then
        table.insert(modes, AACS.MODE_SAFE_OR_FACT)
    end
    return modes
end

function AACS.Log(msg)
    if _sv().VerboseLogs then
        print(string.format("[AACS] %s", tostring(msg)))
    end
end

function AACS.IsAdmin(playerObj)
    if not playerObj then return false end

    if (not isClient()) and (not isServer()) then
        return true
    end

    local lvl
    pcall(function() lvl = playerObj:getAccessLevel() end)
    if not lvl then return false end
    lvl = tostring(lvl):lower()
    local allowed = {
        admin = true,
        moderator = true,
        overseer = true,
        gm = true,
        observer = true,
    }
    return allowed[lvl] == true
end

function AACS.GetPlayerLastLogin(username)
    if not username or username == "" then return nil end

    if isClient and isClient() and AACS.PlayerLastLoginDB then
        return tonumber(AACS.PlayerLastLoginDB[username])
    end

    local db = ModData and ModData.getOrCreate and ModData.getOrCreate(AACS.LASTLOGIN_KEY) or nil
    if not db then return nil end
    return tonumber(db[username])
end

function AACS.Now()
    if getTimestamp then return getTimestamp() * 1000 end
    return os.time() * 1000
end

function AACS.GenerateUID()
    local r = ZombRand(1000, 9999)
    return tostring(AACS.Now()) .. tostring(r)
end

function AACS.CloneAllowListArray(tbl)
    local out, seen = {}, {}
    if type(tbl) ~= "table" then
        return out
    end
    for _, value in ipairs(tbl) do
        local username = _trim(value)
        if username ~= "" and not seen[username] then
            seen[username] = true
            out[#out + 1] = username
        end
    end
    return out
end

function AACS.AllowListToString(tbl)
    local parts = {}
    for _, username in ipairs(AACS.CloneAllowListArray(tbl)) do
        parts[#parts + 1] = username
    end
    return table.concat(parts, ";")
end

function AACS.StringToAllowList(str)
    local out, seen = {}, {}
    str = tostring(str or "")
    if str == "" then
        return out
    end
    for raw in string.gmatch(str, "([^;]+)") do
        local username = _trim(raw)
        if username ~= "" and not seen[username] then
            seen[username] = true
            out[#out + 1] = username
        end
    end
    return out
end

function AACS.AllowListContains(listValue, username)
    username = _trim(username)
    if username == "" then return false end

    if type(listValue) == "table" then
        for _, u in ipairs(listValue) do
            if u == username then
                return true
            end
        end
        return false
    end

    local list = AACS.StringToAllowList(listValue)
    for _, u in ipairs(list) do
        if u == username then
            return true
        end
    end
    return false
end

function AACS.GetAnimalUID(animal)
    if not animal or not animal.getModData then return nil end
    local md = animal:getModData()
    return md and md[AACS.MD_UID] or nil
end

function AACS.GetAnimalOwner(animal)
    if not animal or not animal.getModData then return nil end
    local md = animal:getModData()
    return md and md[AACS.MD_OWNER] or nil
end

function AACS.GetAnimalNickname(animal)
    if not animal or not animal.getModData then return nil end
    local md = animal:getModData()
    return md and md[AACS.MD_NICKNAME] or nil
end

function AACS.SetAnimalNickname(animal, nickname)
    if not animal or not animal.getModData then return end
    local md = animal:getModData()
    if md then
        md[AACS.MD_NICKNAME] = _firstNonEmpty(nickname)
    end
end

function AACS.IsClaimed(animal)
    return AACS.GetAnimalUID(animal) ~= nil
end

function AACS.GetAnimalFromInventoryItem(item)
    if not item then return nil end
    if item.getAnimal and type(item.getAnimal) == "function" then
        local okAnimal, animal = pcall(function() return item:getAnimal() end)
        if okAnimal and animal then
            return animal
        end
    end
    return nil
end

function AACS.GetItemUID(item)
    local md = _getItemModData(item)
    return md and md[AACS.ITEM_MD_UID] or nil
end

function AACS.GetAnimalBestName(animal)
    if not animal then return "" end

    local function safeCall(fn)
        local ok, res = pcall(fn)
        if ok and res ~= nil then
            local s = tostring(res)
            if s ~= "" then return s end
        end
        return nil
    end

    local n = nil
    if animal.getFullName then
        n = safeCall(function() return animal:getFullName() end)
    end
    if not n and animal.getDisplayName then
        n = safeCall(function() return animal:getDisplayName() end)
    end
    if not n and animal.getName then
        n = safeCall(function() return animal:getName() end)
    end
    return n or ""
end

function AACS.GetAnimalTypeName(animal)
    if not animal or not animal.getAnimalType then
        return "animal"
    end
    local okType, animalType = pcall(function() return animal:getAnimalType() end)
    if okType and animalType ~= nil and tostring(animalType) ~= "" then
        return tostring(animalType)
    end
    return "animal"
end

function AACS.NormalizeTransportSignature(signature)
    return _normText(signature)
end

function AACS.BuildTransportSignature(animal)
    if not animal then return "" end
    local parts = {
        AACS.NormalizeTransportSignature(AACS.GetAnimalTypeName(animal)),
        AACS.NormalizeTransportSignature(AACS.GetAnimalBestName(animal)),
        AACS.NormalizeTransportSignature(AACS.GetAnimalNickname(animal)),
    }
    return table.concat(parts, "|")
end

function AACS.BuildEntryTransportSignature(entry)
    if not entry then return "" end
    local parts = {
        AACS.NormalizeTransportSignature(entry.AnimalType or "animal"),
        AACS.NormalizeTransportSignature(entry.AnimalName or ""),
        AACS.NormalizeTransportSignature(entry.Nickname or ""),
    }
    return table.concat(parts, "|")
end

function AACS.EnsureEntrySchema(entry)
    if not entry then return nil end

    entry.SchemaVersion = AACS.REGISTRY_SCHEMA_VERSION
    entry.Owner = tostring(entry.Owner or "")
    entry.PickupMode = AACS.SanitizeMode(tonumber(entry.PickupMode) or AACS.MODE_OWNER_ONLY)
    entry.LeashMode = AACS.SanitizeMode(tonumber(entry.LeashMode) or AACS.MODE_OWNER_ONLY)

    if type(entry.AllowList) == "string" then
        entry.AllowList = AACS.StringToAllowList(entry.AllowList)
    else
        entry.AllowList = AACS.CloneAllowListArray(entry.AllowList)
    end

    entry.AnimalType = _firstNonEmpty(entry.AnimalType, "animal")
    entry.AnimalName = tostring(entry.AnimalName or "")
    entry.Nickname = _firstNonEmpty(entry.Nickname)

    local bestX = _firstNumber(entry.LastX, entry.LastWorldX, 0) or 0
    local bestY = _firstNumber(entry.LastY, entry.LastWorldY, 0) or 0
    local bestZ = _firstNumber(entry.LastZ, entry.LastWorldZ, 0) or 0

    entry.LastX = bestX
    entry.LastY = bestY
    entry.LastZ = bestZ
    entry.LastWorldX = _firstNumber(entry.LastWorldX, entry.LastX, 0) or 0
    entry.LastWorldY = _firstNumber(entry.LastWorldY, entry.LastY, 0) or 0
    entry.LastWorldZ = _firstNumber(entry.LastWorldZ, entry.LastZ, 0) or 0

    local transportKind = tostring(entry.TransportKind or "")
    if transportKind ~= AACS.TRANSPORT_INVENTORY and
       transportKind ~= AACS.TRANSPORT_TRAILER and
       transportKind ~= AACS.TRANSPORT_HUTCH then
        transportKind = AACS.TRANSPORT_WORLD
    end
    entry.TransportKind = transportKind

    entry.CarrierUsername = _firstNonEmpty(entry.CarrierUsername)
    entry.VehicleId = _firstNonEmpty(entry.VehicleId)

    if transportKind == AACS.TRANSPORT_HUTCH then
        entry.HutchX = _firstNumber(entry.HutchX, entry.LastX)
        entry.HutchY = _firstNumber(entry.HutchY, entry.LastY)
        entry.HutchZ = _firstNumber(entry.HutchZ, entry.LastZ)
    else
        entry.HutchX = _firstNumber(entry.HutchX)
        entry.HutchY = _firstNumber(entry.HutchY)
        entry.HutchZ = _firstNumber(entry.HutchZ)
    end

    entry.TransportSignature = AACS.NormalizeTransportSignature(
        _firstNonEmpty(entry.TransportSignature, AACS.BuildEntryTransportSignature(entry))
    )
    entry.LastSeen = tonumber(entry.LastSeen) or AACS.Now()
    return entry
end

function AACS.BuildClaimFromEntry(entry)
    entry = AACS.EnsureEntrySchema(entry)
    if not entry or not entry.UID then
        return nil
    end
    return {
        UID = tostring(entry.UID),
        Owner = tostring(entry.Owner or ""),
        Nickname = _firstNonEmpty(entry.Nickname),
        PickupMode = AACS.SanitizeMode(entry.PickupMode),
        LeashMode = AACS.SanitizeMode(entry.LeashMode),
        AllowList = AACS.CloneAllowListArray(entry.AllowList),
        LastX = _firstNumber(entry.LastX, entry.LastWorldX),
        LastY = _firstNumber(entry.LastY, entry.LastWorldY),
        LastZ = _firstNumber(entry.LastZ, entry.LastWorldZ),
        LastSeen = tonumber(entry.LastSeen) or AACS.Now(),
        TransportKind = entry.TransportKind,
        CarrierUsername = entry.CarrierUsername,
        VehicleId = entry.VehicleId,
        HutchX = entry.HutchX,
        HutchY = entry.HutchY,
        HutchZ = entry.HutchZ,
        TransportSignature = AACS.NormalizeTransportSignature(entry.TransportSignature),
    }
end

local function _snapshotFromModData(md)
    if not md then return nil end
    local uid = _firstNonEmpty(md[AACS.MD_UID])
    if not uid then return nil end
    return {
        UID = uid,
        Owner = _firstNonEmpty(md[AACS.MD_OWNER], ""),
        Nickname = _firstNonEmpty(md[AACS.MD_NICKNAME]),
        PickupMode = AACS.SanitizeMode(md[AACS.MD_PICKUPMODE]),
        LeashMode = AACS.SanitizeMode(md[AACS.MD_LEASHMODE]),
        AllowList = AACS.StringToAllowList(md[AACS.MD_ALLOWLIST]),
        LastX = _firstNumber(md[AACS.MD_LASTX]),
        LastY = _firstNumber(md[AACS.MD_LASTY]),
        LastZ = _firstNumber(md[AACS.MD_LASTZ]),
        LastSeen = tonumber(md[AACS.MD_LASTSEEN]) or AACS.Now(),
    }
end

function AACS.CaptureClaimSnapshotFromAnimal(animal)
    if not animal or not animal.getModData then return nil end
    return _snapshotFromModData(animal:getModData())
end

function AACS.CaptureClaimSnapshotFromItem(item)
    if not item then return nil end

    local md = _getItemModData(item)
    if md then
        local uid = _firstNonEmpty(md[AACS.ITEM_MD_UID])
        if uid then
            return {
                UID = uid,
                Owner = _firstNonEmpty(md[AACS.ITEM_MD_OWNER], ""),
                Nickname = _firstNonEmpty(md[AACS.ITEM_MD_NICKNAME]),
                PickupMode = AACS.SanitizeMode(md[AACS.ITEM_MD_PICKUPMODE]),
                LeashMode = AACS.SanitizeMode(md[AACS.ITEM_MD_LEASHMODE]),
                AllowList = AACS.StringToAllowList(md[AACS.ITEM_MD_ALLOWLIST]),
                LastSeen = AACS.Now(),
            }
        end
    end

    return AACS.CaptureClaimSnapshotFromAnimal(AACS.GetAnimalFromInventoryItem(item))
end

function AACS.WriteClaimSnapshotToItem(item, snapshot)
    local md = _getItemModData(item)
    if not md then return end

    snapshot = snapshot or AACS.CaptureClaimSnapshotFromAnimal(AACS.GetAnimalFromInventoryItem(item))
    if not snapshot or not snapshot.UID then
        AACS.ClearClaimSnapshotFromItem(item)
        return
    end

    md[AACS.ITEM_MD_SCHEMA] = AACS.REGISTRY_SCHEMA_VERSION
    md[AACS.ITEM_MD_UID] = tostring(snapshot.UID)
    md[AACS.ITEM_MD_OWNER] = tostring(snapshot.Owner or "")
    md[AACS.ITEM_MD_PICKUPMODE] = AACS.SanitizeMode(snapshot.PickupMode)
    md[AACS.ITEM_MD_LEASHMODE] = AACS.SanitizeMode(snapshot.LeashMode)
    md[AACS.ITEM_MD_ALLOWLIST] = AACS.AllowListToString(snapshot.AllowList)
    md[AACS.ITEM_MD_NICKNAME] = _firstNonEmpty(snapshot.Nickname)

    local animal = AACS.GetAnimalFromInventoryItem(item)
    if animal then
        AACS.ApplyClaimSnapshotToAnimal(animal, snapshot)
    end
end

function AACS.ClearClaimSnapshotFromItem(item)
    local md = _getItemModData(item)
    if not md then return end
    md[AACS.ITEM_MD_SCHEMA] = nil
    md[AACS.ITEM_MD_UID] = nil
    md[AACS.ITEM_MD_OWNER] = nil
    md[AACS.ITEM_MD_PICKUPMODE] = nil
    md[AACS.ITEM_MD_LEASHMODE] = nil
    md[AACS.ITEM_MD_ALLOWLIST] = nil
    md[AACS.ITEM_MD_NICKNAME] = nil
end

function AACS.SetAnimalClaimModData(animal, entry)
    if not animal or not entry then return end
    local claim = entry.UID and AACS.BuildClaimFromEntry(entry) or entry
    if not claim or not claim.UID then return end

    local md = animal:getModData()
    md[AACS.MD_UID] = tostring(claim.UID)
    md[AACS.MD_OWNER] = tostring(claim.Owner or "")
    md[AACS.MD_NICKNAME] = _firstNonEmpty(claim.Nickname)
    md[AACS.MD_PICKUPMODE] = AACS.SanitizeMode(claim.PickupMode)
    md[AACS.MD_LEASHMODE] = AACS.SanitizeMode(claim.LeashMode)
    md[AACS.MD_ALLOWLIST] = AACS.AllowListToString(claim.AllowList)
    md[AACS.MD_LASTX] = _firstNumber(claim.LastX)
    md[AACS.MD_LASTY] = _firstNumber(claim.LastY)
    md[AACS.MD_LASTZ] = _firstNumber(claim.LastZ)
    md[AACS.MD_LASTSEEN] = tonumber(claim.LastSeen) or AACS.Now()
    _clearOnServer(animal)
end

function AACS.ApplyClaimSnapshotToAnimal(animal, snapshot)
    if not animal or not snapshot or not snapshot.UID then return end
    AACS.SetAnimalClaimModData(animal, snapshot)
end

function AACS.ClearAnimalClaimModData(animal)
    if not animal then return end
    local md = animal:getModData()
    md[AACS.MD_UID] = nil
    md[AACS.MD_OWNER] = nil
    md[AACS.MD_NICKNAME] = nil
    md[AACS.MD_PICKUPMODE] = nil
    md[AACS.MD_LEASHMODE] = nil
    md[AACS.MD_ALLOWLIST] = nil
    md[AACS.MD_LASTX] = nil
    md[AACS.MD_LASTY] = nil
    md[AACS.MD_LASTZ] = nil
    md[AACS.MD_LASTSEEN] = nil
    _clearOnServer(animal)
end

function AACS.GetModeLabel(mode)
    if mode == AACS.MODE_OWNER_ONLY then return getText("IGUI_AACS_Mode1") end
    if mode == AACS.MODE_SAFEHOUSE then return getText("IGUI_AACS_Mode2") end
    if mode == AACS.MODE_FACTION then return getText("IGUI_AACS_Mode3") end
    if mode == AACS.MODE_SAFE_OR_FACT then return getText("IGUI_AACS_Mode4") end
    return tostring(mode)
end

function AACS.IsSafehouseMember(ownerUsername, username)
    if not _sv().AllowSafehouse then return false end
    if not ownerUsername or not username then return false end
    if not SafeHouse or not SafeHouse.hasSafehouse then return false end
    local safehouseObj = SafeHouse.hasSafehouse(ownerUsername)
    if not safehouseObj then return false end

    local players = safehouseObj:getPlayers()
    if players then
        local matched = _iterJavaList(players, function(value)
            return value == username
        end)
        if matched then return true end
    end

    local ok, owner = pcall(function() return safehouseObj:getOwner() end)
    if ok and owner == username then return true end
    return false
end

function AACS.IsFactionMember(ownerUsername, username)
    if not _sv().AllowFaction then return false end
    if not ownerUsername or not username then return false end
    if not Faction or not Faction.getPlayerFaction then return false end
    local factionObj = Faction.getPlayerFaction(ownerUsername)
    if not factionObj then return false end

    local ok, owner = pcall(function() return factionObj:getOwner() end)
    if ok and owner == username then return true end

    local players = factionObj:getPlayers()
    if players then
        local matched = _iterJavaList(players, function(value)
            return value == username
        end)
        if matched then return true end
    end
    return false
end

function AACS.CanPlayerDoClaim(playerObj, claim, action)
    if not playerObj then return false end
    if not claim or not claim.UID then return true end

    local username = playerObj:getUsername()
    if not username or username == "" then
        return false
    end

    if claim.Owner == username then return true end

    local svAACS = _sv()
    local adminBypassEnabled = (svAACS == nil) or (svAACS.AdminBypass ~= false)
    if adminBypassEnabled and AACS.IsAdmin(playerObj) then
        return true
    end

    if AACS.AllowListContains(claim.AllowList, username) then
        return true
    end

    if action == "kill" then
        return false
    end

    local mode = AACS.MODE_OWNER_ONLY
    if action == "pickup" then
        mode = AACS.SanitizeMode(claim.PickupMode)
    elseif action == "leash" then
        mode = AACS.SanitizeMode(claim.LeashMode)
    end

    if mode == AACS.MODE_SAFEHOUSE then
        return AACS.IsSafehouseMember(claim.Owner, username)
    elseif mode == AACS.MODE_FACTION then
        return AACS.IsFactionMember(claim.Owner, username)
    elseif mode == AACS.MODE_SAFE_OR_FACT then
        return AACS.IsSafehouseMember(claim.Owner, username) or AACS.IsFactionMember(claim.Owner, username)
    end

    return false
end

function AACS.CanPlayerDoEntry(playerObj, entry, action)
    return AACS.CanPlayerDoClaim(playerObj, AACS.BuildClaimFromEntry(entry), action)
end

function AACS.CanPlayerDo(playerObj, animal, action)
    return AACS.CanPlayerDoClaim(playerObj, AACS.CaptureClaimSnapshotFromAnimal(animal), action)
end

function AACS.ApplyTransportState(entry, args)
    entry = AACS.EnsureEntrySchema(entry)
    if not entry then return nil end
    args = args or {}

    local targetKind = tostring(args.targetKind or args.TransportKind or entry.TransportKind or AACS.TRANSPORT_WORLD)
    if targetKind ~= AACS.TRANSPORT_INVENTORY and
       targetKind ~= AACS.TRANSPORT_TRAILER and
       targetKind ~= AACS.TRANSPORT_HUTCH then
        targetKind = AACS.TRANSPORT_WORLD
    end

    local lastSeen = tonumber(args.lastSeen or args.LastSeen or args.ts) or AACS.Now()
    local worldX = _firstNumber(args.worldX, args.LastWorldX)
    local worldY = _firstNumber(args.worldY, args.LastWorldY)
    local worldZ = _firstNumber(args.worldZ, args.LastWorldZ)
    local slotX = _firstNumber(args.x, args.lastX, args.containerX, args.hutchX)
    local slotY = _firstNumber(args.y, args.lastY, args.containerY, args.hutchY)
    local slotZ = _firstNumber(args.z, args.lastZ, args.containerZ, args.hutchZ)

    if worldX ~= nil then entry.LastWorldX = worldX end
    if worldY ~= nil then entry.LastWorldY = worldY end
    if worldZ ~= nil then entry.LastWorldZ = worldZ end

    if targetKind == AACS.TRANSPORT_WORLD then
        entry.LastX = _firstNumber(slotX, entry.LastWorldX, entry.LastX, 0) or 0
        entry.LastY = _firstNumber(slotY, entry.LastWorldY, entry.LastY, 0) or 0
        entry.LastZ = _firstNumber(slotZ, entry.LastWorldZ, entry.LastZ, 0) or 0
        entry.CarrierUsername = nil
        entry.VehicleId = nil
        entry.HutchX = nil
        entry.HutchY = nil
        entry.HutchZ = nil
    elseif targetKind == AACS.TRANSPORT_INVENTORY then
        entry.LastX = _firstNumber(slotX, entry.LastX, entry.LastWorldX, 0) or 0
        entry.LastY = _firstNumber(slotY, entry.LastY, entry.LastWorldY, 0) or 0
        entry.LastZ = _firstNumber(slotZ, entry.LastZ, entry.LastWorldZ, 0) or 0
        entry.CarrierUsername = _firstNonEmpty(args.carrierUsername, args.CarrierUsername, entry.Owner)
        entry.VehicleId = nil
        entry.HutchX = nil
        entry.HutchY = nil
        entry.HutchZ = nil
    elseif targetKind == AACS.TRANSPORT_TRAILER then
        entry.LastX = _firstNumber(slotX, entry.LastX, entry.LastWorldX, 0) or 0
        entry.LastY = _firstNumber(slotY, entry.LastY, entry.LastWorldY, 0) or 0
        entry.LastZ = _firstNumber(slotZ, entry.LastZ, entry.LastWorldZ, 0) or 0
        entry.CarrierUsername = nil
        entry.VehicleId = _firstNonEmpty(args.vehicleId, args.VehicleId, entry.VehicleId)
        entry.HutchX = nil
        entry.HutchY = nil
        entry.HutchZ = nil
    elseif targetKind == AACS.TRANSPORT_HUTCH then
        entry.HutchX = _firstNumber(args.hutchX, args.HutchX, slotX, entry.HutchX, entry.LastX, 0) or 0
        entry.HutchY = _firstNumber(args.hutchY, args.HutchY, slotY, entry.HutchY, entry.LastY, 0) or 0
        entry.HutchZ = _firstNumber(args.hutchZ, args.HutchZ, slotZ, entry.HutchZ, entry.LastZ, 0) or 0
        entry.LastX = entry.HutchX
        entry.LastY = entry.HutchY
        entry.LastZ = entry.HutchZ
        entry.CarrierUsername = nil
        entry.VehicleId = nil
    end

    local signature = AACS.NormalizeTransportSignature(
        _firstNonEmpty(args.transportSignature, args.TransportSignature, entry.TransportSignature, AACS.BuildEntryTransportSignature(entry))
    )
    entry.TransportKind = targetKind
    entry.TransportSignature = signature
    entry.LastSeen = lastSeen
    return entry
end

function AACS.MakeEntry(ownerUsername, animal, uid)
    local sq = animal and animal.getSquare and animal:getSquare() or nil
    local x, y, z = 0, 0, 0
    if sq then x, y, z = sq:getX(), sq:getY(), sq:getZ() end

    local entry = {
        UID = uid,
        Owner = ownerUsername,
        AnimalType = AACS.GetAnimalTypeName(animal),
        AnimalName = AACS.GetAnimalBestName(animal),
        Nickname = AACS.GetAnimalNickname(animal),
        PickupMode = AACS.SanitizeMode(_sv().DefaultPickupMode or AACS.MODE_OWNER_ONLY),
        LeashMode = AACS.SanitizeMode(_sv().DefaultLeashMode or AACS.MODE_OWNER_ONLY),
        AllowList = {},
        LastX = x,
        LastY = y,
        LastZ = z,
        LastWorldX = x,
        LastWorldY = y,
        LastWorldZ = z,
        TransportKind = AACS.TRANSPORT_WORLD,
        TransportSignature = AACS.BuildTransportSignature(animal),
        LastSeen = AACS.Now(),
        SchemaVersion = AACS.REGISTRY_SCHEMA_VERSION,
    }
    return AACS.EnsureEntrySchema(entry)
end

function AACS.FormatLocation(entry)
    if not entry then return "-" end
    entry = AACS.EnsureEntrySchema(entry)
    return string.format("%d, %d, %d", tonumber(entry.LastX) or 0, tonumber(entry.LastY) or 0, tonumber(entry.LastZ) or 0)
end

function AACS.FormatLastSeen(entry)
    if not entry or not entry.LastSeen then return "-" end
    local ms = tonumber(entry.LastSeen) or 0
    local seconds = math.floor(ms / 1000)
    return tostring(seconds)
end

AACS.DOCUMENT_ITEM = "Base.DocumentPet"

function AACS.RequiresDocument()
    return _sv().RequireDocumentToAdopt == true
end

function AACS.ShouldReturnDocument()
    return _sv().ReturnDocumentOnUnadopt == true
end

function AACS.GetMaxAnimalsPerPlayer()
    local v = tonumber(_sv().MaxAdoptedAnimalsPerPlayer) or 0
    if v < 0 then v = 0 end
    return v
end

function AACS.CountPlayerAdoptions(username)
    if not username or username == "" then return 0 end
    local count = 0

    if isServer and isServer() then
        local reg = ModData.getOrCreate(AACS.REGISTRY_KEY)
        for _, e in pairs(reg) do
            e = AACS.EnsureEntrySchema(e)
            if e and e.Owner == username then
                count = count + 1
            end
        end
    elseif isClient and isClient() then
        if AACS.ClientCache and AACS.ClientCache.myEntries then
            count = #AACS.ClientCache.myEntries
        end
    else
        local reg = ModData.getOrCreate(AACS.REGISTRY_KEY)
        for _, e in pairs(reg) do
            e = AACS.EnsureEntrySchema(e)
            if e and e.Owner == username then
                count = count + 1
            end
        end
    end

    return count
end

function AACS.IsAtAdoptionLimit(username)
    local max = AACS.GetMaxAnimalsPerPlayer()
    if max <= 0 then return false end
    return AACS.CountPlayerAdoptions(username) >= max
end

function AACS.PlayerHasDocument(playerObj)
    if not playerObj then return false end
    local inv = playerObj:getInventory()
    if not inv then return false end
    local item = inv:getFirstTypeRecurse(AACS.DOCUMENT_ITEM)
    return item ~= nil
end

function AACS.SP_GetRegistry()
    if not ModData or not ModData.getOrCreate then return {} end
    return ModData.getOrCreate(AACS.REGISTRY_KEY)
end
