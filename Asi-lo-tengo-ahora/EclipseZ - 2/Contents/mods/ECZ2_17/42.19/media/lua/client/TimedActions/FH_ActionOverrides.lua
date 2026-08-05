--- Various overrides for functions that need animations.
-- B42.19 Compatibility Version

print("FH B42.19: Loading Action Overrides...")

------------------
-- Unused by the base, but we will call the base anyways
-- B42.19 FIX: Safe ISLightActions override
if ISLightActions and ISLightActions.start then
    local _ISLightActions_start = ISLightActions.start
    function ISLightActions:start()
        _ISLightActions_start(self)
        self:setActionAnim(CharacterActionAnims.Craft)
    end
end

------------------
-- Add the Craft animation to the upgrade
-- B42.19 FIX: Safe ISUpgradeWeapon override
if ISUpgradeWeapon and ISUpgradeWeapon.start then
    local _ISUpgradeWeapon_start = ISUpgradeWeapon.start
    function ISUpgradeWeapon:start()
        -- remove the item from being attached
        local hotbar = getPlayerHotbar(self.character:getPlayerNum())
        if hotbar and hotbar.isInHotbar and hotbar:isInHotbar(self.weapon) then
            hotbar.chr:removeAttachedItem(self.weapon)
        end
        self:setActionAnim(CharacterActionAnims.Craft)
        self:setOverrideHandModels(self.part, self.weapon)
        _ISUpgradeWeapon_start(self)
    end
end

------------------
-- Add the Craft animation to the remove upgrade
-- B42.19 FIX: Safe ISRemoveWeaponUpgrade override
if ISRemoveWeaponUpgrade and ISRemoveWeaponUpgrade.start then
    local _ISRemoveWeaponUpgrade_start = ISRemoveWeaponUpgrade.start
    function ISRemoveWeaponUpgrade:start()
        -- remove the item from being attached
        local hotbar = getPlayerHotbar(self.character:getPlayerNum())
        if hotbar and hotbar.isInHotbar and hotbar:isInHotbar(self.weapon) then
            hotbar.chr:removeAttachedItem(self.weapon)
        end
        self:setActionAnim(CharacterActionAnims.Craft)
        self:setOverrideHandModels(nil, self.weapon)
        _ISRemoveWeaponUpgrade_start(self)
    end
end

------------------
-- Just add the Craft animation here too.
-- B42.19 FIX: Safe ISFixAction override
if ISFixAction and ISFixAction.start then
    local _ISFixAction_start = ISFixAction.start
    function ISFixAction:start()
        -- remove the item from being attached
        local hotbar = getPlayerHotbar(self.character:getPlayerNum())
        if hotbar and hotbar.isInHotbar and hotbar:isInHotbar(self.item) then
            hotbar.chr:removeAttachedItem(self.item)
        end
        self:setActionAnim(CharacterActionAnims.Craft)
        if self.fixing and self.fixing.haveThisFixer then
            self:setOverrideHandModels(self.fixing:haveThisFixer(self.character, self.fixer, self.item), self.item)
        end
        _ISFixAction_start(self)
    end
end

------------------
-- Index all of the available animations
-- B42.19 FIX: Safe access to WearClothingAnimations
-- DISABLED: This was causing infinite clothing animation bug
--[[
local WearAnims = {}
Events.OnGameStart.Add(function()
    if WearClothingAnimations and type(WearClothingAnimations) == "table" then
        for _,v in pairs(WearClothingAnimations) do
            WearAnims[#WearAnims+1] = v
        end
    else
        -- B42.19 fallback animations
        WearAnims = {"Hat", "Torso", "Legs", "Hands", "Feet", "Back"}
        print("FH B42.19: Using fallback WearClothingAnimations")
    end
end)

-- Adds a random animation while drying yourself
---- If this goes longer than 1 tick, then change animation
local _ISDryMyself_update = ISDryMyself.update
function ISDryMyself:update()
    -- I'll just do mine first
    if self.tick >= self.timer then
        self:setAnimVariable("WearClothingLocation", WearAnims[ZombRand(#WearAnims)+1] or "")
    end
    _ISDryMyself_update(self)
end

-- Set the Animation with a radom initial location
local _ISDryMyself_start = ISDryMyself.start
function ISDryMyself:start()
    self:setActionAnim("WearClothing")
    self:setAnimVariable("WearClothingLocation", WearAnims[ZombRand(#WearAnims)+1] or "")
    self:setOverrideHandModels(nil, nil)
    _ISDryMyself_start(self)
end
--]]
print("FH B42.19: ISDryMyself WearClothing animation override DISABLED (caused infinite animation bug)")

------------------
-- Set the loot animation for the Transfer
-- B42 FIX: Check if ISFinalizeDealAction exists
if ISFinalizeDealAction and ISFinalizeDealAction.start then
    local _ISFinalizeDealAction_start = ISFinalizeDealAction.start
    function ISFinalizeDealAction:start()
        self:setActionAnim("Loot")
        self:setAnimVariable("LootPosition", "Mid")
        self.FHIgnore = true
        _ISFinalizeDealAction_start(self)
    end
end

------------------
-- Add the Recipe animation there too
local _ISAddItemInRecipe_start = ISAddItemInRecipe.start
function ISAddItemInRecipe:start()
    local base = nil
    local baseType = self.baseItem:getType()
    if string.find(baseType, "GridlePan") or string.find(baseType, "GriddlePan") then
        base = "GridlePan"
    elseif string.find(baseType, "Saucepan") then
        base = "SaucePan"
    elseif string.find(baseType, "Pot") then
        base = "CookingPot"
    elseif string.find(baseType, "RoastingPan") then
        base = "RoastingPan"
    else
        base = self.baseItem:getStaticModel() or "FryingPan"
    end

    self:setAnimVariable("BaseType", base)
	self:setActionAnim("AddToPan")
    self:setOverrideHandModelsString(self.usedItem:getStaticModel(), base)
    _ISAddItemInRecipe_start(self)
end

-- TODO:
--- I would like to apply the same tweak to the crafting action.
---- let the props take precedence, but also make it so more object show up in hand
---- plus i just made those animations, and putting noodles into a pot is a crafting recipe, so don't work 
---- I've been working on these animations, and trying various ways to get things working with hand models
----- i'm just kinda done with that for now. lmao

local _ISEmptyRainBarrelAction_start = ISEmptyRainBarrelAction.start
function ISEmptyRainBarrelAction:start()
    self:setActionAnim(CharacterActionAnims.Pour)
	self:setAnimVariable("FoodType", "Pot")
    self:setOverrideHandModels(nil, nil)
    _ISEmptyRainBarrelAction_start(self)
end

local _ISStopAlarmClockAction_start = ISStopAlarmClockAction.start
function ISStopAlarmClockAction:start()
    self:setActionAnim("EquipItem")
    if not self.character:isEquipped(self.alarm) then
        self:setOverrideHandModels(nil, self.alarm)
    end
    self.FHIgnore = true
    _ISStopAlarmClockAction_start(self)
end

-- B42.19 FIX: Safe ISConsolidateDrainable override
if ISConsolidateDrainable and ISConsolidateDrainable.start then
    local _ISConsolidateDrainable_start = ISConsolidateDrainable.start
    function ISConsolidateDrainable:start()
        self:setActionAnim("EquipItem")
        self:setOverrideHandModels(self.drainable, self.intoItem)
        _ISConsolidateDrainable_start(self)
    end
end

-- B42.19 FIX: Safe ISConsolidateDrainableAll override
if ISConsolidateDrainableAll and ISConsolidateDrainableAll.start then
    local _ISConsolidateDrainableAll_start = ISConsolidateDrainableAll.start
    function ISConsolidateDrainableAll:start()
        self:setActionAnim("EquipItem")
        local item
        for _,i in pairs(self.consolidateList) do
            item = i
            break
        end
        self:setOverrideHandModels(item, self.drainable)
        _ISConsolidateDrainableAll_start(self)
    end
end

--- Lets make some better pour animations sometime

-- B42.19 FIX: Safe ISBBQLightFromKindle override
if ISBBQLightFromKindle and ISBBQLightFromKindle.start then
    local _ISBBQLightFromKindle_start = ISBBQLightFromKindle.start
    function ISBBQLightFromKindle:start()
        self:setActionAnim("Loot")
        self.character:SetVariable("LootPosition", "Mid")
        self.FHIgnore = true
        _ISBBQLightFromKindle_start(self)
    end
end

-- B42.19 FIX: Safe ISFireplaceLightFromKindle override
if ISFireplaceLightFromKindle and ISFireplaceLightFromKindle.start then
    local _ISFireplaceLightFromKindle_start = ISFireplaceLightFromKindle.start
    function ISFireplaceLightFromKindle:start()
        self:setActionAnim("Loot")
        self.character:SetVariable("LootPosition", "Low")
        self.FHIgnore = true
        _ISFireplaceLightFromKindle_start(self)
    end
end

-- I have included the following fixes in 3 mods now. lmao
--- I will make this the definitive fix for this, and other mods will defer to this
-- B42.19 FIX: Safe ISClothingExtraAction override
if ISClothingExtraAction and ISClothingExtraAction.new then
    local _ISClothingExtraAction_new = ISClothingExtraAction.new
    function ISClothingExtraAction:new(...)
        local o = _ISClothingExtraAction_new(self, ...)
        o.stopOnAim = false
        o.stopOnWalk = false
        o.stopOnRun = true
        o.maxTime = 25
        o.useProgressBar = true
        if o.character and o.character.isTimedActionInstant and o.character:isTimedActionInstant() then
            o.maxTime = 1
        end
        return o
    end
end

-- ISWearClothing override REMOVED - causes multiplayer clothing bug
-- Vanilla ISWearClothing works perfectly, any override breaks it
-- DO NOT ADD ANY OVERRIDE FOR ISWearClothing - it will break multiplayer!
print("FH B42.19: ISWearClothing left to vanilla (no override)")

--- DON'T LOOK AT ME! :O 
---- I'm trying to add some new animations for Transfer Actions, but wasn't able to get this completed before the next update.
-- -- Fix for the Transfer action.
-- --- Player will now only pick items off the ground when they are on the ground :)
-- local _ISInventoryTransferAction_doActionAnim = ISInventoryTransferAction.doActionAnim
-- function ISInventoryTransferAction:doActionAnim(cont)
--     _ISInventoryTransferAction_doActionAnim(self, cont)
--     if self.srcContainer:getType() == "floor" then
--         local worldItem = self.item:getWorldItem()
--         if worldItem then
--             --worldItem:removeFromSquare()
--             local anim = (self.item:getActualWeight() <= 1.0 and "FancyLoot") or nil
--             local posAnim = (anim and "FH_Hand") or "LootPosition"
--             local z = worldItem:getWorldPosZ() - self.character:getZ()
--             local position
--             if z > 0.1 then
--                 position = (anim and ((ZombRand(3) == 1 and "left") or "right")) or "Mid"
--             elseif z > 0.5 then
--                 position = "High"
--             end
--             if position == "left" then
--                 self.action:setOverrideHandModels(nil, self.item)
--             else
--                 self.action:setOverrideHandModels(self.item, nil)
--             end
--             if anim then
--                 self:setActionAnim(anim)
--             end
--             self:setAnimVariable(posAnim, position)
--         end
--     end
-- end

print("FH B42.19: Action Overrides loaded successfully")