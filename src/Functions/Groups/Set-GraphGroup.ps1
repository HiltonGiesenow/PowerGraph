Function Set-GraphGroup
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$GroupId,

        [Parameter()]
        [string]$DisplayName,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [bool]$MailEnabled,

        [Parameter()]
        [bool]$AutoSubscribeNewMembers, 

        [Parameter()]
        [string]$MailNickname,

        [Parameter()]
        [bool]$SecurityEnabled, 

        [Parameter()]
        [string[]]$GroupTypes,

        [Parameter()]
        [ValidateSet("Private","Public")]
        [string]$Visibility
    )

    $bodyRaw = @{ }
    if ($PSBoundParameters.ContainsKey('DisplayName'))
        { $bodyRaw["DisplayName"] = $DisplayName }
    if ($PSBoundParameters.ContainsKey('Description'))
        { $bodyRaw["Description"] = $Description }
    if ($PSBoundParameters.ContainsKey('MailEnabled'))
        { $bodyRaw["MailEnabled"] = $MailEnabled }
    if ($PSBoundParameters.ContainsKey('AutoSubscribeNewMembers'))
        { $bodyRaw["AutoSubscribeNewMembers"] = $AutoSubscribeNewMembers }
    if ($PSBoundParameters.ContainsKey('MailNickname'))
        { $bodyRaw["MailNickname"] = $MailNickname }
    if ($PSBoundParameters.ContainsKey('SecurityEnabled'))
        { $bodyRaw["SecurityEnabled"] = $SecurityEnabled }
    if ($PSBoundParameters.ContainsKey('GroupTypes'))
        { $bodyRaw["GroupTypes"] = $GroupTypes }
    if ($PSBoundParameters.ContainsKey('Visibility'))
        { $bodyRaw["Visibility"] = $Visibility }

    $body = $bodyRaw | ConvertTo-Json

    $uri = $global:PowerGraph_BaseUrl + "groups/$GroupId"

    Write-Verbose "Updating group $GroupId with $body"

    Invoke-MSGraphRequest -Uri $uri -Method Patch -Body $body
    
    return $group
}