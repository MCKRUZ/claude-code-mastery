# Development Workflow

## 5-Phase Pipeline

For non-trivial features (3+ files or unclear requirements), follow these phases in order.

### Phase 1: Research & Reuse
Before writing new code, search for existing solutions:
1. **Codebase first**: `grep`, `glob` for similar patterns already in the project
2. **GitHub search**: `gh search repos` and `gh search code` for proven implementations
3. **Library docs**: Use Context7 (`resolve-library-id` then `query-docs`) for API specifics
4. **Registry search**: npm, NuGet, PyPI before hand-rolling utilities

Only proceed to implementation after confirming no suitable solution exists.

### Phase 2: Plan
- Enter plan mode for 5+ file features
- Define the approach, files to touch, and order of changes
- Identify risks and unknowns upfront
- Get user alignment before writing code

### Phase 3: Implement (TDD when applicable)
- Write failing test first (for bug fixes: always; for features: when requested)
- Implement the minimum code to pass
- Refactor while tests stay green

### Phase 4: Verify
- Run `/verification-loop` or manually check: build, types, lint, tests, security, diff
- 80% coverage minimum on new code
- No console.log, no hardcoded secrets, no TODO comments

### Phase 5: Commit & Review
- Stage specific files (not `git add -A`)
- Commit message: `type: description` (imperative mood, under 72 chars)
- For PRs: full commit history analysis, comprehensive description

## Research-First Rule

**This is mandatory, not optional.** When implementing something new:
- Spend 2-5 minutes researching before writing any code
- Check if someone has already solved this problem (in this codebase or externally)
- Verify API signatures and framework behavior against docs, not memory
- Prefer adapting a proven 80% solution over building from scratch
