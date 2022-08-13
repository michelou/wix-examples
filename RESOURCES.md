# <span id="top">WiX Toolset Resources</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://wixtoolset.org/" rel="external"><img src="./images/wixtoolset.png" width="100" alt="WiX Toolset"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This document gathers <a href="https://wixtoolset.org/" rel="external">WiX Toolset</a> related resources we have collected so far.
  </td>
  </tr>
</table>

## <span id="articles">Articles</span>

- [What is WiX Toolset & how to use it][article_nrird] by Heiswayi Nrird, May 2018.
- [Creating a Localized Windows Installer & Bootstrapper: Part 3][article_carlisle3] by Mike Carlisle, February 2013.
- [Creating a Localized Windows Installer & Bootstrapper: Part 2][article_carlisle2] by Mike Carlisle, February 2013.
- [A quick introduction: Create an MSI installer with WiX][article_moack] by Moack, December 2010.
- [Creating a Localized Windows Installer & Bootstrapper: Part 1][article_carlisle1] by Mike Carlisle, August 2010.
- [Automate Releases With MSBuild And WiX][article_hashimi] by Sayed Ibrahim Hashimi, March 2007.

## <span id="blogs">Blogs</span>

- [Real-World Example: WiX/MSI Application Installer][blog_klein] by Helge Klein, February 2021.
- [WiX Tips](https://sorceryforce.net/en/tips/wix) from Yuuichi Onodera :
  - [Create a Windows Installer "MSI" using WiX part2](https://sorceryforce.net/en/tips/wix-installer-create2), October 2021.
  - [Create a Windows Installer "MSI" using WiX part1](https://sorceryforce.net/en/tips/wix-installer-create1), April 2020.
  - [Set up WiX to create Windows Installer for program distribution](https://sorceryforce.net/en/tips/wix-setup), April 2020.
- [WiX setup saving user input values](https://siderite.dev/blog/wix-setup-windows-installer-saving-user.html/) by Siderite, November 2018.
- [WiX Software Blog](https://www.hass.de/category/software/wix) from Alexander Haas :
  - [How to create MSI packages with multilingual user interface (MUI) ?](https://www.hass.de/content/how-create-msi-packages-multilingual-user-interface-mui)
  - [How to create a MSI for deploying Fonts in Enterprise ?](https://www.hass.de/content/how-create-msi-deploying-fonts-enterprise), September 2016.
- [Variables and Conditional Statements in WiX][blog_kumar] by Arun Kumar, June 2014.
- [Joy of Setup](https://www.joyofsetup.com/) - Bob Arnson's blog :
  - [L10N/M10N: Localization minimization][blog_arnson_2013], February 2013.
  - [Simplifying WiX component authoring][blog_arnson_2009], December 2009.
- [Blog](https://robmensching.com/blog/) from Rob Mensching :
  - [The WiX toolset's "Remember Property" pattern][blog_mensching_2010], May 2010.
  - [How to escape the ampersand in WiX and MSI UI][blog_mensching_2008], April 2008.
- [Wix Blog](https://weblogs.sqlteam.com/mladenp/tags/wix-windows-installer-xml-toolset/) from Mladen Prajdić :
  - [WiX 3 Tutorial: Custom EULA License and MSI localization](https://weblogs.sqlteam.com/mladenp/2010/04/15/wix-3-tutorial-custom-eula-license-and-msi-localization/), April 2010.
  - [WiX 3 Tutorial: Generating file/directory fragments with Heat.exe](https://weblogs.sqlteam.com/mladenp/2010/02/23/wix-3-tutorial-generating-filedirectory-fragments-with-heat.exe/), February 2010.
  - [WiX 3 Tutorial: Understanding main WXS and WXI file](https://weblogs.sqlteam.com/mladenp/2010/02/17/wix-3-tutorial-understanding-main-wxs-and-wxi-file/), February 2010.
  - [WiX 3 Tutorial: Solution/Project structure and Dev resources](https://weblogs.sqlteam.com/mladenp/2010/02/11/wix-3-tutorial-solutionproject-structure-and-dev-resources/), February 2010.
- [Adding and Customizing Dialogs in WiX 3][blog_dizzy] by Dizzy, 2008.
- [WiX: A Better TALLOW – PARAFFIN (Part 3 of 3)][blog_robbin3] by John Robbins, October 2007.
- [WiX: The Pain of WiX (Part 2 of 3)][blog_robbin2] by John Robbins, October 2007.
- [WiX: Hints for New Users (Part 1 of 3)][blog_robbin1] by John Robbin, October 2007.

## <span id="books">Books</span>

- [WiX Cookbook][book_ramirez2] by Nick Ramirez, January 2015.<br/><span style="font-size:80%;">(Packt, ISBN 978-1-7843-9321-2, 260 pages)</span>
- [WiX 3.6: A Developer's Guide to Windows Installer XML][book_ramirez1] by Nick Ramirez, December 2012.<br/><span style="font-size:80%;">(Packt, ISBN 978-1-7821-6042-7, 488 pages)</span>
- [The Definitive Guide to Windows Installer][book_wilson] by Phil Wilson, April 2004.<br/><span style="font-size:80%;">(Apress, ISBN 978-1-59059-297-7, 320 pages)</span>

<!--
## <span id="community">Community</span>

- [The wix-users Archives](http://lists.wixtoolset.org/pipermail/wix-users-wixtoolset.org/) - the mailing list for questions/discussion about the [WiX Toolset][wix_toolset].
-->

## <span id="projects">Projects</span>

- [Adoptium WiX installer](https://github.com/adoptium/installer/tree/master/wix) - the Windows installer for OpenJDK binaries.
- [`cargo-wix`][cargo_wix] - a cargo subcommand to build Windows installers for Rust projects using the [WiX Toolset][wix_toolset].
- [`go-msi`][go_msi] - an easy way to generate MSI package for a Go project.
- [`iswix`](https://github.com/iswix-llc/iswix) - an industrial strength Windows installer XML application.
- [`sbt-native-packager`](https://github.com/sbt/sbt-native-packager) - a [sbt plugin][sbt_plugin] to build application packages in native formats.
- [`scala-dist`](https://github.com/scala/scala-dist) - morphs Maven artifact into a Scala distribution (zip, tar.gz, deb, rpm, and msi).
- [`wix-maven-plugin`](https://wix-maven.github.io/wix-maven-plugin/) - a Maven plugin to create Windows installers with [WiX toolset][wix_toolset].
- [`wixsharp`](https://github.com/oleg-shilo/wixsharp) - a framework for building a MSI or WiX source code using C# script files.

## <span id="tools">Tools</span>

- [CPack WIX Generator](https://cmake.org/cmake/help/v3.22/cpack_gen/wix.html) - WiX generator for [CMake](https://cmake.org/).
- &#128077; [InstEd](http://www.instedit.com/) - a free MSI editor built for professionals.
- [`msiexec`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/msiexec) - the official Microsoft command line tool to install, modify, and perform operations on Windows Installer.

## <span id="tutorials">Tutorials</span>

- &#128077; [From MSI to WiX][tutorial_shevchuck] by Alex Shevchuk, February 2008.
- [Windows Installer User's Guide](https://www.advancedinstaller.com/user-guide/windows-installer.html) by [Caphyon Srl](https://www.caphyon.com/).
- &#128077; [WiX Toolset Tutorial](https://www.firegiant.com/wix/tutorial/).

## <span id="videos">Videos</span>

- [How To Create Windows Installer MSI][video_angelsix] by AngelSix, October 2017.
- [Creating Professional Installations with WiX][video_ives] by  Steve Ives, October 2016.

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Installation settings*** [↩](#anchor_01)

<pre style="margin:0 0 1em 20px; font-size:80%;">
<b>&gt; type %USERPROFILE%\.rustup\settings.toml</b>
default_host_triple = "x86_64-pc-windows-msvc"
default_toolchain = "stable"
profile = "default"
version = "12"

[overrides]
</pre>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/August 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[article_carlisle1]: https://www.codeproject.com/Articles/103746/Creating-a-Localized-Windows-Installer-Bootstrappe
[article_carlisle2]: https://www.codeproject.com/Articles/103747/Creating-a-Localized-Windows-Installer-Bootstrap-2
[article_carlisle3]: https://www.codeproject.com/Articles/103749/Creating-a-Localized-Windows-Installer-Bootstrap-3
[article_hashimi]: https://docs.microsoft.com/en-us/archive/msdn-magazine/2007/march/automate-releases-with-msbuild-and-windows-installer-xml
[article_moack]: https://www.codeproject.com/Tips/105638/A-quick-introduction-Create-an-MSI-installer-with
[article_nrird]: https://heiswayi.nrird.com/get-started-with-wix-toolset
[blog_arnson_2009]: https://www.joyofsetup.com/2009/12/31/simplifying-wix-component-authoring/
[blog_arnson_2013]: https://www.joyofsetup.com/2013/02/06/l10nm10n-localization-minimization/
[blog_dizzy]: http://www.dizzymonkeydesign.com/blog/misc/adding-and-customizing-dlgs-in-wix-3/
[blog_klein]: https://helgeklein.com/blog/real-world-example-wix-msi-application-installer/
[blog_kumar]: https://arunpp.wordpress.com/2014/06/13/variables-conditional-statements-in-wix/
[blog_mensching_2008]: https://robmensching.com/blog/posts/2008/4/21/how-to-escape-the-ampersand-in-wix-and-msi-ui/
[blog_mensching_2010]: https://robmensching.com/blog/posts/2010/5/2/the-wix-toolsets-remember-property-pattern/
[blog_robbin1]: https://www.wintellect.com/wix-hints-for-new-users-part-1-of-3/
[blog_robbin2]: https://www.wintellect.com/wix-the-pain-of-wix-part-2-of-3/
[blog_robbin3]: https://www.wintellect.com/wix-a-better-tallow-paraffin-part-3-of-3/
[book_ramirez1]: https://www.packtpub.com/product/wix-3-6-a-developer-s-guide-to-windows-installer-xml/9781782160427
[book_ramirez2]: https://www.packtpub.com/product/wix-cookbook/9781784393212
[book_wilson]: https://link.springer.com/book/10.1007/978-1-4302-0676-7
[cargo_wix]: https://github.com/volks73/cargo-wix
[go_msi]: https://github.com/mh-cbon/go-msi
[sbt_plugin]: https://www.scala-sbt.org/1.x/docs/Plugins.html
[tutorial_shevchuck]: https://docs.microsoft.com/en-us/archive/blogs/alexshev/from-msi-to-wix
[video_angelsix]: https://youtu.be/6Yf-eDsRrnM
[video_ives]: https://youtu.be/usOh3NQO9Ms
[wix_toolset]: https://wixtoolset.org/
