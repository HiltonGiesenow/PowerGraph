Function Get-SitesForGroup
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$GroupId = @()
    )

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($GroupId, [ref]$emptyGuid))
    {
        $uri = $global:PowerGraph_BaseUrl + "groups/$GroupId/sites/root"

        $return = Invoke-MSGraphRequest -Uri $uri

        return $return    
    }
    else
    {
        throw "Invalid Group ID - $GroupId"
    }
}