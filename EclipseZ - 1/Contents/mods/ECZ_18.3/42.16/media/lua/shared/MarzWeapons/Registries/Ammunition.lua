local Ammo = require("WeaponSystems/Utils/Ammo")
local StatsFactory = require("WeaponSystems/Utils/StatsFactory")

-------------------------------------------------
-- Restore Stats: stats that ammo profiles may modify
-------------------------------------------------
Ammo.RegisterRestoreStats({
    "MaxDamage",
    "MinDamage",
    "MaxRange",
    "MinRange",
    "CritDmgMultiplier",
    "ProjectileCount",
    "MaxHitCount",
    "CriticalChance",
    "PiercingBullets",
    "SoundRadius",
    "SoundVolume",
    "RackAfterShot",
    "ConditionLowerChanceOneIn",
    "MuzzleFlashModelKey",
})

-------------------------------------------------
-- Item -> Ammo Family mappings
-------------------------------------------------
Ammo.RegisterMultipleItemsWithFamilies({
    ["5.56x45mm"] = {
        "MarzGuns.556x45Magazine20_STANAG",
        "MarzGuns.556x45Magazine25_STANAG",
        "MarzGuns.556x45Magazine30_STANAG",
        "MarzGuns.556x45Magazine50_STANAG",
        "MarzGuns.556x45Magazine75_STANAG",
        "MarzGuns.556x45Magazine100_STANAG",
        "MarzGuns.556x45Magazine150_STANAG",
        "MarzGuns.556x45Magazine60_STANAG",
        "MarzGuns.556x45Magazine30_G36",
        "Base.556Clip",
        "Base.JS14_Clip",
        "Base.VarmintRifle",
    },

    ["7.62x51mm"] = {
        "MarzGuns.762x51Magazine20_M14",
        "MarzGuns.762x51Magazine20_FAL",
        "MarzGuns.762x51Magazine20_G3",
        "MarzGuns.762x51Magazine5_M24",
        "MarzGuns.762x51Box100_M60",
        "MarzGuns.762x51Magazine5_PSG1",
        "Base.M14Clip",
        "Base.HuntingRifle",
        "Base.MSR7T_Rifle",
    },

    ["12Gauge"] = {
        "MarzGuns.MOSSBERG_590",
        "MarzGuns.TRENCHGUN",
        "MarzGuns.BENELLI_M4",
        "MarzGuns.SPAS12",
        "MarzGuns.STEVENS_555",
        "MarzGuns.DOUBLEBARREL",
        "MarzGuns.REMINGTON_870",
        "MarzGuns.12GMagazine8_AA12",
        "MarzGuns.12GMagazine20_AA12",
        "MarzGuns.W1887",
        "Base.DoubleBarrelShotgun",
        "Base.DoubleBarrelShotgunSawnoff",
        "Base.JS3T_Shotgun",
        "Base.Shotgun",
        "Base.ShotgunSawnoff",
    },

    [".30-30 Winchester"] = {
        "MarzGuns.W1894",
        "Base.L94_Rifle",
    },

    [".357 Magnum"] = {
        "MarzGuns.PYTHON",
        "MarzGuns.RHINO",
        "MarzGuns.357SpeedLoader6_PYTHON",
        "MarzGuns.W1873",
        "MarzGuns.W1873_CARBINE",
        "Base.Revolver",
        "Base.L92_Carbine",
    },

    [".38 Special"] = {
        "MarzGuns.MP412",
        "MarzGuns.DETECTIVE_38",
        "Base.Revolver_Short",
    },

    [".44 Magnum"] = {
        "MarzGuns.SW629",
        "Base.44Clip",
        "Base.Revolver_Long",
    },

    [".45 ACP"] = {
        "MarzGuns.COLT_SINGLE",
        "MarzGuns.45Magazine7_M1911",
        "MarzGuns.45Magazine12_USP",
        "MarzGuns.45Magazine20_USP",
        "MarzGuns.45Magazine30_THOMPSON",
        "MarzGuns.45Magazine20_THOMPSON",
        "MarzGuns.45Magazine100_THOMPSON",
        "MarzGuns.45Magazine20_MAC10",
        "MarzGuns.45Magazine30_MAC10",
        "Base.45Clip",
    },

    ["9x19mm"] = {
        "MarzGuns.9x19Magazine15_M92FS",
        "MarzGuns.9x19Magazine30_M92FS",
        "MarzGuns.9x19Magazine50_M92FS",
        "MarzGuns.9x19Magazine18_M93R",
        "MarzGuns.9x19Magazine60_M93R",
        "MarzGuns.9x19Magazine13_HIPOWER",
        "MarzGuns.9x19Magazine10_P226",
        "MarzGuns.9x19Magazine20_MP5",
        "MarzGuns.9x19Magazine25_MP5",
        "MarzGuns.9x19Magazine30_MP5",
        "MarzGuns.9x19Magazine60_MP5",
        "MarzGuns.9x19Magazine100_MP5",
        "MarzGuns.9x19Magazine20_TEC9",
        "MarzGuns.9x19Magazine18_VP70M",
        "MarzGuns.9x19Magazine30_VP70M",
        "Base.9mmClip",
    },

    ["40mm"] = {
        "MarzGuns.M79",
    },
})

-------------------------------------------------
-- Ammo Families (bullet types per caliber)
-------------------------------------------------
Ammo.RegisterMultipleAmmoFamilies({
    ["5.56x45mm"] = {
        { type = "MarzGuns.556x45_Bullet",               enum = MarzGuns_AmmoTypes.BULLET_556x45,               profile = "556x45mmBaseAmmo" },
        { type = "MarzGuns.223_Bullet",                  enum = MarzGuns_AmmoTypes.BULLET_223,                  profile = "556x45mmCivilianAmmo" },
        { type = "MarzGuns.556x45_Bullet_ArmorPiercing", enum = MarzGuns_AmmoTypes.BULLET_556x45_ArmorPiercing, profile = "556x45mmArmorPiercingAmmo" },
        { type = "MarzGuns.556x45_Bullet_HollowPoint",   enum = MarzGuns_AmmoTypes.BULLET_556x45_HollowPoint,   profile = "556x45mmHollowPointAmmo" },
        { type = "MarzGuns.556x45_Bullet_Overpressured", enum = MarzGuns_AmmoTypes.BULLET_556x45_Overpressured, profile = "556x45mmOverpressuredAmmo" },
        { type = "MarzGuns.556x45_Bullet_Subsonic",      enum = MarzGuns_AmmoTypes.BULLET_556x45_Subsonic,      profile = "556x45mmSubsonicAmmo" },
        { type = "Base.556Bullets",                      enum = AmmoType.BULLETS_556,                           profile = "556x45mmBaseAmmo" },
    },

    ["7.62x51mm"] = {
        { type = "MarzGuns.762x51_Bullet", enum = MarzGuns_AmmoTypes.BULLET_762x51, profile = "762x51mmBaseAmmo" },
        { type = "MarzGuns.308_Bullet",    enum = MarzGuns_AmmoTypes.BULLET_308,    profile = "762x51mmCivilianAmmo" },
        { type = "Base.308Bullets",        enum = AmmoType.BULLETS_308,             profile = "762x51mmBaseAmmo" },
    },

    ["12Gauge"] = {
        { type = "MarzGuns.12Gauge_Shell_Buckshot", enum = MarzGuns_AmmoTypes.SHELL_12G_BUCKSHOT, profile = "12GaugeBuckAmmo" },
        { type = "MarzGuns.12Gauge_Shell_Slug",     enum = MarzGuns_AmmoTypes.SHELL_12G_SLUG,     profile = "12GaugeSlugAmmo" },
        { type = "Base.ShotgunShells",              enum = AmmoType.SHOTGUN_SHELLS,               profile = "12GaugeBuckAmmo" },
    },

    [".30-30 Winchester"] = {
        { type = "MarzGuns.3030_Bullet", enum = MarzGuns_AmmoTypes.BULLET_3030, profile = "3030WinchesterAmmo" },
        { type = "Base.3030Bullets",     enum = AmmoType.BULLETS_3030,          profile = "3030WinchesterAmmo" },
    },

    [".357 Magnum"] = {
        { type = "MarzGuns.357_Bullet", enum = MarzGuns_AmmoTypes.BULLET_357, profile = "357MagnumAmmo" },
        { type = "Base.Bullets357",     enum = AmmoType.BULLETS_357,          profile = "357MagnumAmmo" },
    },

    [".38 Special"] = {
        { type = "MarzGuns.38_Bullet", enum = MarzGuns_AmmoTypes.BULLET_38, profile = "38SpecialAmmo" },
        { type = "Base.Bullets38",     enum = AmmoType.BULLETS_38,          profile = "38SpecialAmmo" },
    },

    [".44 Magnum"] = {
        { type = "MarzGuns.44_Bullet", enum = MarzGuns_AmmoTypes.BULLET_44, profile = "44MagnumAmmo" },
        { type = "Base.Bullets44",     enum = AmmoType.BULLETS_44,          profile = "44MagnumAmmo" },
    },

    [".45 ACP"] = {
        { type = "MarzGuns.45_Bullet", enum = MarzGuns_AmmoTypes.BULLET_45, profile = "45ACPAmmo" },
        { type = "Base.Bullets45",     enum = AmmoType.BULLETS_45,          profile = "45ACPAmmo" },
    },

    ["9x19mm"] = {
        { type = "MarzGuns.9x19_Bullet", enum = MarzGuns_AmmoTypes.BULLET_9x19, profile = "9x19mmAmmo" },
        { type = "Base.Bullets9mm",      enum = AmmoType.BULLETS_9MM,           profile = "9x19mmAmmo" },
    },

    ["40mm"] = {
        { type = "MarzGuns.40mm_Round_Buckshot",   enum = MarzGuns_AmmoTypes.ROUND_40MM_BUCKSHOT,   profile = "40mmBuckshotAmmo" },
        { type = "MarzGuns.40mm_Round_HE",         enum = MarzGuns_AmmoTypes.ROUND_40MM_HE,         profile = "40mmHEAmmo" },
        { type = "MarzGuns.40mm_Round_Incendiary", enum = MarzGuns_AmmoTypes.ROUND_40MM_INCENDIARY, profile = "40mmIncendiaryAmmo" },
    }
})

-------------------------------------------------
-- Ammo Stat Profiles
-------------------------------------------------
Ammo.RegisterMultipleAmmoStats({
    ["556x45mmBaseAmmo"] = {
        -- no modifiers, use base stats
    },
    ["556x45mmArmorPiercingAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 0.85),
        StatsFactory.Multiply("MinDamage", 0.85),
        StatsFactory.Multiply("CritDmgMultiplier", 0.95),
        StatsFactory.Multiply("CriticalChance", 0.9),
        StatsFactory.Set("PiercingBullets", true),
        StatsFactory.Set("MaxHitCount", 5),
    },
    ["556x45mmHollowPointAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 1.2),
        StatsFactory.Multiply("MinDamage", 1.2),
        StatsFactory.Multiply("CritDmgMultiplier", 1.15),
        StatsFactory.Multiply("CriticalChance", 1.05),
        StatsFactory.Multiply("ConditionLowerChanceOneIn", 0.85),
    },
    ["556x45mmCivilianAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 0.7),
        StatsFactory.Multiply("MinDamage", 0.7),
        StatsFactory.Multiply("CritDmgMultiplier", 0.80),
        StatsFactory.Multiply("CriticalChance", 0.9),
        StatsFactory.Multiply("ConditionLowerChanceOneIn", 1.50),
    },
    ["556x45mmOverpressuredAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 1.5),
        StatsFactory.Multiply("MinDamage", 1.5),
        StatsFactory.Multiply("CritDmgMultiplier", 1.50),
        StatsFactory.Multiply("CriticalChance", 1.05),
        StatsFactory.Multiply("ConditionLowerChanceOneIn", 0.5),
        StatsFactory.Set("PiercingBullets", true),
        StatsFactory.Set("MaxHitCount", 2),
    },
    ["556x45mmSubsonicAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 0.4),
        StatsFactory.Multiply("MinDamage", 0.4),
        StatsFactory.Multiply("SoundRadius", 0.5),
        StatsFactory.Multiply("SoundVolume", 0.5),
        StatsFactory.Multiply("ConditionLowerChanceOneIn", 2.0),
        StatsFactory.Set("RackAfterShot", true),
    },

    ["762x51mmBaseAmmo"] = {
        -- no modifiers, use base stats
    },
    ["762x51mmCivilianAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 0.75),
        StatsFactory.Multiply("MinDamage", 0.75),
        StatsFactory.Multiply("CritDmgMultiplier", 0.85),
        StatsFactory.Multiply("CriticalChance", 0.9),
        StatsFactory.Multiply("ConditionLowerChanceOneIn", 1.50),
    },

    ["12GaugeBuckAmmo"] = {
        -- no modifiers, use base stats
    },
    ["12GaugeSlugAmmo"] = {
        StatsFactory.Multiply("MaxDamage", 2.0),
        StatsFactory.Multiply("MinDamage", 2.0),
        StatsFactory.Set("PiercingBullets", true),
        StatsFactory.Set("MaxHitCount", 3),
        StatsFactory.Set("ProjectileCount", 1),
    },

    ["40mmHEAmmo"] = {
        StatsFactory.Set("ProjectileCount", 0),
        StatsFactory.Set("MaxHitCount", 0),
        StatsFactory.Set("MuzzleFlashModelKey", nil),
        StatsFactory.Set("MaxRange", 1),
        StatsFactory.Set("MinRange", 1),
    },
    ["40mmIncendiaryAmmo"] = {
        StatsFactory.Set("ProjectileCount", 0),
        StatsFactory.Set("MaxHitCount", 0),
        StatsFactory.Set("MuzzleFlashModelKey", nil),
        StatsFactory.Set("MaxRange", 1),
        StatsFactory.Set("MinRange", 1),
    }
})
