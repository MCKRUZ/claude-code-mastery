# Config Protection Hook — Block modifications to linter/formatter configs
#
# PreToolUse on Edit/Write/MultiEdit: prevents the agent from weakening
# linter/formatter configurations to make code pass.

. "$PSScriptRoot\..\hook-profile.ps1" -HookId "config-protection" -MinProfile "standard"
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

$protectedPatterns = @(
    '\.eslintrc', 'eslint\.config', '\.prettierrc', 'prettier\.config',
    '\.stylelintrc', 'stylelint\.config', 'tsconfig.*\.json$',
    '\.editorconfig$', 'biome\.json', '\.flake8$', 'pyproject\.toml$',
    'ruff\.toml$', '\.rubocop\.yml$', 'Directory\.Build\.props$', '\.globalconfig$'
)

$fileName = Split-Path $filePath -Leaf
foreach ($pattern in $protectedPatterns) {
    if ($fileName -match $pattern) {
        Write-Error "BLOCKED: Cannot modify linter/formatter config '$fileName'. Fix the code to satisfy the rules instead of weakening the config. If the config genuinely needs updating, ask the user first."
        exit 2
    }
}

exit 0
