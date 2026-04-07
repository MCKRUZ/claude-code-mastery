---
name: /sdlc
description: Show guidance for the current SDLC phase including what to do, which skills to use, and what artifacts to produce.
---

# /sdlc - Phase Guidance

Show guidance for the current SDLC phase including what to do, which skills to use, and what artifacts to produce.

## Workflow

1. **Locate state file:** Look for `.sdlc/state.yaml` in the current project directory. If not found, tell the user to run `/sdlc-setup` first and exit.

2. **Read state:** Load `.sdlc/state.yaml` to get `current_phase`.

3. **Load phase definition:** Read the phase definition file from `phases/XX-phasename.md` (where XX is the zero-padded phase number).

4. **Load profile:** Read `.sdlc/profile.yaml` to get stack and quality configuration.

5. **Display phase context:**

   ### Header
   ```
   Phase {N}: {Name}
   Profile: {profile_id}
   ```

   ### Purpose
   One-line description of this phase's goal.

   ### What to Do Next
   Based on the phase workflow steps and current artifact state:
   - List the next actionable step
   - Reference the specific skill/command to use
   - Example: "Run `/plan` to decompose your problem statement into requirements"

   ### Required Artifacts
   List artifacts needed to pass exit gates, with status:
   - [x] artifact.md (exists, 1.2KB)
   - [ ] other-artifact.md (missing)

   ### Skills to Use
   List primary and secondary skills for this phase with brief description.

   ### Exit Criteria
   Summarize what must be true to advance (from phase definition's exit criteria).

   ### Quick Commands
   ```
   /sdlc-setup   - Initialize SDLC for a project
   ```

6. **Compliance callout:** If the profile has compliance frameworks, note any compliance-specific requirements for this phase.

7. **Be concise.** The phase definition file has full details -- this command shows the actionable summary, not the full document.

## Arguments
- No arguments: show guidance for current phase
- `<phase-number>`: show guidance for a specific phase (e.g., `/sdlc 3`)

## SDLC Sub-Commands

The full SDLC lifecycle includes these additional sub-commands (not yet ported to Cursor -- available in Claude Code):

| Sub-Command | Purpose |
|-------------|---------|
| `/sdlc-gate` | Run exit criteria check for the current phase |
| `/sdlc-next` | Advance to the next phase (runs gate check first) |
| `/sdlc-phase-report` | Generate an HTML report for the current phase |
| `/sdlc-status` | View full SDLC progress dashboard |

These can be manually replicated by checking `.sdlc/state.yaml` and the corresponding phase definition files.
