Function Get-OneNoteNotebooksForGroup
{
    [CmdletBinding()]
    Param(      
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$GroupId = @()
    )

    $emptyGuid = [guid]::Empty
    if ([guid]::TryParse($GroupId, [ref]$emptyGuid))
    {
        $uri = $global:PowerGraph_BaseUrl + "groups/$GroupId/onenote/notebooks"
        
        $notebooksReturn = Invoke-MSGraphRequest -Uri $uri

        return $notebooksReturn.value
    }
    else
    {
        throw "Invalid Group ID - $singleGroupId"
    }
}