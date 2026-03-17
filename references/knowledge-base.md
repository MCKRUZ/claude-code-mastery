# Claude Code Knowledge Base

> **Last updated:** 2026-03-17
> **Format:** Append-only log. New entries go at the top with dates. Never delete old entries.

---

## 2026-03-17 — Massive Release Sprint (v2.1.68–v2.1.77), Skills Ecosystem Maturity, Article Analysis

### Version History: v2.1.68 through v2.1.77

| Version | Date | Key Changes |
|---------|------|-------------|
| **v2.1.77** | Mar 17 | 64K default output tokens (128K upper bound), `allowRead` sandbox setting, `/fork` renamed to `/branch`, skill character budget scales with context (2%), 45% faster `--resume` |
| **v2.1.76** | Mar 14 | **MCP elicitation** (servers request structured input mid-task), `Elicitation`/`ElicitationResult` hooks, `PostCompact` hook, `/effort` command, `-n`/`--name` flag, `worktree.sparsePaths` for monorepos, auto-compaction retry limit (3 failures) |
| **v2.1.75** | Mar 13 | **1M context window now DEFAULT** for Opus 4.6 (Max/Team/Enterprise), `/color` command, memory files include last-modified timestamps, permission prompts show hook source |
| **v2.1.74** | Mar 12 | `/context` command gives actionable suggestions, `autoMemoryDirectory` setting, **BREAKING: removed deprecated Windows managed settings fallback** at `C:\ProgramData\ClaudeCode\managed-settings.json` |
| **v2.1.73** | Mar 12 | `modelOverrides` setting (map model picker to custom provider IDs), Bedrock inference profile ARN support, **`/output-style` deprecated** (use `/config`) |
| **v2.1.72** | Mar 10 | `ExitWorktree` tool, `w` key in `/copy` writes to file, `/plan` accepts description, effort levels simplified (low/medium/high), ~510KB bundle size reduction |
| **v2.1.71** | Mar 7 | **`/loop` command** for recurring prompts at intervals, CronCreate/CronDelete/CronList scheduling tools, `voice:pushToTalk` rebindable keybinding |
| **v2.1.70** | Mar 6 | VS Code session visuals, full markdown plan document view, native MCP server management via `/mcp`, 74% reduction in prompt re-renders, 426KB startup memory reduction |
| **v2.1.69** | Mar 5 | `/claude-api` skill, voice STT expanded to 20 languages, **`${CLAUDE_SKILL_DIR}` variable**, **`InstructionsLoaded` hook**, `/reload-plugins`, `includeGitInstructions` setting, security: nested skills no longer load from gitignored dirs |
| **v2.1.68** | Mar 4 | **Opus 4.6 now default model** with "medium" effort, "ultrathink" keyword re-introduced, **Opus 4 and 4.1 removed from API** |

### New Hooks (since v2.1.63)

| Hook | Version | Purpose |
|------|---------|---------|
| `InstructionsLoaded` | v2.1.69 | Fires when CLAUDE.md/.claude/rules/*.md are loaded — enables skill activation on config load |
| `PostCompact` | v2.1.76 | Fires after compaction completes — community uses for context renewal (re-injecting critical instructions) |
| `Elicitation` | v2.1.76 | Intercept MCP elicitation requests (MCP servers requesting structured input mid-task) |
| `ElicitationResult` | v2.1.76 | Override elicitation responses before they reach the MCP server |

### New Slash Commands (since v2.1.63)

| Command | Version | Purpose |
|---------|---------|---------|
| `/loop` | v2.1.71 | Recurring task scheduling (e.g., `/loop 5m check the deploy`) |
| `/mcp` | v2.1.70 | Native MCP server management (add/remove/configure within session) |
| `/effort` | v2.1.76 | Adjust model effort level (low/medium/high) |
| `/color` | v2.1.75 | Customize session prompt-bar color |
| `/branch` | v2.1.77 | Fork conversation (renamed from `/fork`, backward-compatible alias kept) |
| `/reload-plugins` | v2.1.69 | Activate plugin/skill changes without restart |
| `/claude-api` | v2.1.69 | API/SDK development skill |

### Breaking Changes (since v2.1.63)

1. **Opus 4 and 4.1 removed** from Claude model selector and Claude Code (v2.1.68) — users auto-migrated to Opus 4.6
2. **`/output-style` deprecated** — use `/config` instead (v2.1.73)
3. **Windows managed settings fallback removed** at `C:\ProgramData\ClaudeCode\managed-settings.json` — must use `C:\Program Files\ClaudeCode\managed-settings.json` (v2.1.74)
4. **`/fork` renamed to `/branch`** — backward-compatible alias maintained (v2.1.77)

### MCP Elicitation (Major Feature — v2.1.76)

MCP servers can now request structured input mid-task via interactive dialogs. This means:
- An MCP server can pause execution and ask the user for additional information
- Dialogs can be form fields or browser URLs
- New hooks (`Elicitation`, `ElicitationResult`) allow intercepting/overriding these requests
- This is the biggest MCP protocol change since Tool Search

### Code Review Launch (March 9, 2026)

Anthropic launched **Code Review** as a new Claude Code capability:
- Multi-agent system that analyzes PRs in parallel
- Leaves comments directly on GitHub pull requests
- Research preview for **Team and Enterprise** customers
- Typical cost: $15-$25 per review, ~20 minute completion time
- 54% of PRs receive substantive comments (up from 16% with older approaches)

### 1M Context Window Now Default

As of v2.1.75 (March 13), Opus 4.6 has a **1M context window by default** for Max, Team, and Enterprise plans. This is no longer a beta flag — it's the standard.

### Output Token Expansion

As of v2.1.77 (March 17):
- **Default** output tokens for Opus 4.6: **64K** (was 32K)
- **Upper bound**: **128K** for both Opus 4.6 and Sonnet 4.6
- Skill character budget now scales with context window (2% of context)

### Skills Ecosystem Maturity (from article analysis + research)

**`${CLAUDE_SKILL_DIR}` variable** (v2.1.69): Skills can now self-reference their own directory in SKILL.md content — critical for skills that include reference files, templates, or scripts relative to their own location.

**Universal SKILL.md format**: The same SKILL.md files now work across Claude Code, Cursor, Gemini CLI, Codex CLI, Antigravity IDE, and 33+ other agents. This is the "Agent Skills open standard" — one skill file, many agents.

**`npx skills` ecosystem (v7.3.0)**:
- Standardized skill installation: `npx skills add <org>/<repo> --skill <name>`
- `npx skills list` to see installed skills
- Works across all compatible agents
- 277K+ installs on frontend-design alone

**Antigravity Awesome Skills** (22K+ GitHub stars, 3.8K+ forks):
- 1,234+ curated agentic skills in a single library
- Install all at once: `npx antigravity-awesome-skills --claude`
- Role-based bundles: Web Wizard, Security Engineer, Essentials
- Key starter skills: `@brainstorming`, `@architecture`, `@debugging-strategies`, `@api-design-principles`, `@security-auditor`, `@create-pr`, `@doc-coauthoring`

**Skill discovery sites**:
- https://www.aitmpl.com/skills — skill marketplace/directory
- skills.sh — daily skill updates and discoveries

### Notable Third-Party Skills Worth Tracking

From the "10 Must-Have Skills" article (unicodeveloper, March 9, 2026):

| Skill | Install | What It Does |
|-------|---------|-------------|
| **Frontend Design** | `npx skills add anthropics/claude-code --skill frontend-design` | Breaks "distributional convergence" — bold design choices instead of generic Inter/purple/white |
| **Browser Use** | `npx skills add browser-use/claude-skill` | Live browser automation — navigate, click, fill forms, screenshot, scrape dynamic content |
| **GWS (Google Workspace)** | `npm install -g @googleworkspace/cli` + `gws mcp` | 50+ Google API automation — Gmail, Drive, Calendar, Sheets, Slides via MCP |
| **Valyu** | `npx skills add valyuAI/skills` | Real-time search across 36+ data sources (SEC filings, PubMed, ChEMBL, FRED, patents) |
| **Shannon** | `npx skills add unicodeveloper/shannon` | Autonomous AI pen testing — 96.15% exploit success on XBOW benchmark, 50+ vulnerability types |
| **PlanetScale** | `npx skills add planetscale/agent-skill` | Schema branching, index-aware query optimization, deploy requests |
| **Excalidraw** | `npx skills add coleam00/excalidraw-diagram-skill` | Architecture diagrams from natural language with self-validation rendering loop |

### Key Concepts from the Article

**"Distributional convergence"** — Anthropic's term for why LLMs produce visually similar outputs. Models are trained on the statistical center of design decisions, so they reproduce the statistical center. Skills like frontend-design break this by injecting a design philosophy before code generation.

**Self-validation loops** — The Excalidraw skill generates JSON, renders to PNG via Playwright, reviews its own output for layout issues, and fixes problems before presenting. This "generate → render → review → fix" pattern is applicable to any skill that produces visual artifacts.

**PostCompact context renewal** — Community pattern using the new PostCompact hook (v2.1.76) to re-inject critical instructions after compaction completes. Prevents post-compaction amnesia where Claude forgets project rules.

### Community Insights

- Claude Code wins 67% of blind code quality tests vs competitors (500+ Reddit developer analysis)
- r/ClaudeCode: 4,200+ weekly contributors
- March usage promotion (Mar 13-27): Anthropic doubled usage quotas during off-peak hours
- PostCompact hooks being used by community for context renewal patterns

### MCP Ecosystem Updates

- **2026 MCP Roadmap** published: top priorities are Streamable HTTP Transport (horizontal scaling, .well-known discovery), Tasks Primitive improvements, Enterprise adoption
- Microsoft, AWS, HashiCorp actively building MCP integrations — validates protocol as production-ready
- Native MCP server management via `/mcp` command (v2.1.70) — no more manual config file editing

### Research Tracking Update
| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-03-17 | v2.1.68-v2.1.77 | GitHub releases / changelog | 10 releases in 14 days; Opus 4.6 default, 1M context default, MCP elicitation, 4 new hooks, 7 new commands |
| 2026-03-17 | Skills ecosystem | Article + web research | Universal SKILL.md format, npx skills v7.3.0, Antigravity 1,234+ skills, ${CLAUDE_SKILL_DIR} var |
| 2026-03-17 | Code Review | Anthropic launch | Multi-agent PR review, $15-25/review, 54% substantive comment rate |
| 2026-03-17 | Output tokens | v2.1.77 release | 64K default, 128K upper bound for Opus 4.6 and Sonnet 4.6 |
| 2026-03-17 | Breaking changes | v2.1.68-v2.1.77 | Opus 4/4.1 removed, /output-style deprecated, Windows managed settings path changed |
| 2026-03-17 | Third-party skills | unicodeveloper article | Frontend Design, Browser Use, GWS, Valyu, Shannon, PlanetScale, Excalidraw tracked |
| 2026-03-17 | PostCompact pattern | Community blogs | Context renewal via PostCompact hook — re-inject critical instructions after compaction |

---

## 2026-03-03 — Context Rot, Wave Execution, and Spec-Driven Development Patterns

### Context Rot (Named Problem)

**Context rot** is quality degradation that occurs not just from hitting the context limit, but from the *accumulation of tool call noise* — hundreds of intermediate results, failed attempts, retried operations, and prior planning artifacts that crowd out working memory. Even at 60–70% context usage, quality degrades if the window is full of stale operational noise rather than clean task context.

**Distinction from context limits:**
- Context limit problem → compact or clear session
- Context rot problem → architectural solution: keep orchestrators lean, give executors a fresh window

**Source:** GSD (get-shit-done) — a widely-adopted Claude Code workflow system (23.9k GitHub stars, Dec 2025). Their "context rot" framing and wave execution solution is the most concrete solution to this problem in the community.

### Wave Execution Pattern

**Core idea:** Orchestrator stays at ~15% context budget. Each plan executor spawns as a fresh Task with 100% context budget.

**How dependency-based waves work:**
1. Analyze all plans → build dependency graph
2. Group plans into waves: independent plans → same wave, dependent plans → later wave
3. Execute waves sequentially, parallelize within each wave

**Vertical slices vs. horizontal layers:**
- Horizontal: "Plan 1: All models / Plan 2: All APIs / Plan 3: All UI" → cascading dependencies, one long sequential queue
- Vertical: "Plan 1: User feature end-to-end / Plan 2: Orders feature end-to-end" → fully parallel Wave 1

**File conflict rule:** Plans in the same wave must not touch the same files. Detect before execution; resolve by moving to later wave or merging plans.

### Plan-Checker Loop (Pre-Execution Quality Gate)

Before executing plans, spawn a checker agent to verify plans achieve phase goals (not just that they're internally consistent). Loop up to 3x with planner revision on failure. Prevents expensive executor runs on under-specified plans.

```
planner → PLAN.md files
    ↓
plan-checker → "Do these plans achieve the phase goal?"
    ↓ FAIL: feedback → planner (revise) → loop
    ↓ PASS (or 3 iterations): proceed to wave execution
```

### XML Task Format (Prompt Engineering)

XML-structured task definitions are more reliably followed by Claude than prose. Each task element constrains a specific dimension of Claude's interpretation:

```xml
<task type="auto">
  <name>Create login endpoint</name>
  <files>src/app/api/auth/login/route.ts</files>
  <action>Use jose for JWT (not jsonwebtoken — CommonJS issues). Validate credentials against users table. Return httpOnly cookie on success.</action>
  <verify>curl -X POST localhost:3000/api/auth/login returns 200 + Set-Cookie</verify>
  <done>Valid credentials return cookie, invalid return 401</done>
</task>
```

Use when: multi-step plans with more than 3 tasks, when precision matters (specific library choices, anti-patterns to avoid), when the plan will be handed off to an executor subagent.

### Research Tracking Update
| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-03-03 | Context Rot | GSD analysis | Named problem: tool noise degradation distinct from context limits; wave execution is the architectural solution |
| 2026-03-03 | Wave Execution | GSD analysis | Orchestrator 15% budget; executors fresh 100%; dependency-graph-based wave grouping; vertical slices > horizontal layers |
| 2026-03-03 | Plan-Checker Loop | GSD analysis | Pre-execution quality gate; max 3 revision iterations; prevents bad plans reaching expensive execution |
| 2026-03-03 | XML Task Format | GSD analysis | Structured XML more reliably followed than prose; name/files/action/verify/done fields |

---

## 2026-03-03 — Double Shot Latte (DSL) Hook — Autonomous Continue Pattern

### Concept (from Jesse Vincent's Superpowers framework)

When Claude is mid-task and stops to ask "should I continue?", the DSL hook evaluates autonomously whether human input is actually needed. If not, Claude continues without interrupting the user.

### Implementation (Two Stop hooks + one UserPromptSubmit reset)

**1. Command hook** (`double-shot-latte.ps1`):
- Reads `~/.claude/hooks/dsl/state.json` for recent stop timestamps
- Cleans entries older than 5 minutes, counts remainder
- If count ≥ 3 → THROTTLED (safety valve against infinite loops)
- Records current timestamp, writes CONTINUE or THROTTLED to `decision.txt`

**2. Prompt hook** (reads decision.txt and instructs Claude):
- If THROTTLED: tell user and stop
- If CONTINUE: distinguish between (A) normal conversational stop → wait for user, or (B) mid-task autonomous check-in → continue if not genuinely blocked

**3. UserPromptSubmit reset hook**:
- On every user message: resets state.json to `{ "stops": [] }` and decision.txt to `CONTINUE`
- This ensures the throttle counter only spans the current autonomous run, not the whole session

### Key Design Decisions

| Decision | Reason |
|----------|--------|
| Command hook writes state; prompt hook reads it | Command hooks can't communicate to Claude at Stop (stdout goes to terminal only); prompt hooks can |
| Reset on UserPromptSubmit | Prevents false throttles from normal interactive conversation stops |
| Type A/B stop distinction in prompt | Normal "end of turn" stops should not trigger autonomous continuation |
| 3 stops / 5 min throttle | Safety valve — prevents Claude looping forever on a stuck task |
| First in Stop array | DSL fires before session-end and save-lessons hooks |

### Files
- `~/.claude/hooks/dsl/double-shot-latte.ps1` — state tracker script
- `~/.claude/hooks/dsl/state.json` — stop timestamp log (reset on each user message)
- `~/.claude/hooks/dsl/decision.txt` — CONTINUE or THROTTLED flag

### Research Tracking Update
| Date | Topic | Source | Finding |
|------|-------|--------|---------|
| 2026-03-03 | DSL hook | Real-world implementation | Built from Superpowers concept; state tracker PS1 + prompt hook pair; UserPromptSubmit reset required to avoid false throttles |

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
