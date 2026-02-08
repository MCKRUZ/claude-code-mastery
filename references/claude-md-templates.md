# CLAUDE.md Templates

> Ready-to-use templates for common project types. Copy and customize.

---

## Template: TypeScript/Next.js Project

```markdown
# Project: [Name]

## Stack
TypeScript, Next.js 16 (App Router), React 19, Tailwind CSS v4, shadcn/ui

## Architecture
App Router with RSC. API routes in `app/api/`. Shared components in `components/ui/` (shadcn) and `components/common/`. Zustand for client state. Server actions for mutations.

## Code Style
- Strict TypeScript (`strict: true`). No `any` types.
- Functional components with hooks only. No class components.
- Use `cn()` utility for conditional classNames.
- Server Components by default; add `"use client"` only when needed.
- Zod for all input validation.

## Commands
- `pnpm dev` — Dev server
- `pnpm build` — Production build
- `pnpm lint` — ESLint
- `pnpm test` — Vitest
- `npx tsc --noEmit` — Type check

## Verification
After changes: `pnpm build && pnpm test`

## Common Mistakes
- Don't use `useEffect` for data fetching — use Server Components or `use()`.
- Don't import from `@/components/ui/*` directly — use the barrel export.
- Don't put `"use client"` on layout files.
```

---

## Template: Python/FastAPI Project

```markdown
# Project: [Name]

## Stack
Python 3.12, FastAPI, SQLAlchemy 2.0, Pydantic v2, Alembic, pytest

## Architecture
`app/` contains routers, models, schemas, services. Dependency injection via FastAPI. Async SQLAlchemy sessions. Alembic for migrations in `alembic/`.

## Code Style
- Type hints on all functions (params + return).
- Pydantic models for all request/response schemas.
- Services layer between routers and database (no direct DB calls in routers).
- Async by default for all I/O operations.

## Commands
- `uv run fastapi dev` — Dev server
- `uv run pytest -v` — Tests
- `uv run ruff check .` — Lint
- `uv run ruff check . --fix` — Auto-fix
- `uv run alembic upgrade head` — Run migrations

## Verification
After changes: `uv run ruff check . && uv run pytest -v`

## Common Mistakes
- Don't use sync SQLAlchemy sessions — use `AsyncSession`.
- Don't skip Pydantic validation on internal service boundaries.
- Always create a migration after model changes: `uv run alembic revision --autogenerate -m "description"`
```

---

## Template: C# / .NET Project

```markdown
# Project: [Name]

## Stack
.NET 9, C# 13, ASP.NET Core, Entity Framework Core, MediatR, FluentValidation

## Architecture
Clean Architecture: Domain -> Application -> Infrastructure -> Presentation. CQRS via MediatR. Commands/queries co-located with handlers. Keyed DI for service resolution.

## Code Style
- Nullable reference types enabled. No suppression operators (`!`) without comment.
- Record types for DTOs and value objects.
- IOptions pattern for configuration.
- Async/await throughout; no `.Result` or `.Wait()`.

## Commands
- `dotnet build` — Build
- `dotnet test` — Run tests
- `dotnet ef database update` — Apply migrations
- `dotnet run --project src/Presentation.API` — Run API

## Verification
After changes: `dotnet build && dotnet test`

## Common Mistakes
- Don't register services as Singleton if they depend on Scoped services.
- Don't use `DbContext` directly in controllers — go through MediatR handlers.
- Always use `CancellationToken` in async methods.
```

---

## Template: Monorepo (Turborepo/pnpm)

```markdown
# Project: [Name] Monorepo

## Stack
TypeScript, Turborepo, pnpm workspaces

## Architecture
- `apps/web` — Next.js frontend
- `apps/api` — Express/Fastify backend
- `packages/shared` — Shared types and utilities
- `packages/ui` — Shared React components

## Code Style
- Shared TypeScript config in `tsconfig.base.json`.
- All packages use `exports` field in package.json.
- No circular dependencies between packages.

## Commands
- `pnpm dev` — Start all apps
- `pnpm build` — Build all
- `pnpm lint` — Lint all
- `pnpm test` — Test all
- `pnpm --filter web dev` — Start only web app

## Verification
After changes: `pnpm build && pnpm test`

## Common Mistakes
- Don't import from packages using relative paths — use package names.
- Don't add dependencies to root unless they're dev-only shared tools.
- Run `pnpm install` after adding dependencies to any package.
```

---

## Template: Global ~/.claude/CLAUDE.md

```markdown
# Global Preferences
- Concise explanations. Don't over-explain.
- Conventional commits format (feat:, fix:, docs:, chore:, etc.)
- When uncertain, ask rather than guessing.
- Check for existing patterns before creating new ones.
- Run tests after code changes.
- Prefer composition over inheritance.
```

---

## Template: Task Approach Section (Add to Any CLAUDE.md)

```markdown
## Task Approach
When given a feature request or task:
1. **Clarify before coding.** If the request is ambiguous or could go multiple directions, ask 1-2 targeted questions first. Don't guess at requirements.
2. **Present options when trade-offs exist.** If there are meaningful architectural choices, briefly present 2-3 options with trade-offs and let me choose.
3. **Scope the work.** Before writing code, state what you plan to do: which files, what approach, what you'll verify. Wait for a thumbs up on big changes.
4. **Implement in layers.** For full-stack features: domain model → application layer → API → frontend → tests. Don't jump straight to UI.
5. **Verify as you go.** Run build/test after each meaningful change, not just at the end.
6. **Flag risks.** If something could break existing functionality, affect performance, or have security implications, call it out before proceeding.
```

---

## Template: .claude/rules/ Path-Scoped Rule

```yaml
---
paths: src/api/**/*.ts
---
# API Endpoint Rules
- Validate all inputs with Zod schemas
- Return consistent error format: { error: string, code: number }
- Add OpenAPI JSDoc comments on all endpoints
- Include rate limiting middleware on public endpoints
```
