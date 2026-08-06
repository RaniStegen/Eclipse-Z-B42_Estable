local RateOfFire = require("WeaponSystems/utils/RateOfFire")

RateOfFire.RegisterMultipleWeapons({
    ["MarzGuns.M93R"] = {
        rpm             = 850,
        enableSpread    = true,
        sustainedSpread = 0.25,
        maxSpread       = 4.0,
    },
    ["MarzGuns.VP70M"] = {
        rpm             = 850,
        enableSpread    = true,
        sustainedSpread = 0.25,
        maxSpread       = 4.0,
    },

    ["MarzGuns.THOMPSON"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.3,
        maxSpread       = 4.5,
    },
    ["MarzGuns.MP5"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 1.5,
    },
    ["MarzGuns.MP5K"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.2,
        maxSpread       = 2.0,
    },
    ["MarzGuns.MP5A2"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 1.5,
    },
    ["MarzGuns.MP5SD"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 1.5,
    },
    ["MarzGuns.MAC10"] = {
        rpm             = 1000,
        enableSpread    = true,
        sustainedSpread = 0.2,
        maxSpread       = 2.0,
    },

    ["MarzGuns.ASVAL"] = {
        rpm             = 900,
        enableSpread    = true,
        sustainedSpread = 0.12,
        maxSpread       = 3.0,
    },
    ["MarzGuns.M16A3"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.15,
        maxSpread       = 2.5,
    },
    ["MarzGuns.M16A2"] = {
        rpm             = 800,
        burstCount      = 3,
        enableSpread    = true,
        sustainedSpread = 0.10,
        maxSpread       = 2.5,
    },
    ["MarzGuns.M16A2_M203"] = {
        rpm             = 800,
        burstCount      = 3,
        enableSpread    = true,
        sustainedSpread = 0.10,
        maxSpread       = 2.5,
    },
    ["MarzGuns.M16A1"] = {
        rpm             = 800,
        enableSpread    = true,
        sustainedSpread = 0.15,
        maxSpread       = 2.5,
    },
    ["MarzGuns.CAR15"] = {
        rpm             = 800,
        burstCount      = 3,
        enableSpread    = true,
        sustainedSpread = 0.10,
        maxSpread       = 2.5,
    },
    ["MarzGuns.XM177"] = {
        rpm             = 800,
        burstCount      = 3,
        enableSpread    = true,
        sustainedSpread = 0.10,
        maxSpread       = 2.5,
    },
    ["MarzGuns.M4A1"] = {
        rpm             = 800,
        burstCount      = 3,
        enableSpread    = true,
        sustainedSpread = 0.10,
        maxSpread       = 2.5,
    },
    ["MarzGuns.M4"] = {
        rpm             = 850,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 2.2,
    },
    ["MarzGuns.AK74"] = {
        rpm             = 650,
        enableSpread    = true,
        sustainedSpread = 0.2,
        maxSpread       = 3.0,
    },
    ["MarzGuns.AKS74U"] = {
        rpm             = 650,
        enableSpread    = true,
        sustainedSpread = 0.25,
        maxSpread       = 3.5,
    },
    ["MarzGuns.FNC"] = {
        rpm             = 750,
        enableSpread    = true,
        sustainedSpread = 0.15,
        maxSpread       = 3.0,
    },
    ["MarzGuns.G36C"] = {
        rpm             = 750,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 2.0,
    },
    ["MarzGuns.G36"] = {
        rpm             = 750,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 2.0,
    },
    ["MarzGuns.FAMAS"] = {
        rpm             = 1000,
        enableSpread    = true,
        sustainedSpread = 0.1,
        maxSpread       = 2.0,
    },
    ["MarzGuns.AK47"] = {
        rpm             = 650,
        enableSpread    = true,
        sustainedSpread = 0.3,
        maxSpread       = 3.5,
    },

    ["MarzGuns.G3"] = {
        rpm             = 600,
        enableSpread    = true,
        sustainedSpread = 0.3,
        maxSpread       = 4.0,
    },
    ["MarzGuns.FAL"] = {
        rpm             = 750,
        enableSpread    = true,
        sustainedSpread = 0.3,
        maxSpread       = 4.5,
    },

    ["MarzGuns.M60"] = {
        rpm             = 650,
        enableSpread    = true,
        sustainedSpread = 0.35,
        maxSpread       = 5.0,
    },

    ["MarzGuns.BAR"] = {
        rpm             = 550,
        enableSpread    = true,
        sustainedSpread = 0.35,
        maxSpread       = 5.0,
    },

    ["MarzGuns.AA12"] = {
        rpm = 300,
    },
})

------------------------------------------------------------------------------------------

RateOfFire.RegisterSpreadPartModifier("MarzGuns.AKS74U_Integrated_Stock_Deployed", { sustainedSpreadMult = 0.75, maxSpreadMult = 0.85 })
RateOfFire.RegisterSpreadPartModifier("MarzGuns.ASVAL_Integrated_Stock_Deployed", { sustainedSpreadMult = 0.75, maxSpreadMult = 0.85 })
RateOfFire.RegisterSpreadPartModifier("MarzGuns.G36C_Integrated_Stock_Deployed", { sustainedSpreadMult = 0.75, maxSpreadMult = 0.85 })
RateOfFire.RegisterSpreadPartModifier("MarzGuns.Bipod_Deployed", { sustainedSpreadMult = 0.65, maxSpreadMult = 0.65 })
RateOfFire.RegisterSpreadPartModifier("MarzGuns.Stub_Foregrip", { sustainedSpreadMult = 0.85, maxSpreadMult = 0.85 })
RateOfFire.RegisterSpreadPartModifier("MarzGuns.MKC_Foregrip", { sustainedSpreadMult = 0.9, maxSpreadMult = 0.9 })
RateOfFire.RegisterSpreadPartModifier("MarzGuns.MK2_Foregrip", { sustainedSpreadMult = 0.9, maxSpreadMult = 0.9 })

------------------------------------------------------------------------------------------

RateOfFire.RegisterSpreadAmmoModifier("MarzGuns.556x45_Bullet_Overpressured", { sustainedSpreadMult = 2.0, maxSpreadMult = 2.00 })
