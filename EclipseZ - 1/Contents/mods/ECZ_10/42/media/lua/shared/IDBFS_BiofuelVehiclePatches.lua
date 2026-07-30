IDBFS = IDBFS or {}
IDBFS.BiofuelVehiclePatches = IDBFS.BiofuelVehiclePatches or {}
IDBFS.BiofuelVehiclePatches.Generators = IDBFS.BiofuelVehiclePatches.Generators or {}

local function getFluidContainer(item)
    return item and item.getFluidContainer and item:getFluidContainer() or nil
end

local function getPrimaryFluidTypeString(fluidContainer)
    if not fluidContainer or fluidContainer:isEmpty() then
        return nil
    end
    local primary = fluidContainer.getPrimaryFluid and fluidContainer:getPrimaryFluid() or nil
    if primary and primary.getFluidTypeString then
        return primary:getFluidTypeString()
    end
    if fluidContainer.getPrimaryFluidTypeString then
        return fluidContainer:getPrimaryFluidTypeString()
    end
    return nil
end

local function isBiofuelItem(item)
    local fluidContainer = getFluidContainer(item)
    if not fluidContainer or fluidContainer:isEmpty() then
        return false
    end

    if IDBFS.getLiquidForFluidContainer then
        local liquidInfo = IDBFS.getLiquidForFluidContainer(item)
        if liquidInfo and liquidInfo.liquidType == "biofuel" and (liquidInfo.amount or 0) > 0 then
            return true
        end
    end

    local fluidType = getPrimaryFluidTypeString(fluidContainer)
    fluidType = fluidType and string.lower(tostring(fluidType)) or nil
    return fluidType == "idbfsbiofuel" or fluidType == "idbfs.idbfsbiofuel" or (fluidType and string.find(fluidType, "biofuel", 1, true) ~= nil)
end

local function getBiofuelFluid()
    if IDBFS.getFluidForLiquid then
        local fluid = IDBFS.getFluidForLiquid("biofuel")
        if fluid then
            return fluid
        end
    end
    if Fluid and Fluid.IDBFSBiofuel then
        return Fluid.IDBFSBiofuel
    end
    if Fluid and Fluid.Get then
        return Fluid.Get("IDBFSBiofuel") or Fluid.Get("IDBFS.IDBFSBiofuel")
    end
    return nil
end

local function getBiofuelEfficiency()
    local def = IDBFS.Liquids and IDBFS.Liquids.biofuel or nil
    local efficiency = tonumber(def and def.fuelEfficiency) or 1
    return math.max(0.01, math.min(1, efficiency))
end

local function getVehicleFuelType(part)
    local modData = part and part.getModData and part:getModData() or nil
    return modData and modData.IDBFSFuelType or nil
end

local function setVehicleFuelType(part, fuelType)
    local modData = part and part.getModData and part:getModData() or nil
    if modData then
        modData.IDBFSFuelType = fuelType
    end
end

local function syncVehiclePart(part)
    local vehicle = part and part.getVehicle and part:getVehicle() or nil
    if vehicle then
        vehicle:transmitPartModData(part)
    end
end

local function containerIsEmpty(item)
    local fluidContainer = getFluidContainer(item)
    return fluidContainer and fluidContainer:isEmpty()
end

local function addFluidToItem(item, fluid, amount)
    local fluidContainer = getFluidContainer(item)
    if not fluidContainer or not fluid or amount <= 0 then
        return
    end
    if fluidContainer:isEmpty() then
        fluidContainer:addFluid(fluid, amount)
    else
        fluidContainer:adjustAmount(amount)
    end
    if item.syncItemFields then
        item:syncItemFields()
    end
end

local function registerBiofuelGenerator(generator)
    if not generator then
        return
    end

    local generators = IDBFS.BiofuelVehiclePatches.Generators
    for i = 1, #generators do
        if generators[i] == generator then
            return
        end
    end
    generators[#generators + 1] = generator
end

local function patchAddGasolineToVehicle()
    if not ISAddGasolineToVehicle or ISAddGasolineToVehicle.IDBFSPatched then
        return
    end

    local originalComplete = ISAddGasolineToVehicle.complete
    ISAddGasolineToVehicle.complete = function(self)
        local fuelType = isBiofuelItem(self.item) and "biofuel" or "petrol"
        local result = originalComplete(self)
        if result and self.part then
            setVehicleFuelType(self.part, fuelType)
            syncVehiclePart(self.part)
        end
        return result
    end

    ISAddGasolineToVehicle.IDBFSPatched = true
end

local function patchTakeGasolineFromVehicle()
    if not ISTakeGasolineFromVehicle or ISTakeGasolineFromVehicle.IDBFSPatched then
        return
    end

    local originalComplete = ISTakeGasolineFromVehicle.complete
    ISTakeGasolineFromVehicle.complete = function(self)
        if getVehicleFuelType(self.part) ~= "biofuel" then
            return originalComplete(self)
        end

        if self.item == nil then
            return false
        end
        if not self.vehicle then
            print("no such vehicle id=", self.vehicle)
            return false
        end
        if not self.part then
            print("no such part ", self.part)
            return false
        end

        local biofuel = getBiofuelFluid()
        if not biofuel then
            return originalComplete(self)
        end

        if (self.itemStart or 0) <= 0 then
            if self.fluidCont and not self.fluidCont:isEmpty() and self.fluidCont.removeFluid then
                self.fluidCont:removeFluid(self.fluidCont:getAmount(), false)
            end
            addFluidToItem(self.item, biofuel, self.itemTarget)
        else
            self.fluidCont:adjustAmount(self.itemTarget)
            self.item:syncItemFields()
        end

        self.part:setContainerContentAmount(self.tankTarget)
        if self.tankTarget <= 0 then
            setVehicleFuelType(self.part, nil)
        end
        self.vehicle:transmitPartModData(self.part)
        return true
    end

    ISTakeGasolineFromVehicle.IDBFSPatched = true
end

local function patchAddFuelToGenerator()
    if not ISAddFuel or ISAddFuel.IDBFSPatched then
        return
    end

    local originalComplete = ISAddFuel.complete
    ISAddFuel.complete = function(self)
        local fuelType = isBiofuelItem(self.petrol) and "biofuel" or "petrol"
        local result = originalComplete(self)
        if result and self.generator and self.generator.getModData then
            local modData = self.generator:getModData()
            modData.IDBFSFuelType = fuelType
            modData.IDBFSLastFuel = self.generator:getFuel()
            if fuelType == "biofuel" then
                registerBiofuelGenerator(self.generator)
            end
            if self.generator.sync then
                self.generator:sync()
            end
        end
        return result
    end

    ISAddFuel.IDBFSPatched = true
end

local function syncGenerator(generator)
    if not generator then
        return
    end
    if generator.sync then
        generator:sync()
    end
    if generator.transmitModData then
        generator:transmitModData()
    end
end

local function isGeneratorActive(generator)
    if generator and generator.isActivated then
        return generator:isActivated()
    end
    if generator and generator.isRunning then
        return generator:isRunning()
    end
    return false
end

local function applyBiofuelGeneratorDrain(generator)
    if not generator or not generator.getModData or not generator.getFuel or not generator.setFuel then
        return
    end

    local modData = generator:getModData()
    if not modData or modData.IDBFSFuelType ~= "biofuel" then
        return
    end

    local fuel = tonumber(generator:getFuel()) or 0
    if fuel <= 0 then
        modData.IDBFSFuelType = nil
        modData.IDBFSLastFuel = nil
        syncGenerator(generator)
        return
    end

    if not isGeneratorActive(generator) then
        modData.IDBFSLastFuel = fuel
        syncGenerator(generator)
        return
    end

    local lastFuel = tonumber(modData.IDBFSLastFuel)
    if not lastFuel or lastFuel < fuel then
        modData.IDBFSLastFuel = fuel
        syncGenerator(generator)
        return
    end

    local vanillaDrain = lastFuel - fuel
    if vanillaDrain <= 0 then
        modData.IDBFSLastFuel = fuel
        return
    end

    local efficiency = getBiofuelEfficiency()
    local extraDrain = vanillaDrain * ((1 / efficiency) - 1)
    local adjustedFuel = math.max(0, fuel - extraDrain)
    generator:setFuel(adjustedFuel)
    modData.IDBFSLastFuel = adjustedFuel
    if adjustedFuel <= 0 then
        modData.IDBFSFuelType = nil
    end
    syncGenerator(generator)
end

local function shouldKeepGeneratorInDrainList(generator)
    local ok, keep = pcall(function()
        local modData = generator and generator.getModData and generator:getModData() or nil
        local fuel = generator and generator.getFuel and tonumber(generator:getFuel()) or 0
        return modData and modData.IDBFSFuelType == "biofuel" and fuel > 0
    end)
    return ok and keep == true
end

local function drainRegisteredBiofuelGenerators()
    if isClient and isClient() then
        return
    end

    local generators = IDBFS.BiofuelVehiclePatches.Generators
    for i = #generators, 1, -1 do
        local generator = generators[i]
        if shouldKeepGeneratorInDrainList(generator) then
            local ok = pcall(applyBiofuelGeneratorDrain, generator)
            if not ok or not shouldKeepGeneratorInDrainList(generator) then
                table.remove(generators, i)
            end
        else
            table.remove(generators, i)
        end
    end
end

function IDBFS.BiofuelVehiclePatches.install()
    pcall(require, "Vehicles/TimedActions/ISAddGasolineToVehicle")
    pcall(require, "Vehicles/TimedActions/ISTakeGasolineFromVehicle")
    pcall(require, "TimedActions/ISAddFuel")
    patchAddGasolineToVehicle()
    patchTakeGasolineFromVehicle()
    patchAddFuelToGenerator()
end

local function addEvent(event, callback)
    if event and event.Add then
        event.Add(callback)
    end
end

addEvent(Events.OnGameBoot, IDBFS.BiofuelVehiclePatches.install)
addEvent(Events.OnGameStart, IDBFS.BiofuelVehiclePatches.install)
addEvent(Events.EveryTenMinutes, drainRegisteredBiofuelGenerators)

IDBFS.BiofuelVehiclePatches.install()
