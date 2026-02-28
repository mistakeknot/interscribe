# interscribe

Documentation quality toolkit for Claude Code projects.

## What this does

interscribe enforces a single rule: CLAUDE.md is for Claude Code configuration only (plugins, hooks, tool preferences, permissions), and everything else — architecture, workflows, conventions, troubleshooting — belongs in AGENTS.md. Project knowledge that leaks into CLAUDE.md wastes context tokens on every session start and fragments the information agents need to do their jobs.

The plugin has three modes. **Audit** analyzes your docs and reports a health score: boundary violations, token budgets, duplicate instructions, stale references. **Refactor** fixes what it finds automatically — moves project knowledge from CLAUDE.md to AGENTS.md, extracts oversized AGENTS.md sections into docs/ reference files with backlinks, removes duplicates, and cleans up dead links. **Consolidate** works across your full doc hierarchy (global → project → subproject) to deduplicate instructions that appear at multiple levels.

Refactoring is fully automatic. All changes are reviewable via `git diff`. The philosophy is: trust the tool, review the output.

## Installation

First, add the [interagency marketplace](https://github.com/mistakeknot/interagency-marketplace) (one-time setup):

```bash
/plugin marketplace add mistakeknot/interagency-marketplace
```

Then install the plugin:

```bash
/plugin install interscribe
```

## Usage

Audit your project's documentation health:

```
/interscribe audit
```

Automatically restructure docs for progressive disclosure:

```
/interscribe refactor
```

Deduplicate across your doc hierarchy:

```
/interscribe consolidate
```

Target a specific path:

```
/interscribe audit apps/autarch
```

## Architecture

```
skills/interscribe/   Main skill — audit, refactor, consolidate modes
scripts/              audit-docs.sh (line/token metrics), find-duplicates.sh (heading overlap)
```

## Design decisions

- Skill-only plugin — no MCP server, no hooks, no compiled binaries
- Fully automatic refactor mode — no approval prompts, reviewable via git diff
- Shell scripts handle deterministic metrics; the LLM handles semantic analysis
- Establishes the `docs/canon/` convention for foundational project docs (PHILOSOPHY.md, naming, doc standards)

## License

MIT
