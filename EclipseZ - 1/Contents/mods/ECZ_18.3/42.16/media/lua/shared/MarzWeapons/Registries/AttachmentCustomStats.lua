local CSA = require("WeaponSystems/Utils/CustomStatsAttachments")
local SF  = require("WeaponSystems/Utils/StatsFactory")
local DA  = require("WeaponSystems/Utils/DynamicAttachment")

CSA.RegisterRestoreStats({
    "AimingTime",
    "CriticalChance",
    "HitChance",
    "UseEndurance",
    "EnduranceMod",
    "HitChance",
    "MaxSightRange",
    "MinSightRange",
    "SwingSound",
    "SoundRadius",
    "SoundVolume",
    "MuzzleFlashModelKey",
    "MaxDamage",
    "MinDamage",
    "RecoilDelay",
    "WeaponSprite",
})

DA.RegisterPair("MarzGuns.Bipod_Deployed", "MarzGuns.Bipod_Folded")
DA.RegisterPair("MarzGuns.Beretta_Stock_Deployed", "MarzGuns.Beretta_Stock_Folded")
DA.RegisterPair("MarzGuns.Booster_Scope", "MarzGuns.Booster_Scope_Off")

CSA.RegisterMultipleParts({
    ["MarzGuns.M60_Integrated_Bipod_Deployed"] = {
        SF.Multiply("AimingTime", 1.3),
        SF.Multiply("CriticalChance", 1.1),
        SF.Multiply("HitChance", 1.1),
        SF.Set("UseEndurance", false),
    },
    ["MarzGuns.M60_Integrated_Bipod_Folded"] = {
        SF.Set("UseEndurance", true),
        SF.Set("EnduranceMod", 0.3),
        SF.Multiply("HitChance", 0.8),
    },

    ["MarzGuns.BAR_Integrated_Bipod_Deployed"] = {
        SF.Multiply("AimingTime", 1.2),
        SF.Multiply("CriticalChance", 1.25),
        SF.Multiply("HitChance", 1.25),
    },
    ["MarzGuns.BAR_Integrated_Bipod_Folded"] = {
        -- Nada
    },

    ["MarzGuns.AKS74U_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.AKS74U_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.25),
        SF.Multiply("AimingTime", 0.85),
    },

    ["MarzGuns.ASVAL_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.ASVAL_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.9),
    },

    ["MarzGuns.FNC_Integrated_Stock_Folded"] = {
        -- Nada
    },
    ["MarzGuns.FNC_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.95),
    },

    ["MarzGuns.G36C_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.G36C_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.75),
    },

    ["MarzGuns.G36_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.G36_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.85),
    },

    ["MarzGuns.CAR15_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.CAR15_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.85),
    },

    ["MarzGuns.SPAS12_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.SPAS12_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.1),
        SF.Multiply("AimingTime", 0.9),
    },

    ["MarzGuns.MP5_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.MP5_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.75),
    },

    ["MarzGuns.MP5SD_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.MP5SD_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("AimingTime", 0.75),
    },

    ["MarzGuns.MAC10_Integrated_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.MAC10_Integrated_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.1),
        SF.Multiply("AimingTime", 0.9),
    },

    ["MarzGuns.Beretta_Stock_Folded"] = {
        -- nothing, we gonna use base stats
    },
    ["MarzGuns.Beretta_Stock_Deployed"] = {
        SF.Multiply("HitChance", 1.1),
        SF.Multiply("AimingTime", 0.9),
    },

    ["MarzGuns.Booster_Scope"] = {
        SF.Multiply("CriticalChance", 1.05),
        SF.Multiply("HitChance", 1.05),
        SF.Multiply("MaxSightRange", 1.05),
        SF.Multiply("MinSightRange", 1.05),
    },
    ["MarzGuns.Booster_Scope_Off"] = {
        -- Nothing so it serves as a base return to the original stats when toggled off
    },

    ["MarzGuns.Bipod_Deployed"] = {
        SF.Multiply("AimingTime", 1.1),
        SF.Multiply("CriticalChance", 1.15),
        SF.Multiply("HitChance", 1.15),
    },
    ["MarzGuns.Bipod_Folded"] = {
        -- Nothing so it serves as a base return to the original stats when toggled off, this is not needed btw, I just like having it.
    },

    ["MarzGuns.Stub_Foregrip"] = {
        SF.Multiply("AimingTime", 0.8),
        SF.Multiply("CriticalChance", 1.15),
        SF.Multiply("HitChance", 1.15),
    },
    ["MarzGuns.MKC_Foregrip"] = {
        SF.Multiply("AimingTime", 0.95),
        SF.Multiply("CriticalChance", 1.25),
        SF.Multiply("HitChance", 1.25),
    },
    ["MarzGuns.MK2_Foregrip"] = {
        SF.Multiply("AimingTime", 0.75),
        SF.Multiply("CriticalChance", 1.1),
        SF.Multiply("HitChance", 1.1),
    },

    -- Short Sights Long Guns
    ["MarzGuns.ReflexS2_Sight"] = {
        SF.Multiply("AimingTime", 0.9),
        SF.Multiply("CriticalChance", 1.05),
        SF.Multiply("HitChance", 1.05),
    },
    ["MarzGuns.Kobra_Sight"] = {
        SF.Multiply("AimingTime", 0.92),
        SF.Multiply("CriticalChance", 1.1),
        SF.Multiply("HitChance", 1.1),
    },
    ["MarzGuns.OKP3_Sight"] = {
        SF.Multiply("AimingTime", 0.95),
        SF.Multiply("CriticalChance", 1.15),
        SF.Multiply("HitChance", 1.15),
    },
    ["MarzGuns.JS14_Sight"] = {
        SF.Multiply("CriticalChance", 1.2),
        SF.Multiply("HitChance", 1.2),
    },
    ["MarzGuns.EXPS3_Sight"] = {
        SF.Multiply("CriticalChance", 1.02),
        SF.Multiply("HitChance", 1.02),
        SF.Multiply("MaxSightRange", 1.1),
        SF.Multiply("MinSightRange", 1.1),
    },
    ["MarzGuns.EXPS1_Sight"] = {
        SF.Multiply("CriticalChance", 1.02),
        SF.Multiply("HitChance", 1.02),
        SF.Multiply("MaxSightRange", 1.12),
        SF.Multiply("MinSightRange", 1.12),
    },
    ["MarzGuns.Aimpoint_Sight"] = {
        SF.Multiply("CriticalChance", 1.03),
        SF.Multiply("HitChance", 1.03),
        SF.Multiply("MaxSightRange", 1.15),
        SF.Multiply("MinSightRange", 1.15),
    },

    -- Mid Range Scopes
    ["MarzGuns.LR4X_Scope"] = {
        SF.Multiply("AimingTime", 1.1),
        SF.Multiply("CriticalChance", 1.06),
        SF.Multiply("HitChance", 1.06),
        SF.Multiply("MaxSightRange", 1.2),
        SF.Multiply("MinSightRange", 1.2),
    },
    ["MarzGuns.TA28_Scope"] = {
        SF.Multiply("AimingTime", 1.15),
        SF.Multiply("CriticalChance", 1.1),
        SF.Multiply("HitChance", 1.1),
        SF.Multiply("MaxSightRange", 1.25),
        SF.Multiply("MinSightRange", 1.25),
    },
    ["MarzGuns.ElcanX2_Scope"] = {
        SF.Multiply("AimingTime", 1.2),
        SF.Multiply("CriticalChance", 1.12),
        SF.Multiply("HitChance", 1.12),
        SF.Multiply("MaxSightRange", 1.25),
        SF.Multiply("MinSightRange", 1.25),
    },

    -- Long-Range Scopes
    ["MarzGuns.TR06X_Scope"] = {
        SF.Multiply("AimingTime", 1.25),
        SF.Multiply("CriticalChance", 1.15),
        SF.Multiply("HitChance", 1.15),
        SF.Multiply("MaxSightRange", 1.3),
        SF.Multiply("MinSightRange", 1.3),
    },
    ["MarzGuns.PSO1_Scope"] = {
        SF.Multiply("AimingTime", 1.30),
        SF.Multiply("CriticalChance", 1.20),
        SF.Multiply("HitChance", 1.20),
        SF.Multiply("MaxSightRange", 1.5),
        SF.Multiply("MinSightRange", 1.5),
    },
    ["MarzGuns.LR10X_Scope"] = {
        SF.Multiply("AimingTime", 1.35),
        SF.Multiply("CriticalChance", 1.3),
        SF.Multiply("HitChance", 1.3),
        SF.Multiply("MaxSightRange", 1.7),
        SF.Multiply("MinSightRange", 1.7),
    },
    ["MarzGuns.LRX12X_Scope"] = {
        SF.Multiply("AimingTime", 1.5),
        SF.Multiply("CriticalChance", 1.50),
        SF.Multiply("HitChance", 1.50),
        SF.Multiply("MaxSightRange", 2.0),
        SF.Multiply("MinSightRange", 2.0),
    },

    -- Pistol Scopes
    ["MarzGuns.PL4_Sight"] = {
        SF.Multiply("CriticalChance", 1.02),
        SF.Multiply("HitChance", 1.02),
    },
    ["MarzGuns.PS1_Sight"] = {
        SF.Multiply("CriticalChance", 1.03),
        SF.Multiply("HitChance", 1.03),
    },
    ["MarzGuns.PM2_Sight"] = {
        SF.Multiply("CriticalChance", 1.08),
        SF.Multiply("HitChance", 1.08),
        SF.Multiply("MaxSightRange", 1.08),
        SF.Multiply("MinSightRange", 1.08),
    },
    ["MarzGuns.PRL1_Scope"] = {
        SF.Multiply("CriticalChance", 1.1),
        SF.Multiply("HitChance", 1.1),
        SF.Multiply("MaxSightRange", 1.1),
        SF.Multiply("MinSightRange", 1.1),
    },

    -- 556mm Suppressors
    ["MarzGuns.MKI_Suppressor"] = {
        SF.Multiply("SoundRadius", 0.3),
        SF.Multiply("SoundVolume", 0.3),
        SF.Multiply("MaxDamage", 0.9),
        SF.Multiply("MinDamage", 0.9),
        SF.Set("SwingSound", "CapGunRevolverShoot"),
        SF.Set("MuzzleFlashModelKey", nil),
    },
    ["MarzGuns.NDR_Suppressor"] = {
        SF.Multiply("SoundRadius", 0.3),
        SF.Multiply("SoundVolume", 0.3),
        SF.Multiply("MaxDamage", 0.9),
        SF.Multiply("MinDamage", 0.9),
        SF.Set("SwingSound", "CapGunRevolverShoot"),
        SF.Set("MuzzleFlashModelKey", nil),
    },

    -- 545mm Suppressors
    ["MarzGuns.PBS-1_Suppressor"] = {
        SF.Multiply("SoundRadius", 0.3),
        SF.Multiply("SoundVolume", 0.3),
        SF.Multiply("MaxDamage", 0.9),
        SF.Multiply("MinDamage", 0.9),
        SF.Set("SwingSound", "CapGunRevolverShoot"),
        SF.Set("MuzzleFlashModelKey", nil),
    },

    -- 9x19mm Suppressors
    ["MarzGuns.M&P_Suppressor"] = {
        SF.Multiply("SoundRadius", 0.3),
        SF.Multiply("SoundVolume", 0.3),
        SF.Multiply("MaxDamage", 0.9),
        SF.Multiply("MinDamage", 0.9),
        SF.Set("SwingSound", "CapGunRifleShoot"),
        SF.Set("MuzzleFlashModelKey", nil),
    },
    ["MarzGuns.Shh9_Suppressor"] = {
        SF.Multiply("SoundRadius", 0.3),
        SF.Multiply("SoundVolume", 0.3),
        SF.Multiply("MaxDamage", 0.9),
        SF.Multiply("MinDamage", 0.9),
        SF.Set("SwingSound", "CapGunRifleShoot"),
        SF.Set("MuzzleFlashModelKey", nil),
    },

    --.45 ACP Suppressors
    ["MarzGuns.P45_Suppressor"] = {
        SF.Multiply("SoundRadius", 0.3),
        SF.Multiply("SoundVolume", 0.3),
        SF.Multiply("MaxDamage", 0.9),
        SF.Multiply("MinDamage", 0.9),
        SF.Set("SwingSound", "CapGunRifleShoot"),
        SF.Set("MuzzleFlashModelKey", nil),
    },

    ["MarzGuns.LR2_Compensator"] = {
        SF.Multiply("SoundRadius", 0.90),
        SF.Multiply("SoundVolume", 0.90),
        SF.Set("MuzzleFlashModelKey", nil),
    },
    ["MarzGuns.LX_Flashhider"] = {
        SF.Multiply("SoundRadius", 0.95),
        SF.Multiply("SoundVolume", 0.95),
        SF.Set("MuzzleFlashModelKey", nil),
    },
    ["MarzGuns.Trix42_Muzzlebreak"] = {
        SF.Multiply("SoundRadius", 0.95),
        SF.Multiply("SoundVolume", 0.95),
        SF.Set("MuzzleFlashModelKey", nil),
    },

    ["MarzGuns.AimRight_Laser"] = {
        SF.Multiply("AimingTime", 0.95),
        SF.Multiply("CriticalChance", 1.05),
        SF.Multiply("HitChance", 1.05),
    },
    ["MarzGuns.LRX-7_Laser"] = {
        SF.Multiply("AimingTime", 0.9),
        SF.Multiply("CriticalChance", 1.03),
        SF.Multiply("HitChance", 1.03),
    },

    ["MarzGuns.PJ-3_Laser"] = {
        SF.Multiply("AimingTime", 0.9),
        SF.Multiply("CriticalChance", 1.03),
        SF.Multiply("HitChance", 1.03),
    },
    ["MarzGuns.PX1_Laser"] = {
        SF.Multiply("AimingTime", 0.9),
        SF.Multiply("CriticalChance", 1.03),
        SF.Multiply("HitChance", 1.03),
    },
    ["MarzGuns.TR-1_Laser"] = {
        SF.Multiply("AimingTime", 0.9),
        SF.Multiply("CriticalChance", 1.03),
        SF.Multiply("HitChance", 1.03),
    },

    ["MarzGuns.Shellholder"] = {
        SF.Multiply("RecoilDelay", 0.6),
    },
})
