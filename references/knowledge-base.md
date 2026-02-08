# Claude Code Knowledge Base

> **Last updated:** 2026-02-07
> **Format:** Append-only log. New entries go at the top with dates. Never delete old entries.

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
