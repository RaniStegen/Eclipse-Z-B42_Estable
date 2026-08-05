-- RetroDashboard/State.lua
-- Per-machine збереження масштабу у ~/Zomboid/Lua/RetroDashboard/settings.lua.
RetroDashboard = RetroDashboard or {}
RetroDashboard.State = {}

local FILE = "RetroDashboard/settings.lua"
RetroDashboard.State.VERSION = 1

local function defaults()
    return { version = RetroDashboard.State.VERSION, scale = 1.0 }
end

function RetroDashboard.State.load()
    local d = defaults()
    local reader = getFileReader(FILE, false)
    if not reader then return d end
    local body = {}
    local line = reader:readLine()
    while line do body[#body + 1] = line; line = reader:readLine() end
    reader:close()
    local chunk = loadstring("return " .. table.concat(body, "\n"))
    if not chunk then return d end
    local ok, parsed = pcall(chunk)
    if ok and type(parsed) == "table" and type(parsed.scale) == "number" then
        d.scale = parsed.scale
    end
    return d
end

function RetroDashboard.State.save()
    local writer = getFileWriter(FILE, true, false)
    if not writer then
        print("[RetroDashboard] settings write failed: getFileWriter nil")
        return
    end
    writer:write(string.format('{\n  ["version"] = %d,\n  ["scale"] = %s,\n}',
        RetroDashboard.State.VERSION, tostring(RetroDashboard.scale)))
    writer:close()
end

return RetroDashboard.State
