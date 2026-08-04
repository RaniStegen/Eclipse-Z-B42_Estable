-- Build 42.20 compatibility.
-- Entity SpriteConfig validation can resolve Lua callbacks on both client and server.
-- Neat Building previously declared these functions only in media/lua/server,
-- causing custom entities to be marked invalid while chunks were streamed.

NB_BuildRecipeCode = NB_BuildRecipeCode or {}

local callbackGroups = {
    "PartFloors",
    "Floors",
    "WindowWall",
    "BigGate",
    "NewWall",
}

for _, groupName in ipairs(callbackGroups) do
    NB_BuildRecipeCode[groupName] = NB_BuildRecipeCode[groupName] or {}
    if type(NB_BuildRecipeCode[groupName].OnCreate) ~= "function" then
        NB_BuildRecipeCode[groupName].OnCreate = function(_params)
            -- Client-side validation stub. The dedicated-server implementation
            -- from NB_BuildRecipeCode.lua replaces this function on the server.
        end
    end
end

-- Some older Neat Building definitions referenced this vanilla namespace even
-- when the callback was absent in the active B42 build. Keep a resolvable
-- compatibility alias without replacing an existing vanilla implementation.
BuildRecipeCode = BuildRecipeCode or {}
BuildRecipeCode.windowGlass = BuildRecipeCode.windowGlass or {}
if type(BuildRecipeCode.windowGlass.OnCreate) ~= "function" then
    BuildRecipeCode.windowGlass.OnCreate = function(_params)
        -- Validation-only fallback. Vanilla remains authoritative when present.
    end
end
