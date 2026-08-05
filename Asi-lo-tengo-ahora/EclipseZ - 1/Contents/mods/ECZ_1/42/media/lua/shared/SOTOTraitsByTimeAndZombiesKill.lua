------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

-------------------------------------
-- TRAITS BY TIME AND ZOMBIES KILL --
-------------------------------------

local SOTOSbvars = SandboxVars.SOTO;

local SOTO_DEBUG = false;

local function dbg(msg)
	if SOTO_DEBUG then print("[SOTO-DEBUG] " .. tostring(msg)) end
end

-- Send visual feedback (sound + halo text) to the player's client.
-- In SP isServer()=true so sendServerCommand still fires OnServerCommand locally.
local function SOTOtraitFX(player, textKey, gained)
	sendServerCommand(player, "SOTO", "TraitFX", {textKey = textKey, gained = gained});
end

function SOTOtraitsByTimeAndZombiesKilled(player)

	if not player then return end
	local playerHoursSurvived = player:getHoursSurvived();
	local playerZombiesKilled = player:getZombieKills();

	if player:getModData().CowardlyRemoved == nil then
	player:getModData().CowardlyRemoved = 0;
	end
	if player:getModData().BraveRecieved == nil then
	player:getModData().BraveRecieved = 0;
	end
	if player:getModData().DesensitizedRecieved == nil then
	player:getModData().DesensitizedRecieved = 0;
	end

	if player:getModData().BraveBonus == nil then
	player:getModData().BraveBonus = 0;
	end
	if player:getModData().CowardlyPenalty == nil then
	player:getModData().CowardlyPenalty = 0;
	end

	-- Self-heal stuck flags: if the flag says "done" but the trait is still present,
	-- the removal happened client-side and got overwritten by the server. Reset so it retries.
	if player:getModData().CowardlyRemoved == 1 and player:hasTrait(CharacterTrait.COWARDLY) then
		player:getModData().CowardlyRemoved = 0;
		dbg("RESET CowardlyRemoved (was stuck - trait still present)")
	end
	if player:getModData().BraveRecieved == 1 and not player:hasTrait(CharacterTrait.BRAVE) and not player:hasTrait(CharacterTrait.DESENSITIZED) then
		player:getModData().BraveRecieved = 0;
		dbg("RESET BraveRecieved (was stuck - trait not present)")
	end
	if player:getModData().DesensitizedRecieved == 1 and not player:hasTrait(CharacterTrait.DESENSITIZED) then
		player:getModData().DesensitizedRecieved = 0;
		dbg("RESET DesensitizedRecieved (was stuck - trait not present)")
	end

	dbg("=== HOURLY TRAIT CHECK (server) ===")
	dbg("HoursSurvived=" .. playerHoursSurvived .. "  ZombiesKilled=" .. playerZombiesKilled)
	dbg("ModData: CowardlyRemoved=" .. tostring(player:getModData().CowardlyRemoved)
		.. "  BraveRecieved=" .. tostring(player:getModData().BraveRecieved)
		.. "  DesensitizedRecieved=" .. tostring(player:getModData().DesensitizedRecieved)
		.. "  BraveBonus=" .. tostring(player:getModData().BraveBonus)
		.. "  CowardlyPenalty=" .. tostring(player:getModData().CowardlyPenalty))
	dbg("Traits: Cowardly=" .. tostring(player:hasTrait(CharacterTrait.COWARDLY))
		.. "  Brave=" .. tostring(player:hasTrait(CharacterTrait.BRAVE))
		.. "  Desensitized=" .. tostring(player:hasTrait(CharacterTrait.DESENSITIZED))
		.. "  Asleep=" .. tostring(player:isAsleep()))

	-- Remove Cowardly Trait by time and kills
	if player:hasTrait(CharacterTrait.COWARDLY) and not player:hasTrait(CharacterTrait.BRAVE) and not player:hasTrait(CharacterTrait.DESENSITIZED) and not player:isAsleep() then
		-- Cowardly Hours Data
		local CowardlyHoursToRemoveMin = SOTOSbvars.CowardlyHoursToRemoveMin;
		local CowardlyHoursToRemoveMax = SOTOSbvars.CowardlyHoursToRemoveMax;
		local CowardlyHoursToRemoveDiff = CowardlyHoursToRemoveMax - CowardlyHoursToRemoveMin;
		local CowardlyHoursToRemove = CowardlyHoursToRemoveMin + ZombRand(CowardlyHoursToRemoveDiff); -- 7-14 days
		-- Cowardly ZombiesKilled Data
		local CowardlyZombiesKilledToRemoveMin = SOTOSbvars.CowardlyZombiesKilledToRemoveMin;
		local CowardlyZombiesKilledToRemoveMax = SOTOSbvars.CowardlyZombiesKilledToRemoveMax;
		local CowardlyZombiesKilledToRemoveDiff = CowardlyZombiesKilledToRemoveMax - CowardlyZombiesKilledToRemoveMin;
		local CowardlyZombiesKilledToRemove = CowardlyZombiesKilledToRemoveMin + ZombRand(CowardlyZombiesKilledToRemoveDiff); -- default 1000-2000

		dbg("COWARDLY block entered")
		dbg("  CowardlyHoursToRemove=" .. CowardlyHoursToRemove .. "  (need " .. playerHoursSurvived .. ">=" .. CowardlyHoursToRemove .. " -> " .. tostring(playerHoursSurvived >= CowardlyHoursToRemove) .. ")")
		dbg("  CowardlyZombiesKilledToRemove=" .. CowardlyZombiesKilledToRemove .. "  (need " .. playerZombiesKilled .. ">=" .. CowardlyZombiesKilledToRemove .. " -> " .. tostring(playerZombiesKilled >= CowardlyZombiesKilledToRemove) .. ")")
		dbg("  CowardlyRemovable=" .. tostring(SOTOSbvars.CowardlyRemovable) .. "  CowardlyRemoved=" .. tostring(player:getModData().CowardlyRemoved))

		if playerHoursSurvived >= CowardlyHoursToRemove then
			if playerZombiesKilled >= CowardlyZombiesKilledToRemove then
				if SOTOSbvars.CowardlyRemovable == true then
					if player:getModData().CowardlyRemoved == 0 then
						player:getModData().CowardlyRemoved = 1;
						SOTOremoveTrait(player, CharacterTrait.COWARDLY);
						SOTOtraitFX(player, "UI_trait_cowardly", false);
						dbg("  >>> COWARDLY REMOVED <<<")
					else
						dbg("  SKIP: CowardlyRemoved already = 1")
					end
				else
					dbg("  SKIP: CowardlyRemovable is false in sandbox")
				end
			end
		end
	end

	-- Adding Brave Trait by time and kills
	if not player:hasTrait(CharacterTrait.COWARDLY) and not player:hasTrait(CharacterTrait.BRAVE) and not player:hasTrait(CharacterTrait.DESENSITIZED) and not player:isAsleep() then
		-- Brave Hours Data
		local BraveHoursToEarnMin = SOTOSbvars.BraveHoursToEarnMin;
		local BraveHoursToEarnMax = SOTOSbvars.BraveHoursToEarnMax;
		local BraveHoursToEarnDiff = BraveHoursToEarnMax - BraveHoursToEarnMin;
		local BraveHoursToEarn = BraveHoursToEarnMin + ZombRand(BraveHoursToEarnDiff);
		-- Brave ZombiesKilled Data
		local BraveZombiesKilledToEarnMin = SOTOSbvars.BraveZombiesKilledToEarnMin;
		local BraveZombiesKilledToEarnMax = SOTOSbvars.BraveZombiesKilledToEarnMax;
		local BraveZombiesKilledToEarnDiff = BraveZombiesKilledToEarnMax - BraveZombiesKilledToEarnMin;
		local BraveZombiesKilledToEarn = BraveZombiesKilledToEarnMin + ZombRand(BraveZombiesKilledToEarnDiff);

		if player:getModData().CowardlyPenalty == 1 then
		BraveHoursToEarn = (BraveHoursToEarnMin * 1.2) + ZombRand((BraveHoursToEarnDiff * 1.2)); -- 21-35 days
		BraveZombiesKilledToEarn = (BraveZombiesKilledToEarnMin * 1.2) + ZombRand((BraveZombiesKilledToEarnDiff * 1.2)); -- 3000-4500
		else
		BraveHoursToEarn = BraveHoursToEarnMin + ZombRand(BraveHoursToEarnDiff); -- 14-28 days
		BraveZombiesKilledToEarn = BraveZombiesKilledToEarnMin + ZombRand(BraveZombiesKilledToEarnDiff); -- 2500-3500
		end

		dbg("BRAVE block entered  (CowardlyPenalty=" .. tostring(player:getModData().CowardlyPenalty) .. ")")
		dbg("  BraveHoursToEarn=" .. BraveHoursToEarn .. "  (need " .. playerHoursSurvived .. ">=" .. BraveHoursToEarn .. " -> " .. tostring(playerHoursSurvived >= BraveHoursToEarn) .. ")")
		dbg("  BraveZombiesKilledToEarn=" .. BraveZombiesKilledToEarn .. "  (need " .. playerZombiesKilled .. ">=" .. BraveZombiesKilledToEarn .. " -> " .. tostring(playerZombiesKilled >= BraveZombiesKilledToEarn) .. ")")
		dbg("  BraveEarnable=" .. tostring(SOTOSbvars.BraveEarnable) .. "  BraveRecieved=" .. tostring(player:getModData().BraveRecieved))

		if playerHoursSurvived >= BraveHoursToEarn then
			if playerZombiesKilled >= BraveZombiesKilledToEarn then
				if SOTOSbvars.BraveEarnable == true then
					if player:getModData().BraveRecieved == 0 then
						SOTOaddTrait(player, CharacterTrait.BRAVE);
						player:getModData().BraveRecieved = 1;
						SOTOtraitFX(player, "UI_trait_brave", true);
						dbg("  >>> BRAVE GAINED <<<")
					else
						dbg("  SKIP: BraveRecieved already = 1")
					end
				else
					dbg("  SKIP: BraveEarnable is false in sandbox")
				end
			end
		end
	end

	-- Adding Desensitized Trait by time and kills
	if player:hasTrait(CharacterTrait.BRAVE) and not player:hasTrait(CharacterTrait.DESENSITIZED) and not player:isAsleep() then
		-- Desensitized Hours Data
		local DesensitizedHoursToEarnMin = SOTOSbvars.DesensitizedHoursToEarnMin;
		local DesensitizedHoursToEarnMax = SOTOSbvars.DesensitizedHoursToEarnMax;
		local DesensitizedHoursToEarnDiff = DesensitizedHoursToEarnMax - DesensitizedHoursToEarnMin;
		local DesensitizedHoursToEarn = DesensitizedHoursToEarnMin + ZombRand(DesensitizedHoursToEarnDiff);
		-- Desensitized ZombiesKilled Data
		local DesensitizedZombiesKilledToEarnMin = SOTOSbvars.DesensitizedZombiesKilledToEarnMin;
		local DesensitizedZombiesKilledToEarnMax = SOTOSbvars.DesensitizedZombiesKilledToEarnMax;
		local DesensitizedZombiesKilledToEarnDiff = DesensitizedZombiesKilledToEarnMax - DesensitizedZombiesKilledToEarnMin;
		local DesensitizedZombiesKilledToEarn = DesensitizedZombiesKilledToEarnMin + ZombRand(DesensitizedZombiesKilledToEarnDiff);

		if player:getModData().CowardlyPenalty == 1 then
		DesensitizedHoursToEarn = (DesensitizedHoursToEarnMin * 1.2) + ZombRand((DesensitizedHoursToEarnDiff * 1.2)); -- 49-77 days
		DesensitizedZombiesKilledToEarn = (DesensitizedZombiesKilledToEarnMin * 1.2) + ZombRand((DesensitizedZombiesKilledToEarnDiff * 1.2)); -- 6000-9000
		elseif player:getModData().BraveBonus == 1 then
		DesensitizedHoursToEarn = (DesensitizedHoursToEarnMin * 0.8) + ZombRand((DesensitizedHoursToEarnDiff * 0.8)); -- 35-63 days
		DesensitizedZombiesKilledToEarn = (DesensitizedZombiesKilledToEarnMin * 0.8) + ZombRand((DesensitizedZombiesKilledToEarnDiff * 0.8)); -- 5000-8000
		else
		DesensitizedHoursToEarn = DesensitizedHoursToEarnMin + ZombRand(DesensitizedHoursToEarnDiff); -- 42-70 days
		DesensitizedZombiesKilledToEarn = DesensitizedZombiesKilledToEarnMin + ZombRand(DesensitizedZombiesKilledToEarnDiff); -- 5500-8500
		end

		dbg("DESENSITIZED block entered  (CowardlyPenalty=" .. tostring(player:getModData().CowardlyPenalty) .. "  BraveBonus=" .. tostring(player:getModData().BraveBonus) .. ")")
		dbg("  DesensitizedHoursToEarn=" .. DesensitizedHoursToEarn .. "  (need " .. playerHoursSurvived .. ">=" .. DesensitizedHoursToEarn .. " -> " .. tostring(playerHoursSurvived >= DesensitizedHoursToEarn) .. ")")
		dbg("  DesensitizedZombiesKilledToEarn=" .. DesensitizedZombiesKilledToEarn .. "  (need " .. playerZombiesKilled .. ">=" .. DesensitizedZombiesKilledToEarn .. " -> " .. tostring(playerZombiesKilled >= DesensitizedZombiesKilledToEarn) .. ")")
		dbg("  DesensitizedEarnable=" .. tostring(SOTOSbvars.DesensitizedEarnable) .. "  DesensitizedRecieved=" .. tostring(player:getModData().DesensitizedRecieved))

		if playerHoursSurvived >= DesensitizedHoursToEarn then
			if playerZombiesKilled >= DesensitizedZombiesKilledToEarn then
				if SOTOSbvars.DesensitizedEarnable == true then
					if player:hasTrait(SOTO.CharacterTrait.FEAR_OF_THE_DARK) then
						SOTOremoveTrait(player, SOTO.CharacterTrait.FEAR_OF_THE_DARK);
						SOTOtraitFX(player, "UI_trait_fearofthedark", false);
					end
					if player:hasTrait(CharacterTrait.HEMOPHOBIC) then
						SOTOremoveTrait(player, CharacterTrait.HEMOPHOBIC);
						SOTOtraitFX(player, "UI_trait_Hemophobic", false);
					end
					if player:getModData().DesensitizedRecieved == 0 then
						player:getModData().DesensitizedRecieved = 1;
						SOTOremoveTrait(player, CharacterTrait.BRAVE);
						SOTOaddTrait(player, CharacterTrait.DESENSITIZED);
						SOTOtraitFX(player, "UI_trait_Desensitized", true);
						dbg("  >>> DESENSITIZED GAINED <<<")
					else
						dbg("  SKIP: DesensitizedRecieved already = 1")
					end
				else
					dbg("  SKIP: DesensitizedEarnable is false in sandbox")
				end
			end
		end
	end

	-- Removing Pacifist
	if player:hasTrait(CharacterTrait.PACIFIST) and not player:isAsleep() then
		-- Pacifist Hours Data
		local PacifistHoursToRemoveMin = SOTOSbvars.PacifistHoursToRemoveMin;
		local PacifistHoursToRemoveMax = SOTOSbvars.PacifistHoursToRemoveMax;
		local PacifistHoursToRemoveDiff = PacifistHoursToRemoveMax - PacifistHoursToRemoveMin;
		local PacifistHoursToRemove = PacifistHoursToRemoveMin + ZombRand(PacifistHoursToRemoveDiff); -- 28-42 days
		-- Pacifist ZombiesKilled Data
		local PacifistZombiesKilledToRemoveMin = SOTOSbvars.PacifistZombiesKilledToRemoveMin;
		local PacifistZombiesKilledToRemoveMax = SOTOSbvars.PacifistZombiesKilledToRemoveMax;
		local PacifistZombiesKilledToRemoveDiff = PacifistZombiesKilledToRemoveMax - PacifistZombiesKilledToRemoveMin;
		local PacifistZombiesKilledToRemove = PacifistZombiesKilledToRemoveMin + ZombRand(PacifistZombiesKilledToRemoveDiff); -- 1500-2500

		if playerHoursSurvived >= PacifistHoursToRemove then
			if playerZombiesKilled >= PacifistZombiesKilledToRemove then
				if SOTOSbvars.PacifistRemovable == true then
					if player:getPerkLevel(Perks.Axe) >= SOTOSbvars.PacifistSkillLvlToRemove
					or player:getPerkLevel(Perks.SmallBlunt) >= SOTOSbvars.PacifistSkillLvlToRemove
					or player:getPerkLevel(Perks.Blunt) >= SOTOSbvars.PacifistSkillLvlToRemove
					or player:getPerkLevel(Perks.SmallBlade) >= SOTOSbvars.PacifistSkillLvlToRemove
					or player:getPerkLevel(Perks.LongBlade) >= SOTOSbvars.PacifistSkillLvlToRemove
					or player:getPerkLevel(Perks.Spear) >= SOTOSbvars.PacifistSkillLvlToRemove
					or player:getPerkLevel(Perks.Aiming) >= SOTOSbvars.PacifistSkillLvlToRemove
					then
						SOTOremoveTrait(player, CharacterTrait.PACIFIST);
						SOTOtraitFX(player, "UI_trait_Pacifist", false);
					end
				end
			end
		end
	end

end

-- Run server-side every hour for all online players.
-- SP: isServer()=true and getOnlinePlayers() contains the local player.
Events.EveryHours.Add(function()
	if not isServer() then return end
	local players = getOnlinePlayers();
	if players:size() == 0 then
		local p = getPlayer();
		if p then SOTOtraitsByTimeAndZombiesKilled(p) end
	else
		for i = 0, players:size() - 1 do
			SOTOtraitsByTimeAndZombiesKilled(players:get(i));
		end
	end
end)
