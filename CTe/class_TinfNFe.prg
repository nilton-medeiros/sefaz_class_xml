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


class TinfNFe
	data documentation READONLY
	data value READONLY
	data chave
	data PIN
	data dPrev
	data infUnidCarga
	data infUnidTransp
	method new(params) constructor
	method addInfUnidCarga()
	method addInfUnidTransp()
end class

method new(params) class TinfNFe
	::documentation := "infNFe | Informações das NF-e"
	::value := "TinfNFe"
	::chave := Telement():new({'value' => params['chave'], 'name' => "chave", 'documentation' => "Chave de acesso da NF-e", 'minLength' => 44, 'type' => "N"})
	::PIN := Telement():new({'value' => hb_HGetDef(params, 'PIN', ''), 'name' => "PIN", 'documentation' => "PIN SUFRAMA", 'required' => False, 'minLength' => 2, 'maxLength' => 9, 'type' => "N"})
	::dPrev := Telement():new({'value' => hb_HGetDef(params, 'dPrev', ''),'name' => "dPrev", 'documentation' => "Data prevista de entrega", 'required' => False, 'minLength' => 10, 'type' => "D"})
	::infUnidCarga := Telement():new({'name' => "infUnidCarga", 'documentation' => "Informações das Unidades de Carga (Containeres/ULD/Outros)", 'value' => {}, 'required' => False, 'type' => "A"})
	::infUnidTransp := Telement():new({'name' => "infUnidTransp", 'documentation' => "Informações das Unidades de Transporte (Carreta/Reboque/Vagão)", 'value' => {}, 'required' => False, 'minLength' => 0, 'maxLength' => 99999, 'type' => "A"})
return self

method addInfUnidCarga() class TinfNFe
	AAdd(::infUnidCarga:value, TinfUnidCarga():new())
return ::infUnidCarga:value[hmg_len(::infUnidCarga:value)]

method addInfUnidTransp() class TinfNFe
	AAdd(::infUnidTransp:Value, TinfUnidTransp():new())
return ::infUnidTransp:Value[hmg_len(::infUnidTransp:Value)]
