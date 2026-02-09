# Rules Directory Pattern

The `.claude/rules/` directory allows you to organize coding standards, conventions, and patterns that are scoped to specific file paths using frontmatter.

## Why Use Rules Instead of CLAUDE.md?

**CLAUDE.md** should contain universally applicable instructions for all files in your project. When you have rules that only apply to specific parts of the codebase (e.g., API layer, frontend components, database layer), put them in `.claude/rules/` with path-scoped frontmatter.

**Benefits:**
1. **Token efficiency** — Rules only load when Claude is working on matching files
2. **Better organization** — Separate concerns by domain/layer
3. **Team collaboration** — Different team members can own different rules files
4. **Easier maintenance** — Update frontend rules without touching backend standards

## File Structure

```
~/.claude/rules/           # User-global rules (all projects)
  ├── agents.md            # Agent orchestration patterns
  ├── coding-style.md      # General coding conventions
  ├── git-workflow.md      # Git commit and PR standards
  ├── hooks.md             # Hook system documentation
  ├── patterns.md          # Common code patterns
  ├── performance.md       # Performance optimization rules
  ├── security.md          # Security guidelines
  └── testing.md           # Testing requirements

.claude/rules/             # Project-specific rules
  ├── frontend.md          # Frontend-specific rules
  ├── backend.md           # Backend-specific rules
  ├── api.md               # API endpoint conventions
  └── database.md          # Database schema rules
```

## Example Rules Files

### Path-Scoped Rule (Frontend Only)

**`.claude/rules/frontend.md`:**
```yaml
---
paths: src/components/**/*.tsx
---
# Frontend Component Rules

## React/Next.js Standards
- Use functional components with hooks
- Prefer React Server Components (RSC) by default
- Add 'use client' directive only when needed (interactivity, browser APIs)
- No prop drilling beyond 2 levels — use Context or state management

## Component Structure
1. Imports (React first, then libraries, then local)
2. Type definitions
3. Component function
4. Styled components or CSS modules
5. Export

## Common Mistakes
- Using `useEffect` for derived state: Calculate during render instead
- Forgetting `key` prop in lists: Always include unique keys
```

### Layer-Specific Rule (API Layer)

**`.claude/rules/api.md`:**
```yaml
---
paths: src/api/**/*.ts
---
# API Endpoint Rules

## Validation
- All endpoints MUST validate input with zod schemas
- Return consistent error format: { error: string, code: number }

## Error Handling
- 400: Bad Request (validation failed)
- 401: Unauthorized (missing/invalid auth)
- 403: Forbidden (valid auth, insufficient permissions)
- 404: Not Found
- 500: Internal Server Error (logged, user sees generic message)

## Response Format
All successful responses return:
```typescript
{
  success: true,
  data: T,
  meta?: { total: number, page: number, limit: number }
}
```
```

### Language-Specific Rule

**`.claude/rules/typescript.md`:**
```yaml
---
paths: "**/*.ts"
---
# TypeScript Standards

## Type Safety
- No `any` types (use `unknown` if necessary)
- Prefer interfaces for objects, types for unions/primitives
- Use discriminated unions for state management

## Naming Conventions
- Interfaces: PascalCase
- Types: PascalCase
- Functions/variables: camelCase
- Constants: UPPER_SNAKE_CASE or camelCase
- Files: kebab-case

## Imports
- Prefer named exports over default exports
- Use path aliases (@/ for src/) to avoid ../../../
```

## Example User-Global Rules

These live in `~/.claude/rules/` and apply to all your projects:

### `~/.claude/rules/agents.md`

Documents which built-in agents to use and when (planner, architect, tdd-guide, code-reviewer, etc.).

### `~/.claude/rules/coding-style.md`

Your personal coding standards (immutability, file organization, error handling, naming conventions). Typically language-specific.

### `~/.claude/rules/git-workflow.md`

How you like to structure commits, PRs, and branch management.

### `~/.claude/rules/security.md`

Security checklist, secret management, input validation patterns.

### `~/.claude/rules/testing.md`

Testing requirements (80% coverage, TDD workflow, unit/integration/e2e patterns).

## Best Practices

1. **Use path scoping aggressively** — Don't load API rules when working on UI components
2. **Keep rules DRY** — Common patterns go in global `~/.claude/rules/`, project-specific in `.claude/rules/`
3. **Document "why" not "what"** — Explain the reasoning behind rules
4. **Update rules when Claude makes mistakes** — Rules should evolve from real errors
5. **Version control project rules** — Commit `.claude/rules/` to git so the team shares standards
6. **Keep rules focused** — One concern per file (frontend, API, database, etc.)

## Path Pattern Syntax

```yaml
---
paths: src/api/**/*.ts                    # All .ts files in src/api/
paths: ["src/**/*.tsx", "app/**/*.tsx"]   # Multiple patterns
paths: "*.test.ts"                        # All test files
---
```

## Integration with CLAUDE.md

**CLAUDE.md hierarchy (all merged):**
1. Enterprise: `/etc/claude-code/CLAUDE.md`
2. User-global: `~/.claude/CLAUDE.md`
3. Project: `./CLAUDE.md`
4. Project local: `./CLAUDE.local.md`
5. Subdirectory: `foo/bar/CLAUDE.md`
6. **Rules directory: `.claude/rules/*.md`** ← Path-scoped activation

## When to Use Rules vs CLAUDE.md

| Use CLAUDE.md | Use .claude/rules/ |
|---------------|-------------------|
| Project overview | Layer-specific conventions |
| Stack & architecture | API endpoint patterns |
| Common commands | Database schema rules |
| Universal code style | Frontend component standards |
| Task approach | Backend service patterns |
| Build/test/lint commands | Security validation for APIs |

## Example Monorepo Setup

```
monorepo/
├── CLAUDE.md                              # Shared: stack, architecture, build commands
├── .claude/rules/
│   ├── frontend.md                        # paths: apps/web/**
│   ├── backend.md                         # paths: apps/api/**
│   ├── shared.md                          # paths: packages/**
│   └── database.md                        # paths: packages/db/**
└── apps/
    ├── web/CLAUDE.md                      # Web-specific overrides
    └── api/CLAUDE.md                      # API-specific overrides
```

## Testing Your Rules

1. Work on a file that should trigger the rule
2. Ask Claude: "What rules apply to this file?"
3. Verify the rule content is loaded correctly
4. Make intentional mistake to confirm Claude catches it

## Common Pitfalls

❌ **Too broad paths** — `paths: "**/*"` defeats the purpose of scoping
❌ **Duplicating CLAUDE.md** — Don't repeat universal instructions
❌ **No frontmatter** — Rules without `paths:` frontmatter won't activate correctly
❌ **Not version controlling** — `.claude/rules/` should be committed to git
❌ **Over-engineering** — Start with 2-3 rules files, add more as needed

## Resources

- [Claude Code Docs: Rules Directory](https://docs.claude.ai/code/rules)
- [CLAUDE.md Best Practices](https://docs.claude.ai/code/claude-md)
