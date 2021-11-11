@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end 

call :args %*
if not %_EXITCODE%==0 goto end 

@rem #########################################################################
@rem ##  Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_INSTALL%==1 (
    call :install
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

set "_PROJECT_DIR=%_ROOT_DIR%cpp"
set "_SOURCE_DIR=%_PROJECT_DIR%\src"
for /f "delims=" %%f in ("%~dp0.") do set "_INSTALL_DIR=%%~dpf"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

for %%f in ("%~dp0.") do set "_PROJECT_NAME=%%~nf"
set _PROJECT_PLATFORM=Win32

set "_MSBUILD_HOME=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\MSBuild\Current"

set _MSBUILD_CMD=
if exist "%_MSBUILD_HOME%\bin\msbuild.exe" (
    set "_MSBUILD_CMD=%_MSBUILD_HOME%\bin\msbuild.exe"
)
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

:args
set _CLEAN=0
set _COMPILE=0
set _HELP=0
set _INSTALL=0
set _PROJECT_CONFIG=Release
set _TARGET_NAME=%_PROJECT_NAME%
set _TIMER=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-help" ( set _HELP=1
    ) else if "%__ARG%"=="-config:Debug" ( set _PROJECT_CONFIG=Debug
    ) else if "%__ARG%"=="-config:Release" ( set _PROJECT_CONFIG=Release
    ) else if "%__ARG:~0,6%"=="-name:" (
        call :target_name "%__ARG:~6%"
        if not !_EXITCODE!==0 goto args_done
    ) else if "%__ARG%"=="-timer" ( set _TIMER=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if "%__ARG%"=="install" ( set _COMPILE=1& set _INSTALL=1
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
set "_OUTPUT_DIR=%_PROJECT_DIR%\%_PROJECT_CONFIG%"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Properties : _PROJECT_NAME=%_PROJECT_NAME% _PROJECT_CONFIG=%_PROJECT_CONFIG% 1>&2
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _INSTALL=%_INSTALL% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
goto :eof

@rem output parameter: _TARGET_NAME
:target_name
set __NAME=
for /f %%i in ('echo "%~1"^|findstr /r [a-z][a-z0-1_-]*') do set "__NAME=%%~i"
if not defined __NAME (
    echo %_ERROR_LABEL% Invalid target name "%~1" ^(accepted syntax: [a-z][a-z0-1_-]^*^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_TARGET_NAME=%__NAME%"
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%%_UNDERSCORE%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      show commands executed by this script
echo     %__BEG_O%-timer%__END%      display total execution time
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%       delete generated files
echo     %__BEG_O%compile%__END%     compile C++ source files
echo     %__BEG_O%install%__END%     install application
echo     %__BEG_O%help%__END%        display this help message
goto :eof

:clean
call :rmdir "%_PROJECT_DIR%\Debug"
call :rmdir "%_PROJECT_DIR%\Release"
goto :eof

@rem input parameter: %1=directory path
:rmdir
set "__DIR=%~1"
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory "!__DIR:%_ROOT_DIR%=!" 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
set "__EXE_FILE=%_OUTPUT_DIR%\%_TARGET_NAME%.exe"

if not defined _MSBUILD_CMD (
    if exist "%WINDIR%\System32\calc.exe" (
        echo 000000000000
        echo %_WARNING_LABEL% MSBuild tool not found; let's take "calc.exe" as alternative Windows application 1>&2
        if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /y "%WINDIR%\System32\calc.exe" "%__EXE_FILE%" 1>&2
        echo F|xcopy /y "%WINDIR%\System32\calc.exe" "%__EXE_FILE%" 1>NUL
        if not !ERRORLEVEL!==0 set _EXITCODE=1
    ) else (
        echo %_ERROR_LABEL% MSBuild installation directory not found 1>&2
        set _EXITCODE=1
    )
    goto :eof
)
set "__SLN_FILE=%_PROJECT_DIR%\%_PROJECT_NAME%.sln"
if not exist "%__SLN_FILE%" (
    echo %_ERROR_LABEL% Solution file "%_PROJECT_NAME%.sln" not found 1>&2
    set _EXITCODE=1
    goto end
)
call :action_required "%__EXE_FILE%" "%__SLN_FILE%" "%_SOURCE_DIR%\*.cpp"
if %_ACTION_REQUIRED%==0 goto :eof

if %_DEBUG%==1 ( set __VERBOSITY_OPT=-verbosity:normal
) else ( set __VERBOSITY_OPT=-verbosity:quiet
)
set __MSBUILD_OPTS=-nologo %__VERBOSITY_OPT% "/p:OutputPath=%_OUTPUT_DIR%" "/p:TargetName=%_TARGET_NAME%"
set __MSBUILD_OPTS=%__MSBUILD_OPTS% "/p:Configuration=%_PROJECT_CONFIG%" "/p:Platform=%_PROJECT_PLATFORM%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_MSBUILD_CMD%" %__MSBUILD_OPTS% "%__SLN_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Generate executable "%_TARGET_NAME%.exe" 1>&2
)
call "%_MSBUILD_CMD%" %__MSBUILD_OPTS% "%__SLN_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate executable "%_TARGET_NAME%.exe" 1>&2
    set _EXITCODE=1
    goto end
)
goto :eof

@rem input parameter: 1=target file 2,3,..=path (wildcards accepted)
@rem output parameter: _ACTION_REQUIRED
:action_required
set "__TARGET_FILE=%~1"

set __PATH_ARRAY=
set __PATH_ARRAY1=
:action_path
shift
set __PATH=%~1
if not defined __PATH goto action_next
set __PATH_ARRAY=%__PATH_ARRAY%,'%__PATH%'
set __PATH_ARRAY1=%__PATH_ARRAY1%,'!__PATH:%_ROOT_DIR%=!'
goto action_path

:action_next
set __TARGET_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -path '%__TARGET_FILE%' -ea Stop | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
     set __TARGET_TIMESTAMP=%%i
)
set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse -path %__PATH_ARRAY:~1% -ea Stop | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S" 2^>NUL`) do (
    set __SOURCE_TIMESTAMP=%%i
)
call :newer %__SOURCE_TIMESTAMP% %__TARGET_TIMESTAMP%
set _ACTION_REQUIRED=%_NEWER%
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% %__TARGET_TIMESTAMP% Target : '%__TARGET_FILE%' 1>&2
    echo %_DEBUG_LABEL% %__SOURCE_TIMESTAMP% Sources: %__PATH_ARRAY:~1% 1>&2
    echo %_DEBUG_LABEL% _ACTION_REQUIRED=%_ACTION_REQUIRED% 1>&2
) else if %_VERBOSE%==1 if %_ACTION_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No action required ^(%__PATH_ARRAY1:~1%^) 1>&2
)
goto :eof

@rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __DATE1=%__TIMESTAMP1:~0,8%
set __TIME1=%__TIMESTAMP1:~-6%

set __DATE2=%__TIMESTAMP2:~0,8%
set __TIME2=%__TIMESTAMP2:~-6%

if %__DATE1% gtr %__DATE2% ( set _NEWER=1
) else if %__DATE1% lss %__DATE2% ( set _NEWER=0
) else if %__TIME1% gtr %__TIME2% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

:install
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy /y "%_OUTPUT_DIR%\*.exe" "%_INSTALL_DIR%" 1^>NUL 1>&2
) else if %_VERBOSE%==1 ( echo Copy executable "%_TARGET_NAME%.exe" to directory "%_INSTALL_DIR%" 1>&2
)
xcopy /y "%_OUTPUT_DIR%\*.exe" "%_INSTALL_DIR%" 1>NUL
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy executable "%_TARGET_NAME%.exe" to directory "%_INSTALL_DIR%" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_TIMER%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __TIMER_END=%%i
    call :duration "%_TIMER_START%" "!__TIMER_END!"
    echo Total execution time: !_DURATION! 1>&2
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
