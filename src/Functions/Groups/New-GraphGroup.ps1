Function New-GraphGroup
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [bool]$MailEnabled = $true,

        [Parameter()]
        [string]$MailNickname,

        [Parameter()]
        [bool]$SecurityEnabled = $false, 

        [Parameter()]
        [string[]]$GroupTypes = @("Unified"),

        [Parameter()]
        [string[]]$OwnerIds = @(),

        [Parameter()]
        [string[]]$MemberIds = @()
    )

    if ([string]::IsNullOrEmpty($MailNickname))
        { $MailNickname = $DisplayName } # this might not be a good idea because of spaces etc. - let's start here for now (yagni)

    if ([string]::IsNullOrEmpty($Description))
        { $Description = $DisplayName }

    if ($SecurityEnabled -and $GroupTypes.Length -gt 0)
        { throw "You cannot set GroupTypes if you are creating a Security Group" }

    #TODO: more validation on GroupTypes values

    $body = (@{
        displayName     = $DisplayName
        description     = $Description
        mailEnabled     = $MailEnabled
        mailNickname    = $MailNickname
        securityEnabled = $SecurityEnabled
        groupTypes      = $GroupTypes
    }) | ConvertTo-Json

    $uri = $global:PowerGraph_BaseUrl + "groups"

    Write-Verbose "Adding new group: $DisplayName with $body"

    $group = Invoke-MSGraphRequest -Uri $uri -Method Post -Body $body

    Write-Verbose "New group created with Id $($group.id)"

    $OwnerIds | New-GraphGroupOwner -GroupId $group.id

    $MemberIds | New-GraphGroupMember -GroupId $group.id

    return $group
}