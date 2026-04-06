---
name: claude-code-mastery
description: >
  The definitive Claude Code setup, configuration, and mastery skill. Use when setting up Claude Code
  for a new project, optimizing an existing setup, configuring CLAUDE.md files, MCP servers, hooks,
  permissions, agent teams, skills, plugins, skill development, eval frameworks, or CI/CD integration.
  Triggers on: "set up Claude Code", "configure CLAUDE.md", "optimize my Claude Code setup", "MCP server",
  "agent teams", "Claude Code hooks", "Claude Code permissions", "Claude Code CI/CD", "Claude Code best
  practices", "improve my Claude Code workflow", "skill development", "eval framework", "build a skill",
  or any question about Claude Code configuration and architecture. Does NOT trigger on general coding
  tasks, code review, debugging, or tool configuration unrelated to Claude Code.
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

## Task Approach
When given a feature request or task:
1. **Clarify before coding.** If ambiguous, ask 1-2 targeted questions first.
2. **Present options when trade-offs exist.** Briefly show 2-3 approaches and let me choose.
3. **Scope the work.** State your plan (files, approach, verification) before big changes.
4. **Implement in layers.** Inner layers first, outer layers last, tests at the end.
5. **Verify as you go.** Run build/test after each meaningful change.
6. **Flag risks.** Call out anything that could break existing functionality.

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

#### Production Global Rules Architecture

A mature setup separates concerns into `~/.claude/CLAUDE.md` (brief, always-loaded) + `~/.claude/rules/*.md` (domain-scoped). This keeps the global CLAUDE.md under 500 tokens while providing deep guidance per domain:

```
~/.claude/
├── CLAUDE.md                  # ~20 lines: compact instructions, cross-project conventions, response style
└── rules/
    ├── agents.md              # When to auto-spawn agents, commit format, PR workflow
    ├── coding-style.md        # Immutability patterns (C#/TS), naming, error handling, validation
    ├── security.md            # Pre-commit checklist: secrets, input validation, JWT, headers, CSRF
    ├── testing.md             # 80% coverage, TDD flow, test patterns (xUnit/Jasmine/Cypress)
    ├── patterns.md            # Privacy tags, skeleton project pattern
    ├── performance.md         # Context window limits, build troubleshooting, research time limits
    └── nexus-memory.md        # Cross-project memory rules (Nexus integration)
```

**Global CLAUDE.md should only contain:**
- Compact instructions (what to preserve during compaction)
- Cross-project conventions (immutability, validation, coverage, no console.log)
- Response style (lead with answer, skip summaries, use file:line references)

**Rules files handle domain depth.** Each loads into context only when relevant. Example `coding-style.md`:
```markdown
# Coding Style
## Immutability (CRITICAL)
- TypeScript: spread operators, never mutate objects/arrays
- C#: prefer records, `with` expressions, `ImmutableList<T>`
- NgRx reducers: always return new state objects
## Naming
- C#: PascalCase (classes/methods), `_camelCase` (private fields)
- TypeScript: PascalCase (types), camelCase (vars), kebab-case (files)
```

### Pillar 2: Context Management

Claude Code operates within a **1M token context window** by default for Opus 4.6 on Max, Team, and Enterprise plans (as of v2.1.75). Output tokens expanded to **64K default / 128K upper bound** (v2.1.77). Current version: **v2.1.92**.

**Key strategies:**

- **Monitor at 70%.** Don't wait for auto-compaction (75–92%). Run `/context` periodically — it now gives actionable suggestions (identifies context-heavy tools, memory bloat, capacity warnings).
- **Compact with directives.** `/compact focus on the API changes` preserves specific context.
- **PostCompact context renewal.** Use the `PostCompact` hook (v2.1.76) to re-inject critical instructions after compaction. Community pattern: a prompt hook that reminds Claude of active skills, project rules, and task state that may have been lost.
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
- **MCP Tool Search (lazy loading):** Claude Code auto-enables lazy loading when MCP tool definitions exceed 10K tokens. Instead of loading all schemas upfront (~77K tokens), it loads a search index (~8.7K tokens) and fetches 3-5 tools on demand. This reduces the old context penalty by 85-95%.
- **CLI tools still have zero overhead.** Prefer them for simple tasks. But the old "20K token MCP limit" rule is now largely obsolete thanks to Tool Search.
- **Rule of thumb (updated):** With Tool Search enabled, you can run many MCP servers freely. Without it (older versions), >20K tokens of MCP definitions will cripple Claude.
- **Effort levels.** Use `/effort` to adjust model effort (low/medium/high). Use "ultrathink" keyword in prompts for one-shot high-effort analysis.
- **Context-mode plugin.** The `context-mode` plugin (mksglu/context-mode) intercepts tool calls that produce large output and routes them through a sandbox — only your printed summary enters the context window. Prevents raw `Bash` or `Read` output from flooding the window. Use `ctx_batch_execute` for research, `ctx_search` for follow-ups, `ctx_execute`/`ctx_execute_file` for data processing. Check savings with `/context-mode:ctx-stats`.

### Pillar 3: MCP Server Stack

MCP servers extend Claude's built-in capabilities (file I/O, git, shell, grep, glob, web fetch).

**Configuration methods (all work in PowerShell):**

```powershell
# Local stdio (Windows: use cmd /c wrapper for npx commands)
claude mcp add -s user context7 -- cmd /c npx -y @upstash/context7-mcp

# GitHub MCP with Personal Access Token (requires env var)
claude mcp add -s user github -- cmd /c npx -y @modelcontextprotocol/server-github --env GITHUB_PERSONAL_ACCESS_TOKEN=your_token_here

# With env vars
claude mcp add -s local postgres -- cmd /c npx -y @modelcontextprotocol/server-postgres --env POSTGRES_URL=postgresql://localhost/mydb

# Remote HTTP (for compatible cloud services with OAuth)
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# Scopes: --scope user (global) / --scope local (project, personal) / --scope project (shared via .mcp.json)
```

> **Windows gotcha:** `claude mcp add` writes to `~/.claude.json`, which requires `cmd /c` before `npx`. Servers in `~/.claude/settings.json` may work without it. Run `claude doctor` to detect issues.

> **GitHub MCP note:** The GitHub Copilot endpoint (`https://api.githubcopilot.com/mcp/`) does NOT work with Claude Code due to incompatible auth. Use the official `@modelcontextprotocol/server-github` package with a GitHub Personal Access Token instead. See troubleshooting.md for detailed setup.

**Recommended tiers:**

**Tier 0 — MCP Gateway Architecture (recommended for power users):**

Instead of running 6+ individual MCP servers (each consuming process overhead and requiring separate permissions), consolidate behind a single **MCP Gateway** that routes to multiple backend servers:

**Option A — Remote gateway (Bifrost, recommended):**

Run a gateway process on a home server or always-on machine. Claude Code connects via HTTP:

```json
{
  "mcpServers": {
    "bifrost": {
      "type": "http",
      "url": "http://your-server:8090/mcp"
    }
  }
}
```

The gateway wraps multiple backend servers (GitHub, Context7, Sequential Thinking, Firecrawl, YouTube, etc.) behind one endpoint. Configure backends in the gateway's own config — Claude Code only sees one server.

**Option B — Local hub (FastMCP wrapping):**

For fully local setups, use a Python FastMCP server that wraps multiple servers:

```json
{
  "mcpServers": {
    "hub": {
      "command": "uv",
      "args": ["--directory", "C:/path/to/mcp-hub", "run", "fastmcp", "run", "src/mcp_hub/server.py"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": ""
      }
    }
  }
}
```

**Benefits of gateway architecture:**
- Single connection instead of 6+ processes (lower memory, faster startup)
- Unified permissions: `mcp__bifrost__*` (or `mcp__hub__*` for local)
- Backend servers managed independently — add/remove without editing Claude settings
- Remote gateways survive Claude Code restarts (no cold-start latency)

**`mcpNotes` pattern** — document why servers were removed so you don't re-add them later:
```json
{
  "mcpNotes": {
    "sentry": "Removed 2026-02-09 — Add back when deploying production apps: https://mcp.sentry.dev/mcp",
    "filesystem": "Removed 2026-02-09 — Built-in Read/Write/Glob/Grep cover file ops, saved ~2-3K tokens",
    "memory": "Removed 2026-02-09 — cmem MCP provides superior conversation memory + learned lessons",
    "hub-mode": "Replaced mcp-hub with Bifrost MCP gateway on mac-mini:8090 (2026-03-26). Nexus runs direct as nexus-local.",
    "config-location": "MCP servers are managed in ~/.claude.json via 'claude mcp add/remove', NOT in settings.json"
  }
}
```

**Tier 1 — Essential (if not using Hub):**
- **GitHub MCP** (`@modelcontextprotocol/server-github`) — Repos, PRs, issues, CI/CD. Use the npm package with a PAT. The `https://api.githubcopilot.com/mcp/` HTTP endpoint does NOT work with Claude Code (incompatible auth).
- **Context7** (`@upstash/context7-mcp`) — Current library docs (solves hallucinated APIs)
- **Sequential Thinking** (`@modelcontextprotocol/server-sequential-thinking`) — Better planning

> **MCP Tool Search (v2.1.x+):** Claude Code now lazy-loads MCP tool definitions when they exceed 10K tokens. This reduces context overhead by 85-95%, making it practical to run many more MCP servers simultaneously.

**Tier 2 — Recommended for specific workflows:**
- **Sentry** (`https://mcp.sentry.dev/mcp`) — Production error tracking
- **Playwright** (`@anthropic-ai/mcp-playwright`) — Browser testing/screenshots
- **PostgreSQL / DBHub** — Database queries and schema inspection
- **cmem** (conversation memory) — Session persistence + learned lessons across conversations (replaces `@modelcontextprotocol/server-memory`)

**Tier 3 — Situational:**
- Brave Search, Docker MCP, Figma, Linear/Jira, Notion/Slack, Firecrawl
- **GWS** (`@googleworkspace/cli`) — Google Workspace: 50+ APIs (Gmail, Drive, Calendar, Sheets). Ships with MCP server: `gws mcp -s drive,gmail,calendar,sheets`

**MCP Elicitation (v2.1.76):** MCP servers can now request structured input mid-task via interactive dialogs (form fields or browser URLs). New hooks `Elicitation` and `ElicitationResult` allow intercepting or overriding these requests.

**Native MCP management:** Use `/mcp` command (v2.1.70) to add/remove/configure MCP servers within a session — no manual config file editing required.

**Project-level `.mcp.json` (commit to git):**

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": ""
      }
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    }
  }
}
```

> **Note:** Don't commit your GitHub token to git! Leave `GITHUB_PERSONAL_ACCESS_TOKEN` empty in `.mcp.json` and set it in your user-level `~/.claude/settings.json` or `~/.claude.json` instead, or use environment variables.

### Pillar 4: Settings, Permissions, and Hooks

**Settings hierarchy:** Managed/Enterprise (highest) → Local → Project → User (lowest).

**Production-ready user settings (`C:\Users\<you>\.claude\settings.json`):**

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "model": "opus[1m]",
  "alwaysThinkingEnabled": true,
  "voiceEnabled": true,
  "autoUpdatesChannel": "latest",
  "skipDangerousModePermissionPrompt": true,
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep", "WebSearch",
      "Bash(dotnet *)", "Bash(git *)", "Bash(gh *)",
      "Bash(ng *)", "Bash(npm *)", "Bash(npx *)",
      "Bash(az *)", "Bash(bicep *)", "Bash(pwsh *)",
      "Bash(python *)", "Bash(py *)", "Bash(pytest *)",
      "Bash(ssh *)", "Bash(claude *)",
      "mcp__bifrost__*",
      "mcp__nexus-local__*"
    ],
    "deny": [
      "Read(.env*)", "Read(*.env)", "Read(secrets/**)", "Read(appsettings.*.json)",
      "Bash(rm -rf *)", "Bash(wget *)",
      "Bash(git push --force *)", "Bash(git reset --hard *)",
      "Bash(pwsh * Invoke-WebRequest *)", "Bash(pwsh * Invoke-RestMethod *)",
      "Bash(pwsh * iwr *)", "Bash(pwsh * irm *)"
    ]
  },
  "env": {
    "TRACE_TO_LANGFUSE": "true",
    "LANGFUSE_PUBLIC_KEY": "",
    "LANGFUSE_SECRET_KEY": "",
    "LANGFUSE_HOST": "https://langfuse.your-server.example",
    "CLAUDE_CODE_EFFORT_LEVEL": "high",
    "CLAUDE_HOOK_PROFILE": "standard",
    "CLAUDE_DISABLED_HOOKS": "ollama-delegate"
  },
  "statusLine": {
    "type": "command",
    "command": "... (claude-hud plugin — see enabledPlugins)"
  },
  "enabledPlugins": {
    "deep-project@piercelamb-plugins": true,
    "deep-plan@piercelamb-plugins": true,
    "deep-implement@piercelamb-plugins": true,
    "code-simplifier@claude-plugins-official": true,
    "context-mode@context-mode": true,
    "claude-hud@claude-hud": true
  },
  "extraKnownMarketplaces": {
    "context-mode": {
      "source": { "source": "github", "repo": "mksglu/context-mode" }
    },
    "claude-hud": {
      "source": { "source": "github", "repo": "jarrodwatts/claude-hud" }
    }
  }
}
```

**Key patterns in this config:**
- **`model: "opus[1m]"`** — locks to Opus with 1M context window
- **`alwaysThinkingEnabled`** — extended thinking on every response (better reasoning)
- **`skipDangerousModePermissionPrompt`** — skip extra confirmation when entering dangerous mode (power users only)
- **`CLAUDE_HOOK_PROFILE`** — enables hook profile switching (standard/minimal/off)
- **`CLAUDE_DISABLED_HOOKS`** — disable specific hooks without removing them
- **`statusLine`** — claude-hud plugin shows project name, model, context usage %, and task state in the prompt bar
- **`enabledPlugins`** — deep-plan/implement for structured TDD workflow, context-mode for context window protection, claude-hud for status display
- **`extraKnownMarketplaces`** — registers third-party plugin sources (context-mode, claude-hud) so `/plugin marketplace` can discover them
- **MCP permissions** — pre-allow Bifrost gateway and Nexus tools via wildcards (`mcp__bifrost__*`, `mcp__nexus-local__*`) to avoid per-tool permission prompts
- **Langfuse tracing** — `TRACE_TO_LANGFUSE` + credentials enable observability. Traces flushed via `langfuse_hook.py` Stop hook (no proxy needed)
- **Deny PowerShell web requests** — prevents accidental data exfiltration via `Invoke-WebRequest`/`irm`

> **Windows note:** All `Bash(...)` permissions and hook commands execute via Git Bash, not PowerShell. Use Unix-style syntax.

**Production hook stack (full lifecycle):**

A mature setup hooks into every lifecycle event. Here's the actual production stack, ordered by execution:

```
SessionStart:
  1. memory-persistence/session-start.ps1   ← Load previous session state
  2. Nexus sync (node CLI)                  ← Sync cross-project intelligence
  3. nexus-session-start.mjs                ← Initialize session tracking

PreToolUse (Edit|Write):
  4. skill-switchboard/switchboard.ps1      ← Inject relevant skills by file type
  5. strategic-compact/suggest-compact.ps1  ← Warn before context gets too full

PreToolUse (git push):
  6. Prompt: "List commits and remind user to review"

PreCompact:
  7. memory-persistence/pre-compact.ps1     ← Save work state before compaction
  8. Prompt: "Update MEMORY.md, session file, save patterns via cmem"

PostCompact:
  9. Prompt: "Re-orient: read MEMORY.md, check TaskList, review rules"

PostToolUse (Edit|Write):
  10. auto-format.sh                        ← Format edited files (prettier, etc.)
  11. memory-persistence/save-observation.ps1 ← Record file change to session log

PostToolUse (all):
  12. nexus-post-tool-use.mjs              ← Track tool usage patterns in Nexus

Stop:
  13. kill-mcp-children.ps1                 ← Clean up zombie MCP processes
  14. dsl/double-shot-latte.ps1             ← Autonomous continue evaluation
  15. memory-persistence/session-end.ps1    ← Persist session summary
  16. Nexus post-session (node CLI)         ← Sync decisions/patterns to Nexus
  17. langfuse_hook.py                      ← Flush observability traces
```

**In settings.json format (abbreviated — see full config for exact paths):**

```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/memory-persistence/session-start.ps1\"", "timeout": 10000 }] },
      { "hooks": [{ "type": "command", "command": "node \"~/path/to/nexus/cli/dist/index.js\" sync --quiet --graceful", "timeout": 15000 }] }
    ],
    "PreToolUse": [
      { "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/skill-switchboard/switchboard.ps1\"", "timeout": 8000 }] },
      { "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/strategic-compact/suggest-compact.ps1\"", "timeout": 5000 }] },
      { "matcher": "Bash(git push*)", "hooks": [{ "type": "prompt", "prompt": "Before pushing, list the commits that will be pushed and remind the user to review changes." }] }
    ],
    "PreCompact": [
      { "hooks": [
        { "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/memory-persistence/pre-compact.ps1\"", "timeout": 10000 },
        { "type": "prompt", "prompt": "Before compaction: update MEMORY.md (current work + next steps), update today's session .tmp file, and save reusable patterns via mcp__cmem__save_lesson if any." }
      ]}
    ],
    "PostCompact": [
      { "hooks": [{ "type": "prompt", "prompt": "Context was just compacted. Re-orient yourself:\n1. Read your project's MEMORY.md for current work state and next steps.\n2. Check the task list (TaskList) for any in-progress tasks.\n3. Review your .claude/rules/ files if working in a specific domain.\nDo NOT announce this re-orientation to the user — just resume working seamlessly." }] }
    ],
    "PostToolUse": [
      { "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "bash \"~/.claude/hooks/auto-format.sh\"", "timeout": 30000 }] },
      { "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/memory-persistence/save-observation.ps1\"", "timeout": 5000 }] },
      { "hooks": [{ "type": "command", "command": "node --experimental-sqlite \"~/.claude/hooks/nexus-post-tool-use.mjs\"" }] }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/kill-mcp-children.ps1\"", "timeout": 8000 }] },
      { "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/dsl/double-shot-latte.ps1\"", "timeout": 8000 }] },
      { "hooks": [{ "type": "command", "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"~/.claude/hooks/memory-persistence/session-end.ps1\"", "timeout": 10000 }] },
      { "hooks": [{ "type": "command", "command": "node \"~/path/to/nexus/cli/dist/index.js\" hook post-session --quiet", "timeout": 30000 }] },
      { "hooks": [{ "type": "command", "command": "py \"~/.claude/hooks/langfuse_hook.py\"", "timeout": 30000 }] }
    ]
  }
}
```

**Key hook patterns:**

| Pattern | Hooks | Purpose |
|---------|-------|---------|
| **Memory persistence lifecycle** | SessionStart → save-observation → PreCompact → Stop | Continuous session state across compactions and restarts |
| **Strategic compact** | PreToolUse (Edit\|Write) | Warns before context window fills — prevents mid-task compaction |
| **Kill MCP children** | Stop | Cleans up zombie MCP server processes that outlive the session |
| **Langfuse tracing** | Stop + ANTHROPIC_BASE_URL proxy | Full observability — every API call traced, flushed on session end |
| **Git push guard** | PreToolUse (git push) | Forces review of commits before push — prevents accidental pushes |

> **Important:** Use `$CLAUDE_FILE_PATH` (not `$file`) for the file path variable. Always include a `timeout` value. Avoid bash-style redirects like `2>/dev/null || true` — they can cause issues on Windows.

**Hook events:** SessionStart, PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, UserPromptSubmit, PreCompact, **PostCompact** (v2.1.76), **InstructionsLoaded** (v2.1.69), **Elicitation** (v2.1.76), **ElicitationResult** (v2.1.76), Stop, SubagentStop, Notification, Setup, TeammateIdle, TaskCompleted.

**New hooks explained:**
- `InstructionsLoaded` — fires when CLAUDE.md or `.claude/rules/*.md` files are loaded. Enables skill activation patterns (e.g., inject additional context when specific rules load).
- `PostCompact` — fires after compaction completes. Use for context renewal: re-inject critical instructions, skill inventories, or project state that may be lost during compaction.
- `Elicitation` / `ElicitationResult` — intercept/override MCP server requests for structured user input.

#### Double Shot Latte (DSL) — Autonomous Continue Hook

Eliminates unnecessary check-in interruptions during long autonomous sessions. When Claude stops, a Haiku-evaluated prompt decides: does it genuinely need human input, or is it stopping out of habit? If the latter, Claude continues autonomously.

**Architecture (two Stop hooks in sequence):**

```json
"Stop": [
  {
    "hooks": [{
      "type": "command",
      "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/dsl/double-shot-latte.ps1\"",
      "timeout": 8000
    }]
  },
  {
    "hooks": [{
      "type": "prompt",
      "prompt": "DOUBLE SHOT LATTE: Read C:/Users/<you>/.claude/hooks/dsl/decision.txt.\n\nIf it contains THROTTLED: stop and tell the user 'DSL throttled: paused after 3 consecutive stops in 5 minutes — what do you need?'\n\nIf it contains CONTINUE: honestly evaluate whether you genuinely need human input. If you stopped out of habit or caution rather than genuine need — continue working autonomously. Only stop if truly blocked."
    }]
  }
]
```

**`double-shot-latte.ps1`** (see `hooks/dsl/double-shot-latte.ps1`):
- Reads `~/.claude/hooks/dsl/state.json` for recent stop timestamps
- Cleans entries older than 5 minutes
- Checks if ≥ 3 stops remain (throttle condition)
- Records current stop timestamp
- Writes `CONTINUE` or `THROTTLED` to `decision.txt`
- The prompt hook instructs Claude to read `decision.txt` and act accordingly

**Throttle logic:** 3 stops within 5 minutes → THROTTLED → Claude stops and surfaces to user. This prevents infinite loops.

**Key gotcha:** Place DSL **before** session-end and save-lessons hooks in the Stop sequence, but **after** cleanup hooks like kill-mcp-children. Claude processes all Stop hooks in sequence; DSL's "continue" instruction takes effect after all hooks complete.

**Hook types:** `command` (shell), `prompt` (LLM-based, runs via Haiku), `agent` (multi-turn with tool access), `http` (POST to endpoint).

**Critical hook gotchas:**
- `type: "prompt"` at **SessionStart** fails if `ANTHROPIC_BASE_URL` points to a custom proxy — use command-only hooks there
- `type: "command"` at **Stop** can't communicate back to Claude (session is over) — use `type: "prompt"` for end-of-session Claude work
- **PreCompact** prompt hooks: never hardcode project-specific paths — use the auto-memory path injected by Claude Code at session start
- **Global hooks** (`~/.claude/settings.json`) run for all projects — keep paths and prompts project-agnostic

### Pillar 5: Agents and Subagents

**Two types of agents available:**

#### Built-in Subagent Types

Claude Code includes specialized subagents invoked via the `Task` tool with `subagent_type` parameter:

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| **planner** | Implementation planning | Complex features, refactoring |
| **architect** | System design | Architectural decisions |
| **tdd-guide** | Test-driven development | New features, bug fixes |
| **code-reviewer** | Code review | After writing code |
| **security-reviewer** | Security analysis | Before commits |
| **build-error-resolver** | Fix build errors | When build fails |
| **e2e-runner** | E2E testing | Critical user flows |
| **refactor-cleaner** | Dead code cleanup | Code maintenance |
| **doc-updater** | Documentation | Updating docs |

**Usage pattern:**
```typescript
// Invoke built-in subagent
Task(subagent_type: "code-reviewer", prompt: "Review auth.ts for security issues")
```

**Proactive usage:** Use planner, architect, tdd-guide, and code-reviewer agents automatically without waiting for user prompt when appropriate.

#### Custom Agents

Create project or domain-specific agents in `~/.claude/agents/` (global) or `.claude/agents/` (project-local).

**Organize agents by purpose:**
```
~/.claude/agents/
├── engineering/         # Engineering workflow agents (code review, architecture)
├── matts-custom/        # Personal/custom agents (brand-specific, domain-specific)
├── testing/             # Test-focused agents (integration, E2E, load testing)
└── _archived/           # Retired agents (keep for reference, don't delete)
```

**Agent file format** (`~/.claude/agents/engineering/my-agent/AGENT.md`):
```yaml
---
name: my-custom-agent
description: What this agent does
tools: Read, Grep, Glob, Bash
model: sonnet
---
You are a [role]. Your responsibilities are:
- [Responsibility 1]
- [Responsibility 2]

[Additional instructions...]
```

**Example:**
```yaml
---
name: security-reviewer
description: Expert security auditor for code review
tools: Read, Grep, Glob, Bash
model: sonnet
---
You are a senior security reviewer. Focus on authentication, authorization, input validation, and data handling.
```

#### Agent Teams (Experimental)

Multi-agent orchestration: Team Lead + Teammates with shared task lists and peer-to-peer messaging.

**Enable:** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.

**When to use what:**
- **Single agent:** Routine tasks, small fixes
- **Subagents:** Quick parallel research, isolated delegation
- **Agent Teams:** Discussion, coordination, competing hypotheses, parallel dev across independent files

**Critical gotchas:**
- **No file locking.** Enforce strict file ownership between teammates.
- **7x token multiplier.** Each teammate is a separate context window.
- **Use Sonnet for implementation teammates.** Reserve Opus for lead/planning.
- **Keep teams to 2-4 agents.** Larger teams increase coordination overhead nonlinearly.
- **Avoid broadcasts.** Use targeted direct messages (broadcasts multiply cost by team size).

**Best pattern: Adversarial (implement + review agents).** LLMs are significantly better in review mode than implementation mode.

#### Code Review (March 2026)

Anthropic launched **Code Review** as a multi-agent PR review capability:
- Multi-agent system that analyzes PRs in parallel, leaving comments directly on GitHub
- Research preview for Team and Enterprise customers
- ~$15-25 per review, ~20 minute completion time
- 54% of PRs receive substantive comments (up from 16% with older approaches)
- Not a skill to install — it's a built-in Claude Code capability

#### Wave Execution Orchestration

The most powerful multi-agent pattern for complex implementation tasks. Solves **context rot** — the quality degradation that happens when a single agent accumulates hundreds of tool call results, failed attempts, and intermediate states alongside actual task context. The fix is architectural: keep orchestrators lean, give executors a fresh window.

**The pattern:**

```
Orchestrator context budget: ~15%
Each executor context budget: 100% fresh (separate Task invocation)

Step 1: Analyze all plans, build dependency graph
Step 2: Group into waves based on dependencies
Step 3: Execute wave by wave (sequential), parallel within each wave

Example:
  Wave 1 (parallel): Plan A + Plan B   ← no dependencies
  Wave 2 (parallel): Plan C + Plan D   ← C needs A, D needs B
  Wave 3 (sequential): Plan E          ← needs C + D
```

**Key design rules:**

- **Orchestrator stays lean.** Discovers plans, analyzes dependencies, spawns agents, collects results — no implementation work itself.
- **Executors are disposable.** Each gets a fresh context window. They load only what they need for their plan.
- **Vertical slices parallelize better than horizontal layers.**
  - Good: `"Plan 01: User registration end-to-end (model → API → UI)"`
  - Bad: `"Plan 01: All models / Plan 02: All APIs / Plan 03: All UI"`
  - Horizontal plans create cascading dependencies (one long Wave 1 → Wave 2 → Wave 3). Vertical slices can all run in Wave 1.
- **File conflict prevention.** Plans in the same wave must not touch the same files. If they do, move one to a later wave or merge the plans.

**Plan-Checker Loop (quality gate before execution):**

Before executing, verify plans actually achieve phase goals. Prevents expensive executor runs on under-specified plans.

```
1. Spawn planner → produces PLAN.md files
2. Spawn plan-checker → verifies: "Do these plans achieve the phase's stated goals?"
3. If FAIL: return feedback to planner → revise → recheck (max 3 iterations)
4. On PASS: proceed to wave execution
```

**XML Task Format:**

Structured XML is more reliably followed by Claude than prose instructions. Use for complex multi-task plans where precision matters:

```xml
<task type="auto">
  <name>Create login endpoint</name>
  <files>src/app/api/auth/login/route.ts</files>
  <action>
    Use jose for JWT (not jsonwebtoken — CommonJS issues).
    Validate credentials against users table.
    Return httpOnly cookie on success.
  </action>
  <verify>curl -X POST localhost:3000/api/auth/login returns 200 + Set-Cookie</verify>
  <done>Valid credentials return cookie, invalid return 401</done>
</task>
```

Fields:
- `name` — task identifier
- `files` — exact files to create/modify (reduces hallucinated paths)
- `action` — precise instructions with specifics (library choices, constraints, anti-patterns)
- `verify` — how to confirm the task worked (shell command, observable behavior)
- `done` — definition of done (expected observable outcome)

### Pillar 6: Skills and Plugins

**Skills** = reusable workflows with SKILL.md + optional scripts/templates/references.

**Plugins** = distributable packages of skills, hooks, agents, and MCP servers.

**Skill locations:**
- `~/.claude/skills/` — User-global
- `.claude/skills/` — Project-level
- Plugin `skills/` directory — Per plugin

**`${CLAUDE_SKILL_DIR}` variable (v2.1.69):** Skills can self-reference their own directory in SKILL.md content. Critical for skills with reference files, templates, or scripts. Example: `See ${CLAUDE_SKILL_DIR}/references/color-palette.md`.

**Universal SKILL.md format:** The same skill files work across Claude Code, Cursor, Gemini CLI, Codex CLI, Antigravity IDE, and 33+ other agents. Write once, use everywhere.

**Skill installation (standardized):**

```powershell
# Official Anthropic skills
npx skills add anthropics/claude-code --skill frontend-design

# Third-party skills (by GitHub repo)
npx skills add browser-use/claude-skill
npx skills add coleam00/excalidraw-diagram-skill --skill excalidraw-diagram

# Antigravity Awesome Skills (1,234+ skills, one command)
npx antigravity-awesome-skills --claude

# List installed skills
npx skills list

# Reload after adding skills (no restart needed)
/reload-plugins
```

**Plugin management:**

```
/plugin marketplace add anthropics/skills
/plugin add /path/to/skill-directory
/plugin marketplace add obra/superpowers-marketplace
```

**Key community plugins:** obra/superpowers (20+ battle-tested skills), wshobson/agents (preset workflows), anthropics/skills (official examples).

**Antigravity Awesome Skills** (22K+ stars, 3.8K+ forks): The largest cross-compatible skill collection. 1,234+ skills organized by category with role-based bundles (Web Wizard, Security Engineer, Essentials). Key starter skills: `@brainstorming`, `@architecture`, `@debugging-strategies`, `@api-design-principles`, `@security-auditor`, `@create-pr`.

**Skill discovery sites:** [aitmpl.com/skills](https://www.aitmpl.com/skills), [skills.sh](https://skills.sh) — updated daily with new skills across the ecosystem.

**Notable skills worth tracking:**

| Skill | What It Does |
|-------|-------------|
| **Frontend Design** (277K+ installs) | Breaks "distributional convergence" — bold design instead of generic AI aesthetic |
| **Browser Use** | Live browser automation — navigate, click, fill forms, screenshot |
| **Remotion** | React-based programmatic video creation (demos, explainers) |
| **Shannon** | Autonomous AI pen testing — 96% exploit success rate, 50+ vulnerability types |
| **Excalidraw** | Architecture diagrams from natural language with self-validation rendering loop |
| **Valyu** | Real-time search across 36+ data sources (SEC, PubMed, FRED, patents) |

#### Advanced: Event-Driven Skill Injection (Skill Switchboard)

The default skill activation model requires manual slash-command invocation. After context compaction, skills are forgotten entirely. The **Skill Switchboard** pattern solves this by wiring a `PreToolUse` hook that reads the file being edited and injects the relevant skill automatically — zero manual invocation required.

**Concept** (inspired by Agent RuleZ by SpillwaveSolutions):
- Static skill lists = ignored after compaction
- Event-driven injection = deterministic, always-on, zero cognitive load
- AND-logic: file extension **+** directory pattern must both match

**Setup (3 files):**

**1. `~/.claude/hooks/skill-switchboard/rules.json`** — define when each skill fires:

```json
{
  "rules": [
    {
      "name": "csharp-coding-standards",
      "enabled": true,
      "priority": 50,
      "matchers": {
        "extensions": [".cs"],
        "directories": ["**/Commands/**", "**/Services/**", "**/Controllers/**"]
      },
      "inject_path": "~/.claude/rules/coding-style.md",
      "max_lines": 120
    },
    {
      "name": "angular-component-standards",
      "enabled": true,
      "priority": 50,
      "matchers": {
        "extensions": [".ts", ".html", ".scss"],
        "directories": ["**/components/**", "**/features/**", "**/store/**"]
      },
      "inject_path": "~/.claude/rules/coding-style.md",
      "max_lines": 120
    },
    {
      "name": "security-sensitive",
      "enabled": true,
      "priority": 100,
      "matchers": {
        "extensions": [".cs"],
        "directories": ["**/Auth/**", "**/Identity/**", "**/Security/**"]
      },
      "inject_path": "~/.claude/rules/security.md",
      "max_lines": 80
    }
  ]
}
```

**2. `~/.claude/hooks/skill-switchboard/switchboard.ps1`** — the engine (reads stdin JSON, matches rules, outputs skill content to Claude's context).

**3. `~/.claude/settings.json`** — wire it as the first PreToolUse hook on `Edit|Write`:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/skill-switchboard/switchboard.ps1\"",
      "timeout": 8000
    }
  ]
}
```

**Key design decisions:**
- `priority` — higher number = injected first (security rules before style rules)
- `max_lines` — truncates large SKILL.md files to keep context lean
- Deduplication — same file injected once even if matched by multiple rules
- Directory patterns support `**/segment/**` glob-style matching
- Hook runs **before** the edit executes — Claude gets context at the right moment

**Five activation patterns (from Agent RuleZ architecture):**

| Pattern | Trigger | Claude Code Hook |
|---------|---------|-----------------|
| **File-based** | Edit/Write on matching extension + directory | `PreToolUse` command |
| **Intent-based** | Natural language mentions migration/auth/etc. | `UserPromptSubmit` prompt |
| **Lifecycle** | Pre-compaction (re-inject skills inventory) | `PreCompact` prompt |
| **Dynamic** | Shell script inspects project state | `PreToolUse` inject_command |
| **Priority** | Critical rules forced to top | `priority` field in rules.json |

**PreCompact skill amnesia fix** — add to your existing PreCompact prompt hook:
```
Before compacting, output a brief "Active Skills Available" section listing which
skills are configured in ~/.claude/hooks/skill-switchboard/rules.json so they
survive compaction.
```

**Reference:** SpillwaveSolutions/agent_rulez on GitHub — comprehensive YAML-based policy engine for Claude Code, OpenCode, and Gemini CLI.

#### Skill Scope Classification: Global vs Project-Level

Every skill installed globally (`~/.claude/skills/`) costs tokens **on every message in every project** — it appears in the system prompt listing regardless of relevance. Project-level skills (`.claude/skills/` in the repo root) only appear when working in that project.

**The rule:** If you wouldn't want a skill listed when working in an unrelated project, it belongs at project level.

**Decision framework:**

| Question | Global | Project |
|----------|--------|---------|
| Useful in any codebase? | ✅ | ❌ |
| Domain-specific (ComfyUI, YouTube, .NET)? | ❌ | ✅ |
| Used < once a month per project? | ❌ | ✅ |
| Workflow skill (commit, review, plan)? | ✅ | ❌ |
| Content/brand/persona for one client? | ❌ | ✅ |

**Global skills — install table:**

These are standalone skills installed into `~/.claude/skills/`. Each has a source repo for reproducible setup.

| Skill | Source | Install |
|-------|--------|---------|
| `claude-code-mastery` | [MCKRUZ/claude-code-mastery](https://github.com/MCKRUZ/claude-code-mastery) | `git clone https://github.com/MCKRUZ/claude-code-mastery ~/.claude/skills/claude-code-mastery` |
| `dashboard-creator` | [mhattingpete/claude-skills-marketplace](https://github.com/mhattingpete/claude-skills-marketplace) | `npx skills add mhattingpete/claude-skills-marketplace --skill dashboard-creator` |
| `demo-video` | [MCKRUZ/demo-video-skill](https://github.com/MCKRUZ/demo-video-skill) | `git clone https://github.com/MCKRUZ/demo-video-skill ~/.claude/skills/demo-video` |
| `docx` | [anthropics/skills](https://github.com/anthropics/skills) | `npx skills add anthropics/skills --skill docx` |
| `excalidraw-diagram-generator` | [coleam00/excalidraw-diagram-skill](https://github.com/coleam00/excalidraw-diagram-skill) | `npx skills add coleam00/excalidraw-diagram-skill` |
| `find-skills` | [anthropics/skills](https://github.com/anthropics/skills) | `npx skills add anthropics/skills --skill find-skills` |
| `functional-design` | [MCKRUZ/functional-design](https://github.com/MCKRUZ/functional-design) | `git clone https://github.com/MCKRUZ/functional-design ~/.claude/skills/functional-design` |
| `humanizer` | [blader/humanizer](https://github.com/blader/humanizer) | `git clone https://github.com/blader/humanizer ~/.claude/skills/humanizer` |
| `llm-cost-optimizer` | [MCKRUZ/llm-cost-optimizer-skill](https://github.com/MCKRUZ/llm-cost-optimizer-skill) | `git clone https://github.com/MCKRUZ/llm-cost-optimizer-skill ~/.claude/skills/llm-cost-optimizer` |
| `pdf` | [anthropics/skills](https://github.com/anthropics/skills) | `npx skills add anthropics/skills --skill pdf` |
| `project-memory` | [SpillwaveSolutions/project-memory](https://github.com/SpillwaveSolutions/project-memory) | `git clone https://github.com/SpillwaveSolutions/project-memory ~/.claude/skills/project-memory` |
| `security-review` | [MCKRUZ/security-review-skill](https://github.com/MCKRUZ/security-review-skill) | `git clone https://github.com/MCKRUZ/security-review-skill ~/.claude/skills/security-review` |
| `shannon` | [KeygraphHQ/shannon](https://github.com/KeygraphHQ/shannon) | `npx skills add unicodeveloper/shannon` |
| `skeptic` | [MCKRUZ/skeptic-skill](https://github.com/MCKRUZ/skeptic-skill) | `git clone https://github.com/MCKRUZ/skeptic-skill ~/.claude/skills/skeptic` |
| `slides` | [MCKRUZ/slides-skill](https://github.com/MCKRUZ/slides-skill) | `git clone https://github.com/MCKRUZ/slides-skill ~/.claude/skills/slides` |
| `tdd-workflow` | [MCKRUZ/tdd-workflow-skill](https://github.com/MCKRUZ/tdd-workflow-skill) | `git clone https://github.com/MCKRUZ/tdd-workflow-skill ~/.claude/skills/tdd-workflow` |
| `visual-explainer` | [nicobailon/visual-explainer](https://github.com/nicobailon/visual-explainer) | `git clone https://github.com/nicobailon/visual-explainer ~/.claude/skills/visual-explainer` |

**Built-in capabilities (not standalone skills — provided by plugins or Claude Code itself):**

| Capability | Source | How to get |
|------------|--------|------------|
| `code-review`, `build-fix`, `refactor-clean` | code-simplifier plugin | `/plugin marketplace add anthropics/claude-code` |
| `plan`, `simplify`, `learn` | code-simplifier plugin | `/plugin marketplace add anthropics/claude-code` |
| `deep-project`, `deep-plan`, `deep-implement` | piercelamb-plugins | `/plugin marketplace add piercelamb/plugins` |
| `ctx-doctor`, `ctx-stats`, `ctx-upgrade` | context-mode plugin | Add marketplace: `mksglu/context-mode`, then enable |
| Status line (project, model, context %) | claude-hud plugin | Add marketplace: `jarrodwatts/claude-hud`, then enable |

**Project-level skills (install only in relevant projects):**

| Skill | Project | Category |
|-------|---------|----------|
| `comfyui-*` (12 skills) | ComfyUI Expert | AI image/video generation |
| `youtube-*` (8 skills), `remotion-best-practices` | ProjectPrism | Video production |
| `matt-kruczek-blog-writer`, `brand`, `banner-design` | personal-brand-assistant | Personal brand |
| `design-system`, `ui-ux-pro-max`, `frontend-design-pro` | ArchitectureHelper, matthewkruczek-ai | Frontend design |
| `consulting-deck`, `sow-writer`, `client-intake` + 5 more | claude-consultant | Consulting |
| `grafana-dashboards` | openclaw-langfuse | Observability |
| `pluralsight-skill` | pluralsight-skill | Course authoring |

**Installing a project-level skill:**

```bash
# From the project root — creates .claude/skills/<skill-name>/
mkdir -p .claude/skills
cp -r ~/.claude/skills/comfyui-workflow-builder .claude/skills/
```

Or symlink (avoids duplication):
```powershell
# PowerShell — requires admin or Developer Mode enabled
New-Item -ItemType SymbolicLink -Path ".claude/skills/comfyui-workflow-builder" -Target "$HOME/.claude/skills/comfyui-workflow-builder"
```

After moving, remove from global to eliminate the system prompt overhead:
```bash
rm -rf ~/.claude/skills/comfyui-workflow-builder
```

**Skill Audit workflow** — when invoked as "audit my skills" or "optimize skill scope":

1. List all skills in `~/.claude/skills/` (global installed)
2. Identify the current project type from CLAUDE.md, package.json, or file patterns
3. Classify each globally-installed skill against the decision framework above
4. Propose a migration plan: which to keep global, which to move to this project, which to move to OTHER projects
5. For skills belonging to other projects not currently open: note them for migration (don't act on other projects without confirmation)
6. Offer to execute the moves for the current project

### Pillar 7: CI/CD and Automation

**Auth CLI (v2.1.41+):**

```powershell
claude auth login    # Authenticate (replaces claude --login)
claude auth status   # Check auth state (useful in CI)
claude auth logout   # Sign out
```

**Headless mode (`-p` / `--print`) — works in PowerShell:**

```powershell
claude -p "Explain the architecture" --output-format json
git diff HEAD~5 | claude -p "Review these changes for bugs"
claude -p "Analyze codebase" --allowedTools "Read,Glob,Grep" --max-turns 10
claude --from-pr 123  # Resume session linked to PR #123
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

**`/loop` for recurring tasks (v2.1.71):**

```powershell
# Run a prompt every 5 minutes
/loop 5m check the deploy status

# Run a slash command on interval (default: 10m)
/loop /babysit-prs
```

Uses CronCreate/CronDelete/CronList scheduling tools. Jobs are session-scoped (gone when Claude exits) and auto-expire after 7 days. Disable with `CLAUDE_CODE_DISABLE_CRON` env var.

**Worktree improvements:**
- `ExitWorktree` tool (v2.1.72): leave worktree sessions mid-conversation (keep or remove)
- `worktree.sparsePaths` setting (v2.1.76): selective directory checkout for monorepos — only clone relevant directories into the worktree

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

**Windows ARM64 support (v2.1.41+):**
- Native `win32-arm64` binary — no emulation required for the CLI
- VS Code extension falls back to x64 via emulation on ARM64 (v2.1.42 fix)
- The `irm https://claude.ai/install.ps1 | iex` installer auto-detects your architecture

**If you get "requires git-bash" error:**

```powershell
# Tell Claude Code where Git Bash lives
[System.Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', 'C:\Program Files\Git\bin\bash.exe', 'User')
# Restart terminal
```

### Windows-Specific Notes

- **Config location:** `~/.claude/settings.json` in your Windows home directory (`C:\Users\<you>\.claude\`)
- **Updates:** Native installer auto-updates. WinGet requires `winget upgrade Anthropic.ClaudeCode` manually.
- **Image paste limitation:** `Win+Shift+S` clipboard paste (Ctrl+V) doesn't work. Use file-based image sharing instead.
- **Managed settings path (BREAKING v2.1.74):** Enterprise managed settings moved from `C:\ProgramData\ClaudeCode\managed-settings.json` to `C:\Program Files\ClaudeCode\managed-settings.json`. The old fallback path was removed.
- **VS Code integration:** Install the Claude Code extension. If it can't find Git Bash, set `CLAUDE_CODE_GIT_BASH_PATH` as a system env var and restart VS Code.
- **Hooks use Git Bash:** All hook commands in settings.json are executed via Git Bash, so use Unix-style commands (not PowerShell cmdlets) in hooks.
- **Windows stability fixes (v2.1.27-2.1.34):** Fixed .bashrc handling, console window flashing, OAuth token expiration, proxy settings, bash sandbox errors, Japanese IME support.

---

## Essential Slash Commands Quick Reference

| Command | When to use |
|---------|------------|
| `/compact` | Context above 70% |
| `/clear` | Between unrelated tasks |
| `/context` | Inspect token usage (now gives actionable suggestions) |
| `/cost` | Check session costs |
| `/init` | New project starter CLAUDE.md |
| `/model` | Switch Sonnet/Opus/Haiku |
| `/effort` | Adjust effort level (low/medium/high) |
| `/resume` | Return to previous session |
| `/plan` | Toggle read-only mode (accepts optional description) |
| `/loop` | Recurring task scheduling (e.g., `/loop 5m check deploy`) |
| `/mcp` | Manage MCP servers within session |
| `/branch` | Fork conversation (was `/fork`) |
| `/color` | Customize session prompt-bar color |
| `/debug` | Ask Claude to diagnose the current session |
| `/rename` | Rename session (auto-generates name if none given) |
| `/reload-plugins` | Activate plugin/skill changes without restart |
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

---

## Reference Files

| File | Contents |
|------|---------|
| `references/knowledge-base.md` | Append-only log of Claude Code discoveries and version changes |
| `references/changelog.md` | What changed in this skill and when |
| `references/settings-templates.md` | Production-ready settings.json templates |
| `references/claude-md-templates.md` | CLAUDE.md templates for common project types |
| `references/troubleshooting.md` | Common issues and fixes |
| `references/rules-directory-pattern.md` | Deep dive on the `.claude/rules/` pattern |
| `references/research-sources.md` | Where to look when researching Claude Code updates |
| `references/spec-driven-development.md` | Goal-backward planning, project artifacts, UAT loop, parallel research team — for multi-session projects |
