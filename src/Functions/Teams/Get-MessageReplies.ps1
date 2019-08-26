Function Get-MessageReplies
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TeamId,
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ChannelId,
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$MessageId
    )

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($TeamId, [ref]$emptyGuid) -eq $false)
        {  throw "Invalid Team ID - $TeamId" }

    # leave off for now, but would look like: "19:191754a761ce4abf9cb47438267cc77c@thread.skype"
    # elseif ([guid]::TryParse($ChannelId, [ref]$emptyGuid) -eq $false)
    # {  throw "Invalid Channel ID - $ChannelId" }
    else {
        $uri = $global:PowerGraph_BaseUrl + "teams/$TeamId/channels/$ChannelId/messages/$MessageId/replies"

        $return = Invoke-MSGraphRequest -Uri $uri

        return $return.value
    }
}