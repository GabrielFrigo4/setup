# ------------------------------------------------------------------------------
# Script: Windows PowerShell Modules & Emacs Daemon Startup Configuration
# ------------------------------------------------------------------------------
[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

Write-Host "📦 [Windows Config]: Instalando módulos essenciais do PowerShell..."

@("PSWindowsUpdate", "Terminal-Icons", "NerdFonts", "Fonts", "pstools") | ForEach-Object {
	Install-Module -Name $_ -Force -SkipPublisherCheck -Scope CurrentUser -ErrorAction SilentlyContinue
}

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

Write-Host "📦 [Windows Config]: Configurando atalhos de inicialização do Emacs Daemon..."

$WshShell = New-Object -ComObject WScript.Shell
$UserHome = $env:USERPROFILE
$AppData = $env:APPDATA
$StartupFolder = [Environment]::GetFolderPath('Startup')

$Shortcut = $WshShell.CreateShortcut("$StartupFolder\Emacs-Daemon.lnk")
$Shortcut.TargetPath = "C:\msys64\ucrt64\bin\runemacs.exe"
$Shortcut.Arguments = "--fg-daemon --init-directory `"$UserHome\.emacs.d`""
$Shortcut.Save()

$TargetFolder = Join-Path $AppData "Microsoft\Windows\Start Menu\Customizado\Emacs"
if (!(Test-Path -Path $TargetFolder)) {
	New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
}

$ShortcutNormal = $WshShell.CreateShortcut("$TargetFolder\Emacs.lnk")
$ShortcutNormal.TargetPath = "C:\msys64\ucrt64\bin\runemacs.exe"
$ShortcutNormal.Arguments = "--init-directory `"$UserHome\.emacs.d`""
$ShortcutNormal.Description = "Inicia uma nova instância standalone do Emacs"
$ShortcutNormal.Save()

$ShortcutClient = $WshShell.CreateShortcut("$TargetFolder\Emacs Client.lnk")
$ShortcutClient.TargetPath = "C:\msys64\ucrt64\bin\emacsclientw.exe"
$ShortcutClient.Arguments = "--server-file `"$UserHome\.emacs.d\var\server\auth\server`" --create-frame --alternate-editor `"`"C:\msys64\ucrt64\bin\runemacs.exe`" --init-directory `"$UserHome\.emacs.d`"`""
$ShortcutClient.Description = "Conecta ao Emacs Daemon"
$ShortcutClient.Save()

Write-Host "✅ [Windows Config]: Módulos e atalhos configurados com sucesso!"
