#include <hmg.ch>
#include "hbclass.ch"
#include <fileio.ch>
#include "Directry.ch"


class TMDFe
   /*
   class: TMDFe
   Projeto: Manifesto Eleletrônico de Documentos Fiscal
   Versão: MOC 3.00a
   Sefaz: https://dfe-portal.svrs.rs.gov.br/Mdfe/Documentos
   */

   data documentation READONLY
   data infMDFe
   data infMDFeSupl
   data xmlName
   data pdfName
   data msgError READONLY
   data validado READONLY
   data situacao
   data remotePath
   data insertEvents
   data ACBr READONLY
   data UTC READONLY
   data systemPath READONLY

   method new() constructor
   method generateKeyMDFe()
   method validarMDFe()
   method criarMDFeXML()
   method validateElement()
   method AAddError()
   method addTagToWrite()
end class

method new(acbr, utc, sysPath) class TMDFe
   ::documentation := "MDFe | Schemas PL_MDFe_300a: mdfeTiposBasico_v3.00.xsd and mdfeModalRodoviario_v3.00.xsd [MOC 3.00a]"
   ::infMDFe := TinfMDFe():new()
   ::infMDFeSupl := TinfMDFeSupl():new()
   ::xmlName := ''
   ::pdfName := ''
   ::msgError := {}
   ::validado := False
   ::situacao := ''
   ::remotePath := ''
   ::insertEvents := {}
   ::ACBr := acbr
   ::UTC := utc
   ::systemPath := sysPath
return self

method generateKeyMDFe() class TMDFe
   local key := " - CHAVE NÃO GERADA"
   if !::validateElement(::infMDFe:ide:cUF) .or.;
      !::validateElement(::infMDFe:ide:dhEmi) .or.;
      !::validateElement(::infMDFe:emit:CNPJ) .or.;
      !::validateElement(::infMDFe:ide:mod) .or.;
      !::validateElement(::infMDFe:ide:serie) .or.;
      !::validateElement(::infMDFe:ide:nMDF) .or.;
      !::validateElement(::infMDFe:ide:tpEmis) .or.;
      !::validateElement(::infMDFe:ide:cMDF)
      return key
   endif
   // Exemplo: "35 2004 61611877000103 57 001 000000057 1 00000057 0"
   with object ::infMDFe
      key := :ide:cUF:value
      key += hb_uSubStr(StrTran(:ide:dhEmi:value,"-", ""),3,4) // AAMM - Ano e Mes de emissao do MDF-e
      key += :emit:CNPJ:value
      key += :ide:mod:value
      key += :ide:serie:value
      key += :ide:nMDF:value
      key += :ide:tpEmis:value
      key += :ide:cMDF:value
      :ide:cDV:value := generateDigitChecker(key) // cDV - Digito Verificador da Chave de Acesso
      key += :ide:cDV:value
   endwith
Return (key)

method validarMDFe() class TMDFe
   local keyGroup := False
   local dispositivo, contratante, condutor, lacre, infMunicipio, chave, averbacao, infSeguro, autorizado, reboque

   with object ::infMDFe
      ::validateElement(:versao)
      if empty(:Id:value) .or. hmg_len(:Id:value) < 47
         :Id:raw := ::generateKeyMDFe()
         :Id:value := 'MDFe' + :Id:raw
         keyGroup := True
      endif
      ::validateElement(:Id)
      if !keyGroup
         ::validateElement(:ide:cUF)
         ::validateElement(:ide:dhEmi)
         ::validateElement(:emit:CNPJ)
         ::validateElement(:ide:mod)
         ::validateElement(:ide:serie)
         ::validateElement(:ide:nMDF)
         ::validateElement(:ide:tpEmis)
         ::validateElement(:ide:cMDF)
      endif
   endwith

   with object ::infMDFe:ide
      ::validateElement(:cUF)
      ::validateElement(:tpAmb)
      ::validateElement(:tpEmit)
      ::validateElement(:tpTransp)
      ::validateElement(:mod)
      ::validateElement(:serie)
      ::validateElement(:nMDF)
      ::validateElement(:cMDF)
      ::validateElement(:cDV)
      ::validateElement(:modal)
      ::validateElement(:dhEmi)
      ::validateElement(:tpEmis)
      ::validateElement(:procEmi)
      ::validateElement(:verProc)
      ::validateElement(:UFIni)
      ::validateElement(:UFFim)
      ::validateElement(:infMunCarrega)
      ::validateElement(:infPercurso)
   endwith

   with object ::infMDFe:emit
      ::validateElement(:CNPJ)
      ::validateElement(:IE)
      ::validateElement(:IEST)
      if ::infMDFe:ide:tpAmb:value == '2'
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
      :fone:raw := onlyNumbers(:fone:raw)
      ::validateElement(:fone)
      ::validateElement(:email)
   endwith

   with object ::infMDFe:infModal:rodo:infANTT
      ::validateElement(:RNTRC)
      ::validateElement(:infCIOT)
      if :valePed:submit
         for each dispositivo in :valePed:disp:value
            ::validateElement(dispositivo:CNPJForn)
            if empty(dispositivo:CNPJPg:value) .and. empty(dispositivo:CPFPg:value)
               ::validateElement(dispositivo:CNPJPg)
               ::validateElement(dispositivo:CPFPg)
            elseif !empty(dispositivo:CNPJPg:value) .and. !empty(dispositivo:CPFPg:value)
               ::AAddError(dispositivo:CNPJPg, "AS TAGs valePed:disp:CNPJpg e valePed:disp:CPFPg NÃO PODEM SER USADAS JUNTAS")
               ::AAddError(dispositivo:CPFPg, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJPg E CPFPg")
            elseif !empty(dispositivo:CNPJPg:value)
               ::validateElement(dispositivo:CNPJPg)
            else
               ::validateElement(dispositivo:CPFPg)
            endif
            ::validateElement(dispositivo:nCompra)
            ::validateElement(dispositivo:vValePed)
         next
      endif
      for each contratante in :infContratante:value
         if Empty(contratante:CNPJ:value) .and. Empty(contratante:CPF:value)
            ::validateElement(contratante:CNPJ)
            ::validateElement(contratante:CPF)
         elseif !Empty(contratante:CNPJ:value) .and. !Empty(contratante:CPF:value)
            ::AAddError(contratante:CNPJ, "AS TAGs infContratante:CNPJ e infContratante:CPF NÃO PODEM SER USADAS JUNTAS")
            ::AAddError(contratante:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
         elseif !Empty(contratante:CNPJ:value)
            ::validateElement(contratante:CNPJ)
         else
            ::validateElement(contratante:CPF)
         endif
      next
   endwith

   with object ::infMDFe:infModal:rodo:veicTracao
      ::validateElement(:cInt)
      ::validateElement(:placa)
      ::validateElement(:RENAVAM)
      ::validateElement(:tara)
      ::validateElement(:capKG)
      ::validateElement(:capM3)
      if :prop:submit
         if Empty(:prop:CNPJ:value) .and. Empty(:prop:CPF:value)
            ::validateElement(:prop:CNPJ)
            ::validateElement(:prop:CPF)
         elseif !Empty(:prop:CNPJ:value) .and. !Empty(:prop:CPF:value)
            ::AAddError(:prop:CNPJ, "AS TAGs veicTracao:prop:CNPJ e veicTracao:prop:CPF NÃO PODEM SER USADAS JUNTAS")
            ::AAddError(:prop:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
         elseif !Empty(:prop:CNPJ:value)
            ::validateElement(:prop:CNPJ)
         else
            ::validateElement(:prop:CPF)
         endif
         ::validateElement(:prop:RNTRC)
         ::validateElement(:prop:xNome)
         ::validateElement(:prop:IE)
         ::validateElement(:prop:UF)
         ::validateElement(:prop:tpProp)
      endif
      ::validateElement(:condutor)
      for each condutor in :condutor:value
         ::validateElement(condutor:xNome)
         ::validateElement(condutor:CPF)
      next
      ::validateElement(:tpRod)
      ::validateElement(:tpCar)
      ::validateElement(:UF)
   endwith

   for each reboque in ::infMDFe:infModal:rodo:veicReboque:value
      if reboque:submit
         with object reboque
            ::validateElement(:cInt)
            ::validateElement(:placa)
            ::validateElement(:RENAVAM)
            ::validateElement(:tara)
            ::validateElement(:capKG)
            ::validateElement(:capM3)
            if :prop:submit
               if Empty(:prop:CNPJ:value) .and. Empty(:prop:CPF:value)
                  ::validateElement(:prop:CNPJ)
                  ::validateElement(:prop:CPF)
               elseif !Empty(:prop:CNPJ:value) .and. !Empty(:prop:CPF:value)
                  ::AAddError(:prop:CNPJ, "AS TAGs veicTracao:prop:CNPJ e veicTracao:prop:CPF NÃO PODEM SER USADAS JUNTAS")
                  ::AAddError(:prop:CPF, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
               elseif !Empty(:prop:CNPJ:value)
                  ::validateElement(:prop:CNPJ)
               else
                  ::validateElement(:prop:CPF)
               endif
               ::validateElement(:prop:RNTRC)
               ::validateElement(:prop:xNome)
               ::validateElement(:prop:IE)
               ::validateElement(:prop:UF)
               ::validateElement(:prop:tpProp)
            endif
            ::validateElement(:tpCar)
            ::validateElement(:UF)
         endwith
      endif
   next

   with object ::infMDFe:infModal:rodo
      ::validateElement(:codAgPorto)
      for each lacre in :lacRodo:value
         ::validateElement(lacre)
      next
   endwith

   with object ::infMDFe:infDoc
      if (hmg_len(:infMunDescarga:value) == 0) .and. :infMunDescarga:required
         ::AAddError(:infMunDescarga, "TAG REQUERIDA - CONTEÚDO NÃO PODE SER VAZIO/NÃO INFORMADO")
      else
         for each infMunicipio in :infMunDescarga:value
            ::validateElement(infMunicipio:cMunDescarga)
            ::validateElement(infMunicipio:xMunDescarga)
            if Empty(infMunicipio:infCTe:value) .and. Empty(infMunicipio:infNFe:value)
               ::AAddError(infMunicipio:infCTe, 'Uma das TAGs :infMDFe:infDoc:infCTe ou :infMDFe:infDoc:infNFe deve ser preenchidas')
            else
               for each chave in infMunicipio:infCTe:value
                  ::validateElement(chave)
               next
               for each chave in infMunicipio:infNFe:value
                  ::validateElement(chave)
               next
            endif
         next
      endif
   endwith

   with object ::infMDFe
      for each infSeguro in :seg:value
         ::validateElement(infSeguro:infResp['respSeg'])
         if Empty(infSeguro:infResp['CNPJ']:value) .and. Empty(infSeguro:infResp['CPF']:value)
            ::validateElement(infSeguro:infResp['CNPJ'])
            ::validateElement(infSeguro:infResp['CPF'])
         elseif !Empty(infSeguro:infResp['CNPJ']:value) .and. !Empty(infSeguro:infResp['CPF']:value)
            ::AAddError(:seg, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
         elseif !Empty(infSeguro:infResp['CNPJ']:value)
            ::validateElement(infSeguro:infResp['CNPJ'])
         else
            ::validateElement(infSeguro:infResp['CPF'])
         endif
         ::validateElement(infSeguro:infSeg)
         ::validateElement(infSeguro:nApol)
         for each averbacao in infSeguro:nAver:value
            ::validateElement(averbacao)
         next
      next
      ::validateElement(:tot:qCTe)
      ::validateElement(:tot:vCarga)
      ::validateElement(:tot:cUnid)
      ::validateElement(:tot:qCarga)
      for each lacre in :lacres:value
         ::validateElement(lacre)
      next
      for each autorizado in :autXML:value
         if Empty(autorizado:CNPJ:value) .and. Empty(autorizado:CPF:value)
            ::validateElement(autorizado:CNPJ)
            ::validateElement(autorizado:CPF)
         elseif !Empty(autorizado:CNPJ:value) .and. !Empty(autorizado:CPF:value)
            ::AAddError(autorizado, "SÓ PODE HAVER UM DOCUMENTO, VERIFIQUE AS TAGs CNPJ E CPF")
         elseif !Empty(autorizado:CNPJ:value)
            ::validateElement(autorizado:CNPJ)
         else
            ::validateElement(autorizado:CPF)
         endif
      next
      ::validateElement(:infAdic:infAdFisco)
      ::validateElement(:infAdic:infCpl)
      if !empty(:infRespTec:CNPJ:value)
         ::validateElement(:infRespTec:CNPJ)
         ::validateElement(:infRespTec:xContato)
         ::validateElement(:infRespTec:email)
         ::validateElement(:infRespTec:fone)
         //::validateElement(:idCSRT)
         //::validateElement(:hashCSRT)
      endif
   endwith

   /*
    * TAG infMDFeSupl : qrCodMDFe
    * Informações suplementares do MDF-e
    * Portais MDFe: https://dfe-portal.svrs.rs.gov.br/Mdfe/Servicos
   */
   if (::infMDFe:ide:tpAmb:value == '1')
      ::infMDFeSupl:qrCodMDFe:value := 'https://dfe-portal.svrs.rs.gov.br/mdfe/qrCode?chMDFe=' + ::infMDFe:Id:raw + '&tpAmb=1'
   else
      ::infMDFeSupl:qrCodMDFe:value := 'https://dfe-portal.svrs.rs.gov.br/mdfe/qrCode?chMDFe=' + ::infMDFe:Id:raw + '&tpAmb=2'
   endif
   ::validateElement(::infMDFeSupl:qrCodMDFe)
   ::validado := True

return Empty(::msgError)

method validateElement(e) class TMDFe
   local isValid := True

   if e:eType == "C"
      if Empty(e:raw)
         e:raw := removeAccentuation(e:value)
      else
         e:raw := removeAccentuation(e:raw)
      endif
      e:value := removeAccentuation(e:value)
   endif

   if !Empty(e:value)
      if (e:eType == 'C') .and. (hmg_len(e:value) > e:maxLength)
         e:value := AllTrim(hb_ULeft(e:value, e:maxLength))
      endif
      if (hmg_len(e:value) < e:minLength) .or. (e:name == 'tagNaoDefinida')
         saveLog('Tag: ' + e:name + ' |Len: ' + hb_ntos(hmg_len(e:value)) + ' |value: ' + e:value + ' |minLength: ' + hb_ntos(e:minLength) + hb_eol() + e:documentation)
      endif
      if (hmg_len(e:value) < e:minLength)
         ::AAddError(e, "TAMANHO INVÁLIDO |Informado: "+hb_ntos(hmg_len(e:value))+ " |Aceito: |Min: "+hb_ntos(e:minLength)+" |Max: "+hb_ntos(e:maxLength))
         isValid := False
      endif
      if !Empty(e:restriction) .and. !(e:value $ e:restriction)
         ::AAddError(e, "RESTRIÇÃO| Informado: "+e:value+" |Esperado: "+e:restriction)
         isValid := False
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

method AAddError(e, msg) class TMDFe
   if (ValType(e:value) == NIL)
      if e:eType $ 'A'
         e:value := {}
      elseif e:eType == 'H'
         e:value := {=>}
      else
         e:value := ''
      endif
   endif
   if (ValType(e:value) == 'C')
      AAdd(::msgError, 'Name TAG: ' + e:name + hb_eol() + e:documentation + hb_eol() + 'ERRO: ' + msg + hb_eol() + 'CONTEÚDO: [' + e:value + ']')
   else
      AAdd(::msgError, 'Name TAG: ' + e:name + hb_eol() + e:documentation + hb_eol() + 'ERRO: ' + msg + hb_eol() + 'CONTEÚDO: [Array/Hash]')
   endif
return nil

method criarMDFeXML() class TMDFe
   local carregamento, percurso, dadosCIOT, dispValePed, contratante, condutor, reboque
   local h, lacre, descarregamento, cte, nfe, seguro, averbacao, autorizado, infSeg

   if !::validado
      ::validarMDFe()
   endif
   if !empty(::msgError)
      return False
   endif

   ::xmlName := ::ACBr:xmlPath + ::infMDFe:Id:raw + '-env.xml'
   if hb_FileExists(::xmlName)
      hb_FileDelete(::xmlName)
   endif

   h := hb_FCreate(::xmlName, FC_NORMAL)

   with object ::infMDFe
      FWrite(h, '<MDFe xmlns="http://www.portalfiscal.inf.br/mdfe">')
         FWrite(h, '<infMDFe Id="' + :Id:value + '" versao="' + :versao:value + '">')
            with object :ide
               FWrite(h, '<ide>')
                  ::addTagToWrite(h, :cUF)
                  ::addTagToWrite(h, :tpAmb)
                  ::addTagToWrite(h, :tpEmit)
                  ::addTagToWrite(h, :tpTransp)
                  ::addTagToWrite(h, :mod)
                  ::addTagToWrite(h, :serie)
                  ::addTagToWrite(h, :nMDF)
                  ::addTagToWrite(h, :cMDF)
                  ::addTagToWrite(h, :cDV)
                  ::addTagToWrite(h, :modal)
                  ::addTagToWrite(h, :dhEmi)
                  ::addTagToWrite(h, :tpEmis)
                  ::addTagToWrite(h, :procEmi)
                  ::addTagToWrite(h, :verProc)
                  ::addTagToWrite(h, :UFIni)
                  ::addTagToWrite(h, :UFFim)
                  for each carregamento in :infMunCarrega:value
                     FWrite(h, '<infMunCarrega>')
                        ::addTagToWrite(h, carregamento:cMunCarrega)
                        ::addTagToWrite(h, carregamento:xMunCarrega)
                     FWrite(h, '</infMunCarrega>')
                  next
                  for each percurso in :infPercurso:value
                     FWrite(h, '<infPercurso>')
                        ::addTagToWrite(h, percurso:UFPer)
                        ::addTagToWrite(h, percurso:dhIniViagem)
                        ::addTagToWrite(h, percurso:indCanalVerde)
                        ::addTagToWrite(h, percurso:indCarregaPosterior)
                     FWrite(h, '</infPercurso>')
                  next
               FWrite(h, '</ide>')
            endwith
            with object :emit
               FWrite(h, '<emit>')
                  ::addTagToWrite(h, :CNPJ)
                  ::addTagToWrite(h, :IE)
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
                     ::addTagToWrite(h, :email)
                  FWrite(h, '</enderEmit>')
               FWrite(h, '</emit>')
            endwith
            FWrite(h, '<infModal versaoModal="' + :versao:value + '">')
               with object :infModal:rodo
                  if :submit
                     FWrite(h, '<rodo>')
                        if :infANTT:submit
                           FWrite(h, '<infANTT>')
                              ::addTagToWrite(h, :infANTT:RNTRC)
                              for each dadosCIOT in :infANTT:infCIOT:value
                                 FWrite(h, '<infCIOT>')
                                    ::addTagToWrite(h, dadosCIOT:CIOT)
                                    ::addTagToWrite(h, iif(Empty(dadosCIOT:CNPJ:value), dadosCIOT:CPF, dadosCIOT:CNPJ))
                                 FWrite(h, '</infCIOT>')
                              next
                              if :infANTT:valePed:submit .and. !(hmg_len(:infANTT:valePed:disp:value) == 0)
                                 FWrite(h, '<valePed>')
                                    for each dispValePed in :infANTT:valePed:disp:value
                                       FWrite(h, '<disp>')
                                          ::addTagToWrite(h, dispValePed:CNPJForn)
                                          ::addTagToWrite(h, iif(Empty(dispValePed:CNPJPg:value), dispValePed:CPFPg, dispValePed:CNPJPg))
                                          ::addTagToWrite(h, dispValePed:Compra)
                                          ::addTagToWrite(h, dispValePed:vValePed)
                                       FWrite(h, '</disp>')
                                    next
                                 FWrite(h, '</valePed>')
                              endif
                              for each contratante in :infANTT:infContratante:value
                                 FWrite(h, '<infContratante>')
                                    ::addTagToWrite(h, iif(Empty(contratante:CNPJ:value), contratante:CPF, contratante:CNPJ))
                                 FWrite(h, '</infContratante>')
                              next
                           FWrite(h, '</infANTT>')
                        endif
                        FWrite(h, '<veicTracao>')
                           ::addTagToWrite(h, :veicTracao:cInt)
                           ::addTagToWrite(h, :veicTracao:placa)
                           ::addTagToWrite(h, :veicTracao:RENAVAM)
                           ::addTagToWrite(h, :veicTracao:tara)
                           ::addTagToWrite(h, :veicTracao:capKG)
                           ::addTagToWrite(h, :veicTracao:capM3)
                           if :veicTracao:prop:submit
                              FWrite(h, '<prop>')
                                 ::addTagToWrite(h, iif(Empty(:veicTracao:prop:CNPJ:value), :veicTracao:prop:CPF, :veicTracao:prop:CNPJ))
                                 ::addTagToWrite(h, :veicTracao:prop:RNTRC)
                                 ::addTagToWrite(h, :veicTracao:prop:xNome)
                                 ::addTagToWrite(h, :veicTracao:prop:IE)
                                 ::addTagToWrite(h, :veicTracao:prop:UF)
                                 ::addTagToWrite(h, :veicTracao:prop:tpProp)
                              FWrite(h, '</prop>')
                           endif
                           for each condutor in :veicTracao:condutor:value
                              FWrite(h, '<condutor>')
                                 ::addTagToWrite(h, condutor:xNome)
                                 ::addTagToWrite(h, condutor:CPF)
                              FWrite(h, '</condutor>')
                           next
                           ::addTagToWrite(h, :veicTracao:tpRod)
                           ::addTagToWrite(h, :veicTracao:tpCar)
                           ::addTagToWrite(h, :veicTracao:UF)
                        FWrite(h, '</veicTracao>')
                        if !(hmg_len(:veicReboque:value) == 0)
                           FWrite(h, '<veicReboque>')
                              for each reboque in :veicReboque:value
                                 ::addTagToWrite(h, reboque:cInt)
                                 ::addTagToWrite(h, reboque:placa)
                                 ::addTagToWrite(h, reboque:RENAVAM)
                                 ::addTagToWrite(h, reboque:tara)
                                 ::addTagToWrite(h, reboque:capKG)
                                 ::addTagToWrite(h, reboque:capM3)
                                 if reboque:prop:submit
                                    FWrite(h, '<prop>')
                                       ::addTagToWrite(h, iif(Empty(:reboque:prop:CNPJ:value), :reboque:prop:CPF, :reboque:prop:CNPJ))
                                       ::addTagToWrite(h, :reboque:prop:RNTRC)
                                       ::addTagToWrite(h, :reboque:prop:xNome)
                                       ::addTagToWrite(h, :reboque:prop:IE)
                                       ::addTagToWrite(h, :reboque:prop:UF)
                                       ::addTagToWrite(h, :reboque:prop:tpProp)
                                    FWrite(h, '</prop>')
                                 endif
                                 ::addTagToWrite(h, reboque:tpCar)
                                 ::addTagToWrite(h, reboque:UF)
                              next
                           FWrite(h, '</veicReboque>')
                        endif
                        ::addTagToWrite(h, :codAgPorto)
                        if !(hmg_len(:lacRodo:value) == 0)
                           FWrite(h, '<lacRodo>')
                              for each lacre in :lacRodo:value
                                 ::addTagToWrite(h, lacre)
                              next
                           FWrite(h, '</lacRodo>')
                        endif
                     FWrite(h, '</rodo>')
                  endif
               endwith
            FWrite(h, '</infModal>')
            FWrite(h, '<infDoc>')
               with object :infDoc
                  for each descarregamento in :infMunDescarga:value
                     FWrite(h, '<infMunDescarga>')
                        ::addTagToWrite(h, descarregamento:cMunDescarga)
                        ::addTagToWrite(h, descarregamento:xMunDescarga)
                        for each cte in descarregamento:infCTe:value
                           FWrite(h, '<infCTe>')
                              ::addTagToWrite(h, cte)
                           FWrite(h, '</infCTe>')
                        next
                        for each nfe in descarregamento:infNFe:value
                           FWrite(h, '<infNFe>')
                              ::addTagToWrite(h, nfe)
                           FWrite(h, '</infNFe>')
                        next
                     FWrite(h, '</infMunDescarga>')
                  next
               endwith
            FWrite(h, '</infDoc>')
            with object :seg
               for each seguro in :value
                  FWrite(h, '<seg>')
                     FWrite(h, '<infResp>')
                        ::addTagToWrite(h, seguro:infResp['respSeg'])
                     // if (seguro:infResp['respSeg']:value == '2')
                           if !Empty(seguro:infResp['CNPJ']:value)
                              ::addTagToWrite(h, seguro:infResp['CNPJ'])
                           else
                              ::addTagToWrite(h, seguro:infResp['CPF'])
                           endif
                     // endif
                     FWrite(h, '</infResp>')
                     infSeg := seguro:infSeg:value
                     if !Empty(infSeg['xSeg'])
                        FWrite(h, '<infSeg>')
                           FWrite(h, '<xSeg>' + infSeg['xSeg'] + '</xSeg>')
                        // if (seguro:infResp['respSeg']:value == '2')
                              FWrite(h, '<CNPJ>' + infSeg['segCNPJ'] + '</CNPJ>')
                        // else
                        //    FWrite(h, '<CNPJ/>') // Verificado: Essa tag é requerida do jeito q está sempre respSeg = 1
                        // endif
                        FWrite(h, '</infSeg>')
                     endif
                     ::addTagToWrite(h, seguro:nApol)
                     for each averbacao in seguro:nAver:value
                        ::addTagToWrite(h, averbacao)
                     next
                  FWrite(h, '</seg>')
               next
            endwith

            // Provisório, tem que implementar URGENTE
            // FWrite(h, "<prodPred><tpCarga>05</tpCarga><xProd>PEÇAS EM GERAL</xProd><cEAN>00008004222782</cEAN><NCM>39231000</NCM></prodPred>")
            with object :prodPred
               FWrite(h, '<prodPred>')
                  ::addTagToWrite(h, :tpCarga)
                  ::addTagToWrite(h, :xProd)
                  ::addTagToWrite(h, :cEAN)
                  ::addTagToWrite(h, :NCM)
                  FWrite(h, '<infLotacao>')
                     FWrite(h, '<infLocalCarrega>')
                        ::addTagToWrite(h, :infLocalCarrega)
                     FWrite(h, '</infLocalCarrega>')
                     FWrite(h, '<infLocalDescarrega>')
                        ::addTagToWrite(h, :infLocalDescarrega)
                     FWrite(h, '</infLocalDescarrega>')
                  FWrite(h, '</infLotacao>')
               FWrite(h, '</prodPred>')
            endwith

            with object :tot
               FWrite(h, '<tot>')
                  ::addTagToWrite(h, :qCTe)
                  ::addTagToWrite(h, :vCarga)
                  ::addTagToWrite(h, :cUnid)
                  ::addTagToWrite(h, :qCarga)
               FWrite(h, '</tot>')
            endwith
            for each autorizado in :autXML:value
               FWrite(h, '<autXML>')
                  ::addTagToWrite(h, iif(Empty(autorizado:CNPJ:value), autorizado:CPF, autorizado:CNPJ))
               FWrite(h, '</autXML>')
            next
            if !Empty(:infAdic:infAdFisco:value) .or. !Empty(:infAdic:infCpl:value)
               FWrite(h, '<infAdic>')
                  ::addTagToWrite(h, :infAdic:infAdFisco)
                  ::addTagToWrite(h, :infAdic:infCpl)
               FWrite(h, '</infAdic>')
            endif
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
         FWrite(h, '</infMDFe>')
         FWrite(h, '<infMDFeSupl>')
            FWrite(h, '<qrCodMDFe>')
               FWrite(h, '<![CDATA[')
                  FWrite(h, ::infMDFeSupl:qrCodMDFe:value)
               FWrite(h, ']]>')
            FWrite(h, '</qrCodMDFe>')
         FWrite(h, '</infMDFeSupl>')
      FWrite(h, '</MDFe>')
   endwith
   FClose(h)

return True

method addTagToWrite(hF, tag) class TMDFe
   if !empty(tag:value) .or. tag:required
      FWrite(hF, '<' + tag:name + '>' + iif(Empty(tag:raw), tag:value, tag:raw) + '</' + tag:name + '>')
   endif
return Nil
