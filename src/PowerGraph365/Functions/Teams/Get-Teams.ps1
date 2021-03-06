Function Get-Teams {
    [CmdletBinding()]
    Param(      
    )

    if ($global:PowerGraph_BaseUrl.ToLower().Contains("beta") -eq $false)
    {
        Write-Warning 'This query/command is currently only supported on the Beta endpoint - please call 'Connect-MSGraph' again with the following setting: -BaseUrl "https://graph.microsoft.com/beta/"'
    } else {
        $uri = $global:PowerGraph_BaseUrl + "groups?`$filter=resourceProvisioningOptions/Any(x:x eq 'Team')"

        $return = Invoke-MSGraphRequest -Uri $uri
    }
    
    return $return.value
}