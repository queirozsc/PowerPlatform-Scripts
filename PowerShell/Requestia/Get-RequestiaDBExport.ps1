###################################################################
# https://winscp.net/eng/docs/library_example_recursive_download_custom_error_handling#powershell
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/expand-archive?view=powershell-6

# Use Generate Session URL function to obtain a value for -sessionUrl parameter.
$remotePath = "/"
$localPath = "."

try {
    Write-Host "Apagando arquivos C:\Power BI Gateway Files\Requestia\*.zip"
    Get-ChildItem -Path $localPath * -Include *.zip -Recurse | Remove-Item -Force
    Write-Host "Apagando arquivos C:\Power BI Gateway Files\Requestia\*.dat"
    Get-ChildItem -Path $localPath * -Include *.dat -Recurse | Remove-Item -Force
    Write-Host "Apagando arquivos C:\Power BI Gateway Files\Requestia\*.csv"
    Get-ChildItem -Path $localPath * -Include *.csv -Recurse | Remove-Item -Force
    Write-Host "Apagando arquivos C:\Power BI Gateway Files\Requestia\*.xml"
    Get-ChildItem -Path $localPath * -Include *.xml -Recurse | Remove-Item -Force


    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

    # Setup session options from URL
    $SessionDefinitions = $localPath + '\SessionProperties.ps1'
    $SessionProperties = (Get-Content $SessionDefinitions | Out-String)
    $SessionProps = Invoke-Expression $SessionProperties
    $SessionOptions = New-Object WinSCP.SessionOptions -Property $SessionProps

    $session = New-Object WinSCP.Session

    try {
        # Connect
        Write-Host "Conectando ao servidor SFTP $($sessionOptions.UserName)@$($sessionOptions.HostName)"
        $session.SessionLogPath = ".\Get-RequestiaDBExport.log"
        $session.Open($sessionOptions)

        # Enumerate files and directories to download
        $fileInfos =
        $session.EnumerateRemoteFiles(
            $remotePath, $Null,
            ([WinSCP.EnumerationOptions]::EnumerateDirectories -bor
                [WinSCP.EnumerationOptions]::AllDirectories))

        foreach ($fileInfo in $fileInfos) {
            $localFilePath =
            [WinSCP.RemotePath]::TranslateRemotePathToLocal(
                $fileInfo.FullName, $remotePath, $localPath)

            if ($fileInfo.IsDirectory) {
                # Create local subdirectory, if it does not exist yet
                if (!(Test-Path $localFilePath)) {
                    New-Item $localFilePath -ItemType directory | Out-Null
                }
            }
            else {
                Write-Host "Baixando o arquivo $($fileInfo.FullName)..."
                # Download file
                $remoteFilePath = [WinSCP.RemotePath]::EscapeFileMask($fileInfo.FullName)
                $transferResult = $session.GetFiles($remoteFilePath, $localFilePath)

                # Did the download succeeded?
                if (!$transferResult.IsSuccess) {
                    # Print error (but continue with other files)
                    Write-Host (
                        "Erro ao fazer download do arquivo $($fileInfo.FullName): " +
                        "$($transferResult.Failures[0].Message)")
                }
            }
        }
    }
    finally {
        # Disconnect, clean up
        $session.Dispose()
    }

    # Unzip downloaded file
    Write-Host "Descompactando $($localFilePath) ..."
    Expand-Archive -LiteralPath $localFilePath -DestinationPath .

    # Rename to a format that Power BI can read
    Get-ChildItem -Filter "*dat" -Path . -Recurse | Move-Item -Path { $_.FullName } -Destination .
    Get-ChildItem -Filter "*dat" -Path . -Recurse | Rename-Item -NewName { [IO.Path]::ChangeExtension($_.name, "csv") }

    # Send to Azure Storage Account
    . ".\Put-BlobStorageAccount.ps1"
    $Extensions = @(".csv")
    Put-BlobStorageAccount -StorageAccountName cargasdatafactory -StorageAccountKey GvYjzpvw5mecekMecvk/++QRMGmhOVnokgLN

    exit 0
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}

