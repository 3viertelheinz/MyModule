function Sign-AllScripts {
    <#
    .SYNOPSIS
    Signs all PowerShell scripts in the current directory.

    .DESCRIPTION
    This function signs all PowerShell scripts (.ps1 files) in the current directory using a specified code-signing certificate.

    .PARAMETER CertificateThumbprint
    The thumbprint of the code-signing certificate to use for signing the scripts.

    .EXAMPLE
    PS> Sign-AllScripts -CertificateThumbprint "ABC123DEF456..."
    Signs all PowerShell scripts in the current directory using the specified certificate.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$CertificateThumbprint
    )

    # Get the code-signing certificate from the certificate store
    $cert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Thumbprint -eq $CertificateThumbprint }

    if (-not $cert) {
        Write-Error "Certificate with thumbprint '$CertificateThumbprint' not found."
        return
    }

    # Get all PowerShell scripts in the current directory
    $scripts = Get-ChildItem -Path . -Filter *.ps1

    foreach ($script in $scripts) {
        try {
            # Sign the script
            Set-AuthenticodeSignature -FilePath $script.FullName -Certificate $cert
            Write-Output "Signed script: $($script.FullName)"
        }
        catch {
            Write-Error "Failed to sign script: $($script.FullName). Error: $_"
        }
    }
}

function Get-CertificateList {
    <#
    .SYNOPSIS
    Lists all certificates in the current user's certificate store.

    .DESCRIPTION
    This function retrieves and lists all certificates in the current user's certificate store.

    .OUTPUTS
    PSCustomObject
    Returns a custom object containing the certificate's subject, thumbprint, and expiration date.

    .EXAMPLE
    PS> Get-CertificateList
    Lists all certificates in the current user's certificate store.
    #>

    # Get all certificates from the current user's certificate store
    $certificates = Get-ChildItem -Path Cert:\CurrentUser\My

    # Create a custom object for each certificate
    $certificates | ForEach-Object {
        [PSCustomObject]@{
            Subject       = $_.Subject
            Thumbprint    = $_.Thumbprint
            ExpirationDate = $_.NotAfter
        }
    }
}

Export-ModuleMember -Function Sign-AllScripts, Get-CertificateList

