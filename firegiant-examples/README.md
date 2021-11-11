# <span id="top">Firegiant's code examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://www.firegiant.com/" rel="external"><img style="border:0;width:120px;" src="https://www.firegiant.com/assets/img/logo_firegiant.png" alt="Firegiant Company" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>firegiant-examples\</code></strong> contains <a href="https://wixtoolset.org/" rel="external">WiX</a> code examples coming from Firegiant's online <a href="https://www.firegiant.com/wix/tutorial/" rel="external">WiX Toolset Tutorial</a>.
  </td>
  </tr>
</table>

The following code examples are adapted from the ZIP archives available from [Firegiant]'s website, namely:
- [`SampleFirst.zip`](https://www.firegiant.com/system/files/samples/SampleFirst.zip).
- [`SampleRegistry.zip`](https://www.firegiant.com/system/files/samples/SampleRegistry.zip).

> **&#9755;** ***Archive contents***<br/>
> The contents of each archive file is minimal: one [WiX source file](https://wixtoolset.org/documentation/manual/v3/overview/files.html) and 3 dummy (*and invalid*) binary files:
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://linux.die.net/man/1/unzip">unzip</a> -Z1 SampleFirst.zip</b>
> Helper.dll
> FoobarAppl10.exe
> Manual.pdf
> SampleFirst.wxs
> </pre>

Concretely, we make the following adaptations to the original examples:
- We modify the original [`SampleFirst.wxs`](./SampleFirst/src/SampleFirst.wxs) file as follows:
  * We replace the `YOURGUID-<...>` placeholders by unique symbolic names (e.g. `Id='YOURGUID-86C7-4D14-AEC0-86416A69ABDE'` becomes `Id='YOURGUID-PRODUCT_CODE'`) in order to delay *and* automatize their substitution (more details below).
  * We introduce [bindpath variables](https://wixtoolset.org/documentation/manual/v3/howtos/general/specifying_source_files.html) to specify the file location in the `Source`tags (e.g. `Source='FoobarAppl10.exe'`becomes `Source='!(bindpath.exe)\FoobarAppl10.exe'`). The real file location is resolved at build time using the `-b "<var>=<path>"` option of the WiX linker [`light`](https://wixtoolset.org/documentation/manual/v3/overview/light.html).
- We replace `Manual.pdf` by a *valid* [dummy PDF file](https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf) available from the [W3C](https://www.w3.org/) [ERT working group](https://www.w3.org/WAI/ER/). In this way the user can successfully open the PDF file (e.g. from the program menu "SampleFirst") after the installation is done.

The build steps to generate a Windows installer are:

<div style="width:300px;border:solid lightgray 2px;text-align:center;margin:0 0 10px 50px;">
<div><a href="./SampleFirst/src/SampleFirst.wxs"><code>src\SampleFirst.wxs</code></a></div>
<div>
  <span style="font-size:70%;">Preprocessing</span>
  <span style="font-size:200%;">⇩</span>
  <span style="font-size:70%;">with <code><a href="./SampleFirst/build.bat">build.bat</a></code></span>
</div>
<div><code>target\src_gen\SampleFirst.wxs</code></div>
<div>
  <span style="font-size:70%;padding:0 0 0 45px;">Compilation</span>
  <span style="font-size:200%;">⇩</span>
  <span style="font-size:70%;">with <code>%WIX%\<a href="https://wixtoolset.org/documentation/manual/v3/overview/candle.html">candle.exe</a></code></span>
</div>
<div><code>target\SampleFirst.wixObj</code></div>
<div>
  <span style="font-size:70%;padding:0 0 0 65px;">Linking</span>
  <span style="font-size:200%;">⇩</span>
  <span style="font-size:70%;">with <code>%WIX%\<a href="https://wixtoolset.org/documentation/manual/v3/overview/light.html">light.exe</a></code></span>
</div>
<div style="padding:0 0 5px 0;">
  <code>target\SampleFirst.msi</code>
</div>
</div>

The preprocessing step consists of several operations:
- We generate a GUID <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> with the [PS][microsoft_powershell] cmdlet [`New-Guid`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid?view=powershell-7.1).
- We associate a new GUID to each symbolic name (e.g. `'YOURGUID-PRODUCT_CODE'`) found in file `src\SampleFirst.wxs`.
- We save the association into the file `build.properties` to ensure the same GUID is *reused* when generating the MSI package again ([`build.bat`](./SampleFirst/build.bat) takes existing GUIDs from `build.properties` instead of generating new ones).

## <span id="samplefirst">SampleFirst</span>

Example `SampleFirst` is organized as follows :
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\firegiant-examples\SampleFirst
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   <a href="./SampleFirst/build.bat">build.bat</a>
├───<b>app</b>
│       FoobarAppl10.exe
│       Helper.dll
│       Manual.pdf
└───<b>src</b>
        <a href="./SampleFirst/src/SampleFirst.wxs">SampleFirst.wxs</a>
</pre>

> **:mag_right:** In more elaborated projects directory [`src\`](./SampleFirst/src/) would also contain [WXI and WXL files](https://wixtoolset.org/documentation/manual/v3/overview/files.html) (aka WiX include and localization files).

Command [`build help`](./SampleFirst/build.bat) displays the batch file options and subcommands:

Command [`build pack`](./SampleFirst/build.bat) generates the MSI package file:

<pre style="font-size:80%;">
<b>&gt; <a href="./SampleFirst/build.bat">build</a> clean pack &amp;&amp; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   candle_ops.txt
│   candle_sources.txt
│   light_opts.txt
│   Sample.cab
│   SampleFirst.msi
│   SampleFirst.wixobj
│   SampleFirst.wixpdb
└───src_gen
        SampleFirst.wxs
</pre>

> **:mag_right:** In the above listing of the `target\` directory file `target\src_gen\SampleFirst.wxs` contains the real GUIDs instead of the symbol names defined in file [`src\SampleFirst.wxs`](./SampleFirst/src/SampleFirst.wxs).

<table>
<tr>
<td style="text-align:center;">
  <a href="images/SampleFirst.png"><img style="max-width:180px;" src="images/SampleFirst.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.1 -</b> <i>Foobar</i> executable<br>(<i>Program Files (x86)</i> folder).<br/>&nbsp;
</td>
<td style="text-align:center;">
  <a href="images/SampleFirst_StartMenu.png"><img style="max-width:160px;" src="images/SampleFirst_StartMenu.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.1 -</b> <i>Foobar</i> shortcuts<br>(<i>Start Menu</i> folder).
</td>
<td style="text-align:center;">
  <a href="images/SampleFirst_Uninstall.png"><img style="max-width:180px;" src="images/SampleFirst_Uninstall.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.2 -</b> Uninstalling <i>Foobar</i><br/>(<i>Settings</i> window).
</td>
</tr>
</table>

## <span id="sample_registry">SampleRegistry</span>

Example `SampleRegistry` is organized in the same way as example `SampleFirst`.

Again command [`build pack`](./SampleFirst/build.bat) generates the Windows installer:

<pre style="font-size:80%;">
<b>&gt; <a href="./SampleRegistry/build.bat">build</a> clean pack &amp;&amp; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   candle_ops.txt
│   candle_sources.txt
│   light_opts.txt
│   Sample.cab
│   SampleRegistry.msi
│   SampleRegistry.wixobj
│   SampleRegistry.wixpdb
└───src_gen
        SampleRegistry.wxs
</pre>

## <span id="Sample_localization">SampleLocalization</span>

Example `SampleLocalization` implements the user interface of the Windows installer.

**WIP**

<!--
http://www.lingoes.net/en/translator/langcode.htm
-->

## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***GUID*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
A GUID is a 128-bit integer (16 bytes) that can be used across all computers and networks wherever a unique identifier is required. Such an identifier has a very low probability of being duplicated.
</p>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[firegiant]: https://www.firegiant.com/
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
