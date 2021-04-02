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


class TinfUnidTransp
	data documentation
	data value
	data tpUnidTransp
	data idUnidTransp
	data lacUnidTransp
	data infUnidCarga
	data qtdRat
	method new() constructor
	method addLacUnidTransp(pLacUnidTransp)
	method addInfUnidCarga()

end class

method new() class TinfUnidTransp
	::documentation := "infUnidTransp | Informações das Unidades de Transporte (Carreta/Reboque/Vagão)"
	::value := "TinfUnidTransp"
	::tpUnidTransp := Telement():new({'name' => "tpUnidTransp", 'documentation' => "Tipo da Unidade de Transporte", 'minLength' => 1, 'restriction' => "1|2|3|4|5|6|7", 'type' => "N"})
	::idUnidTransp := Telement():new({'name' => "idUnidTransp", 'documentation' => "Identificação da Unidade de Transporte", 'minLength' => 1, 'restriction' => "1|2|3|4|5|6|7", 'type' => "N"})
	::lacUnidTransp := Telement():new({'name' => "lacUnidTransp", 'documentation' => "Lacres das Unidades de Transporte", 'value' => {}, 'required' => False, 'type' => "A"})
	::infUnidCarga := Telement():new({'name' => "infUnidCarga", 'documentation' => " Informações das Unidades de Carga (Containeres/ULD/Outros)", 'value' => {}, 'required' => False, 'type' => "A"})
	::qtdRat := Telement():new({'name' => "qtdRat", 'documentation' => "Quantidade rateada (Peso,Volume)", 'required' => False, 'type' => "N"})
return self

method addLacUnidTransp(pLacUnidTransp) class TinfUnidTransp
	AAdd(::lacUnidTransp:value, pLacUnidTransp)
return nil

method addInfUnidCarga() class TinfUnidTransp
	AAdd(::infUnidCarga:value, TinfUnidCarga():new())
return ::infUnidCarga:value[hmg_len(::infUnidCarga:value)]
