<#
.SYNOPSIS
    Installs Claude Code configuration into Cursor.

.DESCRIPTION
    Copies skills (global), project rules, subagents, and commands
    from the cursor-export directory into the appropriate Cursor locations.

    Skills    -> ~/.agents/skills/<name>/SKILL.md  (global, shared ecosystem)
    Rules     -> <project>/.cursor/rules/*.mdc
    Subagents -> <project>/.cursor/agents/*.md
    Commands  -> <project>/.cursor/rules/commands/*.mdc  (as Manual rules, invoke with @)

.PARAMETER ProjectPath
    Target project directory to install project-level configs into.
    If omitted, only global skills are installed.

.PARAMETER SkillsOnly
    Only install global skills (no project-level configs).

.PARAMETER DryRun
    Show what would be done without making changes.

.EXAMPLE
    .\install-cursor.ps1 -ProjectPath "C:\my\project"

.EXAMPLE
    .\install-cursor.ps1 -SkillsOnly

.EXAMPLE
    .\install-cursor.ps1 -ProjectPath "C:\my\project" -DryRun
#>

param(
    [string]$ProjectPath,
    [switch]$SkillsOnly,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$ExportDir = $PSScriptRoot
$AgentsSkillsDir = Join-Path (Join-Path $HOME ".agents") "skills"
$Installed = @{ Skills = 0; Rules = 0; Subagents = 0; Commands = 0 }

function Write-Step($msg) { Write-Host "  [+] $msg" -ForegroundColor Green }
function Write-Skip($msg) { Write-Host "  [-] $msg" -ForegroundColor Yellow }
function Write-Info($msg) { Write-Host "  [i] $msg" -ForegroundColor Cyan }

# --- SKILLS (Global) ----------------------------------------------------------
Write-Host ""
Write-Host "=== Installing Skills to ~/.agents/skills/ ===" -ForegroundColor White

$skillsSource = Join-Path $ExportDir "skills"
if (Test-Path $skillsSource) {
    Get-ChildItem $skillsSource -Filter "*.md" | ForEach-Object {
        $skillName = $_.BaseName
        $targetDir = Join-Path $AgentsSkillsDir $skillName
        $targetFile = Join-Path $targetDir "SKILL.md"

        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            Copy-Item $_.FullName $targetFile -Force
        }
        Write-Step "$skillName -> $targetDir"
        $Installed.Skills++
    }
} else {
    Write-Skip "No skills directory found at $skillsSource"
}

if ($SkillsOnly) {
    Write-Host ""
    Write-Host "=== Summary ===" -ForegroundColor White
    Write-Info "$($Installed.Skills) skills installed"
    Write-Host ""
    Write-Host "  Don't forget to paste global-rules.md into Cursor > Settings > General > Rules for AI" -ForegroundColor Yellow
    exit 0
}

# --- PROJECT-LEVEL CONFIGS ----------------------------------------------------
if (-not $ProjectPath) {
    Write-Host ""
    Write-Host "No -ProjectPath specified. Use -ProjectPath to install project-level configs." -ForegroundColor Yellow
    Write-Host "Example: .\install-cursor.ps1 -ProjectPath 'C:\my\project'" -ForegroundColor Yellow
    exit 0
}

if (-not (Test-Path $ProjectPath)) {
    Write-Error "Project path does not exist: $ProjectPath"
    exit 1
}

$cursorDir = Join-Path $ProjectPath ".cursor"
$cursorRulesDir = Join-Path $cursorDir "rules"
$cursorAgentsDir = Join-Path $cursorDir "agents"
$cursorCommandsDir = Join-Path (Join-Path $cursorDir "rules") "commands"

# --- RULES --------------------------------------------------------------------
Write-Host ""
Write-Host "=== Installing Rules to .cursor/rules/ ===" -ForegroundColor White

$rulesSource = Join-Path $ExportDir "project-rules"
if (Test-Path $rulesSource) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $cursorRulesDir -Force | Out-Null
    }
    Get-ChildItem $rulesSource -Filter "*.mdc" | ForEach-Object {
        $targetFile = Join-Path $cursorRulesDir $_.Name
        if (-not $DryRun) {
            Copy-Item $_.FullName $targetFile -Force
        }
        Write-Step "$($_.Name) -> .cursor/rules/"
        $Installed.Rules++
    }
} else {
    Write-Skip "No project-rules directory found"
}

# --- SUBAGENTS ----------------------------------------------------------------
Write-Host ""
Write-Host "=== Installing Subagents to .cursor/agents/ ===" -ForegroundColor White

$agentsSource = Join-Path $ExportDir "subagents"
if (Test-Path $agentsSource) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $cursorAgentsDir -Force | Out-Null
    }
    Get-ChildItem $agentsSource -Filter "*.md" | ForEach-Object {
        $targetFile = Join-Path $cursorAgentsDir $_.Name
        if (-not $DryRun) {
            Copy-Item $_.FullName $targetFile -Force
        }
        Write-Step "$($_.Name) -> .cursor/agents/"
        $Installed.Subagents++
    }
} else {
    Write-Skip "No subagents directory found"
}

# --- COMMANDS (as Manual rules) -----------------------------------------------
Write-Host ""
Write-Host "=== Installing Commands as Manual Rules to .cursor/rules/commands/ ===" -ForegroundColor White
Write-Info "Cursor does not have file-based commands. These are installed as Manual rules -- invoke with @ in chat."

$commandsSource = Join-Path $ExportDir "commands"
if (Test-Path $commandsSource) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $cursorCommandsDir -Force | Out-Null
    }
    Get-ChildItem $commandsSource -Filter "*.md" | ForEach-Object {
        $mdcName = $_.BaseName + ".mdc"
        $targetFile = Join-Path $cursorCommandsDir $mdcName

        $content = Get-Content $_.FullName -Raw

        if ($content -match "^---") {
            $content = $content -replace "(?m)^alwaysApply:.*$", ""
            $content = $content -replace "(?m)^globs:.*$", ""
        }

        if (-not $DryRun) {
            Set-Content -Path $targetFile -Value $content -Encoding UTF8
        }
        Write-Step "$($_.BaseName) -> .cursor/rules/commands/$mdcName"
        $Installed.Commands++
    }
} else {
    Write-Skip "No commands directory found"
}

# --- SUMMARY ------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor White
if ($DryRun) {
    Write-Host "  DRY RUN -- no files were written" -ForegroundColor Yellow
}
Write-Info "$($Installed.Skills) skills installed (global)"
Write-Info "$($Installed.Rules) rules installed to $cursorRulesDir"
Write-Info "$($Installed.Subagents) subagents installed to $cursorAgentsDir"
Write-Info "$($Installed.Commands) commands installed as manual rules to $cursorCommandsDir"

Write-Host ""
Write-Host "=== Manual Steps Required ===" -ForegroundColor Yellow
Write-Host "  1. Open Cursor > Settings > General > Rules for AI" -ForegroundColor Yellow
Write-Host "  2. Paste the contents of: $ExportDir\global-rules.md" -ForegroundColor Yellow
Write-Host "  3. Verify skills appear in: Cursor > Settings > Rules, Skills, Subagents > Skills" -ForegroundColor Yellow
Write-Host "  4. Ensure 'Include third party Plugins, Skills' toggle is ON" -ForegroundColor Yellow
Write-Host ""
