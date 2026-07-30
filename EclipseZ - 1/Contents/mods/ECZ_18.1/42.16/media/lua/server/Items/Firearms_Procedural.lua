require "Items/ProceduralDistributions"
require "Items/ItemPicker"

-- Maps item names to their spawn condition
local FirearmsSpawnConditions = {
    ["Base.AKM"]                 = function() return SandboxVars.Firearms.SpawnAKM end,
    ["Base.AKM_Mag"]             = function() return SandboxVars.Firearms.SpawnAKM end,
    ["Base.AK47"]                = function() return SandboxVars.Firearms.SpawnAKM end,
    ["Base.SKS"]                 = function() return SandboxVars.Firearms.SpawnSKS end,
    ["Base.M1Garand"]            = function() return SandboxVars.Firearms.SpawnM1Garand end,
    ["Base.M1GarandClip"]        = function() return SandboxVars.Firearms.SpawnM1Garand end,
    ["Base.MP5"]                 = function() return SandboxVars.Firearms.SpawnMP5 end,
    ["Base.MP5Mag"]              = function() return SandboxVars.Firearms.SpawnMP5 end,
    ["Base.MP5SD"]               = function() return SandboxVars.Firearms.SpawnMP5SD end,
    ["Base.MP510"]               = function() return SandboxVars.Firearms.SpawnMP510 end,
    ["Base.MP510Mag"]            = function() return SandboxVars.Firearms.SpawnMP510 end,
    ["Base.MAC10"]               = function() return SandboxVars.Firearms.SpawnMAC10 end,
    ["Base.MAC10Mag"]            = function() return SandboxVars.Firearms.SpawnMAC10 end,
    ["Base.UZI"]                 = function() return SandboxVars.Firearms.SpawnUZI end,
    ["Base.UZIMag"]              = function() return SandboxVars.Firearms.SpawnUZI end,
    ["Base.SPAS12"]              = function() return SandboxVars.Firearms.SpawnSPAS12 end,
    ["Base.ColtPython"]          = function() return SandboxVars.Firearms.SpawnPython end,
    ["Base.ColtPythonHunter"]    = function() return SandboxVars.Firearms.SpawnPython end,
    ["Base.ColtDelta"]           = function() return SandboxVars.Firearms.SpawnColtDelta end,
    ["Base.DeltaClip"]           = function() return SandboxVars.Firearms.SpawnColtDelta end,
    ["Base.ColtPeacemaker"]      = function() return SandboxVars.Firearms.SpawnColtPeacemaker end,
    ["Base.ColtAce"]             = function() return SandboxVars.Firearms.SpawnColtAce end,
    ["Base.22Clip"]              = function() return SandboxVars.Firearms.SpawnColtAce end,
    ["Base.ColtSingleAction22"]  = function() return SandboxVars.Firearms.SpawnColtScout end,
    ["Base.M4"]                  = function() return SandboxVars.Firearms.SpawnM4 end,
    ["Base.Glock17"]             = function() return SandboxVars.Firearms.SpawnGlock17 end,
    ["Base.ColtAnaconda"]        = function() return SandboxVars.Firearms.SpawnAnaconda end,
    ["Base.FN_FAL"]              = function() return SandboxVars.Firearms.SpawnFNFal end,
    ["Base.FN_FAL_Mag"]          = function() return SandboxVars.Firearms.SpawnFNFal end,
    ["Base.G3"]                  = function() return SandboxVars.Firearms.SpawnG3 end,
    ["Base.G3_Mag"]              = function() return SandboxVars.Firearms.SpawnG3 end,
    ["Base.M60"]                 = function() return SandboxVars.Firearms.SpawnM60 end,
    ["Base.M60Mag"]              = function() return SandboxVars.Firearms.SpawnM60 end,
    ["Base.Mossberg500"]         = function() return SandboxVars.Firearms.SpawnMossberg500 end,
    ["Base.Mossberg500Tactical"] = function() return SandboxVars.Firearms.SpawnMossberg500Tactical end,
    ["Base.Remington870"]        = function() return SandboxVars.Firearms.SpawnRemington870 end,
}

-- Filters a flat {item, weight, item, weight...} table down to only enabled items
local function filterItems(items)
    local result = {}
    for i = 1, #items, 2 do
        local item = items[i]
        local weight = items[i + 1]
        local condition = FirearmsSpawnConditions[item]
        if condition == nil or condition() then
            table.insert(result, item)
            table.insert(result, weight)
        end
    end
    return result
end

-- Insert a single item into one distribution container at weight baseWeight.
local function addItem(distTable, i, itemName, weight)
    table.insert(ProceduralDistributions.list[distTable[i]].items, itemName)
    table.insert(ProceduralDistributions.list[distTable[i]].items, weight)
end

-- Insert one item across every container in a flat {name, weight, name, weight...} table.
local function addItemToAll(distTable, itemName, weightFn)
    for i = 1, #distTable, 2 do
        addItem(distTable, i, itemName, weightFn(distTable[i + 1]))
    end
end

-- Insert multiple items (given as {item, weightMult, item, weightMult...}) across
-- every container in distTable. weightMult is multiplied against the base weight.
local function addItemsToAll(distTable, items)
    local filtered = filterItems(items)
    if #filtered == 0 then return end
    for i = 1, #distTable, 2 do
        local base = distTable[i + 1]
        for j = 1, #filtered, 2 do
            addItem(distTable, i, filtered[j], base * filtered[j + 1])
        end
    end
end

-- Like addItemsToAll but only runs when condition is true.
local function addItemsToAllIf(condition, distTable, items)
    if condition then
        addItemsToAll(distTable, items)
    end
end

local function addItemsToBags(bagNames, items)
    local filtered = filterItems(items)
    if #filtered == 0 then return end
    for _, bagName in ipairs(bagNames) do
        local bag = BagsAndContainers[bagName]
        if bag then
            for j = 1, #filtered, 2 do
                table.insert(bag.items, filtered[j])
                table.insert(bag.items, filtered[j + 1])
            end
        else
            print("[Firearms] Warning: BagsAndContainers." .. bagName .. " not found")
        end
    end
end

local FirearmsDistributionAmmoBoxes = {
    "GunStoreAmmunition", 8,
    "HuntingLockers", 2,
}

local FirearmsDistributionAmmoCartons = {
    "GunStoreAmmunition", 0.4,
    "HuntingLockers", 0.5,
    "FirearmWeapons_Mid", 8,
}

local FirearmsDistributionArmyAmmoBoxes = {
    "ArmyStorageGuns", 5,
    "FirearmWeapons", 5,
    "FirearmWeapons_Mid", 5,
    "ArmyStorageAmmunition", 8,
    "ArmySurplusAmmoBoxes", 5,
}

local FirearmsDistribution = {
    "FirearmWeapons", 6,
    "FirearmWeapons_Mid", 6,
    "GunStoreGuns", 5,
    "DrugShackWeapons", 4,
}

local FirearmsDistributionPistols = {
    "GunStorePistols", 6,
    "DrugLabGuns", 4,
    "DrugShackWeapons", 4,
}

local FirearmsDistributionRifles = {
    "GunStoreRifles", 5,
    "PoliceEvidence", 3,
    "DrugLabGuns", 1,
    "DrugShackWeapons", 2,
    "FirearmWeapons", 3,
    "FirearmWeapons_Mid", 4,
    "FirearmWeapons_Late", 7,
}

local FirearmsDistributionMagazines = {
    "GunStoreMagsAmmo", 8,
    "DrugShackWeapons", 8,
    "FirearmWeapons", 3,
    "FirearmWeapons_Mid", 4,
    "FirearmWeapons_Late", 7,
}

local FirearmsDistributionMilitary = {
    "LockerArmyBedroom", 3,
    "ArmyStorageGuns", 750,
    "DrugLabGuns", 1,
    "DrugShackWeapons", 2,
    "FirearmWeapons", 3,
    "FirearmWeapons_Mid", 4,
    "FirearmWeapons_Late", 7,
}

local FirearmsDistributionShotguns = {
    "PoliceStorageGuns", 10,
    "BarCounterWeapon", 5,
    "GarageFirearms", 5,
    "GunStoreShotguns", 10,
    "DrugLabGuns", 5,
    "DrugShackWeapons", 5,
    "FirearmWeapons", 3,
    "FirearmWeapons_Mid", 4,
    "FirearmWeapons_Late", 7,
}

local FirearmsDistributionAttachments = {
    "PoliceStorageGuns", 2,
    "ArmyStorageGuns", 4,
    "LockerArmyBedroom", 1,
    "GunStoreAccessories", 3,
    "DrugLabGuns", 1,
    "FirearmWeapons_Mid", 3,
}

local FirearmsDistributionStocks = {
    "GunStoreAccessories", 1,
}

local FirearmsDistributionPoliceAmmo = {
    "PoliceStorageAmmunition", 7,
    "PrisonGuardLockers", 3,
}

local FirearmsDistributionPolice = {
    "PoliceStorageGuns", 6,
    "PrisonGuardLockers", 3,
}

local FirearmsDistributionSchoolLocker = {
    "SchoolLockersBad", 0.005,
}

local FirearmsDistributionCleaning = {
    "StoreShelfMechanics", 5,
    "ToolStoreMetalwork", 2,
    "ToolStoreCarpentry", 0.5,
    "ToolStoreMisc", 5,
    "JanitorChemicals", 5,
    "CrateTools", 0.5,
    "CrateMechanics", 0.5,
    "GarageTools", 0.5,
    "LockerArmyBedroom", 5,
}

local FirearmsDistributionSlings = {
    "ArmyHangarOutfit", 1,
    "CampingStoreGear", 1,
    "ArmyStorageGuns", 2,
    "GunStoreAccessories", 1,
}

local FirearmsDistributionOld = {
    "BarCounterWeapon", 5,
    "PawnShopGunsSpecial", 8,
}

local FirearmsAmmoBoxes = {
    "Base.Bullets4440Box", 0.75,
    "Base.762x39Box", 0.1,
    "Base.Bullets22Box", 2,
    "Base.Bullets3006Box", 0.5,
    "Base.Bullets10mmBox", 0.5,
}

local FirearmsAmmoCartons = {
    "Base.Bullets4440Carton", 1,
    "Base.Bullets22Carton", 1,
    "Base.Bullets3006Carton", 1,
    "Base.Bullets10mmCarton", 1,
}

local FirearmsShotguns = {
    "Base.Remington870", 1,
    "Base.Remington870Wood", 1.5,
    "Base.LAW12", 0.1,
    "Base.SPAS12", 0.1,
    "Base.Mossberg500", 1,
    "Base.Mossberg500Tactical", 0.1,
}

local FirearmsPistols = {
    "Base.Glock17", 1,
    "Base.Glock17Mag", 1,
    "Base.ColtDelta", 0.15,
    "Base.DeltaClip", 0.125,
    "Base.ColtAce", 0.35,
    "Base.22Clip", 0.25,
}

local FirearmsSchoolLocker = {
    "Base.Remington870", 1,
    "Base.Remington870Wood", 1.5,
    "Base.Glock17", 0.1,
    "Base.Glock17Mag", 0.1,
    "Base.MP5", 0.1,
    "Base.MP5Mag", 0.1,
    "Base.M1Garand", 0.1,
    "Base.M1GarandClip", 0.1,
    "Base.Mossberg500", 1,
    "Base.Mossberg500Tactical", 0.1,
}

local FirearmsSoviet = {
    "Base.AKM", 1,
    "Base.AKM_Mag", 1,
    "Base.SKS", 1,
    "Base.762x39Box", 1,
    "Base.762x39Box", 0.5,
    "Base.762x39Box", 0.25,
}

local FirearmsPolice = {
    "Base.Glock17", 1,
    "Base.Glock17Mag", 1,
}

local FirearmsSWATPolice = {
    "Base.MP5", 0.75,
    "Base.MP5SD", 0.05,
    "Base.MP510", 0.5,
    "Base.LAW12", 1,
    "Base.SPAS12", 1,
}

local FirearmsForeigMilitary = {
    "Base.FN_Fal", 1,
    "Base.G3", 1,
}

local FirearmsMilitary = {
    "Base.SPAS12", 1,
    "Base.MP5", 0.75,
    "Base.MP5SD", 0.01,
    "Base.M60", 0.25,
    "Base.LAW12", 1,
    "Base.Glock17", 1,
    "Base.M4", 1,
}

local FirearmsMagazines = {
    "Base.22Clip", 1,
    "Base.M1GarandClip", 1,
    "Base.MP510Mag", 1,
    "Base.DeltaClip", 1,
    "Base.AKM_Mag", 1,
    "Base.FN_FAL_Mag", 1,
    "Base.G3_Mag", 1,
    "Base.Glock17Mag", 1,
}

local FirearmsStocks = {
    "Base.AmmoStock", 1,
    "Base.ShotgunStock", 1,
    "Base.TacticalStock", 1,
}

local FirearmsCleaning = {
    "Base.Solvent", 1,
}

local FirearmsSlings = {
    "Base.Sling", 1,
    "Base.Sling_Leather", 1,
    "Base.Sling_Camo", 1,
    "Base.Sling_Olive", 1,
}

local FirearmsOld = {
    "Base.M1Garand", 1,
    "Base.ColtPeacemaker", 1,
    "Base.ColtSingleAction22", 1,
}

local FirearmsAttachments = {
    "Base.x4-x12Scope", 0.5,
    "Base.Rifle_Flashlight", 1,
    "Base.Ammostock", 1,
}

local FirearmsDistributionSilencers = {
    "PoliceStorageGuns", 0.02,
    "LockerArmyBedroom", 0.04,
    "ArmyStorageGuns", 0.02,
    "GunStoreAccessories", 0.01,
    "DrugLabGuns", 0.002,
    "FirearmWeapons", 0.002,
    "FirearmWeapons_Mid", 0.01,
    "FirearmWeapons_Late", 0.05,
}

local function initFirearmsDistribution(newGame)
    addItemsToAll(FirearmsDistributionPolice, FirearmsPolice)
    addItemsToAll(FirearmsDistributionPolice, FirearmsSWATPolice)
    addItemsToAll(FirearmsDistribution, FirearmsSWATPolice)
    addItemsToAll(FirearmsDistribution, FirearmsPolice)
    addItemsToAll(FirearmsDistribution, FirearmsCleaning)
    addItemsToAll(FirearmsDistribution, FirearmsOld)
    addItemsToAll(FirearmsDistribution, FirearmsSoviet)
    addItemsToAll(FirearmsDistribution, FirearmsMilitary)
    addItemsToAll(FirearmsDistribution, FirearmsForeigMilitary)
    addItemsToAll(FirearmsDistribution, FirearmsShotguns)
    addItemsToAll(FirearmsDistributionShotguns, FirearmsShotguns)
    addItemsToAll(FirearmsDistributionPistols, FirearmsPistols)
    addItemsToAll(FirearmsDistributionSchoolLocker, FirearmsSchoolLocker)
    addItemsToAll(FirearmsDistributionMilitary, FirearmsForeigMilitary)
    addItemsToAll(FirearmsDistributionOld, FirearmsOld)
    addItemsToAll(FirearmsDistributionStocks, FirearmsStocks)
    addItemsToAll(FirearmsDistributionSlings, FirearmsSlings)
    addItemsToAll(FirearmsDistributionAttachments, FirearmsAttachments)
    addItemsToAll(FirearmsDistributionMagazines, FirearmsMagazines)
    addItemsToAll(FirearmsDistributionAmmoBoxes, FirearmsAmmoBoxes)
    addItemsToAll(FirearmsDistributionPoliceAmmo, FirearmsAmmoBoxes)
    addItemsToAll(FirearmsDistributionArmyAmmoBoxes, FirearmsAmmoBoxes)
    addItemsToAll(FirearmsDistributionAmmoCartons, FirearmsAmmoCartons)
    addItemsToAll(FirearmsDistributionCleaning, FirearmsCleaning)

    local FirearmsPoliceBags = {
        "Bag_Police",
        "BanditBag_Late",
        "SurvivorBag_Late",
    }

    local FirearmsWeaponBags = {
        "SurvivorBag",
        "SurvivorBag_Mid",
        "SurvivorBag_Late",
        "BanditBag",
        "BanditBag_Early",
        "BanditBag_Mid",
        "BanditBag_Late",
    }

    local FirearmsArmyBags = {
        "ALICEpack_Army",
        "BanditBag_Late",
        "SurvivorBag_Late",
    }

    addItemsToBags(FirearmsPoliceBags, FirearmsPolice)
    addItemsToBags(FirearmsWeaponBags, FirearmsPistols)
    addItemsToBags(FirearmsWeaponBags, FirearmsShotguns)
    addItemsToBags(FirearmsWeaponBags, FirearmsOld)
    addItemsToBags(FirearmsWeaponBags, FirearmsForeigMilitary)
    addItemsToBags(FirearmsWeaponBags, FirearmsAmmoBoxes)
    addItemsToBags(FirearmsArmyBags, FirearmsMilitary)
    addItemsToBags(FirearmsArmyBags, FirearmsShotguns)
    addItemsToBags(FirearmsArmyBags, FirearmsAmmoBoxes)

    if SandboxVars.Firearms.SpawnSuppressors then
        local rarity = 128 * (SandboxVars.Firearms.LootSuppressor - 1)
        addItemsToAllIf(SandboxVars.Firearms.SpawnHandgunSuppressors, FirearmsDistributionSilencers, {
            "9mmSilencer", rarity,
            "45Silencer", rarity,
            "10mmSilencer", rarity,
        })
        addItemsToAllIf(SandboxVars.Firearms.SpawnRifleSuppressors, FirearmsDistributionSilencers, {
            "223Silencer", rarity / 2,
            "308Silencer", rarity / 2,
            "22Silencer", rarity / 4,
        })
        addItemsToAllIf(SandboxVars.Firearms.SpawnShotgunSuppressors, FirearmsDistributionSilencers,
            { "ShotgunSilencer", rarity / 4 })
        addItemsToAllIf(SandboxVars.Firearms.SpawnRevolverSuppressors, FirearmsDistributionSilencers,
            { "38Silencer", rarity / 2 })
    end

    ItemPickerJava.Parse()
end

Events.OnInitGlobalModData.Add(initFirearmsDistribution)
