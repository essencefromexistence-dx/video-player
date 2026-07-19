@echo off
setlocal

"%~dp0/dx-video-player" --unregister
if %errorlevel% neq 0 (
    echo Deregistration failed. Make sure dx-video-player is in the same folder as this script.
    pause
    exit /b %errorlevel%
)

pause
endlocal
