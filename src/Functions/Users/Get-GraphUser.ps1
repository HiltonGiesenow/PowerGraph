Function Get-GraphUser
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserId = @()
    )

    Process
    {
        foreach ($singleUserId in $UserId)
        {
            $emptyGuid = [guid]::Empty
            if ([guid]::TryParse($singleUserId, [ref]$emptyGuid) -or $singleUserId.indexOf("@") -gt 0)
            {
                Write-Verbose "Getting record for user with id $singleUserId"

                $uri = $global:PowerGraph_BaseUrl + "users/$singleUserId"
                return Invoke-MSGraphRequest -Uri $uri
            }
            else
            {
                throw "Invalid User ID - $singleUserId"
            }
        }
    }
}