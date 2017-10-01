Function New-GraphGroupMember
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$MemberId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupId
    )

    process
    {

        foreach ($singleMemberId in $MemberId)
        {

            $body = @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$singleMemberId"
            }

            $uri = $global:PowerGraph_BaseUrl + "groups/$GroupId/members/`$ref"

            Write-Verbose "Adding member with Id $singleMemberId to group with Id $GroupId"

            Invoke-MSGraphRequest -Uri $uri -Method Post -Body ($body | ConvertTo-Json)
        }

    }
}