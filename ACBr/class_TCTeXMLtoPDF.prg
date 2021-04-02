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


class TCTeXMLtoPDF
   data xmlString protected
   data node protected
   data lastNode readonly
   data position protected
   data lastTag  protected
   data isRead readonly
   data valid readonly
   data error readonly
   data dfeCancelado readonly
   data chCTe readonly
   method new() constructor
   method isValid() setget
   method getNode()
   method firstNode()
   method nextNode()
   method getSubNode()
   method escape()
end class

method new(xml_file, chDFe) class TCTeXMLtoPDF
   ::xmlString := hb_MemoRead(xml_file)
   ::isRead := !Empty(::xmlString)
   ::node := ''
   ::lastNode := ''
   ::position := 0
   ::lastTag := ''
   ::valid :=  False
   ::error := ''
   ::dfeCancelado := False
   ::chCTe := chDFe
return self

method isValid() class TCTeXMLtoPDF
   local lowerXml := Lower(::xmlString)
   ::error := ''
   if !::isRead
      ::error := 'Erro ao ler Arquivo ' + ::xmlString + hb_eol()
   endif
   if !('<infcte' $ lowerXml)
      ::error := ::error + 'Tag infCte não encontrada' + hb_eol()
   endif
   if !('<ide>' $ lowerXml)
      ::error := ::error + 'Tag infCte não encontrada' + hb_eol()
   endif
   if !('<signature' $ lowerXml)
      ::error := ::error + 'Tag Signature não encontrada' + hb_eol()
   endif
   if !('<protcte' $ lowerXml)
      ::error := ::error + 'Tag protCte não encontrada' + hb_eol()
   endif
   if !('<cstat>100</cstat>' $ lowerXml)
      ::error := ::error + 'A Tag <cstat>100</cstat> não encontradas' + hb_eol()
   endif
   if ('<cstat>135</cstat>' $ lowerXml)
      if !Empty(::chCTe) .and. ('<chcte>' + ::chCTe + '</chcte>' $ lowerXml)
         ::dfeCancelado := True
      endif
   endif
   if !('<chcte>' $ lowerXml)
      ::error := ::error + 'Tag <chCTe> não encontrada' + hb_eol()
   endif
   ::valid := Empty(::error)
return ::valid

method getNode(tag, xmlNode) class TCTeXMLtoPDF
      local inicio, fim
      default xmlNode := ::xmlString
      ::node := ''
      inicio := hb_At('<' + tag, xmlNode)
      // # Nota: A linha abaixo remove o espaço após a tag e é depois de pegar o início, senão falha
      if (' ' $ tag)
         tag := Left(tag, hb_At(' ', tag) - 1)
      endif
      if (Right(tag, 1) == '>')
         tag := Left(tag, len(tag)-1)
      endif
      if !(inicio == 0)
         inicio := inicio + Len(tag) + 2
         if !(inicio == 1) .and. !(SubStr(xmlNode, inicio - 1, 1) == ">") // Caso tenha elementos no bloco
            inicio := hb_At('>', xmlNode, inicio) + 1
         endif
      endif
      fim := hb_At('</' + tag + '>', xmlNode, inicio)
      if !(fim == 0)
         fim--
         ::node := AllTrim(SubStr(xmlNode, inicio, fim - inicio + 1))
         ::position := fim
      endif
return ::escape(::node)

method escape(stringXML) class TCTeXMLtoPDF
   stringXML := StrTran(stringXML, '&lt;', [<])
   stringXML := StrTran(stringXML, '&gt;', [>])
   stringXML := StrTran(stringXML, '&amp;', [&])
   stringXML := StrTran(stringXML, '&quot;', ["])
   stringXML := StrTran(stringXML, '&#39;', ['])
return stringXML

method firstNode(tag) class TCTeXMLtoPDF
   ::lastNode := ::node
   ::lastTag := tag
   ::position := 0
return ::getNode(tag, ::lastNode)

method nextNode() class TCTeXMLtoPDF
   local pos := ::position + Len(::lastTag) + 2
   if !(::position == 0) .and. (pos < Len(::lastNode)) .and. !Empty(::lastNode)
      ::lastNode := SubStr(::lastNode, pos)
   else
      return ''
   endif
return ::getNode(::lastTag, ::lastNode)

method getSubNode(tag, xmlNode) class TCTeXMLtoPDF
   local inicio, fim, rNode := ''
   default xmlNode := ::node
   inicio := hb_At('<' + tag, xmlNode)
   // # Nota: A linha abaixo remove o espaço após a tag e é depois de pagar o início, senão falha
   if (' ' $ tag)
      tag := Left(tag, hb_At(' ', tag) - 1)
   endif
   if !(inicio == 0)
      inicio += Len(tag) + 2
      if !(inicio == 1) .and. !(SubStr(xmlNode, inicio - 1, 1) == ">") // Caso tenha elementos no bloco
         inicio := hb_At('>', xmlNode, inicio) + 1
      endif
   endif
   fim := hb_At('</' + tag + '>', xmlNode, inicio)
   if !(fim == 0)
      fim--
      rNode := AllTrim(SubStr(xmlNode, inicio, fim - inicio + 1))
   endif
return ::escape(rNode)
