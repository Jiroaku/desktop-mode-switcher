#Requires -RunAsAdministrator

# Desktop Switcher Setup Script
# This script sets up the Gaming/Productivity mode switcher

param(
    [string]$ConfigPath = ".\config.json",
    [switch]$Force,
    [switch]$Uninstall
)

# === FUNCTIONS ===
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-NirCmd {
    param([string]$NirCmdPath)

    if (-not (Test-Path $NirCmdPath)) {
        return $false
    }

    try {
        & $NirCmdPath help | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Find-NirCmd {
    $possiblePaths = @(
        "C:\Tools\NirCmd\nircmd.exe",
        "C:\Program Files\NirCmd\nircmd.exe",
        "C:\Program Files (x86)\NirCmd\nircmd.exe",
        "D:\Tools\NirCmd\nircmd.exe",
        "D:\Dev Program Files\NirCmd\nircmd.exe"
    )

    foreach ($path in $possiblePaths) {
        if (Test-NirCmd $path) {
            return $path
        }
    }
    return $null
}

function Show-ConfigWizard {
    Write-ColorOutput "`n🔧 Configuration Wizard" "Cyan"
    Write-ColorOutput "Let's set up your desktop switcher!" "White"

    # Find NirCmd
    $nircmdPath = Find-NirCmd
    if (-not $nircmdPath) {
        Write-ColorOutput "`n❌ NirCmd not found!" "Red"
        Write-ColorOutput "Please download NirCmd from: https://www.nirsoft.net/utils/nircmd.html" "Yellow"
        Write-ColorOutput "Extract it to a folder like C:\Tools\NirCmd\" "Yellow"
        $nircmdPath = Read-Host "Enter the full path to nircmd.exe"

        if (-not (Test-NirCmd $nircmdPath)) {
            Write-ColorOutput "❌ Invalid NirCmd path!" "Red"
            exit 1
        }
    } else {
        Write-ColorOutput "✅ Found NirCmd at: $nircmdPath" "Green"
    }

    # Get user's preferred apps
    Write-ColorOutput "`n📱 Configure your apps:" "Cyan"
    Write-ColorOutput "Enter the apps you want to close during gaming (one per line, press Enter twice when done):" "White"

    $appsToKill = @()
    do {
        $app = Read-Host "App name (or press Enter to finish)"
        if ($app) {
            $appsToKill += $app
        }
    } while ($app)

    # Get resolution preferences
    Write-ColorOutput "`n🖥️ Gaming Resolution:" "Cyan"
    $gamingWidth = Read-Host "Gaming width (default: 1440)"
    $gamingHeight = Read-Host "Gaming height (default: 1080)"
    $gamingRefresh = Read-Host "Gaming refresh rate (default: 144)"

    $normalWidth = Read-Host "Productivity width (default: 2560)"
    $normalHeight = Read-Host "Productivity height (default: 1440)"
    $normalRefresh = Read-Host "Productivity refresh rate (default: 144)"

    # Create config
    $config = @{
        version = "1.0.0"
        nircmd_path = $nircmdPath
        gaming_mode = @{
            name = "Gaming Mode"
            description = "Optimizes system for gaming performance"
            resolution = @{
                width = if ($gamingWidth) { [int]$gamingWidth } else { 1440 }
                height = if ($gamingHeight) { [int]$gamingHeight } else { 1080 }
                color_depth = 32
                refresh_rate = if ($gamingRefresh) { [int]$gamingRefresh } else { 144 }
            }
            processes_to_kill = $appsToKill
            processes_to_start = @()
            sound_notification = $true
            show_notification = $true
        }
        productivity_mode = @{
            name = "Productivity Mode"
            description = "Restores full desktop environment for work"
            resolution = @{
                width = if ($normalWidth) { [int]$normalWidth } else { 2560 }
                height = if ($normalHeight) { [int]$normalHeight } else { 1440 }
                color_depth = 32
                refresh_rate = if ($normalRefresh) { [int]$normalRefresh } else { 144 }
            }
            processes_to_kill = @()
            processes_to_start = @()
            sound_notification = $true
            show_notification = $true
        }
        notifications = @{
            enabled = $true
            duration = 3000
            position = "top-right"
        }
        sounds = @{
            gaming_mode_sound = "C:\Windows\Media\Windows Notify.wav"
            productivity_mode_sound = "C:\Windows\Media\Windows Notify.wav"
        }
    }

    $config | ConvertTo-Json -Depth 10 | Set-Content -Path $ConfigPath -Encoding UTF8
    Write-ColorOutput "✅ Configuration saved to $ConfigPath" "Green"
}

function Install-DesktopSwitcher {
    param([string]$ConfigPath)

    if (-not (Test-Path $ConfigPath)) {
        Write-ColorOutput "❌ Config file not found: $ConfigPath" "Red"
        return $false
    }

    try {
        $config = Get-Content $ConfigPath | ConvertFrom-Json
    }
    catch {
        Write-ColorOutput "❌ Invalid config file!" "Red"
        return $false
    }

    # Validate NirCmd
    if (-not (Test-NirCmd $config.nircmd_path)) {
        Write-ColorOutput "❌ NirCmd not found at: $($config.nircmd_path)" "Red"
        return $false
    }

    Write-ColorOutput "`n🚀 Installing Desktop Switcher..." "Cyan"

    # Create scripts directory
    $scriptsDir = "$env:USERPROFILE\Documents\DesktopSwitcher"
    if (-not (Test-Path $scriptsDir)) {
        New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
    }

    # Generate scripts
    $gamingScriptPath = "$scriptsDir\Enable-GamingMode.ps1"
    $normalScriptPath = "$scriptsDir\Enable-NormalMode.ps1"

    # Gaming Mode Script
    $gamingScript = @"
# Gaming Mode Script - Generated by Desktop Switcher
# Generated on: $(Get-Date)

# Kill background processes
"@

    foreach ($process in $config.gaming_mode.processes_to_kill) {
        $gamingScript += "`nStop-Process -Name `"$process`" -Force -ErrorAction SilentlyContinue"
    }

    $gamingScript += @"

# Set gaming resolution
& `"$($config.nircmd_path)`" setdisplay $($config.gaming_mode.resolution.width) $($config.gaming_mode.resolution.height) $($config.gaming_mode.resolution.color_depth) $($config.gaming_mode.resolution.refresh_rate)

# Show notification
if (`$config.gaming_mode.show_notification) {
    Add-Type -AssemblyName System.Windows.Forms
    `$notify = New-Object System.Windows.Forms.NotifyIcon
    `$notify.Icon = [System.Drawing.SystemIcons]::Information
    `$notify.BalloonTipTitle = "Gaming Mode Enabled"
    `$notify.BalloonTipText = "Background apps closed, resolution optimized for gaming"
    `$notify.Visible = `$true
    `$notify.ShowBalloonTip(3000)
    Start-Sleep -Seconds 3
    `$notify.Dispose()
}

# Play sound
if (`$config.gaming_mode.sound_notification) {
    [System.Media.SystemSounds]::Asterisk.Play()
}
"@

    $gamingScript | Set-Content -Path $gamingScriptPath -Encoding UTF8

    # Normal Mode Script
    $normalScript = @"
# Productivity Mode Script - Generated by Desktop Switcher
# Generated on: $(Get-Date)

# Start productivity apps
"@

    foreach ($app in $config.productivity_mode.processes_to_start) {
        if ($app.path) {
            $normalScript += "`nStart-Process `"$($app.path)`" -WindowStyle $($app.window_style) -ErrorAction SilentlyContinue"
        }
    }

    $normalScript += @"

# Set productivity resolution
& `"$($config.nircmd_path)`" setdisplay $($config.productivity_mode.resolution.width) $($config.productivity_mode.resolution.height) $($config.productivity_mode.resolution.color_depth) $($config.productivity_mode.resolution.refresh_rate)

# Show notification
if (`$config.productivity_mode.show_notification) {
    Add-Type -AssemblyName System.Windows.Forms
    `$notify = New-Object System.Windows.Forms.NotifyIcon
    `$notify.Icon = [System.Drawing.SystemIcons]::Information
    `$notify.BalloonTipTitle = "Productivity Mode Enabled"
    `$notify.BalloonTipText = "Desktop environment restored for work"
    `$notify.Visible = `$true
    `$notify.ShowBalloonTip(3000)
    Start-Sleep -Seconds 3
    `$notify.Dispose()
}

# Play sound
if (`$config.productivity_mode.sound_notification) {
    [System.Media.SystemSounds]::Asterisk.Play()
}
"@

    $normalScript | Set-Content -Path $normalScriptPath -Encoding UTF8

    # Create scheduled tasks
    $gamingTaskName = "DesktopSwitcher-GamingMode"
    $normalTaskName = "DesktopSwitcher-NormalMode"

    # Remove existing tasks
    schtasks /Delete /F /TN $gamingTaskName 2>$null
    schtasks /Delete /F /TN $normalTaskName 2>$null

    # Create new tasks
    schtasks /Create /F /RL HIGHEST /SC ONCE /TN $gamingTaskName /TR "powershell -ExecutionPolicy Bypass -File `"$gamingScriptPath`"" /ST 00:00
    schtasks /Create /F /RL HIGHEST /SC ONCE /TN $normalTaskName /TR "powershell -ExecutionPolicy Bypass -File `"$normalScriptPath`"" /ST 00:00

    # Create shortcuts
    $WshShell = New-Object -ComObject WScript.Shell

    $shortcut1 = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\🎮 Gaming Mode.lnk")
    $shortcut1.TargetPath = "schtasks"
    $shortcut1.Arguments = "/Run /TN $gamingTaskName"
    $shortcut1.IconLocation = "shell32.dll,23"
    $shortcut1.Save()

    $shortcut2 = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\💼 Productivity Mode.lnk")
    $shortcut2.TargetPath = "schtasks"
    $shortcut2.Arguments = "/Run /TN $normalTaskName"
    $shortcut2.IconLocation = "shell32.dll,22"
    $shortcut2.Save()

    Write-ColorOutput "✅ Desktop Switcher installed successfully!" "Green"
    Write-ColorOutput "📱 Shortcuts created on desktop" "White"
    Write-ColorOutput "🎮 Gaming Mode: Kills background apps, optimizes resolution" "White"
    Write-ColorOutput "💼 Productivity Mode: Restores desktop environment" "White"

    return $true
}

function Uninstall-DesktopSwitcher {
    Write-ColorOutput "`n🗑️ Uninstalling Desktop Switcher..." "Cyan"

    # Remove tasks
    schtasks /Delete /F /TN "DesktopSwitcher-GamingMode" 2>$null
    schtasks /Delete /F /TN "DesktopSwitcher-NormalMode" 2>$null

    # Remove shortcuts
    Remove-Item "$env:USERPROFILE\Desktop\🎮 Gaming Mode.lnk" -ErrorAction SilentlyContinue
    Remove-Item "$env:USERPROFILE\Desktop\💼 Productivity Mode.lnk" -ErrorAction SilentlyContinue

    # Remove scripts
    Remove-Item "$env:USERPROFILE\Documents\DesktopSwitcher" -Recurse -Force -ErrorAction SilentlyContinue

    Write-ColorOutput "✅ Desktop Switcher uninstalled!" "Green"
}

# === MAIN SCRIPT ===
Write-ColorOutput "🖥️ Desktop Switcher Setup" "Cyan"
Write-ColorOutput "=========================" "Cyan"

if ($Uninstall) {
    Uninstall-DesktopSwitcher
    exit 0
}

if (-not (Test-Path $ConfigPath) -or $Force) {
    Show-ConfigWizard
}

if (Install-DesktopSwitcher $ConfigPath) {
    Write-ColorOutput "`n🎉 Setup complete! You can now use the desktop shortcuts to switch modes." "Green"
} else {
    Write-ColorOutput "`n❌ Setup failed. Please check the errors above." "Red"
    exit 1
}