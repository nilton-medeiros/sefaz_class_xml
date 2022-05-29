cls
@echo off
@IF NOT EXIST libsistrom_ACBrMonitor.a GOTO setar
del libsistrom_ACBrMonitor.a
:setar
echo.
echo.
hbmk2 sistrom_ACBrMonitor.hbp -iC:\hmg.3.4.4\INCLUDE
@IF EXIST libsistrom_ACBrMonitor.a GOTO copia
echo.
echo Erro: Biblioteca de classes de controle do ACBrMonitor nao gerada!
echo.
GOTO fim
:copia
echo.
copy libsistrom_ACBrMonitor.a C:\hmg.3.4.4\lib /Y
echo.
echo		Biblioteca criada com sucesso!
echo.
:fim
echo.
@echo on