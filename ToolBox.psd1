@{
   
    # Version number of this module.
    ModuleVersion = '1.0.0'

    # ID used to uniquely identify this module
    GUID = '12345678-1234-1234-1234-123456789012'

    # Author of this module
    Author = 'Heinz'

    # Company or vendor of this module
    CompanyName = 'Swissgrid AG'

    # Description of the functionality provided by this module
    Description = 'Toolbox to assist in daily tasks'

    # Functions to export from this module
    FunctionsToExport = @('Get-SwissGridOwner', 'Set-SwissGridOwner', 'Get-DnsInfo')

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
    
    # File list of all files in the module
    FileList = @('activedirectory.psm1', 'dns.psd1')

    }
}