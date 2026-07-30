local FoldingBipod = require("WeaponSystems/Utils/FoldingBipod")

FoldingBipod.RegisterMultipleWeapons({
    ["MarzGuns.M60"] = {
        attachments = {
            partType = "BipodIntegrated",
            folded   = "MarzGuns.M60_Integrated_Bipod_Folded",
            deployed = "MarzGuns.M60_Integrated_Bipod_Deployed",
        },
        initialState = "folded",
    },

    ["MarzGuns.BAR"] = {
        attachments = {
            partType = "BipodIntegrated",
            folded   = "MarzGuns.BAR_Integrated_Bipod_Folded",
            deployed = "MarzGuns.BAR_Integrated_Bipod_Deployed",
        },
        initialState = "folded",
    },

    ["MarzGuns.M24"] = {
        attachments = {
            partType = "BipodIntegrated",
            folded   = "MarzGuns.M24_Integrated_Bipod_Folded",
            deployed = "MarzGuns.M24_Integrated_Bipod_Deployed",
        },
        initialState = "folded",
    },
})
