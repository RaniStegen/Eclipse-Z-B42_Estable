local BodyLocations_Helper = {}

BodyLocations_Helper.group = BodyLocations.getGroup("Human")

function BodyLocations_Helper:AddLocation(name, _index)
    -- Build 42.20: append the custom slot without reordering the live Human
    -- group.  moveLocationToIndex is an old/internal helper and changing the
    -- group's indices after WornItems has been initialised can break unrelated
    -- vanilla slots such as wrists and fanny packs.
    if self.group and self.group.getOrCreateLocation then
        self.group:getOrCreateLocation(name)
    end
end

function BodyLocations_Helper:SetExclusive(name, list)
    for _, value in ipairs(list or {}) do
        self.group:setExclusive(name, value)
    end
end

function BodyLocations_Helper:SetHidden(name, list)
    for _, value in ipairs(list or {}) do
        self.group:setHideModel(name, value)
    end
end

function BodyLocations_Helper:SetAltModel(name, list)
    for _, value in ipairs(list or {}) do
        self.group:setAltModel(name, value)
    end
end

return BodyLocations_Helper
