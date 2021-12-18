# <span id="top">MSI Files</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-development-tools" rel="external"><img src="./images/win-installer.png" width="100" alt=".msi files"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers resources related to <code>.msi</code> files (aka. <a href="https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-development-tools" rel="external">Windows installers</a>).
  </td>
  </tr>
</table>

MSI ("*Microsoft Silent Installer*") files are database files (with components and features) which are executed with the help of [`msiexec.exe`][msiexec_cmd]. MSI files are the current recommended method for installations on MS Windows.

> **:mag_right:** Here are two discussion feeds for people interested in a deeper insight :
> - [The corporate benefits of using MSI files](https://serverfault.com/questions/11670/the-corporate-benefits-of-using-msi-files/274609)
> - [Difference Between MSI and EXE](https://askanydifference.com/difference-between-msi-and-exe/)


## <span id="databases">MSI are Databases</span>

In case we are suspicious about a Windows installer we can run the Windows command [`msiexec`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec) <sup id="anchor_01"><a href="#footnote_01">1</a></sup> to *extract* the files of the <a href="https://en.wikipedia.org/wiki/Cabinet_(file_format)"><code>.cab</code></a> archive(s) embedded in the <code>.msi</code> file (see also the [WiX element `media`](https://wixtoolset.org/documentation/manual/v3/xsd/wix/media.html)).

> **:mag_right:** Visit Microsoft's page [Released Versions of Windows Installer](https://docs.microsoft.com/en-us/windows/win32/msi/released-versions-of-windows-installer) to find the correspondance between Windows installer versions and MS Windows OS versions. For instance [`msiexec`][msiexec_cmd] has version 5.0 on MS Windows 7 and newer :
> <pre>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1">powershell</a> -c "(<a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-item?view=powershell-7.2">Get-Item</a> C:\Windows\System32\msiexec.exe).VersionInfo.ProductVersion"</b>
> 5.0.19041.320
> </pre>

## <span id="installers">Windows Installers</span>

The following table gives a small overview of Windows installers available for open-source (or free) software products <sup id="anchor_02"><a href="#footnote_02">2</a></sup> :

| MSI&nbsp;file  | Signed | Name   | EULA | Destination&nbsp;folder (<i>default</i>) |
|:---------------|:------:|:------:|:----:|:----------------------------------|
| [`amazon-corretto-11.0.13.8.1-windows-x64.msi`](https://github.com/corretto/corretto-11/releases) | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | Amazon.com Services LLC |  | `C:\Program Files\Amazon Corretto\` |
| [`cmake-3.22.0-windows-x86_64.msi`](https://cmake.org/download/) | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | Kitware,&nbsp;Inc. |  | `C:\Program Files\CMake\` |
| [`cppcheck-2.6-x64-Setup.msi`](https://github.com/danmar/cppcheck/releases) | <span style="color:red;"><b>No</b></span> | n.a. |  | `C:\Program Files\Cppcheck\` |
| [`GitHubDesktopSetup-x64.msi`](https://desktop.github.com/) | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | GitHub,&nbsp;Inc. |  | `C:\Program Files(x86)\GitHubDesktop\` |
| [`java-1.8.0-openjdk-1.8.0.312-2.b07.dev.redhat.windows.x86_64.msi`](https://developers.redhat.com/products/openjdk/download) | <span style="color:green;">Yes</span> **<sup>(b)</sup>** | Red Hat, Inc. |  | `C:\Program Files\RedHat\java-1.8.0-openjdk-1.8.0.312-2` |
| [`node-v16.13.0-x64.msi`](https://nodejs.org/en/download/) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | OpenJS Foundation |  | `C:\Program Files\nodejs\` |
| [`OpenJDK8U-jdk_x64_windows_hotspot_8u312b07.msi`](https://adoptium.net/releases.html?variant=openjdk8&jvmVariant=hotspot) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | Eclipse.org Foundation, Inc. |  | `C:\Program Files\Eclipse Adoptium\jdk-8.0.312.7-hotspot\` |
| [`OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi`](https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | Eclipse.org Foundation, Inc. |  | `C:\Program Files\Eclipse Adoptium\jdk-11.0.13.8-hotspot\` |
| [`pandoc-2.16.2-windows-x86_64.msi`](https://pandoc.org/installing.html) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | John MacFarlane |  | `C:\Program Files\Pandoc\` |
| [`sapmachine-jdk-11.0.14-ea.7_windows-x64_bin.msi`](https://github.com/SAP/SapMachine/releases) | <span style="color:red;"><b>No</b></span> | n.a. | GNU GPL v2 | `C:\Program Files\SapMachine\JDK\11\` |
| [`sbt-1.5.7.msi`](https://github.com/sbt/sbt/releases/tag/v1.5.7) | <span style="color:red;"><b>No</b></span> | n.a. |  | `C:\Program Files(x86)\sbt\` |
| [`TortoiseGit-2.12.0.0-64bit.msi`](https://tortoisegit.org/download/) | <span style="color:green;">Yes</span> **<sup>(d)</sup>** | Open Source Developer |  | `C:\Program Files\TortoiseGit\` |
<div style="font-size:70%;"><b><sup>(a)</sup></b> Signer: <a href="https://www.digicert.com/kb/code-signing/signcode-signtool-command-line.htm">Digicert Timestamp 2021</a>.</div>
<div style="font-size:70%;"><b><sup>(b)</sup></b> Signer: Symantec SHA256 TimeStamping Signer - G3.</div>
<div style="font-size:70%;"><b><sup>(c)</sup></b> Signer: Sectigo RSA Time Stamping Signer #2.</div>
<div style="font-size:70%;"><b><sup>(d)</sup></b> Signer: <a href="https://www.certum.eu/en/cert_expertise_root_certificates/">Certum EV TSA SHA2</a>.</div>

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> **`Administrative Installation`** [↩](#anchor_01)

<dl><dd>
With option <code>/a</code> the Windows command <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec"><code>msiexec</code></a> performs a so-called <a href="https://stackoverflow.com/questions/5564619/what-is-the-purpose-of-administrative-installation-initiated-using-msiexec-a">administrative installation</a>. In the following we give 4 examples to illustrate its usage.
</dd></dl>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> msiexec</b>
C:\Windows\System32\msiexec.exe

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec" rel="external">msiexec</a> /a &lt;msi_file_path&gt; /qn TARGETDIR=c:\Temp\unpacked</b>
</pre>

> **:mag_right:** Options are:
> - `/a` - run administrative installation sequence.
> - `/qn` - run completely silently (alternatively: `/qb!` for semi-silent).
> - `/l*v "Extract.log"` - create verbose log file.
> - `TARGETDIR=<dir_path>` - destination path for file extraction (top level folder).

<dl><dd>
We first extract the contents of <a href="https://scala-lang.org/files/archive/"><code>scala-2.13.7.msi</code></a> - the <i>official</i> Scala 2 Windows installer - <i>renamed</i> here to <code>scala-2.13.7_epfl.msi</code> to avoid naming collision with our own <a href="./scala2-examples/README.md">Scala 2 Windows installer</a> :
</dd></dl>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a <a href="https://scala-lang.org/files/archive/">scala-2.13.7_epfl.msi</aS> ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f C:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   scala-2.13.7_epfl.msi
└───<b>PFiles</b>
    └───<b>scala</b>
        ├───<b>api</b>   <i>(600 MB !)</i>
        ├───<b>bin</b>
        ├───<b>doc</b>
        └───<b>lib</b>
</pre>

> **:mag_right:** We observe that 3 files/directories are <i>missing</i> compared to the corresponding Zip archive <a href="https://scala-lang.org/files/archive/"><code>scala-2.13.7.zip</code></a>, namely the two text files <code>LICENSE</code> and <code>NOTICE</code> and the subdirectory `man\`.

<dl><dd>
Now we look at the contents of our <a href="./scala2-examples/README.md">Scala 2 Windows installer</a> :
</dd></dl>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a <a href="https://github.com/michelou/wix-examples/releases/tag/scala-2.13.7.msi">scala-2.13.7.msi</a> ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f C:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   scala-2.13.7.msi
└───<b>PFiles</b>
    └───<b>Scala 2</b>
        │   LICENSE
        │   NOTICE
        ├───<b>api</b>   <i>(600 MB !)</i>
        ├───<b>bin</b>
        ├───<b>doc</b>
        ├───<b>lib</b>
        └───<b>man</b>
</pre>

<dl><dd>
As next example we look at the contents of the sbt Windows installer named <a href="https://github.com/sbt/sbt/releases/tag/v1.5.7"><code>sbt-1.5.7.msi</code></a> : 
</dd></dl>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a <a href="https://github.com/sbt/sbt/releases/tag/v1.5.7">sbt-1.5.7.msi</a> ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f c:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   sbt-1.5.7.msi
└───<b>PFiles</b>
    └───<b>sbt</b>
        │   LICENSE
        │   NOTICE
        ├───<b>bin</b>
        │       sbt
        │       sbt-launch.jar
        │       sbt.bat
        │       sbtn-x86_64-pc-win32.exe
        └───<b>conf</b>
                sbtconfig.txt
                sbtopts
</pre>

> **:mag_right:** We observe that the two *experimental* thin clients `sbtn-x86_64-apple-darwin` (MacOS executable) and `sbtn-x86_64-pc-linux` (Linux executable) are present in Zip file [`sbt-1.5.6.zip`](https://github.com/sbt/sbt/releases/tag/v1.5.6) but not in MSi file [`sbt-1.5.7.msi`](https://github.com/sbt/sbt/releases/tag/v1.5.7); that's fine !

<dl><dd>
Finally we extract the contents of the Java 11 Windows installer named <a href="https://adoptium.net/archive.html?variant=openjdk11&jvmVariant=hotspot"><code>OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi</code></a> :
</dd></dl>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f c:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi
└───<b>Eclipse Adoptium</b>
    └───<b>jdk-11.0.13.8-hotspot</b>
        │   NOTICE
        │   release
        ├───<b>bin</b>
        ├───<b>conf</b>
        ├───<b>include</b>
        ├───<b>jmods</b>
        ├───<b>legal</b>
        └───<b>lib</b>
</pre>

<span id="footnote_02">[2]</span> ***Software Distributions*** [↩](#anchor_02)

<dl><dd>
Software distributions can be installed in several ways, not necessarily using MSI files, for instance :
</dd></dl>

<table style="margin:0 0 0 20px;font-size:80%;">
<tr>
<th>Software distribution</th>
<th>Zip archive <sup><b>(a)</b></sup></td>
<th>Setup program <sup><b>(b)</b></sup></th>
<th>Package manager</th>
</tr>
<tr>
<td><a href="https://maven.apache.org/download.cgi#files">Apache Maven 3.8</a></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
<td></td>
</tr>
<tr>
<td><a href="https://github.com/bazelbuild/bazel/releases">Bazel 4.2</a></td>
<td style="text-align:center;"><b>x</b></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
</tr>
<tr>
<td><a href="https://github.com/denoland/deno/releases">Deno 1.x</a></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
<td><a href="https://formulae.brew.sh/formula/deno">Homebrew</a>, <a href="https://chocolatey.org/packages/deno">Chocolatery</a>, <a href="https://scoop.sh/">Scoop</a>, <a href="https://crates.io/crates/deno">Cargo</a></td>
</tr>
<tr>
<td><a href="https://gradle.org/install/">Gradle 4.2</a></td>
<td style="text-align:center;"><b>x</b></td>
<td style="text-align:center;"><b>x</b></td>
<td><a href="https://sdkman.io/">SDKMAN</a> <sup><b>(c)</b></sup></td>
</tr>
<tr>
<td><a href="https://julialang.org/downloads/#long_term_support_release">Julia 1.6</a></td>
<td style="text-align:center;"><b>x</b></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
</tr>
<tr>
<td><a href="https://github.com/llvm/llvm-project/releases/tag/llvmorg-13.0.0">LLVM 13</a></td>
<td></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
</tr>
<tr>
<td><a href="https://www.python.org/downloads/release/python-3100/">Python 3.10</a></td>
<td></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
</tr>
<tr>
<td><a href="https://code.visualstudio.com/download">VSCode 1.63</a></td>
<td style="text-align:center;"><b>x</b></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
</tr>
<tr>
<td><a href="https://github.com/wixtoolset/wix3/releases/tag/wix3112rtm">WiX Toolset 3.11</a></td>
<td style="text-align:center;"><b>x</b></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
</tr>
</table>
<div style="margin:0 0 0 20px;font-size:80%;"><sup><b>(a)</b></sup> Sometimes both <code>.zip</code> and <code>.tar.gz</code> archives.</div>
<div style="margin:0 0 0 20px;font-size:80%;"><sup><b>(b)</b></sup> Windows executable (<code>.exe</code> extension).</div>
<div style="margin:0 0 0 20px;font-size:80%;"><sup><b>(c)</b></sup> On Windows <a href="https://sdkman.io/install">SDKMAN</a> (written in Bash) requires WSL, Cygwin or MSYS+MinGW.<br/>&nbsp;</div>

<span id="footnote_03">[3]</span> **`MSI Resources`** [↩](#anchor_03)

- [Elastic Windows Installer][project_elastic] - Windows installers for the Elastic stack.
- &#128077; [InstEd][tool_insted] - a free MSI editor built for professionals.
- [lessmi][tool_lessmsi] - a tool to view and extract the contents of an Windows Installer.

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[msiexec_cmd]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec
[project_elastic]: https://github.com/elastic/windows-installers
[tool_insted]: http://www.instedit.com/
[tool_lessmsi]: https://github.com/activescott/lessmsi
