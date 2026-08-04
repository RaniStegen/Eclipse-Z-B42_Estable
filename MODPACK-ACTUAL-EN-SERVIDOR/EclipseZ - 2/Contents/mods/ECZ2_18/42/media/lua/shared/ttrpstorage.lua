local TTRPStorage = {}

function TTRPStorage.readText(path)
    if type(path) ~= "string" or path == "" then
        return nil
    end

    local reader = getFileReader(path, false)
    if not reader then
        return nil
    end

    local lines = {}
    local line = reader:readLine()
    while line do
        table.insert(lines, line)
        line = reader:readLine()
    end
    reader:close()

    return table.concat(lines, "\n")
end

function TTRPStorage.readFirst(paths)
    for _, path in ipairs(paths or {}) do
        local contents = TTRPStorage.readText(path)
        if contents ~= nil then
            return contents, path
        end
    end

    return nil, nil
end

function TTRPStorage.writeText(path, contents)
    if type(path) ~= "string" or path == "" or type(contents) ~= "string" then
        return false
    end

    local writer = getFileWriter(path, true, false)
    if not writer then
        return false
    end

    writer:write(contents)
    writer:close()
    return true
end

return TTRPStorage
