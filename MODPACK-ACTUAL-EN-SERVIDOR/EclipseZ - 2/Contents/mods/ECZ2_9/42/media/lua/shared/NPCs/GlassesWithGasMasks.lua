--[[
    GlassesWithGasMasks.lua

    Lets prescription glasses stay on under full-face gas masks and welding
    masks. Vanilla puts those masks in body locations (base:maskeyes,
    base:maskfull) that are exclusive with the Eyes location, so equipping
    one auto-removes glasses. This mod registers two parallel locations
    (gwgm:maskeyes, gwgm:maskfull) that copy every vanilla exclusion EXCEPT
    the eye ones, then reassigns every clothing item using the old locations
    to the new ones at OnGameBoot. Catches modded masks that reuse the
    vanilla locations. Modded masks on custom body locations are out of
    scope (rare in practice).
--]]

local NS            = "gwgm"
local NEW_MASK_EYES = NS .. ":maskeyes"
local NEW_MASK_FULL = NS .. ":maskfull"

local function hasFn(o, name) return o and type(o[name]) == "function" end

-- ---------- Step 1: register the two custom body locations ----------

local function safeRegister(id)
    if ItemBodyLocation and type(ItemBodyLocation.register) == "function" then
        pcall(ItemBodyLocation.register, id)
    end
end

local function resolveLoc(id)
    if not (ItemBodyLocation and ResourceLocation
            and type(ResourceLocation.of) == "function"
            and type(ItemBodyLocation.get) == "function") then
        return nil
    end
    local ok, loc = pcall(ItemBodyLocation.get, ResourceLocation.of(id))
    if ok then return loc end
    return nil
end

safeRegister(NEW_MASK_EYES)
safeRegister(NEW_MASK_FULL)

local group = BodyLocations and BodyLocations.getGroup and BodyLocations.getGroup("Human")
if not group then
    print("[GlassesWithGasMasks] BodyLocationGroup 'Human' unavailable; mod inactive.")
    return
end

local newMaskEyes = resolveLoc(NEW_MASK_EYES)
local newMaskFull = resolveLoc(NEW_MASK_FULL)

if newMaskEyes and hasFn(group, "getOrCreateLocation") then
    pcall(group.getOrCreateLocation, group, newMaskEyes)
end
if newMaskFull and hasFn(group, "getOrCreateLocation") then
    pcall(group.getOrCreateLocation, group, newMaskFull)
end

-- ---------- Step 2: clone vanilla exclusions, minus eye ones ----------

local function ex(a, b)
    if a and b and hasFn(group, "setExclusive") then
        pcall(group.setExclusive, group, a, b)
    end
end

-- MASK_EYES vanilla exclusions (from media/lua/shared/NPCs/BodyLocations.lua):
--   EYES, LEFT_EYE, RIGHT_EYE         <- dropped (this is the whole point)
--   MASK, MASK_FULL                   <- kept (mask-on-mask)
--   FULL_HAT                          <- kept (NBC hood etc.)
--   SCBA, SCBANOTANK                  <- kept (breathing apparatus)
--   FULL_SUIT_HEAD                    <- kept (hazmat)
if newMaskEyes then
    ex(newMaskEyes, ItemBodyLocation.MASK)
    ex(newMaskEyes, ItemBodyLocation.MASK_FULL)
    ex(newMaskEyes, ItemBodyLocation.FULL_HAT)
    ex(newMaskEyes, ItemBodyLocation.SCBA)
    ex(newMaskEyes, ItemBodyLocation.SCBANOTANK)
    ex(newMaskEyes, ItemBodyLocation.FULL_SUIT_HEAD)
end

-- MASK_FULL vanilla exclusions:
--   EYES, LEFT_EYE, RIGHT_EYE         <- dropped
--   HAT, MASK_EYES, MASK              <- kept (other headgear/masks)
--   FULL_HAT                          <- kept
--   SCBA, SCBANOTANK                  <- kept
--   FULL_SUIT_HEAD                    <- kept
if newMaskFull then
    ex(newMaskFull, ItemBodyLocation.HAT)
    ex(newMaskFull, ItemBodyLocation.MASK_EYES)
    ex(newMaskFull, ItemBodyLocation.MASK)
    ex(newMaskFull, ItemBodyLocation.FULL_HAT)
    ex(newMaskFull, ItemBodyLocation.SCBA)
    ex(newMaskFull, ItemBodyLocation.SCBANOTANK)
    ex(newMaskFull, ItemBodyLocation.FULL_SUIT_HEAD)
end

-- Cross-exclude the two custom locations themselves. After Step 4,
-- gas masks live at gwgm:maskeyes and welding masks at gwgm:maskfull,
-- so the vanilla cross-exclusion above never fires between them.
if newMaskEyes and newMaskFull then
    ex(newMaskEyes, newMaskFull)
end

-- ---------- Step 3: render order ----------
-- Place each new location at the same index as the vanilla one so layers
-- above (e.g. eyes, scarf) keep covering the mask the way they did before.

local function moveNear(vanillaLoc, customLoc)
    if vanillaLoc and customLoc
            and hasFn(group, "indexOf") and hasFn(group, "moveLocationToIndex") then
        local ok, idx = pcall(group.indexOf, group, vanillaLoc)
        if ok and type(idx) == "number" and idx >= 0 then
            pcall(group.moveLocationToIndex, group, customLoc, idx)
        end
    end
end

moveNear(ItemBodyLocation.MASK_EYES, newMaskEyes)
moveNear(ItemBodyLocation.MASK_FULL, newMaskFull)

-- ---------- Step 4: reassign every mask item after all mods load ----------
-- B42 getBodyLocation() doesn't always return a plain Lua string for the
-- script template (can be a ResourceLocation-like object). Coerce via
-- tostring() and substring-match on the lowercased form, the same way
-- ArmorMakesSense reads body locations. This also tolerates module-prefix
-- variants ("base:maskeyes" vs bare "MaskEyes" vs uppercased forms).

local function locStrLower(item)
    if not hasFn(item, "getBodyLocation") then return "" end
    local ok, v = pcall(item.getBodyLocation, item)
    if not ok or v == nil then return "" end
    local s = tostring(v)
    if s == "" or s == "nil" then return "" end
    return string.lower(s)
end

local function isMaskEyesLoc(s)
    return s ~= "" and string.find(s, "maskeyes", 1, true) ~= nil
end

local function isMaskFullLoc(s)
    return s ~= "" and string.find(s, "maskfull", 1, true) ~= nil
end

-- Dump the first few distinct body locations we see, so if we ever miss
-- again we can see exactly what string form items are returning.
local function reportSamples(seen)
    local sample = {}
    local n = 0
    for k, _ in pairs(seen) do
        n = n + 1
        sample[#sample + 1] = k
        if n >= 12 then break end
    end
    table.sort(sample)
    print("[GlassesWithGasMasks] First body-location strings observed: "
            .. table.concat(sample, ", "))
end

local function reassignMaskItems()
    local sm = getScriptManager and getScriptManager() or nil
    if not sm or not hasFn(sm, "getAllItems") then
        print("[GlassesWithGasMasks] ScriptManager.getAllItems unavailable; cannot reassign items.")
        return
    end

    local items = sm:getAllItems()
    if not items or not hasFn(items, "size") then return end

    local switchedEyes, switchedFull, scanned = 0, 0, 0
    local seenLocs = {}
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item then
            scanned = scanned + 1
            local loc = locStrLower(item)
            if loc ~= "" then seenLocs[loc] = true end
            if hasFn(item, "DoParam") then
                if isMaskEyesLoc(loc) then
                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_EYES)
                    switchedEyes = switchedEyes + 1
                elseif isMaskFullLoc(loc) then
                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_FULL)
                    switchedFull = switchedFull + 1
                end
            end
        end
    end

    print(string.format("[GlassesWithGasMasks] Scanned %d script items. Reassigned %d MaskEyes items and %d MaskFull items.",
            scanned, switchedEyes, switchedFull))
    if switchedEyes == 0 and switchedFull == 0 then
        reportSamples(seenLocs)
    end
end

Events.OnGameBoot.Add(reassignMaskItems)
