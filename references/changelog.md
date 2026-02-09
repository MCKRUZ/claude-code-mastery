# Skill Changelog

> Tracks all updates to the claude-code-mastery skill and its knowledge base.

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
