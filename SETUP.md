# <span id="top">WiX Setup</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://wixtoolset.org/"><img src="./docs/wixtoolset.png" width="100" alt="WiX project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document presents some <a href="https://wixtoolset.org//" rel="external">WiX</a> setup details on the Windows platform.
  </td>
  </tr>
</table>

The archive file [wix3x11-binaries.zip](https://github.com/wixtoolset/wix3/releases) is available from GitHub project [`wixtoolset/wix3`][wixtoolset_wix3]. We can just extract its contents to some location, e.g. into directory `C:\opt\WiX-3.11.2\` in our case:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/pushd">pushd</a> c:\opt\WiX-3.11.2&<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /ad/b&<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b *.exe&popd</b>
doc
sdk
x86
<a href="https://wixtoolset.org/documentation/manual/v3/overview/candle.html">candle.exe</a>    <i>(compiler)</i>
dark.exe
<a href="https://wixtoolset.org/documentation/manual/v3/overview/heat.html">heat.exe</a>      <i>(WXS generator)
insignia.exe
<a href="https://wixtoolset.org/documentation/manual/v3/overview/light.html">light.exe</a>     <i>(linker)</i>
lit.exe
lux.exe
melt.exe
nit.exe
pyro.exe
retina.exe
shine.exe
smoke.exe
ThmViewer.exe
torch.exe
WixCop.exe
</pre>

## <span id="variables">Environment Variables</span>

[WiX][wixtoolset_wix3] tools recognize several environment variables:
- `WIX` defines the path of the installation directory.
- `WIX_TEMP` overrides the temporary directory used for CAB creation, [MSM][microsoft_msm] exploding, etc.

> **:mag_right:** The WiX Burn Engine also offers a set of [built-in variables](https://wixtoolset.org/documentation/manual/v3/bundle/bundle_built_in_variables.html) to be used in WXS files.

In our case `WIX` is defined as follows:
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/echo">echo</a> %WIX%</b>
C:\opt\Wix-3.11.2
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[microsoft_msm]: https://docs.microsoft.com/en-us/windows/win32/msi/merge-module-database
[wixtoolset_wix3]: https://github.com/wixtoolset/wix3
