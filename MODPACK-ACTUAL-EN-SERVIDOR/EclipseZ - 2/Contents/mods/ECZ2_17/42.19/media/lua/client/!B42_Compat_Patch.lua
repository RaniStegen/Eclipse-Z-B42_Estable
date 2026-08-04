-- B42.19 FULL COMPATIBILITY PATCH
-- This file ensures compatibility with Build 42.19 API changes

print("Loading Fancy Handwork B42.19 Compatibility Patch...")

-- Flag to enable B42 compatibility mode
FH_B42_COMPAT_MODE = true

-- B42.19 removed some APIs - we need to provide safe fallbacks
local function safePropertyCheck(obj, propertyName)
    if not obj then return false end
    local props = obj:getProperties()
    if not props then return false end

    -- B42.19 changed how properties work
    if props.Is then
        return props:Is(propertyName)
    elseif props.Val then
        return props:Val(propertyName) ~= nil
    end
    return false
end

-- Override problematic door handling for B42.19
Events.OnGameStart.Add(function()
    if FancyHands then
        local _original_doorDecide = FancyHands.doorDecide

        FancyHands.doorDecide = function(obj, playerObj, delayed, fromClick)
            -- B42.19 FIX: Simplified door handling
            if not obj or not playerObj then return nil end

            -- Check if shift is held during click, or if object is destroyed
            if (fromClick and isKeyDown(Keyboard.KEY_LSHIFT)) then return nil end
            if obj.isDestroyed and obj:isDestroyed() then return nil end

            local isGarageDoor = false

            -- Method 1: Check GarageDoor property (vanilla)
            if safePropertyCheck(obj, "GarageDoor") then
                isGarageDoor = true
            end

            -- Method 2: Check sprite name for garage door patterns
            -- Includes common patterns from vanilla and popular mods
            if not isGarageDoor and obj.getSprite then
                local sprite = obj:getSprite()
                if sprite and sprite.getName then
                    local spriteName = string.lower(sprite:getName())
                    -- Common garage door sprite patterns:
                    -- walls_garage_*, construction_01_80-87 (vanilla garage doors)
                    -- Also check for "garagedoor" without space
                    if string.find(spriteName, "garage") or
                       string.find(spriteName, "garagedoor") or
                       (string.find(spriteName, "construction_01_8") and
                        (string.find(spriteName, "construction_01_80") or
                         string.find(spriteName, "construction_01_81") or
                         string.find(spriteName, "construction_01_82") or
                         string.find(spriteName, "construction_01_83") or
                         string.find(spriteName, "construction_01_84") or
                         string.find(spriteName, "construction_01_85") or
                         string.find(spriteName, "construction_01_86") or
                         string.find(spriteName, "construction_01_87"))) then
                        isGarageDoor = true
                    end
                end
            end

            -- Method 3: Check for large door size (garage doors are typically 2+ tiles wide)
            -- This is a fallback for modded garage doors that might not follow naming conventions
            if not isGarageDoor and obj.isDoor and obj:isDoor() then
                -- Check if this is a large door (potential garage door indicator)
                local props = obj:getProperties()
                if props then
                    -- Some garage doors have "IsDoorFrame" property
                    if props.Is and props:Is("IsDoorFrame") then
                        -- Could be a garage door frame
                        isGarageDoor = true
                    end
                end
            end

            -- Return dual-hand high animation for garage doors
            if isGarageDoor then
                return { item = obj, extra = 101 }
            else
                return { item = obj, extra = 0 }
            end
        end

        print("FH B42.19: Door handling patched")
    end
end)

-- B42.19 keybind system compatibility
local function patchKeybinds()
    -- B42.19 uses a different keybind registration system
    if not getCore() or not getCore().getKey then
        print("FH B42.19: Keybind system requires update")
        return
    end

    -- Ensure keybindings table exists
    if not keyBinding then
        keyBinding = {}
        print("FH B42.19: Created keyBinding table")
    end
end

Events.OnGameBoot.Add(patchKeybinds)

print("FH B42.19 Compat Patch loaded successfully")
