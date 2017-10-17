Function Connect-MSGraph
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName="Daemon")]
        [Parameter(Mandatory = $true, ParameterSetName="UserPassword")]
        [ValidateNotNullOrEmpty()]
        [string]$AzureADDomain,
        
        [Parameter(Mandatory = $true, ParameterSetName="Daemon")]
        [Parameter(Mandatory = $true, ParameterSetName="UserPassword")]
        [Alias("ClientId")]
        [ValidateNotNullOrEmpty( )]
        [string]$AppId,

        [Parameter(Mandatory = $true, ParameterSetName="Daemon")]
        [Parameter(Mandatory = $true, ParameterSetName="UserPassword")]
        [Alias("ClientSecret")]
        [ValidateNotNullOrEmpty()]
        [String]$AppSecret,
        
        [Parameter(Mandatory = $true, ParameterSetName="Daemon")]
        [Parameter(Mandatory = $true, ParameterSetName="UserPassword")]
        [ValidateNotNullOrEmpty()]
        [string]$RedirectUrl,
                
        [Parameter(Mandatory = $false, ParameterSetName="Daemon")]
        [Parameter(Mandatory = $false, ParameterSetName="UserPassword")]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUrl = "https://graph.microsoft.com/v1.0/",

        [Parameter(Mandatory = $true, ParameterSetName="UserPassword", Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [Parameter(Mandatory = $true, ParameterSetName="UserPassword", Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Password
    )

    $global:PowerGraph_BaseUrl = $BaseUrl

    $authority = "https://login.microsoftonline.com/$AzureADDomain"

    Write-Verbose "Authority set to $authority"

    # try {

        switch ($PsCmdlet.ParameterSetName)
        {
            "Daemon" {

                #https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols-oauth-client-creds

                $defaultScope = "https://graph.microsoft.com/.default"

                $path = "$PSScriptRoot\..\..\Libraries\Microsoft.Identity.Client\Microsoft.Identity.Client.dll"

                Write-Verbose "Loading Microsoft.Identity.Client library from $path"

                [System.Reflection.Assembly]::LoadFrom($path) | Out-Null

                $clientCredential = New-Object Microsoft.Identity.Client.ClientCredential -ArgumentList $appSecret
                $clientApplication  = New-Object Microsoft.Identity.Client.ConfidentialClientApplication -ArgumentList $AppId, $authority, $RedirectUrl, $clientCredential, $null, $null

                $scopesList = New-Object Collections.Generic.List[string]
                $scopesList.Add("https://graph.microsoft.com/.default")

                Write-Verbose "Aquiring Token - Client Credentials Grant Flow"

                $authenticationResult = $clientApplication.AcquireTokenForClientAsync($scopesList).Result

                $token = @{
                    "TokenType" = "Client Credentials"
                    "AccessToken" = $authenticationResult.AccessToken
                    "ExpiresOn" = $authenticationResult.ExpiresOn
                    "RefreshToken" = $null
                }

            }

            "UserPassword" {
            
                $resource = "https://graph.microsoft.com"
                $tokenEndpointUri = "$authority/v2.0/authorize" # "$authority/oauth2/v2.0/token" # # "$authority/oauth2/token"
                $tokenEndpointUri = "https://login.microsoftonline.com/$AzureADDomain/oauth2/token"
                $body = "grant_type=password&username=$UserName&password=$Password&client_id=$AppId&client_secret=$appSecret&resource=$resource";

                Write-Verbose "Aquiring Token - Password Grant"

                $response = Invoke-WebRequest -Uri $tokenEndpointUri -Body $body -Method Post -UseBasicParsing
                $responseBody = $response.Content | ConvertFrom-JSON

                $token = @{
                    "TokenType" = "Password"
                    "AccessToken" = $responseBody.access_token
                    "ExpiresOn" = $responseBody.expires_on #TODO: Convert this nicely
                    "RefreshToken" = $null
                }

                Write-Verbose "Scopes received: $($responseBody.scope)"

            }
        }

        Write-Verbose "Token retrieved, expires on $($token.ExpiresOn)"

        $global:PowerGraph_AccessToken = $token

    # }
    # catch {
    #     $responseStream = $_.Exception.Response.GetResponseStream()
    #     $streamReader = New-Object System.IO.StreamReader $responseStream
    #     $responseBody = $streamReader.ReadToEnd()

    #     if ($_.Exception.Response.StatusCode -eq "Bad Request") # 400
    #         { $hint = " [Hint: The request you are making might not be possible using the authentication model you've selected. Review the api reference for the command you're trying to execute at https://developer.microsoft.com/en-us/graph/docs/api-reference and verify that the permission does not say 'Not supported.'. If it does, you might need to call Connect-MSGraph with a username and password first instead.] " }

    #     if ($_.Exception.Response.StatusCode -eq "Forbidden") # 403
    #         { $hint = " [Hint: You might need to get an updated Admin consent if you've recently changed the application's permissions. ] " }

    #     Write-Error ($_.Exception.Message + $hint + " " + $responseBody)
    # }
}