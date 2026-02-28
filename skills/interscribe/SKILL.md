---
name: interscribe
description: Documentation quality toolkit — audit doc health, refactor for progressive disclosure, consolidate duplicates. Enforces CLAUDE.md (Claude Code config only) / AGENTS.md (everything else) boundary. Use when docs feel bloated, when CLAUDE.md has project knowledge, or after major project changes.
argument-hint: "[audit|refactor|consolidate] [path]"
allowed-tools: Read, Edit, Write, Bash(wc *), Bash(grep *), Bash(find *), Glob, Grep
---

# Interscribe

Documentation quality toolkit with three modes: **audit**, **refactor**, **consolidate**.

## The Boundary Rule

This is the single most important convention interscribe enforces:

```
CLAUDE.md    → Claude Code ONLY: plugins, hooks, tool preferences, permissions, Claude-specific settings
AGENTS.md    → Everything else: architecture, workflows, conventions, troubleshooting, standards
  → docs/    → Deep reference files linked from AGENTS.md sections
```

**Any project knowledge in CLAUDE.md is a boundary violation.** Project knowledge includes: git workflow, architecture, build instructions, coding conventions, server setup, debugging guides, workflow patterns.

**What belongs in CLAUDE.md:** Plugin versions and settings, hook configuration, tool preferences (Read vs cat), permission notes, Claude-specific behavioral overrides, links to AGENTS.md.

## Input

<interscribe_input> #$ARGUMENTS </interscribe_input>

Parse the input to determine mode and target:
- `audit` / `audit [path]` → Audit mode
- `refactor` / `refactor [path]` → Refactor mode
- `consolidate` / `consolidate [path]` → Consolidate mode
- No argument → Audit mode (default)
- Just a path → Audit that path

## Mode 1: Audit

Analyze documentation health and report findings. No changes made.

### Step 1: Discover Docs

Find all CLAUDE.md and AGENTS.md files in the target path (default: project root). Also find `docs/canon/doc-structure.md` if it exists.

### Step 2: Boundary Check

For each CLAUDE.md, classify every section:
- **Claude Code config** — belongs here (plugins, hooks, tool prefs, permissions)
- **Project knowledge** — boundary violation (architecture, workflows, conventions, git workflow, build, troubleshooting)
- **Pointer** — links to AGENTS.md sections (good)

Report violations with the section heading and line count.

### Step 3: Token Budget

Count lines in each doc. Report:
- CLAUDE.md line count (target: 30-60 lines)
- AGENTS.md line count (no hard cap, but flag sections >100 lines as candidates for extraction to docs/)
- Total context load at session start (sum of auto-loaded docs in the hierarchy)

### Step 4: Duplication Check

Look for semantically identical instructions across:
- Global CLAUDE.md ↔ project CLAUDE.md
- CLAUDE.md ↔ AGENTS.md in the same project
- Parent AGENTS.md ↔ subproject AGENTS.md

Report duplicates with locations.

### Step 5: Staleness Check

Scan for:
- References to files that don't exist
- References to directories that don't exist
- Version numbers that don't match actual versions
- Instructions about tools/features that are no longer present

### Step 6: Report

Output a summary:

```
## Interscribe Audit Report

**Target:** [path]
**CLAUDE.md:** [N] lines ([M] boundary violations)
**AGENTS.md:** [N] lines ([M] sections > 100 lines)
**Duplicates:** [N] found
**Stale references:** [N] found

### Boundary Violations
[list with section names and line counts]

### Oversized Sections
[AGENTS.md sections that should be extracted to docs/]

### Duplicates
[instruction, locations]

### Stale References
[reference, file, line]

**Health Score:** [A-F] based on violation count and severity
```

## Mode 2: Refactor

Restructure docs for progressive disclosure. **Fully automatic** — applies all changes. Review via `git diff`.

### Step 1: Audit First

Run the full audit (Mode 1) to understand current state.

### Step 2: Boundary Enforcement

For each boundary violation in CLAUDE.md:
1. Find or create the appropriate section in AGENTS.md
2. Move the content from CLAUDE.md → AGENTS.md
3. If the content was a standalone topic, add a pointer in CLAUDE.md: `See [Topic](AGENTS.md#section)`
4. If the content was inline in a larger section, just remove it from CLAUDE.md

### Step 3: AGENTS.md Extraction

For AGENTS.md sections exceeding 100 lines:
1. Create a reference file at `docs/[topic].md` with the full content
2. Replace the AGENTS.md section with a summary (3-5 lines) + pointer link
3. Preserve the section heading in AGENTS.md for discoverability

### Step 4: Deduplication

For each duplicate found:
1. Determine the canonical location (highest common ancestor in the hierarchy)
2. Keep the canonical copy
3. Replace other copies with a pointer or remove entirely
4. If there's a contradiction, keep both and add a `<!-- CONTRADICTION: also stated differently in [file] -->` comment

### Step 5: Stale Cleanup

Remove or fix stale references:
- Dead file links → remove the link (keep the instruction if still valid)
- Dead directory references → update or remove
- Outdated version numbers → update if determinable, flag if not

### Step 6: Summary

Report what was changed:

```
## Interscribe Refactor Summary

**CLAUDE.md:** [before] → [after] lines
**AGENTS.md:** [before] → [after] lines
**Files created:** [list of new docs/ reference files]
**Duplicates removed:** [count]
**Stale references fixed:** [count]

Review changes: `git diff`
```

## Mode 3: Consolidate

Deduplicate across a multi-level doc hierarchy. Use when you have global + project + subproject docs.

### Step 1: Map Hierarchy

Build the doc loading tree:
```
~/.claude/CLAUDE.md (global)
  → project/CLAUDE.md
    → project/subdir/CLAUDE.md
~/.codex/AGENTS.md (global, if exists)
  → project/AGENTS.md
    → project/subdir/AGENTS.md
```

### Step 2: Cross-Level Duplication

For each instruction that appears at multiple levels:
- **Identical** → keep at highest level, remove from lower levels
- **Specialized** (lower level adds project-specific detail) → keep both, verify no contradiction
- **Contradictory** → flag for manual resolution, do not auto-fix contradictions across hierarchy levels

### Step 3: Apply and Report

Apply deduplication changes. Report what was consolidated and any contradictions flagged.

## Health Score Rubric

| Grade | Criteria |
|-------|----------|
| **A** | 0 boundary violations, CLAUDE.md <60 lines, 0 duplicates, 0 stale refs |
| **B** | 1-2 boundary violations OR CLAUDE.md 60-80 lines OR 1-2 duplicates |
| **C** | 3-5 boundary violations OR CLAUDE.md 80-120 lines OR 3-5 duplicates |
| **D** | 6+ boundary violations OR CLAUDE.md >120 lines OR 6+ duplicates |
| **F** | AGENTS.md missing entirely OR CLAUDE.md contains >50% project knowledge |

## Conventions

### docs/canon/

Foundational project docs that define identity and standards:

```
docs/canon/
├── PHILOSOPHY.md      # Design bets and tradeoffs
├── doc-structure.md   # This standard (pointer-doc convention, budgets, boundaries)
└── naming.md          # Naming conventions
```

Root keeps: CLAUDE.md, AGENTS.md (operational, auto-loaded by tools).

### Line Budgets

| File | Target | Hard Cap | Action |
|------|--------|----------|--------|
| CLAUDE.md | 30-60 | 80 | Move project knowledge → AGENTS.md |
| AGENTS.md section | 50-80 | 100 | Extract → docs/ reference file |
| MEMORY.md | 100-150 | 200 | Promote stable facts → AGENTS.md via intermem:synthesize |
