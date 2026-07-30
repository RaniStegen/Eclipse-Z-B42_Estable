require "TimedActions/ISBaseTimedAction"
require "LootRequiresLight/LootRequiresLight_Utils"

LRL_SearchInDarknessAction = ISBaseTimedAction:derive("LRL_SearchInDarknessAction")

function LRL_SearchInDarknessAction:isValid()
    return self.character ~= nil
        and self.container ~= nil
        and LRL_Utils.isWorldLootContainer(self.character, self.container)
end

function LRL_SearchInDarknessAction:start()
    self:setActionAnim("Loot")
    self:setOverrideHandModels(nil, nil)
    self.character:reportEvent("EventLootItem")

    local parent = LRL_Utils.getContainerParent(self.container)
    if parent and self.character.faceThisObject then
        pcall(function() self.character:faceThisObject(parent) end)
    end
end

function LRL_SearchInDarknessAction:update()
    local parent = LRL_Utils.getContainerParent(self.container)
    if parent and self.character.faceThisObject then
        pcall(function() self.character:faceThisObject(parent) end)
    end
end

function LRL_SearchInDarknessAction:perform()
    -- Completing the action may unlock this existing container briefly. It never creates, removes or moves loot.
    if not LRL_Utils.darkSearchSucceeds(self.character) then
        LRL_Utils.showMessage(self.character, "IGUI_LRL_FailedDarkSearch", "I can feel things inside, but I can't tell what they are.")
        ISBaseTimedAction.perform(self)
        return
    end

    LRL_Utils.allowTemporarily(self.character, self.container, 25)

    if getPlayerLoot and self.character.getPlayerNum then
        local page = getPlayerLoot(self.character:getPlayerNum())
        if page and page.setForceSelectedContainer then
            page:setForceSelectedContainer(self.container, 5000)
        end
    end

    ISBaseTimedAction.perform(self)
end

function LRL_SearchInDarknessAction:new(character, container)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.container = container
    o.maxTime = LRL_Utils.getMoodledSearchTime(character)
    o.stopOnWalk = true
    o.stopOnRun = true
    o.stopOnAim = true
    return o
end

function LootRequiresLight.queueDarkSearch(player, container)
    if not player or not container then return end
    if not (SandboxVars and SandboxVars.LootRequiresLight and SandboxVars.LootRequiresLight.AllowSearchingInDarkness) then
        return
    end
    if ISTimedActionQueue and LRL_SearchInDarknessAction then
        ISTimedActionQueue.add(LRL_SearchInDarknessAction:new(player, container))
    end
end
