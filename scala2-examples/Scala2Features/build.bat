@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging !
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
set "_RESOURCES_DIR=%_SOURCE_DIR%\resources"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_GEN_DIR=%_TARGET_DIR%\src_gen"

for %%i in ("%_ROOT_DIR%.") do set "_PROJECT_NAME=%%~ni"

set "_FRAGMENTS_FILE=%_GEN_DIR%\Fragments.wxs.txt"
set "_WIXOBJ_FILE=%_TARGET_DIR%\%_PROJECT_NAME%.wixobj"

@rem Architecture (candle): x86, x64, or ia64 (default: x86)
set _PRODUCT_ARCH=x64
set _PRODUCT_VERSION=2.13.7
set "_MSI_FILE=%_TARGET_DIR%\scala-%_PRODUCT_VERSION%.msi"

if not exist "%GIT_HOME%\mingw64\bin\curl.exe" (
    echo %_ERROR_LABEL% Git installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CURL_CMD=%GIT_HOME%\mingw64\bin\curl.exe"
set "_UNZIP_CMD=%GIT_HOME%\usr\bin\unzip.exe"

if not exist "%MAGICK_HOME%\convert.exe" (
    echo %_ERROR_LABEL% ImageMagick installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CONVERT_CMD=%MAGICK_HOME%\convert.exe"

if not exist "%WIX%\candle.exe" (
    echo %_ERROR_LABEL% WiX installation directory not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CANDLE_CMD=%WIX%\candle.exe"
set "_HEAT_CMD=%WIX%\heat.exe"
set "_LIGHT_CMD=%WIX%\light.exe"

if not exist "%WINDIR%\System32\msiexec.exe" (
    echo %_ERROR_LABEL% Microsoft Windows installer not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_MSIEXEC_CMD=%WINDIR%\System32\msiexec.exe"
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
    @rem PRODUCT_CODE UPGRADE_CODE MAIN_EXECUTABLE PROGRAM_MENU_DIR
    if defined __PRODUCT_CODE set "_GUID[PRODUCT_CODE]=!__PRODUCT_CODE!"
    if defined __UPGRADE_CODE set "_GUID[UPGRADE_CODE]=!__UPGRADE_CODE!"
    if defined __MAIN_EXECUTABLE set "_GUID[MAIN_EXECUTABLE]=!__MAIN_EXECUTABLE!"
    if defined __PROGRAM_MENU_DIR set "_GUID[PROGRAM_MENU_DIR]=!__PROGRAM_MENU_DIR!"
    if defined __APPLICATION_DOC set "_GUID[APPLICATION_DOC]=!__APPLICATION_DOC!"
    if defined __APPLICATION_ENV set "_GUID[APPLICATION_ENV]=!__APPLICATION_ENV!"
    if defined __APPLICATION_SHORTCUT set "_GUID[APPLICATION_SHORTCUT]=!__APPLICATION_SHORTCUT!"
    @rem pack\ directory
    if defined __LICENSE set "_GUID[LICENSE]=!__LICENSE!"
    if defined __NOTICE set "_GUID[NOTICE]=!__NOTICE!"
    @rem pack\bin\ directory
    if defined __FSC_BAT set "_GUID[FSC_BAT]=!__FSC_BAT!"
    if defined __FSC_SH set "_GUID[FSC_SH]=!__FSC_SH!"
    if defined __REPL_BAT set "_GUID[REPL_BAT]=!__REPL_BAT!"
    if defined __SCALA_BAT set "_GUID[SCALA_BAT]=!__SCALA_BAT!"
    if defined __SCALA_SH set "_GUID[SCALA_SH]=!__SCALA_SH!"
    if defined __SCALAC_BAT set "_GUID[SCALAC_BAT]=!__SCALAC_BAT!"
    if defined __SCALAC_SH set "_GUID[SCALAC_SH]=!__SCALAC_SH!"
    if defined __SCALADOC_BAT set "_GUID[SCALADOC_BAT]=!__SCALADOC_BAT!"
    if defined __SCALADOC_SH set "_GUID[SCALADOC_SH]=!__SCALADOC_SH!"
    if defined __SCALAP_BAT set "_GUID[SCALAP_BAT]=!__SCALAP_BAT!"
    if defined __SCALAP_SH set "_GUID[SCALAP_SH]=!__SCALAP_SH!"
    @rem pack\doc\ directory
    if defined __DOC_LICENSE_MD set "_GUID[DOC_LICENSE_MD]=!__DOC_LICENSE_MD!"
    if defined __DOC_LICENSE_RTF set "_GUID[DOC_LICENSE_RTF]=!__DOC_LICENSE_RTF!"
    if defined __DOC_README set "_GUID[DOC_README]=!__DOC_README!"
    if defined __DOC_TASTYREAD_MD set "_GUID[DOC_TASTYREAD_MD]=!__DOC_TASTYREAD_MD!"
    if defined __DOC_JNA_TXT set "_GUID[DOC_JNA_TXT]=!__DOC_JNA_TXT!"
    if defined __DOC_ASM_TXT set "_GUID[DOC_ASM_TXT]=!__DOC_ASM_TXT!"
    if defined __DOC_JLINE_TXT set "_GUID[DOC_JLINE_TXT]=!__DOC_JLINE_TXT!"
    if defined __DOC_JQUERY_TXT set "_GUID[DOC_JQUERY_TXT]=!__DOC_JQUERY_TXT!"
    if defined __DOC_FSC_HTML set "_GUID[DOC_FSC_HTML]=!__DOC_FSC_HTML!"
    if defined __DOC_INDEX_HTML set "_GUID[DOC_INDEX_HTML]=!__DOC_INDEX_HTML!"
    if defined __DOC_SCALA_HTML set "_GUID[DOC_SCALA_HTML]=!__DOC_SCALA_HTML!"
    if defined __DOC_SCALAC_HTML set "_GUID[DOC_SCALAC_HTML]=!__DOC_SCALAC_HTML!"
    if defined __DOC_SCALADOC_HTML set "_GUID[DOC_SCALADOC_HTML]=!__DOC_SCALADOC_HTML!"
    if defined __DOC_SCALAP_HTML set "_GUID[DOC_SCALAP_HTML]=!__DOC_SCALAP_HTML!"
    if defined __DOC_STYLE_CSS set "_GUID[DOC_STYLE_CSS]=!__DOC_STYLE_CSS!"
    if defined __DOC_EXTERNAL_GIF set "_GUID[DOC_EXTERNAL_GIF]=!__DOC_EXTERNAL_GIF!"
    if defined __DOC_SCALA_LOGO_PNG set "_GUID[DOC_SCALA_LOGO_PNG]=!__DOC_SCALA_LOGO_PNG!"
    @rem pack\lib\ directory
    if defined __JLINE_JAR set "_GUID[JLINE_JAR]=!__JLINE_JAR!"
    if defined __JNA_JAR set "_GUID[JNA_JAR]=!__JNA_JAR!"
    if defined __SCALA_COMPILER_JAR set "_GUID[SCALA_COMPILER_JAR]=!__SCALA_COMPILER_JAR!"
    if defined __SCALA_LIBRARY_JAR set "_GUID[SCALA_LIBRARY_JAR]=!__SCALA_LIBRARY_JAR!"
    if defined __SCALA_REFLECT_JAR set "_GUID[SCALA_REFLECT_JAR]=!__SCALA_REFLECT_JAR!"
    if defined __SCALAP_JAR set "_GUID[SCALAP_JAR]=!__SCALAP_JAR!"
    @rem pack\man\ directory
    if defined __FSC_MAN set "_GUID[FSC_MAN]=!__FSC_MAN!"
    if defined __SCALA_MAN set "_GUID[SCALA_MAN]=!__SCALA_MAN!"
    if defined __SCALAC_MAN set "_GUID[SCALAC_MAN]=!__SCALAC_MAN!"
    if defined __SCALADOC_MAN set "_GUID[SCALADOC_MAN]=!__SCALADOC_MAN!"
    if defined __SCALAP_MAN set "_GUID[SCALAP_MAN]=!__SCALAP_MAN!"
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
    echo %_DEBUG_LABEL% Variables  : "GIT_HOME=%GIT_HOME%" 1>&2
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

@rem output parameters: _JLINE_VERSION, _JNA_VERSION, _SCALAP_VERSION
@rem NB. we unset variable _PRODUCT_VERSION if download fails
:gen_app
set _JLINE_VERSION=
set _JNA_VERSION=
set _SCALAP_VERSION=

if not exist "%_APP_DIR%\" mkdir "%_APP_DIR%"

if not exist "%_APP_DIR%\LICENSE" (
    @rem we download version %__RELEASE% if product is not yet present in %_APP_DIR%
    set "__RELEASE=%_PRODUCT_VERSION%"
    set _PRODUCT_VERSION=

    set "__ARCHIVE_FILE=scala-!__RELEASE!.zip"
    set "__ARCHIVE_URL=https://downloads.lightbend.com/scala/!__RELEASE!/!__ARCHIVE_FILE!"
    set "__OUTPUT_FILE=%TEMP%\!__ARCHIVE_FILE!"

    if not exist "!__OUTFILE_FILE!" (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" --silent --user-agent "Mozilla 5.0" -L --url "!__ARCHIVE_URL!" ^> "!__OUTPUT_FILE!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download zip archive file "!__ARCHIVE_FILE!" 1>&2
        )
        call "%_CURL_CMD%" --silent --user-agent "Mozilla 5.0" -L --url "!__ARCHIVE_URL!" > "!__OUTPUT_FILE!"
        if not !ERRORLEVEL!==0 (
            echo.
            echo %_ERROR_LABEL% Failed to download file "!__JAR_FILE!" 1>&2
            set _EXITCODE=1
            goto :eof
        )
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_UNZIP_CMD%" -o "!__OUTPUT_FILE!" -d "%TEMP%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Extract zip archive to directory "%TEMP%" 1>&2
    )
    call "%_UNZIP_CMD%" -o "!__OUTPUT_FILE!" -d "%TEMP%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to extract zip archive to directory "%TEMP%" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy /s /y "%TEMP%\scala-!__RELEASE!\*" "%_APP_DIR%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Copy application files to directory "!_APP_DIR:%_ROOT_DIR%=!" 1>&2
    )
    xcopy /s /y "%TEMP%\scala-!__RELEASE!\*" "%_APP_DIR%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to copy application files to directory "!_APP_DIR:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set "_PRODUCT_VERSION=!__RELEASE!"
)
@rem https://downloads.lightbend.com/scala/2.13.7/scala-docs-2.13.7.zip
if not defined _PRODUCT_VERSION (
    echo %_ERROR_LABEL% Product version is undefined 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=^- tokens=1,*" %%i in ('dir /b "%_APP_DIR%\lib\jline-3*.jar"') do (
    set "__STR=%%j"
    set "_JLINE_VERSION=!__STR:.jar=!"
)
if not defined _JLINE_VERSION (
    echo %_ERROR_LABEL% JLine version number not found in directory "!_APP_DIR:%_ROOT_DIR%=!\lib" 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=^- tokens=1,*" %%i in ('dir /b "%_APP_DIR%\lib\jna-5*.jar"') do (
    set "__STR=%%j"
    set "_JNA_VERSION=!__STR:.jar=!"
)
if not defined _JNA_VERSION (
    echo %_ERROR_LABEL% JNA version number not found in directory "!_APP_DIR:%_ROOT_DIR%=!\lib" 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "delims=^- tokens=1,*" %%i in ('dir /b "%_APP_DIR%\lib\scalap-2*.jar"') do (
    set "__STR=%%j"
    set "_SCALAP_VERSION=!__STR:.jar=!"
)
if not defined _SCALAP_VERSION (
    echo %_ERROR_LABEL% Scalap version number not found in directory "!_APP_DIR:%_ROOT_DIR%=!\lib" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:gen_src
if not exist "%_GEN_DIR%" mkdir "%_GEN_DIR%"

@rem https://wixtoolset.org/documentation/manual/v3/overview/heat.html
set __HEAT_OPTS=-nologo -indent 2 -cg PackFiles -suid -sfrag -out "%_FRAGMENTS_FILE%"
if %_VERBOSE%==1 set __HEAT_OPTS=%__HEAT_OPTS% -v

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_HEAT_CMD%" dir "%_APP_DIR%" %__HEAT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate auxiliary WXS file "!_FRAGMENTS_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_HEAT_CMD%" dir "%_APP_DIR%" %__HEAT_OPTS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate auxilary WXS file "!_FRAGMENTS_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
set __WIX_IDS=PRODUCT_CODE UPGRADE_CODE MAIN_EXECUTABLE PROGRAM_MENU_DIR
set __WIX_IDS=%__WIX_IDS% APPLICATION_DOC APPLICATION_ENV APPLICATION_SHORTCUT

set __APP_IDS=LICENSE NOTICE FSC_BAT FSC_SH REPL_BAT SCALA_BAT SCALA_SH SCALAC_BAT SCALAC_SH
set __APP_IDS=%__APP_IDS% SCALADOC_BAT SCALADOC_SH SCALAP_BAT SCALAP_SH
set __APP_IDS=%__APP_IDS% DOC_LICENSE_MD DOC_LICENSE_RTF DOC_README DOC_TASTYREAD_MD
set __APP_IDS=%__APP_IDS% DOC_JNA_TXT DOC_ASM_TXT DOC_JLINE_TXT DOC_JQUERY_TXT
set __APP_IDS=%__APP_IDS% DOC_FSC_HTML DOC_INDEX_HTML DOC_SCALA_HTML DOC_SCALAC_HTML DOC_SCALADOC_HTML
set __APP_IDS=%__APP_IDS% DOC_SCALAP_HTML DOC_STYLE_CSS DOC_EXTERNAL_GIF DOC_SCALA_LOGO_PNG
set __APP_IDS=%__APP_IDS% JLINE_JAR JNA_JAR SCALA_COMPILER_JAR SCALA_LIBRARY_JAR
set __APP_IDS=%__APP_IDS% SCALA_REFLECT_JAR SCALAP_JAR
set __APP_IDS=%__APP_IDS% FSC_MAN SCALA_MAN SCALAC_MAN SCALADOC_MAN SCALAP_MAN

@rem We replace both version and GUID placeholders found in .wx? files
@rem and save the updated .wx? files into directory _GEN_DIR
set __REPLACE_PAIRS=-replace '\$PRODUCT_VERSION', '%_PRODUCT_VERSION%'
set __REPLACE_PAIRS=%__REPLACE_PAIRS% -replace '\$JLINE_VERSION', '%_JLINE_VERSION%'
set __REPLACE_PAIRS=%__REPLACE_PAIRS% -replace '\$JNA_VERSION', '%_JNA_VERSION%'
set __REPLACE_PAIRS=%__REPLACE_PAIRS% -replace '\$SCALAP_VERSION', '%_SCALAP_VERSION%'
for %%i in (%__WIX_IDS% %__APP_IDS%) do (
    if defined _GUID[%%i] ( set "__GUID=!_GUID[%%i]!"
    ) else (
        for /f %%u in ('powershell -C "(New-Guid).Guid"') do set "__GUID=%%u"
        echo %%i=!__GUID!>> "%_ROOT_DIR%\build.properties"
    )
    @rem if %_DEBUG%==1 echo %_DEBUG_LABEL% %%i=!__GUID! 1>&2
    set __REPLACE_PAIRS=!__REPLACE_PAIRS! -replace 'YOURGUID-%%i', '!__GUID!' 
)
@rem replace GUID placeholders found in .wx? files by their GUID values
for /f %%f in ('dir /s /b "%_SOURCE_DIR%\*.wx?" 2^>NUL') do (
    set "__INFILE=%%f"
    for %%g in (%%f) do set "__OUTFILE=%_GEN_DIR%\%%~nxg"
    for /f "usebackq" %%i in (`powershell -C "(Get-Content '!__INFILE!') %__REPLACE_PAIRS% ^| Out-File -encoding ASCII '!__OUTFILE!'"`) do (
       @rem noop
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy /i /q /y "%_RESOURCES_DIR%" "%_TARGET_DIR%\resources" 1>&2
) else if %_VERBOSE%==1 ( echo Copy resource files to directory "!_TARGET_DIR:%_ROOT_DIR%=!\resources" 1>&2
)
xcopy /i /q /y "%_RESOURCES_DIR%" "%_TARGET_DIR%\resources" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to copy resource files to directory "!_TARGET_DIR:%_ROOT_DIR%=!\resources" 1>&2
    set _EXITCODE=1
    goto :eof
)
call :gen_banner
if not %_EXITCODE%==0 goto :eof

call :gen_dialog
if not %_EXITCODE%==0 goto :eof

@rem call :gen_license
@rem if not %_EXITCODE%==0 goto :eof
goto :eof

@rem top banner image has a size of 493x58
:gen_banner
set "__LOGO_FILE=%_RESOURCES_DIR%\logo.svg"

set "__INFILE=%_RESOURCES_DIR%\BannerTop.bmp"
set "__TMPFILE=%TEMP%\BannerTop.bmp"
set "__OUTFILE=%_TARGET_DIR%\resources\BannerTop.bmp"

if exist "%__INFILE%" (
    @rem no need to create initial banner image
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% copy /y "%__INFILE%" "%__TMPFILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Use banner image found in directory "!_RESOURCES_DIR:%_ROOT_DIR%=!" 1>&2
    )
    copy /y "%__INFILE%" "%__TMPFILE%" %_STDOUT_REDIRECT%
) else (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CONVERT_CMD%" -size 493x58 "%__TMPFILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Create the top banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    )
    call "%_CONVERT_CMD%" -size 493x58 "%__TMPFILE%"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to create the top banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CONVERT_CMD%" "%__TMPFILE%" "%__LOGO_FILE%" ... 1>&2
) else if %_VERBOSE%==1 ( echo Add logo to the top banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
)
call "%_CONVERT_CMD%" "%__TMPFILE%" ^( "%__LOGO_FILE%" -resize 28 -transparent "#ffffff" ^) -gravity NorthEast -geometry +18+6 -compose over -composite "%__OUTFILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to add logo to the top banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem dialog background image has a size of 493x312
:gen_dialog
set "__INFILE=%_RESOURCES_DIR%\Dialog.bmp"
set "__LOGO_FILE=%_RESOURCES_DIR%\logo.svg"
set "__OUTFILE=%_TARGET_DIR%\resources\Dialog.bmp"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CONVERT_CMD%" "%__INFILE%" "%__LOGO_FILE%" ... 1>&2
) else if %_VERBOSE%==1 ( echo Add logo to the dialog image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
)
call "%_CONVERT_CMD%" "%__INFILE%" ^( "%__LOGO_FILE%" -fuzz 6000 -transparent "#ffffff" -resize 40 ^) -gravity NorthWest -geometry +106+16 -composite "%__OUTFILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to add logo to the dialog image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
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
set __OPT_PROPERTIES="-dProduct_Version=%_PRODUCT_VERSION%"
echo %__OPT_VERBOSE% %__OPT_EXTENSIONS% %__OPT_PROPERTIES% "-I%_GEN_DIR:\=\\%" -arch %_PRODUCT_ARCH% -nologo -out "%_TARGET_DIR:\=\\%\\"> "%__OPTS_FILE%"

set "__SOURCES_FILE=%_TARGET_DIR%\candle_sources.txt"
if exist "%__SOURCES_FILE%" del "%__SOURCES_FILE%"
set __N=0
for /f %%f in ('dir /s /b "%_GEN_DIR%\*.wxs" 2^>NUL') do (
    echo %%f>> "%__SOURCES_FILE%"
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
@rem ensure directory "%_APP_DIR%" contains the Scala 2 distribution
call :gen_app
if not %_EXITCODE%==0 goto :eof

call :action_required "%_MSI_FILE%" "%_SOURCE_DIR%\*.wx?" "%_APP_DIR%\LICENSE"
if %_ACTION_REQUIRED%==0 goto :eof

call :gen_src
if not %_EXITCODE%==0 goto end

call :compile
if not %_EXITCODE%==0 goto end

set "__OPTS_FILE=%_TARGET_DIR%\light_opts.txt"

if %_DEBUG%==1 ( set __OPT_VERBOSE=-v
) else ( set __OPT_VERBOSE=
)
set __OPT_EXTENSIONS=-ext WixUIExtension
set __LIGHT_BINDINGS=-b "pack=%_APP_DIR%" -b "rsrc=%_TARGET_DIR%\resources"
echo %__OPT_VERBOSE% %__OPT_EXTENSIONS% -nologo -out "%_MSI_FILE:\=\\%" %__LIGHT_BINDINGS%> "%__OPTS_FILE%"

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
if %_VERBOSE%+%_DEBUG% gtr 0 (
    set "__PROGRAMS_DIR=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    set __APP_DIR=
    for /f "delims=" %%f in ('dir /ad /b /s "!__PROGRAMS_DIR!\Scala 2*" 2^>NUL') do set "__APP_DIR=%%f"
    if not defined __APP_DIR (
        echo %_ERROR_LABEL% Application shorcuts directory not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    dir /b /s "!__APP_DIR!" 1>&2
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
) else if %_VERBOSE%==1 ( echo Remove installation "!_MSI_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_MSIEXEC_CMD%" /x "%_MSI_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to remove installation "!_MSI_FILE:%_ROOT_DIR%=!" 1>&2
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
