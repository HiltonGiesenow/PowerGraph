Function New-SitePage {
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteId,

        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [ValidateNotNullOrEmpty()]
        [string]$PageLayout,

        [ValidateNotNullOrEmpty()]
        [object[]]$webParts = @()
    )

    if ($global:PowerGraph_BaseUrl.ToLower().Contains("beta") -eq $false)
    {
        Write-Warning 'This query/command is currently only supported on the Beta endpoint - please call 'Connect-MSGraph' again with the following setting: -BaseUrl "https://graph.microsoft.com/beta/"'
    } else {

        $body = (@{
            name            = $Name
            title           = $Title
            PageLayout      = $PageLayout
            webParts        = $WebParts
        }) | ConvertTo-Json
    
        $uri = $global:PowerGraph_BaseUrl + "sites/$SiteId/pages"

        Write-Verbose "Adding new page: $Title with $body"
    
        $sitePage = Invoke-MSGraphRequest -Uri $uri -Method Post -Body $body
    
        if ($sitePage -ne $null)
        {
            Write-Verbose "New page created with Id $($sitePage.id)"
        }
        
        return $sitePage
    }
}