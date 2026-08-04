local SDRandomZombies = {}

local SPEED_SPRINTER = 1
local SPEED_FAST_SHAMBLER = 2

local COGNITION_SMART = 1
local COGNITION_DEFAULT = 3

local HEARING_PINPOINT = 1
local HEARING_NORMAL = 2

local maxValue = 65536     -- 2^16
local two_32 = 4294967296  -- 2^32

---@param z IsoZombie
local function shouldBeStanding(z)
    return not z:isKnockedDown() and z:getCrawlerType() == 0 and not z:wasFakeDead()
end

local knownZombies = {}
local globalTick = 0
local cacheSize = 0
local lectRand = newrandom()

-- @param string
local function debugPrint(msg)
    if isDebugEnabled()
    then
        print("SDZombies: " .. msg)
    end
end

---@param zombie IsoZombie
---@param sandboxOpts SandboxOptions
local function updateZombie(zombie, sandboxOpts)
    --[[if isClient() and zombie:isRemoteZombie() then
        return false
    end]]
    
    local id = zombie:getOnlineID()
    if id == -1 or id == 0
    then
        if isClient()
        then
            return false
        end
        
        local modData = zombie:getModData()
        if modData.sdzombieID
        then
            id = modData.sdzombieID
        else
            id = lectRand:random(1, 32000)
            modData.sdzombieID = id
        end
    end

    if zombie:isDead() or zombie:getHealth() <= 0
    then
        return false
    end

    local square = zombie:getCurrentSquare()
    if not square
    then
        return false
    end

    local squareXVal = square:getX()
    local squareYVal = square:getY()
    local crawlingVal = zombie:isCrawling()
    
    local cache = knownZombies[id]
    local needsInit = not cache
    
    local hasMoved = false
    local needsRepair = false
    
    if not needsInit
    then
        hasMoved = (math.abs(squareXVal - cache.x) > 30) or (math.abs(squareYVal - cache.y) > 30)
        
        if not hasMoved
        then
            -- 2) Check if the network-synced zombie zone values changed
            local liveSprinterValue = 0
            if cache.zoneName and Zone and Zone.list and Zone.list[cache.zoneName]
            then
                liveSprinterValue = Zone.list[cache.zoneName][8] or 0
            elseif cache.zoneName and NestedZone and NestedZone.list and NestedZone.list[cache.zoneName]
            then
                liveSprinterValue = NestedZone.list[cache.zoneName][8] or 0
            else
                if SandboxVars and SandboxVars.OnWeaponSwing
                then
                    liveSprinterValue = SandboxVars.OnWeaponSwing.basesprinter or 0
                end
            end
            
            -- 3) If zone values are different than the previous cached baseline
            if liveSprinterValue ~= cache.sprinterValue
            then
                local val = id * 2654435769
                local x = val - math.floor(val / two_32) * two_32
                local h = math.floor(x / maxValue)
                local slice = math.floor((h / maxValue) * 10000)

                local distributionLocal = 100 * liveSprinterValue
                if distributionLocal < 100
                then
                    distributionLocal = 0
                end

                local newTargetSpeed = (slice < distributionLocal) and SPEED_SPRINTER or SPEED_FAST_SHAMBLER
                
                if newTargetSpeed ~= cache.speed
                then
                    cache.speed = newTargetSpeed
                    needsRepair = true
                end
                
                cache.sprinterValue = liveSprinterValue
            end

            if not needsRepair and not crawlingVal and zombie:getSpeedType() ~= cache.speed
            then
                needsRepair = true
            end
        end
    end

    if not needsInit and not needsRepair and not hasMoved
    then
        cache.crawl = crawlingVal
        cache.lastSeen = globalTick
        return false
    end

    local targetSpeed, targetHearing, targetCognition
    
    if needsInit or hasMoved
    then
        local val = id * 2654435769
        local x = val - math.floor(val / two_32) * two_32
        local h = math.floor(x / maxValue)
        local slice = math.floor((h / maxValue) * 10000)

        if slice < 0
        then
            slice = 0
        end

        local tier, zone, cx, cy, control, toxic, sprinterValue, pinpointValue, cognitionValue, healthValue = checkZoneAtXY(squareXVal, squareYVal)

        sprinterValue = sprinterValue or 0
        pinpointValue = pinpointValue or 0
        cognitionValue = cognitionValue or 0

        local distributionLocal = 100 * sprinterValue
        local distributionHearing = 100 * pinpointValue
        local distributionCognition = 100 * cognitionValue

        if distributionLocal < 100
        then
            distributionLocal = 0
        end

        targetSpeed = (slice < distributionLocal) and SPEED_SPRINTER or SPEED_FAST_SHAMBLER
        targetHearing = (slice < distributionHearing) and HEARING_PINPOINT or HEARING_NORMAL
        targetCognition = (slice < distributionCognition) and COGNITION_SMART or COGNITION_DEFAULT
        
        -- 1) Initial Set: Cache the zone name and sprinter value
        if needsInit
        then
            cache = {
                x = squareXVal,
                y = squareYVal,
                crawl = crawlingVal,
                zoneName = zone,
                sprinterValue = sprinterValue,
                speed = targetSpeed,
                hearing = targetHearing,
                cognition = targetCognition,
                lastSeen = globalTick
            }
            knownZombies[id] = cache
            cacheSize = cacheSize + 1
        else
            cache.x = squareXVal
            cache.y = squareYVal
            cache.crawl = crawlingVal
            cache.zoneName = zone
            cache.sprinterValue = sprinterValue
            cache.speed = targetSpeed
            cache.hearing = targetHearing
            cache.cognition = targetCognition
            cache.lastSeen = globalTick
        end
        
        sandboxOpts:set("ZombieLore.Hearing", targetHearing)
        sandboxOpts:set("ZombieLore.Cognition", targetCognition)
        zombie:DoZombieStats()
        
        if crawlingVal and targetSpeed == SPEED_SPRINTER and shouldBeStanding(zombie)
        then
            zombie:toggleCrawling()
            zombie:setCanWalk(true)
        end

        if targetSpeed == SPEED_SPRINTER
        then
            zombie:doSprinter()
        else
            zombie:doFastShambler()
        end

    elseif needsRepair
    then
        targetSpeed = cache.speed
        
        if crawlingVal and targetSpeed == SPEED_SPRINTER and shouldBeStanding(zombie)
        then
            zombie:toggleCrawling()
            zombie:setCanWalk(true)
        end

        if targetSpeed == SPEED_SPRINTER
        then
            zombie:doSprinter()
        else
            zombie:doFastShambler()
        end
        
        cache.crawl = crawlingVal
        cache.lastSeen = globalTick
    end
    
    return true
end

local processIndex = 0

local function processZombieBatch()
    local zs = getCell():getZombieList()
    if not zs
    then
        return
    end
    
    local sz = zs:size()
    if sz == 0
    then 
        processIndex = 0
        return 
    end
    
    local sandboxOpts = getSandboxOptions()
    local wasSandboxChanged = false
    
    globalTick = globalTick + 1
    
    if cacheSize > 10000
    then
        local newSize = 0
        for k, v in pairs(knownZombies)
        do
            if globalTick - v.lastSeen > 3600
            then
                knownZombies[k] = nil
            else
                newSize = newSize + 1
            end
        end
        cacheSize = newSize
    end
    
    local batchSize = 20
    local processed = 0
    
    if processIndex >= sz
    then
        processIndex = 0
    end
    
    while processed < batchSize and processIndex < sz
    do
        local z = zs:get(processIndex)
        
        if updateZombie(z, sandboxOpts)
        then
            wasSandboxChanged = true
        end
        
        processIndex = processIndex + 1
        processed = processed + 1
    end
    
    if wasSandboxChanged
    then
        sandboxOpts:set("ZombieLore.Hearing", HEARING_NORMAL)
        sandboxOpts:set("ZombieLore.Cognition", COGNITION_DEFAULT)
    end
end

Events.OnTick.Add(processZombieBatch)