Function New-GraphGroupOwner
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$OwnerId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupId
    )

    process
    {

        foreach ($singleOwnerId in $OwnerId)
        {

            $body = @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$singleOwnerId"
            }

            $uri = $global:PowerGraph_BaseUrl + "groups/$GroupId/owners/`$ref"

            Write-Verbose "Adding owner with Id $singleOwnerId to group with Id $GroupId"

            Invoke-MSGraphRequest -Uri $uri -Method Post -Body ($body | ConvertTo-Json)
        }

    }
}