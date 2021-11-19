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

The [WiX Toolset][wix_toolset] engine provides many [built-in variables](https://wixtoolset.org/documentation/manual/v3/bundle/bundle_built_in_variables.html) to be used in WiX source files. In particular, some of them are needed to target the runtime architecture (e.g. x86, x64, ia64) of the generated Windows installer.

For instance, the variables below are defined as follows for a 64-bit Windows system ([CSIDL]=*"constant special item ID list"*) :

| WiX variable          | [CSIDL]                        |
|:----------------------|:--------------------------------|
| CommonFilesFolder     | `CSIDL_PROGRAM_FILES_COMMONX86` |
| CommonFiles64Folder   | `CSIDL_PROGRAM_FILES_COMMON`    |
| ProgramFilesFolder    | `CSIDL_PROGRAM_FILESX86`        |
| ProgramFiles64Folder  | `CSIDL_PROGRAM_FILES`           |
| SystemFolder          | `CSIDL_SYSTEMX86`&nbsp;*(on&nbsp;64-bit&nbsp;Windows)* |
| System64Folder        | `CSIDL_SYSTEm`  |

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

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[csidl]: https://docs.microsoft.com/en-us/windows/win32/shell/csidl
[wix_toolset]: https://wixtoolset.org/
