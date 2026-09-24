@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Windows Native GameDev & Graphics Libraries
rem ----------------------------------------------------------------

echo [*] Instalando bibliotecas graficas e gamedev (SDL3, GLFW, Emscripten)...

winget install Microsoft.Vcpkg --accept-package-agreements --accept-source-agreements
scoop install emscripten 2>nul

if exist "%VCPKG_ROOT%\vcpkg.exe" (
	"%VCPKG_ROOT%\vcpkg.exe" install glfw3 sdl3 sdl3-image sdl3-mixer sdl3-ttf sdl3-net sdl3-shadercross --triplet x64-windows
) else (
	vcpkg install glfw3 sdl3 sdl3-image sdl3-mixer sdl3-ttf sdl3-net sdl3-shadercross --triplet x64-windows 2>nul
)

echo [V] Bibliotecas e toolchains gamedev instaladas com sucesso!
endlocal
