require "TimedActions/ISBaseTimedAction"

FR_TakePropaneAction = ISBaseTimedAction:derive("FR_TakePropaneAction")

function FR_TakePropaneAction:isValid()
    return self.character
        and self.part
        and self.item
        and self.character:getInventory():contains(self.item)
        and (self.part:getContainerContentAmount() or 0) > 0
end

function FR_TakePropaneAction:start()
    self:setActionAnim("Loot")
end

function FR_TakePropaneAction:update()

    if not self.item or not self.part then return end

    local amountInTruck = self.part:getContainerContentAmount() or 0
    if amountInTruck <= 0 then return end

    local truckMax = 500
    local tankFullCost = 80

    local useDelta = self.item:getUseDelta() or 0.0002
    local maxUses = self.item:getMaxUses()

    local currentUses = self.item:getCurrentUses() or 0

    if currentUses >= maxUses then
        return
    end

    local transferPerTick = 1

    local transfer = math.min(transferPerTick, amountInTruck)

    local usesGain = math.floor((transfer / tankFullCost) * maxUses)

    if usesGain <= 0 then usesGain = 1 end

    local newUses = currentUses + usesGain
    if newUses > maxUses then
        usesGain = maxUses - currentUses
        newUses = maxUses
    end

    self.item:setCurrentUses(newUses)

    local newTruckAmount = amountInTruck - (usesGain / maxUses * tankFullCost)
    if newTruckAmount < 0 then newTruckAmount = 0 end

    self.part:setContainerContentAmount(newTruckAmount)

    self.item:updateWeight()
    self.item:syncItemFields()

end

function FR_TakePropaneAction:stop()
    ISBaseTimedAction.stop(self)
end

function FR_TakePropaneAction:perform()
    ISBaseTimedAction.perform(self)
end

function FR_TakePropaneAction:new(player, part, item, time)
    local o = ISBaseTimedAction.new(self, player)

    o.character = player
    o.part = part
    o.item = item
    o.maxTime = time or 200

    return o
end
