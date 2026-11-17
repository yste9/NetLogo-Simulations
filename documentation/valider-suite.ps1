param([string]$NetLogoDir = 'C:\Program Files\NetLogo 7.0.4')
$ErrorActionPreference = 'Stop'
$javaSuite = Join-Path $NetLogoDir 'runtime\bin\java.exe'
$classpathSuite = Join-Path $NetLogoDir 'app\*'
$modelesSuite = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\modeles\une_vie_de_tortue'))
& $javaSuite '-Dfile.encoding=UTF-8' -cp $classpathSuite (Join-Path $PSScriptRoot 'CheckSuite.java') $modelesSuite | Tee-Object -FilePath (Join-Path $PSScriptRoot 'resultats-suite.txt')
if ($LASTEXITCODE -ne 0) { throw 'Echec des controles v2-v4' }
