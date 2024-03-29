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


class Timp
	data documentation
	data value READONLY
	data name
	// ICMS: Informações relativas ao ICMS
	data ICMS00
	data ICMS20
	data ICMS45
	data ICMS60
	data ICMS90
	data ICMSOutraUF
	data ICMSSN
	data vTotTrib
	data infAdFisco
	/*
	* ICMSUFFim: Informações do ICMS de partilha com a UF de término do serviço de transporte na operação interestadual
	* Grupo a ser informado nas prestações interestaduais para consumidor final, não contribuinte do ICMS
	*/
	data tem_difal
	data pDIFAL
	data vDIFAL
	data ICMSUFFim
	data vBCUFFim
	data pFCPUFFim
	data pICMSUFFim
	data pICMSInter
	data vFCPUFFim
	data vICMSUFFim
	data vICMSUFIni
	method new() constructor
end class

method new() class Timp
	::documentation := "imp | Informações relativas aos Impostos"
	::name := "Timp"
	::ICMS00 := TICMS00():new()
	::ICMS20 := TICMS20():new()
	::ICMS45 := TICMS45():new()
	::ICMS60 := TICMS60():new()
	::ICMS90 := TICMS90():new()
	::ICMSOutraUF := TicmsOutraUF():new()
	::ICMSSN := TICMSSN():new()
	::vTotTrib := Telement():new({'name' => "vTotTrib", 'documentation' => "Valor Total dos Tributos", 'required' => False, 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::infAdFisco := Telement():new({'name' => "infAdFisco", 'documentation' => "Informações adicionais de interesse do Fisco", 'required' => False, 'minLength' => 1, 'maxLength' => 2000, 'type' => "N"})
	::tem_difal := False
	::ICMSUFFim := False
	::pDIFAL := '0'
	::vDIFAL := '0'
	::vBCUFFim := Telement():new({'name' => "vBCUFFim", 'documentation' => "Valor da BC do ICMS na UF de término da prestação do serviço de transporte", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::pFCPUFFim := Telement():new({'name' => "pFCPUFFim", 'documentation' => "Percentual do ICMS relativo ao Fundo de Combate à pobreza (FCP) na UF de término da prestação do serviço de transporte", 'minLength' => 4, 'maxLength' => 6, 'type' => "N", 'value' => "0.0"})
	::pICMSUFFim := Telement():new({'name' => "pICMSUFFim", 'documentation' => "Alíquota interna da UF de término da prestação do serviço de transporte", 'minLength' => 4, 'maxLength' => 6, 'type' => "N", 'value' => "0.0"})
	::pICMSInter := Telement():new({'name' => "pICMSInter", 'documentation' => "Alíquota interestadual das UF envolvidas", 'minLength' => 4, 'maxLength' => 6, 'type' => "N", 'value' => "0.0"})
	::vFCPUFFim := Telement():new({'name' => "vFCPUFFim", 'documentation' => "Valor do ICMS relativo ao Fundo de Combate á Pobreza (FCP) da UF de término da prestação", 'minLength' => 4, 'maxLength' => 16, 'type' => "N", 'value' => "0.0"})
	::vICMSUFFim := Telement():new({'name' => "vICMSUFFim", 'documentation' => "Valor do ICMS de partilha para a UF de término da prestação do serviço de transporte", 'minLength' => 4, 'maxLength' => 16, 'type' => "N", 'value' => "0.0"})
	::vICMSUFIni := Telement():new({'name' => "vICMSUFIni", 'documentation' => "Valor do ICMS de partilha para a UF de início da prestação do serviço de transporte", 'minLength' => 4, 'maxLength' => 16, 'type' => "N", 'value' => "0.0"})
return self
