param([string]$NetLogoDir = 'C:\Program Files\NetLogo 7.0.4')
$ErrorActionPreference = 'Stop'
$javaV0 = Join-Path $NetLogoDir 'runtime\bin\java.exe'
$classpathV0 = Join-Path $NetLogoDir 'app\*'
$modelV0 = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\modeles\une_vie_de_tortue\v0\vie_de_tortue_v0.nlogo'))
foreach ($scenarioV0 in @('initialisation', 'deplacement-energie', 'mort', 'extinction', 'monde-vide', 'dernier-pas-et-bord')) {
    $csvV0 = Join-Path $PSScriptRoot ($scenarioV0 + '.csv')
    & $javaV0 '-Dfile.encoding=UTF-8' -cp $classpathV0 org.nlogo.headless.Main --model $modelV0 --experiment $scenarioV0 --table $csvV0 --threads 1
    if ($LASTEXITCODE -ne 0) { throw "Echec : $scenarioV0" }
    Write-Output "Termine : $scenarioV0 ; consulter $csvV0"
}
& $javaV0 '-Dfile.encoding=UTF-8' -cp $classpathV0 (Join-Path $PSScriptRoot 'Check.java') $modelV0
if ($LASTEXITCODE -ne 0) { throw 'Echec du controle apres extinction' }
