--[[ --------------------------------------------------- --
TODO List:
1.Add XPAward filter (If we can get XPAward)
-- --------------------------------------------------- --]]

require "ISUI/ISPanel"

NC_FilterBar = ISPanel:derive("NC_FilterBar")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

-- ----------------------------------------------------------------------------------------------------- --
-- initialise
-- ----------------------------------------------------------------------------------------------------- --
function NC_FilterBar:initialise()
    ISPanel.initialise(self)
end

function NC_FilterBar:new(x, y, width, height, HandCraftPanel)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    
    o.HandCraftPanel = HandCraftPanel
    o.player = HandCraftPanel.player
    o.logic = HandCraftPanel.logic
    o.padding = HandCraftPanel.padding
    o.buttonsize = FONT_HGT_SMALL

    o.showOnlyCanMake = false
    o.showOnlyKnown = false
    o.showOnlySkillMet = false
    o.showOnlyBenefitFromRecipe = false
    -- Controls a vanilla-like "Show All Recipes" behavior for the recipe source list
    o.showAllRecipes = false
    o.isGridLayout = false
    
    o.GridStyleIcon = getTexture("media/ui/Neat_Crafting/Icon/Icon_CraftGridStyle.png")
    o.ListStyleIcon = getTexture("media/ui/Neat_Crafting/Icon/Icon_CraftListStyle.png")

    return o
end

-- ----------------------------------------------------------------------------------------------------- --
-- Calculate Layout
-- ----------------------------------------------------------------------------------------------------- --

function NC_FilterBar:calculateLayout(_preferredWidth, _preferredHeight)
    local width = _preferredWidth or self.width
    local height = _preferredHeight or self.height

    self.buttonsize = math.floor(height * 0.8)

    if self.layoutToggleButton then
        local layoutButtonX = width - self.buttonsize - self.padding
        local buttonY = (self.height - self.buttonsize) / 2
        
        self.layoutToggleButton:setX(layoutButtonX)
        self.layoutToggleButton:setY(buttonY)
        self.layoutToggleButton:setWidth(self.buttonsize)
        self.layoutToggleButton:setHeight(self.buttonsize)
    end

    local buttonX = self.padding
    local buttonY = (self.height - self.buttonsize) / 2
    
    for _, button in ipairs(self.buttons) do
        button:setX(buttonX)
        button:setY(buttonY)
        button:setWidth(self.buttonsize)
        button:setHeight(self.buttonsize)
        buttonX = buttonX + self.buttonsize + self.padding
    end
    
    self:setWidth(width)
    self:setHeight(height)
end

-- ----------------------------------------------------------------------------------------------------- --
-- createChildren
-- ----------------------------------------------------------------------------------------------------- --
function NC_FilterBar:createChildren()
    -- Sync initial state from the HandCraftPanel (vanilla-like "Show All Recipes")
    local initialShowAll = (self.HandCraftPanel and self.HandCraftPanel.seeAllRecipe) or false
    self.showAllRecipes = initialShowAll

    -- Build icon + tooltip with fallbacks (avoid missing assets/translation keys)
    local showAllIcon = getTexture("media/ui/Neat_Crafting/ICON/Icon_ShowAll.png")
            or getTexture("media/ui/Neat_Crafting/Icon/Icon_ShowAll.png")

    local showAllTooltip = "Show all recipes"
    if getTextOrNull then
        showAllTooltip = getTextOrNull("IGUI_XP_NC_ShowAllRecipe_tooltip")
                or getTextOrNull("IGUI_CraftUI_ShowAllRecipes")
                or showAllTooltip
    end

    local buttonConfigs = {
        {
            icon = getTexture("media/ui/Neat_Crafting/Icon/Icon_CraftSort.png"),
            tooltip = getText("IGUI_NC_SortRecipeList"),
            onClick = self.onSortButtonClick,
            ref = "sortButton"
        },
        {
            icon = showAllIcon,
            tooltip = showAllTooltip,
            onClick = self.onShowAllRecipesButtonClick,
            ref = "showAllRecipesButton"
        },
        {
            icon = getTexture("media/ui/Neat_Crafting/Icon/Icon_Canmake.png"),
            tooltip = getText("IGUI_NC_ShowOnlyCanCraft"),
            onClick = self.onCanMakeFilterButtonClick,
            ref = "CanMakeFilterButton"
        },
        {
            icon = getTexture("media/ui/Neat_Crafting/Icon/Icon_CraftLV.png"),
            tooltip = getText("IGUI_NC_ShowOnlymetSkillRequire"),
            onClick = self.onSkillFilterButtonClick,
            ref = "skillFilterButton"
        },
        {
            icon = getTexture("media/ui/Neat_Crafting/Icon/Icon_RecipeKnow.png"),
            tooltip = getText("IGUI_NC_ShowOnlyRecipesKnew"),
            onClick = self.onKnownFilterButtonClick,
            ref = "knownFilterButton"
        },
        {
            icon = getTexture("media/ui/Neat_Crafting/ICON/Icon_RecipeBenefit.png"),
            tooltip = getText("IGUI_NC_ShowOnlyBenefitFromRecipes"),
            onClick = self.onBenefitFilterButtonClick,
            ref = "benefitFilterButton"
        },
    }

    self.buttons = {}
    
    for i, config in ipairs(buttonConfigs) do
        local button = NC_SquareButton:new(0, 0, 10, config.icon, self, config.onClick)
        button:initialise()
        button:setTooltip(config.tooltip)
        self:addChild(button)

        self[config.ref] = button
        table.insert(self.buttons, button)
        -- Special styling/state for "Show All Recipes" toggle
        if config.ref == "showAllRecipesButton" then
            button:setActiveColor(0.2, 0.6, 0.2)
            button:setActive(initialShowAll)
            self.showAllRecipesButton = button
        end

    end

    self.layoutToggleButton = NC_SquareButton:new(0, 0, 10, self.ListStyleIcon, self, self.onLayoutToggleButtonClick)
    self.layoutToggleButton:initialise()
    self.layoutToggleButton:setTooltip(getText("IGUI_NC_ToggleLayoutStyle"))
    self:addChild(self.layoutToggleButton)

    self:updateSortMode()
    self:updateLayoutButton()
end

-- ----------------------------------------------------------------------------------------------------- --
-- on Filter Click
-- ----------------------------------------------------------------------------------------------------- --
function NC_FilterBar:onCanMakeFilterButtonClick()
    self.showOnlyCanMake = not self.showOnlyCanMake
    self.CanMakeFilterButton:setActive(self.showOnlyCanMake)
    self.HandCraftPanel:onFilterChanged()
end

function NC_FilterBar:onKnownFilterButtonClick()
    self.showOnlyKnown = not self.showOnlyKnown
    self.knownFilterButton:setActive(self.showOnlyKnown)
    self.HandCraftPanel:onFilterChanged()
end

function NC_FilterBar:onSkillFilterButtonClick()
    self.showOnlySkillMet = not self.showOnlySkillMet
    self.skillFilterButton:setActive(self.showOnlySkillMet)
    self.HandCraftPanel:onFilterChanged()
end

function NC_FilterBar:onShowAllRecipesButtonClick()
    -- Toggle internal state (prefer syncing from HandCraftPanel if available)
    local current = (self.HandCraftPanel and self.HandCraftPanel.seeAllRecipe) or self.showAllRecipes or false
    local newState = not current

    self.showAllRecipes = newState

    -- Update button visuals
    if self.showAllRecipesButton then
        self.showAllRecipesButton:setActive(newState)
    end

    -- Apply to panel (this is the real functional switch)
    if self.HandCraftPanel and self.HandCraftPanel.setSeeAllRecipe then
        self.HandCraftPanel:setSeeAllRecipe(newState)
    end
end


-- Sort recipelist
function NC_FilterBar:onSortButtonClick()
    local context = ISContextMenu.get(0, self.sortButton:getAbsoluteX(), self.sortButton:getAbsoluteY() + self.sortButton:getHeight())
    local option1 = context:addOption(getText("IGUI_SortType_RecipeName"), self, self.updateSortMode, "RecipeName")
    option1.iconTexture = getTexture("media/ui/Neat_Crafting/ICON/Grey.png")
    
    local option2 = context:addOption(getText("IGUI_SortType_LastUsed"), self, self.updateSortMode, "LastUsed")
    option2.iconTexture = getTexture("media/ui/Neat_Crafting/ICON/Blue.png")
    
    local option3 = context:addOption(getText("IGUI_SortType_MostUsed"), self, self.updateSortMode, "MostUsed")
    option3.iconTexture = getTexture("media/ui/Neat_Crafting/ICON/Orange.png")
end

-- update sort mode --RecipeName,LastUsed,MostUsed
function NC_FilterBar:updateSortMode(sortmode)
    if not self.sortButton then return end
    if not sortmode then 
        sortmode = self.logic:getRecipeSortMode()
    end

    self.logic:setRecipeSortMode(sortmode) -- this one should sortrecipelist 

    if sortmode == "RecipeName" then
        self.sortButton:setActiveColor(0.2, 0.2, 0.2)
        self.sortButton:setActive(false)
    elseif sortmode == "LastUsed" then
        self.sortButton:setActiveColor(0.2, 0.4, 0.8)
        self.sortButton:setActive(true)
    elseif sortmode == "MostUsed" then
        self.sortButton:setActiveColor(0.8, 0.5, 0.2)
        self.sortButton:setActive(true)
    end

    self.logic:sortRecipeList()
end

function NC_FilterBar:onBenefitFilterButtonClick()
    self.showOnlyBenefitFromRecipe = not self.showOnlyBenefitFromRecipe
    self.benefitFilterButton:setActive(self.showOnlyBenefitFromRecipe)
    self.HandCraftPanel:onFilterChanged()
end

function NC_FilterBar:onLayoutToggleButtonClick()
    local currentStyle = self.logic:getSelectedRecipeStyle() or "list"
    local newStyle = (currentStyle == "grid") and "list" or "grid"
    
    self.logic:setSelectedRecipeStyle(newStyle)
    self:updateLayoutButton()

    if self.HandCraftPanel.recipeListPanel then
        self.HandCraftPanel.recipeListPanel:createChildren()
    end
end

function NC_FilterBar:updateLayoutButton()
    if not self.layoutToggleButton then return end

    local currentStyle = self.logic:getSelectedRecipeStyle() or "list"

    if currentStyle == "grid" then
        self.layoutToggleButton:setIcon(self.GridStyleIcon)
        self.layoutToggleButton:setTooltip(getText("IGUI_NC_SwitchToListLayout"))
    else
        self.layoutToggleButton:setIcon(self.ListStyleIcon)
        self.layoutToggleButton:setTooltip(getText("IGUI_NC_SwitchToGridLayout"))
    end
end

-- ----------------------------------------------------------------------------------------------------- --
-- filter manager
-- ----------------------------------------------------------------------------------------------------- --
function NC_FilterBar:isRecipeCraftableForGroup(recipe)
    if not recipe then
        return false
    end

    -- Mirror vanilla group visibility: partially-expanded groups only show recipes that are currently craftable.
    if self.player and self.player.isBuildCheat and self.player:isBuildCheat() then
        return true
    end

    if self.logic and self.logic.getCachedRecipeInfo then
        local cachedRecipeInfo = self.logic:getCachedRecipeInfo(recipe)
        if cachedRecipeInfo then
            if not cachedRecipeInfo:isValid() then
                return false
            end
            if not cachedRecipeInfo:isCanPerform() then
                return false
            end
        end
    end

    return true
end

function NC_FilterBar:buildVisibleNodeEntries(nodeList, depth)
    local visibleEntries = {}
    if not nodeList then
        return visibleEntries
    end

    depth = depth or 0

    for i = 0, nodeList:size() - 1 do
        local node = nodeList:get(i)
        if node:getType() == CraftRecipeListNode.CraftRecipeListNodeType.RECIPE then
            local recipe = node:getRecipe()
            if self:shouldIncludeRecipe(recipe) then
                table.insert(visibleEntries, {
                    entryType = "recipe",
                    recipe = recipe,
                    node = node,
                    depth = depth,
                    canMake = self:isRecipeCraftableForGroup(recipe),
                })
            end
        elseif node:getType() == CraftRecipeListNode.CraftRecipeListNodeType.GROUP then
            local childEntries = self:buildVisibleNodeEntries(node:getChildren(), depth + 1)
            if #childEntries > 0 then
                local anyCraftableChild = false
                local allCraftableChildren = true

                for _, childEntry in ipairs(childEntries) do
                    if childEntry.canMake then
                        anyCraftableChild = true
                    else
                        allCraftableChildren = false
                    end
                end

                -- Keep the vanilla behavior where a partial group automatically becomes fully open
                -- when every visible child recipe is craftable.
                if allCraftableChildren and node:getExpandedState() == CraftRecipeListNodeExpandedState.PARTIAL then
                    node:setExpandedState(CraftRecipeListNodeExpandedState.OPEN)
                end

                table.insert(visibleEntries, {
                    entryType = "group",
                    node = node,
                    depth = depth,
                    canMake = anyCraftableChild,
                })

                local expandedState = node:getExpandedState()
                if expandedState == CraftRecipeListNodeExpandedState.OPEN then
                    for _, childEntry in ipairs(childEntries) do
                        table.insert(visibleEntries, childEntry)
                    end
                elseif expandedState == CraftRecipeListNodeExpandedState.PARTIAL then
                    for _, childEntry in ipairs(childEntries) do
                        if childEntry.canMake then
                            table.insert(visibleEntries, childEntry)
                        end
                    end
                end
            end
        end
    end

    return visibleEntries
end

function NC_FilterBar:getFilteredRecipes()
    -- Get the object returned by the crafting logic (Build 42 may return a grouped node collection).
    local recipeListObj = (self.logic and self.logic.getRecipeList) and self.logic:getRecipeList() or nil

    -- Build output as a plain Lua array so the custom UI can consume it consistently.
    local filteredRecipes = {}

    if recipeListObj and recipeListObj.getNodes then
        return self:buildVisibleNodeEntries(recipeListObj:getNodes(), 0)
    end

    -- Unwrap older containers used by APIs that only expose a flat recipe list.
    local allRecipes = recipeListObj
    if recipeListObj and recipeListObj.getAllRecipes then
        allRecipes = recipeListObj:getAllRecipes()
    end

    if not allRecipes then
        return filteredRecipes
    end

    if allRecipes.size and allRecipes.get then
        for i = 0, allRecipes:size() - 1 do
            local recipe = allRecipes:get(i)
            if self:shouldIncludeRecipe(recipe) then
                table.insert(filteredRecipes, {
                    entryType = "recipe",
                    recipe = recipe,
                    depth = 0,
                    canMake = self:isRecipeCraftableForGroup(recipe),
                })
            end
        end
        return filteredRecipes
    end

    if type(allRecipes) == "table" then
        for _, recipe in ipairs(allRecipes) do
            if self:shouldIncludeRecipe(recipe) then
                table.insert(filteredRecipes, {
                    entryType = "recipe",
                    recipe = recipe,
                    depth = 0,
                    canMake = self:isRecipeCraftableForGroup(recipe),
                })
            end
        end
    end

    return filteredRecipes
end

function NC_FilterBar:shouldIncludeRecipe(recipe)
    if recipe and self.logic and self.logic:getRecipe() then
        local canMake = self.logic:canCharacterPerformRecipe(recipe)
        local isKnown = self:isRecipeKnown(recipe)
        local skillMet = self:isRecipeSkillMet(recipe)
        local benefitFromRecipe = recipe:couldBenefitFromRecipeAtHand(self.player)

        if self.showOnlyCanMake and not canMake then
            return false
        end
        if self.showOnlyKnown and not isKnown then
            return false
        end
        if self.showOnlySkillMet and not skillMet then
            return false
        end
        if self.showOnlyBenefitFromRecipe and not benefitFromRecipe then
            return false
        end
    end
    
    return true
end

function NC_FilterBar:isRecipeKnown(recipe)
    if not recipe or not self.player then
        return false
    end

    if not recipe:needToBeLearn() then
        return true
    end

    return self.player:isRecipeKnown(recipe, true)
end

function NC_FilterBar:isRecipeSkillMet(recipe)
    if not recipe or not self.player then
        return false
    end
    
    if recipe:getRequiredSkillCount() > 0 then
        for i = 0, recipe:getRequiredSkillCount() - 1 do
            local requiredSkill = recipe:getRequiredSkill(i)
            if not CraftRecipeManager.hasPlayerRequiredSkill(requiredSkill, self.player) then
                return false
            end
        end
    end
    
    return true
end

-- ----------------------------------------------------------------------------------------------------- --
-- Render
-- ----------------------------------------------------------------------------------------------------- --
function NC_FilterBar:prerender()

    local TitleBG = NinePatchTexture.getSharedTexture("media/ui/Neat_Crafting/Panel/InnerTitle_BG.png")
    if TitleBG then
        TitleBG:render(self:getAbsoluteX(), self:getAbsoluteY(), self.width, self.height, 0.2, 0.2, 0.2, NCConfig.titleBackgroundAlpha)
    end
end

return NC_FilterBar