require("Items/ProceduralDistributions/ProceduralDistributions")
require("Vehicles/VehicleDistributions")
require("Items/Distributions")
require("Items/Distribution_BagsAndContainers")
require("Definitions/AttachedWeaponDefinitions")


local Distribution = require("Distribution/Functions.lua")

local tables = { ProceduralDistributions.list, VehicleDistributions, SuburbsDistributions, BagsAndContainers }
local zombieTables = { AttachedWeaponDefinitions }
local vanillaItems = {
    "Base.AssaultRifle",
    "Base.AssaultRifle2",
    "Base.DoubleBarrelShotgun",
    "Base.DoubleBarrelShotgunSawnoff",
    "Base.HuntingRifle",
    "Base.Pistol",
    "Base.Pistol2",
    "Base.Pistol3",
    "Base.Revolver",
    "Base.Revolver_Long",
    "Base.Revolver_Short",
    "Base.Shotgun",
    "Base.ShotgunSawnoff",
    "Base.VarmintRifle",
    "Base.JS14_Rifle",
    "Base.JS3T_Shotgun",
    "Base.L92_Carbine",
    "Base.L94_Rifle",
    "Base.MSR7T_Rifle",
    "Base.TrapperCarbine",

    "Base.44Clip",
    "Base.45Clip",
    "Base.9mmClip",
    "Base.M14Clip",
    "Base.556Clip",
    "Base.JS14_Clip",

    "Base.TritiumSights",
    "Base.RedDot",
    "Base.x2Scope",
    "Base.x4Scope",
    "Base.x8Scope",
    "Base.AmmoStraps",
    "Base.RecoilPad",
    "Base.Laser",
    "Base.GunLight",
    "Base.ChokeTubeFull",
    "Base.ChokeTubeImproved",

    "Base.308Bullets",
    "Base.556Bullets",
    "Base.3030Bullets",
    "Base.Bullets357",
    "Base.Bullets38",
    "Base.Bullets44",
    "Base.Bullets45",
    "Base.Bullets9mm",
    "Base.ShotgunShells",

    "Base.308Box",
    "Base.308Carton",
    "Base.556Box",
    "Base.556Carton",
    "Base.3030Box",
    "Base.3030Carton",
    "Base.Bullets357Box",
    "Base.Bullets357Carton",
    "Base.Bullets38Box",
    "Base.Bullets38Carton",
    "Base.Bullets44Box",
    "Base.Bullets44Carton",
    "Base.Bullets45Box",
    "Base.Bullets45Carton",
    "Base.Bullets9mmBox",
    "Base.Bullets9mmCarton",
    "Base.ShotgunShellsBox",
    "Base.ShotgunShellsCarton",
}

local sandboxWeapons = (SandboxVars and SandboxVars.MarzGuns) or {}

local function isSandboxEnabled(key)
    return sandboxWeapons["Enable_" .. key] ~= false
end

local function weapon(item, baseItem, chance)
    if not isSandboxEnabled(item) then return end
    Distribution.Insert(baseItem, chance, tables, "MarzGuns." .. item)
end

local function ammo(item, baseItem, chance)
    if not isSandboxEnabled(item:gsub("_Box", ""):gsub("_Carton", "")) then return end
    Distribution.Insert(baseItem, chance, tables, "MarzGuns." .. item)
end

local function zombie(item, baseItem)
    if not isSandboxEnabled(item) then return end
    Distribution.Insert(baseItem, nil, zombieTables, "MarzGuns." .. item)
end

local function applyDistributionPass()
    weapon("M16A1", "Base.AssaultRifle", 0.3)
    weapon("M16A2", "Base.AssaultRifle", 0.3)
    weapon("M16A2_M203", "Base.AssaultRifle", 0.3)
    weapon("M16A3", "Base.AssaultRifle", 0.3)
    weapon("AR15", "Base.AssaultRifle2", 0.8)
    weapon("AR15", "Base.JS14_Rifle", 0.8)
    weapon("M4", "Base.JS14_Rifle", 0.01)
    weapon("FNC", "Base.AssaultRifle", 0.2)
    weapon("FNC", "Base.AssaultRifle2", 0.05)
    weapon("FNC", "Base.JS14_Rifle", 0.05)
    weapon("M4A1", "Base.AssaultRifle", 0.05)
    weapon("M4A1", "Base.AssaultRifle", 0.3)
    weapon("CAR15", "Base.AssaultRifle", 0.05)
    weapon("CAR15", "Base.AssaultRifle", 0.3)
    weapon("XM177", "Base.AssaultRifle", 0.05)
    weapon("XM177", "Base.AssaultRifle", 0.3)
    weapon("G36C", "Base.AssaultRifle", 0.35)
    weapon("G36", "Base.AssaultRifle", 0.35)
    weapon("AK74", "Base.AssaultRifle", 0.3)
    weapon("AK74", "Base.AssaultRifle2", 0.08)
    weapon("AK47", "Base.AssaultRifle", 0.2)
    weapon("AK47", "Base.AssaultRifle2", 0.05)
    weapon("AKS74U", "Base.AssaultRifle", 0.3)
    weapon("AKS74U", "Base.AssaultRifle2", 0.08)
    weapon("ASVAL", "Base.AssaultRifle", 0.25)
    weapon("FAMAS", "Base.AssaultRifle", 0.1)
    weapon("FAMAS", "Base.AssaultRifle2", 0.05)
    weapon("FAMAS", "Base.JS14_Rifle", 0.05)
    weapon("M14", "Base.AssaultRifle2", 0.5)
    weapon("M1_GARAND", "Base.AssaultRifle2", 0.25)
    weapon("M1_GARAND", "Base.MSR7T_Rifle", 0.15)
    weapon("FAL", "Base.AssaultRifle2", 0.5)
    weapon("FAL", "Base.AssaultRifle", 0.2)
    weapon("G3", "Base.AssaultRifle2", 0.5)
    weapon("G3", "Base.AssaultRifle", 0.2)
    weapon("MOSIN", "Base.HuntingRifle", 0.5)
    weapon("762x54StripperClip5_MOSIN", "Base.HuntingRifle", 0.2)
    weapon("M24", "Base.MSR7T_Rifle", 0.1)
    weapon("M1903", "Base.MSR7T_Rifle", 0.1)
    weapon("M1903", "Base.HuntingRifle", 0.5)
    weapon("M79", "Base.AssaultRifle", 0.1)
    weapon("M79", "Base.AssaultRifle2", 0.1)
    weapon("W1894", "Base.L92_Carbine", 0.6)
    weapon("W1894", "Base.L94_Rifle", 0.2)
    weapon("M1895", "Base.L94_Rifle", 0.6)
    weapon("M1895", "Base.L92_Carbine", 0.1)
    weapon("W1873", "Base.L94_Rifle", 0.6)
    weapon("W1873", "Base.L92_Carbine", 0.3)
    weapon("W1873_CARBINE", "Base.L94_Rifle", 0.6)
    weapon("W1873_CARBINE", "Base.L92_Carbine", 0.1)
    weapon("W1887", "Base.Shotgun", 0.2)
    weapon("W1887", "Base.DoubleBarrelShotgun", 0.2)
    weapon("M60", "Base.AssaultRifle", 0.1)
    weapon("BAR", "Base.AssaultRifle2", 0.15)
    weapon("M92FS", "Base.Pistol", 1)
    weapon("M93R", "Base.Pistol", 0.2)
    weapon("HIPOWER", "Base.Pistol", 0.7)
    weapon("P226", "Base.Pistol", 0.7)
    weapon("M1911", "Base.Pistol2", 1)
    weapon("USP", "Base.Pistol2", 0.5)
    weapon("DEAGLE", "Base.Pistol3", 1)
    weapon("COLT_SINGLE", "Base.Revolver", 0.7)
    weapon("RHINO", "Base.Revolver", 0.5)
    weapon("MP412", "Base.Revolver_Short", 0.3)
    weapon("DETECTIVE_38", "Base.Revolver_Short", 0.3)
    weapon("SW629", "Base.Revolver_Long", 0.5)
    weapon("PYTHON", "Base.Revolver_Long", 0.5)
    weapon("357SpeedLoader6_PYTHON", "Base.Revolver_Long", 0.2)
    weapon("SVD", "Base.AssaultRifle2", 0.25)
    weapon("SVD", "Base.MSR7T_Rifle", 0.15)
    weapon("SKS", "Base.AssaultRifle2", 0.25)
    weapon("SKS", "Base.MSR7T_Rifle", 0.15)
    weapon("PSG1", "Base.AssaultRifle2", 0.25)
    weapon("PSG1", "Base.MSR7T_Rifle", 0.15)
    weapon("MOSSBERG_590", "Base.Shotgun", 0.5)
    weapon("MOSSBERG_590", "Base.JS3T_Shotgun", 0.5)
    weapon("TRENCHGUN", "Base.Shotgun", 0.2)
    weapon("TRENCHGUN", "Base.JS3T_Shotgun", 0.05)
    weapon("BENELLI_M4", "Base.Shotgun", 0.1)
    weapon("BENELLI_M4", "Base.JS3T_Shotgun", 0.5)
    weapon("SPAS12", "Base.Shotgun", 0.05)
    weapon("SPAS12", "Base.JS3T_Shotgun", 0.5)
    weapon("STEVENS_555", "Base.DoubleBarrelShotgun", 0.5)
    weapon("DOUBLEBARREL", "Base.DoubleBarrelShotgun", 1)
    weapon("AA12", "Base.JS3T_Shotgun", 0.2)
    weapon("REMINGTON_870", "Base.Shotgun", 0.3)
    weapon("REMINGTON_870", "Base.JS3T_Shotgun", 0.2)
    weapon("THOMPSON", "Base.JS14_Rifle", 0.2)
    weapon("MP5", "Base.JS14_Rifle", 0.1)
    weapon("MP5SD", "Base.JS14_Rifle", 0.1)
    weapon("MP5A2", "Base.JS14_Rifle", 0.1)
    weapon("MP5K", "Base.Pistol3", 0.2)
    weapon("TEC9", "Base.Pistol2", 0.3)
    weapon("MAC10", "Base.Pistol2", 0.3)

    if sandboxWeapons.Enable_Explosives then
        Distribution.Insert("Base.PipeBomb", 1, tables, "MarzGuns.M67")
        Distribution.Insert("Base.AssaultRifle", 0.05, tables, "MarzGuns.M67")
        Distribution.Insert("Base.AssaultRifle", 0.05, tables, "MarzGuns.M14_Incendiary")
        Distribution.Insert("Base.PipeBomb", 1, tables, "MarzGuns.M18")
        Distribution.Insert("Base.AssaultRifle", 0.05, tables, "MarzGuns.M18")
    end
    Distribution.Insert("Base.HuntingKnife", 0.2, tables, "MarzGuns.K98_BAYONET")
    Distribution.Insert("Base.HuntingKnife", 0.3, tables, "MarzGuns.M5_BAYONET")
    Distribution.Insert("Base.HuntingKnife", 0.3, tables, "MarzGuns.M9_BAYONET")

    ammo("9x19_Box", "Base.Bullets9mmBox", 1)
    ammo("9x19_Carton", "Base.Bullets9mmCarton", 1)
    ammo("38_Box", "Base.Bullets38Box", 1)
    ammo("38_Carton", "Base.Bullets38Carton", 1)
    ammo("45_Box", "Base.Bullets45Box", 1)
    ammo("45_Carton", "Base.Bullets45Carton", 1)
    ammo("357_Box", "Base.Bullets357Box", 1)
    ammo("357_Carton", "Base.Bullets357Carton", 1)
    ammo("44_Box", "Base.Bullets44Box", 1)
    ammo("44_Carton", "Base.Bullets44Carton", 1)
    ammo("308_Box", "Base.308Box", 1)
    ammo("308_Carton", "Base.308Carton", 1)
    ammo("762x51_Box", "Base.308Box", 0.5)
    ammo("762x51_Carton", "Base.308Carton", 0.5)
    ammo("223_Box", "Base.556Box", 1)
    ammo("223_Carton", "Base.556Carton", 1)
    ammo("556x45_Box", "Base.556Box", 0.5)
    ammo("556x45_Carton", "Base.556Carton", 0.5)
    ammo("3030_Box", "Base.3030Box", 1)
    ammo("3030_Carton", "Base.3030Carton", 1)
    ammo("12Gauge_Box_Buckshot", "Base.ShotgunShellsBox", 1)
    ammo("12Gauge_Carton_Buckshot", "Base.ShotgunShellsCarton", 1)

    ammo("40mm_Box_Buckshot", "Base.ShotgunShellsBox", 0.05)
    if sandboxWeapons.Enable_Explosives then
        ammo("40mm_Box_HE", "Base.ShotgunShellsBox", 0.05)
        ammo("40mm_Box_Incendiary", "Base.ShotgunShellsBox", 0.05)
    end
    ammo("50_Box", "Base.Bullets44Box", 0.5)
    ammo("50_Carton", "Base.Bullets44Carton", 0.5)
    ammo("4570_Box", "Base.3030Box", 0.3)
    ammo("4570_Carton", "Base.3030Carton", 0.3)
    ammo("762x39_Box", "Base.556Box", 0.5)
    ammo("762x39_Carton", "Base.556Carton", 0.5)
    ammo("9x39_Box", "Base.556Box", 0.3)
    ammo("9x39_Carton", "Base.556Carton", 0.3)
    ammo("545x39_Box", "Base.556Box", 0.5)
    ammo("545x39_Carton", "Base.556Carton", 0.5)
    ammo("762x54_Box", "Base.308Box", 0.5)
    ammo("762x54_Carton", "Base.308Carton", 0.5)
    ammo("3006_Box", "Base.308Box", 0.3)
    ammo("3006_Carton", "Base.308Carton", 0.3)
    ammo("556x45_Box_HollowPoint", "Base.556Box", 0.1)
    ammo("556x45_Carton_HollowPoint", "Base.556Carton", 0.1)
    ammo("556x45_Box_ArmorPiercing", "Base.556Box", 0.1)
    ammo("556x45_Carton_ArmorPiercing", "Base.556Carton", 0.1)
    ammo("556x45_Box_Subsonic", "Base.556Box", 0.05)
    ammo("556x45_Carton_Subsonic", "Base.556Carton", 0.05)
    ammo("556x45_Box_Overpressured", "Base.556Box", 0.03)
    ammo("556x45_Carton_Overpressured", "Base.556Carton", 0.03)
    ammo("12Gauge_Box_Slug", "Base.ShotgunShellsBox", 0.2)
    ammo("12Gauge_Carton_Slug", "Base.ShotgunShellsCarton", 0.2)


    Distribution.InsertMany("Base.Laser", 0.05, tables, "MarzGuns.AR_Muzzle_Mount_Device", "MarzGuns.AK_Muzzle_Mount_Device", "MarzGuns.Pistol_Muzzle_Mount_Device", "MarzGuns.45_Muzzle_Mount_Device")
    Distribution.InsertMany("Base.Laser", 0.05, tables, "MarzGuns.LR2_Compensator", "MarzGuns.LX_Flashhider", "MarzGuns.Trix42_Muzzlebreak")
    Distribution.InsertMany("Base.Laser", 0.05, tables, "MarzGuns.MKI_Suppressor", "MarzGuns.NDR_Suppressor", "MarzGuns.PBS-1_Suppressor", "MarzGuns.Shh9_Suppressor", "MarzGuns.M&P_Suppressor", "MarzGuns.P45_Suppressor")

    Distribution.InsertMany("Base.RedDot", 0.05, tables, "MarzGuns.AR_Muzzle_Mount_Device", "MarzGuns.AK_Muzzle_Mount_Device", "MarzGuns.Pistol_Muzzle_Mount_Device", "MarzGuns.45_Muzzle_Mount_Device")
    Distribution.InsertMany("Base.RedDot", 0.05, tables, "MarzGuns.LR2_Compensator", "MarzGuns.LX_Flashhider", "MarzGuns.Trix42_Muzzlebreak")
    Distribution.InsertMany("Base.RedDot", 0.05, tables, "MarzGuns.MKI_Suppressor", "MarzGuns.NDR_Suppressor", "MarzGuns.PBS-1_Suppressor", "MarzGuns.Shh9_Suppressor", "MarzGuns.M&P_Suppressor", "MarzGuns.P45_Suppressor")

    Distribution.InsertMany("Base.GunLight", 0.05, tables, "MarzGuns.AR_Muzzle_Mount_Device", "MarzGuns.AK_Muzzle_Mount_Device", "MarzGuns.Pistol_Muzzle_Mount_Device", "MarzGuns.45_Muzzle_Mount_Device")
    Distribution.InsertMany("Base.GunLight", 0.05, tables, "MarzGuns.LR2_Compensator", "MarzGuns.LX_Flashhider", "MarzGuns.Trix42_Muzzlebreak")
    Distribution.InsertMany("Base.GunLight", 0.05, tables, "MarzGuns.MKI_Suppressor", "MarzGuns.NDR_Suppressor", "MarzGuns.PBS-1_Suppressor", "MarzGuns.Shh9_Suppressor", "MarzGuns.M&P_Suppressor", "MarzGuns.P45_Suppressor")

    Distribution.Insert("Base.RecoilPad", 0.05, tables, "MarzGuns.Bipod_Folded")
    Distribution.Insert("Base.AmmoStraps", 0.05, tables, "MarzGuns.Shellholder")
    Distribution.Insert("Base.AssaultRifle", 0.05, tables, "MarzGuns.M203")

    Distribution.InsertMany("Base.TritiumSights", 0.05, tables, "MarzGuns.ReflexS2_Sight", "MarzGuns.Kobra_Sight", "MarzGuns.OKP3_Sight", "MarzGuns.JS14_Sight", "MarzGuns.EXPS3_Sight", "MarzGuns.EXPS1_Sight", "MarzGuns.Aimpoint_Sight", "MarzGuns.PL4_Sight", "MarzGuns.PS1_Sight", "MarzGuns.PM2_Sight")
    Distribution.InsertMany("Base.RedDot", 0.05, tables, "MarzGuns.ReflexS2_Sight", "MarzGuns.Kobra_Sight", "MarzGuns.OKP3_Sight", "MarzGuns.JS14_Sight", "MarzGuns.EXPS3_Sight", "MarzGuns.EXPS1_Sight", "MarzGuns.Aimpoint_Sight", "MarzGuns.PL4_Sight", "MarzGuns.PS1_Sight", "MarzGuns.PM2_Sight")
    Distribution.InsertMany("Base.x4Scope", 0.05, tables, "MarzGuns.Booster_Scope", "MarzGuns.LR4X_Scope", "MarzGuns.TA28_Scope", "MarzGuns.ElcanX2_Scope")
    Distribution.InsertMany("Base.x2Scope", 0.05, tables, "MarzGuns.Booster_Scope", "MarzGuns.LR4X_Scope", "MarzGuns.TA28_Scope", "MarzGuns.ElcanX2_Scope")
    Distribution.InsertMany("Base.x8Scope", 0.05, tables, "MarzGuns.TR06X_Scope", "MarzGuns.PSO1_Scope", "MarzGuns.LR10X_Scope", "MarzGuns.LRX12X_Scope", "MarzGuns.PRL1_Scope")

    Distribution.InsertMany("Base.TritiumSights", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.RedDot", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.x2Scope", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.x4Scope", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.x8Scope", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.AmmoStraps", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.RecoilPad", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.Laser", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.GunLight", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.ChokeTubeFull", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")
    Distribution.InsertMany("Base.ChokeTubeImproved", 0.05, tables, "MarzGuns.Picatinny_Rail", "MarzGuns.AK_Mount", "MarzGuns.Sniper_Mount", "MarzGuns.Beretta_Mount", "MarzGuns.Colt_Mount", "MarzGuns.Heavy_Pistol_Rail")

    Distribution.Insert("Base.Whetstone", 0.25, tables, "MarzGuns.RepairPack")
    Distribution.Insert("Base.308Box", 0.5, tables, "MarzGuns.RepairPack")
    Distribution.Insert("Base.556Box", 0.5, tables, "MarzGuns.RepairPack")

    Distribution.RemoveMany(
        tables,
        unpack(vanillaItems)
    )
end

Events.OnPostDistributionMerge.Add(applyDistributionPass)

Events.OnInitGlobalModData.Add(
    function()
        zombie("M16A1", "Base.AssaultRifle")
        zombie("M16A2", "Base.AssaultRifle")
        zombie("M16A2_M203", "Base.AssaultRifle")
        zombie("M16A3", "Base.AssaultRifle")
        zombie("AR15", "Base.AssaultRifle2")
        zombie("AR15", "Base.JS14_Rifle")
        zombie("FNC", "Base.AssaultRifle")
        zombie("FNC", "Base.AssaultRifle2")
        zombie("FNC", "Base.JS14_Rifle")
        zombie("CAR15", "Base.AssaultRifle")
        zombie("XM177", "Base.AssaultRifle")
        zombie("M4A1", "Base.AssaultRifle")
        zombie("G36C", "Base.AssaultRifle")
        zombie("G36", "Base.AssaultRifle")
        zombie("AK74", "Base.AssaultRifle")
        zombie("AK74", "Base.AssaultRifle2")
        zombie("AKS74U", "Base.AssaultRifle")
        zombie("AKS74U", "Base.AssaultRifle2")
        zombie("ASVAL", "Base.AssaultRifle")
        zombie("FAMAS", "Base.AssaultRifle")
        zombie("FAMAS", "Base.AssaultRifle2")
        zombie("FAMAS", "Base.JS14_Rifle")
        zombie("M14", "Base.AssaultRifle2")
        zombie("M1_GARAND", "Base.AssaultRifle2")
        zombie("M1_GARAND", "Base.MSR7T_Rifle")
        zombie("FAL", "Base.AssaultRifle2")
        zombie("FAL", "Base.AssaultRifle")
        zombie("G3", "Base.AssaultRifle2")
        zombie("G3", "Base.AssaultRifle")
        zombie("MOSIN", "Base.HuntingRifle")
        zombie("762x54StripperClip5_MOSIN", "Base.HuntingRifle")
        zombie("M24", "Base.MSR7T_Rifle")
        zombie("M1903", "Base.MSR7T_Rifle")
        zombie("M79", "Base.AssaultRifle")
        zombie("M79", "Base.AssaultRifle2")
        zombie("W1894", "Base.L92_Carbine")
        zombie("W1894", "Base.L94_Rifle")
        zombie("M1895", "Base.L94_Rifle")
        zombie("M1895", "Base.L92_Carbine")
        zombie("W1873", "Base.L94_Rifle")
        zombie("W1873", "Base.L92_Carbine")
        zombie("W1873_CARBINE", "Base.L94_Rifle")
        zombie("W1873_CARBINE", "Base.L92_Carbine")
        zombie("W1887", "Base.Shotgun")
        zombie("W1887", "Base.DoubleBarrelShotgun")
        zombie("M60", "Base.AssaultRifle")
        zombie("BAR", "Base.AssaultRifle2")
        zombie("M92FS", "Base.Pistol")
        zombie("M93R", "Base.Pistol")
        zombie("HIPOWER", "Base.Pistol")
        zombie("P226", "Base.Pistol")
        zombie("M1911", "Base.Pistol2")
        zombie("USP", "Base.Pistol2")
        zombie("DEAGLE", "Base.Pistol3")
        zombie("COLT_SINGLE", "Base.Revolver")
        zombie("RHINO", "Base.Revolver")
        zombie("MP412", "Base.Revolver_Short")
        zombie("DETECTIVE_38", "Base.Revolver_Short")
        zombie("SW629", "Base.Revolver_Long")
        zombie("PYTHON", "Base.Revolver_Long")
        zombie("357SpeedLoader6_PYTHON", "Base.Revolver_Long")
        zombie("SVD", "Base.AssaultRifle2")
        zombie("SVD", "Base.MSR7T_Rifle")
        zombie("SKS", "Base.AssaultRifle2")
        zombie("SKS", "Base.MSR7T_Rifle")
        zombie("PSG1", "Base.AssaultRifle2")
        zombie("PSG1", "Base.MSR7T_Rifle")
        zombie("MOSSBERG_590", "Base.Shotgun")
        zombie("MOSSBERG_590", "Base.JS3T_Shotgun")
        zombie("TRENCHGUN", "Base.Shotgun")
        zombie("TRENCHGUN", "Base.JS3T_Shotgun")
        zombie("BENELLI_M4", "Base.Shotgun")
        zombie("BENELLI_M4", "Base.JS3T_Shotgun")
        zombie("SPAS12", "Base.Shotgun")
        zombie("SPAS12", "Base.JS3T_Shotgun")
        zombie("STEVENS_555", "Base.DoubleBarrelShotgun")
        zombie("DOUBLEBARREL", "Base.DoubleBarrelShotgun")
        zombie("AA12", "Base.JS3T_Shotgun")
        zombie("REMINGTON_870", "Base.Shotgun")
        zombie("REMINGTON_870", "Base.JS3T_Shotgun")
        zombie("THOMPSON", "Base.JS14_Rifle")
        zombie("MP5", "Base.JS14_Rifle")
        zombie("MP5K", "Base.Pistol3")
        zombie("MP5SD", "Base.JS14_Rifle")
        zombie("MP5A2", "Base.JS14_Rifle")
        zombie("TEC9", "Base.Pistol2")
        zombie("MAC10", "Base.Pistol2")

        if sandboxWeapons.Enable_Explosives then
            Distribution.Insert("Base.PipeBomb", 1, zombieTables, "MarzGuns.M67")
            Distribution.Insert("Base.AssaultRifle", 0.1, zombieTables, "MarzGuns.M67")
            Distribution.Insert("Base.PipeBomb", 1, zombieTables, "MarzGuns.M18")
            Distribution.Insert("Base.AssaultRifle", 0.1, zombieTables, "MarzGuns.M18")
        end
        Distribution.Insert("Base.HuntingKnife", 0.2, zombieTables, "MarzGuns.K98_BAYONET")
        Distribution.Insert("Base.HuntingKnife", 0.3, zombieTables, "MarzGuns.M5_BAYONET")
        Distribution.Insert("Base.HuntingKnife", 0.3, zombieTables, "MarzGuns.M9_BAYONET")
        Distribution.RemoveMany(
            zombieTables,
            unpack(vanillaItems)
        )
    end
)
