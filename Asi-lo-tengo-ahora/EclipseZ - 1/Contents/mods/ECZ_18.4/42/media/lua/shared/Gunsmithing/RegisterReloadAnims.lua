local ReloadAnim = require("WeaponSystems/Utils/ReloadAnim")

-- durations.load is the PER-ROUND interval and must match the clip's own length, or the
-- server-emulated reload and the clip-driven singleplayer one finish at different moments.

--------------------------------------------------------------------------------
-- Muzzleloaders (Bob_MusketReload, 26.3333s). Most share the animId "Musket1770" (the Musket1770_Load
-- node), differing only in which flintlock cocks/uncocks (their ammoParts flint spec). The 1855 uses
-- its own node "Musket1855" - same clip + ramrod, but it swaps the paper cartridge to a MusketBullet
-- (the conical Minie) rather than the 1770's round MusketBall, so it needs a separate marker set.
--------------------------------------------------------------------------------
local MUSKET_LOAD = 26.3333
local PAPER_AND_BALL = { "Gunsmithing.PaperCartridge", "Gunsmithing.MusketBall" }
local PAPER_AND_BULLET = { "Gunsmithing.PaperCartridge", "Gunsmithing.MusketBullet" }

local M1770_FLINT = {
    partType = "GunsmithingFlint",
    loaded = "Gunsmithing.Musket1770_FlintCooked",
    unloaded = "Gunsmithing.Musket1770_FlintUncooked",
}
local M1855_FLINT = {
    partType = "GunsmithingFlint",
    loaded = "Gunsmithing.Musket1855_FlintCooked",
    unloaded = "Gunsmithing.Musket1855_FlintUncooked",
}

---@param flint table
---@param animId string|nil   defaults to "Musket1770"
---@param props string[]|nil  off-hand prop whitelist; defaults to paper cartridge + musket ball
---@nodiscard
---@return table
local function muzzleloaderProfile(flint, animId, props)
    return {
        animId = animId or "Musket1770",
        archetype = "boltactionnomag",
        durations = {
            load = MUSKET_LOAD,
        },
        partState = {
            ammoParts = { flint },
            ensure = { "Gunsmithing.Musket1770_RamRod" },
            props = props or PAPER_AND_BALL,
        },
    }
end

--------------------------------------------------------------------------------
-- 1875 Springfield Trapdoor (Bob_TrapdoorReload, animId "Trapdoor", 6.0s)
-- Single-shot metallic-cartridge breechloader: open trapdoor, insert cartridge, close, cock.
-- The trapdoor + hammer are single cosmetic parts (no cooked variant), so they are just
-- kept attached via ensure; the loaded round is shown as a HandmadeCartridge hand-prop.
--------------------------------------------------------------------------------
local TRAPDOOR_PROFILE = {
    animId = "Trapdoor",
    archetype = "boltactionnomag",
    durations = {
        load = 6.0,
    },
    partState = {
        -- Trapdoor stays closed at rest; the reload markers flip it open then closed, and ensure
        -- re-closes it if a reload is interrupted mid-open.
        ensure = {
            "Gunsmithing.1875Gun_TrapDoorClosed",
        },
        -- Hammer is cocked while the gun is loaded and uncocked when empty: an ammo-keyed part, the
        -- same mechanism as the musket flint's cooked/uncooked.
        ammoParts = {
            {
                partType = "GunsmithingHammer",
                loaded = "Gunsmithing.1875Gun_HammerCooked",
                unloaded = "Gunsmithing.1875Gun_HammerUncooked",
            },
        },
        props = {
            "Gunsmithing.HandmadeCartridge",
        },
    },
}

--------------------------------------------------------------------------------
-- Double-barrel flintlock shotgun (Bob_FlintlockShotgun, animId "FlintlockShotgun", 24.3333s)
-- Muzzleloads two barrels with the ramrod. The two flintlocks are reconciled to cocked/uncooked
-- by DoubleBarrelLocks.lua (the framework only auto-syncs one flint), so partState here carries
-- only the ramrod (kept attached) and the loading props.
--------------------------------------------------------------------------------
local FLINTLOCK_SHOTGUN_PROFILE = {
    animId = "FlintlockShotgun",
    archetype = "doublebarrel",
    -- Muzzle-loader: no break-action to close, so skip the vanilla double-barrel close/rack finish
    -- stage (the "snap the action shut" motion that plays after the rounds load). The flintlocks
    -- cocking is what makes it ready, handled by DoubleBarrelLocks.lua.
    autoRack = false,
    durations = {
        load = 24.3333,
    },
    partState = {
        ensure = { "Gunsmithing.FlintlockShotgun_RamRod" },
        props = {
            "Gunsmithing.PaperCartridge",
            "Gunsmithing.MusketBall",
        },
    },
}

---@return nil
local function registerReloadAnimations()
    ReloadAnim.RegisterMultipleWeapons({
        ["Gunsmithing.Musket1770"]            = muzzleloaderProfile(M1770_FLINT),
        ["Gunsmithing.Musket1770_Crafted"]    = muzzleloaderProfile(M1770_FLINT),
        ["Gunsmithing.KentuckyRifle"]         = muzzleloaderProfile(M1770_FLINT),
        ["Gunsmithing.KentuckyRifle_Crafted"] = muzzleloaderProfile(M1770_FLINT),
        ["Gunsmithing.Musket1855"]            = muzzleloaderProfile(M1855_FLINT, "Musket1855", PAPER_AND_BULLET),
        ["Gunsmithing.Musket1855_Crafted"]    = muzzleloaderProfile(M1855_FLINT, "Musket1855", PAPER_AND_BULLET),
        ["Gunsmithing.1875Gun"]               = TRAPDOOR_PROFILE,
        ["Gunsmithing.DoubleBarrelFlintlockShotgun"] = FLINTLOCK_SHOTGUN_PROFILE,
    })
end

Events.OnGameBoot.Add(registerReloadAnimations)
