-- AuthenticZ_BodyLocations.lua
-- Build 42.20 multiplayer-safe body-location setup for AuthenticZ.
--
-- AuthenticZ only needs to add its own slots to the existing Human group.
-- Never reset or rebuild BodyLocations here: doing so invalidates the live
-- BodyLocationGroup used by the character and can make vanilla watches,
-- fanny packs and other wearable items finish their timed action without
-- actually becoming equipped.

require "NPCs/BodyLocations"

local BodyAPI = BodyLocations
local SlotAPI = ItemBodyLocation
local RL = ResourceLocation

local function resolveLocation(value)
    if value == nil then return nil end
    if type(value) ~= "string" then return value end
    return SlotAPI.get(RL.of(value))
end

local function insertRelative(group, anchorValue, beforeAnchor, rawIds)
    if not group then return end

    local anchorId = resolveLocation(anchorValue)
    local ids = {}

    for _, rawId in ipairs(rawIds) do
        local locationId = resolveLocation(rawId)
        if locationId then
            group:getOrCreateLocation(locationId)
            ids[#ids + 1] = locationId
        end
    end

    -- Ordering is visual only, but keep the original anchored order whenever
    -- the current Build exposes the required methods.  Failure to move a slot
    -- must never remove or recreate any existing vanilla/modded location.
    if not anchorId or not group.indexOf or not group.moveLocationToIndex then
        return
    end

    local ok, anchorIndex = pcall(function()
        return group:indexOf(anchorId)
    end)
    if not ok or anchorIndex == nil or anchorIndex < 0 then
        return
    end

    local firstIndex = beforeAnchor and anchorIndex or (anchorIndex + 1)
    for offset, locationId in ipairs(ids) do
        pcall(function()
            group:moveLocationToIndex(locationId, firstIndex + offset - 1)
        end)
    end
end

local function setupAuthenticZBodyLocations()
    local group = BodyAPI.getGroup("Human")
    if not group then return end

    local outerVestLayer =
        SlotAPI.TORSO_EXTRA_VEST_BULLET
        or SlotAPI.TORSO_EXTRA_VEST
        or SlotAPI.TORSO_EXTRA

    insertRelative(group, SlotAPI.HAT, false, {
        "AZ:HeadExtra",
        "AZ:HeadExtraHair",
        "AZ:HeadExtraPlus",
    })

    insertRelative(group, SlotAPI.JACKET, false, {
        "AZ:NeckExtra",
    })

    insertRelative(group, SlotAPI.SHOES, true, {
        "AZ:LegsExtra",
    })

    insertRelative(group, outerVestLayer, false, {
        "AZ:TorsoRigPlus2",
        "AZ:TorsoExtraPlus1",
    })
end

Events.OnGameBoot.Add(setupAuthenticZBodyLocations)
