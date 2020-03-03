<#
.SYNOPSIS
    Apaga arquivos de forma recursiva, filtrando pela extensao
.EXAMPLE
    $Extensions = @(".zip", ".dat", ".csv", ".xml")
    Delete-FilesByExtension -Path . -Extensions $Extensions
#>
function Delete-FilesByExtension {
    Param (
        # Diretorio onde sera aplicado o comado
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            if( -Not ($_ | Test-Path -PathType Container) ){
                throw "Path $_ nao existe"
            }
            return $true
        })]
        [System.IO.FileInfo] $Path,

        # Array com as extensoes dos arquivos a serem excluidos
        [String[]]$Extensions
    )
    foreach ($Extension in $Extensions) {
        Write-Host "Apagando *$Extension ..."
        Get-ChildItem -Path $Path * -Include "*$Extension" -Recurse | Remove-Item -Force
    }
}