-- ECZ - Cajas de pilas solo al 100%
-- Bloquea las pilas parcialmente gastadas como ingredientes de Base.PlaceInBox.
-- La receta generica sigue funcionando sin cambios para todos los demas objetos.

ECZ_BatteryBoxFullOnly = ECZ_BatteryBoxFullOnly or {}

-- Tolerancia minima para evitar falsos negativos por redondeo de coma flotante.
local FULL_CHARGE_THRESHOLD = 0.999

local function getFullTypeSafe(item)
    if not item or not item.getFullType then
        return nil
    end

    local ok, fullType = pcall(function()
        return item:getFullType()
    end)

    if ok then
        return fullType
    end

    return nil
end

local function getChargeSafe(item)
    if not item or not item.getUsedDelta then
        return nil
    end

    local ok, charge = pcall(function()
        return item:getUsedDelta()
    end)

    if ok and type(charge) == "number" then
        return charge
    end

    return nil
end

function ECZ_BatteryBoxFullOnly.OnTest(item, result)
    -- No interferir con los demas productos que usan la receta generica PlaceInBox.
    if getFullTypeSafe(item) ~= "Base.Battery" then
        return true
    end

    -- Una pila sin estado de carga valido nunca puede empaquetarse.
    local charge = getChargeSafe(item)
    if charge == nil then
        return false
    end

    return charge >= FULL_CHARGE_THRESHOLD
end
