local Railing = require("WeaponSystems/Utils/Railing")

Railing.RegisterRailing({ "MarzGuns.Picatinny_Rail_Up", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.G36C_Integrated_Rail_Up", "MarzGuns.M4_Integrated_Rail_Up" }, {
    "MarzGuns.Booster_Scope",
    "MarzGuns.Booster_Scope_Off",
    "MarzGuns.EXPS1_Sight",
    "MarzGuns.EXPS3_Sight",
    "MarzGuns.ElcanX2_Scope",
    "MarzGuns.LR10X_Scope",
    "MarzGuns.Aimpoint_Sight",
    "MarzGuns.TA28_Scope",
    "MarzGuns.LR4X_Scope",
    "MarzGuns.OKP3_Sight",
    "MarzGuns.ReflexS2_Sight",
    "MarzGuns.JS14_Sight",
    "MarzGuns.Kobra_Sight",
    "MarzGuns.TR06X_Scope",
    "MarzGuns.PSO1_Scope",
    "MarzGuns.LRX12X_Scope",
})

Railing.RegisterRailing({ "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount" }, {
    "MarzGuns.PL4_Sight",
    "MarzGuns.PM2_Sight",
    "MarzGuns.PS1_Sight",
})

Railing.RegisterRailing({ "MarzGuns.Heavy_Pistol_Rail" }, {
    "MarzGuns.PL4_Sight",
    "MarzGuns.PM2_Sight",
    "MarzGuns.PS1_Sight",
    "MarzGuns.PRL1_Scope",
})

Railing.RegisterRailing({ "MarzGuns.Picatinny_Rail_Down", "MarzGuns.G36C_Integrated_Rail_Down" }, {
    "MarzGuns.Bipod_Deployed",
    "MarzGuns.Bipod_Folded",

    "MarzGuns.Stub_Foregrip",
    "MarzGuns.MKC_Foregrip",
    "MarzGuns.MK2_Foregrip",
})

Railing.RegisterRailing({ "MarzGuns.M4_Integrated_Rail_Down" }, {
    "MarzGuns.Bipod_Deployed",
    "MarzGuns.Bipod_Folded",

    "MarzGuns.Stub_Foregrip",
    "MarzGuns.MKC_Foregrip",
    "MarzGuns.MK2_Foregrip",

    "MarzGuns.M203"
})

Railing.RegisterRailing({ "MarzGuns.Picatinny_Rail_Left", "MarzGuns.M4_Integrated_Rail_Left" }, {
    "MarzGuns.BrightPoint-5_Light",
    "MarzGuns.SR7_Light",
})

Railing.RegisterRailing({ "MarzGuns.Picatinny_Rail_Right", "MarzGuns.M4_Integrated_Rail_Right" }, {
    "MarzGuns.AimRight_Laser",
    "MarzGuns.LRX-7_Laser",
})

Railing.RegisterRailing("MarzGuns.AR_Muzzle_Mount_Device", {
    "MarzGuns.MKI_Suppressor",
    "MarzGuns.NDR_Suppressor",
    "MarzGuns.LR2_Compensator",
    "MarzGuns.LX_Flashhider",
    "MarzGuns.Trix42_Muzzlebreak",
})

Railing.RegisterRailing("MarzGuns.AK_Muzzle_Mount_Device", {
    "MarzGuns.PBS-1_Suppressor",
})

Railing.RegisterRailing("MarzGuns.45_Muzzle_Mount_Device", {
    "MarzGuns.P45_Suppressor",
})

Railing.RegisterRailing("MarzGuns.Pistol_Muzzle_Mount_Device", {
    "MarzGuns.MP_Suppressor",
    "MarzGuns.Shh9_Suppressor",
})

Railing.SetExclusives({ "MarzGuns.Booster_Scope", "MarzGuns.Booster_Scope_Off" }, {
    "MarzGuns.JS14_Sight",
    "MarzGuns.Kobra_Sight",
    "MarzGuns.OKP3_Sight",
    "MarzGuns.ReflexS2_Sight",
    "MarzGuns.LR10X_Scope",
    "MarzGuns.ElcanX2_Scope",
    "MarzGuns.LR4X_Scope",
    "MarzGuns.TR06X_Scope",
    "MarzGuns.PSO1_Scope",
    "MarzGuns.LRX12X_Scope",
})

Railing.SetExclusives({ "MarzGuns.M9_Bayonet_Attachment", "MarzGuns.M5_Bayonet_Attachment", "MarzGuns.K98_Bayonet_Attachment" }, {
    "MarzGuns.MKI_Suppressor",
    "MarzGuns.NDR_Suppressor",
    "MarzGuns.PBS-1_Suppressor",
    "MarzGuns.LR2_Compensator",
    "MarzGuns.LX_Flashhider",
    "MarzGuns.Trix42_Muzzlebreak",
    "MarzGuns.M203",
})

Railing.SetExclusives({ "MarzGuns.PRL1_Scope" }, {
    "MarzGuns.PL4_Sight",
    "MarzGuns.PM2_Sight",
    "MarzGuns.PS1_Sight",
})

Railing.RegisterWeaponExclusions({ "MarzGuns.AA12", "MarzGuns.FNC", "MarzGuns.M60", "MarzGuns.AKS74U", "MarzGuns.ASVAL", "MarzGuns.FAMAS", "MarzGuns.CAR15" }, {
    "MarzGuns.Bipod_Folded",
    "MarzGuns.Bipod_Deployed",
})

Railing.RegisterWeaponExclusions({ "MarzGuns.SVD", "MarzGuns.PSG1" }, {
    "MarzGuns.Stub_Foregrip",
    "MarzGuns.MKC_Foregrip",
    "MarzGuns.MK2_Foregrip",
})

Railing.RegisterWeaponExclusions({ "MarzGuns.MP5", "MarzGuns.MP5K" }, {
    "MarzGuns.Booster_Scope",
    "MarzGuns.Booster_Scope_Off",
    "MarzGuns.ElcanX2_Scope",
    "MarzGuns.LR10X_Scope",
    "MarzGuns.TA28_Scope",
    "MarzGuns.LR4X_Scope",
    "MarzGuns.TR06X_Scope",
    "MarzGuns.PSO1_Scope",
    "MarzGuns.LRX12X_Scope",
})

Railing.RegisterWeaponExclusions({ "MarzGuns.FAMAS", "MarzGuns.MOSSBERG_590", "MarzGuns.BENELLI_M4", "MarzGuns.REMINGTON_870" }, {
    "MarzGuns.Booster_Scope",
    "MarzGuns.Booster_Scope_Off",
})

Railing.SetExclusives({ "MarzGuns.M203" }, {
    "MarzGuns.Stub_Foregrip",
    "MarzGuns.MKC_Foregrip",
    "MarzGuns.MK2_Foregrip",
    "MarzGuns.Bipod_Deployed",
    "MarzGuns.Bipod_Folded",
})
