from pathlib import Path
import re

ROOT = Path("EclipseZ - 1/Contents/mods/ECZ_4")
SOUND_FILES = [
    ROOT / "common/media/scripts/Instruments_sounds_item.txt",
    ROOT / "common/media/scripts/LS_HarmonicaInstruments_sounds_item.txt",
]
LUA_FILES = [
    ROOT / "common/media/lua/shared/TimedActions/PlayInstrumentActionNew.lua",
    ROOT / "common/media/lua/shared/TimedActions/PlayInstrumentTraining.lua",
    ROOT / "common/media/lua/shared/TimedActions/PlayInstrumentVocal.lua",
]

BLOCK_PATTERN = re.compile(r"(sound\s+([A-Za-z0-9_]+)\s*\{)(.*?)(\n\s*\})", re.S)


def update_sound_file(path: Path):
    text = path.read_text(encoding="utf-8")
    changed = 0
    volume_changes = []

    def replace_block(match):
        nonlocal changed
        prefix, name, body, suffix = match.groups()
        if "media/sound/Instruments/" not in body:
            return match.group(0)
        if not re.search(r"distanceMax\s*=\s*100(?:\.0+)?\s*,?", body):
            return match.group(0)

        old_volume_match = re.search(r"volume\s*=\s*([0-9.]+)", body)
        new_body = re.sub(
            r"distanceMin\s*=\s*10(?:\.0+)?\s*,\s*distanceMax\s*=\s*100(?:\.0+)?",
            "distanceMin = 3, distanceMax = 24",
            body,
        )

        if old_volume_match:
            old_volume = float(old_volume_match.group(1))
            new_volume = max(0.10, min(0.75, old_volume * 0.65))
            new_volume = round(new_volume + 1e-9, 2)
            formatted = f"{new_volume:.2f}".rstrip("0").rstrip(".")
            new_body = re.sub(
                r"volume\s*=\s*[0-9.]+",
                f"volume = {formatted}",
                new_body,
                count=1,
            )
            volume_changes.append((name, old_volume, new_volume))

        changed += 1
        return prefix + new_body + suffix

    updated = BLOCK_PATTERN.sub(replace_block, text)
    path.write_text(updated, encoding="utf-8")
    return changed, volume_changes


def update_lua_file(path: Path):
    text = path.read_text(encoding="utf-8")
    text = text.replace(
        "local soundRadius, volume = 10, 5",
        "local soundRadius, volume = 8, 3",
    )
    text = text.replace(
        "if self.character:isOutside() then soundRadius, volume = 30, 10; end",
        "if self.character:isOutside() then soundRadius, volume = 20, 6; end",
    )

    if path.name == "PlayInstrumentVocal.lua":
        repeated = """\t\tlocal soundRadius = 10
\t\tlocal volume = 5

\t\tif self.character:isOutside() then
\t\tsoundRadius = 30
\t\tvolume = 10
\t\tend

\t\t-- update for zombies as the character moves

\t\taddSound(self.character,
\t\t\t\t self.character:getX(),
\t\t\t\t self.character:getY(),
\t\t\t\t self.character:getZ(),
\t\t\t\t soundRadius,
\t\t\t\t volume)
"""
        text = text.replace(
            repeated,
            """\t\t-- Actualiza el ruido para zombis mientras el personaje se mueve.
\t\tself[\"soundPing\"](self)
""",
            1,
        )

        fail_block = """\tlocal soundRadius = 10
\tlocal volume = 5

\t\tif self.character:isOutside() then
\t\tsoundRadius = 30
\t\tvolume = 10
\t\tend

\t\tself.character:getEmitter():playSound(failsound);
\t\t
\t\taddSound(self.character,
\t\t\t\t self.character:getX(),
\t\t\t\t self.character:getY(),
\t\t\t\t self.character:getZ(),
\t\t\t\t soundRadius,
\t\t\t\t volume)
"""
        text = text.replace(
            fail_block,
            """\t\tself.character:getEmitter():playSound(failsound);
\t\tself[\"soundPing\"](self)
""",
            1,
        )

    path.write_text(text, encoding="utf-8")


def main():
    total = 0
    changes = []
    for path in SOUND_FILES:
        changed, volumes = update_sound_file(path)
        total += changed
        changes.extend(volumes)
        print(f"{path}: {changed} pistas")

    for path in LUA_FILES:
        update_lua_file(path)
        print(f"{path}: radio de ruido actualizado")

    if total != 861:
        raise SystemExit(f"Se esperaban 861 pistas y se modificaron {total}")
    if len(changes) != 861:
        raise SystemExit(f"Se esperaban 861 ganancias y se modificaron {len(changes)}")

    print(f"Ganancia final mínima: {min(x[2] for x in changes):.2f}")
    print(f"Ganancia final máxima: {max(x[2] for x in changes):.2f}")


if __name__ == "__main__":
    main()
