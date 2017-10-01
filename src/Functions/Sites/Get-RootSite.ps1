Function Get-RootSite
{
    [CmdletBinding()]
    Param(
    )

    $uri = $global:PowerGraph_BaseUrl + "sites/root"

    return Invoke-MSGraphRequest -Uri $uri
}