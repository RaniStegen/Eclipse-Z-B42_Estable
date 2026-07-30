SpecialLootSpawns = SpecialLootSpawns or {}

SpecialLootSpawns.FirearmsBlueprints = {
    "MakeImprovisedFlashlightSilencer",
    "MakeImprovisedBottleSilencer",
}

SpecialLootSpawns.OnCreateFirearmsBlueprint = function(item)
    SpecialLootSpawns.CreateSchematic(item, SpecialLootSpawns.FirearmsBlueprints, 30);
end

SpecialLootSpawns.OnCreateWeaponWithStock = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
    if item:getType() == "MP510" then
        item:attachWeaponPart(instanceItem("MP5_Stock_Detracted"), true)
    else
        item:attachWeaponPart(instanceItem(item:getType() .. "_Stock_Detracted"), true)
    end
end

SpecialLootSpawns.OnCreateWeapon = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
end

SpecialLootSpawns.OnCreateM4 = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end

    item:attachWeaponPart(instanceItem("Base.TacticalStock"), true)
    item:attachWeaponPart(instanceItem("Base.RIS_Grip"), true)
    item:attachWeaponPart(instanceItem("Base.M4_Carryhandle"), true)
end

SpecialLootSpawns.OnCreateAKM = function(item)
    local random_instance = newrandom()
    local bakeliteChance = random_instance:random(2)
    local foregripChance = random_instance:random(10)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
    if item:getModelIndex() == 0 then
        item:attachWeaponPart(instanceItem("Base.AKM_Handguard_Plastic"), true)
        item:attachWeaponPart(instanceItem("Base.AKM_Stock_Plastic"), true)
    elseif item:getModelIndex() == 1 then
        if bakeliteChance == 1 then
            item:attachWeaponPart(instanceItem("Base.AKM_Handguard_Bakelite"), true)
            item:attachWeaponPart(instanceItem("Base.AKM_Stock_Bakelite"), true)
        else
            if foregripChance == 1 then
                item:attachWeaponPart(instanceItem("Base.AKM_Foregrip_Wood"), true)
            else
                item:attachWeaponPart(instanceItem("Base.AKM_Handguard_Wood"), true)
            end
            item:attachWeaponPart(instanceItem("Base.AKM_Stock_Wood"), true)
        end
    end
end

SpecialLootSpawns.OnCreate1911 = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
    local random_instance = newrandom()
    local icaChance = random_instance:random(50)
    local SpawnICA19 = (SandboxVars.Firearms.SpawnICA19)
    local SpawnSuppressors = (SandboxVars.Firearms.SpawnSuppressors)
    local SpawnHandgunSuppressors = (SandboxVars.Firearms.SpawnHandgunSuppressors)
    if SpawnICA19 and icaChance == 1 then
        if random_instance:random(4) == 1 then
            item:setModelIndex(3)
            item:setName("ICA19 Goldballer")
            if SpawnSuppressors and SpawnHandgunSuppressors then
                item:attachWeaponPart(instanceItem("Base.45Silencer"), true)
            end
        else
            item:setModelIndex(2)
            item:setName("ICA19 Silverballer")
            if SpawnSuppressors and SpawnHandgunSuppressors then
                item:attachWeaponPart(instanceItem("Base.45Silencer"), true)
            end
        end
    else
        if random_instance:random(3) == 1 then
            item:setModelIndex(1)
        else
            item:setModelIndex(0)
        end
    end
    if item:getIconsForTexture() then
        local iconTexture = getTexture("media/textures/Item_" ..
            item:getIconsForTexture():get(item:getModelIndex()) .. ".png")
        if iconTexture then
            item:setTexture(iconTexture)
        end
    end
end

SpecialLootSpawns.OnCreateDEagle = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
    local random_instance = newrandom()
    local goldChance = random_instance:random(50)
    if item:getModelIndex() == 2 then
        if goldChance == 1 then
            item:setModelIndex(2)
            item:setTexture(getTexture("media/textures/Item_" ..
                item:getIconsForTexture():get(item:getModelIndex()) .. ".png"))
            item:setName("Golden Desert Eagle")
        else
            item:setModelIndex(0)
            item:setTexture(getTexture("media/textures/Item_" ..
                item:getIconsForTexture():get(item:getModelIndex()) .. ".png"))
        end
    end
end

SpecialLootSpawns.OnCreateM9 = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
    local random_instance = newrandom()
    local inoxChance = random_instance:random(50)
    if item:getModelIndex() == 1 then
        if inoxChance == 1 then
            item:setModelIndex(1)
            item:setTexture(getTexture("media/textures/Item_" ..
                item:getIconsForTexture():get(item:getModelIndex()) .. ".png"))
            item:setName("Beretta 92FS INOX")
        else
            item:setModelIndex(0)
            item:setTexture(getTexture("media/textures/Item_" ..
                item:getIconsForTexture():get(item:getModelIndex()) .. ".png"))
        end
    end
end

SpecialLootSpawns.OnCreateM16 = function(item)
    if not item then return; end;
    if not item:IsWeapon() or not item:isRanged() then return; end
    local random_instance = newrandom()
    local m16Chance = random_instance:random(10)
    local commandoChance = random_instance:random(100)
    local a2Chance = random_instance:random(2)
    if m16Chance == 1 then
        if commandoChance == 1 then
            item:setModelIndex(2)
            item:setName("Colt Commando")
        else
            if a2Chance == 1 then
                item:setModelIndex(1)
                item:setName("M16A2")
            else
                item:setModelIndex(0)
                item:setName("M16A1")
            end
        end
    else
        item:setModelIndex(1)
        item:setName("AR15")
    end
end
