local Bayonet = require("WeaponSystems/Utils/Bayonet")

-------------------------------------------------
-- Mountable Weapons (weapon -> bayonet attachment)
-------------------------------------------------
Bayonet.RegisterMountableWeapon({ "MarzGuns.K98_Bayonet_Attachment", "MarzGuns.M5_Bayonet_Attachment", "MarzGuns.M9_Bayonet_Attachment" }, {
    "MarzGuns.M16A1",
    "MarzGuns.M16A2",
    "MarzGuns.M16A3",
    "MarzGuns.AR15",
    "MarzGuns.FAMAS",
    "MarzGuns.M14",
    "MarzGuns.M1_GARAND",
    "MarzGuns.G3",
    "MarzGuns.MOSIN",
    "MarzGuns.M1903",
    "MarzGuns.MOSSBERG_590",
    "MarzGuns.BENELLI_M4",
    "MarzGuns.TRENCHGUN",
    "MarzGuns.REMINGTON_870" })

-------------------------------------------------
-- Bayonet Knives (knife -> bayonet attachment -> spear substitute)
-------------------------------------------------
Bayonet.RegisterBayonetKnife("MarzGuns.K98_BAYONET", "MarzGuns.K98_Bayonet_Attachment", "MarzGuns.Attack_Bayonet")
Bayonet.RegisterBayonetKnife("MarzGuns.M5_BAYONET", "MarzGuns.M5_Bayonet_Attachment", "MarzGuns.Attack_Bayonet")
Bayonet.RegisterBayonetKnife("MarzGuns.M9_BAYONET", "MarzGuns.M9_Bayonet_Attachment", "MarzGuns.Attack_Bayonet")

Bayonet.RegisterIntegratedBayonet("MarzGuns.SKS", {
    weaponRef   = "MarzGuns.Attack_Bayonet",
    attachments = {
        partType = "BayonetIntegrated",
        deployed = "MarzGuns.SKS_Bayonet_Deployed",
        folded = "MarzGuns.SKS_Bayonet_Folded"
    }
})

Bayonet.SetExclusives({ "MarzGuns.K98_Bayonet_Attachment", "MarzGuns.M5_Bayonet_Attachment", "MarzGuns.M9_Bayonet_Attachment" }, {
    "MarzGuns.MKI_Suppressor",
    "MarzGuns.NDR_Suppressor",
    "MarzGuns.PBS-1_Suppressor",
    "MarzGuns.LR2_Compensator",
    "MarzGuns.LX_Flashhider",
    "MarzGuns.Trix42_Muzzlebreak",
    "MarzGuns.M203",
})
