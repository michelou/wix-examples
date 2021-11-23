# <span id="top">WiX Quick Reference</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;"><a href="https://wixtoolset.org/" rel="external"><img style="border:0;" src="./docs/wixtoolset.png" width="100" alt="Deno logo"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://wixtoolset.org/" rel="external">WiX</a> hints and tips.
  </td>
  </tr>
</table>

## `WixUI_InstallDir`-dialogs

The dialog strings must be localized. [WiX][wix_toolset] comes with 40 sets of loc strings; you specify them using the `-cultures` switch to `%WIX%\light.exe`.

## <span id="vars">Built-in Variables</span>

The [WiX Toolset][wix_toolset] engine provides many [built-in variables](https://wixtoolset.org/documentation/manual/v3/bundle/bundle_built_in_variables.html) to be used in [WiX][wix_toolset] source files. In particular, some of them are needed to target the runtime architecture (e.g. x86, x64, ia64) of the generated Windows installer.

For instance, the variables below are defined as follows for a 64-bit Windows operating system <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> ([CSIDL]=*"constant special item ID list"*) :

| WiX variable         | [CSIDL]                         | Path |
|:---------------------|:--------------------------------|:-----|
| CommonFilesFolder    | `CSIDL_PROGRAM_FILES_COMMONX86` | `C:\Program Files\Common Files` |
| CommonFiles64Folder  | `CSIDL_PROGRAM_FILES_COMMON`    | `C:\Program Files (x86)\Common Files` |
| ProgramFilesFolder   | `CSIDL_PROGRAM_FILESX86`        | `C:\Program Files (x86)` |
| ProgramFiles64Folder | `CSIDL_PROGRAM_FILES`           | `C:\Program Files` |
| SystemFolder         | `CSIDL_SYSTEMX86`               | `C:\Windows\System32` |
| System64Folder       | `CSIDL_SYSTEM`                  | `C:\Windows\SysWOW64` |

The [WiX][wix_toolset] developer has to take care of them when specifying the `candle` option `-arch <name>` :

<pre style="font-size:75%;">
<b>&gt; %WIX%\candle.exe --help</b>
Windows Installer XML Toolset Compiler version 3.11.2.4516
Copyright (c) .NET Foundation and contributors. All rights reserved.

 usage:  candle.exe [-?] [-nologo] [-out outputFile] sourceFile [sourceFile ...] [@responseFile]

   -arch      set architecture defaults for package, components, etc.
              values: x86, x64, or ia64 (default: x86)
[...]
</pre>

## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***Windows System Information*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
On the Windows prompt we call the command <a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic"><b><code>wmic</code></b></a> to display information about the installed Windows operating system :
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic">wmic</a> os get Caption, Version, BuildNumber, OSArchitecture</b>
BuildNumber  Caption                   OSArchitecture  Version
19042        Microsoft Windows 10 Pro  64-bit          10.0.19042
</pre>

  > **&#9755;** ***WMIC Deprecation***<br/><a href="https://docs.microsoft.com/en-us/windows/win32/wmisdk/wmic"><b><code>wmic</code></b></a> is deprecated since the <a href="https://en.wikipedia.org/wiki/Windows_10_version_history">Windows May 2021 Update</a> (21H1).

<p style="margin:0 0 1em 20px;">
Alternatively we get the same system information with the PowerShell cmdlet <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1"><b><code>Get-WmiObject</code></b></a>  :
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; powershell -c "<a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-wmiobject?view=powershell-5.1">Get-WmiObject</a> -ClassName <a href="https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem">Win32_OperatingSystem</a> | <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-5.1">Select</a> BuildNumber,Caption,Version,OSArchitecture"</b>
&nbsp;
BuildNumber Caption                  Version    OSArchitecture
----------- -------                  -------    --------------
19042       Microsoft Windows 10 Pro 10.0.19042 64-bit
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[csidl]: https://docs.microsoft.com/en-us/windows/win32/shell/csidl
[wix_toolset]: https://wixtoolset.org/
