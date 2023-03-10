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
@rem default product information
set _PRODUCT_SKU=OpenJDK
set _PRODUCT_MAJOR_VERSION=11
set _PRODUCT_MINOR_VERSION=0
set _PRODUCT_MAINTENANCE_VERSION=0
set _PRODUCT_PATCH_VERSION=0
set _PRODUCT_BUILD_NUMBER=28
set _PRODUCT_MSI_VERSION=
set _ARCH=x64
set _JVM=hotspot
set _PRODUCT_CATEGORY=jdk
set _SKIP_MSI_VALIDATION=
set _UPGRADE_CODE_SEED=
set _BUNDLE_ICEDTEAWEB=

@rem default vendor information
set "_VENDOR=Eclipse Adoptium"
set "_VENDOR_BRANDING=Eclipse Temurin"
set "_VENDOR_BRANDING_LOGO=$(var.SetupResourcesDir)\logo.ico"
set "_VENDOR_BRANDING_BANNER=$(var.SetupResourcesDir)\wix-banner.bmp"
set "_VENDOR_BRANDING_DIALOG=$(var.SetupResourcesDir)\wix-dialog.bmp"
set "_PRODUCT_HELP_LINK=https://github.com/adoptium/adoptium-support/issues/new/choose"
set "_PRODUCT_SUPPORT_LINK=https://adoptium.net/support.html"
set "_PRODUCT_UPDATE_INFO_LINK=https://adoptium.net/releases.html"

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
    @rem _PRODUCT_ID is defined in file %_PRODUCT_SKU%-X.Y.Z.txt as it depends on X.Y.Z
    if defined __PRODUCT_SKU set "_PRODUCT_SKU=!__PRODUCT_SKU!"
    if defined __PRODUCT_UPGRADE_CODE set "_PRODUCT_UPGRADE_CODE=!__PRODUCT_UPGRADE_CODE!"
    @rem product information
    if defined __PRODUCT_MAJOR_VERSION set "_PRODUCT_MAJOR_VERSION=!__PRODUCT_MAJOR_VERSION!"
    if defined __PRODUCT_MINOR_VERSION set "_PRODUCT_MINOR_VERSION=!__PRODUCT_MINOR_VERSION!"
    if defined __PRODUCT_MAINTENANCE_VERSION set "_PRODUCT_MAINTENANCE_VERSION=!__PRODUCT_MAINTENANCE_VERSION!"
    if defined __PRODUCT_PATCH_VERSION set "_PRODUCT_PATCH_VERSION=!__PRODUCT_PATCH_VERSION!"
    if defined __PRODUCT_BUILD_NUMBER set "_PRODUCT_BUILD_NUMBER=!__PRODUCT_BUILD_NUMBER!"
    if defined __PRODUCT_MSI_VERSION set "_PRODUCT_MSI_VERSION=!__PRODUCT_MSI_VERSION!"
    if defined __ARCH set "_ARCH=!__ARCH!"
    if defined __JVM set "_JVM=!__JVM!"
    if defined __PRODUCT_CATEGORY set "_PRODUCT_CATEGORY=!__PRODUCT_CATEGORY!"
    if defined __SKIP_MSI_VALIDATION set "_SKIP_MSI_VALIDATION=!__SKIP_MSI_VALIDATION!"
    if defined __UPGRADE_CODE_SEED set "_UPGRADE_CODE_SEED=!__UPGRADE_CODE_SEED!"
    if defined __BUNDLE_ICEDTEAWEB set "_BUNDLE_ICEDTEAWEB=!__BUNDLE_ICEDTEAWEB!"
    @rem vendor information
    if defined __VENDOR set "_VENDOR=!__VENDOR!"
    if defined __VENDOR_BRANDING set "_VENDOR_BRANDING=!__VENDOR_BRANDING!"
    if defined __VENDOR_BRANDING_LOGO set "_VENDOR_BRANDING_LOGO=!__VENDOR_BRANDING_LOGO!"
    if defined __VENDOR_BRANDING_BANNER set "_VENDOR_BRANDING_BANNER=!__VENDOR_BRANDING_BANNER!"
    if defined __VENDOR_BRANDING_DIALOG set "_VENDOR_BRANDING_DIALOG=!__VENDOR_BRANDING_DIALOG!"
    if defined __PRODUCT_HELP_LINK set "_PRODUCT_HELP_LINK=!__PRODUCT_HELP_LINK!"
    if defined __PRODUCT_SUPPORT_LINK set "_PRODUCT_SUPPORT_LINK=!__PRODUCT_SUPPORT_LINK!"
    if defined __PRODUCT_UPDATE_INFO_LINK set "_PRODUCT_UPDATE_INFO_LINK=!__PRODUCT_UPDATE_INFO_LINK!"
    @rem user-defined properties
    if defined __TIMESTAMP_SERVER set "_TIMESTAMP_SERVER=!__TIMESTAMP_SERVER!"
)
if not defined _PRODUCT_UPGRADE_CODE (
    echo %_ERROR_LABEL% Product upgrade code is undefined 1>&2
    set _EXITCODE=1
    goto :eof
)
@rem Postcondition: _ARCH = {x64, x86-32, arm64}
if not "%_ARCH%"=="x64" if not "%_ARCH%"=="x86-32" if not "%_ARCH%"=="arm64" (
    echo %_ERROR_LABEL% Invalid target architecture "%_ARCH%" ^(error 7^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not "%_JVM%"=="hotspot" if not "%_JVM%"=="openj9" if not "%_JVM%"=="dragonwell" (
    echo %_ERROR_LABEL% Invalid JVM variant "%_JVM%" ^(error 8^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not "%_PRODUCT_CATEGORY%"=="jdk" if not "%_PRODUCT_CATEGORY%"=="jre" (
    echo %_ERROR_LABEL% Invalid product category "%_PRODUCT_CATEGORY%" ^(error 9^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _PRODUCT_FULL_VERSION=%_PRODUCT_MAJOR_VERSION%.%_PRODUCT_MINOR_VERSION%.%_PRODUCT_MAINTENANCE_VERSION%.%_PRODUCT_BUILD_NUMBER%
IF %_PRODUCT_MAJOR_VERSION% geq 10 (
    @rem eg. directory => 11.0.13+8, file => 11.0.13_8
    set __VERSION=%_PRODUCT_MAJOR_VERSION%.%_PRODUCT_MINOR_VERSION%.%_PRODUCT_MAINTENANCE_VERSION%
    if defined _PRODUCT_BUILD_NUMBER (
        set _PRODUCT_SHORT_VERSION=!__VERSION!+%_PRODUCT_BUILD_NUMBER%
        set _PRODUCT_FILE_VERSION=!__VERSION!_%_PRODUCT_BUILD_NUMBER%
    ) else (
        set _PRODUCT_SHORT_VERSION=!__VERSION!
        set _PRODUCT_FILE_VERSION=!__VERSION!
    )
) else (
    @rem eg. directory => 8u312-b07, file => 8u312b07
    set _PRODUCT_SHORT_VERSION=%_PRODUCT_MAJOR_VERSION%u%_PRODUCT_MAINTENANCE_VERSION%-b%_PRODUCT_BUILD_NUMBER%
    set _PRODUCT_FILE_VERSION=%_PRODUCT_MAJOR_VERSION%u%_PRODUCT_MAINTENANCE_VERSION%b%_PRODUCT_BUILD_NUMBER%
)
@rem the MSI file version format is: <major>.<minor>.<build>.<update>
if not defined _PRODUCT_MSI_VERSION set "_PRODUCT_MSI_VERSION=%_PRODUCT_FULL_VERSION%
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
set "_PRODUCT_DIR=%_APP_DIR%\%_PRODUCT_SKU%-%_PRODUCT_FILE_VERSION%"
set "_RELEASE_FILE=%_PRODUCT_DIR%\release"

set "_GUIDS_FILE=%_APP_DIR%\%_PRODUCT_SKU%-%_PRODUCT_FILE_VERSION%.txt"
@rem associative array to store <name,guid> pairs
set _GUID=
if exist "%_GUIDS_FILE%" (
    for /f "delims=^= tokens=1,*" %%i in (%_GUIDS_FILE%) do (
        if not "%%j"=="" set "_GUID[%%i]=%%j"
    )
)
if not defined _GUID[PRODUCT_ID] (
    echo %_ERROR_LABEL% Product identified is undefined 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_PRODUCT_ID=%_GUID[PRODUCT_ID]%"

set "_FRAGMENTS_FILE=%_GEN_DIR%\Fragments.wxs"
set "_FRAGMENTS_CID_FILE=%_GEN_DIR%\Fragments-cid.txt"

@rem same baseame as zip file OpenJDK11U-jre_x64_windows_hotspot_11.0.13_8.zip
set "_MSI_FILE=%_TARGET_DIR%\%_PRODUCT_SKU%%_PRODUCT_MAJOR_VERSION%U-%_PRODUCT_CATEGORY%_%_ARCH%_windows_%_JVM%_%_PRODUCT_FILE_VERSION%.msi"

if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _TIMER=%_TIMER% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _CLEAN=%_CLEAN% _INSTALL=%_INSTALL% _LINK=%_LINK% _REMOVE=%_REMOVE% 1>&2
    echo %_DEBUG_LABEL% Variables  : "GIT_HOME=%GIT_HOME%" 1>&2
    echo %_DEBUG_LABEL% Variables  : "WIX=%WIX%" 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_CATEGORY=%_PRODUCT_CATEGORY% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_FILE_VERSION=%_PRODUCT_FILE_VERSION% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_FULL_VERSION=%_PRODUCT_FULL_VERSION% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_MSI_VERSION=%_PRODUCT_MSI_VERSION% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_SHORT_VERSION=%_PRODUCT_SHORT_VERSION% 1>&2
    echo %_DEBUG_LABEL% Variables  : _PRODUCT_SKU=%_PRODUCT_SKU% 1>&2
)
if %_TIMER%==1 for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TIMER_START=%%i
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

@rem ensure application files are ready for addition into the Windows installer
:gen_app
if exist "%_RELEASE_FILE%" goto :eof

@rem Java 8
@rem Corretto  : https://corretto.aws/downloads/resources/8.312.07.1/amazon-corretto-8.312.07.1-windows-x64-jdk.zip
@rem Liberica  : https://download.bell-sw.com/java/8u312+7/bellsoft-jdk8u312+7-windows-amd64.zip
@rem Temurin   : https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u312-b07/OpenJDK8U-jdk_x64_windows_hotspot_8u312b07.zip

@rem Java 11
@rem Corretto  : https://corretto.aws/downloads/resources/11.0.13.8.1/amazon-corretto-11.0.13.8.1-windows-x64-jdk.zip
@rem Dragonwell: https://github.com/alibaba/dragonwell11/releases/download/dragonwell-11.0.13.9_jdk-11.0.13-ga/Alibaba_Dragonwell_11.0.13.9_x64_windows.zip
@rem Liberica  : https://download.bell-sw.com/java/11.0.13+8/bellsoft-jdk11.0.13+8-windows-amd64.zip
@rem Microsoft : https://aka.ms/download-jdk/microsoft-jdk-11.0.13.8.1-windows-x64.zip
@rem Temurin   : https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.13%2B8/OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.zip

@rem Java 17
@rem Corretto  : https://corretto.aws/downloads/resources/17.0.1.12.1/amazon-corretto-17.0.1.12.1-windows-x64-jdk.zip
@rem Dragonwell: https://github.com/alibaba/dragonwell17/releases/download/dragonwell-17.0.1.0.1%2B12_jdk-17.0.1-ga/Alibaba_Dragonwell_17.0.1.0.1+12_x86_windows.zip
@rem Liberica  : https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-windows-amd64.zip
@rem Microsoft : https://aka.ms/download-jdk/microsoft-jdk-17.0.1.12.1-windows-x64.zip
@rem Temurin   : https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_windows_hotspot_17.0.1_12.zip

if not exist "%_RELEASE_FILE%" (
    set "__BASE_URL=https://github.com/adoptium/temurin%_PRODUCT_MAJOR_VERSION%-binaries/releases/download"
    if %_PRODUCT_MAJOR_VERSION% geq 10 ( set "__BASE_URL=!__BASE_URL!/%_PRODUCT_CATEGORY%-%_PRODUCT_SHORT_VERSION%"
    ) else ( set "__BASE_URL=!__BASE_URL!/%_PRODUCT_CATEGORY%%_PRODUCT_SHORT_VERSION%"
    )
    set _PRODUCT_VERSION=
    @rem e.g. OpenJDK8U-jdk_x64_windows_hotspot_8u312b07.zip
    @rem e.g. OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.zip
    set "__ARCHIVE_FILE=%_PRODUCT_SKU%%_PRODUCT_MAJOR_VERSION%U-%_PRODUCT_CATEGORY%_%_ARCH%_windows_%_JVM%_%_PRODUCT_FILE_VERSION%.zip"
    set "__ARCHIVE_URL=!__BASE_URL!/!__ARCHIVE_FILE!"
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
    set __XCOPY_OPTS=/i /s /y
    if %_DEBUG%==0 if %_VERBOSE%==0 set __XCOPY_OPTS=/q !__XCOPY_OPTS!

    set "__TEMP_DIR=%TEMP%\%_PRODUCT_CATEGORY%%_PRODUCT_SHORT_VERSION%!"
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy !__XCOPY_OPTS! "!__TEMP_DIR!\*" "%_PRODUCT_DIR%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Copy application files to directory "!_PRODUCT_DIR:%_ROOT_DIR%=!" 1>&2
    )
    xcopy !__XCOPY_OPTS! "!__TEMP_DIR!\*" "%_PRODUCT_DIR%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to copy application files to directory "!_PRODUCT_DIR:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set "_PRODUCT_VERSION=%_PRODUCT_SHORT_VERSION%"
)
goto :eof

:gen_src
if not exist "%_GEN_DIR%" mkdir "%_GEN_DIR%"

@rem https://wixtoolset.org/documentation/manual/v3/overview/heat.html
set __HEAT_OPTS=-nologo -indent 2 -cg AppFiles
set __HEAT_OPTS=%__HEAT_OPTS% -t "%_XSLT_FILE%"
set __HEAT_OPTS=%__HEAT_OPTS% -var var.pack -suid -sfrag -sreg -out "%_FRAGMENTS_FILE%"
if %_VERBOSE%==1 set __HEAT_OPTS=-v %__HEAT_OPTS%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_HEAT_CMD%" dir "%_APP_DIR%" %__HEAT_OPTS% 1>&2
) else if %_VERBOSE%==1 ( echo Generate auxiliary file "!_FRAGMENTS_FILE:%_ROOT_DIR%=!" 1>&2
)
call "%_HEAT_CMD%" dir "%_APP_DIR%" %__HEAT_OPTS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Failed to generate auxiliary file "!_FRAGMENTS_FILE:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
call :extract_components
if not %_EXITCODE%==0 goto :eof

set __REPLACE=
set __M=0
set __REPLACE[%__M%]=-replace '{vendor}', '%_VENDOR%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{vendor_branding}', '%_VENDOR_BRANDING%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{vendor_branding_banner}', '%_VENDOR_BRANDING_BANNER%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{vendor_branding_dialog}', '%_VENDOR_BRANDING_DIALOG%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{vendor_branding_logo}', '%_VENDOR_BRANDING_LOGO%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{product_help_link}', '%_PRODUCT_HELP_LINK%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{product_support_link}', '%_PRODUCT_SUPPORT_LINK%'
set /a __M+=1
set __REPLACE[%__M%]=-replace '{product_update_info_link}', '%_PRODUCT_UPDATE_INFO_LINK%'

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
set __XCOPY_OPTS=/i /s /y
if %_DEBUG%==0 if %_VERBOSE%==0 set __XCOPY_OPTS=/q !__XCOPY_OPTS!

@rem image files are handled separately (see :gen_banner)
for %%e in (ico rtf) do (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% xcopy %__XCOPY_OPTS% "%_RESOURCES_DIR%\*.%%e" "%_GEN_RESOURCES_DIR%" 1>&2
    ) else if %_VERBOSE%==1 ( echo Copy .%%e files to directory "!_GEN_RESOURCES_DIR:%_ROOT_DIR%=!" 1>&2
    )
    xcopy %__XCOPY_OPTS% "%_RESOURCES_DIR%\*.%%e" "%_GEN_RESOURCES_DIR%" %_STDOUT_REDIRECT%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Failed to copy .%%e files to directory "!_GEN_RESOURCES_DIR:%_ROOT_DIR%=!" 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
@rem call :gen_banner
@rem if not %_EXITCODE%==0 goto :eof

@rem call :gen_dialog
@rem if not %_EXITCODE%==0 goto :eof

@rem call :gen_license
@rem if not %_EXITCODE%==0 goto :eof

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

:compile
if not exist "%_TARGET_DIR%" mkdir "%_TARGET_DIR%"

set "__OPTS_FILE=%_TARGET_DIR%\candle_opts.txt"

set __CANDLE_OPTS=-nologo
if %_DEBUG%==1 set __CANDLE_OPTS=%__CANDLE_OPTS% -v
set __CANDLE_OPTS=%__CANDLE_OPTS% "-I%_GEN_DIR:\=\\%" -arch %_ARCH%
set __CANDLE_OPTS=%__CANDLE_OPTS% -ext wixUtilExtension
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dpack=%_APP_DIR%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dMSIProductVersion=%_PRODUCT_MSI_VERSION%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductVersionString=%_PRODUCT_SHORT_VERSION%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dJVM=%_JVM%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductMajorVersion=%_PRODUCT_MAJOR_VERSION%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductMinorVersion=%_PRODUCT_MINOR_VERSION%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductId=%_PRODUCT_ID%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dProductUpgradeCode=%_PRODUCT_UPGRADE_CODE%"
set __CANDLE_OPTS=%__CANDLE_OPTS% "-dSetupResourcesDir=%_RESOURCES_DIR%"
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
setlocal
@rem Includes.wxi and Main.wxs depend on the following environment variables
set "PLATFORM=%_ARCH%"
set "PRODUCT_CATEGORY=%_PRODUCT_CATEGORY%"
set "PRODUCT_MAJOR_VERSION=%_PRODUCT_MAJOR_VERSION%"
set "BUNDLE_ICEDTEAWEB=%_BUNDLE_ICEDTEAWEB%
call "%_CANDLE_CMD%" "@%__OPTS_FILE%" "@%__SOURCES_FILE%" %_STDOUT_REDIRECT%
if not %ERRORLEVEL%==0 (
    endlocal
    echo %_ERROR_LABEL% Failed to compile %__N_FILES% to directory "!_TARGET_DIR:%_ROOT_DIR%=!" 1>&2
    set _EXITCODE=1
    goto :eof
)
endlocal
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
@rem ensure directory "%_APP_DIR%" contains the OpenJDK distribution
call :gen_app
if not %_EXITCODE%==0 goto :eof

call :action_required "%_MSI_FILE%" "%_SOURCE_DIR%\*.wx?" "%_RELEASE_FILE%"
if %_ACTION_REQUIRED%==0 goto :eof

call :gen_src
if not %_EXITCODE%==0 goto :eof

call :compile
if not %_EXITCODE%==0 goto :eof

set "__OPTS_FILE=%_TARGET_DIR%\light_opts.txt"

set __LIGHT_OPTS=-nologo -sval
if %_DEBUG%==1 set __LIGHT_OPTS=%__LIGHT_OPTS% -v

set __CULTURE=en-us
set __LIGHT_OPTS=%__LIGHT_OPTS% "-cultures:%__CULTURE%"
for /f "delims=" %%f in ('dir /b /s "%_GEN_DIR%\*Base.%__CULTURE%.wxl" "%_GEN_DIR%\*%_JVM%.%__CULTURE%.wxl"') do (
    set __LIGHT_OPTS=!__LIGHT_OPTS! -loc "%%f"
)
set __LIGHT_OPTS=%__LIGHT_OPTS% -ext wixUIExtension -ext wixUtilExtension
echo %__LIGHT_OPTS% -out "%_MSI_FILE:\=\\%" %__LIGHT_BINDINGS%> "%__OPTS_FILE%"

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
set "__LOG_FILE=%_TARGET_DIR%\%PRODUCT_SKU%.log"

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
