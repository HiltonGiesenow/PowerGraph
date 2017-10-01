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
          
            #based on http://johnliu.net/blog/2017/1/create-many-o365-groups-with-powershell-resource-owner-granttype-and-microsoft-graph
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
}