#!/usr/bin/env bash
# find-duplicates.sh — Detect duplicate sections across CLAUDE.md/AGENTS.md hierarchy
# Usage: find-duplicates.sh [project-root]
#
# Extracts H2 headings from all doc files and reports headings that appear
# in multiple files (potential duplicates). Semantic duplication detection
# is handled by the LLM skill; this script catches structural overlap.

set -euo pipefail

ROOT="${1:-.}"

echo "## Heading Overlap Detection"
echo ""

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

# Extract H2 headings with file locations
while IFS= read -r f; do
    rel="${f#$ROOT/}"
    while IFS=: read -r line heading; do
      normalized=$(echo "$heading" | sed 's/^## //' | tr '[:upper:]' '[:lower:]' | sed 's/[[:space:]]*$//')
      printf "%s\t%s:%s\n" "$normalized" "$rel" "$line"
    done < <(grep -n "^## " "$f" 2>/dev/null || true)
done < <(find "$ROOT" \( -name "CLAUDE.md" -o -name "AGENTS.md" \) \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" | sort) > "$tmpfile"

# Find headings that appear in multiple files
if [ -s "$tmpfile" ]; then
  awk -F'\t' '{print $1}' "$tmpfile" | sort | uniq -c | sort -rn | while read -r count heading; do
    if [ "$count" -gt 1 ]; then
      echo "### \"$heading\" (${count}x)"
      grep -F "$heading" "$tmpfile" | awk -F'\t' '{print "  - " $2}'
      echo ""
    fi
  done
else
  echo "No headings found."
fi
