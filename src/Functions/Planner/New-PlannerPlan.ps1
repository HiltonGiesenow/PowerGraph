Function New-PlannerPlan
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupId = @(),

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Title
    )

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($GroupId, [ref]$emptyGuid))
    {
        $body = (@{
            owner     = $GroupId
            title     = $Title
        }) | ConvertTo-Json

        $uri = $global:PowerGraph_BaseUrl + "planner/plans"

        Write-Verbose "Adding new planner: $Title with $body"

        $plan = Invoke-MSGraphRequest -Uri $uri -Method Post -Body $body
    }
    else
    {
        throw "Invalid Group ID - $GroupId"
    }
}