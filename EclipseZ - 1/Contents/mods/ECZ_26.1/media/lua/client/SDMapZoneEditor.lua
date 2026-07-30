require "ZoneCheck_shared"
require "ISUI/ISPanel"
require "ISUI/ISScrollingListBox"

-- Safely append to the existing SDmap table from SDmappanel.lua
SDmap = SDmap or {}
SDmap.ZoneManagerPanel = ISPanel:derive("SDmap.ZoneManagerPanel")
local ModDataMapDrawTierZones = ModData.getOrCreate("MapDrawTierZones")

local function splitString(var)
    local ztable = {}
    local pattern = "[^ %;,]+"
    for match in var:gmatch(pattern) do
        table.insert(ztable, match)
    end
    return ztable
end

local function getTableSize(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

--=======================================================================
-- JSON Export / Import Logic (Global)
--=======================================================================

function SDmap.ExportZones(filename)
    filename = filename or "SD_Zones_Export.json"
    local activeZones = Zone.list
    
    local json = "{\n"
    local firstZone = true
    for k, v in pairs(activeZones) do
        if type(v) == "table" then
            if not firstZone then json = json .. ",\n" end
            firstZone = false
            json = json .. string.format('  "%s": ', tostring(k))
            
            json = json .. "["
            for i = 1, 12 do
                if i > 1 then json = json .. ", " end
                local val = v[i]
                if type(val) == "string" then json = json .. string.format('"%s"', val)
                elseif type(val) == "boolean" then json = json .. tostring(val)
                elseif type(val) == "number" then json = json .. tostring(val)
                else json = json .. "null" end
            end
            json = json .. "]"
        end
    end
    json = json .. "\n}"

    local writer = getFileWriter(filename, true, false)
    writer:write(json)
    writer:close()
    print("[SDmap] Exported " .. getTableSize(activeZones) .. " zones to Zomboid/Lua/" .. filename)
end

function SDmap.ImportZones(filename)
    filename = filename or "SD_Zones_Export.json"
    local reader = getFileReader(filename, false)
    if not reader then 
        print("[SDmap] Could not find " .. filename .. " to import.")
        return 
    end
    
    local json = ""
    local line = reader:readLine()
    while line do json = json .. line; line = reader:readLine() end
    reader:close()

    local MDZ = ModData.getOrCreate("MoreDifficultZones")
    local count = 0

    for key, arrStr in string.gmatch(json, '"([^"]+)":%s*%[([^%]]+)%]') do
        local newArr = {}
        local idx = 1
        for val in string.gmatch(arrStr, '([^,]+)') do
            val = val:match("^%s*(.-)%s*$")
            if val == "true" then newArr[idx] = true
            elseif val == "false" then newArr[idx] = false
            elseif val ~= "null" and tonumber(val) then newArr[idx] = tonumber(val)
            elseif val ~= "null" then newArr[idx] = val:gsub('^"(.*)"$', '%1') end
            idx = idx + 1
        end
        MDZ[key] = newArr
        count = count + 1
    end

    populateZoneNames()
    ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
    ModData.transmit("MoreDifficultZones")
    print("[SDmap] Successfully imported " .. count .. " zones.")
end

--=======================================================================
-- Master Zone Manager Panel
--=======================================================================

function SDmap.ZoneManagerPanel:initialise()
    ISPanel.initialise(self)
    self.originalZoneName = nil
    self.lastSearchText = ""
end

function SDmap.ZoneManagerPanel:close()
    self:setVisible(false)
    self:removeFromUIManager()
end

function SDmap.ZoneManagerPanel:createChildren()
    ISPanel.createChildren(self)
    
    local listWidth = 350
    local formX = listWidth + 30
    
    -- Search Box
    self.searchBox = ISTextEntryBox:new("", 15, 30, listWidth, 24)
    self.searchBox:initialise()
    self.searchBox:instantiate()
    self.searchBox.tooltip = "Search zones..."
    self:addChild(self.searchBox)

    -- Scrolling List (shifted down to accommodate search box)
    self.zoneList = ISScrollingListBox:new(15, 60, listWidth, self.height - 120)
    self.zoneList:initialise()
    self.zoneList:instantiate()
    self.zoneList.itemheight = 24
    self.zoneList.selected = 0
    self.zoneList.joypadParent = self
    self.zoneList.font = UIFont.Small
    self.zoneList.doDrawItem = self.drawZoneListItem
    self.zoneList.drawBorder = true
    self.zoneList.onmousedown = self.onZoneSelect
    self.zoneList.target = self
    self:addChild(self.zoneList)

    -- Right Side: Form Inputs
    local lblY = 30
    local rowH = 34
    local inputX = formX + 110
    local inputW = 280

    self:addLabel(formX, lblY, "X1,Y1:")
    self.x1y1 = ISTextEntryBox:new("0,0", inputX, lblY, inputW, 24); self:addChild(self.x1y1)
    lblY = lblY + rowH
    
    self:addLabel(formX, lblY, "X2,Y2:")
    self.x2y2 = ISTextEntryBox:new("0,0", inputX, lblY, inputW, 24); self:addChild(self.x2y2)
    lblY = lblY + rowH

    self:addLabel(formX, lblY, "Tier#:")
    self.ztier = ISTextEntryBox:new("3", inputX, lblY, inputW, 24); self:addChild(self.ztier)
    lblY = lblY + rowH

    self:addLabel(formX, lblY, "Name:")
    self.zname = ISTextEntryBox:new("Zone #" .. ZombRand(1,10000), inputX, lblY, inputW, 24); self:addChild(self.zname)
    lblY = lblY + rowH

    self:addLabel(formX, lblY, "Sprinter%:")
    self.zsprinter = ISTextEntryBox:new("0", inputX, lblY, inputW, 24); self:addChild(self.zsprinter)
    lblY = lblY + rowH

    self:addLabel(formX, lblY, "Pinpoint%:")
    self.zpinpoint = ISTextEntryBox:new("0", inputX, lblY, inputW, 24); self:addChild(self.zpinpoint)
    lblY = lblY + rowH

    self:addLabel(formX, lblY, "Cognition%:")
    self.zcognition = ISTextEntryBox:new("0", inputX, lblY, inputW, 24); self:addChild(self.zcognition)
    lblY = lblY + rowH

    self:addLabel(formX, lblY, "Health:")
    self.zhealth = ISTextEntryBox:new("2.1", inputX, lblY, inputW, 24); self:addChild(self.zhealth)
    lblY = lblY + rowH

    self.znested = ISTickBox:new(formX, lblY, 20, 20, "", self, nil)
    self.znested:initialise(); self.znested:instantiate(); self.znested.selected[1] = false; self.znested:addOption("Nested"); self:addChild(self.znested)
    
    self.zsubnested = ISTickBox:new(formX + 110, lblY, 20, 20, "", self, nil)
    self.zsubnested:initialise(); self.zsubnested:instantiate(); self.zsubnested.selected[1] = false; self.zsubnested:addOption("Subnested"); self:addChild(self.zsubnested)
    lblY = lblY + rowH

    self.ztoxic = ISTickBox:new(formX, lblY, 20, 20, "", self, nil)
    self.ztoxic:initialise(); self.ztoxic:instantiate(); self.ztoxic.selected[1] = false; self.ztoxic:addOption("Toxic"); self:addChild(self.ztoxic)
    
    self.zevent = ISTickBox:new(formX + 110, lblY, 20, 20, "", self, nil)
    self.zevent:initialise(); self.zevent:instantiate(); self.zevent.selected[1] = false; self.zevent:addOption("Event"); self:addChild(self.zevent)
    
    local btnY = lblY + 40
    self.btnSave = ISButton:new(formX, btnY, 100, 30, "Save Zone", self, self.saveZone)
    self.btnSave:initialise(); self:addChild(self.btnSave)

    self.btnNew = ISButton:new(formX + 120, btnY, 100, 30, "Clear/New", self, self.clearForm)
    self.btnNew:initialise(); self:addChild(self.btnNew)
    
    self.btnDelete = ISButton:new(formX + 240, btnY, 100, 30, "Delete Zone", self, self.deleteZone)
    self.btnDelete:initialise(); self:addChild(self.btnDelete)

    local botY = self.height - 45
    self.btnExport = ISButton:new(15, botY, 120, 30, "Export JSON", self, function() SDmap.ExportZones() end)
    self.btnExport:initialise(); self:addChild(self.btnExport)

    self.btnImport = ISButton:new(145, botY, 120, 30, "Import JSON", self, function() SDmap.ImportZones(); self:populateList() end)
    self.btnImport:initialise(); self:addChild(self.btnImport)

    self.btnClose = ISButton:new(self.width - 120, botY, 100, 30, "Close", self, self.close)
    self.btnClose:initialise(); self:addChild(self.btnClose)

    self:populateList()
end

function SDmap.ZoneManagerPanel:addLabel(x, y, text)
    local lbl = ISLabel:new(x, y + 4, 20, text, 1, 1, 1, 1, UIFont.Medium, true)
    lbl:initialise()
    self:addChild(lbl)
end

function SDmap.ZoneManagerPanel:populateList()
    self.zoneList:clear()
    local MDZ = ModData.getOrCreate("MoreDifficultZones")
    
    -- Grab the search text
    local searchText = ""
    if self.searchBox then
        searchText = string.lower(self.searchBox:getText() or "")
    end
    
    -- Filter and collect keys
    local sortedKeys = {}
    for k, v in pairs(Zone.list) do
        if MDZ[k] ~= "DELETE" then
            if searchText == "" or string.find(string.lower(k), searchText, 1, true) then
                table.insert(sortedKeys, k)
            end
        end
    end
    
    -- Case-insensitive sort
    table.sort(sortedKeys, function(a, b) return string.lower(a) < string.lower(b) end)

    -- Populate the list with sorted keys
    for i=1, #sortedKeys do
        local k = sortedKeys[i]
        self.zoneList:addItem(k, { zoneName = k, zoneData = Zone.list[k] })
    end
end

function SDmap.ZoneManagerPanel:drawZoneListItem(y, item, alt)
    local isSelected = self.selected == item.index
    if isSelected then
        self:drawRect(0, y, self:getWidth(), item.height-1, 0.3, 0.7, 0.35, 0.15)
    end
    self:drawText(item.text, 10, y + 2, 1, 1, 1, 1, self.font)
    return y + item.height
end

function SDmap.ZoneManagerPanel:onZoneSelect(item)
    self:loadZoneData(item.zoneName, item.zoneData)
end

function SDmap.ZoneManagerPanel:loadZoneData(zonename, z)
    self.originalZoneName = zonename
    self.x1y1:setText(tostring(z[1] or 0) .. "," .. tostring(z[2] or 0))
    self.x2y2:setText(tostring(z[3] or 0) .. "," .. tostring(z[4] or 0))
    self.ztier:setText(tostring(z[5] or 1))
    self.zname:setText(zonename)
    self.znested.selected[1] = (z[6] == "Nested")
    self.zsubnested.selected[1] = (z[6] == "Subnested")
    self.ztoxic.selected[1] = (z[7] == "Toxic")
    self.zevent.selected[1] = (z[12] == true)
    self.zsprinter:setText(tostring(z[8] or 0))
    self.zpinpoint:setText(tostring(z[9] or 0))
    self.zcognition:setText(tostring(z[10] or 0))
    self.zhealth:setText(tostring(z[11] or 2.1))
end

function SDmap.ZoneManagerPanel:clearForm()
    self.originalZoneName = nil
    self.x1y1:setText("0,0")
    self.x2y2:setText("0,0")
    self.ztier:setText("1")
    self.zname:setText("Zone #" .. ZombRand(1,10000))
    self.znested.selected[1] = false
    self.zsubnested.selected[1] = false
    self.ztoxic.selected[1] = false
    self.zevent.selected[1] = false
    self.zsprinter:setText("0")
    self.zpinpoint:setText("0")
    self.zcognition:setText("0")
    self.zhealth:setText("2.1")
    self.zoneList.selected = 0
end

function SDmap.ZoneManagerPanel:deleteZone()
    local _zonename = self.originalZoneName
    if not _zonename or _zonename == "" then _zonename = self.zname:getText() end
    if not _zonename or _zonename == "" then return end
    
    local zonesGMD = ModData.getOrCreate("MoreDifficultZones")
    zonesGMD[_zonename] = "DELETE"
    Zone.list[_zonename] = nil
    NestedZone.list[_zonename] = nil
    ZoneNames = getZoneNames(Zone.list)
    NestedZoneNames = getZoneNames(NestedZone.list)
    
    ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
    ModData.transmit("MoreDifficultZones")
    
    local symbolsAPI = self.mapAPI:getSymbolsAPI()
    if symbolsAPI then
        for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
            local symbol = symbolsAPI:getSymbolByIndex(i)
            if symbol and symbol:getSymbolID() == "Asterisk" then symbolsAPI:removeSymbolByIndex(i) end
        end
    end

    self:clearForm()
    self:populateList()
end

function SDmap.ZoneManagerPanel:saveZone()
    local x1y1 = splitString(self.x1y1:getText())
    local x2y2 = splitString(self.x2y2:getText())
    local tier = tonumber(self.ztier:getText())
    local _zname = self.zname:getText()
    local oldName = self.originalZoneName
    
    local _nested, _toxic, _event = nil, nil, nil
    if self.znested.selected[1] then _nested = "Nested" end
    if self.zsubnested.selected[1] then _nested = "Subnested" end
    if self.ztoxic.selected[1] then _toxic = "Toxic" end
    if self.zevent.selected[1] then _event = true end
    
    local sprinter = math.max(math.min(tonumber(self.zsprinter:getText()) or 0, 100), 0)
    local pinpoint = math.max(math.min(tonumber(self.zpinpoint:getText()) or 0, 100), 0)
    local cognition = math.max(math.min(tonumber(self.zcognition:getText()) or 0, 100), 0)
    local zombieHealth = math.max(math.min(tonumber(self.zhealth:getText()) or 2.1, 30), 1.5)
    
    local x1, y1 = tonumber(x1y1[1]) or 0, tonumber(x1y1[2]) or 0
    local x2, y2 = tonumber(x2y2[1]) or 0, tonumber(x2y2[2]) or 0

    local MDZ = ModData.getOrCreate("MoreDifficultZones")
    
    if oldName and oldName ~= "" then
        MDZ[oldName] = "DELETE"
        Zone.list[oldName] = nil
        NestedZone.list[oldName] = nil
    end
    
    MDZ[_zname] = nil
    Zone.list[_zname] = nil
    NestedZone.list[_zname] = nil
    
    MDZ[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth, _event }
    Zone.list[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth, _event }
    if _nested == "Subnested" then
        NestedZone.list[_zname] = { x1, y1, x2, y2, tier, _nested, _toxic, sprinter, pinpoint, cognition, zombieHealth, _event }
    end
    
    populateZoneNames()
    ModDataMapDrawTierZones[getCurrentUserSteamID()] = false
    ModData.transmit("MoreDifficultZones")
    
    local symbolsAPI = self.mapAPI:getSymbolsAPI()
    if symbolsAPI then
        for i=symbolsAPI:getSymbolCount()-1, 0, -1 do
            local symbol = symbolsAPI:getSymbolByIndex(i)
            if symbol and symbol:getSymbolID() == "Asterisk" then symbolsAPI:removeSymbolByIndex(i) end
        end
    end

    self.originalZoneName = _zname
    self:populateList()
end

function SDmap.ZoneManagerPanel:prerender()
    self:drawRectStatic(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorderStatic(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    self:drawTextCentre("Master Zone Manager", self.width / 2, 8, 1, 1, 1, 1, UIFont.Medium)
    
    -- Live search trigger
    if self.searchBox then
        local currentText = self.searchBox:getText()
        if currentText ~= self.lastSearchText then
            self.lastSearchText = currentText
            self:populateList()
        end
    end
end

function SDmap.ZoneManagerPanel:new(x, y, width, height, mapAPI)
    width = math.max(width or 0, 900)
    height = math.max(height or 0, 600)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.mapAPI = mapAPI
    o.backgroundColor = {r=0, g=0, b=0, a=0.95}
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.moveWithMouse = true
    return o
end