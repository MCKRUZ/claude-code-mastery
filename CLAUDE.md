
<!-- nexus:start -->
## Nexus Intelligence

*Auto-updated by Nexus — do not edit this section manually.*
*Last sync: 2026-04-07*

### Portfolio
| Project | Description | Tech |
|---------|------------|------|
| jarvis-stack | — | — |
| personal-brand-assistant | — | — |
| project-avatar | — | — |
| ComfyUI | **ComfyUI** — the main local ComfyUI installation at E:/ComfyUI-Easy-Install/Co… | — |
| sage-voice | **sage-voice** — MCKRUZ project for Sage's voice capabilities.

Sage is the AI … | — |
| matthewkruczek-ai | **matthewkruczek.ai** — static personal brand website for Matthew Kruczek (EY M… | — |
| **claude-code-mastery** (this) | **Claude Code Mastery** — the definitive Claude Code setup and configuration sk… | — |
| ProjectPrism | **Prismcast / ProjectPrism** — autonomous AI news aggregation, synthesis, and v… | — |
| ComfyUI Expert | **VideoAgent / ComfyUI Expert** — session-scoped Claude Code orchestrator that … | — |
| ArchitectureHelper | **AzureCraft / ArchitectureHelper** — AI-native Azure infrastructure designer f… | — |
| Nexus | Nexus is a local-first cross-project intelligence layer for Claude Code. | — |
| _+28 inactive_ | — | — |

### Context from Nexus
#### Roadmap: Next Features
User-approved feature ideas (2026-03-24):

1. **MCP Tool Intelligence Layer** — Nexus sits on mcp-hub, learns which tools succeed/fail per project, i…
*Tags: roadmap, features, mcp-hub, planning*

#### Backlog: Show all active MCP servers in Claude Config tab
The Claude Config dashboard page only shows MCP servers from settings.json/settings.local.json, not the full set of running servers (plugins + projec…
*Tags: backlog, dashboard, mcp, claude-config*

#### Token Budget Optimization Session - 2026-03-18
## Token Budget Optimizations Applied

### 1. Portfolio Table Filter (claude-md-sync.ts)
- Before: All 35+ projects listed in every CLAUDE.md sync (~…
*Tags: token-budget, skills, portfolio, optimization*

#### Session Insights - 2026-03-17
## Session Insights - 2026-03-17

**Scope:** 20 sessions, ~1 month, 670 total messages, 33.5 avg msgs/session

### Top Projects
1. **OpenClaw** — 5 s…
*Tags: insights, sessions, analytics*

#### OpenClaw Ollama Fallback & Stop Hook JSON Validation Fix
(1) OpenClaw agent fallback chain requires tool-capable models; dolphin-llama3 doesn't support tools so was removed; llama3.1:8b being pulled as Olla…
*Tags: openclaw, ollama, hooks, bug-fix*

### Recorded Decisions
- **[security]** Sanitize and rotate credentials after eval runs that may expose secrets
  > During test case TC-003, a real GitHub PAT was exposed in skill output. Established practice to rotate credentials and document secret exposure risks in eval framework.
- **[security]** Sanitize eval test harness to prevent credential leakage from settings files
  > Eval run exposed GitHub PAT token when skill accessed actual settings.json during MCP config test
- **[security]** Include platform-aware syntax validation in evaluations — specifically test Win…
  > TC-005 and TC-003 explicitly validate Windows-compatible output; 15% of benchmark criteria allocated to platform awareness
- **[architecture]** Add failure-mode test cases for adversarial input and edge cases before finaliz…
  > After initial 5 test cases passed at 100%, added TC-006, TC-007, TC-008 to test adversarial users, contradictory platform info, and cold-start scenarios. Discovered that robustness under adversarial conditions should be weighted (10%).
- **[architecture]** Use anchored, objective assertion types for eval scoring instead of subjective …
  > Initial eval used vague assertions like 'sequence_check' and subjective descriptions. Refactored to use concrete assertion types: contains, regex, question_before_code (line position), json_valid, token_limit to reduce scoring ambiguity.

> **Cross-project rule**: Before making decisions that affect shared concerns (APIs, auth, data formats, deployment) or asking the user for server/SSH/infrastructure details, run `nexus_query` to check for existing decisions, notes, and conflicts across the portfolio.

*[Nexus: run `nexus query` to search full knowledge base]*
<!-- nexus:end -->
