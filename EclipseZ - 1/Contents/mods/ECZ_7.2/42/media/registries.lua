-- Runs via ModRegistries.init(), immediately before ScriptManager.Load() parses the item
-- scripts, so these ids resolve when a weapon declares AmmoType = gunsmithing:<id>.
-- The itemKey must be the full type; an ItemKey object stringifies to "Base.<id>" and so
-- can never name a modded item.

AmmoType.register("gunsmithing:musket_ball", "Gunsmithing.MusketBall")
AmmoType.register("gunsmithing:musket_bullet", "Gunsmithing.MusketBullet")
AmmoType.register("gunsmithing:paper_cartridge", "Gunsmithing.PaperCartridge")
AmmoType.register("gunsmithing:handmade_cartridge", "Gunsmithing.HandmadeCartridge")
AmmoType.register("gunsmithing:round_ball_44", "Gunsmithing.RoundBall_44")
AmmoType.register("gunsmithing:pistol_cartridge", "Gunsmithing.PistolCartridge")
