---
name: /sdlc-setup
description: Interactive setup wizard to initialize SDLC lifecycle management for a project.
---

# /sdlc-setup - Interactive Setup Wizard

Initialize SDLC lifecycle management for a project.

## Workflow

### Step 1: Check Existing Setup
Look for `.sdlc/state.yaml` in the current directory.
- If exists: warn the user that SDLC is already initialized. Ask if they want to view status (`/sdlc`) or re-initialize (destructive -- requires confirmation).
- If not exists: proceed with setup.

### Step 2: Profile Selection
List available profiles:

- **microsoft-enterprise** — C#/.NET 8 + Angular 17 + Azure, SOC 2 compliance, 80% coverage minimum, TDD required
- **starter** — Minimal profile, no compliance gates, quick start for any stack

Ask the user to select a profile.

### Step 3: Project Configuration
Ask the user for:
- **Project name** (default: current directory name)
- Confirm the selected profile settings are appropriate

### Step 4: Initialize .sdlc/

Create the following directory structure:
```
.sdlc/
  state.yaml          # Phase tracking (Phase 0: Discovery active)
  profile.yaml        # Frozen copy of selected profile
  constitution.md     # Project constitution
  artifacts/          # Per-phase artifact directories (00-09)
```

If an init script is available (e.g., `init_project.py`), run it:
```bash
python scripts/init_project.py \
  --profile profiles/<selected-profile>/profile.yaml \
  --target . \
  --name "<project-name>"
```

Otherwise, create the directory structure manually.

### Step 5: Update CLAUDE.md / Project Instructions
Read the profile's `claude-md-template.md` and append its contents to the project's instruction file:
- If project instructions exist: append the SDLC section
- If they don't exist: create with the SDLC section

### Step 6: Confirmation
Display:
```
SDLC initialized successfully!

Profile: <profile-id>
Phase: 0 - Discovery (active)
Artifacts: .sdlc/artifacts/00-discovery/

Next steps:
1. Run /sdlc to see Phase 0 guidance
2. Create your problem statement in .sdlc/artifacts/00-discovery/problem-statement.md
3. Check exit criteria when ready
4. Advance to Phase 1 when criteria are met
```

### Step 7: Validate
Run the profile validator to confirm the setup is healthy (if available):
```bash
python scripts/validate_profile.py .sdlc/profile.yaml
```

## Error Handling
- If profile validation fails: show errors and suggest fixes
- If directory permissions prevent creation: report the error clearly
