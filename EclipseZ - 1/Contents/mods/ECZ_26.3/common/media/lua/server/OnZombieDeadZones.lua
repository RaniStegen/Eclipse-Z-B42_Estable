----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------
if isClient() then return end

local function splitString(sandboxvar, delimiter)
	local ztable = {}
	for match in sandboxvar:gmatch(delimiter) do
		table.insert(ztable, match)
	end
	return ztable
end

local tiers = 6
local OZDtable = {}
local function syncSandbox()
	OZDtable = {}
	for i = 1, tiers
	do
		OZDtable["T" .. i] = splitString(SandboxVars.OZD["table"..i], "[^ %;,]+")
		OZDtable["T" .. i .. "_INDEX"] = ZombRand(#OZDtable["T" .. i]) + 1
		OZDtable["T" .. i .. "_ROLL"] = ZombRand(SandboxVars.OZD["roll" .. i])
	end
end
Events.EveryTenMinutes.Add(syncSandbox)

local function OnZombieDeadItemDrop(zombie)
	local player = zombie:getAttackedBy()
	local tierzone = 1
	if player and instanceof(player, "IsoPlayer")
	then
		local pTier = checkZoneAtXY(player:getX(), player:getY())
		local zTier = checkZoneAtXY(zombie:getX(), zombie:getY())
	else
		return
	end

	if pTier and zTier then
		tierzone = math.min(pTier, zTier)
	end

	if tierzone and player and instanceof(player, "IsoPlayer") and not player:isSeatedInVehicle()
	then
		addXp(player, Perks.Strength, tierzone * 5)
		addXp(player, Perks.Fitness, tierzone * 5)

		for j = tierzone, 1, -1
		do
			if OZDtable["T" .. j .. "_ROLL"] == 0
			then
				local itemIndex = OZDtable["T" .. j .. "_INDEX"]
				local item = OZDtable["T" .. j][itemIndex]

				local zInv = zombie:getInventory()
				local zItem = zInv:AddItem(item)
				--sendAddItemToContainer(zInv, zInv:AddItem(item));
				return
			end
		end
	end
end

Events.OnZombieDead.Add(OnZombieDeadItemDrop)--