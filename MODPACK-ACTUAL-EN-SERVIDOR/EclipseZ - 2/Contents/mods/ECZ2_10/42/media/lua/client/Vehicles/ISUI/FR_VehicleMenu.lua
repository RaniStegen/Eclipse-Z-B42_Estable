require "Vehicles/ISUI/ISVehicleMenu"

if FR_VehicleMenu == nil then FR_VehicleMenu = {} end
if FR_VehicleMenu.UI == nil then FR_VehicleMenu.UI = {} end

function FR_VehicleMenu.UI.addOptions(playerObj)
	--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Running function.")
	local menu = getPlayerRadialMenu (playerObj:getPlayerNum())
	if menu == nil then
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Menu is nil")
	return end
	
	local vehicle = playerObj:getVehicle()
	if not vehicle then 
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Vehicle is nil")
		return
	end
	
	local seat = vehicle:getSeat(playerObj)
	local doorPart = vehicle:getPassengerDoor(seat)
	local partConRoof = vehicle:getPartById("FRConRoof")
	local partStopSign = vehicle:getPartById("FRBusStopSign")
	local partInteriorTrunkDoor = vehicle:getPartById("InteriorTrunkDoor")

		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Player's seat is " .. tostring(seat) .. " in the " .. tostring(vehicle:getScriptName()))
	
	if (seat <=1 and partConRoof and partConRoof:getInventoryItem()) then
		--DebugLog.log ("CONVERTIBLE ROOF: Car has roof and player is in the right spot")
		if partConRoof:getDoor():isOpen() then
			--DebugLog.log ("CONVERTIBLE ROOF: Car roof is opened, close it?")
			menu:addSlice(getText("ContextMenu_FR_ConvertClose"), getTexture("media/textures/ui/condown.png"), FR_Functions.togglePart, playerObj, "FRConRoof")
		else
			--DebugLog.log ("CONVERTIBLE ROOF: Car roof is closed, open it?")
			menu:addSlice(getText("ContextMenu_FR_ConvertOpen"), getTexture("media/textures/ui/conup.png"), FR_Functions.togglePart, playerObj, "FRConRoof")
		end
	end
	
	if (seat ==0 and partStopSign and partStopSign:getInventoryItem()) then
		--DebugLog.log ("BUS STOP SIGN: Car has roof and player is in the right spot")
		if partStopSign:getDoor():isOpen() then
			--DebugLog.log ("BUS STOP SIGN: Stop sign is opened, close it?")
			menu:addSlice(getText("ContextMenu_FR_StopSignClose"), getTexture("media/textures/ui/stopsignin.png"), FR_Functions.togglePart, playerObj, "FRBusStopSign")
		else
			--DebugLog.log ("BUS STOP SIGN: Stop sign is closed, open it?")
			menu:addSlice(getText("ContextMenu_FR_StopSignOpen"), getTexture("media/textures/ui/stopsignout.png"), FR_Functions.togglePart, playerObj, "FRBusStopSign")
		end
	end
	
	if partInteriorTrunkDoor and partInteriorTrunkDoor:getInventoryItem() then
		local seatIndex = vehicle:getSeat(chr)
		local seatPart = vehicle:getPartForSeatContainer(seatIndex)
		--local partTrunk = vehicle:getPartById("TruckBed")
		--local keyvaluesContainer = partTrunk:getTable("FRPartInfo")
		local keyvaluesSeat = seatPart:getTable("FRPartInfo")
		if keyvaluesSeat and keyvaluesSeat.canAccessInterior then
			if partInteriorTrunkDoor:getDoor() and partInteriorTrunkDoor:getDoor():isOpen() then
				--DebugLog.log ("Interior Trunk is opened, close it?")
				menu:addSlice(getText("IGUI_CloseTrunk"), getTexture("media/textures/ui/trunkdoorinside_close.png"), FR_Functions.togglePart, playerObj, "InteriorTrunkDoor")
			else
				--DebugLog.log ("Interior Trunk is closed, open it?")
				menu:addSlice(getText("IGUI_OpenTrunk"), getTexture("media/textures/ui/trunkdoorinside_open.png"), FR_Functions.togglePart, playerObj, "InteriorTrunkDoor")
			end
		end
	end
	
	if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() then
		if doorPart:getDoor():isOpen() then
			menu:addSlice(getText("ContextMenu_Close_door"), getTexture("media/textures/ui/doorinside_close.png"), ISVehicleMenu.onCloseDoor, playerObj, doorPart)
		else
			menu:addSlice(getText("ContextMenu_Open_door"), getTexture("media/textures/ui/doorinside_open.png"), ISVehicleMenu.onOpenDoor, playerObj, doorPart)
			--close it
		end
	end
	
	if (seat >=2 or string.match( vehicle:getScriptName(), "Trailer_fr_camper" )) and (vehicle:getPartById("FR_Fridge") or vehicle:getPartById("FR_Oven")) then
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Player is in the correct seat and vehicle")

		if vehicle:getPartById("FR_Fridge") then
			if vehicle:getPartById("FR_Fridge"):getModData().FR_FridgeActive then
				menu:addSlice(getText("ContextMenu_FR_VehicleFridgeOff"), getTexture("media/textures/ui/fridgeoff.png"), FR_Functions.toggleFridge, playerObj)
			elseif vehicle:getBatteryCharge() > 0.0 or vehicle:getSquare():haveElectricity() then
				menu:addSlice(getText("ContextMenu_FR_VehicleFridgeOn"), getTexture("media/textures/ui/fridgeon.png"), FR_Functions.toggleFridge, playerObj)
			else
				menu:addSlice(getText("ContextMenu_FR_VehicleFridgeNoPower"), getTexture("media/textures/ui/fridgeoff.png"))
			end
		end
		
		if vehicle:getPartById("FR_Oven") then
			if vehicle:getPartById("FR_Oven"):getModData().FR_OvenActive then
				menu:addSlice(getText("ContextMenu_FR_VehicleOvenOff"), getTexture("media/textures/ui/ovenoff.png"), FR_Functions.toggleOven, playerObj)
			elseif vehicle:getBatteryCharge() > 0.0 or vehicle:getSquare():haveElectricity() then
				menu:addSlice(getText("ContextMenu_FR_VehicleOvenOn"), getTexture("media/textures/ui/ovenon.png"), FR_Functions.toggleOven, playerObj)
			else
				menu:addSlice(getText("ContextMenu_FR_VehicleOvenNoPower"), getTexture("media/textures/ui/ovenoff.png"))
			end
		end
	end
	
	--local vehicleScriptName = vehicle:getScriptName()
	--local currentGearType = vehicleScriptName:getEngineRPMType()
	--if seat ==0 and currentGearType then
	--	menu:addSlice(getText("ContextMenu_FR_VehicleOvenOff"), getTexture("media/textures/ui/ovenoff.png"), FR_Functions.changeGearType, currentGearType)
	--end
	
end

function FR_VehicleMenu.UI.addOptionsOutside(playerObj)
	--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONSOUTSIDE: Running function.")
	local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
	if menu == nil then
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONSOUTSIDE: Menu is nil")
	return end
	
	local inVehicle = playerObj:getVehicle()
	local vehicle = ISVehicleMenu.getVehicleToInteractWith(playerObj)
	if inVehicle or not vehicle then 
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONSOUTSIDE: Player is in a vehicle")
		return
	end
	
	--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONSOUTSIDE: Vehicle is: " .. tostring(vehicle))
	local partAwning = vehicle:getPartById("FRAwning")
	local partAxeMount = vehicle:getPartById("FRAxeMount")
	local partShovelMount = vehicle:getPartById("FRShovelMount")
	local partSpareTire = vehicle:getPartById("FRSpareTire")
	local partGasCanMount = vehicle:getPartById("FRGasCanMount")
	local partInteriorTrunkDoor = vehicle:getPartById("InteriorTrunkDoor")
	local partWindshieldFolding = vehicle:getPartById("FRFrameWindshieldFolding")

	if partAwning and partAwning:getInventoryItem() then
		--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: FRAwning: Car has awning and player is in the right spot")
		if partAwning:getDoor():isOpen() then
			--DebugLog.log ("FRAwning: Awning is opened, close it?")
			menu:addSlice(getText("ContextMenu_FR_AwningClose"), getTexture("media/textures/ui/rvawningclose.png"), FR_Functions.togglePart, playerObj, "FRAwning")
		else
			--DebugLog.log ("FRAwning: Awning is closed, open it?")
			menu:addSlice(getText("ContextMenu_FR_AwningOpen"), getTexture("media/textures/ui/rvawningopen.png"), FR_Functions.togglePart, playerObj, "FRAwning")
		end
	end

	if partWindshieldFolding and partWindshieldFolding:getInventoryItem() then
		--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: FRAwning: Car has awning and player is in the right spot")
		if partWindshieldFolding:getDoor():isOpen() then
			--DebugLog.log ("FRAwning: Windshield is opened, close it?")
			menu:addSlice(getText("ContextMenu_FR_WindshieldFrameClose"), getTexture("media/textures/ui/windshielframeclose.png"), FR_Functions.togglePart, playerObj, "FRFrameWindshieldFolding")
		else
			--DebugLog.log ("FRAwning: Windshield is closed, open it?")
			menu:addSlice(getText("ContextMenu_FR_WindshieldFrameOpen"), getTexture("media/textures/ui/windshielframeopen.png"), FR_Functions.togglePart, playerObj, "FRFrameWindshieldFolding")
		end
	end
	
	if partInteriorTrunkDoor and partInteriorTrunkDoor:getInventoryItem() then
		local partTrunk = vehicle:getPartById("TruckBed")
		local keyvalues = partTrunk:getTable("FRPartInfo")
		if keyvalues and keyvalues.blocksTrunk then
			local trunkBlocker = vehicle:getPartById(tostring(keyvalues.blocksTrunk))
			if trunkBlocker and not trunkBlocker:getInventoryItem() and partTrunk:getArea() and vehicle:isInArea(partTrunk:getArea(), playerObj) then
				if partInteriorTrunkDoor:getDoor() and partInteriorTrunkDoor:getDoor():isOpen() then
					--DebugLog.log ("Interior Trunk is opened, close it?")
					menu:addSlice(getText("IGUI_CloseTrunk"), getTexture("media/textures/ui/trunkdoorinside_close.png"), FR_Functions.togglePart, playerObj, "InteriorTrunkDoor")
				else
					--DebugLog.log ("Interior Trunk is closed, open it?")
					menu:addSlice(getText("IGUI_OpenTrunk"), getTexture("media/textures/ui/trunkdoorinside_open.png"), FR_Functions.togglePart, playerObj, "InteriorTrunkDoor")
				end
			end
		end
	end
	
	--Set this up so the parts have keyvalues that say whether or not it needs a door, like the trunk, opened to use
	if partAxeMount then
		local item = FR_VehicleMenu.GetItemLocation(vehicle, partAxeMount, playerObj)
		--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: item " .. tostring(item))
		if item == "inVehicle" then
			menu:addSlice(getText("ContextMenu_FR_AxeMountRemoveAxe"), getTexture("media/textures/ui/mountremoveaxe.png"), FR_Functions.itemMountRemove, partAxeMount, playerObj, vehicle)
		elseif type(item) == "userdata" then
			--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Item in hand, item is " .. tostring(item))
			menu:addSlice(getText("ContextMenu_FR_AxeMountAddAxe"), getTexture("media/textures/ui/mountaddaxe.png"), FR_Functions.itemMountAdd, partAxeMount, item, playerObj, vehicle)
		elseif item == "inInventory" then
			menu:addSlice(getText("ContextMenu_FR_AxeMountEquipItem"), getTexture("media/textures/ui/mountinventorytools.png"))
		end
	end
	
	if partShovelMount then
		local item = FR_VehicleMenu.GetItemLocation(vehicle, partShovelMount, playerObj)
		--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: item " .. tostring(item))
		if item == "inVehicle" then
			menu:addSlice(getText("ContextMenu_FR_ShovelMountRemoveShovel"), getTexture("media/textures/ui/mountremoveshovel.png"), FR_Functions.itemMountRemove, partShovelMount, playerObj, vehicle)
		elseif type(item) == "userdata" then
			--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Item in hand, item is " .. tostring(item))
			menu:addSlice(getText("ContextMenu_FR_ShovelMountAddShovel"), getTexture("media/textures/ui/mountaddshovel.png"), FR_Functions.itemMountAdd, partShovelMount, item, playerObj, vehicle)
		elseif item == "inInventory" then
			menu:addSlice(getText("ContextMenu_FR_ShovelMountEquipItem"), getTexture("media/textures/ui/mountinventorytools.png"))
		end
	end
	
	if partGasCanMount then
		local item = FR_VehicleMenu.GetItemLocation(vehicle, partGasCanMount, playerObj)
		--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: item " .. tostring(item))
		if item == "inVehicle" then
			menu:addSlice(getText("ContextMenu_FR_GasMountRemoveGas"), getTexture("media/textures/ui/mountremovegascan.png"), FR_Functions.itemMountRemove, partGasCanMount, playerObj, vehicle)
		elseif type(item) == "userdata" then
			--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Item in hand, item is " .. tostring(item))
			menu:addSlice(getText("ContextMenu_FR_GasMountAddGas"), getTexture("media/textures/ui/mountaddgascan.png"), FR_Functions.itemMountAdd, partGasCanMount, item, playerObj, vehicle)
		elseif item == "inInventory" then
			menu:addSlice(getText("ContextMenu_FR_GasMountEquipItem"), getTexture("media/textures/ui/mountinventorygascan.png"))
		end
	end
	
	if partSpareTire then
		local item = FR_VehicleMenu.GetItemLocation(vehicle, partSpareTire, playerObj)
		--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: item " .. tostring(item))
		if item == "inVehicle" then
			menu:addSlice(getText("ContextMenu_FR_SpareTireMountRemoveSpareTire"), getTexture("media/textures/ui/mountremovetire.png"), FR_Functions.itemMountRemove, partSpareTire, playerObj, vehicle)
		elseif type(item) == "userdata" then
			--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Item in hand, item is " .. tostring(item))
			menu:addSlice(getText("ContextMenu_FR_SpareTireMountAddSpareTire"), getTexture("media/textures/ui/mountaddtire.png"), FR_Functions.itemMountAdd, partSpareTire, item, playerObj, vehicle)
		elseif item == "inInventory" then
			menu:addSlice(getText("ContextMenu_FR_SpareTireMountEquipItem"), getTexture("media/textures/ui/mountinventorytire.png"))
		end
	end
end

function FR_VehicleMenu.GetItemLocation(vehicle, part, playerObj)
	if part then
		local keyvaluesPartInfo = part:getTable("FRPartInfo")
		local keyvaluesInstall = part:getTable("install")
		local keyvaluesUninstall = part:getTable("uninstall")
		--local doorAccess = keyvaluesPartInfo and keyvaluesPartInfo.doorAccess
		--local hasVolume = keyvaluesPartInfo and keyvaluesPartInfo.hasWeight
		--DebugLog.log ("FR_VehicleMenu.GetItemLocation: area test: " .. tostring(part:getId()) .. " is in " .. tostring(part:getArea()))
		
		--if access anywehere = true or player is in the area to access then check the door stuff
		if not((keyvaluesPartInfo and keyvaluesPartInfo.accessAnywhere) or not part:getArea() or vehicle:isInArea(part:getArea(), playerObj)) then
			return "notInArea"
		end
		
		if keyvaluesPartInfo and keyvaluesPartInfo.doorAccess and vehicle:getPartById(tostring(keyvaluesPartInfo.doorAccess)) then
			local doorPart = vehicle:getPartById(keyvaluesPartInfo.doorAccess)
			if doorPart:getInventoryItem() and doorPart:getDoor() and not doorPart:getDoor():isOpen() then
				--DebugLog.log ("FR_VehicleMenu.GetItemLocation: Needs " .. tostring(keyvaluesPartInfo.doorAccess) .. " opened to access.")
				return "doorClosed"
			end
		end
		
		if part:getInventoryItem() then
			if not Vehicles.UninstallTest.FR_Default(vehicle, part, playerObj) then
				--DebugLog.log ("FR_VehicleMenu.GetItemLocation: Uninstall test: " .. tostring(Vehicles.UninstallTest.FR_Default(vehicle, part, playerObj)))
				return "cannotUninstall"
			end
			--DebugLog.log ("FR_VehicleMenu.GetItemLocation: There's an item mounted.")
			return "inVehicle"
		elseif not part:getInventoryItem() then
			if not Vehicles.InstallTest.Default(vehicle, part, playerObj) then
				--DebugLog.log ("FR_VehicleMenu.GetItemLocation: Install test: " .. tostring(Vehicles.InstallTest.Default(vehicle, part, playerObj)))
				return "cannotInstall"
			end
			local equippedPrimary = playerObj:getPrimaryHandItem()
			local equippedSecondary = playerObj:getSecondaryHandItem()
			equippedPrimary = equippedPrimary and equippedPrimary:getType()
			equippedSecondary = equippedSecondary and equippedSecondary:getType()
			--DebugLog.log ("FR_VehicleMenu.GetItemLocation: There's no item mounted.")
			--DebugLog.log ("FR_VehicleMenu.GetItemLocation: Primary: " .. tostring(equippedPrimary) .. ", secondary: " .. tostring(equippedSecondary))
			
			local inInventory
			for i=1,part:getItemType():size() do
				local item = part:getItemType():get(i-1)
				if string.match(item,(tostring(equippedPrimary))) then
					--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Player's right hand " .. tostring(equippedPrimary) .. " or left hand " .. tostring(equippedSecondary) .. " is " .. type(playerObj:getPrimaryHandItem()))
					return playerObj:getPrimaryHandItem()
				elseif string.match(item,(tostring(equippedSecondary))) then
					--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Player's right hand " .. tostring(equippedPrimary) .. " or left hand " .. tostring(equippedSecondary) .. " is " .. tostring(item))
					return playerObj:getSecondaryHandItem()
				elseif playerObj:getInventory():contains(item) then
					--DebugLog.log ("FR_VehicleMenu.UI.addOptionsOutside: Player has a " .. tostring(item) .. " in their inventory. Equip to place.")
					inInventory = true
				end
				--DebugLog.log("FR_VehicleMenu.UI.addOptionsOutside: " .. tostring(i) .. ", " .. tostring(item))
			end
			if inInventory then
				return "inInventory"
			end
		end
	end
end

if isClient() then
	local old_ISVehicleMenu_FillMenuOutsideVehicle = ISVehicleMenu.FillMenuOutsideVehicle

	function ISVehicleMenu.FillMenuOutsideVehicle(player, context, slice, vehicle)

		local frucAnimBugMenu= nil
		local subOptionAnimBug = context:addOption("FRUC Animation Bug Fix")
		subOptionAnimBug.iconTexture = getTexture("media/ui/AnimationFixIcon.png")
		frucAnimBugMenu= ISContextMenu:getNew(context)
		context:addSubMenu(subOptionAnimBug, frucAnimBugMenu)
		frucAnimBugMenu:addOption("Refresh Part Models for Nearby Vehicles", player, FR_VehicleMenu.refreshPartsCell)
		local playerObj = getSpecificPlayer(player)
		local playerVehicle = ISVehicleMenu.getVehicleToInteractWith(playerObj)
		if playerVehicle and string.find(playerVehicle:getScriptName(), "fr_") then
			local refreshText = "Refresh Part Models for " .. playerVehicle:getScriptName()
			frucAnimBugMenu:addOption(refreshText, player, FR_VehicleMenu.refreshParts, playerVehicle)
		end
		old_ISVehicleMenu_FillMenuOutsideVehicle(player, context, slice, vehicle)
	end


	function FR_VehicleMenu.refreshPartsCell(player)
		-- maybe get all vehicles around player
		local vehicleList = getCell():getVehicles()
		for v=1,vehicleList:size() do
			local vehicle = vehicleList[v-1]
			if vehicle and string.find(vehicle:getScriptName(), "fr_")then
				for i=1,vehicle:getPartCount() do
					local part = vehicle:getPartByIndex(i-1)
					if part then
						local luaFunction = part:getLuaFunction("init")
						if luaFunction then
							VehicleUtils.callLua(luaFunction, vehicle, part)
							vehicle:doDamageOverlay()
						end
					end
				end
			end
		end
	end
	
	function FR_VehicleMenu.refreshParts(player, playerVehicle)
		--DebugLog.log("FR_VehicleMenu.refreshParts is running")
		local vehicle = playerVehicle
		local playerObj = getSpecificPlayer(player)
		if not vehicle then return end
		for i=1,vehicle:getPartCount() do
			local part = vehicle:getPartByIndex(i-1)
			if part then
				--DebugLog.log("FR_VehicleMenu.refreshParts: part " .. tostring(i) .. " is " .. tostring(part))
				local luaFunction = part:getLuaFunction("init")
					--DebugLog.log("FR_VehicleMenu.refreshParts: luaFunction is " .. tostring(luaFunction) .. ", type is " .. type(luaFunction))
				if luaFunction then
					--DebugLog.log("FR_VehicleMenu.refreshParts: Calling luaFunction for part " .. tostring(i))
					VehicleUtils.callLua(luaFunction, vehicle, part)
					--DebugLog.log("FR_VehicleMenu.refreshParts: Called luaFunction for part " .. tostring(i))
					vehicle:doDamageOverlay()
					--DebugLog.log("FR_VehicleMenu.refreshParts: doDamageOverlay for " .. tostring(vehicle))
				end
			end
		end
	end
end

--Add options to the interior vehicle menu
if FR_VehicleMenu.UI.defaultShowRadialMenu == nil then
    FR_VehicleMenu.UI.defaultShowRadialMenu = ISVehicleMenu.showRadialMenu
end

function ISVehicleMenu.showRadialMenu(playerObj)
		FR_VehicleMenu.UI.defaultShowRadialMenu(playerObj)
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Intercepting showRadialMenu")
		

    if playerObj:getVehicle() then
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONS: Attempting to add options")
		FR_VehicleMenu.UI.addOptions(playerObj)
    end
end

--Add options to the exterior vehicle menu
if FR_VehicleMenu.UI.defaultshowRadialMenuOutside == nil then
    FR_VehicleMenu.UI.defaultshowRadialMenuOutside = ISVehicleMenu.showRadialMenuOutside
end

function ISVehicleMenu.showRadialMenuOutside(playerObj)
		FR_VehicleMenu.UI.defaultshowRadialMenuOutside(playerObj)
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONSOUTSIDE: Intercepting showRadialMenuOutside")
		

    if ISVehicleMenu.getVehicleToInteractWith(playerObj) then
		--DebugLog.log ("FR_VEHICLEMENU.ADDOPTIONSOUTSIDE: Attempting to add options")
		FR_VehicleMenu.UI.addOptionsOutside(playerObj)
    end
end

FR_TowMenu = {}

--This checks if the vehicle has a trailer hitch slot, and if the hitch is installed.
function FR_TowMenu.hasHitch(vehicle, hitchType)
	--DebugLog.log ("FR_TowMenu.hasHitch: Checking " .. tostring(vehicle:getScriptName()) .. " for " .. tostring(hitchType))
	local part = vehicle:getPartById(hitchType)
	--DebugLog.log ("FR_TowMenu.hasHitch: " .. tostring(part))
	return (vehicle and (part and part:getInventoryItem() ~= nil))
end

--This partially works. Keeping it as a backup.
local temp_doTowingMenu = ISVehicleMenu.doTowingMenu
function ISVehicleMenu.doTowingMenu(playerObj, vehicle, menu)
	--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: vehicle is " .. tostring(vehicle:getScriptName()))
	
	local attachmentA, attachmentB = "trailer", "trailer"
	local vehicleB = ISVehicleTrailerUtils.getTowableVehicleNear(vehicle:getSquare(), vehicle, attachmentA, attachmentB)
	local hitchType = "FRTrailerHitch"

	if vehicleB then
		--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: vehicleB is " .. tostring(vehicleB:getScriptName()))
	else
		--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: vehicleB is not there.")
	end
	
	--if vehicle or vehicleB are one of the vanilla cars, or they're both mine, it runs the vanilla function
	if not vehicleB or (string.find( vehicle:getScriptName(), "^Base.fr_" ) and string.find( vehicleB:getScriptName(), "^Base.fr_" )) or not (string.find( vehicle:getScriptName(), "^Base.fr_" ) or string.find( vehicleB:getScriptName(), "^Base.fr_" )) then
		--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: running vanilla function.")
		temp_doTowingMenu(playerObj, vehicle, menu)
		return
	end
	if string.find( vehicle:getScriptName(), "^Base.Trailer_fr_semi_" ) or string.find( vehicleB:getScriptName(), "^Base.Trailer_fr_semi_") then
		hitchType = "FRFifthWheelHitch"
		--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: It's a semi trailer, it needs a " .. tostring(hitchType))
	else
		--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: It's a regular trailer, it needs a " .. tostring(hitchType))
	end

	--All the other options (trailer/trailerfront) are done in the vanilla function
	--This checks if one vehicle is mine and has a hitch installed, and one is a trailer.
	--If it's mine with no hitch, it ends the function, stopping it from showing the trailer options in the vehicle menu.
	--Before that, though, it'll give the option to disconnect any connected trailers. Just in case somehow it goofs up.
	if vehicleB and ((string.find( vehicle:getScriptName(), "^Base.fr_" ) and not FR_TowMenu.hasHitch(vehicle, hitchType) and string.match( vehicleB:getScriptName(), "Trailer" )) or (string.match( vehicle:getScriptName(), "Trailer" ) and string.find( vehicleB:getScriptName(), "^Base.fr_" ) and not FR_TowMenu.hasHitch(vehicleB, hitchType))) then
		if vehicle:getVehicleTowing() then
			local bName = ISVehicleMenu.getVehicleDisplayName(vehicle:getVehicleTowing())
			menu:addSlice(getText("ContextMenu_Vehicle_DetachTrailer", bName), getTexture("media/ui/ZoomOut.png"), ISVehicleMenu.onDetachTrailer, playerObj, vehicle, vehicle:getTowAttachmentSelf())
			return
		end

		if vehicle:getVehicleTowedBy() then
			local aName = ISVehicleMenu.getVehicleDisplayName(vehicle)
			menu:addSlice(getText("ContextMenu_Vehicle_DetachTrailer", aName), getTexture("media/ui/ZoomOut.png"), ISVehicleMenu.onDetachTrailer, playerObj, vehicle:getVehicleTowedBy(), vehicle:getVehicleTowedBy():getTowAttachmentSelf())
			return
		end
		--DebugLog.log ("Intercepted ISVehicleMenu.doTowingMenu: Ending function")
	return
	end
	temp_doTowingMenu(playerObj, vehicle, menu)
end

--Thanks to KI5 for letting me use and modify his code!
--Dude helped me a lot with this! Please don't copy this code since it's not entirely mine.
--I mean please don't copy any of it without permission, but especially not this.
--Adds my popup headlights code to the vanilla menu.
local temp_onToggleHeadlights = ISVehicleMenu.onToggleHeadlights
function ISVehicleMenu.onToggleHeadlights(playerObj)
--	--DebugLog.log ("POPUP HEADLIGHTS: Intercepting vanilla function - onToggleHeadlights")
	local old_onToggleHeadlights = temp_onToggleHeadlights(playerObj)
--	--DebugLog.log ("POPUP HEADLIGHTS: Running vanilla function - onToggleHeadlights")
	local vehicle = playerObj:getVehicle()
--		--DebugLog.log ("POPUP HEADLIGHTS: vehicle = " .. tostring(vehicle))
			local test = tostring(vehicle)
			local testVehicle = tostring(playerObj:getVehicle())
--		Changed this so I don't have to edit the lua if I add a new vehicle with pop-ups.
		if (vehicle and (vehicle:getPartById("FRPopUpLightsDoor") ~= nil)) then
			--DebugLog.log ("POPUP HEADLIGHTS: Popup lights detected")

			local part = vehicle:getPartById("FRPopUpLightsDoor")
			local active = not vehicle:getHeadlightsOn()
			local opened = part:getDoor():isOpen()
			local vehicleID = vehicle:getId()
			local partID = part:getId()
			
			if active and opened then 
				return
			end

			if not active and opened then
				vehicle:playPartAnim(part, "Close")
				vehicle:playPartSound(part, playerObj, "Close")
				part:getDoor():setOpen(false)
				--DebugLog.log ("Popup lights are closing!")
			elseif active and not opened then
				vehicle:playPartAnim(part, "Open")
				vehicle:playPartSound(part, playerObj, "Open")
				part:getDoor():setOpen(true)
				--DebugLog.log ("Popup lights are opening!")
			end
					
			
			local args = { vehicleID = vehicleID, doorOpen = opened, partID = partID }
			sendClientCommand(playerObj, 'FR_UpdateParts', 'FR_setPopupLights', args)
			
--			--DebugLog.log ("POPUP HEADLIGHTS: vehicleID is " .. type(args.vehicleID))
--			--DebugLog.log ("POPUP HEADLIGHTS: doorOpen is " .. tostring(args.doorOpen))
--			--DebugLog.log ("POPUP HEADLIGHTS: Attempted to send command to server.")
		end
	return old_onToggleHeadlights
end

local temp_onLightbar = ISVehicleMenu.onLightbar
function ISVehicleMenu.onLightbar(playerObj)
	local vehicle = playerObj:getVehicle()
	if vehicle and string.match( vehicle:getScriptName(), "fr_" ) and vehicle:hasLightbar() and vehicle:getPartById("FRAttachmentRoof") then
		--DebugLog.log("INTERCEPTING ISVehicleMenu.onLightbar: Vehicle is one of mine, vanilla function should NOT run!")
		local roofAttachment = vehicle:getPartById("FRAttachmentRoof")
		local item = roofAttachment:getInventoryItem()
		--DebugLog.log("INTERCEPTING ISVehicleMenu.onLightbar: Roof Attachment is: " .. tostring(item and item:getType()))
		if item and string.match(item:getType(), "FRTopLightBar") then
			temp_onLightbar(playerObj)
			--DebugLog.log("INTERCEPTING ISVehicleMenu.onLightbar: " .. tostring(item:getType()) .. " should be the lightbar. Menu should open.")
			return
		else
		--Add a print out to tell players the lightbar is uninstalled. Maybe play a sound, too.
			print(getText("ContextMenu_FR_LightbarIsUninstalled"))
			vehicle:playSound("TelevisionOn")
			if vehicle:getLightbarLightsMode() > 0 then
				vehicle:setLightbarLightsMode(0)
				activeLights = false
			end
			if vehicle:getLightbarSirenMode() > 0 then
				vehicle:setLightbarSirenMode(0)
				activeSiren = false
			end
		end
	else
		--DebugLog.log("INTERCEPTING ISVehicleMenu.onLightbar: Vehicle is not one of mine or doesn't have a lightbar or roof attachment, vanilla function should run!")
		return temp_onLightbar(playerObj)
	end
end

--[[function ISVehicleMenu.onLightbar(playerObj)
	local old_onLightbar = temp_onLightbar(playerObj)
	ISTimedActionQueue.add(ISLightbarUITimedAction:new(playerObj))
	--DebugLog.log("INTERCEPTED ISVehicleMenu.onLightbar is running.")
	return
end--]]
