-- Fancy Handwork B42.19 - Load Order Controller
-- This file must load FIRST to ensure proper initialization

-- Set load priority
if not FH_LOAD_ORDER then
    FH_LOAD_ORDER = {}
end

FH_LOAD_ORDER.version = "2.0.1"
FH_LOAD_ORDER.build = "42.19"
FH_LOAD_ORDER.loadTime = os.time()

-- Load order priority list
FH_LOAD_ORDER.files = {
    -- 1. Core compatibility (loads via !)
    "!B42_Compat_Patch.lua",
    "FH_B42_19_Init.lua",

    -- 2. Shared core files
    "aFancyHandwork.lua",
    "FancyBoop.lua",

    -- 3. Client files
    "!FHHotbar.lua",
    "FH_B42_Compat.lua",

    -- 4. TimedActions
    "FHSwapHandsAction.lua",
    "FHEquipWeaponAction.lua",
    "FHUnequipAction.lua",
    "FH_ActionOverrides.lua",
    "FH_BoopOverrides.lua",

    -- 5. Vehicle & compatibility
    "FH_VehicleTimedActionOverrides.lua",
    "FH_GunFighterCompat.lua"
}

print("FH Load Order: Version " .. FH_LOAD_ORDER.version .. " for Build " .. FH_LOAD_ORDER.build)
print("FH Load Order: Loaded at " .. FH_LOAD_ORDER.loadTime)

-- Check if all critical files are being loaded
Events.OnGameBoot.Add(function()
    print("FH Load Order: Verifying file load sequence...")

    local criticalFiles = {
        "FancyHands",  -- from aFancyHandwork.lua
        "FHSwapHandsAction",  -- from FHSwapHandsAction.lua
        "FH_B42_COMPAT_MODE",  -- from !B42_Compat_Patch.lua
        "FH_B42_19"  -- from FH_B42_19_Init.lua
    }

    local allLoaded = true
    for _, varName in ipairs(criticalFiles) do
        if not _G[varName] then
            print("FH Load Order: WARNING - " .. varName .. " not found!")
            allLoaded = false
        else
            print("FH Load Order: ✓ " .. varName .. " loaded")
        end
    end

    if allLoaded then
        print("FH Load Order: All critical components loaded successfully!")
    else
        print("FH Load Order: WARNING - Some components missing, mod may not work correctly")
    end
end)
