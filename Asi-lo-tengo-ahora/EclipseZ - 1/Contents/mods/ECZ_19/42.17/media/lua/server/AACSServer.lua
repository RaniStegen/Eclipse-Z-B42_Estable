-- AACSServer.lua (Build 42 / MP-safe)
-- Server-side adoption registry + validation. Server is source of truth.

if not isServer() then return end

local ok = pcall(require, "AACSShared")
if not ok then return end
pcall(require, "AACSOverrideShared")

AACS = AACS or {}

local function _t(key, ...)
    local msg = getText(key)
    local args = { ... }
    for i = 1, #args do
        msg = msg:gsub("%%" .. i, tostring(args[i]))
    end
    return msg
end

local function _registry()
    return ModData.getOrCreate(AACS.REGISTRY_KEY)
end

local function _meta()
    return ModData.getOrCreate(AACS.REGISTRY_META_KEY or "AACS_RegistryMeta")
end

-- Sequential, persistent UID generator (01, 02, 03...).
-- Server-only, MP-safe: single source of truth + persisted in ModData.
function AACS.NextSequentialUID()
    local meta = _meta()
    local reg = _registry()

    -- Seed counter from existing numeric UIDs (if any)
    if meta.Counter == nil then
        local maxN = 0
        for uid, _ in pairs(reg) do
            -- Only seed from sequential-style IDs (avoid old timestamp-style IDs)
            if type(uid) == "string" and #uid <= 6 then
                local n = tonumber(uid)
                if n and n > maxN then maxN = n end
            end
        end
        meta.Counter = maxN
    end

    local n = tonumber(meta.Counter) or 0
    local uid = nil

    -- Find next free id (avoid collisions)
    for _i = 1, 1000000 do
        n = n + 1
        uid = string.format("%02d", n)
        if not reg[uid] then
            meta.Counter = n
            return uid
        end
    end

    -- Fallback (should never happen)
    return tostring(AACS.Now())
end


local function _isAdmin(playerObj)
    return AACS.IsAdmin(playerObj)
end

local function _sv()
    return (SandboxVars and SandboxVars.AACS) or {}
end

local function _iterList(listObj, fn)
    if not listObj or not fn then return false end

    if type(listObj) == "table" then
        for _, v in ipairs(listObj) do
            if fn(v) == true then return true end
        end
        return false
    end

    local iteratorFn = nil
    pcall(function() iteratorFn = listObj.iterator end)
    -- Some B42 collections expose only an iterator on dedicated servers.
    local okIter, it = false, nil
    if type(iteratorFn) == "function" then
        okIter, it = pcall(function() return iteratorFn(listObj) end)
    end
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

    local sizeFn = nil
    pcall(function() sizeFn = listObj.size end)
    local okSize, size = false, nil
    if type(sizeFn) == "function" then
        okSize, size = pcall(function() return sizeFn(listObj) end)
    end
    size = okSize and tonumber(size) or nil
    if size ~= nil and size > 0 then
        local getFn = nil
        pcall(function() getFn = listObj.get end)
        if type(getFn) ~= "function" then
            return false
        end
        for i = 0, size - 1 do
            local okItem, v = pcall(function() return getFn(listObj, i) end)
            if okItem and fn(v) == true then
                return true
            end
        end
        return false
    end

    return false
end

local function _playersOnline()
    local t = {}
    _iterList(getOnlinePlayers(), function(player)
        t[#t + 1] = player
    end)
    return t
end

local function _broadcastToAdmins(cmd, args)
    for _, p in ipairs(_playersOnline()) do
        if _isAdmin(p) then
            sendServerCommand(p, "AACS", cmd, args)
        end
    end
end

local function _notify(playerObj, msg, kind)
    sendServerCommand(playerObj, "AACS", "notify", { msg = msg, kind = kind or "info" })
end

-- MP-safe localization:
-- Instead of translating on the server (which may not have the same language
-- or may not have translation tables loaded), send the translation key + args
-- and let each client translate locally.
local function _notifyKey(playerObj, key, kind, ...)
    sendServerCommand(playerObj, "AACS", "notify", { key = key, args = { ... }, kind = kind or "info" })
end

local function _copyPlainTable(src)
    local out = {}
    if type(src) ~= "table" then
        return out
    end
    for k, v in pairs(src) do
        if k ~= nil and v ~= nil then
            out[tostring(k)] = tonumber(v) or v
        end
    end
    return out
end

local function _getSquare(x,y,z)
    local cell = getCell()
    if not cell then return nil end
    return cell:getGridSquare(x, y, z)
end

local function _getAnimalByOnlineId(animalId)
    if not animalId then return nil end
    local key = tostring(animalId)

    AACS._animalIdCache = AACS._animalIdCache or { map = {}, nextRefresh = 0 }
    local cache = AACS._animalIdCache
    local now = getTimestamp()

    if now >= (cache.nextRefresh or 0) or not cache.map[key] then
        cache.map = {}
        cache.nextRefresh = now + 2 -- seconds

        local cell = getCell()
        if cell then
            local allObjects = cell:getObjectList()
            if allObjects then
                _iterList(allObjects, function(obj)
                    if _isAnimalObject(obj) then
                        local objId = nil
                        pcall(function() objId = obj:getOnlineID() end)
                        if objId then
                            cache.map[tostring(objId)] = obj
                        end
                    end
                end)
            end
        end
    end

    return cache.map[key]
end

local function _getOrCreateSquare(x, y, z)
    local cell = getCell()
    if not cell then return nil end

    local sq = cell:getGridSquare(x, y, z)
    if sq then return sq end

    -- Some servers don't have the square loaded yet; try to create/load if supported.
    if cell.getOrCreateGridSquare then
        local ok, created = pcall(function() return cell:getOrCreateGridSquare(x, y, z) end)
        if ok and created then return created end
    end

    return nil
end

local function _teleportPlayerTo(playerObj, x, y, z)
    -- MP note: server should initiate and confirm, but chunk-loading can vary.
    -- We therefore: (1) try server teleport without requiring a loaded square,
    -- (2) best-effort set square if available, (3) instruct client to force-teleport as a fallback.
    if not playerObj then return false end

    local px, py = x + 0.5, y + 0.5
    local did = false

    -- Try built-in teleport first (most reliable when available).
    if playerObj.teleportTo then
        local ok = pcall(function() playerObj:teleportTo(px, py, z) end)
        if ok then did = true end
    end

    -- Fallback: set raw coordinates even if the destination chunk isn't loaded.
    if not did then
        pcall(function() if playerObj.setX then playerObj:setX(px) end end)
        pcall(function() if playerObj.setY then playerObj:setY(py) end end)
        pcall(function() if playerObj.setZ then playerObj:setZ(z) end end)

        pcall(function() if playerObj.setLx then playerObj:setLx(px) end end)
        pcall(function() if playerObj.setLy then playerObj:setLy(py) end end)
        pcall(function() if playerObj.setLz then playerObj:setLz(z) end end)

        did = true
    end

    -- Best-effort: bind to a loaded square if it exists (helps some MP sync paths).
    local sq = _getSquare(x, y, z)
    if not sq then
        -- _getOrCreateSquare may still return nil if the chunk isn't loaded server-side; that's OK.
        sq = _getOrCreateSquare(x, y, z)
    end
    if sq then
        pcall(function() if playerObj.setSquare then playerObj:setSquare(sq) end end)
        pcall(function() if playerObj.setCurrentSquare then playerObj:setCurrentSquare(sq) end end)
        pcall(function() if playerObj.setCurrent then playerObj:setCurrent(sq) end end)
    end

    -- Nudge network sync (API varies by patch; keep pcall safe).
    pcall(function() if playerObj.sendObjectChange then playerObj:sendObjectChange("teleport") end end)

    -- Client fallback: force local teleport to avoid "nothing happens" when chunk isn't server-loaded yet.
    sendServerCommand(playerObj, "AACS", "forceTeleport", { x = px, y = py, z = z })

    return did
end



local function _isAnimalObject(o)
    if not o then return false end
    
    -- Gold standard: instanceof IsoAnimal is the ONLY reliable check in B42.
    local isAnimal = false
    pcall(function()
        isAnimal = instanceof(o, "IsoAnimal")
    end)
    if isAnimal then return true end

    -- Blacklist: reject known non-animal types BEFORE any fallback.
    local isBlacklisted = false
    pcall(function()
        isBlacklisted = instanceof(o, "IsoZombie") or instanceof(o, "IsoPlayer") or
                        instanceof(o, "IsoSurvivor") or instanceof(o, "IsoVehicle") or
                        instanceof(o, "IsoDeadBody")
    end)
    if isBlacklisted then return false end

    -- Secondary: IsoMovingObject with isAnimal() == true
    local isMoving = false
    pcall(function()
        isMoving = instanceof(o, "IsoMovingObject")
    end)
    
    if isMoving then
        if o.isAnimal and type(o.isAnimal) == "function" then
            local ok, res = pcall(function()
                return o:isAnimal()
            end)
            if ok and res == true then return true end
        end
        -- NOTE: Do NOT use getAnimalType/getAnimalID/getAnimalDef as heuristics!
        -- getAnimalType() exists on IsoPlayer too and causes false positives.
    end
    
    return false
end

local function _getAnimalDisplayName(animal)
    if not animal then return nil end
    if animal.getDisplayName then
        local ok, n = pcall(function() return animal:getDisplayName() end)
        if ok and n and n ~= "" then return n end
    end
    if animal.getFullName then
        local ok, n = pcall(function() return animal:getFullName() end)
        if ok and n and n ~= "" then return n end
    end
    if animal.getName then
        local ok, n = pcall(function() return animal:getName() end)
        if ok and n and n ~= "" then return n end
    end
    return nil
end

local function _normName(s)
    if not s then return nil end
    s = tostring(s)
    s = s:gsub("<[^>]+>", "")
    s = s:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return s:lower()
end

local function _captureAnimalTransportSignature(animal)
    if not animal then return "" end
    return AACS.NormalizeTransportSignature(AACS.BuildTransportSignature(animal))
end

local function _extractVehicleId(value)
    if value == nil then return nil end

    if type(value) == "string" or type(value) == "number" then
        local text = tostring(value)
        if text ~= "" then
            return text
        end
        return nil
    end

    if type(value) == "table" then
        local candidates = {
            value.vehicleId, value.VehicleId, value.vehicleID,
            value.sqlId, value.SqlId, value.vehicle, value.trailer,
        }
        for _, candidate in ipairs(candidates) do
            local found = _extractVehicleId(candidate)
            if found then
                return found
            end
        end
        return nil
    end

    local probes = { "getId", "getVehicleID", "getSqlId", "getID" }
    for _, fnName in ipairs(probes) do
        local fn = value[fnName]
        if type(fn) == "function" then
            local okValue, out = pcall(function() return fn(value) end)
            if okValue and out ~= nil and tostring(out) ~= "" then
                return tostring(out)
            end
        end
    end

    return nil
end

local function _extractHutchCoords(value)
    if not value then return nil, nil, nil end

    if type(value) == "table" then
        local x = tonumber(value.hutchX or value.HutchX or value.x or value.X)
        local y = tonumber(value.hutchY or value.HutchY or value.y or value.Y)
        local z = tonumber(value.hutchZ or value.HutchZ or value.z or value.Z)
        if x ~= nil and y ~= nil and z ~= nil then
            return x, y, z
        end
        if value.hutch then
            return _extractHutchCoords(value.hutch)
        end
    end

    if value.getSquare and type(value.getSquare) == "function" then
        local okSq, sq = pcall(function() return value:getSquare() end)
        if okSq and sq then
            return sq:getX(), sq:getY(), sq:getZ()
        end
    end

    return nil, nil, nil
end

local function _resolveCommandAnimal(args)
    if not args then return nil end

    local function scanCandidate(candidate)
        if not candidate then return nil end
        if _isAnimalObject(candidate) then
            return candidate
        end
        if type(candidate) == "table" then
            local nestedKeys = {
                "animal", "target", "object", "movingObject", "isoAnimal", "animalObj"
            }
            for _, key in ipairs(nestedKeys) do
                local nested = scanCandidate(candidate[key])
                if nested then
                    return nested
                end
            end
        end
        return nil
    end

    local directKeys = {
        "animal", "target", "object", "movingObject", "isoAnimal", "animalObj"
    }
    for _, key in ipairs(directKeys) do
        local animal = scanCandidate(args[key])
        if animal then
            return animal
        end
    end

    local animalId = args.animalId or args.onlineId or args.objectId
    if animalId == nil then
        local maybeId = args.id
        if maybeId ~= nil and not (args.vehicleId or args.VehicleId or args.vehicle or args.trailer) then
            animalId = maybeId
        end
    end
    if animalId ~= nil then
        return _getAnimalByOnlineId(animalId)
    end

    return nil
end

local function _findEntryByUID(uid)
    uid = uid and tostring(uid) or ""
    if uid == "" then return nil end
    local reg = _registry()
    local entry = reg[uid]
    if not entry then return nil end
    return AACS.EnsureEntrySchema(entry)
end

local function _entryTransportMatches(entry, kind, params)
    entry = AACS.EnsureEntrySchema(entry)
    if not entry or entry.TransportKind ~= kind then
        return false
    end

    params = params or {}
    local wantSignature = AACS.NormalizeTransportSignature(params.transportSignature or "")
    local entrySignature = AACS.NormalizeTransportSignature(entry.TransportSignature or AACS.BuildEntryTransportSignature(entry))

    if wantSignature ~= "" and entrySignature ~= wantSignature then
        return false
    end

    if kind == AACS.TRANSPORT_TRAILER then
        local wantVehicleId = params.vehicleId and tostring(params.vehicleId) or nil
        return wantVehicleId ~= nil and tostring(entry.VehicleId or "") == wantVehicleId
    end

    if kind == AACS.TRANSPORT_HUTCH then
        local hx, hy, hz = tonumber(params.hutchX), tonumber(params.hutchY), tonumber(params.hutchZ)
        return tonumber(entry.HutchX) == hx and tonumber(entry.HutchY) == hy and tonumber(entry.HutchZ) == hz
    end

    if kind == AACS.TRANSPORT_WORLD then
        local x = tonumber(params.x)
        local y = tonumber(params.y)
        local z = tonumber(params.z)
        if x == nil or y == nil or z == nil then
            return false
        end

        local ex = tonumber(entry.LastWorldX or entry.LastX) or 0
        local ey = tonumber(entry.LastWorldY or entry.LastY) or 0
        local ez = tonumber(entry.LastWorldZ or entry.LastZ) or 0
        local radius = tonumber(params.radius) or 6
        local d2 = (x - ex) * (x - ex) + (y - ey) * (y - ey)
        return ez == z and d2 <= (radius * radius)
    end

    if kind == AACS.TRANSPORT_INVENTORY then
        local x = tonumber(params.x)
        local y = tonumber(params.y)
        local z = tonumber(params.z)
        if x == nil or y == nil or z == nil then
            return false
        end

        local ex = tonumber(entry.LastX) or 0
        local ey = tonumber(entry.LastY) or 0
        local ez = tonumber(entry.LastZ) or 0
        local radius = tonumber(params.radius) or 5
        local d2 = (x - ex) * (x - ex) + (y - ey) * (y - ey)
        if ez ~= z or d2 > (radius * radius) then
            return false
        end

        local wantCarrier = params.carrierUsername and tostring(params.carrierUsername) or nil
        if wantCarrier and tostring(entry.CarrierUsername or "") ~= wantCarrier then
            return false
        end
        return true
    end

    return false
end

local function _resolveUniqueTransportEntry(kind, params)
    local reg = _registry()
    local matches = {}
    for _, entry in pairs(reg) do
        entry = AACS.EnsureEntrySchema(entry)
        if _entryTransportMatches(entry, kind, params) then
            matches[#matches + 1] = entry
        end
    end

    if #matches == 1 then
        return matches[1], false
    end
    if #matches > 1 then
        return nil, true
    end
    return nil, false
end

local function _findUniqueWorldEntryForAnimal(animal, x, y, z, radius)
    local signature = _captureAnimalTransportSignature(animal)
    if signature == "" then
        return nil, false
    end
    return _resolveUniqueTransportEntry(AACS.TRANSPORT_WORLD, {
        x = x,
        y = y,
        z = z,
        radius = radius or 6,
        transportSignature = signature,
    })
end

local function _findUniqueRestoreEntryForAnimal(animal, x, y, z, radius)
    local signature = _captureAnimalTransportSignature(animal)
    if signature == "" then
        return nil, false
    end

    local entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_WORLD, {
        x = x,
        y = y,
        z = z,
        radius = radius or 5,
        transportSignature = signature,
    })
    if entry or conflict then
        return entry, conflict
    end

    return _resolveUniqueTransportEntry(AACS.TRANSPORT_INVENTORY, {
        x = x,
        y = y,
        z = z,
        radius = radius or 5,
        transportSignature = signature,
    })
end

local function _findLiveAnimalForEntry(entry)
    entry = AACS.EnsureEntrySchema(entry)
    if not entry or entry.TransportKind ~= AACS.TRANSPORT_WORLD then
        return nil
    end

    local uid = tostring(entry.UID or "")
    if uid == "" then
        return nil
    end

    local cell = getCell()
    if not cell then
        return nil
    end

    local objs = nil
    local okObjs = pcall(function() objs = cell:getObjectList() end)
    if not okObjs or not objs then
        return nil
    end

    local found = nil
    _iterList(objs, function(obj)
        if _isAnimalObject(obj) then
            local ouid = AACS.GetAnimalUID(obj)
            if ouid and tostring(ouid) == uid then
                found = obj
                return true
            end
        end
        return false
    end)
    return found
end

local function _findAnimalNear(x, y, z, radius, preferName)
    radius = radius or 2
    local targetNN = _normName(preferName)
    local best, bestScore, bestD2 = nil, -1, 999999

    local function scoreName(animal)
        if not targetNN then return 0 end
        local nn = _normName(_getAnimalDisplayName(animal))
        if not nn then return -1 end
        if nn == targetNN then return 100 end
        if nn:find(targetNN, 1, true) or targetNN:find(nn, 1, true) then return 70 end
        return 10
    end

    for dx = -radius, radius do
        for dy = -radius, radius do
            local sq = _getSquare(x + dx, y + dy, z)
            if sq then
                local lists = {}

                local mov = sq.getMovingObjects and sq:getMovingObjects() or nil
                if mov then lists[#lists+1] = mov end

                if sq.getStaticMovingObjects then
                    local ok, smov = pcall(function() return sq:getStaticMovingObjects() end)
                    if ok and smov then lists[#lists+1] = smov end
                end

                for _, lst in ipairs(lists) do
                    _iterList(lst, function(o)
                        if _isAnimalObject(o) then
                            local sc = scoreName(o)
                            if sc >= 0 then
                                local ox, oy = o:getX(), o:getY()
                                local d2 = (ox - x)*(ox - x) + (oy - y)*(oy - y)
                                if (sc > bestScore) or (sc == bestScore and d2 < bestD2) then
                                    bestScore = sc
                                    bestD2 = d2
                                    best = o
                                end
                            end
                        end
                    end)
                end
            end
        end
    end

    return best
end


-- Find an animal near a location by matching AACS UID in modData (more reliable than name matching).
local function _findAnimalNearByUID(x, y, z, radius, uid)
    radius = radius or 6
    uid = tostring(uid or "")
    if uid == "" then return nil end

    for dx = -radius, radius do
        for dy = -radius, radius do
            local sq = _getSquare(x + dx, y + dy, z)
            if sq then
                local lists = {}

                local mov = sq.getMovingObjects and sq:getMovingObjects() or nil
                if mov then lists[#lists+1] = mov end

                if sq.getStaticMovingObjects then
                    local ok, smov = pcall(function() return sq:getStaticMovingObjects() end)
                    if ok and smov then lists[#lists+1] = smov end
                end

                for _, lst in ipairs(lists) do
                    local found = nil
                    local stopped = _iterList(lst, function(o)
                        if _isAnimalObject(o) then
                            local ouid = AACS.GetAnimalUID(o)
                            if ouid and tostring(ouid) == uid then
                                found = o
                                return true
                            end
                        end
                        return false
                    end)
                    if stopped then
                        return found
                    end
                end
            end
        end
    end

    return nil
end

-- Prefer a stable, descriptive name for registry/UI; prefer getFullName to avoid placeholders.
local function _getAnimalBestName(animal)
    if not animal then return nil end
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
    return n
end

-- Repair older/placeholder entries so the UI doesn't show the same name for everything.
local function _repairEntryName(entry)
    if not entry or not entry.UID then return end
    entry = AACS.EnsureEntrySchema(entry)
    local cur = tostring(entry.AnimalName or "")
    local need = (cur == "")

    -- Common placeholder seen in some setups
    if not need then
        local lc = string.lower(cur)
        if lc == "bob" then need = true end
    end
    if not need then return end

    if entry.TransportKind == AACS.TRANSPORT_WORLD then
        local x = tonumber(entry.LastWorldX or entry.LastX) or 0
        local y = tonumber(entry.LastWorldY or entry.LastY) or 0
        local z = tonumber(entry.LastWorldZ or entry.LastZ) or 0
        local animal = _findAnimalNearByUID(x, y, z, 10, tostring(entry.UID))
        if animal then
            local best = _getAnimalBestName(animal)
            if best and best ~= "" then
                entry.AnimalName = best
                _registry()[tostring(entry.UID)] = entry
                return
            end
        end
    end

    -- Fallback: at least make it unique/stable in lists
    local at = tostring(entry.AnimalType or "animal")
    entry.AnimalName = string.format("%s #%s", at, tostring(entry.UID))
    _registry()[tostring(entry.UID)] = entry
end



local function _entryToClient(entry)
    -- Shallow copy only.
    entry = AACS.EnsureEntrySchema(entry)
    local out = {}
    for k,v in pairs(entry) do
        if k == "AllowList" then
            local a = {}
            if v then for _, u in ipairs(v) do table.insert(a, u) end end
            out[k] = a
        else
            out[k] = v
        end
    end
    return out
end

local function _entryAllowListContains(entry, username)
    if not entry or not entry.AllowList or not username then return false end
    for _, u in ipairs(entry.AllowList) do
        if u == username then return true end
    end
    return false
end

local function _entryModeAllows(owner, username, mode)
    if not owner or not username then return false end
    if mode == AACS.MODE_SAFEHOUSE then
        return AACS.IsSafehouseMember(owner, username)
    elseif mode == AACS.MODE_FACTION then
        return AACS.IsFactionMember(owner, username)
    elseif mode == AACS.MODE_SAFE_OR_FACT then
        return AACS.IsSafehouseMember(owner, username) or AACS.IsFactionMember(owner, username)
    end
    return false
end

local function _canPlayerInteractEntry(entry, playerObj)
    if not entry or not playerObj then return false end
    local username = playerObj:getUsername()
    if not username or username == "" then return false end

    if entry.Owner == username then return true end
    local svAACS2 = _sv()
    local adminBypassEnabled2 = (svAACS2 == nil) or (svAACS2.AdminBypass ~= false)
    if adminBypassEnabled2 and _isAdmin(playerObj) then return true end
    if _entryAllowListContains(entry, username) then return true end

    local pickupMode = tonumber(entry.PickupMode) or AACS.MODE_OWNER_ONLY
    local leashMode = tonumber(entry.LeashMode) or AACS.MODE_OWNER_ONLY
    return _entryModeAllows(entry.Owner, username, pickupMode) or _entryModeAllows(entry.Owner, username, leashMode)
end

local function _getOwnerEntries(owner)
    local reg = _registry()
    local entries = {}
    for uid, e in pairs(reg) do
        e = AACS.EnsureEntrySchema(e)
        if e and e.Owner == owner then
            _repairEntryName(e)
            table.insert(entries, _entryToClient(e))
        end
    end    table.sort(entries, function(a,b)
        local an = tonumber(a.UID) or 999999999
        local bn = tonumber(b.UID) or 999999999
        if an ~= bn then return an < bn end
        return tostring(a.UID) < tostring(b.UID)
    end)
    return entries
end

local function _getInteractableEntries(playerObj)
    local reg = _registry()
    local entries = {}
    for uid, e in pairs(reg) do
        e = AACS.EnsureEntrySchema(e)
        if e and _canPlayerInteractEntry(e, playerObj) then
            _repairEntryName(e)
            table.insert(entries, _entryToClient(e))
        end
    end
    table.sort(entries, function(a,b)
        local an = tonumber(a.UID) or 999999999
        local bn = tonumber(b.UID) or 999999999
        if an ~= bn then return an < bn end
        return tostring(a.UID) < tostring(b.UID)
    end)
    return entries
end

local function _getAllEntries()
    local reg = _registry()
    local entries = {}
    for uid, e in pairs(reg) do
        e = AACS.EnsureEntrySchema(e)
        if e then
            _repairEntryName(e)
            table.insert(entries, _entryToClient(e))
        end
    end    table.sort(entries, function(a,b)
        local an = tonumber(a.UID) or 999999999
        local bn = tonumber(b.UID) or 999999999
        if an ~= bn then return an < bn end
        return tostring(a.UID) < tostring(b.UID)
    end)
    return entries
end

local function _applyRegistryToAnimal(animal, entry)
    if not animal then return end
    -- Keep last-seen updated in modData too
    AACS.SetAnimalClaimModData(animal, entry)
end

local function _removeRegistry(uid)
    local reg = _registry()
    local entry = reg[uid]
    if entry then
        entry = AACS.EnsureEntrySchema(entry)
    end
    reg[uid] = nil
    if entry and entry.Owner then
        AACS.Log("Removed adoption UID " .. uid .. " from registry (owner: " .. entry.Owner .. ")")
    end
end

local function _addOrUpdateRegistry(entry)
    entry = AACS.EnsureEntrySchema(entry)
    local reg = _registry()
    reg[entry.UID] = entry
end

local function _updateLastSeen(animal, entry)
    if not entry or not animal then return end
    entry = AACS.EnsureEntrySchema(entry)
    local sq = animal:getSquare()
    if sq then
        entry.LastX, entry.LastY, entry.LastZ = sq:getX(), sq:getY(), sq:getZ()
        entry.LastWorldX, entry.LastWorldY, entry.LastWorldZ = entry.LastX, entry.LastY, entry.LastZ
    end
    entry.TransportKind = AACS.TRANSPORT_WORLD
    entry.TransportSignature = _captureAnimalTransportSignature(animal)
    entry.LastSeen = AACS.Now()
    _addOrUpdateRegistry(entry)
    _applyRegistryToAnimal(animal, entry)
    _repairEntryName(entry)
end

local function _pushEntryUpdate(entry)
    local payload = { entry = _entryToClient(entry) }
    for _, p in ipairs(_playersOnline()) do
        if _isAdmin(p) or _canPlayerInteractEntry(entry, p) then
            sendServerCommand(p, "AACS", "updateEntry", payload)
        end
    end
end

local function _pushEntryRemove(entry)
    local uid = entry and entry.UID
    if not uid then return end
    for _, p in ipairs(_playersOnline()) do
        if _isAdmin(p) or _canPlayerInteractEntry(entry, p) then
            sendServerCommand(p, "AACS", "removeEntry", { uid = uid })
        end
    end
end

-----------------------------------------------------------------------
-- Helper: give a DocumentPet item to a player (server-side).
-- If inventory is full, drop it near the player.
-----------------------------------------------------------------------
local function _giveDocumentToPlayer(playerObj)
    if not playerObj then return false end
    local inv = playerObj:getInventory()
    if not inv then return false end

    -- B42 server: use instanceItem() instead of InventoryItemFactory
    local item = nil
    pcall(function()
        item = instanceItem(AACS.DOCUMENT_ITEM)
    end)

    if not item then
        -- Fallback: try InventoryItemFactory (for SP or older builds)
        pcall(function()
            item = InventoryItemFactory.CreateItem(AACS.DOCUMENT_ITEM)
        end)
    end

    if not item then
        AACS.Log("_giveDocumentToPlayer: failed to create " .. AACS.DOCUMENT_ITEM)
        return false
    end

    -- Ensure item is fresh and reusable (clear any flags)
    pcall(function()
        if item.setActivated then item:setActivated(false) end
        if item.setUsedDelta then item:setUsedDelta(0) end
        if item.setCondition then item:setCondition(100) end
    end)

    -- B42 MP: Add item using direct inventory manipulation + forced sync
    local added = false
    local synced = false
    local error_msg = nil

    -- Try MP sync method first
    local ok, err = pcall(function()
        if isServer() then
            -- B42 requires BOTH operations for reliable sync
            inv:AddItem(item)  -- Add locally first
            sendAddItemToContainer(inv, item)  -- Then sync to client
            added = true
            synced = true
        else
            -- SP: just add
            inv:AddItem(item)
            added = true
            synced = true
        end
    end)

    if not ok then
        error_msg = tostring(err)
        AACS.Log("ERROR in _giveDocumentToPlayer: " .. error_msg)
    end

    if not added then
        -- Fallback: drop near player
        local sq = playerObj:getSquare()
        if sq then
            sq:AddWorldInventoryItem(item, 0.5, 0.5, 0)
            _notifyKey(playerObj, "IGUI_AACS_Notify_DocumentDropped", "info")
            AACS.Log("Document dropped near " .. playerObj:getUsername() .. " (add failed: " .. (error_msg or "unknown") .. ")")
            return true
        end
        return false
    end

    AACS.Log("Document returned to " .. playerObj:getUsername() .. " (MP sync: " .. tostring(synced) .. ")")
    return true
end

-- Commands
function AACS.onClientCommand(module, command, playerObj, args)
    if module == "animal" then
        local actionMap = {
            leash = "leash", setLeashed = "leash", unleash = "leash",
            Leash = "leash", SetLeashed = "leash", Unleash = "leash",
            AttachAnimalToPlayer = "leash", AttachAnimalToTree = "leash",
            pickup = "pickup", carryAnimal = "pickup", carry = "pickup",
            pickupAnimal = "pickup", grab = "pickup",
            PickupAnimal = "pickup",
            AddAnimalFromHandsInTrailer = "pickup",
            AddAnimalInTrailer = "pickup",
            RemoveAnimalFromTrailer = "pickup",
            RemoveAndGrabAnimalFromTrailer = "pickup",
            HutchGrabAnimal = "pickup",
            HutchRemoveAnimalAction = "pickup",
            kill = "kill", slaughter = "kill", killAnimal = "kill",
            slaughterAnimal = "kill",
            KillAnimal = "kill", SlaughterAnimal = "kill",
        }

        local action = actionMap[command]
        if action then
            local animal = _resolveCommandAnimal(args)
            local entry = nil
            local conflict = false

            if animal then
                local uid = AACS.GetAnimalUID(animal)
                if uid then
                    entry = _findEntryByUID(uid)
                end
            end

            if not entry then
                if command == "RemoveAnimalFromTrailer" or command == "RemoveAndGrabAnimalFromTrailer" then
                    local vehicleId = _extractVehicleId(args.vehicleId or args.VehicleId or args.vehicle or args.trailer)
                    local signature = AACS.NormalizeTransportSignature(
                        args.transportSignature or args.signature or args.sourceTransportSignature or _captureAnimalTransportSignature(animal)
                    )
                    entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_TRAILER, {
                        vehicleId = vehicleId,
                        transportSignature = signature,
                    })
                elseif command == "HutchGrabAnimal" or command == "HutchRemoveAnimalAction" then
                    local hx, hy, hz = _extractHutchCoords(args.hutch or args)
                    local signature = AACS.NormalizeTransportSignature(
                        args.transportSignature or args.signature or args.sourceTransportSignature or _captureAnimalTransportSignature(animal)
                    )
                    entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_HUTCH, {
                        hutchX = hx,
                        hutchY = hy,
                        hutchZ = hz,
                        transportSignature = signature,
                    })
                end
            end

            if conflict then
                _notifyKey(playerObj, "IGUI_AACS_Notify_TransportConflict", "bad")
                AACS.Log(string.format("BLOCKED %s by %s due to transport ambiguity", tostring(command), playerObj:getUsername()))
                return
            end

            if entry then
                if not AACS.CanPlayerDoEntry(playerObj, entry, action) then
                    _notifyKey(playerObj, "IGUI_AACS_Notify_Protected", "bad", tostring(entry.Owner or "?"), tostring(entry.UID or "?"))
                    AACS.Log(string.format(
                        "BLOCKED %s attempt by %s on entry %s (owner: %s, kind: %s)",
                        tostring(command), playerObj:getUsername(), tostring(entry.UID or "?"),
                        tostring(entry.Owner or "?"), tostring(entry.TransportKind or "?")
                    ))
                    return
                end
            elseif animal and AACS.IsClaimed(animal) then
                if not AACS.CanPlayerDo(playerObj, animal, action) then
                    local owner = AACS.GetAnimalOwner(animal) or "?"
                    local uid = AACS.GetAnimalUID(animal) or "?"
                    _notifyKey(playerObj, "IGUI_AACS_Notify_Protected", "bad", owner, uid)
                    AACS.Log(string.format(
                        "BLOCKED %s attempt by %s on animal %s (owner: %s)",
                        tostring(command), playerObj:getUsername(), tostring(uid), tostring(owner)
                    ))
                    return
                end
            end
        end
        return
    end
    
    if module ~= "AACS" then return end
    args = args or {}
    local username = playerObj:getUsername()

    if command == "updateLastLogin" then
        -- Same strategy as AVCS: the client pings on join + every in-game hour.
        -- Server records the timestamp and broadcasts to all clients so UIs can show "Expires at" immediately.
        local ts = getTimestamp()
        AACS.SetLastLogin(username, ts)
        sendServerCommand("AACS", "updateClientLastLogin", { username = username, ts = ts })
        return
    end

    if command == "requestMyAnimals" then
        sendServerCommand(playerObj, "AACS", "myAnimalsData", { entries = _getOwnerEntries(username) })
        return
    end

    if command == "requestInteractableAnimals" then
        sendServerCommand(playerObj, "AACS", "interactableAnimalsData", { entries = _getInteractableEntries(playerObj) })
        return
    end

    if command == "requestAllAnimals" then
        if not _isAdmin(playerObj) then
            _notifyKey(playerObj, "IGUI_AACS_Notify_PermissionDenied", "bad")
            return
        end
        sendServerCommand(playerObj, "AACS", "allAnimalsData", { entries = _getAllEntries() })
        return
    end

    if command == "requestLastLoginData" then
        sendServerCommand(
            playerObj,
            "AACS",
            "lastLoginSnapshotData",
            { entries = _copyPlainTable(ModData.getOrCreate(AACS_LASTLOGIN_KEY)) }
        )
        return
    end

    if command == "transportState" then
        local uid = tostring(args.uid or "")
        local entry = nil
        local conflict = false

        if uid ~= "" then
            entry = _findEntryByUID(uid)
        end

        if not entry then
            local sourceKind = tostring(args.sourceKind or "")
            local signature = AACS.NormalizeTransportSignature(args.sourceTransportSignature or args.transportSignature or "")
            if sourceKind == AACS.TRANSPORT_TRAILER then
                entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_TRAILER, {
                    vehicleId = _extractVehicleId(args.sourceVehicleId or args.vehicleId or args.vehicle),
                    transportSignature = signature,
                })
            elseif sourceKind == AACS.TRANSPORT_HUTCH then
                entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_HUTCH, {
                    hutchX = tonumber(args.sourceHutchX or args.hutchX),
                    hutchY = tonumber(args.sourceHutchY or args.hutchY),
                    hutchZ = tonumber(args.sourceHutchZ or args.hutchZ),
                    transportSignature = signature,
                })
            elseif sourceKind == AACS.TRANSPORT_WORLD then
                entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_WORLD, {
                    x = tonumber(args.worldX or args.x),
                    y = tonumber(args.worldY or args.y),
                    z = tonumber(args.worldZ or args.z),
                    radius = 6,
                    transportSignature = signature,
                })
            end
        end

        if conflict then
            _notifyKey(playerObj, "IGUI_AACS_Notify_TransportConflict", "bad")
            AACS.Log(string.format("transportState conflict from %s", username))
            return
        end

        if not entry then
            AACS.Log(string.format("transportState ignored for %s: entry not found", username))
            return
        end

        if not AACS.CanPlayerDoEntry(playerObj, entry, "pickup") then
            _notifyKey(playerObj, "IGUI_AACS_Notify_Protected", "bad", tostring(entry.Owner or "?"), tostring(entry.UID or "?"))
            AACS.Log(string.format("transportState blocked for %s on UID=%s", username, tostring(entry.UID or "?")))
            return
        end

        entry = AACS.ApplyTransportState(entry, args)
        _addOrUpdateRegistry(entry)

        if entry.TransportKind == AACS.TRANSPORT_WORLD then
            local animal = _findLiveAnimalForEntry(entry)
            if animal then
                AACS.SetAnimalClaimModData(animal, entry)
            end
        end

        _pushEntryUpdate(entry)
        return
    end

    if command == "markAnimalDead" then
        local uid = tostring(args.uid or "")
        local entry = nil
        local conflict = false

        if uid ~= "" then
            entry = _findEntryByUID(uid)
        end

        if not entry then
            local sourceKind = tostring(args.sourceKind or "")
            local signature = AACS.NormalizeTransportSignature(args.sourceTransportSignature or args.transportSignature or "")
            if sourceKind == AACS.TRANSPORT_TRAILER then
                entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_TRAILER, {
                    vehicleId = _extractVehicleId(args.sourceVehicleId or args.vehicleId or args.vehicle),
                    transportSignature = signature,
                })
            elseif sourceKind == AACS.TRANSPORT_HUTCH then
                entry, conflict = _resolveUniqueTransportEntry(AACS.TRANSPORT_HUTCH, {
                    hutchX = tonumber(args.sourceHutchX or args.hutchX),
                    hutchY = tonumber(args.sourceHutchY or args.hutchY),
                    hutchZ = tonumber(args.sourceHutchZ or args.hutchZ),
                    transportSignature = signature,
                })
            end
        end

        if conflict then
            _notifyKey(playerObj, "IGUI_AACS_Notify_TransportConflict", "bad")
            AACS.Log(string.format("markAnimalDead conflict from %s", username))
            return
        end

        if not entry then
            return
        end

        if not AACS.CanPlayerDoEntry(playerObj, entry, "kill") then
            _notifyKey(playerObj, "IGUI_AACS_Notify_Protected", "bad", tostring(entry.Owner or "?"), tostring(entry.UID or "?"))
            AACS.Log(string.format("markAnimalDead blocked for %s on UID=%s", username, tostring(entry.UID or "?")))
            return
        end

        local animal = _findLiveAnimalForEntry(entry)
        if animal then
            AACS.ClearAnimalClaimModData(animal)
        end

        _removeRegistry(tostring(entry.UID))
        _pushEntryRemove(entry)
        return
    end


    if command == "teleportToLocation" then
        AACS.SetLastLogin(username, getTimestamp()) -- activity
        if not _isAdmin(playerObj) then
            _notifyKey(playerObj, "IGUI_AACS_Notify_PermissionDenied", "bad")
            return
        end

        local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z)
        if not x or not y or z == nil then return end
        z = tonumber(z) or 0

        -- Simple anti-spam / cooldown per admin (non-persistent; avoids "works once then never" when timestamp units differ)
        AACS._tpCooldown = AACS._tpCooldown or {}
        local now = AACS.Now()
        local last = tonumber(AACS._tpCooldown[username]) or 0
        if now < last then last = 0 end
        local cdMs = 300 -- keep small; admin tool
        if (now - last) < cdMs then
            local remain = cdMs - (now - last)
            _notify(playerObj, _t("IGUI_AACS_Notify_TeleportCooldown", string.format("%.1f", remain / 1000)), "bad")
            return
        end
        AACS._tpCooldown[username] = now

        if not _teleportPlayerTo(playerObj, x, y, z) then
            _notifyKey(playerObj, "IGUI_AACS_Notify_TeleportFailed", "bad")
            return
        end

        _notify(playerObj, _t("IGUI_AACS_Notify_Teleported", x, y, z), "info")
        return
    end

    if command == "queryAnimalAt" then
        AACS.SetLastLogin(username, getTimestamp()) -- activity
        local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z)
        local requestId = tostring(args.requestId or "")
        local name = args.name and tostring(args.name) or nil
        if requestId == "" or (not x) or (not y) or (not z) then return end

        local animal = _findAnimalNear(x, y, z, 6, name)
        if not animal then
            sendServerCommand(playerObj, "AACS", "animalStatus", { requestId = requestId, found = false })
            return
        end

        local claimed = AACS.IsClaimed(animal)
        local owner = claimed and (AACS.GetAnimalOwner(animal) or "?") or nil
        local uid = claimed and (AACS.GetAnimalUID(animal) or "?") or nil
        local canManage = false
        if claimed then
            canManage = (owner == username) or _isAdmin(playerObj)
        end

        sendServerCommand(playerObj, "AACS", "animalStatus", {
            requestId = requestId,
            found = true,
            claimed = claimed,
            owner = owner,
            uid = uid,
            canManage = canManage,
        })
        return
    end

if command == "adoptAnimal" then
        AACS.SetLastLogin(username, getTimestamp()) -- adoption activity
        local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z)
        if not x or not y or not z then return end

        -- [NEW] Server-side: check adoption limit
        local maxAnimals = AACS.GetMaxAnimalsPerPlayer()
        local svAACS = _sv()
        local adminBypassEnabled = (svAACS == nil) or (svAACS.AdminBypass ~= false)
        local bypass = _isAdmin(playerObj) and adminBypassEnabled

        if maxAnimals > 0 and not bypass then
            local currentCount = AACS.CountPlayerAdoptions(username)
            AACS.Log("Adoption limit check: " .. username .. " has " .. currentCount .. " / " .. maxAnimals .. " animals")
            if currentCount >= maxAnimals then
                _notifyKey(playerObj, "IGUI_AACS_Require_Limit", "bad", currentCount, maxAnimals)
                return
            end
        end

        -- Find and validate animal FIRST (before consuming document)
        local animal = _findAnimalNear(x, y, z, 2)
        if not animal then
            _notifyKey(playerObj, "IGUI_AACS_Notify_AnimalNotFoundRetry", "bad")
            return
        end

        if AACS.IsClaimed(animal) and not bypass then
            local owner = AACS.GetAnimalOwner(animal) or "?"
            local uid = AACS.GetAnimalUID(animal) or "?"
            _notify(playerObj, _t("IGUI_AACS_Notify_AlreadyAdopted", owner, uid), "bad")
            return
        end

        -- Second-line defence: only a unique world-state match may be restored.
        do
            local anSq = animal:getSquare()
            local anX = anSq and anSq:getX() or x
            local anY = anSq and anSq:getY() or y
            local anZ = anSq and anSq:getZ() or z
            local existingEntry, conflict = _findUniqueWorldEntryForAnimal(animal, anX, anY, anZ, 6)

            if conflict then
                _notifyKey(playerObj, "IGUI_AACS_Notify_TransportConflict", "bad")
                AACS.Log(string.format(
                    "adoptAnimal: unique-match conflict near %d,%d,%d",
                    anX, anY, anZ
                ))
                return
            end

            if existingEntry then
                AACS.SetAnimalClaimModData(animal, existingEntry)
                _notifyKey(
                    playerObj,
                    "IGUI_AACS_Notify_AlreadyAdopted",
                    "bad",
                    tostring(existingEntry.Owner or "?"),
                    tostring(existingEntry.UID or "?")
                )
                AACS.Log(string.format(
                    "adoptAnimal: duplicate blocked by unique world match UID=%s owner=%s",
                    tostring(existingEntry.UID or "?"),
                    tostring(existingEntry.Owner or "?")
                ))
                return
            end
        end

        -- [NEW] Server-side: check and consume document (ONLY after validating animal)
        if AACS.RequiresDocument() and not bypass then
            local inv = playerObj:getInventory()
            if not inv then
                _notifyKey(playerObj, "IGUI_AACS_Notify_NeedDocument", "bad")
                return
            end
            local docItem = inv:getFirstTypeRecurse(AACS.DOCUMENT_ITEM)
            if not docItem then
                _notifyKey(playerObj, "IGUI_AACS_Notify_NeedDocument", "bad")
                return
            end
            -- Consume the document (only when we KNOW the adoption will succeed)
            -- B42 MP: Remove using both local + sync for reliability
            local synced = false
            local ok, err = pcall(function()
                if isServer() then
                    -- B42 requires BOTH operations
                    inv:Remove(docItem)  -- Remove locally first
                    sendRemoveItemFromContainer(inv, docItem)  -- Then sync to client
                    synced = true
                else
                    -- SP fallback
                    inv:Remove(docItem)
                    synced = true
                end
            end)
            if not ok then
                AACS.Log("ERROR consuming document: " .. tostring(err))
            end
            AACS.Log("Document consumed for adoption by " .. username .. " (MP sync: " .. tostring(synced) .. ")")
        end

        local uid = AACS.NextSequentialUID()
        local entry = AACS.MakeEntry(username, animal, uid)
        _addOrUpdateRegistry(entry)
        _applyRegistryToAnimal(animal, entry)
        _repairEntryName(entry)

        -- Translate on client (server language may differ / may not have tables)
        _notifyKey(playerObj, "IGUI_AACS_Notify_AdoptedCode", "good", uid)
        _pushEntryUpdate(entry)

        -- Notify OTHER admins (not the player who adopted)
        for _, p in ipairs(_playersOnline()) do
            if _isAdmin(p) and p:getUsername() ~= username then
                sendServerCommand(p, "AACS", "notify", {
                    key = "IGUI_AACS_Notify_AdminAdopted",
                    args = { username, uid },
                    kind = "info"
                })
            end
        end
        return
    end

    if command == "unadoptAnimal" then
        AACS.SetLastLogin(username, getTimestamp()) -- adoption activity
        local uid = tostring(args.uid or "")
        if uid == "" then return end

        local reg = _registry()
        local entry = reg[uid]
        entry = AACS.EnsureEntrySchema(entry)
        if not entry then
            _notifyKey(playerObj, "IGUI_AACS_Notify_RecordNotFound", "bad")
            return
        end

        if entry.Owner ~= username and not _isAdmin(playerObj) then
            _notifyKey(playerObj, "IGUI_AACS_Notify_NotOwner", "bad")
            return
        end

        -- Attempt to find the animal near last coords and clear its modData.
        local animal = _findLiveAnimalForEntry(entry)
        if animal and AACS.GetAnimalUID(animal) == uid then
            AACS.ClearAnimalClaimModData(animal)
        end

        _removeRegistry(uid)

        -- [NEW] Return document to the player who executes the unadopt, if enabled.
        if AACS.RequiresDocument() and AACS.ShouldReturnDocument() then
            if _giveDocumentToPlayer(playerObj) then
                _notifyKey(playerObj, "IGUI_AACS_Notify_DocumentReturned", "info")
                AACS.Log("Document returned to " .. username .. " on unadopt of UID " .. uid)
            end
        end

        -- Translate on client (server language may differ / may not have tables)
        _notifyKey(playerObj, "IGUI_AACS_Notify_UnadoptedCode", "good", uid)
        _pushEntryRemove(entry)
        return
    end

    if command == "renameAnimal" then
        AACS.SetLastLogin(username, getTimestamp()) -- activity
        local uid = tostring(args.uid or "")
        local nickname = tostring(args.nickname or "")
        
        if uid == "" or nickname == "" then return end
        
        local reg = _registry()
        local entry = reg[uid]
        entry = AACS.EnsureEntrySchema(entry)
        if not entry then
            _notifyKey(playerObj, "IGUI_AACS_Notify_AnimalNotFound", "bad")
            return
        end
        
        if entry.Owner ~= username and not _isAdmin(playerObj) then
            _notifyKey(playerObj, "IGUI_AACS_Notify_RenameOwnerOnly", "bad")
            return
        end
        
        -- Update entry
        entry.Nickname = nickname
        reg[uid] = entry
        
        -- Update ModData of animal if possible
        local animal = _findLiveAnimalForEntry(entry)
        if animal and AACS.GetAnimalUID(animal) == uid then
            AACS.SetAnimalNickname(animal, nickname)
        end
        
        _notify(playerObj, _t("IGUI_AACS_Notify_Renamed", nickname), "good")
        _pushEntryUpdate(entry)
        return
    end

    if command == "setPermissions" then
        AACS.SetLastLogin(username, getTimestamp()) -- activity
        local uid = tostring(args.uid or "")
        if uid == "" then return end

        local reg = _registry()
        local entry = reg[uid]
        entry = AACS.EnsureEntrySchema(entry)
        if not entry then
            _notifyKey(playerObj, "IGUI_AACS_Notify_RecordNotFound", "bad")
            return
        end

        if entry.Owner ~= username and not _isAdmin(playerObj) then
            _notifyKey(playerObj, "IGUI_AACS_Notify_NotOwner", "bad")
            return
        end

        local pickupMode = tonumber(args.pickupMode) or entry.PickupMode
        local leashMode  = tonumber(args.leashMode)  or entry.LeashMode
        if pickupMode < 1 or pickupMode > 4 then pickupMode = entry.PickupMode end
        if leashMode  < 1 or leashMode  > 4 then leashMode  = entry.LeashMode end
        pickupMode = AACS.SanitizeMode(pickupMode)
        leashMode = AACS.SanitizeMode(leashMode)

        entry.PickupMode = pickupMode
        entry.LeashMode  = leashMode

        -- AllowList array of usernames
        entry.AllowList = {}
        if args.allowList and type(args.allowList) == "table" then
            for _, u in ipairs(args.allowList) do
                if u and u ~= "" then table.insert(entry.AllowList, u) end
            end
        end

        -- Update last seen if we can locate animal
        local animal = _findLiveAnimalForEntry(entry)
        if animal and AACS.GetAnimalUID(animal) == uid then
            _updateLastSeen(animal, entry)
        else
            _addOrUpdateRegistry(entry)
        end

        _notifyKey(playerObj, "IGUI_AACS_Notify_PermissionsUpdated", "good")
        _pushEntryUpdate(entry)
        return
    end

    if command == "pingAnimal" then
        AACS.SetLastLogin(username, getTimestamp()) -- activity
        local uid = tostring(args.uid or "")
        if uid == "" then return end

        local reg = _registry()
        local entry = reg[uid]
        if not entry then return end

        local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z)
        if not x or not y or not z then return end

        local animal = _findAnimalNear(x, y, z, 2)
        if animal and AACS.GetAnimalUID(animal) == uid then
            -- Throttle last-seen updates to avoid excessive registry spam.
            AACS._pingThrottle = AACS._pingThrottle or {}
            local nowMs = AACS.Now()
            local last = AACS._pingThrottle[uid]
            local shouldUpdate = true

            if last and (nowMs - last.ts) < 15000 then
                local dx = (last.x or x) - x
                local dy = (last.y or y) - y
                local dz = (last.z or z) - z
                if (dx * dx + dy * dy + dz * dz) <= 1 then
                    shouldUpdate = false
                end
            end

            if shouldUpdate then
                AACS._pingThrottle[uid] = { ts = nowMs, x = x, y = y, z = z }
                _updateLastSeen(animal, entry)
                _pushEntryUpdate(entry)
            end
        end
        return
    end
end

-- Handler principal AACS
if Events and Events.OnClientCommand then
    Events.OnClientCommand.Add(AACS.onClientCommand)
end


-----------------------------------------------------------------------
-- Adoption Expiry (SandboxVars.AACS.AdoptionExpiryDays)
-- If > 0: when a player stays without logging in for N real days,
-- all their adopted animals are released (registry entries removed).
-- MP-safe: server is source of truth.
-----------------------------------------------------------------------

local AACS_LASTLOGIN_KEY = "AACS_PlayerLastLogin"

local function _aacsOnInitGlobalModData()
    -- Ensure the key exists so clients can ModData.request() it immediately.
    local db = ModData.getOrCreate(AACS_LASTLOGIN_KEY)
    if ModData and ModData.add then
        pcall(function() ModData.add(AACS_LASTLOGIN_KEY, db) end)
    end
end

pcall(function()
    if Events and Events.OnInitGlobalModData then
        Events.OnInitGlobalModData.Add(_aacsOnInitGlobalModData)
    end
end)
pcall(_aacsOnInitGlobalModData)


local function _aacsLastLoginDB()
    return ModData.getOrCreate(AACS_LASTLOGIN_KEY)
end

local function _aacsPersistLastLogin(db)
    -- Not required for logic, but helps ensure persistence across restarts.
    if ModData and ModData.add then
        pcall(function() ModData.add(AACS_LASTLOGIN_KEY, db) end)
    end
end

local function _aacsGetExpiryDays()
    local v = 0
    if SandboxVars and SandboxVars.AACS then
        v = SandboxVars.AACS.AdoptionExpiryDays
    end
    v = tonumber(v) or 0
    if v < 0 then v = 0 end
    return v
end


function AACS.SetLastLogin(username, ts)
    if not username or username == "" then return end
    local db = _aacsLastLoginDB()
    db[username] = tonumber(ts) or getTimestamp()
    _aacsPersistLastLogin(db)
end

local function _aacsIsOnline(username)
    local list = getOnlinePlayers()
    if not list then return false end
    local online = false
    _iterList(list, function(p)
        if p and p:getUsername() == username then
            online = true
            return true
        end
        return false
    end)
    return online
end

function AACS.ReleaseAdoptionsForOwner(ownerUsername, reason)
    if not ownerUsername or ownerUsername == "" then return 0 end
    local reg = _registry()

    local uids = {}
    for uid, entry in pairs(reg) do
        entry = AACS.EnsureEntrySchema(entry)
        if entry and entry.Owner == ownerUsername then
            table.insert(uids, tostring(uid))
        end
    end
    if #uids == 0 then return 0 end

    local released = 0
    for _, uid in ipairs(uids) do
        local entry = reg[uid]
        if entry then
            entry = AACS.EnsureEntrySchema(entry)
            local animal = _findLiveAnimalForEntry(entry)
            if animal and AACS.GetAnimalUID(animal) == uid then
                AACS.ClearAnimalClaimModData(animal)
            end

            _removeRegistry(uid)
            released = released + 1
            _pushEntryRemove(entry)
        end
    end

    -- Let admins know.
    _broadcastToAdmins("notify", {
        msg = _t("IGUI_AACS_Notify_AdoptionExpired", ownerUsername, released),
        kind = "info"
    })

    return released
end

local function _aacsCleanupOrphanAnimalClaims()
    -- If an animal keeps claim modData but its UID isn't in the registry, clear it.
    -- This prevents "ghost protection" when entries are removed while the animal wasn't loaded.
    local cell = getCell()
    if not cell then return end
    local objs = cell:getObjectList()
    if not objs then return end
    local reg = _registry()

    local cleared = 0
    _iterList(objs, function(obj)
        if _isAnimalObject(obj) then
            local uid = AACS.GetAnimalUID(obj)
            if uid and not reg[tostring(uid)] then
                AACS.ClearAnimalClaimModData(obj)
                cleared = cleared + 1
            end
        end
    end)

    if cleared > 0 then
        AACS.Log("Orphan cleanup: cleared " .. tostring(cleared) .. " animal claim modData.")
    end
end

function AACS.DoAdoptionExpiryCheck()
    local days = _aacsGetExpiryDays()
    if days <= 0 then return end

    local now = getTimestamp()
    local secondsLimit = days * 24 * 60 * 60

    local reg = _registry()
    local db = _aacsLastLoginDB()

    -- Heartbeat: refresh online players so they never expire while connected.
    local online = getOnlinePlayers()
    if online then
        _iterList(online, function(p)
            if p then
                db[p:getUsername()] = now
            end
        end)
    end

    local expiredOwners = {}
    local seeded = 0

    for _uid, entry in pairs(reg) do
        entry = AACS.EnsureEntrySchema(entry)
        local owner = entry and entry.Owner or nil
        if owner and owner ~= "" then
            local last = tonumber(db[owner])
            if not last then
                -- Safety: if we have no record, seed from "now" so we don't auto-release legacy claims.
                db[owner] = now
                seeded = seeded + 1
            else
                -- If owner is online, ignore (already refreshed above).
                if not _aacsIsOnline(owner) then
                    if (now - last) > secondsLimit then
                        expiredOwners[owner] = true
                    end
                end
            end
        end
    end

    if seeded > 0 then
        AACS.Log("AdoptionExpiry: seeded last-login for " .. tostring(seeded) .. " owner(s) with no previous record.")
    end

    local totalReleased = 0
    for owner, _ in pairs(expiredOwners) do
        totalReleased = totalReleased + (AACS.ReleaseAdoptionsForOwner(owner, "expiry") or 0)
    end

    _aacsPersistLastLogin(db)

    if totalReleased > 0 then
        AACS.Log("AdoptionExpiry: released " .. tostring(totalReleased) .. " adoption(s).")
    end

    _aacsCleanupOrphanAnimalClaims()
end

-----------------------------------------------------------------------
-- Dead Animal Detection
-- Periodically scans loaded animals and checks for dead ones.
-- Removes dead animals from the adoption registry automatically.
-- Also uses isDead() checks during restamp and orphan cleanup.
-----------------------------------------------------------------------

local function _isAnimalDead(animal)
    if not animal then return true end -- treat nil as "gone"

    -- Primary: isDead() method (most reliable in B42)
    if animal.isDead and type(animal.isDead) == "function" then
        local ok, dead = pcall(function() return animal:isDead() end)
        if ok and dead == true then return true end
    end

    -- Secondary: health <= 0 (some B42 builds)
    if animal.getHealth and type(animal.getHealth) == "function" then
        local ok, hp = pcall(function() return animal:getHealth() end)
        if ok and hp ~= nil and tonumber(hp) ~= nil and tonumber(hp) <= 0 then return true end
    end

    -- Tertiary: check if the object has been removed from the world
    if animal.getSquare and type(animal.getSquare) == "function" then
        local ok, sq = pcall(function() return animal:getSquare() end)
        if ok and sq == nil then return true end -- no longer on any square
    end

    return false
end

function AACS.CheckForDeadAnimals()
    local cell = getCell()
    if not cell then return end
    local reg = _registry()

    local deadUIDs = {}

    -- Scan all loaded objects for dead animals with claim data
    local objs = cell:getObjectList()
    if objs then
        _iterList(objs, function(obj)
            if _isAnimalObject(obj) then
                local uid = AACS.GetAnimalUID(obj)
                if uid and reg[tostring(uid)] then
                    if _isAnimalDead(obj) then
                        deadUIDs[tostring(uid)] = true
                        -- Clear modData from the dead animal/carcass
                        AACS.ClearAnimalClaimModData(obj)
                    end
                end
            end
        end)
    end

    -- Also: for each registry entry, try to find the animal and check if dead.
    -- This catches animals that died while loaded but weren't in objectList scan.
    for uid, entry in pairs(reg) do
        entry = AACS.EnsureEntrySchema(entry)
        if entry and not deadUIDs[tostring(uid)] then
            local animal = _findLiveAnimalForEntry(entry)
            if animal and _isAnimalDead(animal) then
                deadUIDs[tostring(uid)] = true
                AACS.ClearAnimalClaimModData(animal)
            end
        end
    end

    -- Remove dead entries from registry and notify
    local removed = 0
    for uid, _ in pairs(deadUIDs) do
        local entry = AACS.EnsureEntrySchema(reg[uid])
        if entry then
            local animalName = entry.AnimalName or entry.AnimalType or "?"
            local owner = entry.Owner or "?"

            _removeRegistry(uid)
            _pushEntryRemove(entry)
            removed = removed + 1

            -- Notify the owner if online
            for _, p in ipairs(_playersOnline()) do
                if p:getUsername() == owner then
                    _notifyKey(p, "IGUI_AACS_Notify_AnimalDied", "bad", animalName, uid)
                    break
                end
            end

            -- Notify admins
            _broadcastToAdmins("notify", {
                msg = string.format("[AACS] Animal '%s' (code %s, owner: %s) died. Adoption removed.", animalName, uid, owner),
                kind = "info"
            })

            AACS.Log(string.format("Dead animal detected: UID=%s, Name=%s, Owner=%s. Adoption removed.", uid, animalName, owner))
        end
    end

    if removed > 0 then
        AACS.Log("Dead animal cleanup: removed " .. tostring(removed) .. " adoption(s).")
    end
end

-----------------------------------------------------------------------

-- Run expiry check + dead animal check periodically: every 10 minutes.
local function _aacsEveryTenMinutes()
    pcall(AACS.DoAdoptionExpiryCheck)
    pcall(AACS.CheckForDeadAnimals)
end
Events.EveryTenMinutes.Add(_aacsEveryTenMinutes)


-- Backup: if server exposes OnPlayerConnect, refresh immediately.
pcall(function()
    if Events and Events.OnPlayerConnect then
        Events.OnPlayerConnect.Add(function(playerObj)
            if playerObj and playerObj.getUsername then
                AACS.SetLastLogin(playerObj:getUsername(), getTimestamp())
            end
        end)
    end
end)

-- Immediate re-stamp when an animal is added/placed back into the world.
-- Only a unique world-state match may be restored.
pcall(function()
    if Events and Events.OnObjectAdded then
        Events.OnObjectAdded.Add(function(obj)
            if not obj then return end
            local isAnimal = false
            pcall(function() isAnimal = instanceof(obj, "IsoAnimal") end)
            if not isAnimal then
                local isMoving = false
                pcall(function() isMoving = instanceof(obj, "IsoMovingObject") end)
                if isMoving and obj.isAnimal and type(obj.isAnimal) == "function" then
                    local ok2, res = pcall(function() return obj:isAnimal() end)
                    if ok2 and res == true then isAnimal = true end
                end
            end
            if not isAnimal then return end

            if AACS.IsClaimed(obj) then return end

            local anSq = nil
            pcall(function() anSq = obj:getSquare() end)
            if not anSq then return end

            local anX, anY, anZ = anSq:getX(), anSq:getY(), anSq:getZ()
            local entry, conflict = _findUniqueRestoreEntryForAnimal(obj, anX, anY, anZ, 5)

            if conflict then
                AACS.Log(string.format(
                    "OnObjectAdded: ambiguous restore near %d,%d,%d, skipping",
                    anX, anY, anZ
                ))
                return
            end

            if entry then
                AACS.SetAnimalClaimModData(obj, entry)
                entry.LastX, entry.LastY, entry.LastZ = anX, anY, anZ
                entry.LastWorldX, entry.LastWorldY, entry.LastWorldZ = anX, anY, anZ
                entry.TransportKind = AACS.TRANSPORT_WORLD
                entry.CarrierUsername = nil
                entry.TransportSignature = _captureAnimalTransportSignature(obj)
                entry.LastSeen = AACS.Now()
                _addOrUpdateRegistry(entry)
                _pushEntryUpdate(entry)
                AACS.Log(string.format(
                    "OnObjectAdded: restored UID=%s owner=%s kind=%s at %d,%d,%d",
                    tostring(entry.UID), tostring(entry.Owner), tostring(entry.TransportKind), anX, anY, anZ
                ))
            end
        end)
    end
end)
