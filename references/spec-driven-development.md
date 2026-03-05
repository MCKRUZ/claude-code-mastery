# Spec-Driven Development with Claude Code

> **Extracted from:** GSD (get-shit-done) system analysis — 2026-03-03
> **Purpose:** Reference for running structured, multi-phase projects with Claude Code where quality must be consistent across long timelines.

Spec-driven development is a methodology for building larger systems with Claude Code reliably. Instead of prompting task by task, you define a complete specification upfront, plan each phase against it, execute with fresh executor contexts, and verify with human acceptance tests before moving on.

---

## Project Artifact Set

These files form the persistent state of a project. Each serves a distinct purpose:

| File | Purpose | Updated by |
|------|---------|-----------|
| `PROJECT.md` | Vision, goals, success criteria, out-of-scope | Once at project start |
| `REQUIREMENTS.md` | Scoped v1/v2 requirements with phase traceability | At project start; refined at milestones |
| `ROADMAP.md` | Phases mapped to requirements, progress tracking | As phases complete |
| `STATE.md` | Decisions made, blockers, current position | Continuously during execution |
| `{N}-CONTEXT.md` | User's implementation preferences for phase N | Before planning phase N |
| `{N}-RESEARCH.md` | Domain research for phase N (stack, features, architecture, pitfalls) | Before planning phase N |
| `{N}-{M}-PLAN.md` | Atomic task plan for plan M of phase N | During planning phase N |
| `{N}-{M}-SUMMARY.md` | Post-execution record: what changed, commits made | After executing plan M |
| `{N}-VERIFICATION.md` | Automated verification: did code deliver phase goals? | After executing phase N |
| `{N}-UAT.md` | Human acceptance test results, issues found, fix plans | During verify-work for phase N |

**Why STATE.md matters:** Between sessions, Claude has no memory of decisions made mid-execution. `STATE.md` is the session-persistent source of truth — what's been decided, what's blocked, where execution paused. Without it, you re-debate every decision.

---

## The Lifecycle

```
new-project
  ↓ Questions → research → requirements → roadmap

FOR EACH PHASE:
  discuss-phase  ← lock user decisions before planning
  plan-phase     ← research + plan + verify (plan-checker loop)
  execute-phase  ← wave execution with fresh executor contexts
  verify-work    ← human UAT → auto-generate fix plans if issues

complete-milestone → archive + tag release
new-milestone      ← repeat for next version
```

---

## Goal-Backward Planning

Work backward from the phase goal to derive tasks. Never start with "what can I build?" — start with "what must be true when this phase is done?"

**Process:**
1. State the phase goal precisely: "Users can register, verify email, and log in"
2. List must-haves: what observable behaviors confirm this goal is met?
3. For each must-have, identify what needs to exist in code
4. Group into atomic plans: each plan produces something independently deployable/testable
5. Verify backward: "If all these plans complete, does the phase goal hold?"

**Plan granularity:** 2-3 tasks per plan. Small enough to execute in a fresh context window without degradation. Large enough to be independently meaningful.

**Anti-pattern:** Deriving tasks from features instead of goals. "I'll add a registration form, a login form, and a password reset form" — this is feature-driven, not goal-driven. The goal-backward version asks: "What's the minimum for users to be able to authenticate?" Then derives the minimum set of tasks.

---

## User Decision Fidelity Protocol

The most common failure mode in AI-driven development: Claude makes "reasonable" choices that override what the user actually wanted. The discuss → lock → honor protocol prevents this.

### Phase 1: Discuss (before planning)

Ask targeted questions about the gray areas *specific to what's being built*:

- **Visual features** → layout, density, interaction patterns, empty states
- **APIs/CLIs** → response format, flag conventions, error verbosity
- **Content systems** → structure, tone, depth, flow
- **Data operations** → grouping criteria, exception handling, deduplication rules

Don't ask generic questions. Ask about the specific decisions that will shape this phase's implementation.

### Phase 2: Lock

Produce a `CONTEXT.md` file with three categories:

```markdown
## Decisions (LOCKED — must implement exactly as specified)
- Use card layout, not table
- Infinite scroll, not pagination
- Library: jose for JWT (not jsonwebtoken)

## Deferred Ideas (OUT OF SCOPE — do not implement)
- Dark mode
- Search functionality
- Export to CSV

## Claude's Discretion (reasonable defaults acceptable)
- Error message wording
- Loading state design
- Color choices within the established palette
```

### Phase 3: Honor (during planning)

Planner reads CONTEXT.md before producing any plan. For each plan:
- Every locked decision must have a task implementing it
- No task may implement a deferred idea
- Discretion areas get reasonable defaults, documented in task action

**Conflict resolution:** If research suggests library Y but user locked library X, honor the lock. Document the conflict in the task action: "Using X per user decision (research suggested Y for reason Z)."

---

## Parallel Research Team

Before planning a phase, run 4 parallel research agents simultaneously:

| Researcher | Investigates |
|-----------|-------------|
| **Stack** | What libraries, frameworks, tools are available and recommended for this domain? What are the current best options? |
| **Features** | How do successful implementations of similar features work? What patterns and conventions exist? |
| **Architecture** | How should this be structured? What are the common architectural patterns and their trade-offs? |
| **Pitfalls** | What are the common failure modes, gotchas, and anti-patterns to avoid? |

All four run in parallel. A synthesizer agent combines the findings into `RESEARCH.md`. The planner reads RESEARCH.md (plus CONTEXT.md) before producing plans.

**Why parallel, not sequential:** Each researcher is independent. Running them sequentially adds 4x latency with no quality gain.

---

## Brownfield Codebase Mapping

Before planning any changes to an existing codebase, run parallel analysis agents to understand what's already there:

| Analyzer | Investigates |
|---------|-------------|
| **Stack** | Languages, frameworks, versions, package manager, build system |
| **Architecture** | Folder structure, module boundaries, layer separation, dependency direction |
| **Conventions** | Naming patterns, file organization, code style, testing approach |
| **Concerns** | Tech debt, inconsistencies, areas of risk, files that are frequently modified |

Output feeds into planning so that: questions in discuss-phase focus on *what's being added* (not the existing system), plans automatically use existing patterns and libraries, and the planner knows which files are high-risk to modify.

**When to run:** Any time you're adding a significant feature to an existing codebase before the first discuss-phase.

---

## UAT Verify Loop (Human Acceptance Testing)

Automated verification (tests passing, code existing) is not enough. The UAT loop confirms the feature *works the way the user imagined*.

**Process:**

1. **Extract testable deliverables** — from phase goals, derive specific observable behaviors: "Can you submit the registration form?" "Does an email arrive?"
2. **Present one at a time** — don't dump all tests at once. Walk through each: "Try X. Did it work?" Yes / No / Describe what happened.
3. **On failure: diagnose** — spawn a debug agent to investigate root cause (logs, stack traces, state inspection). Do not ask the user to debug.
4. **Auto-generate fix plans** — produce fix PLAN.md files ready for immediate re-execution. Don't ask the user to describe the fix.
5. **Re-execute** — run the fix plans through the same wave execution process.

**Design principle:** The human's job is to use the feature and say whether it works. Everything else is Claude's job.

---

## Atomic Git Commits Per Task

Each task in a plan gets its own commit immediately upon completion. Never batch multiple tasks into one commit.

**Benefits:**
- `git bisect` finds the exact task that introduced a failure
- Each task is independently revertable
- Clean history that Claude can read in future sessions to understand what changed and when
- Failure in task 3 of 5 doesn't require re-running tasks 1 and 2

**Commit format:**
```
feat(phase-task): implement email verification flow
fix(phase-task): correct JWT expiry handling
```

The phase-task identifier in the commit message lets you trace any commit back to its source plan.

---

## When to Use This Methodology

Use spec-driven development when:
- The project will span multiple sessions (context will be lost between sessions)
- Multiple features must be built in a specific order with dependencies
- Quality consistency matters more than speed (each phase verified before the next begins)
- You're working brownfield and need to understand the existing system before adding to it

Use ad-hoc prompting (or `/gsd:quick` equivalent) when:
- Single session, single task
- Bug fixes, small tweaks, one-off scripts
- Exploration and prototyping where requirements are unknown
