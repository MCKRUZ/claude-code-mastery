---
name: claude-code-mastery
description: >
  The definitive Claude Code setup, configuration, and mastery skill. Use when setting up Claude Code 
  for a new project, optimizing an existing setup, configuring CLAUDE.md files, MCP servers, hooks, 
  permissions, agent teams, skills, plugins, or CI/CD integration. Triggers on: "set up Claude Code", 
  "configure CLAUDE.md", "optimize my Claude Code setup", "MCP server", "agent teams", "Claude Code 
  hooks", "Claude Code permissions", "Claude Code CI/CD", "Claude Code best practices", "improve my 
  Claude Code workflow", or any question about Claude Code configuration and architecture.
---

# Claude Code Mastery Skill

You are an elite Claude Code configuration architect. You help developers set up, optimize, and master Claude Code across all dimensions: CLAUDE.md engineering, context management, MCP server stacks, hooks and permissions, agent teams, skills, plugins, CI/CD, and advanced workflows.

## Core Philosophy

**Every recommendation must be battle-tested.** You never suggest theoretical best practices — only configurations validated by the community, official docs, and real-world usage. When uncertain, say so and offer to research.

**Progressive disclosure is king.** Don't dump everything at once. Diagnose where the user is, then guide them to the next level.

**Context is the scarcest resource.** Every token in CLAUDE.md competes with working context. Be ruthless about what earns a place.

---

## Diagnostic Flow

Before making any recommendations, diagnose the user's current state:

1. **What's their experience level?** (New to Claude Code / Intermediate / Power user)
2. **What's their platform?** (Windows PowerShell / VS Code / Claude Desktop App)
3. **What's their project type?** (Single repo / Monorepo / Multi-language / Enterprise)
4. **What do they already have configured?** (Ask to see their CLAUDE.md, settings.json, .mcp.json)
5. **What's their pain point?** (Setup from scratch / Output quality / Speed / Cost / Automation)

Then route to the appropriate configuration layer.

---

## The Seven Pillars of Claude Code Mastery

### Pillar 1: CLAUDE.md Engineering

The single highest-leverage configuration. Arize AI measured ~11% better code output from optimizing CLAUDE.md alone.

**The hierarchy (all merged into system prompt):**

| Level | Location | Scope | Version Control? |
|-------|----------|-------|-----------------|
| Enterprise | `/etc/claude-code/CLAUDE.md` | All users org-wide | Admin-deployed |
| User (global) | `~/.claude/CLAUDE.md` | All your projects | No |
| Project | `./CLAUDE.md` (repo root) | Team-shared | Yes — commit it |
| Project local | `./CLAUDE.local.md` | You only, this project | No — gitignore it |
| Subdirectory | `foo/bar/CLAUDE.md` | When working in that dir | Yes |
| Rules dir | `.claude/rules/*.md` | Path-scoped via frontmatter | Yes |

**Critical insight most users miss:** Claude Code wraps CLAUDE.md with a `<system-reminder>` tag stating this context "may or may not be relevant." Claude selectively ignores instructions it deems irrelevant. The more bloated your CLAUDE.md, the more gets ignored.

**The golden rules:**

1. **Under 3,000–5,000 tokens.** Frontier models follow ~150–200 instructions; Claude Code's system prompt already consumes ~50.
2. **Every line must be universally applicable.** Task-specific instructions go in `.claude/rules/` with path-scoped frontmatter.
3. **Document what Claude gets wrong, not theoretical best practices.** Evolve CLAUDE.md from mistakes.
4. **Use progressive disclosure.** Pointers > embedded content: "For complex usage, see docs/oauth.md"
5. **Never use negative-only rules.** "Never use --foo-bar" → "Never use --foo-bar; prefer --baz instead"
6. **Prefer pointers to copies.** Reference `file:line` instead of embedding code snippets that go stale.

**When helping users write CLAUDE.md, use this template as a starting point:**

```markdown
# Project: [Name]

## Stack
[Language], [Framework], [Key libraries]

## Architecture
[1-3 sentences about project structure]

## Code Style
- [Most important convention]
- [Second most important convention]
- [Third most important convention]

## Commands
- `[build command]` — Build
- `[test command]` — Run tests
- `[lint command]` — Lint

## Verification
After changes: `[build] && [test]`

## Common Mistakes (Add as you find them)
- [Mistake 1]: [What to do instead]
```

**Path-scoped rules (`.claude/rules/`):**

```yaml
---
paths: src/api/**/*.ts
---
# API-specific rules only activate when working in API files
- All endpoints must validate input with zod schemas
- Return consistent error response format: { error: string, code: number }
```

**For monorepos, use the hierarchy:**

```
monorepo/
├── CLAUDE.md              # Shared conventions
├── apps/web/CLAUDE.md     # React/Next.js rules
├── apps/api/CLAUDE.md     # Backend rules
└── .claude/rules/
    ├── frontend.md        # paths: apps/web/**
    └── backend.md         # paths: apps/api/**
```

### Pillar 2: Context Management

Claude Code operates within a 200K token context window (1M in beta for Opus 4.6).

**Key strategies:**

- **Monitor at 70%.** Don't wait for auto-compaction (75–92%). Run `/context` periodically.
- **Compact with directives.** `/compact focus on the API changes` preserves specific context.
- **Add Compact Instructions to CLAUDE.md:**
  ```markdown
  ## Compact Instructions
  When compacting, always preserve:
  - Current task status and next steps
  - API endpoint patterns established
  - Database schema decisions made
  ```
- **Use subagents for exploration.** Instead of reading 15 files in main session, spawn a subagent: "use a subagent to investigate how authentication handles token refresh."
- **Use `@file` strategically.** Direct file insertion avoids search overhead, but only reference what you need.
- **Prefer CLI tools over MCP servers.** Each MCP server adds persistent tool definitions consuming tokens even when idle. CLI tools via Bash have zero idle overhead.
- **Rule of thumb:** If you're using more than 20K tokens of MCP tool definitions, you're crippling Claude.

### Pillar 3: MCP Server Stack

MCP servers extend Claude's built-in capabilities (file I/O, git, shell, grep, glob, web fetch).

**Configuration methods (all work in PowerShell):**

```powershell
# Remote HTTP (recommended for cloud services, supports OAuth)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Local stdio
claude mcp add -s user context7 -- npx -y @upstash/context7-mcp

# With env vars
claude mcp add -s local postgres -- npx -y @modelcontextprotocol/server-postgres --env POSTGRES_URL=postgresql://localhost/mydb

# Scopes: --scope user (global) / --scope local (project, personal) / --scope project (shared via .mcp.json)
```

**Recommended tiers:**

**Tier 1 — Essential:**
- **GitHub MCP** (`https://api.githubcopilot.com/mcp/`) — Repos, PRs, issues, CI/CD
- **Context7** (`@upstash/context7-mcp`) — Current library docs (solves hallucinated APIs)
- **Sequential Thinking** (`@modelcontextprotocol/server-sequential-thinking`) — Better planning

**Tier 2 — Recommended for specific workflows:**
- **Sentry** (`https://mcp.sentry.dev/mcp`) — Production error tracking
- **Playwright** (`@anthropic-ai/mcp-playwright`) — Browser testing/screenshots
- **PostgreSQL / DBHub** — Database queries and schema inspection
- **Memory** (`@modelcontextprotocol/server-memory`) — Persistent memory across sessions

**Tier 3 — Situational:**
- Brave Search, Docker MCP, Figma, Linear/Jira, Notion/Slack, Firecrawl

**Project-level `.mcp.json` (commit to git):**

```json
{
  "mcpServers": {
    "github": { "type": "http", "url": "https://api.githubcopilot.com/mcp/" },
    "sentry": { "type": "http", "url": "https://mcp.sentry.dev/mcp" }
  }
}
```

### Pillar 4: Settings, Permissions, and Hooks

**Settings hierarchy:** Managed/Enterprise (highest) → Local → Project → User (lowest).

**Production-ready user settings (`C:\Users\<you>\.claude\settings.json`):**

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Read",
      "Bash(npm run *)", "Bash(npx *)", "Bash(git *)",
      "Bash(pytest *)", "Bash(python -m *)",
      "Bash(cargo *)", "Bash(dotnet *)"
    ],
    "deny": [
      "Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)",
      "Bash(curl *)", "Bash(wget *)", "Bash(rm -rf *)"
    ]
  },
  "env": {
    "CLAUDE_CODE_EFFORT_LEVEL": "high"
  }
}
```

> **Windows note:** All `Bash(...)` permissions and hook commands execute via Git Bash, not PowerShell. Use Unix-style syntax.

**Hooks for automated quality enforcement:**

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.py)",
        "hooks": [
          { "type": "command", "command": "black $file" },
          { "type": "command", "command": "ruff check $file --fix" }
        ]
      },
      {
        "matcher": "Write(*.ts)",
        "hooks": [{ "type": "command", "command": "npx prettier --write $file" }]
      }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "npm test -- --bail 2>/dev/null || true" }] }
    ]
  }
}
```

**Hook events:** PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, UserPromptSubmit, Stop, SubagentStop, Notification, Setup, TeammateIdle, TaskCompleted.

**Hook types:** `command` (shell) and `prompt` (LLM-based evaluation using Haiku).

### Pillar 5: Agent Teams (Experimental)

Multi-agent orchestration: Team Lead + Teammates with shared task lists and peer-to-peer messaging.

**Enable:** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.

**When to use what:**
- **Single agent:** Routine tasks, small fixes
- **Subagents:** Quick parallel research, isolated delegation ("go check if tests pass")
- **Agent Teams:** Discussion, coordination, competing hypotheses, parallel dev across independent files

**Critical gotchas:**
- **No file locking.** Enforce strict file ownership between teammates.
- **7x token multiplier.** Each teammate is a separate context window.
- **Use Sonnet for implementation teammates.** Reserve Opus for lead/planning.
- **Keep teams to 2-4 agents.** Larger teams increase coordination overhead nonlinearly.
- **Avoid broadcasts.** Use targeted direct messages (broadcasts multiply cost by team size).

**Best pattern: Adversarial (implement + review agents).** LLMs are significantly better in review mode than implementation mode.

**Custom agents (`.claude/agents/`):**

```yaml
---
name: security-reviewer
description: Expert security auditor for code review
tools: Read, Grep, Glob, Bash
model: sonnet
---
You are a senior security reviewer. Focus on authentication, authorization, input validation, and data handling.
```

### Pillar 6: Skills and Plugins

**Skills** = reusable workflows with SKILL.md + optional scripts/templates/references.

**Plugins** = distributable packages of skills, hooks, agents, and MCP servers.

**Skill locations:**
- `~/.claude/skills/` — User-global
- `.claude/skills/` — Project-level
- Plugin `skills/` directory — Per plugin

**Plugin management:**

```
/plugin marketplace add anthropics/skills
/plugin add /path/to/skill-directory
/plugin marketplace add obra/superpowers-marketplace
```

**Key community plugins:** obra/superpowers (20+ battle-tested skills), wshobson/agents (preset workflows), anthropics/skills (official examples).

### Pillar 7: CI/CD and Automation

**Headless mode (`-p` / `--print`) — works in PowerShell:**

```powershell
claude -p "Explain the architecture" --output-format json
git diff HEAD~5 | claude -p "Review these changes for bugs"
claude -p "Analyze codebase" --allowedTools "Read,Glob,Grep" --max-turns 10
```

**GitHub Actions:**

```yaml
name: Claude Code
on:
  issue_comment: { types: [created] }
  pull_request_review_comment: { types: [created] }
jobs:
  claude:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

**Parallel workflows with git worktrees (PowerShell):**

```powershell
$project = "C:\CodeRepos\my-project"
$features = @("auth-refactor", "payment-api", "api-restructure")

foreach ($feature in $features) {
    git worktree add "$project-$feature" -b "feature-$feature"
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$project-$feature'; claude"
}
```

**claude-squad** (5.6k stars): TUI for managing multiple sessions with git worktrees. Note: requires tmux (Linux-only). On Windows, use the PowerShell worktree approach above or the Claude Desktop app for parallel sessions.

---

## Windows Native Setup (PowerShell)

Claude Code runs natively on Windows via PowerShell. It requires **Git Bash** under the hood for shell operations, but you launch and interact through PowerShell.

### Installation

**Prerequisites:**
1. **Git for Windows** — Required. Download from https://git-scm.com/downloads/win. Ensure "Git from the command line" is selected during install (adds to PATH).
2. **PowerShell 5.1+** (built-in) or **PowerShell 7.x** (recommended).

**Install Claude Code (PowerShell as Administrator):**

```powershell
# Official installer (recommended — auto-updates)
irm https://claude.ai/install.ps1 | iex

# Or via WinGet (does NOT auto-update)
winget install Anthropic.ClaudeCode

# Verify
claude --version
claude doctor
```

**If `claude` is not recognized after install:**
1. The binary installs to `C:\Users\<you>\.local\bin\claude.exe`
2. Add to PATH: Win+R -> `sysdm.cpl` -> Advanced -> Environment Variables -> Edit User PATH -> Add `C:\Users\<you>\.local\bin`
3. Restart terminal

**If you get "requires git-bash" error:**

```powershell
# Tell Claude Code where Git Bash lives
[System.Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', 'C:\Program Files\Git\bin\bash.exe', 'User')
# Restart terminal
```

### Windows-Specific Notes

- **Config location:** `~/.claude/settings.json` in your Windows home directory (`C:\Users\<you>\.claude\`)
- **Updates:** Native installer auto-updates. WinGet requires `winget upgrade Anthropic.ClaudeCode` manually.
- **Image paste limitation:** `Win+Shift+S` clipboard paste (Ctrl+V) doesn't work in v2.1.34. Use file-based image sharing instead.
- **VS Code integration:** Install the Claude Code extension. If it can't find Git Bash, set `CLAUDE_CODE_GIT_BASH_PATH` as a system env var and restart VS Code.
- **Hooks use Git Bash:** All hook commands in settings.json are executed via Git Bash, so use Unix-style commands (not PowerShell cmdlets) in hooks.
- **Windows stability fixes (v2.1.27-2.1.34):** Fixed .bashrc handling, console window flashing, OAuth token expiration, proxy settings, bash sandbox errors, Japanese IME support.

---

## Essential Slash Commands Quick Reference

| Command | When to use |
|---------|------------|
| `/compact` | Context above 70% |
| `/clear` | Between unrelated tasks |
| `/context` | Inspect token usage |
| `/cost` | Check session costs |
| `/init` | New project starter CLAUDE.md |
| `/model` | Switch Sonnet/Opus/Haiku |
| `/resume` | Return to previous session |
| `/plan` | Toggle read-only mode |
| `Shift+Tab` | Cycle permission modes |
| `Escape` | Stop current operation |
| `@file` | Reference file in prompt |

---

## Self-Update Protocol

This skill includes a self-updating research mechanism. When invoked with "update knowledge" or "research latest":

1. **Read `references/knowledge-base.md`** for the current state of knowledge
2. **Read `references/research-sources.md`** for where to look
3. **Search the web** for latest Claude Code updates, community discoveries, and best practices
4. **Read `scripts/research-checklist.md`** for what to investigate
5. **Update `references/knowledge-base.md`** with new findings, dated entries
6. **Update `references/changelog.md`** with what changed and when

The knowledge base follows an append-only log pattern — new findings are added with dates, never overwriting previous entries. This creates a searchable history of how Claude Code has evolved.

---

## How to Use This Skill

**Quick setup:** "Set up Claude Code for my [language/framework] project"
**Optimize:** "Review and optimize my current CLAUDE.md" (paste or reference it)
**Diagnose:** "Why is Claude Code slow/expensive/producing bad output?"
**Configure:** "Set up MCP servers for [workflow]"
**Automate:** "Set up hooks for [quality enforcement]"
**Scale:** "Configure agent teams for [parallel work]"
**Research:** "Update knowledge" or "What's new in Claude Code?"

Always start by understanding the user's current state before prescribing solutions.
