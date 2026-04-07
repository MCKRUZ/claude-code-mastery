# Research: Global CLAUDE.md Best Practices

> Compiled 2026-04-07 from 20+ sources across GitHub, official docs, blogs, Reddit, and YouTube.

---

## Table of Contents

1. [How Global CLAUDE.md Works](#how-global-claudemd-works)
2. [Official Anthropic Guidance](#official-anthropic-guidance)
3. [The "Instructions Ignored" Problem](#the-instructions-ignored-problem)
4. [Best-in-Class Examples (Full Configs)](#best-in-class-examples)
5. [Common Sections & Patterns](#common-sections--patterns)
6. [Community-Sourced Tips & Techniques](#community-sourced-tips--techniques)
7. [YouTube Resources](#youtube-resources)
8. [Key Repos & Curated Lists](#key-repos--curated-lists)
9. [Blog Posts & Articles](#blog-posts--articles)
10. [Synthesis: What the Best Global CLAUDE.md Files Have in Common](#synthesis)

---

## How Global CLAUDE.md Works

### Loading Hierarchy (Highest to Lowest Precedence)

| Level | Location | Purpose | Shared With |
|-------|----------|---------|-------------|
| **Managed policy** | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS), `/etc/claude-code/CLAUDE.md` (Linux/WSL), `C:\Program Files\ClaudeCode\CLAUDE.md` (Windows) | Org-wide policies | All users |
| **User global** | `~/.claude/CLAUDE.md` | Personal preferences across ALL projects | Just you |
| **Project root** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team-shared project instructions | Team via git |
| **Local project** | `./CLAUDE.local.md` | Personal project-specific (gitignored) | Just you |
| **Parent dirs** | Walk up from working dir | Monorepo parent context | Team via git |
| **Subdirs** | Below working dir | Loaded on demand when Claude reads files there | Team via git |

**Key insight**: Parent directory CLAUDE.md files load at launch. Subdirectory files load lazily on demand. This matters for monorepos.

### User-Level Rules Directory

Beyond `~/.claude/CLAUDE.md`, you can use `~/.claude/rules/*.md` for modular, path-specific rules:

```
~/.claude/
├── CLAUDE.md              # Global instructions
├── rules/
│   ├── coding-style.md    # Always loaded
│   ├── security.md        # Always loaded
│   └── testing.md         # Always loaded
├── commands/              # Custom slash commands
└── settings.json          # Permissions, model config
```

### Syncing Across Machines

```bash
# Using GNU Stow
cd ~/dotfiles
stow claude  # Symlinks ~/.claude to dotfiles/claude/.claude
```

Source: [Anthropic Official Docs - Memory](https://code.claude.com/docs/en/memory)

---

## Official Anthropic Guidance

### From code.claude.com/docs/en/best-practices

**Write an effective CLAUDE.md:**
- Be direct and specific. "Use 2-space indentation" > "format code nicely"
- Include common commands (build, test, lint, deploy)
- Include coding standards and conventions
- Include architectural decisions and patterns
- Target **under 200 lines** per CLAUDE.md file
- For each line, ask: "Would Claude make a mistake without this?" If not, cut it.

**CLAUDE.md is advisory, not deterministic:**
- It's delivered at the user message layer, not system prompt
- Claude actively judges relevance and may skip instructions
- For 100% enforcement, use **hooks** instead

### From claude.com/blog/using-claude-md-files (Nov 2025)

Official Anthropic blog post with example CLAUDE.md:
```markdown
# Project Context
When working with this codebase, prioritize readability over cleverness.

## About This Project
FastAPI REST API for user authentication and profiles.

## Key Directories
- `app/models/` - database models
- `app/api/` - route handlers

## Standards
- Type hints required on all functions
- pytest for testing

## Common Commands
uvicorn app.main:app --reload  # dev server
pytest tests/ -v               # run tests
```

**Key quote:** "A well-configured CLAUDE.md transforms how Claude works with your specific project."

### From Anthropic Engineering Blog

Boris Cherny (Staff Engineer, creator of Claude Code) says:
- His own CLAUDE.md is "surprisingly vanilla" — ~100 lines, ~2,500 tokens
- He runs 10-15 Claude Code sessions simultaneously
- Team rule: "When Claude does something wrong, add it to CLAUDE.md so it doesn't repeat it"
- Every line must earn its place — no filler, no "just in case" instructions

Sources:
- [Official Best Practices](https://code.claude.com/docs/en/best-practices)
- [Official Memory Docs](https://code.claude.com/docs/en/memory)
- [Official CLAUDE.md Blog Post](https://claude.com/blog/using-claude-md-files)

---

## The "Instructions Ignored" Problem

### Why It Happens (Critical Finding)

Claude Code wraps CLAUDE.md content in a system reminder:
```
<system-reminder>
IMPORTANT: this context may or may not be relevant to your tasks.
You should not respond to this context unless it is highly relevant to your task.
</system-reminder>
```

This means Claude **actively judges relevance** and will skip instructions it deems irrelevant to the current task. The more bloated the file, the more likely instructions get ignored.

### Research Backing

ArXiv paper 2602.11988 studied context files for coding agents:
- LLM auto-generated context files **underperformed baseline** in 5/8 scenarios
- Even developer-written versions had limited benefit at +19% inference cost
- **Writing it badly is worse than not writing it at all**

### The Three-Layer Enforcement Model

| Layer | Role | Enforcement |
|-------|------|-------------|
| `settings.json` | Protects the system (permissions, allowed commands) | 100% deterministic |
| `CLAUDE.md` | Educates Claude (guidance, preferences) | ~80% advisory |
| `hooks` | Enforces rules (pre-commit, linting, formatting) | 100% deterministic |

**Rule of thumb**: If something MUST happen every time without exception, use a hook. If it's guidance Claude should consider, CLAUDE.md is fine.

### For Maximum Enforcement

Use `--append-system-prompt` to elevate critical instructions to system prompt level. This must be passed every invocation, suitable for CI/CD or cron-scheduled agents.

Sources:
- [HumanLayer Blog](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [ShareUHack Complete Guide](https://www.shareuhack.com/en/posts/claude-code-claude-md-setup-guide-2026)

---

## Best-in-Class Examples

### 1. Jesse Vincent (obra) — The "Big Daddy Rule" Original
**URL**: https://github.com/obra/dotfiles/blob/main/.claude/CLAUDE.md
**Stars**: 100 | **Lines**: ~117 | **Tokens**: ~7,300

**What makes it exceptional**: This is the CLAUDE.md that Harper Reed calls the foundation. Jesse Vincent's approach emphasizes relationship dynamics and anti-sycophancy.

**Key sections:**
- **Foundational rules** — "Violating the letter of the rules is violating the spirit"; "NEVER INVENT TECHNICAL DETAILS"
- **Our relationship** — "We're colleagues as Jesse and Bot"; "Don't glaze me. The last assistant was a sycophant"; "NEVER write 'You're absolutely right!'"
- **Proactiveness** — Clear decision framework for when to act vs. ask
- **Designing software** — YAGNI principles
- **Safe word** — "Strange things are afoot at the Circle K" for when Claude is uncomfortable pushing back
- **Testing workflow** — TDD-first approach

**Unique technique**: Explicit anti-sycophancy instructions with a code phrase for pushback.

---

### 2. Harper Reed — The "Personality" Pioneer
**URL**: https://github.com/harperreed/dotfiles/blob/master/.claude/CLAUDE.md
**Stars**: 306 | **Lines**: ~195 | **Tokens**: ~10,200

**What makes it exceptional**: Pioneered the personality/relationship approach that spawned many imitators. Includes a traffic-light decision framework.

**Key sections:**
- **Interaction** — "Any time you interact with me, you MUST address me as 'Doctor Biz'"
- **Our relationship** — Colleague framing, humor-positive, journaling/social media instructions
- **Starting a new project** — "Pick unhinged names, think 90s, monster trucks"
- **Writing code** — `NEVER USE --no-verify`; simple/clean/maintainable over clever
- **Decision-Making Framework**:
  - Green (autonomous): Fix tests, lint errors, single functions
  - Yellow (propose first): Multi-file changes, new features, API changes
  - Red (always ask): Rewriting working code, security changes, data loss risk
- **Quality standards** — Pre-commit hooks, no bypassing quality checks

**Unique technique**: Traffic-light autonomy levels (green/yellow/red) for decision-making.

---

### 3. Trail of Bits — The Security-First Template
**URL**: https://github.com/trailofbits/claude-code-config/blob/main/claude-md-template.md
**Stars**: 1,800 | **Lines**: ~207 | **Tokens**: ~10,000

**What makes it exceptional**: From a premier security research firm. Most comprehensive professional template. Includes language-specific toolchain configs.

**Key sections:**
- **Philosophy** — No speculative features, no premature abstraction, clarity over cleverness, replace don't deprecate, verify at every level, bias toward action, finish the job, agent-native by default
- **Code Quality Hard Limits**:
  - <=100 lines/function, cyclomatic complexity <=8
  - <=5 positional params, 100-char line length
  - Absolute imports only, Google-style docstrings
  - Zero warnings policy
- **Language-Specific Toolchains**:
  - Python: `uv`, `ruff`, `ty`, `pytest`
  - Node/TypeScript: `oxlint`, `vitest`
  - Rust: `clippy`, `cargo deny`
  - Bash: `shellcheck`, `shfmt`
  - GitHub Actions: `actionlint`
- **Code Review Order**: architecture -> code quality -> tests -> performance
- **Testing Methodology**: Descriptive test names, no mocks unless necessary
- **Workflow Conventions**: Imperative mood commits <=72 chars, never push to main, never commit secrets

**Unique technique**: Hard numeric limits on code quality metrics. Language-specific toolchain tables.

---

### 4. Freek Van der Herten — The Minimalist Pro
**URL**: https://github.com/freekmurze/dotfiles (under `config/claude/`)
**Blog**: https://freek.dev/3026-my-claude-code-setup

**What makes it exceptional**: Intentionally short. Focuses on critical behaviors only.

**Key elements:**
- Be critical, not sycophantic
- Follow Spatie PHP guidelines
- Use `gh` for all GitHub operations
- Custom status line showing repo name + context window usage %
- Four custom agents: laravel-simplifier, laravel-debugger, laravel-feature-builder, task-planner

**Unique technique**: Custom status line with color-coded context window percentage (green <40%, yellow 40-59%, red >=60%).

---

### 5. Joe Cotellese — The Structured Professional
**URL**: https://joecotellese.com/posts/claude-code-global-configuration/

**What makes it exceptional**: Heavily influenced by Harper Reed's structure but refined with professional development philosophy.

**Key sections:**
- Identity & personality settings
- Core development philosophy (simple over clever, TDD always, ask don't assume)
- Technology-specific guidelines
- Team dynamics and communication patterns

**Unique technique**: Explicit investment in configuration philosophy documentation.

---

### 6. Zircote — The Comprehensive Dotfiles Repo
**URL**: https://github.com/zircote/.claude
**Stars**: 21 (archived)

**What makes it exceptional**: Full `.claude/` directory as a standalone repo with agents, skills, commands, includes, hooks, and patches.

**Structure:**
```
.claude/
├── CLAUDE.md
├── agents/       # Domain-specific agents (backend, frontend, DevOps, security, data/ML)
├── commands/     # Custom slash commands
├── hooks/        # Pre/post commit hooks
├── includes/     # Shared instruction fragments
├── skills/       # Reusable skill definitions
└── patches/      # Configuration patches
```

**Unique technique**: Modular organization with includes for composable instructions.

---

### 7. Boris Cherny (Creator of Claude Code) — The Minimal Master
**Blog**: https://mindwiredai.com/2026/03/25/claude-code-creator-workflow-claudemd/

**Lines**: ~100 | **Tokens**: ~2,500

**Key sections (from public preview):**
- **Workflow Orchestration**:
  1. Plan Mode Default — enter plan mode for ANY non-trivial task (3+ steps)
  2. Subagent Strategy — use subagents liberally, one task per subagent
  3. Self-Improvement Loop — track what works, adapt
- **Quality Gates**:
  4. Testing Rigor — verify correctness
  5. Demand Elegance (Balanced) — "is there a more elegant way?" (skip for simple fixes)
  6. Autonomous Bug Fixing — just fix it, zero context switching
- **Task Management**: Plan first to tasks/todo.md, verify plan, track progress

**Unique technique**: Only ~100 lines yet outperforms 800-line configs. Every line solves a real problem.

---

## Common Sections & Patterns

### Sections Found Across Multiple Top Configs

| Section | Found In | Purpose |
|---------|----------|---------|
| **Philosophy/Principles** | Trail of Bits, Boris, Joe | Core development values |
| **Relationship/Identity** | Jesse, Harper, Joe | Anti-sycophancy, personality |
| **Autonomy Levels** | Harper, Jesse | When to act vs. ask |
| **Code Quality Rules** | Trail of Bits, Jesse, Harper | Hard limits, formatting |
| **Testing Approach** | Jesse, Trail of Bits, Boris | TDD, test-first |
| **Language/Toolchain** | Trail of Bits | Specific tools per language |
| **Workflow/Planning** | Boris, Harper, Jesse | Plan mode, subagents |
| **Common Commands** | Anthropic official | Build, test, lint, deploy |
| **Git/Commit Rules** | Trail of Bits, Harper | Commit format, branch rules |
| **Error Handling** | Trail of Bits | Fail fast, clear messages |

### The "What-Why-How" Framework (HumanLayer)

From https://www.humanlayer.dev/blog/writing-a-good-claude-md:

- **WHAT**: Tech stack, project structure, key directories (give Claude a map)
- **WHY**: Purpose of the project and its parts
- **HOW**: How Claude should work on the project (tools, commands, verification)

### Global vs Project: What Goes Where

| Global (`~/.claude/CLAUDE.md`) | Project (`./CLAUDE.md`) |
|-------------------------------|------------------------|
| Personal coding style | Project architecture |
| Anti-sycophancy rules | Team coding standards |
| Preferred tools (gh, uv, etc.) | Build/test commands |
| Decision-making framework | Key directories map |
| Cross-project conventions | Domain-specific patterns |
| Personality/relationship rules | CI/CD workflows |

---

## Community-Sourced Tips & Techniques

### From shanraisshan/claude-code-best-practice (32.7k stars)
**URL**: https://github.com/shanraisshan/claude-code-best-practice

Largest community resource (303 commits, 32.7k stars). Key tips:
- "Challenge Claude — 'grill me on these changes and don't make a PR until I pass your test'" (Boris Cherny)
- "After a mediocre fix — 'knowing everything you know now, scrap this and implement the elegant solution'" (Boris Cherny)
- "Claude fixes most bugs by itself — paste the bug, say 'fix', don't micromanage how" (Boris Cherny)

### From Builder.io (50 Tips Article)
**URL**: https://www.builder.io/blog/claude-code-tips-best-practices

- Use `--worktree` for isolated parallel branches (Boris calls this "one of the biggest productivity unlocks")
- Give Claude a way to check its own work (include test commands in prompts) — 2-3x quality improvement
- Set up `cc` alias for `claude --dangerously-skip-permissions`
- Prefix `!` to run bash commands inline
- Esc stops mid-action; Esc+Esc opens rewind/checkpoint menu

### From MorphLLM
**URL**: https://www.morphllm.com/claude-md-examples

- Prompt caching: CLAUDE.md content is cached in system prompt, so multi-turn cost is minimal
- The 200-line guideline: "target under 200 lines per CLAUDE.md file"
- Import system: Use `@path` imports to break large configs into smaller files (max 5 levels deep)
- Monorepo pattern: Root CLAUDE.md for org standards, package-level for package-specific context

### From Kirill Markin
**URL**: https://kirill-markin.com/articles/claude-code-rules-for-ai/

Key insight: "What actually improved my day-to-day was much simpler: a stable user-wide CLAUDE.md and a clean project CLAUDE.md. That stack makes Claude calmer. Fewer random fallbacks. Fewer cute abstractions."

### From Ran Isenberg (RanTheBuilder)
**URL**: https://ranthebuilder.cloud/blog/claude-code-best-practices-lessons-from-real-projects/

- "The tool does not matter nearly as much as the person holding it"
- Use BMAD Method for large projects, Claude Code plan mode for smaller features
- Opus for heavy lifting (architecture, security), Sonnet for planning and iterative polish

### Reddit Community Consensus

From aggregated Reddit discussions:
- Skills are more token-efficient than CLAUDE.md for specialized instructions (only loaded when needed)
- Multi-agent pattern is the most discussed advanced technique
- r/ClaudeCode had 4,200+ weekly contributors by early 2026
- Feedback loops (letting Claude check its own work) are the dream setup

---

## YouTube Resources

### Dedicated CLAUDE.md Videos

| Video | Channel | Date | URL |
|-------|---------|------|-----|
| "How to Use CLAUDE.md in Claude Code in 5 Minutes" | GritAI Studio | Jan 2026 | https://youtube.com/watch?v=h7QJL2_gEXA |
| "Claude.md Configurations Explained in 5 Minutes" | bytecodecrux | Aug 2025 | https://youtube.com/watch?v=lHAzFGCAcrU |
| "Claude Code Tutorial #2 - CLAUDE.md Files & /init" | Net Ninja | Aug 2025 | https://youtube.com/watch?v=i_OHQH4-M2Y |
| "How to actually force Claude Code to use the right CLI (don't use CLAUDE.md)" | Matt Pocock | Feb 2026 | https://youtube.com/watch?v=3CSi8QAoN-s |

### Broader Claude Code Setup Videos

| Video | Channel | Date | URL |
|-------|---------|------|-----|
| "How I Start EVERY Claude Code Project" | AI with Avthar | Dec 2025 | https://youtube.com/watch?v=aQvpqlSiUIQ |
| "How I use Claude Code for real engineering" | Matt Pocock | Oct 2025 | https://youtube.com/watch?v=kZ-zzHVUrO4 |
| "12 Hidden Settings To Enable In Your Claude Code Setup" | AI LABS | Mar 2026 | https://youtube.com/watch?v=pDoBe4qbFPE |
| "5 Claude Code skills I use every single day" | Matt Pocock | Mar 2026 | https://youtube.com/watch?v=EJyuu6zlQCg |
| "How I use Claude Code (Meta Staff Engineer Tips)" | John Kim | Feb 2026 | https://youtube.com/watch?v=mZzhfPle9QU |
| "FULL Claude Code Tutorial for Beginners in 2026!" | Tech With Tim | Mar 2026 | https://youtube.com/watch?v=qYqIhX9hTQk |

### Notable Matt Pocock Insight

His video "How to actually force Claude Code to use the right CLI (don't use CLAUDE.md)" argues that **hooks** are better than CLAUDE.md for enforcing CLI tool choices because CLAUDE.md is advisory while hooks are deterministic.

---

## Key Repos & Curated Lists

### Primary Repos

| Repo | Stars | Description | URL |
|------|-------|-------------|-----|
| shanraisshan/claude-code-best-practice | 32.7k | The largest community resource (69 tips, agent teams, workflows) | https://github.com/shanraisshan/claude-code-best-practice |
| trailofbits/claude-code-config | 1.8k | Professional template with security focus, hooks, MCP configs | https://github.com/trailofbits/claude-code-config |
| hesreallyhim/awesome-claude-code | — | Curated list of skills, hooks, commands, plugins | https://github.com/hesreallyhim/awesome-claude-code |
| rohitg00/awesome-claude-code-toolkit | — | 135 agents, 35 skills, 42 commands, 150+ plugins | https://github.com/rohitg00/awesome-claude-code-toolkit |
| harperreed/dotfiles | 306 | Harper Reed's full .claude/ configuration | https://github.com/harperreed/dotfiles |
| obra/dotfiles | 100 | Jesse Vincent's foundational CLAUDE.md | https://github.com/obra/dotfiles |
| freekmurze/dotfiles | — | Freek Van der Herten's minimal config | https://github.com/freekmurze/dotfiles |
| zircote/.claude | 21 | Full .claude directory as standalone repo (archived) | https://github.com/zircote/.claude |
| ykdojo/claude-code-tips | — | 45 tips including status line, system prompt optimization | https://github.com/ykdojo/claude-code-tips |
| luongnv89/claude-howto | — | Visual, example-driven guide with copy-paste templates | https://github.com/luongnv89/claude-howto |

### Dotfiles with CLAUDE.md

| Repo | URL |
|------|-----|
| rlch/dotfiles | https://github.com/rlch/dotfiles/blob/main/CLAUDE.md |
| ryoppippi/dotfiles | https://github.com/ryoppippi/dotfiles/blob/main/CLAUDE.md |

---

## Blog Posts & Articles

### Tier 1: Must-Read

| Article | Author | URL |
|---------|--------|-----|
| Writing a good CLAUDE.md | HumanLayer | https://www.humanlayer.dev/blog/writing-a-good-claude-md |
| Basic Claude Code | Harper Reed | https://harper.blog/2025/05/08/basic-claude-code/ |
| Using CLAUDE.MD files | Anthropic (official) | https://claude.com/blog/using-claude-md-files |
| CLAUDE.md Complete Guide (2026) | ShareUHack | https://www.shareuhack.com/en/posts/claude-code-claude-md-setup-guide-2026 |
| Claude Code Best Practices (official) | Anthropic | https://code.claude.com/docs/en/best-practices |

### Tier 2: Excellent Reference

| Article | Author | URL |
|---------|--------|-----|
| CLAUDE.md Examples and Best Practices 2026 | MorphLLM | https://www.morphllm.com/claude-md-examples |
| My Claude Code Setup: Global Configuration | Joe Cotellese | https://joecotellese.com/posts/claude-code-global-configuration/ |
| Claude Code Rules: CLAUDE.md Global Instructions | Kirill Markin | https://kirill-markin.com/articles/claude-code-rules-for-ai/ |
| 50 Claude Code Tips and Best Practices | Builder.io | https://www.builder.io/blog/claude-code-tips-best-practices |
| Claude Code Best Practices: Lessons From Real Projects | Ran Isenberg | https://ranthebuilder.cloud/blog/claude-code-best-practices-lessons-from-real-projects/ |
| My Claude Code setup | Freek Van der Herten | https://freek.dev/3026-my-claude-code-setup |

### Tier 3: Supporting Material

| Article | Author | URL |
|---------|--------|-----|
| Anatomy of the .claude/ Folder | Avi Chawla | https://blog.dailydoseofds.com/p/anatomy-of-the-claude-folder |
| CLAUDE.md, AGENTS.md, and Every AI Config File Explained | DeployHQ | https://www.deployhq.com/blog/ai-coding-config-files-guide |
| Claude Code - The Missing Manual | Arthur Clune | https://clune.org/posts/claude-code-manual/ |
| How the Creator of Claude Code Actually Uses It | MindWired AI | https://mindwiredai.com/2026/03/25/claude-code-creator-workflow-claudemd/ |
| 24 Claude Code Tips (#claude_code_advent_calendar) | Ado | https://dev.to/oikon/24-claude-code-tips-claudecodeadventcalendar-52b5 |

---

## Synthesis

### What the Best Global CLAUDE.md Files Have in Common

**1. They're SHORT (60-200 lines)**
- Boris Cherny: ~100 lines
- HumanLayer: <60 lines
- Anthropic recommendation: <200 lines
- Every line must earn its place. "Would Claude make a mistake without this?"

**2. They focus on universally applicable rules**
- Personal coding style that applies to EVERY project
- Anti-sycophancy instructions
- Decision-making framework (when to act vs. ask)
- Preferred tools and CLI conventions

**3. They establish a working relationship**
- Jesse Vincent: "We're colleagues, not hierarchy"
- Harper Reed: "We're coworkers, think of me as Doctor Biz"
- Anti-sycophancy: "Don't glaze me", "Never say 'You're absolutely right!'"

**4. They define autonomy boundaries**
- Green/Yellow/Red traffic light system (Harper Reed)
- "Just do it" vs. "Propose first" vs. "Always ask" (Jesse Vincent)
- Clear guardrails prevent both over-caution and recklessness

**5. They push project-specific details to project CLAUDE.md**
- Global: coding style, tools, relationship, philosophy
- Project: architecture, commands, directories, domain rules

**6. They use hooks for enforcement, CLAUDE.md for guidance**
- CLAUDE.md is ~80% compliance (advisory)
- Hooks are 100% deterministic
- settings.json is 100% system protection

**7. They iterate based on real problems**
- Boris: "When Claude does something wrong, add it to CLAUDE.md"
- Jesse: Every rule exists because it solved a real problem
- Start minimal, add rules when you catch recurring mistakes

### The Ideal Global CLAUDE.md Structure

Based on synthesis of all sources:

```markdown
# Global Development Standards

## Philosophy
[3-5 core development principles]

## Our Relationship
[Anti-sycophancy, how to address you, when to push back]

## Decision Framework
[Green/Yellow/Red autonomy levels]

## Code Quality
[Hard limits: function length, complexity, formatting]

## Preferred Tools
[CLI tools, package managers, linters per language]

## Testing
[TDD approach, test-first rules]

## Git Workflow
[Commit format, branch rules, PR process]

## Common Patterns
[Error handling, imports, documentation style]
```

Target: 100-150 lines. Every line solves a real problem.
