@echo off
setlocal
cd /d "%~dp0"
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit /b 1
py prepare_models.py
if errorlevel 1 exit /b 1
cmake -S . -B out -G "Visual Studio 17 2022" -A x64
if errorlevel 1 exit /b 1
cmake --build out --config Release --parallel 4
exit /b %errorlevel%
