--------------------
--- RLP CLOTHING ---
--------------------

ClothingSelectionDefinitions = ClothingSelectionDefinitions or {}

local medicoForenseOutfit = {
    Male = {
        Hat = {
            chance = 0,
            items = {"Base.Hat_BunnyEarsBlack"},
        },
        Hands = {
            items = {"Base.Gloves_Surgical", "Base.Gloves_Dish"},
        },
        Shoes = {
            items = {"Base.Shoes_Black"},
        },
        Tshirt = {
            items = {"Base.Tshirt_Scrubs"},
        },
        Pants = {
            items = {"Base.Trousers_Scrubs"},
        },
        TorsoExtra = {
            items = {"Base.JacketLong_Doctor", "Base.Apron_White"},
        },
        Mask = {
            items = {"Base.Hat_SurgicalMask", "Base.Hat_BuildersRespirator"},
        },
        Eyes = {
            chance = 30,
            items = {"Base.Glasses_SafetyGoggles"},
        },
    },

    Female = {
        Hat = {
            chance = 0,
            items = {"Base.Hat_BunnyEarsBlack"},
        },
        Hands = {
            items = {"Base.Gloves_Surgical", "Base.Gloves_Dish"},
        },
        Shoes = {
            items = {"Base.Shoes_Black"},
        },
        Tshirt = {
            items = {"Base.Tshirt_Scrubs"},
        },
        Pants = {
            items = {"Base.Trousers_Scrubs"},
        },
        TorsoExtra = {
            items = {"Base.JacketLong_Doctor", "Base.Apron_White"},
        },
        Mask = {
            items = {"Base.Hat_SurgicalMask", "Base.Hat_BuildersRespirator"},
        },
        Eyes = {
            chance = 30,
            items = {"Base.Glasses_SafetyGoggles"},
        },
    },
}

ClothingSelectionDefinitions.medicoforense = medicoForenseOutfit
ClothingSelectionDefinitions["rlp:medicoforense"] = medicoForenseOutfit
-- Compatibility alias for old addon code; not a separate profession ID.
ClothingSelectionDefinitions.labintern = medicoForenseOutfit
