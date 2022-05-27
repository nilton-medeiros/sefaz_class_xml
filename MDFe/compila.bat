cls
@echo off
@IF NOT EXIST libsistrom_xmlmdfe.a GOTO setar
del libsistrom_xmlmdfe.a
:setar
echo.
echo.
hbmk2 sistrom_xmlMDFe.hbp -iC:\hmg.3.4.4\INCLUDE
@IF EXIST libsistrom_xmlmdfe.a GOTO copia
echo.
echo Erro: Biblioteca de funcoes XML-MDFe nao gerada!
echo.
GOTO fim
:copia
echo.
copy libsistrom_xmlmdfe.a C:\hmg.3.4.4\lib /Y
echo.
echo		Biblioteca criada com sucesso!
echo.
:fim
echo.
@echo on