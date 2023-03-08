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


class TGerarPDFdeXML
   data pdfName readonly
   data ok readonly
   data dhRecbto readonly
   data canceladoStatus readonly
   method new() constructor
   method dhXMLtoPDF()
   method getInfImposto()
   method formattedCep(cep)
   method formattedDoc(doc)
   method formattedFone(fone)

end class

method new(xmlName, outPath, systemPath, chDFe) class TGerarPDFdeXML
   local x, pos, aindaTemDocs, pdf, imp, node, vPrest, tpAmb, infDoc, logotipo
   local serie, chave, tpDoc, nDoc, dEmi, vDocFisc, dPrev, obs, aList
   local qtdeDocs, qtdePags, dif, doc, lado1 := {}, lado2 := {}, docsOriginarios := {}
   local descricao, xml := TCTeXMLtoPDF():new(xmlName, chDFe)
   local ind_globalizado := False

   ::pdfName := ''
   ::ok := False
   ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
   ::canceladoStatus := xml:dfeCancelado

   if xml:isValid
      // Verifica se existe o logotipo do Emissor em JPG ou PNG
      logotipo := systemPath + 'logoEmissor.jpg'
      if !hb_FileExists(logotipo)
         logotipo := systemPath + 'logoEmissor.png'
         if !hb_FileExists(logotipo)
            logotipo := ''
            saveLog('Logotipo do emitente nao encontrado')
         endif
      endif

      // Carrega todos os documentos de infDoc (infNFe/infOutros/infNF)
      infDoc := xml:getNode('infDoc')
      if !Empty(infDoc)
         node := xml:getSubNode('infNFe', infDoc)
         if Empty(node)
            node := xml:getSubNode('infOutros', infDoc)
            if Empty(node) .and. !Empty(xml:getSubNode('infNF', infDoc))
               node := xml:firstNode('infNF')
               do while !Empty(node)
                  tpDoc := xml:getSubNode('mod', node)
                  serie := xml:getSubNode('serie', node)
                  nDoc := xml:getSubNode('nDoc', node)
                  if (tpDoc == '04')
                     tpDoc := '04 - NF de Produtor'
                  else
                     tpDoc := '01 - NF Modelo 01/1A e Avulsa'
                  endif
                  AAdd(docsOriginarios, {'tpDoc' => tpDoc, 'descricao' => '', 'nDoc' => nDoc})
                  node := xml:nextNode()
               enddo
            else
               node := xml:firstNode('infOutros')
               do while !Empty(node)
                  tpDoc := xml:getSubNode('tpDoc', node)
                  nDoc := xml:getSubNode('nDoc', node)
                  dEmi := DToC(hb_StoD(StrTran(xml:getSubNode('dEmi', node), '-')))
                  vDocFisc := hb_Val(xml:getSubNode('vDocFisc', node))
                  vDocFisc := LTrim(Transform(vDocFisc, '@E 999,999,999,999.99'))
                  dPrev := xml:getSubNode('dPrev', node)
                  if !Empty(dPrev)
                     dPrev := hb_StoD(StrTran(xml:getSubNode('dPrev', node), '-'))
                     dPrev := DToC(dPrev)
                  endif
                  switch tpDoc
                     case '00'
                        tpDoc := '00 - Declaração'
                        exit
                     case '10'
                        tpDoc := '10 - Dutoviário'
                        exit
                     case '59'
                        tpDoc := '59 - CF-e SAT'
                        exit
                     case '65'
                        tpDoc := '65 - NFC-e'
                        exit
                     case '99'
                        tpDoc := '99 - Outros'
                        exit
                  endswitch
                  descricao := 'Emissão: ' + dEmi + '  Valor: ' + vDocFisc
                  if !Empty(dPrev)
                     descricao := descricao + '  Entrega: ' + dPrev
                  endif
                  AAdd(docsOriginarios, {'tpDoc' => tpDoc, 'descricao' => descricao, 'nDoc' => nDoc})
                  node := xml:nextNode()
               enddo
            endif
         else
            node := xml:firstNode('infNFe')
            do while !Empty(node)
               chave := xml:getSubNode('chave', node)
               serie := hb_utf8SubStr(chave, 23, 3)
               nDoc := hb_utf8SubStr(chave, 26, 9)
               AAdd(docsOriginarios, {'tpDoc' => 'NFE', 'descricao' => chave, 'nDoc' => nDoc})
               node := xml:nextNode()
            enddo
         endif
         // Ordena o array por ordem do numero do doc
         ASort(docsOriginarios,,, {|x, y| x['nDoc'] < y['nDoc']})
      endif

      tpAmb := xml:getNode('tpAmb')
      node := xml:getNode('chCTe')
      ind_globalizado := xml:getNote('indGlobalizado')
      if (ValType(ind_globalizado) == 'N')
         ind_globalizado := hb_ntos(ind_globalizado)
      endif
      ind_globalizado := (ind_globalizado == '1')
      pdf := THPDFDoc():new(outPath, logotipo, node, tpAmb, ind_globalizado)

      // Calcula o total de páginas no PDF baseado na qtde de documentos originários NFe/NF/Declarações...
      qtdeDocs := hmg_len(docsOriginarios)
      if (qtdeDocs < 23)
         pdf:totPag := 1
      else
         qtdeDocs -= 22 // Tira a primeira página q só cabe 22, as demais vão até 66 docs
         qtdePags := (qtdeDocs/66)
         pdf:totPag := Int(qtdePags)
         dif := qtdePags - pdf:totPag
         if !(dif == 0)
            pdf:totPag := pdf:totPag + 1
         endif
         pdf:totPag := pdf:totPag + 1 // Acresenta 1 ao total de página, pois a primeira página c/22 docs não foi contado
      endif

      // Usando configurações de paper padrão. Antes do startPDF(), pode definir algumas configurações como pdf:paper:orientation := 2 (paisagem)
      if pdf:startPDF()

         // Dados do CTe
         xml:getNode('ide')
         pdf:mod := xml:getSubNode('mod')
         pdf:serie := xml:getSubNode('serie')
         pdf:nCT := xml:getSubNode('nCT')
         pdf:dhEmi := ::dhXMLtoPDF(xml:getSubNode('dhEmi'))
         pdf:cfop := xml:getSubNode('CFOP') + ' - ' + xml:getSubNode('natOp')
         pdf:modal := iif(xml:getSubNode('modal') == '01', 'RODOVIÁRIO', 'AÉREO')

         // Emitente
         xml:getNode('emit')
         pdf:emi:nome := xml:getSubNode('xNome')
         pdf:emi:endereco := RTrim(xml:getSubNode('xLgr') + ', ' + xml:getSubNode('nro') + ' ' + xml:getSubNode('xCpl'))
         pdf:emi:bairro := xml:getSubNode('xBairro')
         pdf:emi:cep := ::formattedCep(xml:getSubNode('CEP'))
         pdf:emi:municipio := xml:getSubNode('xMun')
         pdf:emi:uf := xml:getSubNode('UF')
         pdf:emi:fone := ::formattedFone(xml:getSubNode('fone'))
         pdf:emi:doc := ::formattedDoc(xml:getSubNode('CNPJ'))
         pdf:emi:ie := xml:getSubNode('IE')

         pdf:nProt := xml:getNode('nProt') + ' - ' + ::dhXMLtoPDF(xml:getNode('dhRecbto'))
         pdf:iniPrest := xml:getNode('UFIni') + ' - ' + xml:getNode('xMunIni') + ' - ' + xml:getNode('cMunIni')
         pdf:fimPrest := xml:getNode('UFFim') + ' - ' + xml:getNode('xMunFim') + ' - ' + xml:getNode('cMunFim')

         // Remetente
         xml:getNode('rem')
         pdf:rem:nome := xml:getSubNode('xNome')
         pdf:rem:endereco := RTrim(xml:getSubNode('xLgr') + ', ' + xml:getSubNode('nro') + ' ' + xml:getSubNode('xCpl'))
         pdf:rem:bairro := xml:getSubNode('xBairro')
         pdf:rem:cep := ::formattedCep(xml:getSubNode('CEP'))
         pdf:rem:municipio := xml:getSubNode('xMun')
         pdf:rem:uf := xml:getSubNode('UF')
         pdf:rem:fone := ::formattedFone(xml:getSubNode('fone'))
         pdf:rem:doc := xml:getSubNode('CNPJ')
         if Empty(pdf:rem:doc)
            pdf:rem:doc := xml:getSubNode('CPF')
         endif
         pdf:rem:doc := ::formattedDoc(pdf:rem:doc)
         pdf:rem:ie := xml:getSubNode('IE')
         pdf:rem:pais := xml:getSubNode('xPais')

         // Destinatário
         xml:getNode('dest>')
         pdf:des:nome := xml:getSubNode('xNome')
         pdf:des:endereco := RTrim(xml:getSubNode('xLgr') + ', ' + xml:getSubNode('nro') + ' ' + xml:getSubNode('xCpl'))
         pdf:des:bairro := xml:getSubNode('xBairro')
         pdf:des:cep := ::formattedCep(xml:getSubNode('CEP'))
         pdf:des:municipio := xml:getSubNode('xMun')
         pdf:des:uf := xml:getSubNode('UF')
         pdf:des:fone := ::formattedFone(xml:getSubNode('fone'))
         pdf:des:doc := xml:getSubNode('CNPJ')
         if Empty(pdf:des:doc)
            pdf:des:doc := xml:getSubNode('CPF')
         endif
         pdf:des:doc := ::formattedDoc(pdf:des:doc)
         pdf:des:ie := xml:getSubNode('IE')
         pdf:des:pais := xml:getSubNode('xPais')

         // Expedidor
         if !Empty(xml:getNode('exped'))
            pdf:exp:nome := xml:getSubNode('xNome')
            pdf:exp:endereco := RTrim(xml:getSubNode('xLgr') + ', ' + xml:getSubNode('nro') + ' ' + xml:getSubNode('xCpl'))
            pdf:exp:bairro := xml:getSubNode('xBairro')
            pdf:exp:cep := ::formattedCep(xml:getSubNode('CEP'))
            pdf:exp:municipio := xml:getSubNode('xMun')
            pdf:exp:uf := xml:getSubNode('UF')
            pdf:exp:fone := ::formattedFone(xml:getSubNode('fone'))
            pdf:exp:doc := xml:getSubNode('CNPJ')
            if Empty(pdf:exp:doc)
               pdf:exp:doc := xml:getSubNode('CPF')
            endif
            pdf:exp:doc := ::formattedDoc(pdf:exp:doc)
            pdf:exp:ie := xml:getSubNode('IE')
            pdf:exp:pais := xml:getSubNode('xPais')
         endif

         // Recebedor
         if !Empty(xml:getNode('receb'))
            pdf:rec:nome := xml:getSubNode('xNome')
            pdf:rec:endereco := RTrim(xml:getSubNode('xLgr') + ', ' + xml:getSubNode('nro') + ' ' + xml:getSubNode('xCpl'))
            pdf:rec:bairro := xml:getSubNode('xBairro')
            pdf:rec:cep := ::formattedCep(xml:getSubNode('CEP'))
            pdf:rec:municipio := xml:getSubNode('xMun')
            pdf:rec:uf := xml:getSubNode('UF')
            pdf:rec:fone := ::formattedFone(xml:getSubNode('fone'))
            pdf:rec:doc := xml:getSubNode('CNPJ')
            if Empty(pdf:rec:doc)
               pdf:rec:doc := xml:getSubNode('CPF')
            endif
            pdf:rec:doc := ::formattedDoc(pdf:rec:doc)
            pdf:rec:ie := xml:getSubNode('IE')
            pdf:rec:pais := xml:getSubNode('xPais')
         endif

         // Tomador
         node := xml:getNode('toma3')
         if Empty(node)
            node := xml:getNode('toma4')
         endif
         node := xml:getSubNode('toma')
         switch node
            case '0' // Remetente
               pdf:tom := pdf:rem
               exit
            case '1' // Expedidor
               pdf:tom := pdf:exp
               exit
            case '2' // Recebedor
               pdf:tom := pdf:rec
               exit
            case '3' // Destinatário
               pdf:tom := pdf:des
               exit
            case '4' // Outros
               if !Empty(xml:getNode('toma4'))
                  pdf:tom:nome := xml:getSubNode('xNome')
                  pdf:tom:endereco := RTrim(xml:getSubNode('xLgr') + ', ' + xml:getSubNode('nro') + ' ' + xml:getSubNode('xCpl'))
                  pdf:tom:bairro := xml:getSubNode('xBairro')
                  pdf:tom:cep := ::formattedCep(xml:getSubNode('CEP'))
                  pdf:tom:municipio := xml:getSubNode('xMun')
                  pdf:tom:uf := xml:getSubNode('UF')
                  pdf:tom:fone := ::formattedFone(xml:getSubNode('fone'))
                  pdf:tom:doc := xml:getSubNode('CNPJ')
                  if Empty(pdf:tom:doc)
                     pdf:tom:doc := xml:getSubNode('CPF')
                  endif
                  pdf:tom:doc := ::formattedDoc(pdf:tom:doc)
                  pdf:tom:ie := xml:getSubNode('IE')
                  pdf:tom:pais := xml:getSubNode('xPais')
               endif
               exit
         endswitch

         START HPDFDOC
         pdf:encoding()
         aindaTemDocs := True

         do while aindaTemDocs
            START HPDFPAGE
               pdf:pageHeader()
               pdf:pageBody()
               pdf:setFont({'size' => 7, 'bold' => True, 'position' => 'LEFT'})
               if (pdf:pagina == 1)
                  // Dados do Expedidor
                  if !Empty(pdf:exp:nome)
                     pdf:printText(Left(pdf:exp:nome, 58), 114, 16)
                     pdf:printText(pdf:exp:endereco + ' ' + pdf:exp:complemento, 117, 16)
                     pdf:printText(pdf:exp:bairro, 120, 16)
                     pdf:printText(pdf:exp:municipio + ' - ' + pdf:exp:uf, 123, 16)
                     pdf:printText(pdf:exp:doc, 126, 16)
                     pdf:printText(pdf:exp:pais, 129, 16)
                     pdf:font:Position := 'RIGHT'
                     pdf:printText(pdf:exp:cep, 123, 104)
                     pdf:printText(pdf:exp:ie, 126, 104)
                     pdf:printText(pdf:exp:fone, 129, 104)
                  endif
                  // Dados Recebedor
                  if !Empty(pdf:rec:nome)
                     pdf:font:Position := 'LEFT'
                     pdf:printText(Left(pdf:rec:nome, 56), 114, pdf:paper:center + 17)
                     pdf:printText(pdf:rec:endereco + ' ' + pdf:rec:complemento, 117, pdf:paper:center + 17)
                     pdf:printText(pdf:rec:bairro, 120, pdf:paper:center + 17)
                     pdf:printText(pdf:rec:municipio + ' - ' + pdf:rec:uf, 123, pdf:paper:center + 17)
                     pdf:printText(pdf:rec:doc, 126, pdf:paper:center + 17)
                     pdf:printText(pdf:rec:pais, 129, pdf:paper:center + 17)
                     pdf:font:Position := 'RIGHT'
                     pdf:printText(pdf:rec:cep, 123, 207)
                     pdf:printText(pdf:rec:ie, 126, 207)
                     pdf:printText(pdf:rec:fone, 129, 207)
                  endif
                  // Dados do Tomador
                  pdf:font:Position := 'LEFT'
                  pdf:printText(pdf:tom:nome, 134, 16)
                  pdf:printText(pdf:tom:municipio, 134, 133)
                  pdf:printText(pdf:tom:uf, 134, 175)
                  pdf:printText(pdf:tom:endereco + '  ' + pdf:tom:bairro + '  ' + pdf:tom:complemento, 137, 16)
                  pdf:printText(pdf:tom:doc, 140, 16)
                  pdf:printText(pdf:tom:ie, 140, 90)
                  pdf:printText(pdf:tom:pais, 140, 161)
                  pdf:font:Position := 'RIGHT'
                  pdf:printText(pdf:tom:cep, 134, 207)
                  pdf:printText(pdf:tom:fone, 140, 207)

                  // Dados de Produto Predominante
                  pdf:font:Position := 'LEFT'
                  pdf:printText(xml:getNode('proPred'), 148.5, 3)
                  pdf:printText(xml:getNode('xOutCat'), 148.5, pdf:center(120, 165))
                  pdf:printText(LTrim(Transform(hb_val(xml:getNode('vCarga')), "@E 99,999,999,999.99")), 148.5, pdf:center(165, 208))

                  // Dados do Pesos, Medidas e Qtde. Volumes
                  xml:getNode('infCarga')
                  pdf:setLine(156.5)
                  pdf:printText(LTrim(Transform(hb_val(xml:firstNode('qCarga')), "@E 9,999,999.9999")),, pdf:center(2, 40))
                  pdf:printText(LTrim(Transform(hb_val(xml:nextNode('qCarga')), "@E 9,999,999.9999")),, pdf:center(40, 78))
                  pdf:printText(LTrim(Transform(hb_val(xml:nextNode('qCarga')), "@E 9,999,999.9999")),, pdf:center(78, 120))
                  pdf:printText(LTrim(Transform(hb_val(xml:nextNode('qCarga')), "@E 9,999,999.9999")),, pdf:center(120, 164))
                  pdf:printText(LTrim(Transform(hb_val(xml:nextNode('qCarga')), "@E 99,999,999.9999")),, pdf:center(164, 208))

                  // Dados Componentes do Valor da Prestação do Serviço
                  pdf:setLine(168)
                  vPrest := xml:getNode('vPrest')
                  node := xml:firstNode('Comp')
                  pdf:font:Size := 8
                  for x := 1 to 5
                     if Empty(node)
                        Exit
                     endif
                     pdf:printText(xml:getSubNode('xNome', node),, 3, 'LEFT')
                     pdf:printText(LTrim(Transform(hb_Val(xml:getSubNode('vComp', node)), "@E 99,999,999.99")),, 53, 'RIGHT')
                     node := xml:nextNode()
                     if Empty(node)
                        Exit
                     endif
                     pdf:printText(xml:getSubNode('xNome', node),, 56, 'LEFT')
                     pdf:printText(LTrim(Transform(hb_Val(xml:getSubNode('vComp', node)), "@E 99,999,999.99")),, 106, 'RIGHT')
                     node := xml:nextNode()
                     if Empty(node)
                        Exit
                     endif
                     pdf:printText(xml:getSubNode('xNome', node),, 109, 'LEFT')
                     pdf:printText(LTrim(Transform(hb_Val(xml:getSubNode('vComp', node)), "@E 99,999,999.99")),, 159, 'RIGHT')
                     pdf:setLine(pdf:getLine()+3)
                     node := xml:nextNode()
                  next

                  // Valores vTPrest e vRec
                  pdf:setFont({'size' => 9, 'bold' => True})
                  pdf:printText(LTrim(Transform(hb_Val(xml:getSubNode('vTPrest', vPrest)), "@E 99,999,999.99")), 169, pdf:center(161, 208))
                  pdf:printText(LTrim(Transform(hb_Val(xml:getSubNode('vRec', vPrest)), "@E 99,999,999.99")), 179, pdf:center(161, 208))

                  // Dados Informação Relativas ao Imposto
                  pdf:setFont({'size' => 7, 'bold' => True, 'position' => 'LEFT'})
                  pdf:setLine(192)
                  node := xml:getNode('imp')
                  imp := ::getInfImposto(node) // {'CST' => '', 'vBC' => 0, 'pICMS' => 0, 'vICMS' => 0, 'pRedBC' => 0}
                  pdf:printText(imp['CST'],, 3)
                  pdf:printText(LTrim(Transform(imp['vBC'], "@E 99,999,999.99")),, pdf:center(70, 104))
                  pdf:printText(LTrim(Transform(imp['pICMS'], "@E 999.99")),, pdf:center(104, 140))
                  pdf:printText(LTrim(Transform(imp['vICMS'], "@E 99,999,999.99")),, pdf:center(140, 174))
                  pdf:printText(LTrim(Transform(imp['pRedBC'], "@E 99,999,999.99")),, pdf:center(174, 208))

                  // Dados Documentos originários
                  pdf:setFont({'size' => 7, 'bold' => False, 'position' => 'LEFT'})
                  pdf:setLine(205)
                  x := 0
                  for each doc in docsOriginarios
                     // doc == {'tpDoc' => 'NFE', 'descricao' => chave, 'num' => nDoc}
                     x++
                     if (x == 12)
                        pdf:setLine(205)
                     endif
                     if (x < 12)
                        // Preenche todo o lado esquerdo primeiro com até 11 linhas
                        pdf:printText(doc['tpDoc'],, 3)
                        pdf:printText(doc['descricao'],, pdf:center(2, pdf:paper:center - 6))
                        pdf:font:Position := 'RIGHT'
                        pdf:printText(doc['nDoc'],, pdf:paper:center - 2)
                     elseif (x < 23)
                        // Par: Lado Direito de Docs Originários
                        pdf:printText(doc['tpDoc'],, pdf:paper:center + 1)
                        pdf:printText(doc['descricao'],, pdf:center(pdf:paper:center, 202))
                        pdf:font:Position := 'RIGHT'
                        pdf:printText(doc['nDoc'],, 202)
                     else
                        // Atingiu o limite de 22 docs na primeira página, o restante ficará para a próxima página
                        exit
                     endif
                     pdf:font:Position := 'LEFT'
                     pdf:setLine(pdf:getLine()+4)
                  next
                  aindaTemDocs := (x < hmg_len(docsOriginarios))
                  pos := 23  // Próxima posição em docsOriginarios se houver mais docs a imprimir
                  // Dados de Observações
                  obs := xml:getNode('xObs')
                  aList := HB_ATOKENS(obs, ';')
                  pdf:font:Position := 'LEFT'
                  pdf:setLine(254)
                  for each obs in aList
                     pdf:printText(obs, pdf:getLine(), 3)
                     pdf:setLine(pdf:getLine() + 3)
                     if pdf:getLine() > 266
                        exit
                     endif
                  next

                  if (pdf:modal == 'RODOVIÁRIO')
                     // Dados Específicos do Modal Rodoviário
                     pdf:setFont({'size' => 7, 'bold' => True, 'position' => 'LEFT'})
                     pdf:printText(xml:getNode('RNTRC'), 278, 3)
                     pdf:setFont({'size' => 6, 'position' => 'LEFT', 'bold' => False})
                  endif
                  // ObsCont
                  node := xml:getNode('ObsCont')
                  if !Empty(node)
                     obs := xml:firstNode('xTexto')
                     pdf:printText(obs, 285, 3)
                  endif
                  pdf:printText('Emissor: ' + xml:getNode('xEmi'), 288, 3)
               else
                  // Demais páginas - Dados Documentos originários
                  pdf:setFont({'size' => 7, 'bold' => False, 'position' => 'LEFT'})
                  pdf:setLine(121.5)
                  for x := 1 to 84  // até 84 docs por página
                     if pos > hmg_len(docsOriginarios)
                        aindaTemDocs := False
                        exit
                     endif
                     if (x == 43)
                        pdf:setLine(121.5)
                     endif
                     pdf:printDocsOriginarios(docsOriginarios[pos])
                     pos++
                  next
               endif
               pdf:pageFooter()
            END HPDFPAGE
         enddo
         pdf:setdhCreated()
         END HPDFDOC
         ::ok := hb_FileExists(pdf:getNamePDF())
         if ::ok
            ::pdfName := pdf:getNamePDF()
            //::dhRecbto := pdf:getDateCreated()
         else
            saveLog({'Erro ao gerar PDF', hb_eol(), 'pdf: ' + pdf:getNamePDF()})
         endif
      endif
   else
      saveLog({'XML inválido para gerar PDF', hb_eol(), 'xml: ' + xmlName, hb_eol(), 'Erro: ', xml:error})
   endif

return self

method dhXMLtoPDF(xmlDateTime) class TGerarPDFdeXML
   // recebe: xmlDateTime: '2020-03-30T10:57:20-03:00'
   xmlDateTime := StrTran(xmlDateTime, 'T', ' ')    // '2020-03-30 10:57:20-03:00'
   xmlDateTime := Left(xmlDateTime, 19) // '2020-03-30 10:57:20'
   xmlDateTime := hb_utf8SubStr(xmlDateTime, 9, 2) + '/' + hb_utf8SubStr(xmlDateTime, 6, 2) + '/' + Left(xmlDateTime, 4) + ' ' + hb_utf8SubStr(xmlDateTime, 12)
return xmlDateTime  // Retorna 'DD/MM/AAAA HH:MM:SS'

method getInfImposto(node) class TGerarPDFdeXML
   local cst, imp := {'CST' => '', 'vBC' => 0, 'pICMS' => 0, 'vICMS' => 0, 'pRedBC' => 0}
   do case
      case ('ICMS00' $ node)
         imp['CST'] := '00 - TRIBUTAÇÃO NORMAL ICMS'
         imp['vBC'] := hb_Val(f_xmlNode(node, 'vBC'))
         imp['pICMS'] := hb_Val(f_xmlNode(node, 'pICMS'))
         imp['vICMS'] := hb_Val(f_xmlNode(node, 'vICMS'))
      case ('ICMS20' $ node)
         imp['CST'] := '20 - TRIBUTAÇÃO COM BC REDUZIDA DO ICMS'
         imp['vBC'] := hb_Val(f_xmlNode(node, 'vBC'))
         imp['pICMS'] := hb_Val(f_xmlNode(node, 'pICMS'))
         imp['vICMS'] := hb_Val(f_xmlNode(node, 'vICMS'))
         imp['pRedBC'] := hb_Val(f_xmlNode(node, 'pRedBC'))
      case ('ICMS45' $ node)
         cst := f_xmlNode(node, 'CST')
         switch cst
            case '40'
               imp['CST'] := '40 - ICMS ISENÇÃO'
               exit
            case '41'
               imp['CST'] := '41 - ICMS NÃO TRIBUTADA'
               exit
            case '51'
               imp['CST'] := '51 - ICMS DIFERIDO'
               exit
         endswitch
      case ('ICMS60' $ node)
         imp['CST'] := '60 - ICMS COBRADO POR SUBSTITUIÇÃO TRIBUTÁRIA'
         imp['vBC'] := hb_Val(f_xmlNode(node, 'vBCSTRet'))
         imp['vICMS'] := hb_Val(f_xmlNode(node, 'vICMSSTRet'))
         imp['pICMS'] := hb_Val(f_xmlNode(node, 'pICMSSTRet'))
      case ('ICMS90' $ node)
         imp['CST'] := '90 - OUTROS'
         imp['vBC'] := hb_Val(f_xmlNode(node, 'vBC'))
         imp['vICMS'] := hb_Val(f_xmlNode(node, 'vICMS'))
         imp['pICMS'] := hb_Val(f_xmlNode(node, 'pICMS'))
         imp['pRedBC'] := hb_Val(f_xmlNode(node, 'pRedBC'))
      case ('ICMSOutraUF' $ node)
         imp['CST'] := '90 - ICMS OUTRA UF'
         imp['vBC'] := hb_Val(f_xmlNode(node, 'vBCOutraUF'))
         imp['vICMS'] := hb_Val(f_xmlNode(node, 'vICMSOutraUF'))
         imp['pICMS'] := hb_Val(f_xmlNode(node, 'pICMSOutraUF'))
         imp['pRedBC'] := hb_Val(f_xmlNode(node, 'pRedBCOutraUF'))
      case ('ICMSSN' $ node)
         imp['CST'] := '90 - ICMS SIMPLES NACIONAL'
   endcase
return imp

method formattedCep(cep) class TGerarPDFdeXML
return Transform(cep, "@R 99999-999")

method formattedDoc(doc) class TGerarPDFdeXML
   local template := iif(hmg_len(doc) == 11, '@R 999.999.999-99', '@R 99.999.999/9999-99')
return Transform(doc, template)

method formattedFone(fone) class TGerarPDFdeXML
   local template := iif(hmg_len(fone) == 10, '@R (99) 9999-9999', '@R (99) 99999-9999')
return Transform(fone, template)
