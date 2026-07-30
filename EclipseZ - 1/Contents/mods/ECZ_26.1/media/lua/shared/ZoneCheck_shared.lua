-----------------------------------------------------
--Visit Sunday Drivers for the latest and greatest!--
--mod by lect----------------------------------------
--Free to use with permission------------------------
-----------------------------------------------------

-- define zones (towns/maps)
zonetier = {1, 2, 3, 4, 5, 6}
zonetierno = #zonetier

-- zone input, overall zones are on top, nested zones are on bottom
-- order of this table is random, therefore i need to check for nested zones specifically otherwise it may not detect nested areas.

Zone = {
	list = {
		["LouisvillePD"] = {12000, 1200, 12700, 1650, 5, nil, nil, 100, 50, 100, 3.1},
		["LouisvilleMallArea"] = {12700, 1200, 15000, 1650, 5, nil, nil, 100, 35, 50, 3.1},
		["Louisville"] = {12000, 1650, 15000, 4200, 4, nil, nil, 20, 25, 25, 2.8},
		["Muldraugh"] = {9900, 9072, 11050, 11400, 1, nil, nil, 5, 5, 10, 2.1},
		["WestPointWest"] = {10220, 6600, 11850, 7800, 1, nil, nil, 5, 5, 10, 2.1},
		["WestPointEast"] = {11850, 6600, 12900, 7800, 2, nil, nil, 10, 10, 15, 2.3},
		["Riverside"] = {5400, 5100, 7800, 6300, 1, nil, nil, 5, 5, 10, 2.1},
		["Rosewood"] = {7500, 11400, 9300, 12600, 1, nil, nil, 5, 5, 10, 2.1},
		["MarchRidge"] = {9600, 12300, 10500, 13500, 1, nil, nil, 5, 5, 10, 2.1},
	}
}

NestedZone = {
	list = {
	}
}

for k,v in pairs(Zone.list) do
	if v[6] == "Subnested" then
		NestedZone.list[k]=v
	end
end

function getZoneNames(zonelist)
	local zoneNames = {}
	for zoneName, _ in pairs(zonelist) do
		table.insert(zoneNames, zoneName)
	end
	return zoneNames
end

ZoneNames = {}
NestedZoneNames = {}
function populateZoneNames()
	local MDZ = ModData.getOrCreate("MoreDifficultZones")
	for k,v in pairs(MDZ) do
		if v == "DELETE" then
			Zone.list[k] = nil
			NestedZone.list[k] = nil
		else
			Zone.list[k] = v
			if v[6] == "Subnested" then
				NestedZone.list[k] = v
			end
		end
	end
	ZoneNames = getZoneNames(Zone.list)
	NestedZoneNames = getZoneNames(NestedZone.list)
end
function initZoneNames()
	local MDZ = ModData.getOrCreate("MoreDifficultZones")
	for k,v in pairs(MDZ) do
		if not Zone.list[k] and v == "DELETE" then
			MDZ[k] = nil
		elseif v == "DELETE" then
			Zone.list[k] = nil
			NestedZone.list[k] = nil
		else
			Zone.list[k] = v
			if v[6] == "Subnested" then
				NestedZone.list[k] = v
			end
		end
	end
	ZoneNames = getZoneNames(Zone.list)
	NestedZoneNames = getZoneNames(NestedZone.list)
end
Events.OnGameStart.Add(initZoneNames)
Events.OnServerStarted.Add(initZoneNames)

--------------------------------------------------------------
--------------------------------------------------------------
local function ensureZoneGlobalModData()
    -- Clients request these tables during initialisation and periodically.
    -- Registering them on the dedicated server prevents thousands of
    -- "request for non-existing table" messages and needless network traffic.
    ModData.getOrCreate("zonesData")
    ModData.getOrCreate("globalzonesData")
    ModData.getOrCreate("MoreDifficultZones")
end

if isServer() then
    Events.OnInitGlobalModData.Add(ensureZoneGlobalModData)
    Events.OnServerStarted.Add(ensureZoneGlobalModData)
end

local ZoneOverride = {}
if not isServer() then
	if ModData.exists("FactionControlledZones") then ModData.remove("FactionControlledZones") end
	if ModData.exists("zonesData") then ModData.remove("zonesData") end
	if ModData.exists("globalzonesData") then ModData.getOrCreate("globalzonesData") end
	if ModData.exists("MoreDifficultZones") then ModData.remove("MoreDifficultZones") end
end

--local controlledZones = {}
local zonesData = {}--added 20250630

function tick_populateZoneNames()
	Events.OnPlayerUpdate.Remove(tick_populateZoneNames)
	populateZoneNames()
end

local function OnReceiveGlobalModData(key, modData)
	if key == "zoneOverride" then
		if type(modData) == "table" then
			ZoneOverride = modData
		end
	end
	
	--[[if key == "FactionControlledZones" and modData and type(modData) == "table" then
		controlledZones = modData
	end]]
	
	if key == "zonesData" and modData and type(modData) == "table" then
		ModData.add("zonesData", modData)
		zonesData = ModData.getOrCreate("zonesData")
	end
	
	if key == "globalzonesData" and modData and type(modData) == "table" then
		ModData.add("globalzonesData", modData)
	end
	
	if key == "MoreDifficultZones" and modData and type(modData) == "table" then
		ModData.add("MoreDifficultZones", modData)
		Events.OnPlayerUpdate.Add(tick_populateZoneNames)
	end
end
if not isServer() then Events.OnReceiveGlobalModData.Add(OnReceiveGlobalModData) end

local function getMoreDifficultZones()
	ModData.request("MoreDifficultZones")
end
if not isServer() then Events.OnInitGlobalModData.Add(getMoreDifficultZones) end

--[[local function FactionControlledZones()
	ModData.request("FactionControlledZones")
	--ModData.request("zoneOverride")
end
if not isServer() then Events.OnInitGlobalModData.Add(FactionControlledZones) end
if not isServer() then Events.EveryTenMinutes.Add(FactionControlledZones) end]]
local function getZonesData()
	ModData.request("zonesData")
end
if not isServer() then Events.OnInitGlobalModData.Add(getZonesData) end
if not isServer() then Events.EveryTenMinutes.Add(getZonesData) end

--------------------------------------------------------------
--------------------------------------------------------------

local factions = {"COG", "Ranger", "VoidWalker"}
local SDFactions = {}
for i=1,#factions do
	SDFactions[factions[i]]=true
end

local function getControl(zone, player, tier)
	--[[local faction
	local pMD = player:getModData()
	if pMD.faction then 
		faction = pMD.faction
	else
		faction = nil
	end
	if not controlledZones[zone] or not faction then return nil end
	if controlledZones[zone] == faction then
		--if isDebugEnabled() then player:Say("DEBUG: Controlled Zone: " .. zone .. " by Faction: " .. faction) end
		return "control"
	else
		return nil
	end]]
	
	--[[local faction = nil
	local pMD = player:getModData()
	if pMD.faction then 
		faction = pMD.faction
	end
	if not faction then return nil end
	if not SDFactions[faction] then return nil end
	--if not zonesGMD[faction.."_global"] then return nil end
	
	--if zonesGMD[faction.."_global"] and zonesGMD[zone][faction] then
	if not zonesData[zone] then return nil end
	if zonesData[zone][faction] then
		--if isDebugEnabled() then player:Say("DEBUG: Controlled Zone: " .. zone .. " by Faction: " .. faction) end
		--local control = math.min(0.25,zonesGMD[zone][faction]/zonesGMD[faction.."_global"])
		local control = zonesData[zone][faction] / (tier*1000)
		if control >= 1 then return "control" end
	end]]
	
	return nil
end

local base_health = SandboxVars.OnWeaponSwing.basehealth or 2.1
local base_sprinter = SandboxVars.OnWeaponSwing.basesprinter or 0
local base_pinpoint = SandboxVars.OnWeaponSwing.basepinpoint or 0
local base_cognition = SandboxVars.OnWeaponSwing.basecognition or 0
function checkZone(x,y)
	local player = getSpecificPlayer(0)
	
	local x = x or player:getX()
	local y = y or player:getY()
	
	for i = 1, #ZoneNames do
		local _zoneName = ZoneNames[i]
		local zList = Zone.list[_zoneName]
		local x1 = zList[1]
		local y1 = zList[2]
		local x2 = zList[3]
		local y2 = zList[4]

		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			local control = getControl(_zoneName, player, zList[5])
			return zList[5], _zoneName, x, y, control, zList[7], zList[8], zList[9], zList[10], zList[11], zList[12]
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, nil, nil, base_sprinter, base_pinpoint, base_cognition, base_health, nil
end

function checkZoneAtXY(x, y)
	local control = nil
	for i = 1, #ZoneNames do
		local _zoneName = ZoneNames[i]
		local zList = Zone.list[_zoneName]
		local x1 = zList[1]
		local y1 = zList[2]
		local x2 = zList[3]
		local y2 = zList[4]
		if x >= x1 and y >= y1 and x <= x2 and y <= y2 then
			return zList[5], _zoneName, x, y, control, zList[7], zList[8], zList[9], zList[10], zList[11], zList[12]
		end
	end
	return zonetier[1], "Unnamed Zone", x, y, nil, nil, base_sprinter, base_pinpoint, base_cognition, base_health, nil
end
