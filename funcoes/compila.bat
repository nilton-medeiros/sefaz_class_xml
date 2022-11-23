cls
@echo off
@IF NOT EXIST libsistrom_xmlFunctions.a GOTO setar
del libsistrom_xmlFunctions.a
:setar
echo.
echo.
hbmk2 sistrom_xmlFunctions.hbp -iC:\hmg.3.4.4\INCLUDE
@IF EXIST libsistrom_xmlFunctions.a GOTO copia
echo.
echo Erro: Biblioteca de funcoes XML-Functions nao gerada!
echo.
GOTO fim
:copia
echo.
copy libsistrom_xmlFunctions.a C:\hmg.3.4.4\lib /Y
echo.
echo		Biblioteca "libsistrom_xmlFunctions.a" criada com sucesso!
echo.
:fim
echo.
@echo on