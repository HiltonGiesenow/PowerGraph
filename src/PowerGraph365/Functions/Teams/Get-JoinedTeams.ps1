Function Get-JoinedTeams
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserId
    )

    # if ($global:PowerGraph_AccessToken.TokenType -eq "Client Credentials")
    #     { Write-Warning "You cannot currently retrieve Plans for a Group using the Client Credentials authorization model. You might need to call Connect-MSGraph with a username and password first instead." }

    if ($UserId -eq $null)
    {
        $uri = $global:PowerGraph_BaseUrl + "me/joinedTeams"
    } else {
        $uri = $global:PowerGraph_BaseUrl + "users/$UserId/joinedTeams"
    }

    $return = Invoke-MSGraphRequest -Uri $uri

    return $return.value

}

#reference: https://docs.microsoft.com/en-gb/graph/api/user-list-joinedteams?view=graph-rest-1.0&tabs=http