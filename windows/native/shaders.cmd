@echo off
setlocal
rem ----------------------------------------------------------------
rem Recipe: Windows Native Shader Toolchains (Vulkan, Slang & DXC)
rem ----------------------------------------------------------------

echo [*] Instalando toolchains de shaders (Vulkan SDK, DXC, Slang)...

winget install LunarG.VulkanSDK --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DirectXShaderCompiler --accept-package-agreements --accept-source-agreements 2>nul
winget install -e --id shader-slang.slang --accept-package-agreements --accept-source-agreements 2>nul

if exist "%VCPKG_ROOT%\vcpkg.exe" (
	"%VCPKG_ROOT%\vcpkg.exe" install glslang shaderc directx-dxc spirv-cross --triplet x64-windows
) else (
	vcpkg install glslang shaderc directx-dxc spirv-cross --triplet x64-windows 2>nul
)

echo [V] Toolchains de shaders instaladas com sucesso!
endlocal
