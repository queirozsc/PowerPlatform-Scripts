<#
.SYNOPSIS
    Conecta a servidor SFTP
.DESCRIPTION
    Este script conecta a servidor SFTP, a partir de credenciais armazenadas em arquivo
    Requer a biblioteca do WinSCP instalada e chave publica (arquivo .ppk) 
.EXAMPLE
    Connect-SFTP -SessionDefinitionsFile Requestia-SessionProperties.ps1 -SessionLogFile Connect-SFTPRequestia.log
.PARAMETER SessionDefinitionsFile
    Arquivo com as propriedades da sessao. Deve ter a estrutura:
        @{
            Protocol = [WinSCP.Protocol]::Sftp
            HostName = "IP_SERVIDOR_SFTP"
            UserName = "USUARIO_CONEXAO"
            SshPrivateKeyPath = "PATH_ARQUIVO_CHAVE_PUBLICA"
            PrivateKeyPassphrase = "SENHA_USUARIO_CONEXAO"
            SshHostKeyFingerprint = "ssh-rsa 1024 FINGERPRINT_CHAVE_PUBLICA"
        }
.OUTPUTS
    Objeto WinSCP.Session
.NOTES
    Para instalar o WinSCP execute o comando como administrador
    choco install winscp
.LINK
    https://winscp.net/eng/docs/library_example_recursive_download_custom_error_handling#powershell
.LINK
    https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/expand-archive?view=powershell-6
#>
Function Connect-SFTP {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            if( -Not ($_ | Test-Path) ){
                throw "Arquivo $_ nao existe"
            }
            return $true
        })]
        [System.IO.FileInfo] $SessionDefinitionsFile,

        # Arquivo onde sera gravado o log da sessao WinSCP
        [System.IO.FileInfo] $SessionLogFile
    )
    try {
        # Carrega a biblioteca WinSCP
        Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

        # Setup da sessao
        $SessionProperties = (Get-Content $SessionDefinitionsFile | Out-String)
        $SessionProps = Invoke-Expression $SessionProperties
        $SessionOptions = New-Object WinSCP.SessionOptions -Property $SessionProps

        # abre a sessao
        $session = New-Object WinSCP.Session
        $Session.SessionLogPath = $SessionLogFile
        Write-Host "Conectando ao servidor SFTP $($sessionOptions.UserName)@$($sessionOptions.HostName) ..."
        $session.Open($sessionOptions)
        return $session
    }
    catch{
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }
}