# <span id="top">WiX toolset examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://wixtoolset.org/" rel="external"><img style="border:0;width:120px;" src="../images/wixtoolset.png" alt="WiX toolset" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>myexamples\</code></strong> contains <a href="https://wixtoolset.org/" rel="external">WiX toolset</a> examples written by ourself.
  </td>
  </tr>
</table>

The [WiX][wix_toolset] examples presented in the following sections share the same project organization, i.e.
- directory `app\` contains the application files
- directory `src\` contains the [WiX][wix_toolset] source files and resource files
- batch file `build.bat` creates the Windows installer from the two input directories.
- output directory `target\` contains the generated `.msi`, `.msi.md5` <sup id="anchor_01"><a href="#footnote_01">1</a></sup> and `.msi.sha256` files.

## <span id="myapp">`MyApp`</span>

In this first example we aim to install a *single file*, concretely the Windows application `MyApp.exe`, accessible for all users and located in the *MyApp* directory inside the [*Program Files*][windows_program_files] system folder.

For that purpose we declare one single [component element][wix_component] in our [WiX][wix_toolset] source file [`MyApp.wxs`](./MyApp/src/MyApp.wxs); the component element belongs to the *MyApp* directory and refers to the above executable.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\myexamples\MyApp
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   <a href="./MyApp/build.bat">build.bat</a>          <i>(calls candle/light)</i>
├───<a href="./MyApp/app/"><b>app</b></a>
│   └───<a href="./MyApp/app/HelloWorld/"><b>HelloWorld</b></a>
│       │   <a href="./MyApp/app/HelloWorld/00download.txt">00download.txt</a>
│       │   <a href="./MyApp/app/HelloWorld/build.bat">build.bat</a>  <i>(calls MSBuild)</i>
│       │   <a href="./MyApp/app/HelloWorld/README.md">README.md</a>
│       └───<a href="./MyApp/app/HelloWorld/cpp/"><b>cpp</b></a>
│           │   <a href="./MyApp/app/HelloWorld/cpp/HelloWorld.sln">HelloWorld.sln</a>
│           │   <a href="./MyApp/app/HelloWorld/cpp/HelloWorld.vcxproj">HelloWorld.vcxproj</a>
│           └───<a href="./MyApp/app/HelloWorld/cpp/src/"><b>src</b></a>
│                   <a href="./MyApp/app/HelloWorld/cpp/src/main.cpp">main.cpp</a>
└───<a href="./MyApp/src/"><b>src</b></a>
        <a href="./MyApp/src/MyApp.wxs">MyApp.wxs</a>      <i>(with PUT-GUID-HERE placeholders)</i>
</pre>

> **:mag_right:** In order the have a *self-contained* example we include the [`HelloWorld`](./MyApp/HelloWorld/) subproject which contains a simple [Visual Studio solution][vs_solution] for generating `MyApp.exe` to be added to the *MyApp* Windows installer.

Our main batch file [`build.bat`](./MyApp/build.bat) invokes the [WiX][wix_toolset] tools [`candle`][wix_candle] (compiler) and [`light`][wix_light] (linker) with the appropriate settings and inputs.

<pre style="font-size:80%;">
<b>&gt; <a href="./MyApp/build.bat">build</a> -verbose install</b>
Generate executable "MyApp.exe"
Copy executable "MyApp.exe" to directory "Y:\myexamples\MyApp\app\"
Generate auxiliary WXS file
[...]
Compiling 1 WiX source file to directory "target"
Create Windows installer "target\MyApp-1.0.0.msi"
Execute Windows installer "target\MyApp-1.0.0.msi"
</pre>

Figures **1.1** and **1.2** below illustrate the updated user environment after the successful execution of the *MyApp* Windows installer.

> **:mag_right:** The user must navigate to the *Apps &amp; features* window in the *Windows Settings* in order to uninstall the *MyApp* application (**Figure 1.2**).

<table>
<tr>
<td style="text-align:center;">
  <a href="images/MyApp.png"><img style="max-width:180px;" src="images/MyApp.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.1 -</b> <i>MyApp</i> executable<br>(<i>Program Files</i> folder).
</td>
<td style="text-align:center;">
  <a href="images/MyApp_Uninstall.png"><img style="max-width:180px;" src="images/MyApp_Uninstall.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.2 -</b> Uninstall <i>MyApp</i><br/>(<i>Settings</i> window).
</td>
</tr>
</table>

## <span id="myapp_shortcuts">MyAppShortcuts</span>

This second example adds *Start Menu* shortcuts (see [WiX manual](https://wixtoolset.org/documentation/manual/v3/howtos/files_and_registry/create_start_menu_shortcut.html)) to the above [*MyApp*](#myapp) example.

We declare 3 components in our [WiX][wix_toolset] source file [`MyAppShortcuts.wxs`](./MyAppShortcuts/src/MyAppShortcuts.wxs) :
- component 1 refers to the `MyApp` executable (as in previous example).
- component 2 refers to the HTML file [`documentation.html`](./MyAppShortcuts/app/documentation.html).
- component 3 defines the two shortcuts `MyApp` and `Uninstall MyApp` (**Figure 2.2**).

> **:mag_right:** The user has now *two* possibilities to remove the *MyApp* application :
> - from the *Apps &amp; features* window in the [*Windows Settings*][windows_settings]
> - through the *Uninstall MyApp* shortcut in the [*Start Menu*][windows_start_menu] folder.

Figures **2.1** to **2.4** below illustrate the updated user environment after the successful execution of the *MyApp* Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <div>
  <a href="images/MyAppShortcuts.png"><img style="max-width:180px;" src="images/MyAppShortcuts.png" /></a>
  <div style="font-size:70%;"><b>Figure 2.1 -</b> <i>MyApp</i> executable<br/>(<i>Program Files</i> folder).<br/>&nbsp;
  </div>
  <div>
  <a href="images/MyAppShortcuts_StartMenu.png"><img style="max-width:180px;" src="images/MyAppShortcuts_StartMenu.png" /></a>
  <div style="font-size:70%;"><b>Figure 2.2 -</b> <i>MyApp</i> shortcuts<br/>(<a href="https://support.microsoft.com/en-us/windows/see-what-s-on-the-start-menu-a8ccb400-ad49-962b-d2b1-93f453785a13"><i>Start Menu</i></a> folder).
  </div>
</td>
<td style="text-align:center;">
  <a href="images/MyAppShortcuts_Uninstall.png"><img style="max-width:180px;" src="images/MyAppShortcuts_Uninstall.png" /></a>
  <div style="font-size:70%;"><b>Figure 2.3 -</b> Uninstall <i>MyApp</i><br/>(<i>Settings</i> window).
</td>
<td style="text-align:center;">
  <a href="images/MyAppShortcuts_Uninstall_Properties.png"><img style="max-width:180px;" src="images/MyAppShortcuts_Uninstall_Properties.png" /></a>
  <div style="font-size:70%;"><b>Figure 2.4 -</b> Shortcut properties<br/>(<i>Uninstall</i> shortcut).
</td>
</tr>
</table>

> :mag_right: <b>Figure 2.4</b> shows the window <i>Properties</i> of the *Uninstall* shortcut visible in <b>Figure 2.2</b>; in particular we can read in the field "Target" the GUID <sup id="anchor_02"><a href="#footnote_02">2</a></sup> value corresponding to `PRODUCT_CODE` in the file `build.properties`.
> <pre style="font-size:80%;">
> PRODUCT_CODE=C04AE4CF22B4403D97EDF523D3A1BD30
> PRODUCT_UPGRADE_CODE=...
> </pre>

## <span id="myapp_localized">MyAppLocalized</span>

Project `MyAppLocalized` adds language localization to the [WiX][wix_toolset] source files of the *MyApp* Windows installer.

This project contains the additional directory [`src\localizations\`](./MyAppLocalized/src/localizations/) with 3 [WiX localization files](https://wixtoolset.org//documentation/manual/v3/wixui/wixui_localization.html):

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\myexamples\MyAppLocalized
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   <a href="./MyAppLocalized/build.bat">build.bat</a>
├───<a href="./MyAppLocalized/app/"><b>app</b></a>
│   │   <a href="./MyAppLocalized/app/documentation.html">documentation.html</a>
│   └───<b>HelloWorld</b>
│           ... <i>(same as before)</i>
└───<a href="./MyAppLocalized/src/"><b>src</b></a>
    │   <a href="./MyAppLocalized/src/Includes.wxi">Includes.wxi</a>
    │   <a href="./MyAppLocalized/src/MyAppLocalized.wxs">MyAppLocalized.wxs</a>
    └───<a href="./MyAppLocalized/src/localizations/"><b>localizations</b></a>
            <a href="./MyAppLocalized/src/localizations/de-DE.wxl">de-DE.wxl</a>
            <a href="./MyAppLocalized/src/localizations/en-US.xwl">en-US.wxl</a>
            <a href="./MyAppLocalized/src/localizations/fr-FR.wxl">fr-FR.wxl</a>
            <a href="./MyAppLocalized/src/localizations/README.txt">README.txt</a>
</pre>

Command [`build link`](./MyAppLocalized/build.bat) generates a separate MSI file for each language localization, e.g. `MyApp-1.0.0-fr-FR.msi` is the french version of the *MyApp* Windows installer.

<pre style="font-size:80%;">
<b>&gt; <a href="./MyAppLocalized/build.bat">build</a> clean link &amp;&amp; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /a-d /b target</b>
candle_opts.txt
candle_sources.txt
light_opts.txt
MyApp-1.0.0.msi
MyApp-1.0.0.msi.md5
MyApp-1.0.0.msi.sha256
MyApp-1.0.0.wixpdb
MyApp-1.0.0_de-DE.msi
MyApp-1.0.0_de-DE.msi.md5
MyApp-1.0.0_de-DE.msi.sha256
MyApp-1.0.0_de-DE.wixpdb
MyApp-1.0.0_fr-FR.msi
MyApp-1.0.0_fr-FR.msi.md5
MyApp-1.0.0_fr-FR.msi.sha256
MyApp-1.0.0_fr-FR.wixpdb
MyAppLocalized.wixobj
</pre>

Figures **3.1** and **3.2** below illustrate the updated user environment after the successful execution of the *MyApp* Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <a href="images/MyAppLocalized_ProgFiles.png"><img style="max-width:180px;" src="images/MyAppLocalized_ProgFiles.png" /></a>
  <div style="font-size:70%;"><b>Figure 3.1 -</b> <i>MyApp</i> application<br>(<i>Program Files</i> folder).
</td>
<td style="text-align:center;">
  <a href="images/MyAppLocalized_StartMenu.png"><img style="max-width:180px;" src="images/MyAppLocalized_StartMenu.png" /></a>
  <div style="font-size:70%;"><b>Figure 3.2 -</b> <i>MyApp</i> shortcuts<br/>(<i>Start Menu</i> folder).
</td>
</tr>
</table>

## <span id="myapp_features">MyAppFeatures</span>

Project `MyAppFeatures` adds feature customization to the *MyApp* Windows installer.

*tbd*

<table>
<tr>
<td style="text-align:center;">
  <a href="images/MyAppFeatures_Welcome.png"><img style="max-width:180px;" src="images/MyAppFeatures_Welcome.png" /></a>
  <div style="font-size:70%;"><b>Figure 4.1 -</b> Welcome<br>(<i>MyApp</i> installer).
</td>
<td style="text-align:center;">
  <a href="images/MyAppFeatures_Custom.png"><img style="max-width:180px;" src="images/MyAppFeatures_Custom.png" /></a>
  <div style="font-size:70%;"><b>Figure 4.2 -</b> Custom Setup<br/>(<i>MyApp</i> installer).
</td>
</tr>
</table>


## <span id="footnotes">Footnotes</span>


<span id="footnote_01">[1]</span> ***File Checksums*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
We rely on the PowerShell cmdlet <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash" rel="external" title="Get-FileHash"><code>Get-FileHash</code></a> to generate <code>.md5</code> and <code>.sha256</code> checksum files. MD5 checksums can also be generated with command-line tools such as <a href="https://www.fourmilab.ch/md5/" rel="external" title="MD5">MD5</a> or <a href="http://www.pc-tools.net/win32/md5sums/" rel="external" title="MD5sums">MD5sums</a> (see also document <a href="../SECURITY.md"><code>SECURITY.md</code></a>).
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b> &gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1">powershell</a> -C "(<a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash" rel="external" title="Get-FileHash">Get-FileHash</a> 'target\MyApp-1.0.0.msi' -Algorithm md5).Hash"</b>
38C2F1D6F7FF5D40A75DAEA0950CF949
</pre>

<span id="footnote_02">[2]</span> ***GUID*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
A GUID is a 128-bit integer (16 bytes) that can be used across all computers and networks wherever a unique identifier is required. Such an identifier has a very low probability of being duplicated (<i>see also</i> the nice article series from <a href="https://ericlippert.com/about-eric-lippert/">Eric Lippert</a>'s <i>"Guid guide"</i>, <a href="https://ericlippert.com/2012/04/24/guid-guide-part-one/">part 1</a>, <a href="https://ericlippert.com/2012/04/30/guid-guide-part-two/">part 2</a> and <a href="https://ericlippert.com/2012/05/07/guid-guide-part-three/">part 3</a>).
</p>
<p style="margin:0 0 1em 20px;">
<a href="https://wixtoolset.org/">WiX</a> examples developed in this project rely on the PowerShell cmdlet <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid?view=powershell-7.2#examples"><code>New-Guid</code></a> to generate GUID values; for instance :
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1">powershell</a> -C <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid?view=powershell-7.2#examples">"(New-Guid).Guid"</a></b>
2d30a843-3eb2-497a-99a1-49a368bba5f7
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[MiniAppKiller]: https://heiswayi.nrird.com/get-started-with-wix-toolset
[uberAgent]: https://helgeklein.com/blog/real-world-example-wix-msi-application-installer/
[vs_solution]: https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-dot-sln-file?view=vs-2022
[windows_program_files]: https://en.wikipedia.org/wiki/Program_Files
[windows_settings]: https://support.microsoft.com/en-us/windows/find-settings-in-windows-10-6ffbef87-e633-45ac-a1e8-b7a834578ac6
[windows_start_menu]: https://support.microsoft.com/en-us/windows/see-what-s-on-the-start-menu-a8ccb400-ad49-962b-d2b1-93f453785a13
[wix_candle]: https://wixtoolset.org/documentation/manual/v3/overview/candle.html
[wix_component]: https://wixtoolset.org/documentation/manual/v3/xsd/wix/component.html
[wix_light]: https://wixtoolset.org/documentation/manual/v3/overview/light.html
[wix_toolset]: https://wixtoolset.org/
