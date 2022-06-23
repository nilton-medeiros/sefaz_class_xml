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
#include <fileio.ch>
#include "Directry.ch"

/*
 * Algumas funções úteis para lidar com classes
 * __objGetMsgList( oB, .T. ) # Retornar nomes de todos os VAR ou METHOD para um determinado objeto
 * __objGetValueList()   Return an array of VAR names and values for a given object
 * mais em: https://harbour.github.io/doc/

*/

// Atualizado em 2022-06-23 16:45
class TCTe
   /*
   class: TCTe
   Projeto: Conhecimento de Trasnporte Eletrônico
   Versão: MOC 3.00a
   Sefaz: http://www.cte.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=YIi+H8VETH0=
   */

   data documentation READONLY
   data infCte
   data xmlName
   data pdfName
   data infCTeSupl
   data msgError READONLY
   data validado READONLY
   data situacao
   data remotePath
   data insertEvents
   data ACBr READONLY
   data UTC READONLY
   data systemPath READONLY

   method new(acbr, utc, sysPath) constructor
   method validarCTe()
   method criarCTeXML()
   method generateKeyCTe()
   method validateElement(e)
   method validateClient(c)
   method validateNFinfCarga(nf)
   method AAddError(e, msg)
   method addTagToWrite(e)
   method infNFCarga(h, c)
   method infNFTransp(h, t)
end class

method new(acbr, utc, sysPath) class TCTe
   ::documentation := "CTe | Schemas PL_CTe_300a: cteTipoBasico_v3.00.xsd and cteModalRodoviario_v3.00.xsd [MOC 3.00a]"
   ::infCte := TinfCte():new()
   ::xmlName := ''
   ::pdfName := ''
   ::infCTeSupl := TinfCTeSupl():new()
   ::msgError := {}
   ::validado := False
   ::situacao := ''
   ::remotePath := ''
   ::insertEvents := {}
   ::ACBr := acbr
   ::UTC := utc
   ::systemPath := sysPath
return self

method generateKeyCTe() class TCTe
   local key := " - CHAVE NÃO GERADA"

   if !::validateElement(::infCte:ide:cUF) .or.;
      !::validateElement(::infCte:ide:dhEmi) .or.;
      !::validateElement(::infCte:emit:CNPJ) .or.;
      !::validateElement(::infCte:ide:mod) .or.;
      !::validateElement(::infCte:ide:serie) .or.;
      !::validateElement(::infCte:ide:nCT) .or.;
      !::validateElement(::infCte:ide:tpEmis) .or.;
      !::validateElement(::infCte:ide:cCT)
      return key
   endif

   // Exemplo: "35 2004 61611877000103 57 001 000000057 1 00000057 0"
   with object ::infCte
      key := :ide:cUF:value
      key += hb_uSubStr(StrTran(:ide:dhEmi:value,"-", ""),3,4) // AAMM - Ano e Mes de emissao do CT-e
      key += :emit:CNPJ:value
      key += :ide:mod:value
      key += :ide:serie:value
      key += :ide:nCT:value
      key += :ide:tpEmis:value
      key += :ide:cCT:value
      :ide:cDV:value := generateDigitChecker(key) // cDV - Digito Verificador da Chave de Acesso
      key += :ide:cDV:value
   endwith

Return (key)

method validarCTe() class TCTe
   local keyGroup := False
   local tomaCNPJ := ""
   local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
   local eda, idta, dtap, dtae

   with object ::infCte

      ::validateElement(:versao)

      if empty(:Id:value) .or. hmg_len(:Id:value) < 47
         :Id:raw := ::generateKeyCTe()
         :Id:value := 'CTe' + :Id:raw
         keyGroup := True
      endif

      ::validateElement(:Id)

      if !keyGroup
         ::validateElement(:ide:cUF)
         ::validateElement(:ide:dhEmi)
         ::validateElement(:emit:CNPJ)
         ::validateElement(:ide:mod)
         ::validateElement(:ide:serie)
         ::validateElement(:ide:nCT)
         ::validateElement(:ide:tpEmis)
         ::validateElement(:ide:cCT)
      endif

   endwith

   with object ::infCte:ide

      ::validateElement(:CFOP)
      ::validateElement(:natOp)
      ::validateElement(:tpImp)
      ::validateElement(:cDV)
      ::validateElement(:tpAmb)
      ::validateElement(:tpCTe)
      ::validateElement(:procEmi)
      ::validateElement(:verProc)
      ::validateElement(:indGlobalizado)
      ::validateElement(:cMunEnv)
      ::validateElement(:xMunEnv)
      ::validateElement(:UFEnv)
      ::validateElement(:modal)
      ::validateElement(:tpServ)
      ::validateElement(:cMunIni)
      ::validateElement(:xMunIni)
      ::validateElement(:UFIni)
      ::validateElement(:cMunFim)
      ::validateElement(:xMunFim)
      ::validateElement(:UFFim)
      ::validateElement(:retira)
      ::validateElement(:xDetRetira)
      ::validateElement(:indIEToma)

      if empty(:toma3:toma:value) .and. empty(:toma4:toma:value)
         ::validateElement(:toma3:toma)
         ::validateElement(:toma4:toma)
      elseif !empty(:toma3:toma:value) .and. !empty(:toma4:toma:value)
         ::AAddError(:toma3, "AS TAGs toma3 e toma4 NÃO PODEM SER USADAS JUNTAS")
         ::AAddError(:toma4, "SÓ PODE HAVER UM TOMADOR, VERIFIQUE AS TAGs toma3 E toma4")
      elseif !empty(:toma3:toma:value)
         ::validateElement(:toma3:toma)
         switch :toma3:toma:value
            case "0"
               tomaCNPJ := ::infCte:rem:CNPJ:value
               exit
            case "1"
               tomaCNPJ := ::infCte:exped:CNPJ:value
               exit
            case "2"
               tomaCNPJ := ::infCte:receb:CNPJ:value
               exit
            case "3"
               tomaCNPJ := ::infCte:dest:CNPJ:value
               exit
         endswitch
      else
         ::validateElement(:toma4:toma)
         if empty(:toma4:CNPJ:value) .and. empty(:toma4:CPF:value)
            ::validateElement(:toma4:CNPJ)
            ::validateElement(:toma4:CPF)
         elseif !empty(:toma4:CNPJ:value) .and. !empty(:toma4:CPF:value)
            ::AAddError(:toma4:CNPJ, "AS TAGs toma4:CNPJ e toma4:CPF NÃO PODEM SER USADAS JUNTAS")
            ::AAddError(:toma4:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
         elseif !empty(:toma4:CNPJ:value)
            ::validateElement(:toma4:CNPJ)
            ::validateElement(:toma4:IE)
            tomaCNPJ := :toma4:CNPJ:value
         else
            ::validateElement(:toma4:CPF)
         endif
         if :tpAmb:value == '2'
            :toma4:xNome:raw := 'CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
         endif
         ::validateElement(:toma4:xNome)
         ::validateElement(:toma4:xFant)
         ::validateElement(:toma4:fone)
         ::validateElement(:toma4:enderToma:xLgr)
         ::validateElement(:toma4:enderToma:nro)
         ::validateElement(:toma4:enderToma:xLgr)
         ::validateElement(:toma4:enderToma:xCpl)
         ::validateElement(:toma4:enderToma:xBairro)
         ::validateElement(:toma4:enderToma:cMun)
         ::validateElement(:toma4:enderToma:xMun)
         ::validateElement(:toma4:enderToma:CEP)
         ::validateElement(:toma4:enderToma:UF)
         ::validateElement(:toma4:enderToma:cPais)
         ::validateElement(:toma4:enderToma:xPais)
         ::validateElement(:toma4:email)
      endif

      if :tpEmis:value == "5"
         ::validateElement(:dhCont)
         ::validateElement(:xJust)
      endif

   endwith

   with object ::infCte:compl

      ::validateElement(:xCaracAd)
      ::validateElement(:xCaracSer)
      ::validateElement(:xEmi)
      ::validateElement(:fluxo:xOrig)

      for each v1 in :fluxo:pass
         ::validateElement(v1:xPass)
         ::validateElement(v1:xDest)
         ::validateElement(v1:xRota)
      next

      ::validateElement(:Entrega:tpPer)
      ::validateElement(:Entrega:dProg)
      ::validateElement(:Entrega:dIni)
      ::validateElement(:Entrega:dFim)
      ::validateElement(:Entrega:tpHor)
      ::validateElement(:Entrega:hProg)
      ::validateElement(:Entrega:hIni)
      ::validateElement(:Entrega:hFim)

      if (::infCte:ide:modal:value == "02") .and. (:Entrega:tpPer:value == "0")
         ::AAddError(:Entrada:tpPer, "A OPÇÃO '0 - Sem data definida' É PROIBIDA PARA O MODAL AÉREO")
      endif

      ::validateElement(:origCalc)
      ::validateElement(:destCalc)
      ::validateElement(:xObs)

      for each v2 in :ObsCont
         ::validateElement(v2:xCampo)
         ::validateElement(v2:xTexto)
      next

      for each v3 in :ObsFisco
         ::validateElement(v3:xCampo)
         ::validateElement(v3:xTexto)
      next

   endwith

   with object ::infCte:emit
      ::validateElement(:CNPJ)
      ::validateElement(:IE)
      ::validateElement(:IEST)
      if ::infCte:ide:tpAmb:value == '2'
         :xNome:raw := 'CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
         :xFant:raw := 'CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
      endif
      ::validateElement(:xNome)
      ::validateElement(:xFant)
      ::validateElement(:enderEmit:xLgr)
      ::validateElement(:enderEmit:nro)
      ::validateElement(:enderEmit:xCpl)
      ::validateElement(:enderEmit:xBairro)
      ::validateElement(:enderEmit:cMun)
      ::validateElement(:enderEmit:CEP)
      ::validateElement(:enderEmit:UF)
      ::validateElement(:CRT)
      ::validateElement(:fone)
   endwith

   with object ::infCte

      // tpServ (0 - Normal; 1 - Subcontratação; 2 - Redespacho; 3 - Redespacho Intermediário; 4 - Serviço Vinculado a Multimodal)

      if (:ide:tpServ:value $ "012")
         // Informar o remetente e destinatário apenas para o tipo de serviço igual a (0 - Normal; 1 - Subcontratação; 2 - Redespacho)
         ::validateClient(:rem)
         ::validateClient(:dest)
         // Não informar o expedidor, recebedor para este tipo de serviço
         :exped:clear()
         if :receb:submit
            ::validateClient(:receb)
         else
            :receb:clear()
         endif
      else

         // 3 - Redespacho Intermediário; 4 - Serviço Vinculado a Multimodal
         // Não informar o remetente e destinatário para este tipo de serviço
         :rem:clear()
         :dest:clear()
         ::validateClient(:exped)
         ::validateClient(:receb)

         if (:ide:tpServ == 4)
            // 4 - Serviço Vinculado a Multimodal
            for each v4 in :infCTeNorm:infServVinc:infCTeMultimodal:value
               ::validateElement(v4)
            next
         endif

      endif

   endwith

   with object ::infCte:vPrest
      ::validateElement(:vTPrest)
      ::validateElement(:vRec)
      for each v5 in :Comp
         ::validateElement(v5:xNome)
         ::validateElement(v5:vComp)
      next
   endwith

   with object ::infCte:imp
      if !empty(:ICMS00:CST:value) .and. :ICMS00:submit
         ::validateElement(:ICMS00:CST)
         ::validateElement(:ICMS00:vBC)
         ::validateElement(:ICMS00:pICMS)
         ::validateElement(:ICMS00:vICMS)
         :ICMS20:clear()
         :ICMS45:clear()
         :ICMS60:clear()
         :ICMS90:clear()
         :ICMSOutraUF:clear()
         :ICMSSN:clear()
      elseif !empty(:ICMS20:CST:value) .and. :ICMS20:submit
         ::validateElement(:ICMS20:CST)
         ::validateElement(:ICMS20:pRedBC)
         ::validateElement(:ICMS20:vBC)
         ::validateElement(:ICMS20:pICMS)
         ::validateElement(:ICMS20:vICMS)
         :ICMS00:clear()
         :ICMS45:clear()
         :ICMS60:clear()
         :ICMS90:clear()
         :ICMSOutraUF:clear()
         :ICMSSN:clear()
      elseif !empty(:ICMS45:CST:value) .and. :ICMS45:submit
         ::validateElement(:ICMS45:CST)
         :ICMS00:clear()
         :ICMS20:clear()
         :ICMS60:clear()
         :ICMS90:clear()
         :ICMSOutraUF:clear()
         :ICMSSN:clear()
      elseif !empty(:ICMS60:CST:value) .and. :ICMS60:submit
         ::validateElement(:ICMS60:CST)
         ::validateElement(:ICMS60:vBCSTRet)
         ::validateElement(:ICMS60:vICMSSTRet)
         ::validateElement(:ICMS60:pICMSSTRet)
         ::validateElement(:ICMS60:vCred)
         :ICMS00:clear()
         :ICMS20:clear()
         :ICMS45:clear()
         :ICMS90:clear()
         :ICMSOutraUF:clear()
         :ICMSSN:clear()
      elseif !empty(:ICMS90:CST:value) .and. :ICMS90:submit
         ::validateElement(:ICMS90:CST)
         ::validateElement(:ICMS90:pRedBC)
         ::validateElement(:ICMS90:vBC)
         ::validateElement(:ICMS90:pICMS)
         ::validateElement(:ICMS90:vICMS)
         ::validateElement(:ICMS90:vCred)
         :ICMS00:clear()
         :ICMS20:clear()
         :ICMS45:clear()
         :ICMS60:clear()
         :ICMSOutraUF:clear()
         :ICMSSN:clear()
      elseif !empty(:ICMSOutraUF:CST:value) .and. :ICMSOutraUF:submit
         ::validateElement(:ICMSOutraUF:CST)
         ::validateElement(:ICMSOutraUF:pRedBCOutraUF)
         ::validateElement(:ICMSOutraUF:vBCOutraUF)
         ::validateElement(:ICMSOutraUF:pICMSOutraUF)
         ::validateElement(:ICMSOutraUF:vICMSOutraUF)
         :ICMS00:clear()
         :ICMS20:clear()
         :ICMS45:clear()
         :ICMS60:clear()
         :ICMS90:clear()
         :ICMSSN:clear()
      elseif !empty(:ICMSSN:CST:value) .and. :ICMSSN:submit
         ::validateElement(:ICMSSN:CST)
         ::validateElement(:ICMSSN:indSN)
         :ICMS00:clear()
         :ICMS20:clear()
         :ICMS45:clear()
         :ICMS60:clear()
         :ICMS90:clear()
         :ICMSOutraUF:clear()
      else
         ::AAddError(::infCte:imp, "NÃO HÁ INFORMAÇÕES RELATIVAS AOS IMPOSTOS")
      endif

      ::validateElement(:vTotTrib)
      ::validateElement(:infAdFisco)

      if (::infCte:ide:tpCTe:value $ "013") .and.;
         !(::infCte:ide:UFIni:value == ::infCte:ide:UFFim:value) .and.;
         (::infCte:dest:contribuinte_ICMS == '0')
         // Grupo a ser informado nas prestações interestaduais para consumidor final, não contribuinte do ICMS
         :ICMSUFFim := True
         ::validateElement(:vBCUFFim)
         ::validateElement(:pFCPUFFim)
         ::validateElement(:pICMSUFFim)
         ::validateElement(:pICMSInter)
         //::validateElement(:pICMSInterPart)
         ::validateElement(:vFCPUFFim)
         ::validateElement(:vICMSUFFim)
         ::validateElement(:vICMSUFIni)
      else
         :ICMSUFFim := False
      endif
   endwith

   // tpCTe | Tipo do CT-e: 0 - CT-e Normal; 1 - CT-e de Complemento de Valores; 2 - CT-e de Anulação; 3 - CT-e de Substituição"

   if (::infCte:ide:tpCTe:value $ "03")
      // 0 - CT-e Normal e 3 - CT-e de Substituição

      with object ::infCte:infCTeNorm:infCarga
         ::validateElement(:vCarga)
         ::validateElement(:proPred)
         ::validateElement(:xOutCat)
         for each v6 in :infQ:value
            ::validateElement(v6:cUnid)
            ::validateElement(v6:tpMed)
            ::validateElement(v6:qCarga)
         next
         ::validateElement(:vCargaAverb)
      endwith

      with object ::infCte:infCTeNorm:infDoc
         // :infNFe, :infNF e : infOutros são elementos da classe TElements que contém arrays de objtos com as classes TinfNFe, TinfNF e TinfOutros respectivamente
         if !empty(:infNFe:value)
            for each v7 in :infNFe:value
               ::validateElement(v7:chave)
               ::validateElement(v7:PIN)
               ::validateElement(v7:dPrev)
               ::validateNFinfCarga(v7)
            next
            :infNFClear()
            :infOutrosClear()
         elseif !empty(:infNF:value)
            for each v8 in :infNF:value
               ::validateElement(v8:nRoma)
               ::validateElement(v8:nPed)
               ::validateElement(v8:mod)
               ::validateElement(v8:serie)
               ::validateElement(v8:nDoc)
               ::validateElement(v8:dEmi)
               ::validateElement(v8:vBC)
               ::validateElement(v8:vICMS)
               ::validateElement(v8:vBCST)
               ::validateElement(v8:vST)
               ::validateElement(v8:vProd)
               ::validateElement(v8:vNF)
               ::validateElement(v8:nCFOP)
               ::validateElement(v8:nPeso)
               ::validateElement(v8:PIN)
               ::validateElement(v8:dPrev)
               ::validateNFinfCarga(v8)
            next
            :infNFeClear()
            :infOutrosClear()
         elseif !empty(:infOutros:value)
            for each v9 in :infOutros:value
               ::validateElement(v9:tpDoc)
               ::validateElement(v9:descOutros)
               ::validateElement(v9:nDoc)
               ::validateElement(v9:dEmi)
               ::validateElement(v9:vDocFisc)
               ::validateElement(v9:dPrev)
               ::validateNFinfCarga(v9)
            next
            :infNFeClear()
            :infNFClear()
         else
            AAdd(::msgError, 'Name TAG: ' + ::infCte:infCTeNorm:infDoc:documentation + CRLF + "ERRO: NÃO HÁ INFORMAÇÕES RELATIVAS AOS DOCUMENTOS (NFe|NF|Outros)")
         endif
      endwith

      // tpCTe = 0-Normal, 1-Complemento de Valores, 3-Substituto
      // tpServ (0 - Normal; 1 - Subcontratação; 2 - Redespacho; 3 - Redespacho Intermediário; 4 - Serviço Vinculado a Multimodal)
      if (::infCte:ide:tpServ:value $ "123")
         /* Para:
          * tpCTe (0 - CT-e Normal ou 3 - CT-e de Substituição)
          * tpServ (1 - Subcontratação; 2 - Redespacho; 3 - Redespacho Intermediário)
          * O grupo de Documentos Anteriores (docAnt) deve ser informado
         */
         with object ::infCte:infCTeNorm:docAnt
            for each eda in :emiDocAnt:value
               // eda = emitente do Documento Anterior
               if empty(:eda:CNPJ:value) .and. empty(:eda:CPF:value)
                  ::validateElement(:eda:CNPJ)
                  ::validateElement(:eda:CPF)
               elseif !empty(:eda:CNPJ:value) .and. !empty(:eda:CPF:value)
                  ::AAddError(:eda:CNPJ, "AS TAGs emiDocAnt:CNPJ e emiDocAnt:CPF NÃO PODEM SER USADAS JUNTAS")
                  ::AAddError(:eda:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
               elseif !empty(:eda:CNPJ:value)
                  ::validateElement(:eda:CNPJ)
                  ::validateElement(:eda:IE)
               else
                  ::validateElement(:eda:CPF)
               endif
               ::validateElement(:eda:xNome)
               for each idta in :eda:idDocAnt:value
                  for each dtap in idta:idDocAntPap:value
                     ::validateElement(:dtap:tpDoc)
                     ::validateElement(:dtap:serie)
                     ::validateElement(:dtap:subser)
                     ::validateElement(:dtap:nDoc)
                     ::validateElement(:dtap:dEmi)
                  next
                  for each dtae in idta:idDocAntEle:value
                     ::validateElement(:dtae:chCTe)
                  next
               next
            next
         endwith
      else

         // tpServ (0 - Normal; 4 - Serviço Vinculado a Multimodal)
         if (::infCte:ide:tpCTe:value == "0")
            // tpCTe: 0 - Normal | infCte/infCTeNorm/infModal
            if (::infCte:ide:modal:value == "01")
               // rodo
               with object ::infCte:infCTeNorm:infModal:rodo
                  ::validateElement(:RNTRC)
                  for each v10 in :occ
                     // v10: Ordem de Coleta associados
                     ::validateElement(v10:serie)
                     ::validateElement(v10:nOcc)
                     ::validateElement(v10:dEmi)
                     ::validateElement(v10:emiOcc:CNPJ)
                     ::validateElement(v10:emiOcc:cInt)
                     ::validateElement(v10:emiOcc:IE)
                     ::validateElement(v10:emiOcc:UF)
                     ::validateElement(v10:emiOcc:fone)
                  next
               endwith
            else
               // aereo
               with object ::infCte:infCTeNorm:infModal:aereo
                  ::validateElement(:nMinu)
                  ::validateElement(:nOCA)
                  ::validateElement(:dPrevAereo)
                  ::validateElement(:natCarga:xDime)
                  for each v16 in :natCarga:cInfManu
                     ::validateElement(v16)
                  next
                  ::validateElement(:tarifa:CL)
                  ::validateElement(:tarifa:cTar)
                  ::validateElement(:tarifa:vTar)
                  for each v11 in :peri:value
                     ::validateElement(v11:nONU)
                     ::validateElement(v11:qTotEmb)
                     ::validateElement(v11:infTotAP:qTotProd)
                     ::validateElement(v11:infTotAP:uniAP)
                  next
               endwith
            endif
            with object ::infCte:infCTeNorm
               for each v12 in :veicNovos:value
                  ::validateElement(v12:chassi)
                  ::validateElement(v12:cCor)
                  ::validateElement(v12:xCor)
                  ::validateElement(v12:cMod)
                  ::validateElement(v12:vUnit)
                  ::validateElement(v12:vFrete)
               next
               ::validateElement(:cobr:fat:nFat)
               ::validateElement(:cobr:fat:vOrig)
               ::validateElement(:cobr:fat:vDesc)
               ::validateElement(:cobr:fat:vLiq)
               for each v13 in :cobr:dup:value
                  ::validateElement(v13:nDup)
                  ::validateElement(v13:dVenc)
                  ::validateElement(v13:vDup)
               next
            endwith

            if (::infCte:ide:tpServ:value == "0")
               // tpCTe 0 - Nomal; e tpServ 0 - Normal;
               ::validateElement(::infCte:infCTeNorm:infGlobalizado:xObs)
            else
               // tpServ 4 - Serviço Vinculado a Multimodal
               for each v14 in ::infCte:infCTeNorm:infServVinc:infCTeMultimodal:value
                  ::validateElement(v14:chCTeMultimodal)
               next
            endif

         else

            // 3 - CT-e de Substituição
            with object ::infCte:infCTeNorm:infCteSub
               ::validateElement(:chCte)
               ::validateElement(:refCteAnu)

               // Tomador: 1 – Contribuinte ICMS e não emitente do CTe
               if (::infCte:ide:indIEToma:value == "1") .and. tomaCNPJ != ::infCte:emit:CNPJ:value
                  if !empty(:tomaICMS:refNFe:value)
                     ::validateElement(:tomaICMS:refNFe)
                  elseif !empty(:tomaICMS:refNF:value)
                     if empty(:tomaICMS:refNF:CNPJ:value) .and. empty(:tomaICMS:refNF:value)
                        ::validateElement(:tomaICMS:refNF:CNPJ)
                        ::validateElement(:tomaICMS:refNF:CPF)
                     elseif !empty(:tomaICMS:refNF:CNPJ:value) .and. !empty(:tomaICMS:refNF:CPF:value)
                        ::AAddError(:tomaICMS:refNF:CNPJ, "AS TAGs tomaICMS:refNF:CNPJ e tomaICMS:refNF:CPF NÃO PODEM SER USADAS JUNTAS")
                        ::AAddError(:tomaICMS:refNF:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
                     elseif !empty(:tomaICMS:refNF:CNPJ:value)
                        ::validateElement(:tomaICMS:refNF:CNPJ)
                        ::validateElement(:tomaICMS:refNF:IE)
                     else
                        ::validateElement(:tomaICMS:refNF:CPF)
                     endif
                     ::validateElement(:tomaICMS:refNF:mod)
                     ::validateElement(:tomaICMS:refNF:serie)
                     ::validateElement(:tomaICMS:refNF:subserie)
                     ::validateElement(:tomaICMS:refNF:nro)
                     ::validateElement(:tomaICMS:refNF:valor)
                     ::validateElement(:tomaICMS:refNF:dEmi)
                  elseif !empty(:tomaICMS:refCte:value)
                     ::validateElement(:tomaICMS:refCte)
                  else
                     ::AAddError(:tomaICMS, "GRUPO DE DOCUMENTOS (NFe/NF/CTe) DO CT-e DE SUBSTITUIÇÃO NÃO INFORMADO")
                  endif
               endif
               ::validateElement(:indAlteraToma)
            endwith

         endif

      endif

   elseif (::infCte:ide:tpCTe:value == "1")
      // 1 - CT-e de Complemento de Valores;
      ::validateElement(::infCte:infCteComp:chCTe)
   else
      // 2 - CT-e de Anulação
      ::validateElement(::infCte:infCteAnu:chCTe)
      ::validateElement(::infCte:infCteAnu:dEmi)
   endif

   // Autorizados para download do XML do DF-e
   for each v15 in ::infCte:autXML:value
      if empty(v15:CNPJ:value) .and. empty(v15:CPF:value)
         ::AAddError(::infCte:autXML, "INFORMADO 'autXML', MAS CNPJ OU CPF NÃO INFORMADOS")
      elseif !empty(v15:CNPJ:value) .and. !empty(v15:CPF:value)
         ::AAddError(::infCte:autXML, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
      elseif !empty(v15:CNPJ:value)
         ::validateElement(v15:CNPJ)
      else
         ::validateElement(v15:CPF)
      endif
   next

   // Informações do Responsável Técnico pela emissão do DF-e
   /*
    * NT 2018.005 v1.30
    * Implementação futura para o grupo de campos de identificação do responsável técnico e geração do hashCSRT
    * http://nstecnologia.com.br/blog/nt-2018-005-v-1-30/
   */
   if !empty(::infCte:infRespTec:CNPJ:value)
      with object ::infCte:infRespTec
         ::validateElement(:CNPJ)
         ::validateElement(:xContato)
         ::validateElement(:email)
         ::validateElement(:fone)
         //::validateElement(:idCSRT)
         //::validateElement(:hashCSRT)
      endwith
   endif

   /*
    * TAG infCTeSupl : qrCodCTe
    * Informações suplementares do CT-e
   */
   if (::infCte:ide:tpAmb:value == '1')
      ::infCTeSupl:qrCodCTe:value := 'https://nfe.fazenda.sp.gov.br/CTeConsulta/qrCode?chCTe=' + ::infCte:Id:raw + '&tpAmb=1'
   else
      ::infCTeSupl:qrCodCTe:value := 'https://homologacao.nfe.fazenda.sp.gov.br/CTeConsulta/qrCode?chCTe=' + ::infCte:Id:raw + '&tpAmb=2'
   endif
   ::validateElement(::infCTeSupl:qrCodCTe)

   ::validado := True

return empty(::msgError)

method validateNFinfCarga(nf) class TCTe
   local iuc, iut, lacre
   for each iuc in nf:infUnidCarga:value
      ::validateElement(iuc:tpUnidCarga)
      ::validateElement(iuc:idUnidCarga)
      for each lacre in iuc:lacUnidCarga
         ::validateElement(lacre:nLacre)
      next
      ::validateElement(iuc:qtdRat)
   next
   for each iut in nf:infUnidTransp:value
      ::validateElement(iut:tpUnidTransp)
      ::validateElement(iut:idUnidTransp)
      for each lacre in iut:lacUnidTransp
         ::validateElement(lacre:nLacre)
      next
      for each iuc in iut:infUnidCarga:value
         ::validateElement(iuc:tpUnidCarga)
         ::validateElement(iuc:idUnidCarga)
         for each lacre in iuc:lacUnidCarga
            ::validateElement(lacre:nLacre)
         next
         ::validateElement(iuc:qtdRat)
      next
      ::validateElement(iut:qtdRat)
   next
return nil

method validateElement(e) class TCTe
   local isValid := True

   if ! (ValType(e) == 'O')
      saveLog('Tag não é um elemento, é do tipo: ' + ValType(e) + ' | conteúdo: ' + iif(ValType(e) == 'C', e, iif(ValType(e) == 'N', hb_ntos(e), '?')))
      msgDebugInfo({'Element type: ', ValType(e), ' | conteúdo: ', iif(ValType(e) $ 'CN', e, '?')})
   endif

   if e:eType == "C" .and. !Empty(e:value)
      if Empty(e:raw)
         e:raw := removeAccentuation(e:value)
      else
         e:raw := removeAccentuation(e:raw)
      endif
      e:value := removeAccentuation(e:value)
   endif

   if !empty(e:value)
      if (e:eType == 'C') .and. (hmg_len(e:value) > e:maxLength)
         e:value := AllTrim(hb_ULeft(e:value, e:maxLength))
      endif
      if (hmg_len(e:value) < e:minLength) .or. (e:name == 'tagNaoDefinida')
         saveLog('Tag: ' + e:name + ' |Len: ' + hb_ntos(hmg_len(e:value)) + ' |value: ' + e:value + ' |minLength: ' + hb_ntos(e:minLength) + ' |Documentation: ' + e:documentation)
      endif
      if (hmg_len(e:value) < e:minLength)
         ::AAddError(e, "TAMANHO INVÁLIDO |Informado: "+hb_ntos(hmg_len(e:value))+ " |Aceito: |Min: "+hb_ntos(e:minLength)+" |Max: "+hb_ntos(e:maxLength))
         isValid := False
      endif
      if ! (e:eType == "A")
         if !empty(e:restriction) .and. !(e:value $ e:restriction)
            ::AAddError(e, "RESTRIÇÃO| Informado: "+e:value+" |Esperado: "+e:restriction)
            isValid := False
         endif
      endif
      if e:eType == "N" .and. aux_isAlpha(e:raw)
         ::AAddError(e, "CONTEÚDO DA TAG NÃO É NUMÉRICO")
         isValid := False
      elseif e:eType == "D" .and. !isDateFormat(e:value, "D")
         ::AAddError(e, "FORMATO DE DATA INVÁLIDO |Informado: "+e:value+" |ESPERADO: 'AAAA-MM-DD'")
         isValid := False
      elseif e:eType == "DT" .and. !isDateFormat(e:value, "DT")
         ::AAddError(e, "FORMATO DE DATA HORA INVÁLIDO |Informado: "+e:value+" |ESPERADO: 'AAAA-MM-DDTHH:MM:SS'")
         isValid := False
      endif

   elseif e:required
      ::AAddError(e, "TAG REQUERIDA - CONTEÚDO NÃO PODE SER VAZIO/NÃO INFORMADO")
      isValid := False
   endif
return isValid

method validateClient(c) class TCTe

   with object c
      if empty(:CNPJ:value) .and. empty(:CPF:value)
         ::validateElement(:CNPJ)
         ::validateElement(:CPF)
      elseif !empty(:CNPJ:value) .and. !empty(:CPF:value)
         ::AAddError(:CNPJ, "AS TAGs "+c:value+":CNPJ e "+c:value+":CPF NÃO PODEM SER USADAS JUNTAS")
         ::AAddError(:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
      elseif !empty(:CNPJ:value)
         ::validateElement(:CNPJ)
         ::validateElement(:IE)
      else
         ::validateElement(:CPF)
      endif
      if ::infCte:ide:tpAmb:value == '2'
         :xNome:raw := 'CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
         :xFant:raw := 'CT-E EMITIDO EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
      endif
      ::validateElement(:xNome)
      ::validateElement(:xFant)
      :fone:raw := onlyNumbers(:fone:value)
      ::validateElement(:fone)
      ::validateElement(:endereco:xLgr)
      ::validateElement(:endereco:nro)
      ::validateElement(:endereco:xLgr)
      ::validateElement(:endereco:xCpl)
      ::validateElement(:endereco:xBairro)
      ::validateElement(:endereco:cMun)
      ::validateElement(:endereco:xMun)
      :endereco:CEP:raw := onlyNumbers(:endereco:CEP:value)
      ::validateElement(:endereco:CEP)
      ::validateElement(:endereco:UF)
      ::validateElement(:endereco:cPais)
      ::validateElement(:endereco:xPais)
      ::validateElement(:email)
   endwith

return nil

method AAddError(e, msg) class TCTe
   AAdd(::msgError, 'Name TAG: ' + e:name + CRLF + e:documentation + CRLF + "ERRO: " + msg + CRLF + "CONTEÚDO: [" + e:value + "]")
return nil

/*
// Será introduzida ao XML pela ACBr Lib ou ACBrMonitor que autenticará o XML
class TinfCTeSupl
   data documentation init "infCTeSpl | Informações suplementares do CT-e"
   data value init "TinfCTeSupl"
   data qrCodCTe init Telement():new({'name' => "qrCodCTe", 'documentation' => "Texto com o QR-Code impresso no DACTE", 'minLength' => 50, 'maxLength' => 1000})
end class
*/

method criarCTeXML() class TCTe
   local h, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12

   if !::validado
      ::validarCTe()
   endif
   if !empty(::msgError)
      return False
   endif

   ::xmlName := ::ACBr:xmlPath + ::infCte:Id:raw + '-env.xml'
   if hb_FileExists(::xmlName)
      hb_FileDelete(::xmlName)
   endif

   h := hb_FCreate(::xmlName, FC_NORMAL)

   with object ::infCte
      FWrite(h, '<CTe xmlns="http://www.portalfiscal.inf.br/cte">')
         FWrite(h, '<infCte versao="' + :versao:value + '" Id="' + :Id:value + '">')
            with object :ide
               FWrite(h, '<ide>')
                  ::addTagToWrite(h, :cUF)
                  ::addTagToWrite(h, :cCT)
                  ::addTagToWrite(h, :CFOP)
                  ::addTagToWrite(h, :natOp)
                  ::addTagToWrite(h, :mod)
                  ::addTagToWrite(h, :serie)
                  ::addTagToWrite(h, :nCT)
                  ::addTagToWrite(h, :dhEmi)
                  ::addTagToWrite(h, :tpImp)
                  ::addTagToWrite(h, :tpEmis)
                  ::addTagToWrite(h, :cDV)
                  ::addTagToWrite(h, :tpAmb)
                  ::addTagToWrite(h, :tpCTe)
                  ::addTagToWrite(h, :procEmi)
                  ::addTagToWrite(h, :verProc)
                  ::addTagToWrite(h, :indGlobalizado)
                  ::addTagToWrite(h, :cMunEnv)
                  ::addTagToWrite(h, :xMunEnv)
                  ::addTagToWrite(h, :UFEnv)
                  ::addTagToWrite(h, :modal)
                  ::addTagToWrite(h, :tpServ)
                  ::addTagToWrite(h, :cMunIni)
                  ::addTagToWrite(h, :xMunIni)
                  ::addTagToWrite(h, :UFIni)
                  ::addTagToWrite(h, :cMunFim)
                  ::addTagToWrite(h, :xMunFim)
                  ::addTagToWrite(h, :UFFim)
                  ::addTagToWrite(h, :retira)
                  ::addTagToWrite(h, :xDetRetira)
                  ::addTagToWrite(h, :indIEToma)
                  if !empty(:toma3:toma:value)
                     FWrite(h, '<toma3>')
                        ::addTagToWrite(h, :toma3:toma)
                     FWrite(h, '</toma3>')
                  elseif !empty(:toma4:toma:value)
                     FWrite(h, '<toma4>')
                        ::addTagToWrite(h, :toma4:toma)
                        if !empty(:toma4:CNPJ:value)
                           ::addTagToWrite(h, :toma4:CNPJ)
                           ::addTagToWrite(h, :toma4:IE)
                        else
                           ::addTagToWrite(h, :toma4:CPF)
                        endif
                        ::addTagToWrite(h, :toma4:xNome)
                        ::addTagToWrite(h, :toma4:xFant)
                        ::addTagToWrite(h, :toma4:fone)
                        FWrite(h, '<enderToma>')
                           ::addTagToWrite(h, :toma4:enderToma:xLgr)
                           ::addTagToWrite(h, :toma4:enderToma:nro)
                           ::addTagToWrite(h, :toma4:enderToma:xCpl)
                           ::addTagToWrite(h, :toma4:enderToma:xBairro)
                           ::addTagToWrite(h, :toma4:enderToma:cMun)
                           ::addTagToWrite(h, :toma4:enderToma:xMun)
                           ::addTagToWrite(h, :toma4:enderToma:CEP)
                           ::addTagToWrite(h, :toma4:enderToma:UF)
                           ::addTagToWrite(h, :toma4:enderToma:cPais)
                           ::addTagToWrite(h, :toma4:enderToma:xPais)
                        FWrite(h, '</enderToma>')
                        ::addTagToWrite(h, :toma4:email)
                     FWrite(h, '</toma4>')
                  endif
                  ::addTagToWrite(h, :dhCont)
                  ::addTagToWrite(h, :xJus)
               FWrite(h, '</ide>')
            endwith
            if :compl:submit
               with object :compl
                  FWrite(h, '<compl>')
                     ::addTagToWrite(h, :xCaracAd)
                     ::addTagToWrite(h, :xCaracSer)
                     ::addTagToWrite(h, :xEmi)
                     if :fluxo:submit
                        FWrite(h, '<fluxo>') // 63. Previsão do fluxo da carga [Preenchimento obrigatório para o modal aéreo]
                           ::addTagToWrite(h, :fluxo:xOrig)
                           for each p1 in :fluxo:pass
                              FWrite(h, '<pass>')
                                 ::addTagToWrite(h, p1:xPass)
                                 ::addTagToWrite(h, p1:xDest)
                                 ::addTagToWrite(h, p1:xRota)
                              FWrite(h, '</pass>')
                           next
                        FWrite(h, '</fluxo>')
                     endif
                     if :Entrega:submit
                        FWrite(h, '<Entrega>')
                           do case
                              case (:Entrega:tpPer:value == '0')
                                 FWrite(h, '<semData>')
                                    ::addTagToWrite(h, :Entrega:tpPer)
                                 FWrite(h, '</semData>')
                              case (:Entrega:tpPer:value $ '1|2|3')
                                 FWrite(h, '<comData>')
                                    ::addTagToWrite(h, :Entrega:tpPer)
                                    ::addTagToWrite(h, :Entrega:dProg)
                                 FWrite(h, '</comData>')
                              case (:Entrega:tpPer:value == '4')
                                 FWrite(h, '<noPeriodo>')
                                    ::addTagToWrite(h, :Entrega:tpPer)
                                    ::addTagToWrite(h, :Entrega:dIni)
                                    ::addTagToWrite(h, :Entrega:dFim)
                                 FWrite(h, '</noPeriodo>')
                           endcase
                           do case
                              case (:Entrega:tpHor:value == '0')
                                 FWrite(h, '<semHora>')
                                    ::addTagToWrite(h, :Entrega:tpHor)
                                 FWrite(h, '</semHora>')
                              case (:Entrega:tpHor:value $ '1|2|3')
                                 FWrite(h, '<comHora>')
                                    ::addTagToWrite(h, :Entrega:tpHor)
                                    ::addTagToWrite(h, :Entrega:hProg)
                                 FWrite(h, '</comHora>')
                              case (:Entrega:tpHor:value == '4')
                                 FWrite(h, '<noInter>')
                                    ::addTagToWrite(h, :Entrega:tpHor)
                                    ::addTagToWrite(h, :Entrega:hIni)
                                    ::addTagToWrite(h, :Entrega:hFim)
                                 FWrite(h, '</noInter>')
                           endcase
                        FWrite(h, '</Entrega>')
                     endif
                     ::addTagToWrite(h, :origCalc)
                     ::addTagToWrite(h, :destCalc)
                     ::addTagToWrite(h, :xObs)
                     for each p2 in :ObsCont
                        FWrite(h, '<ObsCont xCampo="' + p2:xCampo:value + '">')
                           ::addTagToWrite(h, p2:xTexto)
                        FWrite(h, '</ObsCont>')
                     next
                     for each p3 in :ObsFisco
                        FWrite(h, '<ObsFisco xCampo="' + p3:xCampo:value + '">')
                           ::addTagToWrite(h, p3:xTexto)
                        FWrite(h, '</ObsFisco>')
                     next
                  FWrite(h, '</compl>')
               endwith
            endif
            with object :emit
               FWrite(h, '<emit>')
                  ::addTagToWrite(h, :CNPJ)
                  ::addTagToWrite(h, :IE)
                  ::addTagToWrite(h, :IEST)
                  ::addTagToWrite(h, :xNome)
                  ::addTagToWrite(h, :xFant)
                  FWrite(h, '<enderEmit>')
                     ::addTagToWrite(h, :enderEmit:xLgr)
                     ::addTagToWrite(h, :enderEmit:nro)
                     ::addTagToWrite(h, :enderEmit:xCpl)
                     ::addTagToWrite(h, :enderEmit:xBairro)
                     ::addTagToWrite(h, :enderEmit:cMun)
                     ::addTagToWrite(h, :enderEmit:xMun)
                     ::addTagToWrite(h, :enderEmit:CEP)
                     ::addTagToWrite(h, :enderEmit:UF)
                     ::addTagToWrite(h, :fone)
                  FWrite(h, '</enderEmit>')
                  ::addTagToWrite(h, :CRT)
               FWrite(h, '</emit>')
            endwith
            if :rem:submit
               with object :rem
                  FWrite(h, '<rem>')
                     if !empty(:CNPJ:value)
                        ::addTagToWrite(h, :CNPJ)
                        ::addTagToWrite(h, :IE)
                     else
                        ::addTagToWrite(h, :CPF)
                     endif
                     ::addTagToWrite(h, :xNome)
                     ::addTagToWrite(h, :xFant)
                     ::addTagToWrite(h, :fone)
                     FWrite(h, '<enderReme>')
                        ::addTagToWrite(h, :endereco:xLgr)
                        ::addTagToWrite(h, :endereco:nro)
                        ::addTagToWrite(h, :endereco:xCpl)
                        ::addTagToWrite(h, :endereco:xBairro)
                        ::addTagToWrite(h, :endereco:cMun)
                        ::addTagToWrite(h, :endereco:xMun)
                        ::addTagToWrite(h, :endereco:CEP)
                        ::addTagToWrite(h, :endereco:UF)
                        ::addTagToWrite(h, :endereco:cPais)
                        ::addTagToWrite(h, :endereco:xPais)
                     FWrite(h, '</enderReme>')
                     ::addTagToWrite(h, :email)
                  FWrite(h, '</rem>')
               endwith
            endif
            if :exped:submit
               with object :exped
                  FWrite(h, '<exped>')
                     if !empty(:CNPJ:value)
                        ::addTagToWrite(h, :CNPJ)
                        ::addTagToWrite(h, :IE)
                     else
                        ::addTagToWrite(h, :CPF)
                     endif
                     ::addTagToWrite(h, :xNome)
                     ::addTagToWrite(h, :xFant)
                     ::addTagToWrite(h, :fone)
                     FWrite(h, '<enderExped>')
                        ::addTagToWrite(h, :endereco:xLgr)
                        ::addTagToWrite(h, :endereco:nro)
                        ::addTagToWrite(h, :endereco:xCpl)
                        ::addTagToWrite(h, :endereco:xBairro)
                        ::addTagToWrite(h, :endereco:cMun)
                        ::addTagToWrite(h, :endereco:xMun)
                        ::addTagToWrite(h, :endereco:CEP)
                        ::addTagToWrite(h, :endereco:UF)
                        ::addTagToWrite(h, :endereco:cPais)
                        ::addTagToWrite(h, :endereco:xPais)
                     FWrite(h, '</enderExped>')
                     ::addTagToWrite(h, :email)
                  FWrite(h, '</exped>')
               endwith
            endif
            if :receb:submit
               with object :receb
                  FWrite(h, '<receb>')
                     if !empty(:CNPJ:value)
                        ::addTagToWrite(h, :CNPJ)
                        ::addTagToWrite(h, :IE)
                     else
                        ::addTagToWrite(h, :CPF)
                     endif
                     ::addTagToWrite(h, :xNome)
                     ::addTagToWrite(h, :xFant)
                     ::addTagToWrite(h, :fone)
                     FWrite(h, '<enderReceb>')
                        ::addTagToWrite(h, :endereco:xLgr)
                        ::addTagToWrite(h, :endereco:nro)
                        ::addTagToWrite(h, :endereco:xCpl)
                        ::addTagToWrite(h, :endereco:xBairro)
                        ::addTagToWrite(h, :endereco:cMun)
                        ::addTagToWrite(h, :endereco:xMun)
                        ::addTagToWrite(h, :endereco:CEP)
                        ::addTagToWrite(h, :endereco:UF)
                        ::addTagToWrite(h, :endereco:cPais)
                        ::addTagToWrite(h, :endereco:xPais)
                     FWrite(h, '</enderReceb>')
                     ::addTagToWrite(h, :email)
                  FWrite(h, '</receb>')
               endwith
            endif
            if :dest:submit
               with object :dest
                  FWrite(h, '<dest>')
                     if !empty(:CNPJ:value)
                        ::addTagToWrite(h, :CNPJ)
                        ::addTagToWrite(h, :IE)
                     else
                        ::addTagToWrite(h, :CPF)
                     endif
                     ::addTagToWrite(h, :xNome)
                     ::addTagToWrite(h, :xFant)
                     ::addTagToWrite(h, :fone)
                     FWrite(h, '<enderDest>')
                        ::addTagToWrite(h, :endereco:xLgr)
                        ::addTagToWrite(h, :endereco:nro)
                        ::addTagToWrite(h, :endereco:xCpl)
                        ::addTagToWrite(h, :endereco:xBairro)
                        ::addTagToWrite(h, :endereco:cMun)
                        ::addTagToWrite(h, :endereco:xMun)
                        ::addTagToWrite(h, :endereco:CEP)
                        ::addTagToWrite(h, :endereco:UF)
                        ::addTagToWrite(h, :endereco:cPais)
                        ::addTagToWrite(h, :endereco:xPais)
                     FWrite(h, '</enderDest>')
                  ::addTagToWrite(h, :email)
                  FWrite(h, '</dest>')
               endwith
            endif
            FWrite(h, '<vPrest>')
               with object :vPrest
                  ::addTagToWrite(h, :vTPrest)
                  ::addTagToWrite(h, :vRec)
                  for each p4 in :Comp
                     FWrite(h, '<Comp>')
                        ::addTagToWrite(h, p4:xNome)
                        ::addTagToWrite(h, p4:vComp)
                     FWrite(h, '</Comp>')
                  next
               endwith
            FWrite(h, '</vPrest>')
            FWrite(h, '<imp>')
               FWrite(h, '<ICMS>')
                  do case
                     case :imp:ICMS00:submit
                        FWrite(h, '<ICMS00>')
                        with object :imp:ICMS00
                           ::addTagToWrite(h, :CST)
                           ::addTagToWrite(h, :vBC)
                           ::addTagToWrite(h, :pICMS)
                           ::addTagToWrite(h, :vICMS)
                        endwith
                        FWrite(h, '</ICMS00>')
                     case :imp:ICMS20:submit
                        FWrite(h, '<ICMS20>')
                        with object :imp:ICMS20
                           ::addTagToWrite(h, :CST)
                           ::addTagToWrite(h, :pRedBC)
                           ::addTagToWrite(h, :vBC)
                           ::addTagToWrite(h, :pICMS)
                           ::addTagToWrite(h, :vICMS)
                        endwith
                        FWrite(h, '</ICMS20>')
                     case :imp:ICMS45:submit
                        FWrite(h, '<ICMS45>')
                           ::addTagToWrite(h, :imp:ICMS45:CST)
                        FWrite(h, '</ICMS45>')
                     case :imp:ICMS60:submit
                        FWrite(h, '<ICMS60>')
                        with object :imp:ICMS60
                           ::addTagToWrite(h, :CST)
                           ::addTagToWrite(h, :vBCSTRet)
                           ::addTagToWrite(h, :vICMSSTRet)
                           ::addTagToWrite(h, :pICMSSTRet)
                           ::addTagToWrite(h, :vCred)
                        endwith
                        FWrite(h, '</ICMS60>')
                     case :imp:ICMS90:submit
                        FWrite(h, '<ICMS90>')
                        with object :imp:ICMS90
                           ::addTagToWrite(h, :CST)
                           ::addTagToWrite(h, :pRedBC)
                           ::addTagToWrite(h, :vBC)
                           ::addTagToWrite(h, :pICMS)
                           ::addTagToWrite(h, :vICMS)
                           ::addTagToWrite(h, :vCred)
                        endwith
                        FWrite(h, '</ICMS90>')
                     case :imp:ICMSOutraUF:submit
                        FWrite(h, '<ICMSOutraUF>')
                        with object :imp:ICMSOutraUF
                           ::addTagToWrite(h, :CST)
                           ::addTagToWrite(h, :pRedBCOutraUF)
                           ::addTagToWrite(h, :vBCOutraUF)
                           ::addTagToWrite(h, :pICMSOutraUF)
                           ::addTagToWrite(h, :vICMSOutraUF)
                        endwith
                        FWrite(h, '</ICMSOutraUF>')
                     case :imp:ICMSSN:submit
                        FWrite(h, '<ICMSSN>')
                        with object :imp:ICMSSN
                           ::addTagToWrite(h, :CST)
                           ::addTagToWrite(h, :indSN)
                        endwith
                        FWrite(h, '</ICMSSN>')
                  endcase
               FWrite(h, '</ICMS>')
               ::addTagToWrite(h, :imp:vTotTrib)
               ::addTagToWrite(h, :imp:infAdFisco)
               if :imp:ICMSUFFim
                  FWrite(h, '<ICMSUFFim>')
                     ::addTagToWrite(h, :imp:vBCUFFim)
                     ::addTagToWrite(h, :imp:pFCPUFFim)
                     ::addTagToWrite(h, :imp:pICMSUFFim)
                     ::addTagToWrite(h, :imp:pICMSInter)
                     ::addTagToWrite(h, :imp:vFCPUFFim)
                     ::addTagToWrite(h, :imp:vICMSUFFim)
                     ::addTagToWrite(h, :imp:vICMSUFIni)
                  FWrite(h, '</ICMSUFFim>')
               endif
            FWrite(h, '</imp>')
            if :infCTeNorm:submit
               FWrite(h, '<infCTeNorm>')
                  FWrite(h, '<infCarga>')
                     with object :infCTeNorm:infCarga
                        ::addTagToWrite(h, :vCarga)
                        ::addTagToWrite(h, :proPred)
                        ::addTagToWrite(h, :xOutCat)
                        for each p5 in :infQ:value
                           FWrite(h, '<infQ>')
                              ::addTagToWrite(h, p5:cUnid)
                              ::addTagToWrite(h, p5:tpMed)
                              if p5:cUnid:value = '03'
                                 p5:qCarga:raw := StrTran(p5:qCarga:value, '.0000')
                              endif
                              ::addTagToWrite(h, p5:qCarga)
                           FWrite(h, '</infQ>')
                        next
                        ::addTagToWrite(h, :vCargaAverb)
                     endwith
                  FWrite(h, '</infCarga>')
                  FWrite(h, '<infDoc>')
                     with object :infCTeNorm:infDoc
                        for each p6 in :infNF:value
                           FWrite(h, '<infNF>')
                              ::addTagToWrite(h, p6:nRoma)
                              ::addTagToWrite(h, p6:nPed)
                              ::addTagToWrite(h, p6:mod)
                              ::addTagToWrite(h, p6:serie)
                              ::addTagToWrite(h, p6:nDoc)
                              ::addTagToWrite(h, p6:dEmi)
                              ::addTagToWrite(h, p6:vBC)
                              ::addTagToWrite(h, p6:vICMS)
                              ::addTagToWrite(h, p6:vBCST)
                              ::addTagToWrite(h, p6:vST)
                              ::addTagToWrite(h, p6:vProd)
                              ::addTagToWrite(h, p6:vNF)
                              ::addTagToWrite(h, p6:nCFOP)
                              ::addTagToWrite(h, p6:nPeso)
                              ::addTagToWrite(h, p6:PIN)
                              ::addTagToWrite(h, p6:dPrev)
                              ::infNFCarga(h, p6:infUnidCarga)
                              ::infNFTransp(h, p6:infUnidTransp)
                           FWrite(h, '</infNF>')
                        next
                        for each p7 in :infNFe:value
                           FWrite(h, '<infNFe>')
                              ::addTagToWrite(h, p7:chave)
                              ::addTagToWrite(h, p7:PIN)
                              ::addTagToWrite(h, p7:dPrev)
                              ::infNFCarga(h, p7:infUnidCarga)
                              ::infNFTransp(h, p7:infUnidTransp)
                           FWrite(h, '</infNFe>')
                        next
                        for each p8 in :infOutros:value
                           FWrite(h, '<infOutros>')
                              ::addTagToWrite(h, p8:tpDoc)
                              ::addTagToWrite(h, p8:descOutros)
                              ::addTagToWrite(h, p8:nDoc)
                              ::addTagToWrite(h, p8:dEmi)
                              ::addTagToWrite(h, p8:vDocFisc)
                              ::addTagToWrite(h, p8:dPrev)
                              ::infNFCarga(h, p8:infUnidCarga)
                              ::infNFTransp(h, p8:infUnidTransp)
                           FWrite(h, '</infOutros>')
                        next
                     endwith
                  FWrite(h, '</infDoc>')
                  if :infCTeNorm:docAnt:submit
                     FWrite(h, '<docAnt>')
                        with object :infCTeNorm:docAnt
                           ::addTagToWrite(h, :tpDoc)
                           ::addTagToWrite(h, :serie)
                           ::addTagToWrite(h, :subser)
                           ::addTagToWrite(h, :nDoc)
                           ::addTagToWrite(h, :dEmi)
                        endwith
                     FWrite(h, '</docAnt>')
                  endif
                  FWrite(h, '<infModal versaoModal="' + :versao:value + '">')
                     if :infCTeNorm:infModal:rodo:submit
                        FWrite(h, '<rodo>')
                           with object :infCTeNorm:infModal:rodo
                              ::addTagToWrite(h, :RNTRC)
                              for each p9 in :occ
                                 FWrite(h, '<occ>')
                                    ::addTagToWrite(h, p9:nOcc)
                                    ::addTagToWrite(h, p9:dEmi)
                                    ::addTagToWrite(h, p9:emiOcc:CNPJ)
                                    ::addTagToWrite(h, p9:emiOcc:IE)
                                    ::addTagToWrite(h, p9:emiOcc:UF)
                                 FWrite(h, '</occ>')
                              next
                           endwith
                        FWrite(h, '</rodo>')
                     elseif :infCTeNorm:infModal:aereo:submit
                        FWrite(h, '<aereo>')
                           with object :infCTeNorm:infModal:aereo
                              ::addTagToWrite(h, :nMinu)
                              ::addTagToWrite(h, :nOCA)
                              ::addTagToWrite(h, :dPrevAereo)
                              FWrite(h, '<natCarga>')
                                 ::addTagToWrite(h, :natCarga:xDime)
                                 for each p10 in :natCarga:cInfManu
                                    ::addTagToWrite(h, p10)
                                 next
                              FWrite(h, '</natCarga>')
                              FWrite(h, '<tarifa>')
                                 ::addTagToWrite(h, :tarifa:CL)
                                 ::addTagToWrite(h, :tarifa:cTar)
                                 ::addTagToWrite(h, :tarifa:vTar)
                              FWrite(h, '</tarifa>')
//                            if :peri:required
                                 // Tag não implementado no TMS.CLOUD
//                            endif
                           endwith
                        FWrite(h, '</aereo>')
                     endif
                  FWrite(h, '</infModal>')
                  for each p11 in :infCTeNorm:veicNovos:value
                     FWrite(h, '<veicNovos>')
                        ::addTagToWrite(h, p11:chassi)
                        ::addTagToWrite(h, p11:cCor)
                        ::addTagToWrite(h, p11:xCor)
                        ::addTagToWrite(h, p11:cMod)
                        ::addTagToWrite(h, p11:vUnit)
                        ::addTagToWrite(h, p11:vFrete)
                     FWrite(h, '</veicNovos>')
                  next
                  // cobr: Não implementado, não usado
                  // infCteSub: Não implementado
                  // infGlobalizado: Não implementado
                  // infServVinc: Não implementado
               FWrite(h, '</infCTeNorm>')
            elseif :infCteComp:submit
               //infCteComp: Não implementado
            elseif :infCteAnu:submit
               // infCteAnu: Não implementado
            endif
            for each p12 in :autXML:value
               FWrite(h, '<autXML>')
                  if !empty(p12:CNPJ:value)
                     ::addTagToWrite(h, p12:CNPJ)
                  else
                     ::addTagToWrite(h, p12:CPF)
                  endif
               FWrite(h, '</autXML>')
            next
            if :infRespTec:submit
               FWrite(h, '<infRespTec>')
                  with object :infRespTec
                     ::addTagToWrite(h, :CNPJ)
                     ::addTagToWrite(h, :xContato)
                     ::addTagToWrite(h, :email)
                     ::addTagToWrite(h, :fone)
                     //::addTagToWrite(h, :idCSRT) # Aguardando Sefaz implementar
                     //::addTagToWrite(h, :hashCSRT) # Aguardando Sefaz implementar
                  endwith
               FWrite(h, '</infRespTec>')
            endif
         FWrite(h, '</infCte>')
         FWrite(h, '<infCTeSupl>')
            FWrite(h, '<qrCodCTe>')
               FWrite(h, '<![CDATA[')
                  FWrite(h, ::infCTeSupl:qrCodCTe:value)
               FWrite(h, ']]>')
            FWrite(h, '</qrCodCTe>')
         FWrite(h, '</infCTeSupl>')
      FWrite(h, '</CTe>')
   endwith
   FClose(h)
return True

method addTagToWrite(hF, tag) class TCTe
   local content
   if ! (ValType(tag) == 'O')
      saveLog({'Erro, tag não é um elemento (objeto) - tag type: ', ValType(tag), ' | conteúdo: ', iif(ValType(tag) $ 'CN', tag, 'Não é C ou N')})
      msgDebugInfo({'tag type: ', ValType(tag), ' | conteúdo: ', iif(ValType(tag) $ 'CN', tag, 'Não é C ou N')})
   endif
   if !empty(tag:value) .or. tag:required
      content := iif(Empty(tag:raw), tag:value, tag:raw)
      if tag:eType = 'C'
         content := removeAccentuation(content)
      endif
      FWrite(hF, '<' + tag:name + '>' + content + '</' + tag:name + '>')
   endif
return Nil

method infNFCarga(h, c) class TCTe
   local i, lacre
   for each i in c:value
      FWrite(h, '<infUnidCarga>')
      ::addTagToWrite(h, i:tpUnidCarga)
      ::addTagToWrite(h, i:idUnidCarga)
      for each lacre in i:lacUnidCarga
         FWrite(h, '<lacUnidCarga>')
            ::addTagToWrite(h, lacre:nLacre)
         FWrite(h, '</lacUnidCarga>')
      next
      ::addTagToWrite(h, i:qtdRat)
      FWrite(h, '</infUnidCarga>')
   next
return Nil

method infNFTransp(h, t) class TCTe
   local i, L, u
   for each i in t:value
      FWrite(h, '<infUnidTransp>')
         ::addTagToWrite(h, i:tpUnidTransp)
         ::addTagToWrite(h, i:idUnidTransp)
         for each L in i:lacUnidTransp
            FWrite(h, '<lacUnidTransp>')
               ::addTagToWrite(h, L:nLacre)
            FWrite(h, '</lacUnidCarga>')
         next
         for each u in i:infUnidCarga
            FWrite(h, '<infUnidCarga>')
               ::addTagToWrite(h, u:tpUnidCarga)
               ::addTagToWrite(h, u:idUnidCarga)
               for each L in u:lacUnidCarga
                  FWrite(h, '<lacUnidCarga>')
                     ::addTagToWrite(h, L:nLacre)
                  FWrite(h, '</lacUnidCarga>')
               next
               ::addTagToWrite(h, u:qtdRat)
            FWrite(h, '</infUnidCarga>')
         next
         ::addTagToWrite(h, i:qtdRat)
      FWrite(h, '</infUnidTransp>')
   next
return Nil
