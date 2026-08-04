-- AuthenticZ_BodyLocations.lua
-- Build 42.20 multiplayer-safe body-location setup for AuthenticZ.
--
-- Add only AuthenticZ's own locations to the existing Human group.  Never
-- reset, rebuild or reorder the live BodyLocationGroup: WornItems keeps a
-- reference to that exact group and vanilla wrist/fanny-pack slots must remain
-- untouched.

require "NPCs/BodyLocations"

local CUSTOM_LOCATIONS = {
    "AZ:HeadExtra",
    "AZ:HeadExtraHair",
    "AZ:HeadExtraPlus",
    "AZ:NeckExtra",
    "AZ:LegsExtra",
    "AZ:TorsoRigPlus2",
    "AZ:TorsoExtraPlus1",
}

local function resolveLocation(value)
    if value == nil then return nil end
    if type(value) ~= "string" then return value end
    if not ItemBodyLocation or not ResourceLocation then return nil end
    if type(ItemBodyLocation.get) ~= "function" or type(ResourceLocation.of) ~= "function" then
        return nil
    end

    local okResource, resource = pcall(ResourceLocation.of, value)
    if not okResource or not resource then return nil end

    local okLocation, location = pcall(ItemBodyLocation.get, resource)
    if okLocation then return location end
    return nil
end

local function setupAuthenticZBodyLocations()
    local group = BodyLocations and BodyLocations.getGroup and BodyLocations.getGroup("Human") or nil
    if not group or type(group.getOrCreateLocation) ~= "function" then return end

    for _, rawId in ipairs(CUSTOM_LOCATIONS) do
        local locationId = resolveLocation(rawId)
        if locationId then
            pcall(group.getOrCreateLocation, group, locationId)
        end
    end
end

-- BodyLocations.lua is required above, so the group normally exists already.
-- Repeating this on boot is idempotent and catches unusual load orders.
setupAuthenticZBodyLocations()
if Events and Events.OnGameBoot then
    Events.OnGameBoot.Add(setupAuthenticZBodyLocations)
end
