#Requires -Version 5.1
<#
.SYNOPSIS
    Install claude-code-mastery harness to a new machine.

.DESCRIPTION
    Copies hooks, rules, skills, and commands to ~/.claude/ for a complete
    Claude Code development environment. Non-destructive — existing files
    are backed up before overwriting.

.PARAMETER SkipHooks
    Skip hook installation (install rules, skills, and commands only).

.PARAMETER SkipRules
    Skip rules/instructions installation.

.PARAMETER Force
    Overwrite existing files without prompting.

.EXAMPLE
    .\install.ps1
    .\install.ps1 -SkipHooks
    .\install.ps1 -Force
#>

param(
    [switch]$SkipHooks,
    [switch]$SkipRules,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ClaudeHome = Join-Path $env:USERPROFILE ".claude"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = Join-Path $ClaudeHome "backups" $Timestamp

Write-Host "`n=== claude-code-mastery installer v3.0.0 ===" -ForegroundColor Cyan
Write-Host "Source: $RepoRoot"
Write-Host "Target: $ClaudeHome`n"

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Backup-File([string]$Path) {
    if (Test-Path $Path) {
        Ensure-Dir $BackupDir
        $rel = $Path.Replace($ClaudeHome, "").TrimStart("\", "/")
        $dest = Join-Path $BackupDir $rel
        Ensure-Dir (Split-Path $dest -Parent)
        Copy-Item $Path $dest -Force
        Write-Host "  Backed up: $rel" -ForegroundColor DarkGray
    }
}

function Copy-WithBackup([string]$Source, [string]$Dest) {
    if ((Test-Path $Dest) -and -not $Force) {
        $sourceHash = (Get-FileHash $Source -Algorithm MD5).Hash
        $destHash = (Get-FileHash $Dest -Algorithm MD5).Hash
        if ($sourceHash -eq $destHash) {
            Write-Host "  Unchanged: $(Split-Path $Dest -Leaf)" -ForegroundColor DarkGray
            return
        }
        Backup-File $Dest
    }
    Ensure-Dir (Split-Path $Dest -Parent)
    Copy-Item $Source $Dest -Force
    Write-Host "  Installed: $(Split-Path $Dest -Leaf)" -ForegroundColor Green
}

# --- 1. Hook Scripts ---
if (-not $SkipHooks) {
    Write-Host "Installing hooks..." -ForegroundColor Yellow
    $hooksSource = Join-Path $RepoRoot "hooks"
    $hooksDest = Join-Path $ClaudeHome "hooks"

    $hookFiles = @(
        "hook-profile.ps1",
        "quality-gates/git-safety.ps1",
        "quality-gates/config-protection.ps1",
        "quality-gates/console-warn.ps1",
        "quality-gates/dev-server-block.ps1",
        "mcp-health/health-check.ps1",
        "strategic-compact/suggest-compact.ps1"
    )

    foreach ($f in $hookFiles) {
        $src = Join-Path $hooksSource $f
        $dst = Join-Path $hooksDest $f
        if (Test-Path $src) {
            Copy-WithBackup $src $dst
        } else {
            Write-Host "  Skipped (not found): $f" -ForegroundColor DarkYellow
        }
    }

    # Install hooks.json — resolve {{HOOKS_DIR}} placeholder
    $hooksJsonSource = Join-Path $RepoRoot "hooks.json"
    $hooksJsonDest = Join-Path $hooksDest "hooks.json"
    if (Test-Path $hooksJsonSource) {
        $hooksDir = $hooksDest.Replace("\", "/")
        $content = Get-Content $hooksJsonSource -Raw
        $content = $content.Replace("{{HOOKS_DIR}}", $hooksDir)

        if (Test-Path $hooksJsonDest) {
            Backup-File $hooksJsonDest
        }
        Ensure-Dir (Split-Path $hooksJsonDest -Parent)
        Set-Content -Path $hooksJsonDest -Value $content -Encoding UTF8
        Write-Host "  Installed: hooks.json (paths resolved)" -ForegroundColor Green
    }

    Write-Host ""
}

# --- 2. Rules/Instructions ---
if (-not $SkipRules) {
    Write-Host "Installing rules..." -ForegroundColor Yellow
    $rulesSource = Join-Path $RepoRoot "instructions"
    $rulesDest = Join-Path $ClaudeHome "rules"

    if (Test-Path $rulesSource) {
        $ruleFiles = Get-ChildItem $rulesSource -Filter "*.md"
        foreach ($f in $ruleFiles) {
            $destName = $f.Name -replace '\.instructions\.md$', '.md'
            $dst = Join-Path $rulesDest $destName
            Copy-WithBackup $f.FullName $dst
        }
    }
    Write-Host ""
}

# --- 3. Skills ---
Write-Host "Installing skills..." -ForegroundColor Yellow
$skillsSource = Join-Path $RepoRoot ".claude" "skills"
$skillsDest = Join-Path $ClaudeHome "skills"

if (Test-Path $skillsSource) {
    $skillDirs = Get-ChildItem $skillsSource -Directory
    foreach ($d in $skillDirs) {
        $skillMd = Join-Path $d.FullName "SKILL.md"
        if (Test-Path $skillMd) {
            $dstDir = Join-Path $skillsDest $d.Name
            Ensure-Dir $dstDir

            Get-ChildItem $d.FullName -Recurse -File | ForEach-Object {
                $rel = $_.FullName.Replace($d.FullName, "").TrimStart("\", "/")
                $dst = Join-Path $dstDir $rel
                Copy-WithBackup $_.FullName $dst
            }
        }
    }
}
Write-Host ""

# --- 4. Commands ---
Write-Host "Installing commands..." -ForegroundColor Yellow
$cmdsSource = Join-Path $RepoRoot ".claude" "commands"
$cmdsDest = Join-Path $ClaudeHome "commands"

if (Test-Path $cmdsSource) {
    $cmdFiles = Get-ChildItem $cmdsSource -Filter "*.md" -Recurse
    foreach ($f in $cmdFiles) {
        $dst = Join-Path $cmdsDest $f.Name
        Copy-WithBackup $f.FullName $dst
    }
}
Write-Host ""

# --- 5. Validation ---
Write-Host "Validating installation..." -ForegroundColor Yellow

$hooksJson = Join-Path $ClaudeHome "hooks" "hooks.json"
if (Test-Path $hooksJson) {
    try {
        $null = Get-Content $hooksJson -Raw | ConvertFrom-Json
        Write-Host "  hooks.json: valid JSON" -ForegroundColor Green
    } catch {
        Write-Host "  hooks.json: INVALID JSON - check manually" -ForegroundColor Red
    }
}

$hookProfile = Join-Path $ClaudeHome "hooks" "hook-profile.ps1"
if (Test-Path $hookProfile) {
    Write-Host "  hook-profile.ps1: present" -ForegroundColor Green
} else {
    Write-Host "  hook-profile.ps1: MISSING" -ForegroundColor Red
}

$rulesCount = (Get-ChildItem (Join-Path $ClaudeHome "rules") -Filter "*.md" -ErrorAction SilentlyContinue | Measure-Object).Count
$skillsCount = (Get-ChildItem (Join-Path $ClaudeHome "skills") -Directory -ErrorAction SilentlyContinue | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | Measure-Object).Count
$cmdsCount = (Get-ChildItem (Join-Path $ClaudeHome "commands") -Filter "*.md" -ErrorAction SilentlyContinue | Measure-Object).Count

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host "  Rules:    $rulesCount installed"
Write-Host "  Skills:   $skillsCount installed"
Write-Host "  Commands: $cmdsCount installed"
Write-Host "  Hooks:    $(if ($SkipHooks) { 'skipped' } else { 'installed' })"
if (Test-Path $BackupDir) {
    Write-Host "  Backups:  $BackupDir" -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "Restart Claude Code to activate the new configuration." -ForegroundColor Yellow
Write-Host ""
