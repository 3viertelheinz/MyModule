function Get-FunctionVerbsFrequency {
    <#
    .SYNOPSIS
    Lists the verbs of all loaded functions and shows the frequency of their occurrence.

    .DESCRIPTION
    This function retrieves all loaded functions, extracts their verbs, and displays the frequency of each verb's occurrence.

    .OUTPUTS
    PSCustomObject
    Returns a custom object containing the verb and its frequency.

    .EXAMPLE
    PS> Get-FunctionVerbsFrequency
    Lists the verbs of all loaded functions and shows the frequency of their occurrence.
    #>

    # Get all loaded functions
    $functions = Get-Command -CommandType Function

    # Extract the verbs and count their frequency
    $verbFrequency = $functions | Group-Object -Property Verb | Select-Object Name, Count

    # Create a custom object for each verb and its frequency
    $verbFrequency | ForEach-Object {
        [PSCustomObject]@{
            Verb   = $_.Name
            Count  = $_.Count
        }
    }
}

Export-ModuleMember -Function Get-FunctionVerbsFrequency