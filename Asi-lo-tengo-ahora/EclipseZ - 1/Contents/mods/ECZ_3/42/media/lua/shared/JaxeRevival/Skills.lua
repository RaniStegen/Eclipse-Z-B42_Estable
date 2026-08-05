require("JaxeRevival")

JaxeRevival.Skills = {}

local reducePerkLevel = function(player, perk, modifier)
  local level = math.floor(player:getPerkLevel(perk) * ((100 - modifier) / 100))
  player:setPerkLevelDebug(perk, level)
  player:getXp():setXPToLevel(perk, level)
  xpUpdate.levelPerk(player, perk, level)
end

JaxeRevival.Skills.applyConsequences = function(player)
  if SandboxVars.JaxeRevival.PassiveSkillLoss > 0 then
    reducePerkLevel(player, Perks.Fitness, SandboxVars.JaxeRevival.PassiveSkillLoss)
    reducePerkLevel(player, Perks.Strength, SandboxVars.JaxeRevival.PassiveSkillLoss)
  end

  if SandboxVars.JaxeRevival.AgilitySkillLoss > 0 then
    reducePerkLevel(player, Perks.Sprinting, SandboxVars.JaxeRevival.AgilitySkillLoss)
    reducePerkLevel(player, Perks.Lightfoot, SandboxVars.JaxeRevival.AgilitySkillLoss)
    reducePerkLevel(player, Perks.Nimble, SandboxVars.JaxeRevival.AgilitySkillLoss)
    reducePerkLevel(player, Perks.Sneak, SandboxVars.JaxeRevival.AgilitySkillLoss)
  end

  if SandboxVars.JaxeRevival.WeaponSkillLoss > 0 then
    reducePerkLevel(player, Perks.Aiming, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.Reloading, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.Axe, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.Blunt, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.SmallBlunt, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.LongBlade, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.SmallBlade, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.Spear, SandboxVars.JaxeRevival.WeaponSkillLoss)
    reducePerkLevel(player, Perks.Maintenance, SandboxVars.JaxeRevival.WeaponSkillLoss)
  end

  if SandboxVars.JaxeRevival.OtherSkillLoss > 0 then
    reducePerkLevel(player, Perks.Woodwork, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Cooking, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Farming, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Doctor, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Electricity, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.MetalWelding, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Mechanics, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Tailoring, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Fishing, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.Trapping, SandboxVars.JaxeRevival.OtherSkillLoss)
    reducePerkLevel(player, Perks.PlantScavenging, SandboxVars.JaxeRevival.OtherSkillLoss)
  end
end

JaxeRevival.Skills.checkPassives = function(player) return not SandboxVars.JaxeRevival.RecoveryRequiresPassive or player:getPerkLevel(Perks.Fitness) > 0 and player:getPerkLevel(Perks.Strength) > 0 end

local hasRequiredProfession = function(player, ...)
  local profession = player:getDescriptor():getCharacterProfession()

  for _, required in ipairs { ... } do
    if profession == required then return true end
  end

  return false
end

JaxeRevival.Skills.canProfessionRevive = function(player) return SandboxVars.JaxeRevival.ProfessionRequired == 1 or (SandboxVars.JaxeRevival.ProfessionRequired == 2 and hasRequiredProfession(player, CharacterProfession.DOCTOR)) or (SandboxVars.JaxeRevival.ProfessionRequired == 3 and hasRequiredProfession(player, CharacterProfession.DOCTOR, CharacterProfession.NURSE)) or nil end

JaxeRevival.Skills.canReviveBandage = function(player) return SandboxVars.JaxeRevival.ReviveBandaged ~= 1 and SandboxVars.JaxeRevival.ReviveBandaged == 2 or (SandboxVars.JaxeRevival.ReviveBandaged == 3 and hasRequiredProfession(player, CharacterProfession.DOCTOR)) or (SandboxVars.JaxeRevival.ReviveBandaged == 4 and hasRequiredProfession(player, CharacterProfession.DOCTOR, CharacterProfession.NURSE)) or player:getPerkLevel(Perks.Doctor) >= 10 or nil end
