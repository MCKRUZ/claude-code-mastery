# Claude Code Mastery — Eval Configuration

## Classification
- **Type**: Encoded Preference
- **Category**: Claude Code setup, configuration, and mastery guidance with progressive disclosure

## What "Good" Looks Like
1. Diagnoses user state BEFORE prescribing solutions — asks clarifying questions or infers context from provided info
2. Understands and correctly applies the configuration hierarchy: Enterprise > User > Project > Local
3. Produces accurate CLI commands with Windows-compatible syntax when the user is on Windows
4. Uses progressive disclosure — delivers the right amount of guidance for the user's current level, never dumps everything at once
5. Generates valid CLAUDE.md templates, settings.json, hooks, and MCP server configurations that follow current schema

## Known Limitations
- Cannot detect the user's actual file system state without tool use; relies on user-provided context
- Configuration schema may drift as Claude Code updates — eval cases need periodic refresh
- Cannot validate MCP server connectivity or hook execution at eval time

## Benchmark Strategy
- **Without skill**: Base Claude provides generic setup instructions, often dumps full config blocks without assessing user needs. May miss hierarchy rules or produce Linux syntax on Windows.
- **With skill**: Skill enforces diagnose-first flow, respects hierarchy, tailors output to user's actual state and platform, and uses progressive disclosure.
- **Key differentiator**: Sequence discipline — diagnose before recommend — and platform-aware syntax.

## Security — Eval Sandboxing

Eval runs use real tool access. Agents executing test cases can read actual config files
(`~/.claude/settings.json`, `.mcp.json`, etc.) and may **expose secrets** (API keys, tokens,
connection strings) in their output.

**Mitigations:**
1. **Never commit eval results** that contain real config output. The `results/` directory is gitignored.
2. **Rotate any secrets** that appear in eval output immediately.
3. **Use `--allowedTools "Read,Glob,Grep"` in runner** to prevent eval agents from modifying files.
4. **Consider a sanitized environment** — copy `settings.json` with placeholder values for eval runs.

## Running Evals

```bash
# Full run (with-skill + baseline comparison)
bash eval/run-eval.sh

# With-skill only
bash eval/run-eval.sh --skill-only

# Single test case
bash eval/run-eval.sh --case TC-001
```

Results are written to `eval/results/<timestamp>/` with per-case output and a summary scorecard.

## Retirement Signal
N/A — Encoded preference skill. Retirement not applicable; evolves with Claude Code releases.
