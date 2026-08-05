#!/usr/bin/env python3
"""Valida logs reales de Project Zomboid contra la configuración del modpack."""
from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

FATAL_PATTERNS = {
    "REQUIRED_MOD_NOT_FOUND": re.compile(r"required mod [\"']?([^\"'\r\n]+)[\"']? not found", re.I),
    "WORLD_DICTIONARY": re.compile(r"WorldDictionaryException|Missing dictionary script", re.I),
    "TRANSLATION_FORMAT": re.compile(r"IllegalFormatConversionException|d != java\.lang\.String", re.I),
    "CHECKSUM": re.compile(r"checksum(?:s)? (?:do not match|mismatch)|Lua/script checksums do not match", re.I),
    "VERSION_MISMATCH": re.compile(r"client version mismatch|version mismatch", re.I),
    "FATAL_JAVA": re.compile(r"Exception in thread|java\.lang\.(?:NullPointerException|IllegalStateException)", re.I),
}

WARN_PATTERNS = {
    "LUA_ERROR": re.compile(r"\bERROR\b.*\bLua\b|Lua\s*error", re.I),
    "ANIM_STATE": re.compile(r"AnimState not found|turningmovement180|turning180", re.I),
    "MISSING_FILE": re.compile(r"NoSuchFileException", re.I),
    "DISCONNECT_BEFORE_PLAYER": re.compile(r"disconnection-notification|receive-disconnect", re.I),
}

@dataclass
class Finding:
    severity: str
    code: str
    message: str
    source: str
    line: int | None = None
    excerpt: str | None = None
    details: dict[str, Any] | None = None


def args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument("--server", action="append", type=Path, default=[])
    p.add_argument("--client", action="append", type=Path, default=[])
    p.add_argument("--config", type=Path, default=Path(__file__).with_name("configuracion_servidor_actual.json"))
    p.add_argument("--output", required=True, type=Path)
    p.add_argument("--self-test", action="store_true")
    return p.parse_args()


def read(path: Path) -> str:
    raw = path.read_bytes()
    for enc in ("utf-8-sig", "utf-16", "cp1252"):
        try:
            return raw.decode(enc)
        except UnicodeError:
            pass
    return raw.decode("utf-8", errors="replace")


def scan_patterns(text: str, source: str, findings: list[Finding]) -> None:
    lines = text.splitlines()
    for line_number, line in enumerate(lines, 1):
        for code, pattern in FATAL_PATTERNS.items():
            match = pattern.search(line)
            if match:
                findings.append(Finding("error", code, f"Patrón fatal detectado: {code}", source, line_number, line[:500]))
        for code, pattern in WARN_PATTERNS.items():
            if pattern.search(line):
                findings.append(Finding("warning", code, f"Patrón de advertencia detectado: {code}", source, line_number, line[:500]))


def loading_positions(text: str, mods: list[str]) -> dict[str, int]:
    result: dict[str, int] = {}
    for mod in mods:
        patterns = [
            re.compile(rf"\bloading\s+{re.escape(mod)}\b", re.I),
            re.compile(rf"\bmod\s+[\"']?{re.escape(mod)}[\"']?\s+loaded\b", re.I),
        ]
        positions = [m.start() for pattern in patterns for m in pattern.finditer(text)]
        if positions:
            result[mod] = min(positions)
    return result


def validate_server(path: Path, config: dict[str, Any], findings: list[Finding]) -> dict[str, Any]:
    text = read(path)
    source = path.as_posix()
    scan_patterns(text, source, findings)
    internal = [str(x) for x in config.get("mods", []) if str(x) not in set(map(str, config.get("external_mods", [])))]
    positions = loading_positions(text, internal)
    missing = [mod for mod in internal if mod not in positions]
    if missing:
        findings.append(Finding("error", "SERVER_MODS_NOT_LOADED", f"No se encontraron líneas de carga para {len(missing)} mods internos.", source, details={"missing": missing}))
    started = bool(re.search(r"SERVER STARTED|server started|StartServer", text, re.I))
    if not started:
        findings.append(Finding("warning", "SERVER_STARTED_NOT_CONFIRMED", "El fragmento no confirma que el servidor alcanzase el estado iniciado.", source))
    return {"source": source, "mods_loaded": len(positions), "mods_missing": missing, "server_started": started}


def validate_client(path: Path, config: dict[str, Any], findings: list[Finding]) -> dict[str, Any]:
    text = read(path)
    source = path.as_posix()
    scan_patterns(text, source, findings)
    positions = loading_positions(text, ["ECZ_Mods", "ECZ_Idioma", "ECZChat"])
    game_start = re.search(r"Iniciando el juego|Starting game", text, re.I)
    idioma_ok = "ECZ_Idioma" in positions and (game_start is None or positions["ECZ_Idioma"] < game_start.start())
    if not idioma_ok:
        findings.append(Finding("error", "CLIENT_LANGUAGE_NOT_GLOBAL", "ECZ_Idioma no aparece cargado antes del inicio del juego/menú principal.", source, details={"positions": positions, "game_start": game_start.start() if game_start else None}))
    connected = bool(re.search(r"player-connect|CreatePlayerPacket|player fully connected|Connected to server", text, re.I))
    return {"source": source, "positions": positions, "ecz_idioma_before_game": idioma_ok, "player_connection_confirmed": connected}


def dedupe(findings: list[Finding]) -> list[Finding]:
    seen = set()
    out = []
    for f in findings:
        key = (f.severity, f.code, f.source, f.line, f.excerpt)
        if key not in seen:
            seen.add(key)
            out.append(f)
    return out


def markdown(result: dict[str, Any]) -> str:
    out = [
        "# Validación de logs de runtime",
        "",
        f"- Errores: **{result['errors']}**",
        f"- Advertencias: **{result['warnings']}**",
        "",
        "## Servidor",
        "",
    ]
    if result["server"]:
        for item in result["server"]:
            out.append(f"- `{item['source']}`: {item['mods_loaded']} mods localizados; servidor iniciado={'sí' if item['server_started'] else 'no'}.")
    else:
        out.append("No se proporcionaron logs de servidor.")
    out.extend(["", "## Clientes", ""])
    if result["client"]:
        for item in result["client"]:
            out.append(f"- `{item['source']}`: ECZ_Idioma global={'sí' if item['ecz_idioma_before_game'] else 'no'}; conexión completa={'sí' if item['player_connection_confirmed'] else 'no confirmada'}.")
    else:
        out.append("No se proporcionaron logs de cliente.")
    out.extend(["", "## Hallazgos", ""])
    if not result["findings"]:
        out.append("No se detectaron patrones problemáticos.")
    for item in result["findings"]:
        icon = "❌" if item["severity"] == "error" else "⚠️"
        out.extend([f"### {icon} `{item['code']}`", "", item["message"], "", f"Fuente: `{item['source']}`"])
        if item.get("line"):
            out.append(f"Línea: {item['line']}")
        if item.get("excerpt"):
            out.extend(["", "```text", item["excerpt"], "```"])
        if item.get("details"):
            out.extend(["", "```json", json.dumps(item["details"], ensure_ascii=False, indent=2), "```"])
        out.append("")
    return "\n".join(out)


def self_test() -> int:
    good = "loading ECZ_Mods\nloading ECZ_Idioma\nIniciando el juego\nConnected to server"
    bad = "Iniciando el juego\nIllegalFormatConversionException: d != java.lang.String"
    assert loading_positions(good, ["ECZ_Idioma"])["ECZ_Idioma"] < good.index("Iniciando")
    assert FATAL_PATTERNS["TRANSLATION_FORMAT"].search(bad)
    print("Self-test correcto")
    return 0


def main() -> int:
    a = args()
    if a.self_test:
        return self_test()
    config = json.loads(a.config.read_text(encoding="utf-8-sig"))
    findings: list[Finding] = []
    server = [validate_server(path, config, findings) for path in a.server]
    client = [validate_client(path, config, findings) for path in a.client]
    findings = dedupe(findings)
    result = {
        "errors": sum(f.severity == "error" for f in findings),
        "warnings": sum(f.severity == "warning" for f in findings),
        "server": server,
        "client": client,
        "findings": [asdict(f) for f in findings],
    }
    a.output.parent.mkdir(parents=True, exist_ok=True)
    a.output.with_suffix(".json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    a.output.with_suffix(".md").write_text(markdown(result), encoding="utf-8")
    print(f"Runtime: {result['errors']} errores, {result['warnings']} advertencias")
    return 1 if result["errors"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
