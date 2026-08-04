require "LootRequiresLight/LootRequiresLight_Utils"
require "LootRequiresLight/LootRequiresLight_TimedActions"

local function addDarkSearchOption(playerNum, context, worldobjects)
    if not LRL_Utils.isEnabled() then return end
    if not (SandboxVars and SandboxVars.LootRequiresLight and SandboxVars.LootRequiresLight.AllowSearchingInDarkness) then return end

    local playerObj = getSpecificPlayer(playerNum)
    if not playerObj or not context or not worldobjects then return end

    local added = {}
    for _, object in ipairs(worldobjects) do
        if object and object.getContainerCount then
            for i = 0, object:getContainerCount() - 1 do
                local container = object:getContainerByIndex(i)
                if container
                        and not LRL_Utils.isVehicleContainer(container)
                        and LRL_Utils.shouldBlockContainer(playerObj, container) then
                    local key = LRL_Utils.containerKey(container)
                    if not added[key] then
                        added[key] = true
                        context:addOption(LRL_Utils.getTextOrFallback("IGUI_LRL_SearchInDarkness", "Search in the dark"), playerObj, LootRequiresLight.queueDarkSearch, container)
                    end
                end
            end
        end
    end
end

-- Context menu support is a supplement. The real click-path block lives in LootRequiresLight_Main.lua.
if Events and Events.OnFillWorldObjectContextMenu then
    Events.OnFillWorldObjectContextMenu.Add(addDarkSearchOption)
end
