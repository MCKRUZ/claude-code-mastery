# Full Power-User Setup Guide

> Everything the APM package **doesn't** auto-install. Follow this guide to replicate the complete Claude Code harness — plugins, production settings, MCP gateway, lifecycle hooks, observability, and cross-project intelligence.

**What APM gives you:** The mastery skill + 15 curated skills + instructions + agents + hook patterns.

**What this guide adds:** The infrastructure that ties it all together.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed and authenticated (`claude auth login`)
- [APM](https://github.com/microsoft/apm) installed (`irm https://aka.ms/apm-windows | iex` / `curl -sSL https://aka.ms/apm-unix | sh`)
- [Git for Windows](https://git-scm.com/downloads/win) (or Git on macOS/Linux)
- PowerShell 7.x (`winget install Microsoft.PowerShell`) — required for hook scripts on Windows
- Node.js 20+ (`winget install OpenJS.NodeJS.LTS`)
- Python 3.11+ (optional — for Langfuse tracing hook)

---

## Phase 1: Base Install (APM)

```bash
# In any project directory
apm install MCKRUZ/claude-code-mastery

# Or globally as a skill
git clone https://github.com/MCKRUZ/claude-code-mastery ~/.claude/skills/claude-code-mastery
```

This gives you the skill, 15 dependency skills, 7 instruction sets, 3 agents, and hook patterns. Everything below is additive.

---

## Phase 2: Plugins

Claude Code plugins can't be installed via APM — they use their own plugin system.

### Core Plugins

```
/plugin marketplace add anthropics/claude-code
/plugin marketplace add piercelamb/plugins
```

Then enable in `/config` or `settings.json`:
```json
{
  "enabledPlugins": {
    "code-simplifier@claude-plugins-official": true,
    "deep-project@piercelamb-plugins": true,
    "deep-plan@piercelamb-plugins": true,
    "deep-implement@piercelamb-plugins": true
  }
}
```

### Third-Party Plugins

These require registering custom marketplaces first.

Add to `~/.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "context-mode": {
      "source": { "source": "github", "repo": "mksglu/context-mode" }
    },
    "claude-hud": {
      "source": { "source": "github", "repo": "jarrodwatts/claude-hud" }
    }
  },
  "enabledPlugins": {
    "context-mode@context-mode": true,
    "claude-hud@claude-hud": true
  }
}
```

**What each plugin does:**

| Plugin | Purpose |
|--------|---------|
| **code-simplifier** | `/code-review`, `/build-fix`, `/refactor-clean`, `/plan`, `/simplify`, `/learn` |
| **deep-plan** | Structured TDD-oriented implementation planning with multi-LLM review |
| **deep-implement** | Implements deep-plan sections with code review and git workflow |
| **deep-project** | Decomposes vague requirements into plannable units |
| **context-mode** | Intercepts large tool outputs, routes through sandbox — protects context window |
| **claude-hud** | Status line showing project name, model, context %, task state |

---

## Phase 3: Global Configuration

### 3a. Global CLAUDE.md (`~/.claude/CLAUDE.md`)

Keep this under 500 tokens. It loads on **every message in every project**.

```markdown
# Global Defaults

## Compact Instructions
When compacting, always preserve:
- Current task status and next steps
- Key architectural decisions made this session
- File paths actively being edited
- Any user preferences or corrections given this session

## Cross-Project Conventions
- Immutability first (see rules/coding-style.md for language-specific patterns)
- Validate at system boundaries, trust internal code
- 80% test coverage minimum on new code
- No console.log, no hardcoded secrets, no deep nesting (>4 levels)

## Response Style
- Lead with the answer, not the reasoning
- Skip trailing summaries — the user reads the diff
- Use file_path:line_number when referencing code
- Only add comments where logic isn't self-evident
```

### 3b. Nexus Memory Rule (`~/.claude/rules/nexus-memory.md`)

Only add this if you set up Nexus (Phase 7).

```markdown
# Nexus — Cross-Project Memory

When the user references something specific you lack context for (named document,
character, system, feature), call `nexus_query` BEFORE asking them to explain.
Only ask if Nexus returns nothing useful.
```

### 3c. Production Settings (`~/.claude/settings.json`)

This is the full production configuration. Customize paths and credentials for your environment.

```json
{
  "model": "opus[1m]",
  "alwaysThinkingEnabled": true,
  "voiceEnabled": true,
  "autoUpdatesChannel": "latest",
  "skipDangerousModePermissionPrompt": true,
  "env": {
    "TRACE_TO_LANGFUSE": "true",
    "LANGFUSE_PUBLIC_KEY": "<your-langfuse-public-key>",
    "LANGFUSE_SECRET_KEY": "<your-langfuse-secret-key>",
    "LANGFUSE_HOST": "https://langfuse.your-server.example",
    "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-github-pat>",
    "CLAUDE_CODE_EFFORT_LEVEL": "high",
    "CLAUDE_HOOK_PROFILE": "standard",
    "CLAUDE_DISABLED_HOOKS": ""
  },
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
  "hooks": {
    "_comment": "See Phase 5 for each hook script"
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
  },
  "mcpNotes": {
    "sentry": "Add back when deploying production apps: https://mcp.sentry.dev/mcp",
    "filesystem": "Built-in Read/Write/Glob/Grep cover file ops, saved ~2-3K tokens",
    "memory": "cmem MCP provides superior conversation memory + learned lessons",
    "config-location": "MCP servers managed in ~/.claude.json via 'claude mcp add/remove', NOT in settings.json"
  }
}
```

**Customize before using:**
- Replace `<your-langfuse-*>` with your Langfuse credentials (or remove if not using)
- Replace `<your-github-pat>` with a GitHub Personal Access Token ([create one](https://github.com/settings/tokens))
- Adjust `mcp__bifrost__*` / `mcp__nexus-local__*` to match your MCP server names
- Remove `skipDangerousModePermissionPrompt` if you prefer the safety prompt

---

## Phase 4: MCP Gateway

Instead of running many individual MCP servers, consolidate behind a gateway.

### Option A: Bifrost (Remote Gateway — Recommended)

Run a Bifrost gateway on a home server or always-on machine. Claude Code connects via HTTP.

```bash
# On your server
git clone https://github.com/hyperb1iss/bifrost
cd bifrost
# Follow Bifrost setup docs to configure backend servers
# (GitHub, Context7, Sequential Thinking, YouTube, etc.)
```

Add to Claude Code (on your dev machine):
```bash
claude mcp add -s user bifrost --transport http http://your-server:8090/mcp
```

Then pre-allow in `settings.json`:
```json
{
  "permissions": {
    "allow": ["mcp__bifrost__*"]
  }
}
```

### Option B: Local Hub (FastMCP)

For a fully local setup, create a Python FastMCP server wrapping multiple backends:

```bash
# Create the hub
mkdir mcp-hub && cd mcp-hub
uv init && uv add fastmcp

# Add to Claude Code
claude mcp add -s user hub -- uv --directory C:/path/to/mcp-hub run fastmcp run src/mcp_hub/server.py
```

### Essential MCP Servers (if not using a gateway)

```powershell
# Context7 — current library docs (prevents hallucinated APIs)
claude mcp add -s user context7 -- cmd /c npx -y @upstash/context7-mcp

# GitHub — repos, PRs, issues, CI/CD
claude mcp add -s user github -- cmd /c npx -y @modelcontextprotocol/server-github

# Sequential Thinking — better planning
claude mcp add -s user sequential-thinking -- cmd /c npx -y @modelcontextprotocol/server-sequential-thinking
```

> **Windows note:** `claude mcp add` writes to `~/.claude.json`, which requires `cmd /c` wrapper for `npx` commands. Run `claude doctor` to verify.

### Tracking Removed Servers

Add `mcpNotes` to `settings.json` to document why servers were removed (prevents accidentally re-adding):

```json
{
  "mcpNotes": {
    "sentry": "Removed 2026-02-09 — Add back when deploying production apps",
    "filesystem": "Removed 2026-02-09 — Built-in tools cover file ops"
  }
}
```

---

## Phase 5: Hook Stack

The full lifecycle hook stack. Each hook is independent — install only what you need.

### Directory Setup

```powershell
# Create hook directories
$hookBase = "$env:USERPROFILE\.claude\hooks"
New-Item -ItemType Directory -Force -Path @(
    "$hookBase\memory-persistence",
    "$hookBase\skill-switchboard",
    "$hookBase\strategic-compact",
    "$hookBase\dsl"
)
```

---

### 5a. Memory Persistence (4 scripts)

Maintains session state across compactions and restarts using conversation memory (cmem MCP).

**Requires:** cmem MCP server (`claude mcp add -s user cmem -- cmd /c npx -y @anthropic/cmem-mcp` or equivalent)

**`~/.claude/hooks/memory-persistence/session-start.ps1`**

```powershell
# Load previous session context on startup
# Reads the most recent .tmp session file and outputs it as context
$sessionDir = "$env:USERPROFILE\.claude\sessions"
if (Test-Path $sessionDir) {
    $latest = Get-ChildItem "$sessionDir\*.tmp" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
    if ($latest) {
        $content = Get-Content $latest.FullName -Raw -ErrorAction SilentlyContinue
        if ($content) {
            Write-Output "## [SESSION MEMORY] Last Session Notes: $($latest.BaseName)"
            Write-Output $content
        }
    }
}
```

**`~/.claude/hooks/memory-persistence/pre-compact.ps1`**

```powershell
# Save current work state before compaction
# Creates/updates today's session .tmp file
$sessionDir = "$env:USERPROFILE\.claude\sessions"
if (-not (Test-Path $sessionDir)) { New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null }
$today = Get-Date -Format "yyyy-MM-dd"
$sessionFile = "$sessionDir\$today-session.tmp"

if (-not (Test-Path $sessionFile)) {
    $template = @"
# Session: $today
**Date:** $today
**Started:** $(Get-Date -Format "HH:mm")
**Last Updated:** $(Get-Date -Format "HH:mm")

---

## Request
## Investigated
## Learned
## Completed
## Next Steps
## Context to Load Next Session
"@
    Set-Content -Path $sessionFile -Value $template -Encoding UTF8
} else {
    # Update the Last Updated timestamp
    $content = Get-Content $sessionFile -Raw
    $content = $content -replace '\*\*Last Updated:\*\* \d{2}:\d{2}', "**Last Updated:** $(Get-Date -Format 'HH:mm')"
    Set-Content -Path $sessionFile -Value $content -Encoding UTF8
}
Write-Output "Session file ready: $sessionFile"
```

**`~/.claude/hooks/memory-persistence/save-observation.ps1`**

```powershell
# Record file changes to session log (PostToolUse on Edit|Write)
# Reads tool_use JSON from stdin
$input = $input | Out-String
try {
    $json = $input | ConvertFrom-Json -ErrorAction Stop
    $filePath = $json.tool_input.file_path
    $toolName = $json.tool_name
    if ($filePath) {
        $sessionDir = "$env:USERPROFILE\.claude\sessions"
        $today = Get-Date -Format "yyyy-MM-dd"
        $sessionFile = "$sessionDir\$today-session.tmp"
        $timestamp = Get-Date -Format "HH:mm:ss"
        $entry = "  [$timestamp] $toolName : $filePath"
        Add-Content -Path $sessionFile -Value $entry -Encoding UTF8 -ErrorAction SilentlyContinue
    }
} catch {
    # Silently ignore parse errors
}
```

**`~/.claude/hooks/memory-persistence/session-end.ps1`**

```powershell
# Persist session summary on Stop
$sessionDir = "$env:USERPROFILE\.claude\sessions"
$today = Get-Date -Format "yyyy-MM-dd"
$sessionFile = "$sessionDir\$today-session.tmp"
if (Test-Path $sessionFile) {
    $content = Get-Content $sessionFile -Raw
    $content = $content -replace '\*\*Last Updated:\*\* \d{2}:\d{2}', "**Last Updated:** $(Get-Date -Format 'HH:mm')"
    Set-Content -Path $sessionFile -Value $content -Encoding UTF8
}
```

**Settings.json hooks config:**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{
          "type": "command",
          "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/memory-persistence/session-start.ps1\"",
          "timeout": 10000
        }]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/memory-persistence/pre-compact.ps1\"",
            "timeout": 10000
          },
          {
            "type": "prompt",
            "prompt": "Before compaction: update MEMORY.md (current work + next steps), update today's session .tmp file, and save reusable patterns via mcp__cmem__save_lesson if any."
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{
          "type": "command",
          "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/memory-persistence/save-observation.ps1\"",
          "timeout": 5000
        }]
      }
    ],
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/memory-persistence/session-end.ps1\"",
          "timeout": 10000
        }]
      }
    ]
  }
}
```

Replace `C:/Users/<you>/` with your actual home directory path.

---

### 5b. PostCompact Context Renewal

Re-orients Claude after compaction to prevent post-compaction amnesia.

**No script needed — prompt hook only.**

```json
{
  "PostCompact": [
    {
      "hooks": [{
        "type": "prompt",
        "prompt": "Context was just compacted. Re-orient yourself:\n1. Read your project's MEMORY.md (path is in the auto memory section of your system instructions) for current work state and next steps.\n2. Check the task list (TaskList) for any in-progress tasks.\n3. Review your .claude/rules/ files if working in a specific domain.\nDo NOT announce this re-orientation to the user — just resume working seamlessly."
      }]
    }
  ]
}
```

---

### 5c. Auto-Format on File Write

Automatically formats files after Claude writes them.

**`~/.claude/hooks/auto-format.sh`** (runs via Git Bash):

```bash
#!/bin/bash
# Auto-format edited files based on extension
# Reads CLAUDE_FILE_PATH from environment

FILE="$CLAUDE_FILE_PATH"
if [ -z "$FILE" ]; then exit 0; fi

EXT="${FILE##*.}"

case "$EXT" in
  ts|tsx|js|jsx|json|css|scss|html)
    if command -v npx &>/dev/null && [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/node_modules/.bin/prettier" ]; then
      npx prettier --write "$FILE" 2>/dev/null
    fi
    ;;
  cs)
    if command -v dotnet &>/dev/null; then
      dotnet format --include "$FILE" 2>/dev/null
    fi
    ;;
  py)
    if command -v uv &>/dev/null; then
      uv run black "$FILE" 2>/dev/null
      uv run ruff check "$FILE" --fix 2>/dev/null
    fi
    ;;
esac
```

```json
{
  "PostToolUse": [
    {
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "\"C:/Program Files/Git/bin/bash.exe\" \"C:/Users/<you>/.claude/hooks/auto-format.sh\"",
        "timeout": 30000
      }]
    }
  ]
}
```

---

### 5d. Git Push Guard

Forces review of commits before pushing — prevents accidental pushes.

**No script needed — prompt hook only.**

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash(git push*)",
      "hooks": [{
        "type": "prompt",
        "prompt": "Before pushing, list the commits that will be pushed and remind the user to review changes."
      }]
    }
  ]
}
```

---

### 5e. Strategic Compact Warning

Warns before context window fills up, preventing mid-task compaction.

**`~/.claude/hooks/strategic-compact/suggest-compact.ps1`**

```powershell
# Checks context usage and warns if approaching limit
# This is a PreToolUse hook — reads tool context from stdin
$input = $input | Out-String
try {
    $json = $input | ConvertFrom-Json -ErrorAction Stop
    # The hook can access session metadata if available
    # Output a warning if context is high
    # Note: exact context % detection depends on your setup
    # This is a template — customize the threshold logic
} catch {
    # Silently continue
}
```

```json
{
  "PreToolUse": [
    {
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/strategic-compact/suggest-compact.ps1\"",
        "timeout": 5000
      }]
    }
  ]
}
```

---

### 5f. Skill Switchboard (Event-Driven Skill Injection)

Automatically injects relevant rules based on file type + directory — zero manual invocation.

**`~/.claude/hooks/skill-switchboard/rules.json`**

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

**`~/.claude/hooks/skill-switchboard/switchboard.ps1`**

```powershell
# Reads tool_input from stdin, matches against rules.json, outputs relevant skill content
$input = $input | Out-String
try {
    $json = $input | ConvertFrom-Json -ErrorAction Stop
    $filePath = $json.tool_input.file_path
    if (-not $filePath) { exit 0 }

    $rulesFile = Join-Path $PSScriptRoot "rules.json"
    if (-not (Test-Path $rulesFile)) { exit 0 }
    $rules = (Get-Content $rulesFile -Raw | ConvertFrom-Json).rules

    $ext = [System.IO.Path]::GetExtension($filePath)
    $injected = @{}

    foreach ($rule in ($rules | Where-Object { $_.enabled } | Sort-Object { -$_.priority })) {
        # Check extension match
        if ($rule.matchers.extensions -notcontains $ext) { continue }

        # Check directory match (glob-style)
        $dirMatch = $false
        foreach ($pattern in $rule.matchers.directories) {
            $regex = $pattern -replace '\*\*', '.*' -replace '\*', '[^/\\]*'
            if ($filePath -match $regex) { $dirMatch = $true; break }
        }
        if (-not $dirMatch) { continue }

        # Resolve and inject
        $injectPath = $rule.inject_path -replace '~', $env:USERPROFILE
        if ($injected.ContainsKey($injectPath)) { continue }

        if (Test-Path $injectPath) {
            $content = Get-Content $injectPath -TotalCount $rule.max_lines -ErrorAction SilentlyContinue
            if ($content) {
                Write-Output "`n--- [$($rule.name)] ---"
                Write-Output ($content -join "`n")
                $injected[$injectPath] = $true
            }
        }
    }
} catch {
    # Silently continue
}
```

```json
{
  "PreToolUse": [
    {
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/skill-switchboard/switchboard.ps1\"",
        "timeout": 8000
      }]
    }
  ]
}
```

**Customize `rules.json`** for your stack — add rules for React, Python, Go, or any file pattern.

---

### 5g. Kill MCP Children (Process Cleanup)

Cleans up zombie MCP server processes that outlive the session.

**`~/.claude/hooks/kill-mcp-children.ps1`**

```powershell
# Kill orphaned MCP server processes on session end
$mcpProcesses = Get-Process -Name "node", "python", "uvicorn" -ErrorAction SilentlyContinue |
    Where-Object {
        $_.CommandLine -match "mcp|fastmcp|server-github|context7|sequential-thinking" -or
        $_.MainWindowTitle -eq ""
    }

foreach ($proc in $mcpProcesses) {
    try {
        # Only kill processes started by Claude Code (heuristic: no window title)
        if ($proc.MainWindowHandle -eq 0 -and $proc.StartTime -gt (Get-Date).AddHours(-12)) {
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    } catch {
        # Ignore — process may have already exited
    }
}
```

```json
{
  "Stop": [
    {
      "hooks": [{
        "type": "command",
        "command": "pwsh -NoProfile -ExecutionPolicy Bypass -File \"C:/Users/<you>/.claude/hooks/kill-mcp-children.ps1\"",
        "timeout": 8000
      }]
    }
  ]
}
```

---

### 5h. Double Shot Latte (Autonomous Continue)

Eliminates unnecessary check-in interruptions. When Claude stops mid-task, DSL evaluates whether human input is genuinely needed.

**`~/.claude/hooks/dsl/double-shot-latte.ps1`** (already included in this repo at `hooks/dsl/`):

```powershell
# Tracks stop events, decides CONTINUE or THROTTLED
$stateFile = Join-Path $PSScriptRoot "state.json"
$decisionFile = Join-Path $PSScriptRoot "decision.txt"

# Initialize state file if missing
if (-not (Test-Path $stateFile)) {
    '{ "stops": [] }' | Set-Content $stateFile -Encoding UTF8
}

$state = Get-Content $stateFile -Raw | ConvertFrom-Json
$now = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$windowSeconds = 300  # 5 minutes
$maxStops = 3

# Clean entries older than window
$state.stops = @($state.stops | Where-Object { ($now - $_) -lt $windowSeconds })

# Add current stop
$state.stops += $now

# Decide
if ($state.stops.Count -ge $maxStops) {
    "THROTTLED" | Set-Content $decisionFile -Encoding UTF8
} else {
    "CONTINUE" | Set-Content $decisionFile -Encoding UTF8
}

# Save state
$state | ConvertTo-Json | Set-Content $stateFile -Encoding UTF8
```

**Three hooks needed (in order):**

```json
{
  "UserPromptSubmit": [
    {
      "hooks": [{
        "type": "command",
        "command": "pwsh -NoProfile -ExecutionPolicy Bypass -Command \"Set-Content 'C:/Users/<you>/.claude/hooks/dsl/state.json' '{ \\\"stops\\\": [] }' -Encoding UTF8; Set-Content 'C:/Users/<you>/.claude/hooks/dsl/decision.txt' 'CONTINUE' -Encoding UTF8\"",
        "timeout": 3000
      }]
    }
  ],
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
}
```

**Key:** Place DSL **after** kill-mcp-children but **before** session-end in your Stop hook sequence.

---

## Phase 6: Observability (Langfuse)

Traces every Claude Code API call for cost tracking, quality analysis, and debugging.

### Setup

1. **Deploy Langfuse** (self-hosted or cloud):
   - Self-hosted: `docker compose up -d` from [langfuse/langfuse](https://github.com/langfuse/langfuse)
   - Cloud: [cloud.langfuse.com](https://cloud.langfuse.com)

2. **Get credentials:** Project Settings -> API Keys -> Create

3. **Add env vars** to `~/.claude/settings.json`:
   ```json
   {
     "env": {
       "TRACE_TO_LANGFUSE": "true",
       "LANGFUSE_PUBLIC_KEY": "pk-lf-...",
       "LANGFUSE_SECRET_KEY": "sk-lf-...",
       "LANGFUSE_HOST": "https://langfuse.your-server.example"
     }
   }
   ```

4. **Create the flush hook** (`~/.claude/hooks/langfuse_hook.py`):

   ```python
   """Flush Langfuse traces on session end."""
   import os
   import sys

   try:
       from langfuse import Langfuse

       client = Langfuse(
           public_key=os.environ.get("LANGFUSE_PUBLIC_KEY", ""),
           secret_key=os.environ.get("LANGFUSE_SECRET_KEY", ""),
           host=os.environ.get("LANGFUSE_HOST", "https://cloud.langfuse.com"),
       )
       client.flush()
   except ImportError:
       # langfuse not installed — skip silently
       pass
   except Exception as e:
       print(f"Langfuse flush warning: {e}", file=sys.stderr)
   ```

   Install the SDK: `pip install langfuse` (or `uv pip install langfuse`)

5. **Add Stop hook:**
   ```json
   {
     "Stop": [
       {
         "hooks": [{
           "type": "command",
           "command": "py \"C:/Users/<you>/.claude/hooks/langfuse_hook.py\"",
           "timeout": 30000
         }]
       }
     ]
   }
   ```

---

## Phase 7: Cross-Project Intelligence (Nexus)

Nexus is a local-first cross-project intelligence layer. It syncs decisions, patterns, and context across all your projects.

### Setup

```bash
git clone https://github.com/MCKRUZ/Nexus ~/path/to/Nexus
cd ~/path/to/Nexus
npm install && npm run build
```

### Register as MCP Server

```bash
claude mcp add -s user nexus-local -- node "/path/to/Nexus/packages/cli/dist/index.js" serve
```

Pre-allow in settings.json:
```json
{
  "permissions": {
    "allow": ["mcp__nexus-local__*"]
  }
}
```

### Nexus Hooks

**SessionStart — Sync on startup:**
```json
{
  "hooks": [{
    "type": "command",
    "command": "node \"/path/to/Nexus/packages/cli/dist/index.js\" sync --quiet --graceful",
    "timeout": 15000
  }]
}
```

**SessionStart — Initialize session tracking:**
```json
{
  "hooks": [{
    "type": "command",
    "command": "node --experimental-sqlite \"C:/Users/<you>/.claude/hooks/nexus-session-start.mjs\"",
    "timeout": 10000
  }]
}
```

**PostToolUse — Track tool usage patterns:**
```json
{
  "hooks": [{
    "type": "command",
    "command": "node --experimental-sqlite \"C:/Users/<you>/.claude/hooks/nexus-post-tool-use.mjs\"",
    "timeout": 10000
  }]
}
```

**Stop — Sync decisions to Nexus:**
```json
{
  "hooks": [{
    "type": "command",
    "command": "node \"/path/to/Nexus/packages/cli/dist/index.js\" hook post-session --quiet",
    "timeout": 30000
  }]
}
```

### Add the Nexus Memory Rule

Copy `~/.claude/rules/nexus-memory.md` from Phase 3b above.

---

## Phase 8: Project-Level Skills

Skills that belong in specific projects, not globally. Install only where relevant.

| Skills | Projects | Install |
|--------|----------|---------|
| ComfyUI skills (12) | AI image/video projects | `cp -r ~/.claude/skills/comfyui-* .claude/skills/` |
| YouTube skills (8) | Video production | `cp -r ~/.claude/skills/youtube-* .claude/skills/` |
| Brand/persona skills | Personal brand | Copy to brand project `.claude/skills/` |
| Consulting skills (8) | Client work | Copy to consulting project `.claude/skills/` |
| Grafana dashboards | Observability | Copy to observability project `.claude/skills/` |

**Decision framework — global vs project:**

| Question | Global | Project |
|----------|--------|---------|
| Useful in any codebase? | Yes | No |
| Domain-specific? | No | Yes |
| Used < once a month per project? | No | Yes |
| Workflow skill (commit, review, plan)? | Yes | No |

---

## Phase 9: Complete Hook Sequence

Here's the full production hook order. Hooks within the same event execute top-to-bottom.

```
SessionStart:
  1. memory-persistence/session-start.ps1    <- Load previous session
  2. Nexus sync (node CLI)                   <- Sync cross-project intelligence
  3. nexus-session-start.mjs                 <- Initialize session tracking

PreToolUse (Edit|Write):
  4. skill-switchboard/switchboard.ps1       <- Inject relevant skills by file type
  5. strategic-compact/suggest-compact.ps1   <- Warn before context fills

PreToolUse (git push):
  6. Prompt: "List commits, remind user to review"

PreCompact:
  7. memory-persistence/pre-compact.ps1      <- Save work state
  8. Prompt: "Update MEMORY.md, session file, save patterns"

PostCompact:
  9. Prompt: "Re-orient: read MEMORY.md, check TaskList"

PostToolUse (Edit|Write):
  10. auto-format.sh                         <- Format edited files
  11. memory-persistence/save-observation.ps1 <- Record file change

PostToolUse (all):
  12. nexus-post-tool-use.mjs                <- Track tool patterns

Stop:
  13. kill-mcp-children.ps1                  <- Clean up zombie processes
  14. dsl/double-shot-latte.ps1              <- Autonomous continue eval
  15. DSL prompt hook                        <- Act on CONTINUE/THROTTLED
  16. memory-persistence/session-end.ps1     <- Persist session summary
  17. Nexus post-session (node CLI)          <- Sync to Nexus
  18. langfuse_hook.py                       <- Flush traces
```

---

## Verification Checklist

After completing all phases, verify:

```powershell
# Phase 1 — Skills installed
apm deps tree

# Phase 2 — Plugins active
# Check the prompt bar for claude-hud status line
# Try /code-review, /deep-plan

# Phase 3 — Settings valid
claude doctor

# Phase 4 — MCP servers connected
claude mcp list

# Phase 5 — Hooks firing
# Start a session — SessionStart hooks should show in the header
# Edit a file — auto-format should run
# Try git push — guard should prompt

# Phase 6 — Langfuse receiving traces
# Check your Langfuse dashboard after a session

# Phase 7 — Nexus syncing
# Run: nexus query "test" — should return results if notes exist

# Phase 8 — Project skills scoped
# In a ComfyUI project: ls .claude/skills/ — should see comfyui-*
# In an unrelated project: ls ~/.claude/skills/ — should NOT see comfyui-*
```

---

## Minimal vs Full Setup

Not everyone needs the full stack. Here's what to prioritize:

| Priority | Phases | Time | What You Get |
|----------|--------|------|-------------|
| **Essential** | 1 + 2 + 3a | 10 min | Skills + plugins + global config |
| **Recommended** | + 3c + 5b + 5c + 5d | 20 min | Production settings + core hooks |
| **Power User** | + 4 + 5a + 5f + 5h | 45 min | MCP gateway + memory + switchboard + DSL |
| **Full Harness** | + 5-9 (all) | 90 min | Complete lifecycle automation |

Start with Essential, add more as you feel the need. Every phase is independent.
