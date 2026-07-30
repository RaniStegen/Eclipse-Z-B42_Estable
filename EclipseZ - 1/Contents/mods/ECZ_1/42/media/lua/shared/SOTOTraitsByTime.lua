------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

--------------------
-- TRAITS BY TIME --
--------------------

local SOTOSbvars = SandboxVars.SOTO;

-- Send HaloText+sound to player: server->client command in MP, direct call in SP
local function SOTOnotifyUI(player, textKey, isGain)
    if isServer() then
        sendServerCommand(player, "SOTO", "TraitChangedUI", {textKey = textKey, isGain = isGain or false})
    else
        HaloTextHelper.addTextWithArrow(player, getText(textKey), isGain or false, HaloTextHelper.getColorGreen())
        getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50)
    end
end

-- Returns player list: ArrayList of online players on server, or wrapped local player in SP
local function SOTOgetPlayers()
    if isServer() then
        return getOnlinePlayers()
    end
    local p = getPlayer()
    if not p then return nil end
    return {size = function(self) return 1 end, get = function(self, i) return p end}
end

-- REMOVE SUNDAY DRIVER
local function SOTOprocessSundayDriver(player)
    if not player:hasTrait(CharacterTrait.SUNDAY_DRIVER) then return end

    if player:getModData().SundayDriverMinsWhileDriving == nil then
        player:getModData().SundayDriverMinsWhileDriving = 0
    end

    local SundayDriverHoursToRemoveMin = SOTOSbvars.SundayDriverHoursToRemoveMin
    local SundayDriverHoursToRemoveMax = SOTOSbvars.SundayDriverHoursToRemoveMax
    local SundayDriverMinsToRemoveMin = SundayDriverHoursToRemoveMin * 60
    local SundayDriverMinsToRemoveMax = SundayDriverHoursToRemoveMax * 60
    local SundayDriverMinsToRemoveDiff = SundayDriverMinsToRemoveMax - SundayDriverMinsToRemoveMin
    local SundayDriverMinsToRemove = SundayDriverMinsToRemoveMin + ZombRand(SundayDriverMinsToRemoveDiff)

    if player:hasTrait(CharacterTrait.FAST_LEARNER) then
        SundayDriverMinsToRemove = SundayDriverMinsToRemove * 0.7
    elseif player:hasTrait(CharacterTrait.SLOW_LEARNER) then
        SundayDriverMinsToRemove = SundayDriverMinsToRemove * 1.3
    end

    if player:isDriving() and not player:isAsleep() then
        local vehicle = player:getVehicle()
        if vehicle:getCurrentSpeedKmHour() >= 10 then
            player:getModData().SundayDriverMinsWhileDriving = player:getModData().SundayDriverMinsWhileDriving + 1
        end
    end

    if player:getModData().SundayDriverMinsWhileDriving >= SundayDriverMinsToRemove then
        if SOTOSbvars.SundayDriverRemovable then
            SOTOremoveTrait(player, CharacterTrait.SUNDAY_DRIVER)
            SOTOnotifyUI(player, "UI_trait_SundayDriver", false)
            player:getModData().SundayDriverMinsWhileDriving = 0
        end
    end

    if player:getModData().SundayDriverMinsWhileDriving > SundayDriverMinsToRemoveMax then
        player:getModData().SundayDriverMinsWhileDriving = SundayDriverMinsToRemoveMax
    elseif player:getModData().SundayDriverMinsWhileDriving < 0 then
        player:getModData().SundayDriverMinsWhileDriving = 0
    end
end

function SOTOremoveSundayDriver()
    if isClient() then return end
    local players = SOTOgetPlayers()
    if not players then return end
    for i = 0, players:size() - 1 do
        SOTOprocessSundayDriver(players:get(i))
    end
end


-- REMOVE SMOKER TRAIT
local function SOTOprocessSmoker(player)
    if not player:hasTrait(CharacterTrait.SMOKER) then return end

    if player:getModData().SmokerHoursNotSmoking == nil then
        player:getModData().SmokerHoursNotSmoking = 0
    end

    local SmokerHoursToRemoveMin = SOTOSbvars.SmokerHoursToRemoveMin
    local SmokerHoursToRemoveMax = SOTOSbvars.SmokerHoursToRemoveMax
    local SmokerHoursToRemoveDiff = SmokerHoursToRemoveMax - SmokerHoursToRemoveMin
    local SmokerHoursToRemove = SmokerHoursToRemoveMin + ZombRand(SmokerHoursToRemoveDiff)
    local SmokerDaysSinceLastSmoke = player:getTimeSinceLastSmoke()  -- returns days, not hours

    if SmokerDaysSinceLastSmoke >= 10 then  -- 10 in-game hours expressed in days
        player:getModData().SmokerHoursNotSmoking = player:getModData().SmokerHoursNotSmoking + 1
        print("[SOTO] Player is trying to quit smoking. Hours smoke-free: " .. player:getModData().SmokerHoursNotSmoking .. " / " .. SmokerHoursToRemove)
    else
        player:getModData().SmokerHoursNotSmoking = player:getModData().SmokerHoursNotSmoking - 3
    end

    if player:getModData().SmokerHoursNotSmoking > SmokerHoursToRemoveMax then
        player:getModData().SmokerHoursNotSmoking = SmokerHoursToRemoveMax
    elseif player:getModData().SmokerHoursNotSmoking < 0 then
        player:getModData().SmokerHoursNotSmoking = 0
    end

    if player:getModData().SmokerHoursNotSmoking >= SmokerHoursToRemove and player:hasTrait(CharacterTrait.SMOKER) then
        if SOTOSbvars.SmokerRemovable == true then
            print("[SOTO] Removing Smoker trait, adding Former Smoker.")
            SOTOsetTimeSinceLastSmoke(player, 0)
            SOSetCigStress(player, 0)
            SOTOremoveTrait(player, CharacterTrait.SMOKER)
            SOTOaddTrait(player, SOTO.CharacterTrait.FORMER_SMOKER)
            SOTOnotifyUI(player, "UI_trait_formersmoker", false)
            print("[SOTO] Done. hasSmoker=" .. tostring(player:hasTrait(CharacterTrait.SMOKER)) .. " hasFormerSmoker=" .. tostring(player:hasTrait(SOTO.CharacterTrait.FORMER_SMOKER)))
        end
    end
end

function SOTOremoveSmoker()
    if isClient() then return end
    local players = SOTOgetPlayers()
    if not players then return end
    for i = 0, players:size() - 1 do
        SOTOprocessSmoker(players:get(i))
    end
end


-- ITEMS TRANSFER
local function SOTOprocessItemsTransfer(player)
    if player:hasTrait(CharacterTrait.ALL_THUMBS) then
        local AllThumbsValueToRemove = SOTOSbvars.AllThumbsValueToRemove

        if player:getModData().AllThumbsTransferredValue == nil then
            player:getModData().AllThumbsTransferredValue = 0
        end

        if player:getModData().AllThumbsTransferredValue >= AllThumbsValueToRemove then
            if SOTOSbvars.AllThumbsRemovable == true then
                SOTOremoveTrait(player, CharacterTrait.ALL_THUMBS)
                SOTOnotifyUI(player, "UI_trait_AllThumbs", false)
            end
        end
    end

    if player:hasTrait(CharacterTrait.DISORGANIZED) then
        local DisorganizedValueToRemove = SOTOSbvars.DisorganizedValueToRemove

        if player:getModData().DisorganizedTransferredValue == nil then
            player:getModData().DisorganizedTransferredValue = 0
        end

        if player:getModData().DisorganizedTransferredValue >= DisorganizedValueToRemove then
            if SOTOSbvars.DisorganizedRemovable == true then
                SOTOremoveTrait(player, CharacterTrait.DISORGANIZED)
                SOTOnotifyUI(player, "UI_trait_Disorganized", false)
            end
        end
    end
end

function SOTOItemsTransfer()
    if isClient() then return end
    local players = SOTOgetPlayers()
    if not players then return end
    for i = 0, players:size() - 1 do
        SOTOprocessItemsTransfer(players:get(i))
    end
end


-- CLIENT: receive UI notification from server when a trait changes
Events.OnServerCommand.Add(function(module, command, args)
    if module ~= "SOTO" then return end
    if command == "TraitChangedUI" then
        local player = getPlayer()
        if not player then return end
        HaloTextHelper.addTextWithArrow(player, getText(args.textKey), args.isGain or false, HaloTextHelper.getColorGreen())
        getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50)
    end
end)

Events.EveryHours.Add(SOTOremoveSmoker);
Events.EveryOneMinute.Add(SOTOremoveSundayDriver);
Events.EveryOneMinute.Add(SOTOItemsTransfer);
