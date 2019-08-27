Function Invoke-MSGraphRequest
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'Default',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]$Uri,
        
        [Parameter(Mandatory = $false)]
        [Object]$Body,
        
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers,
        
        [Parameter(Mandatory = $false)]
        [System.String]$ContentType = 'application/json'
    )

    $Params = @{
        Method = $Method
        Uri = $Uri
        ContentType = $ContentType
        #ErrorAction = 'Stop'
    }
    
    if ($Headers) {
        $Params['Headers'] = $Headers
    } else {
        $Params['Headers'] = @{ }
    }
    if (!$global:PowerGraph_AccessToken)
    {
        throw "Access token not found - please connect to your Microsoft Graph account first using the 'Connect-MSGraph' command"
    }

    $Params['Headers']['Authorization'] = 'Bearer {0}' -f $global:PowerGraph_AccessToken.AccessToken
    
    if ([string]::IsNullOrEmpty($Body) -eq $false)
        { $Params['Body'] = $Body }

    try {

        $Result = Invoke-WebRequest @Params -UseBasicParsing -ErrorAction Ignore

        Write-Verbose "Graph Response: $($Result.Content)"

        $returnValue = $Result.Content | ConvertFrom-Json -ErrorAction SilentlyContinue

        return $returnValue

    }
    catch {
        if ($_.Exception.Response -ne $null)
        {
            $responseStream = $_.Exception.Response.GetResponseStream()
            $streamReader = New-Object System.IO.StreamReader $responseStream
            $responseBody = $streamReader.ReadToEnd()

            if ($_.Exception.Response.StatusCode -eq "Unauthorized") # 401
                { $hint = " [Hint: The request you are making might not be possible using the authentication model you've selected. Review the api reference for the command you're trying to execute at https://developer.microsoft.com/en-us/graph/docs/api-reference and verify that the permission does not say 'Not supported.'. If it does, you might need to call Connect-MSGraph with a username and password first instead.] " }

            if ($_.Exception.Response.StatusCode -eq "Forbidden") # 403
                { $hint = " [Hint: You might need to get an updated Admin consent if you've recently changed the application's permissions. ] " }
        } else
            { $responseBody = "" }

        Write-Error ($_.Exception.Message + $hint + " " + $responseBody)
    }
}