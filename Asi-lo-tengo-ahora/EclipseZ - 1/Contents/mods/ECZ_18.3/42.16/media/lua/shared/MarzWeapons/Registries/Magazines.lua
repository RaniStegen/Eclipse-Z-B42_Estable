local Magazine = require("WeaponSystems/Utils/Magazine")

-------------------------------------
--- Magazine Profiles
-------------------------------------
Magazine.RegisterMultipleMagazineProfiles({
    ["STANAG"] = {
        "MarzGuns.556x45Magazine20_STANAG",
        "MarzGuns.556x45Magazine25_STANAG",
        "MarzGuns.556x45Magazine30_STANAG",
        "MarzGuns.556x45Magazine50_STANAG",
        "MarzGuns.556x45Magazine60_STANAG",
        "MarzGuns.556x45Magazine75_STANAG",
        "MarzGuns.556x45Magazine100_STANAG",
        "MarzGuns.556x45Magazine150_STANAG",
    },

    ["545x39"] = {
        "MarzGuns.545x39Magazine30_Bakelite",
        "MarzGuns.545x39Magazine45_Bakelite",
        "MarzGuns.545x39Magazine100_Drum",
    },

    ["AA12"] = {
        "MarzGuns.12GMagazine8_AA12",
        "MarzGuns.12GMagazine20_AA12",
    },

    ["9x19 M92FS"] = {
        "MarzGuns.9x19Magazine15_M92FS",
        "MarzGuns.9x19Magazine30_M92FS",
        "MarzGuns.9x19Magazine50_M92FS",
    },

    ["9x19 M93R"] = {
        "MarzGuns.9x19Magazine18_M93R",
        "MarzGuns.9x19Magazine60_M93R",
    },

    [".45 USP"] = {
        "MarzGuns.45Magazine12_USP",
        "MarzGuns.45Magazine20_USP",
    },

    [".50 Deagle"] = {
        "MarzGuns.50Magazine8_DEAGLE",
        "MarzGuns.50Magazine12_DEAGLE",
    },

    [".45 Thompson"] = {
        "MarzGuns.45Magazine20_THOMPSON",
        "MarzGuns.45Magazine30_THOMPSON",
        "MarzGuns.45Magazine100_THOMPSON",
    },

    ["9x19mm MP5"] = {
        "MarzGuns.9x19Magazine20_MP5",
        "MarzGuns.9x19Magazine25_MP5",
        "MarzGuns.9x19Magazine30_MP5",
        "MarzGuns.9x19Magazine60_MP5",
        "MarzGuns.9x19Magazine100_MP5",
    },

    ["762x39"] = {
        "MarzGuns.762x39Magazine30",
        "MarzGuns.762x39Magazine75",
    },

    ["45 MAC10"] = {
        "MarzGuns.45Magazine30_MAC10",
        "MarzGuns.45Magazine40_MAC10",
    },

    ["9x19mm VP70M"] = {
        "MarzGuns.9x19Magazine18_VP70M",
        "MarzGuns.9x19Magazine30_VP70M",
    },
})

-------------------------------------
--- Weapon in Magazine Profiles
-------------------------------------
Magazine.RegisterMultipleWeaponsWithProfiles({
    ["STANAG"] = {
        "MarzGuns.M16A1",
        "MarzGuns.M16A2",
        "MarzGuns.M16A2_M203",
        "MarzGuns.M16A3",
        "MarzGuns.AR15",
        "MarzGuns.FNC",
        "MarzGuns.M4",
        "MarzGuns.FAMAS",
        "MarzGuns.CAR15",
        "MarzGuns.XM177",
        "MarzGuns.M4A1",
    },

    ["545x39"] = {
        "MarzGuns.AK74",
        "MarzGuns.AKS74U",
    },

    ["AA12"] = {
        "MarzGuns.AA12",
    },

    ["9x19 M92FS"] = {
        "MarzGuns.M92FS",
    },

    ["9x19 M93R"] = {
        "MarzGuns.M93R",
    },

    [".45 USP"] = {
        "MarzGuns.USP",
    },

    [".50 Deagle"] = {
        "MarzGuns.DEAGLE",
    },

    [".45 Thompson"] = {
        "MarzGuns.THOMPSON",
    },

    ["9x19mm MP5"] = {
        "MarzGuns.MP5",
        "MarzGuns.MP5K",
        "MarzGuns.MP5A2",
        "MarzGuns.MP5SD",
    },

    ["762x39"] = {
        "MarzGuns.AK47",
    },

    ["45 MAC10"] = {
        "MarzGuns.MAC10",
    },

    ["9x19mm VP70M"] = {
        "MarzGuns.VP70M",
    },
})
