# MCP Health Check Hook — Verify MCP servers respond on session start
#
# SessionStart: pings key MCP endpoints to verify they're available.
# Warns (does not block) if a server is unreachable.
#
# Customize the $servers array below for your environment.

. "$PSScriptRoot\..\hook-profile.ps1" -HookId "mcp-health-check" -MinProfile "standard"
if ($script:HookSkipped) { exit 0 }

$servers = @(
    @{ Name = "Bifrost"; Url = "http://192.168.50.189:8090/mcp"; Timeout = 5 }
)

$healthy = 0
$unhealthy = 0
$warnings = @()

foreach ($server in $servers) {
    try {
        $uri = [System.Uri]$server.Url
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect($uri.Host, $uri.Port)
        $tcp.Close()
        $healthy++
    } catch {
        $unhealthy++
        $warnings += "  - $($server.Name): unreachable"
    }
}

if ($unhealthy -gt 0) {
    Write-Host "[MCP Health] $healthy/$($healthy + $unhealthy) servers healthy. Issues:" -ForegroundColor Yellow
    foreach ($w in $warnings) { Write-Host $w -ForegroundColor Yellow }
} elseif ($healthy -gt 0) {
    Write-Host "[MCP Health] All $healthy servers healthy" -ForegroundColor Green
}

exit 0
