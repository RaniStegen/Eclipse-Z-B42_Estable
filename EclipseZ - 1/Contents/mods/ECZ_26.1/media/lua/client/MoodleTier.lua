----------------------------------------------
--This mod created for Filthy Casuals server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

require "MF_ISMoodle"
local tiers = 6
for i=1,tiers do
	MF.createMoodle("SD6Tier"..i)
end

local function setTierMoodle(moodleno, strength)
	for i=1,tiers do
		if i == moodleno then
			MF.getMoodle("SD6Tier"..i):setValue(strength)
		else
			MF.getMoodle("SD6Tier"..i):setValue(0.5)
		end
	end
end

local function EveryOneMinuteSD()
	local player = getSpecificPlayer(0)
	if player ~= nil then
		local tier_no = checkZone()
		
		if tier_no == 6 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 5 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 4 then
			setTierMoodle(tier_no, 0.1)
		elseif tier_no == 3 then
			setTierMoodle(tier_no, 0.4)
		elseif tier_no == 2 then
			setTierMoodle(tier_no, 0.6)
		elseif tier_no == 1 then
			setTierMoodle(tier_no, 1.0)
		end
	end
end

Events.EveryOneMinute.Add(EveryOneMinuteSD)