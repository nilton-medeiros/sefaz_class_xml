cls
@echo off
echo.
echo.
cd ACBr
call compila.bat
@IF NOT EXIST libsistrom_ACBrMonitor.a GOTO fim
cd..
cd CTe
call compila.bat
@IF NOT EXIST libsistrom_xmlcte.a GOTO fim
cd..
cd MDFe
call compila.bat
@IF NOT EXIST libsistrom_xmlmdfe.a GOTO fim
cd..
cd funcoes
call compila.bat
@IF NOT EXIST libsistrom_xmlfunctions.a GOTO fim
cd..
:fim
echo.
@echo on