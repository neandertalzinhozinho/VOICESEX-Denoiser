@echo off
cd /d "C:\Users\nean\Documents\Projetos-claude\VOICESEX1\native\sexyvox"

echo Compilando teste de debug do Combinador...

cl.exe /std:c++17 /EHsc /I. /I"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\include" ^
    Combinador.cpp CombinadorTestDebug.cpp ^
    "build_combinador\CombinadorTest_artefacts\JuceLibraryCode\include_juce_dsp.cpp" ^
    /Fe:CombinadorTestDebug.exe ^
    /link /LIBPATH:"C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.44.35207\lib\x64"

if errorlevel 1 (
    echo Falha na compilacao
    exit /b 1
)

echo.
echo Executando teste...
CombinadorTestDebug.exe
