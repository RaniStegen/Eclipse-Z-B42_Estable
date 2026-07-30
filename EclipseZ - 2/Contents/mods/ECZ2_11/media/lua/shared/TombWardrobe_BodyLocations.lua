--Codebase by Yuhiko and his/her mod BodyLocationsTweaker API. All credit of this functionality goes to him/her. 
require "NPCs/BodyLocations" 



local function customGetVal(obj, int) return getClassFieldVal(obj, getClassField(obj, int)); end
local BodyLocationsTweaker = {}; 

BodyLocationsTweaker.group = BodyLocations.getGroup("Human");
BodyLocationsTweaker.list = customGetVal(BodyLocationsTweaker.group, 1); 

function BodyLocationsTweaker:moveOrCreateBeforeOrAfter(toRelocateOrCreate, locationElement, afterBoolean)

    if type(locationElement) ~= "string" then error("Argument 2 is not of type string. Please re-check!", 2); end
    local itemToMoveTo = self.group:getLocation(locationElement); 
    if itemToMoveTo ~= nil then
        
        if type(toRelocateOrCreate) ~= "string" then error("Argument 1 is not of type string. Please re-check!", 2) end
        local curItem = self.group:getOrCreateLocation(toRelocateOrCreate); 
        self.list:remove(curItem); 
        local index = self.group:indexOf(locationElement); 
        if afterBoolean then index = index + 1; end 
        self.list:add(index, curItem); 
        return curItem;
    else 
        error("Could not find the BodyLocation [",locationElement,"] - please check the passed arguments!", 2);
    end
end


function BodyLocationsTweaker:moveOrCreateBefore(toRelocateOrCreate, locationElement) -- for simpler and clearer usage
    return self:moveOrCreateBeforeOrAfter(toRelocateOrCreate, locationElement, false);
end

 BodyLocationsTweaker:moveOrCreateBefore("TWSleeves", "Hands");
 BodyLocationsTweaker:moveOrCreateBefore("TWHarnessUnder", "UnderwearExtra1");
 BodyLocationsTweaker:moveOrCreateBefore("TWHarnessOver", "Scarf");
 BodyLocationsTweaker:moveOrCreateBefore("TWLegHarnessUnder", "UnderwearExtra2");
 BodyLocationsTweaker:moveOrCreateBefore("TWLegHarnessOver", "Scarf");
 BodyLocationsTweaker:moveOrCreateBefore("TWTrenchcoat", "JacketSuit");
 BodyLocationsTweaker:moveOrCreateBefore("TWJacket", "Jacket");


local group = BodyLocations.getGroup("Human")

group:setExclusive("TWTrenchcoat", "TWJacket")

group:setExclusive("TWTrenchcoat", "Jacket")
group:setExclusive("TWTrenchcoat", "Jacket_Down")
group:setExclusive("TWTrenchcoat", "Jacket_Bulky")
group:setExclusive("TWTrenchcoat", "JacketHat")
group:setExclusive("TWTrenchcoat", "JacketHat_Bulky")
group:setExclusive("TWTrenchcoat", "Sweater")
group:setExclusive("TWTrenchcoat", "JacketSuit")

group:setExclusive("TWJacket", "Jacket")
group:setExclusive("TWJacket", "Jacket_Down")
group:setExclusive("TWJacket", "Jacket_Bulky")
group:setExclusive("TWJacket", "JacketHat")
group:setExclusive("TWJacket", "JacketHat_Bulky")
group:setExclusive("TWJacket", "Sweater")
group:setExclusive("TWJacket", "JacketSuit")

group:setExclusive("FullSuit", "TWTrenchcoat")
group:setExclusive("Boilersuit", "TWTrenchcoat")
group:setExclusive("BathRobe", "TWTrenchcoat")

group:setExclusive("FullSuit", "TWJacket")
group:setExclusive("Boilersuit", "TWJacket")
group:setExclusive("BathRobe", "TWJacket")

