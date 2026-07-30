TacPHold = TacPHold or {}
TacPHold.activeMasks = {}
TacPHold.poseMode = 1
TacPHold.clearTimers = {}

TacPHold.getRequiredAiming = function()

    if SandboxVars
    and SandboxVars.TacHold
    and SandboxVars.TacHold.PistolAimingRequirement then
        return SandboxVars.TacHold.PistolAimingRequirement
    end

    return 0

end


TacPHold.getEnabledPoses = function()

    local poses = {}

    if TacPHold.options and TacPHold.options.PoseNormal then
        table.insert(poses,{ right = "TacPistolRight", left = "TacPistolLeft" })
    end

    if TacPHold.options and TacPHold.options.PoseHighReady then
        table.insert(poses,{ right = "TacPistolRightHigh", left = "TacPistolLeftHigh" })
    end
	
	if TacPHold.options and TacPHold.options.PoseLowReady then
        table.insert(poses,{ right = "TacPistolRightLow", left = "TacPistolLeftLow" })
    end

    if TacPHold.options and TacPHold.options.PoseVanilla then
        table.insert(poses,{ right = "TacPistolRightVanilla", left = "TacPistolLeftVanilla" })
    end

    if #poses == 0 then
        table.insert(poses,{ right = "TacPistolRightVanilla", left = "TacPistolLeftVanilla" })
    end

    return poses

end

function TacPHold.TogglePose()

    local poses = TacPHold.getEnabledPoses()

    if #poses == 0 then return end

    TacPHold.poseMode = TacPHold.poseMode + 1

    if TacPHold.poseMode > #poses then
        TacPHold.poseMode = 1
    end

    local pose = poses[TacPHold.poseMode]

    if pose then
        print("TacPHold Pose: " .. pose.right)
    end

end


local function clearTacMasks(player)

    if not player then return end

    local pose = TacPHold.activeMasks[player]

    if pose then

        if player:getVariableString("RightHandMask") == pose.right then
            player:clearVariable("RightHandMask")
        end

        if player:getVariableString("LeftHandMask") == pose.left then
            player:clearVariable("LeftHandMask")
        end

    end

    TacPHold.activeMasks[player] = nil
    TacPHold.clearTimers[player] = nil

end

local function tacHold(player)

    if not player or player:isDead() or player:isAsleep() then return end

    local maskActive = TacPHold.activeMasks[player]


   if player:isAiming() then

    if player:isPlayerMoving() then

        if maskActive then
            clearTacMasks(player)
        end

        TacPHold.clearTimers[player] = nil
        return

    end

    if not TacPHold.clearTimers[player] then
        TacPHold.clearTimers[player] = getGameTime():getWorldAgeHours()
    end

    local start = TacPHold.clearTimers[player]
    local now = getGameTime():getWorldAgeHours()

    if (now - start) * 3600 >= 4 then
        if maskActive then
            clearTacMasks(player)
        end
    end

    return
else
    TacPHold.clearTimers[player] = nil
end

    if player:isSneaking() then
        if maskActive then clearTacMasks(player) end
        return
    end


    if player:isSprinting() then
        if maskActive then clearTacMasks(player) end
        return
    end


    local queue = ISTimedActionQueue.queues[player]

    if queue and queue.queue and #queue.queue > 0 then
        if maskActive then clearTacMasks(player) end
        return
    end

    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    if secondary and maskActive then

        local pose = TacPHold.activeMasks[player]

        if pose and player:getVariableString("LeftHandMask") == pose.left then
            player:clearVariable("LeftHandMask")
        end

    end

    if primary and instanceof(primary,"HandWeapon") then

        if primary:isRanged() and not primary:isTwoHandWeapon() then

            local aiming = player:getPerkLevel(Perks.Aiming)
            local required = TacPHold.getRequiredAiming()

            if aiming < required then
                if maskActive then
                    clearTacMasks(player)
                end
                return
            end

            local poses = TacPHold.getEnabledPoses()
            local pose = poses[TacPHold.poseMode]

            player:setVariable("RightHandMask", pose.right)

            if not secondary then
                player:setVariable("LeftHandMask", pose.left)
            end

            TacPHold.activeMasks[player] = pose

            return
        end

    end

    if maskActive then
        clearTacMasks(player)
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

local function TacPHoldInit()

    print("TacPHold Initialized")

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

        if primary and instanceof(primary,"HandWeapon") then
            if primary:isRanged() and not primary:isTwoHandWeapon() then
                TacPHold.TogglePose()
            end
        end

    end

    Events.OnGameStart.Add(function()

        Events.OnPlayerUpdate.Add(onPlayerUpdate)
        Events.OnKeyPressed.Add(onKeyPressed)

    end)

end

TacPHoldInit()