#!/usr/bin/env bash
#
# Regenerate GEMINI.md from the canonical SKILL.md.
#
# SKILL.md (used by Claude Code + Codex Agent Skills) is the single source of
# truth. Gemini CLI consumes a plain-markdown context file with no YAML
# frontmatter, so this strips the frontmatter block and writes the body to
# GEMINI.md. Run it after editing SKILL.md; CI/`--check` fails if they drift.
#
# Usage:
#   scripts/sync-gemini.sh           # regenerate GEMINI.md
#   scripts/sync-gemini.sh --check   # verify GEMINI.md is up to date (no write)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/skills/use-appclaw-agent-cli/SKILL.md"
DEST="$ROOT/GEMINI.md"

if [[ ! -f "$SRC" ]]; then
  echo "error: source not found: $SRC" >&2
  exit 1
fi

# Strip the leading YAML frontmatter (--- ... ---), then drop leading blank
# lines so the body starts at the first heading.
generated="$(
  awk '
    NR==1 && $0=="---" { infm=1; next }
    infm && $0=="---"  { infm=0; body=1; next }
    infm               { next }
    body               { print }
  ' "$SRC" | sed -e '/./,$!d'
)"

if [[ "${1:-}" == "--check" ]]; then
  if [[ "$generated" == "$(cat "$DEST" 2>/dev/null)" ]]; then
    echo "GEMINI.md is up to date."
    exit 0
  fi
  echo "error: GEMINI.md is out of date — run scripts/sync-gemini.sh" >&2
  exit 1
fi

printf '%s\n' "$generated" > "$DEST"
echo "Wrote $DEST from $SRC"
