local MarzGuns_AttachmentPointsTable = {}

MarzGuns_AttachmentPointsTable.requiredAttachmentsForAttachments = {
    ["PRU"] = "MarzGuns.Picatinny_Rail_Up",
    ["PRD"] = "MarzGuns.Picatinny_Rail_Down",
    ["PRL"] = "MarzGuns.Picatinny_Rail_Left",
    ["PRR"] = "MarzGuns.Picatinny_Rail_Right",
    ["AM"] = "MarzGuns.AK_Mount",
    ["BM"] = "MarzGuns.Beretta_Mount",
    ["CM"] = "MarzGuns.Colt_Mount",
    ["HPR"] = "MarzGuns.Heavy_Pistol_Rail",
    ["SM"] = "MarzGuns.Sniper_Mount",
}

MarzGuns_AttachmentPointsTable.weaponAttachmentTablesAndChances = {

    ["MarzGuns.M16A1"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",
        },
    },

    ["MarzGuns.M16A2"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:50",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:2:PRD",
            "MarzGuns.MKC_Foregrip:2:PRD",
            "MarzGuns.MK2_Foregrip:2:PRD",

            "MarzGuns.AimRight_Laser:2:PRR",
            "MarzGuns.LRX-7_Laser:2:PRR",

            "MarzGuns.BrightPoint-5_Light:2:PRL",
            "MarzGuns.SR7_Light:2:PRL",
        },
    },

    ["MarzGuns.M16A2_M203"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.M16A2_M203_Integrated",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.M16A3"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.AR15"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:5",
            "MarzGuns.556x45Magazine75_STANAG:5",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",
        },
    },

    ["MarzGuns.CAR15"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.CAR15_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:50",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Stub_Foregrip:2:PRD",
            "MarzGuns.MKC_Foregrip:2:PRD",
            "MarzGuns.MK2_Foregrip:2:PRD",

            "MarzGuns.AimRight_Laser:2:PRR",
            "MarzGuns.LRX-7_Laser:2:PRR",

            "MarzGuns.BrightPoint-5_Light:2:PRL",
            "MarzGuns.SR7_Light:2:PRL",
        },
    },

    ["MarzGuns.XM177"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.XM177_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:50",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Stub_Foregrip:2:PRD",
            "MarzGuns.MKC_Foregrip:2:PRD",
            "MarzGuns.MK2_Foregrip:2:PRD",

            "MarzGuns.AimRight_Laser:2:PRR",
            "MarzGuns.LRX-7_Laser:2:PRR",

            "MarzGuns.BrightPoint-5_Light:2:PRL",
            "MarzGuns.SR7_Light:2:PRL",
        },
    },

    ["MarzGuns.M4A1"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.M4A1_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:50",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:2",
            "MarzGuns.556x45Magazine75_STANAG:2",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Stub_Foregrip:2:PRD",
            "MarzGuns.MKC_Foregrip:2:PRD",
            "MarzGuns.MK2_Foregrip:2:PRD",

            "MarzGuns.AimRight_Laser:2:PRR",
            "MarzGuns.LRX-7_Laser:2:PRR",

            "MarzGuns.BrightPoint-5_Light:2:PRL",
            "MarzGuns.SR7_Light:2:PRL",
        },
    },

    ["MarzGuns.FNC"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.FNC_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:5",
            "MarzGuns.556x45Magazine75_STANAG:5",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.M4"] = {
        ['required'] = {
            "MarzGuns.M4_Integrated_Rail_Up",
            "MarzGuns.M4_Integrated_Rail_Down",
            "MarzGuns.M4_Integrated_Rail_Left",
            "MarzGuns.M4_Integrated_Rail_Right"
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:5",
            "MarzGuns.556x45Magazine75_STANAG:5",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5",
            "MarzGuns.Kobra_Sight:5",
            "MarzGuns.OKP3_Sight:5",
            "MarzGuns.JS14_Sight:5",
            "MarzGuns.EXPS3_Sight:5",
            "MarzGuns.EXPS1_Sight:5",
            "MarzGuns.Aimpoint_Sight:5",

            "MarzGuns.LR4X_Scope:3",
            "MarzGuns.TA28_Scope:3",
            "MarzGuns.ElcanX2_Scope:3",

            "MarzGuns.TR06X_Scope:2",
            "MarzGuns.PSO1_Scope:2",
            "MarzGuns.LR10X_Scope:1",
            "MarzGuns.LRX12X_Scope:1",

            "MarzGuns.Stub_Foregrip:10",
            "MarzGuns.MKC_Foregrip:10",
            "MarzGuns.MK2_Foregrip:5",

            "MarzGuns.AimRight_Laser:5",
            "MarzGuns.LRX-7_Laser:5",

            "MarzGuns.BrightPoint-5_Light:10",
            "MarzGuns.SR7_Light:10",
        },
    },

    ["MarzGuns.G36C"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.G36C_Integrated_Rail_Up",
            "MarzGuns.G36C_Integrated_Rail_Down",
            "MarzGuns.G36C_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine30_G36:30",

            "MarzGuns.ReflexS2_Sight:5",
            "MarzGuns.Kobra_Sight:5",
            "MarzGuns.OKP3_Sight:5",
            "MarzGuns.JS14_Sight:5",
            "MarzGuns.EXPS3_Sight:5",
            "MarzGuns.EXPS1_Sight:5",
            "MarzGuns.Aimpoint_Sight:5",

            "MarzGuns.LR4X_Scope:3",
            "MarzGuns.TA28_Scope:3",
            "MarzGuns.ElcanX2_Scope:3",

            "MarzGuns.TR06X_Scope:1",
            "MarzGuns.PSO1_Scope:1",
            "MarzGuns.LR10X_Scope:1",
            "MarzGuns.LRX12X_Scope:1",

            "MarzGuns.Stub_Foregrip:10",
            "MarzGuns.MKC_Foregrip:10",
            "MarzGuns.MK2_Foregrip:5",
        },
    },

    ["MarzGuns.G36"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.G36_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine30_G36:30",

            "MarzGuns.Stub_Foregrip:10",
            "MarzGuns.MKC_Foregrip:10",
            "MarzGuns.MK2_Foregrip:5",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.AK74"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.545x39Magazine30_Bakelite:30",
            "MarzGuns.545x39Magazine45_Bakelite:30",
            "MarzGuns.545x39Magazine100_Drum:30",

            "MarzGuns.ReflexS2_Sight:5:AM",
            "MarzGuns.Kobra_Sight:5:AM",
            "MarzGuns.OKP3_Sight:5:AM",
            "MarzGuns.JS14_Sight:5:AM",
            "MarzGuns.EXPS3_Sight:5:AM",
            "MarzGuns.EXPS1_Sight:5:AM",
            "MarzGuns.Aimpoint_Sight:5:AM",

            "MarzGuns.LR4X_Scope:3:AM",
            "MarzGuns.TA28_Scope:3:AM",
            "MarzGuns.ElcanX2_Scope:3:AM",

            "MarzGuns.TR06X_Scope:1:AM",
            "MarzGuns.PSO1_Scope:1:AM",
            "MarzGuns.LR10X_Scope:1:AM",
            "MarzGuns.LRX12X_Scope:1:AM",
        },
    },

    ["MarzGuns.AKS74U"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.AKS74U_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.545x39Magazine30_Bakelite:30",
            "MarzGuns.545x39Magazine45_Bakelite:30",
            "MarzGuns.545x39Magazine100_Drum:30",

            "MarzGuns.ReflexS2_Sight:5:AM",
            "MarzGuns.Kobra_Sight:5:AM",
            "MarzGuns.OKP3_Sight:5:AM",
            "MarzGuns.JS14_Sight:5:AM",
            "MarzGuns.EXPS3_Sight:5:AM",
            "MarzGuns.EXPS1_Sight:5:AM",
            "MarzGuns.Aimpoint_Sight:5:AM",

            "MarzGuns.LR4X_Scope:1:AM",
            "MarzGuns.TA28_Scope:1:AM",
            "MarzGuns.ElcanX2_Scope:1:AM",

            "MarzGuns.TR06X_Scope:1:AM",
            "MarzGuns.PSO1_Scope:1:AM",
            "MarzGuns.LR10X_Scope:1:AM",
            "MarzGuns.LRX12X_Scope:1:AM",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",
        },
    },

    ["MarzGuns.ASVAL"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.ASVAL_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.9x39Magazine30:50",

            "MarzGuns.ReflexS2_Sight:5:AM",
            "MarzGuns.Kobra_Sight:5:AM",
            "MarzGuns.OKP3_Sight:5:AM",
            "MarzGuns.JS14_Sight:5:AM",
            "MarzGuns.EXPS3_Sight:5:AM",
            "MarzGuns.EXPS1_Sight:5:AM",
            "MarzGuns.Aimpoint_Sight:5:AM",

            "MarzGuns.LR4X_Scope:3:AM",
            "MarzGuns.TA28_Scope:3:AM",
            "MarzGuns.ElcanX2_Scope:3:AM",

            "MarzGuns.TR06X_Scope:1:AM",
            "MarzGuns.PSO1_Scope:1:AM",
            "MarzGuns.LR10X_Scope:1:AM",
            "MarzGuns.LRX12X_Scope:1:AM",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.FAMAS"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.556x45Magazine20_STANAG:30",
            "MarzGuns.556x45Magazine25_STANAG:30",
            "MarzGuns.556x45Magazine30_STANAG:30",
            "MarzGuns.556x45Magazine60_STANAG:10",
            "MarzGuns.556x45Magazine50_STANAG:5",
            "MarzGuns.556x45Magazine75_STANAG:5",
            "MarzGuns.556x45Magazine100_STANAG:2",
            "MarzGuns.556x45Magazine150_STANAG:1",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:3:PRU",
            "MarzGuns.TA28_Scope:3:PRU",
            "MarzGuns.ElcanX2_Scope:3:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",
        },
    },

    ["MarzGuns.AK47"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.762x39Magazine30:30",
            "MarzGuns.762x39Magazine75:1",

            "MarzGuns.ReflexS2_Sight:5:AM",
            "MarzGuns.Kobra_Sight:5:AM",
            "MarzGuns.OKP3_Sight:5:AM",
            "MarzGuns.JS14_Sight:5:AM",
            "MarzGuns.EXPS3_Sight:5:AM",
            "MarzGuns.EXPS1_Sight:5:AM",
            "MarzGuns.Aimpoint_Sight:5:AM",

            "MarzGuns.LR4X_Scope:3:AM",
            "MarzGuns.TA28_Scope:3:AM",
            "MarzGuns.ElcanX2_Scope:3:AM",

            "MarzGuns.TR06X_Scope:1:AM",
            "MarzGuns.PSO1_Scope:1:AM",
            "MarzGuns.LR10X_Scope:1:AM",
            "MarzGuns.LRX12X_Scope:1:AM",
        },
    },

    ["MarzGuns.M14"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.762x51Magazine20_M14:50",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",
        },
    },

    ["MarzGuns.M1_GARAND"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.3006Clip8:50",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",
        },
    },

    ["MarzGuns.FAL"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.762x51Magazine20_FAL:50",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.G3"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.762x51Magazine20_G3:50",

            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.MOSIN"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:1:SM",
            "MarzGuns.Kobra_Sight:1:SM",
            "MarzGuns.OKP3_Sight:1:SM",
            "MarzGuns.JS14_Sight:1:SM",
            "MarzGuns.EXPS3_Sight:1:SM",
            "MarzGuns.EXPS1_Sight:1:SM",
            "MarzGuns.Aimpoint_Sight:1:SM",

            "MarzGuns.LR4X_Scope:1:SM",
            "MarzGuns.TA28_Scope:1:SM",
            "MarzGuns.ElcanX2_Scope:1:SM",

            "MarzGuns.TR06X_Scope:5:SM",
            "MarzGuns.PSO1_Scope:5:SM",
            "MarzGuns.LR10X_Scope:5:SM",
            "MarzGuns.LRX12X_Scope:5:SM",
        },
    },

    ["MarzGuns.M1903"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:1:SM",
            "MarzGuns.Kobra_Sight:1:SM",
            "MarzGuns.OKP3_Sight:1:SM",
            "MarzGuns.JS14_Sight:1:SM",
            "MarzGuns.EXPS3_Sight:1:SM",
            "MarzGuns.EXPS1_Sight:1:SM",
            "MarzGuns.Aimpoint_Sight:1:SM",

            "MarzGuns.LR4X_Scope:1:SM",
            "MarzGuns.TA28_Scope:1:SM",
            "MarzGuns.ElcanX2_Scope:1:SM",

            "MarzGuns.TR06X_Scope:5:SM",
            "MarzGuns.PSO1_Scope:5:SM",
            "MarzGuns.LR10X_Scope:5:SM",
            "MarzGuns.LRX12X_Scope:5:SM",
        },
    },

    ["MarzGuns.M24"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.M24_Integrated_Bipod_Folded",
        },
        ['optionals'] = {
            "MarzGuns.762x51Magazine5_M24:50",

            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:1:PRU",
            "MarzGuns.TA28_Scope:1:PRU",
            "MarzGuns.ElcanX2_Scope:1:PRU",

            "MarzGuns.TR06X_Scope:5:PRU",
            "MarzGuns.PSO1_Scope:5:PRU",
            "MarzGuns.LR10X_Scope:5:PRU",
            "MarzGuns.LRX12X_Scope:5:PRU",
        },
    },

    ["MarzGuns.M79"] = {
        ['required'] = {
            "MarzGuns.Barrel_Close",
        }
    },

    ["MarzGuns.W1894"] = {
        ['required'] = {
            "MarzGuns.Lever_Lock",
        },
        ['optionals'] = {
            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.M1895"] = {
        ['required'] = {
            "MarzGuns.Lever_Lock",
        },
        ['optionals'] = {
            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.W1887"] = {
        ['required'] = {
            "MarzGuns.Lever_Lock",
        },
        ['optionals'] = {
            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.W1873"] = {
        ['required'] = {
            "MarzGuns.Lever_Lock",
        },
        ['optionals'] = {
            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.W1873_CARBINE"] = {
        ['required'] = {
            "MarzGuns.Lever_Lock",
        },
    },

    ["MarzGuns.M60"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.M60_Integrated_Bipod_Folded"
        },
        ['optionals'] = {
            "MarzGuns.762x51Box100_M60:50",
        },
    },

    ["MarzGuns.BAR"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.BAR_Integrated_Bipod_Folded",
        },
        ['optionals'] = {
            "MarzGuns.3006Magazine20_BAR:50",
        },
    },

    ["MarzGuns.M92FS"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine15_M92FS:50",
            "MarzGuns.9x19Magazine30_M92FS:10",
            "MarzGuns.9x19Magazine50_M92FS:5",

            "MarzGuns.PL4_Sight:5:BM",
            "MarzGuns.PM2_Sight:5:BM",
            "MarzGuns.PS1_Sight:5:BM",

            "MarzGuns.PJ-3_Laser:5",
            "MarzGuns.PX1_Laser:5",
            "MarzGuns.TR-1_Laser:5",
            "MarzGuns.LP_Light:5",
            "MarzGuns.TL_Light:5",

            "MarzGuns.Beretta_Stock_Deployed:5",
            "MarzGuns.Beretta_Stock_Folded:5",
        },
    },

    ["MarzGuns.M93R"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine18_M93R:20",
            "MarzGuns.9x19Magazine60_M93R:5",

            "MarzGuns.PL4_Sight:5:BM",
            "MarzGuns.PM2_Sight:5:BM",
            "MarzGuns.PS1_Sight:5:BM",

            "MarzGuns.Beretta_Stock_Deployed:5",
            "MarzGuns.Beretta_Stock_Folded:5",
        },
    },

    ["MarzGuns.HIPOWER"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine13_HIPOWER:20",

            "MarzGuns.PL4_Sight:5:BM",
            "MarzGuns.PM2_Sight:5:BM",
            "MarzGuns.PS1_Sight:5:BM",

            "MarzGuns.PJ-3_Laser:5",
            "MarzGuns.PX1_Laser:5",
            "MarzGuns.TR-1_Laser:5",
            "MarzGuns.LP_Light:5",
            "MarzGuns.TL_Light:5",
        },
    },

    ["MarzGuns.P226"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine10_P226:20",

            "MarzGuns.PL4_Sight:5:BM",
            "MarzGuns.PM2_Sight:5:BM",
            "MarzGuns.PS1_Sight:5:BM",

            "MarzGuns.PJ-3_Laser:5",
            "MarzGuns.PX1_Laser:5",
            "MarzGuns.TR-1_Laser:5",
            "MarzGuns.LP_Light:5",
            "MarzGuns.TL_Light:5",
        },
    },

    ["MarzGuns.VP70M"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine18_VP70M:20",
            "MarzGuns.9x19Magazine30_VP70M:20",
        },
    },

    ["MarzGuns.M1911"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.45Magazine7_M1911:20",

            "MarzGuns.PL4_Sight:5:CM",
            "MarzGuns.PM2_Sight:5:CM",
            "MarzGuns.PS1_Sight:5:CM",

            "MarzGuns.PJ-3_Laser:5",
            "MarzGuns.PX1_Laser:5",
            "MarzGuns.TR-1_Laser:5",
            "MarzGuns.LP_Light:5",
            "MarzGuns.TL_Light:5",
        },
    },

    ["MarzGuns.USP"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.45Magazine12_USP:20",
            "MarzGuns.45Magazine20_USP:5",

            "MarzGuns.PL4_Sight:5:CM",
            "MarzGuns.PM2_Sight:5:CM",
            "MarzGuns.PS1_Sight:5:CM",

            "MarzGuns.PJ-3_Laser:5",
            "MarzGuns.PX1_Laser:5",
            "MarzGuns.TR-1_Laser:5",
            "MarzGuns.LP_Light:5",
            "MarzGuns.TL_Light:5",
        },
    },

    ["MarzGuns.DEAGLE"] = {
        ['required'] = {
            "MarzGuns.Slide_Lock",
        },
        ['optionals'] = {
            "MarzGuns.50Magazine8_DEAGLE:20",
            "MarzGuns.50Magazine12_DEAGLE:5",

            "MarzGuns.PL4_Sight:5:HPR",
            "MarzGuns.PM2_Sight:5:HPR",
            "MarzGuns.PS1_Sight:5:HPR",
            "MarzGuns.PRL1_Scope:5:HPR",

            "MarzGuns.PJ-3_Laser:5",
            "MarzGuns.PX1_Laser:5",
            "MarzGuns.TR-1_Laser:5",
            "MarzGuns.LP_Light:5",
            "MarzGuns.TL_Light:5",
        },
    },

    ["MarzGuns.SVD"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.762x54Magazine10_SVD:50",

            "MarzGuns.ReflexS2_Sight:1:AM",
            "MarzGuns.Kobra_Sight:1:AM",
            "MarzGuns.OKP3_Sight:1:AM",
            "MarzGuns.JS14_Sight:1:AM",
            "MarzGuns.EXPS3_Sight:1:AM",
            "MarzGuns.EXPS1_Sight:1:AM",
            "MarzGuns.Aimpoint_Sight:1:AM",

            "MarzGuns.LR4X_Scope:5:AM",
            "MarzGuns.TA28_Scope:5:AM",
            "MarzGuns.ElcanX2_Scope:5:AM",

            "MarzGuns.TR06X_Scope:1:AM",
            "MarzGuns.PSO1_Scope:1:AM",
            "MarzGuns.LR10X_Scope:1:AM",
            "MarzGuns.LRX12X_Scope:1:AM",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:2:PRD",
            "MarzGuns.MKC_Foregrip:2:PRD",
            "MarzGuns.MK2_Foregrip:2:PRD",
        },
    },

    ["MarzGuns.SKS"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
    },

    ["MarzGuns.PSG1"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.762x51Magazine5_PSG1:50",

            "MarzGuns.ReflexS2_Sight:1:PRU",
            "MarzGuns.Kobra_Sight:1:PRU",
            "MarzGuns.OKP3_Sight:1:PRU",
            "MarzGuns.JS14_Sight:1:PRU",
            "MarzGuns.EXPS3_Sight:1:PRU",
            "MarzGuns.EXPS1_Sight:1:PRU",
            "MarzGuns.Aimpoint_Sight:1:PRU",

            "MarzGuns.LR4X_Scope:5:PRU",
            "MarzGuns.TA28_Scope:5:PRU",
            "MarzGuns.ElcanX2_Scope:5:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",

            "MarzGuns.Stub_Foregrip:2:PRD",
            "MarzGuns.MKC_Foregrip:2:PRD",
            "MarzGuns.MK2_Foregrip:2:PRD",
        },
    },

    ["MarzGuns.MOSSBERG_590"] = {
        ['required'] = {
            "MarzGuns.Pump_Lock",
        },
        ['optionals'] = {
            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:1:PRU",
            "MarzGuns.TA28_Scope:1:PRU",
            "MarzGuns.ElcanX2_Scope:1:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Bipod_Deployed:5:PRD",
            "MarzGuns.Bipod_Folded:5:PRD",
        },
    },

    ["MarzGuns.TRENCHGUN"] = {
        ['required'] = {
            "MarzGuns.Pump_Lock",
        },
        ['optionals'] = {
            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",
        },
    },

    ["MarzGuns.BENELLI_M4"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:1:PRU",
            "MarzGuns.TA28_Scope:1:PRU",
            "MarzGuns.ElcanX2_Scope:1:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.SPAS12"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.SPAS12_Integrated_Stock_Folded",
        },
    },

    ["MarzGuns.STEVENS_555"] = {
        ['required'] = {
            "MarzGuns.Barrel_Close",
        },
        ['optional'] = {
            'MarzGuns.Shellholder:5'
        }
    },

    ["MarzGuns.DOUBLEBARREL"] = {
        ['required'] = {
            "MarzGuns.Barrel_Close",
        },
        ['optional'] = {
            'MarzGuns.Shellholder:5'
        }
    },

    ["MarzGuns.TOZ34"] = {
        ['required'] = {
            "MarzGuns.Barrel_Close",
        },
    },

    ["MarzGuns.AA12"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.12GMagazine8_AA12:30",
            "MarzGuns.12GMagazine20_AA12:30",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:1:PRU",
            "MarzGuns.TA28_Scope:1:PRU",
            "MarzGuns.ElcanX2_Scope:1:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",

            "MarzGuns.Stub_Foregrip:5:PRD",
            "MarzGuns.MKC_Foregrip:5:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",
        },
    },

    ["MarzGuns.REMINGTON_870"] = {
        ['required'] = {
            "MarzGuns.Pump_Lock",
        },
        ['optionals'] = {
            "MarzGuns.M5_Bayonet_Attachment:10",
            "MarzGuns.M9_Bayonet_Attachment:10",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.LR4X_Scope:1:PRU",
            "MarzGuns.TA28_Scope:1:PRU",
            "MarzGuns.ElcanX2_Scope:1:PRU",

            "MarzGuns.TR06X_Scope:1:PRU",
            "MarzGuns.PSO1_Scope:1:PRU",
            "MarzGuns.LR10X_Scope:1:PRU",
            "MarzGuns.LRX12X_Scope:1:PRU",
        },
    },

    ["MarzGuns.THOMPSON"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.45Magazine20_THOMPSON:30",
            "MarzGuns.45Magazine30_THOMPSON:20",
            "MarzGuns.45Magazine100_THOMPSON:5",
        },
    },

    ["MarzGuns.MP5"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.MP5_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine20_MP5:30",
            "MarzGuns.9x19Magazine25_MP5:20",
            "MarzGuns.9x19Magazine30_MP5:5",
            "MarzGuns.9x19Magazine60_MP5:2",
            "MarzGuns.9x19Magazine100_MP5:2",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.MP5K"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine20_MP5:30",
            "MarzGuns.9x19Magazine25_MP5:20",
            "MarzGuns.9x19Magazine30_MP5:5",
            "MarzGuns.9x19Magazine60_MP5:2",
            "MarzGuns.9x19Magazine100_MP5:2",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",
        },
    },

    ["MarzGuns.MP5A2"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine20_MP5:30",
            "MarzGuns.9x19Magazine25_MP5:20",
            "MarzGuns.9x19Magazine30_MP5:5",
            "MarzGuns.9x19Magazine60_MP5:2",
            "MarzGuns.9x19Magazine100_MP5:2",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.MP5SD"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.MP5SD_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine20_MP5:30",
            "MarzGuns.9x19Magazine25_MP5:20",
            "MarzGuns.9x19Magazine30_MP5:5",
            "MarzGuns.9x19Magazine60_MP5:2",
            "MarzGuns.9x19Magazine100_MP5:2",

            "MarzGuns.ReflexS2_Sight:5:PRU",
            "MarzGuns.Kobra_Sight:5:PRU",
            "MarzGuns.OKP3_Sight:5:PRU",
            "MarzGuns.JS14_Sight:5:PRU",
            "MarzGuns.EXPS3_Sight:5:PRU",
            "MarzGuns.EXPS1_Sight:5:PRU",
            "MarzGuns.Aimpoint_Sight:5:PRU",

            "MarzGuns.Stub_Foregrip:10:PRD",
            "MarzGuns.MKC_Foregrip:10:PRD",
            "MarzGuns.MK2_Foregrip:5:PRD",

            "MarzGuns.AimRight_Laser:5:PRR",
            "MarzGuns.LRX-7_Laser:5:PRR",

            "MarzGuns.BrightPoint-5_Light:10:PRL",
            "MarzGuns.SR7_Light:10:PRL",
        },
    },

    ["MarzGuns.TEC9"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
        },
        ['optionals'] = {
            "MarzGuns.9x19Magazine20_TEC9:30",
        },
    },

    ["MarzGuns.MAC10"] = {
        ['required'] = {
            "MarzGuns.Bolt_Lock",
            "MarzGuns.MAC10_Integrated_Stock_Folded",
        },
        ['optionals'] = {
            "MarzGuns.45Magazine30_MAC10:30",
            "MarzGuns.45Magazine40_MAC10:20",
        },
    },

    ["MarzGuns.SW629"] = {
        ['optionals'] = {
            "MarzGuns.PL4_Sight:5:HPR",
            "MarzGuns.PM2_Sight:5:HPR",
            "MarzGuns.PS1_Sight:5:HPR",
            "MarzGuns.PRL1_Scope:5:HPR",
        },
    },

    ["MarzGuns.PYTHON"] = {
        ['optionals'] = {
            "MarzGuns.PL4_Sight:5:HPR",
            "MarzGuns.PM2_Sight:5:HPR",
            "MarzGuns.PS1_Sight:5:HPR",
            "MarzGuns.PRL1_Scope:5:HPR",
        },
    },

    ["MarzGuns.Elvorenstein_Tacticool_Knife"] = {
        ['required'] = {
            "MarzGuns.LRX12X_Scope",
            "MarzGuns.Bipod_Deployed",
        },
    },
}

return MarzGuns_AttachmentPointsTable
