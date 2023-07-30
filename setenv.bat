@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)
set _GIT_PATH=
set _SBT_PATH=
set _WIX_PATH=

call :winsdk
@rem optional (required in myexamples\myApp*)
@rem if not %_EXITCODE%==0 goto end

call :wix3
if not %_EXITCODE%==0 goto end

call :git
if not %_EXITCODE%==0 goto end

@rem required by sbt
call :java "temurin" 11
if not %_EXITCODE%==0 goto end

call :magick
if not %_EXITCODE%==0 goto end

call :sbt
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _BASENAME, _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
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

@rem input parameter: %*
@rem output parameters: _HELP, _VERBOSE
:args
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
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
call :drive_name "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options  : _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Variables: _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter: %1: path to be substituted
@rem output parameter: _DRIVE_NAME
:drive_name
set "__GIVEN_PATH=%~1"

@rem https://serverfault.com/questions/62578/how-to-get-a-list-of-drive-letters-on-a-system-through-a-windows-shell-bat-cmd
set __DRIVE_NAMES=F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:
for /f %%i in ('wmic logicaldisk get deviceid ^| findstr :') do (
    set "__DRIVE_NAMES=!__DRIVE_NAMES:%%i=!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(WMIC^) 1>&2
if not defined __DRIVE_NAMES (
    echo %_ERROR_LABEL% No more free drive name 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst') do (
    set "__SUBST_DRIVE=%%f"
    set "__SUBST_DRIVE=!__SUBST_DRIVE:~0,2!"
    set "__SUBST_PATH=%%h"
    if "!__SUBST_DRiVE!"=="!__GIVEN_PATH:~0,2!" (
        set _DRIVE_NAME=!__SUBST_DRIVE:~0,2!
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    ) else if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set "_DRIVE_NAME=!__SUBST_DRIVE!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        ) else if %_VERBOSE%==1 ( echo Select drive !_DRIVE_NAME! for which a substitution already exists 1>&2
        )
        goto :eof
    )
)
for /f "tokens=1,2,*" %%i in ('subst') do (
    set __USED=%%i
    call :drive_names "!__USED:~0,2!"
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% __DRIVE_NAMES=%__DRIVE_NAMES% ^(SUBST^) 1>&2

set "_DRIVE_NAME=!__DRIVE_NAMES:~0,2!"
if /i "%_DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%_DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign path "%__GIVEN_PATH%" to drive %_DRIVE_NAME% 1>&2
)
subst "%_DRIVE_NAME%" "%__GIVEN_PATH%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to assign drive %_DRIVE_NAME% to path 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=Used drive name
@rem output parameter: __DRIVE_NAMES
:drive_names
set "__USED_NAME=%~1"
set "__DRIVE_NAMES=!__DRIVE_NAMES:%__USED_NAME%=!"
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
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
echo     %__BEG_O%-debug%__END%      display commands executed by this script
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem output parameters: _WINSDK_HOME, _WINSDK_PATH
:winsdk
set _WINSDK_HOME=
set _WINSDK_PATH=

if not exist "%ProgramFiles(x86)%\Windows Kits\10\bin\10*" (
    echo "%_WARNING_LABEL% Windows Kits 10 installation not found 1>&2
    goto :eof
)
set "_WINSDK_HOME=%ProgramFiles(x86)%\Windows Kits\10"
for /f "delims=" %%f in ('dir /b "%_WINSDK_HOME%\bin\10*" 2^>NUL') do (
    set "__BIN_DIR=%_WINSDK_HOME%\bin\%%f"
)
set "_WINSDK_PATH=;%__BIN_DIR%\x86"
goto :eof

@rem output parameters: _WIX_HOME, _WIX_PATH
:wix3
set _WIX_HOME=

set __CANDLE_CMD=
for /f %%f in ('where candle.exe 2^>NUL') do set "__CANDLE_CMD=%%f"
if defined __CANDLE_CMD (
    for %%i in ("%__CANDLE_CMD%") do set "_WIX_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Candle executable found in PATH 1>&2
    goto :eof
) else if defined WIX (
    set "_WIX_HOME=%WIX%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable WIX 1>&2
) else (
    set "__PATH=C:\opt"
    for /f %%f in ('dir /ad /b "!__PATH!\Wix-3*" 2^>NUL') do set "_WIX_HOME=!__PATH!\%%f"
	if not defined _WIX_HOME (
        set "__PATH=%ProgramFiles(x86)%"
        for /f %%f in ('dir /ad /b "!__PATH!\NSIS*" 2^>NUL') do set "_WIX_HOME=!__PATH!\%%f"
    )
)
if not exist "%_WIX_HOME%\candle.exe" (
    echo %_ERROR_LABEL% Wix executable not found ^("%_WIX_HOME%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_WIX_PATH=%_WIX_HOME%"
goto :eof

@rem output parameter: _MAGICK_HOME
:magick
set _MAGICK_HOME=

set __MAGICK_CMD=
for /f %%f in ('where magick.exe 2^>NUL') do set "__MAGICK_CMD=%%f"
if defined __MAGICK_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of ImageMagick executable found in PATH 1>&2
    for /f "delims=" %%f in ("%__MAGICK_CMD%") do set "_MAGICK_HOME=%%~dpf"
) else if defined MAGICK_HOME (
    set "_MAGICK_HOME=%MAGICK_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable MAGICK_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\ImageMagick\" ( set "_MAGICK_HOME=!__PATH!\ImageMagick"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\ImageMagick-7*" 2^>NUL') do set "_MAGICK_HOME=!__PATH!\%%f"
        if not defined _MAGICK_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\ImageMagick-7*" 2^>NUL') do set "_MAGICK_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_MAGICK_HOME%\magick.exe" (
    echo %_ERROR_LABEL% ImageMagick executable not found ^(%_MAGICK_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=vendor %1^=required version
@rem output parameter: _JAVA_HOME (resp. JAVA11_HOME)
:java
set _JAVA_HOME=

set __VENDOR=%~1
set __VERSION=%~2
if not defined __VENDOR ( set __JDK_NAME=jdk-%__VERSION%
) else ( set __JDK_NAME=jdk-%__VENDOR%-%__VERSION%
)
set __JAVAC_CMD=
for /f %%f in ('where javac.exe 2^>NUL') do set "__JAVAC_CMD=%%f"
if defined __JAVAC_CMD (
    call :jdk_version "%__JAVAC_CMD%"
    if !_JDK_VERSION!==%__VERSION% (
        for %%i in ("%__JAVAC_CMD%") do set "__BIN_DIR=%%~dpi"
        for %%f in ("%__BIN_DIR%") do set "_JAVA_HOME=%%~dpf"
    ) else (
        echo %_ERROR_LABEL% Required JDK installation not found ^(%__JDK_NAME%^) 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
if defined JAVA_HOME (
    set "_JAVA_HOME=%JAVA_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable JAVA_HOME 1>&2
) else (
    set _PATH=C:\opt
    for /f "delims=" %%f in ('dir /ad /b "!_PATH!\%__JDK_NAME%*" 2^>NUL') do set "_JAVA_HOME=!_PATH!\%%f"
    if not defined _JAVA_HOME (
        set "_PATH=%ProgramFiles%\Java"
        for /f %%f in ('dir /ad /b "!_PATH!\%__JDK_NAME%*" 2^>NUL') do set "_JAVA_HOME=!_PATH!\%%f"
    )
    if defined _JAVA_HOME (
        if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Java SDK installation directory !_JAVA_HOME! 1>&2
    )
)
if not exist "%_JAVA_HOME%\bin\javac.exe" (
    echo %_ERROR_LABEL% Executable javac.exe not found ^(%_JAVA_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
call :jdk_version "%_JAVA_HOME%\bin\javac.exe"
set "_JAVA!_JDK_VERSION!_HOME=%_JAVA_HOME%"
goto :eof

@rem input parameter(s): %1=javac file path
@rem output parameter(s): _JDK_VERSION
:jdk_version
set "__JAVAC_CMD=%~1"
if not exist "%__JAVAC_CMD%" (
    echo %_ERROR_LABEL% Command javac.exe not found ^("%__JAVAC_CMD%"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set __JAVAC_VERSION=
for /f "usebackq tokens=1,*" %%i in (`"%__JAVAC_CMD%" -version 2^>^&1`) do set __JAVAC_VERSION=%%j
set "__PREFIX=%__JAVAC_VERSION:~0,2%"
@rem either 1.7, 1.8 or 11..18
if "%__PREFIX%"=="1." ( set _JDK_VERSION=%__JAVAC_VERSION:~2,1%
) else ( set _JDK_VERSION=%__PREFIX%
)
goto :eof

@rem output parameters: _SBT_HOME, _SBT_PATH
:sbt
set _SBT_HOME=
set _SBT_PATH=

set __SBT_CMD=
for /f %%f in ('where sbt.bat 2^>NUL') do set "__SBT_CMD=%%f"
if defined __SBT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of sbt executable found in PATH 1>&2
    @rem keep _SBT_PATH undefined since executable already in path
    goto :eof
) else if defined SBT_HOME (
    set "_SBT_HOME=%SBT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable SBT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\sbt\" ( set "_SBT_HOME=!__PATH!\sbt"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "_SBT_HOME=!__PATH!\%%f"
        if not defined _SBT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\sbt-1*" 2^>NUL') do set "_SBT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_SBT_HOME%\bin\sbt.bat" (
    echo %_ERROR_LABEL% sbt executable not found ^(%_SBT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_SBT_PATH=;%_SBT_HOME%\bin"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin;%_GIT_HOME%\mingw64\bin"
goto :eof

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set "__VERSIONS_LINE3=  "
set __WHERE_ARGS=
where /q "%WIX%:candle.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-6,*" %%i in ('"%WIX%\candle.exe"^|findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% candle %%o,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%WIX%:candle.exe"
)
where /q "%WIX%:light.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-6,*" %%i in ('"%WIX%\light.exe"^|findstr XML^|findstr version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% light %%o,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%WIX%:light.exe"
)
set __WINSDK_BIN_DIR=
for /f "delims=" %%f in ('where /r "%WINSDK_HOME%" msiinfo.exe^|findstr \x86') do set "__WINSDK_BIN_DIR=%%~dpf"
where /q "%__WINSDK_BIN_DIR%:msiinfo.exe"
if %ERRORLEVEL%==0 (
    @rem (!) printing the msiinfo version is tricky
    @rem (it requires a msi file as argument, using option '/?' fails)
    for /f "delims=" %%f in ('dir /b /s "%WINDIR%\installer\*.msi"') do (
        for /f "tokens=1,2,*" %%i in ('call "%__WINSDK_BIN_DIR%\msiinfo.exe" "%%f"^|findstr MsiInfo') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% msiinfo %%k,"
        goto end_for
    )
:end_for
    set __WHERE_ARGS=%__WHERE_ARGS% "%__WINSDK_BIN_DIR%:msiinfo.exe"
)
where /q "%__WINSDK_BIN_DIR%:uuidgen.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,4,*" %%i in ('"%__WINSDK_BIN_DIR%\uuidgen.exe" -v^|findstr UUID') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% uuidgen %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%__WINSDK_BIN_DIR%:uuidgen.exe"
)
where /q "%SBT_HOME%\bin:sbt.bat"
if %ERRORLEVEL%==0 (
    for /f "tokens=1-3,*" %%i in ('"%SBT_HOME%\bin\sbt.bat" --version ^| findstr script') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% sbt %%l,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%SBT_HOME%\bin:sbt.bat"
)
where /q "%MAGICK_HOME%:magick.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,3,*" %%i in ('call "%MAGICK_HOME%\magick.exe" --version^|findstr /b Version') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% magick %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%MAGICK_HOME%:magick.exe"
)
where /q "%GIT_HOME%\bin:git.exe"
if %ERRORLEVEL%==0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% git %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if %ERRORLEVEL%==0 (
   for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE3=%__VERSIONS_LINE3% diff %%l"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
echo Tool versions:
echo %__VERSIONS_LINE1%
echo %__VERSIONS_LINE2%
echo %__VERSIONS_LINE3%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
    echo Environment variables: 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined JAVA_HOME echo    "JAVA_HOME=%JAVA_HOME%" 1>&2
    if defined MAGICK_HOME echo    "MAGICK_HOME=%MAGICK_HOME%" 1>&2
    if defined SBT_HOME echo    "SBT_HOME=%SBT_HOME%" 1>&2
    if defined WINSDK_HOME echo    "WINSDK_HOME=%WINSDK_HOME%" 1>&2
    if defined WIX echo    "WIX=%WIX%" 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined JAVA_HOME set "JAVA_HOME=%_JAVA_HOME%"
        if not defined MAGICK_HOME set "MAGICK_HOME=%_MAGICK_HOME%"
        if not defined SBT_HOME set "SBT_HOME=%_SBT_HOME%"
        if not defined WINSDK_HOME set "WINSDK_HOME=%_WINSDK_HOME%"
        if not defined WIX set "WIX=%_WIX_HOME%"
        set "PATH=%PATH%%_SBT_PATH%%_WINSDK_PATH%%WIX_PATH%%_GIT_PATH%;%~dp0bin"
        call :print_env %_VERBOSE%
        if not "%CD:~0,2%"=="%_DRIVE_NAME%:" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME%: 1>&2
            cd /d %_DRIVE_NAME%:
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
