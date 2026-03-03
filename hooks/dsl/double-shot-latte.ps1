# Double Shot Latte — Stop hook state tracker
# Tracks recent stop events and writes a CONTINUE/THROTTLED decision
# for the companion prompt hook to pass to Claude.
#
# Concept: Based on Jesse Vincent's Superpowers DSL hook.
# When Claude repeatedly stops to check in, this throttles it after
# 3 stops in 5 minutes — otherwise it instructs Claude to continue autonomously.

param()

$hookDir      = "$env:USERPROFILE\.claude\hooks\dsl"
$stateFile    = "$hookDir\state.json"
$decisionFile = "$hookDir\decision.txt"
$windowMinutes = 5
$maxStops      = 3

if (-not (Test-Path $hookDir)) {
    New-Item -ItemType Directory -Path $hookDir -Force | Out-Null
}

# Load existing stop timestamps
$stops = @()
if (Test-Path $stateFile) {
    try {
        $json = Get-Content $stateFile -Raw -ErrorAction Stop | ConvertFrom-Json
        if ($null -ne $json.stops) { $stops = @($json.stops) }
    } catch {
        $stops = @()
    }
}

# Remove entries older than the window
$cutoff = [datetime]::UtcNow.AddMinutes(-$windowMinutes)
$stops = @($stops | Where-Object {
    try {
        [datetime]::Parse(
            $_,
            [System.Globalization.CultureInfo]::InvariantCulture,
            [System.Globalization.DateTimeStyles]::RoundtripKind
        ) -gt $cutoff
    } catch { $false }
})

# Check throttle BEFORE recording this event
$throttled = $stops.Count -ge $maxStops

# Record this stop event
$stops += [datetime]::UtcNow.ToString("o")

# Persist updated state
[PSCustomObject]@{ stops = $stops } |
    ConvertTo-Json -Depth 3 |
    Set-Content $stateFile -Encoding UTF8 -NoNewline

# Write decision for the prompt hook
if ($throttled) {
    Set-Content $decisionFile -Value "THROTTLED" -Encoding UTF8 -NoNewline
} else {
    Set-Content $decisionFile -Value "CONTINUE" -Encoding UTF8 -NoNewline
}
