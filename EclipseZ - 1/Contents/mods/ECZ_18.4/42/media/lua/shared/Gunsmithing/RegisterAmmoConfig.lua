local ReloadAnim = require("WeaponSystems/Utils/ReloadAnim")
local Ammo = require("WeaponSystems/Utils/Ammo")

-- Muzzleloaders that fire a musket ball or Minie load a COMBINED paper cartridge: powder, paper and
-- projectile in one tube, so the gun's AmmoType is the whole round and nothing extra is consumed.
-- Only the cap-lock guns still need a second item per round -- the percussion cap. The cap-and-ball
-- revolvers keep the original split load (plain powder charge + loose ball + cap), and the
-- self-contained metallic-cartridge guns consume nothing extra.
local CAP = { "Gunsmithing.CapsPackage" }
local PAPER_CAP = { "Gunsmithing.PaperCartridge", "Gunsmithing.CapsPackage" }

-- Rifled bores accept a ball or a Minie cartridge; smoothbores take the ball cartridge only. The
-- framework's Ammo-family system carries the mixed load in the gun's AmmoList.
local RIFLED_FAMILY = "gunsmithing_rifled"

---@return nil
local function registerAmmoConfig()
    -- Percussion rifle-musket (the 1861 Springfield, id Musket1855): combined cartridge + cap.
    ReloadAnim.RegisterConsumes("Gunsmithing.Musket1855", CAP)
    ReloadAnim.RegisterConsumes("Gunsmithing.Musket1855_Crafted", CAP)

    -- Cap-and-ball revolvers: loose powder charge + cap, on top of their .44 round ball.
    ReloadAnim.RegisterConsumes("Gunsmithing.RemingtonArmy_Percussion", PAPER_CAP)
    ReloadAnim.RegisterConsumes("Gunsmithing.ColtWalker_Percussion", PAPER_CAP)

    -- Rifled long guns take a ball or a Minie cartridge.
    Ammo.RegisterAmmoFamily(RIFLED_FAMILY, {
        { type = "Gunsmithing.PaperCartridge_Bullet" },
        { type = "Gunsmithing.PaperCartridge_Ball" },
    })
    Ammo.RegisterItemWithFamily(RIFLED_FAMILY, {
        "Gunsmithing.KentuckyRifle",
        "Gunsmithing.KentuckyRifle_Crafted",
        "Gunsmithing.Musket1855",
        "Gunsmithing.Musket1855_Crafted",
    })
end

Events.OnGameBoot.Add(registerAmmoConfig)
