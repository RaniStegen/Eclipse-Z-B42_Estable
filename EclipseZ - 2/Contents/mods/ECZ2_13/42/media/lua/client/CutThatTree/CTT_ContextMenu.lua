require "CutThatTree/CTT_Core"
require "CutThatTree/CTT_ChopMinigameUI"
require "TimedActions/CTT_OpenChopMinigameAction"

local CONTEXT_ICON = "media/textures/CTT_Context.png"
local contextIconTexture = nil

local function getContextIcon()
    if contextIconTexture == false then return nil end
    if contextIconTexture == nil then
        local ok, texture = pcall(function() return getTexture(CONTEXT_ICON) end)
        contextIconTexture = ok and texture or false
    end
    if contextIconTexture == false then return nil end
    return contextIconTexture
end

local function findTree(worldobjects)
    if worldobjects then
        for _, object in ipairs(worldobjects) do
            if object then
                if instanceof(object, "IsoTree") then
                    return object
                end

                local square = object:getSquare()
                if square and square:HasTree() then
                    return square:getTree()
                end
            end
        end
    end

    if IsoObjectPicker and IsoObjectPicker.Instance then
        return IsoObjectPicker.Instance:PickTree(getMouseX(), getMouseY())
    end

    return nil
end

local function addUnavailableTooltip(option, description)
    option.notAvailable = true
    if ISWorldObjectContextMenu and ISWorldObjectContextMenu.addToolTip then
        option.toolTip = ISWorldObjectContextMenu.addToolTip()
        option.toolTip.description = description
    end
end

local function isVanillaCutTreeOption(option)
    if not option then return false end

    if ISWorldObjectContextMenu then
        if ISWorldObjectContextMenu.onChopTree and option.onSelect == ISWorldObjectContextMenu.onChopTree then
            return true
        end
        if ISWorldObjectContextMenu.doChopTree and option.onSelect == ISWorldObjectContextMenu.doChopTree then
            return true
        end
    end

    if not option.name then return false end
    local vanillaName = getText("ContextMenu_Chop_Tree")
    return vanillaName and vanillaName ~= "ContextMenu_Chop_Tree" and tostring(option.name) == vanillaName
end

local function moveOptionAfterCutTree(context, option)
    if not context or not context.options or not option then return end

    local optionIndex = nil
    local cutTreeIndex = nil
    for i = 1, #context.options do
        local candidate = context.options[i]
        if candidate == option then
            optionIndex = i
        elseif isVanillaCutTreeOption(candidate) then
            cutTreeIndex = i
        end
    end

    if not optionIndex or not cutTreeIndex then return end

    local moved = table.remove(context.options, optionIndex)
    if optionIndex < cutTreeIndex then
        cutTreeIndex = cutTreeIndex - 1
    end
    table.insert(context.options, cutTreeIndex + 1, moved)
end

local function refreshContextOptions(context)
    if not context or not context.options then return end

    for i = 1, #context.options do
        context.options[i].id = i
    end

    context.numOptions = #context.options + 1
    if context.calcHeight then context:calcHeight() end
    if context.calcWidth and context.setWidth then
        context:setWidth(context:calcWidth())
    end
end

local function hideVanillaCutTreeOptions(context, ownOption)
    if not CutThatTree.isVanillaTreeCutDisabled() then return end
    if not context or not context.options then return end

    local removed = false
    for i = #context.options, 1, -1 do
        local option = context.options[i]
        if option ~= ownOption and isVanillaCutTreeOption(option) then
            table.remove(context.options, i)
            removed = true
        end
    end

    if removed then
        refreshContextOptions(context)
    end
end

function CutThatTree.onTimedChop(worldobjects, playerObj, tree)
    if not CutThatTree.isValidTree(tree) then return end

    local axe = CutThatTree.getBestAxe(playerObj)
    if not axe then
        CutThatTree.halo(playerObj, "UI_CTT_NeedAxe")
        return
    end

    if not CutThatTree.hasMinigameAccess(playerObj) then
        CutThatTree.halo(playerObj, "UI_CTT_NeedAxeSkill", CutThatTree.getRequiredAxeSkillLevel())
        return
    end

    if luautils.walkAdj(playerObj, tree:getSquare(), true) then
        if playerObj:getPrimaryHandItem() ~= axe then
            local twoHands = not playerObj:getSecondaryHandItem()
            ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), axe, true, twoHands)
        end

        playerObj:setIsFarming(true)
        ISTimedActionQueue.add(CTT_OpenChopMinigameAction:new(playerObj, tree))
    end
end

function CutThatTree.onFillWorldObjectContextMenu(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
    if not playerObj or playerObj:getVehicle() then return end

    local tree = findTree(worldobjects)
    if not CutThatTree.isValidTree(tree) then return end

    if test and ISWorldObjectContextMenu and ISWorldObjectContextMenu.setTest then
        return ISWorldObjectContextMenu.setTest()
    end

    local option = context:addGetUpOption(CutThatTree.text("ContextMenu_CTT_ChopTimed"), worldobjects, CutThatTree.onTimedChop, playerObj, tree)
    option.iconTexture = getContextIcon()
    moveOptionAfterCutTree(context, option)
    hideVanillaCutTreeOptions(context, option)

    if not CutThatTree.getBestAxe(playerObj) then
        addUnavailableTooltip(option, CutThatTree.text("Tooltip_CTT_NeedAxe"))
        return
    end

    if not CutThatTree.hasMinigameAccess(playerObj) then
        addUnavailableTooltip(option, CutThatTree.text("Tooltip_CTT_NeedAxeSkill", CutThatTree.getRequiredAxeSkillLevel()))
        return
    end

    if CTT_ChopMinigameUI.instance then
        addUnavailableTooltip(option, CutThatTree.text("Tooltip_CTT_AlreadyOpen"))
    end
end

Events.OnFillWorldObjectContextMenu.Add(CutThatTree.onFillWorldObjectContextMenu)
