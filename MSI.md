# <span id="top">MSI Resources</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-development-tools" rel="external"><img src="./docs/win-installer.png" width="100" alt="Windows installers"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers resources related to <a href="https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-development-tools" rel="external">Windows installers</a> and <code>.msi</code> files.
  </td>
  </tr>
</table>

MSI ("*Microsoft Silent Installer*") files are database files (with components and features) which are executed with the help of ` msicexec.exe`. MSI files are the current recommended method for installations on Windows.

> **:mag_right:** Here are two discussion feeds for people interested in a deeper insight :
> - [The corporate benefits of using MSI files](https://serverfault.com/questions/11670/the-corporate-benefits-of-using-msi-files/274609)
> - [Difference Between MSI and EXE](https://askanydifference.com/difference-between-msi-and-exe/)

## <span id="installers">Windows Installers</span>

The following table shows a brief comparison of some Windows installers available for open-source (or free) software products <sup id="anchor_01"><a href="#footnote_01">1</a></sup> :

| MSI file     | Signed | Name | Destination folder <sup>(a)</sup> |
|:-------------|:------:|:------:|:-------------------|
| [`amazon-corretto-11.0.13.8.1-windows-x64.msi`](https://github.com/corretto/corretto-11/releases) | <span style="color:green;">Yes</span> **<sup>(b)</sup>** | Amazon.com Services LLC |  `C:\Program Files\Amazon Corretto\` |
| [`cmake-3.22.0-windows-x86_64.msi`](https://cmake.org/download/) | <span style="color:green;">Yes</span> **<sup>(b)</sup>** | Kitware,&nbsp;Inc. | `C:\Program Files\CMake\` |
| [`cppcheck-2.6-x64-Setup.msi`](https://github.com/danmar/cppcheck/releases) | <span style="color:red;">No</span> | n.a. | ? |
| [`GitHubDesktopSetup-x64.msi`](https://desktop.github.com/) | <span style="color:green;">Yes</span> **<sup>(b)</sup>** | GitHub,&nbsp;Inc. | ? |
| [`java-1.8.0-openjdk-1.8.0.312-2.b07.dev.redhat.windows.x86_64.msi`](http) | <span style="color:green;">Yes</span> **<sup>(c)</sup>** | Red Hat, Inc. | `C:\Program Files\RedHat\java-1.8.0-openjdk-1.8.0.312-2` |
| [`node-v16.13.0-x64.msi`](https://nodejs.org/en/download/) | <span style="color:green;">Yes</span> **<sup>(d)</sup>** | OpenJS Foundation | `C:\Program Files\nodejs\` |
| [`OpenJDK8U-jdk_x64_windows_hotspot_8u312b07.msi`](http) | <span style="color:green;">Yes</span> **<sup>(d)</sup>** | Eclipse.org Foundation, Inc. | ? |
| [`OpenJDK11U-jdk_x64_windows_hotspot_11.0.13_8.msi`](http) | <span style="color:green;">Yes</span> **<sup>(d)</sup>** | Eclipse.org Foundation, Inc. | ? |
| [`pandoc-2.16.2-windows-x86_64.msi`](https://pandoc.org/installing.html) | <span style="color:green;">Yes</span> **<sup>(d)</sup>** | John MacFarlane | `C:\Program Files\Pandoc\` |
| [`TortoiseGit-2.12.0.0-64bit.msi`](https://tortoisegit.org/download/) | <span style="color:green;">Yes</span> **<sup>(e)</sup>** | Open Source Developer | `C:\Program Files\TortoiseGit\` |
<div style="font-size:70%;"><b><sup>(a)</sup></b> Default location.</div>
<div style="font-size:70%;"><b><sup>(b)</sup></b> Signer: Digicert Timestamp 2021.</div>
<div style="font-size:70%;"><b><sup>(c)</sup></b> Signer: Symantec SHA256 TimeStamping Signer - G3.</div>
<div style="font-size:70%;"><b><sup>(d)</sup></b> Signer: Sectigo RSA Time Stamping Signer #2.</div>
<div style="font-size:70%;"><b><sup>(e)</sup></b> Signer: Certum EV TSA SHA2.</div>

## <span id="projects">Projects</span>

- [Elastic Windows Installer][project_elastic] - Windows installers for the Elastic stack.

## <span id="tools">Tools</span>
- &#128077; [InstEd][tool_insted] - a free MSI editor built for professionals.
- [lessmi][tool_lessmsi] - a tool to view and extract the contents of an Windows Installer.

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Software Distributions*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Several popular software distributions are only available as Zip archives, for instance :
</p>
<ul style="margin:0 0 1em 20px;">
<li><a href="https://maven.apache.org/download.cgi#files">Apache Maven 3.8</a> - a software project management tool.
<li><a href="https://github.com/denoland/deno/releases">Deno 1.x</a> - a modern runtime for JavaScript and TypeScript.</li>
</ul>
<p style="margin:0 0 1em 20px;">
For other popular software distributions the Windows installer is provided as an executable file (extension <code>.exe</code>) instead of a MSI file (extension <code>.msi</code>).
</p>
<ul style="margin:0 0 1em 20px;">
  <li><a href="https://www.python.org/downloads/release/python-3100/">Python 3.x</li>
</ul>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/December 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[project_elastic]: https://github.com/elastic/windows-installers
[tool_insted]: http://www.instedit.com/
[tool_lessmsi]: https://github.com/activescott/lessmsi
