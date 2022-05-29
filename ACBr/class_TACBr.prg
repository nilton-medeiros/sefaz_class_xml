/*
   Projeto: CTeMonitor
   Executavel multiplataforma que faz o intercâmbio do TMS.CLOUD WEB com o ACBrMonitorPlus
   para criar uma interface de comunicação com a Sefaz através de comandos para o ACBrMonitorPlus.

   Direitos Autorais Reservados (c) 2020 Nilton Gonçalves Medeiros

   Colaboradores nesse arquivo:

   Você pode obter a última versão desse arquivo no GitHub
   Componentes localizado em https://github.com/nilton-medeiros/cte-monitor

    Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la
   sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela
   Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)
   qualquer versão posterior.

    Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM
   NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU
   ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor
   do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)

    Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto
   com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,
   no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.
   Você também pode obter uma copia da licença em:
   http://www.opensource.org/licenses/gpl-license.php

   Nilton Gonçalves Medeiros - nilton@sistrom.com.br - www.sistrom.com.br
   Caieiras - SP
*/

#include <hmg.ch>
#include "hbclass.ch"


class TACBr
   data installedStatus readonly
   data activeStatus readonly
   data rootPath readonly
   data inputPath readonly
   data outputPath readonly
   data returnPath readonly
   data DFePath readonly
   data xmlPath readonly
   data pdfPath readonly
   data sharedPath readonly
   method new() constructor
   method isActive()
   method setSharedPath()
end class

method new(sharedFolder) class TACBr
   ::rootPath := 'C:\ACBrMonitorPLUS\'
   if (ValType(sharedFolder) == 'C') .or. !Empty(sharedFolder)
      ::sharedPath := sharedFolder
   else
      ::sharedPath := ''
   endif
   ::installedStatus := False
   ::activeStatus := False
   ::inputPath := ::rootPath + 'entrada\'
   ::outputPath := ::rootPath + 'saida\'
   ::returnPath := ::rootPath + 'retorno\'
   ::DFePath := ::rootPath + 'DFes\'
   ::xmlPath := ::rootPath + 'xml\'
   ::pdfPath := ::rootPath + 'pdf\'

   // Cria a pasta de xml lidos pelo CTeMonitor
   if hb_DirExists(::returnPath + 'lidos')
      AEval(Directory(::returnPath + 'lidos\*.*'), {|aFile| iif(aFile[3] <= (Date()-07), hb_FileDelete(::returnPath + 'lidos\*.*'), NIL)})
   else
      hb_DirBuild(::returnPath + 'lidos')
   endif
   if (RegistryRead(Memvar->appData:registryPath + "Monitoring\DontRun") == 0)
      ::isActive()
   endif
return self

method isActive class TACBr
   ::activeStatus := False
   if (getProcessId('ACBRMONITOR.EXE') == 0)
      if hb_FileExists(::rootPath+'ACBrMonitor.exe')
         ::installedStatus := True
         EXECUTE FILE ::rootPath + 'ACBrMonitor.exe'
         sysWait()
      else
         saveLog({'ACBrMonitor não está instalado!', hb_eol(), 'rootPath: ', ::rootPath, hb_eol()})
      endif
      if (getProcessId('ACBRMONITOR.EXE') == 0)
         saveLog({'ACBrMonitor não está executando!', hb_eol(), 'rootPath: ', ::rootPath, hb_eol()})
      else
         ::activeStatus := True
      endif
   else
      ::installedStatus := True
      ::activeStatus := True
   endif
return ::activeStatus

method setSharedPath(newPath) class TACBr
   ::sharedPath := newPath
return nil