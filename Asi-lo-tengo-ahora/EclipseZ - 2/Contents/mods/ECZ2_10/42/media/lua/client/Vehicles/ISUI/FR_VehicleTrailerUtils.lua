require "Vehicles/ISUI/ISVehicleTrailerUtils"


--I might change the distance checked for the semi-trailers.

local temp_getTowableVehicleNear = ISVehicleTrailerUtils.getTowableVehicleNear
function ISVehicleTrailerUtils.getTowableVehicleNear(square, ignoreVehicle, attachmentA, attachmentB)
	--DebugLog.log("Intercepted ISVehicleTrailerUtils.getTowableVehicleNear")
	if string.find( ignoreVehicle:getScriptName(), "^Base.Trailer_fr_semi_" ) or ignoreVehicle:getPartById("FRFifthWheelHitch") then
		--DebugLog.log("Intercepted ISVehicleTrailerUtils.getTowableVehicleNear: Vehicle is a semi trailer or has a fifth wheel, extending towable check range.")
		for y=square:getY() - 7,square:getY()+7 do
			for x=square:getX()-7,square:getX()+7 do
				local square2 = getCell():getGridSquare(x, y, square:getZ())
				if square2 then
					for i=1,square2:getMovingObjects():size() do
						local obj = square2:getMovingObjects():get(i-1)
						if instanceof(obj, "BaseVehicle") and obj ~= ignoreVehicle and ignoreVehicle:canAttachTrailer(obj, attachmentA, attachmentB) then
							return obj
						end
					end
				end
			end
		end
		return nil
	end
	--DebugLog.log("Intercepted ISVehicleTrailerUtils.getTowableVehicleNear: Vehicle is NOT a semi trailer does NOT have a fifth wheel. Running vanilla.")
	return temp_getTowableVehicleNear(square, ignoreVehicle, attachmentA, attachmentB)
end

local temp_walkToTrailer = ISVehicleTrailerUtils.walkToTrailer
function ISVehicleTrailerUtils.walkToTrailer(playerObj, vehicle, attachment, nextAction)
	--DebugLog.log("Intercepted ISVehicleTrailerUtils.walkToTrailer")
	if string.find( vehicle:getScriptName(), "^Base.Trailer_fr_semi_" ) or vehicle:getPartById("FRFifthWheelHitch") then
		--DebugLog.log("Intercepted ISVehicleTrailerUtils.walkToTrailer: Vehicle is a semi trailer or has a fifth wheel, skipping the walk requirement.")
		ISTimedActionQueue.add(nextAction)
		return true;
	end
	--DebugLog.log("Intercepted ISVehicleTrailerUtils.walkToTrailer: Vehicle is NOT a semi trailer does NOT have a fifth wheel. Running vanilla.")
	return temp_walkToTrailer(playerObj, vehicle, attachment, nextAction)
end

