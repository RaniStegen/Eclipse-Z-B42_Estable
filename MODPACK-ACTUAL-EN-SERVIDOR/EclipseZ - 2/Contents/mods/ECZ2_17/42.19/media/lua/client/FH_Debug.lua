-- Fancy Handwork B42.19 - In-Game Debug Command
-- Type /fhstatus in chat to check mod status

local function showFHStatus()
    local player = getSpecificPlayer(0)
    if not player then
        print("FH Status: No player found")
        return
    end

    print("========================================")
    print("Fancy Handwork Build 42.19 - Status")
    print("========================================")

    -- Version info
    print("Version: " .. (FH_VERSION or "Unknown"))
    print("Build Target: " .. (FH_BUILD or "Unknown"))
    print("Compat Mode: " .. tostring(FH_B42_COMPAT_MODE or false))

    -- API Status
    if FH_B42_19 and FH_B42_19.missingAPIs then
        print("\nMissing APIs: " .. #FH_B42_19.missingAPIs)
        if #FH_B42_19.missingAPIs > 0 then
            for _, api in ipairs(FH_B42_19.missingAPIs) do
                print("  - " .. api)
            end
        else
            print("  ✓ All APIs present")
        end
    end

    -- Current player state
    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    print("\nPlayer State:")
    print("  Primary: " .. (primary and primary:getName() or "Empty"))
    print("  Secondary: " .. (secondary and secondary:getName() or "Empty"))

    -- Keybind status
    local core = getCore()
    if core and core.getKey then
        local modKey = core:getKey('FHModifier')
        local swapKey = core:getKey('FHSwapKey')
        print("\nKeybinds:")
        print("  Modifier: " .. tostring(modKey or "Not set"))
        print("  Swap: " .. tostring(swapKey or "Not set"))
    else
        print("\nKeybinds: ERROR - getKey not available")
    end

    -- Loaded components
    print("\nLoaded Components:")
    print("  FancyHands: " .. tostring(_G.FancyHands ~= nil))
    print("  FHSwapHandsAction: " .. tostring(_G.FHSwapHandsAction ~= nil))
    print("  FH_B42_19: " .. tostring(_G.FH_B42_19 ~= nil))

    -- Compatibility mods
    print("\nCompatibility:")
    local activeMods = getActivatedMods()
    print("  SwapIt: " .. tostring(activeMods:contains('SwapIt')))
    print("  BrutalHandwork: " .. tostring(activeMods:contains('BrutalHandwork')))

    print("========================================")
end

-- Register command
Events.OnGameStart.Add(function()
    -- Chat command
    local function onClientCommand(module, command, playerObj, args)
        if module == "FancyHandwork" and command == "status" then
            showFHStatus()
        end
    end

    if isClient() then
        Events.OnServerCommand.Add(onClientCommand)
    end
end)

-- Add slash command support
Events.OnGameBoot.Add(function()
    print("FH Debug: Type '/fhstatus' in console for mod status")
end)

-- Export for console access
_G.FH_ShowStatus = showFHStatus
