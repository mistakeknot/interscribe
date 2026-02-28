# interscribe Philosophy

## Purpose
Documentation quality toolkit — enforces CLAUDE.md/AGENTS.md boundaries, applies progressive disclosure, and deduplicates across the doc loading hierarchy. 1 skill, 2 helper scripts. General-purpose plugin for any Claude Code project.

## North Star
Maximize agent context quality: every token loaded at session start should be actionable, non-redundant, and in the right file.

## Working Priorities
- Boundary correctness (CLAUDE.md = tool config, AGENTS.md = project knowledge)
- Progressive disclosure (thin entry points, deep reference docs)
- Cross-hierarchy deduplication

## Brainstorming Doctrine
1. Start from outcomes and failure modes, not implementation details.
2. Generate at least three options: conservative, balanced, and aggressive.
3. Explicitly call out assumptions, unknowns, and dependency risk across modules.
4. Prefer ideas that improve clarity, reversibility, and operational visibility.

## Planning Doctrine
1. Convert selected direction into small, testable, reversible slices.
2. Define acceptance criteria, verification steps, and rollback path for each slice.
3. Sequence dependencies explicitly and keep integration contracts narrow.
4. Reserve optimization work until correctness and reliability are proven.

## Decision Filters
- Does this reduce wasted context tokens for agents?
- Does this make the boundary between tool config and project knowledge clearer?
- Is the restructuring safe to apply automatically (reviewable via git diff)?
- Can we revert safely if the restructuring was wrong?

## Evidence Base
- Brainstorms analyzed: 1
- Plans analyzed: 0
- Source confidence: artifact-backed (1 brainstorm(s), 0 plan(s))
- Representative artifacts:
  - `docs/brainstorms/2026-02-28-interscribe-doc-quality-brainstorm.md` (in Demarch root)
