local FAVORITE_BINDING = "TTRP_Favorite"
local ICON_TOGGLE_BINDING = "TTRP_ToggleTreeIcon"
local LIGHT_SOURCE_BINDING = "Equip/Turn On/Off Light Source"

local function findBinding(bindingValue)
    if type(keyBinding) ~= "table" then
        return nil
    end

    for index, binding in ipairs(keyBinding) do
        if binding.value == bindingValue then
            return index
        end
    end

    return nil
end

local function registerKeyBindings()
    if type(keyBinding) ~= "table" then
        return
    end

    local lightSourceIndex = findBinding(LIGHT_SOURCE_BINDING)
    local favoriteIndex = findBinding(FAVORITE_BINDING)

    if not favoriteIndex then
        favoriteIndex = lightSourceIndex and (lightSourceIndex + 1) or (#keyBinding + 1)
        table.insert(keyBinding, favoriteIndex, {
            value = FAVORITE_BINDING,
            key = 53,
        })
    end

    if not findBinding(ICON_TOGGLE_BINDING) then
        table.insert(keyBinding, favoriteIndex + 1, {
            value = ICON_TOGGLE_BINDING,
            key = 0,
        })
    end
end



registerKeyBindings()

Events.OnGameBoot.Add(registerKeyBindings)

return registerKeyBindings
