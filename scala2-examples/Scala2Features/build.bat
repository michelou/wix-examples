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

set "_SOURCE_DIR=%_ROOT_DIR%src"
set "_RESOURCES_DIR=%_SOURCE_DIR%\resources"
set "_TARGET_DIR=%_ROOT_DIR%target"
set "_GEN_DIR=%_TARGET_DIR%\src_gen"
set "_GEN_RESOURCES_DIR=%_GEN_DIR%\resources"

set "_XSLT_FILE=%_RESOURCES_DIR%\Fragments.xslt"

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

set _SIGNTOOL_CMD=
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" ( set __ARCH=x64
) else ( set __ARCH=x86
)
for /f "delims=" %%f in ('where /r "%WINSDK_HOME%\bin" signtool.exe^|findstr %__ARCH%') do set "_SIGNTOOL_CMD=%%f"
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
@rem Architecture (candle): x86, x64, or ia64 (default: x86)
set _ARCH=x64

set _PRODUCT_SKU=scala
set _PRODUCT_UPGRADE_CODE=
set _PRODUCT_VERSION=2.13.7

for /f %%i in ('powershell -c "Get-Date -format yyyy"') do set _COPYRIGHT_END_YEAR=%%i
set _COPYRIGHT_OWNER=EPFL

set "_TIMESTAMP_SERVER=http://timestamp.digicert.com"

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
    @rem WiX information
    @rem _PRODUCT_ID is defined in file app-guids-X.Y.Z.txt as it depends on X.Y.Z
    if defined __PRODUCT_SKU set "_PRODUCT_SKU=!__PRODUCT_SKU!"
    if defined __PRODUCT_UPGRADE_CODE set "_PRODUCT_UPGRADE_CODE=!__PRODUCT_UPGRADE_CODE!"
    @rem product information
    if defined __PRODUCT_VERSION set "_PRODUCT_VERSION=!__PRODUCT_VERSION!"
    if defined __PROGRAM_MENU_DIR set "_PROGRAM_MENU_DIR=!__PROGRAM_MENU_DIR!"
    if defined __APPLICATION_DOC set "_APPLICATION_DOC=!__APPLICATION_DOC!"
    if defined __APPLICATION_SCALA_HOME set "_APPLICATION_SCALA_HOME=!__APPLICATION_SCALA_HOME!"
    if defined __APPLICATION_SHORTCUTS set "_APPLICATION_SHORTCUTS=!__APPLICATION_SHORTCUTS!"
    if defined __APPLICATION_UPDATE_PATH set "_APPLICATION_UPDATE_PATH=!__APPLICATION_UPDATE_PATH!"
    if defined __DOCUMENTATION_SHORTCUTS set "_DOCUMENTATION_SHORTCUTS=!__DOCUMENTATION_SHORTCUTS!"
    @rem user-configurable batch variables
    if defined __COPYRIGHT_OWNER set "_COPYRIGHT_OWNER=!__COPYRIGHT_OWNER!"
    if defined __TIMESTAMP_SERVER set "_TIMESTAMP_SERVER=!__TIMESTAMP_SERVER!"
)
@rem _PRODUCT_UPGRADE_CODE is identical for ALL versions of the SAME product
if not defined _PRODUCT_UPGRADE_CODE (
    echo %_ERROR_LABEL% Product upgrade code is undefined ^("!__PROPS_FILE:%_ROOT_DIR%=!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem the MSI file version format is: <major>.<minor>.<build>.<update>
set __PS1_SCRIPT=$res^='%_PRODUCT_VERSION%' -match '^(?^<major^>\d^+^).^(?^<minor^>\d^+^).^(?^<build^>\d^+^)^(-RC^(?^<update^>\d^+^)^)?'; ^
$u=if($matches.update){$matches.update}else{'0'}; ^
$matches.major+'.'+$matches.minor+'.'+$matches.build+'.'+$u
set _PRODUCT_MSI_VERSION=
for /f "usebackq" %%v in (`powershell -c "%__PS1_SCRIPT%" 2^>NUL`) do set "_PRODUCT_MSI_VERSION=%%v"
if not defined _PRODUCT_MSI_VERSION (
    echo %_ERROR_LABEL% Failed to extract file version from "%_PRODUCT_VERSION%" 1>&2
    set _EXITCODE=1
    goto :eof
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

set "_APP_DIR=%_ROOT_DIR%app"
set "_PRODUCT_DIR=%_APP_DIR%\%_PRODUCT_SKU%-%_PRODUCT_VERSION%"
set "_LICENSE_FILE=%_PRODUCT_DIR%\LICENSE"

set "_GUIDS_FILE=%_APP_DIR%\%_PRODUCT_SKU%-%_PRODUCT_VERSION%.txt"
@rem _GUID is an associative array with GUID pairs <name,value>
set _GUID=
if exist "%_GUIDS_FILE%" (
    for /f "delims=^= tokens=1,*" %%i in (%_GUIDS_FILE%) do (
        if not "%%j"=="" set "_GUID[%%i]=%%j"
    )
)
if not defined _GUID[PRODUCT_ID] (
    echo %_ERROR_LABEL% Product identified is undefined ^("!_GUIDS_FILE:%_ROOT_DIR%=!"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_PRODUCT_ID=%_GUID[PRODUCT_ID]%"

set "_FRAGMENTS_FILE=%_GEN_DIR%\Fragments.wxs"
set "_FRAGMENTS_CID_FILE=%_GEN_DIR%\Fragments-cid.txt"

set "_API_DIR=%_TARGET_DIR%\%_PRODUCT_SKU%-%_PRODUCT_VERSION%\api"

@rem same basename as zip file scala-2.13.7.zip
set "_MSI_FILE=%_TARGET_DIR%\%_PRODUCT_SKU%-%_PRODUCT_VERSION%.msi"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _INSTALL=%_INSTALL% _LINK=%_LINK% _REMOVE=%_REMOVE% 1>&2
    echo %_DEBUG_LABEL% Variables  : "GIT_HOME=%GIT_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "WIX=%WIX%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_MSI_VERSION=%_PRODUCT_MSI_VERSION% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_SKU=%_PRODUCT_SKU% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_VERSION=%_PRODUCT_VERSION% 1>&2
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
echo     %__BEG_O%install%__END%      execute Windows installer %__BEG_O%%_PRODUCT_SKU%%__END%
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

@rem NB. we unset variable _PRODUCT_VERSION if download fails
:gen_app
if not exist "%_PRODUCT_DIR%\" mkdir "%_PRODUCT_DIR%"

if not exist "%_LICENSE_FILE%" (
    @rem we download version %__RELEASE% if product is not yet present in %_PRODUCT_DIR%
    set "__RELEASE=%_PRODUCT_VERSION%"
    set _PRODUCT_VERSION=

    set "__ARCHIVE_FILE=%_PRODUCT_SKU%-!__RELEASE!.zip"
    set "__ARCHIVE_URL=https://downloads.lightbend.com/scala/!__RELEASE!/!__ARCHIVE_FILE!"
    set "__OUTPUT_FILE=%TEMP%\!__ARCHIVE_FILE!"

    if not exist "!__OUTPUT_FILE!" (
        set __CURL_OPTS=--fail --silent --user-agent "Mozilla 5.0" -L --url "!__ARCHIVE_URL!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" !__CURL_OPTS! ^> "!__OUTPUT_FILE!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download zip archive file "!__ARCHIVE_FILE!" 1>&2
        )
        call "%_CURL_CMD%" !__CURL_OPTS! > "!__OUTPUT_FILE!"
        if not !ERRORLEVEL!==0 (
            if exist "!__OUTPUT_FILE!" del "!__OUTPUT_FILE!"
            echo.
            echo %_ERROR_LABEL% Failed to download file "!__ARCHIVE_URL!" 1>&2
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
    set "__TEMP_DIR=%TEMP%\%_PRODUCT_SKU%-!__RELEASE!"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy /s /y "!__TEMP_DIR!\*" "%_PRODUCT_DIR%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Copy application files to directory "!_PRODUCT_DIR:%_ROOT_DIR%=!" 1>&2
    )
    xcopy /s /y "!__TEMP_DIR!\*" "%_PRODUCT_DIR%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to copy application files to directory "!_PRODUCT_DIR:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set "_PRODUCT_VERSION=!__RELEASE!"
)
goto :eof

:gen_src
if not exist "%_GEN_DIR%" mkdir "%_GEN_DIR%"

call :gen_api
if not %_EXITCODE%==0 goto :eof

@rem https://wixtoolset.org/documentation/manual/v3/overview/heat.html
set __HEAT_OPTS=-nologo -indent 2 -cg PackFiles -dr ProgramFiles64Folder
set __HEAT_OPTS=%__HEAT_OPTS% -t "%_XSLT_FILE%"
set __HEAT_OPTS=%__HEAT_OPTS% -var var.pack -suid -sfrag -out "%_FRAGMENTS_FILE%"
if %_VERBOSE%==1 set __HEAT_OPTS=-v %__HEAT_OPTS%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_HEAT_CMD%" dir "%_PRODUCT_DIR%" %__HEAT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate auxiliary file "!_FRAGMENTS_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_HEAT_CMD%" dir "%_PRODUCT_DIR%" %__HEAT_OPTS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate auxiliary file "!_FRAGMENTS_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
call :extract_components
if not %_EXITCODE%==0 goto :eof

set __REPLACE=
set __M=-1
for /f %%i in (%_FRAGMENTS_CID_FILE%) do (
    if defined _GUID[%%i] ( set "__GUID=!_GUID[%%i]!"
    ) else (
        for /f %%u in ('powershell -C "(New-Guid).Guid"') do set "__GUID=%%u"
        echo %%i=!__GUID!>> "%_GUIDS_FILE%"
    )
    set /a __M+=1
    set __REPLACE[!__M!]=-replace 'Id="%%i" Guid="PUT-GUID-HERE"', 'Id="%%i" Guid="!__GUID!"'
)
set "__PS1_FILE=%_TARGET_DIR%\replace.ps1"
if exist "%__PS1_FILE%" del "%__PS1_FILE%"

@rem replace GUID placeholders found in .wx? files by their GUID values
set __N=0
for /f %%f in ('dir /s /b "%_SOURCE_DIR%\*.wx?" "%_GEN_DIR%\Fragments*.wx?" 2^>NUL') do (
    set "__VAR_IN=$in!__N!"
    set "__VAR_OUT=$out!__N!"
    echo !__VAR_IN!='%%f'>> "%__PS1_FILE%"
    for %%g in (%%f) do echo !__VAR_OUT!='%_GEN_DIR%\%%~nxg'>> "%__PS1_FILE%"
    echo ^(Get-Content -Raw -Encoding UTF8 !__VAR_IN!^) `>> "%__PS1_FILE%"
    for /l %%i in (0, 1, %__M%) do echo    !__REPLACE[%%i]! `>> "%__PS1_FILE%"
    echo    ^| Out-File -Encoding UTF8 !__VAR_OUT!>> "%__PS1_FILE%"
    echo.>> "%__PS1_FILE%"
    set /a __N+=1
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% powershell -nologo -file "%__PS1_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Execute PS1 script "!__PS1_FILE:%_ROOT_DIR%=!" 1>&2
)
powershell -nologo -file "%__PS1_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to execute PS1 script "!__PS1_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem image files are handled separately (see :gen_banner)
for %%e in (bat ico) do (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy /i /q /y "%_RESOURCES_DIR%\*.%%e" "%_GEN_RESOURCES_DIR%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Copy .%%e files to directory "!_GEN_RESOURCES_DIR:%_ROOT_DIR%=!" 1>&2
    )
    xcopy /i /q /y "%_RESOURCES_DIR%\*.%%e" "%_GEN_RESOURCES_DIR%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to copy .%%e files to directory "!_GEN_RESOURCES_DIR:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
call :gen_banner
if not %_EXITCODE%==0 goto :eof

call :gen_dialog
if not %_EXITCODE%==0 goto :eof

call :gen_license
if not %_EXITCODE%==0 goto :eof

goto :eof

@rem top banner image has a size of 493x58
:gen_banner
set "__LOGO_FILE=%_RESOURCES_DIR%\logo.svg"

set "__INFILE=%_RESOURCES_DIR%\BannerTop.bmp"
set "__TMPFILE=%TEMP%\BannerTop.bmp"
set "__OUTFILE=%_GEN_RESOURCES_DIR%\BannerTop.bmp"

if exist "%__INFILE%" (
    @rem no need to create initial banner image
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% copy /y "%__INFILE%" "%__TMPFILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Use banner image found in directory "!_RESOURCES_DIR:%_ROOT_DIR%=!" 1>&2
    )
    copy /y "%__INFILE%" "%__TMPFILE%" %_STDOUT_REDIRECT%
) else (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CONVERT_CMD%" -size 493x58 "%__TMPFILE%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Create banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    )
    call "%_CONVERT_CMD%" -size 493x58 "%__TMPFILE%"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to create banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CONVERT_CMD%" "%__TMPFILE%" "%__LOGO_FILE%" ... 1>&2
) else if %_VERBOSE%==1 ( echo Add logo to banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
)
call "%_CONVERT_CMD%" "%__TMPFILE%" ^( "%__LOGO_FILE%" -resize 28 -transparent "#ffffff" ^) -gravity NorthEast -geometry +18+6 -compose over -composite "%__OUTFILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to add logo to banner image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem dialog background image has a size of 493x312
:gen_dialog
set "__INFILE=%_RESOURCES_DIR%\Dialog.bmp"
set "__LOGO_FILE=%_RESOURCES_DIR%\logo.svg"
set "__OUTFILE=%_GEN_RESOURCES_DIR%\Dialog.bmp"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CONVERT_CMD%" "%__INFILE%" "%__LOGO_FILE%" ... 1>&2
) else if %_VERBOSE%==1 ( echo Add logo to dialog image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
)
call "%_CONVERT_CMD%" "%__INFILE%" ^( "%__LOGO_FILE%" -fuzz 6000 -transparent "#ffffff" -resize 40 ^) -gravity NorthWest -geometry +106+16 -composite "%__OUTFILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to add logo to dialog image "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:gen_license
set "__INFILE=%_RESOURCES_DIR%\License.rtf"
set "__OUTFILE=%_GEN_RESOURCES_DIR%\License.rtf"

set __REPLACE_PAIRS=-replace '\[yyyy\]', '%_COPYRIGHT_END_YEAR%'

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% ^(Get-Content -Raw -Encoding Ascii '%__INFILE%'^) %__REPLACE_PAIRS% 1>&2
) else if %_VERBOSE%==1 ( echo Set copyright information in file "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
)
powershell -C "(Get-Content -Raw -Encoding Ascii '%__INFILE%') %__REPLACE_PAIRS% | Out-File -Encoding Ascii '%__OUTFILE%'"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to set copyright information in file "!__OUTFILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:extract_components
if exist "%_FRAGMENTS_CID_FILE%" del "%_FRAGMENTS_CID_FILE%"

set __N=0
for /f "tokens=1,2,*" %%i in ('findstr /r /c:"<Component Id=\".*\" Guid=\"PUT-GUID-HERE\"" "%_FRAGMENTS_FILE%"') do (
    @rem example: Id="tzdb.dat"
    for /f "delims=^= tokens=1,*" %%x in ("%%j") do set "__COMPONENT_ID=%%~y"
    if defined __COMPONENT_ID (
        echo !__COMPONENT_ID!>> "%_FRAGMENTS_CID_FILE%"
        set /a __N+=1
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% Saved %__N% component identifiers to file "!_FRAGMENTS_CID_FILE:%_ROOT_DIR%=!" 1>&2
) else if %_VERBOSE%==1 ( echo Saved %__N% component identifiers to file "!_FRAGMENTS_CID_FILE:%_ROOT_DIR%=!" 1>&2
)
goto :eof

:gen_api
if not exist "%_API_DIR%\" mkdir "%_API_DIR%"

if not exist "%_API_DIR%\scala-library\index.html" (
    set "__RELEASE=%_PRODUCT_VERSION%"
    set _PRODUCT_VERSION=

    set "__ARCHIVE_FILE=%_PRODUCT_SKU%-docs-!__RELEASE!.zip"
    set "__ARCHIVE_URL=https://downloads.lightbend.com/scala/!__RELEASE!/!__ARCHIVE_FILE!"
    set "__OUTPUT_FILE=%TEMP%\!__ARCHIVE_FILE!"

    if not exist "!__OUTPUT_FILE!" (
        set __CURL_OPTS=--fail --silent --user-agent "Mozilla 5.0" -L --url "!__ARCHIVE_URL!"
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" !__CURL_OPTS! ^> "!__OUTPUT_FILE!" 1>&2
        ) else if %_VERBOSE%==1 ( echo Download zip archive file "!__ARCHIVE_FILE!" 1>&2
        )
        call "%_CURL_CMD%" !__CURL_OPTS! > "!__OUTPUT_FILE!"
        if not !ERRORLEVEL!==0 (
            if exist "!__OUTPUT_FILE!" del "!__OUTPUT_FILE!"
            echo.
            echo %_ERROR_LABEL% Failed to download file "!__ARCHIVE_URL!" 1>&2
            set _EXITCODE=1
            goto :eof
        )
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_UNZIP_CMD%" -o "!__OUTPUT_FILE!" -d "%_TARGET_DIR%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Extract zip archive to directory "%_TARGET_DIR%" 1>&2
    )
    call "%_UNZIP_CMD%" -o "!__OUTPUT_FILE!" -d "%_TARGET_DIR%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to extract zip archive to directory "%_TARGET_DIR%" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set "_PRODUCT_VERSION=!__RELEASE!"
)
call :action_required "%_GEN_DIR%\Scala2API.wxs" "%_API_DIR%\scala-library\index.html"
if %_ACTION_REQUIRED%==0 goto :eof

set __HEAT_OPTS=-nologo -indent 2 -cg APIFiles -dr INSTALLDIR
set __HEAT_OPTS=%__HEAT_OPTS% -gg -g1 sfrag -sreg -suid
set __HEAT_OPTS=%__HEAT_OPTS% -var var.api -out "%_GEN_DIR%\Scala2API.wxs"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_HEAT_CMD%" dir "%_API_DIR%" %__HEAT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate WiX source file for Scala 2 API documentation 1>&2
)
call "%_HEAT_CMD%" dir "%_API_DIR%" %__HEAT_OPTS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate WiX source file for Scala 2 API documentation 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

set "__OPTS_FILE=%_TARGET_DIR%\candle_opts.txt"

set __CANDLE_OPTS=-nologo
if %_DEBUG%==1 set __CANDLE_OPTS=%__CANDLE_OPTS% -v
set __CANDLE_OPTS=%__CANDLE_OPTS% "-I%_GEN_DIR:\=\\%" -arch %_ARCH%
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dpack=%_PRODUCT_DIR%" "-dapi=%_API_DIR%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductId=%_PRODUCT_ID%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductMsiVersion=%_PRODUCT_MSI_VERSION%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductUpgradeCode=%_PRODUCT_UPGRADE_CODE%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductVersion=%_PRODUCT_VERSION%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProgramMenuDir=%_PROGRAM_MENU_DIR%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dApplicationDoc=%_APPLICATION_DOC%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dApplicationScalaHome=%_APPLICATION_SCALA_HOME%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dApplicationShortcuts=%_APPLICATION_SHORTCUTS%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dApplicationUpdatePath=%_APPLICATION_UPDATE_PATH%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dDocumentationShortcuts=%_DOCUMENTATION_SHORTCUTS%"
echo %__CANDLE_OPTS% -out "%_TARGET_DIR:\=\\%\\"> "%__OPTS_FILE%"

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

@rem input parameter: %1=file path
:gen_checksums
set "__INPUT_FILE=%~1"

for %%i in (md5 sha256) do (
    set "__CHECK_FILE=%__INPUT_FILE%.%%i"
    powershell -c "$fh=Get-FileHash '%__INPUT_FILE%' -Algorithm %%i;$path=Get-Item $fh.Path;$fh.Hash+'  '+$path.Basename+$path.Extension" > "!__CHECK_FILE!"
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to generate file "!__CHECK_FILE:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

@rem input parameter: %1=file path
:sign_file
set "__TARGET_FILE=%~1"
set "__CERTS_DIR=%USERPROFILE%\Certificates"

set "__FPX_CERT_FILE=%__CERTS_DIR%\wix-examples.pfx"
if not exist "%__FPX_CERT_FILE%" (
    echo %_ERROR_LABEL% PFX certificate file not found ^("!__FPX_CERT_FILE:%USERPROFILE%\=!"^) 1>&2
    echo ^(put file wix-examples.pfx into directory "%%USERPROFILE%%\Certificates"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__PFX_PSWD_FILE=%__CERTS_DIR%\wix-examples.pfx.txt"
if not exist "%__PFX_PSWD_FILE%" (
    echo %_ERROR_LABEL% PFX password file not found ^("!__PFX_PSWD_FILE:%USERPROFILE%\=!"^) 1>&2
    echo ^(put password file wix-examples.pfx.txt into directory "%%USERPROFILE%%\Certificates"^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__CERT_LABEL=%_COPYRIGHT_OWNER%"

@rem DO NOT specify PFX password in variable __SIGN_OPTS (but separately) !!
set __SIGN_OPTS=/f "%__FPX_CERT_FILE%" /d "%__CERT_LABEL%" /t "%_TIMESTAMP_SERVER%" /fd SHA256
if %_DEBUG%==1 set __SIGN_OPTS=-v %__SIGN_OPTS%

@rem print dummy PFX password in console !
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_SIGNTOOL_CMD%" sign /p "XXXXXX" %__SIGN_OPTS% "%__TARGET_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Sign file "!__TARGET_FILE:%_ROOT_DIR%=!" 1>&2
)
set /p __PFX_PSWD=< "%__PFX_PSWD_FILE%"
call "%_SIGNTOOL_CMD%" sign /p "%__PFX_PSWD%" %__SIGN_OPTS% "%__TARGET_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to sign file "!__TARGET_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:link
@rem ensure directory "%_APP_DIR%" contains the Scala 2 distribution
call :gen_app
if not %_EXITCODE%==0 goto :eof

call :action_required "%_MSI_FILE%" "%_SOURCE_DIR%\*.wx?" "%_LICENSE_FILE%"
if %_ACTION_REQUIRED%==0 goto :eof

call :gen_src
if not %_EXITCODE%==0 goto :eof

call :compile
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\light_opts.txt"

set __LIGHT_OPTS=-nologo
if %_DEBUG%==1 set __LIGHT_OPTS=%__LIGHT_OPTS% -v
set __LIGHT_OPTS=%__LIGHT_OPTS% -ext WixUIExtension
set __LIGHT_OPTS=%__LIGHT_OPTS% -b "pack=%_PRODUCT_DIR%" -b "rsrc=%_GEN_RESOURCES_DIR%"
echo %__LIGHT_OPTS% -out "%_MSI_FILE:\=\\%"> "%__OPTS_FILE%"

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
    echo %_ERROR_LABEL% Failed to create Windows installer "!_MSI_FILE:%_ROOT_DIR%=!" ^(error %ERRORLEVEL%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if defined _SIGNTOOL_CMD (
    call :sign_file "%_MSI_FILE%"
    if not !_EXITCODE!==0 goto :eof
) else (
    echo %_WARNING_LABEL% signtool command not found; is Windows SDK 10 installed? 1>&2
)
call :gen_checksums "%_MSI_FILE%"
if not %_EXITCODE%==0 goto :eof
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
    @rem goto :eof
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
if not defined _PRODUCT_ID (
    echo %_ERROR_LABEL% Product identifier not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "__HKLM_UNINSTALL=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"

@rem if %_DEBUG%==1 ( echo %_DEBUG_LABEL% reg query "%__HKLM_UNINSTALL%"| findstr /I /C:"%_PRODUCT_ID%" 1>&2
@rem ) else if %_VERBOSE%==1 ( echo Check if product if already installed 1>&2
@rem )
@rem set __INSTALLED=0
@rem reg query "%__HKLM_UNINSTALL%" | findstr /I /C:"%_PRODUCT_ID%" && set __INSTALLED=1
@rem if %__INSTALLED%==0 (
@rem     echo %_WARNING_LABEL% Product "%_PRODUCT_SKU%" is not installed 1>&2
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
