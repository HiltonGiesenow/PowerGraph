Function Get-JoinedGraphGroups
{
    [CmdletBinding()]
    Param(
        [string]$Query
    )

    $uri = $global:PowerGraph_BaseUrl + "me/joinedTeams"

    $return = Invoke-MSGraphRequest -Uri $uri

    return $return.value
}