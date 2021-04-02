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


class TReadTXT
   data txtFile protected
   data text readonly
   data isRead readonly
   data dhRecbto readonly
   data nProt readonly
   data cStat readonly
   data xMotivo readonly
   data xmlName readonly
   data pdfName readonly
   data isValid readonly
   method new(txt_file) constructor
end class

method new(txt_file, comando) class TReadTXT
   local lowerComando, tpDFe := Left(comando, hb_At('.', comando)-1)
   ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
   ::nProt := 'CTeMonitor'
   ::cStat := '000'
   ::xMotivo := ''
   ::xmlName := ''
   ::pdfName := ''
   ::isValid := False
   ::txtFile := txt_file
   ::text := hb_MemoRead(::txtFile)
   ::isRead := !Empty(::text)
   if ::isRead
      saveLog({'Conteúdo do arquivo lido: ', txt_file, hb_eol(), ::text})
      ::text := StrTran(::text, hb_eol(), '; ')
      lowerComando := Lower(comando)
      if (Left(::text, 2) == 'OK')
         ::isValid := True
         do case
            case ('assinar' $ lowerComando)
               ::xMotivo := tpDFe + ': XML Assinado com sucesso'
               ::xmlName := SubStr(::text, At('C:\', ::text))
               ::xmlName := Left(::xmlName, At('.xml', ::xmlName) + 3)
            case ('validar' $ lowerComando)
               ::xMotivo := tpDFe + ': XML Validado com sucesso'
            case ('imprimirda' $ lowerComando)
               ::xMotivo := 'PDF do ' + 'DA' + Upper(tpDFe) + ' gerado com sucesso'
               ::pdfName := SubStr(::text, At('C:\', ::text))
               ::pdfName := Left(::pdfName, At('.pdf', ::pdfName) + 3)
            case ('imprimirevento' $ lowerComando)
               ::xMotivo := tpDFe + ': PDF do Evento gerado com sucesso'
               ::pdfName := SubStr(::text, At('C:\', ::text))
               ::pdfName := Left(::pdfName, At('.pdf', ::pdfName) + 3)
            otherwise
               ::xMotivo := comando + ': Erro de comando'
               ::isValid := False
         endcase
      else
         do case
            case ('assinar' $ lowerComando)
               ::xMotivo := tpDFe + ': Erro ao Assinar XML'
            case ('validar' $ lowerComando)
               ::xMotivo := tpDFe + ': Erro ao Validar XML'
            case ('imprimirda' $ lowerComando)
               ::xMotivo := tpDFe + ': Erro ao imprimir ' + 'DA' + Upper(tpDFe) + ' em PDF'
            case ('imprimirevento' $ lowerComando)
               ::xMotivo := tpDFe + ': Erro ao imprimir PDF do Evento'
            otherwise
               ::xMotivo := comando + ': Erro'
         endcase
         ::xMotivo := ::xMotivo + '; Resposta: ' + ::text
         ::isValid := False
      endif
   else
      saveLog({'Arquivo ', txt_file, ' não pode ser lido'})
   endif
return self
