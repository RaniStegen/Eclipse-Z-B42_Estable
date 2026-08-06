-- 实际地下室内容
local procedural_basements = {

cathaya1 = { width=27, height=21, stairx=17, stairy=0, stairDir="W" },
cathaya2 = { width=16, height=23, stairx=2, stairy=0, stairDir="W" },
cathaya3 = { width=18, height=11, stairx=1, stairy=6, stairDir="W" },
cathaya4 = { width=21, height=21, stairx=12, stairy=0, stairDir="W" },
cathaya5 = { width=16, height=11, stairx=3, stairy=0, stairDir="W" },
cathaya6 = { width=9, height=15, stairx=7, stairy=7, stairDir="N" },

}

-- 地下室入口位置 以及索引实际内容
local procedural_basement_spawn_locations = {
	{x=7370, y=12674, stairDir="W", choices={"cathaya1"}},
	{x=7222, y=12621, stairDir="W", choices={"cathaya2"}},
	{x=7292, y=12788, stairDir="W", choices={"cathaya3"}},
	{x=7271, y=13155, stairDir="W", choices={"cathaya4"}},
	{x=7288, y=12920, stairDir="W", choices={"cathaya5"}},
	{x=7298, y=12966, stairDir="N", choices={"cathaya6"}},
	

}

-- 地下室入口装饰（可以不要）
local procedural_basement_access = {

}

local api = Basements.getAPIv1()
api:addAccessDefinitions('Cathaya Valley2.0', procedural_basement_access)
api:addBasementDefinitions('Cathaya Valley2.0', procedural_basements)
api:addSpawnLocations('Cathaya Valley2.0', procedural_basement_spawn_locations)