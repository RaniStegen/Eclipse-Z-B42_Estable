#!/usr/bin/env python3
"""Apply the human terminology review to the Qwen Guns of Marz translation."""

from __future__ import annotations

import json
import re
from pathlib import Path


OVERRIDES = {
    "itemname::MarzGuns.12Gauge_Shell_Buckshot":
        "Cartucho de escopeta de calibre 12 con postas",
    "itemname::MarzGuns.12Gauge_Shell_Slug":
        "Cartucho de escopeta de calibre 12 con bala",
    "itemname::MarzGuns.3006Clip8":
        "Peine de 8 cartuchos de .30-06 Springfield",
    "itemname::MarzGuns.3006Magazine20_BAR":
        "Cargador de 20 cartuchos de .30-06 Springfield",
    "itemname::MarzGuns.357SpeedLoader6_PYTHON":
        "Cargador rápido de 6 cartuchos de .357 Magnum para Colt Python",
    "itemname::MarzGuns.45_Bullet": "Cartucho .45 ACP",
    "itemname::MarzGuns.45_Crate": "Cajón de cajas de munición .45 ACP",
    "itemname::MarzGuns.50_Bullet": "Cartucho .50 AE",
    "itemname::MarzGuns.50_Casing": "Vaina .50 AE",
    "itemname::MarzGuns.556x45_Box_ArmorPiercing":
        "Caja de cartuchos perforantes de 5.56x45mm",
    "itemname::MarzGuns.556x45_Box_HollowPoint":
        "Caja de cartuchos de punta hueca de 5.56x45mm",
    "itemname::MarzGuns.762x51Box100_M60":
        "Caja de 100 cartuchos de 7.62x51mm para M60",
    "itemname::MarzGuns.BAR": "Browning Automatic Rifle",
    "itemname::MarzGuns.BENELLI_M4": "Escopeta semiautomática Benelli M4",
    "itemname::MarzGuns.BENELLI_M4_TAC": "Escopeta semiautomática táctica Benelli M4",
    "itemname::MarzGuns.M14": "Fusil de combate M14",
    "itemname::MarzGuns.M16A1": "Fusil de asalto M16A1",
    "itemname::MarzGuns.M16A2": "Fusil de asalto M16A2",
    "itemname::MarzGuns.M16A2_M203": "Fusil de asalto M16A2 con M203",
    "itemname::MarzGuns.M16A3": "Fusil de asalto M16A3",
    "itemname::MarzGuns.M1903": "Fusil de cerrojo M1903 Springfield",
    "itemname::MarzGuns.M1_GARAND": "Fusil de combate M1 Garand",
    "itemname::MarzGuns.M24": "Fusil de francotirador M24",
    "itemname::MarzGuns.M4": "Fusil de asalto M4",
    "itemname::MarzGuns.M4A1": "Fusil de asalto M4A1",
    "itemname::MarzGuns.PRL1_Scope": "Mira telescópica PRL-1",
    "itemname::MarzGuns.PS1_Sight": "Mira PS1",
    "itemname::MarzGuns.PSO1_Scope": "Mira telescópica PSO1",
    "itemname::MarzGuns.SAIGAS12": "Escopeta semiautomática Saiga-12",
    "itemname::MarzGuns.SPAS12": "Escopeta semiautomática SPAS-12",
    "itemname::MarzGuns.Trix42_Muzzlebreak": "Freno de boca Trix42",
    "sandbox::Sandbox_MarzGuns_Enable_BAR_tooltip":
        "Activar Browning Automatic Rifle en el botín inicial.",
    "sandbox::Sandbox_MarzGuns_Enable_DETECTIVE_38":
        "Activar revólver Detective .38 (c. 1990 - .38 Special)",
}

LOWERCASE_INSIDE_NAME = (
    "Automática",
    "Balas",
    "Bayoneta",
    "Cajas",
    "Cajón",
    "Cargadores",
    "Cartucho",
    "Cartuchos",
    "Culata",
    "Desplegada",
    "Dispositivo",
    "Empuñadura",
    "Escopeta",
    "Extendido",
    "Mira",
    "Munición",
    "Paquete",
    "Penetrantes",
    "Perforantes",
    "Penetrantes",
    "Pistolas",
    "Plegada",
    "Punta",
    "Hueca",
    "Semiautomática",
    "Subsonicos",
    "Tambor",
    "Vaina",
)


def normalize(identity: str, value: str) -> str:
    value = value.replace("12 Gauge", "calibre 12")
    value = re.sub(r"\bescopeta (?:de )?12\b", "escopeta de calibre 12", value, flags=re.I)
    value = value.replace("Cartón de cajas", "Paquete de cajas")
    value = value.replace("Subsonicos", "subsónicos")

    if identity.startswith("itemname::"):
        for word in LOWERCASE_INSIDE_NAME:
            value = re.sub(rf"(?<!^)\b{word}\b", word.casefold(), value)

        value = re.sub(
            r"^Cargador de tambor (\d+) cartuchos (.+)$",
            r"Cargador de tambor de \1 cartuchos de \2",
            value,
        )
        value = re.sub(
            r"^Cargador (STANAG|G36|Bakelite) (\d+) cartuchos (.+)$",
            r"Cargador \1 de \2 cartuchos de \3",
            value,
        )
        value = re.sub(
            r"^Cargador (\d+) cartuchos (.+)$",
            r"Cargador de \1 cartuchos de \2",
            value,
        )
        value = re.sub(r"^Caja de cartuchos (.+)$", r"Caja de cartuchos de \1", value)
        value = re.sub(
            r"^Paquete de cajas de cartuchos (.+)$",
            r"Paquete de cajas de munición de \1",
            value,
        )
        value = re.sub(
            r"^Cajón de cajas de cartuchos (.+)$",
            r"Cajón de cajas de munición de \1",
            value,
        )
        value = re.sub(r"^Vaina de cartucho (.+)$", r"Vaina de \1", value)
        value = value.replace("Cartucho de bala ", "Cartucho ")
        value = value.replace(" penetrantes", " perforantes")
        value = value.replace(" penetradoras", " perforantes")
        value = re.sub(r"\bcartuchos (\.[0-9])", r"cartuchos de \1", value)
        value = value.replace(" (pistolas 9mm)", " (pistolas de 9 mm)")
        value = value.replace(" (pistolas de 9mm)", " (pistolas de 9 mm)")

    return value


def main() -> int:
    repo = Path(__file__).resolve().parents[1]
    progress_path = repo / "docs/qwen-guns-of-marz-reviewed-translations.json"
    progress = json.loads(progress_path.read_text(encoding="utf-8"))
    if len(progress) != 627:
        raise ValueError(f"Se esperaban 627 entradas revisadas y hay {len(progress)}.")

    changed = 0
    grouped: dict[str, dict[str, str]] = {}
    for identity, item in progress.items():
        value = OVERRIDES.get(identity, normalize(identity, item["value"]))
        if value != item["value"]:
            item["value"] = value
            changed += 1
        grouped.setdefault(item["file"], {})[item["key"]] = value

    progress_path.write_text(
        json.dumps(progress, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )

    central = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES"
    )
    for filename, reviewed in grouped.items():
        path = central / filename
        data = json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}
        data.update(reviewed)
        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
            newline="\n",
        )

    print(json.dumps({"reviewed": len(progress), "changed_after_qwen": changed}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
