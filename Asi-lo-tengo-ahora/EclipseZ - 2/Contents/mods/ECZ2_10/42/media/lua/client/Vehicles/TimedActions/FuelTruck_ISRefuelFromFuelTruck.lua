--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISRefuelFromFuelTruck = ISBaseTimedAction:derive("ISRefuelFromFuelTruck")

function ISRefuelFromFuelTruck:isValid()
	return self.vehicle:isInArea(self.part:getArea(), self.character)
end

function ISRefuelFromFuelTruck:waitToStart()
	--DebugLog.log("ISRefuelFromFuelTruck:waitToStart: is running.")
	self.character:faceThisObject(self.vehicle)
	return self.character:shouldBeTurning()
end

function ISRefuelFromFuelTruck:update()
	--DebugLog.log("ISRefuelFromFuelTruck:update: is running.")
	local litres = self.tankStart + (self.tankTarget - self.tankStart) * self:getJobDelta()
	litres = math.floor(litres)
	if litres ~= self.amountSent then
		local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = litres }
		sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
		self.amountSent = litres
	end
--[[
	if isClient() then
		if math.floor(litres) ~= self.amountSent then
			local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = litres }
			sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)
			self.amountSent = math.floor(litres)
		end
	else
		self.part:setContainerContentAmount(litres)
	end
]]--
	local pumpUnits = self.pumpStart + (self.pumpTarget - self.pumpStart) * self:getJobDelta()
	pumpUnits = math.ceil(pumpUnits)
	--self.square:getProperties():Set("fuelAmount", tostring(pumpUnits))
	self.tank:setContainerContentAmount(pumpUnits)
    self.character:setMetabolicTarget(Metabolics.HeavyDomestic);
end

function ISRefuelFromFuelTruck:start()
	--DebugLog.log("ISRefuelFromFuelTruck:start: is running.")
	self.tankStart = self.part:getContainerContentAmount()
	-- Pumps start with 100 units of fuel.  8 pump units = 1 PetrolCan according to ISTakeFuel.
	--self.pumpStart = tonumber(self.square:getProperties():Val("fuelAmount"))
	self.pumpStart = self.tank:getContainerContentAmount()
	local pumpLitresAvail = self.pumpStart --* (Vehicles.JerryCanLitres / 8)
	local tankLitresFree = self.part:getContainerCapacity() - self.tankStart
	local takeLitres = math.min(tankLitresFree, pumpLitresAvail)
	self.tankTarget = self.tankStart + takeLitres
	self.pumpTarget = self.pumpStart - takeLitres --/ (Vehicles.JerryCanLitres / 8)
	self.amountSent = self.tankStart

	self.action:setTime(takeLitres * 50)

	self:setActionAnim("fill_container_tap")
	self:setOverrideHandModels(nil, nil)

	self.character:reportEvent("EventTakeWater");

	self.sound = self.character:playSound("VehicleAddFuelFromGasPump")
end

function ISRefuelFromFuelTruck:stop()
	--DebugLog.log("ISRefuelFromFuelTruck:stop: is running.")
	self.character:stopOrTriggerSound(self.sound)
	ISBaseTimedAction.stop(self)
	--Plan: if it's a client, then send this info to the server, then I guess back to the clients
	--self.tank:setContainerContentAmount(pumpUnits)
	--DebugLog.log("ISRefuelFromFuelTruck:stop: self.tank: " .. tostring(self.tank:getId()) .. ", self.tank:getContainerContentAmount(): " .. tostring(self.tank:getContainerContentAmount()))

	if isClient() then
		--local partTankID = self.tank:getId()
		local sourceVehicle = self.tank:getVehicle()
		--local sourceVehicleID = sourceVehicle:getId()
		local args = { partTankID = self.tank:getId(), sourceVehicleID = sourceVehicle:getId(), tankAmount = self.tank:getContainerContentAmount() }
		--DebugLog.log("ISRefuelFromFuelTruck:stop: isClient should be true, " .. tostring(isClient()) .. ", partTankID: " .. tostring(args.partTankID) .. ", sourceVehicleID: " .. tostring(args.sourceVehicleID) .. " tankAmount: " .. tostring(args.tankAmount))
		sendClientCommand(self.character, 'FR_UpdateParts', 'FR_FuelTankAmount', args)
	end
end

function ISRefuelFromFuelTruck:perform()
	--DebugLog.log("ISRefuelFromFuelTruck:perform: is running.")
	self.character:stopOrTriggerSound(self.sound)
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
	
	if isClient() then
		--local partTankID = self.tank:getId()
		local sourceVehicle = self.tank:getVehicle()
		--local sourceVehicleID = sourceVehicle:getId()
		local args = { partTankID = self.tank:getId(), sourceVehicleID = sourceVehicle:getId(), tankAmount = self.tank:getContainerContentAmount() }
		--DebugLog.log("ISRefuelFromFuelTruck:perform: isClient should be true, " .. tostring(isClient()) .. ", partTankID: " .. tostring(args.partTankID) .. ", sourceVehicleID: " .. tostring(args.sourceVehicleID) .. " tankAmount: " .. tostring(args.tankAmount))
		sendClientCommand(self.character, 'FR_UpdateParts', 'FR_FuelTankAmount', args)
	end
end

function ISRefuelFromFuelTruck:new(character, part, square, time, source_Tank)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.vehicle = part:getVehicle()
	o.part = part
	o.square = square
	o.maxTime = math.max(time, 50)
	o.tank = source_Tank
	return o
end

