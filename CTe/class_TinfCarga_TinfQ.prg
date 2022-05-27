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


class TinfCarga
	data documentation
	data value READONLY
	data vCarga
	data proPred
	data xOutCat
	data infQ
	data vCargaAverb

	method new() constructor
	method addInfQ(iq)

end class

method new() class TinfCarga
	::documentation := "infCarga | Informações da Carga do CT-e"
	::value := "TinfCarga"
	::vCarga := Telement():new({'name' => "vCarga", 'documentation' => "Valor total da carga", 'required' => False, 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::proPred := Telement():new({'name' => "proPred", 'documentation' => "Produto predominante", 'minLength' => 1, 'maxLength' => 60})
	::xOutCat := Telement():new({'name' => "xOutCat", 'documentation' => "Outras características da carga", 'required' => False, 'minLength' => 1, 'maxLength' => 30})
	::infQ := Telement():new({'name' => "infQ", 'documentation' => "Informações de quantidades da Carga do CT-e", 'value' => {}, 'maxLength' => 99999, 'type' => "A"})
	::vCargaAverb := Telement():new({'name' => "vCargaAverb", 'documentation' => "Valor da Carga para efeito de averbação", 'minLength' => 4, 'maxLength' => 16, 'required' => False})
return self

method addInfQ(iq) class TinfCarga
	AAdd(::infQ:value, TinfQ():new(iq))
return Nil


class TinfQ
	data documentation readonly
	data value readonly
	data cUnid
	data tpMed
	data qCarga
	method new(iq) constructor
end class

method new(iq) class TinfQ
	::documentation := "infQ | Informações de quantidades da Carga do CT-e"
	::value := "TinfQ"
	//{'cUnid' => "01", 'tpMed' => "PESO BRUTO", 'qCarga' => rowCTe:getField('cte_peso_bruto')}
	::cUnid := Telement():new({'name' => "cUnid", 'documentation' => "Código da Unidade de Medida"+CRLF+;
																			"Preencher com:"+CRLF+"00-M3;"+CRLF+"01-KG;"+CRLF+"02-TON;"+CRLF+"03-UNIDADE;"+CRLF+"04-LITROS;"+CRLF+"05-MMBTU",;
										'value' => iq['cUnid'] , 'minLength' => 2, 'restriction' => "00|01|02|03|04|05", 'type' => "N"})
	::tpMed := Telement():new({'name' => "tpMed", 'documentation' => "Tipo da Medida", 'value' => iq['tpMed'], 'minLength' => 1, 'maxLength' => 20})
	::qCarga := Telement():new({'name' => "qCarga", 'documentation' => "Quantidade", 'value' => iq['qCarga'], 'minLength' => 1, 'maxLength' => 16, 'type' => "N"})
return Self
