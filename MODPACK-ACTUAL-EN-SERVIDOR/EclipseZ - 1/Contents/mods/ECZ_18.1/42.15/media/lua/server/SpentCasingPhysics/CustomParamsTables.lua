local SpentCasingPhysics = require("SpentCasingPhysics/Init")

if SpentCasingPhysics.VFE then
    local vfeParams = {

        ["Base.Shotgun"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.Shotgun2"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.ShotgunSemi"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.ShotgunSemi2"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.ShotgunSawnoff"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.ShotgunSawnoffNoStock"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.DoubleBarrelShotgun"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.0,
            heightOffset  = 0.45,
            shellForce    = 0.15,
            sideSpread    = 30,
            heightSpread  = { 80, 100 },
            ejectAngle    = 180,
        },

        ["Base.DoubleBarrelShotgunSawnoff"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.0,
            heightOffset  = 0.45,
            shellForce    = 0.15,
            sideSpread    = 30,
            heightSpread  = { 80, 100 },
            ejectAngle    = 180,
        },

        ["Base.DoubleBarrelShotgunSawnoffNoStock"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.0,
            heightOffset  = 0.45,
            shellForce    = 0.15,
            sideSpread    = 30,
            heightSpread  = { 80, 100 },
            ejectAngle    = 180,
        },

        ["Base.Spas12"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.Spas12Folded"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.ShotgunSilent"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        --- Rifles

        ["Base.AK47Unfolded"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 55,
        },

        ["Base.AK47Folded"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 55,
        },

        ["Base.AK47"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 55,
        },

        ["Base.MAK90"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.80,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 55,
        },

        ["Base.SKS"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.40,
            sideSpread    = 30,
            heightSpread  = { 70, 90 },
            ejectAngle    = 25,
        },

        ["Base.SKSSpiker"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.40,
            sideSpread    = 30,
            heightSpread  = { 70, 90 },
            ejectAngle    = 25,
        },

        ["Base.1022"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.55,
            sideSpread    = 60,
            heightSpread  = 30,
        },

        ["Base.Mini14Unfolded"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.50,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 25,
        },

        ["Base.Mini14Folded"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.50,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 25,
        },

        ["Base.Mini14"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.50,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 25,
        },

        ["Base.FAL"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 80,
        },

        ["Base.FALClassic"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 80,
        },

        ["Base.CAR15"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.CAR15Folded"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.CAR15D"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 10,
            heightSpread  = 30,
            ejectAngle    = 65,
        },

        ["Base.CAR15DFolded"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.AssaultRifle2"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.55,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 25,
        },

        ["Base.AssaultRifleM1"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.40,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 10,
            verticalForce = 0.1,
        },

        ["Base.AssaultRifle"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.AssaultRifleMasterkeyShotgun"] = {
            forwardOffset = 0.50,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpread  = 30,
        },

        ["Base.AssaultRifleMasterkey"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["Base.M60MMG"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.80,
            sideSpread    = 60,
            heightSpread  = 30,
        },

        ["Base.M60MMG_Bipod"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.80,
            sideSpread    = 60,
            heightSpread  = 30,
        },

        ["Base.HuntingRifle"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.45,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.VarmintRifle"] = {
            forwardOffset = 0.15,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.45,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.SniperRifle"] = {
            forwardOffset = 0.25,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.65,
            sideSpread    = 30,
            ejectAngle    = 45,
            heightSpread  = { 70, 100 },
        },

        ["Base.CampCarbine"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.0,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 60,
        },

        ["Base.LeverRifle"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.25,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.LeverRifle2"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        --- Smgs

        ["Base.MP5"] = {
            forwardOffset = 0.32,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpread  = 60,
        },

        ["Base.MP5SD"] = {
            forwardOffset = 0.32,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpread  = 60,
        },

        ["Base.MP5Unfolded"] = {
            forwardOffset = 0.32,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpread  = 60,
        },

        ["Base.MP5Folded"] = {
            forwardOffset = 0.32,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpread  = 60,
        },

        ["Base.MAC10Unfolded"] = {
            forwardOffset = 0.45,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpread  = 60,
        },

        ["Base.MAC10Folded"] = {
            forwardOffset = 0.45,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.UziUnfolded"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.UziFolded"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        --- Pistols

        ["Base.Tec9"] = {
            forwardOffset = 0.45,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 60,
        },

        ["Base.Pistol"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 60,
        },

        ["Base.Pistol2"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 90,
        },

        ["Base.Pistol3"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.1,
            sideSpread    = 30,
            heightSpread  = { 70, 100 },
            ejectAngle    = 0,
        },

        ["Base.MK23SOCOM"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 50,
            heightSpread  = 45,
        },

        ["Base.Glock"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.45,
            sideSpread    = 45,
            heightSpread  = 90,
        },

        ["Base.Glock18"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.45,
            sideSpread    = 45,
            heightSpread  = 90,
        },

        ["Base.P229"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 90,
        },

        ["Base.CZ75"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.79,
            sideSpread    = 30,
            heightSpread  = 90,
        },

        ["Base.MK2"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.MK2SD"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.Revolver"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.Revolver_Short"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        ["Base.Revolver_Long"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 30,
            heightSpread  = 30,
        },

        --- Combination Gun

        ["Base.M2400_Shotgun"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.0,
            heightOffset  = 0.40,
            shellForce    = 0.30,
            sideSpread    = 10,
            heightSpread  = { 80, 100 },
            ejectAngle    = 180,
        },

        ["Base.M2400_Rifle"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.0,
            heightOffset  = 0.40,
            shellForce    = 0.30,
            sideSpread    = 10,
            heightSpread  = { 80, 100 },
            ejectAngle    = 180,
        },
    }

    for weapon, data in pairs(vfeParams) do
        SpentCasingPhysics.RegisterWeaponParams(
            weapon,
            data.forwardOffset,
            data.sideOffset,
            data.heightOffset,
            data.shellForce,
            data.sideSpread,
            data.heightSpread,
            data.ejectAngle,
            data.verticalForce
        )
    end

    SpentCasingPhysics.RegisterCasingToAmmo({
        ["Base.223Bullets"] = "HBVCEF.223_Casing",
        ["Base.792Bullets"] = "HBVCEF.792x57_Casing",
        ["Base.22Bullets"] = "HBVCEF.22_Casing",
        ["Base.762Bullets"] = "HBVCEF.762x39_Casing",
    })
end

if SpentCasingPhysics.VFES then
    local vfesParams = {

        ["Base.HK416"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.80,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 65,
        },

        ["Base.Galil"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 60,
            ejectAngle    = 45,
        },

        ["Base.AK104"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 65,
        },

        ["Base.AK74"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 65,
        },

        ["Base.AKS74U"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 65,
        },

        ["Base.AK105"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 65,
        },

        ["Base.Saiga12"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.70,
            sideSpread    = 10,
            heightSpread  = 10,
            ejectAngle    = 45,
        },

        ["Base.MP153"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.30,
            sideSpread    = 10,
            heightSpread  = 10,
            ejectAngle    = 65,
        },

        ["Base.MP153sawn"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.30,
            sideSpread    = 10,
            heightSpread  = 10,
            ejectAngle    = 65,
        },

        ["Base.Mosin"] = {
            forwardOffset = 0.25,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.65,
            sideSpread    = 30,
            ejectAngle    = 45,
            heightSpread  = { 70, 100 },
        },

        ["Base.SVD"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 30,
            heightSpread  = 60,
            ejectAngle    = 35,
        },

        ["Base.SV98"] = {
            forwardOffset = 0.25,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.65,
            sideSpread    = 30,
            ejectAngle    = 45,
            heightSpread  = { 70, 100 },
        },

        ["Base.VSS"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 30,
            heightSpread  = 60,
            ejectAngle    = 45,
        },

        ["Base.SVT40"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = { 90, 110 },
            ejectAngle    = 10,
        },

        ["Base.UMP45"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 10,
        },

        ["Base.Vityaz"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.Bizon"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.PPSH"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.10,
            sideSpread    = 60,
            heightSpread  = { 60, 80 },
            ejectAngle    = 0,
        },

        ["Base.Makarov"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpread  = 60,
        },

        ["Base.USP45"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 50,
            heightSpread  = 45,
        },

        ["Base.M249"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 1.20,
            sideSpread    = 60,
            heightSpread  = 30,
        },

        ["Base.PKM"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.10,
            sideSpread    = 60,
            heightSpread  = { 0, 1 },
            ejectAngle    = 340,
            verticalForce = -0.2,
        },
    }

    for weapon, data in pairs(vfesParams) do
        SpentCasingPhysics.RegisterWeaponParams(
            weapon,
            data.forwardOffset,
            data.sideOffset,
            data.heightOffset,
            data.shellForce,
            data.sideSpread,
            data.heightSpread,
            data.ejectAngle,
            data.verticalForce
        )
    end

    SpentCasingPhysics.RegisterCasingToAmmo({
        ["Base.545Bullets"] = "HBVCEF.545x39_Casing",
        ["Base.939Bullets"] = "HBVCEF.9x39_Casing",
        ["Base.76254Bullets"] = "HBVCEF.762x54_Casing"
    })
end

if SpentCasingPhysics.VFE93 then
    local vfe93Params = {

        ["Base.scar17"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 75,
        },

        ["Base.M4A1"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 2.75,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 60,
        },

        ["Base.Block2"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 60,
        },

        ["Base.SPR"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 60,
        },

        ["Base.SPRSD"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 60,
        },

        ["Base.Vector45"] = {
            forwardOffset = 0.50,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpreed  = 60,
        },

        ["Base.Vector9"] = {
            forwardOffset = 0.50,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpreed  = 60,
        },

        ["Base.P90"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.50,
            shellForce    = 0.10,
            sideSpread    = 10,
            heightSpreed  = { 0, 1 },
            ejectAngle    = 0,
            verticalForce = -0.6,
        },

        ["Base.MP7"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 30,
            heightSpreed  = 30,
        },

        ["Base.FN57"] = {
            forwardOffset = 0.45,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.75,
            sideSpread    = 30,
            heightSpreed  = 90,
        },

        ["Base.CP33"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.70,
            sideSpread    = 30,
            heightSpreed  = 60,
        },

        ["Base.1522"] = {
            forwardOffset = 0.25,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 30,
            heightSpreed  = 60,
        },

        ["Base.n418sd"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 60,
        },

        ["Base.n418"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.75,
            sideSpread    = 60,
            heightSpreed  = 30,
            ejectAngle    = 60,
        },

        ["Base.AA12"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.60,
            sideSpread    = 60,
            heightSpreed  = 30,
        },
    }

    for weapon, data in pairs(vfe93Params) do
        SpentCasingPhysics.RegisterWeaponParams(
            weapon,
            data.forwardOffset,
            data.sideOffset,
            data.heightOffset,
            data.shellForce,
            data.sideSpread,
            data.heightSpread,
            data.ejectAngle,
            data.verticalForce
        )
    end

    SpentCasingPhysics.RegisterCasingToAmmo({
        ["Base.223Bullets"] = "HBVCEF.223_Casing",
        ["Base.792Bullets"] = "HBVCEF.792x57_Casing",
        ["Base.22Bullets"] = "HBVCEF.22_Casing",
        ["Base.762Bullets"] = "HBVCEF.762x39_Casing",
    })
end

if SpentCasingPhysics.FIREARMS or SpentCasingPhysics.FIREARMS_BETA then
    SpentCasingPhysics.RegisterCasingToAmmo({
        ["Base.Bullets10mm"] = "HBVCEF.10x25_Casing",
        ["Base.Bullets22"] = "HBVCEF.22_Casing",
        ["Base.762x51Bullets"] = "HBVCEF.762x51_Casing",
        ["Base.762x39Bullets"] = "HBVCEF.762x39_Casing",
        ["Base.Bullets3006"] = "HBVCEF.3006_Casing",
        ["Base.Bullets4440"] = "HBVCEF.44_Casing",
    })
end

if SpentCasingPhysics.GGS then
    SpentCasingPhysics.RegisterCasingToAmmo({
        ["Base.Bullets9mm"] = "Base.pistol_casing",
        ["Base.9x39Bullets"] = "Base.rifle_casing",
        ["Base.Bullets22LR"] = "Base.pistol_casing",
        ["Base.Bullets32"] = "Base.revolver_casing",
        ["Base.Bullets38"] = "Base.revolver_casing",
        ["Base.Bullets44"] = "Base.revolver_casing",
        ["Base.Bullets45"] = "Base.pistol_casing",
        ["Base.Bullets50"] = "Base.rifle_casing",
        ["Base.Bullets50Magnum"] = "Base.revolver_casing",
        ["Base.308Bullets"] = "Base.rifle_casing",
        ["Base.Bullets357"] = "Base.revolver_casing",
        ["Base.545x39Bullets"] = "Base.rifle_casing",
        ["Base.556Bullets"] = "Base.rifle_casing",
        ["Base.762x39Bullets"] = "Base.rifle_casing",
        ["Base.762x54rBullets"] = "Base.rifle_casing",
        ["Base.792x57Bullets"] = "Base.rifle_casing",
        ["Base.ShotgunShells"] = "Base.shells_casing",
    })
end
