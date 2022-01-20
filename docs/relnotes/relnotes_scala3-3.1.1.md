### Release notes &ndash; `scala3-3.1.1.msi`

#### General informations
- `scala3-3.1.1.msi` (103 MB) is a [*self-signed*](https://en.wikipedia.org/wiki/Self-signed_certificate) Windows installer built from [`scala3-3.1.1.zip`](https://github.com/lampepfl/dotty/releases/tag/3.1.1) (33 MB), [`scala3-library_3-3.1.1-javadoc.jar`](https://repo1.maven.org/maven2/org/scala-lang/scala3-library_3/3.1.1/) **and**  [`scala-library-2.13.6-javadoc.jar`](https://repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.6/).
- The [installation context](https://docs.microsoft.com/en-us/windows/win32/msi/installation-context) is *per-machine*, **not** *per-user*.
- The installer targets 64-bit Windows systems (MS Windows 7 or newer); it was tested on Win10 Pro/Home and Win11 Pro.
- The project description is available on page [`README.md`](../../scala3-examples/README.md) (GitHub project [`michelou/wix-examples`](https://github.com/michelou/wix-examples)).

#### What if a Scala 3 installation is already present ?
The Windows installer behaves in *3 different ways* when it detects a [Scala 3](https://dotty.epfl.ch) installation on the user machine :
- if the version to be installed is ***newer than*** the version found on the machine then the Windows installer removes the old version and installs the new one.
- if the version to be installed is ***older than*** the version found on the machine then the [Windows installer does exit](../../scala3-examples/images/Scala3Features_LaterAlreadyInstalled.png).
- if the version to be installed is ***the same as*** the version found on the machine then the user is asked for a [change, repair or remove operation](../../scala3-examples/images/Scala3Features_ChangeOrRepair.png).

#### Running the Scala 3 Windows installer does...
- trigger an elevation of privileges (tested many times but "*usage at your own risk*" disclaimer).
- install the application files to the selected destination folder (default location is : `C:\Program Files\Scala 3\`).
- add the small wrapper script [`bin\repl.bat`](../../scala3-examples/Scala3First/src/resources/repl.bat) which gives direct access to the [Scala 3 REPL](../../scala3-examples/images/Scala3First_REPL.png).
- <small>[<b>&cross;</b>]</small> create shortcuts under the Start Menu folder "[Scala 3](../../scala3-examples/images/Scala3First_Menu.png)".
- <small>[<b>&cross;</b>]</small> add variable `SCALA3_HOME` to the Windows *system environment*.
- <small>[<b>&cross;</b>]</small> append path `%SCALA3_HOME%\bin\` to the system variable `PATH`.
- <small>[<b>&cross;</b>]</small> install the API documentation to the selected destination folder (default location is : `C:\Program Files\Scala 3\`).

<dl><dd><ins>Note</ins>: <small>[<b>&cross;</b>]</small> Optional feature <i>enabled</i> by default.</dd></dl>