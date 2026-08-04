require "Entity/TimedActions/ISHandcraftAction"
require "IDBFS_Core"
require "IDBFS/TimedActions/ISIDBFSTimedCommandAction"

IDBFS = IDBFS or {}
IDBFS.Client = IDBFS.Client or {}

if not IDBFS.Client._pressHandcraftPatchApplied then
    IDBFS.Client._pressHandcraftPatchApplied = true

    local originalFromLogic = ISHandcraftAction.FromLogic
    local originalFromLogicMultiple = ISHandcraftAction.FromLogicMultiple

    local RECIPE_NAME_TO_KEY = {
        PressFruitMash = "fruit",
        PressGrainMash = "grain",
        PressCornMash = "corn",
        PressPotatoMash = "potato",
        PressSugarWash = "sugar",
        PressVegetableOil = "sunflower_oil",
        PressOliveOil = "olive_oil",
    }

    local function getRecipeName(craftRecipe)
        if not craftRecipe or not craftRecipe.getName then
            return nil
        end
        local name = tostring(craftRecipe:getName())
        return name:match("([^%.]+)$") or name
    end

    local function getRecipeKey(craftRecipe)
        return RECIPE_NAME_TO_KEY[getRecipeName(craftRecipe)]
    end

    local function isPressLogic(handcraftLogic)
        if not handcraftLogic then
            return false
        end
        local obj = handcraftLogic:getIsoObject()
        return obj and IDBFS.getObjectType and IDBFS.getObjectType(obj) == "press"
            and getRecipeKey(handcraftLogic:getRecipe()) ~= nil
    end

    local function eachItem(items, callback)
        if not items or not items.size or not items.get then
            return
        end
        for i = 0, items:size() - 1 do
            callback(items:get(i))
        end
    end

    local function getInputItems(handcraftLogic)
        local recipeData = handcraftLogic and handcraftLogic.getRecipeData
            and handcraftLogic:getRecipeData() or nil
        if recipeData and recipeData.getAllInputItems then
            return recipeData:getAllInputItems()
        end
        return nil
    end

    local function getSelectedPressContainer(handcraftLogic, recipeKey)
        local recipe = IDBFS.PressRecipes and IDBFS.PressRecipes[recipeKey] or nil
        local requiredAmount = recipe and (tonumber(recipe.amount) or IDBFS.LIQUID_BATCH_AMOUNT or 10) or 10
        local selectedContainer = nil
        eachItem(getInputItems(handcraftLogic), function(item)
            if not selectedContainer and item and IDBFS.isPressContainer(item)
                and IDBFS.canContainerAcceptLiquid(item, recipe.liquidType, requiredAmount) then
                selectedContainer = item
            end
        end)
        return selectedContainer
    end

    local function getSelectedIngredientIDs(handcraftLogic, recipeKey)
        local recipe = IDBFS.PressRecipes and IDBFS.PressRecipes[recipeKey] or nil
        local ids = {}
        local seen = {}
        if not recipe then
            return ids
        end

        eachItem(getInputItems(handcraftLogic), function(item)
            local itemID = item and item.getID and item:getID() or nil
            if itemID and not seen[itemID] then
                for _, req in ipairs(recipe.ingredients or {}) do
                    if IDBFS.matchesIngredient(item, req) then
                        ids[#ids + 1] = itemID
                        seen[itemID] = true
                        return
                    end
                end
            end
        end)
        return ids
    end

    local function getDuration(character, craftRecipe)
        if character and character.isTimedActionInstant and character:isTimedActionInstant() then
            return 1
        end
        if craftRecipe and craftRecipe.getTime then
            return craftRecipe:getTime(character) * 5
        end
        return 180
    end

    local function makePressAction(handcraftLogic)
        local character = handcraftLogic:getPlayer()
        local obj = handcraftLogic:getIsoObject()
        local craftRecipe = handcraftLogic:getRecipe()
        local recipeKey = getRecipeKey(craftRecipe)
        local container = getSelectedPressContainer(handcraftLogic, recipeKey)
        local args = {
            recipe = recipeKey,
            containerID = container and container.getID and container:getID() or nil,
            ingredientIDs = getSelectedIngredientIDs(handcraftLogic, recipeKey),
        }
        print("[IDBFS] Routing press workstation recipe through mod timed action: " .. tostring(recipeKey))
        return ISIDBFSTimedCommandAction:new(
            character, obj, "press", args, getDuration(character, craftRecipe), container
        )
    end

    function ISHandcraftAction.FromLogic(handcraftLogic, eatPercentage)
        if isPressLogic(handcraftLogic) then
            return makePressAction(handcraftLogic)
        end
        return originalFromLogic(handcraftLogic, eatPercentage)
    end

    function ISHandcraftAction.FromLogicMultiple(handcraftLogic)
        if isPressLogic(handcraftLogic) then
            return makePressAction(handcraftLogic)
        end
        return originalFromLogicMultiple(handcraftLogic)
    end
end
