# Console.log Warning Hook — Warn about debug logging left in code
#
# PostToolUse on Edit/Write: checks if edited JS/TS file contains
# console.log statements and warns (does not block).

. "$PSScriptRoot\..\hook-profile.ps1" -HookId "console-warn" -MinProfile "standard"
if ($script:HookSkipped) { exit 0 }

$input_json = $args[0]
if (-not $input_json) {
    $input_json = [Console]::In.ReadToEnd()
}

try {
    $data = $input_json | ConvertFrom-Json -ErrorAction Stop
    $filePath = $data.tool_input.file_path
    if (-not $filePath) { $filePath = $data.tool_input.path }
} catch {
    exit 0
}

if (-not $filePath) { exit 0 }

$jsExtensions = @('.js', '.jsx', '.ts', '.tsx', '.mjs', '.cjs', '.vue', '.svelte')
$ext = [System.IO.Path]::GetExtension($filePath).ToLower()

if ($jsExtensions -notcontains $ext) { exit 0 }
if (-not (Test-Path $filePath)) { exit 0 }

$matches_found = Select-String -Path $filePath -Pattern 'console\.(log|debug|info|warn|error)\(' -AllMatches
if ($matches_found) {
    $count = ($matches_found | Measure-Object).Count
    Write-Host "[QualityGate] WARNING: $count console.log/debug statement(s) found in $(Split-Path $filePath -Leaf). Remove before committing." -ForegroundColor Yellow
}

exit 0
