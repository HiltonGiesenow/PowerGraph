Function Get-PlannerPlansForGroup
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$GroupId = @()
    )

    if ($global:PowerGraph_AccessToken.TokenType -eq "Client Credentials")
        { Write-Warning "You cannot currently retrieve Plans for a Group using the Client Credentials authorization model. You might need to call Connect-MSGraph with a username and password first instead." }

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($GroupId, [ref]$emptyGuid))
    {
        $uri = $global:PowerGraph_BaseUrl + "groups/$GroupId/planner/plans"

        $plansReturn = Invoke-MSGraphRequest -Uri $uri

        return $plansReturn.value

        <#

        return [pscustomobject]@{
            "ETag" = $plansReturn.value.'@odata.etag'
            "CreatedBy" = $plansReturn.value.createdBy
            "CreatedDateTime" = [datetime]::Parse($plansReturn.value.createdDateTime)
            "Owner" = $plansReturn.value.owner
            "Title" = $plansReturn.value.title
            "Id" = $plansReturn.value.Id
        }
        #>
        
    }
    else
    {
        throw "Invalid Group ID - $singleGroupId"
    }
}