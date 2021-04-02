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


class TinfRespTec
	data documentation  readonly
	data submit
	data value readonly
	data CNPJ
	data xContato
	data email
	data fone
	data idCSRT
	data hashCSRT
	method new() constructor
end class

method new() class TinfRespTec
	::documentation := "infRespTec | Informações do Responsável Técnico pela emissão do DF-e"
	::submit := False
	::value := "TinfRespTec"
	::CNPJ := Telement():new({'name' => "CNPJ", 'documentation' => "CNPJ da pessoa jurídica responsável técnica pelo sistema utilizado na emissão do documento fiscal eletrônico", 'minLength' => 14, 'type' => "N"})
	::xContato := Telement():new({'name' => "xContato", 'documentation' => "Nome da pessoa a ser contatada na empresa desenvolvedora do sistema utilizado na emissão do DFe", 'minLength' => 2, 'maxLength' => 60})
	::email := Telement():new({'name' => "email", 'documentation' => "E-mail da pessoa jurídica a ser contatada", 'maxLength' => 60})
	::fone := Telement():new({'name' => "fone", 'documentation' => "Telefone da pessoa jurídica a ser contatada", 'minLength' => 7, 'maxLength' => 12, 'type' => "N"})
	::idCSRT := Telement():new({'name' => "idCSRT", 'documentation' => "Identificador do código de segurança do responsável técnico (CSRT)", 'minLength' => 3, 'type' => "N"})
	::hashCSRT := Telement():new({'name' => "hashCSRT", 'documentation' => "Hash do token do código de segurança do responsável técnico", 'minLength' => 28})
return self