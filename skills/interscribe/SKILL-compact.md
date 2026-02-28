# Interscribe (compact)

Documentation quality toolkit -- audit, refactor, consolidate. Enforces CLAUDE.md/AGENTS.md boundary.

## When to Invoke

Use when docs feel bloated, CLAUDE.md contains project knowledge, after major project changes, or to deduplicate across doc hierarchies.

## The Boundary Rule

- **CLAUDE.md** = Claude Code config ONLY (plugins, hooks, tool prefs, permissions)
- **AGENTS.md** = Everything else (architecture, workflows, conventions, troubleshooting)
- **docs/** = Deep reference files linked from AGENTS.md sections
- Any project knowledge in CLAUDE.md is a boundary violation

## Modes

### Audit (default)
1. Discover all CLAUDE.md and AGENTS.md files in target path
2. Boundary check -- classify each CLAUDE.md section as config, project knowledge (violation), or pointer
3. Token budget -- CLAUDE.md target 30-60 lines; flag AGENTS.md sections >100 lines
4. Duplication check across global/project/subproject docs
5. Staleness check -- dead links, outdated versions, removed tools
6. Report with health score (A-F)

### Refactor (fully automatic, review via git diff)
1. Run full audit first
2. Move boundary violations: CLAUDE.md -> AGENTS.md (add pointer back)
3. Extract AGENTS.md sections >100 lines -> `docs/[topic].md` with summary + link
4. Deduplicate (keep canonical copy, replace others with pointers)
5. Fix or remove stale references

### Consolidate (multi-level hierarchy)
1. Map doc loading tree (global -> project -> subproject)
2. Identical instructions: keep at highest level, remove lower
3. Specialized: keep both; Contradictory: flag for manual resolution

## Health Score

| Grade | Criteria |
|-------|----------|
| A | 0 violations, CLAUDE.md <60 lines, 0 dupes, 0 stale |
| B | 1-2 violations OR 60-80 lines OR 1-2 dupes |
| C | 3-5 violations OR 80-120 lines OR 3-5 dupes |
| D | 6+ violations OR >120 lines OR 6+ dupes |
| F | AGENTS.md missing OR CLAUDE.md >50% project knowledge |

## Line Budgets

| File | Target | Cap | Action if over |
|------|--------|-----|----------------|
| CLAUDE.md | 30-60 | 80 | Move to AGENTS.md |
| AGENTS.md section | 50-80 | 100 | Extract to docs/ |
| MEMORY.md | 100-150 | 200 | Synthesize to AGENTS.md |

---
*For full report templates, docs/canon convention, and consolidation details, read SKILL.md.*
