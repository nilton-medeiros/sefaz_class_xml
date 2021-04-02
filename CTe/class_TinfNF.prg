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


class TinfNF
	data documentation readonly
	data value readonly
	data nRoma
	data nPed
	data mod
	data serie
	data nDoc
	data dEmi
	data vBC
	data vICMS
	data vBCST
	data vST
	data vProd
	data vNF
	data nCFOP
	data nPeso
	data PIN
	data dPrev
	data infUnidCarga
	data infUnidTransp
	method new(nf) constructor
	method addInfUnidCarga()
	method addInfUnidTransp()
end class

method new(nf) class TinfNF
	::documentation := "infNF | Informações das NF"+CRLF+"Este grupo deve ser informado quando o documento originário for NF"
	::value := "TinfNF"
	::nRoma := Telement():new({'value' => hb_HGetDef(nf, 'nRoma', ""), 'name' => "nRoma", 'documentation' => "Número do Romaneio da NF", 'required' => False, 'maxLength' => 20})
	::nPed := Telement():new({'value' => hb_HGetDef(nf, 'nPed', ""), 'name' => "nPed", 'documentation' => "Número do Pedido da NF", 'required' => False, 'maxLength' => 20})
	::mod := Telement():new({'value' => hb_HGetDef(nf, 'mod', ""), 'name' => "mod", 'documentation' => "Modelo da Nota Fiscal", 'minLength' => 2, 'restriction' => "01|04", 'type' => "N"})
	::serie := Telement():new({'value' => hb_HGetDef(nf, 'serie', ""), 'name' => "serie", 'documentation' => "Série", 'maxLength' => 3})
	::nDoc := Telement():new({'value' => hb_HGetDef(nf, 'nDoc', ""), 'name' => "nDoc", 'documentation' => "Número", 'maxLength' => 20})
	::dEmi := Telement():new({'value' => hb_HGetDef(nf, 'dEmi', ""), 'name' => "dEmi", 'documentation' => "::de Emissão", 'minLength' => 10, 'type' => "D"})
	::vBC := Telement():new({'value' => hb_HGetDef(nf, 'vBC', ""), 'name' => "vBC", 'documentation' => "Valor da Base de Cálculo do ICMS", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vICMS := Telement():new({'value' => hb_HGetDef(nf, 'vICMS', ""), 'name' => "vICMS", 'documentation' => "Valor Total do ICMS", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vBCST := Telement():new({'value' => hb_HGetDef(nf, 'vBCST', ""), 'name' => "vBCST", 'documentation' => "Valor da Base de Cálculo do ICMS ST", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vST := Telement():new({'value' => hb_HGetDef(nf, 'vST', ""), 'name' => "vST", 'documentation' => "Valor Total do ICMS ST", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vProd := Telement():new({'value' => hb_HGetDef(nf, 'vProd', ""), 'name' => "vProd", 'documentation' => "Valor Total dos Produtos", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::vNF := Telement():new({'value' => hb_HGetDef(nf, 'vNF', ""), 'name' => "vNF", 'documentation' => "Valor Total da NF", 'minLength' => 4, 'maxLength' => 16, 'type' => "N"})
	::nCFOP := Telement():new({'value' => hb_HGetDef(nf, 'nCFOP', ""), 'name' => "nCFOP", 'documentation' => "CFOP Predominante", 'minLength' => 4, 'type' => "N"})
	::nPeso := Telement():new({'value' => hb_HGetDef(nf, 'nPeso', ""), 'name' => "nPeso", 'documentation' => "Peso total em Kg", 'required' => False, 'minLength' => 5, 'maxLength' => 16, 'type' => "N"})
	::PIN := Telement():new({'value' => hb_HGetDef(nf, 'PIN', ""), 'name' => "PIN", 'documentation' => "PIN SUFRAMA", 'required' => False, 'minLength' => 2, 'maxLength' => 9, 'type' => "N"})
	::dPrev := Telement():new({'value' => hb_HGetDef(nf, 'dPrev', ""), 'name' => "dPrev", 'documentation' => "::prevista de entrega", 'required' => False, 'minLength' => 10, 'type' => "D"})
	::infUnidCarga := Telement():new({'name' => "infUnidCarga", 'documentation' => "Informações das Unidades de Carga (Containeres/ULD/Outros)", 'value' => {}, 'required' => False, 'minLength' => 0, 'maxLength' => 99999, 'type' => "A"})
	::infUnidTransp := Telement():new({'name' => "infUnidTransp", 'documentation' => "Informações das Unidades de Transporte (Carreta/Reboque/Vagão)", 'value' => {}, 'required' => False, 'minLength' => 0, 'maxLength' => 99999, 'type' => "A"})
	::serie:raw := iif(Empty(::serie:value), '', hb_ntos(hb_Val(::serie:value)))
return self

method addInfUnidCarga() class TinfNF
	AAdd(::infUnidCarga:value, TinfUnidCarga():new())
return ::infUnidCarga:value[hmg_len(::infUnidCarga:value)]

method addInfUnidTransp() class TinfNF
	AAdd(::infUnidTransp:value, TinfUnidTransp():new())
return ::infUnidTransp:value[hmg_len(::infUnidTransp:value)]
