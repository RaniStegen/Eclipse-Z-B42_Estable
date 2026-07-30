--This stuff is from my main man Blair. I might have edited it a little, but it's still his, haha.

require "Vehicles/ISUI/ISVehicleMenu"
require "TimedActions/ISInventoryTransferUtil"

local old_ISVehicleMenu_FillPartMenu = ISVehicleMenu.FillPartMenu

function ISVehicleMenu.FillPartMenu(playerIndex, context, slice, vehicle)
	--local what = IsoObjectPicker():PickVehicle(2,2)
	
	-- print("Player Index: ".. tostring(playerIndex))
	-- print("Context: ".. tostring(context))
	-- print("Slice: " ..tostring(slice))
	-- print("Vehicle: " ..tostring(vehicle))
	
	
	local playerObj = getSpecificPlayer(playerIndex);
	local typeToItem = VehicleUtils.getItems(playerIndex)
	
	local fuel_truck_source = FindVehicleGas(playerObj, vehicle)
	
	
	for i=1,vehicle:getPartCount() do
		local part = vehicle:getPartByIndex(i-1)		
		if part:isContainer() and part:getContainerContentType() == "Gasoline Storage" then
			if ISVehiclePartMenu.getGasCanNotEmpty(playerObj, typeToItem) and part:getContainerContentAmount() < part:getContainerCapacity() then
				if slice then
					slice:addSlice(getText("ContextMenu_FR_AddGasToFuelStorage"), getTexture("media/ui/vehicles/vehicle_add_gas.png"), ISVehiclePartMenu.onAddGasoline, playerObj, part)
				else
					context:addOption(getText("ContextMenu_FR_AddGasToFuelStorage"), playerObj,ISVehiclePartMenu.onAddGasoline, part)
				end
			end
			if ISVehiclePartMenu.getGasCanNotFull(playerObj, typeToItem) and part:getContainerContentAmount() > 0 then
				if slice then
					slice:addSlice(getText("ContextMenu_FR_TakeGasFromFuelStorage"), getTexture("media/ui/vehicles/vehicle_siphon_gas.png"), ISVehiclePartMenu.onTakeGasolineNoHose, playerObj, part)
				else
					context:addOption(getText("ContextMenu_FR_TakeGasFromFuelStorage"), playerObj, ISVehiclePartMenu.onTakeGasolineNoHose, part)
				end
			end
			
			local fuelStation = ISVehiclePartMenu.getNearbyFuelPump(vehicle)
			if fuelStation then
				local square = fuelStation:getSquare();
				if square and ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
					if square and part:getContainerContentAmount() < part:getContainerCapacity() then
						if slice then
							slice:addSlice(getText("ContextMenu_FR_FillFuelTankFromPump"), getTexture("media/textures/ui/refuel_tank_from_pump.png"), ISVehiclePartMenu.onPumpGasoline, playerObj, part)
						else
							context:addOption(getText("ContextMenu_FR_FillFuelTankFromPump"), playerObj, ISVehiclePartMenu.onPumpGasoline, part)
						end
					end
				end
			end
			
			if fuel_truck_source and fuel_truck_source:getContainerContentAmount() > 0 and part:getContainerContentAmount() < part:getContainerCapacity() then
				--if square and part:getContainerContentAmount() < part:getContainerCapacity() then
					if slice then
						slice:addSlice(getText("ContextMenu_FR_FillFuelTankFromFuelTank"), getTexture("media/textures/ui/refuel_tank_from_tank.png"), ISVehiclePartMenu.onPumpGasolineFromTruck, playerObj, part, fuel_truck_source)
					else
						context:addOption(getText("ContextMenu_FR_FillFuelTankFromFuelTank"), playerObj, ISVehiclePartMenu.onPumpGasolineFromTruck, part, fuel_truck_source)
					end
				--end
			end			
		end	

		if not vehicle:isEngineStarted() and part:isContainer() and part:getContainerContentType() == "Gasoline" then
			print("Room")
			
			
			--local square = ISVehiclePartMenu.getNearbyFuelPump(vehicle)
			if fuel_truck_source and fuel_truck_source:getContainerContentAmount() > 0 and part:getContainerContentAmount() < part:getContainerCapacity() then
				--if square and part:getContainerContentAmount() < part:getContainerCapacity() then
					if slice then
						slice:addSlice(getText("ContextMenu_FR_AddGasFromFuelStorage"), getTexture("media/textures/ui/vehicle_refuel_from_tank.png"), ISVehiclePartMenu.onPumpGasolineFromTruck, playerObj, part, fuel_truck_source)
					else
						context:addOption(getText("ContextMenu_FR_AddGasFromFuelStorage"), playerObj, ISVehiclePartMenu.onPumpGasolineFromTruck, part, fuel_truck_source)
					end
				--end
			end			
		end


		
	end
	old_ISVehicleMenu_FillPartMenu(playerIndex, context, slice, vehicle)
end

function FindVehicleGas(playerObj, playerVehicle)
	--print("TEST")
	local radius = 5
	local player = getPlayer()
	local cell = playerObj:getCell()
	local vehicleList = cell:getVehicles()
	local processed = {}
	--for b,vehicle in pairs(vehicleList) do
	for index=0, vehicleList:size()-1 do
		local vehicle = vehicleList[index]
		if vehicle ~= nil and not processed[vehicle] then
			processed[vehicle] = true
			for i=1,vehicle:getPartCount() do
				local part = vehicle:getPartByIndex(i-1)
				if part:isContainer() and part:getContainerContentType() == "Gasoline Storage" and part:getContainerContentAmount() > 0 and vehicle ~= playerVehicle then
					print("FUEL")
					local square = vehicle:getSquare()
						x = math.abs(vehicle:getX()-playerObj:getX())
						y = math.abs(vehicle:getY()-playerObj:getY())
						if x <radius and y<radius then
						--if playerObj:distTo(vehicle) < 10 then
							-- We've found fuel storage
							print("FUEL")
							print(tostring(vehicle:getX()))
							print(tostring(vehicle:getY()))
							--return true
							return part
						end
				end
			end
		end
	end
	return false
end

function ISVehiclePartMenu.onPumpGasolineFromTruck(playerObj, part, source_Tank)
	if playerObj:getVehicle() then
		ISVehicleMenu.onExit(playerObj)
	end
	local square = source_Tank:getVehicle():getSquare()
	if square then
		local action = ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea())
		action:setOnFail(ISVehiclePartMenu.onPumpGasolinePathFail, playerObj)
		ISTimedActionQueue.add(action)
		ISTimedActionQueue.add(ISRefuelFromFuelTruck:new(playerObj, part, square, 100, source_Tank))
	end
end


function FR_create_blank_part()

end

function ISVehiclePartMenu.onTakeGasolineNoHose(playerObj, part)
	if playerObj:getVehicle() then
		ISVehicleMenu.onExit(playerObj)
	end
	local typeToItem,tagToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
	local item = ISVehiclePartMenu.getGasCanNotFull(playerObj, typeToItem)
	if item then
		ISVehiclePartMenu.toPlayerInventory(playerObj, item)
		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
		ISInventoryPaneContextMenu.equipWeapon(item, false, false, playerObj:getPlayerNum())
		ISTimedActionQueue.add(ISTakeGasolineFromVehicle:new(playerObj, part, item))
	end
end
