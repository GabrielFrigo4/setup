# ------------------------------------------------------------------------------
# Recipe: Synchronize IDE Extensions (PowerShell)
# ------------------------------------------------------------------------------
[CmdletBinding()]
param (
	[ValidateSet("auto", "vscode", "antigravity", "vscodium")]
	[string]$Target = "auto",

	[ValidateSet("install", "export")]
	[string]$Action = "install"
)

$ErrorActionPreference = "Stop"

$Cli = ""
$ResolvedTarget = ""

if ($Target -eq "vscode" -or ($Target -eq "auto" -and (Get-Command code -ErrorAction SilentlyContinue))) {
	$Cli = "code"
	$ResolvedTarget = "vscode"
} elseif ($Target -eq "antigravity" -or ($Target -eq "auto" -and (Get-Command antigravity -ErrorAction SilentlyContinue))) {
	$Cli = "antigravity"
	$ResolvedTarget = "antigravity"
} elseif ($Target -eq "vscodium" -or ($Target -eq "auto" -and (Get-Command codium -ErrorAction SilentlyContinue))) {
	$Cli = "codium"
	$ResolvedTarget = "vscodium"
} else {
	Write-Error "❌ [IDE Extensions]: Nenhuma CLI de editor suportada encontrada (antigravity, code, codium)."
	exit 1
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LocalFile = Join-Path $ScriptDir "..\..\..\..\software\editors\$ResolvedTarget\extensions.txt"
$RawUrl = "https://raw.githubusercontent.com/GabrielFrigo4/Configuration/main/software/editors/$ResolvedTarget/extensions.txt"

if ($Action -eq "export") {
	Write-Host "📦 [IDE Extensions]: Exportando extensões instaladas via $Cli para $LocalFile..."
	$installed = & $Cli --list-extensions | Sort-Object
	$installed | Out-File -FilePath $LocalFile -Encoding utf8
	Write-Host "✅ [IDE Extensions]: Lista exportada com sucesso em $LocalFile!"
	exit 0
}

$Lines = @()
if (Test-Path $LocalFile) {
	$Lines = Get-Content $LocalFile
} else {
	Write-Host "🌐 [IDE Extensions]: Buscando extensões declaradas para $ResolvedTarget no GitHub..."
	try {
		$downloaded = (Invoke-RestMethod -Uri $RawUrl) -split "`r?`n"
		$Lines = $downloaded
	} catch {
		Write-Error "❌ [IDE Extensions]: Erro ao baixar extensões de $RawUrl"
		exit 1
	}
}

Write-Host "📦 [IDE Extensions]: Sincronizando extensões declaradas no $ResolvedTarget ($Cli)..."

foreach ($line in $Lines) {
	$trimmed = $line.Trim()
	if ($trimmed -eq "" -or $trimmed.StartsWith("#")) {
		continue
	}
	Write-Host "  ➔ Instalando: $trimmed"
	& $Cli --install-extension $trimmed --force | Out-Null
}

Write-Host "✅ [IDE Extensions]: Extensões sincronizadas com sucesso no $ResolvedTarget!"
