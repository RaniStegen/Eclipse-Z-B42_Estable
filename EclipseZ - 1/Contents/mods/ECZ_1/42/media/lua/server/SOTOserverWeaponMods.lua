------------------------------------------------------
--                       SOTO                       --
--    (Simple Overhaul: Traits and Occupations)     --
--                    by heafoxy                    --
--            Steam Workshop 2023-2026              --
------------------------------------------------------

------------------------------------------------------
--                    WEAPON MODS                   --
--       Special thanks to Star and kERHUS          --
------------------------------------------------------

-- This file contains functions that are activated on the server by other client functions.

local mhweapon

function SOTOSetWeaponMods(mhweapon, set_doordamage, set_endurancemod, set_attackwle)
    
	if not mhweapon then
        return
    end
	
	mhweapon:setDoorDamage(set_doordamage)
	mhweapon:setCantAttackWithLowestEndurance(set_attackwle)
	mhweapon:setEnduranceMod(set_endurancemod)
	
end