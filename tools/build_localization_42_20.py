#!/usr/bin/env python3
"""Build the EclipseZ Spanish localization for Project Zomboid 42.20.

The game-base bundle is rebuilt from the current 42.20 English key topology.
Qwen-reviewed Spanish is preferred, while the official 42.20 Spanish text is
used for keys added after that review. Technical tokens are aligned to the
current English source so controller actions, placeholders and UI markup cannot
silently regress to an older build.

The mod bundle keeps every existing entry and overlays the Qwen-reviewed values.
This script intentionally does not merge or otherwise alter the mods themselves.
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path
from typing import Any


TECH_TOKEN = re.compile(
    r"""
    </?[A-Z][A-Z0-9_]*(?::[^<>]*)?>
    |</?(?:br|font|b|i|u)(?:\s+[^<>]*)?>
    |\[img=[^\]]+\]
    |%(?:\d+\$)?[A-Za-z]
    |%\d+
    """,
    re.VERBOSE,
)
MOJIBAKE_HINT = re.compile(r"(?:Ã.|Â.|â€|ðŸ|ï¿½)")

# Entries whose older Spanish text had lost content or runtime tokens.  These
# are reviewed, complete translations for the current 42.20 English source.
BASE_MANUAL_OVERRIDES: dict[tuple[str, str], str] = {
    ("Challenge.json", "Challenge_Kingsmouth_desc"):
        "¡Escapa del mundo en nuestro paraíso tropical! Explora una isla única con un extenso complejo de cuatro plantas, "
        "bungalós en un paseo marítimo privado, un pequeño pueblo lleno de amables habitantes y mucho más. <LINE><LINE> "
        "Ya sea para pescar, nadar, disfrutar de la mejor comida y bebida o simplemente relajarte, no hay lugar como "
        "Kingsmouth. ¡No olvides la crema solar! <LINE><LINE>",
    ("Challenge.json", "Challenge_Studio_desc"):
        "¡Ya puedes visitar los platós de Mountain Lion Pictures Studios! Descubre dónde se rodaron clásicos como "
        "CyberKiller 2, Mother's Boy y The Dog Goblin. <LINE><LINE>Explora decorados como el pueblo, el cementerio, "
        "la cabaña siniestra y muchos más. Conviértete en la estrella de películas clásicas usando nuestros fondos "
        "azules. Dispara réplicas de armas míticas, como el Magnum de «Filthy» Larry Salatch o la JS2000 recortada de "
        "CyberKiller, en nuestro campo de tiro. ¡Puede que incluso veas alguna cara famosa! <LINE><LINE> AVISO: las "
        "visitas solo se realizan de noche. ¡Durante el día, el reparto y el equipo pueden pasarse un poco con la cafeína!",
    ("ContextMenu.json", "ContextMenu_PickUpAnimalBody"): "Recoger",
    ("ContextMenu.json", "ContextMenu_ButcherAnimal"): "Despiezar",
    ("IG_UI.json", "IGUI_Tutorial1_Bandage5"):
        "<CENTRE> <SIZE:medium> ¡Echemos un vistazo fuera, por si hay más autómatas de carne putrefacta! <LINE> <LINE> "
        "<SIZE:large> ¡Acércate a la ventana con cortinas!",
    ("IG_UI.json", "IGUI_Tutorial1_Shotgun3"):
        "<CENTRE> <SIZE:medium> ¡Aquí vienen! <LINE> <LINE> ¡Aparecerá un círculo rojo cuando apuntes a un objetivo! "
        "<RGB:1,1,1> <LINE> <LINE> <SIZE:large> ¡Pulsa el botón izquierdo del ratón para disparar mientras apuntas "
        "con el botón derecho!",
    ("IG_UI.json", "IGUI_Tutorial1_Welcome2Joypad"):
        "<SIZE:medium> Lo primero es lo primero: ¡puedes alejar el zoom! <LINE> <JOYPAD:Back,28,28> abrirá un menú "
        "con varias opciones. <LINE> <LINE> Contemplemos a vista de pájaro el lugar solitario donde estás a punto de "
        "morir, de forma miserable y en soledad. <LINE> <SIZE:large> Mantén <JOYPAD:Back,28,28>, selecciona "
        "<IMAGE:media/ui/ZoomOut.png,28,28> con <JOYPAD:Aiming,28,28> y, por último, suelta <JOYPAD:Back,28,28>.",
    ("IG_UI.json", "IGUI_Tutorial1_Fight3BisJoypad"):
        "<SIZE:medium> Eso fue INCORRECTO. <LINE> <LINE> NO rompas el ciclo. Para abrir o cerrar una ventana, pulsa "
        "<JOYPAD:Interact,28,28>. Para pasar por ella, pulsa <JOYPAD:ClimbThrough,28,28> o mantén pulsado "
        "<JOYPAD:Interact>. <LINE> <LINE> <SIZE:large> Pulsa <JOYPAD:Interact,28,28> para volver a abrir la ventana, "
        "antes de que nos planteemos tu despido.",
    ("IG_UI.json", "IGUI_Tutorial1_Fight7Joypad"):
        "<SIZE:medium> ¡Toma eso, mamá! <LINE> <LINE> También podrías haber pulsado <JOYPAD:Melee,28,28> para "
        "derribarla, pero ahora mismo tenemos que ir a por la cabeza. <LINE> <LINE> Colócate usando "
        "<JOYPAD:Movement,28,28> y <JOYPAD:Aiming,28,28>, y golpéala con <JOYPAD:Attack,28,28>.",
    ("IG_UI.json", "IGUI_Tutorial1_Shotgun1bJoypad"):
        "<SIZE:medium> Si tienes suficiente habilidad y no estás agotado, puedes trepar vallas altas. <LINE> <LINE> "
        "<SIZE:large> ¡Tienes la habilidad necesaria! <LINE> <LINE> <SIZE:large> Pulsa <JOYPAD:ClimbThrough> o mantén "
        "pulsado <JOYPAD:Interact,28,28> para saltar la alambrada.",
    ("IG_UI.json", "IGUI_Tutorial1_Shotgun3Joypad"):
        "<SIZE:medium> ¡Aquí vienen! <LINE> <LINE> ¡Aparecerá un círculo rojo cuando apuntes a un objetivo! "
        "<RGB:1,1,1> <LINE> <LINE> <SIZE:large> Pulsa <JOYPAD:Attack,28,28> para disparar mientras apuntas manteniendo "
        "<JOYPAD:Aiming,28,28>.",
    ("IG_UI.json", "IGUI_Tutorial1_Shotgun4Joypad"):
        "<SIZE:medium> ¡Han muerto todos! ¡Qué tristeza! No importa: pronto volveréis a estar todos juntos. <LINE> "
        "<LINE> Todos los zombis del bosque han oído la escopeta y vienen a por ti. <LINE> <LINE> <SIZE:large> Pulsa "
        "<JOYPAD:ClimbThrough> o mantén pulsado <JOYPAD:Interact,28,28> para volver a saltar la alambrada y escapar.",
    ("IG_UI.json", "IGUI_PhotoOf"): "%1 de %2",
    ("IG_UI.json", "IGUI_LocketText"): "%1 con una foto de %2",
    ("RadioData.json", "RD_6de6e032-fde5-46a8-889e-6fccd0e58cc8"): "¡No estamos ni cerca!",
    ("RadioData.json", "RD_dfa64f59-9873-488e-ae19-102c874904fd"):
        "[img=music] Dos onzas de tabaco y la leche de una vaca... [img=music]",
    ("RadioData.json", "RD_57a7bfed-6a67-4cb1-894e-5b8f0122e4de"): "¡No estamos ni cerca!",
    ("Recorded_Media.json", "RM_6f916a36-ea46-4a0c-ad36-f40b7364de5f"):
        "ESTA NOCHE... BAJO LA LUNA... ¡VIVE EL GRAN SEÑOR SATÁN!",
    ("Recorded_Media.json", "RM_e6319dbe-407f-40e2-8c5f-108c29c3db8a"):
        "Solo quería los tomates, zorra. Eso es todo...",
    ("Riverside, KY.json", "description"):
        "<CENTRE> <SIZE:medium> RIVERSIDE <LINE> <LINE><LEFT> <SIZE:small> Un colorido pueblo que se aferra a las "
        "orillas del poderoso río Ohio: ¡explorar Riverside es una experiencia rica y diversa! Al oeste encontrarás "
        "las zonas más antiguas del pueblo, mientras que al este trabajan, descansan y se divierten los residentes más "
        "acomodados. <LINE> <LINE>Si estás pensando en alojarte con nosotros, ¿por qué no visitas el cercano West Maple "
        "Country Club? La máxima expresión del confort y la relajación: sus miembros disponen de un campo de golf de "
        "18 hoyos, pistas de tenis, piscina y fantásticos bares y salones. ¡Hazte socio hoy mismo!",
    ("Rosewood, KY.json", "description"):
        "<CENTRE> <SIZE:medium> ROSEWOOD <LINE> <LINE><LEFT> <SIZE:small> Una estancia corta aquí es agradable, pero "
        "¿una larga? Bueno, los internos de la infame Prisión Estatal de Rosewood te dirán que tiene bastante menos "
        "gracia. <LINE> <LINE>Rosewood, con una ubicación ideal y de fácil acceso, es un núcleo de servicios públicos "
        "y administrativos. El juzgado del condado, el parque de bomberos y las animadas dependencias policiales se "
        "han renovado hace poco, lo que convierte a este en uno de los pueblos más importantes de la zona. "
        "¡Ven a visitarlo hoy!",
    ("Tooltip.json", "Tooltip_food_Slice"): "Porción de %1",
    ("Tooltip.json", "Tooltip_Vehicle_WashWaterRequired2"): "%1 litro de agua en el inventario.",
    ("UI.json", "UI_coopscreen_delete_world_prompt"):
        "Estás a punto de eliminar la partida del servidor.\n¡Se eliminará el mundo entero!\n\nSe eliminarán estas "
        "carpetas:\n%1\n%2\n\n¿Eliminar el mundo?",
    ("UI.json", "UI_trait_overweightdesc"):
        "Menor velocidad al correr, poca resistencia y propensión a sufrir lesiones.",
    ("UI.json", "UI_optionscreen_keyAlreadyBinded"):
        "La tecla %1 ya está asignada a «%2».\nElige qué hacer con «%2»:",
    ("UI.json", "UI_mods_WorkshopRequiresSteam"):
        "Pulsa este botón para abrir el foro de mods de The Indie Stone en el navegador.<br>Hay más mods disponibles "
        "en Steam Workshop.",
    ("UI.json", "UI_trait_DisorganizedDesc"):
        "Menor capacidad de los contenedores.<br>Afecta a los contenedores del mundo y a las bolsas, pero no al "
        "inventario principal.",
    ("UI.json", "UI_trait_DexterousDesc"):
        "Transfiere objetos del inventario rápidamente.<br>Trepa por cuerdas más deprisa y tiene menos probabilidades "
        "de caer.<br>Se encara el arma con mayor rapidez.",
    ("UI.json", "UI_trait_AllThumbsDesc"):
        "Transfiere objetos del inventario lentamente. No puede fabricar nada mientras camina.<br>Trepa por cuerdas "
        "más despacio y tiene más probabilidades de caer.<br>Se encara el arma con mayor lentitud.",
    ("UI.json", "UI_trait_HemophobicDesc"):
        "Siente pánico al practicarse primeros auxilios.<br>No puede prestar primeros auxilios a otras personas.<br>"
        "Se estresa cuando está ensangrentado.",
    ("UI.json", "UI_servers_showLargeServer_warning"):
        "<H1> AVISO DE INTERÉS PÚBLICO <BR> <TEXT> <IMAGECENTRE:media/ui/spiffoWarning.png> <LINE><LINE> <CENTRE> "
        "<SIZE:large> Los servidores con más de 32 jugadores pueden sufrir problemas de carga del mapa y "
        "desincronización. Procede con cautela. <LINE><LINE> <CENTRE> <SIZE:large> Te pedimos comprensión mientras "
        "seguimos mejorando, corrigiendo y puliendo el juego. <LINE><LINE>",
    ("UI.json", "UI_ServerOption_ServerWelcomeMessage_tooltip"):
        "Primer mensaje de bienvenida visible en el panel de chat. Se mostrará justo después de que el jugador inicie "
        "sesión. Puedes usar colores RGB para cambiar el color del mensaje. También puedes usar < LINE>, sin el "
        "espacio, para crear líneas separadas en el texto. Uso: \\<RGB:1,0,0> ¡Este mensaje aparecerá en rojo!",
    ("UI.json", "UI_profdesc_lumberjack"):
        "Se mueve un poco más deprisa por bosques y arboledas.<br>Sufre menos fatiga muscular al talar árboles.",
    ("UI.json", "UI_trait_SmokerDesc"):
        "La infelicidad aumenta cuando no fuma tabaco.<br>El estrés y la infelicidad disminuyen después de fumar.",
    ("UI.json", "UI_TradingUIHelp"):
        "<CENTRE> <SIZE:medium> Usa esta interfaz para comerciar de forma segura con otras personas. <LINE> <LINE> "
        "<SIZE:small> <LEFT> Debes añadir objetos del inventario principal a la lista «Tu oferta». No se pueden añadir "
        "objetos de la mochila ni del suelo. <LINE> <LINE> Cuando termines tu oferta, marca la casilla «Sellar tu "
        "oferta». Cuando ambos jugadores la hayan marcado, cualquiera puede pulsar «Aceptar acuerdo» para transferir "
        "todos los objetos. <LINE> <LINE> Si la otra persona cambia su oferta después de que hayas sellado la tuya, "
        "tendrás que volver a sellarla.",
    ("UI.json", "UI_worldscreen_SavefileVehicle"):
        "Debido a la magnitud de los cambios necesarios para implementar los vehículos, las partidas de versiones "
        "anteriores no son compatibles. <LINE> <LINE> Para continuar esta partida, accede a la Build 38.30 anterior "
        "a los vehículos desde la pestaña de betas de Steam. <LINE> <LINE> Versión guardada del mundo: %1 Versión "
        "actual del mundo: %2",
    ("West Point, KY.json", "description"):
        "<CENTRE> <SIZE:medium> WEST POINT <LINE> <LINE><LEFT> <SIZE:small> Ya sea paseando por la plaza, mirando "
        "escaparates o charlando con sus amables habitantes, West Point es la auténtica pequeña ciudad estadounidense. "
        "<LINE> <LINE>No te dejes engañar por sus calles tranquilas, sus viviendas asequibles y sus extensas tierras "
        "de cultivo onduladas: es un núcleo administrativo del condado de Knox. Si el alcalde no está aprobando "
        "ordenanzas en el ayuntamiento, puede que lo encuentres en el famoso bar Twiggy's. Dure lo que dure tu "
        "estancia, West Point te recibirá con los brazos abiertos.",
}


def read_json(path: Path) -> dict[str, str]:
    with path.open("r", encoding="utf-8-sig") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"{path}: the JSON root must be an object")
    if not all(isinstance(key, str) and isinstance(value, str) for key, value in data.items()):
        raise ValueError(f"{path}: every translation entry must be a string")
    return data


def write_json(path: Path, data: dict[str, str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    rendered = json.dumps(data, ensure_ascii=False, indent=2)
    path.write_text(rendered + "\n", encoding="utf-8", newline="\n")


def repair_mojibake(value: str) -> str:
    """Repair repeated UTF-8-as-Windows-1252 corruption when it is unambiguous."""
    result = value
    for _ in range(3):
        if not MOJIBAKE_HINT.search(result):
            break
        try:
            candidate = result.encode("cp1252").decode("utf-8")
        except (UnicodeEncodeError, UnicodeDecodeError):
            break
        if candidate == result:
            break
        result = candidate
    return result


def tokens(value: str) -> list[str]:
    return TECH_TOKEN.findall(value)


def align_tokens(source: str, translated: str) -> tuple[str, bool]:
    """Replace translated technical tokens by the current source tokens.

    Alignment is safe only when both strings expose the same number of tokens.
    Their positions and surrounding translated prose remain untouched.
    """
    expected = tokens(source)
    actual = tokens(translated)
    if expected == actual:
        return translated, True
    if len(expected) != len(actual):
        return translated, False
    iterator = iter(expected)
    return TECH_TOKEN.sub(lambda _match: next(iterator), translated), True


def usable_translation(source: str, candidate: str | None) -> bool:
    if candidate is None:
        return False
    if source and not candidate:
        return False
    return len(tokens(source)) == len(tokens(candidate))


def choose_base_value(
    source: str,
    qwen: str | None,
    official: str | None,
    previous: str | None,
) -> tuple[str, str, bool]:
    candidates = (("qwen", qwen), ("official-42.20", official), ("previous", previous))
    for origin, candidate in candidates:
        if not usable_translation(source, candidate):
            continue
        repaired = repair_mojibake(candidate or "")
        aligned, ok = align_tokens(source, repaired)
        if ok:
            return aligned, origin, True

    for origin, candidate in candidates:
        if candidate is not None:
            return repair_mojibake(candidate), origin, False
    return source, "english-fallback", False


def build_base(
    game_en: Path,
    game_es: Path,
    qwen_es: Path,
    previous_es: Path,
    output_es: Path,
) -> dict[str, Any]:
    report: dict[str, Any] = {
        "files": {},
        "origins": Counter(),
        "token_mismatches": [],
        "english_fallbacks": [],
        "empty_values": [],
    }
    current_files = sorted(game_en.glob("*.json"), key=lambda path: path.name.casefold())

    for source_path in current_files:
        name = source_path.name
        source = read_json(source_path)
        official = read_json(game_es / name) if (game_es / name).exists() else {}
        qwen = read_json(qwen_es / name) if (qwen_es / name).exists() else {}
        previous = read_json(previous_es / name) if (previous_es / name).exists() else {}
        output: dict[str, str] = {}
        file_origins: Counter[str] = Counter()

        for key, source_value in source.items():
            manual = BASE_MANUAL_OVERRIDES.get((name, key))
            if manual is not None:
                value, token_ok = align_tokens(source_value, manual)
                origin = "manual-42.20"
            else:
                value, origin, token_ok = choose_base_value(
                    source_value,
                    qwen.get(key),
                    official.get(key),
                    previous.get(key),
                )
            output[key] = value
            file_origins[origin] += 1
            report["origins"][origin] += 1
            if not token_ok:
                report["token_mismatches"].append(
                    {"file": name, "key": key, "source": source_value, "translation": value}
                )
            if origin == "english-fallback":
                report["english_fallbacks"].append({"file": name, "key": key})
            if source_value and not value:
                report["empty_values"].append({"file": name, "key": key})

        write_json(output_es / name, output)
        report["files"][name] = {
            "keys": len(output),
            "origins": dict(sorted(file_origins.items())),
        }

    # Qwen also contains deliberate EclipseZ override files that are not part of
    # the vanilla language topology. Keep them as independent localization files.
    for extra_path in sorted(qwen_es.glob("*.json"), key=lambda path: path.name.casefold()):
        if extra_path.name in report["files"]:
            continue
        extra = {key: repair_mojibake(value) for key, value in read_json(extra_path).items()}
        write_json(output_es / extra_path.name, extra)
        report["files"][extra_path.name] = {"keys": len(extra), "origins": {"qwen-extra": len(extra)}}
        report["origins"]["qwen-extra"] += len(extra)

    for text_name in ("language.txt", "credits.txt"):
        source_path = qwen_es / text_name
        if not source_path.exists():
            source_path = previous_es / text_name
        if source_path.exists():
            content = repair_mojibake(source_path.read_text(encoding="utf-8-sig"))
            (output_es / text_name).write_text(content.rstrip() + "\n", encoding="utf-8", newline="\n")

    report["origins"] = dict(sorted(report["origins"].items()))
    return report


def build_mods(qwen_es: Path, previous_es: Path, output_es: Path) -> dict[str, Any]:
    report: dict[str, Any] = {"files": {}, "qwen_overrides": 0, "qwen_additions": 0}
    names = {
        path.name
        for folder in (qwen_es, previous_es)
        for path in folder.glob("*.json")
    }

    for name in sorted(names, key=str.casefold):
        previous = read_json(previous_es / name) if (previous_es / name).exists() else {}
        qwen = read_json(qwen_es / name) if (qwen_es / name).exists() else {}
        output = {key: repair_mojibake(value) for key, value in previous.items()}
        overrides = 0
        additions = 0
        for key, value in qwen.items():
            if key in output:
                overrides += 1
            else:
                additions += 1
            output[key] = repair_mojibake(value)
        write_json(output_es / name, output)
        report["files"][name] = {
            "keys": len(output),
            "qwen_overrides": overrides,
            "qwen_additions": additions,
        }
        report["qwen_overrides"] += overrides
        report["qwen_additions"] += additions

    return report


def validate_json_tree(folder: Path) -> dict[str, Any]:
    files = sorted(folder.glob("*.json"), key=lambda path: path.name.casefold())
    key_count = 0
    trailing_space_lines: list[dict[str, Any]] = []
    for path in files:
        key_count += len(read_json(path))
        for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
            if line.rstrip() != line:
                trailing_space_lines.append({"file": path.name, "line": line_number})
    return {
        "files": len(files),
        "keys": key_count,
        "trailing_space_lines": trailing_space_lines,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--game", type=Path, required=True)
    parser.add_argument("--qwen-base", type=Path, required=True)
    parser.add_argument("--qwen-mods", type=Path, required=True)
    parser.add_argument("--base-only", action="store_true")
    args = parser.parse_args()

    repo = args.repo.resolve()
    game_translate = args.game.resolve() / "media/lua/shared/Translate"
    base_target = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Idioma/42.20.0/media/lua/shared/Translate/ES"
    )
    mods_target = (
        repo
        / "ECZTraducciones/Contents/mods/ECZ_Mods/42.20.0/media/lua/shared/Translate/ES"
    )

    base_report = build_base(
        game_translate / "EN",
        game_translate / "ES",
        args.qwen_base.resolve(),
        base_target,
        base_target,
    )
    mods_report = (
        {"skipped": True}
        if args.base_only
        else build_mods(args.qwen_mods.resolve(), mods_target, mods_target)
    )
    report = {
        "target": "Project Zomboid 42.20.0",
        "policy": "Spanish (Spain), Qwen review over current 42.20 topology",
        "base": base_report,
        "mods": mods_report,
        "validation": {
            "base": validate_json_tree(base_target),
            "mods": validate_json_tree(mods_target),
        },
    }

    report_path = repo / "docs/localization-build-report.json"
    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(json.dumps(report["validation"], ensure_ascii=False, indent=2))
    print(f"Base token mismatches: {len(base_report['token_mismatches'])}")
    print(f"English fallbacks: {len(base_report['english_fallbacks'])}")
    print(f"Empty translated values: {len(base_report['empty_values'])}")
    print(f"Report: {report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
