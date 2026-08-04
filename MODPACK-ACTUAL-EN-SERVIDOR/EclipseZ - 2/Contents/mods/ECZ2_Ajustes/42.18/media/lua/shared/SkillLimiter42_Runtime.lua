local SL = require("SkillLimiter42_Core")

SL.Pending = SL.Pending or {}
SL.AuditCountdown = SL.AuditCountdown or {}
SL.InitializationCountdown = SL.InitializationCountdown or {}

local FALLBACK_PERKS = {
    "Fitness", "Strength", "Sprinting", "Lightfoot", "Nimble", "Sneak",
    "Axe", "Blunt", "SmallBlunt", "LongBlade", "SmallBlade", "Spear", "Maintenance",
    "Woodwork", "Cooking", "Farming", "Doctor", "Electricity", "MetalWelding",
    "Mechanics", "Tailoring", "Aiming", "Reloading", "Fishing", "Trapping",
    "PlantScavenging",
}

local function normalized(value)
    if value == nil then return nil end
    local text = string.lower(tostring(value))
    text = string.gsub(text, ".*:", "")
    text = string.gsub(text, "[%s_%.%-]", "")
    return text
end

function SL.GetPlayerKey(player)
    if not player then return "unknown" end
    if player.getOnlineID then
        local ok, id = pcall(function() return player:getOnlineID() end)
        if ok and id and id ~= -1 then return "online:" .. tostring(id) end
    end
    if player.getUsername then
        local ok, username = pcall(function() return player:getUsername() end)
        if ok and username and username ~= "" then return "user:" .. username end
    end
    if player.getPlayerNum then
        local ok, number = pcall(function() return player:getPlayerNum() end)
        if ok and number ~= nil then return "local:" .. tostring(number) end
    end
    return tostring(player)
end

local function levelStartXP(perkEnum, level)
    if not PerkFactory or not PerkFactory.getPerk then return nil end
    local ok, perkObject = pcall(function() return PerkFactory.getPerk(perkEnum) end)
    if not ok or not perkObject or not perkObject.getTotalXpForLevel then return nil end
    local okXP, total = pcall(function() return perkObject:getTotalXpForLevel(level) end)
    if okXP and type(total) == "number" then return total end
    return nil
end

function SL.ClampPerk(player, perkEnum, cap, forceReset)
    if not player or not perkEnum or cap == nil then return false end
    local okLevel, level = pcall(function() return player:getPerkLevel(perkEnum) end)
    if not okLevel or level == nil then return false end

    local xp = player.getXp and player:getXp() or nil
    if not xp then return false end

    local changed = false
    local resetXP = forceReset == true
    if level > cap then
        if player.setPerkLevelDebug then
            pcall(function() player:setPerkLevelDebug(perkEnum, cap) end)
        end
        resetXP = true
        changed = true
    elseif level == cap and xp.getXP then
        local capXP = levelStartXP(perkEnum, cap)
        if capXP ~= nil then
            local okCurrent, currentXP = pcall(function() return xp:getXP(perkEnum) end)
            if okCurrent and type(currentXP) == "number" and currentXP > capXP + 0.001 then
                resetXP = true
            end
        end
    end

    if resetXP and xp.setXPToLevel then
        pcall(function() xp:setXPToLevel(perkEnum, cap) end)
        changed = true
    end
    if changed and SyncXp then pcall(SyncXp, player) end
    return changed
end

function SL.CollectPerks()
    local result = {}
    local seen = {}
    local function add(perk)
        local object = SL.GetPerkObject(perk)
        local enum = SL.GetPerkEnum(object, perk)
        local id = SL.GetPerkId(object, enum)
        local key = normalized(id)
        if object and enum and key and not seen[key] and not SL.IsExcludedPerk(object, id) then
            seen[key] = true
            table.insert(result, { object = object, enum = enum, id = id })
        end
    end

    if PerkFactory and PerkFactory.getPerkList then
        local ok, list = pcall(function() return PerkFactory.getPerkList() end)
        if ok and list and list.size then
            for index = 0, list:size() - 1 do add(list:get(index)) end
        end
    end

    if #result == 0 and Perks and Perks.getMaxIndex and Perks.fromIndex then
        local ok, maxIndex = pcall(function() return Perks.getMaxIndex() end)
        if ok and type(maxIndex) == "number" then
            for index = 0, maxIndex - 1 do
                local okPerk, perk = pcall(function() return Perks.fromIndex(index) end)
                if okPerk and perk then add(perk) end
            end
        end
    end

    for _, name in ipairs(FALLBACK_PERKS) do
        if Perks and Perks[name] then add(Perks[name]) end
    end
    return result
end

function SL.CaptureInitialPoints(player, perks)
    if not player then return 0 end
    local captured = 0
    local list = perks or SL.CollectPerks()
    for _, data in ipairs(list) do
        if SL.GetStoredInitialPoints(player, data.id) == nil then
            local value = SL.CaptureInitialPerkPoints(player, data.object, data.enum, data.id)
            if value ~= nil then captured = captured + 1 end
        end
    end

    -- La instantánea se crea una sola vez por habilidad. Se transmite al
    -- servidor para que sobreviva a reconexiones y no dependa del cliente.
    if captured > 0 and player.transmitModData then
        pcall(function() player:transmitModData() end)
    end
    return captured
end

function SL.AuditPlayer(player)
    local settings = SL.Settings or SL.LoadSettings()
    if not settings.Enable or not player then return end

    local perks = SL.CollectPerks()
    SL.CaptureInitialPoints(player, perks)

    for _, data in ipairs(perks) do
        local cap = SL.GetMaxSkill(player, data.object)
        if cap ~= nil then SL.ClampPerk(player, data.enum, cap, false) end
    end
end

return SL
