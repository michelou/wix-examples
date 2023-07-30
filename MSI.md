# <span id="top">MSI Files</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-development-tools" rel="external"><img src="./images/win-installer.png" width="100" alt=".msi files"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers resources related to <code>.msi</code> files (aka. <a href="https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-development-tools" rel="external">Windows installers</a>).
  </td>
  </tr>
</table>

MSI ("*Microsoft Silent Installer*") files are database files (with components and features) which are executed with the help of [`msiexec.exe`][msiexec_cmd]. MSI files are the current recommended method for installations on Microsoft Windows.

> **:mag_right:** Here are two discussion feeds for people interested in a deeper insight :
> - [The corporate benefits of using MSI files](https://serverfault.com/questions/11670/the-corporate-benefits-of-using-msi-files/274609)
> - [Difference Between MSI and EXE](https://askanydifference.com/difference-between-msi-and-exe/)


## <span id="databases">MSI are Databases</span>

In case we are suspicious about a Windows installer we can run the Windows command [`msiexec`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec) <sup id="anchor_01"><a href="#footnote_01">1</a></sup> to *extract* the files of the <a href="https://en.wikipedia.org/wiki/Cabinet_(file_format)"><code>.cab</code></a> archive(s) embedded in the <code>.msi</code> file (see also the [WiX element `media`](https://wixtoolset.org/documentation/manual/v3/xsd/wix/media.html)).

> **:mag_right:** Visit Microsoft's page [Released Versions of Windows Installer](https://docs.microsoft.com/en-us/windows/win32/msi/released-versions-of-windows-installer) to find the correspondance between Windows installer versions and MS Windows OS versions. For instance [`msiexec`][msiexec_cmd] has version 5.0 on MS Windows 7 and newer :
> <pre>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1">powershell</a> -c "(<a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-item?view=powershell-7.2">Get-Item</a> C:\Windows\System32\msiexec.exe).VersionInfo.ProductVersion"</b>
> 5.0.22621.1
> </pre>

## <span id="installers">Windows Installers</span>

The following table gives a small overview of Windows installers available for open-source (or free) software products <sup id="anchor_02"><a href="#footnote_02">2</a></sup> :

| MSI&nbsp;file  | Checksum | Signed | Name | Destination&nbsp;folder (<i>default</i>) |
|:---------------|:--------:|:------:|:----:|:-----------------------------------------|
| [`amazon-corretto-11.0.16.8.1-windows-x64.msi`](https://github.com/corretto/corretto-11/releases) | [`MD5`](https://github.com/corretto/corretto-11/releases) | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | Amazon.com Services LLC | `C:\Program Files\Amazon Corretto\` |
| [`calibre-64bit-6.2.1.msi`](https://github.com/kovidgoyal/calibre/releases) | <b>No</b> | Yes **<sup>(b)</sup>**| Kovid Goyal | `C:\Program Files\Calibre2\` |
| [`cmake-3.24.0-windows-x86_64.msi`](https://cmake.org/download/) | [`SHA256`](https://cmake.org/download/) | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | Kitware,&nbsp;Inc. | `C:\Program Files\CMake\` |
| [`cppcheck-2.8-x64-Setup.msi`](https://github.com/danmar/cppcheck/releases) | <span style="color:red;"><b>No</b></span> | <span style="color:red;"><b>No</b></span> | n.a. | `C:\Program Files\Cppcheck\` |
| [`GitHubDesktopSetup-x64.msi`](https://desktop.github.com/) | <b>No</b><br/><span style="font-size:70%;">([#8730](https://github.com/desktop/desktop/issues/8730))</span> | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | GitHub,&nbsp;Inc. | `C:\Program Files(x86)\GitHubDesktop\` |
| [`go1.19.windows-amd64.msi`](https://go.dev/dl/#stable) | [`SHA256`](https://go.dev/dl/#stable) | <span style="color:green;">Yes</span> **<sup>(a)</sup>** | Google LLC | `C:\Program Files\Go\` |
| [`java-1.8.0-openjdk-1.8.0.312-2.b07.dev.redhat.windows.x86_64.msi`](https://developers.redhat.com/products/openjdk/download) | <span style="color:red;"><b>No</b></span> | <span style="color:green;">Yes</span> **<sup>(b)</sup>** | Red Hat, Inc. | `C:\Program Files\RedHat\java-1.8.0-openjdk-1.8.0.312-2` |
| [`node-v16.16.0-x64.msi`](https://nodejs.org/en/download/) | [`SHA256`](https://nodejs.org/en/download/) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | OpenJS Foundation | `C:\Program Files\nodejs\` |
| [`OpenJDK8U-jdk_x64_windows_hotspot_8u312b07.msi`](https://adoptium.net/archive.html?variant=openjdk8&jvmVariant=hotspot) | [`SHA256`](https://adoptopenjdk.net/archive.html?variant=openjdk8&jvmVariant=hotspot) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | Eclipse.org Foundation, Inc. | `C:\Program Files\Eclipse Adoptium\jdk-8.0.312.7-hotspot\` |
| [`OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi`](https://adoptium.net/archive.html?variant=openjdk11&jvmVariant=hotspot) | [`SHA256`](https://adoptopenjdk.net/archive.html?variant=openjdk11&jvmVariant=hotspot) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | Eclipse.org Foundation, Inc. | `C:\Program Files\Eclipse Adoptium\jdk-11.0.13.8-hotspot\` |
| [`pandoc-2.19-windows-x86_64.msi`](https://pandoc.org/installing.html) | <span style="color:red;"><b>No</b></span> | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | John MacFarlane | `C:\Program Files\Pandoc\` |
| [`putty-64bit-0.76-installer.msi`](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) | [`MD5/SHA1`](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html#Checksum%20files)<br/>[`SHA256/SHA512`](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html#Checksum%20files) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | Simon Tatham | `C:\Program Files\PuTTY\`|
| [`rust-1.57.0-x86_64-pc-windows-msvc.msi`](https://forge.rust-lang.org/infra/other-installation-methods.html#standalone-installers) | [`GPG`](https://forge.rust-lang.org/infra/other-installation-methods.html#standalone-installers) | <span style="color:red;"><b>No</b></span> | n.a. | `C:\Program Files\Rust stable MSVC 1.57\`|
| [`sapmachine-jdk-11.0.14-ea.7_windows-x64_bin.msi`](https://github.com/SAP/SapMachine/releases) | [`SHA256`](https://github.com/SAP/SapMachine/releases) | <span style="color:red;"><b>No</b></span> | n.a. | `C:\Program Files\SapMachine\JDK\11\` |
| [`sbt-1.7.1.msi`](https://github.com/sbt/sbt/releases) | [`SHA256`](https://github.com/sbt/sbt/releases/tag/v1.7.1) | <span style="color:red;"><b>No</b></span> | n.a. | `C:\Program Files(x86)\sbt\` |
| [`scala-2.13.8.msi`](https://scala-lang.org/files/archive/)<br/>(<b>Lightbend's installer</b>) | <span style="color:red;"><b>No</b></span> | <span style="color:red;"><b>No</b></span> | n.a. | `C:\Program Files (x86)\scala\` |
| [`scala-2.13.8.msi`](https://github.com/michelou/wix-examples/releases)<br/>(<b>our installer</b>) | [`MD5/SHA256`](https://github.com/michelou/wix-examples/releases) | Yes<br/><span style="font-size:70%;">(self-signed)</span> | Stéphane Micheloud | `C:\Program Files\Scala 2\` |
| [`scala3-3.1.0.msi`](https://github.com/michelou/wix-examples/releases)<br/>(<b>our installer</b>) | [`MD5/SHA256`](https://github.com/michelou/wix-examples/releases) | Yes<br/><span style="font-size:70%;">(self-signed)</span> | Stéphane Micheloud | `C:\Program Files\Scala 3\` |
| [`TortoiseGit-2.13.0.1-64bit.msi`](https://tortoisegit.org/download/) | [`RSA`](https://download.tortoisegit.org/tgit/2.13.0.0/)**<sup>(d)</sup>** | <span style="color:green;">Yes</span> **<sup>(e)</sup>** | Open Source Developer | `C:\Program Files\TortoiseGit\` |
<div style="font-size:70%;"><b><sup>(a)</sup></b> Signer: <a href="https://www.digicert.com/kb/code-signing/signcode-signtool-command-line.htm">Digicert Timestamp 2021</a>.</div>
<div style="font-size:70%;"><b><sup>(b)</sup></b> Signer: Symantec SHA256 TimeStamping Signer - G3.</div>
<div style="font-size:70%;"><b><sup>(c)</sup></b> Signer: Sectigo RSA Time Stamping Signer #2.</div>
<div style="font-size:70%;"><b><sup>(d)</sup></b> DigiCert: <a href="https://knowledge.digicert.com/alerts/code-signing-new-minimum-rsa-keysize.html">RSA Code signing changes in 2021</a>.</div>
<div style="font-size:70%;"><b><sup>(e)</sup></b> Signer: <a href="https://www.certum.eu/en/cert_expertise_root_certificates/">Certum EV TSA SHA2</a>.<br/>&nbsp;</div>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> **`Administrative Installation`** [↩](#anchor_01)

<dl><dd>
With option <code>/a</code> the Windows command <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec"><code>msiexec</code></a> performs a so-called <a href="https://stackoverflow.com/questions/5564619/what-is-the-purpose-of-administrative-installation-initiated-using-msiexec-a">administrative installation</a>. In the following we give 4 examples to illustrate its usage.
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> msiexec</b>
C:\Windows\System32\msiexec.exe
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec" rel="external">msiexec</a> /a &lt;msi_file_path&gt; /qn TARGETDIR=c:\Temp\unpacked</b>
</pre>
</dd></dl>

> **:mag_right:** Options are:
> - `/a` - run administrative installation sequence.
> - `/qn` - run completely silently (alternatively: `/qb!` for semi-silent).
> - `/l*v "Extract.log"` - create verbose log file.
> - `TARGETDIR=<dir_path>` - extract files into `<dir_path>` (top level folder).

<dl><dd>
We first extract the contents of <a href="https://scala-lang.org/files/archive/"><code>scala-2.13.8.msi</code></a> - the <i>official</i> Scala 2 Windows installer - <i>renamed</i> here to <code>scala-2.13.8_epfl.msi</code> to avoid naming collision with our own <a href="./scala2-examples/README.md">Scala 2 Windows installer</a> :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a <a href="https://scala-lang.org/files/archive/">scala-2.13.8_epfl.msi</aS> ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f C:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   scala-2.13.8_epfl.msi
└───<b>PFiles</b>
    └───<b>scala</b>
        ├───<b>api</b>   <i>(600 MB !)</i>
        ├───<b>bin</b>
        ├───<b>doc</b>
        └───<b>lib</b>
</pre>
</dd></dl>

> **:mag_right:** We observe that 3 files/directories are <i>missing</i> compared to the corresponding Zip archive <a href="https://scala-lang.org/files/archive/"><code>scala-2.13.8.zip</code></a>, namely the two text files <code>LICENSE</code> and <code>NOTICE</code> and the subdirectory `man\`.

<dl><dd>
Now we look at the contents of our <a href="./scala2-examples/README.md">Scala 2 Windows installer</a> :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a <a href="https://github.com/michelou/wix-examples/releases/tag/scala-2.13.7.msi">scala-2.13.7.msi</a> ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f C:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   scala-2.13.8.msi
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
</dd>
<dd>
As next example we look at the contents of the sbt Windows installer named <a href="https://github.com/sbt/sbt/releases/tag/v1.9.3"><code>sbt-1.9.3.msi</code></a> : 
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a <a href="https://github.com/sbt/sbt/releases/tag/v1.9.3">sbt-1.9.3.msi</a> ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f c:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   sbt-1.9.3.msi
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
</dd></dl>

> **:mag_right:** We observe that the two *experimental* thin clients `sbtn-x86_64-apple-darwin` (MacOS executable) and `sbtn-x86_64-pc-linux` (Linux executable) are present in Zip file [`sbt-1.9.3.zip`](https://github.com/sbt/sbt/releases/tag/v1.9.3) but not in MSi file [`sbt-1.9.3.msi`](https://github.com/sbt/sbt/releases/tag/v1.9.3); that's fine !

<dl><dd>
Finally we extract the contents of the Java 11 Windows installer named <a href="https://adoptium.net/archive.html?variant=openjdk11&jvmVariant=hotspot"><code>OpenJDK11U-jdk_x64_windows_hotspot_11.0.16_8.msi</code></a> :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a OpenJDK11U-jdk_x64_windows_hotspot_11.0.16_8.msi ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f c:\Temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   OpenJDK11U-jdk_x64_windows_hotspot_11.0.16_8.msi
└───<b>Eclipse Adoptium</b>
    └───<b>jdk-11.0.16.8-hotspot</b>
        │   NOTICE
        │   release
        ├───<b>bin</b>
        ├───<b>conf</b>
        ├───<b>include</b>
        ├───<b>jmods</b>
        ├───<b>legal</b>
        └───<b>lib</b>
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***Software Distributions*** [↩](#anchor_02)

<dl><dd>
Software distributions can be installed in several ways, not necessarily using MSI files, for instance :
</dd>
<dd>
<table style="font-size:80%;">
<tr>
<th>Software distribution</th>
<th>Zip archive <sup><b>(a)</b></sup></td>
<th>Setup program <sup><b>(b)</b></sup></th>
<th>Package manager</th>
</tr>
<tr>
<td><a href="https://maven.apache.org/download.cgi#files">Apache Maven 3.9</a></td>
<td style="text-align:center;"><b>x</b></td>
<td></td>
<td></td>
</tr>
<tr>
<td><a href="https://github.com/bazelbuild/bazel/releases">Bazel 6.3</a></td>
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
<td><a href="https://gradle.org/install/">Gradle 7.6</a></td>
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
<td><a href="https://github.com/llvm/llvm-project/releases/tag/llvmorg-15.0.7">LLVM 15</a></td>
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
<td><a href="https://cran.r-project.org/bin/windows/base/">R 4.2.2</a></td>
<td></td>
<td style="text-align:center;"><b>x</b> <sup><b>(d)</b></sup></td>
<td></td>
</tr>
<tr>
<td><a href="https://code.visualstudio.com/download">VSCode 1.75</a></td>
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
<div style="font-size:80%;"><sup><b>(a)</b></sup> Sometimes both <code>.zip</code> and <code>.tar.gz</code> archives.</div>
<div style="font-size:80%;"><sup><b>(b)</b></sup> Windows executable (<code>.exe</code> extension).</div>
<div style="font-size:80%;"><sup><b>(c)</b></sup> On Windows <a href="https://sdkman.io/install">SDKMAN</a> (written in Bash) requires WSL, Cygwin or MSYS+MinGW.</div>
<div style="font-size:80%;"><b><sup>(d)</sup></b> Signer: Symantec SHA256 TimeStamping Signer - G3.<br/>&nbsp;</div>
</dd></dl>

<span id="footnote_03">[3]</span> ***MSI Resources*** [↩](#anchor_03)

<dl><dd>
<ul>
<li><a href="https://github.com/elastic/windows-installers">Elastic Windows Installer</a> - Windows installers for the Elastic stack.</li>
<li>&#128077; <a href="http://www.instedit.com/">InstEd</a> - a free MSI editor built for professionals.</li>
<li><a href="https://github.com/activescott/lessmsi">lessmi</a> - a tool to view and extract the contents of an Windows Installer.</li>
</ul>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2023* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[msiexec_cmd]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec
[project_elastic]: https://github.com/elastic/windows-installers
[tool_insted]: http://www.instedit.com/
[tool_lessmsi]: https://github.com/activescott/lessmsi
