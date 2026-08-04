-- Compatibility with Reorganized Info Screen for Project Zomboid Build 42.20.
--
-- Older releases of Improved Hair Menu restored drag support by replacing the
-- complete ISUI3DModel class with a copied vanilla implementation.  On B42.20
-- that removes newer methods used by the character-creation and main-menu
-- previews, leaving the model area empty.  Keep the active game class and only
-- add the modern methods if another mod has replaced them.
if isServer() then return end

require("ISUI/ISUI3DModel")

if not ISUI3DModel then return end

if not ISUI3DModel.getCharacter then
    function ISUI3DModel:getCharacter()
        return self.javaObject and self.javaObject:getCharacter()
    end
end

if not ISUI3DModel.setAnimSetName then
    function ISUI3DModel:setAnimSetName(animSet)
        if self.javaObject then
            self.javaObject:setAnimSetName(animSet)
        end
    end
end

if not ISUI3DModel.getState then
    function ISUI3DModel:getState()
        return self.javaObject and self.javaObject:getState()
    end
end

if not ISUI3DModel.setVariable then
    function ISUI3DModel:setVariable(key, value)
        if self.javaObject then
            self.javaObject:setVariable(key, value)
        end
    end
end

if not ISUI3DModel.getVariable then
    function ISUI3DModel:getVariable(key)
        return self.javaObject and self.javaObject:getVariable(key)
    end
end

if not ISUI3DModel.clearVariable then
    function ISUI3DModel:clearVariable(key)
        if self.javaObject then
            self.javaObject:clearVariable(key)
        end
    end
end

if not ISUI3DModel.clearVariables then
    function ISUI3DModel:clearVariables()
        if self.javaObject then
            self.javaObject:clearVariables()
        end
    end
end
