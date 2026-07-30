require("JaxeRevival")

JaxeRevival.Compatibility = {}

JaxeRevival.Compatibility.banditsActive = getActivatedMods():contains("Bandits")

JaxeRevival.Compatibility.initialize = function()
  if SandboxVars.ZombieLore.ZombiesDragDown and not SandboxVars.JaxeRevival.DragDownAllowed then
    JaxeRevival.log("Setting 'ZombieLore.ZombiesDragDown' to 'false' for compatibility.")
    SandboxVars.ZombieLore.ZombiesDragDown = false

    getSandboxOptions():getOptionByName("ZombieLore.ZombiesDragDown"):setValue(false)
    getSandboxOptions():toLua()
  end
end

JaxeRevival.Compatibility.checkOnTick = function(player)
  if JaxeRevival.Compatibility.banditsActive and player:getVariableBoolean("Bandit") then return end

  return true
end
