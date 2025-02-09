function Get-DnsInfo {
    <#
    .SYNOPSIS
    Retrieves DNS information for a given FQDN or IP address.

    .DESCRIPTION
    The Get-DnsInfo function accepts a Fully Qualified Domain Name (FQDN) or an IP address as input and retrieves DNS information. 
    It checks if the PTR record matches the input and verifies if a reverse lookup zone exists. The function returns the information as a hashtable.

    .PARAMETER FQDN
    The Fully Qualified Domain Name to query. This parameter is optional but either FQDN or IPAddress must be provided.

    .PARAMETER IPAddress
    The IP address to query. This parameter is optional but either FQDN or IPAddress must be provided.

    .OUTPUTS
    Hashtable
    Returns a hashtable containing the following keys:
    - FQDN: The Fully Qualified Domain Name.
    - IP: The IP address.
    - PtrMatchesInput: A boolean indicating if the PTR record matches the input.
    - ReverseLookupZoneExists: A boolean indicating if a reverse lookup zone exists.

    .EXAMPLE
    PS> Get-DnsInfo -FQDN "example.com"
    Returns DNS information for the FQDN "example.com".

    .EXAMPLE
    PS> Get-DnsInfo -IPAddress "192.168.1.1"
    Returns DNS information for the IP address "192.168.1.1".
    #>

    param (
        [Parameter(Mandatory=$false, Position=0)]
        [string]$FQDN,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$IPAddress
    )

    if (-not $FQDN -and -not $IPAddress) {
        Write-Error "You must provide either a FQDN or an IP address."
        return
    }

    $result = @{ FQDN = $null; IP = $null; PtrMatchesInput = $false; ReverseLookupZoneExists = $false }

    if ($FQDN) {
        $result.FQDN = $FQDN
        $result.IP = [System.Net.Dns]::GetHostAddresses($FQDN) | Select-Object -First 1
    }

    if ($IPAddress) {
        $result.IP = $IPAddress
        $result.FQDN = [System.Net.Dns]::GetHostEntry($IPAddress).HostName
    }

    if ($result.IP) {
        $ptrRecord = [System.Net.Dns]::GetHostEntry($result.IP).HostName
        $result.PtrMatchesInput = ($ptrRecord -eq $result.FQDN)
    }

    $reverseLookupZoneExists = Test-Connection -ComputerName $result.IP -Count 1 -ErrorAction SilentlyContinue
    $result.ReverseLookupZoneExists = $reverseLookupZoneExists

    return $result
}

Export-ModuleMember -Function Get-DnsInfo