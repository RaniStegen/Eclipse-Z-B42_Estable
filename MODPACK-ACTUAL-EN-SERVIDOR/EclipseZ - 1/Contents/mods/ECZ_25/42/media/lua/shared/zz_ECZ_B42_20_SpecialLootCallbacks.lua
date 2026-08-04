-- ECZ_25 / Authentic Z compatibility for Project Zomboid B42.20
-- Restores legacy SpecialLootSpawns callbacks by forwarding to the current
-- ItemCodeOnCreate implementation when it is exposed to Lua.
--
-- Existing functions are never overwritten.

SpecialLootSpawns = SpecialLootSpawns or {}

local reported = {}

local function reportOnce(key, message)
    if reported[key] then
        return
    end
    reported[key] = true
    print("[ECZ B42.20][SpecialLootSpawns] " .. tostring(message))
end

local function invokeItemCode(methodName, item)
    if not item then
        return false
    end

    local bridge = rawget(_G, "ItemCodeOnCreate")
    local method = bridge and bridge[methodName] or nil
    if type(method) ~= "function" then
        reportOnce(methodName, methodName .. " is not exposed; keeping the item usable without legacy initialization.")
        return false
    end

    local ok, err = pcall(method, item)
    if not ok then
        reportOnce(methodName .. ":error", methodName .. " failed safely: " .. tostring(err))
        return false
    end
    return true
end

if type(SpecialLootSpawns.OnCreateGasMask) ~= "function" then
    function SpecialLootSpawns.OnCreateGasMask(item)
        invokeItemCode("onCreateGasMask", item)
    end
end

if type(SpecialLootSpawns.OnCreateRespirator) ~= "function" then
    function SpecialLootSpawns.OnCreateRespirator(item)
        invokeItemCode("onCreateRespirator", item)
    end
end

if type(SpecialLootSpawns.OnCreateSCBA) ~= "function" then
    function SpecialLootSpawns.OnCreateSCBA(item)
        invokeItemCode("onCreateSCBA", item)
    end
end

print("[ECZ B42.20] SpecialLootSpawns compatibility callbacks loaded")
