require "Entity/TimedActions/ISHandcraftAction"
require "IDBFS_Core"

IDBFS = IDBFS or {}

if not IDBFS._mpHandcraftPatchApplied then
    IDBFS._mpHandcraftPatchApplied = true

    local originalNew = ISHandcraftAction.new
    local originalIsValid = ISHandcraftAction.isValid
    local originalStart = ISHandcraftAction.start
    local originalServerStart = ISHandcraftAction.serverStart
    local originalClearItemsProgressBar = ISHandcraftAction.clearItemsProgressBar
    local originalPerformRecipe = ISHandcraftAction.performRecipe
    local originalPerform = ISHandcraftAction.perform

    local FRUITS = {
        ["Base.Apple"] = true,
        ["Base.BerryBlack"] = true,
        ["Base.BerryBlue"] = true,
        ["Base.BerryGeneric1"] = true,
        ["Base.BerryGeneric2"] = true,
        ["Base.BerryGeneric3"] = true,
        ["Base.BerryGeneric4"] = true,
        ["Base.BerryGeneric5"] = true,
        ["Base.BeautyBerry"] = true,
        ["Base.Cherry"] = true,
        ["Base.Grapefruit"] = true,
        ["Base.Grapes"] = true,
        ["Base.Peach"] = true,
        ["Base.Pear"] = true,
        ["Base.Strewberrie"] = true,
        ["Base.WinterBerry"] = true,
    }

    local GRAINS = {
        ["Base.BarleySheafDried"] = true,
        ["Base.RyeSheafDried"] = true,
        ["Base.WheatSheafDried"] = true,
    }

    local function eachItem(items, callback)
        if not items then
            return
        end
        if items.size and items.get then
            for i = 0, items:size() - 1 do
                callback(items:get(i))
            end
            return
        end
        if type(items) == "table" then
            for _, item in pairs(items) do
                callback(item)
            end
        end
    end

    local function getFullType(item)
        return item and item.getFullType and item:getFullType() or nil
    end

    local function getItemID(item)
        return item and item.getID and item:getID() or nil
    end

    local function addCount(counts, fullType)
        if fullType then
            counts[fullType] = (counts[fullType] or 0) + 1
        end
    end

    local function countAny(counts, set)
        local total = 0
        for fullType, count in pairs(counts) do
            if set[fullType] then
                total = total + count
            end
        end
        return total
    end

    local function getCombinedJobText(items)
        local parts = {}
        eachItem(items, function(item)
            local jobType = item and item.getJobType and item:getJobType() or nil
            if jobType and jobType ~= "" then
                parts[#parts + 1] = string.lower(tostring(jobType))
            end
        end)
        return table.concat(parts, " ")
    end

    local function isIDBFSPress(isoObject)
        if not isoObject then
            return false
        end
        if IDBFS.getObjectType and IDBFS.getObjectType(isoObject) == "press" then
            return true
        end
        local text = tostring(isoObject)
        return string.find(text, "IDBFS_ManualPress", 1, true) ~= nil
            or string.find(text, "crafted_05_", 1, true) ~= nil
    end

    local function getRecipeName(craftRecipe)
        if not craftRecipe or not craftRecipe.getName then
            return nil
        end
        local name = tostring(craftRecipe:getName())
        return name:match("([^%.]+)$") or name
    end

    local RECIPE_NAME_TO_KEY = {
        PressFruitMash = "fruit",
        PressGrainMash = "grain",
        PressCornMash = "corn",
        PressPotatoMash = "potato",
        PressSugarWash = "sugar",
        PressVegetableOil = "sunflower_oil",
        PressOliveOil = "olive_oil",
    }

    local function getPressRecipeKeyFromAction(action)
        if not action then
            return nil
        end
        if action.IDBFSPressRecipe then
            return action.IDBFSPressRecipe
        end
        return RECIPE_NAME_TO_KEY[getRecipeName(action.craftRecipe)]
    end

    local function inferPressRecipe(items)
        local counts = {}
        local containerID = nil
        eachItem(items, function(item)
            local fullType = getFullType(item)
            addCount(counts, fullType)
            if not containerID and IDBFS.isPressContainer and IDBFS.isPressContainer(item) then
                containerID = getItemID(item)
            end
        end)

        local jobText = getCombinedJobText(items)
        if counts["Base.SunflowerHeadDried"] and counts["Base.SunflowerHeadDried"] >= 4 then
            return "sunflower_oil", containerID
        end
        if counts["Base.Olives"] and counts["Base.Olives"] >= 2 then
            return "olive_oil", containerID
        end
        if counts["Base.Sugar"] and counts["Base.Sugar"] >= 1 then
            return "sugar", containerID
        end
        if counts["Base.Potato"] and counts["Base.Potato"] >= 4 then
            return "potato", containerID
        end
        if counts["Base.Corn"] and counts["Base.Corn"] >= 4 then
            if string.find(jobText, "oil", 1, true) or string.find(jobText, "aceite", 1, true) then
                return "sunflower_oil", containerID
            end
            return "corn", containerID
        end
        if countAny(counts, GRAINS) >= 1 then
            return "grain", containerID
        end
        if countAny(counts, FRUITS) >= 5 then
            return "fruit", containerID
        end
        return nil, containerID
    end

    local function getRecipeJobName(recipeKey)
        local recipe = IDBFS.PressRecipes and IDBFS.PressRecipes[recipeKey] or nil
        if recipe and recipe.label then
            return tostring(recipe.label)
        end
        return "Distillery Press"
    end

    function ISHandcraftAction:new(character, craftRecipe, containers, isoObject, craftBench, manualInputs, items, recipeItem, variableInputRatio, eatPercentage)
        if craftRecipe == nil and isIDBFSPress(isoObject) then
            local recipeKey, containerID = inferPressRecipe(items)
            local o = ISBaseTimedAction.new(self, character)
            o.stopOnAim = false
            o.character = character
            o.isoObject = isoObject
            o.craftBench = craftBench
            o.containers = containers
            o.manualInputs = manualInputs
            o.craftRecipe = nil
            o.actionScript = nil
            o.stopOnWalk = true
            o.stopOnRun = true
            o.maxTime = 1
            o.items = items
            o.recipeItem = recipeItem
            o.variableInputRatio = variableInputRatio or 1
            o.eatPercentage = 0
            o.IDBFSPressFallback = true
            o.IDBFSPressRecipe = recipeKey
            o.IDBFSPressContainerID = containerID
            return o
        end
        return originalNew(self, character, craftRecipe, containers, isoObject, craftBench, manualInputs, items, recipeItem, variableInputRatio, eatPercentage)
    end

    function ISHandcraftAction:isValid()
        if self.IDBFSPressFallback then
            return self.character ~= nil and self.isoObject ~= nil and self.IDBFSPressRecipe ~= nil
        end
        if isIDBFSPress(self.isoObject) and getPressRecipeKeyFromAction(self) then
            return self.character ~= nil and self.isoObject ~= nil
        end
        return originalIsValid(self)
    end

    function ISHandcraftAction:serverStart()
        if self.IDBFSPressFallback then
            return
        end
        return originalServerStart(self)
    end

    function ISHandcraftAction:start()
        if self.IDBFSPressFallback then
            self:clearItemsProgressBar(true)
            return
        end
        return originalStart(self)
    end

    function ISHandcraftAction:clearItemsProgressBar(bSetJobType)
        if not self.IDBFSPressFallback then
            return originalClearItemsProgressBar(self, bSetJobType)
        end
        local jobName = getRecipeJobName(self.IDBFSPressRecipe)
        eachItem(self.items, function(item)
            if item and item.setJobDelta then
                item:setJobDelta(0.0)
            end
            if bSetJobType and item and item.setJobType then
                item:setJobType(jobName)
            end
        end)
        if self.recipeItem and self.recipeItem.setJobDelta then
            self.recipeItem:setJobDelta(0.0)
            if bSetJobType and self.recipeItem.setJobType then
                self.recipeItem:setJobType(jobName)
            end
        end
    end

    function ISHandcraftAction:performRecipe()
        if self.IDBFSPressFallback then
            if IDBFS.Server and IDBFS.Server.pressWithObject then
                IDBFS.Server.pressWithObject(self.character, self.isoObject, self.IDBFSPressRecipe, self.IDBFSPressContainerID)
            end
            return
        end
        local recipeKey = getPressRecipeKeyFromAction(self)
        if isIDBFSPress(self.isoObject) and recipeKey then
            if IDBFS.Server and IDBFS.Server.pressWithObject then
                local _, containerID = inferPressRecipe(self.items)
                IDBFS.Server.pressWithObject(self.character, self.isoObject, recipeKey, containerID)
            end
            return
        end
        return originalPerformRecipe(self)
    end

    function ISHandcraftAction:perform()
        if self.IDBFSPressFallback then
            self:clearItemsProgressBar(false)
            if not isClient() then
                self:performRecipe()
            end
            ISBaseTimedAction.perform(self)
            return
        end
        return originalPerform(self)
    end
end
