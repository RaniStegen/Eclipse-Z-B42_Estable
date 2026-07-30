----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------


local function splitString(sandboxvar, delimiter)
	local ztable = {}
	local pattern = "[^ %;,]+"

	for match in sandboxvar:gmatch(pattern) do
		table.insert(ztable, match)
	end
	return ztable
end

local function OnZombieDeadItemDrop(zombie)
	player = getSpecificPlayer(0)

	local table1 = splitString(SandboxVars.OZD.table1)
	local n1 = #table1
	local t1 = ZombRand(n1)+1

	local table2 = splitString(SandboxVars.OZD.table2)
	local n2 = #table2
	local t2 = ZombRand(n2)+1

	local table3 = splitString(SandboxVars.OZD.table3)
	local n3 = #table3
	local t3 = ZombRand(n3)+1

	local table4 = splitString(SandboxVars.OZD.table4)
	local n4 = #table4 
	local t4 = ZombRand(n4)+1

	local table5 = splitString(SandboxVars.OZD.table5)
	local n5 = #table5
	local t5 = ZombRand(n5)+1

	local table6 = splitString(SandboxVars.OZD.table6)
	local n6 = #table6
	local t6 = ZombRand(n6)+1
	
	local t1roll = ZombRand(SandboxVars.OZD.roll1)
	local t2roll = ZombRand(SandboxVars.OZD.roll2)
	local t3roll = ZombRand(SandboxVars.OZD.roll3)
	local t4roll = ZombRand(SandboxVars.OZD.roll4)
	local t5roll = ZombRand(SandboxVars.OZD.roll5)
	local t6roll = ZombRand(SandboxVars.OZD.roll6)
	
	local function itemdrop(item)
		zombie:getInventory():AddItem(item)
	end	
	
	local tierzone = checkZone()
	
	if tierzone == 6 then
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t6roll == 0 then
			itemdrop(table6[t6])
		elseif t5roll == 0 then
			itemdrop(table5[t5])
		elseif t4roll == 0 then
			itemdrop(table4[t4])
		elseif t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 5 then
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t5roll == 0 then
			itemdrop(table5[t5])
		elseif t4roll == 0 then
			itemdrop(table4[t4])
		elseif t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 4 then
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t4roll == 0 then
			itemdrop(table4[t4])
		elseif t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 3 then
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t3roll == 0 then
			itemdrop(table3[t3])
		elseif t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 2 then
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t2roll == 0 then
			itemdrop(table2[t2])
		elseif t1roll == 0 then
			itemdrop(table1[t1])
		end
	elseif tierzone == 1 then
		player:getXp():AddXP(Perks.Strength, tierzone*5);
		player:getXp():AddXP(Perks.Fitness, tierzone*5);
		if t1roll == 0 then
			itemdrop(table1[t1])
		end
	end
end

Events.OnZombieDead.Add(OnZombieDeadItemDrop)