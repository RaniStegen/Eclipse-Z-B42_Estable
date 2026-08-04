------------------------------------------
-- Fancy Handwork Hotbar - B42.19 Compatible
---
------------------------------------------
-- SwapIt support was merged! :D Use that if installed
if getActivatedMods():contains('SwapIt') then return end

local _ISHotbar_equipItem = ISHotbar.equipItem

function ISHotbar:equipItem(item)
    -- B42.19 FIX: Safe character check
    if not self.chr or not item then return end

    -- Get Modifier
    local mod = isFHModBindDown(self.chr)
    local primary = self.chr:getPrimaryHandItem()
    -- B42 API: Use getSecondaryHandItem() for secondary hand
    local secondary = self.chr:getSecondaryHandItem()
    local equip = true

    ISInventoryPaneContextMenu.transferIfNeeded(self.chr, item)

    -- If we already have the item equipped
    if (primary and primary == item) or (secondary and secondary == item) then
        -- B42.19 FIX: Check if ISUnequipAction exists
        if ISUnequipAction then
            ISTimedActionQueue.add(ISUnequipAction:new(self.chr, item, 20))
        end
        equip = false
    end

    -- If we didn't just do something
    if equip then
        -- Handle holding big objects
        if primary and isForceDropHeavyItem(primary) then
            if ISUnequipAction then
                ISTimedActionQueue.add(ISUnequipAction:new(self.chr, primary, 50))
            end
            ----- treat "equip" as if we have something equipped from here down
            equip = false
        end
        if mod then
            -- If we still have something equipped in secondary, unequip
            if secondary and equip then
                if ISUnequipAction then
                    ISTimedActionQueue.add(ISUnequipAction:new(self.chr, secondary, 20))
                end
            end
            -- B42.19 FIX: Safe ISEquipWeaponAction call
            if ISEquipWeaponAction then
                ISTimedActionQueue.add(ISEquipWeaponAction:new(self.chr, item, 20, false, item:isTwoHandWeapon()))
            end
        else
            -- If we still have something equipped in primary, unequip
            if primary and equip then
                if ISUnequipAction then
                    ISTimedActionQueue.add(ISUnequipAction:new(self.chr, primary, 20))
                end
            end
            -- Equip Primary - B42.19 FIX
            if ISEquipWeaponAction then
                ISTimedActionQueue.add(ISEquipWeaponAction:new(self.chr, item, 20, true, item:isTwoHandWeapon()))
            end
        end
    end

    self.chr:getInventory():setDrawDirty(true)
    -- B42.19 FIX: Safe playerData access
    local playerData = getPlayerData(self.chr:getPlayerNum())
    if playerData and playerData.playerInventory then
        playerData.playerInventory:refreshBackpacks()
    end
end