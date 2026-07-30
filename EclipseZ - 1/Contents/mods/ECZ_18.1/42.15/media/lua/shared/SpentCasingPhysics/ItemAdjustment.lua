require("SpentCasingPhysics/ModSupport")
local SpentCasingPhysics = require("SpentCasingPhysics/Init")
local function Adjust(Name, Property, Value)
    local item = ScriptManager.instance:getItem(Name)
    if not item then return end
    item:DoParam(Property .. " = " .. Value)
end

if not SpentCasingPhysics.G93
    and not SpentCasingPhysics.GGS
    and not SpentCasingPhysics.MarzGuns
    and not SpentCasingPhysics.SCGL
then
    Events.OnInitWorld.Add(function()
        --Shotgun Modifiers
        Adjust("Base.DoubleBarrelShotgun", "ManuallyRemoveSpentRounds", "true")
        Adjust("Base.DoubleBarrelShotgunSawnoff", "ManuallyRemoveSpentRounds", "true")

        -- Vanilla
        Adjust("Base.308Bullets", "WorldStaticModel", "HBVCEF.308_Round")
        Adjust("Base.556Bullets", "WorldStaticModel", "HBVCEF.556x45_Round_Base")
        Adjust("Base.Bullets38", "WorldStaticModel", "HBVCEF.38_Round_Base")
        Adjust("Base.Bullets44", "WorldStaticModel", "HBVCEF.44_Round_Base")
        Adjust("Base.Bullets45", "WorldStaticModel", "HBVCEF.45_Round_Base")
        Adjust("Base.Bullets9mm", "WorldStaticModel", "HBVCEF.9x19_Round_Base")
        Adjust("Base.ShotgunShells", "WorldStaticModel", "HBVCEF.12Gauge_Shell_Red")
        Adjust("Base.3030Bullets", "WorldStaticModel", "HBVCEF.3030_Round_Base")
        Adjust("Base.Bullets357", "WorldStaticModel", "HBVCEF.357_Round_Base")

        if SandboxVars.HB.CustomIcons then
            Adjust("Base.308Bullets", "icon", "308_Round")
            Adjust("Base.556Bullets", "icon", "556x45_Round_Base")
            Adjust("Base.Bullets38", "icon", "38_Round_Base")
            Adjust("Base.Bullets44", "icon", "44_Round_Base")
            Adjust("Base.Bullets45", "icon", "45_Round_Base")
            Adjust("Base.Bullets9mm", "icon", "9x19_Round_Base")
            Adjust("Base.ShotgunShells", "icon", "12Gauge_Shell_Red")
            Adjust("Base.3030Bullets", "icon", "3030_Round_Base")
            Adjust("Base.Bullets357", "icon", "357_Round_Base")
        end

        -- VFE and Addons
        if SpentCasingPhysics.VFE then
            Adjust("Base.22Bullets", "WorldStaticModel", "HBVCEF.22_Round_Base")
            Adjust("Base.762Bullets", "WorldStaticModel", "HBVCEF.762x39_Round_Base")
            Adjust("Base.223Bullets", "WorldStaticModel", "HBVCEF.223_Round")
            if SandboxVars.HB.CustomIcons then
                Adjust("Base.22Bullets", "icon", "22_Round_Base")
                Adjust("Base.762Bullets", "icon", "762x39_Round_Base")
                Adjust("Base.223Bullets", "icon", "223_Round")
            end
        end

        if SpentCasingPhysics.VFES then
            Adjust("Base.545Bullets", "WorldStaticModel", "HBVCEF.545x39_Round_Base")
            Adjust("Base.76254Bullets", "WorldStaticModel", "HBVCEF.762x54_Round_Base")
            Adjust("Base.939Bullets", "WorldStaticModel", "HBVCEF.9x39_Round_Base")

            if SandboxVars.HB.CustomIcons then
                Adjust("Base.545Bullets", "icon", "545x39_Round_Base")
                Adjust("Base.76254Bullets", "icon", "762x54_Round_Base")
                Adjust("Base.939Bullets", "icon", "9x39_Round_Base")
            end
        end

        if SpentCasingPhysics.VFE93 then
            Adjust("Base.46Bullets", "WorldStaticModel", "HBVCEF.New_46x30_Round_Base")
            Adjust("Base.57Bullets", "WorldStaticModel", "HBVCEF.New_57x28_Round_Base")

            if SandboxVars.HB.CustomIcons then
                Adjust("Base.46Bullets", "icon", "46x30_Round_Base")
                Adjust("Base.57Bullets", "icon", "57x28_Round_Base")
            end
        end

        if SpentCasingPhysics.FIREARMS or SpentCasingPhysics.FIREARMS_BETA then
            Adjust("Base.Bullets10mm", "WorldStaticModel", "HBVCEF.10x25_Round_Base")
            Adjust("Base.Bullets22", "WorldStaticModel", "HBVCEF.22_Round_Base")
            Adjust("Base.762x51Bullets", "WorldStaticModel", "HBVCEF.762x51_Round_Base")
            Adjust("Base.762x39Bullets", "WorldStaticModel", "HBVCEF.762x39_Round_Base")
            Adjust("Base.Bullets3006", "WorldStaticModel", "HBVCEF.3006_Round_Base")
            Adjust("Base.Bullets4440", "WorldStaticModel", "HBVCEF.44_Round_Base")
            Adjust("Base.Bullets357", "WorldStaticModel", "HBVCEF.357_Round_Base")

            if SandboxVars.HB.CustomIcons then
                Adjust("Base.Bullets10mm", "icon", "9x19_Round_Base")
                Adjust("Base.Bullets22", "icon", "22_Round_Base")
                Adjust("Base.762x51Bullets", "icon", "762x51_Round_Base")
                Adjust("Base.762x39Bullets", "icon", "762x39_Round_Base")
                Adjust("Base.Bullets3006", "icon", "3006_Round_Base")
                Adjust("Base.Bullets4440", "icon", "44_Round_Base")
                Adjust("Base.Bullets357", "icon", "357_Round_Base")
            end
        end
    end)
end
