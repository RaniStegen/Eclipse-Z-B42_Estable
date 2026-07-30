------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

--------------------------------------------
-- SIMPLE OVERHAUL TRAITS AND OCCUPATIONS --
--------------------------------------------

SOTOBaseGameCharacterDetails = {}


SOTOBaseGameCharacterDetails.DoNewCharacterInitializations = function(playernum, character)
	local player = getSpecificPlayer(playernum);

	-- BRAVE BONUS
	if player:hasTrait(CharacterTrait.BRAVE) or player:hasTrait(SOTO.CharacterTrait.BRAVE2) then
		if player:getModData().SOBraveBonus == nil then
		player:getModData().SOBraveBonus = 1;
		end	
	end

	-- COWARDLY PENALTY
	if player:hasTrait(CharacterTrait.COWARDLY) then
		if player:getModData().SOCowardlyPenalty == nil then
		player:getModData().SOCowardlyPenalty = 1;
		end	
	end	

	-- ALCOHOLIC MOD DATA
	if player:hasTrait(SOTO.CharacterTrait.ALCOHOLIC) then	
		if player:getModData().AlcoholicTimeSinceLastDrink == nil then
			player:getModData().AlcoholicTimeSinceLastDrink = 0;
		end	
	end

	if player:hasTrait(SOTO.CharacterTrait.CHRONIC_MIGRAINE) then
		if player:getModData().migraineCooldown == nil then
			player:getModData().migraineCooldown = 0;
		end
		if player:getModData().migraineDuration == nil then
			player:getModData().migraineDuration = 0;
		end
		local initialDelay = ZombRand(72, 288); -- 12-48 hours
		player:getModData().migraineCooldown = initialDelay;
		-- local initialDelayHours = math.floor(initialDelay)
		-- print("The first migraine:" .. initialDelayHours)
	end

	if player:hasTrait(SOTO.CharacterTrait.SLACK) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.SLACK); -- removing trait since its only affect strength and fitness
	end		
	if player:hasTrait(SOTO.CharacterTrait.TAUT) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.TAUT); -- removing trait since its only affect strength and fitness
	end	
	
	
	-- TRAITS SWAP	
	
	if player:hasTrait(SOTO.CharacterTrait.FISHING2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.FISHING2);
		SOTOaddTrait(player, CharacterTrait.FISHING);
	end	
	
	if player:hasTrait(SOTO.CharacterTrait.TAILOR2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.TAILOR2);
		SOTOaddTrait(player, CharacterTrait.TAILOR);
	end	
	
	if player:hasTrait(SOTO.CharacterTrait.WOODWORKER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.WOODWORKER2);
		SOTOaddTrait(player, SOTO.CharacterTrait.WOODWORKER);
	end	
	
	if player:hasTrait(SOTO.CharacterTrait.AUTOMECHANIC2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.AUTOMECHANIC2);
		SOTOaddTrait(player, SOTO.CharacterTrait.AUTOMECHANIC);
	end	

	if player:hasTrait(SOTO.CharacterTrait.METAL_WELDER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.METAL_WELDER2);
		SOTOaddTrait(player, SOTO.CharacterTrait.METAL_WELDER);
	end		

	if player:hasTrait(SOTO.CharacterTrait.MASONRY2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.MASONRY2);
		SOTOaddTrait(player, SOTO.CharacterTrait.MASONRY);
	end		
	
	if player:hasTrait(SOTO.CharacterTrait.WILDERNESS_KNOWLEDGE2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.WILDERNESS_KNOWLEDGE2);
		SOTOaddTrait(player, CharacterTrait.WILDERNESS_KNOWLEDGE);
	end	
	
	if player:hasTrait(SOTO.CharacterTrait.BRAVE2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.BRAVE2);
		SOTOaddTrait(player, CharacterTrait.BRAVE);
	end

	if player:hasTrait(SOTO.CharacterTrait.TIRELESS2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.TIRELESS2);
		SOTOaddTrait(player, SOTO.CharacterTrait.TIRELESS);
	end	

	if player:hasTrait(SOTO.CharacterTrait.DEXTROUS2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.DEXTROUS2);
		SOTOaddTrait(player, CharacterTrait.DEXTROUS);
	end
	
	if player:hasTrait(SOTO.CharacterTrait.INVENTIVE2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.INVENTIVE2);
		SOTOaddTrait(player, CharacterTrait.INVENTIVE);
	end	

	if player:hasTrait(SOTO.CharacterTrait.GENERATOR_EXPERT2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.GENERATOR_EXPERT2);
		SOTOaddTrait(player, SOTO.CharacterTrait.GENERATOR_EXPERT);
	end	

	if player:hasTrait(SOTO.CharacterTrait.HANDY2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.HANDY2);
		SOTOaddTrait(player, CharacterTrait.HANDY);
	end	

	if player:hasTrait(SOTO.CharacterTrait.STRONG_BACK2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.STRONG_BACK2);
		SOTOaddTrait(player, SOTO.CharacterTrait.STRONG_BACK);
	end	

	if player:hasTrait(SOTO.CharacterTrait.HERBALIST2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.HERBALIST2);
		SOTOaddTrait(player, CharacterTrait.HERBALIST);
	end		

	if player:hasTrait(CharacterTrait.COOK2) then
		SOTOremoveTrait(player, CharacterTrait.COOK2);
		SOTOaddTrait(player, CharacterTrait.COOK);
	end		

	if player:hasTrait(CharacterTrait.NUTRITIONIST2) then
		SOTOremoveTrait(player, CharacterTrait.NUTRITIONIST2);
		SOTOaddTrait(player, CharacterTrait.NUTRITIONIST);
	end	

	if player:hasTrait(CharacterTrait.MECHANICS2) then
		SOTOremoveTrait(player, CharacterTrait.MECHANICS2);
		SOTOaddTrait(player, CharacterTrait.MECHANICS);
	end

	if player:hasTrait(SOTO.CharacterTrait.ORGANIZED2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.ORGANIZED2);
		SOTOaddTrait(player, CharacterTrait.ORGANIZED);
	end

	if player:hasTrait(SOTO.CharacterTrait.GRACEFUL2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.GRACEFUL2);
		SOTOaddTrait(player, CharacterTrait.GRACEFUL);
	end	

	if player:hasTrait(SOTO.CharacterTrait.INCONSPICUOUS2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.INCONSPICUOUS2);
		SOTOaddTrait(player, CharacterTrait.INCONSPICUOUS);
	end	

	if player:hasTrait(SOTO.CharacterTrait.PACIFIST2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.PACIFIST2);
		SOTOaddTrait(player, CharacterTrait.PACIFIST);
	end	

	if player:hasTrait(SOTO.CharacterTrait.SHOOTER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.SHOOTER2);
		SOTOaddTrait(player, SOTO.CharacterTrait.SHOOTER);
	end			

	if player:hasTrait(SOTO.CharacterTrait.FAST_READER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.FAST_READER2);
		SOTOaddTrait(player, CharacterTrait.FAST_READER);
	end		

	if player:hasTrait(SOTO.CharacterTrait.ADRENALINE_JUNKIE2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.ADRENALINE_JUNKIE2);
		SOTOaddTrait(player, CharacterTrait.ADRENALINE_JUNKIE);
	end

	if player:hasTrait(SOTO.CharacterTrait.SCOUT2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.SCOUT2);
		SOTOaddTrait(player, CharacterTrait.SCOUT);
	end	

	if player:hasTrait(SOTO.CharacterTrait.SPEED_DEMON2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.SPEED_DEMON2);
		SOTOaddTrait(player, CharacterTrait.SPEED_DEMON);
	end		

	if player:hasTrait(SOTO.CharacterTrait.EAGLE_EYED2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.EAGLE_EYED2);
		SOTOaddTrait(player, CharacterTrait.EAGLE_EYED);
	end	

	if player:hasTrait(SOTO.CharacterTrait.FIRST_AID2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.FIRST_AID2);
		SOTOaddTrait(player, CharacterTrait.FIRST_AID);
	end

	if player:hasTrait(SOTO.CharacterTrait.GARDENER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.GARDENER2);
		SOTOaddTrait(player, CharacterTrait.GARDENER);
	end	

	if player:hasTrait(SOTO.CharacterTrait.ANIMAL_FRIEND2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.ANIMAL_FRIEND2);
		SOTOaddTrait(player, CharacterTrait.ANIMAL_FRIEND);
	end

	if player:hasTrait(SOTO.CharacterTrait.SLAUGHTERER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.SLAUGHTERER2);
		SOTOaddTrait(player, SOTO.CharacterTrait.SLAUGHTERER);
	end

	if player:hasTrait(SOTO.CharacterTrait.HUNTER2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.HUNTER2);
		SOTOaddTrait(player, CharacterTrait.HUNTER);
	end

	if player:hasTrait(SOTO.CharacterTrait.DESENSITIZED2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.DESENSITIZED2);
		SOTOaddTrait(player, CharacterTrait.DESENSITIZED);
	end

	if player:hasTrait(SOTO.CharacterTrait.NIGHT_VISION2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.NIGHT_VISION2);
		SOTOaddTrait(player, CharacterTrait.NIGHT_VISION);
	end

	if player:hasTrait(SOTO.CharacterTrait.GYMNAST2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.GYMNAST2);
		SOTOaddTrait(player, CharacterTrait.GYMNAST);
	end	

	if player:hasTrait(SOTO.CharacterTrait.OUTDOORSMAN2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.OUTDOORSMAN2);
		SOTOaddTrait(player, CharacterTrait.OUTDOORSMAN);
	end	

	if player:hasTrait(SOTO.CharacterTrait.KEEN_HEARING2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.KEEN_HEARING2);
		SOTOaddTrait(player, CharacterTrait.KEEN_HEARING);
	end		

	if player:hasTrait(SOTO.CharacterTrait.CRUELTY2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.CRUELTY2);
		SOTOaddTrait(player, SOTO.CharacterTrait.CRUELTY);
	end		

	if player:hasTrait(SOTO.CharacterTrait.BREATHING_TECHNIQUE2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.BREATHING_TECHNIQUE2);
		SOTOaddTrait(player, SOTO.CharacterTrait.BREATHING_TECHNIQUE);
	end

	if player:hasTrait(SOTO.CharacterTrait.STRONG_GRIP2) then
		SOTOremoveTrait(player, SOTO.CharacterTrait.STRONG_GRIP2);
		SOTOaddTrait(player, SOTO.CharacterTrait.STRONG_GRIP);
	end
	
end

Events.OnCreatePlayer.Add(SOTOBaseGameCharacterDetails.DoNewCharacterInitializations);

SOTOBaseGameCharacterDetails.WeightFixCharacterInitializations = function(playernum, character)
    
	local player = getSpecificPlayer(playernum);
    if not player then return end

    local modData = player:getModData();

    if modData.SOTOWeightFixed then
        return
    end

    -- FIX FOR VANILLA WEIGHT START
    if player:hasTrait(CharacterTrait.UNDERWEIGHT) then
        SOTOsetCharacterWeight(player, 70); -- 70
    elseif player:hasTrait(CharacterTrait.VERY_UNDERWEIGHT) then
        SOTOsetCharacterWeight(player, 60); -- 60
    elseif player:hasTrait(CharacterTrait.OVERWEIGHT) then
        SOTOsetCharacterWeight(player, 95); -- 95
    elseif player:hasTrait(CharacterTrait.OBESE) then
        SOTOsetCharacterWeight(player, 105); -- 105
    else
        SOTOsetCharacterWeight(player, 80); -- 80
    end

    modData.SOTOWeightFixed = true;
	
end

Events.OnCreatePlayer.Add(SOTOBaseGameCharacterDetails.WeightFixCharacterInitializations);