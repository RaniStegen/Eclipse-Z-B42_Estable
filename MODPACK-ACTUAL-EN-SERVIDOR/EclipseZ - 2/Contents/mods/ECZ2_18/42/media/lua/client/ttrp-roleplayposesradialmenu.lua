-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- hi, i'm Chris, and I wrote this exstensively modified emote code by referencing RPactions pose mod made by Fuu, please ask them or me first if you use this code! --
-- To contact me, my Discord is ''crystalchris'' for any questions or comments or concerns!                                                                          --            
-- The first half of this file deals with the ghost mode application when posing to remove player collision hitboxes to allow for paired emotes.                     --
-- The second half deals with the actual meat and potatoes of the UI and posing adjacent code.                                                                       --
--  ________      ________       ___    ___  ________       _________    ________      ___           ________      ___  ___      ________      ___      ________     -- 
--|\   ____\    |\   __  \     |\  \  /  /||\   ____\     |\___   ___\ |\   __  \    |\  \         |\   ____\    |\  \|\  \    |\   __  \    |\  \    |\   ____\     --
--\ \  \___|    \ \  \|\  \    \ \  \/  / /\ \  \___|_    \|___ \  \_| \ \  \|\  \   \ \  \        \ \  \___|    \ \  \\\  \   \ \  \|\  \   \ \  \   \ \  \___|_    --
-- \ \  \        \ \   _  _\    \ \    / /  \ \_____  \        \ \  \   \ \   __  \   \ \  \        \ \  \        \ \   __  \   \ \   _  _\   \ \  \   \ \_____  \   --
--  \ \  \____    \ \  \\  \|    \/  /  /    \|____|\  \        \ \  \   \ \  \ \  \   \ \  \____    \ \  \____    \ \  \ \  \   \ \  \\  \|   \ \  \   \|____|\  \  --
--   \ \_______\   \ \__\\ _\  __/  / /        ____\_\  \        \ \__\   \ \__\ \__\   \ \_______\   \ \_______\   \ \__\ \__\   \ \__\\ _\    \ \__\    ____\_\  \ --
--    \|_______|    \|__|\|__||\___/ /        |\_________\        \|__|    \|__|\|__|    \|_______|    \|_______|    \|__|\|__|    \|__|\|__|    \|__|   |\_________\--
--                            \|___|/         \|_________|                                                                                               \|_________|--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

require 'ISUI/ISEmoteRadialMenu'
require "ttrpfavorites"

local TTRPEmoteMenuAPI = {}
TTRPSliceTable = TTRPSliceTable or {}
local EmoteMenuAPICompat = nil
local okEmoteMenuAPI, emoteMenuAPIValue = pcall(function()
    return _G["EmoteMenuAPI"]
end)
if okEmoteMenuAPI then
    EmoteMenuAPICompat = emoteMenuAPIValue
end

function TTRPEmoteMenuAPI.registerSlice(sliceName, sliceFunction)
    if type(sliceName) ~= "string" or type(sliceFunction) ~= "function" then
        return
    end
    TTRPSliceTable[sliceName] = sliceFunction
    if EmoteMenuAPICompat and EmoteMenuAPICompat.registerSlice then
        EmoteMenuAPICompat.registerSlice(sliceName, sliceFunction)
    end
end

function TTRPEmoteMenuAPI.unregisterSlice(sliceName)
    TTRPSliceTable[sliceName] = nil
end

local function TTRPRadialBack(menu, oldSlices)
    menu:clear()
    for _, oldSlice in ipairs(oldSlices) do
        menu:addSlice(
            oldSlice.text,
            oldSlice.texture,
            oldSlice.command[1],
            oldSlice.command[2],
            oldSlice.command[3],
            oldSlice.command[4],
            oldSlice.command[5],
            oldSlice.command[6],
            oldSlice.command[7]
        )
    end
    if menu.display then
        menu:display()
    else
        menu:addToUIManager()
    end
end

local function TTRPGetSliceText(radialMenu, sliceIndex)
    if not radialMenu or not radialMenu.slices then
        return nil
    end
    if sliceIndex < 1 or sliceIndex > #radialMenu.slices then
        return nil
    end
    return radialMenu.slices[sliceIndex].text
end

local function TTRPGetSliceTexture(radialMenu, sliceIndex)
    if not radialMenu or not radialMenu.slices then
        return nil
    end
    if sliceIndex < 1 or sliceIndex > #radialMenu.slices then
        return nil
    end
    return radialMenu.slices[sliceIndex].texture
end

local function TTRPRadialHelper()
    if not ISRadialMenu then
        return false
    end

    -- Build 42 removed helpers supplied by the old radial-menu dependency.
    -- Restore only the missing methods on the vanilla radial menu.
    if not ISRadialMenu.getSliceText then
        function ISRadialMenu:getSliceText(sliceIndex)
            if not self.slices or sliceIndex < 1 or sliceIndex > #self.slices then
                return nil
            end
            return self.slices[sliceIndex].text
        end
    end

    if not ISRadialMenu.getSliceTexture then
        function ISRadialMenu:getSliceTexture(sliceIndex)
            if not self.slices or sliceIndex < 1 or sliceIndex > #self.slices then
                return nil
            end
            return self.slices[sliceIndex].texture
        end
    end

    if not ISRadialMenu.display then
        function ISRadialMenu:display(releaseButton, joypadIgnoreAimUntilCentered)
            releaseButton = releaseButton or self.hideWhenButtonReleased
            if not releaseButton and Joypad then
                releaseButton = Joypad.DPadUp
            end
            joypadIgnoreAimUntilCentered = joypadIgnoreAimUntilCentered ~= false

            self:addToUIManager()

            local joypadPlayer = JoypadState
                and JoypadState.players
                and JoypadState.players[self.playerNum + 1]
            if joypadPlayer then
                if releaseButton then
                    self:setHideWhenButtonReleased(releaseButton)
                end
                setJoypadFocus(self.playerNum, self)
                local playerObj = getSpecificPlayer(self.playerNum)
                if playerObj then
                    playerObj:setJoypadIgnoreAimUntilCentered(joypadIgnoreAimUntilCentered)
                end
            end
        end
    end

    if not ISRadialMenu.createSubMenu then
        function ISRadialMenu:createSubMenu(onSubMenu, args)
            if type(onSubMenu) ~= "function" then
                return
            end

            local oldSlices = self.slices
            self:clear()
            onSubMenu(self, args)
            self:addSlice(
                getText("IGUI_Emote_Back"),
                getTexture("media/ui/emotes/back.png"),
                TTRPRadialBack,
                self,
                oldSlices
            )
            self:display()
        end
    end

    return true
end

local function TTRPIsGhostingEnabled()
    return SandboxVars.TTRPPoses and SandboxVars.TTRPPoses.ToggleGhosting or false
end

local function TTRPGetGhostRange()
    if SandboxVars.TTRPPoses and SandboxVars.TTRPPoses.GhostToggleRange then
        return SandboxVars.TTRPPoses.GhostToggleRange
    end
    return 30
end

local function TTRPMenuHasSlice(menu, sliceText)
    if not menu or not menu.slices or not sliceText then
        return false
    end
    for i = 1, #menu.slices do
        if menu.slices[i].text == sliceText then
            return true
        end
    end
    return false
end

local function TTRPInstallEmoteMenuHook()
    if not TTRPRadialHelper() then
        return false
    end
    if not ISEmoteRadialMenu or type(ISEmoteRadialMenu.fillMenu) ~= "function" then
        return false
    end

    if ISEmoteRadialMenu._TTRPWrappedFillMenu and ISEmoteRadialMenu._TTRPBaseFillMenu then
        ISEmoteRadialMenu.fillMenu = ISEmoteRadialMenu._TTRPWrappedFillMenu
        return true
    end

    if ISEmoteRadialMenu._TTRPWrappedFillMenu and ISEmoteRadialMenu.fillMenu == ISEmoteRadialMenu._TTRPWrappedFillMenu then
        return true
    end

    local baseFillMenu = ISEmoteRadialMenu._TTRPBaseFillMenu
    if not baseFillMenu then
        local currentFillMenu = ISEmoteRadialMenu.fillMenu
        if currentFillMenu ~= ISEmoteRadialMenu._TTRPWrappedFillMenu then
            baseFillMenu = currentFillMenu
            ISEmoteRadialMenu._TTRPBaseFillMenu = baseFillMenu
        end
    end

    if not baseFillMenu then
        return false
    end

    local wrappedFillMenu = function(self, submenu)
        baseFillMenu(self, submenu)

        if submenu then
            return
        end

        local menu = getPlayerRadialMenu(self.playerNum)
        if not menu then
            return
        end

        for sliceName, sliceFunction in pairs(TTRPSliceTable) do
            local sliceText = sliceName
            if sliceName == "TTRP Poses" then
                sliceText = getText("IGUI_TTRP_Poses")
            end
            if not TTRPMenuHasSlice(menu, sliceText) then
                local ok, err = pcall(sliceFunction, menu, self.character)
                if not ok then
                    print("TTRP Poses slice failed: " .. tostring(err))
                end
            end
        end
    end

    ISEmoteRadialMenu._TTRPWrappedFillMenu = wrappedFillMenu
    ISEmoteRadialMenu.fillMenu = wrappedFillMenu
    return true
end

TTRPInstallEmoteMenuHook()
Events.OnGameBoot.Add(TTRPInstallEmoteMenuHook)
Events.OnGameStart.Add(TTRPInstallEmoteMenuHook)
Events.OnConnected.Add(TTRPInstallEmoteMenuHook)
Events.OnCreatePlayer.Add(TTRPInstallEmoteMenuHook)


    -- We do math here. 
    function calculateDistance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
    end
    -- This function does a bunch of mystical math I wrote in a fugue state that grabs the nearest zombie, then gives us its distance to the player.
    function determineNearestZombie(playerObject)
        local playerObject = getSpecificPlayer(0)
        local closestZombie = nil
        local closestDistance = math.huge -- Set initial distance to a large value
        
        local zombieList = getWorld():getCell():getZombieList() -- Feeds us an array of zombies in the loaded nearby cells.
        
        if zombieList then
            for i = 0, zombieList:size() - 1 do 
                local zombie = zombieList:get(i) -- Grabs zombies out of the array, then calculates their distances to the player to find the closest one.
                local distance = calculateDistance(playerObject:getX(), playerObject:getY(), zombie:getX(), zombie:getY())
                if distance < closestDistance then
                    closestZombie = zombie
                    closestDistance = distance
                end
            end
        end
        
        return closestZombie, closestDistance
    end
    

    -- This bit of gobblygoo sets the ghost mode for the player to 'false' if it is within a sandbox adjustable range of the player. Defaults to 30 tiles which is about the range of audible sprinting.
    function setGhostModeBasedOnDistance(playerObject, maxRange)
        local playerObject = getSpecificPlayer(0)
        local closestZombie, closestDistance = determineNearestZombie(playerObject)
        maxRange = SandboxVars.TTRPPoses.GhostToggleRange or 30
        local closestZombieInfo = tostring(closestZombie) -- Convert closestZombie to a string for debug purposes.
         -- print("Closest zombie distance: " .. closestDistance) 
         -- print("Closest zombie distance: " .. closestZombieInfo) 
         -- print("Max Range:" .. maxRange)

    -- Check if closestDistance and maxRange are valid and if not; exit the function early.(In cases where a Zombie is not in render distance or zombies are turned off for pre-apoc settings)
    if type(closestDistance) ~= "number" or type(closestZombieInfo) ~= "string" or type(maxRange) ~= "number" then
         -- print("Warning: closestDistance or maxRange is not a number.")
        return -- Exit the function early if either value is not valid
    end

        if closestDistance <= maxRange and not isAdmin() then -- Does not set ghost mode to false if the player is an Admin.
            playerObject:setGhostMode(false)  -- Set ghost mode to false if within range of a zombie.
        end
         if playerObject:isGhostMode() then
           -- print("Ghost Mode is enabled for player.")
         else
           -- print("Ghost Mode is disabled for player.")
         end
    end

    Events.OnTick.Add(function(tick)
        if tick % 150 ~= 0 then return end -- This ensures the function runs every 150 ticks.
        
        local playerObject = getSpecificPlayer(0)
        
        -- Check if playerObject is nil before proceeding, this usually only happens when you die in multiplayer. Prevents errors.
        if not playerObject then
            --print("Warning: No player object found. Skipping ghost mode update.")
            return
        end
        
        -- If sandbox setting is set to false, will not fire the zombie-detection function.
        if SandboxVars.TTRPPoses.ToggleGhosting then
            setGhostModeBasedOnDistance(playerObject, TTRPGetGhostRange())
            -- print("This is firing.")
        end
    end)


TTRPCurrentEmote = nil

function TTRPdoEmote(emote, player)
    if not player then
        player = getSpecificPlayer(0)
    end

    TTRPCurrentEmote = emote

    if not isClient() and not isServer() then
        player:setVariable("TTRPEmote", emote)
        if TTRPIsGhostingEnabled() then
            player:setGhostMode(true)
        end
        return
    end

    sendClientCommand("TTRP", "doEmote", { emote = emote })

    player:setVariable("TTRPEmote", emote)
    if TTRPIsGhostingEnabled() then
        player:setGhostMode(true)
    end
end

function TTRPcancelEmote(emote, player)
    if not player then
        player = getSpecificPlayer(0)
    end

    TTRPCurrentEmote = nil

    if not isClient() and not isServer() then
        player:setVariable("TTRPEmote", emote)
        if not isAdmin() then
            player:setGhostMode(false)
        end
        return
    end

    sendClientCommand("TTRP", "cancelEmote", { emote = emote })

    player:setVariable("TTRPEmote", emote)
    if not isAdmin() then
        player:setGhostMode(false)
    end
end

local TTRPHandlers = {}

TTRPHandlers.doEmote = function(args)
    local remote = getPlayerByOnlineID(args.id)
    if not remote then return end

    TTRPCurrentEmote = args.emote
    remote:setVariable("TTRPEmote", args.emote)
    if TTRPIsGhostingEnabled() then
        remote:setGhostMode(true)
    end
end

TTRPHandlers.cancelEmote = function(args)
    local remote = getPlayerByOnlineID(args.id)
    if not remote then return end

    TTRPCurrentEmote = nil
    remote:setVariable("TTRPEmote", args.emote)
    if not isAdmin() then
        remote:setGhostMode(false)
    end
end

Events.OnServerCommand.Add(function(module, command, args)
    if module == "TTRP" and TTRPHandlers[command] then
        TTRPHandlers[command](args)
    end
end)

-----------------------------------------------
           -- Main Menu --
-----------------------------------------------

function poseTTRPMain(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Poses"), getTexture("media/ui/menus/main-menu.png"), ISRadialMenu.createSubMenu, menu, TTRPSubmenu, player)
end

-----------------------------------------------
       -- Submenus Creation --
-----------------------------------------------

-- Create the submenus with categories
function TTRPSubmenu(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Cancel"), getTexture("media/ui/menus/stop.png"), TTRPcancelEmote, "BobRPS_Cancel", player)
    menu:addSlice(getText("IGUI_TTRP_Standing"), getTexture("media/ui/menus/standing_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPStanding, player)
    menu:addSlice(getText("IGUI_TTRP_Sitting"), getTexture("media/ui/menus/sitting_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPSit, player)
    menu:addSlice(getText("IGUI_TTRP_Lying"), getTexture("media/ui/menus/lying_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPLying, player)
    menu:addSlice(getText("IGUI_TTRP_Props"), getTexture("media/ui/menus/props_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPprops, player)
    menu:addSlice(getText("IGUI_TTRP_Emotes"), getTexture("media/ui/menus/emotes_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPemotes, player)
    menu:addSlice(getText("IGUI_TTRP_Dances"), getTexture("media/ui/menus/dance_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPDances, player)
    menu:addSlice(getText("IGUI_TTRP_Dynamic"), getTexture("media/ui/menus/dynamic_icon.png"), ISRadialMenu.createSubMenu, menu, subTTRPDynamic, player)

    local function hasFavorites()
        if TTRPFavorites and TTRPFavorites.ensureLoaded then
            TTRPFavorites.ensureLoaded()
        end
        if TTRPFavorites and TTRPFavorites.hasAny then
            return TTRPFavorites.hasAny()
        end
        for _ in pairs(Favorites or {}) do
            return true
        end
        return false
    end

    if hasFavorites() then
        menu:addSlice(getText("IGUI_TTRP_Favorites"), getTexture("media/ui/menus/favorites.png"), ISRadialMenu.createSubMenu, menu, subTTRPFavorites, player)
    end

    local RPAspc = false
    local playerItems = getPlayer():getInventory():getItems()
    -- Adds a submenu if you have forbidden cards in your inventory
    for i=1, playerItems:size() do
        local item = playerItems:get(i-1)
        if ForbiddenPoses[item:getFullType()] then
            if not RPAspc then
                RPAspc = true
                menu:addSlice(getText("IGUI_TTRP_Forbidden"), getTexture("media/ui/menus/forbidden.png"), ISRadialMenu.createSubMenu, menu, subForbidden, player)
            end
        end
    end
end

-------------------
-- STANDING MENU --
-------------------

function subTTRPStanding(menu, player)
    -- Standing Main Menu
    menu:addSlice(getText("IGUI_TTRP_StandingLean"), getTexture("media/ui/menus/leaning_icon.png"), ISRadialMenu.createSubMenu, menu, StandingLean, player)
    menu:addSlice(getText("IGUI_TTRP_StandingLean2"), getTexture("media/ui/menus/lean2.png"), ISRadialMenu.createSubMenu, menu, StandingLean2, player)
    menu:addSlice(getText("IGUI_TTRP_IdlePoses"), getTexture("media/ui/menus/upright_icon.png"), ISRadialMenu.createSubMenu, menu, IdlePoses, player)
    menu:addSlice(getText("IGUI_TTRP_IdlePoses2"), getTexture("media/ui/menus/upright_icon2.png"), ISRadialMenu.createSubMenu, menu, IdlePoses2, player)
    menu:addSlice(getText("IGUI_TTRP_ActivePoses"), getTexture("media/ui/menus/active_icon.png"), ISRadialMenu.createSubMenu, menu, ActivePoses, player)
    menu:addSlice(getText("IGUI_TTRP_StandingPaired"), getTexture("media/ui/menus/paired_icon.png"), ISRadialMenu.createSubMenu, menu, StandingPaired, player)
    menu:addSlice(getText("IGUI_TTRP_Injured"), getTexture("media/ui/menus/standing-injured.png"), ISRadialMenu.createSubMenu, menu, subStandingInjured, player)
end

function StandingLean(menu, player)
    -- Leaning Poses Menu
    menu:addSlice(getText("IGUI_TTRP_LeanSassy"), getTexture("media/ui/poses/standing/lean-sassy.png"), TTRPdoEmote, "TTRP_SassyLean", player)
    menu:addSlice(getText("IGUI_TTRP_LeanSassyReverse"), getTexture("media/ui/poses/standing/sassy-reverse.png"), TTRPdoEmote, "TTRP_SassyLeanReverse", player)
    menu:addSlice(getText("IGUI_TTRP_LeanHandsFlat"), getTexture("media/ui/poses/standing/hands-table.png"), TTRPdoEmote, "TTRP_LeanHandsFlat", player)
    menu:addSlice(getText("IGUI_TTRP_LeanOnChin"), getTexture("media/ui/poses/standing/chin-on-fist.png"), TTRPdoEmote, "TTRP_LeanOnChin", player)
    menu:addSlice(getText("IGUI_TTRP_LeanFootObject"), getTexture("media/ui/poses/standing/foot-object.png"), TTRPdoEmote, "TTRP_Standing-Foot-On-Object", player)
    menu:addSlice(getText("IGUI_TTRP_GlassBoxEmotion"), getTexture("media/ui/poses/standing/glass-case-emotion.png"), TTRPdoEmote, "TTRP_GlassBoxOfEmotion", player)
    menu:addSlice(getText("IGUI_TTRP_LeanBackHandsFolded"), getTexture("media/ui/poses/standing/lean-back-folded-hands.png"), TTRPdoEmote, "TTRP_Lean-Back-Hands-Folded", player)
    menu:addSlice(getText("IGUI_TTRP_LeanTableLeft"), getTexture("media/ui/poses/standing/lean-table-right.png"), TTRPdoEmote, "TTRP_LeanLeftTable", player)
    menu:addSlice(getText("IGUI_TTRP_LeanTableRight"), getTexture("media/ui/poses/standing/lean-table-left.png"), TTRPdoEmote, "TTRP_LeanRightTable", player)
    menu:addSlice(getText("IGUI_TTRP_LeanCrossedArmLeft"), getTexture("media/ui/poses/standing/lean-right-crossed-arms.png"), TTRPdoEmote, "TTRP_Crossed-Arm-Lean-Left", player)
    menu:addSlice(getText("IGUI_TTRP_LeanCrossedArmRight"), getTexture("media/ui/poses/standing/lean-left-crossed-arms.png"), TTRPdoEmote, "TTRP_Crossed-Arm-Lean-Right", player)
    menu:addSlice(getText("IGUI_TTRP_LeanBackPocket"), getTexture("media/ui/poses/standing/lean-pocket.png"), TTRPdoEmote, "TTRP_LeanBackHandinPocket", player)
    menu:addSlice(getText("IGUI_TTRP_LeanBackHandsBehind"), getTexture("media/ui/poses/standing/leantback.png"), TTRPdoEmote, "TTRP_LeantBackHandsResting", player)
    menu:addSlice(getText("IGUI_TTRP_GirlypopDoorLeanLeft"), getTexture("media/ui/poses/standing/lean-right-girly-pop.png"), TTRPdoEmote, "TTRP_GirlypopDoorLeanLeft", player)
    menu:addSlice(getText("IGUI_TTRP_GirlypopDoorLeanRight"), getTexture("media/ui/poses/standing/lean-left-girly-pop.png"), TTRPdoEmote, "TTRP_GirlypopDoorLeanRight", player)
end

function StandingLean2(menu, player)
    -- Standing Lean 2
    menu:addSlice(getText("IGUI_TTRP_LeanArmUpLeft"), getTexture("media/ui/poses/standing/leanarmupleft.png"), TTRPdoEmote, "TTRP_LeanArmUpLeft", player)
    menu:addSlice(getText("IGUI_TTRP_LeanArmUpRight"), getTexture("media/ui/poses/standing/leanarmupright.png"), TTRPdoEmote, "TTRP_LeanArmUpRight", player)
    menu:addSlice(getText("IGUI_TTRP_ArmLeanLeft"), getTexture("media/ui/poses/standing/arm-lean-left.png"), TTRPdoEmote, "TTRP_ManLeanLeft", player)
    menu:addSlice(getText("IGUI_TTRP_ArmLeanRight"), getTexture("media/ui/poses/standing/arm-lean-right.png"), TTRPdoEmote, "TTRP_ManLeanRight", player)
    menu:addSlice(getText("IGUI_TTRP_Bent_Forward"), getTexture("media/ui/poses/standing/bent-forward.png"), TTRPdoEmote, "TTRP_Bent_Forward", player)
    menu:addSlice(getText("IGUI_TTRP_LookingDownAt"), getTexture("media/ui/poses/standing/leanover.png"), TTRPdoEmote, "TTRP_LookingDownAt", player)
    menu:addSlice(getText("IGUI_TTRP_Lean-Back-Arms-Crossed-Shy"), getTexture("media/ui/poses/standing/lean-back-shy.png"), TTRPdoEmote, "TTRP_Lean-Back-Arms-Crossed", player)
    menu:addSlice(getText("IGUI_TTRP_LeanBackHoldVest"), getTexture("media/ui/poses/standing/leanbackvest.png"), TTRPdoEmote, "TTRP_LeanBackHoldVest", player)
    menu:addSlice(getText("IGUI_TTRP_LeanBackHandsPockets"), getTexture("media/ui/poses/standing/leanbackhandspockets.png"), TTRPdoEmote, "TTRP_LeanBackHandsPockets", player)
    menu:addSlice(getText("IGUI_TTRP_DeepLean"), getTexture("media/ui/poses/standing/deeplean.png"), TTRPdoEmote, "TTRP_DeepLean", player)
    menu:addSlice(getText("IGUI_TTRP_DeepLeanReversed"), getTexture("media/ui/poses/standing/deepleanreverse.png"), TTRPdoEmote, "TTRP_DeepLeanReversed", player)
end

function IdlePoses(menu, player)
    -- Standing menu
    menu:addSlice(getText("IGUI_TTRP_JoJoPose"), getTexture("media/ui/poses/standing/jojo.png"), TTRPdoEmote, "TTRP_JoJoPose", player)
    menu:addSlice(getText("IGUI_TTRP_HoldingHandsShy"), getTexture("media/ui/poses/standing/holding-hands-shy.png"), TTRPdoEmote, "TTRP_HoldHandsShy", player)
    menu:addSlice("Sassy Stand", getTexture("media/ui/poses/standing/sassystand.png"), TTRPdoEmote, "TTRP_SassyStance", player)
    menu:addSlice(getText("IGUI_TTRP_HandOnHipAlt"), getTexture("media/ui/poses/standing/hand-on-hip-alt.png"), TTRPdoEmote, "TTRP_HandOnHipAlt", player)
    menu:addSlice(getText("IGUI_TTRP_HandsOnHipsIdle"), getTexture("media/ui/poses/standing/hands-on-hip-idle.png"), TTRPdoEmote, "TTRP_HandsOnHipsIdle", player)
    menu:addSlice(getText("IGUI_TTRP_HandOnChinHip"), getTexture("media/ui/poses/standing/hand-hip-chin.png"), TTRPdoEmote, "TTRP_HandOnHipHandOnChin", player)
    menu:addSlice(getText("IGUI_TTRP_HandInPocketCasual"), getTexture("media/ui/poses/standing/hand-in-pocket-casual.png"), TTRPdoEmote, "TTRP_handinpocketcasual", player)
    menu:addSlice(getText("IGUI_TTRP_FoldingHandsDemurely"), getTexture("media/ui/poses/standing/demure.png"), TTRPdoEmote, "TTRP_HandsFoldedDemure", player)
    menu:addSlice(getText("IGUI_TTRP_HoldVestStraps"), getTexture("media/ui/poses/standing/hold-vest.png"), TTRPdoEmote, "TTRP_HoldVest", player)
    menu:addSlice(getText("IGUI_TTRP_RubbingHandBehindHead"), getTexture("media/ui/poses/standing/hand-behind-head.png"), TTRPdoEmote, "TTRP_Hand-Behind-Head-Rub", player)
    menu:addSlice(getText("IGUI_TTRP_HoldingNeck"), getTexture("media/ui/poses/standing/holdneck.png"), TTRPdoEmote, "TTRP_HoldNeck", player)
    menu:addSlice(getText("IGUI_TTRP_ThinkHoldSelfblend"), getTexture("media/ui/poses/standing/thinkholdself.png"), TTRPdoEmote, "TTRP_ThinkHoldSelfblend", player)
    menu:addSlice(getText("IGUI_TTRP_ShyHoldSelf"), getTexture("media/ui/poses/standing/shyholdself.png"), TTRPdoEmote, "TTRP_ShyHoldSelf", player)
    menu:addSlice(getText("IGUI_TTRP_Shy-Hands-Around-Self-2"), getTexture("media/ui/poses/standing/shyholdself2.png"), TTRPdoEmote, "TTRP_Shy-Hands-Around-Self-2", player)
    menu:addSlice(getText("IGUI_TTRP_PrayerStanding"), getTexture("media/ui/poses/standing/prayer.png"), TTRPdoEmote, "TTRP_PrayerStanding", player)
end

function IdlePoses2(menu, player)
    menu:addSlice(getText("IGUI_TTRP_HandHipForearmForehead"), getTexture("media/ui/poses/standing/handhipforearm.png"), TTRPdoEmote, "TTRP_HandHipForearmForehead", player)
    menu:addSlice(getText("IGUI_TTRP_LowCrossedArms"), getTexture("media/ui/poses/standing/lowcrossedarms.png"), TTRPdoEmote, "TTRP_LowCrossedArms", player)
    menu:addSlice(getText("IGUI_TTRP_HeadRub"), getTexture("media/ui/poses/standing/headscratcher.png"), TTRPdoEmote, "TTRP_HeadRub", player)
    menu:addSlice(getText("IGUI_TTRP_AuraFarm"), getTexture("media/ui/poses/standing/aurafarm.png"), TTRPdoEmote, "TTRP_AuraFarm", player)
    menu:addSlice(getText("IGUI_TTRP_Unbothered"), getTexture("media/ui/poses/standing/unbothered.png"), TTRPdoEmote, "TTRP_Unbothered", player)
    menu:addSlice(getText("IGUI_TTRP_Untouched"), getTexture("media/ui/poses/standing/untouched.png"), TTRPdoEmote, "TTRP_Untouched", player)
    menu:addSlice(getText("IGUI_TTRP_ZyzzFlex"), getTexture("media/ui/poses/standing/zyzz.png"), TTRPdoEmote, "TTRP_ZyzzFlex", player)
    menu:addSlice(getText("IGUI_TTRP_FreizaStance"), getTexture("media/ui/poses/standing/freizastance.png"), TTRPdoEmote, "TTRP_FreizaStance", player)
    menu:addSlice(getText("IGUI_TTRP_FootBounce"), getTexture("media/ui/poses/standing/footbounce.png"), TTRPdoEmote, "TTRP_FootBounce", player)
    menu:addSlice(getText("IGUI_TTRP_ApeMode"), getTexture("media/ui/poses/standing/apemode.png"), TTRPdoEmote, "TTRP_ApeMode", player)
    menu:addSlice(getText("IGUI_TTRP_WristHold"), getTexture("media/ui/poses/standing/wristhold.png"), TTRPdoEmote, "TTRP_WristHold", player)
    menu:addSlice(getText("IGUI_TTRP_TimeOutBruh"), getTexture("media/ui/poses/standing/timeout.png"), TTRPdoEmote, "TTRP_TimeOutBruh", player)
    menu:addSlice(getText("IGUI_TTRP_ReadyStance"), getTexture("media/ui/poses/standing/readystance.png"), TTRPdoEmote, "TTRP_ReadyStance", player)
end


function ActivePoses(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Taunt"), getTexture("media/ui/poses/standing/jeb.png"), TTRPdoEmote, "TTRP_Taunt", player)
    menu:addSlice(getText("IGUI_TTRP_WhoDoYouThinkIAm"), getTexture("media/ui/poses/standing/gurrenlagenn.png"), TTRPdoEmote, "TTRP_WhoDoYouThinkIAmblend", player)
    menu:addSlice(getText("IGUI_TTRP_PierceHeaven"), getTexture("media/ui/poses/standing/pierceheaven.png"), TTRPdoEmote, "TTRP_PierceHeaven", player)
    menu:addSlice(getText("IGUI_TTRP_FlourishingBow"), getTexture("media/ui/poses/standing/curtsy.png"), TTRPdoEmote, "TTRP_FlourishingBow", player)
    menu:addSlice(getText("IGUI_TTRP_ShockedPose"), getTexture("media/ui/poses/standing/shocked.png"), TTRPdoEmote, "TTRP_HandsBehindHeadShocked", player)
    menu:addSlice(getText("IGUI_TTRP_MilitarySalute"), getTexture("media/ui/poses/standing/military-salute.png"), TTRPdoEmote, "TTRP_MilitarySalute", player)
    menu:addSlice(getText("IGUI_TTRP_HandOverEyes"), getTexture("media/ui/poses/standing/hand-over-eyes.png"), TTRPdoEmote, "TTRP_HandOverEyes", player)
    menu:addSlice(getText("IGUI_TTRP_Pondering"), getTexture("media/ui/poses/standing/pondering.png"), TTRPdoEmote, "TTRP_Pondering", player)
    menu:addSlice(getText("IGUI_TTRP_HuggingSelf"), getTexture("media/ui/poses/standing/holding-self.png"), TTRPdoEmote, "TTRP_HUGGING_SELF", player)
    menu:addSlice(getText("IGUI_TTRP_SoccerFlex"), getTexture("media/ui/poses/standing/soccerpose.png"), TTRPdoEmote, "TTRP_SoccerFlex", player)
    menu:addSlice(getText("IGUI_TTRP_Pose28"), getTexture("media/ui/poses/standing/pose28.png"), TTRPdoEmote, "TTRP_Pose28", player)
    menu:addSlice(getText("IGUI_TTRP_Standing_OofOwMyBalls"), getTexture("media/ui/poses/standing/owmyballs.png"), TTRPdoEmote, "TTRP_Standing_OofOwMyBalls", player)
    menu:addSlice(getText("IGUI_TTRP_SkyRoar"), getTexture("media/ui/poses/standing/skyroar.png"), TTRPdoEmote, "TTRP_SkyRoar", player)
end

function StandingPaired(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Hug"), getTexture("media/ui/poses/standing/huga.png"), TTRPdoEmote, "TTRP_Hug1", player)
    menu:addSlice(getText("IGUI_TTRP_MakeoutA"), getTexture("media/ui/poses/standing/kiss1.png"), TTRPdoEmote, "TTRP_Makeout1", player)
    menu:addSlice(getText("IGUI_TTRP_MakeoutB"), getTexture("media/ui/poses/standing/kiss1.png"), TTRPdoEmote, "TTRP_Makeout2", player)
    menu:addSlice(getText("IGUI_TTRP_ArmAroundOtherLeft"), getTexture("media/ui/poses/standing/standing-arm-left.png"), TTRPdoEmote, "TTRP_Arm-Around-Other1", player)
    menu:addSlice(getText("IGUI_TTRP_ArmAroundOtherRight"), getTexture("media/ui/poses/standing/standing-arm-right.png"), TTRPdoEmote, "TTRP_Arm-Around-Other2", player)
    menu:addSlice(getText("IGUI_TTRP_ArmAroundTwo"), getTexture("media/ui/poses/standing/arm-two.png"), TTRPdoEmote, "TTRP_Arm-Around-Two", player)
    menu:addSlice(getText("IGUI_TTRP_GirlyArmLeft"), getTexture("media/ui/poses/standing/girly-left.png"), TTRPdoEmote, "TTRP_GirlyArm", player)
    menu:addSlice(getText("IGUI_TTRP_GirlyArmRight"), getTexture("media/ui/poses/standing/girly-right.png"), TTRPdoEmote, "TTRP_GirlyArm2", player)
    menu:addSlice(getText("IGUI_TTRP_Holding"), getTexture("media/ui/poses/standing/holding.png"), TTRPdoEmote, "TTRP_Holding", player)
    menu:addSlice(getText("IGUI_TTRP_Kabedon"), getTexture("media/ui/poses/standing/kabedon.png"), TTRPdoEmote, "TTRP_Kabedon", player)
    menu:addSlice(getText("IGUI_TTRP_HandsOnChest"), getTexture("media/ui/poses/standing/hand-chest.png"), TTRPdoEmote, "TTRP_Hands-on-Others-Chest", player)
    menu:addSlice(getText("IGUI_TTRP_HoldHips"), getTexture("media/ui/poses/standing/hand-hips.png"), TTRPdoEmote, "TTRP_HoldHips", player)
    menu:addSlice(getText("IGUI_TTRP_LeanOnChest"), getTexture("media/ui/poses/standing/leanonchest.png"), TTRPdoEmote, "TTRP_Lean-On-Chest", player)
end

function subStandingInjured(menu, player)
    menu:addSlice(getText("IGUI_TTRP_LimpLeg"), getTexture("media/ui/poses/standing/injuredlimp.png"), TTRPdoEmote, "TTRP_LimpLeg", player)
    menu:addSlice(getText("IGUI_TTRP_InjuredWalk1"), getTexture("media/ui/poses/standing/injuredwalk1.png"), TTRPdoEmote, "TTRP_InjuredWalk1", player)
    menu:addSlice(getText("IGUI_TTRP_InjuredWalk2"), getTexture("media/ui/poses/standing/injuredwalk2.png"), TTRPdoEmote, "TTRP_InjuredWalk2", player)
end

------------------
-- SITTING MENU --
------------------

function subTTRPSit(menu, player)
    -- Sitting Main Menu
    menu:addSlice(getText("IGUI_TTRP_SitGround"), getTexture("media/ui/menus/ground_icon.png"), ISRadialMenu.createSubMenu, menu, subSittingGround, player)
    menu:addSlice(getText("IGUI_TTRP_SitGround2"), getTexture("media/ui/menus/ground_icon_2.png"), ISRadialMenu.createSubMenu, menu, subSittingGround2, player)
    menu:addSlice(getText("IGUI_TTRP_SitFurniture1"), getTexture("media/ui/menus/furniture_icon.png"), ISRadialMenu.createSubMenu, menu, subSittingObject, player)
    menu:addSlice(getText("IGUI_TTRP_SitFurniture2"), getTexture("media/ui/menus/furniture_icon-2.png"), ISRadialMenu.createSubMenu, menu, subSittingObject2, player)
    menu:addSlice(getText("IGUI_TTRP_SitFurniture3"), getTexture("media/ui/menus/furniture_icon-3.png"), ISRadialMenu.createSubMenu, menu, subSittingObject3, player)
    menu:addSlice(getText("IGUI_TTRP_PairedSitGround"), getTexture("media/ui/menus/sit-paired-ground.png"), ISRadialMenu.createSubMenu, menu, subSittingGroundPaired, player)
    menu:addSlice(getText("IGUI_TTRP_PairedSitFurniture"), getTexture("media/ui/menus/sit-paired-furn.png"), ISRadialMenu.createSubMenu, menu, subSittingObjectPaired, player)
    menu:addSlice(getText("IGUI_TTRP_SittingInjured"), getTexture("media/ui/menus/sit-injured.png"), ISRadialMenu.createSubMenu, menu, subSittingInjured, player)
end

function subSittingGround(menu, player)
    -- Sitting On Ground Menu
    menu:addSlice(getText("IGUI_TTRP_SitHandTap"), getTexture("media/ui/poses/sitting/hand-tap.png"), TTRPdoEmote, "TTRP_SitHandTap", player)
    menu:addSlice(getText("IGUI_TTRP_SitArmsKnee"), getTexture("media/ui/poses/sitting/arms-knee.png"), TTRPdoEmote, "TTRP_HandsOnKnee", player)
    menu:addSlice(getText("IGUI_TTRP_GirlyPopSitGround"), getTexture("media/ui/poses/sitting/girlypop-sit.png"), TTRPdoEmote, "TTRP_GirlyPopSit", player)
    menu:addSlice(getText("IGUI_TTRP_SitHandsBound"), getTexture("media/ui/poses/sitting/hands-cuffed.png"), TTRPdoEmote, "TTRP_HandsBoundKneel", player)
    menu:addSlice(getText("IGUI_TTRP_SitSurrender"), getTexture("media/ui/poses/sitting/surrender.png"), TTRPdoEmote, "TTRP_KneelSurrender", player)
    menu:addSlice(getText("IGUI_TTRP_SitSway"), getTexture("media/ui/poses/sitting/sway-sit.png"), TTRPdoEmote, "TTRP_SitSway", player)
    menu:addSlice(getText("IGUI_TTRP_SitElbowKnee"), getTexture("media/ui/poses/sitting/elbowonknee.png"), TTRPdoEmote, "TTRP_ElbowOnKnee", player)
    menu:addSlice(getText("IGUI_TTRP_SitChinHands"), getTexture("media/ui/poses/sitting/chin-in-hand.png"), TTRPdoEmote, "TTRP_SitWithChinInHands", player)
    menu:addSlice(getText("IGUI_TTRP_SitArmsKnees"), getTexture("media/ui/poses/sitting/arms-over-knee.png"), TTRPdoEmote, "TTRP_SittingArmsOverKnee", player)
    menu:addSlice(getText("IGUI_TTRP_SitForearmsThighs"), getTexture("media/ui/poses/sitting/fore-arms-thighs.png"), TTRPdoEmote, "TTRP_Forearms-Thighs", player)
    menu:addSlice(getText("IGUI_TTRP_KneelHandWall"), getTexture("media/ui/poses/sitting/hand-on-wall.png"), TTRPdoEmote, "TTRP_KneelHandOnWall", player)
    menu:addSlice(getText("IGUI_TTRP_KneelPrayer"), getTexture("media/ui/poses/sitting/praying.png"), TTRPdoEmote, "TTRP_SitPrayer", player)
    menu:addSlice(getText("IGUI_TTRP_KneelHandOverHand"), getTexture("media/ui/poses/sitting/kneel-crossed-hands.png"), TTRPdoEmote, "TTRP_KneelingCrossedHand", player)
    menu:addSlice(getText("IGUI_TTRP_KneelCrossedArms"), getTexture("media/ui/poses/sitting/kneel-crossed-arms.png"), TTRPdoEmote, "TTRP_KneelingCrossedArms", player)
end

function subSittingGround2(menu, player)
    -- Sitting On Ground Menu 2
    menu:addSlice(getText("IGUI_TTRP_WrappedKneesGround"), getTexture("media/ui/poses/sitting/wrapped-knees-ground.png"), TTRPdoEmote, "TTRP_WrappedKneesGround", player)
    menu:addSlice(getText("IGUI_TTRP_KneelHeadDown"), getTexture("media/ui/poses/sitting/kneelheaddown.png"), TTRPdoEmote, "TTRP_KneelHeadDown", player)
    menu:addSlice(getText("IGUI_TTRP_CasualKneel"), getTexture("media/ui/poses/sitting/casualkneel.png"), TTRPdoEmote, "TTRP_CasualKneel", player)
    menu:addSlice(getText("IGUI_TTRP_DeepSquat"), getTexture("media/ui/poses/sitting/deepsquat.png"), TTRPdoEmote, "TTRP_DeepSquat", player)
    menu:addSlice(getText("IGUI_TTRP_GoblinSitGround"), getTexture("media/ui/poses/sitting/goblin.png"), TTRPdoEmote, "TTRP_GoblinSitGround", player)
    menu:addSlice(getText("IGUI_TTRP_SitOnGround"), getTexture("media/ui/poses/sitting/sitground.png"), TTRPdoEmote, "TTRP_SitOnGround", player)
end

function subSittingObject(menu, player)
    -- Sitting on an Object Menu
    menu:addSlice(getText("IGUI_TTRP_ChairHeadInHands"), getTexture("media/ui/poses/sitting/head-in-hands.png"), TTRPdoEmote, "TTRP_HeadInHandsSit", player)
    menu:addSlice(getText("IGUI_TTRP_ChairHandsThighs"), getTexture("media/ui/poses/sitting/deep-squat.png"), TTRPdoEmote, "TTRP_Hands_On_Thighs", player)
    menu:addSlice(getText("IGUI_TTRP_ChairForearmsThighs"), getTexture("media/ui/poses/sitting/arms-thighs.png"), TTRPdoEmote, "TTRP_Sitting_ForearmsThighs", player)
    menu:addSlice(getText("IGUI_TTRP_ChairHandsHead"), getTexture("media/ui/poses/sitting/cantdothisnomore.png"), TTRPdoEmote, "TTRP_Sitting_Hands-Head", player)
    menu:addSlice(getText("IGUI_TTRP_LazyBoy"), getTexture("media/ui/poses/sitting/lazy-boy.png"), TTRPdoEmote, "TTRP_LazyBoy", player)
    menu:addSlice(getText("IGUI_TTRP_Manspread"), getTexture("media/ui/poses/sitting/manspread.png"), TTRPdoEmote, "TTRP_MANSPREAD", player)
    menu:addSlice(getText("IGUI_TTRP_ManspreadArmsFolded"), getTexture("media/ui/poses/sitting/armsfoldedmanspread.png"), TTRPdoEmote, "TTRP_ManspreadCrossedArms", player)
    menu:addSlice(getText("IGUI_TTRP_SassySit"), getTexture("media/ui/poses/sitting/sassy-sit.png"), TTRPdoEmote, "TTRP_SassySit", player)
    menu:addSlice(getText("IGUI_TTRP_LegsCrossedChair"), getTexture("media/ui/poses/sitting/legs-crossed.png"), TTRPdoEmote, "TTRP_SitInChairLegsCrossed", player)
    menu:addSlice(getText("IGUI_TTRP_ChairChinInHand"), getTexture("media/ui/poses/sitting/chair-chin-in-hand.png"), TTRPdoEmote, "TTRP_SitWithChinInHand-Chair", player)
    menu:addSlice(getText("IGUI_TTRP_ChairOneLegUp"), getTexture("media/ui/poses/sitting/one-leg-up.png"), TTRPdoEmote, "TTRP_SitInChairOneLegUp", player)
    menu:addSlice(getText("IGUI_TTRP_ChairHandsFolded"), getTexture("media/ui/poses/sitting/satrmscross.png"), TTRPdoEmote, "TTRP_SitHandsFolded", player)
    menu:addSlice(getText("IGUI_TTRP_LegsKickedUp"), getTexture("media/ui/poses/sitting/legskickedup.png"), TTRPdoEmote, "TTRP_Sit-Legs-Kicked-Up", player)
    menu:addSlice(getText("IGUI_TTRP_CrossChair"), getTexture("media/ui/poses/sitting/sit-cross-chair.png"), TTRPdoEmote, "TTRP_Sit-Cross-Chair", player)
    menu:addSlice(getText("IGUI_TTRP_SunbathingBeachChair"), getTexture("media/ui/poses/sitting/suntanning2.png"), TTRPdoEmote, "TTRP_Suntanning2", player)
    menu:addSlice(getText("IGUI_TTRP_GirlypopArmsLegs"), getTexture("media/ui/poses/sitting/girlypop-kneesup.png"), TTRPdoEmote, "TTRP_Girlypop-Chair-Sit", player)
end

function subSittingObject2(menu, player)
    -- Sitting on an Object Menu pt 2
    menu:addSlice(getText("IGUI_TTRP_ChairHandArmThigh"), getTexture("media/ui/poses/sitting/laxarmsit.png"), TTRPdoEmote, "TTRP_HandThighArmThigh", player)
    menu:addSlice(getText("IGUI_TTRP_ThaneSit"), getTexture("media/ui/poses/sitting/thane.png"), TTRPdoEmote, "TTRP_ThaneSit", player)
    menu:addSlice(getText("IGUI_TTRP_JarlBallin"), getTexture("media/ui/poses/sitting/jarlin.png"), TTRPdoEmote, "TTRP_JARL", player)
    menu:addSlice(getText("IGUI_TTRP_JarlBallinTwoArms"), getTexture("media/ui/poses/sitting/jarlin.png"), TTRPdoEmote, "TTRP_JARL_ARMS_DOWN", player)
    menu:addSlice(getText("IGUI_TTRP_ChairHandsOnChair"), getTexture("media/ui/poses/sitting/handchair.png"), TTRPdoEmote, "TTRP_Sit-Hands-On-Chair", player)
    menu:addSlice(getText("IGUI_TTRP_ChaiseLounge"), getTexture("media/ui/poses/sitting/chaise-lounge.png"), TTRPdoEmote, "TTRP_ChaiseLounge", player)
    menu:addSlice(getText("IGUI_TTRP_ChaiseLoungeReversed"), getTexture("media/ui/poses/sitting/chaise-reversed.png"), TTRPdoEmote, "TTRP_ChaiseLoungeReversed", player)
    menu:addSlice(getText("IGUI_TTRP_OneLegUpOneDown"), getTexture("media/ui/poses/sitting/1up1down.png"), TTRPdoEmote, "TTRP_One-leg-up-one-down", player)
    menu:addSlice(getText("IGUI_TTRP_OneLegUpOneDownReversed"), getTexture("media/ui/poses/sitting/1up1downreversed.png"), TTRPdoEmote, "TTRP_One-Leg-Up-One-Down-Reversed", player)
    menu:addSlice(getText("IGUI_TTRP_LegsCrossed"), getTexture("media/ui/poses/sitting/crossedlegs.png"), TTRPdoEmote, "TTRP_LegsCrossedChair", player)
    menu:addSlice(getText("IGUI_TTRP_GoblinSit"), getTexture("media/ui/poses/sitting/goblin.png"), TTRPdoEmote, "TTRP_GoblinSit", player)
    menu:addSlice(getText("IGUI_TTRP_SitChairArmsAroundSelf"), getTexture("media/ui/poses/sitting/sitarmschair.png"), TTRPdoEmote, "TTRP_SitChairArmsAroundSelf", player)
    menu:addSlice(getText("IGUI_TTRP_HandsBehindHeadChair"), getTexture("media/ui/poses/sitting/handsbehindhead.png"), TTRPdoEmote, "TTRP_HandsBehindHeadChair", player)
    menu:addSlice(getText("IGUI_TTRP_PrayerChair"), getTexture("media/ui/poses/sitting/prayerchair.png"), TTRPdoEmote, "TTRP_PrayerChair", player)
end

function subSittingObject3(menu, player)
    menu:addSlice(getText("IGUI_TTRP_CrossedLegs_Sassy"), getTexture("media/ui/poses/sitting/crosslegssassy.png"), TTRPdoEmote, "TTRP_CrossedLegs_Sassy", player)
    menu:addSlice(getText("IGUI_TTRP_CrossedLegs_Leaned"), getTexture("media/ui/poses/sitting/crosslegsleaned.png"), TTRPdoEmote, "TTRP_CrossedLegs_Leaned", player)
    menu:addSlice(getText("IGUI_TTRP_CrossedLegs_InLap"), getTexture("media/ui/poses/sitting/crosslegsinlap.png"), TTRPdoEmote, "TTRP_CrossedLegs_InLap", player)
end

function subSittingObjectPaired(menu, player)
    menu:addSlice(getText("IGUI_TTRP_SittingBeside"), getTexture("media/ui/poses/sitting/lean-against.png"), TTRPdoEmote, "TTRP_SittingNextTo", player)
    menu:addSlice(getText("IGUI_TTRP_SitHandThighRight"), getTexture("media/ui/poses/sitting/sit-hand-right.png"), TTRPdoEmote, "TTRP_SitBesideHandThighRight", player)
    menu:addSlice(getText("IGUI_TTRP_SitHandThighLeft"), getTexture("media/ui/poses/sitting/sit-hand-left.png"), TTRPdoEmote, "TTRP_SitBesideHandThighLeft", player)
    menu:addSlice(getText("IGUI_TTRP_SitArmAroundRight"), getTexture("media/ui/poses/sitting/sit-around-right.png"), TTRPdoEmote, "TTRP_Sit-Arm-Around-Right", player)
    menu:addSlice(getText("IGUI_TTRP_SitArmAroundLeft"), getTexture("media/ui/poses/sitting/sit-around-left.png"), TTRPdoEmote, "TTRP_Sit-Arm-Around-Left", player)
end

function subSittingGroundPaired(menu, player)
    menu:addSlice(getText("IGUI_TTRP_SitBesideGround"), getTexture("media/ui/poses/sitting/sittingbeside.png"), TTRPdoEmote, "TTRP_SittingNextToGround", player)
    menu:addSlice(getText("IGUI_TTRP_SitLegsSpread"), getTexture("media/ui/poses/sitting/legsspread.png"), TTRPdoEmote, "TTRP_Sit-on-Ground-Legs-Spread", player)
    menu:addSlice(getText("IGUI_TTRP_SitBetweenLegs"), getTexture("media/ui/poses/sitting/sitbetween.png"), TTRPdoEmote, "TTRP_Sit-Between-legs", player)
    menu:addSlice(getText("IGUI_TTRP_SitArmAroundLeft"), getTexture("media/ui/poses/sitting/arm-around-left.png"), TTRPdoEmote, "TTRP_Sitting-Arm-Around", player)
    menu:addSlice(getText("IGUI_TTRP_SitArmAroundRight"), getTexture("media/ui/poses/sitting/arm-around-right.png"), TTRPdoEmote, "TTRP_Sitting-Arm-Around2", player)
    menu:addSlice(getText("IGUI_TTRP_HeadInLap"), getTexture("media/ui/poses/sitting/stroke-head.png"), TTRPdoEmote, "TTRP_Head-In-Lap", player)
end

function subSittingInjured(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Sitting_InjuredArmTucked"), getTexture("media/ui/poses/sitting/sittinginjuredarmtucked.png"), TTRPdoEmote, "TTRP_Sitting_InjuredArmTucked", player)
    menu:addSlice(getText("IGUI_TTRP_Sitting_InjuredArm"), getTexture("media/ui/poses/sitting/sittinginjuredarm.png"), TTRPdoEmote, "TTRP_Sitting_InjuredArm", player)
    menu:addSlice(getText("IGUI_TTRP_InjuredKneeling"), getTexture("media/ui/poses/sitting/injuredkneeling.png"), TTRPdoEmote, "TTRP_InjuredKneel", player)
end



---------------------
-- LYING DOWN MENU --
---------------------
function subTTRPLying(menu, player)
    menu:addSlice(getText("IGUI_TTRP_LyingGround"), getTexture("media/ui/menus/lying-ground.png"), ISRadialMenu.createSubMenu, menu, subTTRPLyingFloor, player)
    menu:addSlice(getText("IGUI_TTRP_LyingFurniture"), getTexture("media/ui/menus/lying-furn.png"), ISRadialMenu.createSubMenu, menu, subTTRPLyingFurniture, player)
    menu:addSlice(getText("IGUI_TTRP_PairedLying"), getTexture("media/ui/menus/lying-paired-ground.png"), ISRadialMenu.createSubMenu, menu, subLyingPairedGround, player)
    menu:addSlice(getText("IGUI_TTRP_PairedLyingFurniture"), getTexture("media/ui/menus/lying-paired-furn.png"), ISRadialMenu.createSubMenu, menu, subLyingPairedFurniture, player)
    menu:addSlice(getText("IGUI_TTRP_LyingInjured"), getTexture("media/ui/menus/lying-injured.png"), ISRadialMenu.createSubMenu, menu, subLyingInjured, player)
end


function subTTRPLyingFloor(menu, player)
    menu:addSlice(getText("IGUI_TTRP_DownAndOut"), getTexture("media/ui/poses/laying/injured1.png"), TTRPdoEmote, "TTRP_DownAndOut", player)
    menu:addSlice(getText("IGUI_TTRP_LyingInjured2"), getTexture("media/ui/poses/laying/injured2.png"), TTRPdoEmote, "TTRP_LyingInjured2", player)
    menu:addSlice(getText("IGUI_TTRP_Cloudspotting"), getTexture("media/ui/poses/laying/cloudwatching.png"), TTRPdoEmote, "TTRP_Cloudspotting", player)
    menu:addSlice(getText("IGUI_TTRP_Lie_Flutter_Kick"), getTexture("media/ui/poses/laying/flutter-kick.png"), TTRPdoEmote, "TTRP_Lie_Flutter_Kick", player)
    menu:addSlice(getText("IGUI_TTRP_FeetOnSofa"), getTexture("media/ui/poses/laying/legs-on-chair.png"), TTRPdoEmote, "TTRP_FeetOnSofa", player)
    menu:addSlice(getText("IGUI_TTRP_FetalPosition"), getTexture("media/ui/poses/laying/fetal.png"), TTRPdoEmote, "TTRP_FetalPosition", player)
    menu:addSlice(getText("IGUI_TTRP_Faceplant"), getTexture("media/ui/poses/laying/faceplant.png"), TTRPdoEmote, "TTRP_Faceplant", player)
    menu:addSlice(getText("IGUI_TTRP_LayStomach1"), getTexture("media/ui/poses/laying/layingstomach.png"), TTRPdoEmote, "TTRP_LayStomach1", player)
    menu:addSlice(getText("IGUI_TTRP_FrenchBoy"), getTexture("media/ui/poses/laying/french_boi.png"), TTRPdoEmote, "TTRP_FrenchBoy", player)
    menu:addSlice(getText("IGUI_TTRP_FrenchBoyReversed"), getTexture("media/ui/poses/laying/french_boi.png"), TTRPdoEmote, "TTRP_FrenchBoyReversed", player)
    menu:addSlice(getText("IGUI_TTRP_FrenchGirl"), getTexture("media/ui/poses/laying/french_goil.png"), TTRPdoEmote, "TTRP_FrenchGirl", player)
    menu:addSlice(getText("IGUI_TTRP_FrenchGirlReversed"), getTexture("media/ui/poses/laying/french_goil.png"), TTRPdoEmote, "TTRP_FrenchGirlReversed", player)
    menu:addSlice(getText("IGUI_TTRP_Lying_Asleep"), getTexture("media/ui/poses/laying/sleeping1.png"), TTRPdoEmote, "TTRP_Lying-Asleep", player)
    menu:addSlice(getText("IGUI_TTRP_Lying_Asleep_Reversed"), getTexture("media/ui/poses/laying/sleeping1.png"), TTRPdoEmote, "TTRP_Lying-Asleep-Reversed", player)
    menu:addSlice(getText("IGUI_TTRP_Lying_Sleeping2"), getTexture("media/ui/poses/laying/sleeping2.png"), TTRPdoEmote, "TTRP_Lying-Sleeping2", player)
    menu:addSlice(getText("IGUI_TTRP_Suntanning"), getTexture("media/ui/poses/laying/suntanning.png"), TTRPdoEmote, "TTRP_Suntanning", player)
    menu:addSlice(getText("IGUI_TTRP_LYING_ELBOWS"), getTexture("media/ui/poses/laying/elbows.png"), TTRPdoEmote, "TTRP_LYING_ELBOWS", player)
 end
 
 function subTTRPLyingFurniture(menu, player)
     menu:addSlice(getText("IGUI_TTRP_FetalFurniture"), getTexture("media/ui/poses/laying/fetal.png"), TTRPdoEmote, "TTRP_FetalFurniture", player)
     menu:addSlice(getText("IGUI_TTRP_StomachLayBed"), getTexture("media/ui/poses/laying/layingstomach.png"), TTRPdoEmote, "TTRP_StomachLayBed", player)
     menu:addSlice(getText("IGUI_TTRP_LegFlutterFurniture"), getTexture("media/ui/poses/laying/flutter-kick.png"), TTRPdoEmote, "TTRP_LegFlutterFurniture", player)
     menu:addSlice(getText("IGUI_TTRP_FrenchBoy_Bed"), getTexture("media/ui/poses/laying/french_boi.png"), TTRPdoEmote, "TTRP_FrenchBoy_Bed", player)
     menu:addSlice(getText("IGUI_TTRP_FrenchBoy_BedReversed"), getTexture("media/ui/poses/laying/french_boi.png"), TTRPdoEmote, "TTRP_FrenchBoy_BedReversed", player)
     menu:addSlice(getText("IGUI_TTRP_FrenchGirl_Bed"), getTexture("media/ui/poses/laying/french_goil.png"), TTRPdoEmote, "TTRP_FrenchGirl_Bed", player)
     menu:addSlice(getText("IGUI_TTRP_FrenchGirl_BedReversed"), getTexture("media/ui/poses/laying/french_goil.png"), TTRPdoEmote, "TTRP_FrenchGirl_BedReversed", player)
     menu:addSlice(getText("IGUI_TTRP_Lying_AsleepFurniture"), getTexture("media/ui/poses/laying/sleeping1.png"), TTRPdoEmote, "TTRP_Lying-AsleepFurniture", player)
     menu:addSlice(getText("IGUI_TTRP_Lying_Asleep_ReversedFurniture"), getTexture("media/ui/poses/laying/sleeping1.png"), TTRPdoEmote, "TTRP_Lying-Asleep-ReversedFurniture", player)
     menu:addSlice(getText("IGUI_TTRP_Lying_Sleeping2Furniture"), getTexture("media/ui/poses/laying/sleeping2.png"), TTRPdoEmote, "TTRP_Lying-Sleeping2Furniture", player)
     menu:addSlice(getText("IGUI_TTRP_LYING_ELBOWS_BED"), getTexture("media/ui/poses/laying/elbows.png"), TTRPdoEmote, "TTRP_LYING_ELBOWS_BED", player)
     menu:addSlice(getText("IGUI_TTRP_SuntanningFurniture"), getTexture("media/ui/poses/laying/suntanning.png"), TTRPdoEmote, "TTRP_SuntanningFurniture", player)
 end
 
 function subLyingPairedGround(menu, player)
     menu:addSlice(getText("IGUI_TTRP_Cuddle1"), getTexture("media/ui/poses/laying/cuddle-reverse.png"), TTRPdoEmote, "TTRP_Cuddle1", player)
     menu:addSlice(getText("IGUI_TTRP_Cuddle_Reversed"), getTexture("media/ui/poses/laying/cuddle-reverse.png"), TTRPdoEmote, "TTRP_Cuddle-Reversed", player)
     menu:addSlice(getText("IGUI_TTRP_Laying_Head_In_Lap"), getTexture("media/ui/poses/laying/head-lap.png"), TTRPdoEmote, "TTRP_Laying-Head-In-Lap", player)
 end
 
 function subLyingPairedFurniture(menu, player)
     menu:addSlice(getText("IGUI_TTRP_Cuddle1_Offset"), getTexture("media/ui/poses/laying/cuddle-reverse.png"), TTRPdoEmote, "TTRP_Cuddle1-Offset", player)
     menu:addSlice(getText("IGUI_TTRP_Cuddle_Reversed_Offset"), getTexture("media/ui/poses/laying/cuddle-reverse.png"), TTRPdoEmote, "TTRP_Cuddle-Reversed-Offset", player)
 end

  function subLyingInjured(menu, player)
     menu:addSlice(getText("IGUI_TTRP_LieAgainstWallInjured"), getTexture("media/ui/poses/laying/lieagainstwall.png"), TTRPdoEmote, "TTRP_LieAgainstWallInjured", player)
     menu:addSlice(getText("IGUI_TTRP_LieAgainstWallInjured2"), getTexture("media/ui/poses/laying/lieagainstwall2.png"), TTRPdoEmote, "TTRP_LieAgainstWallInjured2", player)
     menu:addSlice(getText("IGUI_TTRP_LurchingInjured"), getTexture("media/ui/poses/laying/lurchinginjured.png"), TTRPdoEmote, "TTRP_LurchingInjured", player)
     menu:addSlice(getText("IGUI_TTRP_Injured_LyingClutchStomach"), getTexture("media/ui/poses/laying/lyingclutchstomach.png"), TTRPdoEmote, "TTRP_Injured_LyingClutchStomach", player)
     menu:addSlice(getText("IGUI_TTRP_Lying_Raptured"), getTexture("media/ui/poses/laying/lyingraptured.png"), TTRPdoEmote, "TTRP_Lying_Raptured", player)
     menu:addSlice(getText("IGUI_TTRP_Lying_LimpClutchTummy"), getTexture("media/ui/poses/laying/lyinglimpclutchstomach.png"), TTRPdoEmote, "TTRP_Lying_LimpClutchTummy", player)
     menu:addSlice(getText("IGUI_TTRP_BladeRunner"), getTexture("media/ui/poses/laying/bladerunner.png"), TTRPdoEmote, "TTRP_BladeRunner", player)
     menu:addSlice(getText("IGUI_TTRP_MentalBreak"), getTexture("media/ui/poses/laying/mentalbreak.png"), TTRPdoEmote, "TTRP_MentalBreak", player)
     menu:addSlice(getText("IGUI_TTRP_Crawling"), getTexture("media/ui/poses/laying/crawling.png"), TTRPdoEmote, "TTRP_Crawling", player)
     menu:addSlice(getText("IGUI_TTRP_InjuredCrawl"), getTexture("media/ui/poses/laying/injuredcrawling.png"), TTRPdoEmote, "TTRP_InjuredCrawl", player)
     menu:addSlice(getText("IGUI_TTRP_PanickedScramble"), getTexture("media/ui/poses/laying/panickedcrawl.png"), TTRPdoEmote, "TTRP_PanickedScramble", player)
 end
----------------
-- PROPS MENU --
----------------
function subTTRPprops(menu, player)
    menu:addSlice(getText("IGUI_TTRP_LongRifles"), getTexture("media/ui/menus/rifle-icon.png"), ISRadialMenu.createSubMenu, menu, subLongRifles, player)
    menu:addSlice(getText("IGUI_TTRP_SittingLongRifles"), getTexture("media/ui/menus/rifle-icon2.png"), ISRadialMenu.createSubMenu, menu, subSittingLongRifle, player)
    menu:addSlice(getText("IGUI_TTRP_Pistols"), getTexture("media/ui/menus/pistols-icon.png"), ISRadialMenu.createSubMenu, menu, subPistols, player)
    menu:addSlice(getText("IGUI_TTRP_LongWeapons"), getTexture("media/ui/menus/melee-icon.png"), ISRadialMenu.createSubMenu, menu, subLongWeapons, player)
    menu:addSlice(getText("IGUI_TTRP_InjuredProps"), getTexture("media/ui/menus/injuredprops.png"), ISRadialMenu.createSubMenu, menu, subInjuredProps, player)
    menu:addSlice(getText("IGUI_TTRP_Instruments"), getTexture("media/ui/menus/instruments.png"), ISRadialMenu.createSubMenu, menu, subInstruments, player)
end

function subLongRifles(menu, player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleSteady"), getTexture("media/ui/poses/props/aimrifle.png"), TTRPdoEmote, "TTRP_HoldRifleSteady", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifle"), getTexture("media/ui/poses/props/rifleidle.png"), TTRPdoEmote, "TTRP_HoldRifle", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleArmpit"), getTexture("media/ui/poses/props/riflearmpit.png"), TTRPdoEmote, "TTRP_HoldRifleUnderArmpit", player)
    menu:addSlice(getText("IGUI_TTRP_HoldAtGunpointRifle"), getTexture("media/ui/poses/props/rifle-gunpoint.png"), TTRPdoEmote, "TTRP_HoldAtGunpointRifle", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleAtHip"), getTexture("media/ui/poses/props/riflehip.png"), TTRPdoEmote, "TTRP_HoldRifleAtHip", player)
    menu:addSlice(getText("IGUI_TTRP_Holding_Rifle_Idle_2"), getTexture("media/ui/poses/props/rifle-idle.png"), TTRPdoEmote, "TTRP_Holding_Rifle_Idle_2", player)
    menu:addSlice(getText("IGUI_TTRP_Rifle_One_Hand_Up"), getTexture("media/ui/poses/props/rifle-idle-3.png"), TTRPdoEmote, "TTRP_Rifle-One-Hand-Up", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleHip"), getTexture("media/ui/poses/props/riflehip.png"), TTRPdoEmote, "TTRP_HoldRifleToHip", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleKneel"), getTexture("media/ui/poses/props/kneelshoot.png"), TTRPdoEmote, "TTRP_HoldRifleKneel", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleIdleKneel"), getTexture("media/ui/poses/props/kneelidle.png"), TTRPdoEmote, "TTRP_HoldRifleIdleKneel", player)
    menu:addSlice(getText("IGUI_TTRP_HoldRifleUp"), getTexture("media/ui/poses/props/holdrifleup.png"), TTRPdoEmote, "TTRP_HoldRifleUp", player)
    menu:addSlice(getText("IGUI_TTRP_HoldWeaponOnShoulder"), getTexture("media/ui/poses/props/holdriflshoulder.png"), TTRPdoEmote, "TTRP_HoldWeaponOnShoulder", player)
    menu:addSlice(getText("IGUI_TTRP_ProneRifle"), getTexture("media/ui/poses/props/pronerifle.png"), TTRPdoEmote, "TTRP_ProneRifle", player)
    menu:addSlice(getText("IGUI_TTRP_CrouchedSniper"), getTexture("media/ui/poses/props/crouchsniper.png"), TTRPdoEmote, "TTRP_CrouchedSniper", player)
    menu:addSlice(getText("IGUI_TTRP_Crouched-Rifle-2"), getTexture("media/ui/poses/props/crouchedrifle2.png"), TTRPdoEmote, "TTRP_Crouched-Rifle-2", player)
end

function subSittingLongRifle(menu, player)
    menu:addSlice(getText("IGUI_TTRP_RifleOverLap"), getTexture("media/ui/poses/props/rifle-lap.png"), TTRPdoEmote, "TTRP_RifleOverLap", player)
    menu:addSlice(getText("IGUI_TTRP_Anton"), getTexture("media/ui/poses/props/anton.png"), TTRPdoEmote, "TTRP_Anton", player)
    menu:addSlice(getText("IGUI_TTRP_SittingHipRifle"), getTexture("media/ui/poses/props/sit-rifle-hip.png"), TTRPdoEmote, "TTRP_SittingHipRifle", player)
    menu:addSlice(getText("IGUI_TTRP_SittingRifleBetweenLegs"), getTexture("media/ui/poses/props/rifle-legs.png"), TTRPdoEmote, "TTRP_SittingRifleBetweenLegs", player)
end

-- MEELE PARENT MENU --
function subLongWeapons(menu, player)
        menu:addSlice(getText("IGUI_TTRP_SpearPoses"), getTexture("media/ui/menus/spearsmenu.png"), ISRadialMenu.createSubMenu, menu, subSpearPoses, player)
        menu:addSlice(getText("IGUI_TTRP_SwordPoses"), getTexture("media/ui/menus/swordsmenu.png"), ISRadialMenu.createSubMenu, menu, subSwordPoses, player)
        menu:addSlice(getText("IGUI_TTRP_GenericPropPoses"), getTexture("media/ui/menus/genericmenu.png"), ISRadialMenu.createSubMenu, menu, subGenericPoses, player)
end
    -- MELEE SUBMENUS --
    -- spears
    function subSpearPoses(menu, player)
            menu:addSlice(getText("IGUI_TTRP_HoldAtSpearpoint"), getTexture("media/ui/poses/props/whyareyoureadingthis.png"), TTRPdoEmote, "TTRP_HoldAtSpearpoint", player)
            menu:addSlice(getText("IGUI_TTRP_HoldSpear"), getTexture("media/ui/poses/props/holdspear.png"), TTRPdoEmote, "TTRP_HoldingSpear", player)
            menu:addSlice(getText("IGUI_TTRP_HoldSpearAnime"), getTexture("media/ui/poses/props/holdspearanime.png"), TTRPdoEmote, "TTRP_HoldSpearAnime", player)
            menu:addSlice(getText("IGUI_TTRP_LeanOnSpear"), getTexture("media/ui/poses/props/holdspearlean.png"), TTRPdoEmote, "TTRP_LeanOnSpear", player)
            menu:addSlice(getText("IGUI_TTRP_LeanOnSpearStanding"), getTexture("media/ui/poses/props/holdspearleanstanding.png"), TTRPdoEmote, "TTRP_LeanOnSpearStanding", player)
            menu:addSlice(getText("IGUI_TTRP_SpearThrust"), getTexture("media/ui/poses/props/spearthrust.png"), TTRPdoEmote, "TTRP_SpearThrust", player)
            menu:addSlice(getText("IGUI_TTRP_SpearLine"), getTexture("media/ui/poses/props/spearline.png"), TTRPdoEmote, "TTRP_SpearLine", player)
            menu:addSlice(getText("IGUI_TTRP_SpearPose1"), getTexture("media/ui/poses/props/spearpose1.png"), TTRPdoEmote, "TTRP_SpearPose1", player)
            menu:addSlice(getText("IGUI_TTRP_SpearPoseRelaxed"), getTexture("media/ui/poses/props/spearrelaxed.png"), TTRPdoEmote, "TTRP_SpearPoseRelaxed", player)
    end
    --sword
    function subSwordPoses(menu, player)
            menu:addSlice(getText("IGUI_TTRP_SwordStance1"), getTexture("media/ui/poses/props/swordready.png"), TTRPdoEmote, "TTRP_SwordStance1", player)
            menu:addSlice(getText("IGUI_TTRP_SwordStance2"), getTexture("media/ui/poses/props/swordready2.png"), TTRPdoEmote, "TTRP_SwordStance2", player)
            menu:addSlice(getText("IGUI_TTRP_SwordStance3"), getTexture("media/ui/poses/props/swordready3.png"), TTRPdoEmote, "TTRP_SwordStance3", player)
            menu:addSlice(getText("IGUI_TTRP_SwordStance4"), getTexture("media/ui/poses/props/swordready4.png"), TTRPdoEmote, "TTRP_SwordStance4", player)
            menu:addSlice(getText("IGUI_TTRP_SwordHeldLow"), getTexture("media/ui/poses/props/swordlow.png"), TTRPdoEmote, "TTRP_SwordHeldLow", player)
            menu:addSlice(getText("IGUI_TTRP_DualSwords"), getTexture("media/ui/poses/props/dualswords.png"), TTRPdoEmote, "TTRP_DualSwords", player)
            menu:addSlice(getText("IGUI_TTRP_DualKnives"), getTexture("media/ui/poses/props/dualknives.png"), TTRPdoEmote, "TTRP_DualKnives", player)
            menu:addSlice(getText("IGUI_TTRP_Katana-Stance-1"), getTexture("media/ui/poses/props/katanastance1.png"), TTRPdoEmote, "TTRP_Katana-Stance-1", player)
            menu:addSlice(getText("IGUI_TTRP_Katana-Stance-2"), getTexture("media/ui/poses/props/katanastance2.png"), TTRPdoEmote, "TTRP_Katana-Stance-2", player)
            menu:addSlice(getText("IGUI_TTRP_Challenge"), getTexture("media/ui/poses/props/challenge.png"), TTRPdoEmote, "TTRP_Challenge", player)
            menu:addSlice(getText("IGUI_TTRP_Iaido"), getTexture("media/ui/poses/props/iaido.png"), TTRPdoEmote, "TTRP_Iaido", player)
            menu:addSlice(getText("IGUI_TTRP_Motivated"), getTexture("media/ui/poses/props/motivated.png"), TTRPdoEmote, "TTRP_Motivated", player)
            menu:addSlice(getText("IGUI_TTRP_Fencing1"), getTexture("media/ui/poses/props/fencing1.png"), TTRPdoEmote, "TTRP_Fencing1", player)
            menu:addSlice(getText("IGUI_TTRP_Sentinel"), getTexture("media/ui/poses/props/sentinel.png"), TTRPdoEmote, "TTRP_Sentinel", player)
            menu:addSlice(getText("IGUI_TTRP_DesperadosGrandStand"), getTexture("media/ui/poses/props/desperadosgrandstand.png"), TTRPdoEmote, "TTRP_DesperadosGrandstand", player)
    end
    -- generics
    function subGenericPoses(menu, player)
            menu:addSlice(getText("IGUI_TTRP_BatPat"), getTexture("media/ui/poses/props/batpat.png"), TTRPdoEmote, "TTRP_BatPat", player)
            menu:addSlice(getText("IGUI_TTRP_HoldBehindHead"), getTexture("media/ui/poses/props/weaponbehindhead.png"), TTRPdoEmote, "TTRP_HoldBehindHead", player)
            menu:addSlice(getText("IGUI_TTRP_Weapon_Shoulder"), getTexture("media/ui/poses/props/weaponshoulder.png"), TTRPdoEmote, "TTRP_Weapon-Shoulder", player)
            menu:addSlice(getText("IGUI_TTRP_Artorias"), getTexture("media/ui/poses/props/artorias.png"), TTRPdoEmote, "TTRP_Artorias", player)
            menu:addSlice(getText("IGUI_TTRP_BatterUp"), getTexture("media/ui/poses/props/batterup.png"), TTRPdoEmote, "TTRP_BatterUp", player)
            menu:addSlice(getText("IGUI_TTRP_2hAuraRest"), getTexture("media/ui/poses/props/2haura.png"), TTRPdoEmote, "TTRP_2hAuraRest", player)
            menu:addSlice(getText("IGUI_TTRP_Axe"), getTexture("media/ui/poses/props/axestance.png"), TTRPdoEmote, "TTRP_Axe", player)
            menu:addSlice(getText("IGUI_TTRP_2HWeaponInGround"), getTexture("media/ui/poses/props/2hinground.png"), TTRPdoEmote, "TTRP_2HWeaponInGround", player)
            menu:addSlice(getText("IGUI_TTRP_2HWeaponInGroundBIG"), getTexture("media/ui/poses/props/2hingroundbig.png"), TTRPdoEmote, "TTRP_2HWeaponInGroundBIG", player)
            menu:addSlice(getText("IGUI_TTRP_DualWieldAgile"), getTexture("media/ui/poses/props/dualwieldagile.png"), TTRPdoEmote, "TTRP_DualWieldAgile", player)
            menu:addSlice(getText("IGUI_TTRP_DualWieldComposed"), getTexture("media/ui/poses/props/dualwieldcomposed.png"), TTRPdoEmote, "TTRP_DualWieldComposed", player)
            menu:addSlice(getText("IGUI_TTRP_KnifeComposed"), getTexture("media/ui/poses/props/knifecomposed.png"), TTRPdoEmote, "TTRP_KnifeComposed", player)
            menu:addSlice(getText("IGUI_TTRP_1HWepComposed"), getTexture("media/ui/poses/props/1hcomposed.png"), TTRPdoEmote, "TTRP-1HWep-Composed", player)
            menu:addSlice(getText("IGUI_TTRP_MurderStance"), getTexture("media/ui/poses/props/murderstance.png"), TTRPdoEmote, "TTRP_MurderStance", player)
            menu:addSlice(getText("IGUI_TTRP_MurderStance1h"), getTexture("media/ui/poses/props/murderstance1h.png"), TTRPdoEmote, "TTRP_MurderStance1h", player)
            menu:addSlice(getText("IGUI_TTRP_MurderStanceDW"), getTexture("media/ui/poses/props/murderstance2h.png"), TTRPdoEmote, "TTRP_MurderStanceDW", player)
            menu:addSlice(getText("IGUI_TTRP_1HShield"), getTexture("media/ui/poses/props/1hshield.png"), TTRPdoEmote, "TTRP_1hShield", player)
    end
-- Pistol Parent Menu
function subPistols(menu, player)
        menu:addSlice(getText("IGUI_TTRP_Pistol1"), getTexture("media/ui/menus/pistols1.png"), ISRadialMenu.createSubMenu, menu, subPistols1, player)
        menu:addSlice(getText("IGUI_TTRP_Pistol2"), getTexture("media/ui/menus/pistols2.png"), ISRadialMenu.createSubMenu, menu, subPistols2, player)
end

function subPistols1(menu, player)
    menu:addSlice(getText("IGUI_TTRP_HoldPistol"), getTexture("media/ui/poses/props/pistolsteady.png"), TTRPdoEmote, "TTRP_HoldPistol", player)
    menu:addSlice(getText("IGUI_TTRP_HoldPistolLowReady"), getTexture("media/ui/poses/props/pistollow.png"), TTRPdoEmote, "TTRP_HoldPistolLowReady", player)
    menu:addSlice(getText("IGUI_TTRP_HighReady"), getTexture("media/ui/poses/props/pistolhigh.png"), TTRPdoEmote, "TTRP_HighReady", player)
    menu:addSlice(getText("IGUI_TTRP_Isoceles"), getTexture("media/ui/poses/props/isoceles.png"), TTRPdoEmote, "TTRP_Isoceles", player)
    menu:addSlice(getText("IGUI_TTRP_HoldPistolCrouching"), getTexture("media/ui/poses/props/pistolcrouched.png"), TTRPdoEmote, "TTRP_HoldPistolCrouching", player)
    menu:addSlice(getText("IGUI_TTRP_DualPistolsCrouch"), getTexture("media/ui/poses/props/pistolcrouchdual.png"), TTRPdoEmote, "TTRP_DualPistolsCrouch", player)
    menu:addSlice(getText("IGUI_TTRP_HoldPistolCrouchedHunched"), getTexture("media/ui/poses/props/crouchedhunched.png"), TTRPdoEmote, "TTRP_HoldPistolCrouchedHunched", player)
    menu:addSlice(getText("IGUI_TTRP_HoldPistolProned"), getTexture("media/ui/poses/props/pistolproned.png"), TTRPdoEmote, "TTRP_HoldPistolProned", player)
    menu:addSlice(getText("IGUI_TTRP_FanRevolver"), getTexture("media/ui/poses/props/revolverfanning.png"), TTRPdoEmote, "TTRP_FanRevolver", player)
    menu:addSlice(getText("IGUI_TTRP_PistolHipDrawn"), getTexture("media/ui/poses/props/pistolhip.png"), TTRPdoEmote, "TTRP_PistolHipDrawn", player)
end

function subPistols2(menu, player)
    menu:addSlice(getText("IGUI_TTRP_GunslingerReady"), getTexture("media/ui/poses/props/drawholster.png"), TTRPdoEmote, "TTRP_GunslingerReady", player)
    menu:addSlice(getText("IGUI_TTRP_Pistol_Held_Upwards"), getTexture("media/ui/poses/props/hold-pistol-up.png"), TTRPdoEmote, "TTRP_Pistol-Held-Upwards", player)
    menu:addSlice(getText("IGUI_TTRP_HeldAtGunpoint"), getTexture("media/ui/poses/props/gunoint1.png"), TTRPdoEmote, "TTRP_HeldAtGunpoint", player)
    menu:addSlice(getText("IGUI_TTRP_HeldAtGunpointOlympic"), getTexture("media/ui/poses/props/olympic.png"), TTRPdoEmote, "TTRP_HeldAtGunpointOlympic", player)
    menu:addSlice(getText("IGUI_TTRP_Clean_Pistol"), getTexture("media/ui/poses/props/cleangun.png"), TTRPdoEmote, "TTRP_Clean_Pistol", player)
    menu:addSlice(getText("IGUI_TTRP_Gangsta"), getTexture("media/ui/poses/props/gangsta.png"), TTRPdoEmote, "TTRP_Gangsta", player)
    menu:addSlice(getText("IGUI_TTRP_DualPistols"), getTexture("media/ui/poses/props/dualies.png"), TTRPdoEmote, "TTRP_DualPistols", player)
    menu:addSlice(getText("IGUI_TTRP_DualPistols2"), getTexture("media/ui/poses/props/dualies2.png"), TTRPdoEmote, "TTRP_DualPistols2", player)
    menu:addSlice(getText("IGUI_TTRP_PistolMelee"), getTexture("media/ui/poses/props/swordandshot.png"), TTRPdoEmote, "TTRP_PistolMelee", player)
    menu:addSlice(getText("IGUI_TTRP_PistolMelee2"), getTexture("media/ui/poses/props/swordandshot2.png"), TTRPdoEmote, "TTRP_PistolMelee2", player)
    menu:addSlice(getText("IGUI_TTRP_PistolWithMelee3"), getTexture("media/ui/poses/props/pistolmelee3.png"), TTRPdoEmote, "TTRP_PistolWithMelee3", player)
    menu:addSlice(getText("IGUI_TTRP_PistolWithMelee4"), getTexture("media/ui/poses/props/pistolmelee4.png"), TTRPdoEmote, "TTRP_PistolWithMelee4", player)
    menu:addSlice(getText("IGUI_TTRP_PistolWithMelee5"), getTexture("media/ui/poses/props/pistolmelee5.png"), TTRPdoEmote, "TTRP_PistolWithMelee5", player)
    menu:addSlice(getText("IGUI_TTRP_PistolWithMelee5alt"), getTexture("media/ui/poses/props/pistolmelee5.png"), TTRPdoEmote, "TTRP_PistolWithMelee5alt", player)
    menu:addSlice(getText("IGUI_TTRP_PistolSolo"), getTexture("media/ui/poses/props/pistolsolo.png"), TTRPdoEmote, "TTRP_PistolSolo", player)
    menu:addSlice(getText("IGUI_TTRP_PistolSpy"), getTexture("media/ui/poses/props/pistolspy.png"), TTRPdoEmote, "TTRP_PistolSpy", player)
    menu:addSlice(getText("IGUI_TTRP_PistolWithSass"), getTexture("media/ui/poses/props/pistolwithsass.png"), TTRPdoEmote, "TTRP_PistolWithSass", player)
    menu:addSlice(getText("IGUI_TTRP_PistolWithSassAim"), getTexture("media/ui/poses/props/pistolsassaim.png"), TTRPdoEmote, "TTRP_PistolWithSassAim", player)
end

function subInjuredProps(menu, player)
    menu:addSlice(getText("IGUI_TTRP_LongWeaponInjured"), getTexture("media/ui/poses/props/injuredgun1.png"), TTRPdoEmote, "TTRP_LongWeaponInjured", player)
    menu:addSlice(getText("IGUI_TTRP_LastStand"), getTexture("media/ui/poses/props/laststand.png"), TTRPdoEmote, "TTRP_LastStand", player)
end

function subInstruments(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Strumming"), getTexture("media/ui/poses/props/strumming.png"), TTRPdoEmote, "BttB_strumming", player)
    menu:addSlice(getText("IGUI_TTRP_GuitarPlaySitting"), getTexture("media/ui/poses/props/guitarsitting1.png"), TTRPdoEmote, "TTRP_GuitarPlaySitting", player)
    menu:addSlice(getText("IGUI_TTRP_GuitarPlayLaying"), getTexture("media/ui/poses/props/guitar-play-laying.png"), TTRPdoEmote, "TTRP_GuitarPlayLaying", player)
    menu:addSlice(getText("IGUI_TTRP_SaxPlaying"), getTexture("media/ui/poses/props/saxplaying.png"), TTRPdoEmote, "BttB_SaxPlaying1", player)
    menu:addSlice(getText("IGUI_TTRP_Keytar"), getTexture("media/ui/poses/props/keytar.png"), TTRPdoEmote, "BttB_Keytar", player)
    menu:addSlice(getText("IGUI_TTRP_Flute"), getTexture("media/ui/poses/props/flute.png"), TTRPdoEmote, "BttB_Flute", player)
    menu:addSlice(getText("IGUI_TTRP_Violin"), getTexture("media/ui/poses/props/violin.png"), TTRPdoEmote, "BttB_Violin", player)
    --menu:addSlice(getText("IGUI_TTRP_AirDrumming"), getTexture("media/ui/poses/props/drumming.png"), TTRPdoEmote, "TTRP_AirDrummingWalk", player)
end
-----------------
-- EMOTES MENU --
-----------------

function subTTRPemotes(menu, player)
    menu:addSlice(getText("IGUI_TTRP_EmoteSnortPixie"), getTexture("media/ui/poses/emotes/cocainum.png"), TTRPdoEmote, "TTRP_PixieSticks", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteAccuse"), getTexture("media/ui/poses/emotes/accuser.png"), TTRPdoEmote, "TTRP_Accost", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteUpYours"), getTexture("media/ui/poses/emotes/up-yours.png"), TTRPdoEmote, "TTRP_UpYours", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteUpYoursCasual"), getTexture("media/ui/poses/emotes/up-yours-casual.png"), TTRPdoEmote, "TTRP_UpYoursCasual", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteBigWave"), getTexture("media/ui/poses/emotes/big-wave.png"), TTRPdoEmote, "TTRP_BigWave", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteThink"), getTexture("media/ui/poses/emotes/thinking.png"), TTRPdoEmote, "TTRP_Think", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteRudeGesture"), getTexture("media/ui/poses/emotes/rude-jerk.png"), TTRPdoEmote, "TTRP_JackRude", player)
    menu:addSlice(getText("IGUI_TTRP_EmotePanic"), getTexture("media/ui/poses/emotes/freaking-out.png"), TTRPdoEmote, "TTRP_Panic", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteSigh"), getTexture("media/ui/poses/emotes/big-sigh.png"), TTRPdoEmote, "TTRP_Sighing", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteCry"), getTexture("media/ui/poses/emotes/crying1.png"), TTRPdoEmote, "TTRP_Crying1", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteFacepalm"), getTexture("media/ui/poses/emotes/facepalm.png"), TTRPdoEmote, "TTRP_Facepalm", player)
    menu:addSlice(getText("IGUI_TTRP_EmoteScared"), getTexture("media/ui/poses/emotes/scared.png"), TTRPdoEmote, "TTRP_Scared_Look", player)
end

function subTTRPDances(menu, player)
    menu:addSlice(getText("IGUI_TTRP_AwkwardDance1"), getTexture("media/ui/poses/dancing/awkward-dance-1.png"), TTRPdoEmote, "TTRP_AwkwardDance1", player)
    menu:addSlice(getText("IGUI_TTRP_AwkwardDance2"), getTexture("media/ui/poses/dancing/awkward-dance-2.png"), TTRPdoEmote, "TTRP_AwkwardDance2", player)
    menu:addSlice(getText("IGUI_TTRP_AwkwardDance3"), getTexture("media/ui/poses/dancing/awkward-dance-3.png"), TTRPdoEmote, "TTRP_AwkwardDance3", player)
    menu:addSlice(getText("IGUI_TTRP_AwkwardDance4"), getTexture("media/ui/poses/dancing/bbqdance.png"), TTRPdoEmote, "TTRP_BBQShimmy", player)
    menu:addSlice(getText("IGUI_TTRP_SpookyMonthDance"), getTexture("media/ui/poses/dancing/spookymonthdance.png"), TTRPdoEmote, "TTRP_SpookyMonthDance", player)
    menu:addSlice(getText("IGUI_TTRP_GangnamStyle"), getTexture("media/ui/poses/dancing/gangnam.png"), TTRPdoEmote, "TTRP_GangnamStyle", player)
end

---------------------------------
-- Dynamic Menu                --
---------------------------------

function subTTRPDynamic(menu, player)
    menu:addSlice(getText("IGUI_TTRP_DynamicMisc"), getTexture("media/ui/menus/dynamic-misc.png"), ISRadialMenu.createSubMenu, menu, subDynamicMisc, player)
    menu:addSlice(getText("IGUI_TTRP_DynamicCombat"), getTexture("media/ui/menus/dynamic-combat.png"), ISRadialMenu.createSubMenu, menu, subDynamicCombat, player)
    menu:addSlice(getText("IGUI_TTRP_DynamicCombat2"), getTexture("media/ui/menus/dynamic-combat2.png"), ISRadialMenu.createSubMenu, menu, subDynamicCombat2, player)
    menu:addSlice(getText("IGUI_TTRP_Workouts"), getTexture("media/ui/menus/dynamic-workouts.png"), ISRadialMenu.createSubMenu, menu, subDynamicWorkouts, player)
end

function subDynamicWorkouts(menu, player)
        menu:addSlice(getText("IGUI_TTRP_Bicyclekick"), getTexture("media/ui/poses/dynamic/bicyclekick.png"), TTRPdoEmote, "TTRP_BicycleKick", player)
        menu:addSlice(getText("IGUI_TTRP_JumpingJacks"), getTexture("media/ui/poses/dynamic/jumpingjacks.png"), TTRPdoEmote, "TTRP_JumpingJacks", player)
        menu:addSlice(getText("IGUI_TTRP_Meditate"), getTexture("media/ui/poses/sitting/meditate.png"), TTRPdoEmote, "TTRP_Meditate", player)
        menu:addSlice(getText("IGUI_TTRP_Meditate2"), getTexture("media/ui/poses/dynamic/meditate2.png"), TTRPdoEmote, "TTRP_Meditate2", player)
        menu:addSlice(getText("IGUI_TTRP_Meditate2Furniture"), getTexture("media/ui/poses/dynamic/meditate2.png"), TTRPdoEmote, "TTRP_Meditate2_Furniture", player)
        menu:addSlice(getText("IGUI_TTRP_Dafoe"), getTexture("media/ui/poses/dynamic/dafoe.png"), TTRPdoEmote, "TTRP_Dafoe", player)
        menu:addSlice(getText("IGUI_TTRP_Stretch_Triangle"), getTexture("media/ui/poses/dynamic/stretch1.png"), TTRPdoEmote, "TTRP_Stretch_Triangle", player)
        menu:addSlice(getText("IGUI_TTRP_Stretch_StandingBackSplit"), getTexture("media/ui/poses/dynamic/stretch2.png"), TTRPdoEmote, "TTRP_Stretch_StandingBackSplit", player)
end


function subDynamicMisc(menu, player)
    menu:addSlice(getText("IGUI_TTRP_HandsOverStomach"), getTexture("media/ui/poses/dynamic/handstomach.png"), TTRPdoEmote, "TTRP_HandsOverStomach", player)
    menu:addSlice(getText("IGUI_TTRP_ArmSling"), getTexture("media/ui/poses/dynamic/sling.png"), TTRPdoEmote, "TTRP_ArmSling", player)
    menu:addSlice(getText("IGUI_TTRP_BackpackRummage"), getTexture("media/ui/poses/dynamic/backpackrummage.png"), TTRPdoEmote, "TTRP_BackpackRummage", player)
    menu:addSlice(getText("IGUI_TTRP_Drunk"), getTexture("media/ui/poses/dynamic/drunkenshamble.png"), TTRPdoEmote, "TTRP_Drunk", player)
    menu:addSlice(getText("IGUI_TTRP_CPR"), getTexture("media/ui/poses/dynamic/cpr.png"), TTRPdoEmote, "TTRP_CPR", player)
    menu:addSlice(getText("IGUI_TTRP_CookingWithSpice"), getTexture("media/ui/poses/dynamic/spicybrain.png"), TTRPdoEmote, "TTRP_CookingWithSpice", player)
    menu:addSlice(getText("IGUI_TTRP_Handwash"), getTexture("media/ui/poses/dynamic/handwash.png"), TTRPdoEmote, "TTRP_Handwash", player)
    menu:addSlice(getText("IGUI_TTRP_CoolingOff"), getTexture("media/ui/poses/dynamic/coolingoff.png"), TTRPdoEmote, "TTRP_CoolingOff", player)
    menu:addSlice(getText("IGUI_TTRP_PointBehind"), getTexture("media/ui/poses/dynamic/pointbehind.png"), TTRPdoEmote, "TTRP_Blackboard", player)
    menu:addSlice(getText("IGUI_TTRP_ExamineHand"), getTexture("media/ui/poses/dynamic/examine.png"), TTRPdoEmote, "TTRP_ExamineHand", player)
    menu:addSlice(getText("IGUI_TTRP_WallTinkle"), getTexture("media/ui/poses/dynamic/p-i-s-s.png"), TTRPdoEmote, "TTRP_Wall_Tinkle", player)
    menu:addSlice(getText("IGUI_TTRP_ClutchingToilet"), getTexture("media/ui/poses/dynamic/toiletchuck.png"), TTRPdoEmote, "TTRP_ClutchingToilet", player)
    menu:addSlice(getText("IGUI_TTRP_Snowangel"), getTexture("media/ui/poses/dynamic/starfish.png"), TTRPdoEmote, "TTRP_Snowangel", player)
    menu:addSlice(getText("IGUI_TTRP_ASL"), getTexture("media/ui/poses/dynamic/asl.png"), TTRPdoEmote, "TTRP_ASL", player)
    menu:addSlice(getText("IGUI_TTRP_CampfireSit"), getTexture("media/ui/poses/dynamic/campfire-squat.png"), TTRPdoEmote, "TTRP_CampfireSit", player)
    menu:addSlice(getText("IGUI_TTRP_Texting"), getTexture("media/ui/poses/dynamic/standtexting.png"), TTRPdoEmote, "TTRP_Texting", player)
    menu:addSlice(getText("IGUI_TTRP_Prostrating"), getTexture("media/ui/poses/dynamic/prostrate.png"), TTRPdoEmote, "TTRP_Prostrating", player)
    menu:addSlice(getText("IGUI_TTRP_HandCuffTestFront"), getTexture("media/ui/poses/sitting/hands-cuffed.png"), TTRPdoEmote, "TTRP_CuffsInFront", player)
    menu:addSlice(getText("IGUI_TTRP_HandCuffTest"), getTexture("media/ui/poses/sitting/hands-cuffed.png"), TTRPdoEmote, "TTRP_CuffsBehind", player)
    menu:addSlice(getText("IGUI_TTRP_HandCuffTestFrontStruggle"), getTexture("media/ui/poses/sitting/hands-cuffed.png"), TTRPdoEmote, "TTRP_CuffsInFrontStruggle", player)
    menu:addSlice(getText("IGUI_TTRP_HandCuffTestBackStruggle"), getTexture("media/ui/poses/sitting/hands-cuffed.png"), TTRPdoEmote, "TTRP_CuffsBehindStruggle", player)
    menu:addSlice(getText("IGUI_TTRP_Prostrating"), getTexture("media/ui/poses/dynamic/prostrate.png"), TTRPdoEmote, "TTRP_Prostrating", player)
    -- menu:addSlice("Brushing/Mopping", getTexture("media/ui/poses/dynamic/brushmop.png"), doTTRPActions, "Base.PropaneTank", "mop")
end

function subDynamicCombat(menu, player)
    menu:addSlice(getText("IGUI_TTRP_ShadowBoxing"), getTexture("media/ui/poses/dynamic/shadowboxing.png"), TTRPdoEmote, "TTRP_ShadowBoxing", player)
    menu:addSlice(getText("IGUI_TTRP_FightingStance1"), getTexture("media/ui/poses/dynamic/fightingstance1.png"), TTRPdoEmote, "TTRP_FightingStance1", player)
    menu:addSlice(getText("IGUI_TTRP_FightingStance2"), getTexture("media/ui/poses/dynamic/fightingstance2.png"), TTRPdoEmote, "TTRP_FightingStance2", player)
    menu:addSlice(getText("IGUI_TTRP_FightingStance3"), getTexture("media/ui/poses/dynamic/fightingstance3.png"), TTRPdoEmote, "TTRP_FightingStance3", player)
    menu:addSlice(getText("IGUI_TTRP_Fisticuffs"), getTexture("media/ui/poses/dynamic/fisticuffs.png"), TTRPdoEmote, "TTRP_Fisticuffs", player)
    menu:addSlice(getText("IGUI_TTRP_PostedUp"), getTexture("media/ui/poses/dynamic/postedup.png"), TTRPdoEmote, "TTRP_PostedUp", player)
    menu:addSlice(getText("IGUI_TTRP_BeastMode"), getTexture("media/ui/poses/dynamic/beastmode.png"), TTRPdoEmote, "TTRP_BeastMode", player)
    menu:addSlice(getText("IGUI_TTRP_MajimaThugging"), getTexture("media/ui/poses/dynamic/majimathugging.png"), TTRPdoEmote, "TTRP_MajimaThugging", player)
    menu:addSlice(getText("IGUI_TTRP_ShadowBoxing"), getTexture("media/ui/poses/dynamic/shadowboxing.png"), TTRPdoEmote, "TTRP_ShadowBoxing", player)
    menu:addSlice(getText("IGUI_TTRP_Capoeira"), getTexture("media/ui/poses/dynamic/capoeira.png"), TTRPdoEmote, "TTRP_Capoeira", player)
    menu:addSlice(getText("IGUI_TTRP_FlipKick"), getTexture("media/ui/poses/dynamic/flipkick.png"), TTRPdoEmote, "TTRP_FlipKick", player)
    menu:addSlice(getText("IGUI_TTRP_Raid"), getTexture("media/ui/poses/dynamic/raid.png"), TTRPdoEmote, "TTRP_Raid", player)
    menu:addSlice(getText("IGUI_TTRP_JeetKuneDo"), getTexture("media/ui/poses/dynamic/jkd.png"), TTRPdoEmote, "TTRP_JeetKuneDo", player)
end

function subDynamicCombat2(menu, player)
    menu:addSlice(getText("IGUI_TTRP_Gojo"), getTexture("media/ui/poses/dynamic/gojo.png"), TTRPdoEmote, "TTRP_Gojo", player)
    menu:addSlice(getText("IGUI_TTRP_Lars"), getTexture("media/ui/poses/dynamic/lars.png"), TTRPdoEmote, "TTRP_Lars", player)
    menu:addSlice(getText("IGUI_TTRP_SquareUp"), getTexture("media/ui/poses/dynamic/squareup.png"), TTRPdoEmote, "TTRP_SquareUp", player)
    menu:addSlice(getText("IGUI_TTRP_Sukuna"), getTexture("media/ui/poses/dynamic/sukuna.png"), TTRPdoEmote, "TTRP_Sukuna", player)
    menu:addSlice(getText("IGUI_TTRP_BoxingHitman"), getTexture("media/ui/poses/dynamic/boxinghitman.png"), TTRPdoEmote, "TTRP_BoxingHitman", player)
    menu:addSlice(getText("IGUI_TTRP_AverageFighter"), getTexture("media/ui/poses/dynamic/averagefighter.png"), TTRPdoEmote, "TTRP_AverageFighter", player)
    menu:addSlice(getText("IGUI_TTRP_Horsestance"), getTexture("media/ui/poses/dynamic/horsestance.png"), TTRPdoEmote, "TTRP_Horsestance", player)
    menu:addSlice(getText("IGUI_TTRP_Wrestling"), getTexture("media/ui/poses/dynamic/wrestlingblend.png"), TTRPdoEmote, "TTRP_Wrestling", player)
    menu:addSlice(getText("IGUI_TTRP_PeekabooBoxing"), getTexture("media/ui/poses/dynamic/peekabooboxing.png"), TTRPdoEmote, "TTRP_PeekabooBoxing", player)
    menu:addSlice(getText("IGUI_TTRP_MuayThai"), getTexture("media/ui/poses/dynamic/muay-thai.png"), TTRPdoEmote, "TTRP_MuayThai", player)
    menu:addSlice(getText("IGUI_TTRP_Grappler"), getTexture("media/ui/poses/dynamic/grappler.png"), TTRPdoEmote, "TTRP_Grappler", player)
end
--------------------
-- FAVORITES MENU --
--------------------

function subTTRPFavorites(menu, player)
    local favoritesTable = nil
    if TTRPFavorites and TTRPFavorites.ensureLoaded then
        favoritesTable = TTRPFavorites.ensureLoaded()
    else
        favoritesTable = Favorites or {}
    end

    for text, data in pairs(favoritesTable) do
        if data and data.texture and data.command then
            local texture = nil
            if TTRPFavorites and TTRPFavorites.resolveTexture then
                texture = TTRPFavorites.resolveTexture(data.texture)
            elseif type(data.texture) == "userdata" then
                texture = data.texture
            elseif type(data.texture) == "string" then
                local cleanTexturePath = data.texture:gsub("\\\\", "/"):gsub("\\", "/")
                texture = getTexture(cleanTexturePath)
            end

            -- We need to hardcode the function, couldn't figure out how to correctly extract function data from JSON strings. Might revisit this to let it dynamically store function information in JSON, but I couldn't figure out how.
            local commandFunc = TTRPdoEmote
            local commandArg = nil
            if TTRPFavorites and TTRPFavorites.getEntryEmote then
                commandArg = TTRPFavorites.getEntryEmote(data)
            elseif type(data.command) == "table" then
                commandArg = data.command[2]
            end

            if commandArg then
                menu:addSlice(text, texture, commandFunc, commandArg, player)
            end

        else
            -- --print("Error: Invalid data for favorite:", text)
        end
    end
end

-------------------------------------------------------------------------------------
-- Modified Fuu's action code - Timed Action triggers. Currently these do nothing. --
-- These will be utilized in a future update.                                      --
-------------------------------------------------------------------------------------

 function doTTRPActions(item, action)
     local player = getSpecificPlayer(0)
     if action == "mop" then
        ISTimedActionQueue.add(TTRPBrushMopAction:new(player, item))
     end
 end

 function doTTRPActionsBothHands(item1, item2, action)
    local player = getSpecificPlayer(0)
    if action == "mop" then
        ISTimedActionQueue.add(TTRPBrushMopAction:new(player, item1, item2))
    end
 end

-----------------------------------------------
-- Forbidden Card Poses - Admin only spawns. --
-----------------------------------------------

ForbiddenPoses = {
    ["TTRP.Forbidden_Splits_Card"] = "TTRP_TwerkSplits",
    ["TTRP.Forbidden_Twerk_Card"] = "TTRP_Twerk",
    ["TTRP.Forbidden_T-Pose"] = "TTRP_T-Pose",
    ["TTRP.Forbidden_Frey"] = "TTRP_CaseyFrey",
    ["TTRP.Forbidden_Restart"] = "TTRP_Restart",
    ["TTRP.PinkGuy"] = "TTRP_PinkGuy",
    ["TTRP.SexySax"] = "BttB_SaxPlaying2",
    ["TTRP.GirlypopTwerk"] = "TTRP_GirlypopTwerk",
    ["TTRP.HurricaneKick"] = "TTRP_HurricaneKick",
    ["TTRP.SpookyMonthDance"] = "TTRP_SpookyMonthDanceForbidden",
    ["TTRP.Ascension"] = "TTRP_Lying_RapturedForbidden",
    ["TTRP.InfectedAnim1"] = "TTRP_InfectedAnim1",
    ["TTRP.Howler_Idle2"] = "TTRP_Howler_Idle2",
    ["TTRP.Howler_Call"] = "TTRP_Howler_Call",
    ["TTRP.Howler_Idle"] = "TTRP_Howler_Idle",
    ["TTRP.InfectedCeilingCrawler"] = "TTRP_InfectedCeilingCrawler",
    ["TTRP.Trickshot"] = "TTRP_Trickshot",
    ["TTRP.Forbidden_TPOSE"] = "TTRP_TPOSE",

}

function subForbidden(menu, player)
    local playerItems = getPlayer():getInventory():getItems()
    for i=1,playerItems:size() do
        local item = playerItems:get(i-1)
        if ForbiddenPoses[item:getFullType()] then
            menu:addSlice(ForbiddenPoses[item:getFullType()], getTexture('ui/poses/Forbidden/' .. ForbiddenPoses[item:getFullType()] .. '.png'), TTRPdoEmote, ForbiddenPoses[item:getFullType()], player)
        end
    end
end

TTRPEmoteMenuAPI.registerSlice("TTRP Poses", poseTTRPMain)
---------------------------------------------------------------
-- Radial Slice Detection For Favorites                      --
---------------------------------------------------------------

function SaveRadialSlice(key)
    if key == getCore():getKey("TTRP_Favorite") then 
        local player = getSpecificPlayer(0) 

        local radialMenu = getPlayerRadialMenu(0) 
        if radialMenu and radialMenu:isReallyVisible() then
            local mx, my = getMouseX(), getMouseY()
            local lx = mx - radialMenu:getX()
            local ly = my - radialMenu:getY()
            
            local sliceIndex = radialMenu.javaObject:getSliceIndexFromMouse(lx, ly)
            
            if sliceIndex and sliceIndex >= 0 then
                local sliceText = TTRPGetSliceText(radialMenu, sliceIndex + 1)
                if sliceText then
                    local sliceTexture = TTRPGetSliceTexture(radialMenu, sliceIndex + 1)
                    local sliceCommand = radialMenu:getSliceCommand(sliceIndex + 1)

                    if not sliceCommand or sliceCommand[1] ~= TTRPdoEmote then
                        return
                    end

                    local sliceEmote = sliceCommand[2]
                    if type(sliceEmote) ~= "string" then
                        return
                    end

                    if TTRPFavorites and TTRPFavorites.toggle then
                        TTRPFavorites.toggle(sliceText, sliceTexture, sliceEmote)
                    end

                    if radialMenu then
                        radialMenu:refreshFavoritesMenu(player)
                        -- --print("Refreshed Favorites menu.")
                    end
                end
            end
        end
    end
end

----------------------------------------
-- Menu refresh on Favorites Addition --
----------------------------------------
function ISRadialMenu:clearSlices()
    self.slices = {}
    if self.javaObject then
        self.javaObject:clear() 
    end
end

function ISRadialMenu:refreshFavoritesMenu(player)
    self:clearSlices()
    TTRPSubmenu(self, player)
    self:display()
end

Events.OnGameStart.Add(function()
    if TTRPFavorites and TTRPFavorites.load then
        TTRPFavorites.load()
    end
end)
Events.OnKeyPressed.Add(SaveRadialSlice)



