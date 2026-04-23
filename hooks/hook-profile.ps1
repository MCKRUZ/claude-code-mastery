# Hook Profile System — Shared gatekeeper for all PowerShell hooks
#
# Dot-source this at the top of any hook script:
#
#   . "$PSScriptRoot\hook-profile.ps1" -HookId "switchboard" -MinProfile "standard"
#   if ($script:HookSkipped) { exit 0 }
#
# Environment variables (set in settings.json "env"):
#   CLAUDE_HOOK_PROFILE    — minimal | standard | strict (default: standard)
#   CLAUDE_DISABLED_HOOKS  — comma-separated hook IDs to skip entirely
#
# Profile tiers:
#   minimal  — only session lifecycle (session-start, session-end, pre-compact)
#   standard — all hooks except heavy/experimental ones
#   strict   — everything, including aggressive validation and security checks

param(
    [Parameter(Mandatory)]
    [string]$HookId,

    [ValidateSet("minimal", "standard", "strict")]
    [string]$MinProfile = "standard"
)

$script:HookSkipped = $false

$disabledRaw = $env:CLAUDE_DISABLED_HOOKS ?? ""
if ($disabledRaw) {
    $disabled = $disabledRaw.Split(",") | ForEach-Object { $_.Trim().ToLower() }
    if ($disabled -contains $HookId.ToLower()) {
        $script:HookSkipped = $true
        return
    }
}

$profileOrder = @{ "minimal" = 1; "standard" = 2; "strict" = 3 }
$currentProfile = ($env:CLAUDE_HOOK_PROFILE ?? "standard").ToLower()

if (-not $profileOrder.ContainsKey($currentProfile)) {
    $currentProfile = "standard"
}

$currentLevel = $profileOrder[$currentProfile]
$requiredLevel = $profileOrder[$MinProfile]

if ($currentLevel -lt $requiredLevel) {
    $script:HookSkipped = $true
    return
}
