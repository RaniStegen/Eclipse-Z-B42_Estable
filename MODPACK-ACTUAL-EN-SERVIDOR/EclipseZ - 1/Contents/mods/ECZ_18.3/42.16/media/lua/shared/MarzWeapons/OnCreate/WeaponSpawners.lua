MarzGuns_OnCreate = MarzGuns_OnCreate or {}

local r = newrandom()
local SPAWNER_WEAPON_MODDATA_KEY = "MarzGunsSpawnerWeaponType"

local SpawnerTable = require("MarzWeapons/OnCreate/SpawnerTable")

MarzGuns_OnCreate.needWeaponSpawner = MarzGuns_OnCreate.needWeaponSpawner or {}
local vanillaReplacementSandboxVars = (SandboxVars and SandboxVars.MarzGuns) or {}

local function shouldProcessWeaponSpawner()
    return not isClient() or isServer()
end

local function getSelectedWeaponType(spawnerItem)
    if not spawnerItem then return nil end

    local modData = spawnerItem:getModData()
    local selectedWeaponType = modData[SPAWNER_WEAPON_MODDATA_KEY]
    if selectedWeaponType then
        return selectedWeaponType
    end

    local weaponList = SpawnerTable.SpawnerToWeapon[spawnerItem:getFullType()].replacementOptions
    if not weaponList or #weaponList == 0 then
        return nil
    end

    selectedWeaponType = weaponList[r:random(#weaponList)]
    if selectedWeaponType then
        modData[SPAWNER_WEAPON_MODDATA_KEY] = selectedWeaponType
    end

    return selectedWeaponType
end

local function generateWeapon(spawnerItem)
    local selectedWeaponType = getSelectedWeaponType(spawnerItem)
    if not selectedWeaponType then return nil end

    return instanceItem(selectedWeaponType)
end

local function replaceContainerSpawner(spawnerItem, container, weapon)
    local newWeapon = container:AddItem(weapon)
    if not newWeapon then return false end

    container:DoRemoveItem(spawnerItem)

    if isServer() then
        sendReplaceItemInContainer(container, spawnerItem, newWeapon)
    end

    container:setDirty(true)
    container:setDrawDirty(true)
    return true
end

local function replaceWorldSpawner(spawnerItem, worldItem, weapon)
    local sq = worldItem and worldItem:getSquare()
    if not sq then return false end

    sq:AddWorldInventoryItem(weapon, worldItem.xoff, worldItem.yoff, worldItem.zoff, true)

    if isServer() then
        sq:transmitRemoveItemFromSquare(worldItem)
    end

    worldItem:removeFromWorld()
    worldItem:removeFromSquare()
    spawnerItem:setWorldItem(nil)
    return true
end

function MarzGuns_OnCreate.ResolveWeaponSpawner(item)
    if not shouldProcessWeaponSpawner() or not item then return end
    if not SpawnerTable.SpawnerToWeapon[item:getFullType()] then return end
    local sandboxKey = SpawnerTable.SpawnerToWeapon[item:getFullType()].replacementAllowed
    if not vanillaReplacementSandboxVars[sandboxKey] then return end

    local container = item:getContainer()
    local parent = container and container:getParent()
    local zombieParent = parent and instanceof(parent, "IsoZombie")
    local worldItem = item:getWorldItem()

    if zombieParent or (not container and not worldItem) then
        MarzGuns_OnCreate.needWeaponSpawner[item] = true
        return
    end

    MarzGuns_OnCreate.needWeaponSpawner[item] = nil

    local weapon = generateWeapon(item)
    if not weapon then return end

    if container then
        replaceContainerSpawner(item, container, weapon)
        return
    end

    replaceWorldSpawner(item, worldItem, weapon)
end

function MarzGuns_OnCreate.OnWeaponSpawnerTick()
    if not shouldProcessWeaponSpawner() then return end

    for item, _ in pairs(MarzGuns_OnCreate.needWeaponSpawner) do
        MarzGuns_OnCreate.ResolveWeaponSpawner(item)
    end
end

function MarzGuns_OnCreate.SelectWeapon(weapon)
    if not shouldProcessWeaponSpawner() or not weapon then return end
    if not getSelectedWeaponType(weapon) then return end

    MarzGuns_OnCreate.ResolveWeaponSpawner(weapon)
end

Events.OnTick.Add(MarzGuns_OnCreate.OnWeaponSpawnerTick)
