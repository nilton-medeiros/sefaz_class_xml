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

// Atualizado: 2022-06-07 15:20 | Trocado propriedade tpAmb para xTpAmb class TACBrMonitor

class TACBrMonitor
   data ACBr protected
   data DFe protected
   data chDFe readonly
   data dfe_id readonly
   data xTpAmb readonly
   data tpAmb readonly
   data emitCNPJ protected
   data dhEmi protected
   data situacao
   data events
   data inFile protected
   data outFile protected
   data tmpFile protected
   data xmlSubmit readonly
   data pdfName readonly
   data xmlName readonly
   data pdfCancel readonly
   data xmlCancel readonly
   data copyPDFPath readonly
   data copyXMLPath readonly
   data sharedPath readonly
   data systemPath readonly
   data remotePath readonly
   data xmlAutPath readonly
   data xmlCanPath readonly
   data xmlEncPath readonly
   data xmlInuPath readonly
   data pdfAutPath readonly
   data command protected
   data dhRecbto  readonly
   data cStat readonly
   data xMotivo readonly
   data nProt readonly
   data serviceStatus readonly
   data cert_serial_number readonly
   data cert_company_name readonly
   data cert_cnpj readonly
   data cert_expiration_date readonly
   data cert_certifier readonly
   data certificate_is_valid readonly

   method new() constructor
   method StatusServico()
   method SetFormaEmissao(tpEmis)
   method SetAmbiente(tpEmis)
   method ObterCertificado()
   method Assinar()
   method Validar()
   method Enviar()
   method Consultar()
   method Cancelar()
   method Encerrar()
   method Inutilizar()
   method imprimirPDF()
   method imprimirInutilizacaoPDF()
   method submit(delXmlStatus) protected
   method getReturnXML() protected
   method getReturnTXT() protected
   method read_return_xml() protected
   method sendToPrinter()
   method copyFromTo()
   method setFileFromEvento()
   method foram_lidos(lidos)
end class

method new(params) class TACBrMonitor
   local anoMes
   // params = {'DFe' => ['CTe'|'MDFe'], 'chDFe' => , 'dfeId' => , 'sysPath' => , 'remotePath' => , 'situacao' => , 'emitCNPJ' => , 'dhEmi' => , 'tpAmb' => emitente:getField('tpAmb')}
   ::ACBr := Memvar->appData:ACBr
   ::serviceStatus := ::ACBr:isActive()
   ::DFe := params['DFe']
   ::chDFe := params['chDFe']
   ::dfe_id := params['dfeId']
   ::systemPath := params['sysPath']
   ::remotePath := params['remotePath']
   ::situacao := params['situacao']
   ::events := {}
   ::emitCNPJ := params['emitCNPJ']
   ::dhEmi := params['dhEmi']

   anoMes := Left(onlyNumbers(::dhEmi), 6)

   ::xmlAutPath := ::ACBr:DFePath + ::emitCNPJ + '\' + anoMes + '\' + ::DFe + '\'
   ::xmlCanPath := ::ACBr:DFePath + ::emitCNPJ + '\' + anoMes + '\Evento\Cancelamento\'
   ::xmlEncPath := ::ACBr:DFePath + ::emitCNPJ + '\' + anoMes + '\Evento\Encerramento\'
   ::xmlInuPath := ::ACBr:DFePath + ::emitCNPJ + '\' + anoMes + '\Inu\'
   ::pdfAutPath := ::ACBr:pdfPath + ::emitCNPJ + '\' + anoMes + '\' + ::DFe + '\'
   ::copyPDFPath := ''
   ::copyXMLPath := ''

   if !Empty(::ACBr:sharedPath)
      ::copyPDFPath := ::ACBr:sharedPath + 'pdf\' +::emitCNPJ + '\' + anoMes + '\' + ::DFe + '\'
      ::copyXMLPath := ::ACBr:sharedPath + 'xml\' +::emitCNPJ + '\' + anoMes + '\' + ::DFe + '\'
      if !hb_DirExists(::copyPDFPath)
         hb_DirBuild(::copyPDFPath)
      endif
      if !hb_DirExists(::copyXMLPath)
         hb_DirBuild(::copyXMLPath)
      endif
   endif
   ::tpAmb := params['tpAmb']
   ::xTpAmb := iif(::tpAmb == '2', 'HOMOLOGAÇÃO', 'PRODUÇÃO')
   ::inFile := ::ACBr:inputPath + ::chDFe + '.txt'
   ::outFile := ::ACBr:outputPath + ::chDFe + '-resp.txt'
   ::tmpFile := ::systemPath + 'tmp\' + ::chDFe + '-resp.txt'
   ::xmlSubmit := ::ACBr:xmlPath + ::chDFe + '-env.xml'
   ::xmlName := ''
   ::pdfName := ''
   ::command := ''
   ::pdfCancel := ''
   ::xmlCancel := ''
   ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
   ::cStat := ''
   ::xMotivo := ''
   ::nProt := hb_HGetDef(params, 'nProt', '')
   if !hb_DirExists(::xmlAutPath)
      hb_DirBuild(::xmlAutPath)
   endif
   if !hb_DirExists(::xmlCanPath)
      hb_DirBuild(::xmlCanPath)
   endif
   if !hb_DirExists(::xmlEncPath)
      hb_DirBuild(::xmlEncPath)
   endif
   if !hb_DirExists(::xmlInuPath)
      hb_DirBuild(::xmlInuPath)
   endif
   if !hb_DirExists(::pdfAutPath)
      hb_DirBuild(::pdfAutPath)
   endif
   if !::serviceStatus
      AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'ACBrMonitor não está Ativo ou Instalado | Ambiente de ' + ::xTpAmb})
   endif
   ::certificate_is_valid := False
return self

method StatusServico() class TACBrMonitor
   if !::serviceStatus
      return False
   endif
   ::command := ::DFe + '.StatusServico'
   ::submit()
return ::getReturnXML()

method SetFormaEmissao(tpEmis) class TACBrMonitor
   ::command := ::DFe + '.SetFormaEmissao' + '(' + tpEmis + ')'
   ::submit()
return Nil

method SetAmbiente() class TACBrMonitor
   ::command := ::DFe + '.SetAmbiente' + '(' + ::tpAmb + ')'
   ::submit()
return Nil

method Assinar() class TACBrMonitor
   if !::serviceStatus
      return False
   endif
   ::command := ::DFe + '.Assinar' + ::DFe + '("' + ::xmlSubmit + '")'
   ::xmlName := ''
   ::pdfName := ''
   ::xmlCancel := ''
   ::pdfCancel := ''
   ::submit()
return ::getReturnTXT()

method Validar() class TACBrMonitor
   if !::serviceStatus
      return False
   endif
   ::command := ::DFe + '.Validar' + ::DFe + '("' + ::xmlName + '")'
   ::pdfName := ''
   ::xmlCancel := ''
   ::pdfCancel := ''
   ::submit()
return ::getReturnTXT()

method Enviar() class TACBrMonitor
   local destinationFile, returnStatus := False
   if !::serviceStatus
      return False
   endif
   ::command := ::DFe + '.Enviar' + ::DFe + '("' + ::xmlName + '")'
   ::xmlSubmit := ::xmlName
   ::xmlName := ''
   ::pdfName := ''
   ::xmlCancel := ''
   ::pdfCancel := ''
   ::submit()
   if ::getReturnXML()
      if (::situacao == 'AUTORIZADO')
         ::imprimirPDF()
         if !Empty(::copyXMLPath)
            destinationFile := ::copyXMLPath + ::chDFe + '-' + Lower(::DFe) + '.xml'
            if !hb_FileExists(destinationFile)
               ::copyFromTo(::xmlName, destinationFile)
            endif
         endif
      elseif (::cStat $ '204|205|218|539')
            /* Para os retornos abaixo, atualiza o status do CTe no TMS.Cloud
             * 204|Rejeição: Duplicidade de CT-e/MDF-e
             * 205|Rejeição: CT-e está denegado na base de dados da SEFAZ
             * 218|Rejeição: CT-e/MDF-e já está cancelado na base de dados da SEFAZ
            */
             returnStatus := ::Consultar()
      elseif (::cStat == '206')
         // 206|Rejeição: Número de CT-e já está inutilizado na Base de dados da SEFAZ
         ::situacao := 'INUTILIZADO'
         ::xmlName := ''
         ::pdfName := ''
      elseif (::cStat == '678')
         ::situacao := 'REJEITADO'  // 678|Rejeição: Uso Indevido - Vários acessos consecutivos de uma mesma requisição, Aguardar 60 minutos para nova requisição
         if Empty(::dhRecbto) .or. (::dhRecbto == "0000-00-00 00:00:00")
            ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
         endif
         AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => ::nProt, 'cStat' => '678', 'xMotivo' => 'Rejeição: Uso Indevido | Ambiente de ' + ::xTpAmb})
      endif
      returnStatus := True
   else
      returnStatus := ::Consultar()
   endif
return returnStatus

method Consultar() class TACBrMonitor
   local destinationFile, inuXml, returnStatus := False
   if !::serviceStatus
      return False
   endif
   ::command := ::DFe + '.Consultar' + ::DFe + '("' + ::xmlSubmit + '")'
   ::submit()
   if ::getReturnXML()
      if (::situacao $ 'AUTORIZADO|CANCELADO')
         ::imprimirPDF()
      elseif (::situacao == 'INUTILIZADO')
         if Empty(::xmlName)
            ::xmlName := ::xmlInuPath + ::chDFe + '-' + Lower(::DFe) + '.xml'
         endif
         if hb_FileExists(::xmlName)
            inuXml := Token(::xmlName, '\')
            inuXml := Left(inuXml, At('-', inuXml) - 1)
            ::imprimirInutilizacaoPDF(inuXml)
         endif
      endif
      returnStatus := True
   endif
   if !Empty(::copyXMLPath) .and. !Empty(::xmlName) .and. (::situacao $ 'AUTORIZADO|CANCELADO|INUTILIZADO')
      destinationFile := ::copyXMLPath + token(::xmlName, '\')
      if !hb_FileExists(destinationFile)
         ::copyFromTo(::xmlName, destinationFile)
      endif
   endif
return returnStatus

method Cancelar(xJust) class TACBrMonitor
   local returnStatus := False
   default xJust := 'CANCELAMENTO DO ' + Upper(::DFe) // detEvento
   if !::serviceStatus
      return False
   endif
   ::command := ::DFe + '.Cancelar' + ::DFe + '("' + ::chDFe + '", "' + xJust + '")'
   ::submit()
   if ::getReturnXML() .and. (::situacao $ 'CANCELADO|ENCERRADO')
      returnStatus := ::imprimirPDF()
      if ! returnStatus
         returnStatus := ::Consultar()
      endif
   elseif ! Empty(::xMotivo)
      if Empty(::dhRecbto) .or. (::dhRecbto == "0000-00-00 00:00:00")
         ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
      endif
      AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => ::nProt, 'cStat' => ::cStat, 'xMotivo' => ::xMotivo + ' | Ambiente de ' + ::xTpAmb})
   endif
return returnStatus

method Encerrar(cMunicipioEmitente) class TACBrMonitor
   local returnStatus := False
   if !::serviceStatus
      return False
   endif
   // MDFE.ENCERRARMDFE(nChaveMDFE,dtEnc,cMunicipioDescarga,[nCNPJ],[nProtocolo])
   // MDFe.EncerrarMDFe("35200657296543000115580010000000611000000787", "02/07/2020", "3550308", "57296543000115", "935200016709291")
   ::command := ::DFe + '.Encerrar' + ::DFe + '("' + ::chDFe + '", "' + DToC(Date()) + '", "' + cMunicipioEmitente + '", "' + ::emitCNPJ + '", "' + ::nProt + '")'
   ::submit()
   if ::getReturnXML() .and. (::situacao == 'ENCERRADO')
      returnStatus := ::imprimirPDF()
   endif
return returnStatus

method Inutilizar(params) class TACBrMonitor
   local inuXml, returnStatus := False, ano := SubStr(::dhEmi, 3, 2)
   if !::serviceStatus
      return False
   endif
   // params = {'xJust' => cte:getField('xObs'), 'mod' => mod, 'serie' => serie, 'numInicial' => faixaInicial, 'numFinal' => faixaFinal}
   ::command := 'CTE.InutilizarCTe("'
   ::command += ::emitCNPJ + '","'
   ::command += hb_HGetDef(params, 'xJust', 'PROBLEMA COM A NUMERACAO DO CTE') + '",'
   ::command += ano + ','
   ::command += params['mod'] + ','
   ::command += params['serie'] + ','
   ::command += hb_ntos(params['numInicial']) + ','
   ::command += hb_ntos(params['numFinal']) + ')'
   ::chDFe := params['chave']
   ::submit()
   if ::getReturnXML() .and. (::situacao == 'INUTILIZADO')
      returnStatus := True
      inuXml := Token(::xmlName, '\')
      inuXml := Left(inuXml, At('-', inuXml) - 1)
      ::imprimirInutilizacaoPDF(inuXml)
   endif
return returnStatus

method imprimirPDF() class TACBrMonitor
   local target, infPDF, pdfStatus := False
   local xmlMDFe
   if !::serviceStatus
      return False
   endif
   if Empty(::xmlName) .or. !hb_FileExists(::xmlName)
      target := ::xmlName
      ::xmlName := ::xmlAutPath + ::chDFe + '-' + Lower(::DFe) + '.xml'
      if !hb_FileExists(::xmlName)
         if !Empty(::copyXMLPath)
            ::xmlName := ::copyXMLPath + ::chDFe + '-' + Lower(::DFe) + '.xml'
         endif
         if !hb_FileExists(::xmlName)
            ::xmlName := target
         endif
      endif
   endif
   if Empty(::xmlName)
      saveLog('Arquivo ::xmlName vazio, não será possível gerar o pdf')
      return False
   endif
   if Empty(::dhRecbto) .or. (::dhRecbto == "0000-00-00 00:00:00")
      ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
   endif
   if (::situacao == 'CANCELADO')
      // Cancelado CTe/MDFe
      if Empty(::xmlCancel) .or. !hb_FileExists(::xmlCancel)
         ::setFileFromEvento()
      endif
      if Empty(::xmlCancel)
         saveLog('Arquivo ::xmlCancel vazio, não será possível gerar o pdf')
         AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'Erro ao gerar PDF de Cancelamento | Ambiente de ' + ::xTpAmb})
      elseif !hb_FileExists(::xmlCancel)
         saveLog('Arquivo XML do ' + ::DFe + ' cancelado não encontrado: ' + ::xmlCancel)
         AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'Erro ao gerar PDF de Cancelamento | Ambiente de ' + ::xTpAmb})
      elseif hb_FileExists(::xmlName)
         ::command := ::DFe + '.ImprimirEventoPDF("' + ::xmlCancel + '", "' +  ::xmlName + '")'
         ::submit()
         pdfStatus := ::getReturnTXT()
      else
         saveLog('Arquivo XML do ' + ::DFe + ' cancelado não encontrado: ' + ::xmlName)
         AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'Erro ao gerar PDF de Cancelamento | Ambiente de ' + ::xTpAmb})
      endif
   elseif (Lower(::DFe) == 'mdfe')
      if (::situacao == 'ENCERRADO')
         xmlMDFe := ::xmlAutPath + ::chDFe + '-' + Lower(::DFe) + '.xml'
         if hb_FileExists(xmlMDFe)
            ::command := ::DFe + '.ImprimirEventoPDF("' + ::xmlName + '", "' + xmlMDFe + '")'
         else
            xmlMDFe := ::copyXMLPath + ::chDFe + '-' + Lower(::DFe) + '.xml'
            if hb_FileExists(xmlMDFe)
               ::command := ::DFe + '.ImprimirEventoPDF("' + ::xmlName + '", "' + xmlMDFe + '")'
            else
               saveLog('XML de autorização não encontrado para imprimir PDF de Encerramento: ' + ::xmlMDFe)
               ::command := ''
               AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'XML de autorização não encontrado para imprimir PDF de Encerramento | Ambiente de ' + ::xTpAmb})
            endif
         endif
      else
         ::command := ::DFe + '.ImprimirDAMDFePDF("' + ::xmlName + '")'
      endif
      if !Empty(::command)
         ::submit()
      endif
      pdfStatus := ::getReturnTXT()
      // Verificar os arquivos de retornos do encerramento
   else
      infPDF := TGerarPDFdeXML():new(::xmlName, ::pdfAutPath, ::systemPath, ::chDFe)
      if (pdfStatus := infPDF:ok)
         ::pdfName := infPDF:pdfName
         AAdd(::events, {'dhRecbto' => infPDF:dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'PDF do DACTE gerado com sucesso | Ambiente de ' + ::xTpAmb})
         saveLog('PDF do DA' + Upper(::DFe) + ' gerado com sucesso. Arquivo: ' + ::pdfName)
      elseif infPDF:canceladoStatus
         ::situacao := 'CANCELADO'
         if Empty(::xmlCancel)
            ::xmlCancel := ::xmlName
            ::xmlName := ''
         endif
         ::command := ::DFe + '.ImprimirEventoPDF("' + ::xmlCancel + '", "' +  ::xmlName + '")'
         ::submit()
         pdfStatus := ::getReturnTXT()
      else
         AAdd(::events, {'dhRecbto' => infPDF:dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'Erro ao gerar PDF do DACTE | Ambiente de ' + ::xTpAmb})
         saveLog('Erro ao gerar o PDF do DA' + Upper(::DFe) + '. Arquivo: ' + ::pdfName)
      endif
   endif
   if !Empty(::pdfName)
      ::sendToPrinter(::pdfName)
   endif
   if !Empty(::pdfCancel)
      ::sendToPrinter(::pdfCancel)
   endif
return pdfStatus

method imprimirInutilizacaoPDF(inuXml) class TACBrMonitor
   local renamePDF, returnStatus := False
   if !::serviceStatus
      return False
   endif
   ::command := 'CTE.ImprimirInutilizacaoPDF("' + inuXml + '")'
   // Ao imprimir um número de CTe inutilizado, não apagar os xmls de retorno da faixa inu ao submeter ao ACBrMonitor
   ::submit(False)
   if ::getReturnXML()
      renamePDF := ::pdfAutPath + ::chDFe + '-procInutCTe.pdf'
      ::pdfName := ::ACBr:pdfPath + '-procInutCTe.pdf'
      hb_vfMoveFile( ::pdfName, renamePDF)
      ::pdfName := renamePDF
      returnStatus := True
   endif
   ::sendToPrinter(::pdfName)
return returnStatus

method submit(delXmlStatus) class TACBrMonitor
   local h
   default delXmlStatus := True
   hb_FileDelete(::inFile)
   hb_FileDelete(::outFile)
   // Antes de enviar o comando, apaga todos os arquivos na pasta de retorno do ACBrMonitorPlus, Na inutilização de faixa, não é deletado a faixa de ctes para impressão
   if delXmlStatus
      hb_FileDelete(::ACBr:returnPath + '*.xml')
   endif
   if Empty(::command)
      saveLog('Comando não informado!')
   else
      saveLog('Comando: ' + ::command)
      // Submete o comando ao ACBrMonitorPlus
      h := hb_FCreate(::inFile, FC_NORMAL)
      FWrite(h, ::command)
      FClose(h)
   endif
return Nil

method getReturnXML() class TACBrMonitor
   local lidos := 0
   local em_processamento := False
   local xmlReturned := {}
   local startTime
   local returningFiles := '*.xml'
   saveLog('Arquivo de comando: ' + ::inFile + ' | Aguardando retorno de ACBrMonitor...')
   sysWait(1)
   if ('cancelar' $ Lower(::command)) .or. ('encerrar' $ Lower(::command))
      returningFiles := '*-eve.xml'
   endif
   startTime := Seconds()
   do while Empty(xmlReturned) .and. ((Seconds() - startTime) < 30)
      sysWait(1)
      xmlReturned := hb_Directory(::ACBr:returnPath + returningFiles)
   enddo

   if Empty(xmlReturned)
      saveLog('ACBrMonitor não responde (timeout)')
   else
      // Espera aparecer mais alguns arquivos e re-lê
      sysWait(2)
      xmlReturned := hb_Directory(::ACBr:returnPath + returningFiles)
      AEval(xmlReturned, {|aFile| ::read_return_xml(aFile[F_NAME], @lidos, @em_processamento)})
      ::foram_lidos(!(lidos == 0))
      if em_processamento
         // Sefaz em processamento - houve uma demora, tentar pegar próxima resposta
         sysWait(2)
         xmlReturned := hb_Directory(::ACBr:returnPath + '*.xml')
         AEval(xmlReturned, {|aFile| ::read_return_xml(aFile[F_NAME], @lidos, @em_processamento)})
         ::foram_lidos(!(lidos == 0))
      endif
   endif

return !(lidos == 0)

method read_return_xml(xmlRead, lidos, em_processamento) class TACBrMonitor
   local error, xml, lowerXmlName := Lower(xmlRead)

   if (Right(lowerXmlName, 8) == 'soap.xml') .or. (Right(lowerXmlName, 11) $ 'env-lot.xml|ped-rec.xml|ped-sit.xml|ped-sta.xml|ped-inu.xml|ped-eve.xml')
      // ACBrMonitor retorna vários arquivos xml de envio e retorno, aqui dispensamos os irrelevantes para nosso sistema
      hb_FileDelete(::ACBr:returnPath + xmlRead)
      return Nil
   endif
   saveLog('Lendo arquivo ' + xmlRead)
   xml := TReadXML():new(::ACBr:returnPath + xmlRead, ::DFe)
   if xml:isValidated
      lidos++
      ::dhRecbto := xml:dhRecbto
      if Empty(::dhRecbto) .or. Len(::dhRecbto) < 8
         ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
      endif
      ::cStat := xml:cStat
      ::xMotivo := xml:xMotivo
      ::nProt := xml:nProt
      AAdd(::events, {'dhRecbto' => xml:dhRecbto, 'nProt' => xml:nProt, 'cStat' => xml:cStat, 'xMotivo' => xml:xMotivo + ' | Ambiente de ' + ::xTpAmb})
      saveLog('Informações lidas: dhRecbto: [' + ::dhRecbto + '] cStat: [' + ::cStat + '] xMotivo: [' + ::xMotivo + '] nProt: [' + ::nProt + '] tpEvento: [' + xml:tpEvento + ']')
      switch xml:cStat
         case '100'
            ::situacao := 'AUTORIZADO'
            ::xmlName := ::xmlAutPath + ::chDFe + '-' + Lower(::DFe) +'.xml'
            exit
         case '101' // Cancelamento de DF-e homologado
            ::situacao := 'CANCELADO'
            ::xmlCancel := ::xmlCanPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
            if (xmlRead == ::chDFe + '-sit.xml')
               error := hb_FCopy(::ACBr:returnPath + xmlRead, ::xmlCancel)
               if (error == 0)
                  saveLog('Arquivo ' + ::ACBr:returnPath + xmlRead + ' copiado com sucesso para ' + ::xmlCancel)
               else
                  saveLog('Erro (' + hb_ntos(error) + ') ao tentar copiar arquivo: ' + hb_eol() + '      Origem: ' + ::ACBr:returnPath + xmlRead + hb_eol() + '     Destino: ' + ::xmlCancel)
               endif
            endif
            exit
         case '102'
            ::situacao := 'INUTILIZADO'
            ::xmlName := ::xmlInuPath + StrTran(lowerXmlName, '-inu.xml', '-procInut' + ::DFe + '.xml')
            exit
         case '105'  // Lote em processamento - Sefaz ainda não processou
            em_processamento := True
         case '110' // Retorna qdo em Homologação
            ::situacao := 'DENEGADO'
            exit
         case '132' // Encerramento de MDF-e homologado
            ::situacao := 'ENCERRADO'
            ::setFileFromEvento(xml:xmlId, xmlRead)
            exit
         case '631' // Duplicidade de Evento - Encerramento de MDF-e já foi homologado
            if ('cancelar' $ Lower(::command))
               ::situacao := 'CANCELADO'
               ::setFileFromEvento(xml:xmlId, xmlRead)
            elseif ('encerrar' $ Lower(::command))
               ::situacao := 'ENCERRADO'
               ::setFileFromEvento(xml:xmlId, xmlRead)
            endif
            exit
         case '135' // Evento registrado e vinculado ao DF-e
            if (xml:tpEvento == '110111')
               ::situacao := 'CANCELADO'
               ::setFileFromEvento(xml:xmlId, xmlRead)
            elseif (xml:tpEvento == '110112')
               ::situacao := 'ENCERRADO'
               ::setFileFromEvento(xml:xmlId, xmlRead)
            endif
            exit
         case '218' // Rejeição: CT-e já está cancelada na base de dados da SEFAZ
            ::situacao := 'CANCELADO'
            exit
         case '301' // Retorna qdo em Produção
            ::situacao := 'DENEGADO'
            exit
         case '528' // Rejeição: Vedado cancelamento se exitir MDF-e autorizado para o CT-e
            ::situacao := 'AUTORIZADO' // Mantém o status do CT-e autorizado.
            exit
         otherwise
            if (Left(Lower(removeAccentuation(xml:xMotivo)), 8) == 'rejeicao')
               ::situacao := 'REJEITADO'
            elseif (Left(Lower(removeAccentuation(xml:xMotivo)), 8) == 'denegado')
               ::situacao := 'DENEGADO'
            endif
      endswitch
      saveLog({'Arquivo de retorno xml lido com sucesso: ', xmlRead})
   else
      saveLog({'Arquivo de retorno xml inválido: ', xmlRead, hb_eol(), 'isRead: ', xml:isRead, ' |dhRecbto: ', xml:dhRecbto, ' |nProt: ', xml:nProt, ' |cStat: ', xml:cStat, ' |xMotivo: ', xml:xMotivo})
      AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'Arquivo de retorno xml inválido, ver log CTeMonitor! | Ambiente de ' + ::xTpAmb})
   endif

   hb_vfMoveFile(::ACBr:returnPath + xmlRead, ::ACBr:returnPath + 'lidos\' + xmlRead)

return Nil

method getReturnTXT() class TACBrMonitor
   local target, txt, txtStatus := False
   local startTime, days_lefts, msg_expiration
   local comando

   if ("(" $ ::command)
      comando := Left(::command, At('(', ::command) - 1)
   else
      comando := ::command
   endif

   saveLog( comando + ': ' + ::inFile + hb_eol() + 'Aguardando retorno de ACBrMonitor...')
   sysWait(3)
   startTime := Seconds()
   do while !hb_FileExists(::outFile) .and. ((Seconds() - startTime) < 30)
      sysWait(2)
   enddo

   if hb_FileExists(::outFile)
      saveLog('Lendo arquivo: ' + ::outFile)
      txt := TReadTXT():new(::outFile, comando)
      if txt:isRead
         ::dhRecbto := txt:dhRecbto
         ::cStat := txt:cStat
         ::xmotivo := txt:xMotivo
         ::nProt := txt:nProt
         if ('imprimir' $ Lower(comando))
            if ::situacao = 'CANCELADO'
               ::pdfCancel := txt:pdfName
            else
               ::pdfName := txt:pdfName
            endif
            if !hb_FileExists(txt:pdfName)
               target := StrTran(txt:pdfName, ::DFe + '.pdf', 'NFe.pdf')
               if hb_FileExists(target)
                  if (FRename(target, txt:pdfName) == 0)
                     saveLog('Arquivo pdf renomeado de: ' + target + ' para: ' + txt:pdfName)
                  else
                     saveLog('Erro ao renomear arquivo de: ' + target + ' para: ' + txt:pdfName)
                     if ::situacao = 'CANCELADO'
                        ::pdfCancel := target
                     else
                        ::pdfName := target
                     endif
                  endif
               endif
               if !hb_FileExists(target)
                  saveLog('Arquivo PDF não foi gerado ou não encontrado: ' + target)
               endif
            endif
         elseif ('assinar' $ Lower(comando))
            ::xmlName := txt:xmlName
         elseif ('cancelar' $ Lower(comando)) .and. ::cStat == '135'
            ::situacao := 'CANCELADO'
         elseif ('obtercertificados' $ Lower(comando))
            ::xMotivo := txt:xMotivo
            ::cert_serial_number := txt:cert_serial_number
            ::cert_company_name := txt:cert_company_name
            ::cert_cnpj := txt:cert_cnpj
            ::cert_expiration_date := txt:cert_expiration_date
            ::cert_certifier := txt:cert_certifier
            days_lefts := ::cert_expiration_date - Date()
            if (days_lefts < 30)
               AAdd(::events, {'dhRecbto' => txt:dhRecbto, 'nProt' => txt:nProt, 'cStat' => txt:cStat, 'xMotivo' => 'Certificado Digital - No.Serie: ' + txt:cert_serial_number + ' | Ambiente de ' + ::xTpAmb})
               AAdd(::events, {'dhRecbto' => txt:dhRecbto, 'nProt' => txt:nProt, 'cStat' => txt:cStat, 'xMotivo' => 'Certificado Digital - Empresa: ' + txt:cert_company_name + ' CNPJ: ' + txt:cert_cnpj + ' | Ambiente de ' + ::xTpAmb})
               AAdd(::events, {'dhRecbto' => txt:dhRecbto, 'nProt' => txt:nProt, 'cStat' => txt:cStat, 'xMotivo' => 'Certificado Digital - Certificadora: ' + txt:cert_certifier + ' | Ambiente de ' + ::xTpAmb})
               if (days_lefts == 0)
                  msg_expiration := 'Expirando hoje: ' + DToC(::cert_expiration_date)
               elseif (days_lefts < 0)
                  msg_expiration := 'Expirou em ' + DToC(::cert_expiration_date)
               else
                  msg_expiration := 'Expira em ' + hb_ntos(days_lefts) + ' dias!'
               endif
               AAdd(::events, {'dhRecbto' => txt:dhRecbto, 'nProt' => txt:nProt, 'cStat' => txt:cStat, 'xMotivo' => 'Certificado Digital - ' + msg_expiration + ' | Ambiente de ' + ::xTpAmb})
               saveLog({'Certificado Digital:', hb_eol(), '  No.Série: ', ::cert_serial_number , hb_eol(), '  Empresa: ', ::cert_company_name + ' CNPJ: ' + ::cert_cnpj, hb_eol(), '  Cerificadora: ', ::cert_certifier, '  Validade: ' + msg_expiration})
            endif
         endif
         txtStatus := txt:isValid
      endif
      saveLog({'Resposta: ', txt:xMotivo, hb_eol(), 'retorno: ', txt:text})
      AAdd(::events, {'dhRecbto' => txt:dhRecbto, 'nProt' => txt:nProt, 'cStat' => txt:cStat, 'xMotivo' => txt:xMotivo + ' | Ambiente de ' + ::xTpAmb})
      hb_vfMoveFile( ::outFile, ::tmpFile)
   else
      saveLog({'ACBrMonitor não responde (timeout)', hb_eol(), 'Arquivo esperado: ', ::outFile})
      AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => 'CTeMonitor', 'cStat' => '000', 'xMotivo' => 'ACBrMonitor não responde (timeout)! Ver log CTeMonitor | Ambiente de ' + ::xTpAmb})
   endif

return txtStatus

method sendToPrinter(pdfFile) class TACBrMonitor
   local destinationFile, destinationPath := RegistryRead('HKEY_CURRENT_USER\Software\Sistrom\SendToPrinter\InstallPath\Path')
   if !Empty(pdfFile) .and. hb_FileExists(pdfFile)
      if (ValType(destinationPath) == 'C') .and. !Empty(destinationPath)
         destinationFile := destinationPath + 'printNow\' + Token(pdfFile, '\')
         ::copyFromTo(pdfFile, destinationFile)
      endif
      if !Empty(::copyPDFPath)
         destinationFile := ::copyPDFPath + Token(pdfFile, '\')
         ::copyFromTo(pdfFile, destinationFile)
      endif
   else
      if Empty(pdfFile)
         saveLog('Arquivo PDF não foi gerado: pdfFile vazio')
      else
         saveLog('Arquivo PDF não encontrado: ' + pdfFile)
      endif
   endif
return Nil

method copyFromTo(from_file, to_file) class TACBrMonitor
   local error := hb_FCopy(from_file, to_file)
   if (error == 0)
      saveLog('Arquivo ' + from_file + ' copiado com sucesso para ' + to_file)
   else
      saveLog('Erro (' + hb_ntos(error) + ') ao tentar copiar arquivo: ' + hb_eol() + '      Origem: ' + from_file + hb_eol() + '     Destino: ' + to_file)
   endif
return error

method setFileFromEvento(byId, readName) class TACBrMonitor
   local target, error, oldPath
   default byId := ''
   default readName := ''
   if ('cancelar' $ Lower(::command))
      oldPath := ::xmlCanPath
      ::xmlCanPath := ::ACBr:DFePath + ::emitCNPJ + '\' + Left(DtoS(Date()), 6) + '\Evento\Cancelamento\'
      if !Empty(byId)
         target := ::xmlCanPath + byId + '-procEvento' + ::DFe + '.xml'
      else
         target := ::xmlCanPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
      endif
      ::xmlCancel := ::xmlCanPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
      if hb_FileExists(target)
         if (target == ::xmlCancel)
            saveLog('XML do ' + ::DFe + ' recebido: ' + target)
         else
            if (FRename(target, ::xmlCancel) == 0)
               saveLog('XML do ' + ::DFe + ' cancelado recebido e renomeado de: ' + target + ' para: ' + ::xmlCancel)
            else
               saveLog('Erro ao renomear XML do ' + ::DFe + ' cancelado de: ' + target + ' para: ' + ::xmlCancel)
               ::xmlCancel := target
            endif
         endif
      else
         target := oldPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
         if hb_FileExists(target)
            ::xmlCanPath := oldPath
            if (target == ::xmlCancel)
               saveLog('XML do ' + ::DFe + ' encerrado recebido: ' + target)
            else
               if (FRename(target, ::xmlCancel) == 0)
                  saveLog('XML do ' + ::DFe + ' encerrado recebido e renomeado de: ' + target + ' para: ' + ::xmlCancel)
               else
                  saveLog('Erro ao renomear arquivo XML do ' + ::DFe + target + ' para: ' + ::xmlCancel)
                  ::xmlCancel := target
               endif
            endif
         endif
      endif
      if !hb_FileExists(::xmlCancel)
         oldPath := ::copyXMLPath
         ::copyXMLPath := ::ACBr:sharedPath + 'xml\' + ::emitCNPJ + '\' + Left(DtoS(Date()), 6) + '\' + ::DFe + '\'
         ::xmlCancel := ::copyXMLPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
      endif
      if !hb_FileExists(::xmlCancel)
         saveLog('XML do ' + ::DFe + ' de cancelamento:' + hb_eol() + '   ' + ::xmlCancel + ' e ' + hb_eol() + '   ' + target + hb_eol() + 'não foram encontrados!')
         if (readName == ::chDFe + '-sit.xml')
            error := hb_FCopy(::ACBr:returnPath + readName, ::xmlCancel)
            if (error == 0)
               saveLog('Arquivo ' + ::ACBr:returnPath + readName + ' copiado com sucesso para ' + ::xmlCancel)
            else
               saveLog('Erro (' + hb_ntos(error) + ') ao tentar copiar arquivo: ' + hb_eol() + '     Origem: ' + ::ACBr:returnPath + readName + hb_eol() + '     Destino: ' + ::xmlCancel)
            endif
         endif
      endif
   elseif ('encerrar' $ Lower(::command))
      oldPath := ::xmlEncPath
      ::xmlEncPath := ::ACBr:DFePath + ::emitCNPJ + '\' + Left(DtoS(Date()), 6) + '\Evento\Encerramento\'
      if Empty(byId)
         byId := '110112' + ::chDFe + '01'  // Verificar o dígito '01' como é obtido.
      endif
      target := ::xmlEncPath + byId + '-procEvento' + ::DFe + '.xml'
      saveLog('Tentando encontrar o xml por id: ' + target)
      ::xmlName := ::xmlEncPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
      saveLog({'target: ', target, iif(hb_FileExists(target), ' Encontrado!', ' Não encontrado!')})
      if !hb_FileExists(target)
         target := ::xmlEncPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
         saveLog('Tentando encontrar o xml pela chave: ' + target)
         saveLog({'target: ', target, iif(hb_FileExists(target), ' Encontrado!', ' Não encontrado!')})
      endif
      if hb_FileExists(target)
         if (target == ::xmlName)
            saveLog('XML do ' + ::DFe + ' encerrado recebido: ' + target)
         else
            if (FRename(target, ::xmlName) == 0)
               saveLog('XML do ' + ::DFe + ' encerrado recebido e renomeado de: ' + target + ' para: ' + ::xmlName)
            else
               saveLog('Erro ao renomear arquivo XML do ' + ::DFe + target + ' para: ' + ::xmlName)
               ::xmlName := target
            endif
         endif
      else
         saveLog({'xmlName: ', ::xmlName, iif(hb_FileExists(::xmlName), ' Encontrado!', ' Não encontrado!')})
         target := oldPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
         saveLog({'target: ', target, iif(hb_FileExists(target), ' Encontrado!', ' Não encontrado!')})
         if hb_FileExists(target)
            ::xmlEncPath := oldPath
            if (target == ::xmlName)
               saveLog('XML do ' + ::DFe + ' encerrado recebido: ' + target)
            else
               if (FRename(target, ::xmlName) == 0)
                  saveLog('XML do ' + ::DFe + ' encerrado recebido e renomeado de: ' + target + ' para: ' + ::xmlName)
               else
                  saveLog('Erro ao renomear arquivo XML do ' + ::DFe + target + ' para: ' + ::xmlName)
                  ::xmlName := target
               endif
            endif
         endif
      endif
      if hb_FileExists(::xmlName)
         saveLog({'xmlName: ', ::xmlName, ' Encontrado!'})
      else
         oldPath := ::copyXMLPath
         ::copyXMLPath := ::ACBr:sharedPath + 'xml\' + ::emitCNPJ + '\' + Left(DtoS(Date()), 6) + '\' + ::DFe + '\'
         ::xmlName := ::copyXMLPath + ::chDFe + '-procEvento' + ::DFe + '.xml'
         saveLog({'xmlName: ', ::xmlName, ' Não encontrado!'})
      endif
      if !hb_FileExists(::xmlName)
         saveLog('XML de encerramento:' + hb_eol() + '   ' + ::xmlName + ' e ' + hb_eol() + '   ' + target + hb_eol() + 'não foram encontrados!')
         if (readName == ::chDFe + '-sit.xml')
            error := hb_FCopy(::ACBr:returnPath + readName, ::xmlName)
            if (error == 0)
               saveLog('Arquivo ' + ::ACBr:returnPath + readName + ' copiado com sucesso para ' + ::xmlName)
            else
               saveLog('Erro (' + hb_ntos(error) + ') ao tentar copiar arquivo: ' + hb_eol() + '     Origem: ' + ::ACBr:returnPath + readName + hb_eol() + '     Destino: ' + ::xmlName)
            endif
         endif
      endif
   endif
return Nil

method foram_lidos(lidos) class TACBrMonitor
   local nRet := 0
   if lidos
      if Empty(::dhRecbto) .or. (::dhRecbto == "0000-00-00 00:00:00")
         ::dhRecbto := dateTime_hb_to_mysql(Date(), Time())
      endif
      AAdd(::events, {'dhRecbto' => ::dhRecbto, 'nProt' => ::nProt, 'cStat' => ::cStat, 'xMotivo' => ::xMotivo + ' | Ambiente de ' + ::xTpAmb})
      saveLog({'Status do XML: ', ::situacao, ' |Motivo: ', ::xMotivo})
   else
      saveLog('Nenhum arquivo foi lido de retorno de XMLs, verificando retorno em TXT...')
      if ::getReturnTXT()
         nRet := 1
      endif
   endif
return nRet

method ObterCertificado() class TACBrMonitor
   ::cert_serial_number := ''
   ::cert_company_name := ''
   ::cert_cnpj := ''
   ::cert_expiration_date := ''
   ::cert_certifier := ''
   ::command := 'ACBr.ObterCertificados'
   ::submit()
   ::certificate_is_valid := ::getReturnTXT()
   if !::certificate_is_valid
      ::situacao := 'REJEITADO'
      ::cStat := '291'
   endif
   saveLog({"Situação: ", ::situacao, " | cStat: ", ::cStat, " | Certificado A1 ", iif(::certificate_is_valid, 'VÁLIDO', 'INVÁLIDO')})
return ::certificate_is_valid
