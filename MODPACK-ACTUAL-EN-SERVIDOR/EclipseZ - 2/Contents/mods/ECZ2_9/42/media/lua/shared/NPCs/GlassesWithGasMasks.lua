--[[
    GlassesWithGasMasks.lua

    Lets prescription glasses stay on under full-face gas masks and welding
    masks. Vanilla puts those masks in body locations (base:maskeyes,
    base:maskfull) that are exclusive with the Eyes location, so equipping
    one auto-removes glasses. This mod registers two parallel locations
    (gwgm:maskeyes, gwgm:maskfull) that copy every vanilla exclusion EXCEPT
    the eye ones, then reassigns every clothing item using the old locations
    to the new ones at OnGameBoot.

    Build 42.20 compatibility: custom slots are appended only. The live Human
    BodyLocationGroup is never reordered after WornItems has been initialised.
--]]

local NS            = "gwgm"
local NEW_MASK_EYES = NS .. ":maskeyes"
local NEW_MASK_FULL = NS .. ":maskfull"

local function hasFn(object, name)
    return object and type(object[name]) == "function"
end

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

    local okResource, resource = pcall(ResourceLocation.of, id)
    if not okResource or not resource then return nil end

    local okLocation, location = pcall(ItemBodyLocation.get, resource)
    if okLocation then return location end
    return nil
end

safeRegister(NEW_MASK_EYES)
safeRegister(NEW_MASK_FULL)

local group = BodyLocations and BodyLocations.getGroup and BodyLocations.getGroup("Human") or nil
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

local function ex(first, second)
    if first and second and hasFn(group, "setExclusive") then
        pcall(group.setExclusive, group, first, second)
    end
end

-- MASK_EYES exclusions, intentionally excluding eye/glasses slots.
if newMaskEyes then
    ex(newMaskEyes, ItemBodyLocation.MASK)
    ex(newMaskEyes, ItemBodyLocation.MASK_FULL)
    ex(newMaskEyes, ItemBodyLocation.FULL_HAT)
    ex(newMaskEyes, ItemBodyLocation.SCBA)
    ex(newMaskEyes, ItemBodyLocation.SCBANOTANK)
    ex(newMaskEyes, ItemBodyLocation.FULL_SUIT_HEAD)
end

-- MASK_FULL exclusions, intentionally excluding eye/glasses slots.
if newMaskFull then
    ex(newMaskFull, ItemBodyLocation.HAT)
    ex(newMaskFull, ItemBodyLocation.MASK_EYES)
    ex(newMaskFull, ItemBodyLocation.MASK)
    ex(newMaskFull, ItemBodyLocation.FULL_HAT)
    ex(newMaskFull, ItemBodyLocation.SCBA)
    ex(newMaskFull, ItemBodyLocation.SCBANOTANK)
    ex(newMaskFull, ItemBodyLocation.FULL_SUIT_HEAD)
end

if newMaskEyes and newMaskFull then
    ex(newMaskEyes, newMaskFull)
end

-- Do not call indexOf/moveLocationToIndex here. Render-order movement is only
-- cosmetic; preserving the live group is required for reliable equipping.

local function locStrLower(item)
    if not hasFn(item, "getBodyLocation") then return "" end
    local ok, value = pcall(item.getBodyLocation, item)
    if not ok or value == nil then return "" end
    local text = tostring(value)
    if text == "" or text == "nil" then return "" end
    return string.lower(text)
end

local function isMaskEyesLoc(text)
    return text ~= "" and string.find(text, "maskeyes", 1, true) ~= nil
end

local function isMaskFullLoc(text)
    return text ~= "" and string.find(text, "maskfull", 1, true) ~= nil
end

local function reportSamples(seen)
    local sample = {}
    for value, _ in pairs(seen) do
        sample[#sample + 1] = value
        if #sample >= 12 then break end
    end
    table.sort(sample)
    print("[GlassesWithGasMasks] First body-location strings observed: "
            .. table.concat(sample, ", "))
end

local function reassignMaskItems()
    local scriptManager = getScriptManager and getScriptManager() or nil
    if not scriptManager or not hasFn(scriptManager, "getAllItems") then
        print("[GlassesWithGasMasks] ScriptManager.getAllItems unavailable; cannot reassign items.")
        return
    end

    local items = scriptManager:getAllItems()
    if not items or not hasFn(items, "size") then return end

    local switchedEyes, switchedFull, scanned = 0, 0, 0
    local seenLocations = {}

    for index = 0, items:size() - 1 do
        local item = items:get(index)
        if item then
            scanned = scanned + 1
            local location = locStrLower(item)
            if location ~= "" then seenLocations[location] = true end

            if hasFn(item, "DoParam") then
                if isMaskEyesLoc(location) then
                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_EYES)
                    switchedEyes = switchedEyes + 1
                elseif isMaskFullLoc(location) then
                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_FULL)
                    switchedFull = switchedFull + 1
                end
            end
        end
    end

    print(string.format(
        "[GlassesWithGasMasks] Scanned %d script items. Reassigned %d MaskEyes items and %d MaskFull items.",
        scanned, switchedEyes, switchedFull
    ))

    if switchedEyes == 0 and switchedFull == 0 then
        reportSamples(seenLocations)
    end
end

if Events and Events.OnGameBoot then
    Events.OnGameBoot.Add(reassignMaskItems)
end
