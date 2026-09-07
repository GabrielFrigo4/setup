@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Windows Package Manager (Winget) Curated Packages
rem ----------------------------------------------------------------------------

winget settings --enable InstallerHashOverride

rem --------------------------------
rem language
rem --------------------------------
winget install LLVM.LLVM
winget install zig.zig
winget install GoLang.Go
winget install PyPy.PyPy.3.9
winget install Python.Python.3.14
winget install OpenJS.NodeJS
winget install DenoLand.Deno
winget install Oven-sh.Bun

rem --------------------------------
rem editor
rem --------------------------------
winget install vim.vim
winget install KDE.Kate
winget install Geany.Geany
winget install zyedidia.micro
winget install Notepad++.Notepad++
winget install ArduinoSA.IDE.stable
winget install ZedIndustries.Zed
winget install VSCodium.VSCodium
winget install Google.Antigravity
winget install Google.AntigravityIDE
winget install Google.AntigravityCLI

rem --------------------------------
rem debugger
rem --------------------------------
winget install dnSpyEx.dnSpy
winget install x64dbg.x64dbg
winget install Hex-Rays.IDA.Free
winget instalL Rizin.Cutter

rem --------------------------------
rem database
rem --------------------------------
winget install dbeaver.dbeaver

rem --------------------------------
rem hardware
rem --------------------------------
winget install Intel.OneAPI.BaseToolkit
winget install KhronosGroup.VulkanSDK
winget install Nvidia.CUDA

rem --------------------------------
rem framework
rem --------------------------------
winget install Love2d.Love2d

rem --------------------------------
rem gnuwin32
rem --------------------------------
winget install GnuWin32.Bison
winget install GnuWin32.Cpio
winget install GnuWin32.DiffUtils
winget install GnuWin32.File
winget install GnuWin32.Flex
winget install GnuWin32.GetText
winget install GnuWin32.Grep
winget install GnuWin32.Gzip
winget install GnuWin32.M4
winget install GnuWin32.Make
winget install GnuWin32.UnZip
winget install GnuWin32.Zip
winget install GnuWin32.FindUtils
winget install GnuWin32.Gperf
winget install GnuWin32.Patch
winget install GnuWin32.Tar
winget install GnuWin32.Tree
winget install GnuWin32.Which

rem --------------------------------
rem terminal
rem --------------------------------
winget install GNU.Wget2
winget install JernejSimoncic.Wget
winget install waterlan.dos2unix
winget install JohnMacFarlane.Pandoc
winget install equalsraf.win32yank

rem --------------------------------
rem security
rem --------------------------------
winget install FireDaemon.OpenSSL
winget install Insecure.Nmap
winget install Insecure.Npcap
winget install GnuPG.Gpg4win

rem --------------------------------
rem internet
rem --------------------------------
winget install OpenVPNTechnologies.OpenVPN
winget install OpenVPNTechnologies.OpenVPNConnect
winget install WiresharkFoundation.Wireshark
winget install WinSCP.WinSCP
winget install PuTTY.PuTTY

rem --------------------------------
rem memory
rem --------------------------------
winget install Rufus.Rufus
winget install balenaEtcher
winget install Ventoy.Ventoy
winget install Piriform.Recuva
winget install RARLab.WinRAR
winget install 7zip.7zip

rem --------------------------------
rem information
rem --------------------------------
winget install CPUID.CPU-Z
winget install TechPowerUp.GPU-Z
winget install nepnep.neofetch-win
winget install JosephFinney.Text-Grab

rem --------------------------------
rem microsoft
rem --------------------------------
winget install Microsoft.err
winget install Microsoft.Git
winget install Microsoft.Edit
winget install Microsoft.Coreutils
winget install Microsoft.PowerShell
winget install Microsoft.VisualStudioCode
winget install Microsoft.VisualStudio.Community
winget install Microsoft.VisualStudio.BuildTools
winget install Microsoft.Sysinternals.TCPView
winget install Microsoft.MSIXPackagingTool
winget install Microsoft.WindowsTerminal
winget install Microsoft.PowerToys
winget install Microsoft.WinDbg

rem --------------------------------
rem github
rem --------------------------------
winget install hickford.git-credential-oauth
winget install GitHub.GitHubDesktop
winget install GitHub.cli

rem --------------------------------
rem shell
rem --------------------------------
winget install nushell
winget install chrisant996.Clink
winget install JanDeDobbeleer.OhMyPosh
winget install MSYS2.MSYS2

rem --------------------------------
rem hyper-v
rem --------------------------------
winget install SoftwareFreedomConservancy.QEMU
winget install Oracle.VirtualBox

rem --------------------------------
rem wsl
rem --------------------------------
winget install Microsoft.WSL.PreRelease
winget install dorssel.usbipd-win
winget install Docker.DockerDesktop
winget install RedHat.Podman

rem --------------------------------
rem office
rem --------------------------------
winget install ONLYOFFICE.DesktopEditors
winget install TheDocumentFoundation.LibreOffice

rem --------------------------------
rem browser
rem --------------------------------
winget install Google.Chrome
winget install Mozilla.Firefox.pt-BR
winget install firefoxpwa

rem --------------------------------
rem tweaker
rem --------------------------------
winget install winaero.tweaker
winget install ArminOsaj.AutoDarkMode

rem --------------------------------
rem math
rem --------------------------------
winget install Scilab.Scilab

rem --------------------------------
rem draw
rem --------------------------------
winget install KDE.Krita
winget install GIMP.GIMP.3
winget install Inkscape.Inkscape
winget install BlenderFoundation.Blender

rem --------------------------------
rem game
rem --------------------------------
winget install Valve.Steam
winget install Discord.Discord
winget install Unity.UnityHub

rem --------------------------------
rem device
rem --------------------------------
winget install Logitech.GHUB
winget install timschneeb.GalaxyBudsClient
winget install OBSProject.OBSStudio

rem --------------------------------
rem programming
rem --------------------------------
winget pin add MSYS2.MSYS2
winget pin add Nvidia.CUDA
winget pin add Python.Python.3.14
winget pin add Microsoft.VisualStudio.Community
winget pin add Microsoft.VisualStudio.BuildTools
winget pin add ZedIndustries.Zed

rem --------------------------------
rem software
rem --------------------------------
winget pin add Logitech.GHUB
winget pin add OBSProject.OBSStudio
winget pin add Dell.PeripheralManager
winget pin add Discord.Discord
endlocal
