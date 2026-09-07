@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Aseprite Build from Source
rem ----------------------------------------------------------------------------

curl -fsSL -o "Skia-Windows-Release-x64.zip" "https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-Windows-Release-x64.zip"
if %errorlevel% neq 0 exit /b %errorlevel%

if not exist "%TEMP%\skia" mkdir "%TEMP%\skia" 2>nul
tar -xf "Skia-Windows-Release-x64.zip" -C "%TEMP%\skia" 2>nul
del "Skia-Windows-Release-x64.zip" 2>nul

if not exist "aseprite" (
    git clone --recursive "https://github.com/aseprite/aseprite.git"
    if %errorlevel% neq 0 exit /b %errorlevel%
)

cd aseprite
if not exist "build" mkdir build
cd build

call VsDevEnv x64
call VsCMake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR="%TEMP%\skia" -DSKIA_LIBRARY_DIR="%TEMP%\skia\out\Release-x64" -DSKIA_LIBRARY="%TEMP%\skia\out\Release-x64\skia.lib" -G Ninja ..
ninja aseprite

endlocal
