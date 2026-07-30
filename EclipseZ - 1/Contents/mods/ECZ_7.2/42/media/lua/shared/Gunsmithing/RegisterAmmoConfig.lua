local ReloadAnim = require("WeaponSystems/Utils/ReloadAnim")
local Ammo = require("WeaponSystems/Utils/Ammo")

-- Multi-item reloads: on top of the projectile the gun's AmmoType names (the "bullet" vanilla
-- consumes), these guns also require + burn a paper powder charge per round, and cap-lock guns a
-- percussion cap. Self-contained metallic-cartridge guns (the 1875 trapdoor and the cartridge
-- revolvers) consume nothing extra -- their cartridge is the whole round.
local PAPER = { "Gunsmithing.PaperCartridge" }
local PAPER_CAP = { "Gunsmithing.PaperCartridge", "Gunsmithing.CapsPackage" }

-- Rifled bores accept a round ball OR a Minie bullet; smoothbores take ball only. The framework's
-- Ammo-family system carries the mixed load in the gun's AmmoList.
local RIFLED_FAMILY = "gunsmithing_rifled"

---@return nil
local function registerAmmoConfig()
    -- Flintlock smoothbores: paper charge + ball.
    ReloadAnim.RegisterConsumes("Gunsmithing.Musket1770", PAPER)
    ReloadAnim.RegisterConsumes("Gunsmithing.Musket1770_Crafted", PAPER)
    ReloadAnim.RegisterConsumes("Gunsmithing.DoubleBarrelFlintlockShotgun", PAPER)

    -- Flintlock rifles: paper charge + ball/Minie.
    ReloadAnim.RegisterConsumes("Gunsmithing.KentuckyRifle", PAPER)
    ReloadAnim.RegisterConsumes("Gunsmithing.KentuckyRifle_Crafted", PAPER)

    -- Percussion rifle-musket (the 1861 Springfield, id Musket1855): paper charge + cap + ball/Minie.
    ReloadAnim.RegisterConsumes("Gunsmithing.Musket1855", PAPER_CAP)
    ReloadAnim.RegisterConsumes("Gunsmithing.Musket1855_Crafted", PAPER_CAP)

    -- Cap-and-ball revolvers: paper charge + cap + ball.
    ReloadAnim.RegisterConsumes("Gunsmithing.RemingtonArmy_Percussion", PAPER_CAP)
    ReloadAnim.RegisterConsumes("Gunsmithing.ColtWalker_Percussion", PAPER_CAP)

    -- Rifled long guns take ball or Minie.
    Ammo.RegisterAmmoFamily(RIFLED_FAMILY, {
        { type = "Gunsmithing.MusketBall" },
        { type = "Gunsmithing.MusketBullet" },
    })
    Ammo.RegisterItemWithFamily(RIFLED_FAMILY, {
        "Gunsmithing.KentuckyRifle",
        "Gunsmithing.KentuckyRifle_Crafted",
        "Gunsmithing.Musket1855",
        "Gunsmithing.Musket1855_Crafted",
    })
end

Events.OnGameBoot.Add(registerAmmoConfig)
