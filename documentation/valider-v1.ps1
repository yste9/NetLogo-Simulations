param([string]$NetLogoDir = 'C:\Program Files\NetLogo 7.0.4')
$ErrorActionPreference = 'Stop'
$javaV1 = Join-Path $NetLogoDir 'runtime\bin\java.exe'
$classpathV1 = Join-Path $NetLogoDir 'app\*'
$modeleV0 = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\modeles\une_vie_de_tortue\v0\vie_de_tortue_v0.nlogo'))
$modeleV1 = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\modeles\une_vie_de_tortue\v1\vie_de_tortue_v1.nlogo'))
& $javaV1 '-Dfile.encoding=UTF-8' -cp $classpathV1 (Join-Path $PSScriptRoot 'CheckV1.java') $modeleV0 $modeleV1 | Tee-Object -FilePath (Join-Path $PSScriptRoot 'resultats-v1.txt')
if ($LASTEXITCODE -ne 0) { throw 'Echec des controles v1' }
