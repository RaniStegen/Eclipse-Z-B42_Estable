--- Various overrides for functions that need animations.
-- Vehicles Edition

------------------------------------------------------------------------------
-- B42 FIX (2026-08-03): Do NOT queue anything from ISOpenVehicleDoor:new() or
-- ISCloseVehicleDoor:new().
--
-- Vanilla builds those two actions in strict pairs and relies on the queue
-- order staying untouched:
--
--   enter   : PathFind -> [Unlock] -> OpenDoor -> EnterVehicle -> CloseDoor
--   exit    : OpenDoor -> ExitVehicle -> CloseDoor
--   mechanic: OpenHood -> Install/Uninstall/Repair/Headlight -> CloseHood
--
-- Queueing an FHBoopAction inside :new() lands it *in the middle* of those
-- sandwiches, because :new() runs before the caller's ISTimedActionQueue.add().
--
-- On top of that, in B42 ISOpenVehicleDoor:new() always sets o.seat (it is
-- part:getContainerSeatNumber(), an int - so 0 and -1 are both truthy in Lua),
-- which made the old `if o.seat then return o end` guard swallow every door,
-- while ISCloseVehicleDoor:new() had no guard at all.
--
-- Why it only broke multiplayer: in SP the door actions' isValid() also checks
-- the door's open state, so a mangled sequence is dropped from the queue. In MP
-- isValid() is just `self.part ~= nil`, so the CloseVehicleDoor stays queued and
-- waits forever on getSpriteDef():isFinished() - the queue stalls and the player
-- can no longer enter/exit the vehicle (unless the door is removed, which makes
-- vanilla skip the Open/Close pair entirely).
--
-- We now hook the "the player asked to open/close/lock a door" menu entry points
-- instead, which are never part of an enter/exit/mechanic sequence.
------------------------------------------------------------------------------

local doorType = {
    ["DoorRear"] = 0,
    ["EngineDoor"] = 2,
    ["TrunkDoor"] = 1
}

-- Timed actions that belong to a vanilla vehicle sequence we must never split.
local vehicleSequenceTypes = {
    ISOpenVehicleDoor = true,
    ISCloseVehicleDoor = true,
    ISUnlockVehicleDoor = true,
    ISLockVehicleDoor = true,
    ISEnterVehicle = true,
    ISExitVehicle = true,
    ISSwitchVehicleSeat = true,
    ISOpenMechanicsUIAction = true,
    ISInstallVehiclePart = true,
    ISUninstallVehiclePart = true,
    ISRepairEngine = true,
    ISTakeEngineParts = true,
    ISConfigHeadlight = true,
}

local function queueHasVehicleSequence(character)
    local queue = ISTimedActionQueue.queues[character]
    if not queue then return false end
    for _, action in ipairs(queue.queue) do
        if vehicleSequenceTypes[action.Type] then return true end
    end
    return false
end

--- Queue a boop for a vehicle part, but only when it is safe to do so.
-- Must be called *before* the vanilla handler queues its own actions.
local function addVehicleBoop(character, part, extra)
    if not character or not part then return end
    if character:isSeatedInVehicle() then return end
    if queueHasVehicleSequence(character) then return end

    local vehicle = part:getVehicle()
    if not vehicle then return end

    ISTimedActionQueue.add(FHBoopAction:new(character, { item = vehicle, extra = extra }))
end

------------------
-- Just add our low "boop" animation and hold it
local _ISDeflateTire_start = ISDeflateTire.start
function ISDeflateTire:start()
    _ISDeflateTire_start(self)
    self:setActionAnim("VehicleWorkOnTire")
end

local _ISInflateTire_start = ISInflateTire.start
function ISInflateTire:start()
	_ISInflateTire_start(self)
    self:setActionAnim("VehicleWorkOnTire")
end

------------------
-- Player-initiated door interactions. These are the only places where a boop
-- belongs; the enter/exit/mechanic sequences build their own door actions.
if ISVehicleMenu then
    if ISVehicleMenu.onOpenDoor then
        local _ISVehicleMenu_onOpenDoor = ISVehicleMenu.onOpenDoor
        function ISVehicleMenu.onOpenDoor(playerObj, part)
            addVehicleBoop(playerObj, part, (doorType[part:getId()] and 1) or 0)
            return _ISVehicleMenu_onOpenDoor(playerObj, part)
        end
    end

    if ISVehicleMenu.onCloseDoor then
        local _ISVehicleMenu_onCloseDoor = ISVehicleMenu.onCloseDoor
        function ISVehicleMenu.onCloseDoor(playerObj, part)
            addVehicleBoop(playerObj, part, (doorType[part:getId()] and 101) or 0)
            return _ISVehicleMenu_onCloseDoor(playerObj, part)
        end
    end

    if ISVehicleMenu.onLockDoor then
        local _ISVehicleMenu_onLockDoor = ISVehicleMenu.onLockDoor
        function ISVehicleMenu.onLockDoor(playerObj, part)
            addVehicleBoop(playerObj, part, 0)
            return _ISVehicleMenu_onLockDoor(playerObj, part)
        end
    end

    if ISVehicleMenu.onUnlockDoor then
        local _ISVehicleMenu_onUnlockDoor = ISVehicleMenu.onUnlockDoor
        function ISVehicleMenu.onUnlockDoor(playerObj, part)
            addVehicleBoop(playerObj, part, 0)
            return _ISVehicleMenu_onUnlockDoor(playerObj, part)
        end
    end
end

local _ISTakeEngineParts_start = ISTakeEngineParts.start
function ISTakeEngineParts:start()
    _ISTakeEngineParts_start(self)
    self:setOverrideHandModels(self.item, nil)
    self:setActionAnim("FH_CarWrenchRepair")
end

local _ISRepairEngine_start = ISRepairEngine.start
function ISRepairEngine:start()
    _ISRepairEngine_start(self)
	self:setOverrideHandModels(self.item, nil)
    self:setActionAnim("FH_CarWrenchRepair")
end

local _ISInstallVehiclePart_start = ISInstallVehiclePart.start
function ISInstallVehiclePart:start()
    _ISInstallVehiclePart_start(self)
    if self.part:getId():contains("Suspension") then
        self:setActionAnim("VehicleWorkOnTire")
    elseif self.part:getId():contains("Door") then
        self:setActionAnim("FH_CarWrenchRepair")
    end
end

local _ISUninstallVehiclePart_start = ISUninstallVehiclePart.start
function ISUninstallVehiclePart:start()
    _ISUninstallVehiclePart_start(self)
    if self.part:getId():contains("Suspension") then
        self:setActionAnim("VehicleWorkOnTire")
    elseif self.part:getId():contains("Door") then
        self:setActionAnim("FH_CarWrenchRepair")
    end
end

local _ISEnterVehicle_start = ISEnterVehicle.start
function ISEnterVehicle:start()
    _ISEnterVehicle_start(self)
    self.action:setUseProgressBar((SandboxVars.FancyHandwork and not SandboxVars.FancyHandwork.HideDoorProgressBar) or false)
end

local _ISExitVehicle_start = ISExitVehicle.start
function ISExitVehicle:start()
    _ISExitVehicle_start(self)
    self.action:setUseProgressBar((SandboxVars.FancyHandwork and not SandboxVars.FancyHandwork.HideDoorProgressBar) or false)
end

local _ISPathFindAction_start = ISPathFindAction.start
function ISPathFindAction:start()
    _ISPathFindAction_start(self)
    self.action:setUseProgressBar((SandboxVars.FancyHandwork and not SandboxVars.FancyHandwork.HideVehicleWalkProgressBar) or false)
end

print("FH B42: Vehicle overrides loaded (open/close door boop moved off ISOpen/CloseVehicleDoor:new)")
