# Diagnóstico de acción de vestir v4

## Conteos
- **overrides:** 143
- **registries:** 18
- **hits:** 3639
- **copied:** 122

## Overrides o interceptores
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:695` — `		equipAction = ISWearClothing:new(character,item,50)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:32` — `local og_start = ISWearClothing.start;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:33` — `function ISWearClothing:start()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Painting/Sculpting/SculptingWorkContextMenu.lua:574` — `			ISTimedActionQueue.add(ISWearClothing:new(player, workItems['item3'], 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:17` — `    if clothing and ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.doWearClothingMenu and`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:20` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:27` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:37` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_2/42/media/lua/client/LabModEngine_Client.lua:365` — `        ISInventoryPaneContextMenu.wearItem(clothing, player:getPlayerNum())`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:124` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:152` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:497` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, tests.clothing or tests.canBeEquippedContainer or tests.canBeEquippedOther, items, context);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:500` — `        ISInventoryPaneContextMenu.doClothingItemExtraMenu(context, tests.clothingItemExtra, playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:714` — `        context:addOption(getText("IGUI_invpanel_Inspect"), playerObj, ISInventoryPaneContextMenu.onInspectClothing, tests.clothing);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:956` — `        context:addOption(getText("ContextMenu_WringClothes"), items, ISInventoryPaneContextMenu.onWringClothing, player)    `
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1569` — `ISInventoryPaneContextMenu.onInspectClothing = function(playerObj, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1572` — `		action:setOnComplete(ISInventoryPaneContextMenu.onInspectClothingUI, playerObj, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1575` — `		ISInventoryPaneContextMenu.onInspectClothingUI(playerObj, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1579` — `ISInventoryPaneContextMenu.onInspectClothingUI = function(player, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1594` — `ISInventoryPaneContextMenu.doClothingPatchMenu = function(player, clothing, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1648` — `            local option = subMenuRemove:addOption(patch:getFabricTypeName(), playerObj, ISInventoryPaneContextMenu.removePatch, clothing, part, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1658` — `                local option = subMenuPart:addOption(fabric1:getDisplayName(), playerObj, ISInventoryPaneContextMenu.repairClothing, clothing, part, fabric1, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1668` — `                local option = subMenuPart:addOption(fabric2:getDisplayName(), playerObj, ISInventoryPaneContextMenu.repairClothing, clothing, part, fabric2, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1678` — `                local option = subMenuPart:addOption(fabric3:getDisplayName(), playerObj, ISInventoryPaneContextMenu.repairClothing, clothing, part, fabric3, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1715` — `ISInventoryPaneContextMenu.removePatch = function(player, clothing, part, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1728` — `ISInventoryPaneContextMenu.removeAllPatches = function(player, clothing, parts, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1733` — `            ISInventoryPaneContextMenu.removePatch(player, clothing, part, needle);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1738` — `ISInventoryPaneContextMenu.repairClothing = function(player, clothing, part, fabric, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1764` — `ISInventoryPaneContextMenu.repairAllClothing = function(player, clothing, parts, fabric, thread, needle, onlyHoles)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1785` — `            ISInventoryPaneContextMenu.repairClothing(player, clothing, part, fabricArray:get(successfulActionsAdded), threadArray:get(currentThreadUsed), needle);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1788` — `            ISInventoryPaneContextMenu.repairClothing(player, clothing, part, fabricArray:get(successfulActionsAdded), threadArray:get(currentThreadUsed), needle);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1796` — `ISInventoryPaneContextMenu.doWearClothingTooltip = function(playerObj, newItem, currentItem, option)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1890` — `ISInventoryPaneContextMenu.doWearClothingMenu = function(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1897` — `    local option = context:addOption(getText("ContextMenu_Wear"), items, ISInventoryPaneContextMenu.onWearItems, player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1910` — `    ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothing, clothing, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2398` — `	if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2497` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2697` — `ISInventoryPaneContextMenu.onWringClothing = function(items, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2994` — `ISInventoryPaneContextMenu.onWearItems = function(items, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3007` — `                                ISInventoryPaneContextMenu.onClothingItemExtra(wornItem:getItem(), wornItem:getItem():getClothingItemExtra():get(i), playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3013` — `            ISInventoryPaneContextMenu.wearItem(k, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3032` — `ISInventoryPaneContextMenu.wearItem = function(item, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3038` — `    ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3839` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3887` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4577` — `ISInventoryPaneContextMenu.doClothingItemExtraMenu = function(context, clothingItemExtra, playerObj)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4592` — `            local option = context:addOption(text, clothingItemExtra, ISInventoryPaneContextMenu.onClothingItemExtra, clothingItemExtra:getFullType(), playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4593` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothingItemExtra, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4601` — `        local option = context:addOption(text, clothingItemExtra, ISInventoryPaneContextMenu.onClothingItemExtra, itemType, playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4606` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, item, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4611` — `ISInventoryPaneContextMenu.onClothingItemExtra = function(item, extra, playerObj)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4619` — `                        ISInventoryPaneContextMenu.onClothingItemExtra(wornItem:getItem(), wornItem:getItem():getClothingItemExtra():get(i), playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1666` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1672` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1915` — `                                ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:36` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:71` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1082` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1088` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1300` — `                            ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_ui.lua:255` — `    local option = submenu:addOption(fabric:getDisplayName(), self.player, ISInventoryPaneContextMenu.repairClothing, self.clothing, part, fabric, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_ui.lua:264` — `            allOption = submenu:addOption(allText, self.player, ISInventoryPaneContextMenu.repairAllClothing, self.clothing, self.parts, fabric, thread, needle, true)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_ui.lua:268` — `            allOption = submenu:addOption(allText, self.player, ISInventoryPaneContextMenu.repairAllClothing, self.clothing, self.parts, fabric, thread, needle, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_ui.lua:294` — `        local removeOption = context:addOption(getText("ContextMenu_RemovePatch"), self.player, ISInventoryPaneContextMenu.removePatch, self.clothing, part, scissors)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_ui.lua:302` — `            removeAllOption = context:addOption(getText("ContextMenu_RemoveAllPatches"), self.player, ISInventoryPaneContextMenu.removeAllPatches, self.clothing, self.parts, scissors)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_garmentUI.lua:4` — `--local original = ISInventoryPaneContextMenu.onInspectClothingUI`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_14/common/media/lua/client/interactiveTailoring_garmentUI.lua:5` — `function ISInventoryPaneContextMenu.onInspectClothingUI(player, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:695` — `		equipAction = ISWearClothing:new(character,item,50)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:32` — `local og_start = ISWearClothing.start;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:33` — `function ISWearClothing:start()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Painting/Sculpting/SculptingWorkContextMenu.lua:574` — `			ISTimedActionQueue.add(ISWearClothing:new(player, workItems['item3'], 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:17` — `    if clothing and ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.doWearClothingMenu and`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:20` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:27` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:37` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_2/42/media/lua/client/LabModEngine_Client.lua:365` — `        ISInventoryPaneContextMenu.wearItem(clothing, player:getPlayerNum())`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:124` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:152` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:497` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, tests.clothing or tests.canBeEquippedContainer or tests.canBeEquippedOther, items, context);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:500` — `        ISInventoryPaneContextMenu.doClothingItemExtraMenu(context, tests.clothingItemExtra, playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:714` — `        context:addOption(getText("IGUI_invpanel_Inspect"), playerObj, ISInventoryPaneContextMenu.onInspectClothing, tests.clothing);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:956` — `        context:addOption(getText("ContextMenu_WringClothes"), items, ISInventoryPaneContextMenu.onWringClothing, player)    `
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1569` — `ISInventoryPaneContextMenu.onInspectClothing = function(playerObj, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1572` — `		action:setOnComplete(ISInventoryPaneContextMenu.onInspectClothingUI, playerObj, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1575` — `		ISInventoryPaneContextMenu.onInspectClothingUI(playerObj, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1579` — `ISInventoryPaneContextMenu.onInspectClothingUI = function(player, clothing)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1594` — `ISInventoryPaneContextMenu.doClothingPatchMenu = function(player, clothing, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1648` — `            local option = subMenuRemove:addOption(patch:getFabricTypeName(), playerObj, ISInventoryPaneContextMenu.removePatch, clothing, part, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1658` — `                local option = subMenuPart:addOption(fabric1:getDisplayName(), playerObj, ISInventoryPaneContextMenu.repairClothing, clothing, part, fabric1, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1668` — `                local option = subMenuPart:addOption(fabric2:getDisplayName(), playerObj, ISInventoryPaneContextMenu.repairClothing, clothing, part, fabric2, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1678` — `                local option = subMenuPart:addOption(fabric3:getDisplayName(), playerObj, ISInventoryPaneContextMenu.repairClothing, clothing, part, fabric3, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1715` — `ISInventoryPaneContextMenu.removePatch = function(player, clothing, part, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1728` — `ISInventoryPaneContextMenu.removeAllPatches = function(player, clothing, parts, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1733` — `            ISInventoryPaneContextMenu.removePatch(player, clothing, part, needle);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1738` — `ISInventoryPaneContextMenu.repairClothing = function(player, clothing, part, fabric, thread, needle)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1764` — `ISInventoryPaneContextMenu.repairAllClothing = function(player, clothing, parts, fabric, thread, needle, onlyHoles)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1785` — `            ISInventoryPaneContextMenu.repairClothing(player, clothing, part, fabricArray:get(successfulActionsAdded), threadArray:get(currentThreadUsed), needle);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1788` — `            ISInventoryPaneContextMenu.repairClothing(player, clothing, part, fabricArray:get(successfulActionsAdded), threadArray:get(currentThreadUsed), needle);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1796` — `ISInventoryPaneContextMenu.doWearClothingTooltip = function(playerObj, newItem, currentItem, option)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1890` — `ISInventoryPaneContextMenu.doWearClothingMenu = function(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1897` — `    local option = context:addOption(getText("ContextMenu_Wear"), items, ISInventoryPaneContextMenu.onWearItems, player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1910` — `    ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothing, clothing, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2398` — `	if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2497` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2697` — `ISInventoryPaneContextMenu.onWringClothing = function(items, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2994` — `ISInventoryPaneContextMenu.onWearItems = function(items, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3007` — `                                ISInventoryPaneContextMenu.onClothingItemExtra(wornItem:getItem(), wornItem:getItem():getClothingItemExtra():get(i), playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3013` — `            ISInventoryPaneContextMenu.wearItem(k, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3032` — `ISInventoryPaneContextMenu.wearItem = function(item, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3038` — `    ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3839` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3887` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4577` — `ISInventoryPaneContextMenu.doClothingItemExtraMenu = function(context, clothingItemExtra, playerObj)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4592` — `            local option = context:addOption(text, clothingItemExtra, ISInventoryPaneContextMenu.onClothingItemExtra, clothingItemExtra:getFullType(), playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4593` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothingItemExtra, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4601` — `        local option = context:addOption(text, clothingItemExtra, ISInventoryPaneContextMenu.onClothingItemExtra, itemType, playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4606` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, item, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4611` — `ISInventoryPaneContextMenu.onClothingItemExtra = function(item, extra, playerObj)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4619` — `                        ISInventoryPaneContextMenu.onClothingItemExtra(wornItem:getItem(), wornItem:getItem():getClothingItemExtra():get(i), playerObj);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1666` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1672` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1915` — `                                ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:36` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:71` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1082` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1088` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1300` — `                            ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`

## registries.lua
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.3/42.16/media/registries.lua`
SHA-256: `74e278b4d6af54b2df53e5e81fdead7d588e9c5b41080462c80ad10549e5107c`
```lua
MarzGuns_Tags = {}
MarzGuns_AmmoTypes = {}

MarzGuns_Tags.Ammo50 = ItemTag.register("marzguns:ammo50")
MarzGuns_Tags.Ammo25 = ItemTag.register("marzguns:ammo25")
MarzGuns_Tags.Ammo20 = ItemTag.register("marzguns:ammo20")
MarzGuns_Tags.Ammo10 = ItemTag.register("marzguns:ammo10")

MarzGuns_Tags.AmmoBox50 = ItemTag.register("marzguns:ammobox50")
MarzGuns_Tags.AmmoBox25 = ItemTag.register("marzguns:ammobox25")
MarzGuns_Tags.AmmoBox20 = ItemTag.register("marzguns:ammobox20")
MarzGuns_Tags.AmmoBox10 = ItemTag.register("marzguns:ammobox10")

MarzGuns_Tags.AmmoBox = ItemTag.register("marzguns:ammobox")
MarzGuns_Tags.AmmoCarton = ItemTag.register("marzguns:ammocarton")
MarzGuns_Tags.AmmoCrate = ItemTag.register("marzguns:ammocrate")

MarzGuns_AmmoTypes.BULLET_9x19 = AmmoType.register("marzguns:bullet_9x19", "MarzGuns.9x19_Bullet")
MarzGuns_AmmoTypes.BULLET_45 = AmmoType.register("marzguns:bullet_45", "MarzGuns.45_Bullet")
MarzGuns_AmmoTypes.BULLET_44 = AmmoType.register("marzguns:bullet_44", "MarzGuns.44_Bullet")
MarzGuns_AmmoTypes.BULLET_50 = AmmoType.register("marzguns:bullet_50", "MarzGuns.50_Bullet")
MarzGuns_AmmoTypes.BULLET_38 = AmmoType.register("marzguns:bullet_38", "MarzGuns.38_Bullet")
MarzGuns_AmmoTypes.BULLET_3030 = AmmoType.register("marzguns:bullet_3030", "MarzGuns.3030_Bullet")
MarzGuns_AmmoTypes.BULLET_4570 = AmmoType.register("marzguns:bullet_4570", "MarzGuns.4570_Bullet")
MarzGuns_AmmoTypes.BULLET_357 = AmmoType.register("marzguns:bullet_357", "MarzGuns.357_Bullet")
MarzGuns_AmmoTypes.BULLET_545x39 = AmmoType.register("marzguns:bullet_545x39", "MarzGuns.545x39_Bullet")
MarzGuns_AmmoTypes.BULLET_762x39 = AmmoType.register("marzguns:bullet_762x39", "MarzGuns.762x39_Bullet")
MarzGuns_AmmoTypes.BULLET_762x54 = AmmoType.register("marzguns:bullet_762x54", "MarzGuns.762x54_Bullet")
MarzGuns_AmmoTypes.BULLET_9x39 = AmmoType.register("marzguns:bullet_9x39", "MarzGuns.9x39_Bullet")
MarzGuns_AmmoTypes.BULLET_57x28 = AmmoType.register("marzguns:bullet_57x28", "MarzGuns.57x28_Bullet")
MarzGuns_AmmoTypes.BULLET_3006 = AmmoType.register("marzguns:bullet_3006", "MarzGuns.3006_Bullet")

MarzGuns_AmmoTypes.BULLET_308 = AmmoType.register("marzguns:bullet_308", "MarzGuns.308_Bullet")
MarzGuns_AmmoTypes.BULLET_762x51 = AmmoType.register("marzguns:bullet_762x51", "MarzGuns.762x51_Bullet")

MarzGuns_AmmoTypes.BULLET_223 = AmmoType.register("marzguns:bullet_223", "MarzGuns.223_Bullet")
MarzGuns_AmmoTypes.BULLET_556x45 = AmmoType.register("marzguns:bullet_556x45", "MarzGuns.556x45_Bullet")
MarzGuns_AmmoTypes.BULLET_556x45_Subsonic = AmmoType.register("marzguns:bullet_556x45_subsonic", "MarzGuns.556x45_Bullet_Subsonic")
MarzGuns_AmmoTypes.BULLET_556x45_ArmorPiercing = AmmoType.register("marzguns:bullet_556x45_armor_piercing", "MarzGuns.556x45_Bullet_ArmorPiercing")
MarzGuns_AmmoTypes.BULLET_556x45_HollowPoint = AmmoType.register("marzguns:bullet_556x45_hollow_point", "MarzGuns.556x45_Bullet_HollowPoint")
MarzGuns_AmmoTypes.BULLET_556x45_Overpressured = AmmoType.register("marzguns:bullet_556x45_overpressured", "MarzGuns.556x45_Bullet_Overpressured")

MarzGuns_AmmoTypes.SHELL_12G_BUCKSHOT = AmmoType.register("marzguns:shell_12g_buckshot", "MarzGuns.12Gauge_Shell_Buckshot")
MarzGuns_AmmoTypes.SHELL_12G_SLUG = AmmoType.register("marzguns:shell_12g_slug", "MarzGuns.12Gauge_Shell_Slug")

MarzGuns_AmmoTypes.ROUND_40MM_BUCKSHOT = AmmoType.register("marzguns:round_40mm_buckshot", "MarzGuns.40mm_Round_Buckshot")
MarzGuns_AmmoTypes.ROUND_40MM_HE = AmmoType.register("marzguns:round_40mm_he", "MarzGuns.40mm_Round_HE")
MarzGuns_AmmoTypes.ROUND_40MM_INCENDIARY = AmmoType.register("marzguns:round_40mm_incendiary", "MarzGuns.40mm_Round_Incendiary")

```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_20/42.18/media/registries.lua`
SHA-256: `6e9b54ffb0e66985ebe9013e9dbab8fd4b3ffe6c379474bfa510d64ebfd1ea5b`
```lua
ItemTag.register("VFX:Frosting")
ItemTag.register("VFX:DividedBowls")
ItemTag.register("VFX:GroundMeat")
ItemTag.register("VFX:Sausage")
ItemTag.register("VFX:BouillionCube")
ItemTag.register("VFX:Pitcher")
ItemTag.register("VFX:ProteinShaker")
ItemTag.register("VFX:Icecream")
ItemTag.register("VFX:Rice")
ItemTag.register("VFX:Pasta")
ItemTag.register("VFX:BeerBottle")
ItemTag.register("VFX:AnyFlour")
ItemTag.register("VFX:TraditionalFlour")
ItemTag.register("VFX:PizzaDough")
ItemTag.register("VFX:EvaporatedMilk")
ItemTag.register("VFX:StarterThermophilic")
ItemTag.register("VFX:StarterMesophilic")
ItemTag.register("VFX:StarterSwiss")
ItemTag.register("VFX:StarterParmesan")
ItemTag.register("VFX:StarterFrench")
ItemTag.register("VFX:StarterBlue")
ItemTag.register("VFX:Whey")
ItemTag.register("VFX:VinegarStarter")
ItemTag.register("VFX:Yeast")
ItemTag.register("VFX:Patty")
ItemTag.register("VFX:NutritionTarget")
ItemTag.register("VFX:Toast")
ItemTag.register("VFX:Meatball")
ItemTag.register("VFX:SourdoughStarter")
```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/registries.lua`
SHA-256: `8a459498e99ff9ca57ec3986ff80e9d478828b6a4bbde2bab6a708dc2846acad`
```lua
SapphCookingRegistries = {}

--base Tag

-- item tags --
SapphCookingRegistries.tags = {

    -- mod tags --
    
ricegrain = ItemTag.register("sapphcooking:ricegrain"),
thermos = ItemTag.register("sapphcooking:thermos"),
coffeecup = ItemTag.register("sapphcooking:coffeecup"),
returnthermos = ItemTag.register("sapphcooking:returnthermos"),
returnsaucepan = ItemTag.register("sapphcooking:returnsaucepan"),
returnwokpan = ItemTag.register("sapphcooking:returnwokpan"),
returnbowl = ItemTag.register("sapphcooking:returnbowl"),
dontreturnbowl = ItemTag.register("sapphcooking:dontreturnbowl"),
iscake = ItemTag.register("sapphcooking:iscake"),
juice = ItemTag.register("sapphcooking:juice"),
baconeggspan = ItemTag.register("sapphcooking:baconeggspan"),
eggboiled = ItemTag.register("sapphcooking:eggboiled"),
meltedchocolate = ItemTag.register("sapphcooking:meltedchocolate"),
chocolate = ItemTag.register("sapphcooking:chocolate"),
cookedrice = ItemTag.register("sapphcooking:cookedrice"),
isrisotto = ItemTag.register("sapphcooking:isrisotto"),
icing = ItemTag.register("sapphcooking:icing"),
syrup = ItemTag.register("sapphcooking:syrup"),
sausage = ItemTag.register("sapphcooking:sausage"),
mushroom = ItemTag.register("sapphcooking:mushroom"),
peas = ItemTag.register("sapphcooking:peas"),
beans = ItemTag.register("sapphcooking:beans"),
sourcream = ItemTag.register("sapphcooking:sourcream"),
slicedvegetables = ItemTag.register("sapphcooking:slicedvegetables"),
chicken = ItemTag.register("sapphcooking:chicken"),
beef = ItemTag.register("sapphcooking:beef"),
turkey = ItemTag.register("sapphcooking:turkey"),
pork = ItemTag.register("sapphcooking:pork"),
pastrycream = ItemTag.register("sapphcooking:pastrycream"),
salt = ItemTag.register("sapphcooking:salt"),
soysauce = ItemTag.register("sapphcooking:soysauce"),
pepper = ItemTag.register("sapphcooking:pepper"),
broth = ItemTag.register("sapphcooking:broth"),
bread = ItemTag.register("sapphcooking:bread"),
mincedmeat = ItemTag.register("sapphcooking:mincedmeat"),
carrot = ItemTag.register("sapphcooking:carrot"),
potato = ItemTag.register("sapphcooking:potato"),
citrus = ItemTag.register("sapphcooking:citrus"),
beets = ItemTag.register("sapphcooking:beets"),
berry = ItemTag.register("sapphcooking:berry"),
tomato = ItemTag.register("sapphcooking:tomato"), -- for all tomato dishes
custombottles = ItemTag.register("sapphcooking:custombottles"), -- for all custom bottles
oilpan = ItemTag.register("sapphcooking:oilpan"),
oilpanbig = ItemTag.register("sapphcooking:oilpanbig")

}
-- fliers --

--[[
Flier.register("sapphcooking:Fortune1")
Flier.register("sapphcooking:Fortune2")
Flier.register("sapphcooking:Fortune3")
Flier.register("sapphcooking:Fortune4")
Flier.register("sapphcooking:Fortune5")
Flier.register("sapphcooking:Fortune6")
Flier.register("sapphcooking:Fortune7")
Flier.register("sapphcooking:Fortune8")
Flier.register("sapphcooking:Fortune9")
Flier.register("sapphcooking:Fortune10")
]]--




-- body locations --
ItemBodyLocation.register("sapphcooking:chefapron")

--[[
SapphCookingRegistries.traits = {
    -- "mymod:mytrait" is the identifier for this trait
    -- "mymod" is the namespace for your trait: this should be the same for all registries in your mod
    cook5 = CharacterTrait.register("sapphcooking:cook5"),
    cook6 = CharacterTrait.register("sapphcooking:cook6")
}
]]--
```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_1/42/media/registries.lua`
SHA-256: `36b1eecf6e2197e853fd1edfbf8a2082af72cf741e96678084ebd105c0616b98`
```lua
SOTO = SOTO or {}
SOTO.CharacterTrait = {}
SOTO.CharacterProfession = {}

-- =====================
-- CHARACTER TRAITS
-- =====================

SOTO.CharacterTrait.TAUT = CharacterTrait.register("soto:taut")
SOTO.CharacterTrait.SLACK = CharacterTrait.register("soto:slack")
SOTO.CharacterTrait.FAST_METABOLISM = CharacterTrait.register("soto:fastmetabolism")
SOTO.CharacterTrait.SLOW_METABOLISM = CharacterTrait.register("soto:slowmetabolism")
SOTO.CharacterTrait.SNEAKY = CharacterTrait.register("soto:sneaky")
SOTO.CharacterTrait.LIGHTFOOTED = CharacterTrait.register("soto:lightfooted")
SOTO.CharacterTrait.AGILE = CharacterTrait.register("soto:agile")
SOTO.CharacterTrait.GYMNAST2 = CharacterTrait.register("soto:gymnast2")
SOTO.CharacterTrait.GARDENER2 = CharacterTrait.register("soto:gardener2")
SOTO.CharacterTrait.FORAGER = CharacterTrait.register("soto:forager")
SOTO.CharacterTrait.FORAGER2 = CharacterTrait.register("soto:forager2")
SOTO.CharacterTrait.TRAPPER = CharacterTrait.register("soto:trapper")
SOTO.CharacterTrait.TRACKER = CharacterTrait.register("soto:tracker")
SOTO.CharacterTrait.FISHING2 = CharacterTrait.register("soto:fishing2")
SOTO.CharacterTrait.MUSHROOM_PICKER = CharacterTrait.register("soto:mushroompicker")
SOTO.CharacterTrait.ENTOMOLOGIST = CharacterTrait.register("soto:entomologist")
SOTO.CharacterTrait.IMPROVED_FORAGING = CharacterTrait.register("soto:improvedforaging")
SOTO.CharacterTrait.ADVANCED_FORAGING = CharacterTrait.register("soto:advancedforaging")
SOTO.CharacterTrait.INVENTIVE2 = CharacterTrait.register("soto:inventive2")
SOTO.CharacterTrait.FIRST_AID2 = CharacterTrait.register("soto:firstaid2")
SOTO.CharacterTrait.TAILOR2 = CharacterTrait.register("soto:tailor2")
SOTO.CharacterTrait.CULINARY = CharacterTrait.register("soto:culinary")
SOTO.CharacterTrait.HANDY2 = CharacterTrait.register("soto:handy2")
SOTO.CharacterTrait.WOODWORKER = CharacterTrait.register("soto:woodworker")
SOTO.CharacterTrait.WOODWORKER2 = CharacterTrait.register("soto:woodworker2")
SOTO.CharacterTrait.ELECTRICALMECHANIC = CharacterTrait.register("soto:electricalmechanic")
SOTO.CharacterTrait.ELECTRICALMECHANIC2 = CharacterTrait.register("soto:electricalmechanic2")
SOTO.CharacterTrait.AUTOMECHANIC = CharacterTrait.register("soto:automechanic")
SOTO.CharacterTrait.AUTOMECHANIC2 = CharacterTrait.register("soto:automechanic2")
SOTO.CharacterTrait.METAL_WELDER = CharacterTrait.register("soto:metalwelder")
SOTO.CharacterTrait.METAL_WELDER2 = CharacterTrait.register("soto:metalwelder2")
SOTO.CharacterTrait.MASONRY = CharacterTrait.register("soto:masonry")
SOTO.CharacterTrait.MASONRY2 = CharacterTrait.register("soto:masonry2")
SOTO.CharacterTrait.POTTER = CharacterTrait.register("soto:potter")
SOTO.CharacterTrait.GLASSBLOWER = CharacterTrait.register("soto:glassblower")
SOTO.CharacterTrait.KNAPPING_BASICS = CharacterTrait.register("soto:knappingbasics")
SOTO.CharacterTrait.ANIMAL_FRIEND = CharacterTrait.register("soto:animalfriend")
SOTO.CharacterTrait.ANIMAL_FRIEND2 = CharacterTrait.register("soto:animalfriend2")
SOTO.CharacterTrait.SLAUGHTERER = CharacterTrait.register("soto:slaughterer")
SOTO.CharacterTrait.SLAUGHTERER2 = CharacterTrait.register("soto:slaughterer2")
SOTO.CharacterTrait.KNIFER = CharacterTrait.register("soto:knifer")
SOTO.CharacterTrait.BLUDGEONER = CharacterTrait.register("soto:bludgeoner")
SOTO.CharacterTrait.CUTTER = CharacterTrait.register("soto:cutter")
SOTO.CharacterTrait.SPEARMAN = CharacterTrait.register("soto:spearman")
SOTO.CharacterTrait.SWORDSMAN = CharacterTrait.register("soto:swordsman")
SOTO.CharacterTrait.DURABILITY = CharacterTrait.register("soto:durability")
SOTO.CharacterTrait.SHOOTER = CharacterTrait.register("soto:shooter")
SOTO.CharacterTrait.SHOOTER2 = CharacterTrait.register("soto:shooter2")
SOTO.CharacterTrait.EXP_SHOOTER = CharacterTrait.register("soto:expshooter")
SOTO.CharacterTrait.HUNTER2 = CharacterTrait.register("soto:hunter2")
SOTO.CharacterTrait.SCOUT2 = CharacterTrait.register("soto:formerscout2")
SOTO.CharacterTrait.HERBALIST2 = CharacterTrait.register("soto:herbalist2")
SOTO.CharacterTrait.WILDERNESS_KNOWLEDGE2 = CharacterTrait.register("soto:wildernessknowledge2")
SOTO.CharacterTrait.GENERATOR_EXPERT = CharacterTrait.register("soto:generatorexpert")
SOTO.CharacterTrait.GENERATOR_EXPERT2 = CharacterTrait.register("soto:generatorexpert2")
SOTO.CharacterTrait.CALMMINDED = CharacterTrait.register("soto:calmminded")
SOTO.CharacterTrait.MARATHON_RUNNER = CharacterTrait.register("soto:marathonrunner")
--SOTO.CharacterTrait.NINJAWAY = CharacterTrait.register("soto:ninjaway")
--SOTO.CharacterTrait.NINJAWAY2 = CharacterTrait.register("soto:ninjaway2")
SOTO.CharacterTrait.BREATHING_TECHNIQUE = CharacterTrait.register("soto:breathingtechnique")
SOTO.CharacterTrait.BREATHING_TECHNIQUE2 = CharacterTrait.register("soto:breathingtechnique2")
SOTO.CharacterTrait.TIRELESS = CharacterTrait.register("soto:tireless")
SOTO.CharacterTrait.TIRELESS2 = CharacterTrait.register("soto:tireless2")
SOTO.CharacterTrait.STRONG_GRIP = CharacterTrait.register("soto:stronggrip")
SOTO.CharacterTrait.STRONG_GRIP2 = CharacterTrait.register("soto:stronggrip2")
SOTO.CharacterTrait.SPEED_DEMON2 = CharacterTrait.register("soto:speeddemon2")
SOTO.CharacterTrait.EAGLE_EYED2 = CharacterTrait.register("soto:eagleeyed2")
SOTO.CharacterTrait.NIGHT_VISION2 = CharacterTrait.register("soto:nightvision2")
SOTO.CharacterTrait.KEEN_HEARING2 = CharacterTrait.register("soto:keenhearing2")
SOTO.CharacterTrait.INCONSPICUOUS2 = CharacterTrait.register("soto:inconspicuous2")
SOTO.CharacterTrait.ADRENALINE_JUNKIE2 = CharacterTrait.register("soto:adrenalinejunkie2")
SOTO.CharacterTrait.BRAVE2 = CharacterTrait.register("soto:brave2")
SOTO.CharacterTrait.DESENSITIZED2 = CharacterTrait.register("soto:desensitized2")
SOTO.CharacterTrait.GRACEFUL2 = CharacterTrait.register("soto:graceful2")
SOTO.CharacterTrait.FAST_READER2 = CharacterTrait.register("soto:fastreader2")
SOTO.CharacterTrait.FEAR_OF_THE_DARK = CharacterTrait.register("soto:fearofthedark")
SOTO.CharacterTrait.OUTDOORSMAN2 = CharacterTrait.register("soto:outdoorsman2")
SOTO.CharacterTrait.CRUELTY = CharacterTrait.register("soto:cruelty")
SOTO.CharacterTrait.CRUELTY2 = CharacterTrait.register("soto:cruelty2")
SOTO.CharacterTrait.PACIFIST2 = CharacterTrait.register("soto:pacifist2")
SOTO.CharacterTrait.ALCOHOLIC = CharacterTrait.register("soto:alcoholic")
SOTO.CharacterTrait.LESSSWEATY = CharacterTrait.register("soto:lesssweaty")
SOTO.CharacterTrait.HIGH_SWEATY = CharacterTrait.register("soto:highsweaty")
SOTO.CharacterTrait.ORGANIZED2 = CharacterTrait.register("soto:organized2")
SOTO.CharacterTrait.STRONG_BACK = CharacterTrait.register("soto:strongback")
SOTO.CharacterTrait.STRONG_BACK2 = CharacterTrait.register("soto:strongback2")
SOTO.CharacterTrait.WEAK_BACK = CharacterTrait.register("soto:weakback")
SOTO.CharacterTrait.DEXTROUS2 = CharacterTrait.register("soto:dextrous2")
SOTO.CharacterTrait.THICKBLOOD = CharacterTrait.register("soto:thickblood")
SOTO.CharacterTrait.LIQUIDBLOOD = CharacterTrait.register("soto:liquidblood")
SOTO.CharacterTrait.SENSITIVE_DIGESTION = CharacterTrait.register("soto:sensitivedigestion")
SOTO.CharacterTrait.LARKPERSON = CharacterTrait.register("soto:larkperson")
SOTO.CharacterTrait.OWLPERSON = CharacterTrait.register("soto:owlperson")
SOTO.CharacterTrait.OPTIMISTIC = CharacterTrait.register("soto:optimistic")
SOTO.CharacterTrait.DEPRESSIVE = CharacterTrait.register("soto:depressive")
SOTO.CharacterTrait.CHRONIC_MIGRAINE = CharacterTrait.register("soto:chronicmigraine")
SOTO.CharacterTrait.ALLERGIC = CharacterTrait.register("soto:allergic")
SOTO.CharacterTrait.PANIC_ATTACKS = CharacterTrait.register("soto:panicattacks")
SOTO.CharacterTrait.BREAK_IN_TECHNIQUE = CharacterTrait.register("soto:breakintechnique")
SOTO.CharacterTrait.USED_TO_CORPSES = CharacterTrait.register("soto:usedtocorpses")
SOTO.CharacterTrait.LIFELONG_LEARNER = CharacterTrait.register("soto:lifelonglearner")
SOTO.CharacterTrait.REFUELLER = CharacterTrait.register("soto:refueller")
SOTO.CharacterTrait.CUTTING_TOOLS = CharacterTrait.register("soto:cuttingtools")
SOTO.CharacterTrait.COMMERCIAL_DRIVER = CharacterTrait.register("soto:commercialdriver")
SOTO.CharacterTrait.FRAGILE_HEALTH = CharacterTrait.register("soto:fragilehealth")
--SOTO.CharacterTrait.SNORER = CharacterTrait.register("soto:snorer")	
SOTO.CharacterTrait.FORMER_ALCOHOLIC = CharacterTrait.register("soto:formeralcoholic")
SOTO.CharacterTrait.FORMER_SMOKER = CharacterTrait.register("soto:formersmoker")

-- =====================
-- CHARACTER PROFESSIONS
-- =====================

SOTO.CharacterProfession.DELIVERYMAN = CharacterProfession.register("soto:deliveryman")
SOTO.CharacterProfession.LOADER = CharacterProfession.register("soto:loader")
SOTO.CharacterProfession.TRUCK_DRIVER = CharacterProfession.register("soto:truckdriver")
SOTO.CharacterProfession.SOLDIER = CharacterProfession.register("soto:soldier")
SOTO.CharacterProfession.BOTANIST = CharacterProfession.register("soto:botanist")
SOTO.CharacterProfession.GRAVEDIGGER = CharacterProfession.register("soto:gravedigger")
SOTO.CharacterProfession.DANCER = CharacterProfession.register("soto:dancer")
SOTO.CharacterProfession.PRIEST = CharacterProfession.register("soto:priest")
SOTO.CharacterProfession.WEIGHTLIFTING_INSTRUCTOR = CharacterProfession.register("soto:weightliftinginstructor")
SOTO.CharacterProfession.DETECTIVE = CharacterProfession.register("soto:detective")
SOTO.CharacterProfession.SCHOOL_TEACHER = CharacterProfession.register("soto:schoolteacher")
SOTO.CharacterProfession.JANITOR = CharacterProfession.register("soto:janitor")
SOTO.CharacterProfession.STUNTMAN = CharacterProfession.register("soto:stuntman")
SOTO.CharacterProfession.GAS_STATION_OPERATOR = CharacterProfession.register("soto:gasstationoperator")
SOTO.CharacterProfession.CAMP_COUNSELOR = CharacterProfession.register("soto:campcounselor")
SOTO.CharacterProfession.DRAG_RACER = CharacterProfession.register("soto:dragracer")
SOTO.CharacterProfession.JUNKYARD_WORKER = CharacterProfession.register("soto:junkyardworker")
SOTO.CharacterProfession.LIFEGUARD = CharacterProfession.register("soto:lifeguard")
SOTO.CharacterProfession.DEMOLITION_WORKER = CharacterProfession.register("soto:demolitionworker")
SOTO.CharacterProfession.BUTCHER = CharacterProfession.register("soto:butcher")
SOTO.CharacterProfession.PAPARAZZI = CharacterProfession.register("soto:paparazzi")
SOTO.CharacterProfession.MINER = CharacterProfession.register("soto:miner")
SOTO.CharacterProfession.STORE_EMPLOYEE = CharacterProfession.register("soto:storeemployee")
SOTO.CharacterProfession.CRIMINAL = CharacterProfession.register("soto:criminal")
SOTO.CharacterProfession.ANIMAL_CONTROL_OFFICER = CharacterProfession.register("soto:animalcontrolofficer")
SOTO.CharacterProfession.HUNTSMAN = CharacterProfession.register("soto:huntsman")
SOTO.CharacterProfession.VETERINARIAN = CharacterProfession.register("soto:veterinarian")
	
	
--	CharacterTrait.WHITTLER:getName()
--	SOTO.CharacterTrait.WHITTLER:getName()

--   SOTO.CharacterProfession.SMITHER:getName()

--CharacterTrait.register("soto:enjoytheride")	
--CharacterTrait.register("soto:heavyaxemybeloved")
--CharacterTrait.register("soto:demostronggrip")
--CharacterTrait.register("soto:minersendurance")

-- ============================================================
-- ECLZ JOBS REGISTRY (merged; IDs intentionally unchanged)
-- ============================================================

-- ECLZJobs42 - Build 42.13+ registries
-- Keep these IDs stable: saved character builds reference them directly.

ECLZJobs = ECLZJobs or {}
ECLZJobs.CharacterProfession = ECLZJobs.CharacterProfession or {}

ECLZJobs.CharacterProfession.TAXISTA = CharacterProfession.register("eclzjobs:taxista")
ECLZJobs.CharacterProfession.JOYERO = CharacterProfession.register("eclzjobs:joyero")
ECLZJobs.CharacterProfession.CAMARERO = CharacterProfession.register("eclzjobs:camarero")
ECLZJobs.CharacterProfession.PRESO = CharacterProfession.register("eclzjobs:preso")
ECLZJobs.CharacterProfession.FARMACEUTICO = CharacterProfession.register("eclzjobs:farmaceutico")
ECLZJobs.CharacterProfession.ARMERO = CharacterProfession.register("eclzjobs:armero")
ECLZJobs.CharacterProfession.REPARTIDOR = CharacterProfession.register("eclzjobs:repartidor")
ECLZJobs.CharacterProfession.CONSERJE = CharacterProfession.register("eclzjobs:conserje")
ECLZJobs.CharacterProfession.MEDICO_COMBATE = CharacterProfession.register("eclzjobs:medicocombate")
ECLZJobs.CharacterProfession.PUEBLERINO = CharacterProfession.register("eclzjobs:pueblerino")
ECLZJobs.CharacterProfession.TATUADOR = CharacterProfession.register("eclzjobs:tatuador")

-- ============================================================
-- RLP / MEDICO FORENSE REGISTRY (merged; IDs intentionally stable)
-- ============================================================
RLP = RLP or {}
RLP.CharacterTrait = RLP.CharacterTrait or {}
RLP.CharacterProfession = RLP.CharacterProfession or {}

RLP.CharacterProfession.MEDICO_FORENSE = CharacterProfession.register("rlp:medicoforense")
-- Compatibility alias for the supplied Lua, without registering a second ID.
RLP.CharacterProfession.LAB_INTERN = RLP.CharacterProfession.MEDICO_FORENSE
RLP.CharacterTrait.AUTOPSY_SPECIALIST = CharacterTrait.register("rlp:autopsyspecialist")


```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/registries.lua`
SHA-256: `be80d75007c36b1c83faf703de6cc74b69b98f9aed5b5f32c613dbbf83b4277b`
```lua
EHRCharacterTraits = EHRCharacterTraits or {}
EHRCharacterProfessions = EHRCharacterProfessions or {}

EHRCharacterTraits.patientzero = CharacterTrait.register("ExtensiveHealth:patientzero")
EHRCharacterTraits.scalpelmaster = CharacterTrait.register("ExtensiveHealth:scalpelmaster")

EHRCharacterProfessions.ehrdoctor = CharacterProfession.register("ExtensiveHealth:ehrdoctor")
EHRCharacterProfessions.ehrsurgeon = CharacterProfession.register("ExtensiveHealth:ehrsurgeon")

```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/registries.lua`
SHA-256: `e837272c9024eb47e199d5bcaaf5dab7a49e9d0343a6830e45663a3a47db986c`
```lua
--------------------------------------------------------------------------------------------------
--		----	  |			  |			|		 |				|    --    |      ----			--
--		----	  |			  |			|		 |				|    --	   |      ----			--
--		----	  |		-------	   -----|	 ---------		-----          -      ----	   -------
--		----	  |			---			|		 -----		------        --      ----			--
--		----	  |			---			|		 -----		-------	 	 ---      ----			--
--		----	  |		-------	   ----------	 -----		-------		 ---      ----	   -------
--			|	  |		-------			|		 -----		-------		 ---		  |			--
--			|	  |		-------			|	 	 -----		-------		 ---		  |			--
--------------------------------------------------------------------------------------------------

--LSH = {}
--LSH.ItemKey = {}

local traits = {
	"Artistic","Disciplined","CouchPotato","Virtuoso","ToneDeaf","PartyAnimal","Killjoy","Sloppy","CleanFreak","Tidy",
	"disco","discono","beach","beachno","classical","classicalno","country","countryno","holiday","holidayno","jazz","jazzno","metal","metalno",
	"muzak","muzakno","pop","popno","rap","rapno","rbsoul","rbsoulno","reggae","reggaeno","rock","rockno","salsa","salsano","world","worldno",
	}

for n=1,#traits do
	CharacterTrait[string.upper(traits[n])] = CharacterTrait.register("Lifestyle:"..traits[n])
	--CharacterTrait.register("Lifestyle:"..traits[n])
end

--[[
local items = {
	{"BloodSausage","FOOD",false},
	"Artistic","Disciplined","CouchPotato","Virtuoso","ToneDeaf","PartyAnimal","Killjoy","Sloppy","CleanFreak","Tidy",
	"disco","discono","beach","beachno","classical","classicalno","country","countryno","holiday","holidayno","jazz","jazzno","metal","metalno",
	"muzak","muzakno","pop","popno","rap","rapno","rbsoul","rbsoulno","reggae","reggaeno","rock","rockno","salsa","salsano","world","worldno",
	}

for k, v in pairs(items) do
	

	CharacterTrait[string.upper(traits[n])] = CharacterTrait.register("Lifestyle:"..traits[n])
	--CharacterTrait.register("Lifestyle:"..traits[n])
end
]]--

ItemTag['LSInvention'] = ItemTag.register("Lifestyle:LSInvention")
```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua`
SHA-256: `8498b5a4c44ef78fe7f76a706ff340d4b31614f48b29e378389f62f6e356b416`
```lua

KATTAJ1_BodyLocation = {}

    -- Belt
    KATTAJ1_BodyLocation.KATTAJ1_BeltLeft       = ItemBodyLocation.register("KATTAJ1:BeltLeft")
    KATTAJ1_BodyLocation.KATTAJ1_BeltRight      = ItemBodyLocation.register("KATTAJ1:BeltRight")
    KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft   = ItemBodyLocation.register("KATTAJ1:BeltBackLeft")
    KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight  = ItemBodyLocation.register("KATTAJ1:BeltBackRight")

    -- Legs
    KATTAJ1_BodyLocation.KATTAJ1_UpperLegs      = ItemBodyLocation.register("KATTAJ1:UpperLegs")
    KATTAJ1_BodyLocation.KATTAJ1_LowerLegs      = ItemBodyLocation.register("KATTAJ1:LowerLegs")
    KATTAJ1_BodyLocation.KATTAJ1_Knees          = ItemBodyLocation.register("KATTAJ1:Knees")

    -- Arms
    KATTAJ1_BodyLocation.KATTAJ1_UpperArms      = ItemBodyLocation.register("KATTAJ1:UpperArms")
    KATTAJ1_BodyLocation.KATTAJ1_LowerArms      = ItemBodyLocation.register("KATTAJ1:LowerArms")
    KATTAJ1_BodyLocation.KATTAJ1_Elbows         = ItemBodyLocation.register("KATTAJ1:Elbows")

    -- Back / Head
    KATTAJ1_BodyLocation.KATTAJ1_BackFanny      = ItemBodyLocation.register("KATTAJ1:BackFanny")
    KATTAJ1_BodyLocation.KATTAJ1_Balaclava      = ItemBodyLocation.register("KATTAJ1:Balaclava")
    KATTAJ1_BodyLocation.KATTAJ1_Headsets       = ItemBodyLocation.register("KATTAJ1:Headsets")
    KATTAJ1_BodyLocation.KATTAJ1_Mandible       = ItemBodyLocation.register("KATTAJ1:Mandible")

    -- Chest / Rig
    KATTAJ1_BodyLocation.KATTAJ1_ChestRig       = ItemBodyLocation.register("KATTAJ1:ChestRig")

    -- Fanny packs
    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack       = ItemBodyLocation.register("KATTAJ1:TacticalFannyPack")
    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront  = ItemBodyLocation.register("KATTAJ1:TacticalFannyPackFront")

    -- Pants
    KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants    = ItemBodyLocation.register("KATTAJ1:SkinnyPants")

    -- Protection
    KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads   = ItemBodyLocation.register("KATTAJ1:ShoulderPads")
    KATTAJ1_BodyLocation.KATTAJ1_HipProtection  = ItemBodyLocation.register("KATTAJ1:HipProtection")

    -- Torso Extra
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic    = ItemBodyLocation.register("KATTAJ1:TorsoExtraPelvic")
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder  = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulder")
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulderPelvic")
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull      = ItemBodyLocation.register("KATTAJ1:TorsoExtraFull")



```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua`
SHA-256: `b5fb718a8ecec23504cc1bb5a305c25e17e9de3e7fc84b675fe71c48cbaeed8a`
```lua
ItemBodyLocation.register("AZ:HeadExtra")
ItemBodyLocation.register("AZ:HeadExtraHair")
ItemBodyLocation.register("AZ:HeadExtraPlus")

ItemBodyLocation.register("AZ:NeckExtra")
ItemBodyLocation.register("AZ:LegsExtra")

ItemBodyLocation.register("AZ:TorsoRigPlus2")
ItemBodyLocation.register("AZ:TorsoExtraPlus1")






```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.4/42/media/registries.lua`
SHA-256: `73d127488b276a5bf6b3f661d537325d0cd00f68bcf0a24c1d62b9b498fb9e90`
```lua
-- Runs via ModRegistries.init(), immediately before ScriptManager.Load() parses the item
-- scripts, so these ids resolve when a weapon declares AmmoType = gunsmithing:<id>.
-- The itemKey must be the full type; an ItemKey object stringifies to "Base.<id>" and so
-- can never name a modded item.

AmmoType.register("gunsmithing:musket_ball", "Gunsmithing.MusketBall")
AmmoType.register("gunsmithing:musket_bullet", "Gunsmithing.MusketBullet")
AmmoType.register("gunsmithing:paper_cartridge", "Gunsmithing.PaperCartridge")
AmmoType.register("gunsmithing:paper_cartridge_ball", "Gunsmithing.PaperCartridge_Ball")
AmmoType.register("gunsmithing:paper_cartridge_bullet", "Gunsmithing.PaperCartridge_Bullet")
AmmoType.register("gunsmithing:handmade_cartridge", "Gunsmithing.HandmadeCartridge")
AmmoType.register("gunsmithing:round_ball_44", "Gunsmithing.RoundBall_44")
AmmoType.register("gunsmithing:pistol_cartridge", "Gunsmithing.PistolCartridge")

```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.1/42.15/media/registries.lua`
SHA-256: `1d9532dbe43ffea2430b9d8ac3833993271f6e02e741b9ffaf6ca73d96c2a2e1`
```lua
HBTags = {}

HBTags.LightCasing = ItemTag.register("hb:lightcasing")
HBTags.MediumCasing = ItemTag.register("hb:mediumcasing")
HBTags.HeavyCasing = ItemTag.register("hb:heavycasing")
HBTags.ShotgunShell = ItemTag.register("hb:shotgunshell")

```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_2/42/media/registries.lua`
SHA-256: `41d6de9a476b3b471e417384d12dfe493e5c1bc91b588a931b3b2c14166151b0`
```lua
ItemTag.register("ZVirusVaccine42BETA:TestTag")
ItemTag.register("ZVirusVaccine42BETA:Workbench")
ItemTag.register("ZVirusVaccine42BETA:Centrifuge")
ItemTag.register("ZVirusVaccine42BETA:ChemistrySet")
ItemTag.register("ZVirusVaccine42BETA:Chromatograph")
ItemTag.register("ZVirusVaccine42BETA:Spectrometer")
ItemTag.register("ZVirusVaccine42BETA:MuffleFurnace")
ItemTag.register("ZVirusVaccine42BETA:Microscope")
ItemTag.register("ZVirusVaccine42BETA:Easel")
--ItemType.register("ZVirusVaccine42BETA:freshblood")
--ItemType.register("ZVirusVaccine42BETA:oldblood")
--CraftRecipe.register("ZVirusVaccine42:ReceitaTesteMP")
```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_Ajustes/42.18/media/registries.lua`
SHA-256: `041fd6104e08cd01ebd08c320fc72d124c3c01f8e8a51a4960114afef1614765`
```lua
-- ECZ B42.20 - corrección 03-08-2026
--
-- Este archivo sustituye el registro inválido añadido por la actualización anterior:
--   ItemTag.register("base:keyduplicator")
--   ItemTag.register("base:choppingblock")
--
-- Build 42.20 rechaza el espacio de nombres predeterminado "base:" dentro de
-- ItemTag.register(), provocando excepciones Lua durante cada ResetLua.
-- Las etiquetas originales siguen pudiendo ser descubiertas por sus mods de origen.
-- Se deja el archivo intencionadamente sin llamadas de registro.

```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_18/42/media/registries.lua`
SHA-256: `7bdf09396a3c58e7d9f51fa09ad8d5242fee8a25f93a615c4fbaa19ed58f74a7`
```lua
-- This file MUST be named registries.lua and placed in the media folder
-- It loads before scripts and other Lua files

ItemType.register("ttrp:normal")
ItemTag.register("ttrp:forbidden")
```
### `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua`
SHA-256: `ac96851c8630ef7505719833c907ec27c10680f40a9169f6a77ab2a1e0e28409`
```lua

SpnOpenCloth = {}
SpnOpenCloth.ItemBodyLocation = {}

SpnOpenCloth.ItemBodyLocation.JACKET_OPEN = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPEN")
SpnOpenCloth.ItemBodyLocation.JACKET_ROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_ROLL")
SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPENROLL")
```
### `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/registries.lua`
SHA-256: `8a459498e99ff9ca57ec3986ff80e9d478828b6a4bbde2bab6a708dc2846acad`
```lua
SapphCookingRegistries = {}

--base Tag

-- item tags --
SapphCookingRegistries.tags = {

    -- mod tags --
    
ricegrain = ItemTag.register("sapphcooking:ricegrain"),
thermos = ItemTag.register("sapphcooking:thermos"),
coffeecup = ItemTag.register("sapphcooking:coffeecup"),
returnthermos = ItemTag.register("sapphcooking:returnthermos"),
returnsaucepan = ItemTag.register("sapphcooking:returnsaucepan"),
returnwokpan = ItemTag.register("sapphcooking:returnwokpan"),
returnbowl = ItemTag.register("sapphcooking:returnbowl"),
dontreturnbowl = ItemTag.register("sapphcooking:dontreturnbowl"),
iscake = ItemTag.register("sapphcooking:iscake"),
juice = ItemTag.register("sapphcooking:juice"),
baconeggspan = ItemTag.register("sapphcooking:baconeggspan"),
eggboiled = ItemTag.register("sapphcooking:eggboiled"),
meltedchocolate = ItemTag.register("sapphcooking:meltedchocolate"),
chocolate = ItemTag.register("sapphcooking:chocolate"),
cookedrice = ItemTag.register("sapphcooking:cookedrice"),
isrisotto = ItemTag.register("sapphcooking:isrisotto"),
icing = ItemTag.register("sapphcooking:icing"),
syrup = ItemTag.register("sapphcooking:syrup"),
sausage = ItemTag.register("sapphcooking:sausage"),
mushroom = ItemTag.register("sapphcooking:mushroom"),
peas = ItemTag.register("sapphcooking:peas"),
beans = ItemTag.register("sapphcooking:beans"),
sourcream = ItemTag.register("sapphcooking:sourcream"),
slicedvegetables = ItemTag.register("sapphcooking:slicedvegetables"),
chicken = ItemTag.register("sapphcooking:chicken"),
beef = ItemTag.register("sapphcooking:beef"),
turkey = ItemTag.register("sapphcooking:turkey"),
pork = ItemTag.register("sapphcooking:pork"),
pastrycream = ItemTag.register("sapphcooking:pastrycream"),
salt = ItemTag.register("sapphcooking:salt"),
soysauce = ItemTag.register("sapphcooking:soysauce"),
pepper = ItemTag.register("sapphcooking:pepper"),
broth = ItemTag.register("sapphcooking:broth"),
bread = ItemTag.register("sapphcooking:bread"),
mincedmeat = ItemTag.register("sapphcooking:mincedmeat"),
carrot = ItemTag.register("sapphcooking:carrot"),
potato = ItemTag.register("sapphcooking:potato"),
citrus = ItemTag.register("sapphcooking:citrus"),
beets = ItemTag.register("sapphcooking:beets"),
berry = ItemTag.register("sapphcooking:berry"),
tomato = ItemTag.register("sapphcooking:tomato"), -- for all tomato dishes
custombottles = ItemTag.register("sapphcooking:custombottles"), -- for all custom bottles
oilpan = ItemTag.register("sapphcooking:oilpan"),
oilpanbig = ItemTag.register("sapphcooking:oilpanbig")

}
-- fliers --

--[[
Flier.register("sapphcooking:Fortune1")
Flier.register("sapphcooking:Fortune2")
Flier.register("sapphcooking:Fortune3")
Flier.register("sapphcooking:Fortune4")
Flier.register("sapphcooking:Fortune5")
Flier.register("sapphcooking:Fortune6")
Flier.register("sapphcooking:Fortune7")
Flier.register("sapphcooking:Fortune8")
Flier.register("sapphcooking:Fortune9")
Flier.register("sapphcooking:Fortune10")
]]--




-- body locations --
ItemBodyLocation.register("sapphcooking:chefapron")

--[[
SapphCookingRegistries.traits = {
    -- "mymod:mytrait" is the identifier for this trait
    -- "mymod" is the namespace for your trait: this should be the same for all registries in your mod
    cook5 = CharacterTrait.register("sapphcooking:cook5"),
    cook6 = CharacterTrait.register("sapphcooking:cook6")
}
]]--
```
### `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua`
SHA-256: `8498b5a4c44ef78fe7f76a706ff340d4b31614f48b29e378389f62f6e356b416`
```lua

KATTAJ1_BodyLocation = {}

    -- Belt
    KATTAJ1_BodyLocation.KATTAJ1_BeltLeft       = ItemBodyLocation.register("KATTAJ1:BeltLeft")
    KATTAJ1_BodyLocation.KATTAJ1_BeltRight      = ItemBodyLocation.register("KATTAJ1:BeltRight")
    KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft   = ItemBodyLocation.register("KATTAJ1:BeltBackLeft")
    KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight  = ItemBodyLocation.register("KATTAJ1:BeltBackRight")

    -- Legs
    KATTAJ1_BodyLocation.KATTAJ1_UpperLegs      = ItemBodyLocation.register("KATTAJ1:UpperLegs")
    KATTAJ1_BodyLocation.KATTAJ1_LowerLegs      = ItemBodyLocation.register("KATTAJ1:LowerLegs")
    KATTAJ1_BodyLocation.KATTAJ1_Knees          = ItemBodyLocation.register("KATTAJ1:Knees")

    -- Arms
    KATTAJ1_BodyLocation.KATTAJ1_UpperArms      = ItemBodyLocation.register("KATTAJ1:UpperArms")
    KATTAJ1_BodyLocation.KATTAJ1_LowerArms      = ItemBodyLocation.register("KATTAJ1:LowerArms")
    KATTAJ1_BodyLocation.KATTAJ1_Elbows         = ItemBodyLocation.register("KATTAJ1:Elbows")

    -- Back / Head
    KATTAJ1_BodyLocation.KATTAJ1_BackFanny      = ItemBodyLocation.register("KATTAJ1:BackFanny")
    KATTAJ1_BodyLocation.KATTAJ1_Balaclava      = ItemBodyLocation.register("KATTAJ1:Balaclava")
    KATTAJ1_BodyLocation.KATTAJ1_Headsets       = ItemBodyLocation.register("KATTAJ1:Headsets")
    KATTAJ1_BodyLocation.KATTAJ1_Mandible       = ItemBodyLocation.register("KATTAJ1:Mandible")

    -- Chest / Rig
    KATTAJ1_BodyLocation.KATTAJ1_ChestRig       = ItemBodyLocation.register("KATTAJ1:ChestRig")

    -- Fanny packs
    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack       = ItemBodyLocation.register("KATTAJ1:TacticalFannyPack")
    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront  = ItemBodyLocation.register("KATTAJ1:TacticalFannyPackFront")

    -- Pants
    KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants    = ItemBodyLocation.register("KATTAJ1:SkinnyPants")

    -- Protection
    KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads   = ItemBodyLocation.register("KATTAJ1:ShoulderPads")
    KATTAJ1_BodyLocation.KATTAJ1_HipProtection  = ItemBodyLocation.register("KATTAJ1:HipProtection")

    -- Torso Extra
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic    = ItemBodyLocation.register("KATTAJ1:TorsoExtraPelvic")
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder  = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulder")
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulderPelvic")
    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull      = ItemBodyLocation.register("KATTAJ1:TorsoExtraFull")



```
### `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua`
SHA-256: `b5fb718a8ecec23504cc1bb5a305c25e17e9de3e7fc84b675fe71c48cbaeed8a`
```lua
ItemBodyLocation.register("AZ:HeadExtra")
ItemBodyLocation.register("AZ:HeadExtraHair")
ItemBodyLocation.register("AZ:HeadExtraPlus")

ItemBodyLocation.register("AZ:NeckExtra")
ItemBodyLocation.register("AZ:LegsExtra")

ItemBodyLocation.register("AZ:TorsoRigPlus2")
ItemBodyLocation.register("AZ:TorsoExtraPlus1")






```
### `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua`
SHA-256: `ac96851c8630ef7505719833c907ec27c10680f40a9169f6a77ab2a1e0e28409`
```lua

SpnOpenCloth = {}
SpnOpenCloth.ItemBodyLocation = {}

SpnOpenCloth.ItemBodyLocation.JACKET_OPEN = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPEN")
SpnOpenCloth.ItemBodyLocation.JACKET_ROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_ROLL")
SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPENROLL")
```

## Todas las coincidencias
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:118` — `local function ApplyBayonetWeaponWear(character, tempWeapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:120` — `    if not context or context.weaponWearProcessed then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:122` — `    context.weaponWearProcessed = true`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:489` — `        weaponWearProcessed = false,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:574` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:578` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:582` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/registries.lua:75` — `ItemBodyLocation.register("sapphcooking:chefapron")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:26` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:46` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:66` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:98` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:103` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:124` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:129` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:148` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:152` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:172` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:174` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:196` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:197` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:220` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:221` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:245` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:246` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:269` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:270` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:294` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:295` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:318` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:319` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:343` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:344` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:367` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:368` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:392` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:393` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:417` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:418` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:442` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:443` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:467` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:468` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:492` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:493` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:516` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:517` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:541` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:542` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:565` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:566` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:590` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:591` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:614` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:615` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:640` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:641` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:664` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:665` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:689` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:693` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:713` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:715` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:737` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:741` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:761` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:763` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:786` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:790` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:810` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:812` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:835` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:839` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:859` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:861` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:884` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:888` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:908` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:910` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:933` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:937` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:957` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:959` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:982` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:986` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:1006` — `		BodyLocation = sapphcooking:chefapron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/scripts/items/SapphCooking_clothes.txt:1008` — `		CanBeEquipped = ChefApron,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:9` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:23` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:37` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:51` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:65` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:79` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:93` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:107` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:121` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:135` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:149` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:163` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:177` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:191` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:205` — `        BodyLocation = MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:219` — `        BodyLocation = MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:233` — `        BodyLocation = MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:247` — `        BodyLocation = MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:261` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:275` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:289` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:303` — `        BodyLocation = BodyCostume,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:317` — `        BodyLocation = base:necklace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:330` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:344` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:358` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:372` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:386` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:400` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_13.1/42/media/scripts/generated/items/LC_clothing.txt:414` — `        BodyLocation = base:necklace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_1/42/media/lua/client/SOTOclientMainFunctions.lua:526` — `		local wornItems = player:getWornItems();`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_1/42/media/lua/client/SOTOclientMainFunctions.lua:616` — `	local wornItems = player:getWornItems();`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:10` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:28` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:46` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:64` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:82` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:100` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:119` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:140` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:161` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:182` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:203` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:224` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:245` — `		BodyLocation = base:pants_skinny,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:266` — `		BodyLocation = base:pants_skinny,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:287` — `		BodyLocation = base:pants_skinny,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:308` — `		BodyLocation = base:pants_skinny,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:329` — `		BodyLocation = base:pants_skinny,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:350` — `		BodyLocation = base:pants_skinny,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:372` — `		BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:389` — `		BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:405` — `		BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:426` — `		BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:446` — `		BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:467` — `		BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:487` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:505` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:523` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:541` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:558` — `		BodyLocation = base:webbing,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:559` — `		CanBeEquipped = Webbing,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:582` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:601` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:620` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:639` — `		BodyLocation = base:fullhat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:661` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:683` — `		BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:699` — `		BodyLocation = base:makeup_fullface,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:718` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:734` — `		BodyLocation = base:beltextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:748` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:764` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:782` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_12/42.13/media/scripts/clothing/VGE_Clothes.txt:801` — `		BodyLocation = base:ears,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:11` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:31` — `        BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:52` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:68` — `        BodyLocation = base:Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:83` — `        BodyLocation = base:ammostrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:88` — `        CanBeEquipped = base:ammostrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:105` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:123` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:141` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:161` — `        BodyLocation = base:Gorget,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:187` — `        BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:209` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:228` — `        BodyLocation = base:Sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:244` — `        BodyLocation = base:Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:260` — `        BodyLocation = base:Scarf,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:278` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:299` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:317` — `        BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:332` — `        BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:347` — `        BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:363` — `        BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:378` — `        BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:391` — `        BodyLocation = base:knee_left,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:418` — `        BodyLocation = base:knee_Right,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:447` — `        BodyLocation = Elbow_Left,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:462` — `        BodyLocation = Elbow_Right,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:477` — `        BodyLocation = base:Thigh_Left,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:481` — `        CanBeEquipped = base:Thigh_Left,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:497` — `        BodyLocation = base:Thigh_Right,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:501` — `        CanBeEquipped = base:Thigh_Right,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_17/42/media/scripts/CopClothing.txt:517` — `        BodyLocation = base:ForeArm_Left,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/scripts/EHR_Watches.txt:17` — `        BodyLocation = base:rightwrist,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/scripts/EHR_Watches.txt:37` — `        BodyLocation = base:leftwrist,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_EnvironmentalDiseases.lua:898` — `        if item.getBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_EnvironmentalDiseases.lua:899` — `            pcall(function() location = item:getBodyLocation() end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_EnvironmentalDiseases.lua:922` — `    pcall(function() wornItems = player:getWornItems() end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:615` — `local function getBodyLocationText(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:616` — `    if not item or not item.getBodyLocation then return "" end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:617` — `    local ok, value = pcall(function() return item:getBodyLocation() end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:627` — `    local loc = getBodyLocationText(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:662` — `    if not player or not player.getWornItems then return result end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:664` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_BodyTemperature.lua:1106` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_BodyTemperature.lua:1128` — `                local location = item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:360` — `    if player.getWornItem and ItemBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:361` — `        local locations = { ItemBodyLocation.HANDS, ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.HANDS_RIGHT }`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:364` — `            pcall(function() if location then item = player:getWornItem(location) end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:369` — `    if not player.getWornItems then return nil end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:370` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:376` — `            pcall(function() if item.getBodyLocation then location = item:getBodyLocation() end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_ServerCommands.lua:157` — `    if not player or not player.getWornItems then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_ServerCommands.lua:160` — `        return player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:235` — `    if player.getWornItem and ItemBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:236` — `        local locations = { ItemBodyLocation.HANDS, ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.HANDS_RIGHT }`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:239` — `            pcall(function() if location then item = player:getWornItem(location) end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:243` — `    if not player.getWornItems then return nil end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:244` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:250` — `            pcall(function() if item.getBodyLocation then location = item:getBodyLocation() end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HealthPanelUI.lua:2961` — `    if not player or not player.getWornItems then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HealthPanelUI.lua:2963` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:92` — `    if player.getWornItem and ItemBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:93` — `        local locations = { ItemBodyLocation.HANDS, ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.HANDS_RIGHT }`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:96` — `            pcall(function() if location then item = player:getWornItem(location) end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:101` — `    if not player.getWornItems then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:102` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:108` — `            pcall(function() if item.getBodyLocation then location = item:getBodyLocation() end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:118` — `local function ApplyBayonetWeaponWear(character, tempWeapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:120` — `    if not context or context.weaponWearProcessed then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:122` — `    context.weaponWearProcessed = true`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:489` — `        weaponWearProcessed = false,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:574` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:578` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:582` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/scripts/Lifestyle_items.txt:583` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/scripts/Lifestyle_items.txt:601` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:695` — `		equipAction = ISWearClothing:new(character,item,50)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:771` — `	character:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:805` — `		--character:setWornItem(item:getBodyLocation(), item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:290` — `				if player:isEquippedClothing(newItem) then player:removeWornItem(newItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:442` — `		if (instanceof(item, "InventoryContainer") and item:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:443` — `			player:setWornItem(item:canBeEquipped(), item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:446` — `			player:setWornItem(item:getBodyLocation(), item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:459` — `	if player:isEquippedClothing(item) then player:removeWornItem(item); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:487` — `		player:removeWornItem(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:503` — `	local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:508` — `		local location = item and item.getBodyLocation and item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:111` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:114` — `        if item:getFullType() == itemToBeWorn and item:getBodyLocation() == itemToBeWorn:getBodyLocation() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:122` — `	local hatSlot = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:127` — `	local bL = item.getBodyLocation and item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:128` — `	local validBl = bL and bL ~= "" and (not hasNeuralHat(character) or (bL ~= ItemBodyLocation.HAT and bL ~= ItemBodyLocation.FULL_HAT and bL ~= ItemBodyLocation.MASK_FULL))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:130` — `		local contBl = instanceof(item, "InventoryContainer") and item:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:131` — `		validBl = contBl and contBl ~= "" and (not hasNeuralHat(character) or (contBl ~= ItemBodyLocation.HAT and contBl ~= ItemBodyLocation.FULL_HAT and contBl ~= ItemBodyLocation.MASK_FULL))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:156` — `				player:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:180` — `							if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:181` — `								player:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:184` — `							player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:235` — `				if not isClient() then player:removeWornItem(item, false); end --!`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:284` — `				if itemToBeWorn and itemToBeWorn:getCategory() == "Clothing" and player:getWornItem(itemToBeWorn:getBodyLocation()) == itemToBeWorn then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:293` — `						--player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:298` — `						if player:getHumanVisual():getHairModel():contains("Mohawk") and (itemToBeWorn:getBodyLocation() == "Hat" or itemToBeWorn:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:373` — `				--player:removeWornItem(item, false) --!`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:473` — `									--	if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:474` — `									--		player:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:477` — `									--		player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:483` — `										if player:getHumanVisual():getHairModel():contains("Mohawk") and (itemToBeWorn:getBodyLocation() == "Hat" or itemToBeWorn:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:531` — `	--				if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) and isItemNotEquipped == true then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:541` — `	--					if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:542` — `	--						player:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:545` — `	--					player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:552` — `	--					if player:getHumanVisual():getHairModel():contains("Mohawk") and (itemToBeWorn:getBodyLocation() == "Hat" or itemToBeWorn:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeSet.lua:11` — `	local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/Helper/TransferHelper.lua:255` — `		local canEquip = item.canBeEquipped and item:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/Helper/TransferHelper.lua:257` — `			character:setWornItem(item:getBodyLocation(), item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:235` — `		if item:getClothingItem() and self.character:isEquippedClothing(item) and (item:getBodyLocation() == "Bottoms" or item:getBodyLocation() == "Underwear" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:236` — `		item:getBodyLocation() == "Skirt" or item:getBodyLocation() == "Legs1" or item:getBodyLocation() == "Pants" or item:getBodyLocation() == "UnderwearBottom" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:237` — `		item:getBodyLocation() == "Torso1Legs1" or item:getBodyLocation() == "BathRobe" or item:getBodyLocation() == "FullSuit" or item:getBodyLocation() == "Tail" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:238` — `		item:getBodyLocation() == "FullSuitHead" or item:getBodyLocation() == "Boilersuit" or item:getBodyLocation() == "Dress") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:250` — `			self.character:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:315` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:320` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:321` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:324` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:389` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:394` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:395` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:398` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseTub.lua:840` — `		local item = self.character:getWornItem(ItemBodyLocation[makeup])`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseTub.lua:842` — `			self.character:removeWornItem(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseShower.lua:619` — `		local item = self.character:getWornItem(ItemBodyLocation[makeup])`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseShower.lua:621` — `			self.character:removeWornItem(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:269` — `		if item:getClothingItem() and self.character:isEquippedClothing(item) and (item:getBodyLocation() == "Bottoms" or item:getBodyLocation() == "Underwear" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:270` — `		item:getBodyLocation() == "Skirt" or item:getBodyLocation() == "Legs1" or item:getBodyLocation() == "Pants" or item:getBodyLocation() == "UnderwearBottom" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:271` — `		item:getBodyLocation() == "Torso1Legs1" or item:getBodyLocation() == "BathRobe" or item:getBodyLocation() == "FullSuit" or item:getBodyLocation() == "Tail" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:272` — `		item:getBodyLocation() == "FullSuitHead" or item:getBodyLocation() == "Boilersuit" or item:getBodyLocation() == "Dress") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:284` — `			self.character:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:455` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:460` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:461` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:464` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:613` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:618` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:619` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:622` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSBrushTeeth.lua:231` — `	local item = self.character:getWornItem("MakeUp_Lips");`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSBrushTeeth.lua:238` — `		self.character:removeWornItem(item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:11` — `require "TimedActions/ISWearClothing"`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:14` — `	local hatSlot = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:21` — `		bL = item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:23` — `		bL = item:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:26` — `		if bL ~= ItemBodyLocation.HAT and bL ~= ItemBodyLocation.FULL_HAT and bL ~= ItemBodyLocation.MASK_FULL then return true; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:32` — `local og_start = ISWearClothing.start;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:33` — `function ISWearClothing:start()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Read.lua:25` — `	local headgear = self.character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:36` — `local function MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:37` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:41` — `			if makeup then bodyLocationItem = character:getWornItem(makeup:getBodyLocation()); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:42` — `			--if bodyLocationItem then print("MMgetMakeupBottomOptions: found an item for bodyLocationItem, name is: " .. bodyLocationItem:getName()); break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:43` — `			if bodyLocationItem then break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:46` — `	return bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:85` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:89` — `			bodyLocationItem = MMgetMakeupBodyLocationItem(character, data)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:90` — `			--print("LSMirrorMenu_server.setMirrorChanges - bodyLocationItem set")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:91` — `		elseif bodyLocationItem then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:94` — `				playerInv:AddItem(bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:95` — `				sendAddItemToContainer(playerInv, bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:102` — `				local bodyL = bodyLocationItem:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:103` — `				character:setWornItem(bodyL, bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:104` — `				sendClothing(character,bodyL, bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:106` — `				--if bodyLocationItem.UseAndSync then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:107` — `				--	bodyLocationItem:UseAndSync()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:108` — `				--	sendItemStats(bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:111` — `			bodyLocationItem = false`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:37` — `local function MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:38` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:42` — `			if makeup then bodyLocationItem = character:getWornItem(makeup:getBodyLocation()); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:43` — `			--if bodyLocationItem then print("MMgetMakeupBottomOptions: found an item for bodyLocationItem, name is: " .. bodyLocationItem:getName()); break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:44` — `			if bodyLocationItem then break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:47` — `	return bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:163` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:168` — `			bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, data)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:169` — `		elseif bodyLocationItem then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:172` — `					playerInv:AddItem(bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:176` — `					--if bodyLocationItem.Use then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:177` — `					--	bodyLocationItem:Use()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:182` — `			bodyLocationItem = false`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:194` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:210` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:211` — `		if (self.resetMakeupFull ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupFull and (self.resetMakeupFull ~= 0) then self.character:setWornItem(self.resetMakeupFull:getBodyLocation(), self.resetMakeupFull); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:214` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:215` — `		if (self.resetMakeupEye ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEye and (self.resetMakeupEye ~= 0) then self.character:setWornItem(self.resetMakeupEye:getBodyLocation(), self.resetMakeupEye); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:218` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:219` — `		if (self.resetMakeupEyeShadow ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow ~= 0) then self.character:setWornItem(self.resetMakeupEyeShadow:getBodyLocation(), self.resetMakeupEyeShadow); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:222` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:223` — `		if (self.resetMakeupLipstick ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupLipstick and (self.resetMakeupLipstick ~= 0) then self.character:setWornItem(self.resetMakeupLipstick:getBodyLocation(), self.resetMakeupLipstick); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:226` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:227` — `		if (self.resetMakeupTattooFace ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooFace and (self.resetMakeupTattooFace ~= 0) then self.character:setWornItem(self.resetMakeupTattooFace:getBodyLocation(), self.resetMakeupTattooFace); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:230` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:231` — `		if (self.resetMakeupTattooUB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooUB and (self.resetMakeupTattooUB ~= 0) then self.character:setWornItem(self.resetMakeupTattooUB:getBodyLocation(), self.resetMakeupTattooUB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:234` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:235` — `		if (self.resetMakeupTattooLB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLB and (self.resetMakeupTattooLB ~= 0) then self.character:setWornItem(self.resetMakeupTattooLB:getBodyLocation(), self.resetMakeupTattooLB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:238` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:239` — `		if (self.resetMakeupTattooBack ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooBack and (self.resetMakeupTattooBack ~= 0) then self.character:setWornItem(self.resetMakeupTattooBack:getBodyLocation(), self.resetMakeupTattooBack); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:242` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:243` — `		if (self.resetMakeupTattooLA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLA and (self.resetMakeupTattooLA ~= 0) then self.character:setWornItem(self.resetMakeupTattooLA:getBodyLocation(), self.resetMakeupTattooLA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:246` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:247` — `		if (self.resetMakeupTattooRA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRA and (self.resetMakeupTattooRA ~= 0) then self.character:setWornItem(self.resetMakeupTattooRA:getBodyLocation(), self.resetMakeupTattooRA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:250` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:251` — `		if (self.resetMakeupTattooLL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLL and (self.resetMakeupTattooLL ~= 0) then self.character:setWornItem(self.resetMakeupTattooLL:getBodyLocation(), self.resetMakeupTattooLL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:254` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:255` — `		if (self.resetMakeupTattooRL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRL and (self.resetMakeupTattooRL ~= 0) then self.character:setWornItem(self.resetMakeupTattooRL:getBodyLocation(), self.resetMakeupTattooRL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:273` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:274` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:275` — `	if (self.resetMakeupFull ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupFull and (self.resetMakeupFull ~= 0) then self.character:setWornItem(self.resetMakeupFull:getBodyLocation(), self.resetMakeupFull); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:276` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:277` — `	if (self.resetMakeupEye ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEye and (self.resetMakeupEye ~= 0) then self.character:setWornItem(self.resetMakeupEye:getBodyLocation(), self.resetMakeupEye); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:278` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:279` — `	if (self.resetMakeupEyeShadow ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow ~= 0) then self.character:setWornItem(self.resetMakeupEyeShadow:getBodyLocation(), self.resetMakeupEyeShadow); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:280` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:281` — `	if (self.resetMakeupLipstick ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupLipstick and (self.resetMakeupLipstick ~= 0) then self.character:setWornItem(self.resetMakeupLipstick:getBodyLocation(), self.resetMakeupLipstick); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:282` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:283` — `	if (self.resetMakeupTattooFace ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooFace and (self.resetMakeupTattooFace ~= 0) then self.character:setWornItem(self.resetMakeupTattooFace:getBodyLocation(), self.resetMakeupTattooFace); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:284` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:285` — `	if (self.resetMakeupTattooUB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooUB and (self.resetMakeupTattooUB ~= 0) then self.character:setWornItem(self.resetMakeupTattooUB:getBodyLocation(), self.resetMakeupTattooUB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:286` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:287` — `	if (self.resetMakeupTattooLB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLB and (self.resetMakeupTattooLB ~= 0) then self.character:setWornItem(self.resetMakeupTattooLB:getBodyLocation(), self.resetMakeupTattooLB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:288` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:289` — `	if (self.resetMakeupTattooBack ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooBack and (self.resetMakeupTattooBack ~= 0) then self.character:setWornItem(self.resetMakeupTattooBack:getBodyLocation(), self.resetMakeupTattooBack); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:290` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:291` — `	if (self.resetMakeupTattooLA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLA and (self.resetMakeupTattooLA ~= 0) then self.character:setWornItem(self.resetMakeupTattooLA:getBodyLocation(), self.resetMakeupTattooLA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:292` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:293` — `	if (self.resetMakeupTattooRA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRA and (self.resetMakeupTattooRA ~= 0) then self.character:setWornItem(self.resetMakeupTattooRA:getBodyLocation(), self.resetMakeupTattooRA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:294` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:295` — `	if (self.resetMakeupTattooLL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLL and (self.resetMakeupTattooLL ~= 0) then self.character:setWornItem(self.resetMakeupTattooLL:getBodyLocation(), self.resetMakeupTattooLL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:296` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:297` — `	if (self.resetMakeupTattooRL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRL and (self.resetMakeupTattooRL ~= 0) then self.character:setWornItem(self.resetMakeupTattooRL:getBodyLocation(), self.resetMakeupTattooRL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:314` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:318` — `			bodyLocationItem = self.character:getWornItem(makeup:getBodyLocation())`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:319` — `			if bodyLocationItem then break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:323` — `	if not bodyLocationItem then return; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:325` — `	if button.internal == "FullFace" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupFull = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:326` — `	elseif button.internal == "Eyes" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupEye = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:327` — `	elseif button.internal == "EyesShadow" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupEyeShadow = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:328` — `	elseif button.internal == "Lips" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupLipstick = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:330` — `	elseif button.internal == "Face_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooFace = 0; elseif button.internal == "UpperBody_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooUB = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:331` — `	elseif button.internal == "LowerBody_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooLB = 0; elseif button.internal == "Back_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooBack = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:332` — `	elseif button.internal == "LeftArm_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooLA = 0; elseif button.internal == "RightArm_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooRA = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:333` — `	elseif button.internal == "LeftLeg_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooLL = 0; elseif button.internal == "RightLeg_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooRL = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:358` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:360` — `	if self.resetMakeupFull and (self.resetMakeupFull == 0) and (makeupCat == "FullFace") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace"); self.resetMakeupFull = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:361` — `	if self.resetMakeupEye and (self.resetMakeupEye == 0) and (makeupCat == "Eyes") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes"); self.resetMakeupEye = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:362` — `	if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow == 0) and (makeupCat == "EyesShadow") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow"); self.resetMakeupEyeShadow = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:363` — `	if self.resetMakeupLipstick and (self.resetMakeupLipstick == 0) and (makeupCat == "Lips") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips"); self.resetMakeupLipstick = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:365` — `	if self.resetMakeupTattooFace and (self.resetMakeupTattooFace == 0) and (makeupCat == "Face_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo"); self.resetMakeupTattooFace = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:366` — `	if self.resetMakeupTattooUB and (self.resetMakeupTattooUB == 0) and (makeupCat == "UpperBody_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo"); self.resetMakeupTattooUB = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:367` — `	if self.resetMakeupTattooLB and (self.resetMakeupTattooLB == 0) and (makeupCat == "LowerBody_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo"); self.resetMakeupTattooLB = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:368` — `	if self.resetMakeupTattooBack and (self.resetMakeupTattooBack == 0) and (makeupCat == "Back_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo"); self.resetMakeupTattooBack = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:370` — `	if self.resetMakeupTattooLA and (self.resetMakeupTattooLA == 0) and (makeupCat == "LeftArm_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo"); self.resetMakeupTattooLA = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:371` — `	if self.resetMakeupTattooRA and (self.resetMakeupTattooRA == 0) and (makeupCat == "RightArm_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo"); self.resetMakeupTattooRA = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:372` — `	if self.resetMakeupTattooLL and (self.resetMakeupTattooLL == 0) and (makeupCat == "LeftLeg_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo"); self.resetMakeupTattooLL = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:373` — `	if self.resetMakeupTattooRL and (self.resetMakeupTattooRL == 0) and (makeupCat == "RightLeg_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo"); self.resetMakeupTattooRL = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:392` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:393` — `	if bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:395` — `	self.character:setWornItem(makeup:getBodyLocation(), makeup);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:489` — `	local bodyLocationItem = MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:491` — `	if bodyLocationItem then previousMakeUp = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:498` — `		if previousMakeup then character:removeWornItem(previousMakeup); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:500` — `		character:setWornItem(makeup:getBodyLocation(), makeup);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:522` — `				if previousMakeup then character:removeWornItem(previousMakeup); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:530` — `						resetPlayerModel = character:getWornItem(makeup:getBodyLocation())`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:531` — `						if resetPlayerModel then character:removeWornItem(resetPlayerModel); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:533` — `					character:setWornItem(makeup:getBodyLocation(), makeup);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:556` — `			character:removeWornItem(previousMakeup)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:558` — `		if bodyLocationItem then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:559` — `			local newBodyLocationItem = MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:560` — `			if newBodyLocationItem then character:removeWornItem(newBodyLocationItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:561` — `			character:setWornItem(bodyLocationItem:getBodyLocation(), bodyLocationItem);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:566` — `			bodyLocationItem = MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:567` — `			if bodyLocationItem then character:removeWornItem(bodyLocationItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1827` — `	self.mO.FF = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1828` — `	self.mO.E = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1829` — `	self.mO.ES = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1830` — `	self.mO.L = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1835` — `		self.mO.FT = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1836` — `		self.mO.UBT = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1837` — `		self.mO.LBT = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1838` — `		self.mO.BT = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1839` — `		self.mO.LAT = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1840` — `		self.mO.RAT = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1841` — `		self.mO.LLT = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1842` — `		self.mO.RLT = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1940` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1941` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1942` — `	if (self.resetMakeupFull ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupFull and (self.resetMakeupFull ~= 0) then self.character:setWornItem(self.resetMakeupFull:getBodyLocation(), self.resetMakeupFull); elseif (not bodyLocationItem) and self.mO and self.mO.FF then self.character:setWornItem(self.mO.FF:getBodyLocation(), self.mO.FF); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1943` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1944` — `	if (self.resetMakeupEye ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEye and (self.resetMakeupEye ~= 0) then self.character:setWornItem(self.resetMakeupEye:getBodyLocation(), self.resetMakeupEye); elseif (not bodyLocationItem) and self.mO and self.mO.E then self.character:setWornItem(self.mO.E:getBodyLocation(), self.mO.E); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1945` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1946` — `	if (self.resetMakeupEyeShadow ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow ~= 0) then self.character:setWornItem(self.resetMakeupEyeShadow:getBodyLocation(), self.resetMakeupEyeShadow); elseif (not bodyLocationItem) and self.mO and self.mO.ES then self.character:setWornItem(self.mO.ES:getBodyLocation(), self.mO.ES); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1947` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1948` — `	if (self.resetMakeupLipstick ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupLipstick and (self.resetMakeupLipstick ~= 0) then self.character:setWornItem(self.resetMakeupLipstick:getBodyLocation(), self.resetMakeupLipstick); elseif (not bodyLocationItem) and self.mO and self.mO.L then self.character:setWornItem(self.mO.L:getBodyLocation(), self.mO.L); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1949` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1950` — `	if (self.resetMakeupTattooFace ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooFace and (self.resetMakeupTattooFace ~= 0) then self.character:setWornItem(self.resetMakeupTattooFace:getBodyLocation(), self.resetMakeupTattooFace); elseif (not bodyLocationItem) and self.mO and self.mO.FT then self.character:setWornItem(self.mO.FT:getBodyLocation(), self.mO.FT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1951` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1952` — `	if (self.resetMakeupTattooUB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooUB and (self.resetMakeupTattooUB ~= 0) then self.character:setWornItem(self.resetMakeupTattooUB:getBodyLocation(), self.resetMakeupTattooUB); elseif (not bodyLocationItem) and self.mO and self.mO.UBT then self.character:setWornItem(self.mO.UBT:getBodyLocation(), self.mO.UBT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1953` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1954` — `	if (self.resetMakeupTattooLB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLB and (self.resetMakeupTattooLB ~= 0) then self.character:setWornItem(self.resetMakeupTattooLB:getBodyLocation(), self.resetMakeupTattooLB); elseif (not bodyLocationItem) and self.mO and self.mO.LBT then self.character:setWornItem(self.mO.LBT:getBodyLocation(), self.mO.LBT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1955` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1956` — `	if (self.resetMakeupTattooBack ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooBack and (self.resetMakeupTattooBack ~= 0) then self.character:setWornItem(self.resetMakeupTattooBack:getBodyLocation(), self.resetMakeupTattooBack); elseif (not bodyLocationItem) and self.mO and self.mO.BT then self.character:setWornItem(self.mO.BT:getBodyLocation(), self.mO.BT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1957` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1958` — `	if (self.resetMakeupTattooLA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLA and (self.resetMakeupTattooLA ~= 0) then self.character:setWornItem(self.resetMakeupTattooLA:getBodyLocation(), self.resetMakeupTattooLA); elseif (not bodyLocationItem) and self.mO and self.mO.LAT then self.character:setWornItem(self.mO.LAT:getBodyLocation(), self.mO.LAT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1959` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1960` — `	if (self.resetMakeupTattooRA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRA and (self.resetMakeupTattooRA ~= 0) then self.character:setWornItem(self.resetMakeupTattooRA:getBodyLocation(), self.resetMakeupTattooRA); elseif (not bodyLocationItem) and self.mO and self.mO.RAT then self.character:setWornItem(self.mO.RAT:getBodyLocation(), self.mO.RAT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1961` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1962` — `	if (self.resetMakeupTattooLL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLL and (self.resetMakeupTattooLL ~= 0) then self.character:setWornItem(self.resetMakeupTattooLL:getBodyLocation(), self.resetMakeupTattooLL); elseif (not bodyLocationItem) and self.mO and self.mO.LLT then self.character:setWornItem(self.mO.LLT:getBodyLocation(), self.mO.LLT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1963` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1964` — `	if (self.resetMakeupTattooRL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRL and (self.resetMakeupTattooRL ~= 0) then self.character:setWornItem(self.resetMakeupTattooRL:getBodyLocation(), self.resetMakeupTattooRL); elseif (not bodyLocationItem) and self.mO and self.mO.RLT then self.character:setWornItem(self.mO.RLT:getBodyLocation(), self.mO.RLT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Inventions/NeuralHat.lua:16` — `	local headgear = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Inventions/NeuralHat.lua:35` — `	info.headgear = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/MeditateContextMenu.lua:82` — `		for i=0,thisPlayer:getWornItems():size()-1 do`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/MeditateContextMenu.lua:83` — `			local item = thisPlayer:getWornItems():get(i):getItem();`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/ZenWellnessContextMenu.lua:160` — `	for i=0,thisPlayer:getWornItems():size()-1 do`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/ZenWellnessContextMenu.lua:161` — `		local item = thisPlayer:getWornItems():get(i):getItem();`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Painting/Sculpting/SculptingWorkContextMenu.lua:574` — `			ISTimedActionQueue.add(ISWearClothing:new(player, workItems['item3'], 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Jacket.txt:8` — `	BodyLocation = base:Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Jacket.txt:32` — `	BodyLocation = base:Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shoes.txt:10` — `        BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_KneePads.txt:8` — `        BodyLocation = KATTAJ1:Knees,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_KneePads.txt:24` — `        BodyLocation = KATTAJ1:Knees,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_BulletproofVest.txt:9` — `        BodyLocation = base:TorsoExtraVestBullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_BulletproofVest.txt:37` — `        BodyLocation = KATTAJ1:TorsoExtraShoulderPelvic,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_BulletproofVest.txt:65` — `        BodyLocation = KATTAJ1:TorsoExtraShoulder,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_BulletproofVest.txt:93` — `        BodyLocation = KATTAJ1:TorsoExtraFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_BulletproofVest.txt:121` — `        BodyLocation = KATTAJ1:TorsoExtraPelvic,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:9` — `	BodyLocation = base:Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:32` — `	BodyLocation = base:Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:65` — `	BodyLocation = KATTAJ1:Mandible,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:94` — `        BodyLocation = base:Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:111` — `        BodyLocation = base:Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:136` — `        BodyLocation = KATTAJ1:Headsets,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:154` — `        BodyLocation = KATTAJ1:Headsets,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:180` — `	BodyLocation = base:MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:203` — `	BodyLocation = base:MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:227` — `	BodyLocation = base:MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Hat.txt:250` — `	BodyLocation = base:MaskFull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Underwear.txt:9` — `        BodyLocation = base:UnderwearExtra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Underwear.txt:22` — `        BodyLocation = base:UnderwearExtra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Other.txt:9` — `        BodyLocation = KATTAJ1:Balaclava,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Other.txt:33` — `		BodyLocation = KATTAJ1:Balaclava,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Other.txt:58` — `        BodyLocation = base:Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Other.txt:75` — `        BodyLocation = base:Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Other.txt:96` — `	BodyLocation = base:Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Other.txt:118` — `	BodyLocation = base:Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Pants.txt:15` — `        BodyLocation = base:Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Pants.txt:37` — `        BodyLocation = base:Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Pants.txt:59` — `        BodyLocation = base:Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Pants.txt:89` — `        BodyLocation = KATTAJ1:SkinnyPants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Pants.txt:114` — `        BodyLocation = base:Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Pants.txt:136` — `        BodyLocation = base:Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:17` — `        BodyLocation = base:Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:37` — `        BodyLocation = base:Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:57` — `        BodyLocation = base:Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:77` — `        BodyLocation = base:Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:99` — `        BodyLocation = base:Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:119` — `        BodyLocation = base:Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:141` — `        BodyLocation = base:Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:156` — `        BodyLocation = base:Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:174` — `        BodyLocation = base:TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:189` — `        BodyLocation = base:TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:206` — `        BodyLocation = base:Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Shirt.txt:221` — `        BodyLocation = base:Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:9` — `	CanBeEquipped = base:back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:34` — `	CanBeEquipped = base:back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:76` — `        CanBeEquipped = KATTAJ1:ChestRig,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:97` — `        CanBeEquipped = KATTAJ1:ChestRig,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:118` — `        CanBeEquipped = KATTAJ1:ChestRig,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:148` — `        CanBeEquipped = KATTAJ1:TacticalFannyPack,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:168` — `        CanBeEquipped = KATTAJ1:TacticalFannyPackFront,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:169` — `	BodyLocation = TacticalFannyPackFront,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:197` — `	CanBeEquipped = KATTAJ1:BeltLeft,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:220` — `	CanBeEquipped = KATTAJ1:BeltRight,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:243` — `	CanBeEquipped = KATTAJ1:BeltLeft,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_Bag.txt:266` — `	CanBeEquipped = KATTAJ1:BeltRight,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_ElbowPads.txt:8` — `        BodyLocation = KATTAJ1:Elbows,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.2/42.15/media/scripts/clothing/Cerberus_ElbowPads.txt:24` — `        BodyLocation = KATTAJ1:Elbows,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:2` — `KATTAJ1_BodyLocation = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:5` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltLeft       = ItemBodyLocation.register("KATTAJ1:BeltLeft")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:6` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltRight      = ItemBodyLocation.register("KATTAJ1:BeltRight")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:7` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft   = ItemBodyLocation.register("KATTAJ1:BeltBackLeft")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:8` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight  = ItemBodyLocation.register("KATTAJ1:BeltBackRight")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:11` — `    KATTAJ1_BodyLocation.KATTAJ1_UpperLegs      = ItemBodyLocation.register("KATTAJ1:UpperLegs")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:12` — `    KATTAJ1_BodyLocation.KATTAJ1_LowerLegs      = ItemBodyLocation.register("KATTAJ1:LowerLegs")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:13` — `    KATTAJ1_BodyLocation.KATTAJ1_Knees          = ItemBodyLocation.register("KATTAJ1:Knees")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:16` — `    KATTAJ1_BodyLocation.KATTAJ1_UpperArms      = ItemBodyLocation.register("KATTAJ1:UpperArms")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:17` — `    KATTAJ1_BodyLocation.KATTAJ1_LowerArms      = ItemBodyLocation.register("KATTAJ1:LowerArms")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:18` — `    KATTAJ1_BodyLocation.KATTAJ1_Elbows         = ItemBodyLocation.register("KATTAJ1:Elbows")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:21` — `    KATTAJ1_BodyLocation.KATTAJ1_BackFanny      = ItemBodyLocation.register("KATTAJ1:BackFanny")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:22` — `    KATTAJ1_BodyLocation.KATTAJ1_Balaclava      = ItemBodyLocation.register("KATTAJ1:Balaclava")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:23` — `    KATTAJ1_BodyLocation.KATTAJ1_Headsets       = ItemBodyLocation.register("KATTAJ1:Headsets")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:24` — `    KATTAJ1_BodyLocation.KATTAJ1_Mandible       = ItemBodyLocation.register("KATTAJ1:Mandible")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:27` — `    KATTAJ1_BodyLocation.KATTAJ1_ChestRig       = ItemBodyLocation.register("KATTAJ1:ChestRig")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:30` — `    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack       = ItemBodyLocation.register("KATTAJ1:TacticalFannyPack")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:31` — `    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront  = ItemBodyLocation.register("KATTAJ1:TacticalFannyPackFront")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:34` — `    KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants    = ItemBodyLocation.register("KATTAJ1:SkinnyPants")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:37` — `    KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads   = ItemBodyLocation.register("KATTAJ1:ShoulderPads")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:38` — `    KATTAJ1_BodyLocation.KATTAJ1_HipProtection  = ItemBodyLocation.register("KATTAJ1:HipProtection")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:41` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic    = ItemBodyLocation.register("KATTAJ1:TorsoExtraPelvic")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:42` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder  = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulder")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:43` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulderPelvic")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:44` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull      = ItemBodyLocation.register("KATTAJ1:TorsoExtraFull")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:12` — `        if instanceof(testItem, "InventoryContainer") and testItem:canBeEquipped() ~= nil and testItem:canBeEquipped() ~= "" and not testItem:isEquipped() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:17` — `    if clothing and ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.doWearClothingMenu and`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:20` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_TooltipFixer.lua:7` — `    if item and instanceof( item, "Clothing") and item:getBodyLocation() and  player:getWornItem(item:getBodyLocation())`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_TooltipFixer.lua:8` — `    and instanceof(  player:getWornItem(item:getBodyLocation()), "InventoryContainer") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:5` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:7` — `local group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:13` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:14` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:15` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:16` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:19` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:20` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:21` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Knees)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:24` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:25` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:26` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Elbows)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:29` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BackFanny)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:30` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Balaclava)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:31` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Headsets)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:32` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Mandible)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:35` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ChestRig)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:38` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:39` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:42` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:45` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:46` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_HipProtection)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:49` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:50` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:51` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:52` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:56` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack,ItemBodyLocation.FANNY_PACK_BACK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:57` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront,ItemBodyLocation.FANNY_PACK_FRONT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:59` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Balaclava,ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:60` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:61` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:62` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:67` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:68` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:69` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:71` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:72` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:73` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:74` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:75` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:76` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:78` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:79` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:80` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:84` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:85` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:86` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:88` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:89` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:91` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:92` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:93` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:94` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:95` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:96` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:98` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:99` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:100` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:104` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:105` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:106` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:108` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:109` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:111` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:112` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:113` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:114` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:115` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:116` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:118` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:119` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:120` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:124` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:125` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:126` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:128` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:129` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:131` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:132` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:134` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:135` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:136` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:137` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:138` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:139` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:141` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:142` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:143` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:147` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:148` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:149` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:153` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:154` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:156` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:157` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:158` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:159` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:161` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:162` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:163` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:168` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:169` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:172` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:173` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:174` — `    group:setExclusive( KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:175` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:178` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:179` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:180` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:27` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:37` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:1` — `ItemBodyLocation.register("AZ:HeadExtra")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:2` — `ItemBodyLocation.register("AZ:HeadExtraHair")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:3` — `ItemBodyLocation.register("AZ:HeadExtraPlus")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:5` — `ItemBodyLocation.register("AZ:NeckExtra")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:6` — `ItemBodyLocation.register("AZ:LegsExtra")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:8` — `ItemBodyLocation.register("AZ:TorsoRigPlus2")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:9` — `ItemBodyLocation.register("AZ:TorsoExtraPlus1")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/AuthenticZ_Edited_items.txt:11` — `        BodyLocation 	= base:maskeyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/AuthenticZ_Edited_items.txt:44` — `        BodyLocation 	= base:maskeyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:10` — `        BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:24` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:40` — `        BodyLocation 	 = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:56` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:72` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:88` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:104` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:121` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:138` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:156` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:173` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:189` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:204` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:220` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:236` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:255` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:273` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:291` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:309` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:328` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:346` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:364` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:382` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:400` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:418` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:436` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:454` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:472` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:490` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:508` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:526` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:544` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:562` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:580` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:594` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:608` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:623` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:638` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:653` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:668` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:683` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:698` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:713` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:728` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:743` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:758` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:773` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:788` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:803` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:818` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:833` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:848` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:863` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:878` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:893` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:908` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:922` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:936` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:951` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:966` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:981` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:996` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1011` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1025` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1040` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1055` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1069` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1083` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1098` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1112` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1126` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1144` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1162` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1180` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1198` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1214` — `        BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1228` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_suits.txt:1244` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:13` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:28` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:47` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:65` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:84` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:108` — `        BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:125` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:141` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:164` — `        BodyLocation 	 = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:191` — `        BodyLocation 	 = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:208` — `        BodyLocation 	 = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:225` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:249` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_S_models.txt:265` — `        BodyLocation 	 		= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:11` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:23` — `        BodyLocation	 = ShortSleeveShirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:37` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:51` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:65` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:78` — `        BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:90` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:106` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:120` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:134` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:148` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:162` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:176` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:190` — `		BodyLocation = ShortSleeveShirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:204` — `		BodyLocation = ShortSleeveShirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:218` — `		BodyLocation = ShortSleeveShirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:232` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:245` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:258` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:271` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:284` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:297` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:310` — `		BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:322` — `		BodyLocation 	= Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:335` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:348` — `        BodyLocation = Sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:361` — `        BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:374` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:387` — `        BodyLocation    	= Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:400` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:413` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:427` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:441` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:454` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:468` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:481` — `        BodyLocation    = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:495` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:509` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:523` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:540` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:554` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:568` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:582` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:596` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:614` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:627` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:641` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:655` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:669` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:683` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:697` — `        BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:711` — `        BodyLocation 	 = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:725` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:739` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:753` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:767` — `        BodyLocation 	 = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:781` — `        BodyLocation 	= Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:795` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:809` — `        BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:823` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:837` — `		BodyLocation = Tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:851` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:866` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:881` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:896` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:910` — `        BodyLocation 			= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:926` — `        BodyLocation 	 = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:938` — `        BodyLocation 	= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:950` — `        BodyLocation 	= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:962` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:976` — `        BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:990` — `        BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1004` — `        BodyLocation 			= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1019` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1033` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1047` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1061` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1075` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1089` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shirts.txt:1104` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:13` — `		BodyLocation 			= AmmoStrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:28` — `		BodyLocation 			= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:44` — `        BodyLocation 			= FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:64` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:83` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:103` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:128` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:153` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:178` — `        BodyLocation 			= JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:199` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:221` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:245` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:263` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:280` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:297` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:311` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:328` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:346` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:364` — `         BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:382` — `         BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:399` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:417` — `        BodyLocation 			= Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:436` — `        BodyLocation 			= Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:455` — `        BodyLocation 			= Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:474` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:494` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:513` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:531` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:550` — `        BodyLocation 			= Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XL_models.txt:569` — `        BodyLocation 			= Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:11` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:20` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:28` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:36` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:44` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:52` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:60` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:68` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:76` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:84` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:92` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:100` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:108` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:116` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:124` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:132` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:140` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:148` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:156` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:164` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:172` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:180` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:188` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:196` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:204` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:212` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:220` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:228` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:236` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:244` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:254` — `		BodyLocation = Necklace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:265` — `		BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:274` — `        BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:283` — `        BodyLocation = HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:293` — `		BodyLocation = AZ:HeadExtraHair,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:303` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:312` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:321` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:330` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:339` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:348` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:357` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:366` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:375` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:384` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_wigs.txt:393` — `        BodyLocation = AZ:HeadExtraPlus,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:10` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:32` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:55` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:77` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:100` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:122` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:145` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:167` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:190` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:212` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:235` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:257` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:280` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:299` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:322` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:344` — `        BodyLocation = Jacket_Down,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:367` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:386` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:406` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:426` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:447` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:466` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:483` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:502` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:520` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:538` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:556` — `        BodyLocation 		= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:579` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:599` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:616` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:635` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:655` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:674` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:694` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:710` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:734` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:753` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:776` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:796` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:818` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:839` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:860` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:881` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:899` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:918` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:937` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:954` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:971` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:988` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1005` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1022` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1039` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1056` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1073` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1090` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1107` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1124` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1141` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1158` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1175` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1192` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1209` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1226` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1243` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1260` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1277` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1294` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1311` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1328` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1345` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1362` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1379` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1396` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1413` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1430` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1447` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1464` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1481` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1498` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1514` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1530` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1548` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1566` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1583` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1601` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1619` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1638` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1658` — `        BodyLocation     = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1675` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1698` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1717` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1735` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1750` — `        BodyLocation = AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1769` — `        BodyLocation = AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1788` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1807` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1824` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1839` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1858` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1875` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1890` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1909` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1927` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1942` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1961` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1979` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:1994` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2012` — `        BodyLocation 	 = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2030` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2045` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2063` — `        BodyLocation 	 = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2081` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2096` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2115` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2133` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2148` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2167` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2185` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2200` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2219` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2237` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2252` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2271` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2289` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2304` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2323` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2341` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2356` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2375` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2393` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2408` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2427` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2445` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2460` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2479` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2496` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2510` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2528` — `        BodyLocation 	 = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2545` — `		BodyLocation 	 = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2557` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2578` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2599` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2620` — `        BodyLocation 	 = Sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket.txt:2634` — `        BodyLocation 		= FullTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:13` — `		BodyLocation 			= AmmoStrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:28` — `		BodyLocation 			= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:40` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:63` — `        BodyLocation 			= FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:75` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:93` — `        BodyLocation			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:112` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:136` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:160` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:183` — `        BodyLocation 		= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:205` — `        BodyLocation 			= Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:222` — `        BodyLocation 			= FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:241` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:264` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:288` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:305` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:322` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:340` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:363` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:379` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:392` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:408` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:422` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:436` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:451` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:468` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:485` — `         BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:502` — `         BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:519` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:536` — `        BodyLocation 			= Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:554` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:572` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:590` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:608` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:625` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:642` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:660` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXXL_models.txt:678` — `        BodyLocation 			= Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jewelry.txt:10` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jewelry.txt:21` — `		BodyLocation = Necklace_Long,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jewelry.txt:32` — `		BodyLocation = Necklace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jewelry.txt:43` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:10` — `        BodyLocation = Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:22` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:39` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:54` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:67` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:80` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:93` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:106` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:119` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:132` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:145` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:158` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:171` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:184` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:197` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:210` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:223` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:236` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:249` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:262` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:274` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:286` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:298` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:310` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:322` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:334` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:346` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:362` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:376` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:390` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:404` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:418` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:432` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:447` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:462` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:478` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:493` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:510` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:525` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:540` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:555` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:571` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:587` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:602` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:618` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:633` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:647` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:662` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:678` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:694` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:710` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:726` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:741` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:756` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:772` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:788` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:802` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:818` — `		BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:831` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:844` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:857` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:870` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:883` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:896` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:909` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:923` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:937` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:951` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_pants.txt:966` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:10` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:19` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:29` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:39` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:49` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:59` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:69` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:78` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:88` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:98` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:108` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:119` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:128` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_body_models.txt:138` — `		BodyLocation = Torso1Legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:11` — `		BodyLocation = AZ:LegsExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:25` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:45` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:65` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:83` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:103` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:110` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:130` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:150` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:170` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:188` — `		BodyLocation = AZ:LegsExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:201` — `		BodyLocation = AZ:LegsExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:214` — `		BodyLocation = AZ:LegsExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:227` — `		BodyLocation = AZ:LegsExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:240` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:241` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:261` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:262` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:282` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:283` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:303` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:321` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:336` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:354` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:372` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:390` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:408` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:426` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:444` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:462` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:480` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:498` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:518` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:532` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:546` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:560` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:574` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:588` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:602` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:616` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:630` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:644` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_shoes.txt:658` — `		BodyLocation = Socks,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:9` — `		BodyLocation 			= AmmoStrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:15` — `        CanBeEquipped 			= base:ammostrap,	`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:32` — `		BodyLocation 			= AmmoStrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:37` — `        CanBeEquipped 			= base:ammostrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:54` — `		BodyLocation 			= AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:60` — `        CanBeEquipped 			= AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:77` — `		BodyLocation 			= AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:83` — `        CanBeEquipped 			= AZ:TorsoExtraPlus1,		`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:101` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:112` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:123` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:134` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:148` — `		BodyLocation 			= AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:162` — `		BodyLocation 			= AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:176` — `		BodyLocation 	 		= AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:190` — `		BodyLocation 			= AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:204` — `		BodyLocation 	 		= AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:218` — `		BodyLocation 			= AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:232` — `		BodyLocation 	 		= AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:246` — `		BodyLocation 			= AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:258` — `		BodyLocation 			= AZ:HeadExtraPlus,		`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:271` — `        BodyLocation = Belt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:281` — `		BodyLocation = Underwear,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:291` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:301` — `		BodyLocation = Underwear,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:311` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:319` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:327` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:335` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:343` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:355` — `		BodyLocation 			= 	AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:364` — `        BodyLocation = Tail,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:375` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:387` — `		BodyLocation 		= AZ:NeckExtra,		`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:399` — `		BodyLocation 		= AZ:NeckExtra,		`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:411` — `		BodyLocation 		= AZ:NeckExtra,		`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:423` — `		BodyLocation = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:434` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:446` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:458` — `		BodyLocation = base:gorget,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:467` — `		BodyLocation = base:gorget,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:476` — `		BodyLocation 	= base:gorget,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:488` — `		BodyLocation 			= base:shoulderpadleft,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:502` — `		BodyLocation 			= base:shoulderpadright,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:513` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:529` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:545` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:559` — `		BodyLocation = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:576` — `        BodyLocation 	=  AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:583` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:594` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:606` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:617` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:629` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:641` — `		BodyLocation = Eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:653` — `		BodyLocation	 = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:669` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:685` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:701` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:717` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:734` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:747` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:760` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:773` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:786` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:802` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:815` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:828` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:841` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:855` — `		BodyLocation = Hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:875` — `        BodyLocation = Left_RingFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:889` — `        BodyLocation = Right_RingFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:903` — `        BodyLocation = Right_MiddleFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:917` — `        BodyLocation = Left_MiddleFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:931` — `        BodyLocation = Left_RingFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:945` — `        BodyLocation = Right_RingFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:959` — `        BodyLocation = Right_MiddleFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:973` — `        BodyLocation = Left_MiddleFinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:986` — `		BodyLocation = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1004` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1022` — `		BodyLocation = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1040` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1058` — `		BodyLocation 	  = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1071` — `		BodyLocation 	= AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1081` — `		BodyLocation 	  = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1091` — `		BodyLocation = AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1102` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1112` — `        BodyLocation = AZ:TorsoExtraPlus1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1119` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1127` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1135` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1143` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1151` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1159` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1167` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1175` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1183` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1191` — `        BodyLocation = MakeUp_FullFace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1200` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1208` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1224` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1240` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1256` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1272` — `		BodyLocation = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1283` — `		BodyLocation = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1299` — `		BodyLocation = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1308` — `		BodyLocation = AZ:HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1317` — `        BodyLocation = Scarf,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1332` — `        BodyLocation = Scarf,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1347` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1354` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1363` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1370` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1377` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1384` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1391` — `		BodyLocation = Bandage,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1398` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1405` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1412` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1421` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1428` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1437` — `		BodyLocation = TankTop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1444` — `		BodyLocation = Bandage,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1451` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1458` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1465` — `        BodyLocation = LeftWrist,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1472` — `        BodyLocation = RightWrist,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1479` — `        BodyLocation = LeftWrist,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1486` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1496` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1506` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1516` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1526` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1536` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1546` — `        BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1556` — `		BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1566` — `		BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1576` — `		BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1586` — `		BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1596` — `		BodyLocation = Neck,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1606` — `		BodyLocation = AZ:NeckExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_others.txt:1615` — `		BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:10` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:22` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:36` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:50` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:61` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:72` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:84` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:100` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:116` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:132` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:148` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:164` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:180` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:196` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:212` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:228` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:244` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:260` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:276` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:291` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:304` — `		BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:320` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:335` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:350` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:365` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:380` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:395` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:410` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:425` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:440` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:455` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:469` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:484` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:499` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:514` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:529` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:544` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:558` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:573` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:587` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:602` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:616` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:631` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:645` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:660` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:674` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:688` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:703` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:718` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:733` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:745` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:760` — `        BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:777` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:791` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:806` — `        BodyLocation = Mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:825` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:839` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:853` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:866` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:879` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:893` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:907` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:921` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:935` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:949` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:965` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:980` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:993` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1007` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1019` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1032` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1045` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1060` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1074` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1086` — `		BodyLocation = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1095` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1111` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1127` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1140` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1157` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1168` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1181` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1194` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1212` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1230` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1248` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1266` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1284` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1296` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1308` — `		BodyLocation = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1322` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1338` — `		BodyLocation = HeadExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1354` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1368` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1382` — `        BodyLocation 	= Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1395` — `        BodyLocation 	= Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1408` — `        BodyLocation 	= Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1421` — `        BodyLocation 	= Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1434` — `		BodyLocation 		= MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1450` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1468` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1482` — `        BodyLocation = base:maskfull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1502` — `		BodyLocation = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1517` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1529` — `		BodyLocation = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1544` — `		BodyLocation 		 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1562` — `        BodyLocation 	= Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1574` — `        BodyLocation	 = base:maskeyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1591` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1604` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1620` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1636` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1655` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1669` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1686` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1701` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1715` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1726` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1739` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1752` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1771` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1790` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1806` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1822` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1835` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1850` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1864` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1881` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1898` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1915` — `        BodyLocation = base:maskfull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1935` — `        BodyLocation = base:maskfull,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1954` — `        BodyLocation 	 = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1967` — `		BodyLocation  = MaskEyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1983` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:1997` — `        BodyLocation 	= Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2011` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2031` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2046` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2061` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2076` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2091` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2106` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2118` — `		BodyLocation = FullHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2138` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2156` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2171` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_hats.txt:2184` — `		BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket_Vanilla.txt:13` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_jacket_Vanilla.txt:34` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:13` — `		BodyLocation 			= AmmoStrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:28` — `		BodyLocation 			= TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:44` — `        BodyLocation 			= FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:64` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:83` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:103` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:128` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:153` — `        BodyLocation 			= Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:178` — `        BodyLocation = FullSuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:198` — `        BodyLocation = JacketHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:222` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:247` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:265` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:283` — `        BodyLocation = Pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:300` — `		BodyLocation = Shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:324` — `        BodyLocation = Shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:341` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:358` — `        BodyLocation = Jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:375` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:389` — `        BodyLocation = TorsoExtra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:404` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:422` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:440` — `         BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:458` — `         BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:476` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:494` — `        BodyLocation 			= Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:513` — `        BodyLocation 			= Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:532` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:551` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:570` — `        BodyLocation = Dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:588` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:606` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:625` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_XXL_models.txt:644` — `        BodyLocation = Skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:11` — `        CanBeEquipped = base:back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:34` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:60` — `        CanBeEquipped 			 =	 Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:82` — `        CanBeEquipped 	=	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:104` — `        CanBeEquipped 			 = 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:126` — `        CanBeEquipped 	= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:148` — `        CanBeEquipped 	= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:167` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:191` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:213` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:234` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:255` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:278` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:300` — `        CanBeEquipped			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:322` — `        CanBeEquipped 				= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:345` — `        CanBeEquipped		= Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:363` — `        CanBeEquipped 			 = 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:386` — `		BodyLocation 			= base:webbing,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:387` — `        CanBeEquipped 			= base:webbing,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:405` — `		BodyLocation 			= base:webbing,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:406` — `        CanBeEquipped 			= base:webbing,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:424` — `        CanBeEquipped 			 = 	base:Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:446` — `        CanBeEquipped 			= 	base:Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:467` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:504` — `        BodyLocation 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:505` — `        CanBeEquipped 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:525` — `        BodyLocation 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:526` — `        CanBeEquipped 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:545` — `        BodyLocation 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:546` — `        CanBeEquipped 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:565` — `        BodyLocation 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:566` — `        CanBeEquipped 			= 	AZ:TorsoRigPlus2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:576` — `        CanBeEquipped = base:back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:600` — `        CanBeEquipped = base:ammostrap,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:620` — `		CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_bags.txt:641` — `        CanBeEquipped = base:back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:12` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:22` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:32` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:42` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:52` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:62` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:72` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:82` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:92` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:102` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:112` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:122` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:135` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:148` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:161` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:174` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_gore.txt:187` — `        BodyLocation = Hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_misc.txt:8` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_misc.txt:16` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/clothing/clothing_AuthenticZ_misc.txt:24` — `        BodyLocation = ZedDmg,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:14` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:38` — `        CanBeEquipped 			= 	Back, `
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:62` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:89` — `		CanBeEquipped 			= Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:114` — `		CanBeEquipped 			= Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:139` — `		CanBeEquipped 			= Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:161` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:183` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:205` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:226` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:248` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:270` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:291` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:313` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:335` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:356` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:378` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:400` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:422` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:444` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:466` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:487` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:509` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:531` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:552` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:574` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:596` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:618` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:640` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:662` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:684` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:706` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:728` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:751` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:772` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:789` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:814` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:835` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:852` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:877` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:898` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:915` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:940` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:961` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:978` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1003` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1024` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1045` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1066` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1087` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1108` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1125` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1145` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1165` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1188` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1210` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1232` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1254` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1276` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1298` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1317` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1339` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1361` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1383` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1405` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1427` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1449` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1471` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1493` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1515` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1537` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1559` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1581` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1603` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:1625` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3503` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3525` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3547` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3646` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3668` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3690` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3789` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3811` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3833` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3932` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3954` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:3976` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:4075` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:4097` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:4119` — `        CanBeEquipped 			= 	Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:4217` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:4238` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/scripts/recipes/recipes_AuthenticZ_BackpackUpgrades.txt:4259` — `        CanBeEquipped = Back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:286` — `                if instanceof(result, "InventoryContainer") and (result:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:288` — `                    character:setWornItem(result:canBeEquipped(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:290` — `                        sendClothing(character, result:canBeEquipped(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:294` — `                    if result:getBodyLocation() ~= "" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:295` — `                        character:setWornItem(result:getBodyLocation(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:297` — `                            sendClothing(character, result:getBodyLocation(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:303` — `                            and (result:getBodyLocation() == "Hat" or result:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/client/AuthenticZ_Tweaker.lua:58` — `TweakItem("Base.ManPackRadio", "CanBeEquipped", "AZ:TorsoExtraPlus1");`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/client/AuthenticZ_StraightJacket.lua:10` — `        local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:1` — `-- AuthenticZ_BodyLocations.lua`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:5` — `-- Never reset or rebuild BodyLocations here: doing so invalidates the live`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:6` — `-- BodyLocationGroup used by the character and can make vanilla watches,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:10` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:12` — `local BodyAPI = BodyLocations`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:13` — `local SlotAPI = ItemBodyLocation`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:39` — `    if not anchorId or not group.indexOf or not group.moveLocationToIndex then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:53` — `            group:moveLocationToIndex(locationId, firstIndex + offset - 1)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:58` — `local function setupAuthenticZBodyLocations()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:87` — `Events.OnGameBoot.Add(setupAuthenticZBodyLocations)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_T4/media/scripts/clothing/clothing_pert.txt:10` — `        BodyLocation = Belt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_2/42/media/scripts/generated/items/LabItems.txt:973` — `        CanBeEquipped = base:back,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_2/42/media/lua/client/LabModEngine_Client.lua:365` — `        ISInventoryPaneContextMenu.wearItem(clothing, player:getPlayerNum())`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:133` — `    if character:getWornItems():contains(item) then return end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:154` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:185` — `    if character:getWornItems():contains(item) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:217` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:114` — `    if character:getWornItems():contains(item) then return end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:124` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:134` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:152` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:133` — `    if character:getWornItems():contains(item) then return end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:154` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:185` — `    if character:getWornItems():contains(item) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:217` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:157` — `    tests.canBeEquippedOther = nil;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:169` — `	tests.canBeEquippedContainer = nil;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:293` — `            tests.canBeEquippedOther = testItem;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:370` — `		if instanceof(testItem, "InventoryContainer") and testItem:canBeEquipped() and not playerObj:isEquippedClothing(testItem) and not testItem:getClothingExtraSubmenu() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:371` — `			tests.canBeEquippedContainer = testItem;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:441` — `            tests.canBeEquippedContainer = nil;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:496` — `    if ((tests.clothing and not tests.clothing:isBroken()) or (tests.canBeEquippedContainer or tests.canBeEquippedOther)) and not tests.unequip then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:497` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, tests.clothing or tests.canBeEquippedContainer or tests.canBeEquippedOther, items, context);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:757` — `        local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1796` — `ISInventoryPaneContextMenu.doWearClothingTooltip = function(playerObj, newItem, currentItem, option)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1801` — `	local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1802` — `	local bodyLocationGroup = wornItems:getBodyLocationGroup()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1803` — `	local location = (newItem:IsClothing() or newItem:IsInventoryContainer()) and newItem:getBodyLocation() or newItem:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1809` — `		if (newItem:getBodyLocation() and newItem:getBodyLocation() == wornItem:getLocation()) or (newItem:canBeEquipped() and newItem:canBeEquipped() == wornItem:getLocation()) or (location ~= nil and bodyLocationGroup:isExclusive(location, wornItem:getLocation())) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1890` — `ISInventoryPaneContextMenu.doWearClothingMenu = function(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1897` — `    local option = context:addOption(getText("ContextMenu_Wear"), items, ISInventoryPaneContextMenu.onWearItems, player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1910` — `    ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothing, clothing, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2398` — `	if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2497` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2671` — `	if playerObj:getWornItem(ItemBodyLocation.FULL_HAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2672` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.FULL_HAT), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2674` — `	if playerObj:getWornItem(ItemBodyLocation.HAT) and not beard then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2675` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.HAT), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2677` — `	if beard and playerObj:getWornItem(ItemBodyLocation.MASK) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2678` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.MASK), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2680` — `	if beard and playerObj:getWornItem(ItemBodyLocation.MASK_EYES) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2681` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.MASK_EYES), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2683` — `	if beard and playerObj:getWornItem(ItemBodyLocation.MASK_FULL) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2684` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.MASK_FULL), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2994` — `ISInventoryPaneContextMenu.onWearItems = function(items, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2998` — `        if not (k:getBodyLocation() and typeDone[k:getBodyLocation()]) and not (k:canBeEquipped() and typeDone[k:canBeEquipped()]) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2999` — `            if k:getBodyLocation() == ItemBodyLocation.HAT or k:getBodyLocation() == ItemBodyLocation.FULL_HAT then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3001` — `                local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3004` — `                    if (wornItem:getLocation() == ItemBodyLocation.SWEATER_HAT or wornItem:getLocation() == ItemBodyLocation.JACKET_HAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3013` — `            ISInventoryPaneContextMenu.wearItem(k, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3014` — `            if k:getBodyLocation() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3015` — `                typeDone[k:getBodyLocation()] = true;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3017` — `            if k:canBeEquipped() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3018` — `                typeDone[k:canBeEquipped()] = true;`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3032` — `ISInventoryPaneContextMenu.wearItem = function(item, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3038` — `    ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3839` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3887` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4551` — `local function getWornItemInLocation(playerObj, location)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4552` — `    local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4553` — `    local bodyLocationGroup = wornItems:getBodyLocationGroup()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4556` — `        if (wornItem:getLocation() == location) or bodyLocationGroup:isExclusive(wornItem:getLocation(), location) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4588` — `        local location = clothingItemExtra:IsClothing() and clothingItemExtra:getBodyLocation() or clothingItemExtra:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4589` — `        local existingItem = getWornItemInLocation(playerObj, location)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4593` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothingItemExtra, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4606` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, item, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4612` — `    if item:getBodyLocation() == ItemBodyLocation.HAT or item:getBodyLocation() == ItemBodyLocation.FULL_HAT then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4613` — `        local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4616` — `            if (wornItem:getLocation() == ItemBodyLocation.SWEATER_HAT or wornItem:getLocation() == ItemBodyLocation.JACKET_HAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4734` — `    if playerObj:getWornItem(ItemBodyLocation.MASK) and not playerObj:getWornItem(ItemBodyLocation.MASK):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4735` — `        mask = playerObj:getWornItem(ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4736` — `    elseif  playerObj:getWornItem(ItemBodyLocation.MASK_EYES) and not playerObj:getWornItem(ItemBodyLocation.MASK_EYES):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4737` — `        mask = playerObj:getWornItem(ItemBodyLocation.MASK_EYES)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4738` — `    elseif  playerObj:getWornItem(ItemBodyLocation.MASK_FULL) and not playerObj:getWornItem(ItemBodyLocation.MASK_FULL):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4739` — `        mask = playerObj:getWornItem(ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4740` — `    elseif  playerObj:getWornItem(ItemBodyLocation.FULL_HAT) and not playerObj:getWornItem(ItemBodyLocation.FULL_HAT):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4741` — `        mask = playerObj:getWornItem(ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4742` — `    elseif  playerObj:getWornItem(ItemBodyLocation.FULL_SUIT_HEAD) and not playerObj:getWornItem(ItemBodyLocation.FULL_SUIT_HEAD):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4743` — `        mask = playerObj:getWornItem(ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4744` — `    elseif  playerObj:getWornItem(ItemBodyLocation.SCBA) and not playerObj:getWornItem(ItemBodyLocation.SCBA):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4745` — `        mask = playerObj:getWornItem(ItemBodyLocation.SCBA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4746` — `    elseif  playerObj:getWornItem(ItemBodyLocation.SCBANOTANK) and not playerObj:getWornItem(ItemBodyLocation.SCBANOTANK):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4747` — `        mask = playerObj:getWornItem(ItemBodyLocation.SCBANOTANK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1666` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1668` — `	elseif instanceof(item, "InventoryContainer") and item:canBeEquipped() ~= nil and item:canBeEquipped() ~= "" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1672` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1915` — `                                ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:2849` — `		local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:12` — `    return self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:32` — `        for i=1,mannequin:getWornItems():size() do`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:33` — `            local item = mannequin:getWornItems():get(i-1):getItem()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:36` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:13` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:16` — `    if self.object:getWornItems():size()<1 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:19` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()<1 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:27` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:29` — `    elseif self.object:getWornItems():size()<1 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:31` — `    elseif self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()<1 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:40` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:42` — `    elseif self.object:getWornItems():size()<1 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:44` — `    elseif self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()<1 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:58` — `	    local wornItemsPlayer = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:67` — `        for i=0,mannequin:getWornItems():size()-1 do`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:68` — `            local item = mannequin:getWornItems():get(i):getItem();`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:71` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1082` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1084` — `	elseif instanceof(item, "InventoryContainer") and item:canBeEquipped() ~= nil and item:canBeEquipped() ~= "" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1088` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1300` — `                            ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:2162` — `		local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:240` — `-- ISWearClothing override REMOVED - causes multiplayer clothing bug`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:241` — `-- Vanilla ISWearClothing works perfectly, any override breaks it`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:242` — `-- DO NOT ADD ANY OVERRIDE FOR ISWearClothing - it will break multiplayer!`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:243` — `print("FH B42.19: ISWearClothing left to vanilla (no override)")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:8` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:24` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:40` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:56` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:73` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:91` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:107` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:123` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jumpers.txt:139` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:8` — `        BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:28` — `        BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:45` — `        BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:62` — `        BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:79` — `        BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:96` — `        BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:116` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:136` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:153` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:170` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:187` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Boilersuits.txt:204` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:8` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:23` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:38` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:53` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:70` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:85` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:100` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:115` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:130` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:145` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:163` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:178` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:193` — `        BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:208` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:223` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:238` — `        BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:253` — `        BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:269` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:284` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:299` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:314` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:329` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:344` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:361` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:376` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:391` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:406` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:421` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:436` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:455` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:470` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:485` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:500` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:515` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:530` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:545` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:562` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:577` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:592` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:607` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:622` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:637` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:652` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:667` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:682` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:697` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:712` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:727` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:745` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:760` — `        BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:775` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:790` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:805` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:820` — `		BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:835` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:850` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:866` — `        BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:881` — `        BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:896` — `        BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:913` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:928` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:943` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:958` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:975` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:990` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1005` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1020` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1035` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1050` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1065` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1080` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1095` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1110` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1125` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1140` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1158` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1173` — `        BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1188` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Shirts.txt:1203` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:9` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:27` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:45` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:65` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:85` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:105` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:125` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:145` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:165` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:185` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:205` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:223` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:241` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:259` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:277` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:295` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:316` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:333` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:350` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:369` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:388` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:408` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:428` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:448` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:468` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:489` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:511` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:531` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:551` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:571` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:591` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:611` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:631` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:652` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:673` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:691` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:709` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:727` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:745` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:763` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:783` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:797` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:811` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:825` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:839` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:853` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:867` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:890` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:904` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:918` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:932` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:946` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:960` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/JacketsRolled.txt:974` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:9` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:27` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:47` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:67` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:87` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:107` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:125` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:143` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:164` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:181` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:200` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:220` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:240` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:262` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:282` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:302` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:322` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:343` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:361` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:379` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:399` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:413` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:427` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:441` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:455` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:469` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:483` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:505` — `        BodyLocation = Sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Jackets.txt:522` — `        BodyLocation = SweaterHat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:8` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:23` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:38` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:54` — `        BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:67` — `        BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:80` — `        BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:93` — `        BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:106` — `        BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Vests.txt:119` — `        BodyLocation = base:torsoextravest,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/ShirtsRipped.txt:9` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/ShirtsRipped.txt:24` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/ShirtsRipped.txt:39` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/ShirtsRipped.txt:56` — `		BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:9` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:29` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:44` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:62` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:80` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:97` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:115` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:133` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:148` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:166` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:184` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:202` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:219` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:234` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:250` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:266` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:283` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:298` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:314` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:330` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:346` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:362` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/Trousers.txt:381` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:13` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:31` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:50` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:69` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:88` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:107` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:126` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:143` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:159` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:177` — `		BodyLocation = base:pantsextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:195` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:216` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:232` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:248` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:264` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:280` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:296` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:312` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:328` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:345` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:362` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:379` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:396` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:413` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:431` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:451` — `		BodyLocation = base:fullsuit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.2/42.18/media/scripts/clothing/SpongieOpenJackets/42/SpongieClothes_B42.txt:470` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:11` — `        BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:29` — `        BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:47` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:64` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:81` — `        BodyLocation = base:sweater,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:98` — `        BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:115` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:132` — `        BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:147` — `        BodyLocation = base:shirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:162` — `        BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Shirts.txt:177` — `        BodyLocation = base:shortsleeveshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Gloves.txt:10` — `		BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Gloves.txt:25` — `		BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:10` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:35` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:60` — `        BodyLocation = base:jacket_bulky,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:85` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:111` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:139` — `        BodyLocation = base:jacket_bulky,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:168` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:192` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:216` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:240` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:265` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:287` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:310` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:331` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:352` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:373` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:396` — `        BodyLocation = base:jackethat_bulky,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:422` — `        BodyLocation = base:jacket_bulky,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:450` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:471` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:492` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:513` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:535` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:556` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:577` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:598` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:621` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:643` — `        BodyLocation = base:torsoextravestbullet,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:665` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:685` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:705` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:725` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:746` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:770` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:793` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:817` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:841` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:865` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:888` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:912` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:936` — `        BodyLocation = base:jacket_suit,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:955` — `        BodyLocation = base:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:975` — `        BodyLocation = SpnOpenCloth:JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:994` — `        BodyLocation = SpnOpenCloth:JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:1014` — `        BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Jackets.txt:1035` — `        BodyLocation = SpnOpenCloth:JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Trousers.txt:10` — `        BodyLocation = base:underwearbottom,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Trousers.txt:28` — `		BodyLocation = base:underwearbottom,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Trousers.txt:47` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.3/42.18/media/scripts/SpongieClothing/Trousers.txt:63` — `        BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:24` — `    if ItemBodyLocation and type(ItemBodyLocation.register) == "function" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:25` — `        pcall(ItemBodyLocation.register, id)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:30` — `    if not (ItemBodyLocation and ResourceLocation`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:32` — `            and type(ItemBodyLocation.get) == "function") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:35` — `    local ok, loc = pcall(ItemBodyLocation.get, ResourceLocation.of(id))`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:43` — `local group = BodyLocations and BodyLocations.getGroup and BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:45` — `    print("[GlassesWithGasMasks] BodyLocationGroup 'Human' unavailable; mod inactive.")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:67` — `-- MASK_EYES vanilla exclusions (from media/lua/shared/NPCs/BodyLocations.lua):`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:74` — `    ex(newMaskEyes, ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:75` — `    ex(newMaskEyes, ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:76` — `    ex(newMaskEyes, ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:77` — `    ex(newMaskEyes, ItemBodyLocation.SCBA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:78` — `    ex(newMaskEyes, ItemBodyLocation.SCBANOTANK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:79` — `    ex(newMaskEyes, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:89` — `    ex(newMaskFull, ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:90` — `    ex(newMaskFull, ItemBodyLocation.MASK_EYES)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:91` — `    ex(newMaskFull, ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:92` — `    ex(newMaskFull, ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:93` — `    ex(newMaskFull, ItemBodyLocation.SCBA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:94` — `    ex(newMaskFull, ItemBodyLocation.SCBANOTANK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:95` — `    ex(newMaskFull, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:111` — `            and hasFn(group, "indexOf") and hasFn(group, "moveLocationToIndex") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:114` — `            pcall(group.moveLocationToIndex, group, customLoc, idx)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:119` — `moveNear(ItemBodyLocation.MASK_EYES, newMaskEyes)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:120` — `moveNear(ItemBodyLocation.MASK_FULL, newMaskFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:123` — `-- B42 getBodyLocation() doesn't always return a plain Lua string for the`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:130` — `    if not hasFn(item, "getBodyLocation") then return "" end`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:131` — `    local ok, v = pcall(item.getBodyLocation, item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:181` — `                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_EYES)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:184` — `                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/sandbox-options.txt:69` — `option CutThatTree.ToolConditionWearMultiplier`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/sandbox-options.txt:76` — `    translation = CutThatTree_ToolConditionWearMultiplier,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/CutThatTree/CTT_Core.lua:151` — `function CutThatTree.getToolConditionWearMultiplier()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/CutThatTree/CTT_Core.lua:152` — `    return CutThatTree.getSandboxNumber("ToolConditionWearMultiplier", 1.0, 0.0, 3.0)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/CutThatTree/CTT_Core.lua:730` — `    local wearMultiplier = CutThatTree.getToolConditionWearMultiplier()`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/CH/Sandbox_CH.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "工具耐久損耗倍率",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/CH/Sandbox_CH.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "改變斧頭和砍伐工具損失耐久的機率。",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/UA/Sandbox_UA.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "Множник зносу міцності інструмента",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/UA/Sandbox_UA.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "Змінює шанс втрати міцності сокир та інструментів для рубання.",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/RU/Sandbox_RU.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "Множитель износа прочности инструмента",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/RU/Sandbox_RU.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "Меняет шанс потери прочности у топоров и инструментов для рубки.",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/DE/Sandbox_DE.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "Werkzeugzustand-Verschleiss",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/DE/Sandbox_DE.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "Ändert die Chance auf Zustandsverlust bei Äxten und Fällwerkzeugen.",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/CN/Sandbox_CN.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "工具耐久损耗倍率",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/CN/Sandbox_CN.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "改变斧头和砍伐工具损失耐久的概率。",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/JP/Sandbox_JP.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "道具耐久度消耗倍率",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/JP/Sandbox_JP.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "斧や伐採道具の耐久度低下の確率を変更します。",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/EN/Sandbox_EN.txt:20` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier = "Tool condition wear multiplier",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/Translate/EN/Sandbox_EN.txt:21` — `    Sandbox_CutThatTree_ToolConditionWearMultiplier_tooltip = "Changes condition loss chance for axes and chopping tools.",`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:3` — `SpnOpenCloth.ItemBodyLocation = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:5` — `SpnOpenCloth.ItemBodyLocation.JACKET_OPEN = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPEN")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:6` — `SpnOpenCloth.ItemBodyLocation.JACKET_ROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_ROLL")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:7` — `SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPENROLL")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:4` — `    require("NPCs/BodyLocations")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:6` — `    local BodyLocations_Helper = require("SpongieOpenJackets/BodyLocations_Helper")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:8` — `    local jacketIndex = BodyLocations_Helper.group:indexOf(ItemBodyLocation.JACKET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:10` — `    local bodylocations = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:11` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPEN] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:14` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:15` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:16` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:17` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:18` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:19` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:20` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:21` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:22` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:23` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:24` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:25` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:26` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:27` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:28` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:31` — `                ItemBodyLocation.LEFT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:32` — `                ItemBodyLocation.RIGHT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:33` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:34` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:35` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:38` — `                ItemBodyLocation.FORE_ARM_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:39` — `                ItemBodyLocation.FORE_ARM_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:40` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:41` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:42` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:43` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:44` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:45` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:48` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_ROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:51` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:52` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:53` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:54` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:55` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:56` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:57` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:58` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:59` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:60` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:61` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:62` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:63` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:64` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:65` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:68` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:69` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:70` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:73` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:74` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:75` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:76` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:77` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:78` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:81` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:84` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:85` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:86` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:87` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:88` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:89` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:90` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:91` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:92` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:93` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:94` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:95` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:96` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:97` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:98` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:101` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:102` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:105` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:106` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:107` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:108` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:109` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:110` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:116` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:117` — `        BodyLocations_Helper:AddLocation(name, data.index)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:119` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:120` — `        BodyLocations_Helper:SetExclusive(name, data.exclusive)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:121` — `        BodyLocations_Helper:SetHidden(name, data.hidden)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:122` — `        BodyLocations_Helper:SetAltModel(name, data.altModel)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:1` — `local BodyLocations_Helper = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:3` — `BodyLocations_Helper.group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:4` — `function BodyLocations_Helper:AddLocation(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:6` — `	self.group:moveLocationToIndex(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:8` — `function BodyLocations_Helper:SetExclusive(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:13` — `function BodyLocations_Helper:SetHidden(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:18` — `function BodyLocations_Helper:SetAltModel(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:24` — `return BodyLocations_Helper`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:7` — `		BodyLocation = base:dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:23` — `		BodyLocation = base:dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:39` — `		BodyLocation = base:longdress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:55` — `		BodyLocation = base:dress,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:71` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:88` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:105` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:122` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:139` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:156` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:173` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:190` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:207` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:224` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:241` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:258` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:275` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:292` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:309` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:328` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:346` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:367` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:388` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:405` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:425` — `		BodyLocation = base:pants,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:445` — `		BodyLocation = base:shortsshort,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:462` — `		BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:477` — `		BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:494` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:506` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:519` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:532` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:546` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:559` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:576` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:592` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:609` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:625` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:639` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:652` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:666` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:679` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:693` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:706` — `		BodyLocation = base:eyes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:720` — `		BodyLocation = base:mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:739` — `		BodyLocation = base:mask,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:758` — `		BodyLocation = Nose,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:774` — `        BodyLocation = base:right_ringfinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:788` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:804` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:823` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:842` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:861` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:880` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:896` — `		BodyLocation = base:tshirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:912` — `		BodyLocation = base:skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:928` — `		BodyLocation = base:skirt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:944` — `		BodyLocation = base:scarf,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:955` — `		BodyLocation = base:right_middlefinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:969` — `		BodyLocation = base:left_middlefinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:983` — `		BodyLocation = base:right_middlefinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:994` — `		BodyLocation = base:scarf,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1005` — `		BodyLocation = base:right_middlefinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1019` — `		BodyLocation = base:left_middlefinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1033` — `		BodyLocation = base:right_middlefinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1044` — `		BodyLocation = base:thigh_left,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1058` — `		BodyLocation = base:thigh_right,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1072` — `		BodyLocation = base:underwearextra2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1084` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1103` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1122` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1141` — `		BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1159` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1182` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1205` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1228` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1251` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1274` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1297` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1320` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1343` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1366` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1389` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1412` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1435` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1458` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1481` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1504` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1527` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1550` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1573` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1596` — `		BodyLocation = base:shoes,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1621` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1646` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1671` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1696` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1721` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1746` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1771` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1796` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1821` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1846` — `		BodyLocation = base:jacket,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1871` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1895` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1919` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1943` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1967` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:1991` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2015` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2039` — `		BodyLocation = base:bathrobe,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2061` — `		BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2073` — `		BodyLocation = base:underwearbottom,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2084` — `		BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2095` — `		BodyLocation = base:underwearbottom,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2106` — `		BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2117` — `		BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2128` — `		BodyLocation = base:underwearbottom,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2139` — `		BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2150` — `		BodyLocation = base:underwearbottom,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2161` — `		BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2176` — `		BodyLocation = base:torsoextra,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2191` — `		BodyLocation = base:underwearextra2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2206` — `		BodyLocation = base:tail,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2222` — `		BodyLocation = base:belt,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2234` — `		BodyLocation = base:vesttexture,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2250` — `		BodyLocation = base:vesttexture,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2266` — `		BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2282` — `		BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2297` — `		BodyLocation = base:tanktop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2314` — `		BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2329` — `		BodyLocation = base:hands,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2345` — `		BodyLocation = base:right_ringfinger,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2359` — `        BodyLocation = base:ears,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2369` — `        BodyLocation = base:necklace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2381` — `        BodyLocation = base:necklace,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2393` — `        BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2407` — `        BodyLocation = base:underweartop,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2421` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2432` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2443` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2454` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2465` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2476` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2487` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2498` — `        BodyLocation = base:underwearextra1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2509` — `        BodyLocation = base:underwearextra2,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2520` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2540` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2560` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2580` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2600` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2620` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2640` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2660` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2680` — `        BodyLocation = base:torso1legs1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2700` — `        BodyLocation = base:torso1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2720` — `        BodyLocation = base:torso1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2740` — `        BodyLocation = base:torso1,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2762` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2782` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2803` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/EclipseZ - 2/Contents/mods/ECZ2_11/42.15/media/scripts/clothing/tomb_clothingitems.txt:2823` — `        BodyLocation = base:hat,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:118` — `local function ApplyBayonetWeaponWear(character, tempWeapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:120` — `    if not context or context.weaponWearProcessed then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:122` — `    context.weaponWearProcessed = true`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:489` — `        weaponWearProcessed = false,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:574` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:578` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_7.1/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:582` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_5/42.20.0/media/registries.lua:75` — `ItemBodyLocation.register("sapphcooking:chefapron")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_1/42/media/lua/client/SOTOclientMainFunctions.lua:526` — `		local wornItems = player:getWornItems();`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_1/42/media/lua/client/SOTOclientMainFunctions.lua:616` — `	local wornItems = player:getWornItems();`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_EnvironmentalDiseases.lua:898` — `        if item.getBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_EnvironmentalDiseases.lua:899` — `            pcall(function() location = item:getBodyLocation() end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_EnvironmentalDiseases.lua:922` — `    pcall(function() wornItems = player:getWornItems() end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:615` — `local function getBodyLocationText(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:616` — `    if not item or not item.getBodyLocation then return "" end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:617` — `    local ok, value = pcall(function() return item:getBodyLocation() end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:627` — `    local loc = getBodyLocationText(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:662` — `    if not player or not player.getWornItems then return result end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_CorpseSickness.lua:664` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_BodyTemperature.lua:1106` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/shared/ExtensiveHealth/EHR_BodyTemperature.lua:1128` — `                local location = item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:360` — `    if player.getWornItem and ItemBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:361` — `        local locations = { ItemBodyLocation.HANDS, ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.HANDS_RIGHT }`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:364` — `            pcall(function() if location then item = player:getWornItem(location) end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:369` — `    if not player.getWornItems then return nil end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:370` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HerbalSearchServer.lua:376` — `            pcall(function() if item.getBodyLocation then location = item:getBodyLocation() end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_ServerCommands.lua:157` — `    if not player or not player.getWornItems then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_ServerCommands.lua:160` — `        return player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:235` — `    if player.getWornItem and ItemBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:236` — `        local locations = { ItemBodyLocation.HANDS, ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.HANDS_RIGHT }`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:239` — `            pcall(function() if location then item = player:getWornItem(location) end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:243` — `    if not player.getWornItems then return nil end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:244` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/server/ExtensiveHealth/EHR_HiveWebSearchServer.lua:250` — `            pcall(function() if item.getBodyLocation then location = item:getBodyLocation() end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HealthPanelUI.lua:2961` — `    if not player or not player.getWornItems then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HealthPanelUI.lua:2963` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:92` — `    if player.getWornItem and ItemBodyLocation then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:93` — `        local locations = { ItemBodyLocation.HANDS, ItemBodyLocation.HANDS_LEFT, ItemBodyLocation.HANDS_RIGHT }`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:96` — `            pcall(function() if location then item = player:getWornItem(location) end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:101` — `    if not player.getWornItems then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:102` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_15/42/media/lua/client/ExtensiveHealth/EHR_HerbalSearch.lua:108` — `            pcall(function() if item.getBodyLocation then location = item:getBodyLocation() end end)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:118` — `local function ApplyBayonetWeaponWear(character, tempWeapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:120` — `    if not context or context.weaponWearProcessed then return false end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:122` — `    context.weaponWearProcessed = true`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:489` — `        weaponWearProcessed = false,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:574` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:578` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_18.2/42.13/media/lua/shared/WeaponSystems/Utils/Bayonet.lua:582` — `    ApplyBayonetWeaponWear(character, weapon)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:695` — `		equipAction = ISWearClothing:new(character,item,50)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:771` — `	character:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/LSUtil.lua:805` — `		--character:setWornItem(item:getBodyLocation(), item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:290` — `				if player:isEquippedClothing(newItem) then player:removeWornItem(newItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:442` — `		if (instanceof(item, "InventoryContainer") and item:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:443` — `			player:setWornItem(item:canBeEquipped(), item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:446` — `			player:setWornItem(item:getBodyLocation(), item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:459` — `	if player:isEquippedClothing(item) then player:removeWornItem(item); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:487` — `		player:removeWornItem(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:503` — `	local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/LSservercommands.lua:508` — `		local location = item and item.getBodyLocation and item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:111` — `    local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:114` — `        if item:getFullType() == itemToBeWorn and item:getBodyLocation() == itemToBeWorn:getBodyLocation() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:122` — `	local hatSlot = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:127` — `	local bL = item.getBodyLocation and item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:128` — `	local validBl = bL and bL ~= "" and (not hasNeuralHat(character) or (bL ~= ItemBodyLocation.HAT and bL ~= ItemBodyLocation.FULL_HAT and bL ~= ItemBodyLocation.MASK_FULL))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:130` — `		local contBl = instanceof(item, "InventoryContainer") and item:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:131` — `		validBl = contBl and contBl ~= "" and (not hasNeuralHat(character) or (contBl ~= ItemBodyLocation.HAT and contBl ~= ItemBodyLocation.FULL_HAT and contBl ~= ItemBodyLocation.MASK_FULL))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:156` — `				player:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:180` — `							if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:181` — `								player:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:184` — `							player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:235` — `				if not isClient() then player:removeWornItem(item, false); end --!`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:284` — `				if itemToBeWorn and itemToBeWorn:getCategory() == "Clothing" and player:getWornItem(itemToBeWorn:getBodyLocation()) == itemToBeWorn then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:293` — `						--player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:298` — `						if player:getHumanVisual():getHairModel():contains("Mohawk") and (itemToBeWorn:getBodyLocation() == "Hat" or itemToBeWorn:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:373` — `				--player:removeWornItem(item, false) --!`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:473` — `									--	if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:474` — `									--		player:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:477` — `									--		player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:483` — `										if player:getHumanVisual():getHairModel():contains("Mohawk") and (itemToBeWorn:getBodyLocation() == "Hat" or itemToBeWorn:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:531` — `	--				if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) and isItemNotEquipped == true then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:541` — `	--					if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:542` — `	--						player:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:545` — `	--					player:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeChange.lua:552` — `	--					if player:getHumanVisual():getHairModel():contains("Mohawk") and (itemToBeWorn:getBodyLocation() == "Hat" or itemToBeWorn:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/WardrobeSet.lua:11` — `	local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/Helper/TransferHelper.lua:255` — `		local canEquip = item.canBeEquipped and item:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/Helper/TransferHelper.lua:257` — `			character:setWornItem(item:getBodyLocation(), item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:235` — `		if item:getClothingItem() and self.character:isEquippedClothing(item) and (item:getBodyLocation() == "Bottoms" or item:getBodyLocation() == "Underwear" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:236` — `		item:getBodyLocation() == "Skirt" or item:getBodyLocation() == "Legs1" or item:getBodyLocation() == "Pants" or item:getBodyLocation() == "UnderwearBottom" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:237` — `		item:getBodyLocation() == "Torso1Legs1" or item:getBodyLocation() == "BathRobe" or item:getBodyLocation() == "FullSuit" or item:getBodyLocation() == "Tail" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:238` — `		item:getBodyLocation() == "FullSuitHead" or item:getBodyLocation() == "Boilersuit" or item:getBodyLocation() == "Dress") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:250` — `			self.character:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:315` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:320` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:321` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:324` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:389` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:394` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:395` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToiletGround.lua:398` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseTub.lua:840` — `		local item = self.character:getWornItem(ItemBodyLocation[makeup])`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseTub.lua:842` — `			self.character:removeWornItem(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseShower.lua:619` — `		local item = self.character:getWornItem(ItemBodyLocation[makeup])`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseShower.lua:621` — `			self.character:removeWornItem(item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:269` — `		if item:getClothingItem() and self.character:isEquippedClothing(item) and (item:getBodyLocation() == "Bottoms" or item:getBodyLocation() == "Underwear" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:270` — `		item:getBodyLocation() == "Skirt" or item:getBodyLocation() == "Legs1" or item:getBodyLocation() == "Pants" or item:getBodyLocation() == "UnderwearBottom" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:271` — `		item:getBodyLocation() == "Torso1Legs1" or item:getBodyLocation() == "BathRobe" or item:getBodyLocation() == "FullSuit" or item:getBodyLocation() == "Tail" or`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:272` — `		item:getBodyLocation() == "FullSuitHead" or item:getBodyLocation() == "Boilersuit" or item:getBodyLocation() == "Dress") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:284` — `			self.character:removeWornItem(item, false)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:455` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:460` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:461` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:464` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:613` — `					if (itemToBeWorn:getBodyLocation() ~= "" or (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "")) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:618` — `						if (instanceof(itemToBeWorn, "InventoryContainer") and itemToBeWorn:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:619` — `							self.character:setWornItem(itemToBeWorn:canBeEquipped(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSUseToilet.lua:622` — `						self.character:setWornItem(itemToBeWorn:getBodyLocation(), itemToBeWorn);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSBrushTeeth.lua:231` — `	local item = self.character:getWornItem("MakeUp_Lips");`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/LSBrushTeeth.lua:238` — `		self.character:removeWornItem(item);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:11` — `require "TimedActions/ISWearClothing"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:14` — `	local hatSlot = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:21` — `		bL = item:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:23` — `		bL = item:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:26` — `		if bL ~= ItemBodyLocation.HAT and bL ~= ItemBodyLocation.FULL_HAT and bL ~= ItemBodyLocation.MASK_FULL then return true; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:32` — `local og_start = ISWearClothing.start;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Wear.lua:33` — `function ISWearClothing:start()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/shared/TimedActions/hooks/Read.lua:25` — `	local headgear = self.character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:36` — `local function MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:37` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:41` — `			if makeup then bodyLocationItem = character:getWornItem(makeup:getBodyLocation()); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:42` — `			--if bodyLocationItem then print("MMgetMakeupBottomOptions: found an item for bodyLocationItem, name is: " .. bodyLocationItem:getName()); break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:43` — `			if bodyLocationItem then break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:46` — `	return bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:85` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:89` — `			bodyLocationItem = MMgetMakeupBodyLocationItem(character, data)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:90` — `			--print("LSMirrorMenu_server.setMirrorChanges - bodyLocationItem set")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:91` — `		elseif bodyLocationItem then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:94` — `				playerInv:AddItem(bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:95` — `				sendAddItemToContainer(playerInv, bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:102` — `				local bodyL = bodyLocationItem:getBodyLocation()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:103` — `				character:setWornItem(bodyL, bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:104` — `				sendClothing(character,bodyL, bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:106` — `				--if bodyLocationItem.UseAndSync then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:107` — `				--	bodyLocationItem:UseAndSync()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:108` — `				--	sendItemStats(bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/server/Makeup/LSMirrorMenu_server.lua:111` — `			bodyLocationItem = false`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:37` — `local function MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:38` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:42` — `			if makeup then bodyLocationItem = character:getWornItem(makeup:getBodyLocation()); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:43` — `			--if bodyLocationItem then print("MMgetMakeupBottomOptions: found an item for bodyLocationItem, name is: " .. bodyLocationItem:getName()); break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:44` — `			if bodyLocationItem then break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:47` — `	return bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:163` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:168` — `			bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, data)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:169` — `		elseif bodyLocationItem then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:172` — `					playerInv:AddItem(bodyLocationItem)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:176` — `					--if bodyLocationItem.Use then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:177` — `					--	bodyLocationItem:Use()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:182` — `			bodyLocationItem = false`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:194` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:210` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:211` — `		if (self.resetMakeupFull ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupFull and (self.resetMakeupFull ~= 0) then self.character:setWornItem(self.resetMakeupFull:getBodyLocation(), self.resetMakeupFull); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:214` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:215` — `		if (self.resetMakeupEye ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEye and (self.resetMakeupEye ~= 0) then self.character:setWornItem(self.resetMakeupEye:getBodyLocation(), self.resetMakeupEye); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:218` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:219` — `		if (self.resetMakeupEyeShadow ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow ~= 0) then self.character:setWornItem(self.resetMakeupEyeShadow:getBodyLocation(), self.resetMakeupEyeShadow); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:222` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:223` — `		if (self.resetMakeupLipstick ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupLipstick and (self.resetMakeupLipstick ~= 0) then self.character:setWornItem(self.resetMakeupLipstick:getBodyLocation(), self.resetMakeupLipstick); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:226` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:227` — `		if (self.resetMakeupTattooFace ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooFace and (self.resetMakeupTattooFace ~= 0) then self.character:setWornItem(self.resetMakeupTattooFace:getBodyLocation(), self.resetMakeupTattooFace); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:230` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:231` — `		if (self.resetMakeupTattooUB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooUB and (self.resetMakeupTattooUB ~= 0) then self.character:setWornItem(self.resetMakeupTattooUB:getBodyLocation(), self.resetMakeupTattooUB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:234` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:235` — `		if (self.resetMakeupTattooLB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLB and (self.resetMakeupTattooLB ~= 0) then self.character:setWornItem(self.resetMakeupTattooLB:getBodyLocation(), self.resetMakeupTattooLB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:238` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:239` — `		if (self.resetMakeupTattooBack ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooBack and (self.resetMakeupTattooBack ~= 0) then self.character:setWornItem(self.resetMakeupTattooBack:getBodyLocation(), self.resetMakeupTattooBack); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:242` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:243` — `		if (self.resetMakeupTattooLA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLA and (self.resetMakeupTattooLA ~= 0) then self.character:setWornItem(self.resetMakeupTattooLA:getBodyLocation(), self.resetMakeupTattooLA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:246` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:247` — `		if (self.resetMakeupTattooRA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRA and (self.resetMakeupTattooRA ~= 0) then self.character:setWornItem(self.resetMakeupTattooRA:getBodyLocation(), self.resetMakeupTattooRA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:250` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:251` — `		if (self.resetMakeupTattooLL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLL and (self.resetMakeupTattooLL ~= 0) then self.character:setWornItem(self.resetMakeupTattooLL:getBodyLocation(), self.resetMakeupTattooLL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:254` — `		bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:255` — `		if (self.resetMakeupTattooRL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRL and (self.resetMakeupTattooRL ~= 0) then self.character:setWornItem(self.resetMakeupTattooRL:getBodyLocation(), self.resetMakeupTattooRL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:273` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:274` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:275` — `	if (self.resetMakeupFull ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupFull and (self.resetMakeupFull ~= 0) then self.character:setWornItem(self.resetMakeupFull:getBodyLocation(), self.resetMakeupFull); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:276` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:277` — `	if (self.resetMakeupEye ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEye and (self.resetMakeupEye ~= 0) then self.character:setWornItem(self.resetMakeupEye:getBodyLocation(), self.resetMakeupEye); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:278` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:279` — `	if (self.resetMakeupEyeShadow ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow ~= 0) then self.character:setWornItem(self.resetMakeupEyeShadow:getBodyLocation(), self.resetMakeupEyeShadow); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:280` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:281` — `	if (self.resetMakeupLipstick ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupLipstick and (self.resetMakeupLipstick ~= 0) then self.character:setWornItem(self.resetMakeupLipstick:getBodyLocation(), self.resetMakeupLipstick); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:282` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:283` — `	if (self.resetMakeupTattooFace ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooFace and (self.resetMakeupTattooFace ~= 0) then self.character:setWornItem(self.resetMakeupTattooFace:getBodyLocation(), self.resetMakeupTattooFace); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:284` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:285` — `	if (self.resetMakeupTattooUB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooUB and (self.resetMakeupTattooUB ~= 0) then self.character:setWornItem(self.resetMakeupTattooUB:getBodyLocation(), self.resetMakeupTattooUB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:286` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:287` — `	if (self.resetMakeupTattooLB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLB and (self.resetMakeupTattooLB ~= 0) then self.character:setWornItem(self.resetMakeupTattooLB:getBodyLocation(), self.resetMakeupTattooLB); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:288` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:289` — `	if (self.resetMakeupTattooBack ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooBack and (self.resetMakeupTattooBack ~= 0) then self.character:setWornItem(self.resetMakeupTattooBack:getBodyLocation(), self.resetMakeupTattooBack); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:290` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:291` — `	if (self.resetMakeupTattooLA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLA and (self.resetMakeupTattooLA ~= 0) then self.character:setWornItem(self.resetMakeupTattooLA:getBodyLocation(), self.resetMakeupTattooLA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:292` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:293` — `	if (self.resetMakeupTattooRA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRA and (self.resetMakeupTattooRA ~= 0) then self.character:setWornItem(self.resetMakeupTattooRA:getBodyLocation(), self.resetMakeupTattooRA); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:294` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:295` — `	if (self.resetMakeupTattooLL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLL and (self.resetMakeupTattooLL ~= 0) then self.character:setWornItem(self.resetMakeupTattooLL:getBodyLocation(), self.resetMakeupTattooLL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:296` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:297` — `	if (self.resetMakeupTattooRL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRL and (self.resetMakeupTattooRL ~= 0) then self.character:setWornItem(self.resetMakeupTattooRL:getBodyLocation(), self.resetMakeupTattooRL); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:314` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:318` — `			bodyLocationItem = self.character:getWornItem(makeup:getBodyLocation())`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:319` — `			if bodyLocationItem then break; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:323` — `	if not bodyLocationItem then return; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:325` — `	if button.internal == "FullFace" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupFull = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:326` — `	elseif button.internal == "Eyes" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupEye = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:327` — `	elseif button.internal == "EyesShadow" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupEyeShadow = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:328` — `	elseif button.internal == "Lips" then self.character:removeWornItem(bodyLocationItem); self.resetMakeupLipstick = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:330` — `	elseif button.internal == "Face_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooFace = 0; elseif button.internal == "UpperBody_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooUB = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:331` — `	elseif button.internal == "LowerBody_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooLB = 0; elseif button.internal == "Back_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooBack = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:332` — `	elseif button.internal == "LeftArm_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooLA = 0; elseif button.internal == "RightArm_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooRA = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:333` — `	elseif button.internal == "LeftLeg_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooLL = 0; elseif button.internal == "RightLeg_Tattoo" then self.acidBrush=true; self.character:removeWornItem(bodyLocationItem); self.resetMakeupTattooRL = 0;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:358` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:360` — `	if self.resetMakeupFull and (self.resetMakeupFull == 0) and (makeupCat == "FullFace") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace"); self.resetMakeupFull = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:361` — `	if self.resetMakeupEye and (self.resetMakeupEye == 0) and (makeupCat == "Eyes") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes"); self.resetMakeupEye = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:362` — `	if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow == 0) and (makeupCat == "EyesShadow") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow"); self.resetMakeupEyeShadow = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:363` — `	if self.resetMakeupLipstick and (self.resetMakeupLipstick == 0) and (makeupCat == "Lips") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips"); self.resetMakeupLipstick = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:365` — `	if self.resetMakeupTattooFace and (self.resetMakeupTattooFace == 0) and (makeupCat == "Face_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo"); self.resetMakeupTattooFace = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:366` — `	if self.resetMakeupTattooUB and (self.resetMakeupTattooUB == 0) and (makeupCat == "UpperBody_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo"); self.resetMakeupTattooUB = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:367` — `	if self.resetMakeupTattooLB and (self.resetMakeupTattooLB == 0) and (makeupCat == "LowerBody_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo"); self.resetMakeupTattooLB = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:368` — `	if self.resetMakeupTattooBack and (self.resetMakeupTattooBack == 0) and (makeupCat == "Back_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo"); self.resetMakeupTattooBack = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:370` — `	if self.resetMakeupTattooLA and (self.resetMakeupTattooLA == 0) and (makeupCat == "LeftArm_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo"); self.resetMakeupTattooLA = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:371` — `	if self.resetMakeupTattooRA and (self.resetMakeupTattooRA == 0) and (makeupCat == "RightArm_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo"); self.resetMakeupTattooRA = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:372` — `	if self.resetMakeupTattooLL and (self.resetMakeupTattooLL == 0) and (makeupCat == "LeftLeg_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo"); self.resetMakeupTattooLL = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:373` — `	if self.resetMakeupTattooRL and (self.resetMakeupTattooRL == 0) and (makeupCat == "RightLeg_Tattoo") then bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo"); self.resetMakeupTattooRL = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:392` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:393` — `	if bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:395` — `	self.character:setWornItem(makeup:getBodyLocation(), makeup);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:489` — `	local bodyLocationItem = MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:491` — `	if bodyLocationItem then previousMakeUp = bodyLocationItem; end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:498` — `		if previousMakeup then character:removeWornItem(previousMakeup); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:500` — `		character:setWornItem(makeup:getBodyLocation(), makeup);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:522` — `				if previousMakeup then character:removeWornItem(previousMakeup); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:530` — `						resetPlayerModel = character:getWornItem(makeup:getBodyLocation())`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:531` — `						if resetPlayerModel then character:removeWornItem(resetPlayerModel); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:533` — `					character:setWornItem(makeup:getBodyLocation(), makeup);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:556` — `			character:removeWornItem(previousMakeup)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:558` — `		if bodyLocationItem then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:559` — `			local newBodyLocationItem = MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:560` — `			if newBodyLocationItem then character:removeWornItem(newBodyLocationItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:561` — `			character:setWornItem(bodyLocationItem:getBodyLocation(), bodyLocationItem);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:566` — `			bodyLocationItem = MMgetMakeupBodyLocationItem(character, makeupCat)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:567` — `			if bodyLocationItem then character:removeWornItem(bodyLocationItem); end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1827` — `	self.mO.FF = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1828` — `	self.mO.E = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1829` — `	self.mO.ES = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1830` — `	self.mO.L = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1835` — `		self.mO.FT = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1836` — `		self.mO.UBT = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1837` — `		self.mO.LBT = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1838` — `		self.mO.BT = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1839` — `		self.mO.LAT = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1840` — `		self.mO.RAT = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1841` — `		self.mO.LLT = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1842` — `		self.mO.RLT = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1940` — `	local bodyLocationItem`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1941` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "FullFace")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1942` — `	if (self.resetMakeupFull ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupFull and (self.resetMakeupFull ~= 0) then self.character:setWornItem(self.resetMakeupFull:getBodyLocation(), self.resetMakeupFull); elseif (not bodyLocationItem) and self.mO and self.mO.FF then self.character:setWornItem(self.mO.FF:getBodyLocation(), self.mO.FF); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1943` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Eyes")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1944` — `	if (self.resetMakeupEye ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEye and (self.resetMakeupEye ~= 0) then self.character:setWornItem(self.resetMakeupEye:getBodyLocation(), self.resetMakeupEye); elseif (not bodyLocationItem) and self.mO and self.mO.E then self.character:setWornItem(self.mO.E:getBodyLocation(), self.mO.E); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1945` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "EyesShadow")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1946` — `	if (self.resetMakeupEyeShadow ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupEyeShadow and (self.resetMakeupEyeShadow ~= 0) then self.character:setWornItem(self.resetMakeupEyeShadow:getBodyLocation(), self.resetMakeupEyeShadow); elseif (not bodyLocationItem) and self.mO and self.mO.ES then self.character:setWornItem(self.mO.ES:getBodyLocation(), self.mO.ES); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1947` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Lips")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1948` — `	if (self.resetMakeupLipstick ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupLipstick and (self.resetMakeupLipstick ~= 0) then self.character:setWornItem(self.resetMakeupLipstick:getBodyLocation(), self.resetMakeupLipstick); elseif (not bodyLocationItem) and self.mO and self.mO.L then self.character:setWornItem(self.mO.L:getBodyLocation(), self.mO.L); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1949` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Face_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1950` — `	if (self.resetMakeupTattooFace ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooFace and (self.resetMakeupTattooFace ~= 0) then self.character:setWornItem(self.resetMakeupTattooFace:getBodyLocation(), self.resetMakeupTattooFace); elseif (not bodyLocationItem) and self.mO and self.mO.FT then self.character:setWornItem(self.mO.FT:getBodyLocation(), self.mO.FT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1951` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "UpperBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1952` — `	if (self.resetMakeupTattooUB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooUB and (self.resetMakeupTattooUB ~= 0) then self.character:setWornItem(self.resetMakeupTattooUB:getBodyLocation(), self.resetMakeupTattooUB); elseif (not bodyLocationItem) and self.mO and self.mO.UBT then self.character:setWornItem(self.mO.UBT:getBodyLocation(), self.mO.UBT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1953` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LowerBody_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1954` — `	if (self.resetMakeupTattooLB ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLB and (self.resetMakeupTattooLB ~= 0) then self.character:setWornItem(self.resetMakeupTattooLB:getBodyLocation(), self.resetMakeupTattooLB); elseif (not bodyLocationItem) and self.mO and self.mO.LBT then self.character:setWornItem(self.mO.LBT:getBodyLocation(), self.mO.LBT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1955` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "Back_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1956` — `	if (self.resetMakeupTattooBack ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooBack and (self.resetMakeupTattooBack ~= 0) then self.character:setWornItem(self.resetMakeupTattooBack:getBodyLocation(), self.resetMakeupTattooBack); elseif (not bodyLocationItem) and self.mO and self.mO.BT then self.character:setWornItem(self.mO.BT:getBodyLocation(), self.mO.BT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1957` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1958` — `	if (self.resetMakeupTattooLA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLA and (self.resetMakeupTattooLA ~= 0) then self.character:setWornItem(self.resetMakeupTattooLA:getBodyLocation(), self.resetMakeupTattooLA); elseif (not bodyLocationItem) and self.mO and self.mO.LAT then self.character:setWornItem(self.mO.LAT:getBodyLocation(), self.mO.LAT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1959` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightArm_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1960` — `	if (self.resetMakeupTattooRA ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRA and (self.resetMakeupTattooRA ~= 0) then self.character:setWornItem(self.resetMakeupTattooRA:getBodyLocation(), self.resetMakeupTattooRA); elseif (not bodyLocationItem) and self.mO and self.mO.RAT then self.character:setWornItem(self.mO.RAT:getBodyLocation(), self.mO.RAT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1961` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "LeftLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1962` — `	if (self.resetMakeupTattooLL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooLL and (self.resetMakeupTattooLL ~= 0) then self.character:setWornItem(self.resetMakeupTattooLL:getBodyLocation(), self.resetMakeupTattooLL); elseif (not bodyLocationItem) and self.mO and self.mO.LLT then self.character:setWornItem(self.mO.LLT:getBodyLocation(), self.mO.LLT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1963` — `	bodyLocationItem = MMgetMakeupBodyLocationItem(self.character, "RightLeg_Tattoo")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISUI/LSMirrorMenu.lua:1964` — `	if (self.resetMakeupTattooRL ~= 0) and bodyLocationItem then self.character:removeWornItem(bodyLocationItem); end; if self.resetMakeupTattooRL and (self.resetMakeupTattooRL ~= 0) then self.character:setWornItem(self.resetMakeupTattooRL:getBodyLocation(), self.resetMakeupTattooRL); elseif (not bodyLocationItem) and self.mO and self.mO.RLT then self.character:setWornItem(self.mO.RLT:getBodyLocation(), self.mO.RLT); end;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Inventions/NeuralHat.lua:16` — `	local headgear = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Inventions/NeuralHat.lua:35` — `	info.headgear = character:getWornItems():getItem(ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/MeditateContextMenu.lua:82` — `		for i=0,thisPlayer:getWornItems():size()-1 do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/MeditateContextMenu.lua:83` — `			local item = thisPlayer:getWornItems():get(i):getItem();`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/ZenWellnessContextMenu.lua:160` — `	for i=0,thisPlayer:getWornItems():size()-1 do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/ISMeditation/ZenWellnessContextMenu.lua:161` — `		local item = thisPlayer:getWornItems():get(i):getItem();`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_4/common/media/lua/client/Painting/Sculpting/SculptingWorkContextMenu.lua:574` — `			ISTimedActionQueue.add(ISWearClothing:new(player, workItems['item3'], 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:2` — `KATTAJ1_BodyLocation = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:5` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltLeft       = ItemBodyLocation.register("KATTAJ1:BeltLeft")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:6` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltRight      = ItemBodyLocation.register("KATTAJ1:BeltRight")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:7` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft   = ItemBodyLocation.register("KATTAJ1:BeltBackLeft")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:8` — `    KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight  = ItemBodyLocation.register("KATTAJ1:BeltBackRight")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:11` — `    KATTAJ1_BodyLocation.KATTAJ1_UpperLegs      = ItemBodyLocation.register("KATTAJ1:UpperLegs")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:12` — `    KATTAJ1_BodyLocation.KATTAJ1_LowerLegs      = ItemBodyLocation.register("KATTAJ1:LowerLegs")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:13` — `    KATTAJ1_BodyLocation.KATTAJ1_Knees          = ItemBodyLocation.register("KATTAJ1:Knees")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:16` — `    KATTAJ1_BodyLocation.KATTAJ1_UpperArms      = ItemBodyLocation.register("KATTAJ1:UpperArms")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:17` — `    KATTAJ1_BodyLocation.KATTAJ1_LowerArms      = ItemBodyLocation.register("KATTAJ1:LowerArms")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:18` — `    KATTAJ1_BodyLocation.KATTAJ1_Elbows         = ItemBodyLocation.register("KATTAJ1:Elbows")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:21` — `    KATTAJ1_BodyLocation.KATTAJ1_BackFanny      = ItemBodyLocation.register("KATTAJ1:BackFanny")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:22` — `    KATTAJ1_BodyLocation.KATTAJ1_Balaclava      = ItemBodyLocation.register("KATTAJ1:Balaclava")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:23` — `    KATTAJ1_BodyLocation.KATTAJ1_Headsets       = ItemBodyLocation.register("KATTAJ1:Headsets")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:24` — `    KATTAJ1_BodyLocation.KATTAJ1_Mandible       = ItemBodyLocation.register("KATTAJ1:Mandible")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:27` — `    KATTAJ1_BodyLocation.KATTAJ1_ChestRig       = ItemBodyLocation.register("KATTAJ1:ChestRig")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:30` — `    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack       = ItemBodyLocation.register("KATTAJ1:TacticalFannyPack")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:31` — `    KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront  = ItemBodyLocation.register("KATTAJ1:TacticalFannyPackFront")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:34` — `    KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants    = ItemBodyLocation.register("KATTAJ1:SkinnyPants")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:37` — `    KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads   = ItemBodyLocation.register("KATTAJ1:ShoulderPads")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:38` — `    KATTAJ1_BodyLocation.KATTAJ1_HipProtection  = ItemBodyLocation.register("KATTAJ1:HipProtection")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:41` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic    = ItemBodyLocation.register("KATTAJ1:TorsoExtraPelvic")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:42` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder  = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulder")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:43` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic = ItemBodyLocation.register("KATTAJ1:TorsoExtraShoulderPelvic")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/registries.lua:44` — `    KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull      = ItemBodyLocation.register("KATTAJ1:TorsoExtraFull")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:12` — `        if instanceof(testItem, "InventoryContainer") and testItem:canBeEquipped() ~= nil and testItem:canBeEquipped() ~= "" and not testItem:isEquipped() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:17` — `    if clothing and ISInventoryPaneContextMenu and ISInventoryPaneContextMenu.doWearClothingMenu and`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_WearOptionEnabler.lua:20` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_TooltipFixer.lua:7` — `    if item and instanceof( item, "Clothing") and item:getBodyLocation() and  player:getWornItem(item:getBodyLocation())`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/client/KATTAJ1_TooltipFixer.lua:8` — `    and instanceof(  player:getWornItem(item:getBodyLocation()), "InventoryContainer") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:5` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:7` — `local group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:13` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:14` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:15` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:16` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:19` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:20` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:21` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Knees)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:24` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:25` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:26` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Elbows)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:29` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BackFanny)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:30` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Balaclava)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:31` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Headsets)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:32` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Mandible)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:35` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ChestRig)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:38` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:39` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:42` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:45` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:46` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_HipProtection)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:49` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:50` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:51` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:52` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:56` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack,ItemBodyLocation.FANNY_PACK_BACK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:57` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront,ItemBodyLocation.FANNY_PACK_FRONT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:59` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Balaclava,ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:60` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:61` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:62` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:67` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:68` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:69` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:71` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:72` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:73` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:74` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:75` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:76` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:78` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:79` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:80` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:84` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:85` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:86` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:88` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:89` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:91` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:92` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:93` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:94` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:95` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:96` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:98` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:99` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:100` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:104` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:105` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:106` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:108` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:109` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:111` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:112` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:113` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:114` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:115` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:116` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:118` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:119` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:120` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:124` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:125` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:126` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:128` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:129` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:131` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:132` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:134` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:135` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:136` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:137` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:138` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:139` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:141` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:142` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:143` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:147` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:148` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:149` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:153` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:154` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:156` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:157` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:158` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:159` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:161` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:162` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:163` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:168` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:169` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:172` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:173` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:174` — `    group:setExclusive( KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:175` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:178` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:179` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:180` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:27` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_9/common/media/lua/client/ISUI/BB_CS_EquipFromGroundMenu.lua:37` — `        ISTimedActionQueue.add(ISWearClothing:new(playerObj, obj.item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:1` — `ItemBodyLocation.register("AZ:HeadExtra")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:2` — `ItemBodyLocation.register("AZ:HeadExtraHair")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:3` — `ItemBodyLocation.register("AZ:HeadExtraPlus")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:5` — `ItemBodyLocation.register("AZ:NeckExtra")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:6` — `ItemBodyLocation.register("AZ:LegsExtra")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:8` — `ItemBodyLocation.register("AZ:TorsoRigPlus2")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/registries.lua:9` — `ItemBodyLocation.register("AZ:TorsoExtraPlus1")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:286` — `                if instanceof(result, "InventoryContainer") and (result:canBeEquipped() ~= "") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:288` — `                    character:setWornItem(result:canBeEquipped(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:290` — `                        sendClothing(character, result:canBeEquipped(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:294` — `                    if result:getBodyLocation() ~= "" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:295` — `                        character:setWornItem(result:getBodyLocation(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:297` — `                            sendClothing(character, result:getBodyLocation(), result)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/server/AuthenticZ_RecipeCode.lua:303` — `                            and (result:getBodyLocation() == "Hat" or result:getBodyLocation() == "FullHat") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/client/AuthenticZ_Tweaker.lua:58` — `TweakItem("Base.ManPackRadio", "CanBeEquipped", "AZ:TorsoExtraPlus1");`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/client/AuthenticZ_StraightJacket.lua:10` — `        local wornItems = player:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:1` — `-- AuthenticZ_BodyLocations.lua`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:5` — `-- Never reset or rebuild BodyLocations here: doing so invalidates the live`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:6` — `-- BodyLocationGroup used by the character and can make vanilla watches,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:10` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:12` — `local BodyAPI = BodyLocations`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:13` — `local SlotAPI = ItemBodyLocation`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:39` — `    if not anchorId or not group.indexOf or not group.moveLocationToIndex then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:53` — `            group:moveLocationToIndex(locationId, firstIndex + offset - 1)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:58` — `local function setupAuthenticZBodyLocations()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:87` — `Events.OnGameBoot.Add(setupAuthenticZBodyLocations)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_2/42/media/lua/client/LabModEngine_Client.lua:365` — `        ISInventoryPaneContextMenu.wearItem(clothing, player:getPlayerNum())`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:133` — `    if character:getWornItems():contains(item) then return end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:154` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:185` — `    if character:getWornItems():contains(item) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:217` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.15/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:114` — `    if character:getWornItems():contains(item) then return end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:124` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:134` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/media/lua/client/Starlit/client/timedActions/TimedActionUtils.lua:152` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:133` — `    if character:getWornItems():contains(item) then return end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:144` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:154` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.12/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:173` — `        ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:185` — `    if character:getWornItems():contains(item) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:202` — `        ISWearClothing:new(`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:217` — `    local wornItems = character:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 1/Contents/mods/ECZ_6.1/42.13/media/lua/shared/Starlit/timedActions/TimedActionUtils.lua:241` — `    ISTimedActionQueue.add(ISWearClothing:new(character, item))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:157` — `    tests.canBeEquippedOther = nil;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:169` — `	tests.canBeEquippedContainer = nil;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:293` — `            tests.canBeEquippedOther = testItem;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:370` — `		if instanceof(testItem, "InventoryContainer") and testItem:canBeEquipped() and not playerObj:isEquippedClothing(testItem) and not testItem:getClothingExtraSubmenu() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:371` — `			tests.canBeEquippedContainer = testItem;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:441` — `            tests.canBeEquippedContainer = nil;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:496` — `    if ((tests.clothing and not tests.clothing:isBroken()) or (tests.canBeEquippedContainer or tests.canBeEquippedOther)) and not tests.unequip then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:497` — `        ISInventoryPaneContextMenu.doWearClothingMenu(player, tests.clothing or tests.canBeEquippedContainer or tests.canBeEquippedOther, items, context);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:757` — `        local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1796` — `ISInventoryPaneContextMenu.doWearClothingTooltip = function(playerObj, newItem, currentItem, option)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1801` — `	local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1802` — `	local bodyLocationGroup = wornItems:getBodyLocationGroup()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1803` — `	local location = (newItem:IsClothing() or newItem:IsInventoryContainer()) and newItem:getBodyLocation() or newItem:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1809` — `		if (newItem:getBodyLocation() and newItem:getBodyLocation() == wornItem:getLocation()) or (newItem:canBeEquipped() and newItem:canBeEquipped() == wornItem:getLocation()) or (location ~= nil and bodyLocationGroup:isExclusive(location, wornItem:getLocation())) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1890` — `ISInventoryPaneContextMenu.doWearClothingMenu = function(player, clothing, items, context)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1897` — `    local option = context:addOption(getText("ContextMenu_Wear"), items, ISInventoryPaneContextMenu.onWearItems, player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:1910` — `    ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothing, clothing, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2398` — `	if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2497` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2671` — `	if playerObj:getWornItem(ItemBodyLocation.FULL_HAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2672` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.FULL_HAT), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2674` — `	if playerObj:getWornItem(ItemBodyLocation.HAT) and not beard then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2675` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.HAT), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2677` — `	if beard and playerObj:getWornItem(ItemBodyLocation.MASK) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2678` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.MASK), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2680` — `	if beard and playerObj:getWornItem(ItemBodyLocation.MASK_EYES) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2681` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.MASK_EYES), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2683` — `	if beard and playerObj:getWornItem(ItemBodyLocation.MASK_FULL) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2684` — `		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getWornItem(ItemBodyLocation.MASK_FULL), 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2994` — `ISInventoryPaneContextMenu.onWearItems = function(items, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2998` — `        if not (k:getBodyLocation() and typeDone[k:getBodyLocation()]) and not (k:canBeEquipped() and typeDone[k:canBeEquipped()]) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:2999` — `            if k:getBodyLocation() == ItemBodyLocation.HAT or k:getBodyLocation() == ItemBodyLocation.FULL_HAT then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3001` — `                local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3004` — `                    if (wornItem:getLocation() == ItemBodyLocation.SWEATER_HAT or wornItem:getLocation() == ItemBodyLocation.JACKET_HAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3013` — `            ISInventoryPaneContextMenu.wearItem(k, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3014` — `            if k:getBodyLocation() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3015` — `                typeDone[k:getBodyLocation()] = true;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3017` — `            if k:canBeEquipped() then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3018` — `                typeDone[k:canBeEquipped()] = true;`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3032` — `ISInventoryPaneContextMenu.wearItem = function(item, player)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3038` — `    ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50));`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3839` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:3887` — `    if mask then ISTimedActionQueue.add(ISWearClothing:new(playerObj, mask, 50)) end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4551` — `local function getWornItemInLocation(playerObj, location)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4552` — `    local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4553` — `    local bodyLocationGroup = wornItems:getBodyLocationGroup()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4556` — `        if (wornItem:getLocation() == location) or bodyLocationGroup:isExclusive(wornItem:getLocation(), location) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4588` — `        local location = clothingItemExtra:IsClothing() and clothingItemExtra:getBodyLocation() or clothingItemExtra:canBeEquipped()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4589` — `        local existingItem = getWornItemInLocation(playerObj, location)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4593` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, clothingItemExtra, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4606` — `            ISInventoryPaneContextMenu.doWearClothingTooltip(playerObj, item, clothingItemExtra, option);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4612` — `    if item:getBodyLocation() == ItemBodyLocation.HAT or item:getBodyLocation() == ItemBodyLocation.FULL_HAT then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4613` — `        local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4616` — `            if (wornItem:getLocation() == ItemBodyLocation.SWEATER_HAT or wornItem:getLocation() == ItemBodyLocation.JACKET_HAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4734` — `    if playerObj:getWornItem(ItemBodyLocation.MASK) and not playerObj:getWornItem(ItemBodyLocation.MASK):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4735` — `        mask = playerObj:getWornItem(ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4736` — `    elseif  playerObj:getWornItem(ItemBodyLocation.MASK_EYES) and not playerObj:getWornItem(ItemBodyLocation.MASK_EYES):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4737` — `        mask = playerObj:getWornItem(ItemBodyLocation.MASK_EYES)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4738` — `    elseif  playerObj:getWornItem(ItemBodyLocation.MASK_FULL) and not playerObj:getWornItem(ItemBodyLocation.MASK_FULL):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4739` — `        mask = playerObj:getWornItem(ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4740` — `    elseif  playerObj:getWornItem(ItemBodyLocation.FULL_HAT) and not playerObj:getWornItem(ItemBodyLocation.FULL_HAT):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4741` — `        mask = playerObj:getWornItem(ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4742` — `    elseif  playerObj:getWornItem(ItemBodyLocation.FULL_SUIT_HEAD) and not playerObj:getWornItem(ItemBodyLocation.FULL_SUIT_HEAD):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4743` — `        mask = playerObj:getWornItem(ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4744` — `    elseif  playerObj:getWornItem(ItemBodyLocation.SCBA) and not playerObj:getWornItem(ItemBodyLocation.SCBA):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4745` — `        mask = playerObj:getWornItem(ItemBodyLocation.SCBA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4746` — `    elseif  playerObj:getWornItem(ItemBodyLocation.SCBANOTANK) and not playerObj:getWornItem(ItemBodyLocation.SCBANOTANK):hasTag(ItemTag.CAN_EAT) then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPaneContextMenu.lua:4747` — `        mask = playerObj:getWornItem(ItemBodyLocation.SCBANOTANK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1666` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1668` — `	elseif instanceof(item, "InventoryContainer") and item:canBeEquipped() ~= nil and item:canBeEquipped() ~= "" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1672` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:1915` — `                                ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/ISInventoryPane.lua:2849` — `		local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:12` — `    return self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:32` — `        for i=1,mannequin:getWornItems():size() do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:33` — `            local item = mannequin:getWornItems():get(i-1):getItem()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinWearAll.lua:36` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:13` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:16` — `    if self.object:getWornItems():size()<1 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:19` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()<1 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:27` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:29` — `    elseif self.object:getWornItems():size()<1 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:31` — `    elseif self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()<1 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:40` — `    if self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:42` — `    elseif self.object:getWornItems():size()<1 and self.playerObj:getWornItems():size()>0 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:44` — `    elseif self.object:getWornItems():size()>0 and self.playerObj:getWornItems():size()<1 then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:58` — `	    local wornItemsPlayer = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:67` — `        for i=0,mannequin:getWornItems():size()-1 do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:68` — `            local item = mannequin:getWornItems():get(i):getItem();`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/ISUI/LootWindow/Handlers/MannequinSwitchOutfit.lua:71` — `                ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1082` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1084` — `	elseif instanceof(item, "InventoryContainer") and item:canBeEquipped() ~= nil and item:canBeEquipped() ~= "" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1088` — `			ISInventoryPaneContextMenu.onWearItems({item}, self.player);`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:1300` — `                            ISTimedActionQueue.add(ISWearClothing:new(playerObj, v))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 3/Contents/mods/ECZ3_2/42.19/media/lua/client/CleanUI/Vanilla/CleanUI_Vanilla_ISInventoryPane.lua:2162` — `		local wornItems = playerObj:getWornItems()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:240` — `-- ISWearClothing override REMOVED - causes multiplayer clothing bug`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:241` — `-- Vanilla ISWearClothing works perfectly, any override breaks it`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:242` — `-- DO NOT ADD ANY OVERRIDE FOR ISWearClothing - it will break multiplayer!`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_17/42.19/media/lua/client/TimedActions/FH_ActionOverrides.lua:243` — `print("FH B42.19: ISWearClothing left to vanilla (no override)")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:24` — `    if ItemBodyLocation and type(ItemBodyLocation.register) == "function" then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:25` — `        pcall(ItemBodyLocation.register, id)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:30` — `    if not (ItemBodyLocation and ResourceLocation`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:32` — `            and type(ItemBodyLocation.get) == "function") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:35` — `    local ok, loc = pcall(ItemBodyLocation.get, ResourceLocation.of(id))`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:43` — `local group = BodyLocations and BodyLocations.getGroup and BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:45` — `    print("[GlassesWithGasMasks] BodyLocationGroup 'Human' unavailable; mod inactive.")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:67` — `-- MASK_EYES vanilla exclusions (from media/lua/shared/NPCs/BodyLocations.lua):`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:74` — `    ex(newMaskEyes, ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:75` — `    ex(newMaskEyes, ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:76` — `    ex(newMaskEyes, ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:77` — `    ex(newMaskEyes, ItemBodyLocation.SCBA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:78` — `    ex(newMaskEyes, ItemBodyLocation.SCBANOTANK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:79` — `    ex(newMaskEyes, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:89` — `    ex(newMaskFull, ItemBodyLocation.HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:90` — `    ex(newMaskFull, ItemBodyLocation.MASK_EYES)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:91` — `    ex(newMaskFull, ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:92` — `    ex(newMaskFull, ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:93` — `    ex(newMaskFull, ItemBodyLocation.SCBA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:94` — `    ex(newMaskFull, ItemBodyLocation.SCBANOTANK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:95` — `    ex(newMaskFull, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:111` — `            and hasFn(group, "indexOf") and hasFn(group, "moveLocationToIndex") then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:114` — `            pcall(group.moveLocationToIndex, group, customLoc, idx)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:119` — `moveNear(ItemBodyLocation.MASK_EYES, newMaskEyes)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:120` — `moveNear(ItemBodyLocation.MASK_FULL, newMaskFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:123` — `-- B42 getBodyLocation() doesn't always return a plain Lua string for the`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:130` — `    if not hasFn(item, "getBodyLocation") then return "" end`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:131` — `    local ok, v = pcall(item.getBodyLocation, item)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:181` — `                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_EYES)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_9/42/media/lua/shared/NPCs/GlassesWithGasMasks.lua:184` — `                    pcall(item.DoParam, item, "BodyLocation = " .. NEW_MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/CutThatTree/CTT_Core.lua:151` — `function CutThatTree.getToolConditionWearMultiplier()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/CutThatTree/CTT_Core.lua:152` — `    return CutThatTree.getSandboxNumber("ToolConditionWearMultiplier", 1.0, 0.0, 3.0)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_13/42/media/lua/shared/CutThatTree/CTT_Core.lua:730` — `    local wearMultiplier = CutThatTree.getToolConditionWearMultiplier()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:3` — `SpnOpenCloth.ItemBodyLocation = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:5` — `SpnOpenCloth.ItemBodyLocation.JACKET_OPEN = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPEN")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:6` — `SpnOpenCloth.ItemBodyLocation.JACKET_ROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_ROLL")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/registries.lua:7` — `SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL = ItemBodyLocation.register("SpnOpenCloth:JACKET_OPENROLL")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:4` — `    require("NPCs/BodyLocations")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:6` — `    local BodyLocations_Helper = require("SpongieOpenJackets/BodyLocations_Helper")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:8` — `    local jacketIndex = BodyLocations_Helper.group:indexOf(ItemBodyLocation.JACKET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:10` — `    local bodylocations = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:11` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPEN] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:14` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:15` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:16` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:17` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:18` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:19` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:20` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:21` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:22` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:23` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:24` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:25` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:26` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:27` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:28` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:31` — `                ItemBodyLocation.LEFT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:32` — `                ItemBodyLocation.RIGHT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:33` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:34` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:35` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:38` — `                ItemBodyLocation.FORE_ARM_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:39` — `                ItemBodyLocation.FORE_ARM_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:40` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:41` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:42` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:43` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:44` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:45` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:48` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_ROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:51` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:52` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:53` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:54` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:55` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:56` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:57` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:58` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:59` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:60` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:61` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:62` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:63` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:64` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:65` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:68` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:69` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:70` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:73` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:74` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:75` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:76` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:77` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:78` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:81` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:84` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:85` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:86` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:87` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:88` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:89` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:90` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:91` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:92` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:93` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:94` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:95` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:96` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:97` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:98` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:101` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:102` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:105` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:106` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:107` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:108` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:109` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:110` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:116` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:117` — `        BodyLocations_Helper:AddLocation(name, data.index)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:119` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:120` — `        BodyLocations_Helper:SetExclusive(name, data.exclusive)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:121` — `        BodyLocations_Helper:SetHidden(name, data.hidden)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:122` — `        BodyLocations_Helper:SetAltModel(name, data.altModel)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:1` — `local BodyLocations_Helper = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:3` — `BodyLocations_Helper.group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:4` — `function BodyLocations_Helper:AddLocation(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:6` — `	self.group:moveLocationToIndex(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:8` — `function BodyLocations_Helper:SetExclusive(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:13` — `function BodyLocations_Helper:SetHidden(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:18` — `function BodyLocations_Helper:SetAltModel(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_WEAR_ACTION_V4/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:24` — `return BodyLocations_Helper`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:5` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:7` — `local group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:13` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:14` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:15` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:16` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:19` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:20` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:21` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Knees)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:24` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:25` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:26` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Elbows)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:29` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BackFanny)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:30` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Balaclava)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:31` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Headsets)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:32` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Mandible)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:35` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ChestRig)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:38` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:39` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:42` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:45` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:46` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_HipProtection)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:49` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:50` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:51` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:52` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:56` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack,ItemBodyLocation.FANNY_PACK_BACK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:57` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront,ItemBodyLocation.FANNY_PACK_FRONT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:59` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Balaclava,ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:60` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:61` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:62` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:67` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:68` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:69` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:71` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:72` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:73` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:74` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:75` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:76` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:78` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:79` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:80` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:84` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:85` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:86` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:88` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:89` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:91` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:92` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:93` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:94` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:95` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:96` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:98` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:99` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:100` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:104` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:105` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:106` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:108` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:109` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:111` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:112` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:113` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:114` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:115` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:116` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:118` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:119` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:120` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:124` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:125` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:126` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:128` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:129` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:131` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:132` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:134` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:135` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:136` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:137` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:138` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:139` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:141` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:142` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:143` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:147` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:148` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:149` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:153` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:154` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:156` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:157` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:158` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:159` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:161` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:162` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:163` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:168` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:169` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:172` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:173` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:174` — `    group:setExclusive( KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:175` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:178` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:179` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:180` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:1` — `-- AuthenticZ_BodyLocations.lua`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:5` — `-- Never reset or rebuild BodyLocations here: doing so invalidates the live`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:6` — `-- BodyLocationGroup used by the character and can make vanilla watches,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:10` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:12` — `local BodyAPI = BodyLocations`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:13` — `local SlotAPI = ItemBodyLocation`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:39` — `    if not anchorId or not group.indexOf or not group.moveLocationToIndex then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:53` — `            group:moveLocationToIndex(locationId, firstIndex + offset - 1)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:58` — `local function setupAuthenticZBodyLocations()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:87` — `Events.OnGameBoot.Add(setupAuthenticZBodyLocations)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:4` — `    require("NPCs/BodyLocations")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:6` — `    local BodyLocations_Helper = require("SpongieOpenJackets/BodyLocations_Helper")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:8` — `    local jacketIndex = BodyLocations_Helper.group:indexOf(ItemBodyLocation.JACKET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:10` — `    local bodylocations = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:11` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPEN] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:14` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:15` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:16` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:17` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:18` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:19` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:20` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:21` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:22` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:23` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:24` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:25` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:26` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:27` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:28` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:31` — `                ItemBodyLocation.LEFT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:32` — `                ItemBodyLocation.RIGHT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:33` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:34` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:35` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:38` — `                ItemBodyLocation.FORE_ARM_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:39` — `                ItemBodyLocation.FORE_ARM_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:40` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:41` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:42` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:43` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:44` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:45` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:48` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_ROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:51` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:52` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:53` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:54` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:55` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:56` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:57` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:58` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:59` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:60` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:61` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:62` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:63` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:64` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:65` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:68` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:69` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:70` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:73` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:74` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:75` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:76` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:77` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:78` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:81` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:84` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:85` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:86` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:87` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:88` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:89` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:90` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:91` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:92` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:93` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:94` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:95` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:96` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:97` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:98` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:101` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:102` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:105` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:106` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:107` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:108` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:109` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:110` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:116` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:117` — `        BodyLocations_Helper:AddLocation(name, data.index)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:119` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:120` — `        BodyLocations_Helper:SetExclusive(name, data.exclusive)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:121` — `        BodyLocations_Helper:SetHidden(name, data.hidden)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:122` — `        BodyLocations_Helper:SetAltModel(name, data.altModel)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:1` — `local BodyLocations_Helper = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:3` — `BodyLocations_Helper.group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:4` — `function BodyLocations_Helper:AddLocation(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:6` — `	self.group:moveLocationToIndex(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:8` — `function BodyLocations_Helper:SetExclusive(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:13` — `function BodyLocations_Helper:SetHidden(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:18` — `function BodyLocations_Helper:SetAltModel(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:24` — `return BodyLocations_Helper`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:5` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:7` — `local group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:13` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:14` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:15` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackLeft)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:16` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BeltBackRight)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:19` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:20` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:21` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Knees)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:24` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_UpperArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:25` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:26` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Elbows)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:29` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_BackFanny)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:30` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Balaclava)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:31` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Headsets)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:32` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_Mandible)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:35` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ChestRig)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:38` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:39` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:42` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_SkinnyPants)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:45` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_ShoulderPads)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:46` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_HipProtection)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:49` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:50` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:51` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:52` — `    group:getOrCreateLocation(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:56` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPack,ItemBodyLocation.FANNY_PACK_BACK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:57` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront,ItemBodyLocation.FANNY_PACK_FRONT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:59` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Balaclava,ItemBodyLocation.MASK)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:60` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.MASK_FULL)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:61` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_HAT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:62` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Mandible,ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:67` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:68` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:69` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:71` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:72` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:73` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:74` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:75` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:76` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:78` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:79` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:80` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:84` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:85` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:86` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:88` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:89` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:91` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:92` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:93` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:94` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:95` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:96` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:98` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:99` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:100` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:104` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:105` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:106` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:108` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:109` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:111` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:112` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:113` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:114` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:115` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:116` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:118` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:119` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:120` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:124` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:125` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulder)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:126` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:128` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:129` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:131` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:132` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:134` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT_HEAD)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:135` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_SUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:136` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.FULL_TOP)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:137` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BOILERSUIT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:138` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BATH_ROBE)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:139` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.BODY_COSTUME)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:141` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:142` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:143` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull, ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:147` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:148` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraShoulderPelvic,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:149` — `    group:setHideModel(KATTAJ1_BodyLocation.KATTAJ1_TorsoExtraFull,KATTAJ1_BodyLocation.KATTAJ1_TacticalFannyPackFront)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:153` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:154` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperLegs, ItemBodyLocation.THIGH_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:156` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:157` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:158` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:159` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerLegs, ItemBodyLocation.CALF_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:161` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:162` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, ItemBodyLocation.KNEE_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:163` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Knees, KATTAJ1_BodyLocation.KATTAJ1_LowerLegs)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:168` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:169` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_UpperArms,ItemBodyLocation.SHOULDERPAD_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:172` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:173` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:174` — `    group:setExclusive( KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:175` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_LowerArms,ItemBodyLocation.FORE_ARM_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:178` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_LEFT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:179` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,ItemBodyLocation.ELBOW_RIGHT)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_21.1/42.15/media/lua/shared/NPCs/KATTAJ1_ExtraBodyLocations.lua:180` — `    group:setExclusive(KATTAJ1_BodyLocation.KATTAJ1_Elbows,KATTAJ1_BodyLocation.KATTAJ1_LowerArms)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:1` — `-- AuthenticZ_BodyLocations.lua`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:5` — `-- Never reset or rebuild BodyLocations here: doing so invalidates the live`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:6` — `-- BodyLocationGroup used by the character and can make vanilla watches,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:10` — `require "NPCs/BodyLocations"`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:12` — `local BodyAPI = BodyLocations`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:13` — `local SlotAPI = ItemBodyLocation`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:39` — `    if not anchorId or not group.indexOf or not group.moveLocationToIndex then`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:53` — `            group:moveLocationToIndex(locationId, firstIndex + offset - 1)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:58` — `local function setupAuthenticZBodyLocations()`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 1/Contents/mods/ECZ_25/42/media/lua/shared/NPCs/AuthenticZ_BodyLocations.lua:87` — `Events.OnGameBoot.Add(setupAuthenticZBodyLocations)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:4` — `    require("NPCs/BodyLocations")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:6` — `    local BodyLocations_Helper = require("SpongieOpenJackets/BodyLocations_Helper")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:8` — `    local jacketIndex = BodyLocations_Helper.group:indexOf(ItemBodyLocation.JACKET)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:10` — `    local bodylocations = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:11` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPEN] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:14` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:15` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:16` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:17` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:18` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:19` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:20` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:21` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:22` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:23` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:24` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:25` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:26` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:27` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:28` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:31` — `                ItemBodyLocation.LEFT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:32` — `                ItemBodyLocation.RIGHT_WRIST,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:33` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:34` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:35` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:38` — `                ItemBodyLocation.FORE_ARM_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:39` — `                ItemBodyLocation.FORE_ARM_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:40` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:41` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:42` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:43` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:44` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:45` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:48` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_ROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:51` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:52` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:53` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:54` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:55` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:56` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:57` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:58` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:59` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:60` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:61` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:62` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:63` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:64` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:65` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:68` — `                ItemBodyLocation.FANNY_PACK_FRONT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:69` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:70` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:73` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:74` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:75` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:76` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:77` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:78` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:81` — `        [SpnOpenCloth.ItemBodyLocation.JACKET_OPENROLL] = {`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:84` — `                ItemBodyLocation.JACKET,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:85` — `                SpnOpenCloth.ItemBodyLocation.JACKET_OPEN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:86` — `                SpnOpenCloth.ItemBodyLocation.JACKET_ROLL,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:87` — `                ItemBodyLocation.FULL_SUIT_HEAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:88` — `                ItemBodyLocation.FULL_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:89` — `                ItemBodyLocation.FULL_TOP,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:90` — `                ItemBodyLocation.BATH_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:91` — `                ItemBodyLocation.FULL_ROBE,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:92` — `                ItemBodyLocation.JACKET_DOWN,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:93` — `                ItemBodyLocation.JACKET_HAT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:94` — `                ItemBodyLocation.JACKET_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:95` — `                ItemBodyLocation.JACKET_HAT_BULKY,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:96` — `                ItemBodyLocation.JACKET_SUIT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:97` — `                ItemBodyLocation.SPORT_SHOULDERPAD,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:98` — `                ItemBodyLocation.TORSO_EXTRA,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:101` — `                ItemBodyLocation.FANNY_PACK_BACK,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:102` — `                ItemBodyLocation.SHOULDER_HOLSTER,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:105` — `                ItemBodyLocation.SHOULDERPAD_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:106` — `                ItemBodyLocation.SHOULDERPAD_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:107` — `                ItemBodyLocation.ELBOW_LEFT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:108` — `                ItemBodyLocation.ELBOW_RIGHT,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:109` — `                ItemBodyLocation.CUIRASS,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:110` — `                ItemBodyLocation.WEBBING,`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:116` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:117` — `        BodyLocations_Helper:AddLocation(name, data.index)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:119` — `    for name, data in pairs(bodylocations) do`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:120` — `        BodyLocations_Helper:SetExclusive(name, data.exclusive)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:121` — `        BodyLocations_Helper:SetHidden(name, data.hidden)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Setup.lua:122` — `        BodyLocations_Helper:SetAltModel(name, data.altModel)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:1` — `local BodyLocations_Helper = {}`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:3` — `BodyLocations_Helper.group = BodyLocations.getGroup("Human")`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:4` — `function BodyLocations_Helper:AddLocation(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:6` — `	self.group:moveLocationToIndex(name, i)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:8` — `function BodyLocations_Helper:SetExclusive(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:13` — `function BodyLocations_Helper:SetHidden(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:18` — `function BodyLocations_Helper:SetAltModel(name, list)`
- `MODPACK-ACTUAL-EN-SERVIDOR/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/_AUDITORIA/TEMP_DIAGNOSTICO_EQUIPAMIENTO_ESCALERA_V3/archivos/EclipseZ - 2/Contents/mods/ECZ2_7.1/42.18/media/lua/shared/SpongieOpenJackets/BodyLocations_Helper.lua:24` — `return BodyLocations_Helper`
