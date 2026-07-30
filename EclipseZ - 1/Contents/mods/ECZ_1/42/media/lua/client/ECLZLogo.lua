-- ECLZJobs42 logo overlay. Client-only and guarded to avoid UI errors.
local logo = getTexture("media/textures/GUI/logo.png")

local function drawOverlay()
    if not logo or not UIManager or not getCore() then return end

    local size = 150
    UIManager.DrawTexture(
        logo,
        getCore():getScreenWidth() - size,
        getCore():getScreenHeight() - size,
        size,
        size,
        255
    )
end

Events.OnPreUIDraw.Add(drawOverlay)
