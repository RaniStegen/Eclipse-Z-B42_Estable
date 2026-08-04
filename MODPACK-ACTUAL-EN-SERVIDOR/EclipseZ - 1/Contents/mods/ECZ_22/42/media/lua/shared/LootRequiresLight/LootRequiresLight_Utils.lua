LootRequiresLight = LootRequiresLight or {}
LRL_Utils = LRL_Utils or {}

local function sandboxValue(name, fallback)
    if SandboxVars and SandboxVars.LootRequiresLight and SandboxVars.LootRequiresLight[name] ~= nil then
        return SandboxVars.LootRequiresLight[name]
    end
    return fallback
end

function LRL_Utils.isEnabled()
    return sandboxValue("EnableMod", true) and sandboxValue("RequireLightToLoot", true)
end

function LRL_Utils.getTextOrFallback(key, fallback)
    if getTextOrNull and getTextOrNull(key) then
        return getText(key)
    end
    return fallback
end

function LRL_Utils.nowSeconds()
    if getTimestampMs then
        return getTimestampMs() / 1000
    end
    return os.time()
end

function LRL_Utils.getLightThreshold()
    local option = tonumber(sandboxValue("LightThreshold", 2)) or 2
    if option == 1 then return 0.20 end
    if option == 3 then return 0.42 end
    if option == 4 then return 0.55 end
    return 0.32
end

function LRL_Utils.getSearchTimeMultiplier()
    local option = tonumber(sandboxValue("DarknessSearchTimeMultiplier", 2)) or 2
    if option == 1 then return 2.0 end
    if option == 3 then return 4.0 end
    if option == 4 then return 6.0 end
    return 3.0
end

function LRL_Utils.showMessage(player, key, fallback)
    if not sandboxValue("ShowMessages", true) then return end
    if player and player.Say then
        player:Say(LRL_Utils.getTextOrFallback(key, fallback))
    end
end

function LRL_Utils.getContainerSquare(container)
    if not container then return nil end

    local ok, square = pcall(function()
        if container.getSourceGrid then return container:getSourceGrid() end
    end)
    if ok and square then return square end

    ok, square = pcall(function()
        local parent = container.getParent and container:getParent() or nil
        if parent and parent.getSquare then return parent:getSquare() end
    end)
    if ok and square then return square end

    ok, square = pcall(function()
        local item = container.getContainingItem and container:getContainingItem() or nil
        local worldItem = item and item.getWorldItem and item:getWorldItem() or nil
        if worldItem and worldItem.getSquare then return worldItem:getSquare() end
    end)
    if ok and square then return square end

    return nil
end

function LRL_Utils.getContainerParent(container)
    if not container then return nil end
    local ok, parent = pcall(function()
        if container.getParent then return container:getParent() end
    end)
    if ok and parent then return parent end

    ok, parent = pcall(function()
        local item = container.getContainingItem and container:getContainingItem() or nil
        if item and item.getWorldItem then return item:getWorldItem() end
    end)
    if ok then return parent end
    return nil
end

function LRL_Utils.isVehicleContainer(container)
    if not container then return false end

    local ok, part = pcall(function()
        if container.getVehiclePart then
            return container:getVehiclePart()
        end
    end)
    if ok and part then return true end

    local parent = LRL_Utils.getContainerParent(container)
    if parent and instanceof then
        if instanceof(parent, "BaseVehicle") then return true end
    end

    ok, part = pcall(function()
        if parent and parent.getVehicle then
            return parent:getVehicle()
        end
    end)
    return ok and part ~= nil
end

function LRL_Utils.isPersonalContainer(player, container)
    if not player or not container then return true end
    if container.getType and container:getType() == "floor" then return true end
    if container == player:getInventory() then return true end
    if LRL_Utils.isVehicleContainer(container) then return true end

    local ok, result = pcall(function()
        return container:isInCharacterInventory(player)
    end)
    if ok and result then return true end

    local parent = LRL_Utils.getContainerParent(container)
    if parent and instanceof then
        if instanceof(parent, "IsoGameCharacter") then return true end
        if instanceof(parent, "IsoDeadBody") then return true end
    end

    return false
end

function LRL_Utils.isWorldLootContainer(player, container)
    if not container or not player then return false end
    if LRL_Utils.isPersonalContainer(player, container) then return false end
    return LRL_Utils.getContainerSquare(container) ~= nil
end

local function itemIsActiveLight(item)
    if not item then return false end
    local ok, result = pcall(function()
        return item.canEmitLight and item:canEmitLight()
            and item.canBeActivated and item:canBeActivated()
            and item.isActivated and item:isActivated()
            and (not item.getLightStrength or item:getLightStrength() > 0)
    end)
    return ok and result or false
end

function LRL_Utils.hasActiveEquippedLight(player)
    if not player or not sandboxValue("FlashlightAllowsLoot", true) then return false end
    if itemIsActiveLight(player:getPrimaryHandItem()) then return true end
    if itemIsActiveLight(player:getSecondaryHandItem()) then return true end

    local ok, attached = pcall(function()
        if player.getAttachedItems then return player:getAttachedItems() end
    end)
    if ok and attached and attached.size then
        for i = 0, attached:size() - 1 do
            local item = attached:getItemByIndex(i)
            if itemIsActiveLight(item) then return true end
        end
    end

    return false
end

local function squareLight(player, square)
    if not player or not square then return 0 end
    local light = 0

    -- Build 42 exposes the same square light used by foraging through IsoGridSquare:getLightLevel(playerNum).
    local ok, value = pcall(function()
        return square:getLightLevel(player:getPlayerNum())
    end)
    if ok and tonumber(value) then light = math.max(light, tonumber(value)) end

    ok, value = pcall(function()
        if square:isOutside() and getClimateManager then
            return getClimateManager():getDayLightStrength()
        end
    end)
    if ok and tonumber(value) then light = math.max(light, tonumber(value)) end

    return light
end

function LRL_Utils.getEffectiveLightLevel(player, square)
    if not player then return 1 end
    local playerSquare = player:getSquare()
    local light = math.max(squareLight(player, playerSquare), squareLight(player, square))

    -- Fallback for held/attached lights: player:getTorchStrength() is used by vanilla foraging.
    local ok, torch = pcall(function()
        if player.getTorchStrength then return player:getTorchStrength() end
    end)
    if ok and tonumber(torch) then light = math.max(light, math.min(1, tonumber(torch))) end

    if LRL_Utils.hasActiveEquippedLight(player) then
        light = math.max(light, LRL_Utils.getLightThreshold())
    end

    return math.min(1, light)
end

function LRL_Utils.hasEnoughLight(player, square)
    if not LRL_Utils.isEnabled() then return true end
    if not player or not square then return true end
    return LRL_Utils.getEffectiveLightLevel(player, square) >= LRL_Utils.getLightThreshold()
end

function LRL_Utils.containerKey(container)
    if not container then return nil end
    local square = LRL_Utils.getContainerSquare(container)
    local parent = LRL_Utils.getContainerParent(container)
    local ctype = "unknown"
    pcall(function() ctype = container:getType() or ctype end)

    if square then
        local x, y, z = square:getX(), square:getY(), square:getZ()
        local index = "no-parent"
        pcall(function()
            if parent and parent.getObjectIndex then index = tostring(parent:getObjectIndex()) end
        end)
        return table.concat({ tostring(x), tostring(y), tostring(z), tostring(index), tostring(ctype) }, ":")
    end

    return tostring(container)
end

LootRequiresLight.AllowedUntil = LootRequiresLight.AllowedUntil or {}

function LRL_Utils.isTemporarilyAllowed(player, container)
    local key = LRL_Utils.containerKey(container)
    if not key then return false end
    local playerNum = player and player.getPlayerNum and player:getPlayerNum() or 0
    local untilTime = LootRequiresLight.AllowedUntil[playerNum .. "|" .. key]
    return untilTime ~= nil and untilTime > LRL_Utils.nowSeconds()
end

function LRL_Utils.allowTemporarily(player, container, seconds)
    local key = LRL_Utils.containerKey(container)
    if not key then return end
    local playerNum = player and player.getPlayerNum and player:getPlayerNum() or 0
    LootRequiresLight.AllowedUntil[playerNum .. "|" .. key] = LRL_Utils.nowSeconds() + (seconds or 20)
end

function LRL_Utils.shouldBlockContainer(player, container)
    if LRL_Utils.isVehicleContainer(container) then return false end
    if not LRL_Utils.isEnabled() then return false end
    if not LRL_Utils.isWorldLootContainer(player, container) then return false end
    if LRL_Utils.isTemporarilyAllowed(player, container) then return false end
    return not LRL_Utils.hasEnoughLight(player, LRL_Utils.getContainerSquare(container))
end

function LRL_Utils.getMoodledSearchTime(player)
    local time = 120 * LRL_Utils.getSearchTimeMultiplier()
    if not player then return time end

    local stats = player.getStats and player:getStats() or nil
    local body = player.getBodyDamage and player:getBodyDamage() or nil

    -- Time penalties are deliberately read from stable vanilla stats/moodles with nil checks.
    if sandboxValue("PanicSlowsSearching", true) and stats and stats.getPanic then
        time = time * (1.0 + math.min(1.0, stats:getPanic() / 100.0))
    end
    if sandboxValue("TirednessSlowsSearching", true) and stats and stats.getFatigue then
        local fatigue = stats:getFatigue()
        time = time * (1.0 + math.min(2.0, fatigue * 2.0))
        if fatigue >= 0.75 then time = time * 1.5 end
    end
    if sandboxValue("PainSlowsSearching", true) and body and body.getOverallBodyHealth then
        local healthLoss = math.max(0, 100 - body:getOverallBodyHealth())
        time = time * (1.0 + math.min(0.75, healthLoss / 100.0))
    end

    return math.floor(time)
end

function LRL_Utils.getDarkSearchSuccessChance(player)
    local chance = 70
    if not player then return chance end

    local stats = player.getStats and player:getStats() or nil
    local body = player.getBodyDamage and player:getBodyDamage() or nil

    if stats and stats.getPanic then
        chance = chance - math.floor(math.min(25, stats:getPanic() * 0.25))
    end
    if stats and stats.getFatigue then
        chance = chance - math.floor(math.min(25, stats:getFatigue() * 25))
    end
    if body and body.getOverallBodyHealth then
        local healthLoss = math.max(0, 100 - body:getOverallBodyHealth())
        chance = chance - math.floor(math.min(15, healthLoss * 0.15))
    end

    if chance < 25 then chance = 25 end
    if chance > 90 then chance = 90 end
    return chance
end

function LRL_Utils.darkSearchSucceeds(player)
    local chance = LRL_Utils.getDarkSearchSuccessChance(player)
    if ZombRand then
        return ZombRand(100) < chance
    end
    return math.random(100) <= chance
end
