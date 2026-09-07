@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Windows Development Tools
rem ----------------------------------------------------------------------------

echo [*] Instalando ferramentas essenciais de desenvolvimento...

winget install Microsoft.VisualStudio.Community --accept-package-agreements --accept-source-agreements
winget install Microsoft.VisualStudio.BuildTools --accept-package-agreements --accept-source-agreements
winget install Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements
winget install Microsoft.PowerToys --accept-package-agreements --accept-source-agreements
winget install Microsoft.Sysinternals.TCPView --accept-package-agreements --accept-source-agreements
winget install Microsoft.WinDbg --accept-package-agreements --accept-source-agreements

echo [V] Ferramentas de desenvolvimento instaladas com sucesso!
endlocal
