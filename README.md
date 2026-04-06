# Claude Code Mastery

The definitive Claude Code setup, configuration, and mastery package. Battle-tested rules, agents, hooks, and 17 curated skills — one install for a complete development environment.

## What This Package Does

Helps you set up, optimize, and master Claude Code across seven pillars:

1. **CLAUDE.md Engineering** — hierarchy, golden rules, templates
2. **Context Management** — token budgeting, compaction, context-mode plugin
3. **MCP Server Stack** — gateway architecture, tiered recommendations
4. **Settings/Permissions/Hooks** — production-ready templates, lifecycle hooks
5. **Agents & Subagents** — orchestration, wave execution, agent teams
6. **Skills & Plugins** — ecosystem, 17 curated skills, plugin stack
7. **CI/CD & Automation** — headless mode, GitHub Actions, worktrees

## Installation

### APM (recommended)

```bash
# Install APM first (if you haven't)
# Windows: irm https://aka.ms/apm-windows | iex
# macOS/Linux: curl -sSL https://aka.ms/apm-unix | sh

# Install the full package (skill + 17 curated skills + rules + agents + hooks)
apm install MCKRUZ/claude-code-mastery
```

### Git Clone (skill only)

```bash
git clone https://github.com/MCKRUZ/claude-code-mastery ~/.claude/skills/claude-code-mastery
```

### npx skills

```bash
npx skills add MCKRUZ/claude-code-mastery
```

## What's Included

### Skills (via APM dependencies)

| Skill | Source |
|-------|--------|
| claude-code-mastery | This package (the core skill) |
| dashboard-creator | mhattingpete/claude-skills-marketplace |
| demo-video | MCKRUZ/demo-video-skill |
| docx | anthropics/skills |
| excalidraw-diagram-generator | coleam00/excalidraw-diagram-skill |
| find-skills | anthropics/skills |
| functional-design | MCKRUZ/functional-design |
| humanizer | blader/humanizer |
| llm-cost-optimizer | MCKRUZ/llm-cost-optimizer-skill |
| pdf | anthropics/skills |
| project-memory | SpillwaveSolutions/project-memory |
| security-review | MCKRUZ/security-review-skill |
| shannon | KeygraphHQ/shannon |
| skeptic | MCKRUZ/skeptic-skill |
| slides | MCKRUZ/slides-skill |
| tdd-workflow | MCKRUZ/tdd-workflow-skill |
| visual-explainer | nicobailon/visual-explainer |

### Instructions (deployed to `.claude/rules/` or `.github/instructions/`)

| File | What It Covers |
|------|---------------|
| `coding-style` | Immutability, naming, file organization, validation |
| `security` | Pre-commit checklist, JWT, headers, secrets |
| `testing` | 80% coverage, TDD, bug-fix-first workflow |
| `agents` | When to spawn agents, commit format, PR workflow |
| `performance` | Context window, research limits, build troubleshooting |
| `patterns` | Privacy tags, skeleton projects |
| `plugins` | Recommended plugin stack with install commands |

### Agents (deployed to `.claude/agents/` or `.github/agents/`)

| Agent | Purpose |
|-------|---------|
| `code-reviewer` | Post-change quality review (bugs, security, coverage) |
| `security-auditor` | Auto-spawned for auth/payment/identity code |
| `doc-writer` | Technical documentation with project style matching |

### Hooks (reference patterns in `hooks.json`)

| Hook | Event | What It Does |
|------|-------|-------------|
| git-push-guard | PreToolUse | Forces commit review before push |
| auto-format-* | PostToolUse | Formats TS/Python/C# files on write |
| context-renewal | PostCompact | Re-orients after compaction |
| type/build-check | Stop | Catches errors when Claude stops |

## Full Power-User Setup

The APM package gives you the foundation. For the complete harness — plugins, production settings, MCP gateway, lifecycle hooks, Langfuse observability, and cross-project intelligence — see **[SETUP.md](SETUP.md)**.

| Priority | What You Get | Time |
|----------|-------------|------|
| **Essential** | Skills + plugins + global config | 10 min |
| **Recommended** | + production settings + core hooks | 20 min |
| **Power User** | + MCP gateway + memory + switchboard + DSL | 45 min |
| **Full Harness** | Complete lifecycle automation | 90 min |

## Self-Updating Knowledge Base

Say "update knowledge" or "research latest" and the skill will search official docs and community sources, appending findings to `references/knowledge-base.md`.

## Usage

- Invoke directly: `/claude-code-mastery`
- Or let Claude auto-detect from context (e.g., "set up Claude Code for my project")
- Audit your setup: "audit my Claude Code configuration"

## File Structure

```
claude-code-mastery/
├── plugin.json                    # APM plugin manifest
├── apm.yml                        # APM dependency manifest
├── SKILL.md                       # Core skill (7 pillars)
├── instructions/                  # APM instructions (.instructions.md)
│   ├── coding-style, security, testing, agents,
│   ├── performance, patterns, plugins
├── agents/                        # APM agent definitions (.agent.md)
│   ├── code-reviewer, security-auditor, doc-writer
├── hooks.json                     # Universal hook patterns (reference)
├── hooks/dsl/                     # Double Shot Latte autonomous hook
├── references/                    # Knowledge base & templates
│   ├── knowledge-base.md          # Living knowledge (append-only)
│   ├── settings-templates.md      # Production settings templates
│   ├── claude-md-templates.md     # CLAUDE.md templates (TS, Python, C#)
│   ├── troubleshooting.md         # Common problems + fixes
│   └── changelog.md               # Version history
├── eval/                          # Skill evaluation framework
└── scripts/                       # Research checklist
```

## License

MIT
