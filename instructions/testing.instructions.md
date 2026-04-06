# Testing

## Bug Fix Workflow (MANDATORY)
When a bug is reported, do NOT start by trying to fix it. Instead:
1. Write a test that reproduces the bug (prove it fails)
2. Use subagents to fix the bug and prove it with a passing test
This applies to all projects, always.

## Coverage: 80% minimum
Unit + Integration + E2E for critical flows.

## TDD (when requested)
RED (write failing test) -> GREEN (minimal implementation) -> REFACTOR (clean up, verify coverage)

## Patterns
- C#: xUnit, AAA, Moq, `WebApplicationFactory<Program>` + in-memory DB
- Angular: Jasmine/Karma, `HttpTestingController`, `afterEach(() => httpMock.verify())`
- E2E: Cypress/Playwright with `data-cy` selectors, `cy.intercept` for API mocking

## Commands
- C#: `dotnet test`, `dotnet test --collect:"XPlat Code Coverage"`
- Angular: `ng test --code-coverage`, `ng test --watch=false --browsers=ChromeHeadless`
- E2E: `npx cypress run`
