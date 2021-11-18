# <span id="top">WiX examples with Scala 2 distribution</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://wixtoolset.org/" rel="external"><img style="border:0;width:120px;" src="../docs/wixtoolset.png" alt="WiX project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>scala2-examples\</code></strong> contains <a href="https://wixtoolset.org/" rel="external">WiX</a> examples written by ourself for creating a <a href="https://www.scala-lang.org/">Scala 2</a> Windows installer.
  </td>
  </tr>
</table>

The [WiX][wix_toolset] examples presented in the following sections
- share the same characteristics as the [WiX][wix_toolset] examples from page [examples/README.md](../examples/README.md).
- add the source file `Fragments.wxs` (generated *once* with the [`heat`][wix_heat] tool) which contains all references to the application files. 

## <span id="scala2_first">Scala2First</span>

Project `Scala2First` is our first iteration to create a Windows installer (aka. MSI file) for the [Scala 2][scala2_releases] software distribution.

The project directory is organized as follows :
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
Y:\examples\Scala2First
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f . | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   <a href="./Scala3First/build.bat">build.bat</a>
├───<b>app</b>
│   └───<i>files extracted from</i> <a href="https://www.scala-lang.org/download/2.13.7.html"><b>scala-2.13.7.zip</b></a>
└───<b>src</b>
    │   <a href="./Scala3First/src/Fragments.wxs">Fragments.wxs</a>
    │   <a href="./Scala3First/src/Scala3First.wxs">Scala2First.wxs</a>
    └───<b>resources</b>
            favicon.ico
            <a href="./Scala3First/src/resources/repl.bat">repl.bat</a>
</pre>

Command [`build link`](./Scala3First/build.bat) generates the [Scala 2][scala2] Windows installer with file name `scala-2.13.7.msi`.

> **:mag_right:** Command [`build help`](./Scala3First/build.bat) displays the batch file options and subcommands:

<pre style="font-size:80%;">
<b>&gt; <a href="./Scala3First/build.bat">build</a> clean link &amp;&amp; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f target | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   candle_opts.txt
│   candle_sources.txt
│   Fragments.wixobj
│   light_opts.txt
│   scala-2.13.7.msi
│   scala-2.13.7.wixpdb
│   Scala2First.wixobj
└───<b>src_gen</b>
        Fragments.wxs
        Fragments.wxs.txt  <i>(raw output from <a href="https://wixtoolset.org/documentation/manual/v3/overview/heat.html">heat</a>)</i>
        Scala2First.wxs
</pre>

> **:mag_right:** File `target\src_gen\Scala2First.wxs` in the above listing contains the real GUIDs instead of the symbol names defined in source file [`src\Scala2First.wxs`](./Scala2First/src/Scala2First.wxs).

Figures **1.1** to **1.4** below illustrate the updated user environment after the successful execution of the [Scala 2][scala2] Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2First_ProgFiles.png"><img style="max-width:180px;" src="images/Scala2First_ProgFiles.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.1 -</b> <i>Scala 2</i> directory<br>(<i>Program Files (x86)</i> folder).<br/>&nbsp;
  </div>
  <div>
  <a href="images/Scala2First_StartMenu.png"><img style="max-width:180px;" src="images/Scala2First_StartMenu.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.2 -</b> <i>Scala 2</i> shortcuts<br>(<i>Start Menu</i> folder).
  </div>
</td>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2First_REPL.png"><img style="max-width:180px;" src="images/Scala2First_REPL.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.3 -</b> <i>Scala 2</i> REPL<br>(<i>Start Menu</i> folder).<br/>&nbsp;
  </div>
</td>
<td style="text-align:center;">
  <a href="images/Scala2First_Uninstall.png"><img style="max-width:180px;" src="images/Scala2First_Uninstall.png" /></a>
  <div style="font-size:70%;"><b>Figure 1.4 -</b> Uninstall <i>Scala 2</i><br/>(<i>Settings</i> window).
</td>
</tr>
</table>

## <span id="scala2_sbt">Scala2Sbt</span>

In this example we rely on the sbt [Windows Plugin][sbt_windows_plugin] to generate the [Scala 2][scala2] Windows installer; this is the way the [Scala team][lightbend_scala] at Lightbend publishes the [Scala 2][scala2] Windows installer (see [Scala Archive](https://www.scala-lang.org/files/archive/)).

Figures **2.1** to **2.4** below illustrate the dialog windows of the Windows installer while Figure **2.5** shows the updated user environment after the successful execution of the [Scala 2][scala2] Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2Sbt_Setup1.png">
  <img style="max-width:180px;" src="images/Scala2Sbt_Setup1.png" alt="Welcome" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.1 -</b> Welcome<br>(<i>Scala 2</i> installer).<br/>&nbsp;
  </div>
  <div>
  <a href="images/Scala2Sbt_Setup2.png">
  <img style="max-width:180px;" src="images/Scala2Sbt_Setup2.png" alt="License" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.2 -</b> License<br>(<i>Scala 2</i> installer).
  </div>
</td>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2Sbt_Setup3.png">
  <img style="max-width:180px;" src="images/Scala2Sbt_Setup3.png" alt="Custom Setup" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.3 -</b> Custom Setup<br>(<i>Scala 2</i> installer).<br/>&nbsp;
  </div>
  <div>
  <a href="images/Scala2Sbt_Setup4.png">
  <img style="max-width:180px;" src="images/Scala2Sbt_Setup4.png" alt="Completed" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.4 -</b> Completed Installation<br>(<i>Scala 2</i> installer).
  </div>
</td>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2Sbt_ProgFiles.png">
  <img style="max-width:180px;" src="images/Scala2Sbt_ProgFiles.png" alt="Scala 2 directory" />
  </a>
  <div style="font-size:70%;"><b>Figure 2.5 -</b> <i>Scala 2</i> directory<br>(<i>Program Files (x86)</i> folder).
  </div>
</td>
</tr>
</table>

## <span id="scala2_ui">Scala2UI</span>

*wip*

Figures **3.1** to **3.4** below illustrate the dialog windows of the Windows installer while Figures **3.5** and **3.6** show the updated user environment after the successful execution of the [Scala 2][scala2] Windows installer.

<table>
<tr>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2UI_Setup1.png">
  <img style="max-width:180px;" src="images/Scala2UI_Setup1.png" alt="Welcome" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.1 -</b> Welcome<br>(<i>Scala 2</i> installer).<br/>&nbsp;
  </div>
  <div>
  <a href="images/Scala2UI_Setup2.png">
  <img style="max-width:180px;" src="images/Scala2UI_Setup2.png" alt="License" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.2 -</b> License<br>(<i>Scala 2</i> installer).
  </div>
</td>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2UI_Setup3.png">
  <img style="max-width:180px;" src="images/Scala2UI_Setup3.png" alt="Custom Setup" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.3 -</b> Custom Setup<br>(<i>Scala 2</i> installer).<br/>&nbsp;
  </div>
  <div>
  <a href="images/Scala2UI_Setup4.png">
  <img style="max-width:180px;" src="images/Scala2UI_Setup4.png" alt="Completed" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.4 -</b> Completed Installation<br>(<i>Scala 2</i> installer).
  </div>
</td>
<td style="text-align:center;">
  <div>
  <a href="images/Scala2UI_ProgFiles.png">
  <img style="max-width:180px;" src="images/Scala2UI_ProgFiles.png" alt="Scala 2 directory" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.5 -</b> <i>Scala 2</i> directory<br>(<i>Program Files (x86)</i> folder).<br/>&nbsp;
  </div>
  <div>
  <a href="images/Scala2UI_StartMenu.png">
  <img style="max-width:180px;" src="images/Scala2UI_StartMenu.png" alt="Scala 2 directory" />
  </a>
  <div style="font-size:70%;"><b>Figure 3.6 -</b> <i>Scala 2</i> directory<br>(<i>Program Files (x86)</i> folder).
  </div>
</td>
</tr>
</table>

<!--
## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***Default OpenJDK Location*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">

</p>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[firegiant]: https://www.firegiant.com/
[lightbend_scala]: https://www.lightbend.com/blog/scala-center
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[sbt_windows_plugin]: https://www.scala-sbt.org/sbt-native-packager/formats/windows.html
[scala2]: https://www.scala-lang.org/
[scala2_releases]: https://github.com/scala/scala/releases
[windows_program_files]: https://en.wikipedia.org/wiki/Program_Files
[windows_settings]: https://support.microsoft.com/en-us/windows/find-settings-in-windows-10-6ffbef87-e633-45ac-a1e8-b7a834578ac6
[windows_start_menu]: https://support.microsoft.com/en-us/windows/see-what-s-on-the-start-menu-a8ccb400-ad49-962b-d2b1-93f453785a13
[wix_candle]: https://wixtoolset.org/documentation/manual/v3/overview/candle.html
[wix_component]: https://wixtoolset.org/documentation/manual/v3/xsd/wix/component.html
[wix_heat]: https://wixtoolset.org/documentation/manual/v3/overview/heat.html
[wix_light]: https://wixtoolset.org/documentation/manual/v3/overview/light.html
[wix_toolset]: https://wixtoolset.org/
