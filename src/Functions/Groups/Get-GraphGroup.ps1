Function Get-GraphGroup
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$GroupId = @()
    )

    foreach ($singleGroupId in $GroupId)
    {
        $emptyGuid = [guid]::Empty
        if ([guid]::TryParse($singleGroupId, [ref]$emptyGuid))
        {
            $uri = $global:PowerGraph_BaseUrl + "groups/$singleGroupId"
            return Invoke-MSGraphRequest -Uri $uri
        }
        else
        {
            throw "Invalid Group ID - $singleGroupId"
        }
    }
}