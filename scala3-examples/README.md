# <span id="top">WiX examples with Scala 3 distribution</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://wixtoolset.org/" rel="external"><img style="border:0;width:120px;" src="../images/wixtoolset.png" alt="WiX Toolset" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>scala3-examples\</code></strong> contains <a href="https://wixtoolset.org/" rel="external">WiX</a> examples written by ourself to create a <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> Windows installer.<br/>This work is mainly motivated by <a href="https://github.com/lampepfl/dotty/issues/12502">issue 12502</a> (<i>Distribute releases as .deb and .msi</i>) of the <a href="https://github.com/lampepfl/dotty" rel="external">Dotty project</a>.<br/>Follow <a href="https://github.com/michelou/wix-examples/blob/main/scala2-examples/README.md">this link</a> if you're looking for the Scala 2 Windows installer.
  </td>
  </tr>
</table>

The [WiX][wix_toolset] examples presented in the following sections
- *share* the same project organisation as the [WiX][wix_toolset] examples from page [`myexamples/README.md`](../myexamples/README.md).
- *differ* in several respects from the [WiX][wix_toolset] examples from page [`myexamples/README.md`](../myexamples/README.md), in particular :
   - we *download* and extract the application files from the Zip archive (e.g. [`scala3-3.3.0.zip`][scala3_zip]) if they are not yet present in directory `app\`.
   - we *do not* maintain a source file `Fragments.wxs` in directory `src\`; the file `target\src_gen\Fragments.wxs` <sup id="anchor_01">[1](#footnote_01)</sup> ‒ which contains a *list of links* to the application files ‒ is generated on each run with GUID values inserted on the fly. 

The [Scala 3][scala3] Windows installer behaves in *3 different ways* when it detects a [Scala 3][scala3] installation on the target machine (see [WiX element `MajorUpgrade`](https://wixtoolset.org/documentation/manual/v3/xsd/wix/majorupgrade.html)) :
- if the version to be installed is ***newer than*** the version found on the machine then the Windows installer goes on (it removes the old version and install the new one).
- if the version to be installed is ***older than*** the version found on the machine then the [Windows installer does exit](./images/Scala3Features_LaterAlreadyInstalled.png).
- if the version to be installed is ***the same as*** the version found on the machine then the user is asked for a [change, repair or remove operation](./images/Scala3Features_ChangeOrRepair.png).

> **&#9755;** Visit our [Releases](https://github.com/michelou/wix-examples/releases) page to download and try the latest *self-signed* [Scala 3][scala3] Windows installer. The document [`SECURITY.md`](../SECURITY.md) provides more information about [*self-signed certificates*](https://en.wikipedia.org/wiki/Self-signed_certificate).

## <span id="scala3_first">`Scala3First` Example</span>

`Scala3First` <sup id="anchor_02">[2](#footnote_02)</sup> is our first iteration to create a Windows installer (aka. `.msi` file) for the [Scala 3][scala3_releases] software distribution.

The project directory is organized as follows :
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\scala3-examples\Scala3First
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [a-z]</b>
│   <a href="./Scala3First/build.bat">build.bat</a>
├───<b>app</b>
│   ├───<b>scala3-3.0.2</b>
│   │       <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.0.2"><b>scala3-3.0.2.zip</b></a><i>)</i>
│   └───<b>scala3-3.1.0</b>
│           <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.1.0"><b>scala3-3.1.0.zip</b></a><i>)</i>
└───<a href="./Scala3First/src/"><b>src</b></a>
    │   <a href="./Scala3First/src/Scala3First.wxs">Scala3First.wxs</a>
    └───<a href="./Scala3First/src/resources/"><b>resources</b></a>
            <a href="./Scala3First/src/resources/favicon.ico">favicon.ico</a>
            <a href="./Scala3First/src/resources/Fragments.xslt">Fragments.xslt</a>
            <a href="./Scala3First/src/resources/repl.bat">repl.bat</a>
</pre>

> **:mag_right:** During installation the batch file [`src\resources\repl.bat`](./Scala3First/src/resources/repl.bat) is added to the `bin\` directory; the goal of that wrapper script is to look for a Java installation <sup id="anchor_03">[3](#footnote_03)</sup> before starting the Scala 3 REPL (Scala commands require either variable **`JAVA_HOME`** or variable **`JAVACMD`** to be defined).

Command [`build link`](./Scala3First/build.bat) <sup id="anchor_04">[4](#footnote_04)</sup> generates the [Scala 3][scala3] Windows installer with file name `scala3-3.3.0.msi`.

<pre style="font-size:80%;">
<b>&gt; <a href="./Scala3First/build.bat">build</a> clean link &amp;&amp; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   candle_opts.txt
│   candle_sources.txt
│   Fragments.wixobj
│   light_opts.txt
│   replace.ps1
│   scala3-3.1.0.msi
│   scala3-3.1.0.msi.md5
│   scala3-3.1.0.msi.sha256
│   scala3-3.1.0.wixpdb
│   Scala3First.wixobj
├───<b>resources</b>
│       favicon.ico
│       repl.bat
└───<b>src_gen</b>
        Fragments-cid.txt   <i>(component identifier list)</i>
        Fragments.wxs
        Scala3First.wxs
</pre>

> **:mag_right:** The above file `target\src_gen\Scala3First.wxs` contains the real GUIDs instead of the variables names specified in source file [`src\Scala3First.wxs`](./Scala3First/src/Scala3First.wxs).

Figures **1.1** to **1.5** below illustrate the updated user environment after the successful execution of the [Scala 3][scala3] Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <a href="images/Scala3First_ProgFiles.png">
  <img style="max-width:180px;" src="images/Scala3First_ProgFiles.png" alt="Scala 3 directory" />
  </a>
  <div style="font-size:70%;"><b>Figure 1.1 -</b> <i>Scala 3</i> directory<br>(<i>Program Files</i> folder).<br/>&nbsp;
  </div>
  <a href="images/Scala3First_Menu.png">
  <img style="max-width:180px;" src="images/Scala3First_Menu.png" alt="Scala 3 shortcuts" />
  </a>
  <div style="font-size:70%;"><b>Figure 1.2 -</b> <i>Scala 3</i> shortcuts<br>(<i>Start Menu</i> folder).
  </div>
</td>
<td style="text-align:center;background-color:#bbeedd;">
  <a href="images/Scala3First_StartMenu.png">
  <img style="max-width:160px;" src="images/Scala3First_StartMenu.png" alt="Start Menu" />
  </a>
  <div style="font-size:70%;"><b>Figure 1.3 -</b> <i>Scala 3</i> shorcuts<br>(<i>Start Menu</i> folder).<br/>&nbsp;
  </div>
  <a href="images/Scala3First_REPL.png">
  <img style="max-width:180px;" src="images/Scala3First_REPL.png" alt="Scala 3 REPL" />
  </a>
  <div style="font-size:70%;"><b>Figure 1.4 -</b> <i>Scala 3</i> REPL<br/>(<code>JAVA_HOME</code> defined).
  </div>
</td>
<td style="text-align:center;">
  <a href="images/Scala3First_REPL_failed.png">
  <img style="max-width:180px;" src="images/Scala3First_REPL_failed.png" alt="Scala 3 REPL" />
  </a>
  <div style="font-size:70%;"><b>Figure 1.5 -</b> <i>Scala 3</i> REPL<br/>(<code>JAVA_HOME</code> undefined).<br/>&nbsp;
  </div>
  <a href="images/Scala3First_Uninstall.png">
  <img style="max-width:180px;" src="images/Scala3First_Uninstall.png" alt="Uninstall Scala 3" />
  </a>
  <div style="font-size:70%;"><b>Figure 1.6 -</b> Uninstall <i>Scala 3</i><br/>(<i>Settings</i> window).
  </div>
</td>
</tr>
</table>

## <span id="scala3_ui">`Scala3UI` Example</span> [**&#x25B4;**](#top)

`Scala3UI` <sup id="anchor_02">[2](#footnote_02)</sup> adds customizations to the graphical user interface of the [Scala 3][scala3] Windows installer. Concretely, we define two images to customize the dialog windows of the Windows installer, ie. :
- image [`Dialog.bmp`](./Scala3UI/src/resources/Dialog.bmp) appears in the *Welcome* and *Completed* dialog windows.
- image [`BannerTop.bmp`](./Scala3UI/src/resources/BannerTop.bmp) appears at the top of the other dialog windows.


The project directory is organized as follows :
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\scala3-examples\Scala3UI
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [a-z]</b>
│   <a href="./Scala3UI/build.bat">build.bat</a>
├───<b>app</b>
│   ├───<b>scala3-3.0.2</b>
│   │       <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.0.2"><b>scala3-3.0.2.zip</b></a><i>)</i>
│   └───<b>scala3-3.1.0</b>
│           <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.1.0"><b>scala3-3.1.0.zip</b></a><i>)</i>
│   └───<b>scala3-3.3.0</b>
│           <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.3.0"><b>scala3-3.3.0.zip</b></a><i>)</i>
└───<a href="./Scala3UI/src/"><b>src</b></a>
    │   <a href="./Scala3UI/src/Includes.wxi">Includes.wxi</a>
    │   <a href="./Scala3UI/src/Scala3UI.wxs">Scala3UI.wxs</a>
    └───<a href="./Scala3UI/src/resources/"><b>resources</b></a>
            <a href="./Scala3UI/src/resources/BannerTop.bmp">BannerTop.bmp</a>
            <a href="./Scala3UI/src/resources/Dialog.bmp">Dialog.bmp</a>
            <a href="./Scala3UI/src/resources/logo.svg">logo.svg</a>
            <a href="./Scala3UI/src/resources/favicon.ico">favicon.ico</a>
            <a href="./Scala3UI/src/resources/Fragments.xslt">Fragments.xslt</a>
            <a href="./Scala3UI/src/resources/LICENSE.rtf">LICENSE.rtf</a>
            <a href="./Scala3UI/src/resources/network.ico">network.ico</a>
            <a href="./Scala3UI/src/resources/repl.bat">repl.bat</a>
</pre>

Figures **2.1** to **2.4** below illustrate the dialog windows of the [Scala 3][scala3] Windows installer while figures **2.5** and **2.6** show the updated user environment after the successful execution of the Windows installer.

<table>
<tr>
<td style="text-align:center;background-color:#bbeedd;">
  <a href="images/Scala3UI_Setup1.png">
  <img style="max-width:180px;" src="images/Scala3UI_Setup1.png" alt="Welcome" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.1 -</b> Welcome<br/>(<i>Scala 3</i> installer).<br/>&nbsp;
  </div>
  <a href="images/Scala3UI_Setup2.png">
  <img style="max-width:180px;" src="images/Scala3UI_Setup2.png" alt="EULA" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.2 -</b> EULA<br/>(<i>Scala 3</i> installer).
  </div>
</td>
<td style="text-align:center;background-color:#bbeedd;">
  <a href="images/Scala3UI_Setup3.png">
  <img style="max-width:180px;" src="images/Scala3UI_Setup3.png" alt="Custom Setup" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.3 -</b> Destination folder<br/>(<i>Scala 3</i> installer).<br/>&nbsp;
  </div>
  <a href="images/Scala3UI_Setup5.png">
  <img style="max-width:180px;" src="images/Scala3UI_Setup5.png" alt="Completed" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.4 -</b> Completed installation<br/>(<i>Scala 3</i> installer).
  </div>
</td>
<td style="text-align:center;">
  <a href="images/Scala3UI.png">
  <img style="max-width:180px;" src="images/Scala3UI.png" alt="Scala 3 directory" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.5 -</b> <i>Scala 3</i> directory<br>(<i>Program Files</i> folder).<br/>&nbsp;
  </div>
  <a href="images/Scala3UI_Menu.png">
  <img style="max-width:180px;" src="images/Scala3UI_Menu.png" alt="Scala 3 shortcuts" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.6 -</b> <i>Scala 3</i> shortcuts<br>(<i>Start Menu</i> folder).
  </div>
</td>
</tr>
</table>

## <span id="scala3_localized">`Scala3Localized` Example</span> [**&#x25B4;**](#top)

Project `Scala3Localized` <sup id="anchor_02">[2](#footnote_02)</sup> adds language localization to the [WiX][wix_toolset] source files of the [Scala 3][scala3] Windows installer.

This project contains the additional directory [`src\localizations\`](./Scala3Localized/src/localizations/) with 4 [WiX localization files](https://wixtoolset.org//documentation/manual/v3/wixui/wixui_localization.html):
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\scala3-examples\Scala3Localized
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [a-z]</b>
│   <a href="./Scala3Localized/build.bat">build.bat</a>
├───<b>app</b>
│   ├───<b>scala3-3.0.2</b>
│   │       <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.0.2"><b>scala3-3.0.2.zip</b></a><i>)</i>
│   └───<b>scala3-3.1.0</b>
│           <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.1.0"><b>scala3-3.1.0.zip</b></a><i>)</i>
│   └───<b>scala3-3.3.0</b>
│           <i>(files extracted from</i> <a href="https://github.com/lampepfl/dotty/releases/tag/3.3.0"><b>scala3-3.3.0.zip</b></a><i>)</i>
└───<a href="./Scala3Localized/src/"><b>src</b></a>
    │   <a href="./Scala3Localized/src/Includes.wxi">Includes.wxi</a>
    │   <a href="./Scala3Localized/src/Scala3Localized.wxs">Scala3Localized.wxs</a>
    ├───<a href="./Scala3Localized/src/localizations/"><b>localizations</b></a>
    │       <a href="./Scala3Localized/src/localizations/de-DE.wxl">de-DE.wxl</a>
    │       <a href="./Scala3Localized/src/localizations/en-US.wxl">en-US.wxl</a>
    │       <a href="./Scala3Localized/src/localizations/fr-FR.wxl">fr-Fr.wxl</a>
    │       <a href="./Scala3Localized/src/localizations/sv-SE.wxl">sv-SE.wxl</a>
    └───<a href="./Scala3Localized/src/resources/"><b>resources</b></a>
            <a href="./Scala3Localized/src/resources/BannerTop.bmp">BannerTop.bmp</a>
            <a href="./Scala3Localized/src/resources/Dialog.bmp">Dialog.bmp</a>
            <a href="./Scala3Localized/src/resources/logo.svg">logo.svg</a>
            <a href="./Scala3Localized/src/resources/favicon.ico">favicon.ico</a>
            <a href="./Scala3Localized/src/resources/LICENSE.rtf">LICENSE.rtf</a>
            <a href="./Scala3Localized/src/resources/network.ico">network.ico</a>
            <a href="./Scala3Localized/src/resources/repl.bat">repl.bat</a>
</pre>

Command [`build link`](./Scala3Localized/build.bat) generates a separate MSI file for each language localization, e.g. `scala3-3.1.0-sv-SE.msi` is the swedish version of the [Scala 3][scala3] Windows installer.

<pre style="font-size:80%;">
<b>&gt; <a href="./Scala3Localized/build.bat">build</a> clean link && <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b /a-d target</b>
candle_opts.txt
candle_sources.txt
Fragments.wixobj
light_opts.txt
replace.ps1
<b>scala3-3.1.0.msi</b>
scala3-3.1.0.msi.md5
scala3-3.1.0.msi.sha256
scala3-3.1.0.wixpdb
<b>scala3-3.1.0_de-DE.msi</b>
scala3-3.1.0_de-DE.msi.md5
scala3-3.1.0_de-DE.msi.sha256
scala3-3.1.0_de-DE.wixpdb
<b>scala3-3.1.0_fr-FR.msi</b>
scala3-3.1.0_fr-FR.msi.md5
scala3-3.1.0_fr-FR.msi.sha256
scala3-3.1.0_fr-FR.wixpdb
<b>scala3-3.1.0_sv-SE.msi</b>
scala3-3.1.0_sv-SE.msi.md5
scala3-3.1.0_sv-SE.msi.sha256
scala3-3.1.0_sv-SE.wixpdb
Scala3Localized.wixobj
</pre>

Figures **3.1** to **3.4** below illustrate the "**Welcome**" dialog window of the [Scala 3][scala3] Windows installer in english, german, french and swedish.

<table>
<tr>
<td style="text-align:center;">
  <a href="images/Scala3Localized_Setup1.png">
  <img style="max-width:180px;" src="images/Scala3Localized_Setup1.png" alt="Welcome" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.1 -</b> Welcome<br/>(<i>english</i> version).<br/>&nbsp;
  </div>
  <a href="images/Scala3Localized_Setup1_de.png">
  <img style="max-width:180px;" src="images/Scala3Localized_Setup1_de.png" alt="Willkommen" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.2 -</b> Willkommen<br/>(<i>german</i> version).
  </div>
</td>
<td style="text-align:center;">
  <a href="images/Scala3Localized_Setup1_fr.png">
  <img style="max-width:180px;" src="images/Scala3Localized_Setup1_fr.png" alt="Bienvenue" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.3 -</b> Bienvenue<br/>(<i>french</i> version).<br/>&nbsp;
  </div>
  <a href="images/Scala3Localized_Setup1_sv.png">
  <img style="max-width:180px;" src="images/Scala3Localized_Setup1_sv.png" alt="Välkommen" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.4 -</b> Välkommen<br/>(<i>swedish</i> version).
  </div>
</td>
</tr>
</table>

## <span id="scala3_features">`Scala3Features` Example</span>

`Scala3Features` <sup id="anchor_02">[2](#footnote_02)</sup> adds feature customization to the [Scala 3][scala3] Windows installer.

Concretely the main [`Feature` element](https://wixtoolset.org/documentation/manual/v3/xsd/wix/feature.html) of the WiX source file [`Scala3Features.wxs`](./Scala3Features/src/Scala3Features.wxs) contains one mandatory `Feature` element and 3 optional `Feature` elements (attribute `Absent="allow"`): 

<pre style="font-size:80%;">
&lt;<b>Feature</b> Id="AppComponents" Absent="disallow" ...&gt;
  &lt;<b>Feature</b> Id="AppCore" Absent="disallow" ...&gt;
    &lt;<b>ComponentGroupRef</b> Id='PackFiles' /&gt;
    &lt;<b>ComponentRef</b> Id="ApplicationShortcuts" /&gt;
  &lt;/<b>Feature</b>&gt;
  &lt;<b>Feature</b> Id="ScalaHome" Absent="allow" ...&gt;
    &lt;<b>ComponentRef</b> Id="ApplicationScalaHome" /&gt;
  &lt;/<b>Feature</b>&gt;
  &lt;<b>Feature</b> Id="UpdatePath" Absent="allow" ...&gt;
    &lt;<b>ComponentRef</b> Id="ApplicationUpdatePath" /&gt;
  &lt;/<b>Feature</b>&gt;
  &lt;<b>Feature</b> Id="AppDocumentation" Absent="allow" ...&gt;
    &lt;<b>ComponentGroupRef</b> Id="APIFiles" /&gt;
    &lt;<b>ComponentRef</b> Id="DocumentationShortcuts" /&gt;
  &lt;/<b>Feature</b>&gt;
&lt;/<b>Feature</b>&gt;
</pre>

As before command [`build link`](./Scala3Features/build.bat) generates the MSI file [`scala3-3.1.0.msi`](https://github.com/michelou/wix-examples/releases) with the two checksum files `scala3-3.1.0.msi.md5` and `scala3-3.1.0.msi.sha256`.

<pre style="font-size:80%;">
<b>&gt; <a href="./Scala3Features/build.bat">build</a> -verbose clean link</b>
Delete directory "target"
Generate auxiliary file "target\src_gen\Fragments.wxs"
Saved 54 component identifiers to file "target\src_gen\Fragments-cid.txt"
Execute PowerShell script "target\replace.ps1"
Copy .bat files to directory "target\resources"
Copy .ico files to directory "target\resources"
Use banner image found in directory "src\resources"
Add logo to banner image "target\resources\BannerTop.bmp"
Add logo to dialog image "target\resources\Dialog.bmp"
Set copyright information in file "target\resources\LICENSE.rtf"
Compiling 2 WiX source files to directory "target"
Create Windows installer "target\scala3-3.1.0.msi"
</pre>

<table>
<tr>
<td style="text-align:center;">
  <a href="images/Scala3Features_CustomSetup.png">
  <img style="max-width:180px;" src="images/Scala3Features_CustomSetup.png" alt="Welcome" />
  </a>
  <div style="font-size:70%;"><b>Figure 4.1 -</b> Custom Setup<br/>(<i>Scala3</i> installer).<br/>&nbsp;
  </div>
</td>
</tr>
</table>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **`Fragments.wxs`** [↩](#anchor_01)

<dl><dd>
When we run the <a href="https://wixtoolset.org/documentation/manual/v3/overview/heat.html"><code>heat</code></a> tool to generate the file <code>target\src_gen\Fragments.wxs</code> in the above projects, we also specify the option <code>-t <a href="./Scala3UI/src/resources/Fragments.xslt">src\resources\Fragments.xslt</a></code> to apply a few XML transformations to the generated <a href="https://wixtoolset.org/">WiX</a> source file (eg. addition of component element <code>"repl.bat"</code>).
</dd></dl>

<span id="footnote_02">[2]</span> ***Environment variables*** [↩](#anchor_02)

<dl><dd>
The Scala 3 Windows installer generated in projects <code>Scala3UI</code>, <code>Scala3Localized</code> and <code>Scala3Features</code> (but <b><i>not</i></b> <code>Scala3First</code>) will <i>update</i> the system environment as follows :
</dd>
<dd><pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> SCALA</b>
SCALA3_HOME=C:\Program Files\Scala 3\
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> scala</b>
C:\Program Files\Scala 3\bin\scala
C:\Program Files\Scala 3\bin\scala.bat
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> JAVA_HOME=c:\opt\jdk-bellsoft-1.8.0u312</b>
&nbsp;
<b>&gt; scala -version</b>
Scala code runner version 3.3.0 -- Copyright 2002-2023, LAMP/EPFL
</pre></dd>
</dl>

<span id="footnote_03">[3]</span> ***Default Java Location*** [↩](#anchor_03)

<dl><dd>
OpenJDK implementations are available either as Zip files (<code>.zip</code/>) or as Windows installers (<code>.msi</code>).
</dd>
<dd>
Unfortunately each Windows installer suggests a <i>different</i> default installation location <b>and</b> follows <i>inconsistent</i> naming conventions:
</dd>
<dd>
<table style="font-size:80%;">
<tr>
  <th style="padding:6px;">OpenJDK<br/>Implementation</th>
  <th style="padding:6px;">Default location<br/>in directory <code>%ProgramFiles%</code></th>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://github.com/corretto/corretto-11/releases">Amazon Corretto 11</a></td>
  <td style="padding:6px;"><code>Amazon Corretto\jdk11.0.16_8\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://github.com/corretto/corretto-17/releases">Amazon Corretto 17</a></td>
  <td style="padding:6px;"><code>Amazon Corretto\</code> <b>&#8678;&#8678; !!</b></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://www.azul.com/downloads/?version=java-8-lts&os=windows&architecture=x86-64-bit&package=jdk">Azul Zulu 8</a></td>
  <td style="padding:6px;"><code>Zulu\zulu-8\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://www.azul.com/downloads/?version=java-11-lts&os=windows&architecture=x86-64-bit&package=jdk">Azul Zulu 11</a></td>
  <td style="padding:6px;"><code>Zulu\zulu-11\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://www.azul.com/downloads/?version=java-17-lts&os=windows&architecture=x86-64-bit&package=jdk">Azul Zulu 17</a></td>
  <td style="padding:6px;"><code>Zulu\zulu-17\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://adoptium.net/?variant=openjdk8&jvmVariant=hotspot">Eclipse&nbsp;Temurin&nbsp;8</a></td>
  <td style="padding:6px;"><code>Eclipse Adoptium\jdk-8.0.312.7-hotspot\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://adoptium.net/?variant=openjdk11&jvmVariant=hotspot">Eclipse&nbsp;Temurin&nbsp;11</a></td>
  <td style="padding:6px;"><code>Eclipse Adoptium\jdk-11.0.13.8-hotspot\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://adoptium.net/?variant=openjdk17&jvmVariant=hotspot">Eclipse&nbsp;Temurin&nbsp;17</a></td>
  <td style="padding:6px;"><code>Eclipse Adoptium\jdk-17.0.1.12-hotspot\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://docs.microsoft.com/en-us/java/openjdk/download#openjdk-11">Microsoft 11</a></td>
  <td style="padding:6px;"><code>Microsoft\jdk-11.0.13.8-hotspot\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://docs.microsoft.com/en-us/java/openjdk/download#openjdk-17">Microsoft 17</a></td>
  <td style="padding:6px;"><code>Microsoft\jdk-17.0.1.12-hotspot\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://developers.redhat.com/products/openjdk/download">RedHat 8</a></td>
  <td style="padding:6px;"><code>RedHat\java-1.8.0-openjdk-1.8.0.312.2\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://developers.redhat.com/products/openjdk/download">RedHat 11</a></td>
  <td style="padding:6px;"><code>RedHat\java-11-openjdk-11.0.13-1\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://developers.redhat.com/products/openjdk/download">RedHat 17</a></td>
  <td style="padding:6px;"><code>RedHat\java-17-openjdk-17.0.1.0.12-1\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://sap.github.io/SapMachine/">SapMachine 11</a></td>
  <td style="padding:6px;"><code>SapMachine\JDK\11\</code></td>
</tr>
<tr>
  <td style="padding:6px;"><a href="https://sap.github.io/SapMachine/">SapMachine 17</a></td>
  <td style="padding:6px;"><code>SapMachine\JDK\17\</code></td>
</tr>
</table>
</dd></dl>

<span id="footnote_04">[4]</span> ***Batch file* `build.bat`** [↩](#anchor_04)

<dl><dd>
Command <a href="./Scala3First/build.bat"><code>build help</code></a> displays the batch file options and subcommands :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="./Scala3First/build.bat">build</a> help</b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -debug       print commands executed by this script
    -timer       print total execution time
    -verbose     print progress messages
&nbsp;
  Subcommands:
    clean        delete generated files
    help         print this help message
    install      execute Windows installer scala3
    link         create Windows installer from WXS/WXI/WXL files
    remove       remove installed program (same as uninstall)
    uninstall    remove installed program
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[firegiant]: https://www.firegiant.com/
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[scala3]: https://dotty.epfl.ch
[scala3_releases]: https://github.com/lampepfl/dotty/releases
[scala3_zip]: https://github.com/lampepfl/dotty/releases/tag/3.3.0
[windows_program_files]: https://en.wikipedia.org/wiki/Program_Files
[windows_settings]: https://support.microsoft.com/en-us/windows/find-settings-in-windows-10-6ffbef87-e633-45ac-a1e8-b7a834578ac6
[windows_start_menu]: https://support.microsoft.com/en-us/windows/see-what-s-on-the-start-menu-a8ccb400-ad49-962b-d2b1-93f453785a13
[wix_candle]: https://wixtoolset.org/documentation/manual/v3/overview/candle.html
[wix_component]: https://wixtoolset.org/documentation/manual/v3/xsd/wix/component.html
[wix_heat]: https://wixtoolset.org/documentation/manual/v3/overview/heat.html
[wix_light]: https://wixtoolset.org/documentation/manual/v3/overview/light.html
[wix_toolset]: https://wixtoolset.org/
