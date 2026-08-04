-- ============================================================
-- PagerMod_Distribution.lua
-- Seeds the "Pager Tower Schematics" magazine into electronics/comms
-- loot — but ONLY when a tower is actually needed: a powered-tower signal
-- mode, OR receive-only pagers (then the tower is the only way to send).
-- The tower recipe can't be learnt any other way, so otherwise the magazine
-- never spawns and the tower can't be built — exactly when it isn't needed.
-- ============================================================

require "PagerMod_Shared"

-- Procedural-distribution lists to seed. B41 and B42 use slightly different
-- list names (e.g. "ElectronicStore..." vs "ElectronicsStore..."), so we list
-- both and silently skip any that don't exist in the running build.
local TARGET_LISTS = {
    -- B42
    "ElectronicStoreMagazines", "ElectronicStoreHAMRadio", "ElectronicStoreMisc",
    "RadioFactoryComponents", "ArmyStorageElectronics", "MechanicShelfElectric",
    "StoreShelfElectronics", "CrateElectronics", "GigamartHouseElectronics",
    -- B41 / older spellings
    "ElectronicsStoreMagazines", "ElectronicsStoreElectronics", "ElectronicsStoreMisc",
    "GarageElectronics",
}

local SCHEMATIC = "PagerMod.TowerSchematic"
local WEIGHT    = 8   -- modest rarity, in line with other recipe magazines

local function towerNeeded()
    local sv = SandboxVars and SandboxVars.PagerMod
    if not sv then return false end
    -- A tower is needed (so its recipe must be obtainable) when EITHER:
    --   * the network requires a tower (a powered-tower signal mode), or
    --   * pagers are receive-only — then the tower console is the only way to
    --     SEND a page, so players have to be able to craft one.
    if PagerMod.isTowerMode(sv.SignalMode) then return true end
    if sv.PagerMode == PagerMod.PagerMode.RECEIVE_ONLY then return true end
    return false
end

local function seedSchematic()
    if not towerNeeded() then return end
    local lists = ProceduralDistributions and ProceduralDistributions.list
    if not lists then return end

    local added = 0
    local seen = {}
    for _, name in ipairs(TARGET_LISTS) do
        local entry = lists[name]
        if entry and entry.items and not seen[name] then
            seen[name] = true
            table.insert(entry.items, SCHEMATIC)
            table.insert(entry.items, WEIGHT)
            added = added + 1
        end
    end
    print(string.format("[PagerMod] Tower mode on: seeded %s into %d loot list(s).", SCHEMATIC, added))
end

Events.OnPreDistributionMerge.Add(seedSchematic)
