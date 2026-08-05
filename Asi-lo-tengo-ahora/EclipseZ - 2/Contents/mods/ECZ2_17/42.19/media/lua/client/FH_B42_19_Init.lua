-- Fancy Handwork Build 42.19 Initialization and Compatibility Layer
-- This file ensures the mod works properly with Build 42.19

print("===========================================")
print("Fancy Handwork Build 42.19 - Initializing")
print("===========================================")

-- Version info
FH_VERSION = "2.0-B42.19"
FH_BUILD = "42.19"

-- B42.19 API Check and Compatibility Layer
FH_B42_19 = {
    apiChecks = {},
    missingAPIs = {},
    warnings = {}
}

-- Check for critical B42.19 APIs
local function checkAPI(name, obj, method)
    local exists = false

    if method then
        -- For player instance methods, create a test player
        if name == "IsoPlayer" then
            local testPlayer = getSpecificPlayer(0)
            if testPlayer and testPlayer[method] then
                exists = true
            end
        elseif obj and obj[method] then
            exists = true
        end
    else
        exists = _G[name] ~= nil
    end

    FH_B42_19.apiChecks[name .. (method and ("." .. method) or "")] = exists

    if not exists then
        table.insert(FH_B42_19.missingAPIs, name .. (method and ("." .. method) or ""))
    end

    return exists
end

-- Perform API checks AFTER game starts (when player exists)
Events.OnGameStart.Add(function()
    print("FH B42.19: Performing API compatibility checks...")

    -- Check core game APIs
    checkAPI("ISTimedActionQueue", ISTimedActionQueue, "add")
    checkAPI("ISBaseTimedAction", ISBaseTimedAction, "new")
    checkAPI("ISEquipWeaponAction", ISEquipWeaponAction, "new")
    checkAPI("ISUnequipAction", ISUnequipAction, "new")
    checkAPI("ISHotbar", ISHotbar, "equipItem")

    -- Check potentially missing B42 actions (these were removed in B42.19, expected to be missing)
    -- These checks are kept for compatibility logging but are expected to fail
    -- Suppressed from warning list as they are known removals
    local b42RemovedAPIs = {
        "ISFinalizeDealAction",
        "ISFireplaceInfoAction",
        "IsoPlayer.getItemInHand"
    }

    -- Only check APIs that should exist
    checkAPI("ISCampingInfoAction")
    checkAPI("ISGeneratorInfoAction")

    -- Check player APIs
    checkAPI("IsoPlayer", nil, "getPrimaryHandItem")
    checkAPI("IsoPlayer", nil, "getSecondaryHandItem")
    checkAPI("IsoPlayer", nil, "setVariable")
    checkAPI("IsoPlayer", nil, "getVariableBoolean")

    -- Check animation APIs
    checkAPI("CharacterActionAnims")

    -- Report missing APIs
    if #FH_B42_19.missingAPIs > 0 then
        print("FH B42.19: WARNING - Missing APIs detected:")
        for _, api in ipairs(FH_B42_19.missingAPIs) do
            print("  - " .. api)
        end
        print("FH B42.19: Some features may be disabled")
    else
        print("FH B42.19: ✓ All critical APIs present!")
    end

    print("FH B42.19: Initialization complete")
    print("FH B42.19: Version " .. FH_VERSION)
end)

-- Safe wrapper for player variable access
FH_B42_19.safeSetVariable = function(player, varName, value)
    if not player or not player.setVariable then
        return false
    end
    player:setVariable(varName, value)
    return true
end

FH_B42_19.safeClearVariable = function(player, varName)
    if not player or not player.clearVariable then
        return false
    end
    player:clearVariable(varName)
    return true
end

FH_B42_19.safeGetVariableBoolean = function(player, varName)
    if not player or not player.getVariableBoolean then
        return false
    end
    return player:getVariableBoolean(varName)
end

-- Safe wrapper for action queue
FH_B42_19.safeAddAction = function(action)
    if not ISTimedActionQueue or not ISTimedActionQueue.add then
        print("FH B42.19: ERROR - Cannot add action, ISTimedActionQueue missing")
        return false
    end
    ISTimedActionQueue.add(action)
    return true
end

-- Framerate fallback for B42.19
FH_B42_19.getFramerate = function()
    if getPerformance and getPerformance() and getPerformance().getFramerate then
        return getPerformance():getFramerate()
    end
    return 60 -- Safe default
end

-- Perk level fallback
FH_B42_19.getPerkLevel = function(player, perk)
    if not player or not player.getPerkLevel then
        return 0
    end
    if not perk then
        return 0
    end
    return player:getPerkLevel(perk)
end

print("FH B42.19: Core compatibility layer loaded")
