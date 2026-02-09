# Troubleshooting Guide

> Common problems and proven solutions for Claude Code on Windows.

---

## Output Quality Problems

### "Claude keeps ignoring my CLAUDE.md instructions"
**Cause:** CLAUDE.md is too long or contains non-universally-applicable content. Claude's system wraps it with "may or may not be relevant" framing.
**Fix:**
1. Trim to under 3,000 tokens
2. Move task-specific rules to `.claude/rules/` with path-scoped frontmatter
3. Ensure every instruction is universally applicable to all tasks in the project
4. Test by asking Claude "what does your CLAUDE.md say about [topic]?"

### "Claude hallucinates API methods"
**Cause:** Claude is using training data instead of current docs.
**Fix:** Add Context7 MCP server: `claude mcp add -s user context7 -- npx -y @upstash/context7-mcp`

### "Claude produces generic/low-quality frontend code"
**Cause:** No aesthetic direction provided.
**Fix:**
1. Install Anthropic's frontend-design plugin
2. Add explicit aesthetic direction to prompts
3. Use Playwright MCP for visual verification
4. Add UI-specific rules to `.claude/rules/` for frontend files

### "Claude keeps making the same mistake"
**Cause:** The mistake isn't documented.
**Fix:** Add it to CLAUDE.md immediately: "Common Mistakes: [X]: [What to do instead]"

---

## Performance / Speed Problems

### "Claude Code is slow on Windows"
**Possible causes & fixes:**
1. **Antivirus scanning:** Add your project directories to Windows Defender exclusions. Real-time scanning on every file operation slows things down dramatically.
   - Settings -> Windows Security -> Virus & Threat Protection -> Manage settings -> Exclusions -> Add
2. **Large node_modules:** Ensure node_modules is in `.gitignore` and your project doesn't have unnecessary large directories.
3. **Network-mounted drives:** Work on local drives (C:, D:), not network shares or OneDrive-synced folders.

### "Git Bash not found / requires git-bash error"
**Fix:**
```powershell
# Set the path to Git Bash explicitly
[System.Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', 'C:\Program Files\Git\bin\bash.exe', 'User')
# Restart terminal and VS Code
```
If Git Bash is installed to a non-default location, adjust the path accordingly.

### "Context fills up too fast"
**Causes & Fixes:**
1. **Too many MCP servers:** Each adds persistent tool definitions. Remove unused ones. Stay under 20K tokens of MCP tools.
2. **Large `@file` imports in CLAUDE.md:** Replace with pointers: "For details, see docs/X.md"
3. **Not compacting:** Run `/compact focus on [current task]` at 70% usage
4. **Reading too many files directly:** Use subagents for exploration

---

## Configuration Problems

### "Claude Code hangs on startup / can't type"
**Most common causes (check in order):**

1. **Dead MCP packages.** If any MCP server references a package that doesn't exist on npm, `npx` will hang trying to resolve it. Test each server independently:
   ```powershell
   npx -y @upstash/context7-mcp  # Should start and print a message
   ```
   Known dead packages: `@anthropic/mcp-server-dotnet`, `@context7/mcp-server`.

2. **Missing `cmd /c` wrapper in `.claude.json`.** MCP servers defined in `~/.claude.json` (not `settings.json`) require `cmd /c` on Windows:
   ```json
   {
     "command": "cmd",
     "args": ["/c", "npx", "-y", "@upstash/context7-mcp"]
   }
   ```
   Run `claude doctor` to detect this — it will warn about servers needing the wrapper.

3. **TUI input focus bug.** Claude Code launches and shows the prompt but won't accept keystrokes. Press `Enter` once to give the TUI input focus. This is a known quirk on Windows, especially with slow PowerShell profiles.

4. **SessionStart hook hanging.** If a SessionStart hook script doesn't exist, has errors, or waits for input, it blocks startup. Test the script independently:
   ```powershell
   pwsh -NoProfile -ExecutionPolicy Bypass -File "C:/Users/<you>/.claude/hooks/memory-persistence/session-start.ps1"
   ```

**Nuclear option:** Rename `settings.json` and `.claude.json` temporarily to confirm Claude Code starts clean, then add configs back incrementally.

### "Found N invalid settings files" warning
**Cause:** Invalid JSON or unrecognized fields in settings files. The warning appears in the status bar at the bottom of Claude Code.
**Fix:**
1. Run `claude doctor` to see exactly which files and what's wrong
2. Check **both** `~/.claude/settings.json` AND `~/.claude.json` for MCP issues
3. Check project-level `.claude/settings.json` and `.mcp.json` in your current directory
4. Common issues: bash-style redirects (`2>/dev/null`), invalid hook variables (`$file` instead of `$CLAUDE_FILE_PATH`), missing `cmd /c` wrapper for npx on Windows

### "Two config files define MCP servers"
**Explanation:** Claude Code has two places where MCP servers can be defined:
- `~/.claude/settings.json` — Your main settings (hooks, permissions, env, mcpServers)
- `~/.claude.json` — Claude Code's state file (also has a `mcpServers` section at the bottom)

Both are loaded and merged. `claude doctor` only validates `.claude.json`. When troubleshooting, check both. Servers added via `claude mcp add -s user` go into `.claude.json`.

### "Custom agents not recognized"
**Known issue:** GitHub #18212, #4728, #9930. Particularly on Linux ARM and certain plugin configs.
**Workaround:** Ensure agents are in `.claude/agents/` (project) or `~/.claude/agents/` (user). Restart Claude Code. Try explicit invocation.

### "MCP server won't connect"
**Debug steps:**
1. `claude mcp list` — verify it's registered
2. `claude mcp get <n>` — check configuration
3. Test server independently: `npx @modelcontextprotocol/inspector`
4. Check if server requires env vars that aren't set
5. For remote HTTP servers, verify OAuth flow completed

### "GitHub MCP Server: Incompatible auth server / does not support dynamic client registration"

**Problem:** You see this error when trying to connect the GitHub MCP server at `https://api.githubcopilot.com/mcp/`:
```
Status: ✗ failed
Auth: ✗ not authenticated
Error: Incompatible auth server: does not support dynamic client registration
```

**Cause:** The GitHub Copilot MCP endpoint requires special OAuth authentication that's not compatible with Claude Code's dynamic client registration.

**Fix:** Replace with the official GitHub MCP server:

1. **Open** `~/.claude.json` (or `~/.claude/settings.json` if the server is there)

2. **Replace** the GitHub server configuration:
   ```json
   // BEFORE (doesn't work):
   "github": {
     "type": "http",
     "url": "https://api.githubcopilot.com/mcp/"
   }

   // AFTER (works):
   "github": {
     "type": "stdio",
     "command": "cmd",
     "args": ["/c", "npx", "-y", "@modelcontextprotocol/server-github"],
     "env": {
       "GITHUB_PERSONAL_ACCESS_TOKEN": ""
     }
   }
   ```

3. **Create a GitHub Personal Access Token:**
   - Go to https://github.com/settings/tokens
   - Click "Generate new token" → "Generate new token (classic)"
   - Name: `Claude Code MCP`
   - Scopes: `repo`, `read:org`, `read:user`
   - Click "Generate token" and **copy it immediately**

4. **Add the token** to the `GITHUB_PERSONAL_ACCESS_TOKEN` field in your config

5. **Restart Claude Code**

**Verify:** Run `claude mcp list` and the GitHub server should show as connected.

### "Hooks not firing"
**Check:**
1. Hook is in correct settings level (project `.claude/settings.json` for project hooks)
2. Matcher pattern matches the file extension
3. Command exists and is executable
4. Try running the hook command manually

---

## Agent Teams Problems

### "Teammates can't see each other's changes"
**Cause:** No file locking in Agent Teams.
**Fix:** Enforce strict file ownership. Each teammate works on completely separate files. Split by feature, not by layer.

### "Agent Teams costing too much"
**Fixes:**
1. Use Sonnet for implementation teammates (model field in frontmatter)
2. Keep teams to 2-4 agents
3. Use direct messages, not broadcasts (broadcasts multiply cost by team size)
4. Set `MAX_THINKING_TOKENS=8000` for simpler tasks
5. Clean up teams immediately when done (idle teammates still consume tokens)
6. Ask: "Does this actually need Agent Teams, or would subagents suffice?"

### "Split-pane mode doesn't work"
**Known limitation:** Requires tmux (Linux/macOS only). Not available on Windows native.
**Workaround:** Use Agent Teams in "in-process" mode (default on Windows) which uses Shift+Up/Down to cycle between teammates. Alternatively, use the Claude Desktop app which supports parallel sessions with git worktrees natively.

---

## Installation Problems

### "Claude command not recognized after install"
**Cause:** `C:\Users\<you>\.local\bin` not in PATH.
**Fix:**
1. Win+R -> `sysdm.cpl` -> Advanced -> Environment Variables
2. Edit User PATH -> New -> Add `C:\Users\<you>\.local\bin`
3. Restart all terminal windows

### "Native installation exists but not in PATH"
**Same fix as above.** The installer warns about this. Add the displayed path to your User PATH.

### "Claude Code installs but crashes or won't start"
**Checklist:**
1. Git for Windows installed? (`git --version` in PowerShell)
2. `CLAUDE_CODE_GIT_BASH_PATH` set if non-default Git location?
3. Run `claude doctor` for diagnostics
4. Try running from Git Bash directly to isolate the issue

### "VS Code extension can't find Git Bash"
**Known regression after extension v1.0.126** (GitHub #13184, #8674).
**Fix:** Set `CLAUDE_CODE_GIT_BASH_PATH` as a **System** environment variable (not just User), then restart VS Code completely.

### "WinGet update not available yet"
**Known issue:** Claude Code may notify of updates before WinGet has the new version. Wait a few hours and try `winget upgrade Anthropic.ClaudeCode` again.

---

## Cost Optimization Checklist

1. [ ] Using Sonnet (not Opus) for routine tasks? (`/model sonnet`)
2. [ ] CLAUDE.md under 3K tokens?
3. [ ] MCP tool definitions under 20K tokens?
4. [ ] Compacting at 70% context usage?
5. [ ] Using subagents for exploration (not main session)?
6. [ ] Agent Teams only when genuinely needed?
7. [ ] Teammates using Sonnet with `MAX_THINKING_TOKENS=8000`?
8. [ ] Direct messages instead of broadcasts in teams?
9. [ ] Cleaning up teams immediately when done?
10. [ ] Using `/clear` between unrelated tasks?
