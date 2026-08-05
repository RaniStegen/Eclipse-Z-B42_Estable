-- B42 COMPATIBILITY PATCH
-- Auto-generated null checks for all action overrides

print("Loading FH_B42_Compat patch...")

-- List of actions removed in B42.19 - these are EXPECTED to be missing
-- The code already handles their absence via safe checks (if ActionName and ActionName.method then)
local B42_REMOVED_ACTIONS = {
    "ISFinalizeDealAction",     -- Removed in B42.19
    "ISFireplaceInfoAction",    -- Removed in B42.19
}

-- List of actions that should exist
local B42_OPTIONAL_ACTIONS = {
    "ISCampingInfoAction",
    "ISGeneratorInfoAction",
}

-- Check and log missing actions (only log the optional ones as warnings)
for _, actionName in ipairs(B42_OPTIONAL_ACTIONS) do
    if not _G[actionName] then
        print("FH B42 Compat: " .. actionName .. " not found in B42 - skipping override")
    end
end

print("FH_B42_Compat patch loaded successfully")
