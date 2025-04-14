# === CONFIG ===
$gamingScriptPath = "$env:USERPROFILE\Documents\Enable-GamingMode.ps1"
$normalScriptPath = "$env:USERPROFILE\Documents\Enable-NormalMode.ps1"
$nircmd = "D:\Dev Program Files\NirCmd\nircmd.exe"

# === CREATE GAMING MODE SCRIPT ===
$gamingScript = @"
# Kill background tools
Stop-Process -Name "Windhawk" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "PowerToys" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "yasb" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Everything" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "cute-borders" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "wallpaper32" -Force -ErrorAction SilentlyContinue

# Set gaming resolution
& "$nircmd" setdisplay 1440 1080 32 144
"@
$gamingScript | Set-Content -Path $gamingScriptPath -Encoding UTF8
6
# === CREATE NORMAL MODE SCRIPT ===
$normalScript = @"
# Reopen background tools minimized
Start-Process "D:\Dev Program Files\Windhawk\windhawk.exe" -WindowStyle Minimized
Start-Process "D:\Dev Program Files\PowerToys\PowerToys.exe" -WindowStyle Minimized
Start-Process "D:\Dev Program Files\Yasb\yasb.exe" -WindowStyle Minimized
Start-Process "D:\Dev Program Files\Everything\Everything.exe" -WindowStyle Minimized
Start-Process "C:\Users\Straker\.cuteborders\cute-borders.exe" -WindowStyle Minimized
Start-Process "E:\Programs\Steam\steamapps\common\wallpaper_engine\wallpaper32.exe" -WindowStyle Minimized

# Set normal resolution
& "$nircmd" setdisplay 2560 1440 32 144
"@
$normalScript | Set-Content -Path $normalScriptPath -Encoding UTF8

# === CREATE TASKS TO RUN SCRIPTS AS ADMIN ===
$gamingTaskName = "GamingModeSwitch"
$normalTaskName = "NormalModeSwitch"

schtasks /Create /F /RL HIGHEST /SC ONCE /TN $gamingTaskName /TR "powershell -ExecutionPolicy Bypass -File `"$gamingScriptPath`"" /ST 00:00
schtasks /Create /F /RL HIGHEST /SC ONCE /TN $normalTaskName /TR "powershell -ExecutionPolicy Bypass -File `"$normalScriptPath`"" /ST 00:00

# === CREATE SHORTCUTS ===
$WshShell = New-Object -ComObject WScript.Shell

$shortcut1 = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Enable Gaming Mode.lnk")
$shortcut1.TargetPath = "schtasks"
$shortcut1.Arguments = "/Run /TN $gamingTaskName"
$shortcut1.Save()

$shortcut2 = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Enable Normal Mode.lnk")
$shortcut2.TargetPath = "schtasks"
$shortcut2.Arguments = "/Run /TN $normalTaskName"
$shortcut2.Save()
