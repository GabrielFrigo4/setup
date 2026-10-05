# ----------------------------------------------------------------
# Recipe: Windows PowerShell Modules, Emacs Daemon & Ollama
# ----------------------------------------------------------------
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

# ----------------------------------------------------------------
# Módulos PowerShell & Políticas
# ----------------------------------------------------------------
Write-Host "📦 [PowerShell]: Instalando módulos essenciais..." -ForegroundColor Cyan

$Modules = @("PSWindowsUpdate", "Terminal-Icons", "NerdFonts", "Fonts", "pstools")
foreach ($Module in $Modules) {
	if (-not (Get-Module -ListAvailable -Name $Module)) {
		Install-Module -Name $Module -Force -SkipPublisherCheck -Scope CurrentUser -ErrorAction SilentlyContinue
	}
}

if ((Get-ExecutionPolicy -Scope CurrentUser) -ne 'RemoteSigned') {
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -ErrorAction SilentlyContinue
}

# ----------------------------------------------------------------
# Rede: Portas Dinâmicas (Padrão IANA: 49152-65535)
# ----------------------------------------------------------------
$IanaStartPort = 49152
$DynamicPorts  = netsh int ipv4 show dynamicport tcp

if ($DynamicPorts -notmatch $IanaStartPort) {
    Write-Host "📦 [Rede]: Ajustando faixa dinâmica do WinNAT para o padrão IANA..." -ForegroundColor Cyan

    $Commands = @(
        "net stop winnat",
        "netsh int ipv4 set dynamicport tcp start=$IanaStartPort num=16384",
        "netsh int ipv6 set dynamicport tcp start=$IanaStartPort num=16384",
        "net start winnat"
    ) -join " && "

    sudo cmd /c $Commands
}

# ----------------------------------------------------------------
# Infraestrutura de Atalhos
# ----------------------------------------------------------------
$WshShell       = New-Object -ComObject WScript.Shell
$UserHome       = $env:USERPROFILE
$AppData        = $env:APPDATA
$LocalAppData   = $env:LOCALAPPDATA
$StartupFolder  = [Environment]::GetFolderPath('Startup')
$CustomFolder   = Join-Path $AppData "Microsoft\Windows\Start Menu\Customizado"

function New-AppShortcut {
	param (
		[Parameter(Mandatory)] [string] $TargetPath,
		[Parameter(Mandatory)] [string] $ShortcutPath,
		[string] $Arguments = "",
		[string] $Description = "",
		[string] $WorkingDirectory = "",
		[string] $IconLocation = ""
	)

	$Folder = Split-Path -Path $ShortcutPath -Parent
	if (-not (Test-Path -Path $Folder)) {
		New-Item -ItemType Directory -Path $Folder -Force | Out-Null
	}

	$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
	$Shortcut.TargetPath = $TargetPath
	if ($Arguments)        { $Shortcut.Arguments =$Arguments }
	if ($Description)      { $Shortcut.Description =$Description }
	if ($WorkingDirectory) { $Shortcut.WorkingDirectory = $WorkingDirectory }
	if ($IconLocation)     { $Shortcut.IconLocation = $IconLocation }
	$Shortcut.Save()
}

# ----------------------------------------------------------------
# Atalhos: Emacs & Daemon
# ----------------------------------------------------------------
Write-Host "📦 [Emacs]: Verificando instalação e gerando atalhos..." -ForegroundColor Cyan

$RunEmacsExe       = "C:\msys64\ucrt64\bin\runemacs.exe"
$EmacsClientExe    = "C:\msys64\ucrt64\bin\emacsclientw.exe"
$TargetFolderEmacs = Join-Path $CustomFolder "Emacs"

if (Test-Path $RunEmacsExe) {
	New-AppShortcut `
		-TargetPath $RunEmacsExe `
		-ShortcutPath "$StartupFolder\Emacs-Daemon.lnk" `
		-Arguments "--fg-daemon --init-directory `"$UserHome\.emacs.d`"" `
		-Description "Inicia o Emacs Daemon no boot"

	New-AppShortcut `
		-TargetPath $RunEmacsExe `
		-ShortcutPath "$TargetFolderEmacs\Emacs.lnk" `
		-Arguments "--init-directory `"$UserHome\.emacs.d`"" `
		-Description "Inicia uma nova instância standalone do Emacs"

	if (Test-Path $EmacsClientExe) {$ClientArgs = "--server-file `"$UserHome\.emacs.d\var\server\auth\server`" --create-frame --alternate-editor `"`"$RunEmacsExe`" --init-directory `"$UserHome\.emacs.d`"`""
		New-AppShortcut `
			-TargetPath $EmacsClientExe `
			-ShortcutPath "$TargetFolderEmacs\Emacs Client.lnk" `
			-Arguments $ClientArgs `
			-Description "Conecta ao Emacs Daemon"
	}
} else {
	Write-Warning "Emacs não foi encontrado em '$RunEmacsExe'. Atalhos ignorados."
}

# ----------------------------------------------------------------
# Atalhos: Ollama
# ----------------------------------------------------------------
Write-Host "📦 [Ollama]: Verificando instalação e gerando atalhos..." -ForegroundColor Cyan

$OllamaAppPath      = Join-Path $LocalAppData "Programs\Ollama\ollama app.exe"
$OllamaIconPath     = Join-Path $LocalAppData "Programs\Ollama\app.ico"

$TargetFolderOllama = Join-Path $CustomFolder "Ollama"
if (Test-Path $OllamaAppPath) {
	New-AppShortcut `
		-TargetPath $OllamaAppPath `
		-ShortcutPath "$StartupFolder\Ollama.lnk" `
		-Description "Inicia o Ollama no boot" `
		-IconLocation $OllamaIconPath

	New-AppShortcut `
		-TargetPath $OllamaAppPath `
		-ShortcutPath "$TargetFolderOllama\Ollama.lnk" `
		-Description "Inicia o Ollama" `
		-IconLocation $OllamaIconPath
} else {
	Write-Warning "Ollama não foi encontrado em '$OllamaAppPath'. Atalhos ignorados."
}

Write-Host "✅ [Windows Config]: Processo finalizado com sucesso!" -ForegroundColor Green
