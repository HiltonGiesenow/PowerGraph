Function Get-GraphGroups
{
    [CmdletBinding()]
    Param(
        [string]$Query
    )

    $uri = $global:PowerGraph_BaseUrl + "groups"

    if (![string]::IsNullOrEmpty($Query))
        { $uri += "?$Query" }

    $return = Invoke-MSGraphRequest -Uri $uri

    return $return.value
}