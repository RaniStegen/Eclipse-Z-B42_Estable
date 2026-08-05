local SpentCasingPhysics                     = {}

--------------------------------------------------------------------
--- Vanilla Weapons
--------------------------------------------------------------------
SpentCasingPhysics.WeaponEjectionPortParams  = {
    --Pistols
    ["Base.Pistol3"] = {
        forwardOffset = 0.50,
        sideOffset = 0.0,
        heightOffset = 0.45,
        shellForce = 0.30,
    },

    ["Base.Pistol2"] = {
        forwardOffset = 0.50,
        sideOffset = 0.0,
        heightOffset = 0.45,
        shellForce = 0.25,
    },

    ["Base.Revolver_Short"] = {
        forwardOffset = 0.15,
        sideOffset = 0.0,
        heightOffset = 0.35,
        shellForce = 0.10,
    },

    ["Base.Revolver"] = {
        forwardOffset = 0.15,
        sideOffset = 0.0,
        heightOffset = 0.35,
        shellForce = 0.10,
    },

    ["Base.Pistol"] = {
        forwardOffset = 0.50,
        sideOffset = 0.0,
        heightOffset = 0.45,
        shellForce = 0.25,
    },

    ["Base.Revolver_Long"] = {
        forwardOffset = 0.15,
        sideOffset = 0.0,
        heightOffset = 0.35,
        shellForce = 0.10,
    },

    --Shotguns
    ["Base.DoubleBarrelShotgun"] = {
        forwardOffset = 0.27,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.15,
    },

    ["Base.DoubleBarrelShotgunSawnoff"] = {
        forwardOffset = 0.27,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.15,
    },

    ["Base.Shotgun"] = {
        forwardOffset = 0.27,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.15,
    },

    ["Base.ShotgunSawnoff"] = {
        forwardOffset = 0.27,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.15,
    },

    --Rifles
    ["Base.AssaultRifle2"] = {
        forwardOffset = 0.40,
        sideOffset = 0.08,
        heightOffset = 0.45,
        shellForce = 0.55,
    },

    ["Base.AssaultRifle"] = {
        forwardOffset = 0.30,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.45,
    },

    ["Base.VarmintRifle"] = {
        forwardOffset = 0.30,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.30,
    },

    ["Base.HuntingRifle"] = {
        forwardOffset = 0.30,
        sideOffset = 0.10,
        heightOffset = 0.45,
        shellForce = 0.30,
    },
}

--------------------------------------------------------------------
--- Fallback defaults
--------------------------------------------------------------------
SpentCasingPhysics.DefaultEjectionPortParams = {
    [WeaponReloadType.BOLT_ACTION_NO_MAG] = {
        forwardOffset = 0.30,
        sideOffset    = 0.10,
        heightOffset  = 0.45,
        shellForce    = 0.45,
        sideSpread    = 30,
        heightSpread  = 30,
    },

    [WeaponReloadType.BOLT_ACTION] = {
        forwardOffset = 0.30,
        sideOffset    = 0.10,
        heightOffset  = 0.45,
        shellForce    = 0.75,
        sideSpread    = 60,
        heightSpread  = 30,
        ejectAngle    = 75,
    },

    [WeaponReloadType.SHOTGUN] = {
        forwardOffset = 0.27,
        sideOffset    = 0.10,
        heightOffset  = 0.45,
        shellForce    = 0.25,
        sideSpread    = 30,
        heightSpread  = 30,
        ejectAngle    = 75,
    },

    [WeaponReloadType.DOUBLE_BARREL_SHOTGUN] = {
        forwardOffset = 0.27,
        sideOffset    = 0.0,
        heightOffset  = 0.45,
        shellForce    = 0.15,
        sideSpread    = 30,
        heightSpread  = { 80, 100 },
        ejectAngle    = 180,
    },

    [WeaponReloadType.DOUBLE_BARREL_SHOTGUN_SAWN] = {
        forwardOffset = 0.27,
        sideOffset    = 0.0,
        heightOffset  = 0.45,
        shellForce    = 0.15,
        sideSpread    = 30,
        heightSpread  = { 80, 100 },
        ejectAngle    = 180,
    },

    [WeaponReloadType.HANDGUN] = {
        forwardOffset = 0.40,
        sideOffset    = 0.0,
        heightOffset  = 0.50,
        shellForce    = 0.60,
        sideSpread    = 45,
        heightSpread  = 90,
    },

    [WeaponReloadType.REVOLVER] = {
        forwardOffset = 0.10,
        sideOffset    = 0.0,
        heightOffset  = 0.30,
        shellForce    = 0.10,
        sideSpread    = 30,
        heightSpread  = 30,
    },

    [WeaponReloadType.LEVER_ACTION] = {
        forwardOffset = 0.10,
        sideOffset    = 0.0,
        heightOffset  = 0.32,
        shellForce    = 0.45,
        sideSpread    = 30,
        heightSpread  = 30,
    },
}

--------------------------------------------------------------------
--- Vanilla Ammo to Casing mapping
--------------------------------------------------------------------
SpentCasingPhysics.AMMO_TO_CASING            = {
    ["Base.Bullets9mm"] = "HBVCEF.9x19_Casing",
    ["Base.Bullets45"] = "HBVCEF.45_Casing",
    ["Base.Bullets44"] = "HBVCEF.44_Casing",
    ["Base.Bullets38"] = "HBVCEF.38_Casing",
    ["Base.308Bullets"] = "HBVCEF.762x51_Casing",
    ["Base.556Bullets"] = "HBVCEF.556x45_Casing",
    ["Base.ShotgunShells"] = "HBVCEF.12Gauge_Hull_Red",
    ["Base.3030Bullets"] = "HBVCEF.3030_Casing",
    ["Base.Bullets357"] = "HBVCEF.357_Casing",
}

--------------------------------------------------------------------
--- Register Functions for Params and Casing mapping
--------------------------------------------------------------------
function SpentCasingPhysics.RegisterCasingToAmmo(entries, casingType)
    if type(entries) == "table" then
        for ammoType, itemType in pairs(entries) do
            if type(ammoType) == "string" and type(itemType) == "string" then
                SpentCasingPhysics.AMMO_TO_CASING[ammoType] = itemType
            end
        end
        return
    end

    if type(entries) == "string" and type(casingType) == "string" then
        SpentCasingPhysics.AMMO_TO_CASING[entries] = casingType
    end
end

function SpentCasingPhysics.RegisterWeaponParams(
    weapon,
    forwardOffset,
    sideOffset,
    heightOffset,
    shellForce,
    sideSpread,
    heightSpread,
    ejectAngle,
    verticalForce)
    SpentCasingPhysics.WeaponEjectionPortParams[weapon] = {
        forwardOffset = forwardOffset or 0,
        sideOffset    = sideOffset or 0,
        heightOffset  = heightOffset or 0,
        shellForce    = shellForce or 0,
        sideSpread    = sideSpread or 10,
        heightSpread  = heightSpread or 10,
        ejectAngle    = ejectAngle,
        verticalForce = verticalForce,
    }
end

function SpentCasingPhysics.usesManualSpentRoundRemoval(weapon)
    if not weapon then return false end
    if weapon:isManuallyRemoveSpentRounds() then return true end
    return weapon:getModData().WillRequiredManualRemovalOfAmmo == true
end

return SpentCasingPhysics
