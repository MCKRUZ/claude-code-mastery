# Git Safety Hook — Block dangerous git patterns
#
# PreToolUse on Bash: blocks --no-verify, --force (on push), reset --hard,
# and other destructive git operations that bypass safety checks.

. "$PSScriptRoot\..\hook-profile.ps1" -HookId "git-safety" -MinProfile "standard"
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

$blocked = $false
$reason = ""

if ($command -match 'git\s+(commit|push)\s.*--no-verify') {
    $blocked = $true
    $reason = "BLOCKED: --no-verify bypasses pre-commit hooks. Fix the underlying issue instead."
}

if ($command -match 'git\s+push\s.*--force(?!-)' -or $command -match 'git\s+push\s.*-f\b') {
    $blocked = $true
    $reason = "BLOCKED: Force push can destroy remote history. Use --force-with-lease if necessary, or ask the user."
}

if ($command -match 'git\s+reset\s+--hard') {
    $blocked = $true
    $reason = "BLOCKED: git reset --hard discards uncommitted changes. Confirm with the user first."
}

if ($command -match 'git\s+clean\s+-[a-zA-Z]*f') {
    $blocked = $true
    $reason = "BLOCKED: git clean -f permanently deletes untracked files. Confirm with the user first."
}

if ($command -match 'git\s+branch\s+-[dD]\s+(main|master)\b') {
    $blocked = $true
    $reason = "BLOCKED: Cannot delete main/master branch."
}

if ($blocked) {
    Write-Error $reason
    exit 2
}

exit 0
