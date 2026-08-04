------------------------------------------
-- Fancy Handwork Init
------------------------------------------

FancyHands = FancyHands or {}

------------------------------------------
-- Fancy Handwork Configuration
------------------------------------------

FancyHands.config = {
    applyRotationL = true
}

FancyHands.nomask = {
	["Base.Torch"] = true,
	["Base.HandTorch"] = true,
	["Base.UmbrellaBlack"] = true,
	["Base.UmbrellaWhite"] = true,
	["Base.UmbrellaBlue"] = true
}

FancyHands.special = {
    ["Base.Generator"] = "holdinggenerator",
    ["Base.CorpseMale"] = "holdingbody",
    ["Base.CorpseFemale"] = "holdingbody"
}

-- Use the animations from this mod instead!
if getActivatedMods():contains('Skizots Visible Boxes and Garbage2') then
    FancyHands.special = {}
end

-- We will begin to store compatibility objects here
FancyHands.compat = {}
-- if getActivatedMods():contains('Amputation2') then -- now included in TOC!
--     FancyHands.compat.TOC = require('compat/FH_TOC')
-- end
if getActivatedMods():contains('BrutalHandwork') then
    FancyHands.compat.brutal = true
end
------------------------------------------
-- Fancy Handwork Utilities
------------------------------------------

function isFHModKeyDown()
    -- B42.19 FIX: Safe key checking
    local core = getCore()
    if not core or not core.getKey then return false end
    local key = core:getKey('FHModifier')
    if not key then return false end
    return isKeyDown(key)
end

function isFHModBindDown(player)
    -- B42.19 FIX: Safe bind checking
    local modKeyDown = isFHModKeyDown()
    if player and player.isLBPressed then
        return modKeyDown or player:isLBPressed()
    end
    return modKeyDown
end

local FHswapItems = function(character)
    local primary = character:getPrimaryHandItem()
    -- B42 API: Use getSecondaryHandItem() for secondary hand
    local secondary = character:getSecondaryHandItem()
    if (primary or secondary) and (primary ~= secondary) then
        ISTimedActionQueue.add(FHSwapHandsAction:new(character, primary, secondary, 10))
    end
end

local FHswapItemsMod = function(character)
    if isFHModKeyDown() then
        FHswapItems(character)
    end
end

local FHcreateBindings = function()
    -- B42.19 FIX: Ensure keyBinding table exists
    if not keyBinding then
        keyBinding = {}
        print("FH: Created keyBinding table for B42.19")
    end

    local FHbindings = {
        {
            name = '[FancyHandwork]'
        },
        {
            value = 'FHModifier',
            key = Keyboard.KEY_LCONTROL,
        },
        {
            value = 'FHSwapKey',
            action = FHswapItems,
            key = 0,
        },
        {
            value = 'FHSwapKeyMod',
            action = FHswapItemsMod,
            key = Keyboard.KEY_E,
            swap = true
        },
    }

    for _, bind in ipairs(FHbindings) do
        if bind.name then
            table.insert(keyBinding, { value = bind.name, key = nil })
        else
            if bind.key then
                table.insert(keyBinding, { value = bind.value, key = bind.key })
            end
        end
    end

    local FHhandleKeybinds = function(key)
        local player = getSpecificPlayer(0)
        if not player then return end

        local action
        local core = getCore()
        if not core or not core.getKey then return end

        for _,bind in ipairs(FHbindings) do
            local bindKey = core:getKey(bind.value)
            if bindKey and key == bindKey then
                if bind.swap then
                    if isFHModKeyDown() then
                        action = bind.action
                        break
                    end
                else
                    action = bind.action
                    break
                end
            end
        end

        if not action or isGamePaused() or player:isDead() then
            return
        end
        action(player)
    end

    FancyHands.addKeyBind = function(keybind)
        table.insert(FHbindings, keybind)
    end

    Events.OnGameStart.Add(function()
        Events.OnKeyPressed.Add(FHhandleKeybinds)
    end)

end

-- Mask values this mod owns. Anything else in RightHandMask/LeftHandMask was put
-- there by vanilla (torch, bag, umbrella) or another mod, so we must not clear it.
local FHOwnedMasks = {
    ["holdinggunright"] = true,
    ["holdingitemright"] = true,
    ["holdinghgunleft"] = true,
    ["holdingitemleft"] = true,
    ["holdinggenerator"] = true,
    ["holdingbody"] = true,
    ["bhunarmedaim"] = true,
}

---Set the given anim mask, or clear it when we own the stale value.
function FancyHands.applyMask(player, varName, mask)
    if mask then
        player:setVariable(varName, mask)
        return
    end
    local current = player:getVariableString(varName)
    if current and FHOwnedMasks[current] then
        player:clearVariable(varName)
    end
end

local function calcRecentMove(player)
    -- B42.19 FIX: Safe modData access
    if not player.getModData then return end

    player:getModData().FancyHands = player:getModData().FancyHands or {
        recentMove = false,
        recentDelta = 0
    }

    if player:isPlayerMoving() then
        player:getModData().FancyHands.recentMove = true
        player:getModData().FancyHands.recentDelta = 0
    else
        if player:getModData().FancyHands.recentMove then
            player:getModData().FancyHands.recentDelta = player:getModData().FancyHands.recentDelta + 1
            local turnDelay = 1
            if SandboxVars.FancyHandwork and SandboxVars.FancyHandwork.TurnDelaySec then
                turnDelay = SandboxVars.FancyHandwork.TurnDelaySec
            end
            -- B42.19 FIX: Safe framerate access
            local framerate = 60
            if getPerformance and getPerformance() and getPerformance().getFramerate then
                framerate = getPerformance():getFramerate()
            end
            if player:getModData().FancyHands.recentDelta >= turnDelay * framerate then
                player:getModData().FancyHands.recentMove = false
            end
        end
    end
end



local function fancy(player)
    if not player or player:isDead() or player:isAsleep() then return end

    -- B42.19: Keep using getSecondaryHandItem() - it's still available in B42
    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    -- B42.19 FIX: Safe variable access
    -- IMPORTANT: Only block animations during actual timed actions, not just "IsPerformingAnAction"
    local queue = ISTimedActionQueue.queues[player]
    local doingAction = (queue and #queue.queue > 0 and not queue.queue[1].FHIgnore) or false
    player:setVariable("FHDoingAction", doingAction)

    -- 2 hands (two-handed weapon)
    if primary == secondary then
        if primary then
            if FancyHands.special[primary:getFullType()] then
                player:setVariable("LeftHandMask", FancyHands.special[primary:getFullType()])
                FancyHands.applyMask(player, "RightHandMask", nil)
                return
            end
            -- some other mods do have their own anim masks, so lets keep those!
            if primary:getItemReplacementPrimaryHand() then
                FancyHands.applyMask(player, "LeftHandMask", nil)
                return
            end

            -- B42.19 FIX: Tactical Hold compatibility - don't clear their RightHandMask
            if TacHold and TacHold.activeMasks and TacHold.activeMasks[player] then
                -- Tactical Hold is active for this player, don't interfere
                return
            end
        end
        -- B42.19 FIX: Safe Brutal Handwork compat check
        if FancyHands.compat.brutal then
            local equipped = instanceof(primary, "HandWeapon") and primary:getCategories():contains("Unarmed")
            -- we already established that primary and secondary are the same, so if primary is nil then so is secondary
            -- or, this is a 2h fist weapon and therefore we should still get ready to punch
            if (not primary and player:isAiming() and (SandboxVars.BrutalHandwork and SandboxVars.BrutalHandwork.EnableUnarmed and (SandboxVars.BrutalHandwork.AlwaysUnarmed or isFHModBindDown(player)))) or equipped then
                player:setVariable("RightHandMask", "bhunarmedaim")
                return
            end
        end
        FancyHands.applyMask(player, "LeftHandMask", nil)
        FancyHands.applyMask(player, "RightHandMask", nil)
        return
    end

    -- While a timed action runs the AnimSets already gate on FHDoingAction, so
    -- leave the masks alone and let the action own the arms.
    if doingAction then return end

    -- B42 FIX: don't leave a stale mask behind. The old code only ever *set*
    -- RightHandMask/LeftHandMask, so dropping the item in one hand while still
    -- holding something in the other left that arm pinned to the FH holding
    -- pose forever - which reads as "aiming and melee animations are frozen".
    local rightMask = nil
    if primary and not primary:getItemReplacementPrimaryHand() and instanceof(primary, "HandWeapon") then
        rightMask = (primary:isRanged() and "holdinggunright") or "holdingitemright"
    end

    -- Check if left hand aiming is enabled in sandbox (default: true)
    local enableLeftHandAiming = true
    if SandboxVars.FancyHandwork and SandboxVars.FancyHandwork.EnableLeftHandAiming ~= nil then
        enableLeftHandAiming = SandboxVars.FancyHandwork.EnableLeftHandAiming
    end

    local leftMask = nil
    if enableLeftHandAiming and secondary and not secondary:getItemReplacementSecondHand() and instanceof(secondary, "HandWeapon") then
        leftMask = (secondary:isRanged() and "holdinghgunleft") or "holdingitemleft"
    end

    if rightMask and enableLeftHandAiming then
        -- B42.19 FIX: Safe perk level check
        local aimingLevel = 0
        if player.getPerkLevel and Perks and Perks.Aiming then
            aimingLevel = player:getPerkLevel(Perks.Aiming)
        end
        -- The sandbox option is named ExperiencedAim (see sandbox-options.txt);
        -- the old ExperiencedAiming lookup was always nil, pinning this to 3.
        local experiencedAiming = 3
        if SandboxVars.FancyHandwork and SandboxVars.FancyHandwork.ExperiencedAim then
            experiencedAiming = SandboxVars.FancyHandwork.ExperiencedAim
        end
        player:setVariable("FHExp", aimingLevel >= experiencedAiming)
    end

    -- B42.19 FIX: Tactical Hold compatibility - don't fight over their masks
    if TacHold and TacHold.activeMasks and TacHold.activeMasks[player] then
        return
    end

    FancyHands.applyMask(player, "RightHandMask", rightMask)
    FancyHands.applyMask(player, "LeftHandMask", leftMask)
end

local curPlayer = 0
local function fancyMP(player)
    if not player or player:isDead() or player:isAsleep() then return end
    
    fancy(player)
    
    -- We will do one player per tick to set their state
    ---- We do this to ensure each tick doesn't take too long
    local players = getOnlinePlayers()
    if curPlayer > (players:size()-1) then curPlayer = 0 end
    local mPlayer = players:get(curPlayer)
    if mPlayer ~= player then
        fancy(mPlayer)
    end
    curPlayer = curPlayer + 1
end

local function FancyHandwork()
    print(getText("UI_Init_FancyHandwork"))

    if isServer() then return end
    FHcreateBindings()

    Events.OnGameStart.Add(function()
        if isClient() then
            Events.OnPlayerUpdate.Add(function(player)
                fancyMP(player)
                calcRecentMove(player)
            end)
        else
            Events.OnPlayerUpdate.Add(function(player)
                fancy(player)
                calcRecentMove(player)
            end)
        end
    end)
end

FancyHandwork()

