# Desktop Switcher Troubleshooting Guide

This guide helps you resolve common issues with Desktop Switcher.

## 🔍 Quick Diagnostics

Run the system requirements test to identify issues:

```powershell
# Basic test
.\scripts\Test-SystemRequirements.ps1

# Detailed test with fix suggestions
.\scripts\Test-SystemRequirements.ps1 -Detailed -Fix
```

## 🚨 Common Issues & Solutions

### 1. "NirCmd not found" Error

**Problem**: Setup fails because NirCmd cannot be found.

**Solutions**:
1. **Download NirCmd**:
   - Visit: https://www.nirsoft.net/utils/nircmd.html
   - Download the ZIP file
   - Extract to `C:\Tools\NirCmd\`

2. **Update Configuration**:
   ```powershell
   # Edit config.json and update the path
   {
     "nircmd_path": "C:\\Tools\\NirCmd\\nircmd.exe"
   }
   ```

3. **Verify Installation**:
   ```powershell
   # Test if NirCmd works
   C:\Tools\NirCmd\nircmd.exe help
   ```

### 2. "Access Denied" Errors

**Problem**: Scripts fail with permission errors.

**Solutions**:
1. **Run as Administrator**:
   - Right-click PowerShell
   - Select "Run as Administrator"

2. **Check UAC Settings**:
   - Open User Account Control settings
   - Ensure it's not set to "Always notify"

3. **Verify Task Scheduler Permissions**:
   ```powershell
   # Check if tasks exist
   schtasks /Query /TN DesktopSwitcher-GamingMode
   ```

### 3. Shortcuts Not Working

**Problem**: Desktop shortcuts don't switch modes.

**Solutions**:
1. **Verify Tasks Exist**:
   ```powershell
   schtasks /Query /TN DesktopSwitcher-GamingMode
   schtasks /Query /TN DesktopSwitcher-NormalMode
   ```

2. **Recreate Tasks**:
   ```powershell
   # Re-run setup
   .\scripts\Setup-GamingSwitcher.ps1
   ```

3. **Check Shortcut Properties**:
   - Right-click shortcut → Properties
   - Verify Target points to `schtasks`
   - Check Arguments are correct

### 4. Apps Not Closing/Opening

**Problem**: Apps don't respond to mode switches.

**Solutions**:
1. **Check Process Names**:
   ```powershell
   # Find exact process names in Task Manager
   Get-Process | Where-Object {$_.ProcessName -like "*discord*"}
   ```

2. **Update Configuration**:
   ```json
   {
     "gaming_mode": {
       "processes_to_kill": [
         "Discord",        // Exact process name
         "chrome",         // Not "Chrome"
         "firefox"         // Not "Firefox"
       ]
     }
   }
   ```

3. **Test Individual Apps**:
   ```powershell
   # Test closing an app
   Stop-Process -Name "Discord" -Force -ErrorAction SilentlyContinue
   ```

### 5. Resolution Not Changing

**Problem**: Screen resolution doesn't switch.

**Solutions**:
1. **Verify NirCmd Path**:
   ```powershell
   # Test resolution change manually
   C:\Tools\NirCmd\nircmd.exe setdisplay 1920 1080 32 60
   ```

2. **Check Supported Resolutions**:
   - Open Display Settings
   - Note your monitor's supported resolutions
   - Update config.json with valid resolutions

3. **Test Different Resolutions**:
   ```json
   {
     "gaming_mode": {
       "resolution": {
         "width": 1920,
         "height": 1080,
         "color_depth": 32,
         "refresh_rate": 60
       }
     }
   }
   ```

### 6. Notifications Not Showing

**Problem**: No visual/audio feedback when switching modes.

**Solutions**:
1. **Enable Notifications**:
   ```json
   {
     "gaming_mode": {
       "show_notification": true,
       "sound_notification": true
     }
   }
   ```

2. **Check Windows Notification Settings**:
   - Settings → System → Notifications
   - Ensure PowerShell notifications are enabled

3. **Test Notifications**:
   ```powershell
   # Test notification manually
   Add-Type -AssemblyName System.Windows.Forms
   $notify = New-Object System.Windows.Forms.NotifyIcon
   $notify.Icon = [System.Drawing.SystemIcons]::Information
   $notify.BalloonTipTitle = "Test"
   $notify.BalloonTipText = "This is a test notification"
   $notify.Visible = $true
   $notify.ShowBalloonTip(3000)
   ```

### 7. GUI Not Opening

**Problem**: DesktopSwitcher-GUI.ps1 doesn't start.

**Solutions**:
1. **Check PowerShell Execution Policy**:
   ```powershell
   Get-ExecutionPolicy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Run with Explicit Parameters**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File ".\scripts\DesktopSwitcher-GUI.ps1"
   ```

3. **Check Dependencies**:
   - Ensure config.json exists
   - Verify all required assemblies are available

### 8. Performance Issues

**Problem**: Mode switching is slow or causes system lag.

**Solutions**:
1. **Reduce App List**:
   - Remove unnecessary apps from kill/start lists
   - Focus on resource-heavy applications only

2. **Optimize Scripts**:
   ```json
   {
     "gaming_mode": {
       "processes_to_kill": [
         "chrome",      // Only essential apps
         "discord",
         "spotify"
       ]
     }
   }
   ```

3. **Check System Resources**:
   - Monitor CPU/Memory usage during switches
   - Close other resource-intensive applications

## 🔧 Advanced Troubleshooting

### Enable Debug Logging

Add debug output to scripts:

```powershell
# Add to beginning of scripts
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

# Add debug statements
Write-Debug "Starting gaming mode switch"
Write-Verbose "Killing process: $processName"
```

### Check Windows Event Logs

1. Open Event Viewer
2. Navigate to: Windows Logs → Application
3. Look for PowerShell or Desktop Switcher entries
4. Check for error details

### Manual Task Execution

Test tasks manually:

```powershell
# Run gaming mode task
schtasks /Run /TN DesktopSwitcher-GamingMode

# Run productivity mode task
schtasks /Run /TN DesktopSwitcher-NormalMode
```

### Configuration Validation

Validate your configuration:

```powershell
# Test JSON syntax
Get-Content config.json | ConvertFrom-Json

# Check required fields
$config = Get-Content config.json | ConvertFrom-Json
$config.nircmd_path
$config.gaming_mode.resolution
```

## 🆘 Getting Help

If you're still having issues:

1. **Run Full Diagnostics**:
   ```powershell
   .\scripts\Test-SystemRequirements.ps1 -Detailed -Fix
   ```

2. **Check System Logs**:
   - Windows Event Viewer
   - PowerShell execution logs
   - Task Scheduler logs

3. **Create Issue Report**:
   - Include system information
   - Attach configuration file
   - Describe exact error messages
   - Include steps to reproduce

4. **Community Support**:
   - Check GitHub Issues
   - Review example configurations
   - Ask in discussions

## 📋 System Requirements Checklist

- [ ] Windows 10 or higher
- [ ] PowerShell 5.1 or higher
- [ ] Administrator privileges
- [ ] NirCmd installed and accessible
- [ ] Task Scheduler permissions
- [ ] Valid configuration file
- [ ] Supported display resolutions

## 🔄 Reset to Default

If all else fails, reset to defaults:

```powershell
# Uninstall everything
.\scripts\Uninstall-DesktopSwitcher.ps1

# Remove configuration
Remove-Item config.json -Force

# Reinstall with defaults
.\scripts\Setup-GamingSwitcher.ps1
```

---

**Still need help?** Create an issue on GitHub with:
- System information
- Error messages
- Configuration file
- Steps to reproduce
