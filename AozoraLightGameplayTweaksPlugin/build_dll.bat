@echo off
setlocal
cd /d "%~dp0"

echo [1/4] Setting up VS 2026 environment...
call "D:\Program Files\Microsoft Visual Studio\VC\Auxiliary\Build\vcvarsall.bat" amd64
if %ERRORLEVEL% neq 0 (
    echo [ERROR] vcvarsall.bat failed
    exit /b 1
)

echo [2/4] Compiling source...
if not exist "build\msvc" mkdir "build\msvc"
cl /nologo /std:c++latest /EHsc /MD /O2 /DNDEBUG ^
    /I"Y:\Games\MODCreation\Workspace\commonlibf4-frakkin64\include" ^
    /I"Y:\Games\MODCreation\Workspace\commonlibf4-frakkin64\lib\commonlib-shared\include" ^
    /I"%CD%\src" ^
    /Fo"build\msvc\main.obj" ^
    /c "src\main.cpp"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] compile failed
    exit /b 1
)

echo [3/4] Linking DLL...
link /NOLOGO /DLL ^
    /OUT:"build\msvc\AozoraLightGameplayTweaks.dll" ^
    "build\msvc\main.obj" ^
    "Y:\Games\MODCreation\Workspace\OutfitManager_2.0_BuildCache\build\windows\x64\release\commonlibf4.lib" ^
    "Y:\Games\MODCreation\Workspace\OutfitManager_2.0_BuildCache\build\windows\x64\release\commonlib-shared.lib" ^
    "C:\Users\Sylva\AppData\Local\.xmake\packages\s\spdlog\v1.16.0\1053dccb2da94316b3bef3cb1db15374\lib\spdlog.lib" ^
    version.lib dbghelp.lib user32.lib shell32.lib advapi32.lib bcrypt.lib d3d11.lib d3dcompiler.lib dxgi.lib ole32.lib ws2_32.lib
if %ERRORLEVEL% neq 0 (
    echo [ERROR] link failed
    exit /b 1
)

echo [4/4] Copying DLL to mod folder...
if not exist "..\AozoraLightGameplayTweaks\F4SE\Plugins" mkdir "..\AozoraLightGameplayTweaks\F4SE\Plugins"
copy /Y "build\msvc\AozoraLightGameplayTweaks.dll" "..\AozoraLightGameplayTweaks\F4SE\Plugins\AozoraLightGameplayTweaks.dll"
echo [DONE] DLL copied to mod folder.
