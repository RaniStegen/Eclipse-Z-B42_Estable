IDBFS = IDBFS or {}
IDBFS.Compatibility = IDBFS.Compatibility or {}

function IDBFS.Compatibility.patchRCStructureFramework()
    if IDBFS.Compatibility.RCStructureFrameworkPatched then
        return
    end

    local ok, materialContainers = pcall(require, "RCStructureFramework/MaterialContainers")
    if not ok or type(materialContainers) ~= "table" or type(materialContainers.isContainer) ~= "function" then
        return
    end

    local originalIsContainer = materialContainers.isContainer
    materialContainers.isContainer = function(structureId, item)
        if item ~= nil and type(item.hasTag) ~= "function" then
            return false
        end
        local success, result = pcall(originalIsContainer, structureId, item)
        return success and result == true
    end

    IDBFS.Compatibility.RCStructureFrameworkPatched = true
end

if Events and Events.OnGameStart then
    Events.OnGameStart.Add(IDBFS.Compatibility.patchRCStructureFramework)
end

IDBFS.Compatibility.patchRCStructureFramework()
