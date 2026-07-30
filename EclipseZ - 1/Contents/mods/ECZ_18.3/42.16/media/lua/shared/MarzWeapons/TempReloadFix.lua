require("TimedActions/ISBaseTimedAction")
require("TimedActions/ISReloadWeaponAction")
require("TimedActions/ISEjectMagazine")
require("TimedActions/ISInsertMagazine")
require("TimedActions/ISRackFirearm")

local customReloadAnims = {
    ["MarzGuns.FAL"] = "FAL",
    ["MarzGuns.BAR"] = "FAL",
    ["MarzGuns.M1_GARAND"] = "m1reload",
    ["MarzGuns.BENELLI_M4"] = "shotgunsemi",
    ["MarzGuns.SPAS12"] = "shotgunsemi",
    ["MarzGuns.W1894"] = "lever",
    ["MarzGuns.W1887"] = "lever",
    ["MarzGuns.M1895"] = "lever",
    ["MarzGuns.W1873"] = "lever",
    ["MarzGuns.W1873_CARBINE"] = "lever",
    ["MarzGuns.MP5"] = "MP5",
    ["MarzGuns.MP5SD"] = "MP5",
    ["MarzGuns.MP5A2"] = "MP5",
    ["MarzGuns.G3"] = "MP5",
    ["MarzGuns.PSG1"] = "MP5",
    ["MarzGuns.MP5K"] = "handgun2",
    ["MarzGuns.TEC9"] = "handgun2",
    ["MarzGuns.FAMAS"] = "BullpupReload",
}

local function overrideReloadType(action)
    local gun = action.gun
    if gun then
        local reloadType = customReloadAnims[gun:getFullType()]
        if reloadType then
            action:setAnimVariable("WeaponReloadType", reloadType)
        end
    end
end

local origReloadStart = ISReloadWeaponAction.start
function ISReloadWeaponAction:start()
    origReloadStart(self)
    overrideReloadType(self)
end

local origEjectStart = ISEjectMagazine.start
function ISEjectMagazine:start()
    origEjectStart(self)
    overrideReloadType(self)
end

local origInsertStart = ISInsertMagazine.start
function ISInsertMagazine:start()
    origInsertStart(self)
    overrideReloadType(self)
end

local origRackStart = ISRackFirearm.start
function ISRackFirearm:start()
    origRackStart(self)
    overrideReloadType(self)
end
