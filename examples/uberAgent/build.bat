@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :props
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
if %_LINK%==1 (
    call :link
    if not !_EXITCODE!==0 goto end
)
if %_INSTALL%==1 (
    call :install
    if not !_EXITCODE!==0 goto end
)
if %_REMOVE%==1 (
    call :remove
    if not !_EXITCODE!==0 goto end
)
goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:

set "_APP_DIR=%_ROOT_DIR%app"
set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_GEN_DIR=%_TARGET_DIR%\src_gen"

for %%i in ("%_ROOT_DIR%.") do set "_PROJECT_NAME=%%~ni"
set "_MSI_FILE=%_TARGET_DIR%\%_PROJECT_NAME%.msi"

if not exist "%WIX%\candle.exe" (
    echo %_ERROR_LABEL% WiX installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CANDLE_CMD=%WIX%\candle.exe"
set "_LIGHT_CMD=%WIX%\light.exe"

set "_MSIEXEC_CMD=msiexec.exe"
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

:props
@rem associative array to store <name,guid> pairs
set _GUID=

set "__PROPS_FILE=%_ROOT_DIR%build.properties"
if exist "%__PROPS_FILE%" (
    for /f "tokens=1,* delims==" %%i in (%__PROPS_FILE%) do (
        set __NAME=
        set __VALUE=
        for /f "delims= " %%n in ("%%i") do set __NAME=%%n
        @rem line comments start with "#"
        if defined __NAME if not "!__NAME:~0,1!"=="#" (
            @rem trim value
            for /f "tokens=*" %%v in ("%%~j") do set __VALUE=%%v
            set "__!__NAME!=!__VALUE!"
        )
    )
    if defined __PRODUCT_CODE set "_GUID[PRODUCT_CODE]=!__PRODUCT_CODE!"
    if defined __UPGRADE_CODE set "_GUID[UPGRADE_CODE]=!__UPGRADE_CODE!"
    if defined __INSTALLDIR set "_GUID[INSTALLDIR]=!__INSTALLDIR!"
    if defined __EXE_FILE set "_GUID[EXE_FILE]=!__EXE_FILE!"
    if defined __CONFIGURATION_FILE set "_GUID[CONFIGURATION_FILE]=!__CONFIGURATION_FILE!"
    if defined __REG_VAL_INSTALLATION set "_GUID[REG_VAL_INSTALLATION]=!__REG_VAL_INSTALLATION!"
)
goto :eof

:args
set _CLEAN=0
set _HELP=0
set _INSTALL=0
set _LINK=0
set _REMOVE=0
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
    ) else if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="install" ( set _LINK=1& set _INSTALL=1
    ) else if "%__ARG%"=="link" ( set _LINK=1
    ) else if "%__ARG%"=="remove" ( set _REMOVE=1
    ) else if "%__ARG%"=="uninstall" ( set _REMOVE=1
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
set _STDOUT_REDIRECT=1^>NUL
if %_DEBUG%==1 set _STDOUT_REDIRECT=

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _INSTALL=%_INSTALL% _LINK=%_LINK% _REMOVE=%_REMOVE% 1>&2
    if defined GIT_HOME echo %_DEBUG_LABEL% Variables  : "GIT_HOME=%GIT_HOME%" 1>&2
	echo %_DEBUG_LABEL% Variables  : "WIX=%WIX%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _PROJECT_NAME=%_PROJECT_NAME% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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
echo     %__BEG_O%-debug%__END%       show commands executed by this script
echo     %__BEG_O%-timer%__END%       display total execution time
echo     %__BEG_O%-verbose%__END%     display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%clean%__END%        delete generated files
echo     %__BEG_O%help%__END%         display this help message
echo     %__BEG_O%install%__END%      execute Windows installer %__BEG_O%%_PROJECT_NAME%%__END%
echo     %__BEG_O%link%__END%         create Windows installer from WXS/WXI/WXL files
echo     %__BEG_O%remove%__END%       remove installed program ^(same as %__BEG_O%uninstall%__END%^)
echo     %__BEG_O%uninstall%__END%    remove installed program
goto :eof

:clean
call :rmdir "%_TARGET_DIR%"
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

:gen_app
set "__TARGET_FILE=%_APP_DIR%\uberAgent.exe"
if exist "%__TARGET_FILE%" goto :eof

if %_DEBUG%==1 echo %_DEBUG_LABEL% xcopy /y "%WINDIR%\System32\calc.exe" "%__TARGET_FILE%" 1>&2
echo F|xcopy /y "%WINDIR%\System32\calc.exe" "%__TARGET_FILE%"
if not !ERRORLEVEL!==0 (
	set _EXITCODE=1
	goto :eof
)
goto :eof

:gen_src
if not exist "%_GEN_DIR%" mkdir "%_GEN_DIR%"

set __REPLACE_PAIRS=
for %%i in (PRODUCT_CODE UPGRADE_CODE INSTALLDIR EXE_FILE CONFIGURATION_FILE REG_VAL_INSTALLATION) do (
    if defined _GUID[%%i] ( set "__GUID=!_GUID[%%i]!"
    ) else (
        for /f %%u in ('powershell -C "(New-Guid).Guid"') do set "__GUID=%%u"
        echo %%i=!__GUID!>> "%_ROOT_DIR%\build.properties"
    )
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% %%i=!__GUID! 1>&2
    set __REPLACE_PAIRS=!__REPLACE_PAIRS! -replace 'YOURGUID-%%i', '!__GUID!' 
)
for /f %%f in ('dir /s /b "%_SOURCE_DIR%\*.wx?" 2^>NUL') do (
    set "__INFILE=%%f"
    for %%g in (%%f) do set "__OUTFILE=%_GEN_DIR%\%%~nxg"
    for /f "usebackq" %%i in (`powershell -C "(Get-Content '!__INFILE!') %__REPLACE_PAIRS% ^| Out-File -encoding ASCII '!__OUTFILE!'"`) do (
       @rem noop
    )
)
goto :eof

:compile
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

set "__OPTS_FILE=%_TARGET_DIR%\candle_opts.txt"

if %_DEBUG%==1 ( set __OPT_VERBOSE=-v
) else ( set __OPT_VERBOSE=
)
@rem set __OPT_EXTENSIONS= -ext WiXUtilExtension
set __OPT_EXTENSIONS=
set __OPT_PROPERTIES="-dProjectDir=%_APP_DIR:\=\\%" "-dPlatform=x64"
echo %__OPT_VERBOSE% %__OPT_EXTENSIONS% -nologo -arch x64 -out "%_TARGET_DIR:\=\\%\\" %__OPT_PROPERTIES%> "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\candle_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%"
set __N=0
for /f %%f in ('dir /s /b "%_GEN_DIR%\*.wxs" 2^>NUL') do (
    echo %%f >> "%__SOURCES_FILE%"
    set /a __N+=1
)
if %__N%==0 (
    echo %_WARNING_LABEL% No WiX source file found 1>&2
    goto :eof
) else if %__N%==1 ( set __N_FILES=%__N% WiX source file
) else ( set __N_FILES=%__N% WiX source files
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CANDLE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compiling %__N_FILES% to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
)
call "%_CANDLE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:link
call :action_required "%_MSI_FILE%" "%_SOURCE_DIR%\*.wx?" "%_APP_DIR%\*.pdf"
if %_ACTION_REQUIRED%==0 goto :eof

call :gen_app
if not %_EXITCODE%==0 goto end

call :gen_src
if not %_EXITCODE%==0 goto end

call :compile
if not %_EXITCODE%==0 goto end

set "__OPTS_FILE=%_TARGET_DIR%\light_opts.txt"

if %_DEBUG%==1 ( set __OPT_VERBOSE=-v
) else ( set __OPT_VERBOSE=
)
set __OPT_LOCALIZED=
if exist "%_SOURCE_DIR%\*.wxl" (
    for /f "delims=" %%f in ('dir /b /s "%_SOURCE_DIR%\*.wxl"') do (
        set __OPT_LOCALIZED=-loc "%%f"
    )
)
set __OPT_EXTENSIONS=-ext WixUIExtension -ext WixUtilExtension
@rem set __LIGHT_BINDINGS= -b "exe=%_APP_DIR%" -b "dll=%_APP_DIR%" -b "pdf=%_APP_DIR%"
set __LIGHT_BINDINGS=-b "images=%_SOURCE_DIR%\images"
echo %__OPT_VERBOSE% %__OPT_LOCALIZED:\=\\% %__OPT_EXTENSIONS% -nologo -out "%_MSI_FILE:\=\\%" %__LIGHT_BINDINGS%> "%__OPTS_FILE%"

set __WIXOBJ_FILES=
set __N=0
for /f %%f in ('dir /s /b "%_TARGET_DIR%\*.wixobj" 2^>NUL') do (
    set __WIXOBJ_FILES=!__WIXOBJ_FILES! "%%f"
    set /a __N+=1
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_LIGHT_CMD%" "@%__OPTS_FILE%" %__WIXOBJ_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Create Windows installer "!_MSI_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_LIGHT_CMD%" "@%__OPTS_FILE%" %__WIXOBJ_FILES% %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo 1111111111111111 ERRORLEVEL=%ERRORLEVEL%
    echo %_ERROR_LABEL% Failed to create Windows installer "!_MSI_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
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
if not exist "%_MSI_FILE%" (
    echo %_ERROR_LABEL% Windows installer not found ^("!_MSI_FILE:%_ROOT_DIR%=!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__LOG_FILE=%_TARGET_DIR%\%_PROJECT_NAME%.log"

if %_DEBUG%==1 (echo %_DEBUG_LABEL% "%_MSIEXEC_CMD%" /i "%_MSI_FILE%" /l* "%__LOG_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Execute Windows installer "!_MSI_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_MSIEXEC_CMD%" /i "%_MSI_FILE%" /l* "%__LOG_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute Windows installer "!_MSI_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:remove
if not defined _GUID[PRODUCT_CODE] (
    echo %_ERROR_LABEL% Product code not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__HKLM_UNINSTALL=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
set "__PRODUCT_CODE=%_GUID[PRODUCT_CODE]%"

@rem if %_DEBUG%==1 ( echo %_DEBUG_LABEL% reg query "%__HKLM_UNINSTALL%"| findstr /I /C:"%__PRODUCT_CODE%" 1>&2
@rem ) else if %_VERBOSE%==1 ( echo Check if product if already installed 1>&2
@rem )
@rem set __INSTALLED=0
@rem reg query "%__HKLM_UNINSTALL%" | findstr /I /C:"%__PRODUCT_CODE%" && set __INSTALLED=1
@rem if %__INSTALLED%==0 (
@rem     echo %_WARNING_LABEL% Product "%_PROJECT_NAME%" is not installed 1>&2
@rem     goto :eof
@rem )
if %_DEBUG%==1 (echo %_DEBUG_LABEL% "%_MSIEXEC_CMD%" /x "%_MSI_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Remove installation 1>&2
)
call "%_MSIEXEC_CMD%" /x "%_MSI_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to remove installation 1>&2
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
