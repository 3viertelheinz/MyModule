<#
.SYNOPSIS
Retrieves DNS information for a given FQDN or IP address.

.DESCRIPTION
The Get-DnsInfo function accepts a Fully Qualified Domain Name (FQDN) or an IP address as input and retrieves DNS information. 
It checks if the PTR record matches the input and verifies if a reverse lookup zone exists. The function returns the information as a hashtable.

.PARAMETER InputValue
The FQDN or IP address to query. This parameter is mandatory.

.OUTPUTS
Hashtable
Returns a hashtable containing the following keys:
- FQDN: The Fully Qualified Domain Name.
- IP: The IP address.
- PtrMatchesInput: A boolean indicating if the PTR record matches the input.
- ReverseLookupZoneExists: A boolean indicating if a reverse lookup zone exists.

.EXAMPLE
PS> Get-DnsInfo -InputValue "example.com"
Returns DNS information for the FQDN "example.com".

.EXAMPLE
PS> Get-DnsInfo -InputValue "192.168.1.1"
Returns DNS information for the IP address "192.168.1.1".

#>
function Get-DnsInfo {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$InputValue
    )

    $result = @{}
    $fqdn = $null
    $ip = $null

    if ($InputValue -match '^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') {
        $fqdn = $InputValue
        $ip = [System.Net.Dns]::GetHostAddresses($fqdn) | Select-Object -First 1
    } elseif ($InputValue -match '^\d{1,3}(\.\d{1,3}){3}$') {
        $ip = $InputValue
        $fqdn = [System.Net.Dns]::GetHostEntry($ip).HostName
    } else {
        Write-Error "Invalid input. Please provide a valid FQDN or IP address."
        return
    }

    $result.FQDN = $fqdn
    $result.IP = $ip

    if ($ip) {
        $ptrRecord = [System.Net.Dns]::GetHostEntry($ip).HostName
        $result.PtrMatchesInput = ($ptrRecord -eq $fqdn)
    } else {
        $result.PtrMatchesInput = $false
    }

    $reverseLookupZoneExists = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue
    $result.ReverseLookupZoneExists = $reverseLookupZoneExists

    return $result
}