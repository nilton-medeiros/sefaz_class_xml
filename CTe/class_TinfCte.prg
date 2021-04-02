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


class TinfCte
	data documentation READONLY
	data value READONLY
	data versao
	data Id
	data ide
	data compl
	data emit
	data rem
	data exped
	data receb
	data dest
	data vPrest
	data imp
	data infCTeNorm
	data infCteComp
	data infCteAnu
	data autXML
	data infRespTec
	method new() constructor
	method add_autXML()
end class

method new() class TinfCte
	::documentation := "infCte | Informações do CT-e"
	::value := "TinfCte"
	::versao := Telement():new({'name' => "versao", 'documentation' => "Versão do leiaute", 'minLength' => 4, 'maxLength' => 5, 'type' => "N"})
	::Id := Telement():new({'name' => "Id", 'documentation' => 'Identificador da tag a ser assinada'+CRLF+'Informar a chave de acesso do CT-e e precedida do literal "CTe"', 'minLength' => 47})
	::ide := TideCTe():new()
	::compl := Tcompl():new()
	::emit := Temit():new(True)
	::rem := TClient():new({'tag' => "rem", 'who' => "remetente"})
	::exped := TClient():new({'tag' => "exped", 'who' => "expedidor"})
	::receb := TClient():new({'tag' => "receb", 'who' => "recebedor"})
	::dest := TClient():new({'tag' => "dest", 'who' => "destinatário"})
	::vPrest := TvPrest():new()
	::imp := Timp():new()
	::infCTeNorm := TinfCTeNorm():new()
	::infCteComp := TinfCteComp():new()
	::infCteAnu := TinfCteAnu():new()
	::autXML := Telement():new({'name' => "autXML", 'documentation' => "Autorizados para download do XML do DF-e", 'value' => {}, 'minLength' => 0, 'maxLength' => 10, 'type' => "A"})
	::infRespTec := TinfRespTec():new()
return self

method add_autXML(p) class TinfCte
	local add_status := (hmg_len(::autXML:value) < ::autXML:maxLength)
	if add_status
		AAdd(::autXML:value, TautXML():new(p))
	endif
return add_status
