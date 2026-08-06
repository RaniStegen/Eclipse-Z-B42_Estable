require "OfflineSurvivorV2/OS_Constants"
require "OfflineSurvivorV2/OS_LootUI"

local OS = OfflineSurvivorV2
local sealedVisualContainers = setmetatable({}, { __mode = "k" })
local sealScanTick = 0

-- The native corpse stores visual clones in an ItemContainer so its HumanVisual
-- and worn items can be sent by the standard corpse packet. The V2 loot UI is
-- the only permitted route to the real offline inventory.
local function isOfflineVisualContainer(container)
    if not container then return false end
    local ok, parent = pcall(function() return container:getParent() end)
    if not ok or not parent then return false end
    local data = nil
    ok, data = pcall(function() return parent:getModData() end)
    return ok and data and data[OS.OFFLINE_MARKER] and data.renderer == OS.RENDERER
end

local function isOfflineVisualObject(object)
    if not object then return false end
    local ok, data = pcall(function() return object:getModData() end)
    return ok and data and data[OS.OFFLINE_MARKER] and data.renderer == OS.RENDERER
end

-- The corpse packet needs its temporary clothing items so the native renderer
-- can build the correct mesh.  On a client those items would otherwise also
-- be exposed as ordinary corpse loot.  Replacing only the displayed corpse
-- container keeps WornItems/hand models intact while leaving no item for the
-- inventory UI or transfer actions to take.  The server keeps its original
-- visual container for later chunk/save replication.
local function sealOfflineVisualCorpse(object)
    if not isOfflineVisualObject(object) or sealedVisualContainers[object] then return false end

    local ok, original = pcall(function() return object:getContainer() end)
    if not ok or not original then return false end

    local replacement = nil
    ok, replacement = pcall(function() return ItemContainer.new() end)
    if not ok or not replacement then return false end

    ok = pcall(function() object:setContainer(replacement) end)
    if not ok then return false end
    sealedVisualContainers[object] = replacement
    return true
end

local function installVisualCloneGuards()
    require "TimedActions/ISInventoryTransferAction"
    require "TimedActions/ISGrabCorpseAction"
    require "TimedActions/ISBurnCorpseAction"
    require "ISUI/ISInventoryPane"
    require "ISUI/ISInventoryPage"
    require "TimedActions/ISInventoryTransferUtil"

    if ISInventoryTransferAction and not ISInventoryTransferAction.OfflineSurvivorV2Guard then
        local baseIsValid = ISInventoryTransferAction.isValid
        function ISInventoryTransferAction:isValid()
            if isOfflineVisualContainer(self.srcContainer) or isOfflineVisualContainer(self.destContainer) then
                return false
            end
            return baseIsValid(self)
        end
        ISInventoryTransferAction.OfflineSurvivorV2Guard = true
    end

    -- Some inventory actions create their transfer action through this helper.
    -- Keep an explicit guard here as well, including for UI paths added by
    -- other mods that don't call ISInventoryPane directly.
    if ISInventoryTransferUtil and not ISInventoryTransferUtil.OfflineSurvivorV2Guard then
        local baseNewTransferAction = ISInventoryTransferUtil.newInventoryTransferAction
        function ISInventoryTransferUtil.newInventoryTransferAction(character, item, srcContainer, destContainer, time)
            local action = baseNewTransferAction(character, item, srcContainer, destContainer, time)
            if action and (isOfflineVisualContainer(srcContainer) or isOfflineVisualContainer(destContainer)) then
                function action:isValid()
                    return false
                end
            end
            return action
        end
        ISInventoryTransferUtil.OfflineSurvivorV2Guard = true
    end

    if ISInventoryPane and not ISInventoryPane.OfflineSurvivorV2Guard then
        local baseRefreshContainer = ISInventoryPane.refreshContainer
        local baseLootAll = ISInventoryPane.lootAll
        local baseTransferAll = ISInventoryPane.transferAll
        local baseTransferItemsByWeight = ISInventoryPane.transferItemsByWeight
        local baseOnMouseDoubleClick = ISInventoryPane.onMouseDoubleClick

        function ISInventoryPane:refreshContainer()
            if isOfflineVisualContainer(self.inventory) then
                -- Never display the renderer-only items, even if another UI
                -- selected this container before the corpse was sealed.
                self.items = {}
                self.itemslist = {}
                self.itemindex = {}
                self.selected = {}
                return
            end
            return baseRefreshContainer(self)
        end

        function ISInventoryPane:lootAll()
            if isOfflineVisualContainer(self.inventory) then return end
            return baseLootAll(self)
        end

        function ISInventoryPane:transferAll()
            if isOfflineVisualContainer(self.inventory) then return end
            return baseTransferAll(self)
        end

        function ISInventoryPane:transferItemsByWeight(items, container)
            if isOfflineVisualContainer(self.inventory) or isOfflineVisualContainer(container) then return end
            for _, item in ipairs(items or {}) do
                local source = nil
                pcall(function() source = item:getContainer() end)
                if isOfflineVisualContainer(source) then return end
            end
            return baseTransferItemsByWeight(self, items, container)
        end

        function ISInventoryPane:onMouseDoubleClick(x, y)
            if isOfflineVisualContainer(self.inventory) then return end
            return baseOnMouseDoubleClick(self, x, y)
        end
        ISInventoryPane.OfflineSurvivorV2Guard = true
    end

    if ISInventoryPage and not ISInventoryPage.OfflineSurvivorV2Guard then
        local baseSetNewContainer = ISInventoryPage.setNewContainer
        function ISInventoryPage:setNewContainer(inventory)
            if isOfflineVisualContainer(inventory) then return end
            return baseSetNewContainer(self, inventory)
        end
        ISInventoryPage.OfflineSurvivorV2Guard = true
    end

    -- Prevent ordinary clients from dragging or burning an offline proxy.
    -- The body remains static; only the custom Search command is allowed.
    if ISGrabCorpseAction and not ISGrabCorpseAction.OfflineSurvivorV2Guard then
        local baseIsValid = ISGrabCorpseAction.isValid
        function ISGrabCorpseAction:isValid()
            -- B42 uses corpseBody, while a few compatibility paths still use
            -- corpse. Guard both so this visual proxy can never be picked up.
            if isOfflineVisualObject(self.corpseBody) or isOfflineVisualObject(self.corpse) then return false end
            return baseIsValid(self)
        end
        ISGrabCorpseAction.OfflineSurvivorV2Guard = true
    end

    if ISBurnCorpseAction and not ISBurnCorpseAction.OfflineSurvivorV2Guard then
        local baseIsValid = ISBurnCorpseAction.isValid
        function ISBurnCorpseAction:isValid()
            if isOfflineVisualObject(self.corpse) then return false end
            return baseIsValid(self)
        end
        ISBurnCorpseAction.OfflineSurvivorV2Guard = true
    end
end

installVisualCloneGuards()

local function offlineData(object)
    if not object then return nil end
    local ok, data = pcall(function() return object:getModData() end)
    if ok and data and data[OS.OFFLINE_MARKER] and data.steamId then return data end
    return nil
end

local function findOfflineObject(worldObjects)
    for _, object in ipairs(worldObjects or {}) do
        local data = offlineData(object)
        if data then
            sealOfflineVisualCorpse(object)
            return object, data
        end
    end

    -- A corpse is in staticMovingObjects, not square.objects. World context
    -- callbacks do not always include it, so inspect its square explicitly.
    local firstObject = worldObjects and worldObjects[1]
    if not firstObject then return nil, nil end
    local ok, square = pcall(function() return firstObject:getSquare() end)
    if not ok or not square then return nil, nil end

    local function findOnSquare(list)
        if not list then return nil, nil end
        for index = 0, list:size() - 1 do
            local object = list:get(index)
            local data = offlineData(object)
            if data then
                sealOfflineVisualCorpse(object)
                return object, data
            end
        end
        return nil, nil
    end

    local object, data = findOnSquare(square:getStaticMovingObjects())
    if object then return object, data end
    return findOnSquare(square:getObjects())
end

local function optionReferencesObject(option, object)
    if not option or not object then return false end
    if option.target == object then return true end
    for index = 1, 10 do
        if option["param" .. index] == object then return true end
    end
    return false
end

local function removeMenuOption(menu, index)
    local option = menu.options[index]
    if option and menu.optionPool then table.insert(menu.optionPool, option) end
    table.remove(menu.options, index)
    menu.numOptions = #menu.options + 1
    for optionIndex, remaining in ipairs(menu.options) do
        remaining.id = optionIndex
    end
end

-- OnFillWorldObjectContextMenu runs after the base game has added its corpse
-- entries. Remove only options whose arguments reference this exact offline
-- body, leaving normal ground items and real corpses on the same square alone.
local function removeNativeCorpseOptions(menu, corpse)
    if not menu or not menu.options then return false end
    local changed = false
    for index = #menu.options, 1, -1 do
        local option = menu.options[index]
        local subMenu = option and option.subOption and menu:getSubMenu(option.subOption) or nil
        if subMenu and removeNativeCorpseOptions(subMenu, corpse) then changed = true end
        if optionReferencesObject(option, corpse) or (subMenu and #subMenu.options == 0) then
            removeMenuOption(menu, index)
            changed = true
        end
    end
    if changed then
        menu:calcHeight()
        menu:setWidth(menu:calcWidth())
    end
    return changed
end

local function notify(message)
    message = tostring(message or "")
    if message == "" then return end

    local player = getSpecificPlayer(0)
    if player and HaloTextHelper and HaloTextHelper.addText then
        local ok = pcall(function() HaloTextHelper.addText(player, message) end)
        if ok then return end
    end
    if player and player.Say then
        pcall(function() player:Say(message) end)
    else
        print("[OfflineSurvivor V2] " .. message)
    end
end

function OS.requestLoot(_, playerIndex, targetSteamId)
    if not targetSteamId then return end
    local player = getSpecificPlayer(playerIndex or 0)
    if not player then return end

    sendClientCommand(player, OS.MODULE, OS.COMMAND_REQUEST_LOOT, {
        targetSteamId = tostring(targetSteamId),
    })
end

local function addOfflineContext(playerIndex, context, worldObjects, test)
    if test or not OS.isEnabled() then return end

    local object, data = findOfflineObject(worldObjects)
    if not data then return end

    sealOfflineVisualCorpse(object)
    removeNativeCorpseOptions(context, object)

    local label = context:addOption((data.username or "Jugador") .. " está descansando.", nil, nil)
    label.notAvailable = true

    local option = context:addOption("Registrar", OS, OS.requestLoot, playerIndex, data.steamId)
    if OS.getOption("EnableLoot", true) == false then option.notAvailable = true end
end

local function sealNearbyOfflineCorpses()
    sealScanTick = sealScanTick + 1
    if sealScanTick % 60 ~= 0 then return end

    local player = getSpecificPlayer(0)
    if not player then return end
    local cell = getCell()
    if not cell then return end

    local x = math.floor(player:getX())
    local y = math.floor(player:getY())
    local z = math.floor(player:getZ())
    for dx = -4, 4 do
        for dy = -4, 4 do
            local square = cell:getGridSquare(x + dx, y + dy, z)
            local objects = square and square:getStaticMovingObjects() or nil
            if objects then
                for index = 0, objects:size() - 1 do
                    sealOfflineVisualCorpse(objects:get(index))
                end
            end
        end
    end
end

local function onServerCommand(module, command, args)
    if module ~= OS.MODULE then return end
    args = args or {}

    if command == OS.COMMAND_OPEN_LOOT then
        OS.openLootUI(args)
    elseif command == OS.COMMAND_LOOT_RESULT then
        if OS.ActiveLootUI and tonumber(OS.ActiveLootUI.sessionId) == tonumber(args.sessionId) then
            OS.ActiveLootUI:finish()
        end
        notify(args.message)
    elseif command == OS.COMMAND_LOOT_NOTICE then
        notify(args.message)
    end
end

Events.OnFillWorldObjectContextMenu.Add(addOfflineContext)
Events.OnServerCommand.Add(onServerCommand)
Events.OnTick.Add(sealNearbyOfflineCorpses)
