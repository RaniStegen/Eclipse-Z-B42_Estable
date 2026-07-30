-- ****************************************************
-- Author：十叁
-- Date：2026.04.20
-- ****************************************************
-- LiuDing3DItem记得自己全部替换成自己的名字避免与其他MOD重名

LiuDing3DItem = LiuDing3DItem or {}



-- Tile对应道具表可自己添加对应关系
-- @参数1 ItemType 道具全名
-- @参数2 IsRand 是否随机摆放
-- @参数3 PosX 单格square内的三维坐标x偏移(0为随机)
-- @参数4 PosY 单格square内的三维坐标y偏移(0为随机)
-- @参数5 PosZ 单格square内的三维坐标z偏移(0为随机)
-- @参数6 RotateX 物品的旋转角度X
-- @参数7 RotateY 物品的旋转角度Y
-- @参数8 RotateZ 物品的旋转角度Z
-- @参数9 DisDir 分布方向 N or W
LiuDing3DItem.TileCorrespondItem = 
{
	['LiuDing_Tiles_3DItem_0'] =  {ItemType = 'Base.Sledgehammer',    IsRand = true,  PosZ = 0.1},
	--['LiuDing_Tiles_3DItem_0'] =   {ItemType = 'Base.Sledgehammer',   IsRand = false, PosX = 0.5, PosY = 0.0, PosZ = 0.1, RotateX = 0, RotateY = 0, RotateZ = 180, DisDir = 'W'},
	--['LiuDing_Tiles_3DItem_0'] =   {ItemType = 'Base.Sledgehammer',   IsRand = false, PosX = 0.0, PosY = -0.2, PosZ = 0.1, RotateX = 0, RotateY = 0, RotateZ = 180, DisDir = 'N'},
}



function LiuDing3DItem.Spawns3DItem(square)
	local sqObjs = square:getObjects()
	local top = 0
	local tbl = {}
    for i = 0, sqObjs:size() - 1 do
        if not instanceof(sqObjs:get(i), "IsoWorldInventoryObject") then
			local sqobj = sqObjs:get(i)
			if sqobj:getSprite() ~= nil then 
				
				local sprite = sqObjs:get(i):getSprite():getName()
				
				if LiuDing3DItem.TileCorrespondItem[sqobj:getSprite():getName()] then
					if not tbl[sprite] then 
						tbl[sprite] = {}
					end 
					table.insert(tbl[sprite], sqObjs:get(i))
				else 
					local sharedSprite = getSprite(sprite);
					if sharedSprite then 
						local objProps = sharedSprite:getProperties();
						if objProps then 
							if objProps:get("IsStackable") then
								top = tonumber(objProps:get("Surface")) or 0
							elseif objProps:get("IsTable") then
								top = tonumber(objProps:get("Surface")) or 0
							end 
						end 
					end 
				end 
			end 
		end 
    end
	if top ~= 0 then 
		top = top / 128
	end 
    for k, v in pairs(tbl) do
		local maxnum = #v
		for _k, _v in pairs(v) do
			if _v:getSprite() ~= nil then
				if isClient() then
					sledgeDestroy(_v)
				else
					square:transmitRemoveItemFromSquare(_v)
				end
				local spritename = _v:getSprite():getName()
				local newItem = instanceItem(LiuDing3DItem.TileCorrespondItem[spritename].ItemType)
				if LiuDing3DItem.TileCorrespondItem[spritename].IsRand == true then 
					local x = ZombRandFloat(0.1, 1.0)
					local y = ZombRandFloat(0.1, 1.0)

					local inventoryitem = square:AddWorldInventoryItem(newItem, x, y, 0)
					
					if LiuDing3DItem.TileCorrespondItem[spritename].PosZ then 
						local z = LiuDing3DItem.TileCorrespondItem[spritename].PosZ or 0
						local timerID = "LiuDing3DItem_" .. tostring(square:getX()) .. "_" .. tostring(square:getY()) .. "_" .. tostring(k)
						Events.OnTick.Add(function()
							local worldObj = inventoryitem:getWorldItem()
							if worldObj then
								worldObj:setOffZ(top + z)
							end
							Events.OnTick.Remove(timerID)
						end, timerID)
					end 
				else 
					local x = LiuDing3DItem.TileCorrespondItem[spritename].PosX
					local y = LiuDing3DItem.TileCorrespondItem[spritename].PosY
					local z = LiuDing3DItem.TileCorrespondItem[spritename].PosZ
					local pos = (_k - 0.5) / maxnum
					--local pos = 1.0 / maxnum * _k

					if LiuDing3DItem.TileCorrespondItem[spritename].DisDir == 'N' then 
						x = pos + x
						y = y
					elseif LiuDing3DItem.TileCorrespondItem[spritename].DisDir == 'W' then 
						x = x
						y = pos + y
					end 
					local inventoryitem = square:AddWorldInventoryItem(newItem, 0.5, 0.5, 0)
					
					inventoryitem:setWorldXRotation(LiuDing3DItem.TileCorrespondItem[spritename].RotateX)
					inventoryitem:setWorldYRotation(LiuDing3DItem.TileCorrespondItem[spritename].RotateY)
					inventoryitem:setWorldZRotation(LiuDing3DItem.TileCorrespondItem[spritename].RotateZ)
	
					local timerID = "LiuDing3DItem_" .. tostring(square:getX()) .. "_" .. tostring(square:getY()) .. "_" .. tostring(k)
					Events.OnTick.Add(function()
						local worldObj = inventoryitem:getWorldItem()
						if worldObj then
							worldObj:setOffset(x, y, top + z)
						end
						Events.OnTick.Remove(timerID)
					end, timerID)
				end 
			end
		end 
    end
end 


function LiuDing3DItem.LoadGridsquareAdd()
	Events.LoadGridsquare.Add(LiuDing3DItem.Spawns3DItem)
end 


Events.OnInitGlobalModData.Add(LiuDing3DItem.LoadGridsquareAdd)