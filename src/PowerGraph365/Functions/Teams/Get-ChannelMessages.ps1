Function Get-ChannelMessages
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TeamId,
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ChannelId
    )

    # if ($global:PowerGraph_AccessToken.TokenType -eq "Client Credentials")
    #     { Write-Warning "You cannot currently retrieve Plans for a Group using the Client Credentials authorization model. You might need to call Connect-MSGraph with a username and password first instead." }

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($TeamId, [ref]$emptyGuid) -eq $false)
        {  throw "Invalid Team ID - $TeamId" }

    # leave off for now, but would look like: "19:191754a761ce4abf9cb47438267cc77c@thread.skype"
    # elseif ([guid]::TryParse($ChannelId, [ref]$emptyGuid) -eq $false)
    # {  throw "Invalid Channel ID - $ChannelId" }
    else {
        $uri = $global:PowerGraph_BaseUrl + "teams/$TeamId/channels/$ChannelId/messages"

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