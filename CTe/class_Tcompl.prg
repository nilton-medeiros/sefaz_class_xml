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


class Tcompl

	data documentation init "compl | Dados complementares do CT-e para fins operacionais ou comerciais" READONLY
	data submit
	data value READONLY
	data xCaracAd
	data xCaracSer
	data xEmi
	data fluxo
	data Entrega
	data origCalc
	data destCalc
	data xObs
	data ObsCont READONLY
	data ObsFisco READONLY

	method new() constructor
	method addObsCont(pObsCont)
	method addObsFisco(pObsFisco)

end class

method new() class Tcompl
	::documentation := "compl | Dados complementares do CT-e para fins operacionais ou comerciais"
	::submit := False
	::value := "Tcompl"
	::xCaracAd := Telement():new({'name' => "xCaracAd", 'documentation' => "Característica adicional do transporte", 'required' => False, 'minLength' => 1, 'maxLength' => 15})
	::xCaracSer := Telement():new({'name' => "xCaracSer", 'documentation' => "Característica adicional do serviço", 'required' => False, 'minLength' => 1, 'maxLength' => 30})
	::xEmi := Telement():new({'name' => "xEmi", 'documentation' => "Funcionário emissor do CTe", 'required' => False, 'minLength' => 1, 'maxLength' => 20})
	::fluxo := Tfluxo():new()
	::Entrega := TEntrega():new()
	::origCalc := Telement():new({'name' => "origCalc", 'documentation' => "Município de origem para efeito de cálculo do frete", 'required' => False, 'minLength' => 2, 'maxLength' => 40})
	::destCalc := Telement():new({'name' => "destCalc", 'documentation' => "Município de destino para efeito de cálculo do frete", 'required' => False, 'minLength' => 2, 'maxLength' => 40})
	::xObs := Telement():new({'name' => "xObs", 'documentation' => "Observações Gerais", 'required' => False, 'minLength' => 1, 'maxLength' => 2000})
	::ObsCont := {}
	::ObsFisco := {}
return self

method addObsCont(pObsCont) class Tcompl
	if hmg_len(::ObsCont) < 10
		AAdd(::ObsCont, TObservacao():new({'tag' => "ObsCont", 'obs' => pObsCont, 'maxLength' => 160}))
	endif
return nil

method addObsFisco(pObsFisco) class Tcompl
	if hmg_len(::ObsFisco) < 10
		AAdd(::ObsFisco, TObservacao():new({'tag' => "ObsFisco", 'obs' => pObsFisco, 'maxLength' => 60}))
	endif
return nil
