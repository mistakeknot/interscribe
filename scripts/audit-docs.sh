#!/usr/bin/env bash
# audit-docs.sh — Token counting and line metrics for CLAUDE.md/AGENTS.md files
# Usage: audit-docs.sh [project-root]

set -euo pipefail

ROOT="${1:-.}"

echo "## Doc Metrics"
echo ""

# Find all CLAUDE.md and AGENTS.md files
find "$ROOT" -name "CLAUDE.md" -o -name "AGENTS.md" | \
  grep -v node_modules | grep -v .git | sort | while read -r f; do
    rel="${f#$ROOT/}"
    lines=$(wc -l < "$f")
    # Rough token estimate: ~0.75 tokens per word
    words=$(wc -w < "$f")
    tokens=$((words * 3 / 4))

    type="AGENTS.md"
    flag=""
    if [[ "$f" == *CLAUDE.md ]]; then
      type="CLAUDE.md"
      if [ "$lines" -gt 80 ]; then
        flag=" ⚠ OVER BUDGET (>80 lines)"
      elif [ "$lines" -gt 60 ]; then
        flag=" △ APPROACHING BUDGET (>60 lines)"
      fi
    fi

    printf "%-50s %4d lines  ~%5d tokens%s\n" "$rel" "$lines" "$tokens" "$flag"
done

echo ""

# Check for docs/canon/ existence
if [ -d "$ROOT/docs/canon" ]; then
  echo "docs/canon/: present"
  ls "$ROOT/docs/canon/" 2>/dev/null | sed 's/^/  /'
else
  echo "docs/canon/: missing"
fi
