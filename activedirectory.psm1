function Set-SwissGridOwner {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GroupName,
        [Parameter(Mandatory = $true)]
        [string]$Owner
    )

    # Import the Active Directory module
    Import-Module ActiveDirectory

    try {
        # Get the AD group object
        $group = Get-ADGroup -Filter { Name -eq $GroupName } -Properties swissgridowner

        if ($null -eq $group) {
            Write-Error "Group '$GroupName' not found."
            return
        }

        # Set the custom attribute swissgridowner
        Set-ADGroup -Identity $group -Replace @{swissgridowner = $Owner}
        Write-Output "The swissgridowner for group '$GroupName' has been set to '$Owner'."
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

Export-ModuleMember -Function Get-SwissGridOwner, Set-SwissGridOwner