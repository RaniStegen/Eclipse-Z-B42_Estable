TacHold = TacHold or {}
TacHold.activeMasks = {}
TacHold.poseMode = 1
TacHold.clearTimers = {}


TacHold.getRequiredAiming = function()
    if SandboxVars
    and SandboxVars.TacHold
    and SandboxVars.TacHold.AimingRequirement then
        return SandboxVars.TacHold.AimingRequirement
    end
    return 0
end


TacHold.getEnabledPoses = function()
    local poses = {}

    if TacHold.options and TacHold.options.PoseNormal then
        table.insert(poses, "TacGunPose")
    end

    if TacHold.options and TacHold.options.PoseHighReady then
        table.insert(poses, "TacGunPoseHighReady")
    end

    if TacHold.options and TacHold.options.PoseLowReady then
        table.insert(poses, "TacGunPoseLowready")
    end
	
	if TacHold.options and TacHold.options.PoseGunResting then
        table.insert(poses, "TacGunResting")
    end

    if TacHold.options and TacHold.options.PoseVanilla then
        table.insert(poses, "Vanilla")
    end

    if #poses == 0 then
        table.insert(poses, "Vanilla")
    end

    return poses
end


function TacHold.TogglePose()
    local poses = TacHold.getEnabledPoses()

    TacHold.poseMode = TacHold.poseMode + 1
    if TacHold.poseMode > #poses then
        TacHold.poseMode = 1
    end

    print("TacHold Pose: " .. poses[TacHold.poseMode])
end


local function clearTacMask(player)
    if not player then return end

    local pose = TacHold.activeMasks[player]

    if pose then
        if player:getVariableString("RightHandMask") == pose then
            player:clearVariable("RightHandMask")
        end
    end

    TacHold.activeMasks[player] = nil
    TacHold.clearTimers[player] = nil
end


local function tacHold(player)

    if not player or player:isDead() or player:isAsleep() then
        return
    end

    local maskActive = TacHold.activeMasks[player]


    if player:isAiming() then

        if player:isPlayerMoving() then
            if maskActive then
                clearTacMask(player)
            end
            TacHold.clearTimers[player] = nil
            return
        end

        if not TacHold.clearTimers[player] then
            TacHold.clearTimers[player] = getGameTime():getWorldAgeHours()
        end

        local start = TacHold.clearTimers[player]
        local now = getGameTime():getWorldAgeHours()

        if (now - start) * 3600 >= 4 then
            if maskActive then
                clearTacMask(player)
            end
        end

        return
    else
        TacHold.clearTimers[player] = nil
    end


    local queue = ISTimedActionQueue.queues[player]

    if queue then
        local firstAction = queue.queue[1]

        if firstAction and firstAction:isValid() and not firstAction.THIgnore then
            if maskActive then
                clearTacMask(player)
            end
            return
        end
    end
	
    if player:isSneaking() then
        if maskActive then clearTacMask(player) end
        return
    end


    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    if primary and instanceof(primary, "HandWeapon") and primary:isRanged() and primary:isTwoHandWeapon() and (secondary == nil or secondary == primary) then

         
            local aiming = player:getPerkLevel(Perks.Aiming)
            local required = TacHold.getRequiredAiming()

            if aiming < required then
                if maskActive then
                    clearTacMask(player)
                end
                return
            end

            local poses = TacHold.getEnabledPoses()
            local pose = poses[TacHold.poseMode]

            player:setVariable("RightHandMask", pose)
            TacHold.activeMasks[player] = pose


            return
    end


    if maskActive then
        clearTacMask(player)
    end
end


local curPlayer = 0

local function tacHoldMP(player)

    if not player or player:isDead() or player:isAsleep() then return end

    tacHold(player)
	
    local players = getOnlinePlayers()
    if not players or players:size() == 0 then return end


    if curPlayer >= players:size() then
        curPlayer = 0
    end

    local mPlayer = players:get(curPlayer)

    if mPlayer and mPlayer ~= player then
        tacHold(mPlayer)
    end

    curPlayer = curPlayer + 1
end


local function TacHoldInit()

    print("TacHold Initialized")

    if isServer() then return end

    local function onPlayerUpdate(player)

      tacHold(player)

    end

local function onKeyPressed(key)
    local bind = getCore():getKey("TacHoldCycle")

    if key ~= bind then return end

    local player = getPlayer()
    if not player then return end

    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    if primary and instanceof(primary, "HandWeapon") and primary:isRanged() and primary:isTwoHandWeapon() and (secondary == nil or secondary == primary) then
        TacHold.TogglePose()
    end
end

    Events.OnGameStart.Add(function()

        Events.OnPlayerUpdate.Add(onPlayerUpdate)
        Events.OnKeyPressed.Add(onKeyPressed)

    end)

end
local function registerTacHoldKey()
    if not ModOptions or not ModOptions.AddKeyBinding then return end

    local keyData = {
        key = Keyboard.KEY_U,
        name = "TacHoldCycle"
    }

    ModOptions:AddKeyBinding("[Player Control]", keyData)
end

Events.OnGameBoot.Add(registerTacHoldKey)

TacHoldInit()