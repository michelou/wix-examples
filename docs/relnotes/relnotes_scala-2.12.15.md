### Release notes &ndash; `scala-2.12.15.msi`

#### General informations
- `scala-2.12.15.msi` (88 MB) is a [*self-signed*](https://en.wikipedia.org/wiki/Self-signed_certificate) Windows installer built from [`scala-2.12.15.zip`](https://scala-lang.org/files/archive/) (20 MB) **and** [`scala-docs-2.12.15.zip`](https://scala-lang.org/files/archive/) (108 MB).
- The [installation context](https://docs.microsoft.com/en-us/windows/win32/msi/installation-context) is *per-machine*, **not** *per-user*.
- The installation targets 64-bit Windows systems (MS Windows 7 or newer).
- The project description is available on page [`README.md`](../../scala2-examples/README.md) (GitHub project [`michelou/wix-examples`](https://github.com/michelou/wix-examples)).

#### What if a Scala 2 installation is already present ?
The Windows installer behaves in *3 different ways* when it detects a [Scala 2](https://www.scala-lang.org/) installation on the user machine :
- if the version to be installed is ***newer than*** the version found on the machine then the Windows installer removes the old version and installs the new one.
- if the version to be installed is ***older than*** the version found on the machine then the [Windows installer does exit](../../scala2-examples/images/Scala2Features_LaterAlreadyInstalled.png).
- if the version to be installed is ***the same as*** the version found on the machine then the user is asked for a [change, repair or remove operation](../../scala2-examples/images/Scala2Features_ChangeOrRepair.png).

#### Running the Scala 2 Windows installer does...
- trigger an elevation of privileges (tested many times but "*usage at your own risk*" disclaimer).
- install the application files to the selected destination folder (*default* location is : `C:\Program Files\Scala 2\`).
- add the small wrapper script [`bin\repl.bat`](../../scala2-examples/Scala2First/src/resources/repl.bat) which gives direct access to the [Scala 2 REPL](../../scala2-examples/images/Scala2First_REPL.png).
- create shortcuts under the *Start Menu* folder "[Scala 2](../../scala2-examples/images/Scala2First_StartMenu.png)".
- add variable `SCALA_HOME` to the Windows *system environment* (tested on Win10 Pro/Home).
- append path `%SCALA_HOME%\bin\` to the system variable `PATH`.
<!--
***Not yet implemented***
- [Scala 2 API](https://www.scala-lang.org/api/current/) documentation is currently not part of the installer (unlike the official [Scala 2 Windows installer](https://scala-lang.org/files/archive/)).
-->
