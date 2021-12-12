[CmdletBinding()]
Param (
    [ValidateSet('3.0.2', '3.1.0')]
    [string]$version = '3.1.0',
    [ValidateSet('md5', 'sha256')]
    [string]$algorithm = 'md5'
)
$algorithm = $algorithm.ToUpper()

$TempFolder = Join-Path $env:TEMP -ChildPath 'checksum-scala3'
if (-Not (Test-Path -Path $TempFolder)) {
    New-Item -Path $TempFolder -ItemType Directory
}
$MsiName = "scala3-$version.msi";
$MsiUri = "https://github.com/michelou/wix-examples/releases/download/scala3-$version.msi/$MsiName";
$MsiFile = Join-Path -Path $TempFolder -ChildPath $MsiName;

$ChecksumName = "$MsiName.$algorithm";
$ChecksumUri = "$MsiUri.$algorithm";
$ChecksumFile = Join-Path -Path $TempFolder -ChildPath $ChecksumName;

$ProgressPreference = 'SilentlyContinue'
Invoke-RestMethod -UserAgent 'Mozilla 5.0' -Uri $MsiUri -OutFile $MsiFile
Invoke-RestMethod -UserAgent 'Mozilla 5.0' -Uri $ChecksumUri -OutFile $ChecksumFile

$fh = Get-FileHash $MsiFile -Algorithm $algorithm;
$path = Get-Item $fh.Path;
$ComputedHash = $fh.Hash+'  '+$path.Basename+$path.Extension;
## Out-String option '-NoNewline' only available in PowerShell 6.0
$ChecksumHash = Get-Content -Path $ChecksumFile -First 1 | Out-String
$ChecksumHash = $ChecksumHash.Substring(0, $ComputedHash.length)

Write-Host "Computed: $ComputedHash"
Write-Host "$algorithm file: $ChecksumHash"
if ($ComputedHash.Equals($ChecksumHash)) {
    Write-Host 'The two checksums are equal';
} else {
    Write-Host 'The two checksums differ';
}
