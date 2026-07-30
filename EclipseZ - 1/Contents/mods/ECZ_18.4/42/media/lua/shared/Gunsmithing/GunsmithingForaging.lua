require "Foraging/forageDefinitions"
require "Foraging/forageSystem"

---Registers Gunsmithing's raw ores with the vanilla foraging system so they turn up
---in forest zones under the existing "Stones" category. Cinnabar is the rarer,
---higher-skill find; zinc is the common one.
local function registerGunsmithingOreForageDefs()
    local ores = {
        ZincOre = {
            type = "Gunsmithing.ZincOre",
            skill = 1,
            xp = 10,
            snowChance = -50,
            minCount = 1,
            maxCount = 1,
            categories = { "Stones" },
            zones = {
                Forest        = 3,
                DeepForest    = 4,
                PHForest      = 3,
                PRForest      = 3,
                BirchForest   = 3,
                OrganicForest = 3,
                Vegitation    = 2,
                FarmLand      = 2,
                ForagingNav   = 2,
            },
            months = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
        },
        -- Galena: the most common ore of the three, but still scarcer per forage than flint,
        -- which turns up at the same zone rate in stacks of up to two.
        LeadOre = {
            type = "Gunsmithing.LeadOre",
            skill = 1,
            xp = 10,
            snowChance = -50,
            minCount = 1,
            maxCount = 1,
            categories = { "Stones" },
            zones = {
                Forest        = 4,
                DeepForest    = 4,
                PHForest      = 4,
                PRForest      = 4,
                BirchForest   = 4,
                OrganicForest = 4,
                Vegitation    = 3,
                FarmLand      = 3,
                ForagingNav   = 3,
            },
            months = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
        },
        CinnabarOre = {
            type = "Gunsmithing.CinnabarOre",
            skill = 3,
            xp = 15,
            snowChance = -50,
            minCount = 1,
            maxCount = 1,
            categories = { "Stones" },
            zones = {
                Forest        = 1,
                DeepForest    = 2,
                PHForest      = 1,
                PRForest      = 1,
                BirchForest   = 1,
                OrganicForest = 1,
                Vegitation    = 1,
            },
            months = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
        },
        -- Knapped flint for flintlock strikers: common stone, found low-skill nearly anywhere.
        FlintFlake = {
            type = "Gunsmithing.FlintFlake",
            skill = 0,
            xp = 5,
            snowChance = -20,
            minCount = 1,
            maxCount = 2,
            categories = { "Stones" },
            zones = {
                Forest        = 4,
                DeepForest    = 4,
                PHForest      = 4,
                PRForest      = 4,
                BirchForest   = 4,
                OrganicForest = 4,
                Vegitation    = 3,
                FarmLand      = 3,
                TrailerPark   = 2,
                ForagingNav   = 3,
            },
            months = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 },
        },
    }

    for itemName, itemDef in pairs(ores) do
        forageSystem.addForageDef(itemName, itemDef)
    end
end

registerGunsmithingOreForageDefs()
