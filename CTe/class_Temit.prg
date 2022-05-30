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

// Atualizado em 2022-05-30 20:00 [Inclusão TAG CRT]
class Temit
	data documentation
	data value READONLY
	data id
	data CNPJ
	data CPF
	data IE
	data IEST
	data xNome
	data xFant
	data enderEmit
	data CRT
	data fone
	data email
	method new() constructor
end class

method new(isCTe) class Temit
	::documentation := "emit | Identificação do Emitente do " + iif(isCTe, 'CT-e', 'Manifesto')
	::value := "Temit"
	::id := '0'
	::CNPJ := Telement():new({'name' => "CNPJ", 'documentation' => "CNPJ do emitente; Informar os zeros não significativos", 'minLength' => 14, 'type' => "N"})
	::CPF := Telement():new({'name' => "CPF", 'documentation' => "CPF do emitente; Informar os zeros não significativos", 'minLength' => 11, 'type' => "N"})
	::IE := Telement():new({'name' => "IE", 'minLength' => 6, 'maxLength' => 14, 'documentation' => "Inscrição Estadual do emitente"})
	::IEST := Telement():new({'name' => "IEST", 'minLength' => 6, 'maxLength' => 14, 'required' => False, 'type' => "N", 'documentation' => "Inscrição Estadual do Substituto Tributário"})
	::xNome := Telement():new({'name' => "xNome", 'documentation' => "Razão Social ou nome do emitente", 'minLength' => 2, 'maxLength' => 60})
	::xFant := Telement():new({'name' => "xFant", 'documentation' => "Nome Fantasia", 'minLength' => 2, 'maxLength' => 60, 'required' => False})
	::enderEmit := TEndereco():new({'tag' => "enderEmit", 'nome' => "emitente"})
	::CRT := Telement():new({'name' => "CRT", 'documentation' => "Código do Regime Tributário", 'minLength' => 1, 'required' => False, 'restriction' => "1|2|3", 'type' => "N"})
	::fone := Telement():new({'name' => "fone", 'documentation' => "Telefone do Emitente", 'minLength' => 6, 'maxLength' => 14, 'required' => False, 'type' => "N"})
	::email := Telement():new({'name' => "email", 'documentation' => "Endereço de E-mail", 'minLength' => 6, 'maxLength' => 60, 'required' => False})
return self