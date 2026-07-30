TacHold = TacHold or {}
TacHold.activeMasks = {}
TacHold.poseMode = {}
TacHold.clearTimers = {}
TacHold.remotePoses = TacHold.remotePoses or {}

TacHold.getRequiredAiming = function()
    if SandboxVars and SandboxVars.TacHold and SandboxVars.TacHold.AimingRequirement then
        return SandboxVars.TacHold.AimingRequirement
    end
    return 0
end

TacHold.getCycleKey = function()
    local opt = TacHold and TacHold.options and TacHold.options.CycleKey
    if opt and opt.getValue then
        local v = opt:getValue()
        if type(v) == "number" and v >= 0 then
            return v
        end
    end
    return Keyboard.KEY_U
end

TacHold.getEnabledPoses = function()
    local poses = {}
    
    local function getOptVal(opt)
        if not opt then return false end
        if opt.getValue then
            local v = opt:getValue()
            if v ~= nil then return v end
        end
        if opt.value ~= nil then return opt.value end
        return true
    end

    if TacHold.options and getOptVal(TacHold.options.PoseNormal) then
        table.insert(poses, "TacGunPose")
    end
    if TacHold.options and getOptVal(TacHold.options.PoseHighReady) then
        table.insert(poses, "TacGunPoseHighReady")
    end
    if TacHold.options and getOptVal(TacHold.options.PoseLowReady) then
        table.insert(poses, "TacGunPoseLowready")
    end
    if TacHold.options and getOptVal(TacHold.options.PoseGunResting) then
        table.insert(poses, "TacGunResting")
    end
    if TacHold.options and getOptVal(TacHold.options.PoseVanilla) then
        table.insert(poses, "Vanilla")
    end
    if #poses == 0 then
        table.insert(poses, "Vanilla")
    end
    return poses
end

function TacHold.TogglePose(player)
    if not player then return end
    local poses = TacHold.getEnabledPoses()
    TacHold.poseMode[player] = (TacHold.poseMode[player] or 1) + 1
    if TacHold.poseMode[player] > #poses then
        TacHold.poseMode[player] = 1
    end
    print("TacHold Pose: " .. poses[TacHold.poseMode[player]])
end

local function clearTacMask(player)
    if not player then return end
    local pose = TacHold.activeMasks[player]
    if pose and player:getVariableString("RightHandMask") == pose then
        player:clearVariable("RightHandMask")
    end
    TacHold.activeMasks[player] = nil
    TacHold.clearTimers[player] = nil
    player:getModData().TacHoldPose = nil
    player:transmitModData()

    if player:isLocalPlayer() then
        sendClientCommand(player, "TacHoldSync", "setPose", { type = "rifle", pose = nil })
    end
end

local function tacHold(player)
    -- Death/Sleep check
    if player:isDead() or player:isAsleep() then
        if TacHold.activeMasks[player] then clearTacMask(player) end
        return
    end

    local maskActive = TacHold.activeMasks[player]
    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    -- Valid Weapon Check (rifles / two-handed ranged)
    if primary and instanceof(primary, "HandWeapon") and primary:isRanged() and primary:isTwoHandWeapon() and (secondary == nil or secondary == primary) then
        
        if player:isAiming() or player:isSneaking() then
            if maskActive then clearTacMask(player) end
            return
        end
        
        local aiming = player:getPerkLevel(Perks.Aiming)
        local required = TacHold.getRequiredAiming()
        
        if aiming < required then
            if maskActive then clearTacMask(player) end
            return
        end

        local poses = TacHold.getEnabledPoses()
        local mode = TacHold.poseMode[player] or 1
        local pose = poses[mode]

        -- Animation trigger
        if player:getVariableString("RightHandMask") ~= pose then
            player:setVariable("RightHandMask", pose)
            TacHold.activeMasks[player] = pose
            player:getModData().TacHoldPose = pose
            player:transmitModData()

            if player:isLocalPlayer() then
                sendClientCommand(player, "TacHoldSync", "setPose", { type = "rifle", pose = pose })
            end
        end
        
        return
    end

    -- Fallthrough (If no gun, clear)
    if maskActive then
        clearTacMask(player)
    end
end

local function tacHoldMP(mPlayer)
    if not mPlayer or mPlayer:isLocalPlayer() then return end

    -- Safety Check: Clear animation if the player is dead or asleep
    if mPlayer:isDead() or mPlayer:isAsleep() then
        if mPlayer:getVariableString("RightHandMask") ~= "" then
            mPlayer:clearVariable("RightHandMask")
        end
        return
    end

    local username = mPlayer:getUsername()
    if TacPHold and TacPHold.remotePoses and TacPHold.remotePoses[username] then
        return
    end

    local current = mPlayer:getVariableString("RightHandMask")
    local netPose = TacHold.remotePoses[username]

    if netPose then
        if current ~= netPose then
            mPlayer:setVariable("RightHandMask", netPose)
        end
    else
        if current ~= "" and current ~= nil then
            mPlayer:clearVariable("RightHandMask")
        end
    end
end

local function TacHoldInit()
    if isServer() then return end

    local function onPlayerUpdate(player)
        if not player:isLocalPlayer() then return end
        
        tacHold(player)
        
        local players = getOnlinePlayers()
        if players then
            for i = 0, players:size() - 1 do
                local remotePlayer = players:get(i)
                if remotePlayer and not remotePlayer:isLocalPlayer() then
                    tacHoldMP(remotePlayer)
                end
            end
        end
    end

    local function onKeyPressed(key)
        if key ~= TacHold.getCycleKey() then return end

        local player = getPlayer()
        if not player then return end

        local primary = player:getPrimaryHandItem()
        local secondary = player:getSecondaryHandItem()

        if primary and instanceof(primary, "HandWeapon") and primary:isRanged() and primary:isTwoHandWeapon() and (secondary == nil or secondary == primary) then
            TacHold.TogglePose(player)
        end
    end

    Events.OnGameStart.Add(function()
        if TacHold.options and TacHold.options.CycleKey and TacHold.options.CycleKey.apply then
            TacHold.options.CycleKey:apply()
        end

        Events.OnPlayerUpdate.Add(onPlayerUpdate)
        Events.OnKeyPressed.Add(onKeyPressed)
    end)
end

TacHoldInit()

-- ============================================================
-- TacHold Sync Events (Server and Client)
-- ============================================================
TacHold.remotePoses = TacHold.remotePoses or {}
TacPHold = TacPHold or {}
TacPHold.remotePoses = TacPHold.remotePoses or {}

if isServer() then
    local function onClientCommand(module, command, player, args)
        if module == "TacHoldSync" then
            if command == "setPose" then
                local username = player:getUsername()
                if args.type == "rifle" then
                    TacHold.remotePoses[username] = args.pose
                elseif args.type == "pistol" then
                    if args.right or args.left then
                        TacPHold.remotePoses[username] = { right = args.right, left = args.left }
                    else
                        TacPHold.remotePoses[username] = nil
                    end
                end
                sendServerCommand("TacHoldSync", "updatePose", { username = username, args = args })
            elseif command == "requestPoses" then
                sendServerCommand(player, "TacHoldSync", "initPoses", {
                    rifle = TacHold.remotePoses,
                    pistol = TacPHold.remotePoses
                })
            end
        end
    end
    Events.OnClientCommand.Add(onClientCommand)
end

if not isServer() then
    local function onServerCommand(module, command, args)
        if module == "TacHoldSync" then
            if command == "updatePose" then
                local username = args.username
                local poseArgs = args.args
                if poseArgs.type == "rifle" then
                    TacHold.remotePoses[username] = poseArgs.pose
                elseif poseArgs.type == "pistol" then
                    if poseArgs.right or poseArgs.left then
                        TacPHold.remotePoses[username] = { right = poseArgs.right, left = poseArgs.left }
                    else
                        TacPHold.remotePoses[username] = nil
                    end
                end
            elseif command == "initPoses" then
                if args.rifle then
                    for u, p in pairs(args.rifle) do
                        TacHold.remotePoses[u] = p
                    end
                end
                if args.pistol then
                    for u, p in pairs(args.pistol) do
                        TacPHold.remotePoses[u] = p
                    end
                end
            end
        end
    end
    Events.OnServerCommand.Add(onServerCommand)

    local function clientOnCreatePlayer(playerIndex, player)
        if player:isLocalPlayer() then
            sendClientCommand(player, "TacHoldSync", "requestPoses", {})
        end
    end
    Events.OnCreatePlayer.Add(clientOnCreatePlayer)
end