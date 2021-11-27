# <span id="top">WiX examples with OpenJDK distribution</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://wixtoolset.org/" rel="external"><img style="border:0;width:120px;" src="../docs/wixtoolset.png" alt="WiX project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>openjdk-examples\</code></strong> contains <a href="https://wixtoolset.org/" rel="external">WiX</a> examples written by ourself to create a <a href="https://www.scala-lang.org/">OpenJDK</a> Windows installer.
  </td>
  </tr>
</table>

[Eclipse Adoptium](https://projects.eclipse.org/projects/adoptium) is a top-level project whose mission is to provide an open and reproducible build and test system for OpenJDK source across multiple platforms.

This includes the development of a [WiX installer](https://github.com/adoptium/installer/tree/master/wix) (see GitHub project [`adoptium/installer`][adoptium_installer]) configurable for various OpenJDK implementations.

## <span id="openjdk11">OpenJDK11</span>

Project `OpenJDK11` is derived from the [WiX][wix_toolset] installer developed in the project [`adoptium/installer`][adoptium_installer].

> **:mag_right:**  Concretely, localization and resource files are the same as well as the source file [`src\Main.wxs`](./OpenJDK11/src/Main.wxs) *but* we do not have a source file `src\Fragments.wxs` as in the Adoptium project. GUID values are stored in a separate file named `guids-11.0.13_8.txt` (*ignored* by [`git`][git_cmd]) and inserted into the generated file `target\src_gen\Fragments.wxs` before calling the [`candle`][wix_candle] tool (compiler).

The project directory is organized as follows :
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\openjdk-examples\OpenJDK11
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   <a href="./OpenJDK11/00download.txt">00download.txt</a>
│   <a href="./OpenJDK11/build.bat">build.bat</a>
├───<b>app</b>
│   └───<i>files extracted from</i> <a href="https://adoptium.net/archive.html?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.zip</a>
└───<b>src</b>
    │   <a href="./OpenJDK11/src/Includes.wxi">Includes.wxi</a>
    │   <a href="./OpenJDK11/src/Main.wxs">Main.wxs</a>
    ├───<b>localizations</b>
    │       <a href="./OpenJDK11/src/localizations/OpenJDK.Base.en-us.wxl">OpenJDK.Base.en-us.wxl</a>
    │       <a href="./OpenJDK11/src/localizations/OpenJDK.Base.fr-fr.wxl">OpenJDK.Base.fr-fr.wxl</a>
    │       <a href="./OpenJDK11/src/localizations/OpenJDK.hotspot.en-us.wxl">OpenJDK.hotspot.en-us.wxl</a>
    │       <a href="./OpenJDK11/src/localizations/OpenJDK.hotspot.fr-fr.wxl">OpenJDK.hotspot.fr-fr.wxl</a>
    │       <a href="./OpenJDK11/src/localizations/OpenJDK.openj9.en-us.wxl">OpenJDK.openj9.en-us.wxl</a>
    │       <a href="./OpenJDK11/src/localizations/OpenJDK.openj9.fr-fr.wxl">OpenJDK.openj9.fr-fr.wxl</a>
    └───<b>resources</b>
            license-GPLv2+CE.en-us.rtf
            license-OpenJ9.en-us.rtf
            logo.ico
            <a href="./OpenJDK11/src/resources/wix-banner.bmp">wix-banner.bmp</a>
            <a href="./OpenJDK11/src/resources/wix-dialog.bmp">wix-dialog.bmp</a>
</pre>

Command [`build link`](./OpenJDK11/build.bat) <sup id="anchor_01">[1](#footnote_01)</sup> generates the [OpenJDK 11][adoptium_openjdk11] Windows installer with file name `OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi` <sup id="anchor_02">[2](#footnote_02)</sup>.

<pre style="font-size:80%;">
<b>&gt; <a href="./OpenJDK11/build.bat">build</a> -verbose clean link</b>
Delete directory "target"
Generate auxiliary file "target\src_gen\Fragments.wxs.txt"
Saved 497 component identifiers to file "target\src_gen\Fragments.cid.txt"
ECHO is off.
Execute PS1 script "target\replace.ps1"
Compiling 2 WiX source files to directory "target"
Create Windows installer "target\OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi"
</pre>

The output directory `target\` looks as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /a-d /b target</b>
candle_opts.txt
candle_sources.txt
Fragments.wixobj
light_opts.txt
Main.wixobj
OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi
OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi.md5
OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi.sha256
OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.wixpdb
replace.ps11
</pre>

Figures **1.1** to **1.4** below illustrate the dialog windows of our [OpenJDK 11][adoptium_openjdk11] Windows installer while figures **1.5** and **1.6** show the updated user environment after the successful execution of the Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <a href="images/Temurin_OpenJDK11_Welcome.png"><img style="max-width:180px;" src="images/Temurin_OpenJDK11_Welcome.png" /></a>
  <div style="font-size:70%;">
  <b>Figure 1.1 -</b> Welcome<br>(<i>OpenJDK 11</i> installer).<br/>&nbsp;
  </div>
  <a href="images/Temurin_OpenJDK11_CustomSetup.png"><img style="max-width:180px;" src="images/Temurin_OpenJDK11_CustomSetup.png" /></a>
  <div style="font-size:70%;">
  <b>Figure 1.2 -</b> Custom setup<br>(<i>OpenJDK 11</i> installer).
  </div>
</td>
<td style="text-align:center;">
  <a href="images/Temurin_OpenJDK11_Ready.png"><img style="max-width:180px;" src="images/Temurin_OpenJDK11_Ready.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.3 -</b> Ready<br>(<i>OpenJDK 11</i> installer).<br/>&nbsp;
  </div>
  <a href="images/Temurin_OpenJDK11_Completed.png"><img style="max-width:180px;" src="images/Temurin_OpenJDK11_Completed.png" /></a>
  <div style="font-size:70%;">
  <b>Figure 1.4 -</b> Completed installation<br/>(<i>OpenJDK 11</i> installer).
  </div>
</td>
<td>
  <a href="images/Temurin_OpenJDK11_ProgFiles.png"><img style="max-width:180px;" src="images/Temurin_OpenJDK11_ProgFiles.png" /></a>
  <div style="font-size:70%;">
  <b>Figure 1.5 -</b> <i>OpenJDK 11</i> directory<br/>(<i>Program&nbsp;Files</i> folder).<br/>&nbsp;
  </div>
  <a href="images/Temurin_OpenJDK11_Uninstall.png"><img style="max-width:180px;" src="images/Temurin_OpenJDK11_Uninstall.png" /></a>
  <div style="font-size:70%;">
  <b>Figure 1.6 -</b> Uninstall<br/>(<i>Settings</i> window).
  </div>
</td>
</tr>
</table>

## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***Batch file* `build.bat`** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Command <a href="./OpenJDK11/build.bat"><code>build help</code></a> displays the batch file options and subcommands :
</p>

<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; build help</b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -debug       show commands executed by this script
    -timer       display total execution time
    -verbose     display progress messages
&nbsp;
  Subcommands:
    clean        delete generated files
    help         display this help message
    install      execute Windows installer OpenJDK
    link         create Windows installer from WXS/WXI/WXL files
    remove       remove installed program (same as uninstall)
    uninstall    remove installed program
</pre>

<b name="footnote_02">[2]</b> ***File naming conventions*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
For instance the name of file <code>OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi</code> can be decomposed as follows (see also the Swagger descriptions of the <a href="https://api.adoptium.net/q/swagger-ui/#/Installer">OpenAPI UI</a>):
</p>
<table style="margin:0 0 1em 20px;">
<tr>
   <th>Name&nbsp;part</th>
   <th>Description</th>
   <th>Values</th>
</tr>
<tr>
  <td><code>OpenJDK</code></td>
  <td>Product SKU</td>
  <td><code>OpenJDK</code></td>
</tr>
<tr>
  <td><code>11</code></td>
  <td>Product major version</td>
  <td><code>8</code>, <code>11</code>, <code>17</code></td>
</tr>
<tr>
  <td><code>U</code></td>
  <td>Update release</td>
  <td><code>U</code></td>
</tr>
<tr>
  <td><code>jdk</code></td>
  <td>Product category</td>
  <td><code>jdk</code>, <code>jre</code></td>
</tr>
<tr>
  <td><code>x64</code></td>
  <td>Target architecture</td>
  <td><code>aarch64</code>, <code>arm64</code>, <code>ppc64</code>, <code>s390x</code>, <code>x64</code>, <code>x86_32</code></td>
</tr>
<tr>
  <td><code>windows</code></td>
  <td>Target platform</td>
  <td><code>aix</code>, <code>alpine-linux</code>,<code>arm_linux</code>, <code>linux</code>, <code>mac</code>, <code>windows</code></td>
</tr>
<tr>
  <td><code>hotspot</code></td>
  <td>JVM variant</td>
  <td><code>hotspot</code>, <code>openj9</code>, <code>dragonwell</code></td>
</tr>
<tr>
  <td><code>11.0.13_8</code><br/>&nbsp;<br/><code>8u312b07</code></td>
  <td>Product&nbsp;version</td>
  <td><code>&lt;major&gt;.&lt;minor&gt;.&lt;maintenance&gt;_&lt;build&gt;</code><br/><b>NB.</b> prior to Java 10 written :<br/><code>&lt;major&gt;u&lt;maintenance&gt;b&lt;build&gt;</code></td>
</tr>
<tr>
  <td><code>msi</code></td>
  <td>File extension</td>
  <td><code>msi</code>, <code>zip</code></td>
</tr>
</table>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[adoptium_installer]: https://github.com/adoptium/installer
[adoptium_openjdk11]: https://adoptium.net/?variant=openjdk11&jvmVariant=hotspot
[git_cmd]: https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html
[wix_candle]: https://wixtoolset.org/documentation/manual/v3/overview/candle.html
[wix_component]: https://wixtoolset.org/documentation/manual/v3/xsd/wix/component.html
[wix_heat]: https://wixtoolset.org/documentation/manual/v3/overview/heat.html
[wix_light]: https://wixtoolset.org/documentation/manual/v3/overview/light.html
[wix_toolset]: https://wixtoolset.org/
