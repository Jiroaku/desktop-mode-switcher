@echo off
echo Desktop Switcher Installer
echo ========================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo Running Desktop Switcher setup...
echo.

REM Run the PowerShell setup script
powershell -ExecutionPolicy Bypass -File "scripts\Setup-GamingSwitcher.ps1"

if %errorLevel% equ 0 (
    echo.
    echo SUCCESS: Desktop Switcher has been installed!
    echo Check your desktop for the new shortcuts.
    echo.
) else (
    echo.
    echo ERROR: Installation failed.
    echo Please check the error messages above.
    echo.
)

pause
