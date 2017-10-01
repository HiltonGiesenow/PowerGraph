$version = "0.0.1"
$manifestPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "\PowerGraph.psd1"

Remove-Item -Path $manifestPath -ErrorAction SilentlyContinue

$description = "tbd"

$releaseNotes = "0.0.1
* Initial release.
"

New-ModuleManifest -Path $manifestPath -ModuleVersion $version -RootModule "PowerGraph.psm1" -Guid '3d4fe3d7-46d7-418f-8979-1f7b36b3dd35' -Author "Hilton Giesenow" -CompanyName "Experts Inside" -FunctionsToExport '*' -Copyright "2017 Hilton Giesenow, All Rights Reserved" -ProjectUri "https://github.com/HiltonGiesenow/PowerGraph" -LicenseUri "https://github.com/HiltonGiesenow/PowerGraph/blob/master/LICENSE" -Description $description -Tags 'Office Graph', 'Planner', 'Office 365', 'Groups', 'OneDrive' -ReleaseNotes $releaseNotes -Verbose

$t = Test-ModuleManifest -Path $manifestPath

$t

$t.ExportedCommands.Keys

#Remove-Module PoShMon