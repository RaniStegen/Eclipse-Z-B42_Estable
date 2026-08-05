require "Vehicle/Vehicles"

local old_VehicleUtils_createPartInventoryItem =  VehicleUtils.createPartInventoryItem

function VehicleUtils.createPartInventoryItem(part)
    local iType = nil 
    if part:getItemType() and part:getItemType():get(0) then
        iType = part:getItemType():get(0)
    end
    if iType and iType:contains("Base.nil")  then
        return false
    end
    return old_VehicleUtils_createPartInventoryItem(part)        
end