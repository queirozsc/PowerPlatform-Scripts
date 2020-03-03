<#
.SYNOPSIS
    Download dos arquivos do servidor SFTP
.DESCRIPTION
    Faz o donwload de todas as pastas e arquivos do servidor SFTP
.EXAMPLE
    Get-SFTPFiles
.EXAMPLE
    Get-SFTPFiles -RemotePath / -LocalPath .
.LINK
    https://winscp.net/eng/docs/library_example_recursive_download_custom_error_handling#powershell
#>
function Get-SFTPFiles {
    Param (
        # Diretorio remoto
        [Parameter(Mandatory=$true)]
        [WinSCP.Session]$Session,
        [PSDefaultValue(Help = '/')]
        [String] $RemotePath = '/',

        # Diretorio local
        [PSDefaultValue(Help = '.')]
        [ValidateScript({
            if( -Not ($_ | Test-Path) ){
                throw "Arquivo $_ nao existe"
            }
            return $true
        })]
        [System.IO.FileInfo] $LocalPath = '.'

    )
    try {
        # Lista arquivos e diretorios para download
        $fileInfos =
        $Session.EnumerateRemoteFiles(
            $RemotePath, $Null,
            ([WinSCP.EnumerationOptions]::EnumerateDirectories -bor
                [WinSCP.EnumerationOptions]::AllDirectories))

        foreach ($fileInfo in $fileInfos) {
            $localFilePath =
            [WinSCP.RemotePath]::TranslateRemotePathToLocal(
                $fileInfo.FullName, $RemotePath, $LocalPath)

            if ($fileInfo.IsDirectory) {
                # Cria o diretorio local, caso nao exista
                if (!(Test-Path $LocalFilePath)) {
                    New-Item $LocalFilePath -ItemType Directory | Out-Null
                }
            }
            else {
                Write-Host "Baixando o arquivo $($fileInfo.FullName) ..."
                # Download 
                $RemoteFilePath = [WinSCP.RemotePath]::EscapeFileMask($fileInfo.FullName)
                $TransferResult = $Session.GetFiles($RemoteFilePath, $LocalFilePath)

                # Problema no download?
                if (!$transferResult.IsSuccess) {
                    # Exibe o erro mas continua para o proximo arquivo
                    Write-Host (
                        "Erro ao fazer download do arquivo $($fileInfo.FullName): " +
                        "$($transferResult.Failures[0].Message)")
                }
            }
        }
    }
    finally {
      # Disconecta
      $session.Dispose()   
    }

    # Descompacta o arquivo zip
    Write-Host "Descompactando $($localFilePath) ..."
    Expand-Archive -LiteralPath $localFilePath -DestinationPath $LocalPath

    # Renomeia para csv
    Get-ChildItem -Filter "*dat" -Path $LocalPath -Recurse | Move-Item -Path { $_.FullName } -Destination $LocalPath
    Get-ChildItem -Filter "*dat" -Path $LocalPath -Recurse | Rename-Item -NewName { [IO.Path]::ChangeExtension($_.name, "csv") }
    
    exit 0
}