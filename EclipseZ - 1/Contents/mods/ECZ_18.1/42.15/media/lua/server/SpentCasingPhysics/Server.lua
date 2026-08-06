local SpentCasingPhysics                   = require("SpentCasingPhysics/Init")

SpentCasingPhysics.activeCasings           = {}
SpentCasingPhysics.RANDOM                  = newrandom()
SpentCasingPhysics.GRAVITY                 = 0.020
SpentCasingPhysics.XY_STEP                 = 0.10
SpentCasingPhysics.Z_STEP                  = 0.05
SpentCasingPhysics.GRAVITY_SCALE           = 1.0
SpentCasingPhysics.DRAG_XY                 = 0.97
SpentCasingPhysics.DRAG_Z                  = 0.995
SpentCasingPhysics.SETTLE_THRESHOLD        = 0.001
SpentCasingPhysics.BOUNCE_RESTITUTION      = 0.60
SpentCasingPhysics.BOUNCE_POSITION_CORRECT = 0.12
SpentCasingPhysics.BOUNCE_MIN_VELOCITY     = 0.004
SpentCasingPhysics.LOW_WALL_Z_THRESHOLD    = 0.25
SpentCasingPhysics.updateCounter           = 0

SpentCasingPhysics.SurfaceType             = {
    Concrete = "Concrete",
    Dirt     = "Dirt",
    Grass    = "Grass",
    Puddles  = "Puddles",
    Snow     = "Snow",
    Wood     = "Wood",
}

SpentCasingPhysics.FOOTSTEP_TO_SURFACE     = {
    Concrete = SpentCasingPhysics.SurfaceType.Concrete,
    Brick    = SpentCasingPhysics.SurfaceType.Concrete,

    Dirt     = SpentCasingPhysics.SurfaceType.Dirt,
    Gravel   = SpentCasingPhysics.SurfaceType.Dirt,
    Sand     = SpentCasingPhysics.SurfaceType.Dirt,
    Carpet   = SpentCasingPhysics.SurfaceType.Dirt,

    Grass    = SpentCasingPhysics.SurfaceType.Grass,

    Water    = SpentCasingPhysics.SurfaceType.Puddles,

    Snow     = SpentCasingPhysics.SurfaceType.Snow,

    Wood     = SpentCasingPhysics.SurfaceType.Wood,
}

SpentCasingPhysics.CasingImpactSoundParams = {
    Bullet = {
        Concrete = { prefix = "Bullet_Concrete_", variations = 6 },
        Dirt     = { prefix = "Bullet_Dirt_", variations = 6 },
        Grass    = { prefix = "Bullet_Grass_", variations = 6 },
        Puddles  = { prefix = "Bullet_Puddles_", variations = 6 },
        Snow     = { prefix = "Bullet_Snow_", variations = 6 },
        Wood     = { prefix = "Bullet_Wood_", variations = 6 },
    },
    Shells = {
        Concrete = { prefix = "Shells_Concrete_", variations = 6 },
        Dirt     = { prefix = "Shells_Dirt_", variations = 6 },
        Grass    = { prefix = "Shells_Grass_", variations = 6 },
        Puddles  = { prefix = "Shells_Puddles_", variations = 6 },
        Snow     = { prefix = "Shells_Snow_", variations = 6 },
        Wood     = { prefix = "Shells_Wood_", variations = 6 },
    },
    ["40mm"] = {
        Concrete = { prefix = "40mm_Concrete_", variations = 5 },
        Dirt     = { prefix = "40mm_Dirt_", variations = 5 },
        Grass    = { prefix = "40mm_Dirt_", variations = 5 },
        Puddles  = { prefix = "40mm_Concrete_", variations = 5 },
        Snow     = { prefix = "40mm_Snow_", variations = 5 },
        Wood     = { prefix = "40mm_Concrete_", variations = 5 },
    },
}

function SpentCasingPhysics.isLowWall(wall)
    if not wall then return false end
    local props = wall.getProperties and wall:getProperties() or nil
    if not props then return false end

    if props:has(IsoFlagType.transparentW)
        or props:has(IsoFlagType.transparentN)
        or props:has(IsoFlagType.HoppableW)
        or props:has(IsoFlagType.HoppableN)
    then
        return true
    end
    return false
end

function SpentCasingPhysics.isBlockedBetweenSquares(fromSq, toSq, dir, casingZ)
    if not fromSq or not toSq or not dir then return false end

    local barrier = fromSq:getDoorOrWindowOrWindowFrame(dir, true)
    if not barrier then
        local revDir = dir:Rot180()
        barrier = toSq:getDoorOrWindowOrWindowFrame(revDir, true)
    end

    if barrier and (instanceof(barrier, "IsoDoor") or instanceof(barrier, "IsoWindow")) then
        local destroyed = barrier.isDestroyed and barrier:isDestroyed() or false
        if not barrier:IsOpen() and not destroyed then
            return true
        end
        return false
    end

    if fromSq:isWallTo(toSq) then
        local wall1 = fromSq:getWall()
        local wall2 = toSq:getWall()

        local isLow = (wall1 and SpentCasingPhysics.isLowWall(wall1)) or
            (wall2 and SpentCasingPhysics.isLowWall(wall2))

        if isLow then
            return (casingZ or 0) < SpentCasingPhysics.LOW_WALL_Z_THRESHOLD
        end

        return true
    end

    return false
end

function SpentCasingPhysics.isWaterFloor(floor)
    if not floor then return false end
    local props = floor.getProperties and floor:getProperties() or nil
    if not props then return false end

    if props:has(IsoFlagType.water) then
        return true
    end
    return false
end

function SpentCasingPhysics.isSoftFloor(floor)
    if not floor then return false end

    local sq = floor.getSquare and floor:getSquare() or nil
    if sq then
        local cell = getCell()
        if cell and cell:gridSquareIsSnow(sq:getX(), sq:getY(), sq:getZ()) then
            return true
        end
    end

    local props = floor.getProperties and floor:getProperties() or nil
    if not props then return false end

    local mat = props:get("FootstepMaterial")
    if mat == "Grass" or mat == "Sand" or mat == "Snow" then
        return true
    end

    return false
end

function SpentCasingPhysics.getTileTopZ(square)
    if not square then return nil end

    local objects = square:getObjects()
    if not objects then return nil end

    local topZ = nil

    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)
        if obj then
            local surfOff = nil

            if obj.getSurfaceOffsetNoTable then
                surfOff = obj:getSurfaceOffsetNoTable()
            end

            if (not surfOff or surfOff <= 0) and obj.getSurfaceOffset then
                local so = obj:getSurfaceOffset()
                if so and so > 0 then
                    surfOff = so
                end
            end

            if surfOff and surfOff > 0 then
                local z = surfOff / 96.0
                if not topZ or z > topZ then
                    topZ = z
                end
            end
        end
    end

    return topZ
end

function SpentCasingPhysics.getSurfaceTypeFromSquare(square)
    if not square then
        return SpentCasingPhysics.SurfaceType.Concrete
    end

    local floor = square:getFloor()
    if not floor then
        return SpentCasingPhysics.SurfaceType.Concrete
    end

    if SpentCasingPhysics.isWaterFloor(floor) then
        return SpentCasingPhysics.SurfaceType.Puddles
    end

    local cell = getCell()
    if cell and cell.gridSquareIsSnow and cell:gridSquareIsSnow(square:getX(), square:getY(), square:getZ()) then
        return SpentCasingPhysics.SurfaceType.Snow
    end

    local props = floor.getProperties and floor:getProperties() or nil
    if not props then
        return SpentCasingPhysics.SurfaceType.Concrete
    end

    local mat = props:get("FootstepMaterial")
    local surface = SpentCasingPhysics.FOOTSTEP_TO_SURFACE[mat]

    return surface or SpentCasingPhysics.SurfaceType.Concrete
end

function SpentCasingPhysics.getCasingSoundFamily(casing)
    if not casing then
        return "Bullet"
    end

    local weapon = casing.weapon

    if weapon and weapon.getAmmoType then
        local ammoType = weapon:getAmmoType():getItemKey()
        if ammoType and (
                ammoType == "Base.ShotgunShells"
            ) then
            return "Shells"
        end
    end

    if weapon and weapon.getAmmoType then
        local ammoType = weapon:getAmmoType():getItemKey()
        if ammoType and (
                ammoType == "MarzGuns.40mm_Round_Buckshot"
                or ammoType == "MarzGuns.40mm_Round_HE"
            ) then
            return "40mm"
        end
    end

    if weapon and weapon.getShellFallSound then
        local shellSound = weapon:getShellFallSound()
        if shellSound and (
                shellSound == "DoubleBarrelShotgunCartridgeFall" or
                shellSound == "SawnOffDoubleBarrelShotgunCartridgeFall" or
                shellSound == "JS2000ShotgunCartridgeFall" or
                shellSound == "SawnOffJS2000ShotgunCartridgeFall")
        then
            return "Shells"
        end
    end

    return "Bullet"
end

function SpentCasingPhysics.playCasingImpactSound(casing, square)
    if not casing or not casing.repeatCasingSound then return end

    if casing.customSound then
        if isServer() then
            if casing.player then
                sendServerCommand(casing.player, "HBVCEF", "playCasingImpactSound", { sound = casing.customSound })
            else
                sendServerCommand("HBVCEF", "playCasingImpactSound", { sound = casing.customSound })
            end
            return
        end

        if casing.player then
            casing.player:getEmitter():playSound(casing.customSound)
        end
        casing.repeatCasingSound = false
        return
    end

    local family = SpentCasingPhysics.getCasingSoundFamily(casing)
    local surfaceTypeName = SpentCasingPhysics.getSurfaceTypeFromSquare(square)

    local familyParams = SpentCasingPhysics.CasingImpactSoundParams[family]
    if not familyParams then return end

    local params = familyParams[surfaceTypeName] or familyParams.Concrete
    if not params then return end

    local count = params.variations or 1
    local idx = (count > 1) and SpentCasingPhysics.RANDOM:random(1, count) or 1
    local soundName = params.prefix .. tostring(idx)

    if isServer() then
        if casing.player then
            sendServerCommand(casing.player, "HBVCEF", "playCasingImpactSound", { sound = soundName })
        else
            sendServerCommand("HBVCEF", "playCasingImpactSound", { sound = soundName })
        end
        return
    end

    if casing.player then
        casing.player:getEmitter():playSound(soundName)
    end
end

function SpentCasingPhysics.GT()
    return GameTime.getInstance()
end

function SpentCasingPhysics.addCasing(
    player,
    weapon,
    square,
    casingType,
    startX,
    startY,
    startZ,
    velocityX,
    velocityY,
    velocityZ,
    customSound,
    floorBounces)
    if not square then return end

    local casingData = {
        player = player,
        weapon = weapon,
        square = square,
        casingType = casingType,
        x = startX,
        y = startY,
        z = startZ,
        velocityX = velocityX or 0,
        velocityY = velocityY or 0,
        velocityZ = velocityZ or 0.1,
        active = true,
        currentWorldItem = nil,
        floorBounces = floorBounces or SpentCasingPhysics.RANDOM:random(1, 2),
        hasHitFloor = false,
        repeatCasingSound = true,
        customSound = customSound,
    }

    casingData.currentWorldItem = square:AddWorldInventoryItem(casingType, startX, startY, startZ)

    table.insert(SpentCasingPhysics.activeCasings, casingData)
end

function SpentCasingPhysics.removeWorldItem(casing)
    if not casing.currentWorldItem then return end
    local wobj = casing.currentWorldItem:getWorldItem()
    if wobj then
        local wSquare = wobj:getSquare()
        if wSquare then
            if isServer() then
                wSquare:transmitRemoveItemFromSquare(wobj)
            end
            wSquare:removeWorldObject(wobj)
        end
    end
    casing.currentWorldItem = nil
end

function SpentCasingPhysics.update()
    local dt = SpentCasingPhysics.GT():getTimeDelta()
    local scale = dt * 60

    local buffer = SandboxVars.HB.MultiplayerTick or 0
    local shouldRender = true
    if buffer > 0 then
        SpentCasingPhysics.updateCounter = SpentCasingPhysics.updateCounter + 1
        if SpentCasingPhysics.updateCounter > buffer then
            SpentCasingPhysics.updateCounter = 0
        else
            shouldRender = false
        end
    end

    local i = 1

    while i <= #SpentCasingPhysics.activeCasings do
        local casing = SpentCasingPhysics.activeCasings[i]
        local removed = false

        if not casing or not casing.square or not casing.active then
            table.remove(SpentCasingPhysics.activeCasings, i)
            removed = true
        else
            local prevZ = casing.z or 0
            local oldEdgeX = casing.x
            local oldEdgeY = casing.y
            casing.velocityZ = casing.velocityZ -
                (SpentCasingPhysics.GRAVITY * SpentCasingPhysics.GRAVITY_SCALE * scale)

            casing.x = casing.x + (casing.velocityX * SpentCasingPhysics.XY_STEP * scale)
            casing.y = casing.y + (casing.velocityY * SpentCasingPhysics.XY_STEP * scale)
            casing.z = casing.z + (casing.velocityZ * SpentCasingPhysics.Z_STEP * scale)

            casing.z = math.max(0, casing.z)

            local worldX = casing.square:getX() + casing.x
            local worldY = casing.square:getY() + casing.y
            local worldZ = casing.square:getZ()

            local dragXY = math.pow(SpentCasingPhysics.DRAG_XY, scale)
            local dragZ = math.pow(SpentCasingPhysics.DRAG_Z, scale)
            casing.velocityX = casing.velocityX * dragXY
            casing.velocityY = casing.velocityY * dragXY
            casing.velocityZ = casing.velocityZ * dragZ

            local localX = worldX - casing.square:getX()
            local localY = worldY - casing.square:getY()
            local edgeX = localX
            local edgeY = localY

            local EDGE_TOL = 0.15

            local sx = casing.square:getX()
            local sy = casing.square:getY()
            local sz = casing.square:getZ()

            local blockX = false
            local blockY = false

            if casing.velocityX > 0 and oldEdgeX < (1.0 - EDGE_TOL) and edgeX >= (1.0 - EDGE_TOL) then
                local neighbor = getCell():getGridSquare(sx + 1, sy, sz)
                if neighbor and SpentCasingPhysics.isBlockedBetweenSquares(casing.square, neighbor, IsoDirections.E, casing.z) then
                    blockX = true
                end
            elseif casing.velocityX < 0 and oldEdgeX > EDGE_TOL and edgeX <= EDGE_TOL then
                local neighbor = getCell():getGridSquare(sx - 1, sy, sz)
                if neighbor and SpentCasingPhysics.isBlockedBetweenSquares(casing.square, neighbor, IsoDirections.W, casing.z) then
                    blockX = true
                end
            end

            if casing.velocityY > 0 and oldEdgeY < (1.0 - EDGE_TOL) and edgeY >= (1.0 - EDGE_TOL) then
                local neighbor = getCell():getGridSquare(sx, sy + 1, sz)
                if neighbor and SpentCasingPhysics.isBlockedBetweenSquares(casing.square, neighbor, IsoDirections.S, casing.z) then
                    blockY = true
                end
            elseif casing.velocityY < 0 and oldEdgeY > EDGE_TOL and edgeY <= EDGE_TOL then
                local neighbor = getCell():getGridSquare(sx, sy - 1, sz)
                if neighbor and SpentCasingPhysics.isBlockedBetweenSquares(casing.square, neighbor, IsoDirections.N, casing.z) then
                    blockY = true
                end
            end

            if blockX then
                casing.velocityX = -casing.velocityX * SpentCasingPhysics.BOUNCE_RESTITUTION
                casing.x = casing.x + (casing.velocityX * SpentCasingPhysics.BOUNCE_POSITION_CORRECT)
                if math.abs(casing.velocityX) < SpentCasingPhysics.BOUNCE_MIN_VELOCITY then
                    casing.velocityX = 0
                end
            end

            if blockY then
                casing.velocityY = -casing.velocityY * SpentCasingPhysics.BOUNCE_RESTITUTION
                casing.y = casing.y + (casing.velocityY * SpentCasingPhysics.BOUNCE_POSITION_CORRECT)
                if math.abs(casing.velocityY) < SpentCasingPhysics.BOUNCE_MIN_VELOCITY then
                    casing.velocityY = 0
                end
            end

            if blockX or blockY then
                worldX = casing.square:getX() + casing.x
                worldY = casing.square:getY() + casing.y
            end

            local targetTileX = math.floor(worldX)
            local targetTileY = math.floor(worldY)

            local MIN_Z = -32
            local checkZ = worldZ
            local targetSquare = nil
            local drops = 0

            while checkZ >= MIN_Z do
                local sq = getCell():getGridSquare(targetTileX, targetTileY, checkZ)

                if not sq then
                    break
                end

                if sq:getFloor() then
                    targetSquare = sq
                    break
                end

                checkZ = checkZ - 1
                drops = drops + 1
            end

            if not targetSquare then
                targetSquare = casing.square
            else
                if drops > 0 then
                    casing.z = casing.z + drops
                end
            end

            local localX2 = worldX - targetSquare:getX()
            local localY2 = worldY - targetSquare:getY()

            localX2 = PZMath.clamp_01(localX2)
            localY2 = PZMath.clamp_01(localY2)

            if shouldRender then
                SpentCasingPhysics.removeWorldItem(casing)
            end

            local falling = (casing.velocityZ <= 0)

            local tileTopZ = nil
            if not casing.hasHitFloor and falling then
                tileTopZ = SpentCasingPhysics.getTileTopZ(targetSquare)
            end

            local surfaceZ = 0.0

            if tileTopZ then
                if prevZ >= tileTopZ and casing.z <= tileTopZ then
                    surfaceZ = tileTopZ
                end
            end

            if casing.z > surfaceZ then
                if shouldRender then
                    casing.currentWorldItem = targetSquare:AddWorldInventoryItem(
                        casing.casingType,
                        localX2,
                        localY2,
                        casing.z
                    )
                end
            else
                local floor = targetSquare and targetSquare:getFloor() or nil

                if surfaceZ == 0.0 then
                    casing.hasHitFloor = true
                end

                if surfaceZ == 0.0 and SpentCasingPhysics.isWaterFloor(floor) then
                    SpentCasingPhysics.removeWorldItem(casing)
                    casing.active = false
                    table.remove(SpentCasingPhysics.activeCasings, i)
                    removed = true
                    SpentCasingPhysics.playCasingImpactSound(casing, targetSquare)
                else
                    local speedXY = math.sqrt(
                        casing.velocityX * casing.velocityX +
                        casing.velocityY * casing.velocityY
                    )

                    local canBounceHere =
                        casing.floorBounces and casing.floorBounces > 0 and
                        speedXY > SpentCasingPhysics.SETTLE_THRESHOLD
                    if surfaceZ == 0.0 and floor and SpentCasingPhysics.isSoftFloor(floor) then
                        canBounceHere = false
                    end

                    if canBounceHere then
                        casing.floorBounces = casing.floorBounces - 1
                        casing.z            = surfaceZ + 0.05
                        casing.velocityZ    = math.abs(casing.velocityZ) * SpentCasingPhysics.BOUNCE_RESTITUTION
                        casing.velocityX    = casing.velocityX * 0.5
                        casing.velocityY    = casing.velocityY * 0.5

                        if shouldRender then
                            SpentCasingPhysics.removeWorldItem(casing)
                            casing.currentWorldItem = targetSquare:AddWorldInventoryItem(
                                casing.casingType,
                                localX2,
                                localY2,
                                casing.z
                            )
                        end
                        SpentCasingPhysics.playCasingImpactSound(casing, targetSquare)
                    else
                        SpentCasingPhysics.removeWorldItem(casing)
                        if SandboxVars.HB.PermanentCasings then
                            targetSquare:AddWorldInventoryItem(
                                casing.casingType,
                                localX2,
                                localY2,
                                surfaceZ
                            )
                        end
                        if SandboxVars.HB.PermanentCasings and SpentCasingPhysics.AMMOMAKER then
                            ammoMakerItemCleanUpAddModData(casing.casingType, casing.square:getX(), casing.square:getY(), casing.square:getZ())
                        end
                        SpentCasingPhysics.playCasingImpactSound(casing, targetSquare)
                        casing.active = false
                        table.remove(SpentCasingPhysics.activeCasings, i)
                        removed = true
                    end
                end
            end

            if not removed then
                if targetSquare ~= casing.square then
                    casing.square = targetSquare
                end

                casing.x = PZMath.clamp_01(localX2)
                casing.y = PZMath.clamp_01(localY2)
            end
        end

        if not removed then
            i = i + 1
        end
    end
end

function SpentCasingPhysics.getItemToEject(ammoType)
    if SpentCasingPhysics.G93 then
        return ammoType .. "Brass"
    end

    return SpentCasingPhysics.AMMO_TO_CASING[ammoType]
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

function SpentCasingPhysics.spawnCasing(player, weapon)
    if not player or player:isDead() then return end
    if not weapon or not weapon:isRanged() or weapon:isMelee() then return end
    if weapon:isRackAfterShoot()
        or SpentCasingPhysics.usesManualSpentRoundRemoval(weapon) then
        return
    end

    local params = SpentCasingPhysics.WeaponEjectionPortParams[weapon:getFullType()] or
        SpentCasingPhysics.DefaultEjectionPortParams[weapon:getWeaponReloadType()]

    if weapon:isRoundChambered() and not weapon:isJammed() and weapon:haveChamber() then
        if SpentCasingPhysics.VFE and weapon:hasTag(VFETags.m60_link) then
            local brassCatcher = weapon:getWeaponPart('RecoilPad')
            if brassCatcher then
                player:getInventory():AddItem("HBVCEF.308_Casing")
                player:getInventory():AddItem("Base.M60_Link")
            else
                SpentCasingPhysics.doSpawnCasing(player, weapon, params, false, "HBVCEF.308_Casing")
                SpentCasingPhysics.doSpawnCasing(player, weapon, params, false, "Base.M60_Link")
            end
        else
            SpentCasingPhysics.doSpawnCasing(player, weapon, params)
        end
    end
end

function SpentCasingPhysics.rackCasing(player, weapon, racking)
    if not player or player:isDead() then return end
    if not weapon or not weapon:isRanged() or weapon:isMelee() then return end

    local params = SpentCasingPhysics.WeaponEjectionPortParams[weapon:getFullType()] or
        SpentCasingPhysics.DefaultEjectionPortParams[weapon:getWeaponReloadType()]

    if racking then
        if SpentCasingPhysics.VFE and weapon:hasTag(VFETags.m60_link) then
            local brassCatcher = weapon:getWeaponPart('RecoilPad')
            if brassCatcher then
                player:getInventory():AddItem("HBVCEF.308_Casing")
                player:getInventory():AddItem("Base.M60_Link")
            else
                SpentCasingPhysics.doSpawnCasing(player, weapon, params, racking, "HBVCEF.308_Casing")
                SpentCasingPhysics.doSpawnCasing(player, weapon, params, racking, "Base.M60_Link")
            end
        else
            SpentCasingPhysics.doSpawnCasing(player, weapon, params, racking)
        end
    end

    if not racking then
        SpentCasingPhysics.doSpawnCasing(player, weapon, params, racking)
    end
end

function SpentCasingPhysics.getWeaponFromArgs(player, args)
    if not player or not args then return nil end
    if args.weaponId and player:getInventory() and player:getInventory().getItemById then
        local item = player:getInventory():getItemById(args.weaponId)
        if item then return item end
    end

    return player:getPrimaryHandItem()
end

function SpentCasingPhysics.onClientCommand(module, command, player, args)
    if module ~= "HBVCEF" then return end
    if not player then return end

    if command == "spawnCasing" then
        local weapon = SpentCasingPhysics.getWeaponFromArgs(player, args)
        if weapon then
            SpentCasingPhysics.spawnCasing(player, weapon)
        end
    elseif command == "rackCasing" then
        local weapon = SpentCasingPhysics.getWeaponFromArgs(player, args)
        if weapon then
            SpentCasingPhysics.rackCasing(player, weapon, args and args.racking)
        end
    elseif command == "appendSpent" then
        local weapon = SpentCasingPhysics.getWeaponFromArgs(player, args)
        if weapon and args and args.bulletType then
            local spentList = weapon:getModData().SpentAmmoList
            if not spentList then
                spentList = {}
                weapon:getModData().SpentAmmoList = spentList
            end
            spentList[#spentList + 1] = args.bulletType
        end
    end
end

Events.OnClientCommand.Add(SpentCasingPhysics.onClientCommand)
Events.OnTick.Add(SpentCasingPhysics.update)
