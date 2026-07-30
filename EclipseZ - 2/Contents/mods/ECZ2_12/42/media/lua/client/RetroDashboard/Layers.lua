-- RetroDashboard/Layers.lua
-- Реєстр повноекранних шарів. Кожен: {key, file, z, isOn(dash)->bool}.
-- isOn отримує екземпляр приборки (self) — має .vehicle, .character, .gasTank.
-- Малюються за зростанням z (Dashboard:render). Фон і ambient — окремо.
RetroDashboard = RetroDashboard or {}
RetroDashboard.Layers = {}

local L = RetroDashboard.Layers
local TEXROOT = "media/textures/RetroDashboard/"

-- Кеш текстур. RetroDashboard.tex("bg_day") -> Texture.
local cache = {}
function RetroDashboard.tex(name)
    if cache[name] == nil then
        cache[name] = getTexture(TEXROOT .. name .. ".png")
    end
    return cache[name]
end

-- Маленькі предикати на машині (нічого не падає, якщо частини нема).
local function veh(d) return d.vehicle end

-- Emissive-шари індикаторів (z з spec §4). Константні день/ніч.
L.emissive = {
    { key = "radio",        file = "em_radio",        z = 3,
      isOn = function(d) local v=veh(d); local p=v and v:getPartById("Radio")
          return p and p:getDeviceData() and p:getDeviceData():getIsTurnedOn() or false end },
    { key = "air_cold",     file = "em_air_cold",     z = 4,
      isOn = function(d) return RetroDashboard.climateState(d) == "cold" end },
    { key = "air_hot",      file = "em_air_hot",      z = 5,
      isOn = function(d) return RetroDashboard.climateState(d) == "hot" end },
    { key = "trunk",        file = "em_trunk",        z = 6,
      isOn = function(d) local v=veh(d); return v and v:getPartById("TruckBed") and v:isTrunkLocked() or false end },
    { key = "lights",       file = "em_lights",       z = 7,
      isOn = function(d) local v=veh(d); return v and v:getHeadlightsOn() or false end },
    { key = "door",         file = "em_door",         z = 8,
      isOn = function(d) local v=veh(d); return v and v:areAllDoorsLocked() or false end },
    { key = "battery",      file = "em_battery",      z = 9,
      isOn = function(d) local v=veh(d)
          if not v then return false end
          if not (v:isEngineRunning() or v:isKeysInIgnition()) then return false end
          return v:getBatteryCharge() <= 0 end },
    { key = "engine_on",    file = "em_engine_on",    z = 10,
      isOn = function(d) local v=veh(d); return v and v:isEngineRunning() and RetroDashboard.engineOk(d) or false end },
    { key = "engine_error", file = "em_engine_error", z = 11,
      isOn = function(d) return not RetroDashboard.engineOk(d) end },
    -- Ключ: рівно один зі станів (z поверх індикаторів).
    { key = "key_in",       file = "key_in",          z = 12,
      isOn = function(d) return RetroDashboard.keyState(d) == "in" end },
    { key = "key_on",       file = "key_on",          z = 12,
      isOn = function(d) return RetroDashboard.keyState(d) == "on" end },
    { key = "key_hotwired", file = "key_hotwired",    z = 12,
      isOn = function(d) return RetroDashboard.keyState(d) == "hotwired" end },
}

-- Клімат за напрямком температури регулятора (ISVehicleACUI):
-- temperature > 0 → "hot" (червоний), < 0 → "cold" (синій), 0/вимк → nil.
-- Діапазон регулятора -25..+25 (vehicle:getHeater():getModData()).
function RetroDashboard.climateState(d)
    local v = veh(d); if not v then return nil end
    local heater
    local okh, h = pcall(function() return v:getHeater() end)
    if okh and h then heater = h else heater = v:getPartById("Heater") end
    if not heater then return nil end
    local md = heater:getModData()
    if not (md and md.active) then return nil end
    local t = md.temperature or 0
    if t > 0 then return "hot" end
    if t < 0 then return "cold" end
    return nil
end

-- Двигун «ок» = немає несправності (ванільний checkEngineFull, через pcall).
function RetroDashboard.engineOk(d)
    local v = veh(d); if not v then return true end
    local ok, res = pcall(function() return d:checkEngineFull() end)
    if not ok then return true end
    return res ~= false
end

-- Стан ключа: "empty" | "in" | "on" | "hotwired".
function RetroDashboard.keyState(d)
    local v = veh(d); if not v then return "empty" end
    if v:isHotwired() then return "hotwired" end
    if v:isEngineRunning() or v:isStarting() then return "on" end
    if v:isKeysInIgnition() then return "in" end
    return "empty"
end

return RetroDashboard.Layers
