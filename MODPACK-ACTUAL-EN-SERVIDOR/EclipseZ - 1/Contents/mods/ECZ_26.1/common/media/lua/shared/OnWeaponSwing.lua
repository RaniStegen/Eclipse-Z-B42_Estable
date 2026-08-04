----------------------------------------------
--This mod created for Sunday Drivers server--
--mod by lect---------------------------------
--Free to use with permission-----------------
----------------------------------------------

local VANILLA_XP_CUMULATIVE = {
    [0] = 0, [1] = 75, [2] = 225, [3] = 525, [4] = 1275, 
    [5] = 2775, [6] = 5775, [7] = 10275, [8] = 16275, [9] = 23775, [10] = 32775
}
local function GetMasteryLevel(totalXp)
    if not totalXp then totalXp = 0 end
    if totalXp >= VANILLA_XP_CUMULATIVE[10] then return 10 end
    for lvl = 10, 1, -1 do
        if totalXp >= VANILLA_XP_CUMULATIVE[lvl] then return lvl end
    end
    return 0
end

local function untierWeapon(player)
	Events.OnPlayerMove.Remove(untierWeapon)
	local handItem = player:getPrimaryHandItem()
	if handItem and handItem:getModData().zoneTier then
		handItem:getModData().zoneTier = false
		syncHandWeaponFields(character, handItem)
	end
end
Events.OnPlayerMove.Add(untierWeapon)

local function initMeleeStats(modData, inventoryItem, character)
	if	modData.CriticalChance		== nil and
		modData.CritDmgMultiplier	== nil and
		modData.MinDamage			== nil and
		modData.MaxDamage			== nil and
		modData.MaxHitCount			== nil and
		modData.Name				== nil then
		
		local newItem = instanceItem(inventoryItem:getFullType())
		
		modData.CriticalChance		= newItem:getCriticalChance()
		modData.CritDmgMultiplier	= newItem:getCriticalDamageMultiplier()
		modData.MinDamage			= newItem:getMinDamage()
		modData.MaxDamage			= newItem:getMaxDamage()
		modData.MaxHitCount			= newItem:getMaxHitCount()
		modData.Name				= newItem:getName()
		modData.SD7_1				= true
	elseif not modData.SD7_1 then
		local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())

		inventoryItem:setMaxRange(scriptItem:getMaxRange())
		
		modData.MinDamage 			= scriptItem:getMinDamage()
		modData.MaxDamage 			= scriptItem:getMaxDamage()
		modData.SD7_1 				= true
	end
	syncHandWeaponFields(character, inventoryItem)
end

local function initRangedStats(modData, inventoryItem, character)
	local newItem = instanceItem(inventoryItem:getFullType())
	if 	modData.AimingPerkHitChanceModifier == nil and
		modData.AimingPerkCritModifier 		== nil and
		modData.AimingPerkRangeModifier 	== nil and
		modData.AimingTime 					== nil and
		modData.ReloadTime 					== nil and
		modData.RecoilDelay					== nil and
		modData.Name						== nil and
		modData.CriticalChance				== nil and
		modData.CritDmgMultiplier			== nil and
		modData.MinDamage					== nil and
		modData.MaxDamage					== nil and
		modData.MaxHitCount					== nil then
		
		modData.CriticalChance				= newItem:getCriticalChance()
		modData.CritDmgMultiplier			= newItem:getCriticalDamageMultiplier()
		modData.MinDamage					= newItem:getMinDamage()
		modData.MaxDamage					= newItem:getMaxDamage()
		modData.AimingPerkHitChanceModifier = newItem:getAimingPerkHitChanceModifier()
		modData.AimingPerkCritModifier 		= newItem:getAimingPerkCritModifier()
		modData.AimingPerkRangeModifier 	= newItem:getAimingPerkRangeModifier()
		modData.AimingTime					= newItem:getAimingTime()
		modData.ReloadTime					= newItem:getReloadTime()
		modData.RecoilDelay					= newItem:getRecoilDelay()
		modData.Name						= newItem:getName()
		modData.MaxHitCount					= newItem:getMaxHitCount()
		modData.SD7_1						= true
	elseif not modData.SD7_1 then
		modData.MinDamage					= inventoryItem:getScriptItem():getMinDamage()
		modData.MaxDamage					= inventoryItem:getScriptItem():getMaxDamage()
		modData.SD7_1 						= true
	end
	modData.HFO_MeleeSwap = nil

	syncHandWeaponFields(character, inventoryItem)
end

local function OnWeaponSwing(character, handWeapon)
	if character:getPrimaryHandItem() == nil then return end
	if character ~= getSpecificPlayer(0) then return end
	
	local tierzone, zonename, x, y, toxic, control, sprinter, pinpoint, cognition, zoneHealth = checkZone()
	--local tierzone = checkZone()
	
	local base_health = SandboxVars.OnWeaponSwing.basehealth

	local zoneMulti = zoneHealth/base_health
	
	local tiercritratemod	= {(SandboxVars.OnWeaponSwing.Tier1critrate), (SandboxVars.OnWeaponSwing.Tier2critrate), (SandboxVars.OnWeaponSwing.Tier3critrate), (SandboxVars.OnWeaponSwing.Tier4critrate), (SandboxVars.OnWeaponSwing.Tier5critrate), (SandboxVars.OnWeaponSwing.Tier6critrate)}
	local tiercritmultimod	= {(SandboxVars.OnWeaponSwing.Tier1critmulti), (SandboxVars.OnWeaponSwing.Tier2critmulti), (SandboxVars.OnWeaponSwing.Tier3critmulti), (SandboxVars.OnWeaponSwing.Tier4critmulti), (SandboxVars.OnWeaponSwing.Tier5critmulti), (SandboxVars.OnWeaponSwing.Tier6critmulti)}
	local tierdmgmod		= {(SandboxVars.OnWeaponSwing.Tier1dmg), (SandboxVars.OnWeaponSwing.Tier2dmg), (SandboxVars.OnWeaponSwing.Tier3dmg), (SandboxVars.OnWeaponSwing.Tier4dmg), (SandboxVars.OnWeaponSwing.Tier5dmg), (SandboxVars.OnWeaponSwing.Tier6dmg)}
	
	local localdmgmulti, localcritrate, localcritmulti = tierdmgmod[tierzone]/zoneMulti, tiercritratemod[tierzone], tiercritmultimod[tierzone]
	
	local inventoryItem = handWeapon
	local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
	local modData = inventoryItem:getModData()
	if modData.Augments and modData.Augments > 4 then modData.Augments = 4 end

    local pMD = character:getModData()
    local username = character:getUsername() or "SinglePlayer"
    local masteries = (pMD.SkillMastery and pMD.SkillMastery[username]) or {}

    local masteryDmgMult = 1
    local masteryCritMult = 1
    local masteryCondMult = 1
    local masteryAccMult = 1

    if masteries.Damage then
        local lvl = GetMasteryLevel(masteries.Damage)
        masteryDmgMult = 1 + (lvl * 0.03) -- 3% per level
    end

    if masteries.Critical then
        local lvl = GetMasteryLevel(masteries.Critical)
        masteryCritMult = 1 + (lvl * 0.03) -- 3% per level
    end
	
	if tierzone and not handWeapon:isRanged() and modData.zonename ~= zonename then
		initMeleeStats(modData, inventoryItem, character)

        if masteries.Condition then
            local lvl = GetMasteryLevel(masteries.Condition)
            masteryCondMult = 1 + (lvl * 0.05) -- 5% per level
        end
		
		local basecritrate, basecritmulti, basemindmg, basemaxdmg, basename = modData.CriticalChance, modData.CritDmgMultiplier, modData.MinDamage, modData.MaxDamage, modData.Name
		
		local isHardmode = modData.HardcoreMode or nil
		local modeMultiplier = 1.0
		
		if isHardmode then modeMultiplier = 0.5 end
		
		local isSoulForged = modData.SoulForged or false
		local hasSouls = modData.KillCount or false
		local augmentMulti = modData.Augments or 0
		local addMaxDmg, addCritChance, addCritMulti = 0, 0, 0
		local o_scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
		if isSoulForged and hasSouls then
			local weaponMaxCond = inventoryItem:getConditionMax()
			local weaponCondLowerChance = inventoryItem:getConditionLowerChance()
			local soulsRequired = weaponMaxCond * weaponCondLowerChance * o_scriptItem:getMinDamage()
			local soulsFreed = modData.KillCount or nil
			local soulPower = math.min(soulsFreed / soulsRequired, 1)
			addMaxDmg = soulPower * 1 * augmentMulti/4
			addCritChance = soulPower * 5 * augmentMulti/4
			addCritMulti = soulPower * 0.5 * augmentMulti/4
		end
		
		local localdmgmulti, localcritrate, localcritmulti = (localdmgmulti * modeMultiplier), (localcritrate * modeMultiplier), (localcritmulti * modeMultiplier)
		local maxHit = inventoryItem:getMaxHitCount()
		
		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		local soulForgeConditionLowerChance = modData.ConditionLowerChance or 1
		local soulForgeEnduranceMod = modData.EnduranceMod or inventoryItem:getEnduranceMod()
		local soulForgeMaxCondition = modData.MaxCondition or 1
		local soulForgeMaxHitCount = modData.MaxHitCount or maxHit
		local soulWrought = modData.SoulWrought or ""
		
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1
		
		local permaCritRate = pMD.PermaSoulForgeCritRateBonus 
		local permaCritMulti = pMD.PermaSoulForgeCritMultiBonus
		local permaMaxDmg = pMD.PermaSoulForgeMaxDmgBonus
		local permaMaxCondition = pMD.PermaMaxConditionBonus
		local permaConditionLowerChance = pMD.PermaSoulForgeConditionBonus
		
		if permaCritRate and permaCritRate > 1 then soulForgeCritRate = soulForgeCritRate * permaCritRate end
		if permaCritMulti and permaCritMulti > 1 then soulForgeCritMulti = soulForgeCritMulti * permaCritMulti end
		if permaMaxDmg and permaMaxDmg > 1 then soulForgeMaxDmgMulti = soulForgeMaxDmgMulti * permaMaxDmg end
		if soulForgeMaxCondition and permaMaxCondition and permaMaxCondition > 1 then soulForgeMaxCondition = soulForgeMaxCondition * permaMaxCondition end
		if soulForgeConditionLowerChance and permaConditionLowerChance and permaConditionLowerChance > 1 then soulForgeConditionLowerChance = soulForgeConditionLowerChance * permaConditionLowerChance end
		
		local engravedName = modData.EngravedName
		
		inventoryItem:setCriticalChance(((basecritrate + addCritChance) * localcritrate) * modeMultiplier * soulForgeCritRate * mdzCriticalChance * masteryCritMult)
		inventoryItem:setCriticalDamageMultiplier(((basecritmulti + addCritMulti) * localcritmulti) * modeMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier * masteryCritMult)
		inventoryItem:setMinDamage((basemindmg * localdmgmulti) * modeMultiplier * soulForgeMinDmgMulti * mdzMinDmg * masteryDmgMult)
		inventoryItem:setMaxDamage(((basemaxdmg + addMaxDmg) * localdmgmulti) * modeMultiplier * soulForgeMaxDmgMulti * mdzMaxDmg * masteryDmgMult)
		
		if engravedName then
			inventoryItem:setName(engravedName .. " [T" .. tostring(tierzone) .. "]")
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			if SandboxVars.OnWeaponSwing.swingrename then inventoryItem:setName(soulWrought.. mdzPrefix .. basename .. " [T" .. tostring(tierzone) .. "]") end
		end

		if soulForgeConditionLowerChance then inventoryItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * soulForgeConditionLowerChance * masteryCondMult) end
		if soulForgeMaxCondition then inventoryItem:setConditionMax(scriptItem:getConditionMax() * soulForgeMaxCondition * masteryCondMult) end
		
		if soulForgeMaxHitCount then
			local mhc = math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)
			if inventoryItem:getSwingAnim() == "Heavy" then mhc = soulForgeMaxHitCount end
			if mhc ~= maxHit then inventoryItem:setMaxHitCount(mhc) end
		end
		if soulForgeEnduranceMod then inventoryItem:setEnduranceMod(soulForgeEnduranceMod) end
		
		modData.zonename = zonename
	elseif tierzone and handWeapon:isRanged() and modData.zonename ~= zonename then-- and handWeapon:getSwingAnim() ~= "Handgun" then
		initRangedStats(modData, inventoryItem, character)

        if masteries.Accuracy then
            local lvl = GetMasteryLevel(masteries.Accuracy)
            masteryAccMult = 1 + (lvl * 0.03) -- 3% per level
        end

		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzAimingTime = modData.mdzAimingTime or 1
		local mdzReloadTime = modData.mdzReloadTime or 1
		local mdzRecoilDelay = modData.mdzRecoilDelay or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1

		local soulForgeAmmoPerShoot = modData.soulForgeAmmoPerShoot or 1
		local soulForgeAimingPerkCritModifier = modData.soulForgeAimingPerkCritModifier or 1
		local soulForgeAimingPerkHitChanceModifier = modData.soulForgeAimingPerkHitChanceModifier or 1
		local soulForgeAimingPerkRangeModifier = modData.soulForgeAimingPerkRangeModifier or 1
		local soulForgeAimingTime = modData.soulForgeAimingTime or 1
		local soulForgeProjectileCount = modData.soulForgeProjectileCount or 1
		
		local soulWrought = modData.SoulWrought or ""
		local soulForgeMaxHitCount = modData.MaxHitCount

		if soulForgeMaxHitCount then
			local mhc = math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)
			inventoryItem:setMaxHitCount(mhc)
		end
		
		local dmgMulti = (SandboxVars.OnWeaponSwing.RangedDamageMultiplier) or 1.0
		local perkMulti = 1.1 - tierzone/10

		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		
		local permaCritRate = pMD.PermaSoulForgeCritRateBonus 
		local permaCritMulti = pMD.PermaSoulForgeCritMultiBonus
		local permaMaxDmg = pMD.PermaSoulForgeMaxDmgBonus
		local permaAiming = pMD.PermaAiming or 1
		local permaReloading = 1
		if pMD.PermaReloading and pMD.PermaReloading > 0 then permaReloading = math.max(0.35,1-pMD.PermaReloading) end
		local permaRecoil = 1
		if pMD.PermaRecoil and pMD.PermaRecoil > 0 then permaRecoil = math.max(0.35,1-pMD.PermaRecoil) end

		if permaCritRate and permaCritRate > 1 then soulForgeCritRate = soulForgeCritRate * permaCritRate end
		if permaCritMulti and permaCritMulti > 1 then soulForgeCritMulti = soulForgeCritMulti * permaCritMulti end
		if permaMaxDmg and permaMaxDmg > 1 then soulForgeMaxDmgMulti = soulForgeMaxDmgMulti * permaMaxDmg end
		
		local attachedDmg = 0
		local attachedAim = 0
		local attachedRecoil = 0
		local attachedReload = 0
		
		if modData.attachedDmg then attachedDmg = modData.attachedDmg end
		if modData.attachedAim then attachedAim = modData.attachedAim end
		if modData.attachedRecoil then attachedRecoil = modData.attachedRecoil end
		if modData.attachedReload then attachedReload = modData.attachedReload end
		
		local convertedRangedMulti = 1 - (1 - localdmgmulti) / dmgMulti
		
		if modData.CriticalChance then inventoryItem:setCriticalChance(modData.CriticalChance * soulForgeCritRate * mdzCriticalChance * masteryCritMult) end
		if modData.CritDmgMultiplier then inventoryItem:setCriticalDamageMultiplier(modData.CritDmgMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier * masteryCritMult) end
		inventoryItem:setMinDamage((modData.MinDamage + attachedDmg) * soulForgeMinDmgMulti * mdzMinDmg * convertedRangedMulti * masteryDmgMult)
		inventoryItem:setMaxDamage((modData.MaxDamage + attachedDmg) * soulForgeMaxDmgMulti * mdzMaxDmg * convertedRangedMulti * masteryDmgMult)
		if modData.ReloadTime then inventoryItem:setReloadTime(permaReloading * (modData.ReloadTime + attachedReload) * mdzReloadTime) end
		if modData.RecoilDelay then inventoryItem:setRecoilDelay(permaRecoil * (modData.RecoilDelay + attachedRecoil) * mdzRecoilDelay) end
		
		inventoryItem:setAimingTime(permaAiming * (modData.AimingTime + attachedAim) * mdzAimingTime * soulForgeAimingTime * perkMulti * masteryAccMult)
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier * masteryAccMult)-- * perkMulti)
		inventoryItem:setAimingPerkCritModifier(soulForgeAimingPerkCritModifier * modData.AimingPerkCritModifier * perkMulti)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier * soulForgeAimingPerkRangeModifier * perkMulti)
		
		local engravedName = modData.EngravedName
		if engravedName then 
			inventoryItem:setName(engravedName)
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			if SandboxVars.OnWeaponSwing.swingrename then inventoryItem:setName(mdzPrefix .. soulWrought ..  modData.Name .. " [T" .. tostring(tierzone) .. "]") end
		end
		modData.zonename = zonename
	end
	syncHandWeaponFields(character, inventoryItem)
end
Events.OnWeaponSwing.Add(OnWeaponSwing)

local function SDWeaponCheck(character, inventoryItem)
	if inventoryItem == nil then return end
	if character ~= getSpecificPlayer(0) then return end
	if not inventoryItem:IsWeapon() then return end
	
	local scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
	
	local tierzone = checkZone()
	
	local modData = inventoryItem:getModData()
	if modData.Augments and modData.Augments > 4 then modData.Augments = 4 end

    local pMD = character:getModData()
    local username = "SinglePlayer"
    local usernameOK, characterUsername = pcall(function()
        return character:getUsername()
    end)
    if usernameOK and characterUsername and characterUsername ~= "" then
        username = characterUsername
    end
    local masteries = (pMD.SkillMastery and pMD.SkillMastery[username]) or {}

    local masteryDmgMult = 1
    local masteryCritMult = 1
    local masteryCondMult = 1
    local masteryAccMult = 1

    if masteries.Damage then
        local lvl = GetMasteryLevel(masteries.Damage)
        masteryDmgMult = 1 + (lvl * 0.03) -- 3% per level
    end

    if masteries.Critical then
        local lvl = GetMasteryLevel(masteries.Critical)
        masteryCritMult = 1 + (lvl * 0.03) -- 3% per level
    end
	
	if not inventoryItem:isRanged() then
		initMeleeStats(modData, inventoryItem, character)
		
        if masteries.Condition then
            local lvl = GetMasteryLevel(masteries.Condition) or 0
            masteryCondMult = 1 + (lvl * 0.05) -- 5% per level
        end

		local isHardmode = modData.HardcoreMode or nil
		local modeMultiplier = 1.0
		
		if isHardmode then modeMultiplier = 0.5 end
		
		local isSoulForged = modData.SoulForged or false
		local hasSouls = modData.KillCount or false
		local augmentMulti = modData.Augments or 0
		local addMaxDmg, addCritChance, addCritMulti = 0, 0, 0
		local o_scriptItem = ScriptManager.instance:getItem(inventoryItem:getFullType())
		if isSoulForged and hasSouls then
			local weaponMaxCond = inventoryItem:getConditionMax()
			local weaponCondLowerChance = inventoryItem:getConditionLowerChance()
			local soulsRequired = weaponMaxCond * weaponCondLowerChance * o_scriptItem:getMinDamage()
			local soulsFreed = modData.KillCount or nil
			local soulPower = math.min(soulsFreed / soulsRequired, 1)
			addMaxDmg = soulPower * 1 * augmentMulti/4
			addCritChance = soulPower * 5 * augmentMulti/4
			addCritMulti = soulPower * 0.5 * augmentMulti/4
		end
		
		local basecritrate, basecritmulti, basemindmg, basemaxdmg, basename = modData.CriticalChance, modData.CritDmgMultiplier, modData.MinDamage, modData.MaxDamage, modData.Name
		local maxHit = inventoryItem:getMaxHitCount()
		
		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		local soulForgeConditionLowerChance = modData.ConditionLowerChance or 1
		local soulForgeEnduranceMod = modData.EnduranceMod or inventoryItem:getEnduranceMod()
		local soulForgeMaxCondition = modData.MaxCondition or 1
		local soulForgeMaxHitCount = modData.MaxHitCount or maxHit
		local soulWrought = modData.SoulWrought or ""
		
		local permaCritRate = pMD.PermaSoulForgeCritRateBonus 
		local permaCritMulti = pMD.PermaSoulForgeCritMultiBonus
		local permaMaxDmg = pMD.PermaSoulForgeMaxDmgBonus
		local permaMaxCondition = pMD.PermaMaxConditionBonus
		local permaConditionLowerChance = pMD.PermaSoulForgeConditionBonus
		
		if permaCritRate and permaCritRate > 1 then soulForgeCritRate = soulForgeCritRate * permaCritRate end
		if permaCritMulti and permaCritMulti > 1 then soulForgeCritMulti = soulForgeCritMulti * permaCritMulti end
		if permaMaxDmg and permaMaxDmg > 1 then soulForgeMaxDmgMulti = soulForgeMaxDmgMulti * permaMaxDmg end
		if soulForgeMaxCondition and permaMaxCondition and permaMaxCondition > 1 then soulForgeMaxCondition = soulForgeMaxCondition * permaMaxCondition end
		if soulForgeConditionLowerChance and permaConditionLowerChance and permaConditionLowerChance > 1 then soulForgeConditionLowerChance = soulForgeConditionLowerChance * permaConditionLowerChance end
		
		local engravedName = modData.EngravedName
		
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1
		
		inventoryItem:setCriticalChance((basecritrate + addCritChance) * soulForgeCritRate * mdzCriticalChance * masteryCritMult)
		inventoryItem:setCriticalDamageMultiplier((basecritmulti + addCritMulti) * soulForgeCritMulti * mdzCritDmgMultiplier * masteryCritMult)
		inventoryItem:setMinDamage(basemindmg * soulForgeMinDmgMulti * mdzMinDmg * masteryDmgMult)
		inventoryItem:setMaxDamage((basemaxdmg + addMaxDmg) * soulForgeMaxDmgMulti * mdzMaxDmg * masteryDmgMult)
		if engravedName then 
			inventoryItem:setName(engravedName)
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			if SandboxVars.OnWeaponSwing.equiprename then inventoryItem:setName(soulWrought.. mdzPrefix .. basename) end
		end
		
		if soulForgeMaxHitCount then
			local mhc = math.max(soulForgeMaxHitCount-math.floor(tierzone/4),1)
			if inventoryItem:getSwingAnim() == "Heavy" then mhc = soulForgeMaxHitCount end
			if mhc ~= maxHit then inventoryItem:setMaxHitCount(mhc) end
		end
		if soulForgeConditionLowerChance then inventoryItem:setConditionLowerChance(scriptItem:getConditionLowerChance() * soulForgeConditionLowerChance * masteryCondMult) end
		if soulForgeMaxCondition then inventoryItem:setConditionMax(scriptItem:getConditionMax() * soulForgeMaxCondition * masteryCondMult) end
		if soulForgeEnduranceMod then inventoryItem:setEnduranceMod(soulForgeEnduranceMod) end
		
		modData.zonename = false
	else
		initRangedStats(modData, inventoryItem, character)

        if masteries.Accuracy then
            local lvl = GetMasteryLevel(masteries.Accuracy)
            masteryAccMult = 1 + (lvl * 0.03) -- 3% per level
        end

		local isSoulForged = modData.SoulForged or false
		
		local mdzMaxDmg = modData.mdzMaxDmg or 1
		local mdzMinDmg = modData.mdzMinDmg or 1
		local mdzAimingTime = modData.mdzAimingTime or 1
		local mdzReloadTime = modData.mdzReloadTime or 1
		local mdzRecoilDelay = modData.mdzRecoilDelay or 1
		local mdzCriticalChance = modData.mdzCriticalChance or 1
		local mdzCritDmgMultiplier = modData.mdzCritDmgMultiplier or 1
		
		local soulForgeAmmoPerShoot = modData.soulForgeAmmoPerShoot or 1
		local soulForgeAimingPerkCritModifier = modData.soulForgeAimingPerkCritModifier or 1
		local soulForgeAimingPerkHitChanceModifier = modData.soulForgeAimingPerkHitChanceModifier or 1
		local soulForgeAimingPerkRangeModifier = modData.soulForgeAimingPerkRangeModifier or 1
		local soulForgeAimingTime = modData.soulForgeAimingTime or 1
		local soulForgeProjectileCount = modData.soulForgeProjectileCount or 1
		local isPiercingBullets = modData.isPiercingBullets or false
		local soulWrought = modData.SoulWrought or ""
		local soulForgeMaxHitCount = modData.MaxHitCount or nil
		
		if soulForgeMaxHitCount then
			inventoryItem:setMaxHitCount(soulForgeMaxHitCount)
		end
		
		local soulForgeMinDmgMulti = modData.soulForgeMinDmgMulti or 1
		local soulForgeMaxDmgMulti = modData.soulForgeMaxDmgMulti or 1
		local soulForgeCritRate = modData.soulForgeCritRate or 1
		local soulForgeCritMulti = modData.soulForgeCritMulti or 1
		
		local attachedDmg = 0
		local attachedAim = 0
		local attachedRecoil = 0
		local attachedReload = 0
		
		if modData.attachedDmg then attachedDmg = modData.attachedDmg end
		if modData.attachedAim then attachedAim = modData.attachedAim end
		if modData.attachedRecoil then attachedRecoil = modData.attachedRecoil end
		if modData.attachedReload then attachedReload = modData.attachedReload end
		
		if modData.CriticalChance then inventoryItem:setCriticalChance(modData.CriticalChance * soulForgeCritRate * mdzCriticalChance * masteryCritMult) end
		if modData.CritDmgMultiplier then inventoryItem:setCriticalDamageMultiplier(modData.CritDmgMultiplier * soulForgeCritMulti * mdzCritDmgMultiplier * masteryCritMult) end
		inventoryItem:setMinDamage((modData.MinDamage + attachedDmg) * soulForgeMinDmgMulti * mdzMinDmg * masteryDmgMult)
		inventoryItem:setMaxDamage((modData.MaxDamage + attachedDmg) * soulForgeMaxDmgMulti * mdzMaxDmg * masteryDmgMult)
		if modData.ReloadTime then inventoryItem:setReloadTime((modData.ReloadTime + attachedReload) * mdzReloadTime) end
		if modData.RecoilDelay then inventoryItem:setRecoilDelay((modData.RecoilDelay + attachedRecoil) * mdzRecoilDelay) end
		
		inventoryItem:setAimingTime((modData.AimingTime + attachedAim) * mdzAimingTime * soulForgeAimingTime * masteryAccMult)
		inventoryItem:setAimingPerkHitChanceModifier(modData.AimingPerkHitChanceModifier * soulForgeAimingPerkHitChanceModifier * masteryAccMult)
		inventoryItem:setAimingPerkCritModifier(modData.AimingPerkCritModifier * soulForgeAimingPerkCritModifier)
		inventoryItem:setAimingPerkRangeModifier(modData.AimingPerkRangeModifier * soulForgeAimingPerkRangeModifier)
		
		local engravedName = modData.EngravedName
		if engravedName then 
			inventoryItem:setName(engravedName)
		else
			local mdzPrefix = ""
			if modData.mdzPrefix then mdzPrefix = modData.mdzPrefix .. " " end
			if SandboxVars.OnWeaponSwing.equiprename then inventoryItem:setName(mdzPrefix .. soulWrought .. modData.Name) end
		end

		modData.zonename = false
	end
	syncHandWeaponFields(character, inventoryItem)
end
Events.OnEquipPrimary.Add(SDWeaponCheck)