# Dev Server Block Hook — Prevent hanging dev server commands
#
# PreToolUse on Bash: blocks commands that start long-running dev servers
# without background/timeout, which would hang the Claude session.

. "$PSScriptRoot\..\hook-profile.ps1" -HookId "dev-server-block" -MinProfile "standard"
if ($script:HookSkipped) { exit 0 }

$input_json = $args[0]
if (-not $input_json) {
    $input_json = [Console]::In.ReadToEnd()
}

try {
    $data = $input_json | ConvertFrom-Json -ErrorAction Stop
    $command = $data.tool_input.command
} catch {
    exit 0
}

if (-not $command) { exit 0 }

$devServerPatterns = @(
    'npm\s+run\s+dev\b', 'npm\s+start\b', 'npx\s+next\s+dev',
    'npx\s+vite\b(?!.*build)', 'npx\s+webpack\s+serve', 'ng\s+serve\b',
    'dotnet\s+run\b(?!.*--no-launch)', 'dotnet\s+watch\b',
    'flask\s+run\b', 'uvicorn\s+.*--reload', 'python\s+-m\s+http\.server',
    'php\s+artisan\s+serve', 'yarn\s+dev\b', 'pnpm\s+dev\b', 'bun\s+run\s+dev\b'
)

if ($command -match '&\s*$' -or $command -match 'run_in_background' -or $command -match 'timeout\s+\d') {
    exit 0
}

foreach ($pattern in $devServerPatterns) {
    if ($command -match $pattern) {
        Write-Error "BLOCKED: '$($Matches[0])' starts a long-running dev server that will hang the session. Use run_in_background:true on the Bash tool, or append '&' to background it."
        exit 2
    }
}

exit 0
