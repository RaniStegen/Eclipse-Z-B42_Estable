-- Eclipse-Z / Build 42.20
-- Preserve vanilla wrist and fanny-pack slots and repair the four affected
-- wear actions without rebuilding or reordering BodyLocations.

require "NPCs/BodyLocations"
require "TimedActions/ISWearClothing"

local TARGET_NAMES = {
    leftwrist = true,
    rightwrist = true,
    fannypackfront = true,
    fannypackback = true,
}

local BASE_LOCATIONS = {
    ItemBodyLocation.LEFT_WRIST,
    ItemBodyLocation.RIGHT_WRIST,
    ItemBodyLocation.FANNY_PACK_FRONT,
    ItemBodyLocation.FANNY_PACK_BACK,
}

local function locationKey(value)
    if value == nil then return "" end
    return tostring(value):lower():gsub("[^a-z0-9]", "")
end

local function isTargetLocation(value)
    local key = locationKey(value)
    for name, _ in pairs(TARGET_NAMES) do
        if key == name or key:sub(-#name) == name then
            return true
        end
    end
    return false
end

local function ensureLocation(group, location)
    if not group or location == nil then return false end
    if type(group.getOrCreateLocation) ~= "function" then return false end
    local ok = pcall(group.getOrCreateLocation, group, location)
    return ok
end

local function ensureBaseLocationsOnGroup(group)
    for _, location in ipairs(BASE_LOCATIONS) do
        ensureLocation(group, location)
    end
end

local function ensureGlobalBaseLocations()
    local group = BodyLocations and BodyLocations.getGroup and BodyLocations.getGroup("Human") or nil
    ensureBaseLocationsOnGroup(group)
end

local function getCharacterGroup(character)
    if not character then return nil end

    if character.getBodyLocationGroup then
        local ok, group = pcall(character.getBodyLocationGroup, character)
        if ok and group then return group end
    end

    if character.getWornItems then
        local okWorn, wornItems = pcall(character.getWornItems, character)
        if okWorn and wornItems and wornItems.getBodyLocationGroup then
            local okGroup, group = pcall(wornItems.getBodyLocationGroup, wornItems)
            if okGroup then return group end
        end
    end

    return nil
end

local function getItemLocation(item)
    if not item then return nil end

    local isContainer = instanceof and instanceof(item, "InventoryContainer") or false
    local isWearableTag = false
    if ItemTag and ItemTag.WEARABLE and item.hasTag then
        local okTag, result = pcall(item.hasTag, item, ItemTag.WEARABLE)
        isWearableTag = okTag and result or false
    end

    if (isContainer or isWearableTag) and item.canBeEquipped then
        local ok, location = pcall(item.canBeEquipped, item)
        if ok and location ~= nil and tostring(location) ~= "" then
            return location
        end
    end

    if item.getBodyLocation then
        local ok, location = pcall(item.getBodyLocation, item)
        if ok and location ~= nil and tostring(location) ~= "" then
            return location
        end
    end

    return nil
end

local function getWornItem(character, location)
    if not character or not character.getWornItem or location == nil then return nil end
    local ok, item = pcall(character.getWornItem, character, location)
    if ok then return item end
    return nil
end

local function setWornItem(character, location, item)
    if not character or not character.setWornItem or location == nil or not item then
        return false
    end

    local ok = pcall(character.setWornItem, character, location, item)
    if not ok then
        ok = pcall(character.setWornItem, character, tostring(location), item)
    end
    return ok
end

ensureGlobalBaseLocations()

if Events then
    if Events.OnGameBoot then
        Events.OnGameBoot.Add(ensureGlobalBaseLocations)
    end
    if Events.OnGameStart then
        Events.OnGameStart.Add(ensureGlobalBaseLocations)
    end
    if Events.OnServerStarted then
        Events.OnServerStarted.Add(ensureGlobalBaseLocations)
    end
end

-- Keep vanilla complete() authoritative. The wrapper only ensures that the
-- target slot exists on the character's live group before vanilla writes to it,
-- then retries the same setWornItem call if another mod left the slot unusable.
if ISWearClothing and not ISWearClothing.ECZ_B4220_BaseWearFix then
    ISWearClothing.ECZ_B4220_BaseWearFix = true
    local vanillaComplete = ISWearClothing.complete

    function ISWearClothing:complete()
        local item = self.item
        local character = self.character
        local location = getItemLocation(item)
        local target = isTargetLocation(location)

        if target then
            ensureGlobalBaseLocations()
            local characterGroup = getCharacterGroup(character)
            ensureBaseLocationsOnGroup(characterGroup)
            ensureLocation(characterGroup, location)
        end

        local result = vanillaComplete(self)

        if target and result and getWornItem(character, location) ~= item then
            setWornItem(character, location, item)
            if character and character.onWornItemsChanged then
                pcall(character.onWornItemsChanged, character)
            end

            if getWornItem(character, location) ~= item then
                print("[ECZ B42.20] Could not equip " .. tostring(item and item:getFullType())
                    .. " at " .. tostring(location))
            end
        end

        return result
    end
end
