
<!-- nexus:start -->
## Nexus Intelligence

*Auto-updated by Nexus — do not edit this section manually.*
*Last sync: 2026-03-13*

### Project Context
#### Project Overview
**Claude Code Mastery** — the definitive Claude Code setup and configuration skill for Windows/PowerShell.

**Stack:** Markdown-based skill system. S…
*Tags: overview, claude*

### Context from claude-code-langfuse-template
#### Project Overview
**Claude Code + Langfuse Template** — production-ready setup for observing Clau…
*Tags: overview, claude, typescript*

### Context from everything-claude-code
#### Project Overview
**Everything Claude Code** — complete collection of Claude Code configs from an…
*Tags: overview, claude*

### Context from github-agentic-workflows-poc
#### Project Overview
**GitHub Agentic Workflows POC** — proof-of-concept for GitHub's Agentic Workfl…
*Tags: overview, claude, dotnet*

### Context from CodeReviewAssistant
#### Project Overview
**CodeReviewAssistant** — MCP server for capturing, analyzing, and documenting …
*Tags: overview, typescript, claude*

### Recorded Decisions
- **[security]** Sanitize and rotate credentials after eval runs that may expose secrets
  > During test case TC-003, a real GitHub PAT was exposed in skill output. Established practice to rotate credentials and document secret exposure risks in eval framework.
- **[security]** Sanitize eval test harness to prevent credential leakage from settings files
  > Eval run exposed GitHub PAT token when skill accessed actual settings.json during MCP config test
- **[security]** Include platform-aware syntax validation in evaluations — specifically test Win…
  > TC-005 and TC-003 explicitly validate Windows-compatible output; 15% of benchmark criteria allocated to platform awareness
- **[architecture]** Add failure-mode test cases for adversarial input and edge cases before finaliz…
  > After initial 5 test cases passed at 100%, added TC-006, TC-007, TC-008 to test adversarial users, contradictory platform info, and cold-start scenarios. Discovered that robustness under adversarial conditions should be weighted (10%).
- **[architecture]** Use anchored, objective assertion types for eval scoring instead of subjective …
  > Initial eval used vague assertions like 'sequence_check' and subjective descriptions. Refactored to use concrete assertion types: contains, regex, question_before_code (line position), json_valid, token_limit to reduce scoring ambiguity.

### Established Patterns
- **Claude hooks for session lifecycle automation**: Use ~/.claude/settings.json hooks (SessionStart, Stop, PostToolUse) to automate memory persistence, formatting, and knowledge extraction at session boundaries.
- **Diagnose-Before-Recommend**: Assessment cases require understanding existing state and user context before providing solutions or recommendations
- **Trigger/Non-Trigger Classification**: Skills evaluated with explicit lists of queries that should and should not activate the skill logic, with 10+ examples in each category

*[Nexus: run `nexus query` to search full knowledge base]*
<!-- nexus:end -->
