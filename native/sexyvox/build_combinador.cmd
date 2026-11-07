@echo off
REM Build isolado do CombinadorTest
REM Não interfere com o build principal do SEXYVOX

if not exist "build_combinador" mkdir build_combinador
cd build_combinador

cmake .. -G "Visual Studio 17 2022" -A x64
cmake --build . --config Release --target CombinadorTest

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERRO] Falha na compilacao
    exit /b 1
)

echo.
echo [OK] Build concluido com sucesso
echo.
echo Executando testes...
echo ========================================
CombinadorTest_artefacts\Release\CombinadorTest.exe
echo ========================================
echo.

if %ERRORLEVEL% EQU 0 (
    echo [OK] Todos os testes passaram
) else (
    echo [ERRO] Alguns testes falharam
)

cd ..
