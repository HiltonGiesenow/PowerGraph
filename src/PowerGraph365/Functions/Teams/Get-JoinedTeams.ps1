Function Get-JoinedTeams
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "users/{id}/joinedTeams",
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserId
    )

    # if ($global:PowerGraph_AccessToken.TokenType -eq "Client Credentials")
    #     { Write-Warning "You cannot currently retrieve Plans for a Group using the Client Credentials authorization model. You might need to call Connect-MSGraph with a username and password first instead." }

    switch ($PsCmdlet.ParameterSetName)
    {
        "users/{id}/joinedTeams" {

            #Todo: Validate UserId is valid for type

            if ($global:PowerGraph_AccessToken.TokenType -eq "Password")
                { Write-Warning "This operation is not support for this type of login ('Delegated') to the API. Please try using 'Connect-MSGraph' without a username and password." }

            $uri = $global:PowerGraph_BaseUrl + "users/$UserId/joinedTeams"
        }

        default {
            if ($global:PowerGraph_AccessToken.TokenType -eq "Client Credentials")
                { Write-Warning "This operation is not support for this type of login ('Application') to the API. Please try using 'Connect-MSGraph' with a username and password." }

            $uri = $global:PowerGraph_BaseUrl + "me/joinedTeams"
        }
    }
    
    $return = Invoke-MSGraphRequest -Uri $uri

    return $return.value

}

#reference: https://docs.microsoft.com/en-gb/graph/api/user-list-joinedteams?view=graph-rest-1.0&tabs=http