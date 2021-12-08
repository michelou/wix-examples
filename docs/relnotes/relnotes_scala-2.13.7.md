### Release notes &ndash; `scala-2.13.7.msi`

#### General informations :
- `scala-2.13.7.msi` (24 MB) is a [*self-signed*](https://en.wikipedia.org/wiki/Self-signed_certificate) Windows installer built from [`scala-2.13.7.zip`](https://scala-lang.org/files/archive/) (23 MB).
- The [installation context](https://docs.microsoft.com/en-us/windows/win32/msi/installation-context) is *per-machine*, **not** *per-user*.
- The installation targets 64-bit Windows systems (MS Windows 7 or newer).
- The project description is available on page [`README.md`](../scala2-examples/README.md) (GitHub project [`michelou/wix-examples`](https://github.com/michelou/wix-examples)).

#### What if a Scala 2 installation is already present ?
The Windows installer behaves in *3 different ways* when it detects a [Scala 2](https://www.scala-lang.org/) installation on the user machine :
- if the version to be installed is ***newer than*** the version found on the machine then the Windows installer removes the old version and installs the new one.
- if the version to be installed is ***older than*** the version found on the machine then the Windows installer does exit.
- if the version to be installed is ***the same as*** the version found on the machine then the user is asked for a change, repair or remove operation.

#### The execution of the Scala 2 Windows installer :
- triggers an elevation of privileges (tested many times but "*usage at your own risk*" disclaimer).
- installs the application files to the selected destination folder (*default* location is : `C:\Program Files\Scala 2\`).
- adds the wrapper script [`bin\repl.bat`](../scala2-examples/Scala2First/src/resources/repl.bat) which gives direct access to the [Scala 2 REPL](../scala2-examples/images/Scala2First_REPL.png).
- creates shortcuts under the *Start Menu* folder "[Scala 2](../scala2-examples/images/Scala2First_StartMenu.png)".
- adds variable `SCALA_HOME` to the Windows *system environment* (tested on Win10 Pro/Home).
- appends path `%SCALA_HOME%\bin\` to the system variable `PATH`.

***Work in progress*** Some parts need further development : 
- ~~more work with the feature tree in the "Custom Setup" dialog window~~
- ~~handling of upgrade installations (downgrading is not considered)~~
- [Scala 2 API](https://www.scala-lang.org/api/current/) documentation is currently not part of the installer (unlike the official [Scala 2 installer](https://scala-lang.org/files/archive/))
