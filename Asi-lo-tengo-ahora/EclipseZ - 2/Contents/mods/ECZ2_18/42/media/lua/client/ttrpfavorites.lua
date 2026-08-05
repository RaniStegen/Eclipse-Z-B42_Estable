local json = require "ttrpjson"
local storage = require "ttrpstorage"

TTRPFavorites = TTRPFavorites or {}
Favorites = Favorites or {}

local FAVORITES_FILE_PATH = "TTRP_Favorites.txt"
local LEGACY_FAVORITES_FILE_PATHS = {
    "TTRP_Favorites.json",
    "favorites.json",
}
local favoritesLoaded = false

-----------------------------------------------
-- Internal Helper Functions                 --
-----------------------------------------------

local function ensureFavoritesTable()
    Favorites = Favorites or {}
    return Favorites
end

local function jsonEncode(value)
    if type(json) ~= "table" then
        return nil
    end

    local encoder = json.stringify or json.encode or json.Encode
    if type(encoder) ~= "function" then
        return nil
    end

    local ok, result = pcall(encoder, value)
    if not ok then
        print("TTRP Favorites: failed to encode JSON: " .. tostring(result))
        return nil
    end
    return result
end

local function jsonDecode(value)
    if type(json) ~= "table" then
        return nil
    end

    local decoder = json.parse or json.decode or json.Decode
    if type(decoder) ~= "function" then
        return nil
    end

    local ok, result = pcall(decoder, value)
    if not ok then
        print("TTRP Favorites: failed to decode JSON: " .. tostring(result))
        return nil
    end
    return result
end

local function resolveEmoteFunction()
    if type(TTRPdoEmote) == "function" then
        return TTRPdoEmote
    end
    return "TTRPdoEmote"
end

local function normalizeTexturePath(texturePath)
    if type(texturePath) ~= "string" or texturePath == "" then
        return nil
    end

    local normalized = texturePath:gsub("\\\\", "/"):gsub("\\", "/")
    local mediaStart = normalized:lower():find("/media/", 1, true)
    if mediaStart then
        normalized = normalized:sub(mediaStart + 1)
    end
    return normalized
end

local function textureToPath(texture)
    if texture and type(texture) == "userdata" and texture.getName then
        return normalizeTexturePath(texture:getName())
    end

    if type(texture) == "string" then
        return normalizeTexturePath(texture)
    end

    return nil
end

local function getEntryEmote(entryData)
    if type(entryData) ~= "table" then
        return nil
    end

    if type(entryData.command) == "table" and type(entryData.command[2]) == "string" then
        return entryData.command[2]
    end

    if type(entryData.emote) == "string" then
        return entryData.emote
    end

    return nil
end

local function toRuntimeEntry(texture, emote)
    return {
        texture = texture,
        command = { resolveEmoteFunction(), emote }
    }
end

-------------------------------------------------
-- Favorites API for the radial and tree menus --
-------------------------------------------------

function TTRPFavorites.getFilePath()
    return FAVORITES_FILE_PATH
end

function TTRPFavorites.getTable()
    return ensureFavoritesTable()
end

function TTRPFavorites.hasAny()
    for _ in pairs(ensureFavoritesTable()) do
        return true
    end
    return false
end

function TTRPFavorites.contains(label)
    if type(label) ~= "string" then
        return false
    end
    return ensureFavoritesTable()[label] ~= nil
end

function TTRPFavorites.getEntryEmote(entryData)
    return getEntryEmote(entryData)
end

function TTRPFavorites.resolveTexture(texture)
    if type(texture) == "userdata" then
        return texture
    end

    local texturePath = normalizeTexturePath(textureToPath(texture))
    if not texturePath then
        return nil
    end

    return getTexture(texturePath) or texturePath
end

function TTRPFavorites.save()
    local favoritesTable = ensureFavoritesTable()
    local serializableFavorites = {}

    for label, entryData in pairs(favoritesTable) do
        local emote = getEntryEmote(entryData)
        if type(label) == "string" and emote then
            serializableFavorites[label] = {
                texture = textureToPath(entryData.texture),
                command = { "TTRPdoEmote", emote }
            }
        end
    end

    local jsonString = jsonEncode(serializableFavorites)
    if type(jsonString) ~= "string" then
        return false
    end

    if not storage.writeText(FAVORITES_FILE_PATH, jsonString) then
        print("TTRP Favorites: failed to write '" .. FAVORITES_FILE_PATH .. "'")
        return false
    end
    return true
end

function TTRPFavorites.load()
    favoritesLoaded = true

    local candidatePaths = { FAVORITES_FILE_PATH }
    for _, legacyPath in ipairs(LEGACY_FAVORITES_FILE_PATHS) do
        table.insert(candidatePaths, legacyPath)
    end

    local jsonString, loadedPath = storage.readFirst(candidatePaths)
    if jsonString == nil then
        ensureFavoritesTable()
        return Favorites
    end

    if jsonString == "" then
        Favorites = {}
        return Favorites
    end

    local parsed = jsonDecode(jsonString)
    if type(parsed) ~= "table" then
        Favorites = {}
        return Favorites
    end

    local loadedFavorites = {}
    for label, entryData in pairs(parsed) do
        local emote = getEntryEmote(entryData)
        if type(label) == "string" and emote then
            loadedFavorites[label] = toRuntimeEntry(TTRPFavorites.resolveTexture(entryData.texture), emote)
        end
    end

    Favorites = loadedFavorites
    if loadedPath ~= FAVORITES_FILE_PATH then
        if TTRPFavorites.save() then
            print("TTRP Favorites: migrated '" .. loadedPath .. "' to '" .. FAVORITES_FILE_PATH .. "'")
        end
    end
    return Favorites
end

function TTRPFavorites.ensureLoaded()
    if not favoritesLoaded then
        TTRPFavorites.load()
    end
    return ensureFavoritesTable()
end

function TTRPFavorites.toggle(label, texture, emote)
    if type(label) ~= "string" or label == "" or type(emote) ~= "string" or emote == "" then
        return nil
    end

    local favoritesTable = ensureFavoritesTable()
    if favoritesTable[label] then
        favoritesTable[label] = nil
        TTRPFavorites.save()
        return false
    end

    favoritesTable[label] = toRuntimeEntry(texture, emote)
    TTRPFavorites.save()
    return true
end

return TTRPFavorites
