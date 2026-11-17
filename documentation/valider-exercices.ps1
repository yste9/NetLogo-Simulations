param([string]$NetLogoDir = 'C:\Program Files\NetLogo 7.0.4')
$ErrorActionPreference = 'Stop'
$javaExercices = Join-Path $NetLogoDir 'runtime\bin\java.exe'
$classpathExercices = Join-Path $NetLogoDir 'app\*'
$racineExercices = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
& $javaExercices '-Dfile.encoding=UTF-8' -cp $classpathExercices (Join-Path $PSScriptRoot 'CheckExercices.java') $racineExercices | Tee-Object -FilePath (Join-Path $PSScriptRoot 'resultats-exercices.txt')
if ($LASTEXITCODE -ne 0) { throw 'Echec de la validation des exercices suivants' }
