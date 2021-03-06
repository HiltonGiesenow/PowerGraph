$scriptFiles  = @( Get-ChildItem -Path $PSScriptRoot\Functions\**\*.ps1 -ErrorAction SilentlyContinue )

Foreach($import in $scriptFiles)
{
    Try
    {
        Write-Verbose "Importing $import"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}