------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

--------------------
-- MAIN FUNCTIONS --
--------------------

-- This file contains functions that are activated by the client to activate functions on the server.

local SOTOSbvars = SandboxVars.SOTO;

-- CHECKING SKILL LEVELS --

function checkskillslevel()

	local player = getPlayer();
	if player == nil then return end

	SOTOStrengthLvl = player:getPerkLevel(Perks.Strength);
	SOTOFitnessLvl = player:getPerkLevel(Perks.Fitness);

	SOTONimbleLvl = player:getPerkLevel(Perks.Nimble);
	SOTOSneakLvl = player:getPerkLevel(Perks.Sneak);		
	SOTOSprintingLvl = player:getPerkLevel(Perks.Sprinting);		
	SOTOLightfootedLvl = player:getPerkLevel(Perks.Lightfoot);	

	SOTOAxeLvl = player:getPerkLevel(Perks.Axe);

end

Events.OnGameStart.Add(checkskillslevel);
Events.LevelPerk.Add(checkskillslevel);
Events.OnCreatePlayer.Add(checkskillslevel);
Events.OnCreateLivingCharacter.Add(checkskillslevel);

-- MAX WEIGHT BASE

function SOTOCheckMaxWeightBase()
	local player = getPlayer()
	if not player then return end
	-- Vanilla B42 already scales carry weight with Strength on top of maxWeightBase.
	-- SOTO only sets the trait-based base offset; do NOT add strBonus here (double-counts).
	local newWeight
	if player:hasTrait(SOTO.CharacterTrait.STRONG_BACK) then
		newWeight = 9
	elseif player:hasTrait(SOTO.CharacterTrait.WEAK_BACK) then
		newWeight = 7
	else
		newWeight = 8
	end
	player:setMaxWeightBase(newWeight)
end

Events.EveryHours.Add(SOTOCheckMaxWeightBase);
Events.OnGameStart.Add(SOTOCheckMaxWeightBase);
Events.OnCreatePlayer.Add(SOTOCheckMaxWeightBase);
Events.OnCreateLivingCharacter.Add(SOTOCheckMaxWeightBase);
Events.LevelPerk.Add(SOTOCheckMaxWeightBase);

-- LARK TRAIT
function larkpersontrait()
	
	local player = getPlayer();
	if player == nil then return end
	
	local gameTime = getGameTime();
	local currentHour = gameTime:getHour();
 	if player:hasTrait(SOTO.CharacterTrait.LARKPERSON) and not player:isAsleep() then
		if currentHour >= 5 and currentHour <= 9 then	
			SOTOdecreaseFatigue(player, 50, 0.0065);
		end
		if currentHour >= 17 and currentHour <= 21 then
			SOTOincreaseFatigue(player, 50, 0.0065);
		end
	end
end

-- OWL TRAIT
function owlpersontrait()

	local player = getPlayer();
	if player == nil then return end
	
	local gameTime = getGameTime();
	local currentHour = gameTime:getHour();
 	if player:hasTrait(SOTO.CharacterTrait.OWLPERSON) and not player:isAsleep() then
		if currentHour >= 17 and currentHour <= 21 then	
			SOTOdecreaseFatigue(player, 50, 0.0065);
		end
		if currentHour >= 5 and currentHour <= 9 then
			SOTOincreaseFatigue(player, 50, 0.0065);
		end
	end
end


-- TIRELESS MUSCLE STRAIN
function tirelessmusclestrain() 

	local player = getPlayer();
	if player == nil then return end

	local StrengthLvlValues = {
		[0] 	= 0.60,
		[1]		= 0.66,
		[2] 	= 0.73,
		[3] 	= 0.79,
		[4] 	= 0.88,
		[5] 	= 0.97,
		[6] 	= 1.04,
		[7] 	= 1.08,
		[8] 	= 1.14,
		[9] 	= 1.21,
		[10]	= 1.33
	}
	
	local x = SOTOStrengthLvl;
	local tirelessreducestiffness = StrengthLvlValues[x];	

	if player:hasTrait(SOTO.CharacterTrait.TIRELESS) then
		-- 0.084 - stiffness reduction amount around 35% reduction of original value
		--local tirelessreducestiffness = 0.1;
		SOTOdecreaseStiffness (player, 100, "Hand_R", tirelessreducestiffness);
		SOTOdecreaseStiffness (player, 100, "Hand_L", tirelessreducestiffness)
		SOTOdecreaseStiffness (player, 100, "ForeArm_R", tirelessreducestiffness);
		SOTOdecreaseStiffness (player, 100, "ForeArm_L", tirelessreducestiffness);
		SOTOdecreaseStiffness (player, 100, "UpperArm_R", tirelessreducestiffness);
		SOTOdecreaseStiffness (player, 100, "UpperArm_L", tirelessreducestiffness);
		-- print(string.format("Reduced stiffness for %s: %.2f -> %.2f", partName, stiffness, newStiffness))
	end
	
end

-- STRONG BACK MUSCLE STRAIN
function strongbackmusclestrain()
	
	local player = getPlayer();
	if player == nil then return end

	local StrengthLvlValues = {
		[0] 	= 0.60,
		[1]		= 0.66,
		[2] 	= 0.73,
		[3] 	= 0.79,
		[4] 	= 0.88,
		[5] 	= 0.97,
		[6] 	= 1.04,
		[7] 	= 1.08,
		[8] 	= 1.14,
		[9] 	= 1.21,
		[10]	= 1.33
	}
	
	local x = SOTOStrengthLvl;
	local strongbackreducestiffness = StrengthLvlValues[x];	
	
    if player:hasTrait(SOTO.CharacterTrait.STRONG_BACK) then
		-- 0.084 - stiffness reduction amount around 35% reduction of original value
		--local strongbackreducestiffness = 0.1;
		SOTOdecreaseStiffness (player, 100, "Torso_Upper", strongbackreducestiffness);
		SOTOdecreaseStiffness (player, 100, "Torso_Lower", strongbackreducestiffness);
		-- print(string.format("Reduced stiffness for %s: %.2f -> %.2f", partName, stiffness, newStiffness))
	end
	
end

-- TIRELESS TRAIT - MAIN
function tirelesstrait(player, weapon)
	
	local player = getPlayer();
	if player == nil then return end
	
	local currentFatigue
	local FatigueMult
	local EndRecoverChance

	if player:hasTrait(SOTO.CharacterTrait.TIRELESS) then
		-- return if UNARMED
		if weapon:getType() == "UNARMED" then
			return
		end
		-- get item stats
		local WeaponInPrimaryHand = player:getPrimaryHandItem();
		local WeaponInSecondaryHand = player:getSecondaryHandItem();	
		-- if no mainhand weapon then return
		if WeaponInPrimaryHand == nil then
			return
		end
		if WeaponInPrimaryHand:IsWeapon() then 

			local WeaponEndMod = WeaponInPrimaryHand:getEnduranceMod();
			local WeaponWeight = WeaponInPrimaryHand:getWeight();

			currentFatigue = player:getStats():get(CharacterStat.FATIGUE);
			FatigueMult = 1.0 - currentFatigue;
			FatigueMult = round(FatigueMult,2);

			if player:hasTrait(SOTO.CharacterTrait.TIRELESS) then EndRecoverChance = 20 end -- 20% if Tireless
			
			-- Endurance formula	
			local RWeaponEndCost = (((WeaponWeight * 0.003) * WeaponEndMod)) * FatigueMult;	
			local RWeaponEndCost = round(RWeaponEndCost,6);
			-- Restoring 50% of RWeaponEndCost while swing with 25% chance
			SOTOincreaseEndurance(player, EndRecoverChance, (RWeaponEndCost * 0.5));
			end
		-- print("Tireless: " .. EndRecoverChance)		
		-- print("Tireless: " .. (RWeaponEndCost * 0.5))
		-- print("FatigueMult: " .. FatigueMult)	
		end
end

-- MARATHON RUNNER TRAIT - MAIN
function marathonrunnertrait ()

	local player = getPlayer();
	if player == nil then return end
	
	local currentFatigue
	local FatigueMult
	local OverweightMult
	local ObeseMult	
	local AthleticPenalty
	
	if player:hasTrait(SOTO.CharacterTrait.MARATHON_RUNNER) then 
		-- local EndRegenChance = 100;	
		local FitnessMult = 0.7 + (SOTOFitnessLvl * 0.1);

		if player:hasTrait(CharacterTrait.OVERWEIGHT) then			
			OverweightMult = 0.7;
			else OverweightMult = 1;
		end				
		if player:hasTrait(CharacterTrait.OBESE) then			
			ObeseMult = 0.4;
			else ObeseMult = 1	;
		end
		if SOTOFitnessLvl >= 9 then
			AthleticPenalty = 0.4;
			else AthleticPenalty = 1;
		end	

		currentFatigue = player:getStats():get(CharacterStat.FATIGUE);
		FatigueMult = 1.0 - currentFatigue;
		FatigueMult = round(FatigueMult, 2);
		local MRRunER = (((0.0009 * FitnessMult) * AthleticPenalty) * (OverweightMult * ObeseMult)) * FatigueMult;
		local MRRunER = round(MRRunER, 6);	
		-- Running and Sprinting
		if player:IsRunning() == true or player:isSprinting() == true then
			if player:isPlayerMoving() and player:isSneaking() == false then
				SOTOincreaseEndurance(player, 100, MRRunER);
				-- print("MR Endurance: " .. MRRunER)		
			end
		end
	end
	
end

-- BETWEEN THE SHADOWS - MAIN
function ninjawaytrait ()

	local player = getPlayer();
	if player == nil then return end
	
	local currentFatigue;
	local currentEndurance;
	local FatigueMult;
	local OverweightMult;
	local ObeseMult;
	local AthleticPenalty;
	local FitnessLvlValues = {
		[0] 	= 0.7,
		[1]		= 0.8,
		[2] 	= 0.9,
		[3] 	= 1.0,
		[4] 	= 1.1,
		[5] 	= 1.2,
		[6] 	= 1.3,
		[7] 	= 1.4,
		[8] 	= 1.5,
		[9] 	= 1.55,
		[10]	= 1.6
	}
	local x = SOTOFitnessLvl;
	local FitnessMult = FitnessLvlValues[x];		

	if player:hasTrait(SOTO.CharacterTrait.NINJAWAY) and not player:isAsleep() then 	
		if player:hasTrait(CharacterTrait.OVERWEIGHT) then			
			OverweightMult = 0.7;
				else OverweightMult = 1;
		end				
		if player:hasTrait(CharacterTrait.OBESE) then			
			ObeseMult = 0.4;
				else ObeseMult = 1;
		end	
		if SOTOFitnessLvl >= 9 then
			AthleticPenalty = 0.4;
				else AthleticPenalty = 1;
		end		
		currentEndurance = player:getStats():get(CharacterStat.ENDURANCE);
		currentFatigue = player:getStats():get(CharacterStat.FATIGUE);
		FatigueMult = 1.0 - currentFatigue;
		FatigueMult = round(FatigueMult, 2);
		local BtSEnduranceRUN = (((0.00065 * FitnessMult) * AthleticPenalty)* (OverweightMult * ObeseMult)) * FatigueMult;	
		local BtSEnduranceRUN = round(BtSEnduranceRUN,6);
		local BtSEnduranceRegen = ((0.00065 * FitnessMult) * (OverweightMult * ObeseMult)) * FatigueMult;
		local BtSEnduranceRegen = round(BtSEnduranceRegen,6);
		if player:isSneaking() == true then
			-- Sneaking NOT MOVING
			if not player:isPlayerMoving() and currentEndurance <= 0.99 then
				if not player:getCurrentState() == PlayerAimState.instance() or player:isSitOnGround() == false then	
					SOTOincreaseEndurance(player, 100, (BtSEnduranceRegen * 2));
					-- print("BtS stand: " .. (BtSEnduranceRegen * 2))		
				end
			end
			-- Sneaking WALK
			if player:isPlayerMoving() and player:IsRunning() == false then
				if player:isAiming() == false then
					SOTOincreaseEndurance(player, 100, BtSEnduranceRegen);
					-- print("BtS Walk: " .. BtSEnduranceRegen)		
				end
			end	
			-- Sneaking RUN			
			if player:isPlayerMoving() and player:IsRunning() == true then
				SOTOincreaseEndurance(player, 100, (BtSEnduranceRUN * 2));
				-- print("BtS Run: " .. (BtSEnduranceRUN * 2))		
			end	
		end
	end

end

-- BREATHING TECHNIQUE TRAIT - MAIN
function breathingtechtrait()

	local player = getPlayer();
	if player == nil then return end
	
	local currentEndurance;
	local currentFatigue;
	local FatigueMult;
	local OverweightMult;
	local ObeseMult;
	local FitnessLvlValues = {
		[0] 	= 0.7,
		[1]		= 0.8,
		[2] 	= 0.9,
		[3] 	= 1.0,
		[4] 	= 1.1,
		[5] 	= 1.2,
		[6] 	= 1.3,
		[7] 	= 1.4,
		[8] 	= 1.5,
		[9] 	= 1.55,
		[10]	= 1.6
	}
	local x = SOTOFitnessLvl;
	local FitnessMult = FitnessLvlValues[x];	
	
	if player:hasTrait(SOTO.CharacterTrait.BREATHING_TECHNIQUE) then
		if player:hasTrait(CharacterTrait.OVERWEIGHT) then			
			OverweightMult = 0.7;
				else OverweightMult = 1;
		end				
		if player:hasTrait(CharacterTrait.OBESE) then			
			ObeseMult = 0.4;
				else ObeseMult = 1;
		end		
		currentEndurance = player:getStats():get(CharacterStat.ENDURANCE);
		currentFatigue = player:getStats():get(CharacterStat.FATIGUE);
		FatigueMult = 1.0 - currentFatigue;
		FatigueMult = round(FatigueMult, 2);
		local BTEndRestoringAmount = ((0.0025 * FitnessMult) * (OverweightMult * ObeseMult)) * FatigueMult;
		local BTEndRestoringAmount = round(BTEndRestoringAmount,6);
		if not player:isAsleep() and currentEndurance <= 0.999 then
			-- if not moving stand
			if not player:isPlayerMoving() and player:isAiming() == false and player:isSitOnGround() == false and player:getVehicle() == nil then
				SOTOincreaseEndurance(player, 100, BTEndRestoringAmount);
--				print("BThq stand: " .. BTEndRestoringAmount)				
			end
			-- if not moving sitting
			if (not player:isPlayerMoving() and (player:isSitOnGround() == true or player:isSittingOnFurniture())) or player:getVehicle() ~= nil then	
				SOTOincreaseEndurance(player, 100, (BTEndRestoringAmount * 3));
--				print("BThq sitting: " .. (BTEndRestoringAmount * 3))			
			end			
		end
	end
end

-- LIQUID BLOOD TRAIT - MAIN
function liquidbloodtrait()
    local player = getPlayer();
    if player == nil then return end
    
    if player:hasTrait(SOTO.CharacterTrait.LIQUIDBLOOD) then 
        local gamespeed = UIManager.getSpeedControls():getCurrentGameSpeed();
        local gsmultiplier = 1;
        
        if gamespeed == 1 then gsmultiplier = 1;
        elseif gamespeed == 2 then gsmultiplier = 5;
        elseif gamespeed == 3 then gsmultiplier = 20;
        elseif gamespeed == 4 then gsmultiplier = 40;
        end
        
        local bodydamage = player:getBodyDamage();

        if bodydamage:getNumPartsBleeding() > 0 then
            local bodyParts = bodydamage:getBodyParts();
            for i = 0, bodyParts:size() - 1 do
                local bodyPart = bodyParts:get(i);
                
                if bodyPart:bleeding() and not bodyPart:IsBleedingStemmed() then
                    local damage = (0.0057 * gsmultiplier);
                    
                    if bodyPart:getType() == BodyPartType.Neck then
                        SOTOreduceBodyPartsHealth(player, bodyPart, (damage * 5));
                    else 
                        SOTOreduceBodyPartsHealth(player, bodyPart, damage);
                    end
                end
            end
        end
    end
end
-- THICK BLOOD TRAIT - MAIN
function thickbloodtrait()
    local player = getPlayer();
    if player == nil then return end
    
    if player:hasTrait(SOTO.CharacterTrait.THICKBLOOD) then 
        local gamespeed = UIManager.getSpeedControls():getCurrentGameSpeed();
        local gsmultiplier = 1;
        
        if gamespeed == 1 then gsmultiplier = 1;
        elseif gamespeed == 2 then gsmultiplier = 5;
        elseif gamespeed == 3 then gsmultiplier = 20;
        elseif gamespeed == 4 then gsmultiplier = 40;
        end
        
        local bodydamage = player:getBodyDamage();

        if bodydamage:getNumPartsBleeding() > 0 then
            local bodyParts = bodydamage:getBodyParts();
            for i = 0, bodyParts:size() - 1 do
                local bodyPart = bodyParts:get(i);
                
                if bodyPart:bleeding() and not bodyPart:IsBleedingStemmed() then
                    local damage = (0.00228 * gsmultiplier);
                    
                    if bodyPart:getType() == BodyPartType.Neck then
                        SOTOaddBodyPartsHealth(player, bodyPart, (damage * 5));
                    else 
                        SOTOaddBodyPartsHealth(player, bodyPart, damage);
                    end
                end
            end
        end
    end
end

-- CHRONIC MIGRAINE TRAIT - MAIN
function chronicmigrainetrait()

	local player = getPlayer();
	if player == nil then return end
	
	local head = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Head"));
	local painEffect = player:getPainEffect();
	local foodSicknessLevel = player:getStats():get(CharacterStat.FOOD_SICKNESS);
	local currentHeadPain = head:getPain();
	local modData = player:getModData();

	if modData.migraineCooldown == nil then modData.migraineCooldown = 0 end
	if modData.migraineDuration == nil then modData.migraineDuration = 0 end

	if player:hasTrait(SOTO.CharacterTrait.CHRONIC_MIGRAINE) then

		if modData.migraineCooldown > 0 then modData.migraineCooldown = modData.migraineCooldown - 1 end
		if modData.migraineDuration > 0 then modData.migraineDuration = modData.migraineDuration - 1 end

		-- Debug values
		-- local durationInHours = math.floor(player:getModData().migraineDuration / 6)
		-- local cooldownInHours = math.floor(player:getModData().migraineCooldown / 6)

		-- Migraine is active
		if modData.migraineDuration > 0 then
			-- print("Migraine active. Time remaining: " .. durationInHours)
			if painEffect <= 0 then
				local migrainePain = ZombRand(8, 16);	
				local migraunePainChance = 100;
				if currentHeadPain <= 70 and currentHeadPain >= 40 then migraunePainChance = 75;
				elseif currentHeadPain >= 71 then migraunePainChance = 30 end
				-- print("migraunePainChance: " .. migraunePainChance)
				-- print("migrainePain: " .. migrainePain)
				SOTOincreasePain(player, migraunePainChance, "Head", migrainePain);
			end
			elseif modData.migraineCooldown > 0 then
			-- print("Cooldown until next migraine: " .. cooldownInHours)
		end
		-- Migraine not active and cooldown is complete
		if modData.migraineDuration <= 0 and modData.migraineCooldown <= 0 then
			modData.migraineDuration = ZombRand(24, 288); -- 4-48 hours
			modData.migraineCooldown = ZombRand(144, 432); -- 24-72 hours
			-- print("Migraine started. Duration: " .. durationInHours)
		end
	end
end

--[[ SENSITIVE DIGESTION TRAIT - MAIN
function sensitivedigestiontrait()
	local player = getPlayer();
	if player:hasTrait(SOTO.CharacterTrait.SENSITIVE_DIGESTION) then
		local FoodEatenLevel = player:getMoodles():getMoodleLevel(MoodleType.FOOD_EATEN);
		local currentDiscomfort = player:getStats():get(CharacterStat.DISCOMFORT);
		local currentFoodSickness = player:getStats():get(CharacterStat.FOOD_SICKNESS);
		local SickProtection = 1;
		local discomfortLimit = 0;

		if currentFoodSickness >= 80 then
			SickProtection = 0.5;
		end

		-- DiscomfortModifier
		local wornItems = player:getWornItems();
		local totalModifier = 0;
		for i = 0, wornItems:size() - 1 do
			local item = wornItems:get(i):getItem();
			if item and item:IsClothing() then
				totalModifier = totalModifier + item:getDiscomfortModifier();
			end
		end

		local modifierPercent = totalModifier * 100; -- 0.1 → 10
		--print("[Debug] Total clothing DiscomfortModifier:", totalModifier, "→", modifierPercent);

		if FoodEatenLevel == 1 then
			discomfortLimit = 20 + modifierPercent;
			if currentDiscomfort < discomfortLimit then
				SOTOincreaseDiscomfort(player, 100, 2);
			end

		elseif FoodEatenLevel == 2 then
			discomfortLimit = 40 + modifierPercent;
			if currentDiscomfort < discomfortLimit then
				SOTOincreaseDiscomfort(player, 100, 3);
			end
			SOTOincreasePain(player, 100, "Torso_Lower", 1.0);
			SOTOincreaseFoodSickness(player, 100, 0.44 * SickProtection);

		elseif FoodEatenLevel == 3 then
			discomfortLimit = 60 + modifierPercent;
			if currentDiscomfort < discomfortLimit then
				SOTOincreaseDiscomfort(player, 100, 4);
			end
			SOTOincreasePain(player, 100, "Torso_Lower", 1.1);
			SOTOincreaseFoodSickness(player, 100, 0.55 * SickProtection);

		elseif FoodEatenLevel == 4 then
			discomfortLimit = 80 + modifierPercent;
			if currentDiscomfort < discomfortLimit then
				SOTOincreaseDiscomfort(player, 100, 5);
			end
			SOTOincreasePain(player, 100, "Torso_Lower", 1.2);
			SOTOincreaseFoodSickness(player, 100, 0.66 * SickProtection);
		end

		-- Debug
		--print(string.format("[SensitiveDigestion] Level: %d | Discomfort: %.2f / %.2f (incl. modifier %.2f%%)", FoodEatenLevel, currentDiscomfort, discomfortLimit, modifierPercent));
	end
end]]

-- SENSITIVE DIGESTION TRAIT - PAIN & FOOD SICKNESS
function sensitivedigestionmain()
	
	local player = getPlayer();
	if player == nil then return end
	
	if not player:hasTrait(SOTO.CharacterTrait.SENSITIVE_DIGESTION) then return end

	local FoodEatenLevel = player:getMoodles():getMoodleLevel(MoodleType.FOOD_EATEN);
	local currentFoodSickness = player:getStats():get(CharacterStat.FOOD_SICKNESS);

	local SickProtection = 1
	if currentFoodSickness >= 80 then SickProtection = 0.5 end

	if FoodEatenLevel == 2 then
		SOTOincreasePain(player, 100, "Torso_Lower", 1.0);
		SOTOincreaseFoodSickness(player, 100, 0.44 * SickProtection);

	elseif FoodEatenLevel == 3 then
		SOTOincreasePain(player, 100, "Torso_Lower", 1.1);
		SOTOincreaseFoodSickness(player, 100, 0.55 * SickProtection);

	elseif FoodEatenLevel == 4 then
		SOTOincreasePain(player, 100, "Torso_Lower", 1.2);
		SOTOincreaseFoodSickness(player, 100, 0.66 * SickProtection);
	end
end

Events.EveryOneMinute.Add(sensitivedigestionmain);

-- SENSITIVE DIGESTION TRAIT - DISCOMFORT
function sensitivedigestiondiscomfort()
	
	local player = getPlayer();
	if player == nil then return end
	
	if not player:hasTrait(SOTO.CharacterTrait.SENSITIVE_DIGESTION) then return end

	local FoodEatenLevel = player:getMoodles():getMoodleLevel(MoodleType.FOOD_EATEN);
	local currentDiscomfort = player:getStats():get(CharacterStat.DISCOMFORT);

	-- Discomfort modifier from clothes
	local wornItems = player:getWornItems();
	local totalModifier = 0;

	for i = 0, wornItems:size() - 1 do
		local item = wornItems:get(i):getItem();
		if item and item:IsClothing() then
			totalModifier = totalModifier + item:getDiscomfortModifier();
		end
	end

	local modifierPercent = totalModifier * 100;
	local discomfortLimit = 0;
	--local discomfortAmount = 0

	if FoodEatenLevel == 1 then
		--discomfortLimit = 20 + modifierPercent;
		--discomfortAmount = 0.05;

	elseif FoodEatenLevel == 2 then
		discomfortLimit = 25 + modifierPercent;
		--discomfortAmount = 0.1;

	elseif FoodEatenLevel == 3 then
		discomfortLimit = 45 + modifierPercent;
		--discomfortAmount = 0.15;

	elseif FoodEatenLevel == 4 then
		discomfortLimit = 85 + modifierPercent;
		--discomfortAmount = 0.1;
	end

	if currentDiscomfort < discomfortLimit then
		SOTOsetDiscomfort(player, discomfortLimit);
		--player:getStats():set(CharacterStat.DISCOMFORT, discomfortLimit);
	end
end

Events.OnTick.Add(sensitivedigestiondiscomfort);

-- PANIC ATTACKS TRAIT - MAIN
function panicattackstrait ()
	
	local player = getPlayer();
	if player == nil then return end
	
	local playersurvivedhours = player:getHoursSurvived();	
	local stats = player:getStats();
	local currpanic = stats:get(CharacterStat.PANIC);
	local speedcontrolforpa = UIManager.getSpeedControls();
	local gamespeedforpa = speedcontrolforpa:getCurrentGameSpeed();	
	local betaEffect = player:getBetaEffect()
	
	if player:hasTrait(SOTO.CharacterTrait.PANIC_ATTACKS) and betaEffect <= 0 then

		PAchancecalc = 864 + (playersurvivedhours * 0.4);
		PAchance = ZombRand(PAchancecalc);

		if PAchance == 0 then
		-- Panic attack while sleeping	
		if player:isAsleep() then
			forceAwakechance = ZombRand(12);
			if forceAwakechance == 0 then
				player:forceAwake();
				getSoundManager():PlaySound("ZombieSurprisedPlayer", false, 0):setVolume(0.50);			
				-- player:playEmote("soshiver");
				player:setVariable("Ext", "Shiver");
				player:reportEvent("EventDoExt");			
				SOTOincreasePanic(player, 100, (ZombRand(21)+80));
				SOTOincreaseStress(player, 100, 0.60);
				SOTOincreaseWetness(player, 100, (ZombRand(31)+20));
			end
		end
		-- Panic attack not sleeping	
		if not player:isAsleep() then		
			if gamespeedforpa <= 3 then
				getSoundManager():PlaySound("ZombieSurprisedPlayer", false, 0):setVolume(0.25);			
			end
			-- player:playEmote("soshiver");
			player:setVariable("Ext", "Shiver");
			player:reportEvent("EventDoExt");		
			SOTOincreasePanic(player, 100, (ZombRand(31)+70));
			SOTOincreaseStress(player, 100, 0.30);
			-- SOTOincreaseWetness(player, 100, (ZombRand(31)+10));
			end
		end
		--	Panic increase		
		if currpanic >= 10 and currpanic <= 49 then
			SOTOincreasePanic(player, 100, (ZombRand(3)+1));	
		end
		if currpanic >= 50 and currpanic <= 79 then
			SOTOincreasePanic(player, 66, (ZombRand(5)+1));	
		end	
		if currpanic >= 80 then
			SOTOincreasePanic(player, 33, (ZombRand(10)+1));	
		end	
		-- print("PAchancecalc: " .. PAchancecalc);			
		-- print("PAchance: " .. PAchance);	
	end		
end

-- ALLERGIC TRAIT - MAIN
function allergictrait ()

	local player = getPlayer();
	if player == nil then return end
	
	if player:hasTrait(SOTO.CharacterTrait.ALLERGIC) and not player:isAsleep() then
		local itemmh = player:getPrimaryHandItem();
		local itemsh = player:getSecondaryHandItem();
		if player:hasTrait(CharacterTrait.PRONE_TO_ILLNESS) then
		AllergicSneezeChance = 230;
			else AllergicSneezeChance = 288;
		end
		-- print("AllergicSneezeChance: " .. AllergicSneezeChance);		
		if ZombRand(AllergicSneezeChance) == 0 then
			-- Sneezing
			if not player:hasEquipped("Base.ToiletPaper") and not player:hasEquipped("Base.Tissue") then
				player:Say(getText("IGUI_PlayerText_Sneeze"));	
				if not player:isOutside() then	
					addSound(player, player:getX(), player:getY(), player:getZ(), 20, 50); -- range, then volume
					else 
					addSound(player, player:getX(), player:getY(), player:getZ(), 40, 100); -- range, then volume
				end
--				player:playEmote("sosneeze");
				player:setVariable("Ext", "Sneeze2");
				player:reportEvent("EventDoExt");		
				player:playerVoiceSound("SneezeHeavy");
			end
			-- Sneezing Toilet Paper			
			if player:hasEquipped("Base.ToiletPaper") or player:hasEquipped("Base.Tissue") then
				if ZombRand(2) == 0 then			
					if itemmh and itemmh:getType() == "ToiletPaper" then
					itemmh:Use();
						elseif itemsh and itemsh:getType() == "ToiletPaper" then
						itemsh:Use();
							elseif itemmh and itemmh:getType() == "Tissue" then
							itemmh:Use();
								elseif itemsh and itemsh:getType() == "Tissue" then
								itemsh:Use();				
					end
				end
				player:Say(getText("IGUI_PlayerText_SneezeMuffled"));
				addSound(player, player:getX(), player:getY(), player:getZ(), 3, 10); -- range, then volume
				player:setVariable("Ext", "Sneeze2");
				player:reportEvent("EventDoExt");
				player:playerVoiceSound("SneezeLight");
			end
		end
	end
	
end

--[[ SNORER TRAIT - MAIN
function snorertrait ()
	local player = getPlayer();
	if player:hasTrait(SOTO.CharacterTrait.SNORER) and player:isAsleep() then
		if ZombRand(30) == 0 then
			if not player:isOutside() then	
			addSound(player, player:getX(), player:getY(), player:getZ(), 10, 20); -- range, then volume
				else 
				addSound(player, player:getX(), player:getY(), player:getZ(), 20, 40); -- range, then volume
			end	
		end
		if ZombRand(300) == 0 then
			if not player:isOutside() then	
			addSound(player, player:getX(), player:getY(), player:getZ(), 14, 30); -- range, then volume
				else 
				addSound(player, player:getX(), player:getY(), player:getZ(), 28, 60); -- range, then volume
			end	
		end		
	end
end
]]

-- SMOKER TRAIT - MAIN
function smokertraitmain ()
	
	local player = getPlayer();
	if player == nil then return end
	
	local EnduranceMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.ENDURANCE);
	
	if player:hasTrait(CharacterTrait.SMOKER) and not player:isAsleep() then	
		if EnduranceMoodleLevel >= 1 then
			local AsthmaticMult	= 1;
			local EndSmokeScale = 1;
			local EndSmokeCoughRange = 20;
			if player:hasTrait(CharacterTrait.ASTHMATIC) then AsthmaticMult = 0.7 end	
			if EnduranceMoodleLevel == 1 then
				EndSmokeCoughChance = 1;
				EndSmokeCoughRange = 15;	
				elseif EnduranceMoodleLevel == 2 then
				EndSmokeCoughChance = 0.8;
				EndSmokeCoughRange = 18;	
				elseif EnduranceMoodleLevel == 3 then
				EndSmokeCoughChance = 0.6;
				EndSmokeCoughRange = 22;					
				elseif EnduranceMoodleLevel == 4 then
				EndSmokeCoughChance = 0.4; 
				EndSmokeCoughRange = 26;
			end			
				
			local SmokerCoughChance = ((100 * EndSmokeCoughChance) * AsthmaticMult * EndSmokeScale) -- 2.0% per min
			if ZombRand(SmokerCoughChance) == 0 then
				-- Coughing
				if not player:hasEquipped("Base.ToiletPaper") and not player:hasEquipped("Base.Tissue") then
					player:Say(getText("IGUI_PlayerText_Cough"));	
					if not player:isOutside() then	
						addSound(player, player:getX(), player:getY(), player:getZ(), (EndSmokeCoughRange * 0.5), 50); -- range, then volume
						else 
						addSound(player, player:getX(), player:getY(), player:getZ(), EndSmokeCoughRange, 100); -- range, then volume
					end
					player:setVariable("Ext", "Cough");
					player:reportEvent("EventDoExt");
					player:playerVoiceSound("Cough");
				end
				-- Coughing Muffled		
				if player:hasEquipped("Base.ToiletPaper") or player:hasEquipped("Base.Tissue") then
					if ZombRand(2) == 0 then			
						if itemmh and itemmh:getType() == "ToiletPaper" then
						itemmh:Use();
							elseif itemsh and itemsh:getType() == "ToiletPaper" then
							itemsh:Use();
								elseif itemmh and itemmh:getType() == "Tissue" then
								itemmh:Use();
									elseif itemsh and itemsh:getType() == "Tissue" then
									itemsh:Use();
						end
					end
					player:Say(getText("IGUI_PlayerText_CoughMuffled"));
					addSound(player, player:getX(), player:getY(), player:getZ(), (EndSmokeCoughRange * 0.1), 10); -- range, then volume
					player:setVariable("Ext", "Cough");
					player:reportEvent("EventDoExt");
					player:playerVoiceSound("Cough");
				end
			end	
		end
				
		-- ENDURANCE LOSS IF RUNNING	
		if player:isPlayerMoving() and player:IsRunning() == true then
			-- player:Say("smoke run");
			SOTOdecreaseEndurance(player, 50, 0.00033);
		end
	end
	
end

function smokeroftenandhunger()

	local player = getPlayer();
	if player == nil then return end

	if player:hasTrait(CharacterTrait.SMOKER) and not player:isAsleep() then	
		local CheckTimeSinceLastSmoke = player:getTimeSinceLastSmoke();	
		-- Smoke more often
		if ZombRand(50) == 0 and CheckTimeSinceLastSmoke <= 9 then
			--print("Added 1 hour to time")
			
			SOTOsetTimeSinceLastSmoke(player, CheckTimeSinceLastSmoke + 1)
			--player:setTimeSinceLastSmoke(TimeSinceLastSmoke + 1);
			elseif CheckTimeSinceLastSmoke > 10 then 
			SOTOsetTimeSinceLastSmoke(player, 10)
		end
		-- Smoker reduce hunger
		if CheckTimeSinceLastSmoke <= 6 then
			--print("Smoker reduce hunger")
			SOTOdecreaseHunger(player, 55, 0.0005);
		else
		-- Smoker increase hunger
		-- if CheckTimeSinceLastSmoke >= 9 then
			--print("Smoker increase hunger")
			SOTOincreaseHunger(player, 45, 0.0005);
		end
	end
	
end

-- SMOKER TRAIT - SWING ENDUR LOSS
function smokerattack(player, weapon)

	local player = getPlayer();
	if player == nil then return end

	if player:hasTrait(CharacterTrait.SMOKER) then
		local AsthmaticMult
		-- return if Bare Hands
		if weapon:getType() == "UNARMED" then
			return
		end
		-- get item stats
		local WeaponInPrimaryHand = player:getPrimaryHandItem();
		local WeaponInSecondaryHand = player:getSecondaryHandItem();	
		-- if no mainhaind weapon then return
		if WeaponInPrimaryHand == nil then
			return
		end
		if WeaponInPrimaryHand:IsWeapon() then 
			--player:Say("Smoker WEAPON swing");
			local WeaponEndMod = WeaponInPrimaryHand:getEnduranceMod();
			local WeaponWeight = WeaponInPrimaryHand:getWeight();
			if player:hasTrait(CharacterTrait.ASTHMATIC) then			
				AsthmaticMult = 1.3
					else AsthmaticMult = 1
			end				
			-- Endurance formula	
			local RWeaponEndCost = ((WeaponWeight * 0.003) * WeaponEndMod) * AsthmaticMult;	
			local RWeaponEndCost = round(RWeaponEndCost,6);
			-- Loses endurance while swing with chance
			SOTOdecreaseEndurance(player, 10, (RWeaponEndCost * 0.33));
			--print("Smoker swing: " .. (RWeaponEndCost * 0.5))
			--player:Say("Smoker NOT WEAPON");
		end
	end
	
end

-- HIKER TRAIT - MAIN REGEN
function hikertrait ()
	
	local player = getPlayer();
	if player == nil then return end
	
	local modData = player:getModData();
	
	if modData.SOminutesWalking == nil then
		modData.SOminutesWalking = 0;
	end		
	if player:hasTrait(CharacterTrait.HIKER) then 
		if player:isPlayerMoving() and player:IsRunning() == false and player:isSprinting() == false and player:isSneaking() == false then
			modData.SOminutesWalking = modData.SOminutesWalking + 1;
			else
				modData.SOminutesWalking = modData.SOminutesWalking - 3;
		end
		if modData.SOminutesWalking >= 10 then
			SOTOdecreaseFatigue(player, 100, 0.000125);
			SOTOdecreaseThirst(player, 100, 0.000125);	
			SOTOdecreaseHunger(player, 100, 0.000125);		
		end
		if modData.SOminutesWalking > 13 then
			modData.SOminutesWalking = 13;
			elseif modData.SOminutesWalking < 0 then
			modData.SOminutesWalking = 0;
		end	
	end
	
end

-- OPTIMISTIC TRAIT - HOURS UNTIL DEPRESSION
function hoursindepression ()
	
	local player = getPlayer();
	if player == nil then return end
	
	local modData = player:getModData();
	
	if modData.SOhoursUntilDepression == nil then
		modData.SOhoursUntilDepression = 0;
	end
	
	if player:hasTrait(SOTO.CharacterTrait.OPTIMISTIC) then
		if player:getStats():get(CharacterStat.UNHAPPINESS) >= 39 then
			modData.SOhoursUntilDepression = modData.SOhoursUntilDepression + 1;
			else
				modData.SOhoursUntilDepression = modData.SOhoursUntilDepression - 2;
		end
		if modData.SOhoursUntilDepression > 168 then
		modData.SOhoursUntilDepression = 168;
			elseif modData.SOhoursUntilDepression < 0 then
			modData.SOhoursUntilDepression = 0;
		end	
	-- print("SOhoursUntilDepression = " .. player:getModData().SOhoursUntilDepression)
	end
	
end

-- OPTIMISTIC TRAIT - MAIN
function optimisttrait ()
	
	local player = getPlayer();
	if player == nil then return end
	
	local modData = player:getModData();
	--local currentUnhappiness = player:getStats():get(CharacterStat.UNHAPPINESS);	
	if modData.SOhoursUntilDepression == nil then
		modData.SOhoursUntilDepression = 0;
	end
	if player:hasTrait(SOTO.CharacterTrait.OPTIMISTIC) and not player:isAsleep() and modData.SOhoursUntilDepression <= 32 then
		if player:getStats():get(CharacterStat.UNHAPPINESS) >= 50 then
			SOSetUnhappiness(player, 49);
			-- player:getStats():set(CharacterStat.UNHAPPINESS,49);	
		end
	end
	
end

-- OPTIMISTIC TRAIT - BOREDOOM
function optimistraitbored ()
	
	local player = getPlayer();
	if player == nil then return end
	
	local boredoommod = 0.045;
	
	if player:hasTrait(SOTO.CharacterTrait.OPTIMISTIC) then
		-- passive reducing boredoom		
		if not player:isAsleep() then
			SOTOdecreaseBoredom(player, 100, boredoommod);	
		end
		-- more reducing boredoom while sleeping	
		if player:isAsleep() then	
			SOTOdecreaseBoredom(player, 100, (boredoommod * 2));
		end	
	end
	
end

-- DEPRESSIVE TRAIT - MAIN
function depressivemoodtrait()
	
	local player = getPlayer();
	if not player or not player:hasTrait(SOTO.CharacterTrait.DEPRESSIVE) or player:isAsleep() then
		return
	end
	
	local unhappinessChance = 5;
	
	if RainManager:isRaining() then
		unhappinessChance = 10;
	end
	SOTOincreaseUnhappiness(player, unhappinessChance, (ZombRand(5) + 1));
	
end

Events.EveryTenMinutes.Add(depressivemoodtrait)

-- DEPRESSIVE EPISODE SYSTEM
local isDepressiveEpisodeActive = false;
local depressiveEpisodeTimer = 0;
local depressiveEpisodeDuration = 60; -- в минутах
local depressiveEpisodeAddPerMinute = 0;
local depressiveEpisodeCooldown = 120; -- кулдаун в минутах
local depressiveEpisodeCooldownTimer = 0;

function depressivemoodepisode()
    
	local player = getPlayer();
	if not player or not player:hasTrait(SOTO.CharacterTrait.DEPRESSIVE) or player:isAsleep() then
		return
	end

	-- if the episode is not active and the cooldown is over, a chance to start a new one
    if not isDepressiveEpisodeActive and depressiveEpisodeCooldownTimer <= 0 then
        if ZombRand(1440) == 0 then --1440
            local totalUnhappiness = ZombRand(51, 101); -- 50-100
            depressiveEpisodeAddPerMinute = totalUnhappiness / depressiveEpisodeDuration;
            isDepressiveEpisodeActive = true;
            depressiveEpisodeTimer = 0;
            --print("Depressive episode started: +" .. totalUnhappiness .. " over " .. depressiveEpisodeDuration .. " minutes.")
        end
    end

	-- if the episode is active, add misfortune and count the time
    if isDepressiveEpisodeActive then
        SOTOincreaseUnhappiness(player, 100, depressiveEpisodeAddPerMinute);
        depressiveEpisodeTimer = depressiveEpisodeTimer + 1;

        if depressiveEpisodeTimer >= depressiveEpisodeDuration then
            isDepressiveEpisodeActive = false;
            depressiveEpisodeTimer = 0;
            depressiveEpisodeCooldownTimer = depressiveEpisodeCooldown;
            --print("Depressive episode ended.")
        end

	-- if the episode is not active, we count the cooldown
    elseif depressiveEpisodeCooldownTimer > 0 then
        depressiveEpisodeCooldownTimer = depressiveEpisodeCooldownTimer - 1;
    end
	
end

Events.EveryOneMinute.Add(depressivemoodepisode)

-- CALM-MINDED - MAIN
function calmmindedtrait()
	
	local player = getPlayer();
	if player == nil then return end
	
	local stats = player:getStats();
	local currentStress = stats:get(CharacterStat.STRESS);
	local currentPanic = stats:get(CharacterStat.PANIC);
	local bodydamage = player:getBodyDamage();
	local infected = bodydamage:isInfected();

	if player:hasTrait(SOTO.CharacterTrait.CALMMINDED) then
		local modpanic = 1
		if currentStress > 0 and infected == false then
			SOTOdecreaseStress(player, 100, 0.01);
		end
		if currentPanic > 0 then
			if currentPanic >= 80 then modpanic = 3
				elseif currentPanic <= 79.9 and currentPanic >= 60 then modpanic = 2.5
				elseif currentPanic <= 59.9 and currentPanic >= 40 then modpanic = 2
				elseif currentPanic <= 39.9 and currentPanic >= 20 then modpanic = 1.5	
				elseif currentPanic <= 19.9 and currentPanic > 0 then modpanic = 1
			end
			SOTOdecreasePanic(player, 100, modpanic)
		end
	--print(string.format("DiscomfortLevel: %.3f", player:getBodyDamage():getDiscomfortLevel()))
	end

end

-- CALM-MINDED - LIMIT
function calmmindedstresslimit()

	local player = getPlayer();
	if player == nil then return end
	
	local stats = player:getStats();
	local currentStress = stats:get(CharacterStat.STRESS);
	local bodydamage = player:getBodyDamage();
	local infected = bodydamage:isInfected();	
	
	if player:hasTrait(SOTO.CharacterTrait.CALMMINDED) then
		if currentStress >= 0.5 and infected == false then
			SOTOsetStress(player, 0.5)
			--stats:set(CharacterStat.STRESS, 0.5)
		end
	end
	
end

-- COMMERCIAL DRIVER TRAIT - MAIN
function commdrivertrait()
	
	local player = getPlayer();
	if player == nil then return end
	
	local modData = player:getModData();
	if player:hasTrait(SOTO.CharacterTrait.COMMERCIAL_DRIVER) and not player:isAsleep() then
		if player:isDriving() == true then
			-- player:Say("wroom");		
			SOTOdecreaseFatigue(player, 50, 0.0015);
		end
	end
	
end

-- USED TO CORPSES TRAIT - MAIN
function gravemanjob(player)

	local player = getPlayer();
	if player == nil then return end
	
	local bodydamage = player:getBodyDamage();
	local foodSickness = player:getStats():get(CharacterStat.FOOD_SICKNESS);
	local poison = player:getStats():get(CharacterStat.POISON);
	local infected = bodydamage:isInfected();	
	--local newSickness = foodSickness - 1;
	local FoodEatenLevel = player:getMoodles():getMoodleLevel(MoodleType.FOOD_EATEN);

	if player:hasTrait(SOTO.CharacterTrait.USED_TO_CORPSES) then
		if foodSickness >= 1 and foodSickness <= 25 then 	
			if infected == false and poison == 0 then 	
				if player:hasTrait(SOTO.CharacterTrait.SENSITIVE_DIGESTION) and FoodEatenLevel == 0 then
					SOTOdecreaseFoodSickness(player, 100, 1);
					--print("Sickness protection with DS".. foodSickness)		
					elseif not player:hasTrait(SOTO.CharacterTrait.SENSITIVE_DIGESTION) then
					SOTOdecreaseFoodSickness(player, 100, 1);
					--print("Sickness protection".. foodSickness)	
				end
			end
		end
	end
	-- print("poison = " .. bodydamage:getPoisonLevel())	
end

-- LOW SWEATING - MAIN
function lesssweatytrait()	

	local player = getPlayer();
	if player == nil then return end
	
	local currentWetness = player:getStats():get(CharacterStat.WETNESS);
	local climateManager = getClimateManager();
	local currentRainIntensity = climateManager:getRainIntensity();
	
	if player:hasTrait(SOTO.CharacterTrait.LESSSWEATY) and currentWetness > 0 and not player:isAsleep() then
		-- if Inside House or Vehicle
		if not player:isOutside() or not player:getVehicle() == nil then
			if player:IsRunning() == false and player:isSprinting() == false then
			SOTOdecreaseWetness(player, 100, 0.1);
			elseif player:IsRunning() == true then
			SOTOdecreaseWetness(player, 100, 0.125);
			elseif player:isSprinting() == true then
			SOTOdecreaseWetness(player, 100, 0.15);
			end		
		end
		-- if Outside House or Vehicle	
		if player:isOutside() and player:getVehicle() == nil then
			-- If No Rain			
			if currentRainIntensity <= 0.09 then	
				if player:IsRunning() == false and player:isSprinting() == false then	
					SOTOdecreaseWetness(player, 100, 0.1);
					elseif player:IsRunning() == true then
					SOTOdecreaseWetness(player, 100, 0.125);
					elseif player:isSprinting() == true then
					SOTOdecreaseWetness(player, 100, 0.15);
				end		
			end
			-- if Medium Rain	
			if currentRainIntensity >= 0.10 and currentRainIntensity <= 0.39 then
				if player:IsRunning() == false and player:isSprinting() == false then	
					SOTOdecreaseWetness(player, 100, 0.05);
					elseif player:IsRunning() == true then
					SOTOdecreaseWetness(player, 100, 0.065);
					elseif player:isSprinting() == true then
					SOTOdecreaseWetness(player, 100, 0.08);
				end		
			end
			-- if Heavy Rain			
			if currentRainIntensity >= 0.40 then
				if player:IsRunning() == false and player:isSprinting() == false then	
					SOTOdecreaseWetness(player, 100, 0.025);
					elseif player:IsRunning() == true then
					SOTOdecreaseWetness(player, 100, 0.3);
					elseif player:isSprinting() == true then
					SOTOdecreaseWetness(player, 100, 0.35);
				end		
			end
		end
	end
	
end	

-- EXCESSIVE SWEATING TRAIT - MAIN
function highsweatytrait()	

	local player = getPlayer();
	if player == nil then return end
	
	local stats = player:getStats();
	local currpanic = stats:get(CharacterStat.PANIC);	

	if player:hasTrait(SOTO.CharacterTrait.HIGH_SWEATY) then 	
		-- if panic more than 25			
		if currpanic >= 25 then
			SOTOincreaseWetness(player, 25, 0.5);		
		end
		-- if panic more than 50		
		if currpanic >= 50 then
			SOTOincreaseWetness(player, 25, 0.5);		
		end		
		-- always 
		if player:IsRunning() == false and player:isSprinting() == false then
			SOTOincreaseThirst(player, 10, 0.0001);			
			SOTOincreaseWetness(player, 25, 0.25);
		end
		-- if running 		
		if player:IsRunning() == true then
			SOTOincreaseThirst(player, 25, 0.0002);		
			SOTOincreaseWetness(player, 50, 0.5);
		end
		-- if sprinting 		
		if player:isSprinting() == true then
			SOTOincreaseThirst(player, 50, 0.0003);		
			SOTOincreaseWetness(player, 100, 1);
		end		
	end
	
end

-- EXCESSIVE SWEATING TRAIT - ATTACK
function highsweatyattack(player, weapon)	
	
	local player = getPlayer();
	local weaponscriptItem = weapon:getScriptItem();
    
	if not weaponscriptItem then
		return
	end
	
	if player:hasTrait(SOTO.CharacterTrait.HIGH_SWEATY) and not player:isAsleep() then
		if not weaponscriptItem:containsWeaponCategory(WeaponCategory.UNARMED) then
			if weaponscriptItem:containsWeaponCategory(WeaponCategory.BLUNT) or weaponscriptItem:containsWeaponCategory(WeaponCategory.LONG_BLADE) or weaponscriptItem:containsWeaponCategory(WeaponCategory.SPEAR) or weaponscriptItem:containsWeaponCategory(WeaponCategory.AXE) then
				SOTOincreaseThirst(player, 28, 0.0001);			
				SOTOincreaseWetness(player, 50, 1);
			end
			if weaponscriptItem:containsWeaponCategory(WeaponCategory.SMALL_BLUNT) then
				SOTOincreaseThirst(player, 14, 0.0001);		
				SOTOincreaseWetness(player, 50, 0.5);
			end
			if weaponscriptItem:containsWeaponCategory(WeaponCategory.SMALL_BLADE) then
				SOTOincreaseThirst(player, 7, 0.0001);			
				SOTOincreaseWetness(player, 50, 0.25);
			end
		end	
		if weaponscriptItem:containsWeaponCategory(WeaponCategory.UNARMED) then
			if not player:isAimAtFloor() then
				SOTOincreaseThirst(player, 28, 0.0001);			
				SOTOincreaseWetness(player, 33, 0.5);
			end
			if player:isAimAtFloor() then
				SOTOincreaseThirst(player, 28, 0.0001);			
				SOTOincreaseWetness(player, 33, 0.5);
			end				
		end	
	end
	
end

-- PRONE TO ILLNESS - COLD
function pronetoillnesscold()

	local player = getPlayer();
	if player == nil then return end
	
	local ChanceToCatchACold;

	if player:hasTrait(CharacterTrait.PRONE_TO_ILLNESS) and player:isOutside() then
		if player:hasTrait(CharacterTrait.OUTDOORSMAN) then
			ChanceToCatchACold = 1440000; -- 0.1% per 24 hours with Outdoorsman
			else ChanceToCatchACold = 144000; -- 1.0% per 24 hours
		end
		if ZombRand(ChanceToCatchACold) == 0 and not player:getBodyDamage():isHasACold() then
--			player:Say("cold +");
			SOTOincreaseColdStrength(player, 35);	
		end
	end
	
end

-- LIFELONGER LEARNER
function lifelongerlearnertrait()

	local player = getPlayer();
	if player == nil then return end

	if player:hasTrait(SOTO.CharacterTrait.LIFELONG_LEARNER) and player:isReading() == true then
		SOTOdecreaseBoredom(player, 100, 1);	
	end

end

--[[ ENJOY THE RIDE TRAIT - MAIN
function enjoytheridetrait()
	local player = getPlayer();
	if player:hasTrait(SOTO.CharacterTrait.ENJOYTHERIDE) then	
	if player:isDriving() == true then
		local vehicle = player:getVehicle();
			if vehicle:getCurrentSpeedKmHour() >= 60 then
			SOTOdecreaseUnhappiness(player, 100, (ZombRand(5)+1));
			SOTOdecreaseBoredom(player, 100, 10);
			SOTOdecreaseStress(player, 100, 0.1);
			end
		end
	end		
end]]

-- FEAR OF THE DARK TRAIT - MAIN
function fearofthedarktrait() 

	local player = getPlayer();
	if player == nil then return end
	
	local stats = player:getStats();
	local currpanic = stats:get(CharacterStat.PANIC);	
	local vehicle = player:getVehicle();	
	local betaEffect = player:getBetaEffect();
	local currsquare = player:getCurrentSquare();
	if currsquare == nil then return end
	local lightLevel = currsquare:getLightLevel(player:getPlayerNum());
	-- print("betaEffect: " .. betaEffect);

	if player:hasTrait(SOTO.CharacterTrait.FEAR_OF_THE_DARK) and not player:isAsleep() and betaEffect <= 0 then
		local gamespeed = UIManager.getSpeedControls():getCurrentGameSpeed();
		local gsmultiplier = 1;
		if gamespeed == 1 then gsmultiplier = 1;
			elseif gamespeed == 2 then gsmultiplier = 5;
			elseif gamespeed == 3 then gsmultiplier = 20;
			elseif gamespeed == 4 then gsmultiplier = 40;
		end
		if vehicle ~= nil then
			if vehicle:getHeadlightsOn() then
			-- print("in car with headlight");
				return
			end
		-- print("in car");
		end
		-- print("lightLevel: " .. lightLevel);			
		if lightLevel <= 0.36 then
			if currpanic <= 15 then
				SOTOincreasePanic(player, 100, (0.1 * gsmultiplier));
			end
			if player:hasTrait(CharacterTrait.COWARDLY) then
				if currpanic >= 1 and currpanic <= 40 then
					SOTOincreasePanic(player, 100, (0.1 * gsmultiplier));
					elseif currpanic >= 1 and currpanic <= 20 then
						SOTOincreasePanic(player, 100, (0.05 * gsmultiplier));
				end	
			end
		end
	end	
--	print("lightLevel: " .. lightLevel);	
end

-- FEAR OF THE DARK TRAIT - STRESS
function fearofthedarkstress() 
	
	local player = getPlayer();
	if player == nil then return end
	
	local stats = player:getStats();
	local currentStress = stats:get(CharacterStat.STRESS);
	local vehicle = player:getVehicle();		
	
	if player:hasTrait(SOTO.CharacterTrait.FEAR_OF_THE_DARK) and not player:isAsleep() then
		if vehicle ~= nil then 
			if vehicle:getHeadlightsOn() then
			-- print("in car with headlight");		
				return
			end		
		-- print("in car");					
		end	
		local currentSquare = player:getCurrentSquare();
		if currentSquare == nil then
			return
		end
		local currentLightLevel = currentSquare:getLightLevel(player:getPlayerNum());
		if currentLightLevel <= 0.36 and currentStress <= 0.3 then
			SOTOincreaseStress(player, 100, 0.025);	
		end
	end
	
end

-- BRAWLER TRAIT - MAIN
function brawlerweapontrait(actor, target, weapon)
	
	local player = getPlayer();
	if player == nil then return end
	
	local weaponScriptItem = weapon:getScriptItem();
   
	if not weaponScriptItem then
		return
	end	
	
	if player:hasTrait(CharacterTrait.BRAWLER) then	
		if actor == player and target:isZombie() == true then
			if weaponScriptItem:containsWeaponCategory(WeaponCategory.BLUNT) or weaponScriptItem:containsWeaponCategory(WeaponCategory.LONG_BLADE) or weaponScriptItem:containsWeaponCategory(WeaponCategory.SPEAR) or weaponScriptItem:containsWeaponCategory(WeaponCategory.AXE) then
				SOTOdecreaseUnhappiness(player, 18, (ZombRand(5)+1));	
				--print("1");
			elseif weaponScriptItem:containsWeaponCategory(WeaponCategory.SMALL_BLUNT) then
				SOTOdecreaseUnhappiness(player, 18, (ZombRand(3)+1));	
					--print("2");
			elseif weaponScriptItem:containsWeaponCategory(WeaponCategory.SMALL_BLADE) or weaponScriptItem:containsWeaponCategory(WeaponCategory.UNARMED) then			
				SOTOdecreaseUnhappiness(player, 12, (ZombRand(2)+1));
					--print("3");
			end
		end
	end
	
end


-- CHOP TREE EXP
function choptreesexp(player, weapon)

	local player = getPlayer();
	if player == nil then return end
	
	local weaponScriptItem = weapon:getScriptItem();
	local weaponTreeDamage = player:getPrimaryHandItem():getTreeDamage();
   
	if not weaponScriptItem then
		return
	end	
	
	if weaponScriptItem:containsWeaponCategory(WeaponCategory.AXE) then
		--print("weaponTreeDamage: " .. weaponTreeDamage);	
		local TreeAxeChopXP = 0.0035 * weaponTreeDamage;
		if SOTOAxeLvl >= 5 then
			TreeAxeChopXP = TreeAxeChopXP * 0.37;
		end
		TreeAxeChopXP = round(TreeAxeChopXP, 3); -- round number to 0.000
		SOTOAddXP(player, Perks.Axe, TreeAxeChopXP);
		-- print("TreeAxeChopXP: " .. TreeAxeChopXP);	
	end
	
end

-- RUNNING FITNESS XP WITH MULTIPLIER & GROWING CHANCE + CELL CHECK
local runningXPProgress = {
	currentMultiplier = 1.0,
	maxMultiplier = 2.5,
	gainStep = 0.25,
	decayStep = 1.0,

	currentChance = 0.50,
	maxChance = 1.00,
	chanceGainStep = 0.03,
	chanceDecayStep = 0.15,

	lastX = nil,
	lastY = nil,
	lastZ = nil,
}

function runningFitnessXP()
	
	local player = getPlayer();
	if player == nil then return end
	
	local isRunning = player:isPlayerMoving() and player:IsRunning();
	local x = math.floor(player:getX());
	local y = math.floor(player:getY());
	local z = math.floor(player:getZ());
	local hasMoved = false;

	if not SOTOSbvars.AddFitXPWhileRun then
		return
	end

	if runningXPProgress.lastX ~= nil then
		hasMoved = (x ~= runningXPProgress.lastX) or (y ~= runningXPProgress.lastY) or (z ~= runningXPProgress.lastZ);
	end
	-- Debug: print position info
	-- print(string.format("Current Pos: (%d, %d, %d)", x, y, z))
	--if runningXPProgress.lastX then
		-- print(string.format("Previous Pos: (%d, %d, %d)", runningXPProgress.lastX, runningXPProgress.lastY, runningXPProgress.lastZ))
		-- print("Moved: " .. tostring(hasMoved))
	--end

	-- Save current position
	runningXPProgress.lastX = x;
	runningXPProgress.lastY = y;
	runningXPProgress.lastZ = z;

	if isRunning and hasMoved then
		-- Increase XP multiplier
		runningXPProgress.currentMultiplier = math.min(runningXPProgress.currentMultiplier + runningXPProgress.gainStep, runningXPProgress.maxMultiplier);
		-- Increase XP chance
		runningXPProgress.currentChance = math.min(runningXPProgress.currentChance + runningXPProgress.chanceGainStep, runningXPProgress.maxChance);
		if ZombRandFloat(0.0, 1.0) < runningXPProgress.currentChance then
			local xpAmount = runningXPProgress.currentMultiplier;
			SOTOAddXP(player, Perks.Fitness, xpAmount);
			--print(string.format("Fitness XP gained: %.2f | Chance: %.0f%%", xpAmount, runningXPProgress.currentChance * 100))
			else
			--print(string.format("Fitness XP skipped | Chance: %.0f%%", runningXPProgress.currentChance * 100))
		end
	else
		-- Decay multiplier
		if runningXPProgress.currentMultiplier > 1.0 then
			runningXPProgress.currentMultiplier = math.max(runningXPProgress.currentMultiplier - runningXPProgress.decayStep, 1.0);
			--print(string.format("Multiplier decayed to: %.2f", runningXPProgress.currentMultiplier))
		end
		-- Decay chance
		if runningXPProgress.currentChance > 0.5 then
			runningXPProgress.currentChance = math.max(runningXPProgress.currentChance - runningXPProgress.chanceDecayStep, 0.5);
			--print(string.format("Chance decayed to: %.0f%%", runningXPProgress.currentChance * 100))
		end
	end
	
end

-- WEAK BACK - PAIN
function weakbackpain()
	
	local player = getPlayer();
	if player == nil then return end

	if player:hasTrait(SOTO.CharacterTrait.WEAK_BACK) then
		local Neck = player:getBodyDamage():getBodyPart(BodyPartType.FromString("Neck"));		
		if Neck:getPain() <= 15 and player:getMoodles():getMoodleLevel(MoodleType.HEAVY_LOAD) == 4 then	
			SOTOincreasePain(player, 100, "Neck", (ZombRand(3)+2));	
			elseif Neck:getPain() <= 15 and player:getMoodles():getMoodleLevel(MoodleType.HEAVY_LOAD) == 3 then	
			SOTOincreasePain(player, 100, "Neck", (ZombRand(2)+1));	
		end
	end

end

-- FRAGILE HEALT TRAIT - HEAVY LOAD
function fragilehealthheavyload()

	local player = getPlayer();
	if player == nil then return end
	
	if player:hasTrait(SOTO.CharacterTrait.FRAGILE_HEALTH) and not player:isAsleep() then
		local HeavyLoadMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.HEAVY_LOAD);
		if HeavyLoadMoodleLevel >= 3 then
			if player:getBodyDamage():getOverallBodyHealth() >= 49.25 then
				for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
				local b = player:getBodyDamage():getBodyParts():get(i);
				b:AddDamage(0.25);
				end
			end
		end
	end	

end

-- CALORIES TRAITS - MAIN
function caloriestraits()

	local player = getPlayer();
	if player == nil then return end

	local currcalories = player:getNutrition():getCalories();
	local weight = player:getNutrition():getWeight();

	-- calories spend PER HOUR x 60
	local CalSleeping	= 0.18;
	local CalIdling		= 0.96;
	local CalWalking	= 1.73;
	local CalRunning	= 7.80;
	local CalSprinting	= 10.14;
	
	-- calories modifier
	local CalMod 		= 0.30 -- plus or minus 30% calories when doing actions
	
	-- adjusting calories
	-- calories when sleeping	
	if player:isAsleep() then
		if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) and weight <= 90 then -- Gain weight faster when below 90 weight
			SOTOincreaseCalories(player, (CalSleeping * CalMod));
			--player:getNutrition():setCalories(currcalories + (CalSleeping * CalMod))
		end
		if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) and weight >= 70 then -- Losing weight faster when weight over 70
			SOTOdecreaseCalories(player, (CalSleeping * CalMod));
			--player:getNutrition():setCalories(currcalories - (CalSleeping * CalMod))
		end		
	end
	-- calories when not sleeping	
	if not player:isAsleep() then
		-- calories when idling	
		if not player:isPlayerMoving() then
			if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) and weight <= 90 then -- Gain weight faster when below 90 weight
				SOTOincreaseCalories(player, (CalIdling * CalMod));
				--player:getNutrition():setCalories(currcalories + (CalIdling * CalMod))
			end
			if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) and weight >= 70 then -- Losing weight faster when weight over 70
				SOTOdecreaseCalories(player, (CalIdling * CalMod));
				--player:getNutrition():setCalories(currcalories - (CalIdling * CalMod))
			end		
		end	

		-- calories when walking		
		if player:isPlayerMoving() and player:IsRunning() == false and player:isSprinting() == false then
			if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) and weight <= 90 then -- Gain weight faster when below 90 weight
				SOTOincreaseCalories(player, (CalWalking * CalMod));
				--player:getNutrition():setCalories(currcalories + (CalWalking * CalMod))
			end
			if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) and weight >= 70 then -- Losing weight faster when weight over 70
				SOTOdecreaseCalories(player, (CalWalking * CalMod));
				--player:getNutrition():setCalories(currcalories - (CalWalking * CalMod))
			end		
		end	

		-- calories when running		
		if player:isPlayerMoving() and player:IsRunning() == true and player:isSprinting() == false then
			if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) and weight <= 90 then -- Gain weight faster when below 90 weight
				SOTOincreaseCalories(player, (CalRunning * CalMod));
				--player:getNutrition():setCalories(currcalories + (CalRunning * CalMod))
			end
			if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) and weight >= 70 then -- Losing weight faster when weight over 70
				SOTOdecreaseCalories(player, (CalRunning * CalMod));
				--player:getNutrition():setCalories(currcalories - (CalRunning * CalMod))
			end		
		end		

		-- calories when sprinting		
		if player:isPlayerMoving() and player:IsRunning() == false and player:isSprinting() == true then
			if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) and weight <= 90 then -- Gain weight faster when below 90 weight
				SOTOincreaseCalories(player, (CalSprinting * CalMod));
				--player:getNutrition():setCalories(currcalories + (CalSprinting * CalMod))
			end
			if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) and weight >= 70 then -- Losing weight faster when weight over 70
				SOTOdecreaseCalories(player, (CalSprinting * CalMod));
				--player:getNutrition():setCalories(currcalories - (CalSprinting * CalMod))
			end		
		end		
	end

end

-- CALORIES TRAITS - SWING
function caloriestraitsswing(player, weapon)

	local player = getPlayer();
	if player == nil then return end
	
	local currcalories = player:getNutrition():getCalories();
	local weight = player:getNutrition():getWeight();
	local calswingcost	 = 2.0;
	local calmod		 = 0.3;

	if weapon == nil then
		return
	end

	if weapon:getSwingAnim() == Heavy then
		calswingcost = 6.0;
	end
	if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) and weight <= 90 then -- Gain weight faster when below 90 weight
		SOTOincreaseCalories(player, (calswingcost * calmod));
	end
	if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) and weight >= 70 then -- Losing weight faster when weight over 70
		SOTOdecreaseCalories(player, (calswingcost * calmod));
	end
	
end

-- WEAPON TRAITS XP
local isMyWeaponXP = false

local function weapontraitsxp(player, perk, amount)

	if isMyWeaponXP then return end

	if not player or amount > 30 or amount < 0 then return end

	local baseAmount = amount;
	local totalModifier = 0;

	-- Check if perk is a valid weapon skill
	local isWeaponSkill = perk == Perks.Axe or perk == Perks.Blunt or perk == Perks.SmallBlunt
		or perk == Perks.LongBlade or perk == Perks.SmallBlade or perk == Perks.Spear
		or perk == Perks.Maintenance or perk == Perks.Aiming

	-- Cruelty bonus
	if player:hasTrait(SOTO.CharacterTrait.CRUELTY) and isWeaponSkill then
		totalModifier = totalModifier + 0.25;
	end

	-- CUTTING_TOOLS bonus
	if player:hasTrait(SOTO.CharacterTrait.CUTTING_TOOLS) then
		local weapon = player:getPrimaryHandItem();
		local offHand = player:getSecondaryHandItem();
		if weapon and weapon ~= offHand then
			local weaponscriptItem = weapon:getScriptItem();
			if not weaponscriptItem then return end	
			if weaponscriptItem then
				if weaponscriptItem:containsWeaponCategory(WeaponCategory.AXE) or weaponscriptItem:containsWeaponCategory(WeaponCategory.SMALL_BLADE) or weaponscriptItem:containsWeaponCategory(WeaponCategory.LONG_BLADE) then
					-- Only apply if related perk
					if perk == Perks.Axe or perk == Perks.SmallBlade or perk == Perks.LongBlade then
						totalModifier = totalModifier + 0.20;
					end
				end
			end
		end
	end

	-- If any modifier applied
	if totalModifier > 0 then
		local finalBonusXP = round(amount * totalModifier, 3);
		isMyWeaponXP = true
		SOTOAddXP(player, perk, finalBonusXP, false, false, false);		
		--player:getXp():AddXP(perk, finalBonusXP, false, false, false)
		isMyWeaponXP = false

		-- Debug
	local perkName = perk and perk:getName() or tostring(perk)
	--print(string.format("XP %s MODIFIER: %.2f | Base: %.3f | Bonus: %.3f | Final: %.3f", perkName, totalModifier, baseAmount, finalBonusXP, (baseAmount + finalBonusXP)))
	end
	
end

-- XP BODY TYPE TRAITS
local isMyBodyTypeFMSTRAddXP = false
local isMyBodyTypeFMFITAddXP = false
local isMyBodyTypeSMSTRAddXP = false
local isMyBodyTypeSMFITAddXP = false

function bodytypetraitsxp(player, perk, amount)
	
	if isMyBodyTypeFMSTRAddXP then return end
	if isMyBodyTypeFMFITAddXP then return end
	if isMyBodyTypeSMSTRAddXP then return end
	if isMyBodyTypeSMFITAddXP then return end

	local player = getPlayer();
	if player == nil then return end;
	
	if player:hasTrait(SOTO.CharacterTrait.FAST_METABOLISM) then
		local modifier = 0.30;
		if perk == Perks.Strength then
			if amount > 30 or amount < 0 then return end
--			print("STR XP: " .. amount); 
			amount = (amount * modifier) * -1;-- -30%		
			isMyBodyTypeFMSTRAddXP = true
			SOTOAddXP(player, perk, amount, false, false, false);
			--player:getXp():AddXP(perk, amount, false, false, false);
			isMyBodyTypeFMSTRAddXP = false
--			print("Str removed: " .. amount); 
		end
		if perk == Perks.Fitness then
			if amount > 30 or amount < 0 then return end
--			print("Fit XP: " .. amount); 
			amount = (amount * modifier);-- +30%	
			isMyBodyTypeFMFITAddXP = true	
			SOTOAddXP(player, perk, amount, false, false, false);
			--player:getXp():AddXP(perk, amount, false, false, false);
			isMyBodyTypeFMFITAddXP = false
--			print("Fit added: " .. amount); 			
		end		
	end	
	if player:hasTrait(SOTO.CharacterTrait.SLOW_METABOLISM) then
		local modifier = 0.30;	
		if perk == Perks.Fitness then
			if amount > 30 or amount < 0 then return end
			amount = (amount * modifier) * -1;-- -30%		
			isMyBodyTypeSMFITAddXP = true				
			SOTOAddXP(player, perk, amount, false, false, false);			
			--player:getXp():AddXP(perk, amount, false, false, false);
			isMyBodyTypeSMFITAddXP = false	
		end
		if perk == Perks.Strength then
			if amount > 30 or amount < 0 then return end
			amount = (amount * modifier);-- +30%		
			isMyBodyTypeSMSTRAddXP = true		
			SOTOAddXP(player, perk, amount, false, false, false);			
			--player:getXp():AddXP(perk, amount, false, false, false);
			isMyBodyTypeSMSTRAddXP = false	
		end		
	end	
end

-- DEPRESSIVE TRAIT - XP ALWAYS SHOULD BE LAST!
local isMyDepressiveAddXP = false

function depressivexp(player, perk, amount)

	if isMyDepressiveAddXP then return end

	local player = getPlayer();
	if player == nil then return end

	if player:hasTrait(SOTO.CharacterTrait.DEPRESSIVE) then
		local UnhappyMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType.UNHAPPY);
		local UnhappyXPMod = 0;
		if UnhappyMoodleLevel == 2 then UnhappyXPMod = 0.03;
		elseif UnhappyMoodleLevel == 3 then UnhappyXPMod = 0.06;
		elseif UnhappyMoodleLevel == 4 then UnhappyXPMod = 0.10;
		end	
		if UnhappyMoodleLevel >= 2 then
			if amount > 30 or amount < 0 then return end
			-- print("XP: " .. tostring(perk) .. amount); 			
			amount = -(amount * UnhappyXPMod)
			isMyDepressiveAddXP = true;
			SOTOAddXP(player, perk, amount, false, false, false);				
			isMyDepressiveAddXP = false;
			-- print("XP removed: " .. tostring(perk) .. amount); 
		end	
	end
	
end

-- EVENTS --
-- ON HIT TREE
Events.OnWeaponHitTree.Add(choptreesexp);
-- ON HIT
Events.OnWeaponHitCharacter.Add(brawlerweapontrait);
-- ON SWING
--OnWeaponSwing
Events.OnWeaponSwingHitPoint.Add(tirelesstrait);
Events.OnWeaponSwingHitPoint.Add(highsweatyattack);
Events.OnWeaponSwingHitPoint.Add(smokerattack);
Events.OnWeaponSwingHitPoint.Add(caloriestraitsswing);
-- ON TICK
Events.OnTick.Add(liquidbloodtrait);
Events.OnTick.Add(thickbloodtrait);
Events.OnTick.Add(optimisttrait);
Events.OnTick.Add(fearofthedarktrait);
Events.OnTick.Add(calmmindedstresslimit);
-- EVERY ONE MINUTE
Events.EveryOneMinute.Add(breathingtechtrait);
--Events.EveryOneMinute.Add(ninjawaytrait);
Events.EveryOneMinute.Add(marathonrunnertrait);
Events.EveryOneMinute.Add(runningFitnessXP);
Events.EveryOneMinute.Add(panicattackstrait);
Events.EveryOneMinute.Add(allergictrait);
Events.EveryOneMinute.Add(commdrivertrait);
Events.EveryOneMinute.Add(optimistraitbored);
Events.EveryOneMinute.Add(smokertraitmain);
Events.EveryOneMinute.Add(hikertrait);
Events.EveryOneMinute.Add(lesssweatytrait);
Events.EveryOneMinute.Add(highsweatytrait);
Events.EveryOneMinute.Add(fearofthedarkstress);
--Events.EveryOneMinute.Add(enjoytheridetrait);
Events.EveryOneMinute.Add(weakbackpain);
--Events.EveryOneMinute.Add(sensitivedigestiontrait);
--Events.EveryOneMinute.Add(snorertrait);
Events.EveryOneMinute.Add(pronetoillnesscold);
--Events.EveryOneMinute.Add(fragilehealthheavyload);
Events.EveryOneMinute.Add(caloriestraits);
Events.EveryOneMinute.Add(lifelongerlearnertrait);
Events.EveryOneMinute.Add(gravemanjob);
Events.EveryOneMinute.Add(tirelessmusclestrain);
Events.EveryOneMinute.Add(strongbackmusclestrain);
Events.EveryOneMinute.Add(calmmindedtrait);
-- EVERY TEN MINUTES
Events.EveryTenMinutes.Add(larkpersontrait);
Events.EveryTenMinutes.Add(owlpersontrait);
Events.EveryTenMinutes.Add(depressivemoodtrait);
Events.EveryTenMinutes.Add(smokeroftenandhunger);
Events.EveryTenMinutes.Add(chronicmigrainetrait)
-- EVERY HOUR
Events.EveryHours.Add(hoursindepression);
--Events.EveryHours.Add(SOcheckWeight);
-- ADD EXP
Events.AddXP.Add(weapontraitsxp)
Events.AddXP.Add(depressivexp);
Events.AddXP.Add(bodytypetraitsxp);
-- ON GAME START
--Events.OnGameStart.Add(SOcheckWeight);
-- ON CREATE PLAYER
--Events.OnCreatePlayer.Add(SOcheckWeight);
--

-- FIX NOT SMOKER STRESS
function fixnotsmokerstress()
	
	local player = getPlayer();
	
	if not player:hasTrait(CharacterTrait.SMOKER) then
		if player:getStats():get(CharacterStat.NICOTINE_WITHDRAWAL) > 0 then
			--player:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, 0)
			SOSetCigStress(player, 0);
			--print("NICOTINE_WITHDRAWAL BEGONE")
		end
		if player:getTimeSinceLastSmoke() > 0 then	
			--player:setTimeSinceLastSmoke(0);	
			SOTOsetTimeSinceLastSmoke(player, 0)
			--print("TimeSinceLastSmoke BEGONE")
		end
	end
	
end

Events.OnGameStart.Add(fixnotsmokerstress); --OnGameStart

--[[
function debugeveryonemin()
	local player = getPlayer(); 
	local bodydamage = player:getBodyDamage();
	local STEffect = player:getSleepingTabletEffect()
	local PillsTaken = player:getSleepingPillsTaken()
	print("STEffect = " .. STEffect)	
	print("PillsTaken = " .. PillsTaken)	
--	print("Every one min");	
end
Events.EveryOneMinute.Add(debugeveryonemin);]]
	
	--[[
function debuglocation()
print("[DEBUG] trait =", trait)

local rl = ResourceLocation.of(trait)
print("[DEBUG] namespace =", rl:getNamespace())
print("[DEBUG] path =", rl:getPath())

end]]


--[[
local function test111()

	local player = getPlayer();
	if player == nil then
		return
	end
	
	local mhweapontype
	local ohweapontype
	
--	local wmainga = player:getPrimaryHandItem();
--	local woffHand = player:getSecondaryHandItem();
	local mhweapon = player:getPrimaryHandItem()
	local ohweapon = player:getSecondaryHandItem()
	if mhweapon ~= nil then 
	mhweapontype = mhweapon:getType()	
	print("mhweapontype: " .. mhweapontype); 
	end	
	if ohweapon ~= nil then
	ohweapontype = ohweapon:getType()
	print("ohweapontype: " .. ohweapontype); 	
	end	

	if mhweapon and mhweapon ~= ohweapon then
	print("OK");
		local weaponscriptItem = mhweapon:getScriptItem()
	--print("weaponscriptItem: " .. weaponscriptItem); 			
		
		if not weaponscriptItem then return end	
		if weaponscriptItem then
			if weaponscriptItem:containsWeaponCategory(WeaponCategory.AXE) then 
			player:Say("Axe")
			elseif weaponscriptItem:containsWeaponCategory(WeaponCategory.SMALL_BLADE) then 
			player:Say("SmallBlade")
			elseif weaponscriptItem:containsWeaponCategory(WeaponCategory.LONG_BLADE) then
			player:Say("LongBlade");
			end
		end
	
	
--	print("offHand: " .. player:getSecondaryHandType());	
	

	end

	if offHand == nil then
	return
	end		

end]]


--Events.EveryOneMinute.Add(test111)


local weeeeeecounter = 0   -- счётчик вне функции

local function weeeeee()
    weeeeeecounter = weeeeeecounter + 1
    print("weeeeeecounter " .. weeeeeecounter)
end

--Events.OnTick.Add(weeeeee)

local opucounter = 0   -- счётчик вне функции

local function opu()
    opucounter = opucounter + 1
    print("opucounter " .. opucounter)
end

--Events.OnPlayerUpdate.Add(opu)


function ifweaponcheck()

	local player = getPlayer();
	if player == nil then
		return
	end

    local weapon = player:getPrimaryHandItem()
    if not weapon then
        -- print("No weapon in primary hand")
        return
    end

	local endurancemod = weapon:getEnduranceMod()
	local doordamage = weapon:getDoorDamage()

	print("endurancemod: " .. endurancemod)
	print("doordamage: " .. doordamage)

	--if weapon:IsWeapon() then 
	--print("weapon");
	--else 
	--print("NOT weapon");
	--end	

end

--Events.EveryOneMinute.Add(ifweaponcheck)

-- Visual feedback and perk boost sync from server-side trait changes
Events.OnServerCommand.Add(function(module, command, args)
	if module ~= "SOTO" then return end
	local player = getPlayer();
	if not player then return end

	if command == "TraitFX" then
		getSoundManager():PlaySound("GainExperienceLevel", false, 0):setVolume(0.50);
		if args and args.textKey then
			HaloTextHelper.addTextWithArrow(player, getText(args.textKey), args.gained, HaloTextHelper.getColorGreen());
		end

	elseif command == "SyncMaxWeight" then
		if args and args.weight then
			player:setMaxWeightBase(args.weight)
		end

	elseif command == "SyncPerkBoost" then
		-- Server set a perkBoost but it doesn't sync automatically, so apply it on the client too.
		-- tostring(perk) produces the perk name string (e.g. "LongBlade") on both sides.
		if args and args.perkStr and args.boost then
			local perkLookup = {
				["Sneak"]          = Perks.Sneak,
				["Lightfoot"]      = Perks.Lightfoot,
				["Sprinting"]      = Perks.Sprinting,
				["Nimble"]         = Perks.Nimble,
				["PlantScavenging"]= Perks.PlantScavenging,
				["Fishing"]        = Perks.Fishing,
				["Trapping"]       = Perks.Trapping,
				["Tracking"]       = Perks.Tracking,
				["Doctor"]         = Perks.Doctor,
				["Cooking"]        = Perks.Cooking,
				["Farming"]        = Perks.Farming,
				["Woodwork"]       = Perks.Woodwork,
				["Electricity"]    = Perks.Electricity,
				["Mechanics"]      = Perks.Mechanics,
				["MetalWelding"]   = Perks.MetalWelding,
				["Tailoring"]      = Perks.Tailoring,
				["Carving"]        = Perks.Carving,
				["Masonry"]        = Perks.Masonry,
				["Pottery"]        = Perks.Pottery,
				["Glassmaking"]    = Perks.Glassmaking,
				["Blacksmith"]     = Perks.Blacksmith,
				["FlintKnapping"]  = Perks.FlintKnapping,
				["Husbandry"]      = Perks.Husbandry,
				["Butchering"]     = Perks.Butchering,
				["Maintenance"]    = Perks.Maintenance,
				["SmallBlade"]     = Perks.SmallBlade,
				["SmallBlunt"]     = Perks.SmallBlunt,
				["Axe"]            = Perks.Axe,
				["Spear"]          = Perks.Spear,
				["LongBlade"]      = Perks.LongBlade,
				["Blunt"]          = Perks.Blunt,
				["Aiming"]         = Perks.Aiming,
				["Reloading"]      = Perks.Reloading,
			};
			local p = perkLookup[args.perkStr];
			if p then
				player:getXp():setPerkBoost(p, args.boost);
			end
		end
	end
end)