# <span id="top">Running WiX on Microsoft Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://wixtoolset.org/" rel="external"><img src="./docs/wixtoolset.png" width="100" alt="WiX project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://wixtoolset.org/" rel="external">WiX</a> code examples coming from various websites and books.<br/>
  It also includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with <a href="https://wixtoolset.org/" rel="external">WiX</a> on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

[Deno][deno_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Python][python_examples], [Rust][rust_examples], [Scala 3][scala3_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** plaform:

- [Git 2.33][git_downloads] ([*release notes*][git_relnotes])
- [WiX 3.11][wix3_downloads] ([*release notes*][wix3_relnotes])

Optionally one may also install the following software:

- [ImageMagick 7.1][magick_downloads] <sup id="anchor_01"><a href="#footnote_01">1</a></sup> ([*change log*][magick_changelog])
- [Microsoft Visual Studio Community 2019][vs2019_downloads] <sup id="anchor_02"><a href="#footnote_02">2</a></sup> ([*release notes*][vs2019_relnotes])

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*similar to* the [`/opt/`][linux_opt] directory on Unix).

For instance our development environment looks as follows (*November 2021*) <sup id="anchor_03"><a href="#footnote_03">3</a></sup>:

<pre style="font-size:80%;">
C:\opt\Git-2.33.1\             <i>(279 MB)</i>
C:\opt\ImageMagick-7.1.0-Q16\  <i>(300 MB)</i>
C:\opt\WiX-3.11.2\             <i>( 99 MB)</i>
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\  <i>(2.98 GB)</i>
</pre>

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**][git_docs] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span>

This project is organized as follows:
<pre style="font-size:80%;">
bin\
examples\
firegiant-examples\{<a href="./firegiant-examples/SampleFirst">SampleFirst</a>, etc.}
<a href="QUICKREF.md">QUICKREF.md</a>
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="SETUP.md">SETUP.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`bin\`**](bin/) contains utility batch scripts.
- directory [**`examples\`**](examples/) contains [WiX] code examples (see [`README.md`](examples/README.md) file).
- directory [**`firegiant-examples\`**](firegiant-examples/) contains [WiX] code examples from [FireGiant] (see [`README.md`](firegiant-examples/README.md) file).
- file [**`QUICKREF.md`**](QUICKREF.md) is our [WiX] quick reference.
- file **`README.md`** is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`SETUP.md`**](SETUP.md) gives some [WiX] setup details.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

<pre style="font-size:80%;">
<b>&gt; <a href="./setenv.bat">setenv</a> -verbose</b>
Tool versions:
   candle 3.11.2.4516,
   magick 7.1.0-7, git 2.33.1.windows.1, diff 3.8
Tool paths:
   C:\opt\Wix-3.11.2\candle.exe
   C:\opt\WiX-3.11.2\light.exe
   C:\opt\ImageMagick-7.1.0-Q16\magick.exe
   C:\opt\Git-2.33.1\bin\git.exe
   C:\opt\Git-2.33.1\usr\bin\diff.exe
Environment variables:
   "GIT_HOME=C:\opt\Git-2.33.1"
   "MAGICK_HOME=C:\opt\ImageMagick-7.1.0-Q16"
   "WIX=C:\opt\WiX-3.11.2"
</pre>

## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***ImageMagick*** [↩](#anchor_01)

[ImageMagick] is free software to create, edit, compose, or convert digital images. In this project we rely on the [`convert`][magick_convert] tool to customize dialog windows in the generated Windows installer.

<b name="footnote_02">[2]</b> ***Visual Studio 2019*** [↩](#anchor_02)

[Microft Visual Studio 2019](https://visualstudio.microsoft.com/vs/older-downloads/) is the defacto IDE for devopping Microsoft Windows application (either console applications or GUI applications). In this project we use the [`MSBuild`](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild) tool to build a basic GUI application and the Windows installer to install it.

<b name="footnote_03">[3]</b> ***Downloads*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://imagemagick.org/script/download.php#windows">ImageMagick-7.1.0-portable-Q16-x64.zip</a>  <i>(111 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.33.1-64-bit.7z.exe</a>        <i>( 42 MB)</i>
vs_2019_community.exe                   <i>(1.7 GB)</i>
<a href="https://github.com/wixtoolset/wix3/releases">wix311-binaries.zip</a>                     <i>( 33 MB)</i>
</pre>
<p style="margin:0 0 1em 20px;">
Microsoft doesn't provide an offline installer for <a href="https://visualstudio.microsoft.com/vs/2019/">VS 2019</a> but we can follow the <a href="https://docs.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2019">following instructions</a> to create a local installer (so called <i>layout cache</i>) for later (re-)installation.
</p>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[cargo_cli]: https://doc.rust-lang.org/cargo/commands/cargo.html
[deno_examples]: https://github.com/michelou/deno-examples
[firegiant]: https://www.firegiant.com/
[git_docs]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[github_markdown]: https://github.github.com/gfm/
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.33.1.txt
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[haskell_examples]: https://github.com/michelou/haskell-examples
[imagemagick]: https://imagemagick.org/
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples
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
[python_examples]: https://github.com/michelou/python-examples
[rust_examples]: https://github.com/michelou/rust-examples
[scala3_examples]: https://github.com/michelou/dotty-examples
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[vs2019_downloads]: https://visualstudio.microsoft.com/vs/older-downloads/
[vs2019_relnotes]: https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix]: https://wixtoolset.org/
[wix3_downloads]: https://github.com/wixtoolset/wix3/releases
[wix3_relnotes]: https://github.com/wixtoolset/wix3/releases
[zip_archive]: https://www.howtogeek.com/178146/
