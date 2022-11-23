cls
@echo off
@IF NOT EXIST libsistrom_xmlCTe.a GOTO setar
del libsistrom_xmlCTe.a
:setar
echo.
echo.
hbmk2 sistrom_xmlCTe.hbp -iC:\hmg.3.4.4\INCLUDE
@IF EXIST libsistrom_xmlCTe.a GOTO copia
echo.
echo Erro: Biblioteca de funcoes XML-CTe nao gerada!
echo.
GOTO fim
:copia
echo.
copy libsistrom_xmlCTe.a C:\hmg.3.4.4\lib /Y
echo.
echo		Biblioteca "libsistrom_xmlCTe.a" criada com sucesso!
echo.
:fim
echo.
@echo on