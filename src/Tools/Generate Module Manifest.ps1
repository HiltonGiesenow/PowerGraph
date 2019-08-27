$version = "0.0.2"
$manifestPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "..\PowerGraph365\PowerGraph365.psd1"

Remove-Item -Path $manifestPath -ErrorAction SilentlyContinue

$description = "PowerGraph 365 is a PowerShell library for interacting with the Microsoft Graph"

$releaseNotes = "
0.0.2
* Updating to latest version of MSAL for Daemon login

0.0.1
* Initial release.
"

$tags = @(
    'Office',
    'OfficeGraph'
    'Microsoft',
    'MicrosoftGraph',
    'Graph',
    '365',
    'Office365',
    'O365',
    'PowerGraph',
    'Planner',
    'Groups',
    'OneDrive',
    'Teams',
    'SharePoint',
    'Online',
    'SharePointOnline',
    'Intune'
)

New-ModuleManifest -Path $manifestPath -ModuleVersion $version -RootModule "PowerGraph365.psm1" -Guid '3d4fe3d7-46d7-418f-8979-1f7b36b3dd35' -Author "Hilton Giesenow" -CompanyName "Experts Inside" -FunctionsToExport '*' -Copyright "2019 Hilton Giesenow, All Rights Reserved" -ProjectUri "https://github.com/HiltonGiesenow/PowerGraph" -LicenseUri "https://github.com/HiltonGiesenow/PowerGraph/blob/master/LICENSE" -Description $description -Tags $tags -ReleaseNotes $releaseNotes -Verbose

$t = Test-ModuleManifest -Path $manifestPath

$t

$t.ExportedCommands.Keys

#Remove-Module PoShMon