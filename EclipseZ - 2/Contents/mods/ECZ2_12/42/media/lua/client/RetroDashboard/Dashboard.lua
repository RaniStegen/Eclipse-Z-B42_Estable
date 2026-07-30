-- RetroDashboard/Dashboard.lua
-- Monkey-patch ванільного ISVehicleDashboard: повна заміна вигляду.
require "Vehicles/ISUI/ISVehicleDashboard"
require "ISUI/ISContextMenu"
require "RetroDashboard/Coords"
require "RetroDashboard/Layers"
require "RetroDashboard/State"

RetroDashboard = RetroDashboard or {}
local C = RetroDashboard.Coords

-- Глобальний масштаб (Task 10 під'єднає збереження). Дефолт 100%.
RetroDashboard.scale = RetroDashboard.scale or 1.0

-- Ніч: 18:00–06:00 (CALIBRATE діапазон за смаком).
function RetroDashboard.isNight()
    local gt = getGameTime()
    if not gt then return false end
    local h = gt:getHour()
    return h >= 18 or h < 6
end

local DASH = ISVehicleDashboard

-- :new — лишаємо ванільну ініціалізацію (playerNum, character, gauges),
-- але одразу довантажуємо наші текстури й фіксуємо ширину полотна.
local vanillaNew = DASH.new
function DASH:new(playerNum, chr)
    local o = vanillaNew(self, playerNum, chr)
    o.rd_bgDay   = RetroDashboard.tex("bg_day")
    o.rd_bgNight = RetroDashboard.tex("bg_night")
    o.rd_ambient = RetroDashboard.tex("ambient_night")
    o:setWidth(C.CANVAS_W * RetroDashboard.scale)
    o:setHeight(C.CANVAS_H * RetroDashboard.scale)
    return o
end

-- :createChildren — НЕ створюємо ванільних дочірніх віджетів. Малюємо все самі.
function DASH:createChildren()
    -- навмисно порожньо
end

-- :setVehicle — спрощена версія: тільки прив'язка машини й видимість.
function DASH:setVehicle(vehicle)
    self.vehicle = vehicle
    if not vehicle then
        self:removeFromUIManager()
        return
    end
    local part = vehicle:getPartById("GasTank")
    if part and part:isContainer() and part:getContainerContentType() then
        self.gasTank = part
    else
        self.gasTank = nil
    end
    self.dispMph = nil   -- скинути згладжування стрілок для нової машини
    self.dispRpm = nil
    self.rd_nightFade = nil   -- без хибного фейду підсвітки на вході
    self.rd_prevKey = nil     -- без хибного звуку ключа на вході
    self.rd_flickerT = nil    -- скинути мигання
    self:setVisible(true)
    self:addToUIManager()
    self:onResolutionChange()
    if not ISUIHandler.allUIVisible then
        self:removeFromUIManager()
    end
end

-- :prerender — згладжування стрілок (плавний набір/скид замість стрибків,
-- напр. при перемиканні передачі). Зберігаємо показуване значення на self і
-- щокадру наближаємо його до цільового. FPS-незалежне експ. згладжування.
function DASH:prerender()
    if not self.vehicle then return end
    local v = self.vehicle
    local tMph, tRpm = 0, 0
    if v:isEngineRunning() then
        tMph = math.abs(v:getCurrentSpeedKmHour()) * 0.621371
        tRpm = v:getEngineSpeed()
    end
    if self.dispMph == nil then self.dispMph = tMph end
    if self.dispRpm == nil then self.dispRpm = tRpm end
    local fps = 30
    local okf, perf = pcall(function() return getPerformance():getUIRenderFPS() end)
    if okf and perf and perf > 1 then fps = perf end
    local a = 1 - (1 - C.NEEDLE_SMOOTH) ^ (30 / fps)
    self.dispMph = self.dispMph + (tMph - self.dispMph) * a
    self.dispRpm = self.dispRpm + (tRpm - self.dispRpm) * a

    -- день/ніч: авто за часом + ручний override, який авто-скидається на межі
    -- (їхали вночі, настав день → перемкнеться авто, навіть якщо було вручну).
    local autoNight = RetroDashboard.isNight()
    if self.rd_lastAuto ~= nil and autoNight ~= self.rd_lastAuto then
        self.rd_manual = nil
    end
    self.rd_lastAuto = autoNight
    if self.rd_manual ~= nil then self.rd_night = self.rd_manual else self.rd_night = autoNight end

    -- крос-фейд підсвітки до цільового стану (день=0, ніч=1): швидко, але плавно
    local target = self.rd_night and 1 or 0
    if self.rd_nightFade == nil then self.rd_nightFade = target end
    local fa = 1 - (1 - C.NIGHT_FADE) ^ (30 / fps)
    self.rd_nightFade = self.rd_nightFade + (target - self.rd_nightFade) * fa

    -- звук вставлення/виймання ключа на зміні стану
    local ks = RetroDashboard.keyState(self)
    if self.rd_prevKey == nil then self.rd_prevKey = ks end
    if ks ~= self.rd_prevKey then
        if self.character then
            if (ks == "in" or ks == "on") and self.rd_prevKey == "empty" then
                self.character:playSound(C.SND_KEY_IN)
            elseif ks == "empty" then
                self.character:playSound(C.SND_KEY_OUT)
            end
        end
        self.rd_prevKey = ks
    end

    -- мигання підсвітки при ударі: множник альфи нічного шару (1=норма, 0=гасне)
    self.rd_flickerMul = 1
    if self.rd_flickerT and self.rd_flickerT > 0 then
        self.rd_flickerT = self.rd_flickerT - 1 / fps
        local elapsed = C.FLICKER_DUR - self.rd_flickerT
        local seg = math.floor(elapsed / C.FLICKER_BLINK)
        self.rd_flickerMul = (seg % 2 == 0) and 0 or 1
        if self.rd_flickerT <= 0 then self.rd_flickerMul = 1 end
    end
end

-- Малює спрайт-стрілку, повернуту на angleDeg і масштабовану на S, навколо
-- (cx, cy) у локальних координатах панелі. tex 64x200; (tpx,tpy) — pivot у
-- текстурі. Використовуємо drawTextureAllPoint (DrawTextureAngle не масштабує).
function RetroDashboard.drawNeedle(self, tex, cx, cy, angleDeg, S, tpx, tpy)
    -- drawTextureAllPoint малює в АБСОЛЮТНИХ екранних координатах (на відміну
    -- від drawTextureScaled/drawRect, які локальні). Тому додаємо абсолютну
    -- позицію панелі — інакше стрілка «літає» у кутку екрана.
    local ox, oy = self:getAbsoluteX(), self:getAbsoluteY()
    local w, h = 64, 200
    local rad = math.rad(angleDeg)
    local cosA, sinA = math.cos(rad), math.sin(rad)
    local corners = {
        { -tpx,      -tpy },       -- TL
        {  w - tpx,  -tpy },       -- TR
        {  w - tpx,   h - tpy },   -- BR
        { -tpx,       h - tpy },   -- BL
    }
    local p = {}
    for i = 1, 4 do
        local lx, ly = corners[i][1] * S, corners[i][2] * S
        p[i] = {
            ox + cx + (lx * cosA - ly * sinA),
            oy + cy + (lx * sinA + ly * cosA),
        }
    end
    self:drawTextureAllPoint(tex,
        p[1][1], p[1][2], p[2][1], p[2][2],
        p[3][1], p[3][2], p[4][1], p[4][2],
        1, 1, 1, 1)
end

-- mph -> кут; rpm -> кут (лінійно по діапазону). CALIBRATE start/sweep у Coords.
function RetroDashboard.speedAngle(mph)
    local f = math.max(0, math.min(1, mph / C.SPEED_MAX_MPH))
    return C.SPEED_START_DEG + f * C.SPEED_SWEEP_DEG
end
function RetroDashboard.rpmAngle(rpm)
    local span = C.RPM_MAX - C.RPM_MIN
    local f = math.max(0, math.min(1, (rpm - C.RPM_MIN) / span))
    return C.RPM_START_DEG + f * C.RPM_SWEEP_DEG
end

-- Гліфи Digital Numbers: char -> файл у glyphs/. nil = не малюємо (пропуск).
local GLYPH_KEYS = {
    ["0"]="g_0",["1"]="g_1",["2"]="g_2",["3"]="g_3",["4"]="g_4",["5"]="g_5",
    ["6"]="g_6",["7"]="g_7",["8"]="g_8",["9"]="g_9",
    ["N"]="g_N",["R"]="g_R",["P"]="g_P",["D"]="g_D",
}

-- Малює рядок гліфами (x,y — дизайн-координати лівого-верхнього; *S всередині).
-- Колір/трек з C.GLYPH. drawTextureScaled — локальні координати панелі.
function RetroDashboard.drawGlyphs(self, str, x, y, S, dim)
    local G = C.GLYPH
    local m = dim and 0.3 or 1.0                 -- тьмяний варіант (вимк. круїз)
    local w = G.nativeW * G.designScale * S
    local h = G.nativeH * G.designScale * S
    local adv = (G.nativeW * G.designScale + G.track) * S
    local cx, cy = x * S, y * S
    for i = 1, #str do
        local key = GLYPH_KEYS[string.sub(str, i, i)]
        if key then
            self:drawTextureScaled(RetroDashboard.tex("glyphs/" .. key), cx, cy, w, h, 1, G.r * m, G.g * m, G.b * m)
        end
        cx = cx + adv
    end
end

-- :render — фон + emissive-шари (z-порядок) + ambient зверху вночі.
function DASH:render()
    if not self.vehicle then return end
    local S = RetroDashboard.scale
    local W, H = C.CANVAS_W * S, C.CANVAS_H * S

    -- 1) фон: крос-фейд день↔ніч (плавна підсвітка), rd_nightFade у :prerender
    local fade = self.rd_nightFade
    if fade == nil then fade = ((self.rd_night or RetroDashboard.isNight()) and 1) or 0 end
    local night = fade >= 0.5
    local renderFade = fade * (self.rd_flickerMul or 1)   -- мигання при ударі
    self:drawTextureScaled(self.rd_bgDay, 0, 0, W, H, 1, 1, 1, 1)
    if renderFade > 0.001 then
        self:drawTextureScaled(self.rd_bgNight, 0, 0, W, H, renderFade, 1, 1, 1)
    end

    -- 2) emissive-індикатори за зростанням z (реєстр уже в порядку z)
    for _, layer in ipairs(RetroDashboard.Layers.emissive) do
        if layer.isOn(self) then
            self:drawTextureScaled(RetroDashboard.tex(layer.file), 0, 0, W, H, 1, 1, 1, 1)
        end
    end

    -- 3a) стрілки (значення згладжені в :prerender)
    do
        local mph = self.dispMph or 0
        local rpm = self.dispRpm or 0
        local needle = night and RetroDashboard.tex("needle_night")
                             or RetroDashboard.tex("needle_day")
        local sp = C.speedNeedle
        RetroDashboard.drawNeedle(self, needle, sp.pivotX * S, sp.pivotY * S,
            RetroDashboard.speedAngle(mph), S, sp.texPivotX, sp.texPivotY)
        local rp = C.rpmNeedle
        RetroDashboard.drawNeedle(self, needle, rp.pivotX * S, rp.pivotY * S,
            RetroDashboard.rpmAngle(rpm), S, rp.texPivotX, rp.texPivotY)
    end

    -- 3b) паливо: сегментний бар (9 секцій) + іконка
    do
        local pct = 0
        if self.gasTank then
            local v = self.vehicle
            local ok, val = pcall(function() return v:getRemainingFuelPercentage() end)
            pct = (ok and val) or 0
        end
        local fb = C.fuelBar
        local fill = math.max(0, math.min(1, pct / 100))
        local litCount = math.ceil(fill * fb.count)
        for i = 1, fb.count do
            local sx = (fb.x + (i - 1) * (fb.segW + fb.gap)) * S
            local sy = fb.y * S
            local r, g, b                              -- колір за позицією
            if i <= fb.redCount then r, g, b = 1.0, 0.12, 0.06   -- червоний
            else r, g, b = 1.0, 0.55, 0.0 end                    -- оранжевий
            if i <= litCount then
                self:drawRect(sx, sy, fb.segW * S, fb.segH * S, 0.95, r, g, b)
            else                                       -- незапалений = тьмяний
                self:drawRect(sx, sy, fb.segW * S, fb.segH * S, 0.9, r * 0.22, g * 0.22, b * 0.22)
            end
        end
        -- іконка пального — повноекранний PNG: оранж >=20%, червона <20%
        local icon = (pct < 20) and RetroDashboard.tex("fuel_icon_red")
                                or RetroDashboard.tex("fuel_icon_orange")
        self:drawTextureScaled(icon, 0, 0, W, H, 1, 1, 1, 1)
    end

    -- 3c) гліфи Digital Numbers: передача + круїз-швидкість
    do
        local v = self.vehicle
        local gear = "P"
        if v:isEngineRunning() then
            local ok, val = pcall(function() return v:getTransmissionNumberLetter() end)
            if ok and val and val ~= "" then gear = tostring(val) end
        end
        RetroDashboard.drawGlyphs(self, gear, C.gear.x, C.gear.y, S)
        -- круїз: завжди показуємо; тьмяно коли вимкнено. Право-вирівняний:
        -- 2-значне число стоїть на cruise.x, кожен зайвий розряд зсуває вліво.
        local reg = 0
        local okr, rs = pcall(function() return v:getRegulatorSpeed() end)
        if okr and rs then reg = math.floor(rs) end
        local s = tostring(reg)
        local advD = C.GLYPH.nativeW * C.GLYPH.designScale + C.GLYPH.track
        local cruiseX = C.cruise.x + (2 - #s) * advD
        RetroDashboard.drawGlyphs(self, s, cruiseX, C.cruise.y, S, not v:isRegulator())
    end

    -- 4) ambient permanent (нічний топ-шар) ВИМКНЕНО: при текстурній компресії
    -- плавний градієнт перетворюється на монотонну пляму. Повернути, якщо
    -- вирішимо проблему компресії.
    -- if night then self:drawTextureScaled(self.rd_ambient, 0, 0, W, H, 1, 1, 1, 1) end
end

-- :onResolutionChange — притиснути панель до низу-центру з урахуванням масштабу.
function DASH:onResolutionChange()
    local S = RetroDashboard.scale
    local screenLeft   = getPlayerScreenLeft(self.playerNum)
    local screenTop    = getPlayerScreenTop(self.playerNum)
    local screenWidth  = getPlayerScreenWidth(self.playerNum)
    local screenHeight = getPlayerScreenHeight(self.playerNum)
    self:setWidth(C.CANVAS_W * S)
    self:setHeight(C.CANVAS_H * S)
    self:setX(screenLeft + (screenWidth - self:getWidth()) / 2)
    self:setY(screenTop + screenHeight - self:getHeight())
end

-- Чи точка (локальні координати панелі) у масштабованому прямокутнику зони.
local function hitZone(btn, S, x, y)
    local bx, by = btn.x * S, btn.y * S
    local bw, bh = btn.w * S, btn.h * S
    return x >= bx and x <= bx + bw and y >= by and y <= by + bh
end

-- ЛКМ по панелі: знайти зону й викликати її обробник (ванільний або наш).
-- Ванільні onClick* і наш rdToggleDayNight — усі методи ISVehicleDashboard.
function DASH:onMouseDown(x, y)
    if not self.vehicle then return false end
    local S = RetroDashboard.scale
    for _, btn in pairs(C.buttons) do
        if btn.handler and hitZone(btn, S, x, y) then
            local fn = ISVehicleDashboard[btn.handler]
            if fn then fn(self); return true end
        end
    end
    return false
end

-- Ручний тумблер день/ніч: фліпає поточний режим (авто-скинеться на межі).
function DASH:rdToggleDayNight()
    local cur = self.rd_night
    if cur == nil then cur = RetroDashboard.isNight() end
    self.rd_manual = not cur
    self.rd_night = self.rd_manual
    getSoundManager():playUISound(C.SND_BACKLIGHT)
end

-- ПКМ по панелі → контекстне меню з пресетами масштабу.
local SCALE_PRESETS = { 0.50, 0.75, 0.90, 1.00, 1.10, 1.25, 1.50 }
function DASH:onRightMouseDown(x, y)
    local menu = ISContextMenu.get(self.playerNum, self:getAbsoluteX() + x, self:getAbsoluteY() + y)
    local sub = ISContextMenu:getNew(menu)
    local parent = menu:addOption(getText("ContextMenu_RetroDash_Scale"), nil, nil)
    menu:addSubMenu(parent, sub)
    for _, p in ipairs(SCALE_PRESETS) do
        local opt = sub:addOption(tostring(math.floor(p * 100 + 0.5)) .. "%", self, DASH.onPickScale, p)
        if math.abs(RetroDashboard.scale - p) < 0.001 then
            sub:setOptionChecked(opt, true)
        end
    end
    return true
end

function DASH:onPickScale(scale)
    RetroDashboard.scale = scale
    RetroDashboard.State.save()
    self:onResolutionChange()
end

-- Старт мигання підсвітки (викликається з damageFlick при ударі).
function DASH:rdStartFlicker()
    self.rd_flickerT = C.FLICKER_DUR
end

-- Перевизначаємо ванільний damageFlick: замість мигання кнопок — мигання
-- підсвітки нашого дашборда. Детекцію удару робить ванільний damageChecker
-- (OnTick, лишився активним), що викликає цю функцію через таблицю класу.
function ISVehicleDashboard.damageFlick(character)
    if not (instanceof(character, 'IsoPlayer') and character:isLocalPlayer()) then return end
    local dash = getPlayerVehicleDashboard(character:getPlayerNum())
    if dash then dash:rdStartFlicker() end
end
