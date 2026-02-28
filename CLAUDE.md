# interscribe

> See `AGENTS.md` for full development guide.

## Overview

Documentation quality toolkit — 1 skill (audit, refactor, consolidate modes), 2 helper scripts. Enforces the CLAUDE.md/AGENTS.md boundary rule: CLAUDE.md is Claude Code config only, everything else lives in AGENTS.md with pointers to docs/.

## Quick Commands

```bash
# Test locally
claude --plugin-dir /root/projects/Interverse/plugins/interscribe

# Validate structure
ls skills/*/SKILL.md | wc -l          # Should be 1
ls scripts/*.sh | wc -l               # Should be 3
python3 -c "import json; json.load(open('.claude-plugin/plugin.json'))"  # Manifest check
```

## Design Decisions (Do Not Re-Ask)

- Namespace: `interscribe:` (standalone plugin, not a Clavain companion)
- Skill-only plugin — no compiled MCP server, no hooks
- Fully automatic refactor mode by default — trust the tool, review via git diff
- The boundary rule: CLAUDE.md = Claude Code config, AGENTS.md = everything else
- General-purpose from day 1 — not Demarch-specific
- `docs/canon/` convention for foundational docs (PHILOSOPHY.md, standards) — operational docs stay at root
