-- RetroDashboard/Coords.lua
-- Єдине джерело координат. Усі значення — абсолютні в полотні 1148x212
-- (база, до масштабу). Походження: spec §5 (Figma "cords", offset +9 по X).
RetroDashboard = RetroDashboard or {}
RetroDashboard.Coords = {}

local C = RetroDashboard.Coords

C.CANVAS_W = 1148
C.CANVAS_H = 212

-- Зони кліку індикаторів: {x, y, w, h, handler}. handler — ім'я статичного
-- методу ISVehicleDashboard (викликається як self[handler](self)).
C.buttons = {
    battery = { x = 511, y = 41,  w = 40, h = 36, handler = nil },             -- лише індикація
    engine  = { x = 555, y = 41,  w = 40, h = 36, handler = "onClickEngine" },
    door    = { x = 599, y = 41,  w = 40, h = 36, handler = "onClickDoors" },
    lights  = { x = 511, y = 81,  w = 40, h = 36, handler = "onClickHeadlights" },
    air     = { x = 555, y = 81,  w = 40, h = 36, handler = "onClickHeater" },
    trunk   = { x = 599, y = 81,  w = 40, h = 36, handler = "onClickTrunk" },
    radio   = { x = 599, y = 123, w = 40, h = 32, handler = "onClickRadio" },
    -- Авторитетні зони з Figma (абсолютні в полотні 1148x212, без +9):
    -- ключ — права ручка; daynight — ліва ручка (свап день/ніч).
    -- Поведінку daynight/ignition підключаємо пізніше (onMouseDown, Task 9+).
    ignition = { x = 1021, y = 124, w = 64, h = 64, handler = "onClickKeys" },
    daynight = { x = 63,   y = 124, w = 64, h = 64, handler = "rdToggleDayNight" },
}

-- Динамічні елементи.
C.gear   = { x = 516, y = 128, w = 18, h = 22 }
C.cruise = { x = 560, y = 128, w = 32, h = 28 }
-- Паливний бар: 9 сегментів 7x22, відступ 3; перші 2 — червоні, решта — оранж.
-- Загораються зліва направо за рівнем; незапалені — тьмяні.
C.fuelBar  = { x = 516, y = 171, segW = 7, segH = 22, gap = 3, count = 9, redCount = 2 }
C.fuelIcon = { x = 620, y = 171, w = 22, h = 22 }

-- Стрілки: pivot — центр циферблата в полотні (де маточина). tex — маточина в
-- PNG 64x200 = ГЕОМЕТРИЧНИЙ ЦЕНТР текстури (32,100). pivotY — TODO точний центр.
C.speedNeedle = { pivotX = 328, pivotY = 170, texPivotX = 32, texPivotY = 100 }
C.rpmNeedle   = { pivotX = 806, pivotY = 170, texPivotX = 32, texPivotY = 100 }

-- Діапазони стрілок. 0 = горизонтально вліво (-90), max = вправо (+90),
-- через верх. CALIBRATE точні значення в грі.
C.SPEED_MAX_MPH = 120
C.SPEED_START_DEG = -90    -- кут при 0 mph (горизонтально вліво)
C.SPEED_SWEEP_DEG = 180    -- розмах до MAX (горизонтально вправо)
C.RPM_MIN = 1000
C.RPM_MAX = 7000
C.RPM_START_DEG = -90
C.RPM_SWEEP_DEG = 180

-- Згладжування стрілок: частка наближення до цілі за кадр @30fps (0..1).
-- Менше = плавніше/повільніше. FPS-незалежне (масштабується в :prerender).
C.NEEDLE_SMOOTH = 0.2

-- Гліфи Digital Numbers: нативна комірка 34x46 (рендер 2x), масштаб у дизайн
-- 0.5 → ~17x23. track — додатковий крок між гліфами (від'ємний = щільніше).
-- Колір #ff9000 (r,g,b). CALIBRATE track/позиції в грі.
C.GLYPH = { nativeW = 34, nativeH = 46, designScale = 0.5, track = -4,
            r = 1.0, g = 0.565, b = 0.0 }

-- Крос-фейд підсвітки день↔ніч: частка за кадр @30fps (швидко, але плавно).
C.NIGHT_FADE = 0.3

-- Мигання підсвітки при ударі машини: загальна тривалість і період on/off (сек).
C.FLICKER_DUR = 0.6
C.FLICKER_BLINK = 0.08

-- Звуки (вбудовані PZ; легко замінити на власний .ogg пізніше).
C.SND_KEY_IN   = "VehicleInsertIgnitionKey"
C.SND_KEY_OUT  = "VehicleRemoveIgnitionKey"
C.SND_BACKLIGHT = "VehicleACButton"

return RetroDashboard.Coords
