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


class TICMS60
	data documentation
	data submit
	data value READONLY
	data CST
	data vBCSTRet
	data vICMSSTRet
	data pICMSSTRet
	data vCred
	method new() constructor
	method clear()
end class

method new() class TICMS60
	::documentation := "ICMS60 | Tributação pelo ICMS60 - ICMS cobrado por substituição tributária"+CRLF+;
									"Responsabilidade do recolhimento do ICMS"+CRLF+;
									"atribuído ao tomador ou 3º por ST"
	::submit := False
	::value := "TICMS60"
	::CST := Telement():new({'name' => "CST", 'documentation' => "60 - ICMS cobrado por substituição tributária",;
												'minLength' => 2, 'restriction' => "60", 'type' => "N"})
	::vBCSTRet := Telement():new({'name' => "vBCSTRet", 'documentation' => "Valor da BC do ICMS ST retido",;
													  'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vICMSSTRet := Telement():new({'name' => "vICMSSTRet", 'documentation' => "Valor do ICMS ST retido", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::pICMSSTRet := Telement():new({'name' => "pICMSSTRet", 'documentation' => "Alíquota do ICMS", 'minLength' => 4, 'maxLength' => 6, 'type' => "N"})
	::vCred := Telement():new({'name' => "vCred", 'documentation' => "Valor do Crédito outorgado/Presumido", 'minLength' => 4, 'maxLength' => 16, 'type' => "N", 'required' => False})
return self

method clear() class TICMS60
	::submit := False
	::CST:value := ""
	::vBCSTRet:value := ""
	::vICMSSTRet:value := ""
	::pICMSSTRet:value := ""
	::vCred:value := ""
return nil
