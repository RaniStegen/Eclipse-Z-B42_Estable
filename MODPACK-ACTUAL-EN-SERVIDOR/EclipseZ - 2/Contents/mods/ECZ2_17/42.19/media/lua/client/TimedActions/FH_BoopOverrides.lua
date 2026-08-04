-- These just add the "boop!"
----
-- Why do these on "perform?"
----
--- The perform function is the only function to be guaranteed to run on success
--- it is not run when the action is canceled, so we don't do our bit

-- B42 FIX: FHBoopAction:new() returns nil when it gets no data, and
-- FancyHands.checkDoor() legitimately returns nil (destroyed door, curtain we
-- don't handle, ...). Feeding that nil to ISTimedActionQueue.add() throws inside
-- perform(), which tears down the whole action queue.
local function addBoop(character, data)
    if not character or not data or not data.item then return end
    ISTimedActionQueue.add(FHBoopAction:new(character, data))
end

local _ISToggleStoveActione_perform = ISToggleStoveAction.perform
function ISToggleStoveAction:perform()
    addBoop(self.character, { item = self.object, extra = 0 })
    _ISToggleStoveActione_perform(self)
end

local _ISToggleLightAction_perform = ISToggleLightAction.perform
function ISToggleLightAction:perform()
    addBoop(self.character, { item = self.object, extra = 0 })
    _ISToggleLightAction_perform(self)
end

local _ISToggleLightSourceAction_perform = ISToggleLightSourceAction.perform
function ISToggleLightSourceAction:perform()
    addBoop(self.character, { item = self.lightSource, extra = 0 })
    _ISToggleLightSourceAction_perform(self)
end

local _ISToggleComboWasherDryer_perform = ISToggleComboWasherDryer.perform
function ISToggleComboWasherDryer:perform()
    addBoop(self.character, { item = self.object, extra = 0 })
    _ISToggleComboWasherDryer_perform(self)
end

local _ISToggleClothingWasher_perform = ISToggleClothingWasher.perform
function ISToggleClothingWasher:perform()
    addBoop(self.character, { item = self.object, extra = 0 })
    _ISToggleClothingWasher_perform(self)
end

local _ISToggleClothingDryer_perform = ISToggleClothingDryer.perform
function ISToggleClothingDryer:perform()
    addBoop(self.character, { item = self.object, extra = 0 })
    _ISToggleClothingDryer_perform(self)
end

local _ISSetComboWasherDryerMode_perform = ISSetComboWasherDryerMode.perform
function ISSetComboWasherDryerMode:perform()
    addBoop(self.character, { item = self.object, extra = 0 })
    _ISSetComboWasherDryerMode_perform(self)
end

local _ISOvenUITimedAction_perform = ISOvenUITimedAction.perform
function ISOvenUITimedAction:perform()
    addBoop(self.character, { item = self.mcwave or self.stove, extra = 0 })
    _ISOvenUITimedAction_perform(self)
end

local _ISOpenCloseDoor_perform = ISOpenCloseDoor.perform
function ISOpenCloseDoor:perform()
    addBoop(self.character, FancyHands.checkDoor(self.item, self.character, true))
    _ISOpenCloseDoor_perform(self)
end

local _ISLockDoor_perform = ISLockDoor.perform
function ISLockDoor:perform()
    addBoop(self.character, FancyHands.checkDoor(self.door, self.character, true))
    _ISLockDoor_perform(self)
end

local _ISOpenCloseCurtain_perform = ISOpenCloseCurtain.perform
function ISOpenCloseCurtain:perform()
    addBoop(self.character, FancyHands.checkDoor(self.item, self.character, true))
    _ISOpenCloseCurtain_perform(self)
end

local _ISPadlockAction_perform = ISPadlockAction.perform
function ISPadlockAction:perform()
    addBoop(self.character, { item = self.thump, extra = 1 })
    _ISPadlockAction_perform(self)
end

local _ISBBQInfoAction_perform = ISBBQInfoAction.perform
function ISBBQInfoAction:perform()
    addBoop(self.character, { item = self.bbq, extra = 1 })
    _ISBBQInfoAction_perform(self)
end

-- B42 FIX: Check if ISCampingInfoAction exists
if ISCampingInfoAction and ISCampingInfoAction.perform then
    local _ISCampingInfoAction_perform = ISCampingInfoAction.perform
    function ISCampingInfoAction:perform()
        addBoop(self.character, { item = self.campfire, extra = 1 })
        _ISCampingInfoAction_perform(self)
    end
end

-- B42 FIX: Check if ISFireplaceInfoAction exists
if ISFireplaceInfoAction and ISFireplaceInfoAction.perform then
    local _ISFireplaceInfoAction_perform = ISFireplaceInfoAction.perform
    function ISFireplaceInfoAction:perform()
        addBoop(self.character, { item = self.fireplace, extra = -1 })
        _ISFireplaceInfoAction_perform(self)
    end
end

-- B42 FIX: Check if ISGeneratorInfoAction exists
if ISGeneratorInfoAction and ISGeneratorInfoAction.perform then
    local _ISGeneratorInfoAction_perform = ISGeneratorInfoAction.perform
    function ISGeneratorInfoAction:perform()
        addBoop(self.character, { item = self.object, extra = -1 })
        _ISGeneratorInfoAction_perform(self)
    end
end

local _ISInventoryPage_toggleStove = ISInventoryPage.toggleStove
function ISInventoryPage:toggleStove()
    _ISInventoryPage_toggleStove(self)
    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
		return
	end
    local stoveInventory = self.inventoryPane and self.inventoryPane.inventory
    if not stoveInventory then return end
    addBoop(getSpecificPlayer(self.player), { item = stoveInventory:getParent(), extra = 0 })
end

local _ISRadioAction_perform = ISRadioAction.perform
function ISRadioAction:perform()
    -- Fix for the infinite error when the device is in your inventory
    if not (instanceof(self.device, "InventoryItem") and self.device:isInPlayerInventory()) and not self.character:isSeatedInVehicle() then
        addBoop(self.character, { item = self.device, extra = 0 })
    end
    _ISRadioAction_perform(self)
end