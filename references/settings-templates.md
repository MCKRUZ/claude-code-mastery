# Settings & Configuration Templates

> Production-ready configuration templates for Claude Code on Windows. Copy and customize.

---

## User-Level Settings (`~/.claude/settings.json`)

### General Developer (Windows)

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Read",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(git *)",
      "Bash(pytest *)",
      "Bash(python -m *)",
      "Bash(uv run *)",
      "Bash(cargo *)",
      "Bash(dotnet *)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(rm -rf *)"
    ]
  },
  "env": {
    "CLAUDE_CODE_EFFORT_LEVEL": "high"
  }
}
```

> **Windows hook note:** All Bash commands in hooks execute via Git Bash, so use Unix-style syntax (e.g., `npx prettier --write $file`), not PowerShell cmdlets.

### Power User — Agent Teams Enabled (Windows)

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Read",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(git *)",
      "Bash(pytest *)",
      "Bash(python -m *)",
      "Bash(uv run *)",
      "Bash(cargo *)",
      "Bash(dotnet *)",
      "Bash(docker compose *)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(rm -rf *)"
    ]
  },
  "env": {
    "CLAUDE_CODE_EFFORT_LEVEL": "high",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

---

## Project-Level Settings (`.claude/settings.json`)

### TypeScript/JavaScript Project

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test *)",
      "Bash(npm run lint)",
      "Bash(npx prettier *)",
      "Bash(npx tsc *)",
      "mcp__github__*",
      "mcp__context7__*"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.ts)",
        "hooks": [
          { "type": "command", "command": "npx prettier --write \"$CLAUDE_FILE_PATH\"", "timeout": 10000 }
        ]
      },
      {
        "matcher": "Write(*.tsx)",
        "hooks": [
          { "type": "command", "command": "npx prettier --write \"$CLAUDE_FILE_PATH\"", "timeout": 10000 }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "npx tsc --noEmit", "timeout": 30000 }
        ]
      }
    ]
  }
}
```

### Python Project

```json
{
  "permissions": {
    "allow": [
      "Bash(uv run pytest *)",
      "Bash(uv run ruff *)",
      "Bash(uv run black *)",
      "Bash(uv run mypy *)",
      "mcp__github__*"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.py)",
        "hooks": [
          { "type": "command", "command": "uv run black \"$CLAUDE_FILE_PATH\"", "timeout": 10000 },
          { "type": "command", "command": "uv run ruff check \"$CLAUDE_FILE_PATH\" --fix", "timeout": 10000 }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "uv run pytest --tb=short -q", "timeout": 30000 }
        ]
      }
    ]
  }
}
```

### C# / .NET Project

```json
{
  "permissions": {
    "allow": [
      "Bash(dotnet build *)",
      "Bash(dotnet test *)",
      "Bash(dotnet run *)",
      "Bash(dotnet ef *)",
      "mcp__github__*"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write(*.cs)",
        "hooks": [
          { "type": "command", "command": "dotnet format --include \"$CLAUDE_FILE_PATH\"", "timeout": 10000 }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "dotnet build --no-restore -q", "timeout": 30000 }
        ]
      }
    ]
  }
}
```

---

## MCP Server Configurations (`.mcp.json`)

### Minimal (Most Projects)

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    }
  }
}
```

### Standard Development Stack

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    }
  }
}
```

### Full Stack with Database

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "${DATABASE_URL:-postgresql://localhost:5432/mydb}"
      }
    }
  }
}
```

### Frontend Development

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "shadcn": {
      "type": "http",
      "url": "https://www.shadcn.io/api/mcp"
    },
    "playwright": {
      "command": "npx",
      "args": ["@anthropic-ai/mcp-playwright"]
    }
  }
}
```

---

## User-Level MCP Setup Commands (PowerShell)

```powershell
# Essential (run once, applies to all projects)
# NOTE: On Windows, servers added via `claude mcp add` go into ~/.claude.json
# which requires the cmd /c wrapper. Use these commands:
claude mcp add -s user context7 -- cmd /c npx -y @upstash/context7-mcp
claude mcp add -s user sequential-thinking -- cmd /c npx -y @modelcontextprotocol/server-sequential-thinking

# Optional but recommended
claude mcp add -s user memory -- cmd /c npx -y @modelcontextprotocol/server-memory

# Verify
claude mcp list

# Diagnose issues
claude doctor
```

**Windows notes:**
- MCP servers added via `claude mcp add` go into `~/.claude.json` (the state file), NOT `~/.claude/settings.json`.
- Servers in `.claude.json` require the `cmd /c` wrapper for `npx` commands on Windows.
- Servers in `settings.json` may work without the wrapper (Claude Code handles it internally).
- Run `claude doctor` to check for MCP configuration warnings.
- If using NVM for Windows, ensure the active Node version is on PATH.

---

## GitHub Actions Template

```yaml
name: Claude Code Review
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
jobs:
  claude:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      issues: write
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

---

## Agent Definition Templates (`.claude/agents/`)

### Code Reviewer

```yaml
---
name: code-reviewer
description: Senior code reviewer. Use after code changes for quality review.
tools: Read, Grep, Glob, Bash
model: sonnet
---
You are a senior code reviewer. When invoked:
1. Run `git diff HEAD~1` to see recent changes
2. Check for bugs, security issues, performance problems
3. Verify test coverage for changed code
4. Report findings with severity (critical/warning/info)
```

### Security Auditor

```yaml
---
name: security-auditor
description: Security-focused code auditor. Reviews for vulnerabilities and auth issues.
tools: Read, Grep, Glob
model: sonnet
---
You are a security auditor. Focus on:
1. Authentication and authorization vulnerabilities
2. Input validation and sanitization
3. SQL injection, XSS, CSRF risks
4. Sensitive data exposure (API keys, secrets, PII)
5. Dependency vulnerabilities
```

### Documentation Writer

```yaml
---
name: doc-writer
description: Technical documentation writer. Creates and updates docs.
tools: Read, Write, Edit, Glob, Grep
model: sonnet
---
You are a technical documentation writer. When invoked:
1. Analyze the code to understand what it does
2. Write clear, concise documentation
3. Include usage examples
4. Follow the project's existing doc style
```
