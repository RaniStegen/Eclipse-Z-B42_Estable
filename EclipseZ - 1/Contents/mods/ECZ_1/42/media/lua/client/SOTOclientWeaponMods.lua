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

-- This file contains functions that are activated by the client to activate functions on the server.

local mhweapon

-- HEAVY BLUNT ON EQUIP
function SOTOWeaponMods()

    local player = getPlayer()
    if not player then return end

    local mhweapon = player:getPrimaryHandItem()
    if not mhweapon then
        return
    end
	
	local mhIsMeleeWeapon = mhweapon:getStringItemType()
	if mhIsMeleeWeapon and mhIsMeleeWeapon ~= "MeleeWeapon" then
		--print("Not MeleeWeapon")
		return
	end
	--print("MeleeWeapon")

    local scriptItem = mhweapon:getScriptItem()	
	if not scriptItem then
		return
	end
	--local categories = scriptItem:getWeaponCategory()
    local swingAnim = scriptItem:getSwingAnim()
	
	local mhweapon_endurancemod = mhweapon:getEnduranceMod()	
	local mhweapon_doordamage = mhweapon:getDoorDamage()	
	local mhweapon_attackwle = mhweapon:isCantAttackWithLowestEndurance()
	
	local ADoorDamage = scriptItem:getDoorDamage()
	local AEnduranceMod = scriptItem:getEnduranceMod()
	local ACantAttackWithLowestEndurance = scriptItem:isCantAttackWithLowestEndurance()
	
	if player:hasTrait(SOTO.CharacterTrait.STRONG_GRIP) and swingAnim and swingAnim == "Heavy" then
		AEnduranceMod = 1
		ACantAttackWithLowestEndurance = false
	end
	if player:hasTrait(SOTO.CharacterTrait.BREAK_IN_TECHNIQUE) and scriptItem:containsWeaponCategory(WeaponCategory.AXE) then
		ADoorDamage = ADoorDamage * 1.5	
	end

	if ADoorDamage == mhweapon_doordamage and AEnduranceMod == mhweapon_endurancemod and ACantAttackWithLowestEndurance == mhweapon_attackwle then
		return
	end

	SOTOSetWeaponMods(mhweapon, ADoorDamage, AEnduranceMod, ACantAttackWithLowestEndurance);
	
end

--[[
local function ifweaponcheck()

	local player = getPlayer();
	if player == nil then
	return
	end

	local weapon = player:getPrimaryHandItem()
	if not weapon then
	-- print("No weapon in primary hand")
	return
	end
	
	local mhIsMeleeWeapon = weapon:getStringItemType()
	-- zReTIPS доп проверки
	if mhIsMeleeWeapon and mhIsMeleeWeapon ~= "MeleeWeapon" then
		print("ETO NE BUDET DEBAGATSA, NOT MELEE WEAPON")
		return
	end

	local endurancemod = weapon:getEnduranceMod()
	local doordamage = weapon:getDoorDamage()
	local showcanattackend = tostring(weapon:isCantAttackWithLowestEndurance())
	local showweptype = weapon:getStringItemType()
	print("endurancemod: " .. endurancemod)
	print("doordamage: " .. doordamage)
	print("showcanattackend: " .. showcanattackend)
	print("showweptype: " .. showweptype)

end
Events.EveryOneMinute.Add(ifweaponcheck)]]

Events.OnEquipPrimary.Add(SOTOWeaponMods);
Events.OnEquipSecondary.Add(SOTOWeaponMods);
Events.OnGameStart.Add(SOTOWeaponMods);
Events.LevelPerk.Add(SOTOWeaponMods);
Events.OnCreatePlayer.Add(SOTOWeaponMods);
Events.OnCreateLivingCharacter.Add(SOTOWeaponMods);