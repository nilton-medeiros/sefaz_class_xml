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


class TinfCTeNorm
	data documentation
	data submit
	data value READONLY
	data infCarga
	data infDoc
	data docAnt
	data infModal
	data veicNovos
	data cobr
	data infCteSub
	data infGlobalizado // Opcional - Não usando, Não enviar a Tag
	data infServVinc
	method new() constructor
	method addVeicNovos()
end class

method new() class TinfCTeNorm
	::documentation := "infCTeNorm | Grupo de informações do CT-e Normal e Substituto"
	::submit := False
	::value := "TinfCTeNorm"
	::infCarga := TinfCarga():new()
	::infDoc := TinfDoc():new()
	::docAnt := TdocAnt():new()
	::infModal := TinfModal():new()
	::veicNovos := Telement():new({'name' => "veicNovos", 'documentation' => "informações dos veículos transportados", 'value' => {}, 'minLength' => 0, 'maxLength' => 99999, 'type' => "A"})
	::cobr := Tcobr():new()
	::infCteSub := TinfCteSub():new()
	::infGlobalizado := TinfGlobalizado():new()
	::infServVinc := TinfServVinc():new()
return self

method addVeicNovos() class TinfCTeNorm
	AAdd(::veicNovos:value, TveicNovos():new() )
return ::veicNovos:value[hmg_len(::veicNovos:value)]
