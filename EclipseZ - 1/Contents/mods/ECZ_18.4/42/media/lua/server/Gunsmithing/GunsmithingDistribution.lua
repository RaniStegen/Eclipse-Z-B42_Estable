require "Items/ProceduralDistributions"

---Appends `item, weight` pairs to an existing ProceduralDistributions container.
---Silently skips containers that another mod removed so we never hard-error a merge.
---@param containerName string
---@param entries table<string, number> fullType -> weight
local function addToContainer(containerName, entries)
    local container = ProceduralDistributions.list[containerName]
    if not container or not container.items then
        return
    end
    for fullType, weight in pairs(entries) do
        table.insert(container.items, fullType)
        table.insert(container.items, weight)
    end
end

---@param containerNames string[]
---@param entries table<string, number>
local function addToContainers(containerNames, entries)
    for i = 1, #containerNames do
        addToContainer(containerNames[i], entries)
    end
end

local function injectGunsmithingLoot()
    local rifles = {
        ["Gunsmithing.Musket1770"]   = 1.0,
        ["Gunsmithing.KentuckyRifle"] = 1.0,
        ["Gunsmithing.Musket1855"]   = 1.0,
        ["Gunsmithing.1875Gun"]      = 0.8,
    }
    local shotguns = {
        ["Gunsmithing.DoubleBarrelFlintlockShotgun"] = 0.8,
    }
    local pistols = {
        ["Gunsmithing.SchofieldCartridge"]      = 0.8,
        ["Gunsmithing.RemingtonArmy_Percussion"] = 0.8,
        ["Gunsmithing.ColtWalker_Percussion"]   = 0.8,
        ["Gunsmithing.ColtWalker_Cartridge"]    = 0.6,
    }
    local ammo = {
        ["Gunsmithing.PaperCartridge"]    = 3.0,
        ["Gunsmithing.HandmadeCartridge"] = 2.0,
        ["Gunsmithing.MusketBall"]        = 4.0,
        ["Gunsmithing.MusketBullet"]      = 3.0,
        ["Gunsmithing.RoundBall_44"]      = 3.0,
        ["Gunsmithing.PistolCartridge"]   = 2.0,
        ["Gunsmithing.CapsPackage"]       = 3.0,
    }
    local parts = {
        ["Gunsmithing.Crafting_Barrel"] = 1.0,
        ["Gunsmithing.Crafting_Stock"]  = 1.0,
        ["Gunsmithing.GunParts"]        = 0.8,
        ["Gunsmithing.GunBands"]        = 0.8,
        ["Gunsmithing.BrassCasing"]     = 1.0,
        ["Gunsmithing.Musket1770_RamRod"] = 1.5,
    }
    local rawMaterials = {
        ["Gunsmithing.GunBands"]      = 0.6,
        ["Gunsmithing.BrassCasing"]   = 0.8,
        ["Gunsmithing.Saltpeter"]     = 0.6,
        ["Gunsmithing.ZincOre"]       = 0.5,
        ["Gunsmithing.CinnabarOre"]   = 0.3,
    }

    addToContainers({ "GunStoreRifles", "GunStoreGuns", "GunStoreDisplayCase", "HuntingLockers", "ArmyStorageGuns" }, rifles)
    addToContainers({ "GunStoreShotguns", "GunStoreGuns", "GunStoreDisplayCase" }, shotguns)
    addToContainers({ "GunStorePistols", "GunStoreGuns", "GunStoreDisplayCase" }, pistols)
    addToContainers({ "GunStoreAmmunition", "GunStoreMagsAmmo", "ArmyStorageAmmunition" }, ammo)
    addToContainers({ "GunStoreAccessories", "GunStoreShelf", "GarageTools", "CrateTools" }, parts)
    addToContainers({ "CrateTools", "GarageTools" }, rawMaterials)
end

Events.OnPreDistributionMerge.Add(injectGunsmithingLoot)
