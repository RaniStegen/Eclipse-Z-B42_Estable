local function FR_DrivingAnimiation(player)
    local vehicle = player:getVehicle()
    if not vehicle then
        return
    end
    local vehicleName = vehicle:getScriptName()
    -- DebugLog.log("FR_DrivingAnimiation: The player, " .. tostring(player:getUsername()) .. ", entered " .. tostring(vehicleName))
    if not vehicleName:contains("fr_") then
        return
    end

    local passCompPart = vehicle:getPartById("PassengerCompartment")
    local keyvalues = passCompPart:getTable("FRSeatAnimations")
    local seatPos = vehicle:getSeat(player)
    -- DebugLog.log ("FR_DrivingAnimiation: seatPos is " .. seatPos)
    local seatAnim = ""
    if keyvalues and passCompPart then
        -- SeatFrontLeft starts at 0
        if seatPos == 0 then
            seatAnim = keyvalues.seat0 or ""
        elseif seatPos == 1 then
            seatAnim = keyvalues.seat1
        elseif seatPos == 2 then
            seatAnim = keyvalues.seat2
        elseif seatPos == 3 then
            seatAnim = keyvalues.seat3
        elseif seatPos == 4 then
            seatAnim = keyvalues.seat4
        elseif seatPos == 5 then
            seatAnim = keyvalues.seat5
        elseif seatPos == 6 then
            seatAnim = keyvalues.seat6
        elseif seatPos == 7 then
            seatAnim = keyvalues.seat7
        elseif seatPos == 8 then
            seatAnim = keyvalues.seat8
        elseif seatPos == 9 then
            seatAnim = keyvalues.seat9
        elseif seatPos == 10 then
            seatAnim = keyvalues.seat10
        elseif seatPos == 11 then
            seatAnim = keyvalues.seat11
        end
        seatAnim = tostring(seatAnim or keyvalues.seatAll or "")
        -- DebugLog.log ("FR_DrivingAnimiation: seatAnim is " .. tostring(seatAnim))
        -- This sends the info to the server so it can tell the other players to sync the animations
        -- DebugLog.log("FR_DrivingAnimiation: isClient: " .. tostring(isClient()) .. ", isServer: " .. tostring(isServer()))
        if isClient() then
            local args = {
                seatAnim = seatAnim,
                onlineID = player:getOnlineID()
            }
            -- DebugLog.log("FR_DrivingAnimiation: isClient: " .. tostring(isClient()) .. ", should be multiplayer. Sending info to be set later. isServer: " .. tostring(isServer()))
            -- DebugLog.log("FR_DrivingAnimiation: player is " .. tostring(player) .. ", username is " .. tostring(player:getUsername()) .. ", onlineID is " .. tostring(player:getOnlineID()))
            sendClientCommand(player, 'FR_VehicleAnimations', 'FR_SendPlayerAnimation', args)
        else
            -- DebugLog.log("FR_DrivingAnimiation: isClient: " .. tostring(isClient()) .. ", should be singleplayer, setting variable directly.")
            -- player:SetVariable("FR_Animation", seatAnim)
            player:SetVariable("FR_Vehicle", "True")
        end
    end
end

local function FR_ExitAnimation(player)
    local seatAnim = ""
    -- DebugLog.log("FR_ExitAnimation: isClient: " .. tostring(isClient()) .. ", isServer: " .. tostring(isServer()))
    -- DebugLog.log("FR_DrivingAnimiation: The player, " .. tostring(player:getUsername()) .. ", exited a vehicle")
    if isClient() then
        local args = {
            seatAnim = seatAnim,
            onlineID = player:getOnlineID()
        }
        sendClientCommand(player, 'FR_VehicleAnimations', 'FR_SendPlayerAnimation', args)
        -- DebugLog.log("FR_ExitAnimation: isClient: " .. tostring(isClient()) .. ", should be multiplayer. , isServer: " .. tostring(isServer()))
        -- DebugLog.log("FR_ExitAnimation: player is " .. tostring(player) .. ", username is " .. tostring(player:getUsername()) .. ", online Id is " .. tostring(player:getOnlineID()))
        -- DebugLog.log("FR_ExitAnimation: player is " .. tostring(getPlayerByOnlineID(player:getOnlineID())))
    else
        player:SetVariable("FR_Animation", seatAnim)
        player:SetVariable("FR_Vehicle", "False")
        -- DebugLog.log("FR_ExitAnimation: isClient: " .. tostring(isClient()) .. ", should be singleplayer, setting variable directly.")
    end
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

Events.OnEnterVehicle.Add(FR_DrivingAnimiation)
Events.OnSwitchVehicleSeat.Add(FR_DrivingAnimiation)
Events.OnExitVehicle.Add(FR_ExitAnimation)

local originalEV = ISEnterVehicle.start

function ISEnterVehicle:start()
    if string.starts(self.vehicle:getScript():getFullName(), "Base.fr_fo_b700_") or
        self.vehicle:getScript():getFullName() == "Base.fr_fl_bounder_86" or
        string.starts(self.vehicle:getScript():getFullName(), "Base.fr_pe_359_82_") then
        if not isServer() then
            local playerNum = self.character:getPlayerNum()
            getCell():setDrag(nil, playerNum)
            local contextMenu = getPlayerContextMenu(playerNum)
            if contextMenu and contextMenu:isAnyVisible() then
                contextMenu:hideAndChildren()
            end
        end

        self.started = true

        local outside = self.vehicle:getPassengerPosition(self.seat, "outside")
        local worldPos = Vector3f.new()
        self.vehicle:getWorldPos(outside:getOffset(), worldPos)

        if self.character:DistTo(worldPos:x(), worldPos:y()) > 4 then
            return
        end

        self.action:setBlockMovementEtc(true) -- ignore 'E' while entering
        self.vehicle:enter(self.seat, self.character)
        self.vehicle:playPassengerSound(self.seat, "enter")
        self.character:SetVariable("bEnteringVehicle", "true")
        self.character:triggerMusicIntensityEvent("VehicleEnter")

        if (self.character:getPrimaryHandItem() and self.character:getPrimaryHandItem():hasTag(ItemTag.HEAVY_ITEM)) or
            (self.character:getSecondaryHandItem() and self.character:getSecondaryHandItem():hasTag(ItemTag.HEAVY_ITEM)) then
            if isClient() then
                local args = {
                    id = self.character:getOnlineID()
                }
                sendClientCommand(self.character, 'player', 'onDropHeavyItem', args)
            else
                forceDropHeavyItems(self.character)
            end
        end
    else
        originalEV(self)
    end
end
