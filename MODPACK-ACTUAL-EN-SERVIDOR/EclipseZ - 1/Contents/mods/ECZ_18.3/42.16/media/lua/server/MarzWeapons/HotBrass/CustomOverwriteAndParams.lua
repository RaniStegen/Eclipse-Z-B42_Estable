local SpentCasingPhysics = require("SpentCasingPhysics/Init")
local Ammo = require("WeaponSystems/Utils/Ammo")

local profilesPressures = {
    ["556x45mmBaseAmmo"] = 1.0,
    ["556x45mmCivilianAmmo"] = 0.7,
    ["556x45mmSubsonicAmmo"] = 0.25,
    ["556x45mmArmorPiercingAmmo"] = 1.1,
    ["556x45mmHollowPointAmmo"] = 1.1,
    ["556x45mmOverpressuredAmmo"] = 1.7,
}

if SpentCasingPhysics then
    SpentCasingPhysics.RegisterCasingToAmmo({
        ["MarzGuns.9x19_Bullet"] = "MarzGuns.9x19_Casing",
        ["MarzGuns.45_Bullet"] = "MarzGuns.45_Casing",
        ["MarzGuns.44_Bullet"] = "MarzGuns.44_Casing",
        ["MarzGuns.50_Bullet"] = "MarzGuns.50_Casing",
        ["MarzGuns.500_Bullet"] = "MarzGuns.500_Casing",
        ["MarzGuns.38_Bullet"] = "MarzGuns.38_Casing",
        ["MarzGuns.3030_Bullet"] = "MarzGuns.3030_Casing",
        ["MarzGuns.4570_Bullet"] = "MarzGuns.4570_Casing",
        ["MarzGuns.357_Bullet"] = "MarzGuns.357_Casing",
        ["MarzGuns.545x39_Bullet"] = "MarzGuns.545x39_Casing",
        ["MarzGuns.9x39_Bullet"] = "MarzGuns.9x39_Casing",
        ["MarzGuns.762x39_Bullet"] = "MarzGuns.762x39_Casing",
        ["MarzGuns.762x54_Bullet"] = "MarzGuns.762x54_Casing",
        ["MarzGuns.3006_Bullet"] = "MarzGuns.3006_Casing",

        ["MarzGuns.308_Bullet"] = "MarzGuns.308_Casing",
        ["MarzGuns.762x51_Bullet"] = "MarzGuns.762x51_Casing",

        ["MarzGuns.223_Bullet"] = "MarzGuns.223_Casing",
        ["MarzGuns.556x45_Bullet"] = "MarzGuns.556x45_Casing",
        ["MarzGuns.556x45_Bullet_ArmorPiercing"] = "MarzGuns.556x45_Casing",
        ["MarzGuns.556x45_Bullet_HollowPoint"] = "MarzGuns.556x45_Casing",
        ["MarzGuns.556x45_Bullet_Overpressured"] = "MarzGuns.556x45_Casing",
        ["MarzGuns.556x45_Bullet_Subsonic"] = "MarzGuns.556x45_Casing",

        ["MarzGuns.12Gauge_Shell_Buckshot"] = "MarzGuns.12Gauge_Hull_Red",
        ["MarzGuns.12Gauge_Shell_Slug"] = "MarzGuns.12Gauge_Hull_Green",

        ["MarzGuns.40mm_Round_Buckshot"] = "MarzGuns.40mm_Casing",
        ["MarzGuns.40mm_Round_HE"] = "MarzGuns.40mm_Casing",
        ["MarzGuns.40mm_Round_Incendiary"] = "MarzGuns.40mm_Casing",
    })

    local marzgunsParams = {

        ["MarzGuns.M16A2"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["MarzGuns.M16A3"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["MarzGuns.AR15"] = {
            forwardOffset = 0.30,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["MarzGuns.FNC"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 55,
        },

        ["MarzGuns.M4"] = {
            forwardOffset = 0.32,
            sideOffset    = 0.08,
            heightOffset  = 0.47,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["MarzGuns.FAMAS"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.08,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 55,
        },

        ["MarzGuns.G36C"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 40,
            ejectAngle    = 65,
        },

        ["MarzGuns.G36"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 40,
            ejectAngle    = 65,
        },

        ["MarzGuns.AK74"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 75,
            ejectAngle    = 45,
        },

        ["MarzGuns.AKS74U"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 75,
            ejectAngle    = 45,
        },

        ["MarzGuns.ASVAL"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.09,
            heightOffset  = 0.47,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 75,
            ejectAngle    = 45,
        },

        ["MarzGuns.AK47"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 75,
            ejectAngle    = 45,
        },

        ["MarzGuns.M14"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.55,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 25,
        },

        ["MarzGuns.M1_GARAND"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.40,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 10,
            verticalForce = 0.1,
        },

        ["MarzGuns.G3"] = {
            forwardOffset = 0.37,
            sideOffset    = 0.10,
            heightOffset  = 0.47,
            shellForce    = 1,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 55,
        },

        ["MarzGuns.FAL"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.85,
            sideSpread    = 60,
            heightSpread  = 90,
            ejectAngle    = 80,
        },

        ["MarzGuns.MOSIN"] = {
            forwardOffset = 0.38,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.45,
            sideSpread    = 60,
            heightSpread  = 60,
            ejectAngle    = 70,
        },

        ["MarzGuns.M24"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.45,
            sideSpread    = 60,
            heightSpread  = 60,
        },

        ["MarzGuns.M79"] = {
            forwardOffset = 0.27,
            sideOffset    = 0.0,
            heightOffset  = 0.45,
            shellForce    = 0.15,
            sideSpread    = 30,
            heightSpread  = 1,
            ejectAngle    = 180,
        },

        ["MarzGuns.W1894"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 50,
            heightSpread  = { 40, 50 },
            ejectAngle    = 10,
        },

        ["MarzGuns.M1895"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 50,
            heightSpread  = 30,
            ejectAngle    = 55,
        },

        ["MarzGuns.W1887"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 50,
            heightSpread  = { 40, 50 },
            ejectAngle    = 10,
        },

        ["MarzGuns.W1873"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 50,
            heightSpread  = { 40, 50 },
            ejectAngle    = 45,
        },

        ["MarzGuns.W1873_CARBINE"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.35,
            sideSpread    = 50,
            heightSpread  = { 40, 50 },
            ejectAngle    = 45,
        },

        ["MarzGuns.M60"] = {
            forwardOffset = 0.28,
            sideOffset    = 0.08,
            heightOffset  = 0.49,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["MarzGuns.BAR"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 75,
        },

        ["MarzGuns.M92FS"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 60,
        },

        ["MarzGuns.M93R"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 60,
            ejectAngle    = 45,
        },

        ["MarzGuns.HIPOWER"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 50,
            heightSpread  = 45,
        },

        ["MarzGuns.M1911"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 50,
            heightSpread  = 45,
        },

        ["MarzGuns.USP"] = {
            forwardOffset = 0.40,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.60,
            sideSpread    = 45,
            heightSpread  = 90,
        },

        ["MarzGuns.DEAGLE"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.0,
            heightOffset  = 0.50,
            shellForce    = 0.35,
            sideSpread    = 30,
            heightSpread  = { 100, 130 },
            ejectAngle    = 0,
        },

        ["MarzGuns.SW629"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 50,
            heightSpread  = { 30, 50 },
        },

        ["MarzGuns.PYTHON"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 50,
            heightSpread  = { 30, 50 },
        },

        ["MarzGuns.RHINO"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 50,
            heightSpread  = { 30, 50 },
        },

        ["MarzGuns.MP412"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 50,
            heightSpread  = { 30, 50 },
        },

        ["MarzGuns.COLT_SINGLE"] = {
            forwardOffset = 0.10,
            sideOffset    = 0.0,
            heightOffset  = 0.30,
            shellForce    = 0.10,
            sideSpread    = 50,
            heightSpread  = { 30, 50 },
        },

        ["MarzGuns.SVD"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.90,
            sideSpread    = 90,
            heightSpread  = { 80, 90 },
            ejectAngle    = 65,
        },

        ["MarzGuns.SKS"] = {
            forwardOffset = 0.35,
            sideOffset    = 0.10,
            heightOffset  = 0.45,
            shellForce    = 0.40,
            sideSpread    = 90,
            heightSpread  = { 70, 80 },
            ejectAngle    = 30,
            verticalForce = 0.1,
        },

        ["MarzGuns.PSG1"] = {
            forwardOffset = 0.37,
            sideOffset    = 0.10,
            heightOffset  = 0.47,
            shellForce    = 1,
            sideSpread    = 60,
            heightSpread  = 30,
            ejectAngle    = 55,
        },

        ["MarzGuns.THOMPSON"] = {
            forwardOffset = 0.34,
            sideOffset    = 0.08,
            heightOffset  = 0.48,
            shellForce    = 0.75,
            sideSpread    = 50,
            heightSpread  = { 80, 100 },
            ejectAngle    = 90,
        },

        ["MarzGuns.MP5"] = {
            forwardOffset = 0.36,
            sideOffset    = 0.08,
            heightOffset  = 0.48,
            shellForce    = 0.65,
            sideSpread    = 50,
            heightSpread  = { 80, 100 },
            ejectAngle    = 80,
        },

        ["MarzGuns.MP5K"] = {
            forwardOffset = 0.55,
            sideOffset    = 0.06,
            heightOffset  = 0.53,
            shellForce    = 0.65,
            sideSpread    = 50,
            heightSpread  = { 80, 100 },
            ejectAngle    = 80,
        },

        ["MarzGuns.AA12"] = {
            forwardOffset = 0.32,
            sideOffset    = 0.06,
            heightOffset  = 0.45,
            shellForce    = 0.65,
            sideSpread    = 50,
            heightSpread  = 50,
            ejectAngle    = 75,
        },
    }

    for weapon, data in pairs(marzgunsParams) do
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

    function SpentCasingPhysics.doSpawnCasing(player, weapon, params, racking, optionalItem)
        local forwardOffset = params and params.forwardOffset or 0.10
        local sideOffset    = params and params.sideOffset or 0.10
        local heightOffset  = params and params.heightOffset or 0.5
        local shellForce    = params and params.shellForce or 0.20
        local sideSpread    = params and params.sideSpread or 10
        local heightSpread  = params and params.heightSpread or 10
        local ejectAngle    = params and params.ejectAngle
        local verticalForce = params and params.verticalForce or 0
        local customSound   = params and params.customSound or nil
        local floorBounces  = params and params.floorBounces
        local ammoType      = weapon:getAmmoType():getItemKey()
        if not ammoType then return end

        local itemToEject = SpentCasingPhysics.getItemToEject(ammoType)
        if racking then
            itemToEject = ammoType
        end
        if optionalItem then
            itemToEject = optionalItem
        end
        if not itemToEject then return end

        local px, py, pz = player:getX(), player:getY(), player:getZ()

        local angleDeg = player:getDirectionAngle() or 0
        local angleRad = math.rad(angleDeg)

        local fx = math.cos(angleRad)
        local fy = math.sin(angleRad)
        local rx = math.cos(angleRad + math.pi / 2)
        local ry = math.sin(angleRad + math.pi / 2)

        local spawnWorldX = px + fx * forwardOffset + rx * sideOffset
        local spawnWorldY = py + fy * forwardOffset + ry * sideOffset
        local targetSquare = player:getCurrentSquare()
        if not targetSquare then return end

        local startX = spawnWorldX - targetSquare:getX()
        local startY = spawnWorldY - targetSquare:getY()

        local stairFrac = pz - targetSquare:getZ()
        local startZ = stairFrac + heightOffset

        local velX = (SpentCasingPhysics.RANDOM:random(sideSpread) - 5) / 200.0
        local velY = (SpentCasingPhysics.RANDOM:random(sideSpread) - 5) / 200.0

        local velZ
        if type(heightSpread) == "table" then
            local minH = tonumber(heightSpread[1]) or 0
            local maxH = tonumber(heightSpread[2]) or minH
            if maxH < minH then
                minH, maxH = maxH, minH
            end
            local rawH = SpentCasingPhysics.RANDOM:random(minH, maxH)
            velZ = rawH / 200.0
        else
            velZ = (SpentCasingPhysics.RANDOM:random(heightSpread) + 25) / 200.0
        end

        velZ = velZ + verticalForce

        local pressureMultiplier = profilesPressures[Ammo.GetAmmoCharacteristics(ammoType)] or 1.0

        if pressureMultiplier then
            shellForce = shellForce * pressureMultiplier
        end

        if racking then
            shellForce = 0.35
        end

        if shellForce ~= 0 then
            local dirX, dirY
            if ejectAngle ~= nil then
                local totalDeg = angleDeg + ejectAngle
                local totalRad = math.rad(totalDeg)
                dirX = math.cos(totalRad)
                dirY = math.sin(totalRad)
            else
                dirX = rx
                dirY = ry
            end

            velX = velX + dirX * shellForce
            velY = velY + dirY * shellForce
        end

        SpentCasingPhysics.addCasing(
            player,
            weapon,
            targetSquare,
            itemToEject,
            startX,
            startY,
            startZ,
            velX,
            velY,
            velZ,
            customSound,
            floorBounces
        )
    end
end
