# <span id="top">Playing with WiX Toolset on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://wixtoolset.org/" rel="external"><img src="./images/wixtoolset.png" width="100" alt="WiX project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://wixtoolset.org/" rel="external">Windows installer</a> examples coming from various websites and books.<br/>
  It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>) for experimenting with the <a href="https://wixtoolset.org/" rel="external">WiX Toolset</a> on a Windows machine.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [COBOL][cobol_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Erlang][erlang_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [Zig][zig_examples] are other topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** platform:

- [Git 2.45][git_downloads] ([*release notes*][git_relnotes])
- [WiX Toolset 3.14][wix3_downloads] ([*release notes*][wix3_relnotes])

Optionally one may also install the following software:

- [ConEmu 2023][conemu_downloads] ([*release notes*][conemu_relnotes])
- [ImageMagick 7.1][magick_downloads] <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([*change log*][magick_changelog])
- [InstEd 1.5][insted_downloads] <sup id="anchor_02"><a href="#footnote_02">2</a></sup> ([*release notes*][insted_relnotes])
- [Microsoft Visual Studio Community 2019][vs2019_downloads] <sup id="anchor_03"><a href="#footnote_03">3</a></sup> ([*release notes*][vs2019_relnotes])
- [Microsoft Windows 10 SDK][windows_sdk] <sup id="anchor_04"><a href="#footnote_04">4</a></sup> ([*release notes*][windows_sdk_relnotes])
- [Visual Studio Code 1.91][vscode_downloads] ([*release notes*][vscode_relnotes])

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*similar to* the [`/opt/`][linux_opt] directory on Unix).

For instance our development environment looks as follows (*July 2024*) <sup id="anchor_05">[5](#footnote_05)</sup>:

<pre style="font-size:80%;">
C:\opt\ConEmu\                 <i>( 26 MB)</i>
C:\opt\Git\                    <i>(314 MB)</i>
C:\opt\ImageMagick-7.1.0-Q16\  <i>(300 MB)</i>
C:\opt\VSCode\                 <i>(341 MB)</i>
C:\opt\WiX-3.14.1\             <i>(116 MB)</i>
C:\Program Files (x86)\instedit.com\InstEd\  <i>(  7 MB)</i>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\  <i>(2.98 GB)</i>
C:\Program Files (x86)\Windows Kits\10\      <i>(5.46 GB)</i>
</pre>

> **:mag_right:** [Git for Windows][git_scm] provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

This project is organized as follows:
<pre style="font-size:80%;">
<a href="./examples/docs">docs\</a>
examples\{<a href="./examples/README.md">README.md</a>, <a href="./examples/MiniAppKiller">MiniAppKiller</a>, <a href="./examples/uberAgent">uberAgent</a>}
firegiant-examples\{<a href="./firegiant-examples/README.md">README.md</a>, <a href="./firegiant-examples/SampleFirst">SampleFirst</a>, etc.}
myexamples\{<a href="./myexamples/README.md">README.md</a>, <a href="./myexamples/MyApp">MyApp</a>, etc.}
openjdk-examples\{<a href="./openjdk-examples/README.md">README.md</a>, <a href="./openjdk-examples/OpenJDK11">OpenJDK11</a>, etc.}
scala2-examples\{<a href="./scala2-examples/README.md">README.md</a>, <a href="./scala2-examples/Scala2First">Scala2First</a>, <a href="./scala2-examples/Scala2UI">Scala2UI</a>, etc.}
scala3-examples\{<a href="./scala3-examples/README.md">README.md</a>, <a href="./scala3-examples/Scala3First">Scala3First</a>, <a href="./scala3-examples/Scala3UI">Scala3UI</a>, etc.}
<a href="MSI.md">MSI.md</a>
<a href="QUICKREF.md">QUICKREF.md</a>
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="SECURITY.md">SECURITY.md</a>
<a href="SETUP.md">SETUP.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`docs\`**](docs/) contains [WiX] related papers/articles.
- directory [**`examples\`**](examples/) contains [WiX] examples (see [`README.md`](examples/README.md) file).
- directory [**`firegiant-examples\`**](firegiant-examples/) contains [WiX] examples from [FireGiant] (see [`README.md`](firegiant-examples/README.md) file).
- directory [**`myexamples\`**](myexamples/) contains [WiX] examples (see [`README.md`](myexamples/README.md) file).
- directory [**`openjdk-examples\`**](openjdk-examples/) contains [WiX] examples for creating [OpenJDK]() installers (see [`README.md`](openjdk-examples/README.md) file).
- directory [**`scala2-examples\`**](scala2-examples/) contains [WiX] examples for creating [Scala 2][scala2] installers (see [`README.md`](scala2-examples/README.md) file).
- directory [**`scala3-examples\`**](scala3-examples/) contains [WiX] examples for creating [Scala 3][scala3] installers (see [`README.md`](scala3-examples/README.md) file).
- file [**`MSI.md`**](MSI.md) provides some insight into MSI files.
- file [**`QUICKREF.md`**](QUICKREF.md) is our [WiX] quick reference.
- file **`README.md`** is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`SECURITY.md`**](SECURITY.md) answers the security concerns about `.msi` files.
- file [**`SETUP.md`**](SETUP.md) gives some [WiX] setup details.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

## <span id="commands">Batch commands</span>

### **`setenv.bat`** <sup id="anchor_06">[6](#footnote_06)</sup>

Command [**`setenv.bat`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`code.cmd`**][code_cli] and [**`git.exe`**][git_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="./setenv.bat">setenv</a> -verbose</b>
Tool versions:
   candle 3.14.1.8722, light 3.14.1.8722,
   msiinfo 5.0, uuidgen v1.01, magick 7.1.0-7,
   git 2.45.2, diff 3.10, diff 3.10
Tool paths:
   C:\opt\WiX-3.14.1\candle.exe
   C:\opt\WiX-3.14.1\light.exe
   C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x86\MsiInfo.exe
   C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x86\uuidgen.exe
   C:\opt\ImageMagick-7.1.0-Q16\magick.exe
   C:\opt\Git\bin\git.exe
   C:\opt\Git\usr\bin\diff.exe
   C:\opt\Git\bin\bash.exe
Environment variables:
   "GIT_HOME=C:\opt\Git"
   "JAVA_HOME=C:\opt\jdk-temurin-11.0.23_9"
   "MAGICK_HOME=C:\opt\ImageMagick-7.1.0-Q16"
   "SBT_HOME=C:\opt\sbt"
   "WINSDK_HOME=C:\Program Files (x86)\Windows Kits\10"
   "WIX=C:\opt\WiX-3.14.1"
&nbsp;
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> msiinfo git</b>
C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x86\MsiInfo.exe
C:\opt\Git\bin\git.exe
C:\opt\Git\mingw64\bin\git.exe
</pre>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***ImageMagick*** [↩](#anchor_01)

<dl><dd>
<a href="https://imagemagick.org/ rel="external">ImageMagick</a> is a free software to create, edit, compose, or convert digital images. In this project we rely on the <a href="https://imagemagick.org/script/convert.php" rel="external"><code>convert</code></a> tool to customize the dialog windows in the generated Windows installer.
</dd></dl>

<span id="footnote_02">[2]</span> ***InstEd*** [↩](#anchor_02)

<dl><dd>
<a href="http://www.instedit.com/download.html">InstEd</a> is a free MSI editor built for professionals. In this project we use that tool to inspect Windows installers available for other software products, e.g.
</dd>
<dd>
<ul>
  <li><a href="https://github.com/corretto/corretto-11/releases"><code>amazon-corretto-11.0.18.10.1-windows-x64.msi</code></a>
  <li><a href="https://developers.redhat.com/products/openjdk/download"><code>java-1.8.0-openjdk-1.8.0.362-1.b08.redhat.windows.x86_64.msi</code></a></li>
  <li><a href="https://adoptium.net/"><code>OpenJDK8U-jdk_x64_windows_hotspot_8u312b07.msi</code></a></li>
</ul>
</dd></dl>

<span id="footnote_03">[3]</span> ***Visual Studio 2019*** [↩](#anchor_03)

<dl><dd>
<a href="https://visualstudio.microsoft.com/vs/older-downloads/">Microsoft Visual Studio 2019</a> is the defacto <a href="https://en.wikipedia.org/wiki/Integrated_development_environment">IDE</a> for devopping Microsoft Windows application (either console applications or <a href="https://en.wikipedia.org/wiki/Graphical_user_interface">GUI</a> applications). In this project we use the <a href="https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild">MSBuild</a> tool to build a basic GUI application and the <a href="https://wixtoolset.org/" rel="external">WiX Toolset</a> to create a Windows installer.
</dd></dl>

<span id="footnote_04">[4]</span> ***Windows SDK*** [↩](#anchor_04)

<dl><dd>
The <a href="https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/" rel="external">Windows SDK</a> provides libraries and tools for building Windows applications; for instance <a href="https://docs.microsoft.com/en-us/windows/win32/seccrypto/signtool" rel="external"><code>signtool.exe</code></a> is the security tool we use in this project to sign the generated Windows installers.
</dd></dl>

<span id="footnote_05">[5]</span> ***Downloads*** [↩](#anchor_05)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/Maximus5/ConEmu/releases/tag/v23.07.24" rel="external">ConEmuPack.230724.7z</a>                    <i>(  5 MB)</i>
<a href="https://imagemagick.org/script/download.php#windows">ImageMagick-7.1.0-portable-Q16-x64.zip</a>  <i>(111 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.45.2-64-bit.7z.exe</a>        <i>( 44 MB)</i>
vs_2019_community.exe                   <i>(1.7 GB)</i>
<a href="https://code.visualstudio.com/Download#" rel="external">VSCode-win32-x64-1.91.0.zip</a>             <i>(131 MB)</i>
<a href="https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/">winsdksetup.exe</a>                         <i>(  1 MB)</i>
<a href="https://github.com/wixtoolset/wix3/releases">wix314-binaries.zip</a>                     <i>( 39 MB)</i>
</pre>
</dd>
<dd>
Microsoft doesn't provide an offline installer for <a href="https://visualstudio.microsoft.com/vs/2019/">VS 2019</a> but we can follow the <a href="https://docs.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2019">following instructions</a> to create a local installer (so called <i>layout cache</i>) for later (re-)installation.
</dd></dl>

<span id="footnote_06">[6]</span> **`setenv.bat` *usage*** [↩](#anchor_06)

<dl><dd>
<a href=./setenv.bat><code><b>setenv.bat</b></code></a> has specific environment variables set that enable us to use command-line developer tools more easily.
</dd>
<dd>It is similar to the setup scripts described on the page <a href="https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell" rel="external">"Visual Studio Developer Command Prompt and Developer PowerShell"</a> of the <a href="https://learn.microsoft.com/en-us/visualstudio/windows" rel="external">Visual Studio</a> online documentation.
</dd>
<dd>
For instance we can quickly check that the two scripts <code>Launch-VsDevShell.ps1</code> and <code>VsDevCmd.bat</code> are indeed available in our Visual Studio 2019 installation :
<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/where" rel="external">where</a> /r "C:\Program Files (x86)\Microsoft Visual Studio" *vsdev*</b>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Launch-VsDevShell.ps1
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_end.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\vsdevcmd\core\vsdevcmd_start.bat
</pre>
</dd>
<dd>
Concretely, <code>setenv.bat</code> in our GitHub projects which depend on Visual Studio (e.g. <a href="https://github.com/michelou/cpp-examples"><code>michelou/cpp-examples</code></a>) do invoke <code>VsDevCmd.bat</code> (resp. <code>vcvarall.bat</code> for older Visual Studio versions) to setup the Visual Studio tools on the command prompt. 
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2024* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[cargo_cli]: https://doc.rust-lang.org/cargo/commands/cargo.html
[code_cli]: https://code.visualstudio.com/docs/editor/command-line
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[conemu_downloads]: https://github.com/Maximus5/ConEmu/releases
[conemu_relnotes]: https://conemu.github.io/blog/2023/07/24/Build-230724.html
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples
[erlang_examples]: https://github.com/michelou/erlang-examples#top
[flix_examples]: https://github.com/michelou/flix-examples#top
[firegiant]: https://www.firegiant.com/
[git_cli]: https://git-scm.com/docs/git
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_scm]: https://git-scm.com/
[github_markdown]: https://github.github.com/gfm/
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.45.2.txt
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[gui]: https://en.wikipedia.org/wiki/Graphical_user_interface
[haskell_examples]: https://github.com/michelou/haskell-examples#top
[imagemagick]: https://imagemagick.org/
[insted_downloads]: http://www.instedit.com/download.html
[insted_relnotes]: http://www.instedit.com/features2.html
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[m2_examples]: https://github.com/michelou/m2-examples#top
[magick_changelog]: https://imagemagick.org/script/changelog.php
[magick_convert]: https://imagemagick.org/script/convert.php
[magick_downloads]: https://imagemagick.org/script/download.php#windows
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[rust_examples]: https://github.com/michelou/rust-examples#top
[scala2]: https://www.scala-lang.org/download/scala2.html
[scala3]: https://www.scala-lang.org/download/scala3.html
[scala3_examples]: https://github.com/michelou/dotty-examples#top
[spark_examples]: https://github.com/michelou/spark-examples#top
[spring_examples]: https://github.com/michelou/spring-examples#top
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[vs2019_downloads]: https://visualstudio.microsoft.com/vs/older-downloads/
[vs2019_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates/
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_sdk]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
[windows_sdk_relnotes]: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/#relnote
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix]: https://wixtoolset.org/
[wix3_downloads]: https://github.com/wixtoolset/wix3/releases
[wix3_relnotes]: https://github.com/wixtoolset/wix3/releases
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/
