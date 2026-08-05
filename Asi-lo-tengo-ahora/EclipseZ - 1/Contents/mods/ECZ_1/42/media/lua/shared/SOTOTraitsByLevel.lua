------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

---------------------
-- TRAITS BY LEVEL --
---------------------

local SOTOSbvars = SandboxVars.SOTO;

-- Fallback definitions used when server/ functions are not loaded (client-side path).
if not SOTOaddTrait then
	function SOTOaddTrait(player, trait)
		if not player:hasTrait(trait) then
			player:getCharacterTraits():add(trait);
		end
	end
end
if not SOTOremoveTrait then
	function SOTOremoveTrait(player, trait)
		if player:hasTrait(trait) then
			player:getCharacterTraits():remove(trait);
		end
	end
end
if not SOTOincreaseExpBoost then
	-- Fallback: SET boost to max(current, targetBoost), never stacks on re-level.
	function SOTOincreaseExpBoost(player, perk, targetBoost)
		local currentXPBoost = player:getXp():getPerkBoost(perk);
		local finalBoost = math.min(math.max(currentXPBoost, targetBoost), 3);
		player:getXp():setPerkBoost(perk, finalBoost);
	end
end

-- Send trait-change halo text + sound to the player's client via server command.
-- Works in SP (isServer()=true, sendServerCommand fires OnServerCommand locally).
local function SOTOlevelFX(player, textKey, gained)
	sendServerCommand(player, "SOTO", "TraitFX", {textKey = textKey, gained = gained});
end

function SOTOlevelPerk(player, perk, perkLevel, addBuffer)
	SOTOsetTraitsByLevel(player, perk, perkLevel);
end

Events.LevelPerk.Add(SOTOlevelPerk);

function SOTOsetTraitsByLevel(player, perk, perkLevel)
	-- All trait/boost changes must happen server-side so they sync correctly.
	if not isServer() then return end
	-- STRENGTH
	if perk == Perks.Strength then
		if perkLevel >= 8 and player:getPerkLevel(Perks.Fitness) >= 8 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
			SOTOremoveTrait(player, SOTO.CharacterTrait.SLACK);
			SOTOlevelFX(player, "UI_trait_slack", false);
		end
	end

	-- FITNESS
	if perk == Perks.Fitness then
		if perkLevel >= 8 and player:getPerkLevel(Perks.Strength) >= 8 and player:hasTrait(SOTO.CharacterTrait.SLACK) then
			SOTOremoveTrait(player, SOTO.CharacterTrait.SLACK);
			SOTOlevelFX(player, "UI_trait_slack", false);
		end
	end

	-- SNEAK
	if perk == Perks.Sneak then
		if SOTOSbvars.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(SOTO.CharacterTrait.SNEAKY) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SNEAKY);
			SOTOincreaseExpBoost(player, Perks.Sneak, 1);
			SOTOlevelFX(player, "UI_trait_sneaky", true);
		end
		if SOTOSbvars.AgilityTraitsObtainable == true and perkLevel >= 5 and player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(SOTO.CharacterTrait.SNEAKY) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SNEAKY);
			SOTOincreaseExpBoost(player, Perks.Sneak, 1);
			SOTOlevelFX(player, "UI_trait_sneaky", true);
		end
		if SOTOSbvars.InconspicuousEarnable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.CONSPICUOUS) and not player:hasTrait(CharacterTrait.INCONSPICUOUS) then
			SOTOaddTrait(player, CharacterTrait.INCONSPICUOUS);
			SOTOlevelFX(player, "UI_trait_Inconspicuous", true);
		end
		if SOTOSbvars.ConspicuousRemovable == true and perkLevel == 6 and player:hasTrait(CharacterTrait.CONSPICUOUS) then
			SOTOremoveTrait(player, CharacterTrait.CONSPICUOUS);
			SOTOlevelFX(player, "UI_trait_Conspicuous", false);
		end
	end

	-- LIGHTFOOT
	if perk == Perks.Lightfoot then
		if SOTOSbvars.AgilityTraitsObtainable == true and perkLevel >= 4 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and not player:hasTrait(CharacterTrait.CLUMSY) then
			SOTOaddTrait(player, SOTO.CharacterTrait.LIGHTFOOTED);
			SOTOincreaseExpBoost(player, Perks.Lightfoot, 1);
			SOTOlevelFX(player, "UI_trait_lightfooted", true);
		end
		if SOTOSbvars.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.LIGHTFOOTED) and player:hasTrait(CharacterTrait.CLUMSY) then
			SOTOaddTrait(player, SOTO.CharacterTrait.LIGHTFOOTED);
			SOTOincreaseExpBoost(player, Perks.Lightfoot, 1);
			SOTOlevelFX(player, "UI_trait_lightfooted", true);
		end
		if SOTOSbvars.GracefulEarnable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.CLUMSY) and not player:hasTrait(CharacterTrait.GRACEFUL) then
			SOTOaddTrait(player, CharacterTrait.GRACEFUL);
			SOTOlevelFX(player, "UI_trait_graceful", true);
		end
		if SOTOSbvars.ClumsyRemovable == true and perkLevel == 6 and player:hasTrait(CharacterTrait.CLUMSY) then
			SOTOremoveTrait(player, CharacterTrait.CLUMSY);
			SOTOlevelFX(player, "UI_trait_clumsy", false);
		end
	end

	-- SPRINTING
	if perk == Perks.Sprinting then
		if SOTOSbvars.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(CharacterTrait.JOGGER) then
			SOTOaddTrait(player, CharacterTrait.JOGGER);
			SOTOincreaseExpBoost(player, Perks.Sprinting, 1);
			SOTOlevelFX(player, "UI_trait_Jogger", true);
		end
	end

	-- NIMBLE
	if perk == Perks.Nimble then
		if SOTOSbvars.AgilityTraitsObtainable == true and perkLevel >= 5 and not player:hasTrait(SOTO.CharacterTrait.AGILE) then
			SOTOaddTrait(player, SOTO.CharacterTrait.AGILE);
			SOTOincreaseExpBoost(player, Perks.Nimble, 1);
			SOTOlevelFX(player, "UI_trait_agile", true);
		end
	end

	-- FORAGING
	if perk == Perks.PlantScavenging then
		if SOTOSbvars.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.FORAGER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.FORAGER);
			SOTOincreaseExpBoost(player, Perks.PlantScavenging, 1);
			SOTOlevelFX(player, "UI_trait_forager", true);
		end
	end

	-- FISHING
	if perk == Perks.Fishing then
		if SOTOSbvars.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.FISHING) then
			SOTOaddTrait(player, CharacterTrait.FISHING);
			SOTOincreaseExpBoost(player, Perks.Fishing, 1);
			SOTOlevelFX(player, "UI_trait_Fishing", true);
		end
	end

	-- TRAPPING
	if perk == Perks.Trapping then
		if SOTOSbvars.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.TRAPPER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.TRAPPER);
			SOTOincreaseExpBoost(player, Perks.Trapping, 1);
			SOTOlevelFX(player, "UI_trait_trapper", true);
		end
	end

	-- TRACKING
	if perk == Perks.Tracking then
		if SOTOSbvars.SurvTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.TRACKER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.TRACKER);
			SOTOincreaseExpBoost(player, Perks.Tracking, 1);
			SOTOlevelFX(player, "UI_trait_tracker", true);
		end
	end

	-- FIRST AID
	if perk == Perks.Doctor then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.FIRST_AID) then
			SOTOaddTrait(player, CharacterTrait.FIRST_AID);
			SOTOincreaseExpBoost(player, Perks.Doctor, 1);
			SOTOlevelFX(player, "UI_trait_FIRST_AID", true);
		end
	end

	-- COOKING
	if perk == Perks.Cooking then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.CULINARY) then
			SOTOaddTrait(player, SOTO.CharacterTrait.CULINARY);
			SOTOincreaseExpBoost(player, Perks.Cooking, 1);
			SOTOlevelFX(player, "UI_trait_culinary", true);
		end
	end

	-- FARMING
	if perk == Perks.Farming then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.GARDENER) then
			SOTOaddTrait(player, CharacterTrait.GARDENER);
			SOTOincreaseExpBoost(player, Perks.Farming, 1);
			SOTOlevelFX(player, "UI_trait_Gardener", true);
		end
	end

	-- CARPENTRY
	if perk == Perks.Woodwork then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.WOODWORKER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.WOODWORKER);
			SOTOincreaseExpBoost(player, Perks.Woodwork, 1);
			SOTOlevelFX(player, "UI_trait_woodworker", true);
		end
	end

	-- ELECTRICITY
	if perk == Perks.Electricity then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.ELECTRICALMECHANIC) then
			SOTOaddTrait(player, SOTO.CharacterTrait.ELECTRICALMECHANIC);
			SOTOincreaseExpBoost(player, Perks.Electricity, 1);
			SOTOlevelFX(player, "UI_trait_electricalmechanic", true);
		end
	end

	-- MECHANICS
	if perk == Perks.Mechanics then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.AUTOMECHANIC) then
			SOTOaddTrait(player, SOTO.CharacterTrait.AUTOMECHANIC);
			SOTOincreaseExpBoost(player, Perks.Mechanics, 1);
			SOTOlevelFX(player, "UI_trait_automechanic", true);
		end
	end

	-- METALWELDING
	if perk == Perks.MetalWelding then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.METAL_WELDER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.METAL_WELDER);
			SOTOincreaseExpBoost(player, Perks.MetalWelding, 1);
			SOTOlevelFX(player, "UI_trait_metalwelder", true);
		end
	end

	-- TAILORING
	if perk == Perks.Tailoring then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.TAILOR) then
			SOTOaddTrait(player, CharacterTrait.TAILOR);
			SOTOincreaseExpBoost(player, Perks.Tailoring, 1);
			SOTOlevelFX(player, "UI_trait_Tailor", true);
		end
	end

	-- CARVING
	if perk == Perks.Carving then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.WHITTLER) then
			SOTOaddTrait(player, CharacterTrait.WHITTLER);
			SOTOincreaseExpBoost(player, Perks.Carving, 1);
			SOTOlevelFX(player, "UI_trait_Whittler", true);
		end
	end

	-- MASONRY
	if perk == Perks.Masonry then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.MASONRY) then
			SOTOaddTrait(player, SOTO.CharacterTrait.MASONRY);
			SOTOincreaseExpBoost(player, Perks.Masonry, 1);
			SOTOlevelFX(player, "UI_trait_masonry", true);
		end
	end

	-- POTTERY
	if perk == Perks.Pottery then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.POTTER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.POTTER);
			SOTOincreaseExpBoost(player, Perks.Pottery, 1);
			SOTOlevelFX(player, "UI_trait_potter", true);
		end
	end

	-- GLASSMAKING
	if perk == Perks.Glassmaking then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.GLASSBLOWER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.GLASSBLOWER);
			SOTOincreaseExpBoost(player, Perks.Glassmaking, 1);
			SOTOlevelFX(player, "UI_trait_glassblower", true);
		end
	end

	-- BLACKSMITH
	if perk == Perks.Blacksmith then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.BLACKSMITH) then
			SOTOaddTrait(player, CharacterTrait.BLACKSMITH);
			SOTOincreaseExpBoost(player, Perks.Blacksmith, 1);
			SOTOlevelFX(player, "UI_trait_Blacksmith", true);
		end
	end

	-- FLINTKNAPPING
	if perk == Perks.FlintKnapping then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.KNAPPING_BASICS) then
			SOTOaddTrait(player, SOTO.CharacterTrait.KNAPPING_BASICS);
			SOTOincreaseExpBoost(player, Perks.FlintKnapping, 1);
			SOTOlevelFX(player, "UI_trait_knappingbasics", true);
		end
	end

	-- HUSBANDRY
	if perk == Perks.Husbandry then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.ANIMAL_FRIEND) then
			SOTOaddTrait(player, SOTO.CharacterTrait.ANIMAL_FRIEND);
			SOTOincreaseExpBoost(player, Perks.Husbandry, 1);
			SOTOlevelFX(player, "UI_trait_animalfriend", true);
		end
	end

	-- BUTCHERING
	if perk == Perks.Butchering then
		if SOTOSbvars.CraftTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SLAUGHTERER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SLAUGHTERER);
			SOTOincreaseExpBoost(player, Perks.Butchering, 1);
			SOTOlevelFX(player, "UI_trait_slaughterer", true);
		end
	end

	-- MAINTENANCE
	if perk == Perks.Maintenance then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.TINKERER) then
			SOTOaddTrait(player, CharacterTrait.TINKERER);
			SOTOincreaseExpBoost(player, Perks.Maintenance, 1);
			SOTOlevelFX(player, "UI_trait_tinkerer", true);
		end
	end

	-- SMALL BLADE
	if perk == Perks.SmallBlade then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.KNIFER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.KNIFER);
			SOTOincreaseExpBoost(player, Perks.SmallBlade, 1);
			SOTOlevelFX(player, "UI_trait_knifer", true);
		end
	end

	-- SMALL BLUNT
	if perk == Perks.SmallBlunt then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.BLUDGEONER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.BLUDGEONER);
			SOTOincreaseExpBoost(player, Perks.SmallBlunt, 1);
			SOTOlevelFX(player, "UI_trait_bludgeoner", true);
		end
	end

	-- AXE
	if perk == Perks.Axe then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.CUTTER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.CUTTER);
			SOTOincreaseExpBoost(player, Perks.Axe, 1);
			SOTOlevelFX(player, "UI_trait_cutter", true);
		end
	end

	-- SPEAR
	if perk == Perks.Spear then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SPEARMAN) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SPEARMAN);
			SOTOincreaseExpBoost(player, Perks.Spear, 1);
			SOTOlevelFX(player, "UI_trait_spearman", true);
		end
	end

	-- LONG BLADE
	if perk == Perks.LongBlade then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(SOTO.CharacterTrait.SWORDSMAN) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SWORDSMAN);
			SOTOincreaseExpBoost(player, Perks.LongBlade, 1);
			SOTOlevelFX(player, "UI_trait_swordsman", true);
		end
	end

	-- BLUNT
	if perk == Perks.Blunt then
		if SOTOSbvars.CombatTraitsObtainable == true and perkLevel >= 6 and not player:hasTrait(CharacterTrait.BASEBALL_PLAYER) then
			SOTOaddTrait(player, CharacterTrait.BASEBALL_PLAYER);
			SOTOincreaseExpBoost(player, Perks.Blunt, 1);
			SOTOlevelFX(player, "UI_trait_PlaysBaseball", true);
		end
	end

	-- AIMING
	-- EXP_SHOOTER blocks checked first (require SHOOTER already present).
	-- Target boost = 2 because EXP_SHOOTER represents the second tier (+1 on top of SHOOTER's +1).
	if perk == Perks.Aiming then
		if SOTOSbvars.FirearmTraitsObtainable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(CharacterTrait.EAGLE_EYED) and player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) then
			SOTOremoveTrait(player, SOTO.CharacterTrait.SHOOTER);
			SOTOaddTrait(player, SOTO.CharacterTrait.EXP_SHOOTER);
			SOTOincreaseExpBoost(player, Perks.Aiming, 2);
			SOTOincreaseExpBoost(player, Perks.Reloading, 2);
			SOTOlevelFX(player, "UI_trait_expshooter", true);
		end
		if SOTOSbvars.FirearmTraitsObtainable == true and perkLevel == 5 and not player:hasTrait(CharacterTrait.SHORT_SIGHTED) and player:hasTrait(CharacterTrait.EAGLE_EYED) and player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) then
			SOTOremoveTrait(player, SOTO.CharacterTrait.SHOOTER);
			SOTOaddTrait(player, SOTO.CharacterTrait.EXP_SHOOTER);
			SOTOincreaseExpBoost(player, Perks.Aiming, 2);
			SOTOincreaseExpBoost(player, Perks.Reloading, 2);
			SOTOlevelFX(player, "UI_trait_expshooter", true);
		end
		if SOTOSbvars.FirearmTraitsObtainable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(CharacterTrait.EAGLE_EYED) and player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) then
			SOTOremoveTrait(player, SOTO.CharacterTrait.SHOOTER);
			SOTOaddTrait(player, SOTO.CharacterTrait.EXP_SHOOTER);
			SOTOincreaseExpBoost(player, Perks.Aiming, 2);
			SOTOincreaseExpBoost(player, Perks.Reloading, 2);
			SOTOlevelFX(player, "UI_trait_expshooter", true);
		end
		if SOTOSbvars.FirearmTraitsObtainable == true and perkLevel == 6 and not player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(CharacterTrait.EAGLE_EYED) and not player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SHOOTER);
			SOTOincreaseExpBoost(player, Perks.Aiming, 1);
			SOTOincreaseExpBoost(player, Perks.Reloading, 1);
			SOTOlevelFX(player, "UI_trait_shooter", true);
		end
		if SOTOSbvars.FirearmTraitsObtainable == true and perkLevel == 5 and not player:hasTrait(CharacterTrait.SHORT_SIGHTED) and player:hasTrait(CharacterTrait.EAGLE_EYED) and not player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SHOOTER);
			SOTOincreaseExpBoost(player, Perks.Aiming, 1);
			SOTOincreaseExpBoost(player, Perks.Reloading, 1);
			SOTOlevelFX(player, "UI_trait_shooter", true);
		end
		if SOTOSbvars.FirearmTraitsObtainable == true and perkLevel == 7 and player:hasTrait(CharacterTrait.SHORT_SIGHTED) and not player:hasTrait(CharacterTrait.EAGLE_EYED) and not player:hasTrait(SOTO.CharacterTrait.SHOOTER) and not player:hasTrait(SOTO.CharacterTrait.EXP_SHOOTER) then
			SOTOaddTrait(player, SOTO.CharacterTrait.SHOOTER);
			SOTOincreaseExpBoost(player, Perks.Aiming, 1);
			SOTOincreaseExpBoost(player, Perks.Reloading, 1);
			SOTOlevelFX(player, "UI_trait_shooter", true);
		end
	end
end
