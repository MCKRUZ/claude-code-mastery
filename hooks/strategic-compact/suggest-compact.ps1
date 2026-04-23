# Strategic Compact Suggester
#
# Runs on PreToolUse to suggest manual compaction at logical intervals.
# Manual compaction preserves context through logical phases better than
# auto-compaction which happens at arbitrary points.

. "$PSScriptRoot\..\hook-profile.ps1" -HookId "suggest-compact" -MinProfile "standard"
if ($script:HookSkipped) { exit 0 }

$sessionKey = $env:DEEP_SESSION_ID
if (-not $sessionKey) {
    try {
        $sessionKey = (Get-WmiObject Win32_Process -Filter "ProcessId=$PID" -ErrorAction SilentlyContinue).ParentProcessId
    } catch {
        $sessionKey = "default"
    }
}
$CounterFile = "$env:TEMP\claude-tool-count-$sessionKey.txt"
$Threshold = if ($env:COMPACT_THRESHOLD) { [int]$env:COMPACT_THRESHOLD } else { 50 }

$count = 1
if (Test-Path $CounterFile) {
    $count = [int](Get-Content $CounterFile) + 1
}
Set-Content -Path $CounterFile -Value $count

if ($count -eq $Threshold) {
    Write-Host "[StrategicCompact] $Threshold tool calls reached - consider /compact if transitioning phases" -ForegroundColor Yellow
}

if ($count -gt $Threshold -and ($count % 25) -eq 0) {
    Write-Host "[StrategicCompact] $count tool calls - good checkpoint for /compact if context is stale" -ForegroundColor Yellow
}

$input | Write-Output
