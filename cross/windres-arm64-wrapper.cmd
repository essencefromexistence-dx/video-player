@echo off
"G:\Dev\Tools\Scoop\apps\mingw\current\bin\windres.exe" --target=aarch64-w64-mingw32 %*
exit /b %ERRORLEVEL%
