<#
.SYNOPSIS
    Donwload dos arquivos do servidor SFTP da Requestia
.DESCRIPTION
    Executa o download dos arquivos do Requestia
    Ao final, envia para o Azure Storage Account
#>
try {
    . ".\Delete-FilesByExtension.ps1"
    . ".\Connect-SFTP.ps1"
    . ".\Get-SFTPFiles.ps1"
    . ".\Put-BlobStorageAccount.ps1"

    # Apaga os arquivos da execucao anterior
    $Extensions = @(".zip", ".dat", ".csv", ".xml")
    Delete-FilesByExtension -Path . -Extensions $Extensions

    # Conecta no servidor SFTP
    $Session = Connect-SFTP -SessionDefinitionsFile Requestia-SessionProperties.ps1 -SessionLogFile Connect-SFTPRequestia.log

    # Download dos arquivos
    Get-SFTPFiles -RemotePath \ -LocalPath .

    # Envia arquivos ao Azure Storage Account
    $Extensions = @(".csv")
    Put-BlobStorageAccount -StorageAccountName cargasdatafactory -StorageAccountKey GvYjzpvw5mecekMecvk/++QRMGmhOVnokgLNMH/r9B+4rIm7W1LwhOP+pPwlLm/DlZmLmDnlohgG/7WDBOZs3g== -Container requestia -Extensions $Extensions 

    exit 0
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
