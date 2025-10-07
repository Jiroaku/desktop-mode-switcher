#Requires -RunAsAdministrator

# Desktop Switcher Uninstaller
# This script removes all Desktop Switcher components

param(
    [switch]$Force
)

# === FUNCTIONS ===
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Remove-DesktopSwitcher {
    Write-ColorOutput "`n🗑️ Desktop Switcher Uninstaller" "Cyan"
    Write-ColorOutput "=================================" "Cyan"

    $removedItems = @()
    $errors = @()

    # Remove scheduled tasks
    Write-ColorOutput "`n📋 Removing scheduled tasks..." "Yellow"
    $tasks = @("DesktopSwitcher-GamingMode", "DesktopSwitcher-NormalMode", "GamingModeSwitch", "NormalModeSwitch")

    foreach ($task in $tasks) {
        try {
            $result = schtasks /Query /TN $task 2>$null
            if ($LASTEXITCODE -eq 0) {
                schtasks /Delete /F /TN $task 2>$null
                if ($LASTEXITCODE -eq 0) {
                    $removedItems += "Scheduled task: $task"
                    Write-ColorOutput "  ✅ Removed task: $task" "Green"
                } else {
                    $errors += "Failed to remove task: $task"
                    Write-ColorOutput "  ❌ Failed to remove task: $task" "Red"
                }
            }
        }
        catch {
            # Task doesn't exist, that's fine
        }
    }

    # Remove desktop shortcuts
    Write-ColorOutput "`n🔗 Removing desktop shortcuts..." "Yellow"
    $shortcuts = @(
        "$env:USERPROFILE\Desktop\🎮 Gaming Mode.lnk",
        "$env:USERPROFILE\Desktop\💼 Productivity Mode.lnk",
        "$env:USERPROFILE\Desktop\Enable Gaming Mode.lnk",
        "$env:USERPROFILE\Desktop\Enable Normal Mode.lnk"
    )

    foreach ($shortcut in $shortcuts) {
        if (Test-Path $shortcut) {
            try {
                Remove-Item $shortcut -Force
                $removedItems += "Desktop shortcut: $(Split-Path $shortcut -Leaf)"
                Write-ColorOutput "  ✅ Removed shortcut: $(Split-Path $shortcut -Leaf)" "Green"
            }
            catch {
                $errors += "Failed to remove shortcut: $shortcut"
                Write-ColorOutput "  ❌ Failed to remove shortcut: $(Split-Path $shortcut -Leaf)" "Red"
            }
        }
    }

    # Remove scripts directory
    Write-ColorOutput "`n📁 Removing scripts directory..." "Yellow"
    $scriptsDir = "$env:USERPROFILE\Documents\DesktopSwitcher"
    if (Test-Path $scriptsDir) {
        try {
            Remove-Item $scriptsDir -Recurse -Force
            $removedItems += "Scripts directory: $scriptsDir"
            Write-ColorOutput "  ✅ Removed scripts directory" "Green"
        }
        catch {
            $errors += "Failed to remove scripts directory: $scriptsDir"
            Write-ColorOutput "  ❌ Failed to remove scripts directory" "Red"
        }
    }

    # Remove individual script files
    $scriptFiles = @(
        "$env:USERPROFILE\Documents\Enable-GamingMode.ps1",
        "$env:USERPROFILE\Documents\Enable-NormalMode.ps1"
    )

    foreach ($script in $scriptFiles) {
        if (Test-Path $script) {
            try {
                Remove-Item $script -Force
                $removedItems += "Script file: $(Split-Path $script -Leaf)"
                Write-ColorOutput "  ✅ Removed script: $(Split-Path $script -Leaf)" "Green"
            }
            catch {
                $errors += "Failed to remove script: $script"
                Write-ColorOutput "  ❌ Failed to remove script: $(Split-Path $script -Leaf)" "Red"
            }
        }
    }

    # Summary
    Write-ColorOutput "`n📊 Uninstall Summary" "Cyan"
    Write-ColorOutput "===================" "Cyan"

    if ($removedItems.Count -gt 0) {
        Write-ColorOutput "`n✅ Successfully removed:" "Green"
        foreach ($item in $removedItems) {
            Write-ColorOutput "  • $item" "White"
        }
    }

    if ($errors.Count -gt 0) {
        Write-ColorOutput "`n❌ Errors encountered:" "Red"
        foreach ($error in $errors) {
            Write-ColorOutput "  • $error" "White"
        }
    }

    if ($removedItems.Count -gt 0 -and $errors.Count -eq 0) {
        Write-ColorOutput "`n🎉 Desktop Switcher has been completely uninstalled!" "Green"
        Write-ColorOutput "All components have been removed from your system." "White"
    } elseif ($errors.Count -gt 0) {
        Write-ColorOutput "`n⚠️ Uninstall completed with some errors." "Yellow"
        Write-ColorOutput "Some components may still remain on your system." "White"
    } else {
        Write-ColorOutput "`nℹ️ No Desktop Switcher components found to remove." "Blue"
        Write-ColorOutput "The system appears to be clean." "White"
    }
}

# === MAIN SCRIPT ===
if (-not $Force) {
    Write-ColorOutput "🖥️ Desktop Switcher Uninstaller" "Cyan"
    Write-ColorOutput "This will remove all Desktop Switcher components from your system." "White"
    Write-ColorOutput ""
    $confirm = Read-Host "Are you sure you want to continue? (y/N)"

    if ($confirm -notmatch "^[yY]") {
        Write-ColorOutput "Uninstall cancelled." "Yellow"
        exit 0
    }
}

Remove-DesktopSwitcher
