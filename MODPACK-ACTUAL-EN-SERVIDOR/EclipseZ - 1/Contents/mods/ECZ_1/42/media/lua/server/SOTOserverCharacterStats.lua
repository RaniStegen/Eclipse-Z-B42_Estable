------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

---------------------
-- CHARACTER STATS --
---------------------

-- This file contains functions that are activated on the server by other client functions.

-- SOTO ADD XP
function SOTOAddXP(player, perk, xpamount, ...)
	if not player or not perk or not xpamount then return end
	player:getXp():AddXP(perk, xpamount, ...)
end

-- SOTO CHARACTER STATS MODIFIERS --

-- INTOXICATION
function SOTOdecreaseIntoxication(player, chance, intoxication)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentIntoxication = player:getStats():get(CharacterStat.INTOXICATION);
		player:getStats():set(CharacterStat.INTOXICATION, currentIntoxication - intoxication);
		if player:getStats():get(CharacterStat.INTOXICATION) < 0 then
			player:getStats():set(CharacterStat.INTOXICATION, 0);
		end	
	end
end

-- BOREDOM
function SOTOdecreaseBoredom(player, chance, boredom)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentBoredom = player:getStats():get(CharacterStat.BOREDOM);
		player:getStats():set(CharacterStat.BOREDOM, currentBoredom - boredom);
		if player:getStats():get(CharacterStat.BOREDOM) < 0 then
			player:getStats():set(CharacterStat.BOREDOM, 0);
		end
	end
end
function SOTOincreaseBoredom(player, chance, boredom)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentBoredom = player:getStats():get(CharacterStat.BOREDOM);
		player:getStats():set(CharacterStat.BOREDOM, currentBoredom + boredom);
		if player:getStats():get(CharacterStat.BOREDOM) > 100 then
			player:getStats():set(CharacterStat.BOREDOM, 100);
		end
	end
end

-- HUNGER
function SOTOincreaseHunger(player, chance, hunger)
	local HundredChance = ZombRand(100);
	local HeartyAppititeMult = 1;
	local LightEaterMult = 1;	
	if HundredChance <= chance then
		local currentHunger = player:getStats():get(CharacterStat.HUNGER);
		if player:hasTrait(CharacterTrait.HEARTY_APPETITE) then
			HeartyAppititeMult = 1.50;
		end	
		if player:hasTrait(CharacterTrait.LIGHT_EATER) then
			LightEaterMult = 0.75;
		end	
		player:getStats():set(CharacterStat.HUNGER, currentHunger + (hunger * (HeartyAppititeMult * LightEaterMult)));
		if player:getStats():get(CharacterStat.HUNGER) > 1 then
			player:getStats():set(CharacterStat.HUNGER, 1);
		end
	end
end	
function SOTOdecreaseHunger(player, chance, hunger)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentHunger = player:getStats():get(CharacterStat.HUNGER);
		player:getStats():set(CharacterStat.HUNGER, currentHunger - hunger);
		if player:getStats():get(CharacterStat.HUNGER) < 0 then
			player:getStats():set(CharacterStat.HUNGER, 0);
		end
	end
end	

-- THIRST
function SOTOincreaseThirst(player, chance, thirst)
	local HundredChance = ZombRand(100);
	local HighThirstMult = 1;
	local LowThirstMult = 1;
	if HundredChance <= chance then
		local currentThirst = player:getStats():get(CharacterStat.THIRST);
		if player:hasTrait(CharacterTrait.HIGH_THIRST) then
			HighThirstMult = 2.0;
		end	
		if player:hasTrait(CharacterTrait.LOW_THIRST) then
			LowThirstMult = 0.50;
		end			
		player:getStats():set(CharacterStat.THIRST, currentThirst + (thirst * (HighThirstMult * LowThirstMult)));
		if player:getStats():get(CharacterStat.THIRST) > 1 then
			player:getStats():set(CharacterStat.THIRST, 1);
		end
	end
end	
function SOTOdecreaseThirst(player, chance, thirst)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentThirst = player:getStats():get(CharacterStat.THIRST);
		player:getStats():set(CharacterStat.THIRST, currentThirst - thirst);
		if player:getStats():get(CharacterStat.THIRST) < 0 then
			player:getStats():set(CharacterStat.THIRST, 0);
		end
	end
end	

-- WETNESS
function SOTOincreaseWetness(player, chance, wetness)
	local HundredChance = ZombRand(100);
	local OverweightMult = 1;
	local ObeseMult = 1;
	if HundredChance <= chance then
		local currentWetness = player:getStats():get(CharacterStat.WETNESS);
		if player:hasTrait(CharacterTrait.OVERWEIGHT) then
			OverweightMult = 1.2;
		end	
		if player:hasTrait(CharacterTrait.OBESE) then
			ObeseMult = 1.4;
		end	
		player:getStats():set(CharacterStat.WETNESS, currentWetness + (wetness * (OverweightMult * ObeseMult)));
		if player:getStats():get(CharacterStat.WETNESS) > 100 then
			player:getStats():set(CharacterStat.WETNESS, 100);
		end
	end
end	
function SOTOdecreaseWetness(player, chance, wetness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentWetness = player:getStats():get(CharacterStat.WETNESS);
		local OverweightMult = 1;
		local ObeseMult = 1;
		if player:hasTrait(CharacterTrait.OVERWEIGHT) then
			OverweightMult = 0.8;
		end	
		if player:hasTrait(CharacterTrait.OBESE) then
			ObeseMult = 0.6;
		end	
		player:getStats():set(CharacterStat.WETNESS, currentWetness - (wetness * (OverweightMult * ObeseMult)));
		if player:getStats():get(CharacterStat.WETNESS) < 0 then
			player:getStats():set(CharacterStat.WETNESS, 0);
		end
	end
end	

-- STRESS
function SOTOincreaseStress(player, chance, stress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentStress = player:getStats():get(CharacterStat.STRESS);
		player:getStats():set(CharacterStat.STRESS, currentStress + stress);
		if player:getStats():get(CharacterStat.STRESS) > 1 then
			player:getStats():set(CharacterStat.STRESS, 1);
		end
	end
end
function SOTOdecreaseStress(player, chance, stress)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentStress = player:getStats():get(CharacterStat.STRESS);
		player:getStats():set(CharacterStat.STRESS, currentStress - stress);
		if player:getStats():get(CharacterStat.STRESS) < 0 then
			player:getStats():set(CharacterStat.STRESS, 0);
		end
	end
end
function SOTOsetStress(player, stress)
		player:getStats():set(CharacterStat.STRESS, stress);
end

-- NICOTINE_WITHDRAWAL
function SOTOincreaseNicotineWithdrawal(player, chance, nicotinewithdrawal)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentNicotineWithdrawal = player:getStats():get(CharacterStat.NICOTINE_WITHDRAWAL);
		player:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, currentNicotineWithdrawal + nicotinewithdrawal);
		if player:getStats():get(CharacterStat.NICOTINE_WITHDRAWAL) > 1 then
			player:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, 1);
		end
	end
end
function SOTOdecreaseNicotineWithdrawal(player, chance, nicotinewithdrawal)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentNicotineWithdrawal = player:getStats():get(CharacterStat.NICOTINE_WITHDRAWAL);
		player:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, currentNicotineWithdrawal - nicotinewithdrawal);
		if player:getStats():get(CharacterStat.NICOTINE_WITHDRAWAL) < 0 then
			player:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, 0);
		end
	end
end
function SOSetCigStress(player, nicotinewithdrawal)
	player:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, nicotinewithdrawal);
end

-- UNHAPPINESS
function SOTOincreaseUnhappiness(player, chance, unhappiness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentUnhappiness = player:getStats():get(CharacterStat.UNHAPPINESS);
		player:getStats():set(CharacterStat.UNHAPPINESS, currentUnhappiness + unhappiness);
		if player:getStats():get(CharacterStat.UNHAPPINESS) > 100 then
			player:getStats():set(CharacterStat.UNHAPPINESS, 100);
		end
	end
end
function SOTOdecreaseUnhappiness(player, chance, unhappiness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentUnhappiness = player:getStats():get(CharacterStat.UNHAPPINESS);
		player:getStats():set(CharacterStat.UNHAPPINESS, currentUnhappiness - unhappiness);
		if player:getStats():get(CharacterStat.UNHAPPINESS) < 0 then
			player:getStats():set(CharacterStat.UNHAPPINESS, 0);
		end
	end
end
function SOSetUnhappiness(player, unhappiness)
		player:getStats():set(CharacterStat.UNHAPPINESS, unhappiness);
end

-- PANIC
function SOTOincreasePanic(player, chance, panic)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentPanic = player:getStats():get(CharacterStat.PANIC);
		player:getStats():set(CharacterStat.PANIC,currentPanic + panic);
		if player:getStats():get(CharacterStat.PANIC) > 100 then
			player:getStats():set(CharacterStat.PANIC, 100);
		end
	end
end
function SOTOdecreasePanic(player, chance, panic)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentPanic = player:getStats():get(CharacterStat.PANIC);
		player:getStats():set(CharacterStat.PANIC, currentPanic - panic);
		if player:getStats():get(CharacterStat.PANIC) < 0 then
			player:getStats():set(CharacterStat.PANIC, 0);
		end
	end
end
function SOTOsetPanic(player, panic)
		player:getStats():set(CharacterStat.PANIC, panic);
end

-- FATIGUE
function SOTOincreaseFatigue(player, chance, fatigue)
	local HundredChance = ZombRand(100);
	local FitnessLvlValues = {
		[0] 	= 1.0,
		[1]		= 0.95,
		[2] 	= 0.92,
		[3] 	= 0.89,
		[4] 	= 0.87,
		[5] 	= 0.85,
		[6] 	= 0.83,
		[7] 	= 0.81,
		[8] 	= 0.79,
		[9] 	= 0.77,
		[10]	= 0.75
	}
	local x = SOTOFitnessLvl;
	local FitnessFatGainMult = FitnessLvlValues[x];	
	if HundredChance <= chance then
		local currentFatigue = player:getStats():get(CharacterStat.FATIGUE);
		local SleepyheadMult = 1
		local WakefulMult = 1		
		if player:hasTrait(CharacterTrait.NEEDS_MORE_SLEEP) then			
			SleepyheadMult = 1.3
		end		
		if player:hasTrait(CharacterTrait.NEEDS_LESS_SLEEP) then			
			WakefulMult = 0.7
		end				
		player:getStats():set(CharacterStat.FATIGUE, currentFatigue + (((fatigue * FitnessFatGainMult) * (SleepyheadMult * WakefulMult))));		
		if player:getStats():get(CharacterStat.FATIGUE) > 1 then
			player:getStats():set(CharacterStat.FATIGUE, 1);
		end
	end
end
function SOTOdecreaseFatigue(player, chance, fatigue)
	local HundredChance = ZombRand(100);
	local SleepyheadMult = 1
	local WakefulMult = 1	
	if HundredChance <= chance then
		local currentFatigue = player:getStats():get(CharacterStat.FATIGUE);
		if player:hasTrait(CharacterTrait.NEEDS_MORE_SLEEP) then			
			SleepyheadMult = 0.7
		end		
		if player:hasTrait(CharacterTrait.NEEDS_LESS_SLEEP) then			
			WakefulMult = 1.3
		end		
		player:getStats():set(CharacterStat.FATIGUE, currentFatigue - ((fatigue * (SleepyheadMult * WakefulMult))));			
		if player:getStats():get(CharacterStat.FATIGUE) < 0 then
			player:getStats():set(CharacterStat.FATIGUE, 0);
		end
	end
end

-- DISCOMFORT
function SOTOincreaseDiscomfort(player, chance, discomfort)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentDiscomfort = player:getStats():get(CharacterStat.DISCOMFORT);
		player:getStats():set(CharacterStat.DISCOMFORT, currentDiscomfort + discomfort);
		if player:getStats():get(CharacterStat.DISCOMFORT) > 100 then
			player:getStats():set(CharacterStat.DISCOMFORT, 100);
		end
	end
end
function SOTOdecreaseDiscomfort(player, chance, discomfort)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentDiscomfort = player:getStats():get(CharacterStat.DISCOMFORT);
		player:getStats():set(CharacterStat.DISCOMFORT, currentDiscomfort - discomfort);
		if player:getStats():get(CharacterStat.DISCOMFORT) < 0 then
			player:getStats():set(CharacterStat.DISCOMFORT, 0);
		end
	end
end
function SOTOsetDiscomfort(player, discomfort)
		player:getStats():set(CharacterStat.DISCOMFORT, discomfort);
end


-- FOOD_SICKNESS
function SOTOincreaseFoodSickness(player, chance, foodsickness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
	local currentFoodSickness = player:getStats():get(CharacterStat.FOOD_SICKNESS);
		if player:hasTrait(CharacterTrait.WEAK_STOMACH) then
			player:getStats():set(CharacterStat.FOOD_SICKNESS, currentFoodSickness + (foodsickness * 1.3));
		elseif player:hasTrait(CharacterTrait.IRON_GUT) then
			player:getStats():set(CharacterStat.FOOD_SICKNESS, currentFoodSickness + (foodsickness * 0.7));
		else
			player:getStats():set(CharacterStat.FOOD_SICKNESS, currentFoodSickness + foodsickness);
		end
		if player:getStats():get(CharacterStat.FOOD_SICKNESS) > 100 then
			player:getStats():set(CharacterStat.FOOD_SICKNESS, 100);
		end
	end
end
function SOTOdecreaseFoodSickness(player, chance, foodsickness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
	local currentFoodSickness = player:getStats():get(CharacterStat.FOOD_SICKNESS);
		if player:hasTrait(CharacterTrait.WEAK_STOMACH) then
			player:getStats():set(CharacterStat.FOOD_SICKNESS, currentFoodSickness - (foodsickness * 0.7));
		elseif player:hasTrait(CharacterTrait.IRON_GUT) then
			player:getStats():set(CharacterStat.FOOD_SICKNESS, currentFoodSickness - (foodsickness * 1.3));
		else
			player:getStats():set(CharacterStat.FOOD_SICKNESS, currentFoodSickness - foodsickness);
		end
		if player:getStats():get(CharacterStat.FOOD_SICKNESS) < 0 then
			player:getStats():set(CharacterStat.FOOD_SICKNESS, 0);
		end
	end
end


-- PAIN
function SOTOincreasePain(player, chance, bodyPart, pain)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local bodyPartAux = BodyPartType.FromString(bodyPart);
		local playerBodyPart = player:getBodyDamage():getBodyPart(bodyPartAux);
		local currentPain = playerBodyPart:getPain();
		playerBodyPart:setAdditionalPain(currentPain + pain);
		if playerBodyPart:getPain() > 99 then
			playerBodyPart:setAdditionalPain(99);
		end
	end
end

-- ENDURANCE
function SOTOincreaseEndurance(player, chance, endurance)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentEndurance = player:getStats():get(CharacterStat.ENDURANCE);
		player:getStats():set(CharacterStat.ENDURANCE, currentEndurance + endurance);
		if player:getStats():get(CharacterStat.ENDURANCE) > 1 then
			player:getStats():set(CharacterStat.ENDURANCE, 1);
		end
	--print("Restored");			
	end
end

function SOTOdecreaseEndurance(player, chance, endurance)
	local HundredChance = ZombRand(100);
	local FitnessLvlValues = {
		[0] 	= 0.9,
		[1]		= 0.8,
		[2] 	= 0.75,
		[3] 	= 0.7,
		[4] 	= 0.65,
		[5] 	= 0.60,
		[6] 	= 0.57,
		[7] 	= 0.53,
		[8] 	= 0.49,
		[9] 	= 0.46,
		[10]	= 0.43
	}
	local x = SOTOFitnessLvl;
	local FitnessEndLossMult = FitnessLvlValues[x];
	if HundredChance <= chance then
		local currentEndurance = player:getStats():get(CharacterStat.ENDURANCE);
		player:getStats():set(CharacterStat.ENDURANCE, currentEndurance - (endurance * FitnessEndLossMult));
		if player:getStats():get(CharacterStat.ENDURANCE) < 0 then
			player:getStats():set(CharacterStat.ENDURANCE, 0);
		end
	end
end

-- STIFFNESS / MUSCLE STRAIN
function SOTOdecreaseStiffness(player, chance, bodyPart, stiffness)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local bodyPartAux = BodyPartType.FromString(bodyPart);
		local playerBodyPart = player:getBodyDamage():getBodyPart(bodyPartAux);
		local currentStiffness = playerBodyPart:getStiffness();
		if currentStiffness > 0 then
			playerBodyPart:setStiffness(currentStiffness - stiffness);
			if playerBodyPart:getStiffness() < 0 then
				playerBodyPart:setStiffness(0);
			end	
		end
	end
end

function SOTOincreaseColdStrength(player, coldstrength)
	local currentColdStrength = player:getBodyDamage():getColdStrength();
	player:getBodyDamage():setHasACold(true);
	player:getBodyDamage():setColdStrength(currentColdStrength + coldstrength);
	if player:getBodyDamage():getColdStrength() > 100 then
		player:getBodyDamage():setColdStrength(100);
	end
end

-- TIMESINCELASTSMOKE
function SOTOsetTimeSinceLastSmoke(player, timesincelastsmoke)
		player:setTimeSinceLastSmoke(timesincelastsmoke);
end

-- SLEEPINGTABLETDELTA
function SOTOdecreaseSleepingTabletDelta(player, chance, stdelta)
	local HundredChance = ZombRand(100);
	if HundredChance <= chance then
		local currentstdelta = player:getSleepingTabletDelta();
		player:setSleepingTabletDelta(math.max(0, currentstdelta - stdelta));
		if player:getSleepingTabletDelta() < 0 then
			player:setSleepingTabletDelta(0);
		end
	end
end

-- CALORIES
function SOTOincreaseCalories(player, calories)
	local currCalories = player:getNutrition():getCalories();
	player:getNutrition():setCalories(currCalories + calories);
	if player:getNutrition():getCalories() > 5000 then
		player:getNutrition():getCalories(5000);
	end
end
function SOTOdecreaseCalories(player, calories)
	local currCalories = player:getNutrition():getCalories();
	player:getNutrition():setCalories(currCalories - calories);
	if player:getNutrition():getCalories() < -5000 then
		player:getNutrition():getCalories(-5000);
	end
end

-- BODY HEALTH
function SOTOaddBodyPartsHealth(player, bodyPart, heal)
    bodyPart:AddHealth(heal);
end
function SOTOreduceBodyPartsHealth(player, bodyPart, damage)
    bodyPart:ReduceHealth(damage);
end

-- MAX WEIGHT BASE
function SOTOsetMaxWeightBase(player, maxweightbase)
	player:setMaxWeightBase(maxweightbase);
end

-- Recomputes and applies the correct max weight for a player server-side, then syncs to client.
function SOTOUpdateMaxWeight(player)
	if not player then return end
	-- Flat base only — vanilla B42 multiplies maxWeightBase by a strength factor,
	-- so adding strBonus here would double-count and cause inflated values.
	local newWeight
	if player:hasTrait(SOTO.CharacterTrait.STRONG_BACK) then
		newWeight = 9
	elseif player:hasTrait(SOTO.CharacterTrait.WEAK_BACK) then
		newWeight = 7
	else
		newWeight = 8
	end
	player:setMaxWeightBase(newWeight)
	sendServerCommand(player, "SOTO", "SyncMaxWeight", {weight = newWeight})
end

local function SOTOUpdateAllPlayersWeight()
	local players = getOnlinePlayers()
	if players:size() == 0 then
		local p = getPlayer()
		if p then SOTOUpdateMaxWeight(p) end
	else
		for i = 0, players:size() - 1 do
			SOTOUpdateMaxWeight(players:get(i))
		end
	end
end

Events.EveryHours.Add(SOTOUpdateAllPlayersWeight)

Events.OnCreatePlayer.Add(function(playerNum)
	local player = getSpecificPlayer(playerNum)
	if player then
		SOTOUpdateMaxWeight(player)
	else
		SOTOUpdateAllPlayersWeight()
	end
end)

Events.LevelPerk.Add(function(player, perk)
	if perk == Perks.Strength then
		SOTOUpdateMaxWeight(player)
	end
end)

-- CHARACTER WEIGHT
function SOTOsetCharacterWeight(player, characterweigth)

	player:getNutrition():setWeight(characterweigth);

end




