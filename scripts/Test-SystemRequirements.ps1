#Requires -RunAsAdministrator

# Desktop Switcher System Requirements Test
# This script validates that your system meets all requirements

param(
    [switch]$Detailed,
    [switch]$Fix
)

# === FUNCTIONS ===
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-NirCmd {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return @{ Success = $false; Message = "NirCmd not found at: $Path" }
    }

    try {
        $result = & $Path help 2>&1
        if ($LASTEXITCODE -eq 0) {
            return @{ Success = $true; Message = "NirCmd is working correctly" }
        } else {
            return @{ Success = $false; Message = "NirCmd executable is corrupted or incompatible" }
        }
    }
    catch {
        return @{ Success = $false; Message = "NirCmd execution failed: $($_.Exception.Message)" }
    }
}

function Find-NirCmd {
    $possiblePaths = @(
        "C:\Tools\NirCmd\nircmd.exe",
        "C:\Program Files\NirCmd\nircmd.exe",
        "C:\Program Files (x86)\NirCmd\nircmd.exe",
        "D:\Tools\NirCmd\nircmd.exe",
        "D:\Dev Program Files\NirCmd\nircmd.exe",
        "C:\NirCmd\nircmd.exe"
    )

    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $test = Test-NirCmd $path
            if ($test.Success) {
                return @{ Path = $path; Test = $test }
            }
        }
    }
    return $null
}

function Test-PowerShellVersion {
    $version = $PSVersionTable.PSVersion
    $required = [Version]"5.1"

    if ($version -ge $required) {
        return @{ Success = $true; Message = "PowerShell $version (Required: $required)" }
    } else {
        return @{ Success = $false; Message = "PowerShell $version (Required: $required or higher)" }
    }
}

function Test-WindowsVersion {
    $version = [System.Environment]::OSVersion.Version
    $build = $version.Build

    # Windows 10 build 10240 or higher
    if ($build -ge 10240) {
        return @{ Success = $true; Message = "Windows Build $build (Compatible)" }
    } else {
        return @{ Success = $false; Message = "Windows Build $build (Requires Windows 10 or higher)" }
    }
}

function Test-TaskScheduler {
    try {
        $tasks = schtasks /Query /TN "DesktopSwitcher-GamingMode" 2>$null
        if ($LASTEXITCODE -eq 0) {
            return @{ Success = $true; Message = "Desktop Switcher tasks are installed" }
        } else {
            return @{ Success = $false; Message = "Desktop Switcher tasks not found (run setup first)" }
        }
    }
    catch {
        return @{ Success = $false; Message = "Task Scheduler access failed: $($_.Exception.Message)" }
    }
}

function Test-Shortcuts {
    $shortcuts = @(
        "$env:USERPROFILE\Desktop\🎮 Gaming Mode.lnk",
        "$env:USERPROFILE\Desktop\💼 Productivity Mode.lnk"
    )

    $found = 0
    foreach ($shortcut in $shortcuts) {
        if (Test-Path $shortcut) {
            $found++
        }
    }

    if ($found -eq $shortcuts.Count) {
        return @{ Success = $true; Message = "All desktop shortcuts found" }
    } else {
        return @{ Success = $false; Message = "Missing desktop shortcuts ($found/$($shortcuts.Count) found)" }
    }
}

function Test-ConfigFile {
    $configPath = ".\config.json"
    if (-not (Test-Path $configPath)) {
        return @{ Success = $false; Message = "Configuration file not found: $configPath" }
    }

    try {
        $config = Get-Content $configPath | ConvertFrom-Json
        if ($config.nircmd_path -and (Test-Path $config.nircmd_path)) {
            return @{ Success = $true; Message = "Configuration file is valid" }
        } else {
            return @{ Success = $false; Message = "Configuration file has invalid NirCmd path" }
        }
    }
    catch {
        return @{ Success = $false; Message = "Configuration file is corrupted: $($_.Exception.Message)" }
    }
}

function Get-SystemInfo {
    return @{
        OS = [System.Environment]::OSVersion.VersionString
        PowerShell = $PSVersionTable.PSVersion.ToString()
        User = [System.Environment]::UserName
        Computer = [System.Environment]::MachineName
        Architecture = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    }
}

function Show-DetailedReport {
    param([array]$Tests)

    Write-ColorOutput "`n📊 Detailed System Report" "Cyan"
    Write-ColorOutput "=========================" "Cyan"

    $systemInfo = Get-SystemInfo
    Write-ColorOutput "`n🖥️ System Information:" "Yellow"
    Write-ColorOutput "  OS: $($systemInfo.OS)" "White"
    Write-ColorOutput "  PowerShell: $($systemInfo.PowerShell)" "White"
    Write-ColorOutput "  User: $($systemInfo.User)" "White"
    Write-ColorOutput "  Computer: $($systemInfo.Computer)" "White"
    Write-ColorOutput "  Architecture: $($systemInfo.Architecture)" "White"

    Write-ColorOutput "`n🔍 Test Results:" "Yellow"
    foreach ($test in $Tests) {
        $status = if ($test.Success) { "✅" } else { "❌" }
        $color = if ($test.Success) { "Green" } else { "Red" }
        Write-ColorOutput "  $status $($test.Name): $($test.Message)" $color
    }

    $passed = ($Tests | Where-Object { $_.Success }).Count
    $total = $Tests.Count

    Write-ColorOutput "`n📈 Summary: $passed/$total tests passed" "Cyan"
}

function Show-FixSuggestions {
    param([array]$FailedTests)

    Write-ColorOutput "`n🔧 Fix Suggestions" "Cyan"
    Write-ColorOutput "==================" "Cyan"

    foreach ($test in $FailedTests) {
        switch ($test.Name) {
            "Administrator Rights" {
                Write-ColorOutput "`n🔑 Administrator Rights:" "Yellow"
                Write-ColorOutput "  • Right-click PowerShell and select 'Run as Administrator'" "White"
                Write-ColorOutput "  • Or run: Start-Process powershell -Verb RunAs" "White"
            }
            "NirCmd Installation" {
                Write-ColorOutput "`n📦 NirCmd Installation:" "Yellow"
                Write-ColorOutput "  • Download from: https://www.nirsoft.net/utils/nircmd.html" "White"
                Write-ColorOutput "  • Extract to: C:\Tools\NirCmd\" "White"
                Write-ColorOutput "  • Or update config.json with correct path" "White"
            }
            "PowerShell Version" {
                Write-ColorOutput "`n💻 PowerShell Version:" "Yellow"
                Write-ColorOutput "  • Update Windows to get PowerShell 5.1+" "White"
                Write-ColorOutput "  • Or install PowerShell Core 7+" "White"
            }
            "Windows Version" {
                Write-ColorOutput "`n🪟 Windows Version:" "Yellow"
                Write-ColorOutput "  • Update to Windows 10 or higher" "White"
                Write-ColorOutput "  • Check Windows Update" "White"
            }
            "Desktop Switcher Installation" {
                Write-ColorOutput "`n⚙️ Desktop Switcher:" "Yellow"
                Write-ColorOutput "  • Run: .\scripts\Setup-GamingSwitcher.ps1" "White"
                Write-ColorOutput "  • As Administrator" "White"
            }
            "Configuration File" {
                Write-ColorOutput "`n📄 Configuration:" "Yellow"
                Write-ColorOutput "  • Check config.json exists and is valid" "White"
                Write-ColorOutput "  • Run setup wizard to create configuration" "White"
            }
        }
    }
}

# === MAIN SCRIPT ===
Write-ColorOutput "🖥️ Desktop Switcher System Requirements Test" "Cyan"
Write-ColorOutput "=============================================" "Cyan"

$tests = @()

# Test Administrator Rights
$adminTest = Test-AdminRights
$tests += @{
    Name = "Administrator Rights"
    Success = $adminTest
    Message = if ($adminTest) { "Running with administrator privileges" } else { "Not running as administrator" }
}

# Test PowerShell Version
$psTest = Test-PowerShellVersion
$tests += @{
    Name = "PowerShell Version"
    Success = $psTest.Success
    Message = $psTest.Message
}

# Test Windows Version
$winTest = Test-WindowsVersion
$tests += @{
    Name = "Windows Version"
    Success = $winTest.Success
    Message = $winTest.Message
}

# Test NirCmd
$nircmd = Find-NirCmd
if ($nircmd) {
    $tests += @{
        Name = "NirCmd Installation"
        Success = $true
        Message = "Found at: $($nircmd.Path)"
    }
} else {
    $tests += @{
        Name = "NirCmd Installation"
        Success = $false
        Message = "NirCmd not found in common locations"
    }
}

# Test Configuration File
$configTest = Test-ConfigFile
$tests += @{
    Name = "Configuration File"
    Success = $configTest.Success
    Message = $configTest.Message
}

# Test Task Scheduler
$taskTest = Test-TaskScheduler
$tests += @{
    Name = "Desktop Switcher Installation"
    Success = $taskTest.Success
    Message = $taskTest.Message
}

# Test Shortcuts
$shortcutTest = Test-Shortcuts
$tests += @{
    Name = "Desktop Shortcuts"
    Success = $shortcutTest.Success
    Message = $shortcutTest.Message
}

# Show Results
$passed = ($tests | Where-Object { $_.Success }).Count
$total = $tests.Count

Write-ColorOutput "`n📊 Quick Results: $passed/$total tests passed" "Cyan"

if ($Detailed) {
    Show-DetailedReport $tests
}

$failedTests = $tests | Where-Object { -not $_.Success }
if ($failedTests.Count -gt 0) {
    Write-ColorOutput "`n❌ Failed Tests:" "Red"
    foreach ($test in $failedTests) {
        Write-ColorOutput "  • $($test.Name): $($test.Message)" "Red"
    }

    if ($Fix) {
        Show-FixSuggestions $failedTests
    }
} else {
    Write-ColorOutput "`n🎉 All tests passed! Your system is ready for Desktop Switcher." "Green"
}
