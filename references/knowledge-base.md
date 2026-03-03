# Claude Code Knowledge Base

> **Last updated:** 2026-03-03
> **Format:** Append-only log. New entries go at the top with dates. Never delete old entries.

---

## 2026-03-03 — Hook Architecture Findings, v2.1.63, GitHub MCP Clarification

### Current Version: v2.1.63
(Up from v2.1.45 documented 2026-02-18)

### Hook Architecture: Critical Findings from Real-World Debugging

#### `type: "prompt"` at SessionStart fails with custom `ANTHROPIC_BASE_URL`
When `ANTHROPIC_BASE_URL` is set to a custom proxy (LiteLLM, local gateway, etc.), `type: "prompt"` hooks make LLM evaluation calls through that proxy. Incompatible proxy responses cause the hook to fail with `SessionStart:startup hook error` shown in the UI header, even though command hooks in the same group succeed.

**Symptom:** UI shows `SessionStart:startup hook error` while `SessionStart:startup hook success: Success` also appears (from the successful command hook in the same group).

**Fix:** Remove `type: "prompt"` hooks from SessionStart entirely. The command hook's stdout is already injected into the conversation as a system-reminder — no prompt hook is needed for context injection.

**Rule:** Only use `type: "prompt"` SessionStart hooks when you have a standard Anthropic API connection (no custom proxy).

#### `type: "command"` Stop hooks cannot communicate back to Claude
Stop hooks fire after Claude has finished its last response. Command hook stdout goes to the terminal only — Claude is done and cannot act on it.

**Use case that works:** File operations (creating session logs, Langfuse tracing, VS Code notifications) — these don't need Claude. Fine as command hooks.

**Anti-pattern:** Using a command hook at Stop to print "evaluate session for extractable patterns" — Claude can't read it and can't respond.

**Fix:** For end-of-session Claude work, use `type: "prompt"` Stop hooks. These inject a prompt that Claude processes before fully stopping:

```json
{
  "hooks": [{
    "type": "prompt",
    "prompt": "This session is ending. If this session had 10 or more meaningful exchanges and surfaced reusable patterns or architectural insights, call mcp__cmem__save_lesson for each one."
  }]
}
```

#### Global PreCompact prompt hooks: never hardcode project-specific paths
A PreCompact prompt hook in the user-level `settings.json` runs for ALL projects. Hardcoding a specific project's MEMORY.md path (e.g., `C:\Users\you\.claude\projects\my-project\memory\MEMORY.md`) silently fails for every other project.

**Fix:** Use project-agnostic instructions: "Update your project's MEMORY.md — the path is shown in your system instructions (auto-memory section)." Claude Code injects the current project's auto-memory path at session start, so Claude knows where to look.

### GitHub MCP Clarification: npm package is still the correct approach

**Correction to 2026-02-09 entry:** The statement that `@modelcontextprotocol/server-github` is "deprecated" was incorrect for Claude Code users.

| Approach | Works with Claude Code? | Notes |
|---------|------------------------|-------|
| `npx @modelcontextprotocol/server-github` + PAT | ✅ Yes | Use this |
| `https://api.githubcopilot.com/mcp/` HTTP endpoint | ❌ No | "Incompatible auth server: does not support dynamic client registration" |

The HTTP endpoint requires GitHub Copilot OAuth which uses incompatible Dynamic Client Registration. The npm package with a Personal Access Token works reliably.

**Correct GitHub MCP config for Claude Code:**
```json
"github": {
  "type": "stdio",
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "your-pat-here"
  }
}
```

### Research Tracking Update
| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-03-03 | SessionStart prompt hook | Real-world debugging | Fails with custom ANTHROPIC_BASE_URL proxy |
| 2026-03-03 | Stop command hooks | Real-world debugging | Can't communicate back to Claude; use prompt type instead |
| 2026-03-03 | PreCompact prompt paths | Real-world debugging | Hardcoded paths silently fail for other projects |
| 2026-03-03 | GitHub MCP HTTP endpoint | Real-world debugging | Confirmed: does not work with Claude Code, use npm package |
| 2026-03-03 | v2.1.63 | Status bar | Current version as of 2026-03-03 |

---

## 2026-03-03 — Event-Driven Skill Injection (Skill Switchboard Pattern)

### The Skill Gap Problem
Static skill lists in CLAUDE.md or SessionStart hooks fail at scale because:
- Context compaction drops older static lists to make room for active work
- All skills loaded equally regardless of what's being worked on (irrelevant noise)
- Developer must manually invoke skills at exactly the right time (cognitive load)

**Source:** Rick Hightower / SpillwaveSolutions — "The End of Manual Agent Skill Invocation" (Medium, Feb 23, 2026). References a January 2026 Vercel study confirming agents only activate the right skills 79% of the time without deterministic injection.

### The Skill Switchboard Solution
A `PreToolUse` hook intercepts every `Edit`/`Write` event, reads the file path from stdin JSON, and injects relevant skill content into Claude's context before the tool executes. No slash commands required.

**Architecture:**
- `rules.json` — maps file extensions + directory glob patterns to skill files
- `switchboard.ps1` — PowerShell engine: reads stdin, matches rules, outputs skill content
- AND-logic matching: extension **and** directory pattern must both match
- Priority field: higher number = injected first (100 = security, 50 = coding style)
- Deduplication: same skill file never injected twice in one edit event
- `max_lines` truncation: keeps large SKILL.md files from blowing context budget

**Five activation patterns:**
1. **File-based** — PreToolUse on Edit/Write (core pattern)
2. **Intent-based** — UserPromptSubmit prompt matching natural language
3. **Lifecycle** — PreCompact hook re-injects skill inventory (prevents amnesia)
4. **Dynamic** — inject_command shell script inspects project state
5. **Priority** — high-priority rules (security) injected before general rules

**Real-world rules for C#/Angular stack:**
- `.cs` in `**/Commands/**`, `**/Services/**`, `**/Controllers/**` → coding-style.md
- `.ts/.html/.scss` in `**/components/**`, `**/features/**` → coding-style.md
- `.cs` in `**/Auth/**`, `**/Identity/**` → security.md (priority 100)
- `.json` in `**/workflows/**` → comfyui-character-gen SKILL.md
- `.html` in `**/.agent/diagrams/**` → dashboard-creator SKILL.md

**Repo:** SpillwaveSolutions/agent_rulez (supports Claude Code, OpenCode, Gemini CLI)

---

## 2026-02-18 — Claude Sonnet 4.6, Windows ARM64, Auth CLI, MCP Tool Search

### Claude Sonnet 4.6 Released (Feb 17, 2026)
- Model ID: `claude-sonnet-4-6` — now added to Claude Code in **v2.1.45**
- **70% user preference** over Sonnet 4.5 in Claude Code tasks
- Better reads full context before modifying code; consolidates shared logic instead of duplicating
- Human-level computer use capability (spreadsheets, multi-step web forms across browser tabs)
- 200K context window (1M in beta), 64K max output tokens, extended + adaptive thinking
- Web search / web fetch tools now support **dynamic filtering** — Claude writes code to filter results before they hit context
- Free tier users now get: file creation, connectors, skills, and compaction

### Version History Since v2.1.37 (as of 2026-02-18)
| Version | Date | Key Changes |
|---------|------|------------|
| **v2.1.45** | Feb 17 | Sonnet 4.6 support, `spinnerTipsOverride` setting, SDK rate limit types, Agent Teams fixed on Bedrock/Vertex/Foundry, Task tool crash fixed, startup perf improved (no eager history load), memory improved for large shell output |
| **v2.1.44** | Feb 16 | Fixed auth refresh errors |
| **v2.1.42** | Feb 13 | Fixed `/resume` showing interrupt messages as titles, fixed Opus 4.6 launch announcement for Bedrock/Vertex/Foundry, improved image dimension error messages |
| **v2.1.41** | Feb 13 | **Windows ARM64 native binary** (`win32-arm64`), `claude auth login/status/logout` CLI subcommands, fixed AWS auth refresh hanging (3-min timeout), `/rename` now auto-generates session names |
| **v2.1.39** | Feb 10 | Improved terminal rendering performance, fixed fatal errors being swallowed, fixed process hanging after session close |
| **v2.1.38** | Feb 10 | Fixed VS Code terminal scroll-to-top regression, Tab key queueing slash commands instead of autocompleting, text disappearing between tool uses |

**Current latest:** v2.1.45

### New CLI Auth Commands (v2.1.41)
```powershell
claude auth login    # Authenticate with Anthropic
claude auth status   # Check current auth state
claude auth logout   # Sign out
```
Replaces the old `claude --login` pattern. Useful for scripting and CI/CD.

### Windows ARM64 Native Support (v2.1.41-42)
- Native `win32-arm64` binary shipped in v2.1.41
- VS Code extension falls back to x64 via emulation on ARM64 (v2.1.42 fix)
- Install via `irm https://claude.ai/install.ps1 | iex` — auto-detects ARM64

### MCP Tool Search — Lazy Loading (shipped ~January 2026, v2.1.x)
**Major feature** that obsoletes the "20K token MCP limit" rule:
- Triggered automatically when total MCP tool definitions exceed **10K tokens**
- Loads a lightweight search index instead of all tool schemas upfront
- Claude receives a `Tool Search` tool and fetches 3-5 relevant tools (~3K tokens) on demand
- **Result:** Context reduced from ~77K tokens → ~8.7K tokens (85-95% reduction)
- You can now run many MCP servers without the crippling context overhead
- Old advice: "If using >20K tokens of MCPs, you're crippling Claude" — **now largely moot** with Tool Search enabled

### New Slash Commands & UI Additions
| Command/Feature | Since | Purpose |
|----------------|-------|---------|
| `/debug` | ~Feb 2026 | Asks Claude to troubleshoot the current session |
| `Summarize from here` | ~Feb 2026 | Message selector option for partial conversation summarization |
| `/rename` (improved) | v2.1.41 | Now auto-generates session names if none provided |

### PR Integration Features (~Feb 2026)
- `--from-pr` flag: Resume a session linked to a specific PR
- Auto-linking: Sessions auto-link to PRs created via `gh pr create` within the session

### MCP OAuth Pre-configured Credentials
For MCP servers that don't support Dynamic Client Registration (e.g., Slack):
```bash
claude mcp add slack --client-id <id> --client-secret <secret> -- npx @slack/mcp-server
```
The `--client-id` and `--client-secret` flags store OAuth credentials for the server.

### Agent Teams Status (as of Feb 2026) — Still Experimental
Confirmed limitations still active:
- In-process teammates are **not restored** when using `/resume` or `/rewind` — lead may message teammates that no longer exist
- Teammates sometimes forget to mark tasks as completed — check manually if stuck
- A lead manages one team at a time — clean up current team before starting another
- Bedrock/Vertex/Foundry teammates failing — **fixed in v2.1.45**

### Research Tracking Update
| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-02-18 | Sonnet 4.6 | Anthropic blog | Released Feb 17; 70% preference over Sonnet 4.5 in Claude Code |
| 2026-02-18 | v2.1.45 | GitHub releases | Sonnet 4.6, startup perf, Task tool crash fix |
| 2026-02-18 | v2.1.41 | GitHub releases | Windows ARM64, auth CLI commands |
| 2026-02-18 | MCP Tool Search | Web research | 85-95% context reduction, lazy loading since Jan 2026 |
| 2026-02-18 | Auth CLI | GitHub releases | claude auth login/status/logout in v2.1.41 |

---

## 2026-02-09 — MCP & Hook Configuration Fixes (Real-World Debugging)

### Critical Discovery: Two Config Files for MCP Servers
Claude Code uses **two separate files** for MCP server configuration:
- `~/.claude/settings.json` — The main settings file (hooks, permissions, env, mcpServers)
- `~/.claude.json` — The Claude Code state file (also contains `mcpServers` at the bottom)

Both files can define MCP servers, and both are loaded. `claude doctor` only flags issues in `.claude.json`, not `settings.json`. When troubleshooting MCP issues, check **both files**.

### Windows MCP Server Fix: `cmd /c` Wrapper Required
On Windows, MCP servers using `npx` as the command **must** be wrapped with `cmd /c`:

**Broken (hangs on startup):**
```json
{
  "command": "npx",
  "args": ["-y", "@upstash/context7-mcp"]
}
```

**Fixed:**
```json
{
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@upstash/context7-mcp"]
}
```

This applies to all stdio-based MCP servers in `.claude.json`. Servers defined in `settings.json` with `"command": "npx"` appear to work without the wrapper (Claude Code may handle this internally), but `.claude.json` entries require it.

### Dead MCP Packages (Will Hang Startup)
These packages do **not exist** on npm and will cause Claude Code to hang indefinitely during startup:
- `@anthropic/mcp-server-dotnet` — Does not exist. No official Anthropic .NET MCP server.
- `@context7/mcp-server` — Wrong package name. The correct package is `@upstash/context7-mcp`.
- `@modelcontextprotocol/server-github` — Still works but is **deprecated**. Use the HTTP endpoint `https://api.githubcopilot.com/mcp/` instead.

### Hook Variable Fix: `$file` → `$CLAUDE_FILE_PATH`
Project-level hooks using `$file` as a variable placeholder is **not valid**. The correct environment variable is `$CLAUDE_FILE_PATH`:

**Broken:**
```json
{ "type": "command", "command": "npx prettier --write $file 2>/dev/null || true" }
```

**Fixed:**
```json
{ "type": "command", "command": "npx prettier --write \"$CLAUDE_FILE_PATH\"", "timeout": 10000 }
```

Note: `2>/dev/null || true` bash redirects should also be removed from hook commands as they can cause issues. Add explicit `timeout` values instead.

### TUI Input Focus Bug on Windows
When launching Claude Code interactively (`claude` or `claude -c`), the TUI input may appear ready but not accept keystrokes. Pressing `Enter` once gives the TUI input focus and allows typing. This is a known quirk, particularly when launching from PowerShell with slow-loading profiles.

### `claude doctor` — The Diagnostic Command
- The command is `claude doctor` (no dashes), not `claude --doctor`
- It checks MCP server configurations and reports warnings
- It only checks `.claude.json` MCP servers, not `settings.json` MCP servers
- Run it whenever you see "Found N invalid settings files" in the status bar

### Updated Version Info
- **Claude Code CLI:** v2.1.37 (up from v2.1.34)
- Opus 4.6 now shown as default model with "Claude Max" tier
- $50 free extra usage promotion active

### Research Tracking Update
| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-02-09 | MCP cmd /c wrapper | Real-world debugging | Windows requires cmd /c for npx in .claude.json |
| 2026-02-09 | Dead MCP packages | npm registry test | @anthropic/mcp-server-dotnet and @context7/mcp-server are 404 |
| 2026-02-09 | Hook variables | Real-world debugging | $file is invalid, use $CLAUDE_FILE_PATH |
| 2026-02-09 | Two config files | Real-world debugging | .claude.json and settings.json both define mcpServers |
| 2026-02-09 | TUI focus bug | Real-world debugging | Press Enter to give TUI input focus on Windows |

---

## 2026-02-07 — Initial Knowledge Snapshot

### Current Versions
- **Claude Code CLI:** v2.1.34 (latest as of today)
- **Claude Opus 4.6:** Latest model, 1M token context in beta, top Terminal-Bench 2.0 scores
- **Claude Sonnet 4.5:** Balanced model, recommended for teammates/subagents
- **Claude Haiku 4.5:** Fast/cheap model, good for linting hooks and quick subagent tasks
- **Claude Agent SDK:** v0.2.34 (Python: `claude-agent-sdk`, TypeScript: `@anthropic-ai/claude-agent-sdk`)

### Agent Teams (Research Preview)
- Launched Feb 5, 2026 in v2.1.32 alongside Opus 4.6
- v2.1.33 (Feb 6): Fixed tmux messaging bugs, added TeammateIdle/TaskCompleted hooks, `memory` frontmatter
- v2.1.34 (Feb 7): Fixed crash when agent teams settings changed between renders
- Still behind `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` flag
- 7x token multiplier when teammates run in plan mode (~5x general usage)
- Anthropic stress test: 16 agents, 2 weeks, 2B input tokens, 140M output tokens, $20,000
- **No file locking** — the critical gotcha that burns everyone
- Best pattern: adversarial (implement + review agents)
- Split by feature, not by layer — backend changes often need frontend reflection

### Skills System
- Skills replaced legacy commands as recommended approach
- Support frontmatter configuration, model selection, shell preprocessing
- Follow Agent Skills open standard (works across multiple AI tools)
- Progressive disclosure: ~100 tokens for metadata -> <5K tokens for full instructions -> resources on demand
- Locations: `~/.claude/skills/`, `.claude/skills/`, plugin directories
- Live change detection when added via `--add-dir`

### Plugin System
- Launched December 2025 with 36 curated plugins
- Marketplace-style distribution of skills, hooks, agents, and MCP servers
- Key plugins: obra/superpowers (20+ skills), anthropics/skills (official)

### Auto Memory
- Records and recalls learnings across sessions without manual configuration
- Complements CLAUDE.md with session-derived insights

### MCP Ecosystem
- GitHub MCP: Official Go-based server, remote HTTP with OAuth
- Context7: Universally praised, solves hallucinated API problem
- Sentry, Playwright, PostgreSQL, Memory servers all mature
- awesome-mcp-servers repository: 74.9k stars
- Community rule: "If using >20K tokens of MCPs, you're crippling Claude"

### CLAUDE.md Best Practices (Community-Validated)
- Under 3,000-5,000 tokens (Arize AI: ~11% better output from optimization)
- ~150-200 instruction following capacity; system prompt consumes ~50
- `.claude/rules/` directory with path-scoped frontmatter for domain-specific rules
- `@file` imports embed entire file every session — use sparingly
- Negative-only rules cause agent to get stuck; always provide alternatives
- Subdirectory CLAUDE.md files load on-demand when Claude reads files in that subtree

### Context Window Management
- Standard: 200K tokens; Beta: 1M for Opus 4.6 and Sonnet 4.5
- Auto-compaction triggers at 75-92%
- `/compact` with directives preserves specific context
- Subagents for exploration (separate context windows)
- Monitor at 70% usage proactively

### Hooks System
- Events: PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, UserPromptSubmit, Stop, SubagentStop, Notification, Setup, TeammateIdle, TaskCompleted
- Types: `command` (shell) and `prompt` (LLM-based via Haiku)
- PostToolUse + Write matcher = auto-formatting on save

### CI/CD Integration
- Headless mode: `-p`/`--print` with `--output-format json`
- GitHub Actions: `anthropics/claude-code-action@v1`
- `/install-github-app` for quick setup
- Multi-turn headless via `--resume "$session_id"`

### Cost Management
- Average single-agent session: ~$6/developer/day ($100-200/month with Sonnet)
- 5-agent team: ~$30-42/day
- Sonnet for implementation, Opus for planning/lead
- `MAX_THINKING_TOKENS=8000` for simpler teammate tasks
- Rate limits: ~20K TPM per user recommended for org of ~200

### Windows Native Setup
- Claude Code runs natively on Windows since v2.x (2025)
- Requires Git Bash under the hood (Git for Windows must be installed)
- Launch from PowerShell or CMD; shell operations use Git Bash internally
- Install: `irm https://claude.ai/install.ps1 | iex` (PowerShell as Admin)
- Or via WinGet: `winget install Anthropic.ClaudeCode` (no auto-update)
- Binary location: `C:\Users\<user>\.local\bin\claude.exe`
- Config location: `C:\Users\<user>\.claude\settings.json`
- Common issue: PATH not set after install -> add `.local\bin` manually
- Common issue: "requires git-bash" error -> set `CLAUDE_CODE_GIT_BASH_PATH` env var
- Image paste (Win+Shift+S -> Ctrl+V) doesn't work; use file-based sharing
- Windows stability fixes in v2.1.27-2.1.34: .bashrc handling, console flashing, OAuth, proxy, sandbox, IME
- Hooks execute via Git Bash, so use Unix-style commands in hook definitions
- VS Code extension may need `CLAUDE_CODE_GIT_BASH_PATH` system env var

### Enterprise Deployments
- Used at scale by Uber, Salesforce, Spotify, Rakuten
- Managed settings override all other levels
- `/etc/claude-code/CLAUDE.md` for org-wide standards

### Known Issues & Gotchas
- Custom agents in `.claude/agents/` sometimes not recognized (#18212, #4728, #9930)
- Particularly on Linux ARM and certain plugin configurations
- Split panes don't work in VS Code integrated terminal, Windows Terminal, or Ghostty
- Agent Teams: no session resumption, no file conflict resolution, no nested team support
- Agent Teams: tmux required for split-pane mode

---

## Research Tracking

| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-02-07 | Initial snapshot | Official docs + community | Baseline established |
