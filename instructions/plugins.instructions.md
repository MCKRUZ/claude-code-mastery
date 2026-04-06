# Recommended Plugins

These Claude Code plugins complement the skill and instruction set. Install via `/plugin marketplace add` or by adding to `extraKnownMarketplaces` in settings.json.

## Core Plugins

| Plugin | Source | What It Does |
|--------|--------|-------------|
| **code-simplifier** | `anthropics/claude-code` | Code review, build-fix, refactor-clean, plan, simplify, learn |
| **deep-plan** | `piercelamb/plugins` | Structured TDD-oriented implementation planning |
| **deep-implement** | `piercelamb/plugins` | Implements plans from deep-plan with code review |
| **deep-project** | `piercelamb/plugins` | Decomposes vague requirements into plannable units |

## Context & Observability Plugins

| Plugin | Source | What It Does |
|--------|--------|-------------|
| **context-mode** | `mksglu/context-mode` | Intercepts large tool outputs, routes through sandbox — only summaries enter context window |
| **claude-hud** | `jarrodwatts/claude-hud` | Status line showing project name, model, context usage %, and task state |

## Installation

```powershell
# Official plugins (already registered)
/plugin marketplace add anthropics/claude-code
/plugin marketplace add piercelamb/plugins

# Third-party plugins (need marketplace registration)
# Add to settings.json:
#   "extraKnownMarketplaces": {
#     "context-mode": { "source": { "source": "github", "repo": "mksglu/context-mode" } },
#     "claude-hud": { "source": { "source": "github", "repo": "jarrodwatts/claude-hud" } }
#   }
# Then enable in settings.json:
#   "enabledPlugins": {
#     "context-mode@context-mode": true,
#     "claude-hud@claude-hud": true
#   }
```
