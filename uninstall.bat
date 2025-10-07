@echo off
echo Desktop Switcher Uninstaller
echo ============================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo This will remove Desktop Switcher from your system.
set /p confirm="Are you sure you want to continue? (y/N): "
if /i not "%confirm%"=="y" (
    echo Uninstall cancelled.
    pause
    exit /b 0
)

echo.
echo Removing Desktop Switcher...
echo.

REM Run the PowerShell uninstall script
powershell -ExecutionPolicy Bypass -File "scripts\Uninstall-DesktopSwitcher.ps1"

if %errorLevel% equ 0 (
    echo.
    echo SUCCESS: Desktop Switcher has been uninstalled!
    echo.
) else (
    echo.
    echo ERROR: Uninstall failed.
    echo Please check the error messages above.
    echo.
)

pause
