IDBFS = IDBFS or {}
IDBFS.MoveableTiles = IDBFS.MoveableTiles or {}

IDBFS.MoveableTiles.CustomItemsBySprite = {
    crafted_05_0 = "IDBFS.MoveableManualPress",
    crafted_05_1 = "IDBFS.MoveableManualPress",
    crafted_05_2 = "IDBFS.MoveableManualPress",
    crafted_05_3 = "IDBFS.MoveableManualPress",
    location_business_distillery_01_8 = "IDBFS.MoveableFermentationBarrel",
    location_business_distillery_01_9 = "IDBFS.MoveableFermentationBarrel",
    location_business_distillery_01_10 = "IDBFS.MoveableFermentationBarrel",
    location_business_distillery_01_1 = "IDBFS.MoveableLiquidBarrelRack",
    location_business_distillery_01_3 = "IDBFS.MoveableLiquidBarrelRack",
    location_business_distillery_01_4 = "IDBFS.MoveableLiquidBarrelRack",
    location_business_distillery_01_11 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_12 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_13 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_24 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_25 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_26 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_29 = "IDBFS.MoveableDistillationStill",
    location_business_distillery_01_30 = "IDBFS.MoveableDistillationStill",
    industry_02_34 = "IDBFS.MoveableDistillationStill",
    industry_02_72 = "IDBFS.MoveableIndustrialTank",
    industry_02_73 = "IDBFS.MoveableIndustrialTank",
    industry_02_74 = "IDBFS.MoveableIndustrialTank",
    industry_02_75 = "IDBFS.MoveableIndustrialTank",
}

IDBFS.MoveableTiles.AnchorSpriteByItem = {
    ["IDBFS.MoveableManualPress"] = "crafted_05_0",
    ["IDBFS.MoveableFermentationBarrel"] = "location_business_distillery_01_8",
    ["IDBFS.MoveableLiquidBarrelRack"] = "location_business_distillery_01_1",
    ["IDBFS.MoveableDistillationStill"] = "location_business_distillery_01_29",
    ["IDBFS.MoveableIndustrialTank"] = "industry_02_73",
}

IDBFS.MoveableTiles.CanonicalItemByFullType = {
    ["IDBFS.industry_02_72"] = "IDBFS.MoveableIndustrialTank",
    ["IDBFS.industry_02_73"] = "IDBFS.MoveableIndustrialTank",
    ["IDBFS.industry_02_74"] = "IDBFS.MoveableIndustrialTank",
    ["IDBFS.industry_02_75"] = "IDBFS.MoveableIndustrialTank",
}

IDBFS.MoveableTiles.CustomItemWeights = {
    ["IDBFS.MoveableManualPress"] = 15.0,
    ["IDBFS.MoveableFermentationBarrel"] = 15.0,
    ["IDBFS.MoveableLiquidBarrelRack"] = 25.0,
    ["IDBFS.MoveableDistillationStill"] = 25.0,
    ["IDBFS.MoveableIndustrialTank"] = 25.0,
}

IDBFS.MoveableTiles.FaceSpritesByItem = {
    ["IDBFS.MoveableFermentationBarrel"] = {
        S = "location_business_distillery_01_8",
        N = "location_business_distillery_01_9",
        E = "location_business_distillery_01_10",
    },
}

IDBFS.MoveableTiles.ForceSingleItemSprites = {
    crafted_05_0 = true,
    crafted_05_1 = true,
    crafted_05_2 = true,
    crafted_05_3 = true,
    location_business_distillery_01_1 = true,
    location_business_distillery_01_3 = true,
    location_business_distillery_01_4 = true,
    location_business_distillery_01_11 = true,
    location_business_distillery_01_12 = true,
    location_business_distillery_01_13 = true,
    location_business_distillery_01_24 = true,
    location_business_distillery_01_25 = true,
    location_business_distillery_01_26 = true,
    location_business_distillery_01_29 = true,
    location_business_distillery_01_30 = true,
    industry_02_34 = true,
    industry_02_72 = true,
    industry_02_73 = true,
    industry_02_74 = true,
    industry_02_75 = true,
}

IDBFS.MoveableTiles.CompositePlacement = {
    ["IDBFS.MoveableDistillationStill"] = {
        objectType = "still",
        anchor = "location_business_distillery_01_29",
        parts = {
            { sprite = "location_business_distillery_01_30", x = 0, y = -1, z = 0 },
            { sprite = "location_business_distillery_01_29", x = 0, y = 0, z = 0 },
            { sprite = "location_business_distillery_01_26", x = 0, y = 1, z = 0 },
            { sprite = "location_business_distillery_01_24", x = -1, y = 2, z = 0 },
            { sprite = "location_business_distillery_01_25", x = 0, y = 2, z = 0 },
            { sprite = "location_business_distillery_01_13", x = 0, y = 0, z = 1 },
            { sprite = "location_business_distillery_01_12", x = 0, y = 1, z = 1 },
            { sprite = "location_business_distillery_01_11", x = 0, y = 2, z = 1 },
        },
    },
    ["IDBFS.MoveableIndustrialTank"] = {
        objectType = "tank",
        anchor = "industry_02_73",
        simplePlacementFallback = true,
        parts = {
            { sprite = "industry_02_74", x = -1, y = -1 },
            { sprite = "industry_02_75", x = 0, y = -1 },
            { sprite = "industry_02_72", x = -1, y = 0 },
            { sprite = "industry_02_73", x = 0, y = 0 },
        },
    },
}

IDBFS.MoveableTiles.Props = {
    crafted_05_0 = {
        CustomName = "Distillery Press",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableManualPress",
        PickUpWeight = "150",
        ForceSingleItem = "",
    },
    crafted_05_1 = {
        CustomName = "Distillery Press",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableManualPress",
        PickUpWeight = "150",
        ForceSingleItem = "",
    },
    crafted_05_2 = {
        CustomName = "Distillery Press",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableManualPress",
        PickUpWeight = "150",
        ForceSingleItem = "",
    },
    crafted_05_3 = {
        CustomName = "Distillery Press",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableManualPress",
        PickUpWeight = "150",
        ForceSingleItem = "",
    },
    location_business_distillery_01_8 = {
        CustomName = "Fermentation Barrel",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableFermentationBarrel",
        PickUpWeight = "150",
        Material = "Wood",
        Material2 = "Nails",
        Facing = "S",
        Noffset = "1",
        Woffset = "2",
        Eoffset = "2",
    },
    location_business_distillery_01_9 = {
        CustomName = "Fermentation Barrel",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableFermentationBarrel",
        PickUpWeight = "150",
        Material = "Wood",
        Material2 = "Nails",
        Facing = "N",
        Soffset = "-1",
        Woffset = "1",
        Eoffset = "1",
    },
    location_business_distillery_01_10 = {
        CustomName = "Fermentation Barrel",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableFermentationBarrel",
        PickUpWeight = "150",
        Material = "Wood",
        Material2 = "Nails",
        Facing = "E",
        Noffset = "-1",
        Soffset = "-1",
        Woffset = "-2",
    },
    location_business_distillery_01_1 = {
        CustomName = "Double Barrel Container",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableLiquidBarrelRack",
        PickUpWeight = "250",
        Material = "Wood",
        Material2 = "Nails",
        ForceSingleItem = "",
    },
    location_business_distillery_01_3 = {
        CustomName = "Double Barrel Container",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableLiquidBarrelRack",
        PickUpWeight = "250",
        Material = "Wood",
        Material2 = "Nails",
        ForceSingleItem = "",
    },
    location_business_distillery_01_4 = {
        CustomName = "Double Barrel Container",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableLiquidBarrelRack",
        PickUpWeight = "250",
        Material = "Wood",
        Material2 = "Nails",
        ForceSingleItem = "",
    },
    location_business_distillery_01_24 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    location_business_distillery_01_25 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    location_business_distillery_01_26 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    industry_02_34 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "80",
        Material = "MetalPipe",
        Material2 = "MetalScrap",
        ForceSingleItem = "",
    },
    location_business_distillery_01_11 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    location_business_distillery_01_12 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    location_business_distillery_01_13 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    location_business_distillery_01_29 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    location_business_distillery_01_30 = {
        CustomName = "Distillation Still",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableDistillationStill",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    industry_02_72 = {
        CustomName = "Industrial Tank",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableIndustrialTank",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    industry_02_73 = {
        CustomName = "Industrial Tank",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableIndustrialTank",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    industry_02_74 = {
        CustomName = "Industrial Tank",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableIndustrialTank",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
    industry_02_75 = {
        CustomName = "Industrial Tank",
        GroupName = "Distillery",
        IsMoveAble = "",
        CustomItem = "IDBFS.MoveableIndustrialTank",
        PickUpWeight = "250",
        Material = "MetalPlates",
        Material2 = "MetalPipe",
        ForceSingleItem = "",
    },
}

function IDBFS.MoveableTiles.apply()
    if not IsoSpriteManager or not IsoSpriteManager.instance then
        return
    end
    for tileName, values in pairs(IDBFS.MoveableTiles.Props) do
        local tile = IsoSpriteManager.instance:getSprite(tileName)
        local props = tile and tile:getProperties() or nil
        if props then
            for key, value in pairs(values) do
                props:set(key, value)
            end
        end
    end
end

function IDBFS.MoveableTiles.installMoveablePatch()
    if ISMoveableSpriteProps and ISMoveableSpriteProps.IDBFSPatched then
        return
    end
    if not ISMoveableSpriteProps then
        pcall(require, "Moveables/ISMoveableSpriteProps")
    end
    if not ISMoveableSpriteProps or ISMoveableSpriteProps.IDBFSPatched then
        return
    end

    local originalNew = ISMoveableSpriteProps.new
    local originalInstanceItem = ISMoveableSpriteProps.instanceItem
    local originalCanPlaceMoveable = ISMoveableSpriteProps.canPlaceMoveable
    local originalPlaceMoveable = ISMoveableSpriteProps.placeMoveable
    local originalPickUpMoveable = ISMoveableSpriteProps.pickUpMoveable
    local originalHasFaces = ISMoveableSpriteProps.hasFaces
    local originalGetIndexedFaces = ISMoveableSpriteProps.getIndexedFaces
    local originalGetFaceIndex = ISMoveableSpriteProps.getFaceIndex
    local originalGetFaceDirectionFromSpriteName = ISMoveableSpriteProps.getFaceDirectionFromSpriteName

    local function ensureItemComponents(item)
        if not item or not item.hasComponents or item:hasComponents() then
            return
        end
        if not GameEntityFactory or not GameEntityFactory.CreateInventoryItemEntity or not item.getScriptItem then
            return
        end
        local scriptItem = item:getScriptItem()
        if scriptItem and scriptItem.hasComponents and scriptItem:hasComponents() then
            pcall(GameEntityFactory.CreateInventoryItemEntity, item, scriptItem, false)
        end
    end

    local function getCanonicalItemType(itemType)
        return itemType and (IDBFS.MoveableTiles.CanonicalItemByFullType[itemType] or itemType) or nil
    end

    local function applyCustomItemWeight(item, customItem)
        local itemType = getCanonicalItemType(customItem or (item and item.getFullType and item:getFullType() or nil))
        local actualWeight = itemType and IDBFS.MoveableTiles.CustomItemWeights[itemType] or nil
        if item and item.setActualWeight and actualWeight then
            item:setActualWeight(actualWeight)
            if item.setWeight then
                item:setWeight(actualWeight)
            end
            if item.setCustomWeight then
                item:setCustomWeight(true)
            end
        end
        if itemType == "IDBFS.MoveableIndustrialTank" and item and item.setWorldSprite then
            pcall(item.setWorldSprite, item, IDBFS.MoveableTiles.AnchorSpriteByItem[itemType])
        end
    end

    ISMoveableSpriteProps.new = function(_sprite)
        local props = originalNew(_sprite)
        local spriteName = props and props.spriteName or nil
        local customItem = spriteName and IDBFS.MoveableTiles.CustomItemsBySprite[spriteName] or nil
        if customItem then
            props.isMoveable = true
            props.customItem = customItem
            props.isForceSingleItem = IDBFS.MoveableTiles.ForceSingleItemSprites[spriteName] == true or props.isForceSingleItem
            props.IDBFSFaceSprites = IDBFS.MoveableTiles.FaceSpritesByItem[customItem]
            local customWeight = IDBFS.MoveableTiles.CustomItemWeights[customItem]
            if customWeight then
                props.weight = customWeight
                props.rawWeight = customWeight * 10
                if ISMoveableSpriteProps.itemInstances and ISMoveableSpriteProps.itemInstances[customItem] then
                    applyCustomItemWeight(ISMoveableSpriteProps.itemInstances[customItem], customItem)
                end
            end
            if IDBFS.MoveableTiles.Props[spriteName] then
                props.name = IDBFS.MoveableTiles.Props[spriteName].CustomName or props.name
                props.groupName = IDBFS.MoveableTiles.Props[spriteName].GroupName or props.groupName
            end
        end
        return props
    end

    function ISMoveableSpriteProps:instanceItem(_spriteNameOverride)
        local spriteName = _spriteNameOverride or self.spriteName
        local customItem = spriteName and IDBFS.MoveableTiles.CustomItemsBySprite[spriteName] or nil
        if customItem then
            local item = instanceItem(customItem)
            if item then
                if instanceof and instanceof(item, "Moveable") and item.ReadFromWorldSprite then
                    local readSprite = spriteName
                    if not item:ReadFromWorldSprite(readSprite) then
                        readSprite = IDBFS.MoveableTiles.AnchorSpriteByItem[customItem] or spriteName
                        item:ReadFromWorldSprite(readSprite)
                    end
                    applyCustomItemWeight(item, customItem)
                end
                ensureItemComponents(item)
                return item
            end
        end
        return originalInstanceItem(self, _spriteNameOverride)
    end

    function ISMoveableSpriteProps:hasFaces()
        if self.IDBFSFaceSprites then
            local count = 0
            for _, _ in pairs(self.IDBFSFaceSprites) do
                count = count + 1
                if count > 1 then
                    return true
                end
            end
            return false
        end
        return originalHasFaces(self)
    end

    function ISMoveableSpriteProps:getIndexedFaces()
        if self.IDBFSFaceSprites then
            local faces = self.IDBFSFaceSprites
            return {
                faces.N or faces.S or self.spriteName,
                faces.W or faces.E or self.spriteName,
                faces.S or faces.N or self.spriteName,
                faces.E or faces.W or self.spriteName,
            }
        end
        return originalGetIndexedFaces(self)
    end

    function ISMoveableSpriteProps:getFaceIndex()
        if self.IDBFSFaceSprites then
            for i, spriteName in ipairs(self:getIndexedFaces()) do
                if spriteName == self.spriteName then
                    return i
                end
            end
            return -1
        end
        return originalGetFaceIndex(self)
    end

    function ISMoveableSpriteProps:getFaceDirectionFromSpriteName(_face)
        if self.IDBFSFaceSprites then
            for direction, spriteName in pairs(self.IDBFSFaceSprites) do
                if spriteName == _face then
                    return direction
                end
            end
            return nil
        end
        return originalGetFaceDirectionFromSpriteName(self, _face)
    end

    local function getItemFullType(item)
        return getCanonicalItemType(item and item.getFullType and item:getFullType() or nil)
    end

    local function getRawItemFullType(item)
        return item and item.getFullType and item:getFullType() or nil
    end

    local function getCustomItemForMoveable(self, item, spriteName)
        local itemType = getItemFullType(item)
        if itemType and IDBFS.MoveableTiles.CompositePlacement[itemType] then
            return itemType
        end
        local customItem = self and self.customItem or nil
        if customItem and IDBFS.MoveableTiles.CompositePlacement[customItem] then
            return customItem
        end
        customItem = spriteName and IDBFS.MoveableTiles.CustomItemsBySprite[spriteName] or nil
        if customItem and IDBFS.MoveableTiles.CompositePlacement[customItem] then
            return customItem
        end
        return nil
    end

    local function findCompositeItem(character, customItem, spriteName)
        if not character or not customItem then
            return nil
        end
        local inventory = character:getInventory()
        local items = inventory and inventory:getItems() or nil
        if not items then
            return nil
        end
        local fallbackItem = nil
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            if getItemFullType(item) == customItem then
                ensureItemComponents(item)
                applyCustomItemWeight(item, customItem)
                local worldSprite = item.getWorldSprite and item:getWorldSprite() or nil
                if not spriteName or worldSprite == spriteName or worldSprite == IDBFS.MoveableTiles.AnchorSpriteByItem[customItem] then
                    return item
                end
                fallbackItem = fallbackItem or item
            end
        end
        return fallbackItem
    end

    local function normalizeContainerItems(container)
        local items = container and container.getItems and container:getItems() or nil
        if not items then
            return
        end
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            local itemType = getItemFullType(item)
            if itemType and IDBFS.MoveableTiles.CustomItemWeights[itemType] then
                ensureItemComponents(item)
                applyCustomItemWeight(item, itemType)
            end
            if item and item.IsInventoryContainer and item:IsInventoryContainer() and item.getItemContainer then
                normalizeContainerItems(item:getItemContainer())
            end
        end
    end

    function IDBFS.MoveableTiles.normalizeInventoryWeights(playerObj)
        local inventory = playerObj and playerObj.getInventory and playerObj:getInventory() or nil
        normalizeContainerItems(inventory)
    end

    local function getPartSquare(anchorSquare, part, create)
        if not anchorSquare or not part then
            return nil
        end
        local x = anchorSquare:getX() + (tonumber(part.x) or 0)
        local y = anchorSquare:getY() + (tonumber(part.y) or 0)
        local z = anchorSquare:getZ() + (tonumber(part.z) or 0)
        local cell = getCell()
        local square = cell:getGridSquare(x, y, z)
        if square or not create then
            return square
        end
        if cell.getOrCreateGridSquare then
            local ok, created = pcall(cell.getOrCreateGridSquare, cell, x, y, z)
            if ok and created then
                return created
            end
        end
        if cell.createNewGridSquare then
            local ok, created = pcall(cell.createNewGridSquare, cell, x, y, z, false)
            if ok and created then
                if cell.EnsureSurroundNotNull then
                    pcall(cell.EnsureSurroundNotNull, cell, x, y, z)
                end
                return created
            end
        end
        return nil
    end

    local function findObjectWithSprite(square, spriteName)
        if not square or not spriteName then
            return nil
        end
        local objects = square:getObjects()
        if not objects then
            return nil
        end
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            local sprite = obj and obj:getSprite() or nil
            if sprite and sprite:getName() == spriteName then
                return obj
            end
        end
        return nil
    end

    local function getPartForSprite(placement, spriteName)
        if not placement or not spriteName then
            return nil
        end
        for _, part in ipairs(placement.parts) do
            if part.sprite == spriteName then
                return part
            end
        end
        return nil
    end

    local function getCompositeAnchorSquare(clickedSquare, placement, clickedSprite)
        if not clickedSquare or not placement or not clickedSprite then
            return clickedSquare
        end
        local fallback = nil
        for _, part in ipairs(placement.parts) do
            if part.sprite == clickedSprite then
                local anchorSquare = getCell():getGridSquare(
                    clickedSquare:getX() - (tonumber(part.x) or 0),
                    clickedSquare:getY() - (tonumber(part.y) or 0),
                    clickedSquare:getZ() - (tonumber(part.z) or 0)
                )
                fallback = fallback or anchorSquare
                if findObjectWithSprite(anchorSquare, placement.anchor) then
                    return anchorSquare
                end
            end
        end
        return fallback or clickedSquare
    end

    local function getCompositeEntries(anchorSquare, placement)
        if not anchorSquare or not placement then
            return nil
        end
        local entries = {}
        for _, part in ipairs(placement.parts) do
            local square = getPartSquare(anchorSquare, part)
            local obj = findObjectWithSprite(square, part.sprite)
            if not square or not obj then
                return nil
            end
            table.insert(entries, { square = square, object = obj, part = part })
        end
        return entries
    end

    local function canPlaceCompositePartFallback(props, square)
        if not props or not square or square:isVehicleIntersecting() or not square:getFloor() then
            return false
        end
        if props.isSquareAtTopOfStairs and props:isSquareAtTopOfStairs(square) then
            return false
        end
        return props.isFreeTile and props:isFreeTile(square) == true
    end

    local function canPlaceComposite(self, character, anchorSquare, item, placement)
        if not placement or not anchorSquare or anchorSquare:has(IsoFlagType.water) then
            return false
        end
        for _, part in ipairs(placement.parts) do
            local square = getPartSquare(anchorSquare, part)
            local sprite = getSprite(part.sprite)
            local zOffset = tonumber(part.z) or 0
            if zOffset > 0 then
                if not sprite then
                    return false
                end
            elseif not square or not sprite then
                return false
            else
                local props = ISMoveableSpriteProps.new(sprite)
                if not props or (not props:canPlaceMoveableInternal(character, square, item)
                        and not (placement.simplePlacementFallback and canPlaceCompositePartFallback(props, square))) then
                    return false
                end
            end
        end
        return true
    end

    local function createCompositeTile(square, spriteName)
        local sprite = getSprite(spriteName)
        if not square or not sprite then
            return nil
        end
        local obj = IsoObject.new(getCell(), square, sprite)
        square:AddTileObject(obj)
        if isClient and isClient() then
            obj:transmitCompleteItemToServer()
        end
        if isServer and isServer() then
            obj:transmitCompleteItemToClients()
        end
        if triggerEvent then
            triggerEvent("OnObjectAdded", obj)
        end
        return obj
    end

    local function initializeCompositeStorage(anchorObj, objectType)
        if IDBFS.ensureState then
            local data = IDBFS.ensureState(anchorObj, objectType, false)
            if data then
                data.createdByIDBFS = true
                if IDBFS.clearLiquid then
                    IDBFS.clearLiquid(data)
                end
            end
        end
        if IDBFS.syncObject then
            IDBFS.syncObject(anchorObj)
        elseif anchorObj and anchorObj.transmitModData then
            anchorObj:transmitModData()
        end
    end

    local function placeComposite(self, character, anchorSquare, item, placement)
        local anchorObj = nil
        for _, part in ipairs(placement.parts) do
            local square = getPartSquare(anchorSquare, part, true)
            local obj = createCompositeTile(square, part.sprite)
            if part.sprite == placement.anchor then
                anchorObj = obj
            end
        end
        initializeCompositeStorage(anchorObj, placement.objectType)
        character:getInventory():Remove(item)
        if sendRemoveItemFromContainer then
            sendRemoveItemFromContainer(character:getInventory(), item)
        end
        if ISMoveableCursor and ISMoveableCursor.clearCacheForAllPlayers then
            ISMoveableCursor.clearCacheForAllPlayers()
        end
    end

    local function removeCompositeTile(entry)
        if not entry or not entry.square or not entry.object then
            return
        end
        triggerEvent("OnObjectAboutToBeRemoved", entry.object)
        if isClient and isClient() then
            entry.square:transmitRemoveItemFromSquare(entry.object)
        elseif isServer and isServer() then
            entry.square:transmitRemoveItemFromSquareOnClients(entry.object)
            entry.square:RemoveTileObject(entry.object)
        else
            entry.square:RemoveTileObject(entry.object)
        end
        entry.square:RecalcProperties()
        entry.square:RecalcAllWithNeighbours(true)
        IsoGenerator.updateGenerator(entry.square)
    end

    local function pickUpComposite(self, character, clickedSquare, createItem, forceAllow, placement, clickedSprite)
        local clickedObj = findObjectWithSprite(clickedSquare, clickedSprite)
        if not clickedObj then
            return false
        end
        if not (forceAllow or character:isMovablesCheat() or ISMoveableDefinitions.cheat or self:canPickUpMoveable(character, clickedSquare, clickedObj)) then
            return false
        end

        local anchorSquare = getCompositeAnchorSquare(clickedSquare, placement, clickedSprite)
        local entries = getCompositeEntries(anchorSquare, placement)
        if not entries then
            return false
        end

        local item = nil
        if createItem then
            item = self:instanceItem(placement.anchor)
            if item then
                local anchorObj = findObjectWithSprite(anchorSquare, placement.anchor) or clickedObj
                if GameEntityFactory and GameEntityFactory.TransferComponents then
                    pcall(GameEntityFactory.TransferComponents, anchorObj, item)
                end
                if instanceof and instanceof(anchorObj, "IsoThumpable") then
                    self:saveThumpableParameters(item:getModData(), anchorObj)
                elseif anchorObj and anchorObj:hasModData() and anchorObj:getModData().movableData then
                    item:getModData().movableData = copyTable(anchorObj:getModData().movableData)
                end
                character:getInventory():AddItem(item)
                sendAddItemToContainer(character:getInventory(), item)
            end
        end

        for _, entry in ipairs(entries) do
            if entry.object:getFluidContainer() then
                entry.object:getFluidContainer():Empty()
            end
            removeCompositeTile(entry)
        end

        if ISMoveableCursor and ISMoveableCursor.clearCacheForAllPlayers then
            ISMoveableCursor.clearCacheForAllPlayers()
        end
        triggerEvent("OnContainerUpdate")
        return item and { item } or {}
    end

    function ISMoveableSpriteProps:canPlaceMoveable(_character, _square, _item)
        local customItem = getCustomItemForMoveable(self, _item, self and self.spriteName or nil)
        local placement = customItem and IDBFS.MoveableTiles.CompositePlacement[customItem] or nil
        if placement then
            return canPlaceComposite(self, _character, _square, _item, placement)
        end
        return originalCanPlaceMoveable(self, _character, _square, _item)
    end

    function ISMoveableSpriteProps:placeMoveable(_character, _square, _origSpriteName, _forceAllow)
        local sourceSprite = _origSpriteName or self.spriteName
        local directCustomItem = (self and self.customItem) or (sourceSprite and IDBFS.MoveableTiles.CustomItemsBySprite[sourceSprite]) or nil
        if directCustomItem and _character and _character.getInventory then
            local inventory = _character:getInventory()
            local items = inventory and inventory:getItems() or nil
            if items then
                for i = 0, items:size() - 1 do
                    local item = items:get(i)
                    if getItemFullType(item) == directCustomItem then
                        ensureItemComponents(item)
                        applyCustomItemWeight(item, directCustomItem)
                    end
                end
            end
        end
        local customItem = getCustomItemForMoveable(self, nil, sourceSprite)
        local placement = customItem and IDBFS.MoveableTiles.CompositePlacement[customItem] or nil
        if placement then
            local item = findCompositeItem(_character, customItem, _origSpriteName or self.spriteName)
            if item and (_forceAllow or canPlaceComposite(self, _character, _square, item, placement)) then
                placeComposite(self, _character, _square, item, placement)
            end
            return
        end
        return originalPlaceMoveable(self, _character, _square, _origSpriteName, _forceAllow)
    end

    function ISMoveableSpriteProps:pickUpMoveable(_character, _square, _createItem, _forceAllow)
        local spriteName = self and self.spriteName or nil
        local customItem = getCustomItemForMoveable(self, nil, spriteName)
        local placement = customItem and IDBFS.MoveableTiles.CompositePlacement[customItem] or nil
        if placement then
            if not (self.isMoveable and instanceof(_character, "IsoGameCharacter") and instanceof(_square, "IsoGridSquare")) then
                return false
            end
            return pickUpComposite(self, _character, _square, _createItem, _forceAllow, placement, spriteName)
        end
        return originalPickUpMoveable(self, _character, _square, _createItem, _forceAllow)
    end

    ISMoveableSpriteProps.IDBFSPatched = true
end

function IDBFS.MoveableTiles.installCursorPatch()
    if ISMoveableCursor and ISMoveableCursor.IDBFSCompositePreviewPatched then
        return
    end
    if not ISMoveableCursor then
        pcall(require, "BuildingObjects/ISMoveableCursor")
    end
    if not ISMoveableCursor or ISMoveableCursor.IDBFSCompositePreviewPatched then
        return
    end

    local originalRender = ISMoveableCursor.render

    function ISMoveableCursor:render(_x, _y, _z, _square)
        local customItem = nil
        if ISMoveableCursor.mode[self.player] == "place" and self.currentMoveProps then
            customItem = self.currentMoveProps.customItem
                    or (self.currentMoveProps.spriteName and IDBFS.MoveableTiles.CustomItemsBySprite[self.currentMoveProps.spriteName])
        end
        local placement = customItem and IDBFS.MoveableTiles.CompositePlacement[customItem] or nil
        if not placement then
            return originalRender(self, _x, _y, _z, _square)
        end

        self.renderX, self.renderY, self.renderZ = _x, _y, _z
        local color = self.colorMod or ISMoveableSpriteProps.invalidColor or { r = 1, g = 0, b = 0 }
        for _, part in ipairs(placement.parts) do
            local sprite = getSprite(part.sprite)
            local partX = _x + (tonumber(part.x) or 0)
            local partY = _y + (tonumber(part.y) or 0)
            local partZ = _z + (tonumber(part.z) or 0)
            local square = getCell():getGridSquare(partX, partY, partZ)
            if square and square:getFloor() and square:getFloor():getSprite() then
                square:getFloor():getSprite():RenderGhostTileColor(partX, partY, partZ, 0.75, 1, 0.75, 0.25)
            end
            if sprite then
                sprite:RenderGhostTileColor(partX, partY, partZ, 0, self.yOffset * Core.getTileScale(), color.r, color.g, color.b, 0.8)
            end
        end
    end

    ISMoveableCursor.IDBFSCompositePreviewPatched = true
end

function IDBFS.MoveableTiles.normalizePlayerInventory(playerNum, playerObj)
    IDBFS.MoveableTiles.installMoveablePatch()
    if not playerObj and getSpecificPlayer and playerNum ~= nil then
        playerObj = getSpecificPlayer(playerNum)
    end
    if IDBFS.MoveableTiles.normalizeInventoryWeights then
        IDBFS.MoveableTiles.normalizeInventoryWeights(playerObj)
    end
end

function IDBFS.MoveableTiles.normalizeAllPlayerInventories()
    IDBFS.MoveableTiles.installMoveablePatch()
    if not getSpecificPlayer then
        return
    end
    for playerNum = 0, 3 do
        local playerObj = getSpecificPlayer(playerNum)
        if playerObj then
            IDBFS.MoveableTiles.normalizePlayerInventory(playerNum, playerObj)
        end
    end
end

Events.OnGameStart.Add(IDBFS.MoveableTiles.apply)
Events.OnGameStart.Add(IDBFS.MoveableTiles.installMoveablePatch)
Events.OnGameStart.Add(IDBFS.MoveableTiles.installCursorPatch)
Events.OnGameStart.Add(IDBFS.MoveableTiles.normalizeAllPlayerInventories)
if Events.OnCreatePlayer then
    Events.OnCreatePlayer.Add(IDBFS.MoveableTiles.normalizePlayerInventory)
end
Events.OnServerStarted.Add(IDBFS.MoveableTiles.apply)
Events.OnServerStarted.Add(IDBFS.MoveableTiles.installMoveablePatch)
Events.OnServerStarted.Add(IDBFS.MoveableTiles.installCursorPatch)
IDBFS.MoveableTiles.apply()
IDBFS.MoveableTiles.installMoveablePatch()
IDBFS.MoveableTiles.installCursorPatch()
IDBFS.MoveableTiles.normalizeAllPlayerInventories()
