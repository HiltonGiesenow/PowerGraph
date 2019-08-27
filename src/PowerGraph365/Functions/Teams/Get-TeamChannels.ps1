Function Get-TeamChannels
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TeamId
    )

    # if ($global:PowerGraph_AccessToken.TokenType -eq "Client Credentials")
    #     { Write-Warning "You cannot currently retrieve Plans for a Group using the Client Credentials authorization model. You might need to call Connect-MSGraph with a username and password first instead." }

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($TeamId, [ref]$emptyGuid) -eq $false)
        {  throw "Invalid Team ID - $TeamId" }
    else {
        $uri = $global:PowerGraph_BaseUrl + "teams/$TeamId/channels"

        $return = Invoke-MSGraphRequest -Uri $uri

        return $return.value

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
}