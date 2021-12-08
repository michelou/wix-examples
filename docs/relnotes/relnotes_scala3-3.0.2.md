### Release notes &ndash; `scala3-3.0.2.msi`

#### General informations : 
- `scala3-3.0.2.msi` (32 MB) is a [*self-signed*](https://en.wikipedia.org/wiki/Self-signed_certificate) Windows installer built from [`scala3-3.0.2.zip`](https://github.com/lampepfl/dotty/releases/tag/3.0.2) (31 MB).
- The [installation context](https://docs.microsoft.com/en-us/windows/win32/msi/installation-context) is *per-machine*, **not** *per-user*.
- The installation targets 64-bit Windows systems (MS Windows 7 or newer).
- The project description is available on page [`README.md`](../scala3-examples/README.md) (GitHub project [`michelou/wix-examples`](https://github.com/michelou/wix-examples)).

#### What if a Scala 3 installation is already present ?
The Windows installer behaves in *3 different ways* when it detects a [Scala 3](https://dotty.epfl.ch) installation on the user machine :
- if the version to be installed is ***newer than*** the version found on the machine then the Windows installer removes the old version and installs the new one.
- if the version to be installed is ***older than*** the version found on the machine then the Windows installer does exit.
- if the version to be installed is ***the same as*** the version found on the machine then the user is asked for a change, repair or remove operation.

#### The execution of the Scala 3 Windows installer : 
- triggers an elevation of privileges (tested many times but "*usage at your own risk*" disclaimer).
- installs the application files to the selected destination folder (default location is : `C:\Program Files\Scala 3\`).
- adds the wrapper script [`bin\repl.bat`](../scala3-examples/Scala3First/src/resources/repl.bat) which gives direct access to the [Scala 3 REPL](../scala3-examples/images/Scala3First_REPL.png).
- creates shortcuts under the Start Menu folder "[Scala 3](../scala3-examples/images/Scala3First_Menu.png)".
- adds variable `SCALA3_HOME` to the Windows *system environment* (tested on Win10 Pro/Home).
- appends path `%SCALA3_HOME%\bin\` to the system variable `PATH`.

***Work in progress*** Some parts need further development : 
- ~~more work with the feature tree in the "Custom Setup" dialog window~~
- ~~handling of upgrade installations (downgrading is not considered)~~
- [Scala 3 API](https://scala-lang.org/api/3.x/) documentation is currently not part of the installer (unlike [Scala 2 installer](https://scala-lang.org/files/archive/))
