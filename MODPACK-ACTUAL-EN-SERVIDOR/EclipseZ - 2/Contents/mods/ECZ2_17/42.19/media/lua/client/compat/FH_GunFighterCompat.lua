
Events.OnGameBoot.Add(function()
	-- Have to fix this function to not wipe the secondaryHandItem
	local _ReEquipIt = ReEquipIt
	function ReEquipIt(player, weapon)
		player:setPrimaryHandItem(weapon) 
		if	(weapon:isRequiresEquippedBothHands() or weapon:isTwoHandWeapon()) then
				player:setSecondaryHandItem(weapon)
		-- remove this! It will ALWAYS remove the secondary hand item, even if its not a weapon (bag, generic item, etc). Also, since I'm doing dual wielding, removing myself
		--else	player:setSecondaryHandItem(nil) 
		end
	end
end)