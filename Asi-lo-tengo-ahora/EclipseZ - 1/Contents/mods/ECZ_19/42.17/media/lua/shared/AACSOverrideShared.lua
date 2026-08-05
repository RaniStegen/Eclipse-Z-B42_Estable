-- AACSOverrideShared.lua (Build 42.17 / MP-safe)
-- Timed-action guards plus claim snapshot transport handling.

local okBase = pcall(require, "TimedActions/ISBaseTimedAction")
if not okBase then return end
local okShared = pcall(require, "AACSShared")
if not okShared then return end

if isServer() and (not isClient()) and ISInventoryPage == nil then
    ISInventoryPage = {}
end

AACS = AACS or {}

local function _t(key, ...)
    local msg = getText(key)
    local args = { ... }
    for i = 1, #args do
        msg = msg:gsub("%%" .. i, tostring(args[i]))
    end
    return msg
end

local function _notifyDenied(playerObj, msg)
    if not msg then msg = "Denied" end

    if isServer() and playerObj and sendServerCommand then
        sendServerCommand(playerObj, "AACS", "notify", { msg = msg, kind = "bad" })
        return
    end

    if isClient() and playerObj then
        if HaloTextHelper and HaloTextHelper.addText then
            if not pcall(HaloTextHelper.addText, playerObj, msg) then
                playerObj:Say(msg)
            end
        else
            playerObj:Say(msg)
        end
    end
end

local function _denyCooldown(playerObj, key)
    if not playerObj or not key then return false end
    local md = playerObj:getModData()
    md.AACS_Deny = md.AACS_Deny or {}
    local now = AACS.Now()
    local last = md.AACS_Deny[key] or 0
    local threshold = (now > 100000000000) and 800 or 1
    if now - last < threshold then
        return true
    end
    md.AACS_Deny[key] = now
    return false
end

local function _getVehicleId(vehicle)
    if not vehicle then return nil end
    local probes = { "getId", "getVehicleID", "getSqlId", "getID" }
    for _, fnName in ipairs(probes) do
        local fn = vehicle[fnName]
        if type(fn) == "function" then
            local okValue, value = pcall(function() return fn(vehicle) end)
            if okValue and value ~= nil and tostring(value) ~= "" then
                return tostring(value)
            end
        end
    end
    return nil
end

local function _getSquareXYZ(obj)
    if not obj then return nil, nil, nil end
    if obj.getSquare and type(obj.getSquare) == "function" then
        local okSq, sq = pcall(function() return obj:getSquare() end)
        if okSq and sq then
            return sq:getX(), sq:getY(), sq:getZ()
        end
    end
    local okX, x = pcall(function() return obj:getX() end)
    local okY, y = pcall(function() return obj:getY() end)
    local okZ, z = pcall(function() return obj:getZ() end)
    if okX and okY and okZ then
        return tonumber(x), tonumber(y), tonumber(z)
    end
    return nil, nil, nil
end

local function _captureCharacterXYZ(character)
    return _getSquareXYZ(character)
end

local function _buildSignatureFromAnimal(animal)
    return AACS.NormalizeTransportSignature(AACS.BuildTransportSignature(animal))
end

local function _collectCachedEntries()
    local out, seen = {}, {}
    local cache = AACS.ClientCache or {}
    local buckets = { cache.myEntries, cache.interactEntries, cache.allEntries }

    for _, bucket in ipairs(buckets) do
        if type(bucket) == "table" then
            for _, entry in ipairs(bucket) do
                entry = AACS.EnsureEntrySchema(entry)
                if entry and entry.UID and not seen[tostring(entry.UID)] then
                    seen[tostring(entry.UID)] = true
                    out[#out + 1] = entry
                end
            end
        end
    end

    return out
end

local function _resolveCachedTransportEntry(kind, params)
    if not isClient() then
        return nil, false
    end

    params = params or {}
    local matches = {}
    local wantVehicleId = params.vehicleId and tostring(params.vehicleId) or nil
    local wantHx = tonumber(params.hutchX)
    local wantHy = tonumber(params.hutchY)
    local wantHz = tonumber(params.hutchZ)
    local wantSignature = AACS.NormalizeTransportSignature(params.transportSignature or "")

    for _, entry in ipairs(_collectCachedEntries()) do
        if entry.TransportKind == kind then
            local containerMatch = false
            if kind == AACS.TRANSPORT_TRAILER then
                containerMatch = wantVehicleId ~= nil and tostring(entry.VehicleId or "") == wantVehicleId
            elseif kind == AACS.TRANSPORT_HUTCH then
                containerMatch =
                    tonumber(entry.HutchX) == wantHx and
                    tonumber(entry.HutchY) == wantHy and
                    tonumber(entry.HutchZ) == wantHz
            else
                containerMatch = true
            end

            if containerMatch then
                local entrySignature = AACS.NormalizeTransportSignature(entry.TransportSignature or AACS.BuildEntryTransportSignature(entry))
                if wantSignature ~= "" then
                    if entrySignature == wantSignature then
                        matches[#matches + 1] = entry
                    end
                else
                    matches[#matches + 1] = entry
                end
            end
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

local function _rememberClaim(self, snapshot, context, conflict)
    self.aacsClaimSnapshot = snapshot
    self.aacsClaimContext = context or {}
    self.aacsClaimConflict = conflict == true
    return snapshot
end

local function _denyConflict(character, suffix)
    suffix = suffix or "transport"
    local key = "conflict:" .. tostring(suffix)
    if not _denyCooldown(character, key) then
        _notifyDenied(character, getText("IGUI_AACS_Notify_TransportConflict"))
    end
    return false
end

local function _validateSnapshotAction(character, snapshot, action)
    if not snapshot or not snapshot.UID then
        return true
    end
    if AACS.CanPlayerDoClaim(character, snapshot, action) then
        return true
    end

    local uid = tostring(snapshot.UID or "?")
    local owner = tostring(snapshot.Owner or "?")
    local msg = _t("IGUI_AACS_Notify_Protected", owner, uid)
    local key = tostring(action) .. ":" .. uid
    if not _denyCooldown(character, key) then
        _notifyDenied(character, msg)
    end
    return false
end

local function _precheck(self, action, resolver)
    local snapshot, context, conflict = resolver(self)
    _rememberClaim(self, snapshot, context, conflict)

    if conflict then
        return _denyConflict(self.character, action)
    end
    return _validateSnapshotAction(self.character, snapshot, action)
end

local function _updateTransportStateSP(payload)
    local uid = payload and payload.uid and tostring(payload.uid) or ""
    if uid == "" then return end
    local reg = AACS.SP_GetRegistry()
    local entry = reg[uid]
    if not entry then return end
    entry = AACS.ApplyTransportState(entry, payload)
    reg[uid] = entry
end

local function _removeDeadEntrySP(payload)
    local uid = payload and payload.uid and tostring(payload.uid) or ""
    if uid == "" then return end
    local reg = AACS.SP_GetRegistry()
    reg[uid] = nil
end

local function _sendTransportState(character, payload)
    if not payload or not payload.uid then return end
    payload.lastSeen = tonumber(payload.lastSeen) or AACS.Now()
    if isClient() and sendClientCommand then
        sendClientCommand(character, "AACS", "transportState", payload)
    else
        _updateTransportStateSP(payload)
    end
end

local function _sendMarkDead(character, payload)
    if not payload or not payload.uid then return end
    payload.lastSeen = tonumber(payload.lastSeen) or AACS.Now()
    if isClient() and sendClientCommand then
        sendClientCommand(character, "AACS", "markAnimalDead", payload)
    else
        _removeDeadEntrySP(payload)
    end
end

local function _buildPayloadFromContext(self, targetKind, extra)
    local snapshot = self.aacsClaimSnapshot
    if not snapshot or not snapshot.UID then
        return nil
    end

    local ctx = self.aacsClaimContext or {}
    local payload = {
        uid = tostring(snapshot.UID),
        targetKind = targetKind,
        transportSignature = extra and extra.transportSignature or ctx.transportSignature,
        sourceKind = ctx.sourceKind,
        sourceVehicleId = ctx.vehicleId,
        sourceHutchX = ctx.hutchX,
        sourceHutchY = ctx.hutchY,
        sourceHutchZ = ctx.hutchZ,
        sourceTransportSignature = ctx.transportSignature,
        carrierUsername = extra and extra.carrierUsername or nil,
        vehicleId = extra and extra.vehicleId or nil,
        hutchX = extra and extra.hutchX or nil,
        hutchY = extra and extra.hutchY or nil,
        hutchZ = extra and extra.hutchZ or nil,
        x = extra and extra.x or nil,
        y = extra and extra.y or nil,
        z = extra and extra.z or nil,
        worldX = extra and extra.worldX or nil,
        worldY = extra and extra.worldY or nil,
        worldZ = extra and extra.worldZ or nil,
        lastSeen = AACS.Now(),
    }
    return payload
end

local function _getHandAnimalItem(character)
    if not character then return nil end

    local primary = character:getPrimaryHandItem()
    if primary and primary.getAnimal then
        return primary
    end

    local secondary = character:getSecondaryHandItem()
    if secondary and secondary.getAnimal then
        return secondary
    end

    return nil
end

local function _resolveWorldAnimal(self)
    local snapshot = AACS.CaptureClaimSnapshotFromAnimal(self.animal)
    local x, y, z = _getSquareXYZ(self.animal)
    return snapshot, {
        sourceKind = AACS.TRANSPORT_WORLD,
        transportSignature = _buildSignatureFromAnimal(self.animal),
        x = x, y = y, z = z,
    }, false
end

local function _resolveInventoryAnimal(self)
    local item = self.animalItem or self.animalInventoryItem or _getHandAnimalItem(self.character)
    local snapshot = AACS.CaptureClaimSnapshotFromItem(item)
    if not snapshot and self.animal then
        snapshot = AACS.CaptureClaimSnapshotFromAnimal(self.animal)
    end

    local animal = AACS.GetAnimalFromInventoryItem(item) or self.animal
    local x, y, z = _captureCharacterXYZ(self.character)
    return snapshot, {
        sourceKind = AACS.TRANSPORT_INVENTORY,
        carrierUsername = self.character and self.character:getUsername() or nil,
        transportSignature = _buildSignatureFromAnimal(animal),
        x = x, y = y, z = z,
    }, false
end

local function _resolveTrailerAnimal(self)
    local snapshot = AACS.CaptureClaimSnapshotFromAnimal(self.animal)
    local vehicleId = _getVehicleId(self.vehicle)
    local signature = _buildSignatureFromAnimal(self.animal)

    if (not snapshot or not snapshot.UID) and isClient() then
        local entry, conflict = _resolveCachedTransportEntry(AACS.TRANSPORT_TRAILER, {
            vehicleId = vehicleId,
            transportSignature = signature,
        })
        if conflict then
            return nil, {
                sourceKind = AACS.TRANSPORT_TRAILER,
                vehicleId = vehicleId,
                transportSignature = signature,
            }, true
        end
        if entry then
            snapshot = AACS.BuildClaimFromEntry(entry)
        end
    end

    if snapshot and self.animal then
        AACS.ApplyClaimSnapshotToAnimal(self.animal, snapshot)
    end

    local x, y, z = _getSquareXYZ(self.vehicle)
    return snapshot, {
        sourceKind = AACS.TRANSPORT_TRAILER,
        vehicleId = vehicleId,
        transportSignature = signature,
        x = x, y = y, z = z,
    }, false
end

local function _resolveHutchAnimal(self)
    local animal = self.hutch and self.hutch.getAnimal and self.hutch:getAnimal(self.index) or nil
    local snapshot = AACS.CaptureClaimSnapshotFromAnimal(animal)
    local hx, hy, hz = _getSquareXYZ(self.hutch)
    local signature = _buildSignatureFromAnimal(animal)

    if (not snapshot or not snapshot.UID) and isClient() then
        local entry, conflict = _resolveCachedTransportEntry(AACS.TRANSPORT_HUTCH, {
            hutchX = hx,
            hutchY = hy,
            hutchZ = hz,
            transportSignature = signature,
        })
        if conflict then
            return nil, {
                sourceKind = AACS.TRANSPORT_HUTCH,
                hutchX = hx,
                hutchY = hy,
                hutchZ = hz,
                transportSignature = signature,
            }, true
        end
        if entry then
            snapshot = AACS.BuildClaimFromEntry(entry)
        end
    end

    if snapshot and animal then
        AACS.ApplyClaimSnapshotToAnimal(animal, snapshot)
    end

    return snapshot, {
        sourceKind = AACS.TRANSPORT_HUTCH,
        hutchX = hx,
        hutchY = hy,
        hutchZ = hz,
        transportSignature = signature,
    }, false
end

local function _patchGuardedAction(classObj, action, resolver)
    if not classObj then return end

    if classObj.isValid then
        local oldValid = classObj.isValid
        function classObj:isValid()
            if not oldValid(self) then return false end
            return _precheck(self, action, resolver)
        end
    end

    if classObj.start then
        local oldStart = classObj.start
        function classObj:start()
            if not _precheck(self, action, resolver) then
                self:forceStop()
                return
            end
            oldStart(self)
        end
    end

    if classObj.perform then
        local oldPerform = classObj.perform
        function classObj:perform()
            if not _precheck(self, action, resolver) then
                self:forceStop()
                return
            end
            oldPerform(self)
        end
    end
end

pcall(require, "TimedActions/ISAttachAnimalToPlayer")
if ISAttachAnimalToPlayer then
    _patchGuardedAction(ISAttachAnimalToPlayer, "leash", _resolveWorldAnimal)
end

pcall(require, "TimedActions/Animals/ISPickupAnimal")
if ISPickupAnimal then
    _patchGuardedAction(ISPickupAnimal, "pickup", _resolveWorldAnimal)

    if ISPickupAnimal.complete then
        local oldComplete = ISPickupAnimal.complete
        function ISPickupAnimal:complete()
            if not _precheck(self, "pickup", _resolveWorldAnimal) then
                return false
            end

            local sourceX, sourceY, sourceZ = _getSquareXYZ(self.animal)
            local okComplete, result = pcall(oldComplete, self)
            if not okComplete then
                error(result)
            end

            if result and self.aacsClaimSnapshot then
                local item = _getHandAnimalItem(self.character)
                if item then
                    AACS.WriteClaimSnapshotToItem(item, self.aacsClaimSnapshot)
                end
                local x, y, z = _captureCharacterXYZ(self.character)
                _sendTransportState(self.character, _buildPayloadFromContext(self, AACS.TRANSPORT_INVENTORY, {
                    carrierUsername = self.character and self.character:getUsername() or nil,
                    x = x, y = y, z = z,
                    worldX = sourceX, worldY = sourceY, worldZ = sourceZ,
                }))
            end

            return result
        end
    end
end

pcall(require, "TimedActions/Animals/ISAddAnimalInTrailer")
if ISAddAnimalInTrailer then
    _patchGuardedAction(ISAddAnimalInTrailer, "pickup", function(self)
        if self.fromHand then
            local snapshot, context = _resolveInventoryAnimal(self)
            if snapshot and self.animal then
                AACS.ApplyClaimSnapshotToAnimal(self.animal, snapshot)
            end
            return snapshot, context, false
        end
        return _resolveWorldAnimal(self)
    end)

    if ISAddAnimalInTrailer.complete then
        local oldComplete = ISAddAnimalInTrailer.complete
        function ISAddAnimalInTrailer:complete()
            if not _precheck(self, "pickup", function(actionSelf)
                if actionSelf.fromHand then
                    local snapshot, context = _resolveInventoryAnimal(actionSelf)
                    if snapshot and actionSelf.animal then
                        AACS.ApplyClaimSnapshotToAnimal(actionSelf.animal, snapshot)
                    end
                    return snapshot, context, false
                end
                return _resolveWorldAnimal(actionSelf)
            end) then
                return false
            end

            local worldX, worldY, worldZ = _getSquareXYZ(self.animal)
            local okComplete, result = pcall(oldComplete, self)
            if not okComplete then
                error(result)
            end

            if result and self.aacsClaimSnapshot then
                local vx, vy, vz = _getSquareXYZ(self.vehicle)
                _sendTransportState(self.character, _buildPayloadFromContext(self, AACS.TRANSPORT_TRAILER, {
                    vehicleId = _getVehicleId(self.vehicle),
                    transportSignature = _buildSignatureFromAnimal(self.animal),
                    x = vx, y = vy, z = vz,
                    worldX = worldX, worldY = worldY, worldZ = worldZ,
                }))
            end

            return result
        end
    end
end

pcall(require, "TimedActions/Animals/ISRemoveAnimalFromTrailer")
if ISRemoveAnimalFromTrailer then
    _patchGuardedAction(ISRemoveAnimalFromTrailer, "pickup", _resolveTrailerAnimal)

    if ISRemoveAnimalFromTrailer.complete then
        local oldComplete = ISRemoveAnimalFromTrailer.complete
        function ISRemoveAnimalFromTrailer:complete()
            if not _precheck(self, "pickup", _resolveTrailerAnimal) then
                return false
            end

            local vehicleX, vehicleY, vehicleZ = _getSquareXYZ(self.vehicle)
            local okComplete, result = pcall(oldComplete, self)
            if not okComplete then
                error(result)
            end

            if result and self.aacsClaimSnapshot then
                if self.grab then
                    local item = _getHandAnimalItem(self.character)
                    if item then
                        AACS.WriteClaimSnapshotToItem(item, self.aacsClaimSnapshot)
                    end
                    local x, y, z = _captureCharacterXYZ(self.character)
                    _sendTransportState(self.character, _buildPayloadFromContext(self, AACS.TRANSPORT_INVENTORY, {
                        carrierUsername = self.character and self.character:getUsername() or nil,
                        x = x, y = y, z = z,
                        worldX = vehicleX, worldY = vehicleY, worldZ = vehicleZ,
                    }))
                else
                    if self.animal then
                        AACS.ApplyClaimSnapshotToAnimal(self.animal, self.aacsClaimSnapshot)
                    end
                    local x, y, z = _getSquareXYZ(self.animal)
                    _sendTransportState(self.character, _buildPayloadFromContext(self, AACS.TRANSPORT_WORLD, {
                        x = x, y = y, z = z,
                        worldX = x, worldY = y, worldZ = z,
                    }))
                end
            end

            return result
        end
    end
end

pcall(require, "TimedActions/Animals/ISPutAnimalInHutch")
if ISPutAnimalInHutch then
    _patchGuardedAction(ISPutAnimalInHutch, "pickup", function(self)
        local snapshot, context = _resolveInventoryAnimal(self)
        local item = _getHandAnimalItem(self.character)
        local animal = AACS.GetAnimalFromInventoryItem(item)
        if snapshot and animal then
            AACS.ApplyClaimSnapshotToAnimal(animal, snapshot)
        end
        return snapshot, context, false
    end)

    if ISPutAnimalInHutch.complete then
        local oldComplete = ISPutAnimalInHutch.complete
        function ISPutAnimalInHutch:complete()
            if not _precheck(self, "pickup", function(actionSelf)
                local snapshot, context = _resolveInventoryAnimal(actionSelf)
                local item = _getHandAnimalItem(actionSelf.character)
                local animal = AACS.GetAnimalFromInventoryItem(item)
                if snapshot and animal then
                    AACS.ApplyClaimSnapshotToAnimal(animal, snapshot)
                end
                return snapshot, context, false
            end) then
                return false
            end

            local okComplete, result = pcall(oldComplete, self)
            if not okComplete then
                error(result)
            end

            if result and self.aacsClaimSnapshot then
                local hx, hy, hz = _getSquareXYZ(self.hutch)
                _sendTransportState(self.character, _buildPayloadFromContext(self, AACS.TRANSPORT_HUTCH, {
                    hutchX = hx, hutchY = hy, hutchZ = hz,
                    x = hx, y = hy, z = hz,
                }))
            end

            return result
        end
    end
end

pcall(require, "TimedActions/Animals/ISHutchGrabAnimal")
if ISHutchGrabAnimal then
    _patchGuardedAction(ISHutchGrabAnimal, "pickup", _resolveHutchAnimal)

    if ISHutchGrabAnimal.complete then
        local oldComplete = ISHutchGrabAnimal.complete
        function ISHutchGrabAnimal:complete()
            if not _precheck(self, "pickup", _resolveHutchAnimal) then
                return false
            end

            local hx, hy, hz = _getSquareXYZ(self.hutch)
            local okComplete, result = pcall(oldComplete, self)
            if not okComplete then
                error(result)
            end

            if result and self.aacsClaimSnapshot then
                local item = _getHandAnimalItem(self.character)
                if item then
                    AACS.WriteClaimSnapshotToItem(item, self.aacsClaimSnapshot)
                end
                local x, y, z = _captureCharacterXYZ(self.character)
                _sendTransportState(self.character, _buildPayloadFromContext(self, AACS.TRANSPORT_INVENTORY, {
                    carrierUsername = self.character and self.character:getUsername() or nil,
                    x = x, y = y, z = z,
                    worldX = hx, worldY = hy, worldZ = hz,
                }))
            end

            return result
        end
    end
end

pcall(require, "TimedActions/Animals/ISSlaughterAnimal")
if ISSlaughterAnimal then
    _patchGuardedAction(ISSlaughterAnimal, "kill", _resolveWorldAnimal)
end

pcall(require, "TimedActions/Animals/ISKillAnimal")
if ISKillAnimal then
    _patchGuardedAction(ISKillAnimal, "kill", _resolveWorldAnimal)
end

pcall(require, "TimedActions/Animals/ISKillAnimalInInventory")
if ISKillAnimalInInventory then
    _patchGuardedAction(ISKillAnimalInInventory, "kill", _resolveInventoryAnimal)

    if ISKillAnimalInInventory.complete then
        local oldComplete = ISKillAnimalInInventory.complete
        function ISKillAnimalInInventory:complete()
            if not _precheck(self, "kill", _resolveInventoryAnimal) then
                return false
            end

            local okComplete, result = pcall(oldComplete, self)
            if not okComplete then
                error(result)
            end

            if result and self.aacsClaimSnapshot then
                _sendMarkDead(self.character, {
                    uid = tostring(self.aacsClaimSnapshot.UID),
                    transportSignature = (self.aacsClaimContext and self.aacsClaimContext.transportSignature) or nil,
                })
            end

            return result
        end
    end
end
