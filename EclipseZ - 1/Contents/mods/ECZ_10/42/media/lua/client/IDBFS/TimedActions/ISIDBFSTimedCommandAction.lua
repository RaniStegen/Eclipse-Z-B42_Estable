require "TimedActions/ISBaseTimedAction"
require "IDBFS_Core"

ISIDBFSTimedCommandAction = ISBaseTimedAction:derive("ISIDBFSTimedCommandAction")

local function findItemByID(container, itemID)
    if not container or not itemID or not container.getItems then
        return nil
    end

    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and item.getID and item:getID() == itemID then
            return item
        end
        if item and item.IsInventoryContainer and item:IsInventoryContainer() and item.getItemContainer then
            local found = findItemByID(item:getItemContainer(), itemID)
            if found then
                return found
            end
        end
    end
    return nil
end

local function text(key, fallback)
    if getText then
        local value = getText(key)
        if value and value ~= key then
            return value
        end
    end
    return fallback or key
end

local function getHandModel(item)
    if item and item.getStaticModel then
        local model = item:getStaticModel()
        if model and model ~= "" then
            return model
        end
    end
    return item
end

local function getPourType(item)
    if item and item.getPourType then
        local pourType = item:getPourType()
        if pourType and pourType ~= "" then
            return pourType
        end
    end
    return "Bucket"
end

function ISIDBFSTimedCommandAction:refreshHandItem()
    if not self.handItemID or not self.character or not self.character.getInventory then
        return self.handItem
    end

    local inventory = self.character:getInventory()
    local item = inventory and inventory.getItemById and inventory:getItemById(self.handItemID) or nil
    if not item then
        item = findItemByID(inventory, self.handItemID)
    end
    self.handItem = item
    return item
end

function ISIDBFSTimedCommandAction:isValid()
    if not self.character or not self.objectRef then
        return false
    end
    if self.handItemID and not self:refreshHandItem() then
        return false
    end

    local obj = IDBFS.resolveObjectRef(self.objectRef)
    if not obj or not IDBFS.isFunctionalObject(obj) then
        return false
    end
    self.object = obj
    return true
end

function ISIDBFSTimedCommandAction:waitToStart()
    if self.object and self.object.getSquare then
        self.character:faceLocation(self.object:getSquare():getX(), self.object:getSquare():getY())
    end
    return self.character:shouldBeTurning()
end

function ISIDBFSTimedCommandAction:update()
    if self.object and self.object.getSquare then
        self.character:faceLocation(self.object:getSquare():getX(), self.object:getSquare():getY())
    end
    if self.handItem and self.handItem.setJobDelta then
        self.handItem:setJobDelta(self:getJobDelta())
    end
    if self.command == "fillStorage" or self.command == "takeLiquid" or self.command == "emptyStorage" then
        self.character:setMetabolicTarget(Metabolics.LightDomestic)
    end
end

function ISIDBFSTimedCommandAction:start()
    self:refreshHandItem()
    local item = self.handItem

    if self.command == "fillStorage" and item then
        if item.setJobType then
            item:setJobType(text("ContextMenu_IDBFS_Fill", "Fill / Load Liquid"))
        end
        if item.setJobDelta then
            item:setJobDelta(0.0)
        end
        if CharacterActionAnims and CharacterActionAnims.Pour then
            self:setActionAnim(CharacterActionAnims.Pour)
        else
            self:setActionAnim("Pour")
        end
        self:setAnimVariable("PourType", getPourType(item))
        self:setOverrideHandModels(getHandModel(item), nil)
        self.sound = self.character:playSound("TransferLiquid")
        self.character:reportEvent("EventTakeWater")
        return
    end

    if self.command == "takeLiquid" and item then
        if item.setBeingFilled then
            item:setBeingFilled(true)
        end
        if item.setJobType then
            item:setJobType(text("ContextMenu_IDBFS_TakeLiquid", "Take Liquid"))
        end
        if item.setJobDelta then
            item:setJobDelta(0.0)
        end
        self:setActionAnim("fill_container_tap")
        self:setAnimVariable("PourType", getPourType(item))
        self:setOverrideHandModels(getHandModel(item), nil)
        self.sound = self.character:playSound("TransferLiquid")
        self.character:reportEvent("EventTakeWater")
        return
    end

    if self.command == "emptyStorage" then
        self:setActionAnim("fill_container_tap")
        self:setAnimVariable("PourType", "Bucket")
        self:setOverrideHandModels(nil, nil)
        self.sound = self.character:playSound("TransferLiquid")
        self.character:reportEvent("EventTakeWater")
        return
    end

    if self.command == "press" then
        self:setActionAnim("UseHandPress")
        self:setOverrideHandModels(nil, nil)
        if item and item.setJobType then
            local recipe = self.args and self.args.recipe and IDBFS.PressRecipes and IDBFS.PressRecipes[self.args.recipe] or nil
            local liquidType = recipe and recipe.liquidType or nil
            item:setJobType(liquidType and IDBFS.getLiquidLabel(liquidType) or text("ContextMenu_IDBFS_Process", "Process"))
        end
        if item and item.setJobDelta then
            item:setJobDelta(0.0)
        end
        if self.onStartFunc then
            self.onStartFunc(self.onStartTarget, self)
        end
        return
    end

    self:setActionAnim("Loot")

    if self.onStartFunc then
        self.onStartFunc(self.onStartTarget, self)
    end
end

function ISIDBFSTimedCommandAction:stopSound()
    if self.sound and self.character and self.character.getEmitter and self.character:getEmitter():isPlaying(self.sound) then
        self.character:stopOrTriggerSound(self.sound)
    end
end

function ISIDBFSTimedCommandAction:clearHandItemState()
    if not self.handItem then
        return
    end
    if self.handItem.setBeingFilled then
        self.handItem:setBeingFilled(false)
    end
    if self.handItem.setJobDelta then
        self.handItem:setJobDelta(0.0)
    end
end

function ISIDBFSTimedCommandAction:stop()
    self:stopSound()
    self:clearHandItemState()
    ISBaseTimedAction.stop(self)
    if self.onCancelFunc then
        self.onCancelFunc(self.onCancelTarget)
    end
    if self.onCompleteFunc then
        self.onCompleteFunc(self.onCompleteTarget)
    end
end

function ISIDBFSTimedCommandAction:perform()
    self.args = self.args or {}
    self.args.obj = self.objectRef
    self.args.objectType = self.objectType

    if sendClientCommand then
        sendClientCommand(self.character, IDBFS.MOD_ID, self.command, self.args)
    elseif IDBFS and IDBFS.Server and IDBFS.Server.onClientCommand then
        IDBFS.Server.onClientCommand(IDBFS.MOD_ID, self.command, self.character, self.args)
    end

    self:stopSound()
    self:clearHandItemState()
    ISBaseTimedAction.perform(self)
    if self.onCompleteFunc then
        self.onCompleteFunc(self.onCompleteTarget)
    end
end

function ISIDBFSTimedCommandAction:setOnStart(_func, _target)
    self.onStartFunc = _func
    self.onStartTarget = _target
end

function ISIDBFSTimedCommandAction:setOnComplete(_func, _target)
    self.onCompleteFunc = _func
    self.onCompleteTarget = _target
end

function ISIDBFSTimedCommandAction:setOnCancel(_func, _target)
    self.onCancelFunc = _func
    self.onCancelTarget = _target
end

function ISIDBFSTimedCommandAction:new(character, object, command, args, time, handItem)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.object = object
    o.objectRef = IDBFS.getObjectRef(object)
    o.objectType = IDBFS.getObjectType(object)
    o.command = command
    o.args = args or {}
    o.handItem = handItem
    o.handItemID = handItem and handItem.getID and handItem:getID() or nil
    o.maxTime = time or 120
    if character and character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o
end
