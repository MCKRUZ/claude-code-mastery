# Agent Orchestration & Workflow

## Built-in Subagent Types

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| planner | Implementation planning | 5+ file features, new services |
| architect | System design | Major architectural decisions |
| tdd-guide | Test-driven development | On request or complex logic |
| code-reviewer | Code review | Before PRs, not every edit |
| security-reviewer | Security analysis | Auth/payment/identity code |
| build-error-resolver | Fix build errors | When build fails |
| e2e-runner | E2E testing | Critical user flows |
| refactor-cleaner | Dead code cleanup | On request |
| doc-updater | Documentation | On request |

## When to Auto-Spawn Agents

Only mandatory without user prompt:
1. Security-sensitive code (auth, payments, identity) -> **security-reviewer**
2. Build failure -> **build-error-resolver**

Available on request or when clearly beneficial:
- Complex features -> planner (suggest it, don't force it)
- After implementation -> code-reviewer (for PRs, not every edit)
- TDD workflow -> tdd-guide (when user wants TDD)

## Parallel Execution
Use parallel agents for independent operations. Don't run sequentially when parallelism is possible.

## Commit Messages
Format: `type: description` (feat, fix, refactor, docs, test, chore, perf, ci)

## PR Workflow
1. Analyze full commit history with `git diff [base-branch]...HEAD`
2. Draft comprehensive summary with test plan
3. Push with `-u` flag if new branch
