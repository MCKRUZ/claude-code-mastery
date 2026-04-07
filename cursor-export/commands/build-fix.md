---
name: /build-fix
description: Incrementally fix TypeScript and build errors one at a time, verifying each fix before moving on.
---

# Build and Fix

Incrementally fix TypeScript and build errors with verification after each fix.

## Workflow

1. **Run build**: `npm run build` or `pnpm build`

2. **Parse error output**:
   - Group by file
   - Sort by severity

3. **For each error**:
   - Show error context (5 lines before/after)
   - Explain the issue
   - Propose fix
   - Apply fix
   - Re-run build
   - Verify error resolved

4. **Stop if**:
   - Fix introduces new errors
   - Same error persists after 3 attempts
   - User requests pause

5. **Show summary**:
   - Errors fixed
   - Errors remaining
   - New errors introduced

## Important

Fix one error at a time for safety. Always verify the build after each fix before moving to the next error.
