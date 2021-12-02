# <span id="top">Security of MSI files</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://en.wikipedia.org/wiki/Self-signed_certificate/" rel="external"><img src="docs/security.png" width="100" alt="Security"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document aims to response to the security concerns regarding Windows executables and, in our case, regarding <code>.msi</code> files (aka. Windows installers).<br/>We present several ways to address those concerns, e.g. with <a href="https://en.wikipedia.org/wiki/Self-signed_certificate/" rel="external">self-signed certificates</a>.
  </td>
  </tr>
</table>

*WIP*

<img src="images/Open_Executable_File.png" />


## <span id="checksums">File Checksums</span>

Checksums are used to verify the integrity of files downloaded from an external source, eg. a Windows installer. In this project we rely on two small PowerShell scripts to check the [Scala 2][scala2] and [Scala 3][scala3] Windows installers available on the [Releases](https://github.com/michelou/wix-examples/releases) page.

<pre style="margin:0 4em 0 0;font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1" rel="external">powershell</a> -nologo -f bin\<a href="bin/checksum-scala.ps1">checksum-scala.ps1</a></b>
Computed: 0350F37BE2C23608DB6BA34AB6A778E3  scala-2.13.7.msi
MD5 file: 0350F37BE2C23608DB6BA34AB6A778E3  scala-2.13.7.msi
Both checksums are equal

<b>&gt; <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_powershell_exe?view=powershell-5.1">powershell</a> -nologo -f bin\<a href="bin/checksum-scala3.ps1">checksum-scala3.ps1</a></b>
Computed: 5088FF0014D3A95825F3A9FC15EE3C21  scala3-3.1.0.msi
MD5 file: 5088FF0014D3A95825F3A9FC15EE3C21  scala3-3.1.0.msi
Both checksums are equal
</pre>

## <span id="msi">MSI files</span>

In case we are suspicious about a Windows installer we can run the command [`msiexec`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec) <sup id="anchor_01"><a href="#footnote_01">1</a></sup> to extract the files of the <a href="https://en.wikipedia.org/wiki/Cabinet_(file_format)"><code>.cab</code></a> archive(s) embedded in the <code>.msi</code> file.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> msiexec</b>
C:\Windows\System32\msiexec.exe

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a &lt;path_to_msi_file&gt; /qn TARGETDIR=c:\Temp\unpacked</b>
</pre>

## <span id="certificates">Self-signed Certificates</span>

*WIP*

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> **`msiexec`** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
We take <code>scala-2.13.7.msi</code> as first example :
</p>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a scala-2.13.7.msi ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   scala-2.13.7.msi
└───<b>Program Files</b>
    └───<b>Scala 2</b>
        │   LICENSE
        │   NOTICE
        ├───<b>bin</b>
        ├───<b>doc</b>
        ├───<b>lib</b>
        └───<b>man</b>
</pre>

<p style="margin:0 0 1em 20px;">
For comparison we give a second example with <code>OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi</code> :
</p>

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec">msiexec</a> /a OpenJDK11U-jdk_x64_w.._h.._11.0.13_8.msi ^<br/>          /qn TARGETDIR=c:\Temp\unpacked</b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f c:\temp\unpacked | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [a-z]</b>
│   OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi
│
└───<b>Eclipse Adoptium</b>
    └───jdk-11.0.13.8-hotspot
        │   NOTICE
        │   release
        ├───bin
        ├───conf
        ├───include
        ├───jmods
        ├───legal
        └───lib
</pre>

<span id="footnote_02">[2]</span> ***Articles*** [↩](#anchor_02)

- [6 OpenSSL command options that every sysadmin should know][article_critelli] by Anthony Critelli, March 2021.
- [Internet Safety: 7 Steps to Keeping Your Computer Safe on the Internet][article_notenboom] by A. Notenboom, March 2004.

<span id="footnote_03">[3]</span> ***Dev Links*** [↩](#anchor_03)

- [Released Versions of Windows Installer](https://docs.microsoft.com/en-us/windows/win32/msi/released-versions-of-windows-installer) (Microsoft Dev), July 2021.

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[article_critelli]: https://www.redhat.com/sysadmin/6-openssl-commands
[article_notenboom]: https://askleo.com/internet_safety_7_steps_to_keeping_your_computer_safe_on_the_internet/
[aaaa]: https://docs.microsoft.com/en-us/powershell/module/pki/new-selfsignedcertificate?view=windowsserver2019-ps
[scala2]: https://www.scala-lang.org/
[scala3]: https://dotty.epfl.ch
