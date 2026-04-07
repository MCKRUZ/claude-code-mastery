---
name: /code-review
description: Comprehensive security and quality review of uncommitted changes. Blocks commit on CRITICAL or HIGH issues.
---

# Code Review

Perform a comprehensive security and quality review of uncommitted changes.

## Workflow

1. Get changed files: `git diff --name-only HEAD`

2. For each changed file, check for:

### Security Issues (CRITICAL)
- Hardcoded credentials, API keys, tokens
- SQL injection vulnerabilities
- XSS vulnerabilities
- Missing input validation
- Insecure dependencies
- Path traversal risks

### Code Quality (HIGH)
- Functions > 50 lines
- Files > 800 lines
- Nesting depth > 4 levels
- Missing error handling
- console.log statements
- TODO/FIXME comments
- Missing JSDoc for public APIs

### Best Practices (MEDIUM)
- Mutation patterns (use immutable instead)
- Emoji usage in code/comments
- Missing tests for new code
- Accessibility issues (a11y)

## Output Format

3. Generate report with:
   - **Severity**: CRITICAL, HIGH, MEDIUM, LOW
   - **File location** and line numbers
   - **Issue description**
   - **Suggested fix**

## Gate

4. **Block commit if CRITICAL or HIGH issues found** — list all issues that must be resolved before merging.

Never approve code with security vulnerabilities.
