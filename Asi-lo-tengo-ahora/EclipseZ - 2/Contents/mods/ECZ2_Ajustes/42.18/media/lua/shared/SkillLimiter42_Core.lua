ECZSkillLimiter = ECZSkillLimiter or {}
local SL = ECZSkillLimiter

SL.VERSION = "2.2.0-b42.18"
SL.Settings = SL.Settings or nil

local SNAPSHOT_KEY = "ECZSkillLimiter42"
local SNAPSHOT_VERSION = 1

local DEFAULTS = {
    Enable = true,
    AgilityBonus = 0,
    CombatBonus = 0,
    CraftingBonus = 0,
    FirearmBonus = 0,
    SurvivalistBonus = 0,
    PassivesBonus = 0,
    PerkLvl0Cap = 3,
    PerkLvl1Cap = 7,
    PerkLvl2Cap = 9,
    PerkLvl3Cap = 10,
    PerkBonuses = "metalwelding:0;mechanics:0;plantscavenging:0",
}

local CATEGORY_OPTIONS = {
    agility = "AgilityBonus",
    combat = "CombatBonus",
    melee = "CombatBonus",
    crafting = "CraftingBonus",
    farmingcategory = "CraftingBonus",
    firearm = "FirearmBonus",
    survivalist = "SurvivalistBonus",
    passiv = "PassivesBonus",
    passive = "PassivesBonus",
    physical = "PassivesBonus",
    physicalcategory = "PassivesBonus",
}

-- Música pertenece a Lifestyle y queda expresamente fuera del limitador.
-- Se conservan varios identificadores por compatibilidad con distintas versiones.
local EXCLUDED_PERKS = {
    music = true,
    musicskill = true,
    musicianship = true,
    instrument = true,
    instruments = true,
}

local function numberValue(value, default, minimum, maximum)
    local result = tonumber(value)
    if result == nil then result = default end
    if minimum ~= nil and result < minimum then result = minimum end
    if maximum ~= nil and result > maximum then result = maximum end
    return result
end

local function booleanValue(value, default)
    if value == nil then return default end
    if type(value) == "boolean" then return value end
    if type(value) == "number" then return value ~= 0 end
    if type(value) == "string" then
        local text = string.lower(value)
        if text == "true" or text == "1" or text == "yes" or text == "on" then return true end
        if text == "false" or text == "0" or text == "no" or text == "off" then return false end
    end
    return default
end

local function normalized(value)
    if value == nil then return nil end
    local text = string.lower(tostring(value))
    text = string.gsub(text, ".*:", "")
    text = string.gsub(text, "[%s_%.%-]", "")
    return text
end

local function objectId(value)
    if value == nil then return nil end
    if type(value) == "string" then return value end
    if value.getId then
        local ok, result = pcall(function() return value:getId() end)
        if ok and result ~= nil then return tostring(result) end
    end
    if value.getType then
        local ok, result = pcall(function() return value:getType() end)
        if ok and result ~= nil and result ~= value then
            local nested = objectId(result)
            if nested then return nested end
        end
    end
    return tostring(value)
end

function SL.GetPerkObject(perk)
    if perk == nil then return nil end
    if perk.getId and perk.getParent then return perk end

    local candidate = perk
    if type(perk) == "string" and Perks and Perks[perk] then candidate = Perks[perk] end

    if PerkFactory and PerkFactory.getPerk then
        local ok, result = pcall(function() return PerkFactory.getPerk(candidate) end)
        if ok and result then return result end
    end

    if type(perk) == "string" and PerkFactory and PerkFactory.getPerkFromName then
        local ok, result = pcall(function() return PerkFactory.getPerkFromName(perk) end)
        if ok and result then return result end
    end

    return nil
end

function SL.GetPerkEnum(perkObject, original)
    if perkObject and perkObject.getType then
        local ok, result = pcall(function() return perkObject:getType() end)
        if ok and result then return result end
    end
    if original and type(original) ~= "string" then return original end
    return nil
end

function SL.GetPerkId(perkObject, perkEnum)
    return objectId(perkObject) or objectId(perkEnum)
end

function SL.IsExcludedPerk(perkObject, perkId)
    local id = normalized(perkId)
    if not id and perkObject then
        id = normalized(SL.GetPerkId(perkObject, SL.GetPerkEnum(perkObject, perkObject)))
    end
    return id ~= nil and EXCLUDED_PERKS[id] == true
end

local function javaNumber(value)
    if type(value) == "number" then return value end
    if value == nil then return 0 end
    if value.intValue then
        local ok, result = pcall(function() return value:intValue() end)
        if ok and type(result) == "number" then return result end
    end
    if value.doubleValue then
        local ok, result = pcall(function() return value:doubleValue() end)
        if ok and type(result) == "number" then return result end
    end
    return tonumber(tostring(value)) or 0
end

local function tierValue(value)
    return math.floor(numberValue(value, 0, 0, 3))
end

local function eachMap(map, callback)
    if map == nil then return end
    if type(map) == "table" then
        for key, value in pairs(map) do callback(key, value) end
        return
    end
    if transformIntoKahluaTable then
        local ok, tableMap = pcall(transformIntoKahluaTable, map)
        if ok and type(tableMap) == "table" then
            for key, value in pairs(tableMap) do callback(key, value) end
            return
        end
    end
    if map.entrySet then
        local ok, entries = pcall(function() return map:entrySet() end)
        if ok and entries and entries.iterator then
            local iterator = entries:iterator()
            while iterator:hasNext() do
                local entry = iterator:next()
                callback(entry:getKey(), entry:getValue())
            end
        end
    end
end

local function parseCustomBonuses(text)
    local bonuses = {}
    if type(text) ~= "string" then return bonuses end
    for entry in string.gmatch(text, "[^;]+") do
        local perkId, bonus = string.match(entry, "^%s*([^:]+)%s*:%s*([%-]?[%d%.]+)%s*$")
        if perkId and bonus then bonuses[normalized(perkId)] = tonumber(bonus) or 0 end
    end
    return bonuses
end

function SL.LoadSettings()
    SandboxVars = SandboxVars or {}
    SandboxVars.SkillLimiter = SandboxVars.SkillLimiter or {}
    local vars = SandboxVars.SkillLimiter
    for key, default in pairs(DEFAULTS) do
        if vars[key] == nil then vars[key] = default end
    end

    SL.Settings = {
        Enable = booleanValue(vars.Enable, DEFAULTS.Enable),
        AgilityBonus = math.floor(numberValue(vars.AgilityBonus, DEFAULTS.AgilityBonus, 0, 3)),
        CombatBonus = math.floor(numberValue(vars.CombatBonus, DEFAULTS.CombatBonus, 0, 3)),
        CraftingBonus = math.floor(numberValue(vars.CraftingBonus, DEFAULTS.CraftingBonus, 0, 3)),
        FirearmBonus = math.floor(numberValue(vars.FirearmBonus, DEFAULTS.FirearmBonus, 0, 3)),
        SurvivalistBonus = math.floor(numberValue(vars.SurvivalistBonus, DEFAULTS.SurvivalistBonus, 0, 3)),
        PassivesBonus = math.floor(numberValue(vars.PassivesBonus, DEFAULTS.PassivesBonus, 0, 3)),
        PerkLvl0Cap = math.floor(numberValue(vars.PerkLvl0Cap, DEFAULTS.PerkLvl0Cap, 0, 10)),
        PerkLvl1Cap = math.floor(numberValue(vars.PerkLvl1Cap, DEFAULTS.PerkLvl1Cap, 0, 10)),
        PerkLvl2Cap = math.floor(numberValue(vars.PerkLvl2Cap, DEFAULTS.PerkLvl2Cap, 0, 10)),
        PerkLvl3Cap = math.floor(numberValue(vars.PerkLvl3Cap, DEFAULTS.PerkLvl3Cap, 0, 10)),
        PerkBonuses = parseCustomBonuses(vars.PerkBonuses or DEFAULTS.PerkBonuses),
    }
    return SL.Settings
end

local function settings()
    return SL.Settings or SL.LoadSettings()
end

local function categoryOption(perkObject, perkId)
    if SL.IsExcludedPerk(perkObject, perkId) then return nil, false end
    if not perkObject or not perkObject.getParent then return nil, false end
    local ok, parent = pcall(function() return perkObject:getParent() end)
    if not ok or not parent then return nil, false end
    local option = CATEGORY_OPTIONS[normalized(objectId(parent))]
    return option, option ~= nil
end

local function boostFromMap(map, perkId)
    local total = 0
    eachMap(map, function(key, value)
        local keyObject = SL.GetPerkObject(key)
        local keyId = SL.GetPerkId(keyObject, key)
        if normalized(keyId) == normalized(perkId) then total = total + javaNumber(value) end
    end)
    return total
end

local function traitBoost(character, perkId)
    if not character or not character.getTraits or not TraitFactory then return 0 end
    local ok, traits = pcall(function() return character:getTraits() end)
    if not ok or not traits or not traits.size then return 0 end

    local total = 0
    for index = 0, traits:size() - 1 do
        local traitRef = traits:get(index)
        local trait = nil
        if traitRef and traitRef.getXPBoostMap then
            trait = traitRef
        elseif TraitFactory.getTrait then
            local okTrait, result = pcall(function() return TraitFactory.getTrait(objectId(traitRef)) end)
            if okTrait then trait = result end
        end
        if trait and trait.getXPBoostMap then
            local okMap, map = pcall(function() return trait:getXPBoostMap() end)
            if okMap and map then total = total + boostFromMap(map, perkId) end
        end
    end
    return total
end

local function professionBoost(character, perkId)
    if not character or not character.getDescriptor or not ProfessionFactory then return 0 end
    local okDescriptor, descriptor = pcall(function() return character:getDescriptor() end)
    if not okDescriptor or not descriptor then return 0 end

    local professionRef = nil
    if descriptor.getProfession then
        local ok, result = pcall(function() return descriptor:getProfession() end)
        if ok then professionRef = result end
    end

    local profession = professionRef
    if not (profession and profession.getXPBoostMap) and professionRef ~= nil and ProfessionFactory.getProfession then
        local ok, result = pcall(function() return ProfessionFactory.getProfession(objectId(professionRef)) end)
        if ok then profession = result end
    end

    if not profession or not profession.getXPBoostMap then return 0 end
    local okMap, map = pcall(function() return profession:getXPBoostMap() end)
    if not okMap or not map then return 0 end
    return boostFromMap(map, perkId)
end

local function snapshot(character, create)
    if not character or not character.getModData then return nil end
    local ok, modData = pcall(function() return character:getModData() end)
    if not ok or type(modData) ~= "table" then return nil end

    local data = modData[SNAPSHOT_KEY]
    if type(data) ~= "table" then
        if not create then return nil end
        data = { version = SNAPSHOT_VERSION, initialPoints = {} }
        modData[SNAPSHOT_KEY] = data
    end

    if type(data.initialPoints) ~= "table" then
        if not create then return nil end
        data.initialPoints = {}
    end
    data.version = SNAPSHOT_VERSION
    return data
end

function SL.GetStoredInitialPoints(character, perkId)
    if SL.IsExcludedPerk(nil, perkId) then return nil end
    local data = snapshot(character, false)
    local key = normalized(perkId)
    if not data or not key then return nil end
    local value = data.initialPoints[key]
    if value == nil then return nil end
    return tierValue(value)
end

function SL.CaptureInitialPerkPoints(character, perkObject, perkEnum, perkId)
    if SL.IsExcludedPerk(perkObject, perkId) then return nil end
    local key = normalized(perkId)
    if not key then return nil end

    local stored = SL.GetStoredInitialPoints(character, perkId)
    if stored ~= nil then return stored end

    local detected = nil
    local reliable = false
    local xp = character and character.getXp and character:getXp() or nil
    if xp and xp.getPerkBoost and perkEnum then
        local ok, value = pcall(function() return xp:getPerkBoost(perkEnum) end)
        if ok and value ~= nil then
            detected = tierValue(javaNumber(value))
            reliable = true
        end
    end

    if not reliable then
        local fallback = traitBoost(character, perkId) + professionBoost(character, perkId)
        if fallback > 0 then
            detected = tierValue(fallback)
            reliable = true
        end
    end

    if not reliable then return nil end

    local data = snapshot(character, true)
    if not data then return nil end
    data.initialPoints[key] = detected
    return detected
end

function SL.GetTierPoints(character, perkObject, perkId)
    local cfg = settings()
    if not cfg.Enable or SL.IsExcludedPerk(perkObject, perkId) then return nil end

    local option, recognized = categoryOption(perkObject, perkId)
    local custom = cfg.PerkBonuses[normalized(perkId)]
    if not recognized and custom == nil then return nil end

    local perkEnum = SL.GetPerkEnum(perkObject, perkObject)
    local initial = SL.GetStoredInitialPoints(character, perkId)
    if initial == nil then return nil end

    local total = initial
    if option then total = total + (cfg[option] or 0) end
    if custom then total = total + custom end
    return total
end

function SL.GetMaxSkill(character, perk)
    local cfg = settings()
    if not cfg.Enable then return nil end

    local perkObject = SL.GetPerkObject(perk)
    local perkEnum = SL.GetPerkEnum(perkObject, perk)
    local perkId = SL.GetPerkId(perkObject, perkEnum)
    if not perkObject or not perkId then return nil end

    local points = SL.GetTierPoints(character, perkObject, perkId)
    if points == nil then return nil end
    if points <= 0 then return cfg.PerkLvl0Cap end
    if points == 1 then return cfg.PerkLvl1Cap end
    if points == 2 then return cfg.PerkLvl2Cap end
    return cfg.PerkLvl3Cap
end

return SL
