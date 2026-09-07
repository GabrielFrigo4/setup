@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Flat Assembler Suite (FASM, FASMG, FASMARM)
rem ----------------------------------------------------------------------------

echo [*] Instalando FASM Suite...

mkdir "C:\Program Files\FASM" 2>nul
wget -O "%TEMP%\fasm.zip" "https://flatassembler.net/fasmw17332.zip"
7z x "%TEMP%\fasm.zip" -o"C:\Program Files\FASM" -y
del "%TEMP%\fasm.zip" 2>nul

mkdir "C:\Program Files\FASMG" 2>nul
wget -O "%TEMP%\fasmg.zip" "https://flatassembler.net/fasmg.k7j4.zip"
7z x "%TEMP%\fasmg.zip" -o"C:\Program Files\FASMG" -y
del "%TEMP%\fasmg.zip" 2>nul

mkdir "C:\Program Files\FASMARM" 2>nul
wget -O "%TEMP%\fasmarm.zip" "https://arm.flatassembler.net/FASMARM_win32.ZIP"
7z x "%TEMP%\fasmarm.zip" -o"C:\Program Files\FASMARM" -y
del "%TEMP%\fasmarm.zip" 2>nul

endlocal
