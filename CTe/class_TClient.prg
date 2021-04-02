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


class TClient
	data documentation READONLY
	data submit init False
	data value init "TClient" READONLY
	data CNPJ
	data CPF
	data IE
	data xNome
	data xFant
	data fone
	data endereco
	data email
	data contribuinte_ICMS
	method new(client) constructor
	method clear()
end class

method new(client) class TClient
	// client recebe {'tag' => "rem", 'who' => "remetente"}
	::documentation := client['tag']+" | Informações do "+client['who']+" do CT-e"
	::value := client['tag']
	::CNPJ := Telement():new({'name' => "CNPJ", 'documentation' => "Número do CNPJ do "+client['who'], 'minLength' => 14, 'type' => "N"})
	::CPF := Telement():new({'name' => "CPF", 'documentation' => "Número do CPF do "+client['who'], 'minLength' => 11, 'type' => "N"})
	::IE := Telement():new({'name' => "IE", 'documentation' => "Inscrição Estadual do "+client['who'], 'minLength' => 6, 'maxLength' => 14, 'required' => False})
	::xNome := Telement():new({'name' => "xNome", 'documentation' => "Razão Social ou nome do "+client['who'], 'minLength' => 2, 'maxLength' => 60})
	::xFant := Telement():new({'name' => "xFant", 'documentation' => "Nome Fantasia do "+client['who'], 'minLength' => 2, 'maxLength' => 60, 'required' => False})
	::fone := Telement():new({'name' => "fone", 'documentation' => "Telefone do "+client['who'], 'minLength' => 6, 'maxLength' => 14, 'required' => False, 'type' => "N"})
	::endereco := TEndereco():new({'tag' => "endereco", 'nome' => client['who']})
	::email := Telement():new({'name' => "email", 'documentation' => "Endereço de email do "+client['who'], 'minLength' => 1, 'maxLength' => 60, 'required' => False})
return self

method clear() class TClient
	::submit := False
	::CNPJ:value := ""
	::CPF:value := ""
	::IE:value := ""
	::xNome:value := ""
	::xFant:value := ""
	::fone:value := ""
	::endereco:clear()
	::email:value := ""
return nil
