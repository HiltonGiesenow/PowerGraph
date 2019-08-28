Function Get-Team
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$TeamId = @()
    )

    Process
    {
        foreach ($singleTeamId in $TeamId)
        {
            $emptyGuid = [guid]::Empty
            if ([guid]::TryParse($singleTeamId, [ref]$emptyGuid))
            {
                $uri = $global:PowerGraph_BaseUrl + "teams/$singleTeamId"
                return Invoke-MSGraphRequest -Uri $uri
            }
            else
            {
                throw "Invalid Team ID - $singleTeamId"
            }
        }
    }
}