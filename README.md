# Claude Code Mastery Skill

The definitive Claude Code setup, configuration, and mastery skill for Windows/PowerShell. Built from official documentation, community best practices, and real-world validated configurations.

## What This Skill Does

Helps you set up, optimize, and master Claude Code across seven pillars:

1. **CLAUDE.md Engineering** — hierarchy, golden rules, templates
2. **Context Management** — token budgeting, compaction, subagents
3. **MCP Server Stack** — tiered recommendations, project configs
4. **Settings/Permissions/Hooks** — production-ready templates
5. **Agent Teams** — orchestration, cost management, patterns
6. **Skills & Plugins** — ecosystem, community plugins
7. **CI/CD & Automation** — headless mode, GitHub Actions, worktrees

## Self-Updating Knowledge Base

The skill includes a built-in research mechanism. Say "update knowledge" or "research latest" and it will:

- Search official docs and community sources for updates
- Append new findings to `references/knowledge-base.md` (dated, never overwritten)
- Follow a systematic checklist in `scripts/research-checklist.md`
- Track changes in `references/changelog.md`

## Installation

### Global (all projects)

Copy this folder to your Claude Code skills directory:

```powershell
Copy-Item -Recurse .\claude-code-mastery\ "$env:USERPROFILE\.claude\skills\claude-code-mastery\"
```

### Project-level

Copy to your project's `.claude/skills/` directory:

```powershell
Copy-Item -Recurse .\claude-code-mastery\ .\.claude\skills\claude-code-mastery\
```

### Usage

- Invoke directly: `/claude-code-mastery`
- Or let Claude auto-detect it from context (e.g., "set up Claude Code for my project")

## File Structure

```
claude-code-mastery/
├── SKILL.md                              # Core skill instructions
├── references/
│   ├── knowledge-base.md                 # Living knowledge (append-only, dated)
│   ├── research-sources.md               # Where to look for updates
│   ├── claude-md-templates.md            # CLAUDE.md templates (TS, Python, C#, monorepo)
│   ├── settings-templates.md             # settings.json, hooks, MCP, agent configs
│   ├── troubleshooting.md                # Common problems + proven fixes
│   └── changelog.md                      # Skill version history
├── scripts/
│   └── research-checklist.md             # Systematic update protocol
├── agents/                               # Custom agent definitions (future)
└── evals/                                # Eval test cases (future)
```

## License

MIT
