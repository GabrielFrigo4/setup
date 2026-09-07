@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: LibreSprite Build from Source (Windows)
rem ----------------------------------------------------------------------------


if not exist "LibreSprite" (
    git clone --recursive "https://github.com/LibreSprite/LibreSprite"
    if %errorlevel% neq 0 exit /b %errorlevel%
)

cd LibreSprite
if not exist "build" mkdir build
cd build

cmake -G Ninja ..
ninja install

endlocal
