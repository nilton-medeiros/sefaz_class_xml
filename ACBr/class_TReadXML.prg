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


class TReadXML
   data xmlId
   data stringXML readonly
   data node protected
   data isRead readonly
   data cStat readonly
   data xMotivo readonly
   data tpEvento readonly
   data xEvento readonly
   data dhRecbto  readonly
   data nProt readonly
   data tpDFe protected
   method new(xml_file) constructor
   method xmlNode(xml, tag)
   method isValidated() setget
   method escape()
end class

method new(xml_file, tp_dfe) class TReadXML
   local p, key, seq, inicio, fim
   ::xmlId := ''
   ::node := ''
   ::cStat := ''
   ::xMotivo := ''
   ::tpEvento := ''
   ::xEvento := ''
   ::dhRecbto := ''
   ::nProt := ''
   ::tpDFe := Lower(tp_dfe)
   ::stringXML := hb_MemoRead(xml_file)
   ::isRead := !Empty(::stringXML)
   if ::isRead
      ::node := ::xmlNode(::stringXML, 'infEvento>')
      if Empty(::node)
         ::node :=  ::xmlNode(::stringXML, 'infInut>')
         if Empty(::node)
            ::node := ::xmlNode(::stringXML, 'infProt>')
            if Empty(::node) .and. (::tpDFe == 'mdfe')
               // No retorno do protocolo de recebimento da MDFe é diferente, a tag infProt é <infProt Id="MDFe...">
               ::node := ::xmlNode(::stringXML, 'infProt ')
               if Empty(::node) .and. ('<infProt Id' $ ::stringXML)
                  inicio := hb_At('infProt Id', ::stringXML)
                  fim := hb_At('</infProt>', ::stringXML, inicio) - inicio + 10
                  ::node := SubStr(::stringXML, inicio, fim)
                  saveLog('MDFe| retorno node: ' + iif(Empty(::node), '<<Retornou vazio!>>', ::node))
               endif
            endif
            if Empty(::node)
               ::dhRecbto := ::xmlNode(::stringXML, 'dhRecbto')
               ::cStat := ::xmlNode(::stringXML, 'cStat')
               ::xMotivo := ::xmlNode(::stringXML, 'xMotivo')
               ::nProt := ::xmlNode(::stringXML, 'nProt')
            else // infProt
               ::dhRecbto := ::xmlNode(::node, 'dhRecbto')
               ::cStat := ::xmlNode(::node, 'cStat')
               ::xMotivo := ::xmlNode(::node, 'xMotivo')
               ::nProt := ::xmlNode(::node, 'nProt')
            endif
         else // infInut
            ::dhRecbto := ::xmlNode(::node, 'dhRecbto')
            ::nProt := ::xmlNode(::node, 'nProt')
            ::cStat := ::xmlNode(::node, 'cStat')
            ::xMotivo := ::xmlNode(::node, 'xMotivo')
         endif
      else // infEvento
         ::cStat := ::xmlNode(::node, 'cStat')
         ::tpEvento := ::xmlNode(::node, 'tpEvento')
         ::xEvento := ::xmlNode(::node, 'xEvento')
         if Empty(::xEvento)
            ::xMotivo := ::xmlNode(::node, 'xMotivo')
         else
            ::xMotivo := ::xEvento + ': ' + ::xmlNode(::node, 'xMotivo')
         endif
         ::dhRecbto := ::xmlNode(::node, 'dhRegEvento')
         ::nProt := ::xmlNode(::node, 'nProt')
         if !Empty(::tpEvento)
            key := ::xmlNode(::node, 'chCTe')
            seq := ::xmlNode(::node, 'nSeqEvento')
            if !Empty(key) .and. !Empty(seq)
               ::xmlId := ::tpEvento + key + seq
            elseif !(At('id="id', lower(::stringXML)) == 0)
               ::xmlId := ::tpEvento + SubStr(::stringXML, At('id="id', lower(::stringXML))+6, 52)
            endif
         endif
      endif
      if (::tpDFe == 'mdfe') .and. Empty(::dhRecbto)
         p := At('dhRegEvento:', ::stringXML)
         if !(p == 0) // 2020-05-27T12:33:43-03:00
            ::dhRecbto := SubStr(::stringXML, p + 12, 19)
         endif
         p := At('nProt:', ::stringXML)
         if !(p == 0) // 935200013534028
            ::nProt := SubStr(::stringXML, p + 6, 15)
         endif
      endif
      ::dhRecbto := xmlDateToMySql(::dhRecbto)
      if Empty(::nProt)
         ::nProt := ::xmlNode(::stringXML, 'nRec')
         if Empty(::nProt)
            ::nProt := 'CTeMonitor'
         endif
      endif
      if (ValType(::nProt) == 'N')
         ::nProt := hb_ntos(::nProt)
      endif
      if (ValType(::cStat) == 'N')
         ::cStat := hb_ntos(::cStat)
      endif
      if (::cStat $ '110|301')
         ::xMotivo += '| Verique se a I.E. do emitente esteja suspensa, cancelada, baixada ou em processo de baixa'
      endif
   else
      saveLog('Não foi possível ler arquivo ' + xml_file)
   endif
return self

method xmlNode(xml, tag) class TReadXML
   local inicio, fim, node := ''
   inicio := At('<' + tag, xml)
	// # Nota: A linha abaixo é depois de pagar o início, senão falha
	if (' ' $ tag)
		tag := Left(tag, At(' ', tag) - 1)
	endif
   if (Right(tag, 1) == '>')
      tag := Left(tag, len(tag)-1)
   endif
   if !(inicio == 0)
      inicio += Len(tag) + 2
      if !(inicio == 1) .and. !(SubStr(xml, inicio - 1, 1) == ">") // Caso tenha elementos no bloco
         inicio := hb_At('>', xml, inicio) + 1
      endif
      fim := hb_At('</' + tag + '>', xml, inicio)
      if !(fim == 0)
         fim -= 1
         node := SubStr(xml, inicio, fim - inicio + 1)
      endif
	endif
return ::escape(node)

method isValidated() class TReadXML
   local validatedStatus
   if (::tpDFe == 'cte')
      validatedStatus := ::isRead .and. !Empty(::dhRecbto) .and. !Empty(::nProt) .and. !Empty(::cStat) .and. !Empty(::xMotivo)
   else
      validatedStatus := ::isRead .and. !Empty(::cStat) .and. !Empty(::xMotivo)
   endif
return validatedStatus

method escape(stringXML) class TReadXML
   stringXML := StrTran(stringXML, '&lt;', [<])
   stringXML := StrTran(stringXML, '&gt;', [>])
   stringXML := StrTran(stringXML, '&amp;', [&])
   stringXML := StrTran(stringXML, '&quot;', ["])
   stringXML := StrTran(stringXML, '&#39;', ['])
return AllTrim(stringXML)
