<#
.SYNOPSIS
    Envia os arquivos ao Azure Storage Account
.DESCRIPTION
    Envia os arquivos ao container no Azure Storage Account
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function Put-BlobStorageAccount {
    Param (
        # Nome do Azure Storage Account
        [Parameter(Mandatory = $true)]
        [String]$StorageAccountName,

        # Chave de acesso do Azure Storage Account
        [Parameter(Mandatory = $true)]
        [String]$StorageAccountKey,
        
        # Nome do container do Azure Storage Account
        [Parameter(Mandatory = $true)]
        [String]$Container,

        # Array com as extensoes dos arquivos a serem excluidos
        [String[]]$Extensions
    )
    
    $AzureStorageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    foreach ($Extension in $Extensions) {
        Write-Host "Enviando *$Extension ao Azure Storage Account $StorageAccountName/$Container ..."
        $files = Get-ChildItem -Path $Path * -Include "*$Extension" -Recurse 
        foreach ($file in $files) {
            Set-AzStorageBlobContent -File $file -Container $Container -Context $AzureStorageContext -Force
            }
    }    

}