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


class Tfluxo
	data documentation
	data submit
	data value
	data xOrig
	data pass READONLY
	method new() constructor
	method addPass()
end class

method new() class Tfluxo
	::documentation := "fluxo | Previsão do fluxo da carga"+CRLF+"Preenchimento obrigatório para o modal aéreo."
	::submit := False
	::value := "Tfluxo"
	::xOrig := Telement():new({'name' => "xOrig", 'documentation' => "xOrig | Sigla ou código interno da Filial/Porto/Estação/Aeroporto de Origem"+CRLF+;
															  "Observações para o modal aéreo:"+CRLF+" - Preenchimento obrigatório para o modal aéreo."+CRLF+;
															  "O código de três letras IATA do aeroporto de partida deverá ser incluído como primeira anotação."+CRLF+;
															  "Quando não for possível, utilizar a sigla OACI.",;
												  'required' => False, 'minLength' => 1, 'maxLength' => 60})
	::pass := {}
return self

/*Observação para o modal aéreo: - O código de três letras IATA, referente ao aeroporto de transferência, deverá ser incluído, quando for o caso.
Quando não for possível, utilizar a sigla OACI. Qualquer solicitação de itinerário deverá ser incluída.*/
method addPass() class Tfluxo
	AAdd(::pass, Tpass():new())
return ::pass[hmg_len(::pass)]


class Tpass
	data value
	data xPass
	data xDest
	data xRota
	method new() constructor
end class

method new() class Tpass
	::value := "Tpass"
	::xPass := Telement():new({'name' => "xPass", 'documentation' => "Sigla ou código interno da Filial/Porto/Estação/Aeroporto de Passagem", 'value' => "OACI", 'required' => False, 'minLength' => 1, 'maxLength' => 15})
	::xDest := Telement():new({'name' => "xDest", 'documentation' => "Sigla ou código interno da Filial/Porto/Estação/Aeroporto de Destino", 'required' => False, 'minLength' => 1, 'maxLength' => 60})
	::xRota := Telement():new({'name' => "xRota", 'documentation' => "Código da Rota de Entrega", 'required' => False, 'minLength' => 1, 'maxLength' => 10})
return self
