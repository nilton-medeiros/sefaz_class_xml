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


class Ttoma3
	data documentation readonly
	data value readonly
	data toma
	method new() constructor
end class

method new() class Ttoma3
	::documentation := 'toma3 | Indicador do "papel" do tomador do serviço no CT-e'
	::value := "Ttoma3"
	::toma := Telement():new({'name' => "toma", ;
							'documentation' => "Tomador do Serviço"+CRLF+"Preencher com:"+CRLF+;
										"0-Remetente;"+CRLF+;
										"1-Expedidor;"+CRLF+;
										"2-Recebedor;"+CRLF+;
										"3-Destinatário."+CRLF+;
										"Serão utilizadas as informações contidas no respectivo grupo, conforme indicado pelo conteúdo deste campo",;
							'minLength' => 1, 'restriction' => "0|1|2|3", 'type' => "N"})
return self

class Ttoma4
	data documentation readonly
	data value readonly
	data toma
	data CNPJ
	data CPF
	data IE
	data xNome
	data xFant
	data fone
	data enderToma
	data email
	method new() constructor
end class

method new() class Ttoma4
	::documentation := 'toma4 | Indicador do "papel" do tomador do serviço no CT-e'
	::value := "Ttoma4"
	::toma := Telement():new({'name' => "toma", 'minLength' => 1, 'restriction' => "4",;
												 'documentation' => "Tomador do Serviço"+CRLF+;
															 "Preencher com: 4 - Outros"+CRLF+;
															 "Obs: Informar os dados cadastrais do tomador do serviço", 'type' => "N"})
	::CNPJ := Telement():new({'name' => "CNPJ", ;
							'documentation' => "Número do CNPJ"+CRLF+;
										"Em caso de empresa não estabelecida no Brasil, será informado o CNPJ com zeros."+CRLF+;
										"Informar os zeros não significativos.",;
							'minLength' => 14, 'type' => "N"})
	::CPF := Telement():new({'name' => "CPF", 'documentation' => "Número do CPF"+CRLF+"Informar os zeros não significativos.", 'minLength' => 11, 'type' => "N"})
	::IE := Telement():new({'name' => "IE", 'minLength' => 6, 'maxLength' => 14, 'required' => False,;
											  'documentation' => "Inscrição Estadual"+CRLF+;
															"Informar a IE do tomador ou ISENTO se tomador é contribuinte do ICMS isento de inscrição no cadastro de contribuintes do ICMS."+CRLF+;
															"Caso o tomador não seja contribuinte do ICMS não informar o conteúdo."})
	::xNome := Telement():new({'name' => "xNome", 'documentation' => "Razão Social ou Nome", 'minLength' => 2, 'maxLength' => 60})
	::xFant := Telement():new({'name' => "xFant", 'documentation' => "Nome Fantasia", 'minLength' => 2, 'maxLength' => 60, 'required' => False})
	::fone := Telement():new({'name' => "fone", 'documentation' => "Telefone", 'minLength' => 6, 'maxLength' => 14, 'required' => False, 'type' => "N"})
	::enderToma := TEndereco():new({'tag' => "enderToma", 'nome' => "tomador"})
	::email := Telement():new({'name' => "email", 'documentation' => "Endereço de email", 'minLength' => 1, 'maxLength' => 60, 'required' => False})
return self
