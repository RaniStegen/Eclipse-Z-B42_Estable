require "LootRequiresLight/LootRequiresLight_Utils"
require "LootRequiresLight/LootRequiresLight_TimedActions"

LootRequiresLight.LastWarning = LootRequiresLight.LastWarning or {}

local function warn(player, key, fallback)
    local playerNum = player and player.getPlayerNum and player:getPlayerNum() or 0
    local now = LRL_Utils.nowSeconds()
    if (LootRequiresLight.LastWarning[playerNum] or 0) + 1.5 > now then return end
    LootRequiresLight.LastWarning[playerNum] = now
    LRL_Utils.showMessage(player, key, fallback)
end

local function safeCall(fn, fallback)
    local ok, result = pcall(fn)
    if ok then return result end
    return fallback
end

local function getClickedWorldContainer(object, x, y)
    if not object then return nil end

    local container = safeCall(function()
        if object.getContainerClickedOn then
            return object:getContainerClickedOn(x, y)
        end
    end, nil)
    if container then return container end

    return safeCall(function()
        if object.getContainer then
            return object:getContainer()
        end
    end, nil)
end

function LootRequiresLight.patchObjectClickHandler()
    if not ISObjectClickHandler or ISObjectClickHandler.LootRequiresLightPatched or not ISObjectClickHandler.doClick then return end

    ISObjectClickHandler.LRLOldDoClick = ISObjectClickHandler.doClick
    ISObjectClickHandler.doClick = function(object, x, y)
        local playerObj = getSpecificPlayer(0)
        local container = getClickedWorldContainer(object, x, y)

        if LRL_Utils.isVehicleContainer(container) then
            return ISObjectClickHandler.LRLOldDoClick(object, x, y)
        end

        -- Block the direct furniture click without touching the inventory page.
        if LRL_Utils.shouldBlockContainer(playerObj, container) then
            warn(playerObj, "IGUI_LRL_NoLight", "I can't see anything.")
            return
        end

        return ISObjectClickHandler.LRLOldDoClick(object, x, y)
    end

    ISObjectClickHandler.LootRequiresLightPatched = true
end

function LootRequiresLight.patchTransferAction()
    if not ISInventoryTransferAction or ISInventoryTransferAction.LootRequiresLightPatched or not ISInventoryTransferAction.isValid then return end

    ISInventoryTransferAction.LRLOldIsValid = ISInventoryTransferAction.isValid
    function ISInventoryTransferAction:isValid()
        if LRL_Utils.isVehicleContainer(self.srcContainer)
            or LRL_Utils.isVehicleContainer(self.destContainer) then
            return ISInventoryTransferAction.LRLOldIsValid(self)
        end

        -- Fallback gameplay guard: if another UI path starts a transfer from/to a dark world container, cancel it.
        if LRL_Utils.shouldBlockContainer(self.character, self.srcContainer)
            or LRL_Utils.shouldBlockContainer(self.character, self.destContainer) then
            warn(self.character, "IGUI_LRL_NoLight", "I can't see anything.")
            return false
        end
        return ISInventoryTransferAction.LRLOldIsValid(self)
    end

    ISInventoryTransferAction.LootRequiresLightPatched = true
end

local function selectFloorWithoutRefreshing(page)
    if not page or page.onCharacter or not page.inventoryPane or type(page.backpacks) ~= "table" then
        return
    end

    local floorButton = nil
    for _, button in ipairs(page.backpacks) do
        local container = button and button.inventory or nil
        if container and safeCall(function() return container:getType() == "floor" end, false) then
            floorButton = button
            break
        end
    end
    if not floorButton then return end

    page.inventoryPane.lastinventory = floorButton.inventory
    page.inventoryPane.inventory = floorButton.inventory
    page.inventory = floorButton.inventory
    page.capacity = floorButton.capacity
    page.title = floorButton.name
    page.selectedButton = floorButton

    for _, button in ipairs(page.backpacks) do
        if button and button.setBackgroundRGBA then
            if button == floorButton then
                button:setBackgroundRGBA(0.7, 0.7, 0.7, 1.0)
            else
                button:setBackgroundRGBA(0.0, 0.0, 0.0, 0.0)
            end
        end
    end

    if page.inventoryPane.refreshContainer then
        page.inventoryPane:refreshContainer()
    end
    if page.refreshWeight then page:refreshWeight() end
    if page.updateItemCount then page:updateItemCount() end
end

function LootRequiresLight.patchInventoryPage()
    if not ISInventoryPage or ISInventoryPage.LootRequiresLightSelectionPatched then return end
    if not ISInventoryPage.selectContainer or not ISInventoryPage.checkExplored then return end

    ISInventoryPage.LRLOldSelectContainer = ISInventoryPage.selectContainer
    function ISInventoryPage:selectContainer(button)
        local container = button and button.inventory or nil
        local playerObj = getSpecificPlayer(self.player)

        if LRL_Utils.shouldBlockContainer(playerObj, container) then
            warn(playerObj, "IGUI_LRL_NoLight", "I can't see anything.")
            return
        end

        return ISInventoryPage.LRLOldSelectContainer(self, button)
    end

    ISInventoryPage.LRLOldCheckExplored = ISInventoryPage.checkExplored
    function ISInventoryPage:checkExplored(container, playerObj)
        if LRL_Utils.shouldBlockContainer(playerObj, container) then
            return
        end
        return ISInventoryPage.LRLOldCheckExplored(self, container, playerObj)
    end

    ISInventoryPage.LootRequiresLightSelectionPatched = true
end

local function onRefreshInventoryWindowContainers(page, phase)
    if phase ~= "end" or not page or page.onCharacter or not page.inventoryPane then return end

    local playerObj = getSpecificPlayer(page.player)
    if LRL_Utils.shouldBlockContainer(playerObj, page.inventoryPane.inventory) then
        selectFloorWithoutRefreshing(page)
    end
end

local function installPatches()
    LootRequiresLight.patchInventoryPage()
    LootRequiresLight.patchObjectClickHandler()
    LootRequiresLight.patchTransferAction()
end

installPatches()

if Events and Events.OnRefreshInventoryWindowContainers
        and not LootRequiresLight.RefreshSelectionGuardInstalled then
    Events.OnRefreshInventoryWindowContainers.Add(onRefreshInventoryWindowContainers)
    LootRequiresLight.RefreshSelectionGuardInstalled = true
end

if Events and Events.OnGameStart then
    Events.OnGameStart.Add(installPatches)
end
