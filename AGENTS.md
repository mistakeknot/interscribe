# AGENTS.md

## Canonical References
1. [`PHILOSOPHY.md`](../../PHILOSOPHY.md) — direction for ideation and planning decisions.
2. `CLAUDE.md` — Claude Code settings only.

> Cross-AI documentation for interscribe. Works with Claude Code, Codex CLI, and other AI coding tools.

## Overview

**interscribe** is a documentation quality toolkit that enforces the CLAUDE.md/AGENTS.md boundary, applies progressive disclosure to project docs, and deduplicates instructions across the doc loading hierarchy.

**Problem:** CLAUDE.md files accumulate project knowledge that belongs in AGENTS.md. AGENTS.md sections grow without bounds. The same instruction appears at multiple hierarchy levels. No tool restructures docs after they're created.

**Solution:** Three modes — audit (report health), refactor (restructure automatically), consolidate (deduplicate across hierarchy).

**Plugin Type:** Claude Code skill plugin
**Current Version:** 0.1.0

## The Boundary Rule

The single convention that drives all of interscribe's behavior:

| File | Contains | Does NOT contain |
|------|----------|-----------------|
| CLAUDE.md | Plugin settings, hook config, tool preferences, permissions, Claude-specific behavioral overrides | Architecture, workflows, conventions, git workflow, build instructions, troubleshooting |
| AGENTS.md | Architecture, workflows, conventions, standards, troubleshooting, build instructions | Plugin/hook config, Claude-specific tool preferences |
| docs/ | Deep reference content linked from AGENTS.md sections | Top-level project overview (that belongs in AGENTS.md) |

## Repository Structure

```
interverse/interscribe/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── skills/
│   └── interscribe/
│       └── SKILL.md          # Main skill (3 modes: audit, refactor, consolidate)
├── scripts/
│   ├── audit-docs.sh         # Token counting, line metrics
│   └── find-duplicates.sh    # Cross-file duplication detection
├── CLAUDE.md                 # Claude Code settings only
├── AGENTS.md                 # This file
└── README.md                 # User-facing docs
```

## Modes

### Audit
Non-destructive analysis. Reports boundary violations, token budgets, duplicates, stale references. Outputs a health score (A-F).

### Refactor
Fully automatic restructuring. Moves project knowledge from CLAUDE.md → AGENTS.md, extracts oversized AGENTS.md sections → docs/, removes duplicates, fixes stale references. All changes reviewable via `git diff`.

### Consolidate
Cross-hierarchy deduplication. Maps the full doc loading tree (global → project → subproject), finds duplicate instructions, keeps them at the highest common ancestor level.

## Integration Points

| Tool | Relationship |
|------|-------------|
| interdoc | interdoc generates AGENTS.md from code. interscribe restructures it for optimal consumption. Run interdoc first, interscribe after. |
| interwatch | interwatch detects content drift. Could trigger interscribe:audit when structural drift detected. |
| /review-doc | review-doc scores content quality. interscribe scores structural quality. Complementary. |
| /distill | distill applies progressive disclosure to skills. interscribe applies it to project docs. Same pattern, different targets. |
| intermem:synthesize | intermem promotes memory → docs. interscribe restructures the result. |

## docs/canon/ Convention

Foundational docs that define project identity and standards. Applies to all repos:

```
docs/canon/
├── PHILOSOPHY.md      # Design bets and tradeoffs
├── doc-structure.md   # Pointer-doc standard, token budgets, boundary rules
└── naming.md          # Naming conventions
```

Operational docs (CLAUDE.md, AGENTS.md) stay at project root — they're auto-loaded by tools.

## Development

This is a skill-only plugin. No compiled binaries, no MCP server. The skill is the product.

Shell scripts in `scripts/` provide deterministic metrics (line counts, link checking) that the skill invokes. The LLM handles semantic analysis (boundary classification, duplication detection, restructuring decisions).

## Philosophy Alignment

Directly serves "Documentation is agent memory" (PHILOSOPHY.md §Receipts Close Loops). Better-structured docs → better agent context → better decisions → faster flywheel. The boundary rule is "composition over capability" applied to documentation: small, scoped docs with explicit interfaces (pointers) beat monolithic ones.
