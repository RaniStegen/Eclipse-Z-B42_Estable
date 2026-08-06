MarzGuns_OnCreate = MarzGuns_OnCreate or {}

local r = newrandom()
local MarzGuns_AttachmentPointsTable = require("MarzWeapons/OnCreate/AttachmentPointsTable")

local function parseOptionalAttachmentEntry(entry)
    local itemType, chance, requiredMount = string.match(entry, "^([^:]+):([^:]+):([^:]+)$")
    if itemType then
        return itemType, tonumber(chance) or 0, requiredMount
    end

    itemType, chance = string.match(entry, "^([^:]+):([^:]+)$")
    if itemType then
        return itemType, tonumber(chance) or 0, nil
    end

    return entry, 100, nil
end

local function ensureRequiredMount(weapon, mountCode)
    local mountType = MarzGuns_AttachmentPointsTable.requiredAttachmentsForAttachments[mountCode]
    if not mountType then return end

    local mountPart = instanceItem(mountType)
    if not mountPart then return end

    if weapon:getWeaponPart(mountPart:getPartType()) then
        return
    end

    weapon:attachWeaponPart(mountPart)
end

function MarzGuns_OnCreate.AttachParts(weapon)
    if not weapon then return end

    local listOfAttachments = MarzGuns_AttachmentPointsTable.weaponAttachmentTablesAndChances[weapon:getFullType()]
    if listOfAttachments then
        for _, partItemType in ipairs(listOfAttachments['required'] or {}) do
            local part = instanceItem(partItemType)
            if part then
                weapon:attachWeaponPart(part)
            end
        end

        for _, partItemTypeChance in ipairs(listOfAttachments['optionals'] or {}) do
            local itemType, chanceNum, requiredMount = parseOptionalAttachmentEntry(partItemTypeChance)

            local roll = chanceNum > 0 and r:random(100) < chanceNum
            if roll then
                if requiredMount then
                    ensureRequiredMount(weapon, requiredMount)
                end

                local part = instanceItem(itemType)
                if part then
                    weapon:attachWeaponPart(part)
                end
            end
        end
    end

    if weapon:getWeaponPart("Clip") ~= nil then
        local magazine = weapon:getWeaponPart("Clip")
        local randomAmmo = r:random(magazine:getMaxAmmo())
        weapon:setMaxAmmo(magazine:getMaxAmmo())
        weapon:setMagazineType(magazine:getFullType())
        weapon:setCurrentAmmoCount(randomAmmo)
        weapon:setContainsClip(true)
    else
        weapon:setContainsClip(false)
    end
end
