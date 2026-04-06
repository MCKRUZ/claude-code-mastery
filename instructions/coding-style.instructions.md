# Coding Style

## Immutability (CRITICAL)
- TypeScript: spread operators, never mutate objects/arrays. `{ ...obj, key }` and `[...arr, item]`.
- C#: prefer records, `with` expressions, `ImmutableList<T>`. Init-only properties.
- NgRx reducers: always return new state objects.

## File Organization
- Many small files > few large files. 200-400 lines typical, 800 max.
- Organize by feature/domain, not by type.
- High cohesion, low coupling.

## Naming
- C#: PascalCase (classes/methods/props), `_camelCase` (private fields), camelCase (locals/params)
- TypeScript: PascalCase (types/classes), camelCase (vars/funcs), kebab-case (files)

## Error Handling
- C#: Result<T> pattern, structured logging, let global handler catch unhandled exceptions.
- Angular: catchError in pipes, use logger service (no console.log), notify user.

## Validation
- C#: FluentValidation on all DTOs. Angular: Reactive Forms with validators.
- Always validate user input at system boundaries.

## Quality Checklist
- Functions <50 lines, no deep nesting (>4 levels)
- No console.log, no hardcoded values
- Immutable patterns used, input validation in place
