[CmdletBinding()]
Param (
    [ValidateSet('3.0.2', '3.1.0')]
    [string]$version = '3.1.0',
    [ValidateSet('md5', 'sha256')]
    [string]$algorithm = 'md5'
)
$TempFolder = Join-Path $env:TEMP -ChildPath 'checksum-scala3'
if (-Not (Test-Path -Path $TempFolder)) {
    New-Item -Path $TempFolder -ItemType Directory
}
$MsiName = "scala3-$version.msi";
$MsiUri = "https://github.com/michelou/wix-examples/releases/download/scala3-$version.msi/$MsiName";
$MsiFile = Join-Path -Path $TempFolder -ChildPath $MsiName;

$Md5Name = "$MsiName.$algorithm";
$Md5Uri = "$MsiUri.$algorithm";
$Md5File = Join-Path -Path $TempFolder -ChildPath $Md5Name;

$ProgressPreference = 'SilentlyContinue'
Invoke-RestMethod -UserAgent 'Mozilla 5.0' -Uri $MsiUri -OutFile $MsiFile
Invoke-RestMethod -UserAgent 'Mozilla 5.0' -Uri $Md5Uri -OutFile $Md5File

$fh = Get-FileHash $MsiFile -Algorithm $algorithm;
$path = Get-Item $fh.Path;
$ComputedHash = $fh.Hash+'  '+$path.Basename+$path.Extension;
## Out-String option '-NoNewline' only available in PowerShell 6.0
$Md5Hash = Get-Content -Path $Md5File -First 1 | Out-String
$Md5Hash = $Md5Hash.Substring(0, $ComputedHash.length)

Write-Host 'Computed:'$ComputedHash
Write-Host 'MD5 file:'$Md5Hash
if ($ComputedHash.Equals($Md5Hash)) {
    Write-Host 'Both checksums are equal';
} else {
    Write-Host 'Both checksums differ';
}
