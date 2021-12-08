@echo off
setlocal enabledelayedexpansion

set _SCALA_ENV=
if defined JAVACMD ( set _SCALA_ENV=1
) else if defined JAVA_HOME ( set _SCALA_ENV=1
) else if exist "%ProgramFiles%\Amazon Corretto\jdk*" (
    call :javacmd "%ProgramFiles%\Amazon Corretto" "jdk*"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles%\Eclipse Adoptium\" (
    call :javacmd "%ProgramFiles%\Eclipse Adoptium"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles%\Microsoft\jdk-*" (
    call :javacmd "%ProgramFiles%\Microsoft" "jdk-*"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles%\RedHat\java-*" (
    call :javacmd "%ProgramFiles%\RedHat" "java-*"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles%\SapMachine\JDK\*" (
    call :javacmd "%ProgramFiles%\SapMachine\JDK"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles%\Zulu\zulu-*" (
    call :javacmd "%ProgramFiles%\Zulu" "zulu-*"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles%\Java\" (
    call :javacmd "%ProgramFiles%\Java"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%ProgramFiles(x86)%\Java\" (
    call :javacmd "%ProgramFiles(x86)%\Java"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
) else if exist "%SystemDrive%\opt\*jdk*" (
    call :javacmd "%SystemDrive%\opt\" "*jdk*"
    if defined _JAVACMD set "JAVACMD=!_JAVACMD!"& set _SCALA_ENV=1
)
if defined _SCALA_ENV (
    call "%~dp0scala.bat"
    exit /b !ERRORLEVEL!
) else (
    powershell -C "$x = [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $res = [Windows.Forms.MessageBox]::show('Environment variable JAVA_HOME or JAVAMCD must be defined', 'Scala 2');
    exit /b 1
)
endlocal

@rem output parameter: _JAVACMD
:javacmd
set _JAVACMD=

set "__PATH=%~1"
set "__PATTERN=%~2"
for /f "delims=" %%d in ('dir /ad /b "%__PATH%\%__PATTERN%" 2^>NUL') do (
    for /f "delims=" %%f in ('where /r "%__PATH%\%%d\bin" java.exe 2^>NUL') do ( 
        set "_JAVACMD=%%f"
        goto :eof
    )
)
goto :eof
