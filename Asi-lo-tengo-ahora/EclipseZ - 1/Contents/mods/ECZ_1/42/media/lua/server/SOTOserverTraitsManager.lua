------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

--------------------
-- TRAITS MANAGER --
--------------------

-- This file contains functions that are activated on the server by other client functions.

local SOTOSbvars = SandboxVars.SOTO;

function SOTOaddTrait(player, trait)
	if not player:hasTrait(trait) then
		player:getCharacterTraits():add(trait);
	end
end

function SOTOremoveTrait(player, trait)
	if player:hasTrait(trait) then
		player:getCharacterTraits():remove(trait);	
	end
end

function SOTOincreaseExpBoost(player, perk, targetBoost)
    local currentXPBoost = player:getXp():getPerkBoost(perk);
    local finalBoost = math.min(math.max(currentXPBoost, targetBoost), 3);
    player:getXp():setPerkBoost(perk, finalBoost);
    sendServerCommand(player, "SOTO", "SyncPerkBoost", {perkStr = tostring(perk), boost = finalBoost});
end