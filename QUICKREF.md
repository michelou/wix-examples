# <span id="top">WiX Toolset Quick Reference</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://wixtoolset.org/" rel="external"><img style="border:0;" src="./images/wixtoolset.png" width="100" alt="WiX toolset"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://wixtoolset.org/" rel="external">WiX</a> hints and tips.
  </td>
  </tr>
</table>

## <span id="dialogs">`WixUI_InstallDir`-dialogs</span>

The dialog strings must be localized. [WiX][wix_toolset] comes with 40 sets of loc strings; you specify them using the `-cultures` switch to `%WIX%\light.exe`.

## <span id="custom">WiX custom variables</span>

The [WiX Toolset][wix_toolset] engine supports 3 types of [custom variables](https://wixtoolset.org/documentation/manual/v3/overview/preprocessor.html) : 
- *Environment variables* : The syntax is `$(env.<var_name>)` where `<var_name>` is case-insensitive. For example, we write `$(env.APPDATA)` to retrieve the environment variable [`%APPDATA%`][windows_appdata].
- *System variables* : The syntax is `$(sys.<var_name>)`.<br/>**`CURRENTDIR`** - The current directory where the build process is running.<br/>**`SOURCEFILEPATH`** - the full path to the file being processed.<br/>**`SOURCEFILEDIR`** - the directory containing the file being processed.<br/>**`BUILDARCH`** - the platform this package is compiled for (Intel, x64, Intel64, ARM).
- *User-defined variables* : The user has two ways to defined them, either at the top of a WiX source file as `<?define MyVariable="Hello World" ?>` or from the command line using option `-d`, e.g. `candle -dMyVariable="Hello World" ...`.

## <span id="builtin">WiX built-in variables</span>

The [WiX Toolset][wix_toolset] engine provides many [built-in variables](https://wixtoolset.org/documentation/manual/v3/bundle/bundle_built_in_variables.html) to be used in [WiX][wix_toolset] source files. In particular, some of them are needed to target the runtime architecture (e.g. x86, x64, ia64) of the generated Windows installer.

For instance, the variables below are defined as follows for a 64-bit Windows operating system <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([CSIDL]=*"constant special item ID list"*) :

| WiX variable         | [CSIDL]                         | Path |
|:---------------------|:--------------------------------|:-----|
| CommonFilesFolder    | `CSIDL_PROGRAM_FILES_COMMONX86` | `C:\Program Files\Common Files` |
| CommonFiles64Folder  | `CSIDL_PROGRAM_FILES_COMMON`    | `C:\Program Files (x86)\Common Files` |
| ProgramFilesFolder   | `CSIDL_PROGRAM_FILESX86`        | `C:\Program Files (x86)` |
| ProgramFiles64Folder | `CSIDL_PROGRAM_FILES`           | `C:\Program Files` |
| SystemFolder         | `CSIDL_SYSTEMX86`               | `C:\Windows\System32` |
| System64Folder       | `CSIDL_SYSTEM`                  | `C:\Windows\SysWOW64` |

The [WiX][wix_toolset] developer has to take care of them when specifying the [`candle`][candle_cmd] option `-arch <name>` :

<pre style="font-size:75%;">
<b>&gt; %WIX%\<a href="https://wixtoolset.org/documentation/manual/v3/overview/candle.html">candle.exe</a> --help</b>
Windows Installer XML Toolset Compiler version 3.11.2.4516
Copyright (c) .NET Foundation and contributors. All rights reserved.

 usage:  candle.exe [-?] [-nologo] [-out outputFile] sourceFile [sourceFile ...] [@responseFile]

   -arch      set architecture defaults for package, components, etc.
              values: x86, x64, or ia64 (default: x86)
[...]
</pre>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Windows System Information*** [↩](#anchor_01)

<dl><dd>
On the Windows prompt we call the command <a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic"><b><code>wmic.exe</code></b></a> to display information about the installed Windows operating system :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic">wmic</a> os get BuildNumber, Caption, OSArchitecture, Version</b>
BuildNumber  Caption                   OSArchitecture  Version
19042        Microsoft Windows 10 Pro  64-bit          10.0.19042
</pre>

  > **&#9755;** ***WMIC Deprecation***<br/><a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic"><b><code>wmic.exe</code></b></a> is deprecated since the <a href="https://en.wikipedia.org/wiki/Windows_10_version_history">Windows May 2021 Update</a> (21H1).
</dd>
<dd">
Alternatively we get the same system information with the PowerShell cmdlet <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1"><b><code>Get-WmiObject</code></b></a>  :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1" rel="external">powershell</a> -c "<a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1">Get-WmiObject</a> -ClassName <a href="https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem">Win32_OperatingSystem</a> | <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-5.1">Select</a> BuildNumber,Caption,Version,OSArchitecture"</b>
&nbsp;
BuildNumber Caption                  Version    OSArchitecture
----------- -------                  -------    --------------
19042       Microsoft Windows 10 Pro 10.0.19042 64-bit
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/January 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[candle_cmd]: https://wixtoolset.org/documentation/manual/v3/overview/candle.html
[csidl]: https://docs.microsoft.com/en-us/windows/win32/shell/csidl
[windows_appdata]: https://docs.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables#variables-that-are-recognized-only-in-the-user-context
[wix_toolset]: https://wixtoolset.org/
