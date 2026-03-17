# Skill Changelog

> Tracks all updates to the claude-code-mastery skill and its knowledge base.

## 2026-03-17 — v1.7.0 (Major Ecosystem Update: v2.1.77, Skills Maturity, Article Analysis)

### Massive Version Catch-Up (v2.1.63 → v2.1.77)

10 releases in 14 days. This is the largest single knowledge base update since v1.0.0.

**What was added/updated:**

**SKILL.md updates across all seven pillars:**
- **Pillar 2** — 1M context window now default (not beta), 64K/128K output tokens, PostCompact context renewal pattern, `/effort` command, `/context` actionable suggestions
- **Pillar 3** — MCP elicitation (servers requesting structured input mid-task), `/mcp` native management command, GWS (Google Workspace) skill added to Tier 3
- **Pillar 4** — Four new hooks documented (InstructionsLoaded, PostCompact, Elicitation, ElicitationResult), new hooks explained section, managed settings path breaking change
- **Pillar 5** — Code Review capability (multi-agent PR review, $15-25/review, 54% substantive comments)
- **Pillar 6** — `${CLAUDE_SKILL_DIR}` variable, universal SKILL.md format (38+ agents), `npx skills add` standardized installation, Antigravity Awesome Skills (1,234+ skills, 22K stars), skill discovery sites, notable third-party skills table
- **Pillar 7** — `/loop` recurring tasks with CronCreate, ExitWorktree tool, `worktree.sparsePaths` for monorepos
- **Slash commands table** — Added 6 new commands (/effort, /loop, /mcp, /branch, /color, /reload-plugins)
- **Windows notes** — Added managed settings path breaking change (v2.1.74)

**Knowledge base:**
- Full version history table v2.1.68 through v2.1.77
- New hooks table with versions and purposes
- New slash commands table with versions
- Breaking changes documented (Opus 4/4.1 removed, /output-style deprecated, Windows managed settings, /fork→/branch)
- MCP elicitation deep dive
- Code Review launch details
- Skills ecosystem maturity analysis (npx skills v7.3.0, Antigravity, discovery sites)
- Notable third-party skills from article (Frontend Design, Browser Use, GWS, Valyu, Shannon, PlanetScale, Excalidraw)
- Key concepts: distributional convergence, self-validation loops, PostCompact context renewal
- Community insights (Reddit analysis, usage promotion)
- MCP 2026 roadmap summary

### Article Analysis: "10 Must-Have Skills for Claude Code" (unicodeveloper, March 9 2026)

Skills tracked and integrated into knowledge base. Key takeaways incorporated:
- Universal SKILL.md cross-agent format awareness added to Pillar 6
- Standardized `npx skills add` installation workflow added
- Antigravity Awesome Skills as the largest skill library documented
- Skill discovery sites (aitmpl.com/skills, skills.sh) referenced
- "Distributional convergence" concept documented as design quality insight

### Breaking Changes Awareness
- Opus 4 and 4.1 removed from Claude Code (v2.1.68)
- `/output-style` deprecated → use `/config` (v2.1.73)
- Windows managed settings path changed (v2.1.74)
- `/fork` renamed to `/branch` (v2.1.77, backward-compatible)

---

## 2026-03-03 — v1.6.0 (GSD Extraction: Wave Execution & Spec-Driven Development)

### New: Wave Execution Orchestration (Pillar 5 addition)

Extracted from analysis of the GSD (get-shit-done) system (23.9k stars). The most concrete multi-agent execution pattern in the community. Named and solved the "context rot" problem architecturally.

**What was added:**
- **SKILL.md Pillar 5** — New "Wave Execution Orchestration" subsection covering: wave pattern, orchestrator budget rule (15%), executor fresh context rule (100%), dependency-graph wave grouping, vertical vs. horizontal slice design principle, file conflict prevention, plan-checker loop, XML task format
- **knowledge-base.md** — New 2026-03-03 entry: context rot definition, wave execution pattern, plan-checker loop, XML task format
- **references/spec-driven-development.md** — New reference file: goal-backward planning, project artifact set (PROJECT.md etc.), user decision fidelity protocol (discuss → lock → honor), parallel research team pattern, brownfield codebase mapping, UAT verify loop, atomic git commits per task
- **SKILL.md** — Added Reference Files table at the bottom linking to all reference files including the new spec-driven-development.md

**Source:** GSD system at github.com/gsd-build/get-shit-done — analyzed for extractable patterns compatible with this skill's configuration-focused approach.

## 2026-03-03 — v1.5.0 (Double Shot Latte Hook)

### New: Double Shot Latte (DSL) Autonomous Continue Hook

Inspired by Jesse Vincent's Superpowers framework. When Claude is mid-task and stops to check in unnecessarily, DSL evaluates whether human input is actually needed and instructs Claude to continue autonomously if not.

**What was added:**
- `hooks/dsl/double-shot-latte.ps1` — PowerShell state tracker (stop event log, throttle detection, writes CONTINUE/THROTTLED to decision.txt)
- **SKILL.md Pillar 4** — Added full DSL architecture documentation with code examples and key gotchas
- **knowledge-base.md** — Added 2026-03-03 DSL entry documenting design decisions, files, and implementation insights
- **settings-templates.md** — Added "Power User — Autonomous Sessions with DSL Hook" template

**Three-hook architecture:**
1. `UserPromptSubmit` command hook: resets state.json on every user message (prevents false throttles)
2. `Stop` command hook: tracks stop events, writes CONTINUE/THROTTLED to decision.txt
3. `Stop` prompt hook: Claude reads decision.txt and decides whether to continue or wait

**Key insight:** The UserPromptSubmit reset is essential — without it, normal conversational stops (end of each response turn) accumulate and falsely trigger the throttle during regular interactive sessions.

---

## 2026-03-03 — v1.4.0 (Hook Architecture & Bug Fixes)

### Bug Fixes
- **Fixed GitHub MCP templates** in `settings-templates.md`: replaced broken `https://api.githubcopilot.com/mcp/` HTTP endpoint with correct `@modelcontextprotocol/server-github` npm + PAT config across all 4 template variants (Minimal, Standard, Full Stack, Frontend)
- **Corrected 2026-02-09 knowledge-base entry**: `@modelcontextprotocol/server-github` is NOT deprecated for Claude Code users — the HTTP endpoint doesn't work, the npm package does
- **Updated MCP context warning** in troubleshooting: the "20K token limit" is now largely obsolete thanks to MCP Tool Search (v2.1.x+)

### New Hook Architecture Documentation
- **Added `SessionStart:startup hook error` troubleshooting section** — cause, symptom, and fix for `type: "prompt"` hook failures with custom `ANTHROPIC_BASE_URL`
- **Added Stop hook communication limitation** — documented that command hooks at Stop cannot communicate back to Claude; solution is `type: "prompt"` hooks
- **Added global PreCompact path antipattern** — hardcoded project paths in global hooks silently fail for other projects
- **Updated SKILL.md Pillar 4 hook events list** — added SessionStart, PreCompact; added agent and http hook types
- **Added hook gotchas block** to SKILL.md with four critical rules

### Knowledge Base
- Added 2026-03-03 hook architecture entry (real-world debugging findings)
- Updated current version to v2.1.63

---

## 2026-03-03 — v1.3.0 (Event-Driven Skill Injection)

### New: Skill Switchboard Pattern (Pillar 6 extension)
- **Added "Event-Driven Skill Injection" sub-section** to Pillar 6 (Skills and Plugins)
- Documents the Skill Switchboard architecture: `rules.json` + `switchboard.ps1` + PreToolUse hook
- Covers all five activation patterns (file-based, intent-based, lifecycle, dynamic, priority)
- Includes complete `rules.json` schema with real C#/Angular examples
- Includes `settings.json` wiring snippet
- Documents PreCompact skill amnesia fix pattern
- References Agent RuleZ (SpillwaveSolutions) as the upstream concept source

### Knowledge Base
- Added 2026-03-03 entry covering the Skill Gap problem, switchboard architecture, five activation patterns, and real-world rules for C#/Angular/ComfyUI stack

---

## 2026-02-18 — v1.2.0 (Knowledge Base Update)

### Knowledge Base Updates
- **Added Claude Sonnet 4.6** entry: Released Feb 17, 70% user preference over Sonnet 4.5 in Claude Code, much-improved coding skills, human-level computer use, 64K output, extended thinking, dynamic web search filtering
- **Added version history table** v2.1.38 through v2.1.45 with key changes per release
- **Added Windows ARM64 native support** docs (v2.1.41+): native `win32-arm64` binary, VS Code emulation fallback
- **Added Auth CLI commands** (`claude auth login/status/logout`): replaces old `--login` pattern
- **Added MCP Tool Search** section: lazy loading that reduces context 85-95%, makes the "20K MCP limit" rule largely obsolete
- **Added PR integration features**: `--from-pr` flag, auto-linking sessions to PRs
- **Added MCP OAuth pre-configured credentials** for servers without Dynamic Client Registration
- **Added new slash commands**: `/debug`, "Summarize from here" in message selector
- **Updated Agent Teams status**: still experimental, Bedrock/Vertex/Foundry teammates fixed in v2.1.45
- **Updated current version**: v2.1.45 (was v2.1.37)

### Breaking Change Awareness
- Sonnet 4.6 is now the recommended default model for Claude Code (was Sonnet 4.5)
- `claude auth login` replaces `claude --login` pattern in new tooling/scripts

---

## 2026-02-09 — v1.1.0 (MCP & Hook Fixes)

### Bug Fixes (from real-world debugging session)
- **Fixed all hook templates:** Replaced invalid `$file` variable with `$CLAUDE_FILE_PATH` across SKILL.md, settings-templates.md
- **Fixed all hook templates:** Removed bash-style `2>/dev/null || true` redirects, added explicit `timeout` values
- **Fixed MCP setup commands:** Added `cmd /c` wrapper for Windows in all `claude mcp add` examples
- **Fixed Context7 package name:** Documented that `@context7/mcp-server` is invalid, correct is `@upstash/context7-mcp`

### New Documentation
- **Troubleshooting:** Added "Claude Code hangs on startup / can't type" section with step-by-step diagnosis
- **Troubleshooting:** Added "Found N invalid settings files" section
- **Troubleshooting:** Added "Two config files define MCP servers" explanation (`.claude.json` vs `settings.json`)
- **Knowledge Base:** Added 2026-02-09 entry documenting all MCP, hook, and TUI discoveries
- **Settings Templates:** Added Windows-specific notes about `cmd /c` wrapper and `.claude.json` vs `settings.json`

### Dead Package Registry
- Documented `@anthropic/mcp-server-dotnet` as non-existent (npm 404)
- Documented `@context7/mcp-server` as non-existent (npm 404)
- Documented `@modelcontextprotocol/server-github` as deprecated

---

## 2026-02-07 — v1.0.0 (Initial Release)

### Knowledge Base
- Established baseline snapshot covering all seven pillars
- Documented Claude Code v2.1.34, Opus 4.6, Agent Teams research preview
- Cataloged MCP ecosystem state (74.9k+ stars on awesome-mcp-servers)
- Captured community-validated CLAUDE.md best practices
- Documented all known gotchas and limitations
- Windows/PowerShell native focus (no WSL2 content)

### Skill Structure
- Created SKILL.md with seven-pillar architecture
- Created self-updating research mechanism (knowledge-base + research-sources + research-checklist)
- Created CLAUDE.md template generator reference (TypeScript, Python, C#, Monorepo)
- Created settings.json template reference (Windows-specific)
- Created troubleshooting guide (Windows-specific)

### Research Infrastructure
- Established four-tier research source hierarchy
- Created systematic research checklist protocol
- Defined research cadence (weekly/bi-weekly/monthly/on-demand)
- Created web search query templates for updates
