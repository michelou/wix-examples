# <span id="top">Firegiant's WiX examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://www.firegiant.com/" rel="external"><img style="border:0;width:120px;" src="https://www.firegiant.com/assets/img/logo_firegiant.png" alt="Firegiant Company" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>firegiant-examples\</code></strong> contains the <a href="https://wixtoolset.org/" rel="external">WiX</a> examples presented in the Firegiant's online <a href="https://www.firegiant.com/wix/tutorial/" rel="external">WiX Toolset Tutorial</a>, the authoritative guide for <a href="https://wixtoolset.org/" rel="external">WiX</a> developers.
  </td>
  </tr>
</table>

The [WiX][wix_toolset] examples presented in the following sections
are adapted <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> from the ZIP archives <sup id="anchor_02"><a href="#footnote_02">[2]</a></sup> available on [Firegiant]'s website and share the same characteristics as the [WiX][wix_toolset] examples from page [myexamples/README.md](../myexamples/README.md).

## <span id="sample_first">SampleFirst</span>

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

<b name="footnote_01">[1]</b> ***Archive contents*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
The contents of each archive file is minimal; for instance the <code>SampleFirst.zip</code> example contains one <a href="https://wixtoolset.org/documentation/manual/v3/overview/files.html">WiX source file</a> and 3 dummy (<i>and invalid</i>) binary files:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://linux.die.net/man/1/unzip">unzip</a> -Z1 SampleFirst.zip</b>
Helper.dll
FoobarAppl10.exe
Manual.pdf
SampleFirst.wxs
</pre>
<p style="margin:0 0 1em 20px;">
Concretely, we undertake the following modifications of the original examples:
</p>
<ul style="margin:0 0 1em 20px;">
<li>
We modify the original <a href="./SampleFirst/src/SampleFirst.wxs"><code>SampleFirst.wxs</code></a> file as follows:
  <ul>
  <li>We replace the <code>YOURGUID-<...></code> placeholders by unique symbolic names (e.g. <code>Id='YOURGUID-86C7-4D14-AEC0-86416A69ABDE'</code> becomes <code>Id='YOURGUID-PRODUCT_CODE'</code>) in order to delay <i>and</i> automatize their substitution (more details below).
  </li>
  <li>We introduce <a href="https://wixtoolset.org/documentation/manual/v3/howtos/general/specifying_source_files.html">bindpath variables</a> to specify the file location in the <code>Source</code> tags (e.g. <code>Source='FoobarAppl10.exe'</code> becomes <code>Source='!(bindpath.exe)\FoobarAppl10.exe'</code>). The real file location is resolved at build time using the <code>-b "&lt;var&gt;=&lt;path&gt;"</code> option of the <a href="https://wixtoolset.org/">WiX</a> linker <a href="https://wixtoolset.org/documentation/manual/v3/overview/light.html"><code>light</code></a>.
  </liS>
  </ul>
</li>
<li>
We replace <code>Manual.pdf</code> by a <i>valid</i> <a href="https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf">dummy PDF file</a> available from the <a href="https://www.w3.org/) [ERT working group](https://www.w3.org/WAI/ER/">W3C</a>. In this way the user can successfully open the PDF file (e.g. from the program menu "SampleFirst") after the installation is done.
</li>
</ul>
<p style="margin:0 0 1em 20px;">
The build steps to generate a Windows installer are:
</p>
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
<p style="margin:0 0 1em 20px;">
The preprocessing step consists of several operations:
</p>
<ul style="margin:0 0 1em 20px;">
<li>We generate a GUID <sup id="anchor_03"><a href="#footnote_03">[3]</a></sup> with the <a href="https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6">PS</a> cmdlet <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid?view=powershell-7.1"><code>New-Guid</code></a>.</li>
<li>We associate a new GUID to each symbolic name (e.g. <code>'YOURGUID-PRODUCT_CODE'</code>) found in file <code>src\SampleFirst.wxs</code>.</li>
<li>We save the association into the file `build.properties` to ensure the same GUID is <i>reused</i> when generating the MSI package again <a href="./SampleFirst/build.bat"></code>build.bat</code></a> takes existing GUIDs from <code>build.properties</code> instead of generating new ones).</li>
</ul>

<b name="footnote_02">[2]</b> ***Archive List*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
Here is the list of ZIP archives available on <a href="https://www.firegiant.com/">Firegiant</a>'s website :
</p>

<table style="margin:0 0 1em 20px;">
<tr><th>Chapter</th><th>Zip archive</th></tr>
<tr>
  <td><a href="">Getting Started</a></td>
  <td><a href="https://www.firegiant.com/system/files/samples/SampleFirst.zip"><code>SampleFirst.zip</code></a></td>
</tr>
<!--
<tr>
  <td><a href="https://www.firegiant.com/wix/tutorial/events-and-actions">Events and Actions</a></td>
  <td><a href=""><code>xxxx</code></a></td>
</tr>
-->
<tr>
  <td><a href="https://www.firegiant.com/wix/tutorial/upgrades-and-modularization/checking-for-oldies/">Upgrades and Modularization<br/>Checking for Oldies</a></td>
  <td><a href="https://www.firegiant.com/system/files/samples/SampleUpgrade.zip"><code>SampleUpgrade.zip</code></a></td>
</tr>
<tr>
  <td><a href="https://www.firegiant.com/wix/tutorial/upgrades-and-modularization/patchwork/">Upgrades and Modularization<br/>Patchwork</a></td>
  <td><a href="https://www.firegiant.com/system/files/samples/SamplePatch.zip"><code>SamplePatch.zip</code></a></td>
</tr>
<tr>
  <td><a href="https://www.firegiant.com/wix/tutorial/upgrades-and-modularization/fragments/">Upgrades and Modularization<br/>Fragments</a></td>
  <td><a href="https://www.firegiant.com/system/files/samples/SampleFragment.zip"><code>SampleFragment.zip</code></a></td>
</tr>
<tr>
  <td><a href="https://www.firegiant.com/wix/tutorial/user-interface/">User Interface</a></td>
  <td><a href="https://www.firegiant.com/system/files/samples/SampleWixUI.zip"><code>SampleWixUI.zip</code></a></td>
</tr>
</table>

<b name="footnote_03">[3]</b> ***GUID*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
A GUID is a 128-bit integer (16 bytes) that can be used across all computers and networks wherever a unique identifier is required. Such an identifier has a very low probability of being duplicated.
</p>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[firegiant]: https://www.firegiant.com/
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[wix_toolset]: https://wixtoolset.org/
