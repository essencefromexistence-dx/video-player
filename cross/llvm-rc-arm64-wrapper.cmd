@echo off
setlocal

rem Meson may invoke this as either:
rem   input.rc output.o [windres options]
rem or:
rem   /nologo /fooutput.res input.rc
rem llvm-rc emits a .res-compatible object, which llvm-lib/lld-link accept
rem even when Meson gives the output file a .o suffix.
set "input="
set "output="

:parse
if "%~1"=="" goto run
set "arg=%~1"
if /I "%arg%"=="/nologo" goto next
if /I "%arg:~0,3%"=="/fo" (
    set "output=%arg:~3%"
    goto next
)
if /I "%arg:~0,2%"=="--" goto next
if not defined input (
    set "input=%~1"
    goto next
)
if not defined output set "output=%~1"

:next
shift
goto parse

:run
if "%input%"=="" exit /b 1
if "%output%"=="" exit /b 1
"C:\Program Files\LLVM\bin\llvm-rc.exe" /I "%~dp0.." /I "%CD%" /I "%CD%\common" /FO "%output%" "%input%"
exit /b %ERRORLEVEL%
