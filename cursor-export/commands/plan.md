---
name: /plan
description: Restate requirements, assess risks, and create a step-by-step implementation plan. WAIT for user CONFIRM before touching any code.
---

# Plan Command

Create a comprehensive implementation plan before writing any code.

## Workflow

1. **Restate Requirements** - Clarify what needs to be built
2. **Identify Risks** - Surface potential issues and blockers
3. **Create Step Plan** - Break down implementation into phases
4. **Wait for Confirmation** - MUST receive user approval before proceeding

## When to Use

Use `/plan` when:
- Starting a new feature
- Making significant architectural changes
- Working on complex refactoring
- Multiple files/components will be affected
- Requirements are unclear or ambiguous

## Process

1. **Analyze the request** and restate requirements in clear terms
2. **Break down into phases** with specific, actionable steps
3. **Identify dependencies** between components
4. **Assess risks** and potential blockers
5. **Estimate complexity** (High/Medium/Low)
6. **Present the plan** and WAIT for explicit confirmation

## Output Format

```
# Implementation Plan: [Feature Name]

## Requirements Restatement
- [Clear bullet points of what needs to be built]

## Implementation Phases

### Phase 1: [Name]
- [Specific actionable steps]
- [Files to create/modify]

### Phase 2: [Name]
- [Steps]

## Dependencies
- [External services, libraries, etc.]

## Risks
- HIGH: [Critical risks]
- MEDIUM: [Notable risks]
- LOW: [Minor risks]

## Estimated Complexity: [HIGH/MEDIUM/LOW]
- [Time estimates per phase]

**WAITING FOR CONFIRMATION**: Proceed with this plan? (yes/no/modify)
```

## Important

**CRITICAL**: Do **NOT** write any code until the user explicitly confirms the plan with "yes", "proceed", or similar affirmative response.

If the user wants changes, they can respond with:
- "modify: [changes]"
- "different approach: [alternative]"
- "skip phase X and do phase Y first"

## Integration with Other Commands

After planning:
- Use `/tdd` to implement with test-driven development
- Use `/build-fix` if build errors occur
- Use `/code-review` to review completed implementation
